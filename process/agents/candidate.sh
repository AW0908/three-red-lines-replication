#!/bin/bash
# Ergebnis nach der ersten Qualitätskontrolle als Kandidat einfrieren.
#   agents/candidate.sh T001
# Speichert Prüfsummen aller in Karte und Bericht genannten Dateien. Die Verwaltungsdateien des
# Teams (tasks/, review/, state/) ändern sich im Ablauf und bleiben außen vor.
source "$(dirname "$0")/lib.sh"

load_task "${1:-}"
# REWORK ist erlaubt, wenn der Co-PI einen Befund ohne Worker-Lauf klären konnte (in der Karte begründen).
require_status EXECUTED CANDIDATE REWORK
[[ -s "$REPORT" ]] || die "$REPORT fehlt."

FILES="$(listed_files "$CARD" "$REPORT" | grep -v -E '^(tasks|review|state)/' | grep -v -E '(^|/)\.DS_Store$' || true)"
[[ -n "$FILES" ]] || die "In Karte und Bericht ist keine existierende Datei in Backticks genannt."

echo "$FILES" | while IFS= read -r f; do shasum -a 256 "$f"; done > "$FROZEN"
# Schreibaufgaben: Änderungen gegenüber dem letzten Overleaf-Stand für den Reviewer festhalten.
rm -f "$TEXDIFF" "$TEXBUILD"
if [[ -d proposal/.git ]] && echo "$FILES" | grep -q '^proposal/'; then
  git -C proposal add -A -N
  git -C proposal diff > "$TEXDIFF"
  # Übersetzung prüfen; das Ergebnis bekommt der Reviewer, der selbst nichts schreiben darf.
  agents/overleaf.sh check > "$TEXBUILD" 2>&1 || true
  echo "$ID: $(tail -1 "$TEXBUILD")"
fi

echo "$ID: $(wc -l < "$FROZEN" | tr -d ' ') Dateien eingefroren ($FROZEN)"
set_status CANDIDATE
