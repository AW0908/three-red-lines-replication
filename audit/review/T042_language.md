## Rolle: language (codex, medium) – VERDICT: REWORK


## Befunde

1. **Mehrere Abkürzungen werden beim ersten Auftreten nicht ausgeschrieben.** In `proposal/appendix/ai_use.tex:5` stehen „PI“ und „Co-PI“ ohne Auflösung; in Zeile 89 gilt dies für „CNKI“ und „CSSCI“. Auch im vorausgehenden Proposal-Text habe ich dafür keine ausgeschriebenen Definitionen gefunden. Das erschwert insbesondere externen Lesern das Verständnis der Rollen und Suchquellen. Korrekturvorschläge:
   - Zeile 5: „Anton, the principal investigator (PI), …“ und „Claude Code, the co-principal investigator (Co-PI), …“.
   - Zeile 89: „China National Knowledge Infrastructure (CNKI)“ und „Chinese Social Sciences Citation Index (CSSCI)“.

Weitere eindeutige Rechtschreib-, Grammatik- oder LaTeX-Typografiefehler wurden im geprüften Appendix nicht gefunden. Die knappen Tabellenfragmente sind für eine Nutzungsdokumentation angemessen.

## Abnahmekriterien

1. **Quellenzuordnung jeder Zeile:** nicht meine Rolle. Die Zuordnungstabelle steht in `tasks/T042_report.md:39–65`; ihre sachliche Richtigkeit wurde nicht geprüft.
2. **Keine unbelegt behaupteten Prüfungen:** nicht meine Rolle. Die sprachliche Unterscheidung zwischen dokumentierter Prüfung, offenen Prüfungen und ausstehender PI-Abnahme ist nachvollziehbar.
3. **Abdeckung aller freigegebenen Karten:** nicht meine Rolle.
4. **Sechs Spalten, Englisch, fehlerfreie Übersetzung, höchstens vier Seiten:** hinsichtlich der Sprachvorgaben **nicht vollständig erfüllt**, wegen der undefinierten Abkürzungen aus Befund 1. Durchgehend englischer Text und eine sechs Spalten definierende `longtable` sind belegt (`proposal/appendix/ai_use.tex:5–95`). Amerikanische Schreibweisen sind konsistent, etwa „Summarize“ und „labeled“ in Zeilen 49 und 55. `review/T042_latex.txt:1` bestätigt eine fehlerfreie Übersetzung; Seitenzahl und tatsächlicher Satz wurden nicht unabhängig geprüft.
5. **Vorschläge für fehlende Logeinträge:** nicht meine Rolle; entsprechende Vorschläge stehen in `tasks/T042_report.md:134–157`.

Die ausdrücklich angeforderten Sprachkorrekturen aus `tasks/T042.md:69` sind umgesetzt: ausgeschriebene WoS-/PRISMA-Bezeichnungen, „All reviews: PASS“, die Formulierung zu PI-Entscheidungen, die Unterscheidung der Übersetzungsprüfungen sowie parallele Verben in R19 (`proposal/appendix/ai_use.tex:55,73,76,89`).

## Nicht geprüft

- Quellenwahrheit, Freigaben, vollständige Kartenabdeckung, Variablendefinitionen und Stichproben: außerhalb der Language-Rolle.
- PDF-Layout, Vierseitengrenze und Überläufe: keine unabhängige visuelle Prüfung oder erneute Übersetzung durchgeführt.
- Die gemeldeten Änderungen an Eingaben und Dateien außerhalb des Schreibbereichs: nicht unabhängig untersucht oder dem Worker zugerechnet; durch die zuständige Rolle zu klären.
- Keine Dateien verändert und keine Shell-Befehle ausgeführt.