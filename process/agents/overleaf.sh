#!/bin/bash
# Abgleich von proposal/ mit dem Overleaf-Projekt.
#   agents/overleaf.sh pull         Änderungen aus Overleaf holen
#   agents/overleaf.sh check        proposal/main.tex testweise übersetzen
#   agents/overleaf.sh push T002    abgenommene Aufgabe committen und hochladen (nur Status DELIVERED)
#   agents/overleaf.sh preview T002 Zwischenstand nach einem Review hochladen (Status REWORK, PASS, ESCALATE, DELIVERED;
#                                   nicht während APPROVED/EXECUTED/CANDIDATE, damit kein eingefrorener Stand verändert wird)
# Der Zugang liegt im macOS-Schlüsselbund; hier steht kein Token.
source "$(dirname "$0")/lib.sh"

[[ -d proposal/.git ]] || die "proposal/ ist kein Git-Klon des Overleaf-Projekts."
export GIT_TERMINAL_PROMPT=0

compile_check() {
  command -v latexmk > /dev/null || { echo "latexmk fehlt, Übersetzung nicht geprüft."; return 0; }
  local out; out="$(mktemp -d)"
  if (cd proposal && latexmk -interaction=nonstopmode -halt-on-error -outdir="$out" main.tex > "$out/build.log" 2>&1); then  # Engine aus proposal/latexmkrc (XeLaTeX)
    echo "LaTeX: übersetzt fehlerfrei."
    rm -rf "$out"
  else
    grep -m5 -A2 '^!' "$out/build.log" || tail -5 "$out/build.log"
    die "LaTeX übersetzt nicht (Protokoll: $out/build.log)."
  fi
}

case "${1:-}" in
  pull)
    if ! out="$(git -C proposal pull --ff-only --autostash 2>&1)"; then
      echo "$out"
      if grep -qiE "unable to access|could not resolve|failed to connect|timed out|connection refused" <<< "$out"; then
        echo "WARNUNG: Overleaf nicht erreichbar. Weiter mit lokalem Stand von proposal/ ($(git -C proposal log -1 --format=%h))."
        echo "         Nicht parallel im Overleaf-Web editieren; push holt Overleaf-Änderungen vorher per rebase."
        exit 0
      fi
      die "Pull gescheitert: lokale und Overleaf-Änderungen widersprechen sich."
    fi
    echo "$out"
    ;;
  check)
    compile_check
    ;;
  push)
    load_task "${2:-}"
    require_status DELIVERED
    compile_check
    git -C proposal add -A
    if git -C proposal diff --cached --quiet; then
      echo "Nichts zu committen."
    else
      git -C proposal commit -q -m "$ID: $(field title)"
    fi
    git -C proposal pull --rebase || die "Overleaf hat neuere Änderungen, die sich nicht automatisch einfügen lassen."
    git -C proposal push || die "Push gescheitert."
    echo "$ID: nach Overleaf hochgeladen ($(git -C proposal log -1 --format=%h))."
    ;;
  preview)
    load_task "${2:-}"
    require_status REWORK PASS ESCALATE DELIVERED
    compile_check
    git -C proposal add -A
    if git -C proposal diff --cached --quiet; then
      echo "Nichts zu committen."
    else
      git -C proposal commit -q -m "$ID: Zwischenstand zur Ansicht (Status $(field status))"
    fi
    git -C proposal pull --rebase || die "Overleaf hat neuere Änderungen, die sich nicht automatisch einfügen lassen."
    git -C proposal push || die "Push gescheitert."
    echo "$ID: Zwischenstand nach Overleaf hochgeladen ($(git -C proposal log -1 --format=%h))."
    ;;
  *) die "Aufruf: agents/overleaf.sh pull | check | push T001 | preview T001" ;;
esac
