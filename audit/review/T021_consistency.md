## Rolle: consistency (codex, high) – VERDICT: PASS


## Befunde

1. Keine inhaltlichen Abweichungen zwischen dem geprüften Text und den zugehörigen Outputs gefunden. Werte, Rundungen, Vorzeichen, Standardfehler, Konfidenzintervalle und Fallzahlen in `proposal/sections/06_preliminary_analysis.tex:20–91` stimmen mit den genannten CSV-Dateien überein. Insbesondere ist die JV-Stichprobe jetzt korrekt beschrieben: 1.545 − 317 fehlende Outcomes − 3 Singletons = 1.225 Beobachtungen (`t009_did_main.csv:6`; Abschnitt 6, Zeile 35). Die Abgrenzung zur Hauptstichprobe entspricht Abschnitt 5, Zeilen 31–32.

2. Alle drei eingebundenen Tabellen und neun Abbildungen sind bytegleich mit ihren Gegenstücken unter `replication/outputs/`. Die Tabellenzahlen stimmen mit den CSV-Fassungen überein; der vollständige Abgleich der Robustheitstabelle ergibt keine Abweichungen. Die Abbildungsnotizen beschreiben die verwendeten Zeitfenster, Referenzperiode, Spezifikationen und Konfidenzintervalle zutreffend. Die Eigentümerabbildung verwendet Split-Schätzungen; der Text kennzeichnet ausdrücklich die gleichen Punktschätzer des Interaktionsmodells und verwechselt die Spezifikationen nicht (`06_preliminary_analysis.tex:81–91`).

## Abnahmekriterien

1. **Übersetzung und Verweise: belegt erfüllt.** `review/T021_latex.txt:1` meldet eine fehlerfreie Übersetzung. Alle in Abschnitt 6 und im Ergebnisanhang verwendeten Verweisziele existieren, einschließlich der durch Einbindungsmakros erzeugten Labels. Die verwendeten Literaturkeys sind in `proposal/references.bib` vorhanden.

2. **Vollständige Zahl→Quelle-Liste: belegt erfüllt.** `tasks/T021_report.md:16–25` dokumentiert die Zahlen aus Abschnitt 6 sowie Zeitfenster, Binbreiten, Referenzdatum und Konfidenzniveau der Abbildungsnotizen. Die Ergebniszahlen sind anhand der genannten Outputs nachvollziehbar. Zeitfenster und Konfidenzniveau entsprechen zusätzlich den Definitionen in `replication/code/03_figures.R:28–30` und `02_estimate.R:18,107`.

3. **Platzierung: belegt erfüllt.** Abschnitt 6 enthält genau RL1-Bunching, Haupt-DiD-Tabelle, dreiteilige Event-Study-Abbildung und Eigentümerabbildung. `proposal/appendix/results.tex:7–23` enthält Robustheits- und SOE-Tabelle, RL2-/RL3-Bunching sowie die Event Studies für rl2_gap und jv_ta. Der Anhang ist an der vorgeschriebenen Stelle eingebunden (`proposal/main.tex:85–87`).

4. **Signifikanz und H4: belegt erfüllt.** Die Hauptschätzungen werden korrekt als auf dem 5-%-Niveau nicht signifikant bezeichnet. Die Robustheitsaussagen entsprechen den jeweiligen Ergebnis- und Vortrend-p-Werten. Die SOE-Konfidenzintervalle schließen für RL1/RL2 null aus; sämtliche SOE–Privat-Differenzen schließen null ein. H4 bleibt ausdrücklich ohne Vorzeichen (`06_preliminary_analysis.tex:35,65–73,88`).

5. **Längenschätzung: belegt erfüllt.** Der Bericht nennt rund fünf Seiten einschließlich Floats (`tasks/T021_report.md:29`). Die Überschreitung des ursprünglichen Richtwerts ist gemäß Kartenfeedback vorerst akzeptiert; die Kürzung ist zurückgestellt (`tasks/T021.md:77`).

## Nicht geprüft

- Datenaufbereitung, Schätzverfahren und Identifikationsgültigkeit: nicht meine Rolle.
- Eigener LaTeX-Lauf, visuelle PDF-Prüfung und tatsächliche Seitenzahl: keine Befehle ausgeführt.
- Originalpublikationen hinter den Literaturangaben: nur projektinterne Zuordnung und vorhandene BibTeX-Keys geprüft.
- Urheberschaft der gemeldeten Änderungen außerhalb des Schreibbereichs und historische Änderungen an `state/STATE.md`: aus Änderungszeiten beziehungsweise der Prüfsummenwarnung nicht feststellbar. Die neun Dateien des eingefrorenen Manifests stimmen aktuell mit ihren SHA-256-Prüfsummen überein. Das Konsistenzurteil ersetzt keine Klärung dieser Prozesshinweise.