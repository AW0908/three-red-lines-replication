#!/bin/bash
# Übersicht aller Aufgaben.
source "$(dirname "$0")/lib.sh"

printf "%-6s %-10s %-7s %-8s %-30s %s\n" ID STATUS PRIO WORKER REVIEWER TITEL
for CARD in tasks/T[0-9][0-9][0-9].md; do
  [[ -f "$CARD" ]] || { echo "(noch keine Aufgaben)"; break; }
  printf "%-6s %-10s %-7s %-8s %-30s %s\n" "$(field id)" "$(field status)" "$(priority)" "$(field worker)" "$( r="$(field reviewers || true)"; if [[ -n "$r" ]]; then echo "$r" | tr -d " " | sed "s/=[a-z]*//g"; else field reviewer; fi )" "$(field title)"
done
