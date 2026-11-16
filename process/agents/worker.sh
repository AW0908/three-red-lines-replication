#!/bin/bash
# Worker auf eine freigegebene Aufgabe ansetzen.
#   agents/worker.sh T001
# Läuft nur nach Freigabe (APPROVED), nach einem Review (REWORK) oder nach Rückmeldung des
# Co-PI (EXECUTED). Der Bericht landet in tasks/T001_report.md.
source "$(dirname "$0")/lib.sh"

load_task "${1:-}"
require_status APPROVED REWORK EXECUTED
DECLARED_WORKER="$(field worker)"
WORKER="$(effective_tool "$DECLARED_WORKER" worker)"

# Ausgangszustand der Eingaben einmalig festhalten.
if [[ ! -f "$BASELINE" ]]; then
  input_files | while IFS= read -r f; do shasum -a 256 "$f"; done > "$BASELINE"
fi

PROMPT="$(cat agents/roles/worker.md)

---
Deine Aufgabe: $CARD (Status $(field status)). Lies die Karte und setze sie um."
[[ -f "$REVIEW" ]] && PROMPT="$PROMPT
Es gibt einen Prüfbericht: $REVIEW. Behebe die dort genannten Punkte."

# Schreibaufgabe: Writer-Zusatz laden; Overleaf synchronisiert nur der PI.
if awk '/^## (Schreibbereich|Write scope)/{f=1;next} /^## /{f=0} f' "$CARD" | grep -q 'proposal/'; then
  WRITING=1
  # Overleaf synchronization remains an explicit PI action; no automatic network call.
  PROMPT="$PROMPT

$(cat agents/roles/writer.md)"
else
  WRITING=0
fi
LOG="tasks/${ID}_worker.log"

MODEL="$(tier "$WORKER")"
echo "$ID: declared=$DECLARED_WORKER effective=$WORKER Aufwand=$MODEL (Protokoll: $LOG)"
# Preserve earlier reports/logs on reruns.
ARCHIVE="state/run_archive/$(date '+%Y%m%d_%H%M%S')_${ID}_worker_$$"
mkdir -p "$ARCHIVE"
for f in "$REPORT" "$LOG"; do [[ ! -f "$f" ]] || cp -p "$f" "$ARCHIVE/"; done
ROLE_MODEL="$(role_model worker "$WORKER")"
echo "$ID: Worker-Modell=${ROLE_MODEL:-Provider-Standard}"
: > "$RUNSTART"   # Laufmarker für die Schreibbereichsprüfung (PI 16.11.2026)
MTPA_ROLE_MODEL="$ROLE_MODEL" run_provider "$WORKER" worker "$MODEL" "$PROMPT" "$REPORT" "$LOG" \
  || die "$WORKER abgebrochen; Status unverändert, siehe $LOG"
OUTSIDE="$(touched_since_start | outside_scope)"
[[ -z "$OUTSIDE" ]] || die "Änderungen außerhalb des Schreibbereichs (Status unverändert): $OUTSIDE"

# Abbruch wegen Nutzungslimit erkennen (Tool endet sonst mit Exit 0 und leerem Bericht).
if grep -qiE "hit your (session |usage )?limit|usage limit|model is at capacity|^Execution error" "$REPORT" "$LOG" 2>/dev/null && [[ $(wc -c < "$REPORT") -lt 2000 ]] || [[ ! -s "$REPORT" ]]; then
  die "Worker hat wegen Nutzungslimit/Kapazität nicht gearbeitet (siehe $REPORT, $LOG). Status bleibt $(field status)."
fi

[[ -s "$REPORT" ]] || die "Kein Bericht entstanden, siehe $LOG"
echo "$(date '+%Y-%m-%d %H:%M') $ID worker $WORKER $MODEL (priority $(priority))" >> state/runs.log
set_status EXECUTED
echo "Bericht: $REPORT"
