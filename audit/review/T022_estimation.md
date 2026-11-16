## Rolle: estimation (claude, sonnet) – VERDICT: PASS


## Befunde
Keine inhaltlichen Fehler im Rahmen meiner Rolle (Estimation).

[number withheld]. Die einzige Codeänderung betrifft die S1[number withheld]-Notiz (`04_robustness.R:353`). Dort steht jetzt „both already outside the main sample“. Die Schätzzeilen sind unverändert:
   - `run_spec`, `run_all` und die S1[number withheld]-Aufrufe (Z. [number withheld]–[number withheld], [number withheld]) enthalten nichts Neues.
   - Die eingebetteten Fixtures (T011, T019) und die [number withheld]-Assertions (Z. [number withheld]–[number withheld]) laufen weiter vor dem Schreiben.
   - Verändert sich eine Zahl, bricht das Skript also ab, bevor die Datei entsteht.
[number withheld]. In `t011_robustness.tex` Zeile [number withheld] steht die korrigierte Notiz. Die einzigen verbleibenden Unterstriche stehen in Zeile [number withheld] und Zeile [number withheld] als `dose\_pre`, also maskiert.
[number withheld]. Auch die anderen `.tex`-Tabellen enthalten außerhalb von `\label{tab:did_main}` und `\label{tab:soe_het}` kein `sample_main` und kein Muster `x_y`. Das ist unkritisch, weil Unterstriche in Labels erlaubt sind.
[number withheld]. Das Worker-Protokoll (Fresh-Copy-Build, [number withheld] von [number withheld] Artefakten bytegleich) habe ich nicht neu ausgeführt. Dass die Tabellenzahlen konsistent sind, zeigt aber der Vergleich: S1[number withheld] entspricht S0 in allen Zellen, wie `04_robustness.R:330–331` es erzwingt. S1–S1[number withheld] passen zu den Fixture-Ketten.

## Abnahmekriterien
[number withheld]. **Belegt erfüllt:** Die Datei enthält keinen unmaskierten Unterstrich (Grep). Die Notizänderung ist die einzige, die der Code erklärt; die Zahlen entstehen aus unveränderten Modellaufrufen.
[number withheld]. **Teilweise belegt:** Der Code lässt keine andere Änderung zu. Die Bytegleichheit der übrigen Outputs und Exit [number withheld] habe ich nicht selbst nachgeprüft; dafür gibt es nur den Worker-Bericht. Das ist keine Aussage, die in meine Rolle fällt.
[number withheld]. **Belegt erfüllt:** Der Bericht listet den Scan für alle sechs `.tex`-Dateien (T0[number withheld]_report.md Z. [number withheld]–[number withheld]). Mein Grep bestätigt das für Unterstriche. `%`, `&` und `#` habe ich nicht eigenständig gescannt.
[number withheld]. **Write scope:** Geschrieben wurde nur in `04_robustness.R`, `t011_robustness.tex` und der README-Changelog (Z. [number withheld]). `00_setup.R` ist unverändert, der Helfer war optional. Zur Änderung von `agents/Team_Workflow_EN.tex` (außerhalb des Schreibbereichs) gibt es keinen Hinweis in den Dateien dieser Karte. Das gehört zum Co-PI oder zu einer parallelen Sitzung und lässt sich aus meinen Dateien nicht zuordnen.

## Nicht geprüft
- Ich habe keinen Befehl ausgeführt, also weder den Fresh-Copy-Build noch einen Byte-Diff.
- Ob das LaTeX tatsächlich kompiliert, habe ich nicht geprüft. Dazu fehlte die Möglichkeit, pdfLaTeX auszuführen.
- Die Konsistenz zwischen Text und Output ist Aufgabe der Rolle „consistency“.
