## Ergebnis

Rework 4 setzt die zehn freigegebenen Ersetzungen um; sechs LaTeX-Dateien wurden geändert. Der Abstract hat 88 Wörter, der Haupttext endet auf Seite 14 und die Gesamtfassung bleibt bei 37 Seiten. Build, Schriftprüfung und Sichtprüfung bestehen.

## Dateien

- `proposal/main.tex` – Abstract und Wortzählkommentar.
- `proposal/sections/01_introduction.tex` – Trendwortlaut.
- `proposal/sections/02_literature.tex` – schließendes Anführungszeichen.
- `proposal/sections/06_preliminary_analysis.tex` – Fallzahlen, Terminologie, Tabellennote, Trenddeutung und Fall (a).
- `proposal/sections/07_conclusion.tex` – Trendwortlaut.
- `proposal/appendix/results.tex` – Verifikationshinweis und Crosser-Anteile.
- `review/T045_build/main.pdf` – geprüfte Gesamtfassung.
- `review/T045_build/main.aux`, `main.fdb_latexmk`, `main.fls`, `main.log`, `main.out`, `main.toc`, `main.xdv` – Build-Nebenprodukte.
- `tasks/T045_report.md` – vollständiger Bericht mit A1–F-Matrix, Zahlenquellen, Statement-IDs und Wortzählungen.

:codex-file-citation{path="/Users/<local>/Desktop/UNI/5. Semester PKU/Policy Analysis/review/T045_build/main.pdf" purpose="output"}

## Ausführung

Selbst ausgeführt, Exitcode 0:

[fenced excerpt withheld in public audit]
[fenced excerpt withheld in public audit]

Letzte Ausgabezeilen:

[fenced excerpt withheld in public audit]
[fenced excerpt withheld in public audit]

Zusätzlich: CSV- und Registerabgleich, SHA-256-Prüfung, `pdffonts`, `pdfinfo`, `detex` und Sichtprüfung aller 37 gerenderten Seiten.

## Abnahmekriterien

| Rework-4-Punkt | Ergebnis und Fundstelle |
|---|---|
| 1 | Erfüllt: Trendwortlaut wortgleich in `01_introduction.tex:19`, `06_preliminary_analysis.tex:61`, `07_conclusion.tex:5`. |
| 2 | Erfüllt: Abstract-Satz ersetzt; 88 Wörter, `proposal/main.tex:51–52`. |
| 3 | Erfüllt: Anführungszeichen geschlossen, `02_literature.tex:16`. |
| 4 | Erfüllt: 602 Firmenhalbjahre/129 Firmen, `06_preliminary_analysis.tex:42`; CSV-Filter `window=post, variant=all, scope=paired, specification=main`. |
[firm-specific excerpt withheld in public audit]
| 6 | Erfüllt: 33 Firmenjahre für Crossers und 48 für übrige Firmen ausgeschrieben, `06_preliminary_analysis.tex:91`; gegen T046 geprüft. |
| 7 | Erfüllt: „firm trend“ und „compliant share“ vereinheitlicht; erste Nennung je Absatz bereits „percentage points“. |
| 8 | Erfüllt: vorsichtige Anreizformulierung, `06_preliminary_analysis.tex:67`. |
| 9 | Erfüllt: Bezug „Such group-internal capital“, `06_preliminary_analysis.tex:97`. |
| 10 | Erfüllt: beide Ersetzungen, `proposal/appendix/results.tex:143,146`. |

Die vollständige A1–F- und Zahlenzuordnung steht in `tasks/T045_report.md`.

- **Zahlen:** Ausschließlich 602/129 neu ergänzt; beide CSV-bestätigt. Alle bisherigen numerischen Angaben unverändert. Die dokumentierten Ausnahmen von der strikten Output-CSV-Pflicht bleiben bestehen.
- **Verifikation:** 47 qualitative Aussagen erneut `yes/meaning`; 109 beobachtete numerische Ledger-Operanden mindestens `yes/strings`. 54 fehlende Operanden bleiben fehlend.
- **Build:** Keine Fehler oder undefinierten Referenzen; BibTeX-Log ohne Warnungen. Einzige Overfull-Box: 0,79266 pt, unter 2 pt.
- **Umfang:** Haupttext 14 Seiten; Anhang B 15, Anhang C 3; insgesamt 37 PDF-Seiten.
- **Schriften:** Alle 25 Ressourcen eingebettet; keine verbotenen Textfonts.
- **Interpretation:** Keine eigene Ergebnisaussage als kausaler Politikeffekt; Trendbefund in allen vier verlangten Teilen.
- **Dateischutz:** Alle 414 inventarisierten Dateien unter `replication/` unverändert; Kartenstatus unverändert.

| Abschnitt | Vorher | Nachher |
|---|---:|---:|
| Introduction | 436 | 446 |
| Literature | 551 | 551 |
| Framework | 644 | 644 |
| Empirical strategy | 798 | 798 |
| Context/data | 814 | 814 |
| Preliminary analysis | 1621 | 1642 |
| Conclusion | 154 | 164 |
| **Gesamt** | **5018** | **5059** |

Gezählt mit `detex -l`; Zusatzdesigns 48/50 Wörter, Fall (d) 89 Wörter.

## Offene Fragen

- Unabhängiges Review und PI-Abnahme stehen aus; Status bleibt REWORK.
- „Equity transactions“ im Abstract, „all eligible paired“ in `04_empirical_model.tex:32` und weitere Stilvorschläge bleiben gemäß der verbindlichen Beschränkung auf die zehn Ersetzungen unverändert.
- Unveränderte Zahlenquellen und Firmenanteilszellen wurden in dieser Runde nicht vollständig erneut nachgerechnet; Vertragsseiten nicht erneut übersetzt. Die Analysepipeline wurde nicht ausgeführt.
- KI-Protokolleintrag vorgeschlagen, da außerhalb des Schreibbereichs: „2026-10-30, Codex CLI, T045 Rework 4: zehn freigegebene Ersetzungen; CSV-, Register-, Build-, Schrift- und Sichtprüfung; Abstract 88 Wörter, Haupttext 14 Seiten/5.059 Wörter; Daten und Outputs unverändert.“