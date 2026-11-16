## Rolle: data (codex, high) – VERDICT: ESCALATE


## Befunde

[firm-specific excerpt withheld in public process copy]

[number withheld]. **Die Firmenzahlen in der Timingdatei haben eine uneinheitliche Bedeutung.** `replication/outputs/tables/t031_timing.csv`, Zeile [number withheld], berichtet für das lineare Basismodell bei Distanz [number withheld] `n_pre = [number withheld]`, `n_post = [number withheld]`, aber `firms_pre = [number withheld]`, `firms_post = [number withheld]`. Die Beobachtungszahlen betreffen die gesamte Modellstichprobe; die Firmenzahlen stammen ausschließlich aus dem jeweiligen Distanzbin (`replication/code/12_q1_robustness.R:399–400`). Die vollständigen Periodenstichproben umfassen tatsächlich **[number withheld] beziehungsweise [number withheld] Firmen**. Die CSV unterschätzt damit unter allgemein bezeichneten Spalten die Firmenstützung des linearen Modells. Gesamtstichprobe und lokale Binstützung sollten getrennte, eindeutig benannte Spalten erhalten. Dieser Mangel ist innerhalb der Karte behebbar.

## Abnahmekriterien

[number withheld]. **T023 reproduziert; bestehende Outputs und zwei Läufe byteidentisch:**  
   Der **Tabellenabgleich ist belegt erfüllt**: `t031_baseline.csv`, Zeilen [number withheld]–[number withheld], stimmt mit `t023_excess_mass.csv`, Zeilen [number withheld] und [number withheld], einschließlich Fallzahlen und KI überein; post beträgt b = [number withheld]. Der vorgeschaltete Assert steht in `12_q1_robustness.R:106–121`. Byteidentität ist im gespeicherten Hashmanifest dokumentiert, wurde von mir jedoch **nicht unabhängig nachgerechnet**. `state/STATE.md` hat laut Manifest, Zeile [number withheld], nach Lauf [number withheld] einen anderen Hash; die Paneldateien sind dort unverändert ausgewiesen.

[number withheld]. **Jede Gitterzelle und Stichprobe berichtet; ausschließlich Baseline hervorgehoben:**  
   **Belegt erfüllt hinsichtlich Vollständigkeit der Datenaufbereitung**, mit dem Darstellungsfehler aus Befund [number withheld]:
   
   - **Firmenstützung:** `t031_support.csv` enthält pre [number withheld] Beobachtungen/[number withheld] Firmen und post [number withheld]/[number withheld], maximal jeweils fünf Beobachtungen je Firma. Zwei Eintrittsdefinitionen sind getrennt ausgewiesen.
   - **Leave-one-out:** [number withheld] berechtigte Firmen und [number withheld] Ausgabezeilen. Die Berechtigung verwendet das geschlossene Intervall [[number withheld]; [number withheld]] über alle [number withheld] Stichtage (`12_q1_robustness.R:174–183`).
   - **Stichproben:** Alle drei Varianten und beide Perioden vorhanden. Unabhängiges Lesen der Panelzeilen bestätigt **[number withheld]/[number withheld]/[number withheld] Firmen** für A/B/C. Die Hauptstichprobe enthält [number withheld] Zeilen; ein fehlender RL1-Wert führt pre von [number withheld] auf [number withheld] verfügbare Beobachtungen. Post sind es [number withheld]. Diese Zahlen stimmen mit `t004_panel_counts.csv` und `t031_samples.csv` überein.
   - **Gitter:** Alle [number withheld] Kombinationen vorhanden; genau Spezifikation [number withheld] ist als Baseline markiert. Tatsächliche Fenstergrenzen bei [number withheld]-Bins werden zusätzlich zu nominellen Grenzen ausgewiesen.
   - **Umkehrungen:** Die Aufbereitung verwendet ausschließlich den nächsten planmäßigen Firmenstichtag, ohne Lücken zu überbrücken (`12_q1_robustness.R:255–263`). Aus [number withheld]/[number withheld] möglichen Ursprungsbeobachtungen bleiben nach fehlendem Folgewert [number withheld]/[number withheld]. RL1 = [number withheld] wird eingeschlossen, RL1 = [number withheld] ausgeschlossen; ein Folgewert genau [number withheld] zählt nicht als Umkehrung. Distanz ist `[number withheld] − RL1`, in Quoteneinheiten.
   - **Timing:** Alle drei Ursprungsfenster und [number withheld] Ergebniszeilen vorhanden. Der Folgestichtag darf außerhalb des Ursprungsfensters liegen; Ende [number withheld] ist rechtszensiert. Beides wird dokumentiert.

[number withheld]. **Bericht beurteilt das Überstehen jedes Checks anhand der KI:**  
   **Nicht meine Rolle.** Die Bewertung der Schätzer, KI und Schlussfolgerungen gehört zum Estimation- beziehungsweise Consistency-Review.

Die T031-Aufbereitung liest nur das bestehende Hauptpanel, führt keine neuen Rohdatenmerges oder Imputationen ein und verwendet keine Erweiterungsbeobachtungen. Der Panel-Schlüssel ist eindeutig: [number withheld] Zeilen, [number withheld] Firmen, keine doppelten Firmen-Stichtage. Bestehende Imputationen für Vorauszahlungen und Perpetuals sind geflaggt und in `state/LIMITATIONS.md` dokumentiert. Der zusätzliche RL1-Konflikt aus Befund [number withheld] bleibt offen.

## Nicht geprüft

- Keine Analyseskripte, Builds, Hashberechnungen oder Shellbefehle ausgeführt; keine Dateien geändert.
- Keine vollständige erneute Prüfung sämtlicher EastMoney-/Wind-Rohwerte und ursprünglicher Joins. Geprüft wurden deren relevante Codepfade, das eingefrorene Panel und die T031-Auswahlregeln.
- Die Berichtsoffenlegung wurde anhand des vorhandenen lokalen Seitentexts gelesen; die Übereinstimmung dieses Textauszugs mit dem PDF wurde nicht erneut geprüft. Eine verbindliche Reguliererdefinition zu Perpetuals wurde nicht festgestellt.
- Regressionen, Bootstrap-Inferenz, PDF-Gestaltung und Textinterpretation: nicht meine Rolle.
- Die gemeldeten Änderungen außerhalb des Schreibbereichs lassen sich anhand von Änderungszeiten keinem Verursacher zuordnen. Das Hashmanifest dokumentiert für die erfassten Daten und bestehenden Outputs gleiche Inhalte während beider Builds; eine vollständige historische Schreibbereichsprüfung ist damit nicht möglich.