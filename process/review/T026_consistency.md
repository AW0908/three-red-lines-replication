## Rolle: consistency (codex, high) – VERDICT: REWORK


## Befunde

[number withheld]. **Der Haupttext überschreitet die verbindliche Grenze von sechs Seiten.** Im vorhandenen PDF `review/T026_theory_build/theory_note.pdf` beginnt die Diskussion auf Seite [number withheld] und läuft auf Seite [number withheld] weiter, bis „These extensions are left for future work.“ Erst danach beginnt das Literaturverzeichnis. Der Haupttext umfasst somit **[number withheld] Seiten**, das gesamte Dokument [number withheld] Seiten. Die Tabelle liegt auf Seite [number withheld]; Anhang A beginnt auf Seite [number withheld] (`review/T0[number withheld]_theory_build/theory_note.aux`, Zeilen [number withheld]–[number withheld]). Damit ist die Zusatzanforderung aus `tasks/T026.md`, Zeilen [number withheld]–[number withheld], nicht erfüllt. Weitere Kürzung oder Verlagerung in den Anhang ist erforderlich.

## Abnahmekriterien

[number withheld]. **Propositionen und vollständige algebraische Herleitung:** nicht meine Rolle. Hinsichtlich innerer Konsistenz stimmen Definitionen und Verweise überein. Die Erweiterung um den anfänglichen Wedge definiert ausdrücklich \(L_0\), den Rückgang \(\Delta L=L_0-L\) und die unveränderten Entscheidungsbedingungen (`proposal/theory_note.tex`, Zeilen [number withheld]–[number withheld]).

[number withheld]. **Vorhersage–Test-Tabelle stimmt mit T023–T025 und bestehenden Ergebnissen überein: belegt erfüllt im Rahmen der Consistency-Rolle.**

   - Die DiD-Beschreibung nennt Outcome-Niveaus, alle [number withheld] Halbjahresdaten sowie Firmen- und Datums-Fixed-Effects. Das entspricht `replication/code/02_estimate.R`, Zeilen [number withheld]–[number withheld] und [number withheld]–[number withheld].
   - Die Aussage über einen positiven anfänglichen `rl2_gap` ist belegt: `pre_mean = [number withheld]` (`replication/outputs/tables/t009_did_main.csv`, Zeile [number withheld]).
   - Die Einschränkung von `rl2_adj` auf den Perpetual-Kanal und die informative Teilstichprobe ist ausdrücklich genannt. Das entspricht den Definitionen und dem Ausschluss imputierter Perpetual-Nullwerte (`replication/code/01_clean.R`, Zeilen [number withheld]–[number withheld] und [number withheld]–[number withheld]; `replication/code/06_bunching_tests.R`, Zeilen [number withheld]–[number withheld]).
   - Die RL2-Bingrenzen `[[number withheld])` entsprechen `replication/outputs/tables/t023_reversal.tex`, Zeile [number withheld]. `rl1_alt` wird korrekt als beschreibende Alternativdefinition behandelt.
   - Die zusätzliche Annahme zum mechanischen Beitrag im tatsächlich geschätzten TWFE-Modell und ihre Geltung auch für Änderungen innerhalb einer Firma stehen ausdrücklich im Text (`proposal/theory_note.tex`, Zeilen [number withheld]–[number withheld]).
   - RD und Attrition werden entsprechend T024 beziehungsweise T025 zugeordnet. Die Notiz behauptet keine bereits nachgewiesenen empirischen Effekte.

[number withheld]. **Eigenständige Übersetzung: belegt erfüllt anhand des vorhandenen Builds.** `review/T026_latex.txt`, Zeile [number withheld], meldet erfolgreiche Übersetzung; das ausführliche Buildlog dokumentiert die PDF-Ausgabe. Keine undefinierten Verweise oder Zitate festgestellt.

[number withheld]. **Keine Änderung anderer Dateien: nicht vollständig prüfbar.** Präambel, Bibliografie und Framework haben in Baseline und Freeze identische SHA-[number withheld]-Einträge (`review/T026_baseline.sha256` und `review/T026_frozen.sha256`, jeweils Zeilen [number withheld]–[number withheld]). Die darüber hinaus gemeldeten Änderungen lassen sich damit nicht vollständig dem T026-Worker oder anderen Sitzungen zuordnen. Änderungen an `main.tex` und dem Schlussgerüst sind als Co-PI-Arbeit dokumentiert (`state/STATE.md`, Zeile [number withheld]).

[number withheld]. **Zusatzanforderungen zu Layout und Umfang:** teilweise erfüllt. Im vorhandenen LaTeX-Log stehen weder „Float too large“ noch „Overfull \hbox“. Die Grenze von sechs Haupttextseiten ist **nicht erfüllt**, siehe Befund [number withheld].

## Nicht geprüft

- Mathematische Beweise, Schätzverfahren und Datenbereinigung: nicht meine Spezialrolle.
- Keine eigene Übersetzung, Schätzung oder sonstige Befehlsausführung; ausschließlich vorhandene Dateien gelesen.
- Keine vollständige Prüfung des übrigen Proposals außerhalb von T026.
- Urheberschaft und genaue Inhaltsänderungen sämtlicher gemeldeter Dateien außerhalb des Schreibbereichs; dafür fehlt ein vollständiger Vergleich mit zugeordneten Ausgangsständen.