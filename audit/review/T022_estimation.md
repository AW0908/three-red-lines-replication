## Rolle: estimation (claude, sonnet) – VERDICT: PASS


## Befunde
Keine inhaltlichen Fehler im Rahmen meiner Rolle (Estimation).

1. Die einzige Codeänderung betrifft die S14-Notiz (`04_robustness.R:353`). Dort steht jetzt „both already outside the main sample“. Die Schätzzeilen sind unverändert:
   - `run_spec`, `run_all` und die S14-Aufrufe (Z. 82–204, 308) enthalten nichts Neues.
   - Die eingebetteten Fixtures (T011, T019) und die 1e-12-Assertions (Z. 284–332) laufen weiter vor dem Schreiben.
   - Verändert sich eine Zahl, bricht das Skript also ab, bevor die Datei entsteht.
2. In `t011_robustness.tex` Zeile 77 steht die korrigierte Notiz. Die einzigen verbleibenden Unterstriche stehen in Zeile 62 und Zeile 63 als `dose\_pre`, also maskiert.
3. Auch die anderen `.tex`-Tabellen enthalten außerhalb von `\label{tab:did_main}` und `\label{tab:soe_het}` kein `sample_main` und kein Muster `x_y`. Das ist unkritisch, weil Unterstriche in Labels erlaubt sind.
4. Das Worker-Protokoll (Fresh-Copy-Build, 36 von 37 Artefakten bytegleich) habe ich nicht neu ausgeführt. Dass die Tabellenzahlen konsistent sind, zeigt aber der Vergleich: S14 entspricht S0 in allen Zellen, wie `04_robustness.R:330–331` es erzwingt. S1–S13 passen zu den Fixture-Ketten.

## Abnahmekriterien
1. **Belegt erfüllt:** Die Datei enthält keinen unmaskierten Unterstrich (Grep). Die Notizänderung ist die einzige, die der Code erklärt; die Zahlen entstehen aus unveränderten Modellaufrufen.
2. **Teilweise belegt:** Der Code lässt keine andere Änderung zu. Die Bytegleichheit der übrigen Outputs und Exit 0 habe ich nicht selbst nachgeprüft; dafür gibt es nur den Worker-Bericht. Das ist keine Aussage, die in meine Rolle fällt.
3. **Belegt erfüllt:** Der Bericht listet den Scan für alle sechs `.tex`-Dateien (T022_report.md Z. 35–46). Mein Grep bestätigt das für Unterstriche. `%`, `&` und `#` habe ich nicht eigenständig gescannt.
4. **Write scope:** Geschrieben wurde nur in `04_robustness.R`, `t011_robustness.tex` und der README-Changelog (Z. 513). `00_setup.R` ist unverändert, der Helfer war optional. Zur Änderung von `agents/Team_Workflow_EN.tex` (außerhalb des Schreibbereichs) gibt es keinen Hinweis in den Dateien dieser Karte. Das gehört zum Co-PI oder zu einer parallelen Sitzung und lässt sich aus meinen Dateien nicht zuordnen.

## Nicht geprüft
- Ich habe keinen Befehl ausgeführt, also weder den Fresh-Copy-Build noch einen Byte-Diff.
- Ob das LaTeX tatsächlich kompiliert, habe ich nicht geprüft. Dazu fehlte die Möglichkeit, pdfLaTeX auszuführen.
- Die Konsistenz zwischen Text und Output ist Aufgabe der Rolle „consistency“.
