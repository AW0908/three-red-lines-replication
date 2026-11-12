## Rolle: consistency (codex, high) – VERDICT: REWORK


## Befunde

1. **Die vollständige T023-Tabelle passt nicht auf die Seite.** `proposal/appendix/results.tex:17` bindet drei Tabellenblöcke samt langer Note in einen einzigen, nicht umbrechbaren Float ein. Das neuere Buildprotokoll meldet eine Überschreitung der Seitenhöhe um **315,78389 pt** (`review/T036_build/main.log:1200`). Für T028 beträgt sie zusätzlich **8,5126 pt** (`:1294`, Einbindung in `proposal/appendix/results.tex:100`). Die erfolgreiche Übersetzung belegt deshalb keine vollständige Darstellung innerhalb des Satzspiegels. Die Einbindung muss angepasst werden, ohne die Outputwerte zu verändern.

2. **Die Compliance-Definition in den neuen Notes weicht am Schwellenwert von der Berechnung ab.** `proposal/sections/06_preliminary_analysis.tex:108` und `:115` definieren Compliance als RL1 „below 0.70“. Die ausgewiesenen Anteile verwenden hingegen **RL1 ≤ 0,70** (`replication/code/11_mechanism.R:149–150`); das entspricht auch der Verletzungsdefinition RL1 > 0,70 in `proposal/sections/04_empirical_model.tex:7`. Genau 0,70 wird somit unterschiedlich eingeordnet. Die Notes sollten „at or below 0.70“ verwenden. Ob tatsächlich Beobachtungen exakt auf der Grenze liegen, wurde nicht geprüft.

## Abnahmekriterien

1. **Jede Zahl stimmt mit den CSVs überein; mindestens 30 Zahlen prüfen — belegt erfüllt für die Ergebniszahlen in Abschnitt 6.** Werte, Vorzeichen, Rundungen und verwendete Spezifikationen wurden abgeglichen. Eine Auswahl von bereits 30 einzeln geprüften Werten:

   | Ergebnis | Textwert und Intervall | Beleg unter `replication/outputs/tables/` |
   |---|---|---|
   | Bunching post | 3,14 [1,01; 5,84] | `t023_excess_mass.csv:17` |
   | Bunching pre | −0,88 [−1,85; 0,43] | `t023_excess_mass.csv:2` |
   | Balanciertes Panel | 3,24 [1,02; 6,19] | `t031_samples.csv:5` |
   | Mindestabdeckung | 3,10 [0,93; 5,56] | `t031_samples.csv:7` |
   | Ohne 2020H2 | 3,54 [1,11; 6,76] | `t031_timing.csv:10` |
   | Nur 2020H2 | 1,74 [−0,67; 4,99] | `t031_timing.csv:18` |
   | Offizielles RL1, gepaarte Stichprobe | 3,18 [1,01; 6,01] | `t029_counterfactual_bunching.csv:3` |
   | Eingefrorene Minderheitsanteile | −0,52 [−1,83; 1,08] | `t029_counterfactual_bunching.csv:4` |
   | Bunching-Differenz | 3,71 [1,60; 6,14] | `t029_counterfactual_bunching.csv:5` |
   | Compliance-Differenz post minus Placebo, Prozentpunkte | 7,4 [3,1; 11,8] | `t029_compliance.csv:100` |

   Zusätzlich stimmen unter anderem die Zerlegungszahlen, Compliance-Anteile, DiD-Koeffizienten und Standardfehler, RD-Schätzer sowie IPW-Ergebnisse mit den jeweiligen CSVs überein. Die Differenzen 3,71 und 4,1 Prozentpunkte sind korrekt aus ungerundeten Werten berechnet.

   Sämtliche vorhandenen `.tex`-Tabellen und PDF-Abbildungen unter `proposal/tables/` beziehungsweise `proposal/figures/` sind bytegleich mit ihren Gegenstücken unter `replication/outputs/`. Die unveränderte Einbindung gewährleistet jedoch nicht die vollständige Darstellung; siehe Befund 1.

2. **Aussagen gemäß Schreibregeln und Vorbehalte aus STATE — belegt erfüllt hinsichtlich der Ergebnisinterpretation; Definitionskorrektur erforderlich.** Die zentrale Aussage steht in `proposal/sections/06_preliminary_analysis.tex:125` ausdrücklich als mechanischer Zusammenhang, ohne kausale Policy- oder Economic-Leverage-Aussage. Enthalten sind:

   - Part-B-Vortrend: `:125`, bestätigt durch `t029_distance_es.csv:4,8,12,16`.
   - 63 von 72 Spezifikationen mit Intervallen oberhalb null: `:35`, bestätigt durch `t031_grid.csv`.
   - Schwächerer Umkehrbefund ohne 2020H2 unter Distanzmodellen: `:62`, bestätigt durch `t031_timing.csv:12,15`.
   - Bedingter Vortrend bei kontrollierter DiD: `:146`, bestätigt durch `t028_pretrend_controls.csv:3`.

   Die verwendeten `\ref`- und `\eqref`-Ziele sind in der Build-`.aux` definiert; der Literaturkey `kleven2016bunching` existiert. Die Compliance-Notes bleiben gemäß Befund 2 inkonsistent.

3. **Kein unverifiziertes handerhobenes Material — belegt erfüllt.** Abschnitt 6.3 enthält ausschließlich Pilotdesign und Verifikationsstatus, keine Firmenfälle oder Transaktionszahlen (`proposal/sections/06_preliminary_analysis.tex:127–134`). Der verlangte `% TODO(PI)` ist vorhanden. `transactions.csv` und `case_notes.md` existieren am angegebenen Ort nicht.

4. **Wortbudget und fehlerfreie Übersetzung — teilweise belegt erfüllt.** Die drei Abbildungen und zwei kompakten Haupttexttabellen sind vorhanden. Die abschließende verbindliche Wortzählung ist **nicht meine Rolle**; orientierend ergeben sich rund 1.600 Wörter Fließtext ohne Floats.

   Die Übersetzung ist durch das neuere Protokoll belegt: `review/T036_build/main.log:1361–1362` meldet ein erzeugtes PDF mit 72 Seiten. `review/T036_latex.txt` dokumentiert einen früheren, inzwischen überholten Abbruch wegen fehlender Grafik. Die verbleibenden Größenwarnungen sind in Befund 1 aufgeführt.

## Nicht geprüft

- Datenbereinigung, Schätzcode und Identifikation wurden nicht auf methodische Richtigkeit geprüft; geprüft wurde ihre Übereinstimmung mit Text und Outputs. Keine Analyseskripte oder Shell-Befehle ausgeführt, keine Dateien geändert.
- Keine visuelle Seitenprüfung des erzeugten PDFs. Die Layoutbefunde beruhen auf Einbindung und vorhandenem Buildprotokoll.
- Die drei eingefrorenen Dateien stimmen mit `review/T036_frozen.sha256` überein. `state/STATE.md` weicht weiterhin vom Baseline-Hash ab. Der frühere Inhalt und die Urheberschaft der gemeldeten Änderungen außerhalb des Schreibbereichs lassen sich daraus nicht rekonstruieren. Die Outputkopien sind in der Karte ausdrücklich vorgesehen; weitere Änderungen wurden dem Worker nicht ohne Beleg zugerechnet.
- Sprachprüfung und spätere Integration der noch ausstehenden Schreibkarten sind nicht meine Rolle. Insbesondere verweist die κ-Diskussion derzeit auf Abschnitt 3, der überwiegend aus auskommentierten Entwurfsanweisungen besteht.
- `AI_USAGE_LOG.md` enthält keinen T036-Eintrag. Vorgeschlagener Nachtrag durch Co-PI/PI: „T036: Neufassung von Abschnitt 6 und Ergebnisanhang; unabhängiger Text-Output-Abgleich; REWORK wegen Tabellenüberhöhe und Compliance-Grenzdefinition.“