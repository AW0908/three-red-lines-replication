# Gemeinsame Funktionen der Team-Skripte. Wird per `source` eingebunden.

set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")/.."

die() { echo "Fehler: $*" >&2; exit 1; }

# Ausgabe jedes Skriptaufrufs zusätzlich nach state/terminal.log, damit der Co-PI mitlesen kann.
# Nur im äußersten Skript (verschachtelte Aufrufe schreiben über dieselbe Pipe mit).
if [[ -z "${MTPA_LOGGING:-}" ]]; then
  export MTPA_LOGGING=1
  mkdir -p state
  { echo; echo "===== $(date '+%Y-%m-%d %H:%M:%S') \$ agents/$(basename "$0") $*"; } >> state/terminal.log
  exec > >(tee -a state/terminal.log) 2>&1
fi

# Aufgabe aus dem ersten Argument laden: setzt ID, CARD, REPORT, REVIEW, FROZEN, BASELINE, TEXDIFF.
load_task() {
  ID="${1:-}"
  [[ "$ID" =~ ^T[0-9]{3}$ ]] || die "Aufgaben-ID wie T001 angeben."
  CARD="tasks/$ID.md"
  REPORT="tasks/${ID}_report.md"
  REVIEW="review/$ID.md"
  FROZEN="review/${ID}_frozen.sha256"
  BASELINE="review/${ID}_baseline.sha256"
  RUNSTART="review/${ID}_runstart"
  TEXDIFF="review/${ID}_proposal.diff"
  TEXBUILD="review/${ID}_latex.txt"
  [[ -f "$CARD" ]] || die "$CARD existiert nicht."
}

# Feld aus dem Kopf der Karte lesen, z. B. `field status`.
field() { grep -m1 "^$1:" "$CARD" | sed "s/^$1:[[:space:]]*//" | tr -d '\r'; }

set_status() {
  sed -i '' "s/^status:.*/status: $1/" "$CARD"
  echo "$ID: Status $1"
}

require_status() {
  local current; current="$(field status)"
  local allowed
  for allowed in "$@"; do [[ "$current" == "$allowed" ]] && return 0; done
  die "$ID hat Status $current, nötig ist: $*"
}

# Alle in Backticks genannten, existierenden Dateien aus den übergebenen Markdown-Dateien.
listed_files() {
  grep -oh '`[^`]*`' "$@" 2>/dev/null | tr -d '`' | sort -u | while IFS= read -r p; do
    if [[ -f "$p" ]]; then echo "$p"; fi
  done
  return 0
}

# In Backticks genannte, existierende Dateien aus dem Abschnitt "Eingaben" der Karte.
input_files() {
  { awk '/^## (Eingaben|Inputs)/{f=1;next} /^## /{f=0} f' "$CARD" | grep -o '`[^`]*`' || true; } | tr -d '`' | sort -u | while IFS= read -r p; do
    if [[ -f "$p" ]]; then echo "$p"; fi
  done
  return 0
}

# Wichtigkeit der Aufgabe (Feld `priority:`), Vorgabe normal.
priority() {
  local p; p="$(field priority || true)"; p="${p:-normal}"
  case "$p" in high|normal|low) echo "$p" ;; *) die "priority muss high, normal oder low sein, nicht '$p'." ;; esac
}

source agents/providers.sh
# Compatibility helper: historical declarations validate but default routing is policy-driven.
effective_tool() { provider_name "$1" > /dev/null; select_provider "${2:-worker}"; }
tier() {
  provider_name "$1" > /dev/null
  case "$(priority)" in high) echo high ;; normal) echo medium ;; low) echo low ;; esac
}

# In Backticks genannte Pfade aus dem Abschnitt "Schreibbereich" der Karte (Dateien oder Ordner).
scope_paths() {
  awk '/^## (Schreibbereich|Write scope)/{f=1;next} /^## /{f=0} f' "$CARD" | grep '^- ' | grep -o '`[^`]*`' | tr -d '`' | sed 's/\.\.\.$/*/' | sort -u || true
}

# Liest Pfade von stdin und gibt die aus, die nicht im Schreibbereich liegen.
outside_scope() {
  local scope; scope="$(scope_paths)"
  while IFS= read -r f; do
    [[ -n "$f" ]] || continue
    local inside=0 s
    while IFS= read -r s; do
      [[ -n "$s" ]] || continue
      if [[ "$f" == "$s" || "$f" == "${s%/}/"* || ( "$s" == *\* && "$f" == $s ) ]]; then inside=1; fi
    done <<< "$scope"
    if [[ "$inside" == 0 ]]; then echo "$f"; fi
  done
  return 0
}

# Projektdateien, die seit Beginn des letzten Worker-Laufs geändert wurden (ohne Verwaltung des Teams).
# Referenz ist der Laufmarker RUNSTART (worker.sh setzt ihn vor jedem Lauf); ohne Marker die Baseline des ersten Laufs.
# PI-Entscheidung 16.11.2026: Dateien anderer Karten, die zwischen zwei Läufen entstanden, zählen nicht als Verstoß.
touched_since_start() {
  local ref="$BASELINE"
  [[ -f "$RUNSTART" ]] && ref="$RUNSTART"
  [[ -f "$ref" ]] || return 0
  find . -type f -newer "$ref" \
    -not -path './proposal/.git/*' -not -path './Daten/.venv/*' \
    -not -path './tasks/*' -not -path './review/*' -not -path './state/*' \
    -not -path './MTPA Vault/.obsidian/*' -not -path './presentation/slides/*' \
    -not -name '.DS_Store' | sed 's|^\./||' | sort
}
