## Rolle: data (codex, high) – VERDICT: ESCALATE


## Befunde

[firm-specific excerpt withheld in public audit]

2. **Die Firmenzahlen in der Timingdatei haben eine uneinheitliche Bedeutung.** `replication/outputs/tables/t031_timing.csv`, Zeile 7, berichtet für das lineare Basismodell bei Distanz 0,005 `n_pre = 148`, `n_post = 144`, aber `firms_pre = 15`, `firms_post = 21`. Die Beobachtungszahlen betreffen die gesamte Modellstichprobe; die Firmenzahlen stammen ausschließlich aus dem jeweiligen Distanzbin (`replication/code/12_q1_robustness.R:399–400`). Die vollständigen Periodenstichproben umfassen tatsächlich **54 beziehungsweise 56 Firmen**. Die CSV unterschätzt damit unter allgemein bezeichneten Spalten die Firmenstützung des linearen Modells. Gesamtstichprobe und lokale Binstützung sollten getrennte, eindeutig benannte Spalten erhalten. Dieser Mangel ist innerhalb der Karte behebbar.

## Abnahmekriterien

1. **T023 reproduziert; bestehende Outputs und zwei Läufe byteidentisch:**  
   Der **Tabellenabgleich ist belegt erfüllt**: `t031_baseline.csv`, Zeilen 2–3, stimmt mit `t023_excess_mass.csv`, Zeilen 2 und 17, einschließlich Fallzahlen und KI überein; post beträgt b = 3,1428547576. Der vorgeschaltete Assert steht in `12_q1_robustness.R:106–121`. Byteidentität ist im gespeicherten Hashmanifest dokumentiert, wurde von mir jedoch **nicht unabhängig nachgerechnet**. `state/STATE.md` hat laut Manifest, Zeile 209, nach Lauf 2 einen anderen Hash; die Paneldateien sind dort unverändert ausgewiesen.

2. **Jede Gitterzelle und Stichprobe berichtet; ausschließlich Baseline hervorgehoben:**  
   **Belegt erfüllt hinsichtlich Vollständigkeit der Datenaufbereitung**, mit dem Darstellungsfehler aus Befund 2:
   
   - **Firmenstützung:** `t031_support.csv` enthält pre 67 Beobachtungen/35 Firmen und post 118/43, maximal jeweils fünf Beobachtungen je Firma. Zwei Eintrittsdefinitionen sind getrennt ausgewiesen.
   - **Leave-one-out:** 115 berechtigte Firmen und 115 Ausgabezeilen. Die Berechtigung verwendet das geschlossene Intervall [0,60; 0,80] über alle 13 Stichtage (`12_q1_robustness.R:174–183`).
   - **Stichproben:** Alle drei Varianten und beide Perioden vorhanden. Unabhängiges Lesen der Panelzeilen bestätigt **136/115/124 Firmen** für A/B/C. Die Hauptstichprobe enthält 1.692 Zeilen; ein fehlender RL1-Wert führt pre von 798 auf 797 verfügbare Beobachtungen. Post sind es 630. Diese Zahlen stimmen mit `t004_panel_counts.csv` und `t031_samples.csv` überein.
   - **Gitter:** Alle 72 Kombinationen vorhanden; genau Spezifikation 33 ist als Baseline markiert. Tatsächliche Fenstergrenzen bei 0,02-Bins werden zusätzlich zu nominellen Grenzen ausgewiesen.
   - **Umkehrungen:** Die Aufbereitung verwendet ausschließlich den nächsten planmäßigen Firmenstichtag, ohne Lücken zu überbrücken (`12_q1_robustness.R:255–263`). Aus 149/181 möglichen Ursprungsbeobachtungen bleiben nach fehlendem Folgewert 148/144. RL1 = 0,60 wird eingeschlossen, RL1 = 0,70 ausgeschlossen; ein Folgewert genau 0,70 zählt nicht als Umkehrung. Distanz ist `0,70 − RL1`, in Quoteneinheiten.
   - **Timing:** Alle drei Ursprungsfenster und 24 Ergebniszeilen vorhanden. Der Folgestichtag darf außerhalb des Ursprungsfensters liegen; Ende 2022 ist rechtszensiert. Beides wird dokumentiert.

3. **Bericht beurteilt das Überstehen jedes Checks anhand der KI:**  
   **Nicht meine Rolle.** Die Bewertung der Schätzer, KI und Schlussfolgerungen gehört zum Estimation- beziehungsweise Consistency-Review.

Die T031-Aufbereitung liest nur das bestehende Hauptpanel, führt keine neuen Rohdatenmerges oder Imputationen ein und verwendet keine Erweiterungsbeobachtungen. Der Panel-Schlüssel ist eindeutig: 2.279 Zeilen, 184 Firmen, keine doppelten Firmen-Stichtage. Bestehende Imputationen für Vorauszahlungen und Perpetuals sind geflaggt und in `state/LIMITATIONS.md` dokumentiert. Der zusätzliche RL1-Konflikt aus Befund 1 bleibt offen.

## Nicht geprüft

- Keine Analyseskripte, Builds, Hashberechnungen oder Shellbefehle ausgeführt; keine Dateien geändert.
- Keine vollständige erneute Prüfung sämtlicher EastMoney-/Wind-Rohwerte und ursprünglicher Joins. Geprüft wurden deren relevante Codepfade, das eingefrorene Panel und die T031-Auswahlregeln.
- Die Berichtsoffenlegung wurde anhand des vorhandenen lokalen Seitentexts gelesen; die Übereinstimmung dieses Textauszugs mit dem PDF wurde nicht erneut geprüft. Eine verbindliche Reguliererdefinition zu Perpetuals wurde nicht festgestellt.
- Regressionen, Bootstrap-Inferenz, PDF-Gestaltung und Textinterpretation: nicht meine Rolle.
- Die gemeldeten Änderungen außerhalb des Schreibbereichs lassen sich anhand von Änderungszeiten keinem Verursacher zuordnen. Das Hashmanifest dokumentiert für die erfassten Daten und bestehenden Outputs gleiche Inhalte während beider Builds; eine vollständige historische Schreibbereichsprüfung ist damit nicht möglich.