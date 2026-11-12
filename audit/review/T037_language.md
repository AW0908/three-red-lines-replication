## Rolle: language (codex, high) – VERDICT: REWORK


## Befunde

1. **EBITDA wird nicht definiert.** In `proposal/sections/02_literature.tex:23` erscheint „debt-to-EBITDA“ ohne Erläuterung. Das verletzt die Vorgabe, Abkürzungen beim ersten Auftreten einzuführen (`state/writing_rules.md:6`). Vorschlag: „debt relative to earnings before interest, taxes, depreciation, and amortization (EBITDA)“.

2. **„The excess mass disappears“ ist sprachlich zu kategorisch.** Die Formulierung steht in `proposal/main.tex:48` und `proposal/sections/07_conclusion.tex:9`. Sie beschreibt das Verschwinden als feststehenden Befund. Abschnitt 6 berichtet hingegen einen negativen Punktschätzer mit einem Unsicherheitsintervall (`proposal/sections/06_preliminary_analysis.tex:87,100–101`). Präziser: „estimated excess mass becomes negative“. Die statistische Bewertung bleibt Aufgabe des Consistency Reviewers.

3. **Geschützte Leerzeichen vor eingebundenen Autorenzitaten fehlen.** Entgegen `state/writing_rules.md:6` stehen gewöhnliche Leerzeichen an folgenden Stellen. Dadurch können Satzanschluss und Autorenzitat getrennt umbrechen. Korrekturen:

   - `proposal/sections/01_introduction.tex:16`: `proposal,~\citet{jin2025deleveraging}`
   - `proposal/sections/02_literature.tex:13`: `is~\citet{jin2025deleveraging}`
   - `proposal/sections/02_literature.tex:17`: `and~\citet{zheng2024three}`
   - `proposal/sections/02_literature.tex:23`: `terms,~\citet{dichev2002largesample}`, `and~\citet{bordeman2022borrowers}` und `response:~\citet{owens2015quarterend}`
   - `proposal/sections/02_literature.tex:27`: `developers,~\citet{huang2025leverage}`

4. **Hinweis zum unveränderten Literaturbestand: uneinheitliche Großschreibung von Autorennamen.** `proposal/references.bib:24` enthält „jiang, kangqi“, Zeile 38 „MILLS, LILLIAN F.“ und „NEWBERRY, KAYE J.“, Zeile 44 „BORDEMAN, ADAM“ und „DEMERJIAN, PETER“. Diese Quellschreibweisen können im Literaturverzeichnis beziehungsweise in Autorenzitaten erscheinen. Zielschreibweisen sind „Jiang, Kangqi“, „Mills, Lillian F.“, „Newberry, Kaye J.“, „Bordeman, Adam“ und „Demerjian, Peter“. Da die Bibliografie außerhalb des Schreibbereichs von T037 liegt und Metadaten nicht von Hand geändert werden sollen, sollte der PI normalisierte Exporte bereitstellen.

## Abnahmekriterien

1. **Wortbudgets; keine neuen Keys; `[cite]`-Liste: belegt erfüllt.** Abstract: 98 Wörter (`proposal/main.tex:45–49`); Conclusion: 343 Wörter (`proposal/sections/07_conclusion.tex:9–15`). Einleitung und Literatur bleiben auch unter Berücksichtigung der Autorenzitate unter 700 beziehungsweise 600 Wörtern. Alle verwendeten Zitierschlüssel existieren in `proposal/references.bib`; der Diff enthält keine Änderung der Bibliografie. Die fehlenden Literaturangaben sind in `tasks/T037_report.md:26–29` aufgelistet.

2. **Befunde identisch mit Abschnitt 6: nicht meine Rolle. Sprachliche Zurückhaltung: nicht vollständig erfüllt**, siehe Befund 2. Die Einschränkungen zur Kausalität und zur unbekannten ökonomischen Substanz werden ansonsten ausdrücklich und verständlich formuliert (`proposal/sections/01_introduction.tex:28`; `proposal/sections/07_conclusion.tex:9`).

3. **Fehlerfreie Übersetzung durch den PI: nicht meine Rolle.** Das bereitgestellte Protokoll meldet „LaTeX: übersetzt fehlerfrei“ (`review/T037_latex.txt:1`).

## Nicht geprüft

- Variablendefinitionen, Stichprobenfilter, Zahlenabgleich mit CSV-Dateien, Identifikationsannahmen und Reproduzierbarkeit: außerhalb der Spezialrolle.
- Literaturinhalte und bibliografische Metadaten gegen Originalquellen: außerhalb der Sprachprüfung.
- Gerenderte Typografie, tatsächliche Zeilenumbrüche und Darstellung der Autorennamen: kein eingefrorenes PDF beziehungsweise Bibliografie-Ergebnis geprüft.
- Keine eigene Kompilierung, keine Befehle und keine Dateiänderungen. `proposal/sections/03_framework.tex` wurde als Kontext gelesen; Änderungen daran sind nicht Gegenstand von T037.