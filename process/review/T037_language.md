## Rolle: language (codex, high) – VERDICT: REWORK


## Befunde

[number withheld]. **EBITDA wird nicht definiert.** In `proposal/sections/02_literature.tex:23` erscheint „debt-to-EBITDA“ ohne Erläuterung. Das verletzt die Vorgabe, Abkürzungen beim ersten Auftreten einzuführen (`state/writing_rules.md:6`). Vorschlag: „debt relative to earnings before interest, taxes, depreciation, and amortization (EBITDA)“.

[number withheld]. **„The excess mass disappears“ ist sprachlich zu kategorisch.** Die Formulierung steht in `proposal/main.tex:48` und `proposal/sections/07_conclusion.tex:9`. Sie beschreibt das Verschwinden als feststehenden Befund. Abschnitt [number withheld] berichtet hingegen einen negativen Punktschätzer mit einem Unsicherheitsintervall (`proposal/sections/[number withheld]_preliminary_analysis.tex:[number withheld]–[number withheld]`). Präziser: „estimated excess mass becomes negative“. Die statistische Bewertung bleibt Aufgabe des Consistency Reviewers.

[number withheld]. **Geschützte Leerzeichen vor eingebundenen Autorenzitaten fehlen.** Entgegen `state/writing_rules.md:6` stehen gewöhnliche Leerzeichen an folgenden Stellen. Dadurch können Satzanschluss und Autorenzitat getrennt umbrechen. Korrekturen:

   - `proposal/sections/01_introduction.tex:16`: `proposal,~\citet{jin2[number withheld]deleveraging}`
   - `proposal/sections/02_literature.tex:13`: `is~\citet{jin2[number withheld]deleveraging}`
   - `proposal/sections/02_literature.tex:17`: `and~\citet{zheng2[number withheld]three}`
   - `proposal/sections/02_literature.tex:23`: `terms,~\citet{dichev2[number withheld]largesample}`, `and~\citet{bordeman2[number withheld]borrowers}` und `response:~\citet{owens2[number withheld]quarterend}`
   - `proposal/sections/02_literature.tex:27`: `developers,~\citet{huang2[number withheld]leverage}`

[number withheld]. **Hinweis zum unveränderten Literaturbestand: uneinheitliche Großschreibung von Autorennamen.** `proposal/references.bib:24` enthält „jiang, kangqi“, Zeile [number withheld] „MILLS, LILLIAN F.“ und „NEWBERRY, KAYE J.“, Zeile [number withheld] „BORDEMAN, ADAM“ und „DEMERJIAN, PETER“. Diese Quellschreibweisen können im Literaturverzeichnis beziehungsweise in Autorenzitaten erscheinen. Zielschreibweisen sind „Jiang, Kangqi“, „Mills, Lillian F.“, „Newberry, Kaye J.“, „Bordeman, Adam“ und „Demerjian, Peter“. Da die Bibliografie außerhalb des Schreibbereichs von T037 liegt und Metadaten nicht von Hand geändert werden sollen, sollte der PI normalisierte Exporte bereitstellen.

## Abnahmekriterien

[number withheld]. **Wortbudgets; keine neuen Keys; `[cite]`-Liste: belegt erfüllt.** Abstract: [number withheld] Wörter (`proposal/main.tex:45–49`); Conclusion: [number withheld] Wörter (`proposal/sections/07_conclusion.tex:9–15`). Einleitung und Literatur bleiben auch unter Berücksichtigung der Autorenzitate unter [number withheld] beziehungsweise [number withheld] Wörtern. Alle verwendeten Zitierschlüssel existieren in `proposal/references.bib`; der Diff enthält keine Änderung der Bibliografie. Die fehlenden Literaturangaben sind in `tasks/T037_report.md:26–29` aufgelistet.

[number withheld]. **Befunde identisch mit Abschnitt [number withheld]: nicht meine Rolle. Sprachliche Zurückhaltung: nicht vollständig erfüllt**, siehe Befund [number withheld]. Die Einschränkungen zur Kausalität und zur unbekannten ökonomischen Substanz werden ansonsten ausdrücklich und verständlich formuliert (`proposal/sections/01_introduction.tex:28`; `proposal/sections/07_conclusion.tex:9`).

[number withheld]. **Fehlerfreie Übersetzung durch den PI: nicht meine Rolle.** Das bereitgestellte Protokoll meldet „LaTeX: übersetzt fehlerfrei“ (`review/T037_latex.txt:1`).

## Nicht geprüft

- Variablendefinitionen, Stichprobenfilter, Zahlenabgleich mit CSV-Dateien, Identifikationsannahmen und Reproduzierbarkeit: außerhalb der Spezialrolle.
- Literaturinhalte und bibliografische Metadaten gegen Originalquellen: außerhalb der Sprachprüfung.
- Gerenderte Typografie, tatsächliche Zeilenumbrüche und Darstellung der Autorennamen: kein eingefrorenes PDF beziehungsweise Bibliografie-Ergebnis geprüft.
- Keine eigene Kompilierung, keine Befehle und keine Dateiänderungen. `proposal/sections/03_framework.tex` wurde als Kontext gelesen; Änderungen daran sind nicht Gegenstand von T037.