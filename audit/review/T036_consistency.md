## Rolle: consistency (codex, high) – VERDICT: REWORK


## Befunde

[number withheld]. **Die vollständige T023-Tabelle passt nicht auf die Seite.** `proposal/appendix/results.tex:17` bindet drei Tabellenblöcke samt langer Note in einen einzigen, nicht umbrechbaren Float ein. Das neuere Buildprotokoll meldet eine Überschreitung der Seitenhöhe um **[number withheld] pt** (`review/T036_build/main.log:1200`). Für T028 beträgt sie zusätzlich **[number withheld] pt** (`:[number withheld]`, Einbindung in `proposal/appendix/results.tex:100`). Die erfolgreiche Übersetzung belegt deshalb keine vollständige Darstellung innerhalb des Satzspiegels. Die Einbindung muss angepasst werden, ohne die Outputwerte zu verändern.

[number withheld]. **Die Compliance-Definition in den neuen Notes weicht am Schwellenwert von der Berechnung ab.** `proposal/sections/06_preliminary_analysis.tex:108` und `:[number withheld]` definieren Compliance als RL1 „below [number withheld]“. Die ausgewiesenen Anteile verwenden hingegen **RL1 ≤ [number withheld]** (`replication/code/11_mechanism.R:149–150`); das entspricht auch der Verletzungsdefinition RL1 > [number withheld] in `proposal/sections/04_empirical_model.tex:7`. Genau [number withheld] wird somit unterschiedlich eingeordnet. Die Notes sollten „at or below [number withheld]“ verwenden. Ob tatsächlich Beobachtungen exakt auf der Grenze liegen, wurde nicht geprüft.

## Abnahmekriterien

[number withheld]. **Jede Zahl stimmt mit den CSVs überein; mindestens [number withheld] Zahlen prüfen — belegt erfüllt für die Ergebniszahlen in Abschnitt [number withheld].** Werte, Vorzeichen, Rundungen und verwendete Spezifikationen wurden abgeglichen. Eine Auswahl von bereits [number withheld] einzeln geprüften Werten:

   | Ergebnis | Textwert und Intervall | Beleg unter `replication/outputs/tables/` |
   |---|---|---|
   | Bunching post | [number withheld] [[number withheld]; [number withheld]] | `t023_excess_mass.csv:17` |
   | Bunching pre | [number withheld] [[number withheld]; [number withheld]] | `t023_excess_mass.csv:2` |
   | Balanciertes Panel | [number withheld] [[number withheld]; [number withheld]] | `t031_samples.csv:5` |
   | Mindestabdeckung | [number withheld] [[number withheld]; [number withheld]] | `t031_samples.csv:7` |
   | Ohne [number withheld]H2 | [number withheld] [[number withheld]; [number withheld]] | `t031_timing.csv:10` |
   | Nur [number withheld]H2 | [number withheld] [[number withheld]; [number withheld]] | `t031_timing.csv:18` |
   | Offizielles RL1, gepaarte Stichprobe | [number withheld] [[number withheld]; [number withheld]] | `t029_counterfactual_bunching.csv:3` |
   | Eingefrorene Minderheitsanteile | [number withheld] [[number withheld]; [number withheld]] | `t029_counterfactual_bunching.csv:4` |
   | Bunching-Differenz | [number withheld] [[number withheld]; [number withheld]] | `t029_counterfactual_bunching.csv:5` |
   | Compliance-Differenz post minus Placebo, Prozentpunkte | [number withheld] [[number withheld]; [number withheld]] | `t029_compliance.csv:100` |

   Zusätzlich stimmen unter anderem die Zerlegungszahlen, Compliance-Anteile, DiD-Koeffizienten und Standardfehler, RD-Schätzer sowie IPW-Ergebnisse mit den jeweiligen CSVs überein. Die Differenzen [number withheld] und [number withheld] Prozentpunkte sind korrekt aus ungerundeten Werten berechnet.

   Sämtliche vorhandenen `.tex`-Tabellen und PDF-Abbildungen unter `proposal/tables/` beziehungsweise `proposal/figures/` sind bytegleich mit ihren Gegenstücken unter `replication/outputs/`. Die unveränderte Einbindung gewährleistet jedoch nicht die vollständige Darstellung; siehe Befund [number withheld].

[number withheld]. **Aussagen gemäß Schreibregeln und Vorbehalte aus STATE — belegt erfüllt hinsichtlich der Ergebnisinterpretation; Definitionskorrektur erforderlich.** Die zentrale Aussage steht in `proposal/sections/06_preliminary_analysis.tex:125` ausdrücklich als mechanischer Zusammenhang, ohne kausale Policy- oder Economic-Leverage-Aussage. Enthalten sind:

   - Part-B-Vortrend: `:[number withheld]`, bestätigt durch `t0[number withheld]_distance_es.csv:[number withheld]`.
   - [number withheld] von [number withheld] Spezifikationen mit Intervallen oberhalb null: `:[number withheld]`, bestätigt durch `t031_grid.csv`.
   - Schwächerer Umkehrbefund ohne [number withheld]H2 unter Distanzmodellen: `:[number withheld]`, bestätigt durch `t0[number withheld]_timing.csv:[number withheld]`.
   - Bedingter Vortrend bei kontrollierter DiD: `:[number withheld]`, bestätigt durch `t028_pretrend_controls.csv:3`.

   Die verwendeten `\ref`- und `\eqref`-Ziele sind in der Build-`.aux` definiert; der Literaturkey `kleven2[number withheld]bunching` existiert. Die Compliance-Notes bleiben gemäß Befund [number withheld] inkonsistent.

[number withheld]. **Kein unverifiziertes handerhobenes Material — belegt erfüllt.** Abschnitt [number withheld] enthält ausschließlich Pilotdesign und Verifikationsstatus, keine Firmenfälle oder Transaktionszahlen (`proposal/sections/06_preliminary_analysis.tex:127–134`). Der verlangte `% TODO(PI)` ist vorhanden. `transactions.csv` und `case_notes.md` existieren am angegebenen Ort nicht.

[number withheld]. **Wortbudget und fehlerfreie Übersetzung — teilweise belegt erfüllt.** Die drei Abbildungen und zwei kompakten Haupttexttabellen sind vorhanden. Die abschließende verbindliche Wortzählung ist **nicht meine Rolle**; orientierend ergeben sich rund [number withheld] Wörter Fließtext ohne Floats.

   Die Übersetzung ist durch das neuere Protokoll belegt: `review/T036_build/main.log:1361–1362` meldet ein erzeugtes PDF mit [number withheld] Seiten. `review/T036_latex.txt` dokumentiert einen früheren, inzwischen überholten Abbruch wegen fehlender Grafik. Die verbleibenden Größenwarnungen sind in Befund [number withheld] aufgeführt.

## Nicht geprüft

- Datenbereinigung, Schätzcode und Identifikation wurden nicht auf methodische Richtigkeit geprüft; geprüft wurde ihre Übereinstimmung mit Text und Outputs. Keine Analyseskripte oder Shell-Befehle ausgeführt, keine Dateien geändert.
- Keine visuelle Seitenprüfung des erzeugten PDFs. Die Layoutbefunde beruhen auf Einbindung und vorhandenem Buildprotokoll.
- Die drei eingefrorenen Dateien stimmen mit `review/T036_frozen.sha256` überein. `state/STATE.md` weicht weiterhin vom Baseline-Hash ab. Der frühere Inhalt und die Urheberschaft der gemeldeten Änderungen außerhalb des Schreibbereichs lassen sich daraus nicht rekonstruieren. Die Outputkopien sind in der Karte ausdrücklich vorgesehen; weitere Änderungen wurden dem Worker nicht ohne Beleg zugerechnet.
- Sprachprüfung und spätere Integration der noch ausstehenden Schreibkarten sind nicht meine Rolle. Insbesondere verweist die κ-Diskussion derzeit auf Abschnitt [number withheld], der überwiegend aus auskommentierten Entwurfsanweisungen besteht.
- `AI_USAGE_LOG.md` enthält keinen T036-Eintrag. Vorgeschlagener Nachtrag durch Co-PI/PI: „T036: Neufassung von Abschnitt [number withheld] und Ergebnisanhang; unabhängiger Text-Output-Abgleich; REWORK wegen Tabellenüberhöhe und Compliance-Grenzdefinition.“