#!/bin/bash
# Unabhängige Prüfung eines eingefrorenen Kandidaten.
#   agents/review.sh T001
# Reviewer lesen nur. Urteil und Bericht landen in review/T001.md.
# Mehrere spezialisierte Reviewer (seit 2026-10-19): Kartenfeld
#   reviewers: data=codex, estimation=codex, consistency=codex, language=codex
# Rollen: data, estimation, consistency, language (agents/roles/review_<rolle>.md).
# Ohne Feld `reviewers` gilt wie bisher ein allgemeiner Reviewer aus `reviewer:`.
# Gesamturteil: ESCALATE vor REWORK vor PASS.
source "$(dirname "$0")/lib.sh"

load_task "${1:-}"
require_status CANDIDATE
WORKER="$(field worker)"
REVIEWERS="$(field reviewers || true)"
[[ -n "$REVIEWERS" ]] || REVIEWERS="general=$(field reviewer)"
PAIRS="$(echo "$REVIEWERS" | tr ',' '\n' | sed 's/[[:space:]]//g' | grep '=' || true)"
[[ -n "$PAIRS" ]] || die "Feld reviewers leer oder falsch (Format: rolle=tool, ...)."
while IFS='=' read -r ROLE TOOL; do
  effective_tool "$TOOL" "$ROLE" > /dev/null
  [[ "$ROLE" == general || -f "agents/roles/review_${ROLE}.md" ]] || die "Unbekannte Reviewer-Rolle '$ROLE'."
done <<< "$PAIRS"
[[ -s "$FROZEN" ]] || die "$FROZEN fehlt. Erst agents/candidate.sh $ID."
shasum -a 256 -c "$FROZEN" > /dev/null 2>&1 \
  || die "Dateien wurden seit dem Einfrieren verändert. Erst erneut einfrieren: agents/candidate.sh $ID"

# Eingaben gegen den Zustand vor der Ausführung vergleichen.
if [[ -s "$BASELINE" ]]; then
  # Eingaben, die zugleich im Schreibbereich liegen, dürfen sich ändern.
  CHANGED="$(shasum -a 256 -c "$BASELINE" 2>/dev/null | grep -v ': OK$' | sed 's/: .*//' | outside_scope || true)"
  if [[ -z "$CHANGED" ]]; then
    INPUTS="unverändert ($(wc -l < "$BASELINE" | tr -d ' ') Dateien)"
  else
    INPUTS="verändert oder gelöscht: $(echo "$CHANGED" | tr '\n' ' ')"
  fi
else
  INPUTS="kein Ausgangszustand gespeichert"
fi

# Was wurde seit dem ersten Worker-Lauf außerhalb des Schreibbereichs angefasst (nach Änderungszeit)?
OUTSIDE="$(touched_since_start | outside_scope | tr '\n' ' ')"
[[ -n "$OUTSIDE" ]] || OUTSIDE="keine"

BASE="Prozessunabhängiger Review in frischer Provider-Sitzung; gleiche Modellfamilie wie Worker möglich. Keine vollständige Modellunabhängigkeit.
---
Zu prüfen: Aufgabe $ID.
Aufgabenkarte mit Abnahmekriterien: $CARD
Bericht des Workers (nur als Wegweiser zu den Dateien): $REPORT
Eingefrorene Dateien:
$(sed 's/^[0-9a-f]*  /- /' "$FROZEN")
Vom Skript per SHA-256 geprüft – Eingaben der Karte seit Beginn der Ausführung: $INPUTS
Vom Skript nach Änderungszeit geprüft – seit Beginn der Ausführung geänderte Projektdateien außerhalb des Schreibbereichs (ohne tasks/, review/, state/): $OUTSIDE"
[[ -s "$TEXDIFF" ]] && BASE="$BASE
Änderungen in proposal/ gegenüber dem letzten Overleaf-Stand (vom Skript erzeugt): $TEXDIFF"
[[ -s "$TEXBUILD" ]] && BASE="$BASE
Ergebnis der Test-Übersetzung des eingefrorenen Stands mit pdfLaTeX (vom Skript erzeugt): $TEXBUILD"

# Ein Reviewer-Lauf: run_reviewer ROLLE TOOL -> schreibt review/${ID}_${ROLLE}.md, gibt Urteil aus.
run_reviewer() {
  local role="$1" tool="$2" out log model prompt verdict
  prompt="$(cat agents/roles/reviewer.md)"
  if [[ "$role" != general ]]; then
    prompt="$prompt

$(cat "agents/roles/review_${role}.md")

Prüfe nur die Aspekte deiner Spezialrolle gründlich; andere Rollen prüfen den Rest. Die Abnahmekriterien
der Karte bewertest du, soweit sie deine Rolle betreffen, die übrigen markierst du als \"nicht meine Rolle\"."
  fi
  prompt="$prompt

$BASE"
  out="$(mktemp)"; log="review/${ID}_${role}.log"; model="$(tier "$tool")"
  local declared="$tool"
  tool="$(effective_tool "$tool" "$role")"
  echo "$ID: [$role] declared=$declared effective=$tool Aufwand=$model (Protokoll: $log)" >&2
  local rmodel; rmodel="$(role_model "$role" "$tool")"
  echo "$ID: [$role] Modell=${rmodel:-Provider-Standard}" >&2
  MTPA_ROLE_MODEL="$rmodel" run_provider "$tool" reviewer "$model" "$prompt" "$out" "$log" \
    || { if grep -qiE 'OAuth|401|authenticat|fchmod|/tmp/claude-' "$log" 2>/dev/null; then
           die "$tool ($role) abgebrochen: vermutlich Claude-Anmeldung abgelaufen (Sandbox verhindert die Erneuerung). Im Terminal einmal  claude -p \"Antworte nur mit OK\" --no-session-persistence  ausführen (bei Fehler 401: claude, /login), dann review.sh erneut starten. Protokoll: $log"
         fi
         die "$tool ($role) abgebrochen, siehe $log"; }
  verdict="$(grep -m1 -oE 'VERDICT: *(PASS|REWORK|ESCALATE)' "$out" | sed 's/VERDICT: *//' || true)"
  [[ "$(head -1 "$out")" =~ ^VERDICT:\ (PASS|REWORK|ESCALATE)$ ]] || die "Ungültige erste Urteilszeile [$role]; Status bleibt CANDIDATE."
  [[ -n "$verdict" ]] || { cp "$out" "review/${ID}_${role}_ohne_urteil.md"; die "Kein Urteil von [$role], gespeichert als review/${ID}_${role}_ohne_urteil.md"; }
  { echo "## Rolle: $role (declared=$declared, effective=$tool, $model, Modell=${rmodel:-Provider-Standard}) – VERDICT: $verdict"; echo; sed '1{/^VERDICT:/d;}' "$out"; } > "review/${ID}_${role}.md"
  rm -f "$out"
  echo "$(date '+%Y-%m-%d %H:%M') $ID reviewer[$role] $tool $model (priority $(priority)) $verdict" >> state/runs.log
  echo "$verdict"
}

# Preserve prior role reports and logs before any overwrite.
ARCHIVE="state/run_archive/$(date '+%Y%m%d_%H%M%S')_${ID}_review_$$"
mkdir -p "$ARCHIVE"
for f in review/"$ID".md review/"${ID}"_*.md review/"${ID}"_*.log; do
  [[ ! -f "$f" ]] || cp -p "$f" "$ARCHIVE/"
done
VERDICT=PASS; SUMMARY=""; ROLES=""
while IFS='=' read -r ROLE TOOL; do
  V="$(run_reviewer "$ROLE" "$TOOL")" || die "Reviewer [$ROLE] gescheitert; Status bleibt CANDIDATE."
  [[ "$V" =~ ^(PASS|REWORK|ESCALATE)$ ]] || die "Reviewer [$ROLE] lieferte kein gültiges Urteil ('$V')."
  echo "$ID: [$ROLE] $V"
  SUMMARY="$SUMMARY
| $ROLE | $TOOL → $(select_provider "$ROLE") | $V |"
  ROLES="$ROLES $ROLE"
  case "$V" in
    ESCALATE) VERDICT=ESCALATE ;;
    REWORK) [[ "$VERDICT" == ESCALATE ]] || VERDICT=REWORK ;;
  esac
done <<< "$PAIRS"

if shasum -a 256 -c "$FROZEN" > /dev/null 2>&1; then
  INTEGRITY="unverändert"
else
  INTEGRITY="VERÄNDERT WÄHREND DER PRÜFUNG – Urteil ungültig"
  VERDICT=ESCALATE
fi

# Hard failures override any model PASS.
if [[ "$INPUTS" == verändert* || "$INPUTS" == "kein Ausgangszustand gespeichert" || "$OUTSIDE" != keine ]]; then VERDICT=ESCALATE; fi
if [[ -s "$BASELINE" ]]; then
  POST_CHANGED="$(shasum -a 256 -c "$BASELINE" 2>/dev/null | grep -v ': OK$' | sed 's/: .*//' | outside_scope || true)"
  [[ -z "$POST_CHANGED" ]] || VERDICT=ESCALATE
fi
POST_OUTSIDE="$(touched_since_start | outside_scope | tr '\n' ' ')"
[[ -z "$POST_OUTSIDE" ]] || VERDICT=ESCALATE
{
  echo "# Prüfbericht $ID"
  echo
  echo "VERDICT: $VERDICT"
  echo
  echo "- Datum: $(date '+%Y-%m-%d %H:%M')"
  echo "- Worker: $WORKER, Wichtigkeit $(priority)"
  echo "- Kandidat: $(wc -l < "$FROZEN" | tr -d ' ') Dateien, Prüfsummen in \`$FROZEN\`"
  echo "- Eingaben seit Beginn der Ausführung: $INPUTS"
  echo "- Geänderte Dateien außerhalb des Schreibbereichs seit Beginn: $OUTSIDE"
  echo "- Kandidat nach der Prüfung: $INTEGRITY"
  echo "- Eingaben nach Prüfung: ${POST_CHANGED:-keine Abweichung}; Schreibbereich nach Prüfung: ${POST_OUTSIDE:-keine Abweichung}"
  echo
  echo "| Rolle | Tool | Urteil |"
  echo "|---|---|---|$SUMMARY"
  echo
  for R in $ROLES; do cat "review/${ID}_${R}.md"; echo; done
} > "$REVIEW"

set_status "$VERDICT"
echo "Prüfbericht: $REVIEW"
