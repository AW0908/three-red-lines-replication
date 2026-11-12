## Rolle: consistency (codex, high) – VERDICT: REWORK


## Befunde

1. **Der Haupttext überschreitet die verbindliche Grenze von sechs Seiten.** Im vorhandenen PDF `review/T026_theory_build/theory_note.pdf` beginnt die Diskussion auf Seite 6 und läuft auf Seite 7 weiter, bis „These extensions are left for future work.“ Erst danach beginnt das Literaturverzeichnis. Der Haupttext umfasst somit **7 Seiten**, das gesamte Dokument 13 Seiten. Die Tabelle liegt auf Seite 6; Anhang A beginnt auf Seite 8 (`review/T026_theory_build/theory_note.aux`, Zeilen 40–54). Damit ist die Zusatzanforderung aus `tasks/T026.md`, Zeilen 115–120, nicht erfüllt. Weitere Kürzung oder Verlagerung in den Anhang ist erforderlich.

## Abnahmekriterien

1. **Propositionen und vollständige algebraische Herleitung:** nicht meine Rolle. Hinsichtlich innerer Konsistenz stimmen Definitionen und Verweise überein. Die Erweiterung um den anfänglichen Wedge definiert ausdrücklich \(L_0\), den Rückgang \(\Delta L=L_0-L\) und die unveränderten Entscheidungsbedingungen (`proposal/theory_note.tex`, Zeilen 358–374).

2. **Vorhersage–Test-Tabelle stimmt mit T023–T025 und bestehenden Ergebnissen überein: belegt erfüllt im Rahmen der Consistency-Rolle.**

   - Die DiD-Beschreibung nennt Outcome-Niveaus, alle 13 Halbjahresdaten sowie Firmen- und Datums-Fixed-Effects. Das entspricht `replication/code/02_estimate.R`, Zeilen 17–39 und 84–90.
   - Die Aussage über einen positiven anfänglichen `rl2_gap` ist belegt: `pre_mean = 0.0469214550766438` (`replication/outputs/tables/t009_did_main.csv`, Zeile 4).
   - Die Einschränkung von `rl2_adj` auf den Perpetual-Kanal und die informative Teilstichprobe ist ausdrücklich genannt. Das entspricht den Definitionen und dem Ausschluss imputierter Perpetual-Nullwerte (`replication/code/01_clean.R`, Zeilen 549–550 und 580–590; `replication/code/06_bunching_tests.R`, Zeilen 48–66).
   - Die RL2-Bingrenzen `[0.95,1.00)` entsprechen `replication/outputs/tables/t023_reversal.tex`, Zeile 24. `rl1_alt` wird korrekt als beschreibende Alternativdefinition behandelt.
   - Die zusätzliche Annahme zum mechanischen Beitrag im tatsächlich geschätzten TWFE-Modell und ihre Geltung auch für Änderungen innerhalb einer Firma stehen ausdrücklich im Text (`proposal/theory_note.tex`, Zeilen 370–377).
   - RD und Attrition werden entsprechend T024 beziehungsweise T025 zugeordnet. Die Notiz behauptet keine bereits nachgewiesenen empirischen Effekte.

3. **Eigenständige Übersetzung: belegt erfüllt anhand des vorhandenen Builds.** `review/T026_latex.txt`, Zeile 1, meldet erfolgreiche Übersetzung; das ausführliche Buildlog dokumentiert die PDF-Ausgabe. Keine undefinierten Verweise oder Zitate festgestellt.

4. **Keine Änderung anderer Dateien: nicht vollständig prüfbar.** Präambel, Bibliografie und Framework haben in Baseline und Freeze identische SHA-256-Einträge (`review/T026_baseline.sha256` und `review/T026_frozen.sha256`, jeweils Zeilen 1–3). Die darüber hinaus gemeldeten Änderungen lassen sich damit nicht vollständig dem T026-Worker oder anderen Sitzungen zuordnen. Änderungen an `main.tex` und dem Schlussgerüst sind als Co-PI-Arbeit dokumentiert (`state/STATE.md`, Zeile 47).

5. **Zusatzanforderungen zu Layout und Umfang:** teilweise erfüllt. Im vorhandenen LaTeX-Log stehen weder „Float too large“ noch „Overfull \hbox“. Die Grenze von sechs Haupttextseiten ist **nicht erfüllt**, siehe Befund 1.

## Nicht geprüft

- Mathematische Beweise, Schätzverfahren und Datenbereinigung: nicht meine Spezialrolle.
- Keine eigene Übersetzung, Schätzung oder sonstige Befehlsausführung; ausschließlich vorhandene Dateien gelesen.
- Keine vollständige Prüfung des übrigen Proposals außerhalb von T026.
- Urheberschaft und genaue Inhaltsänderungen sämtlicher gemeldeter Dateien außerhalb des Schreibbereichs; dafür fehlt ein vollständiger Vergleich mit zugeordneten Ausgangsständen.