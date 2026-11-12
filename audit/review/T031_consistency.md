## Rolle: consistency (codex, high) – VERDICT: REWORK


## Befunde

1. **Die Timing-CSV verwendet uneinheitliche Bezugsgrößen für Beobachtungs- und Firmenzahlen.** In `replication/outputs/tables/t031_timing.csv`, Zeilen 4–9, beziehen sich `n_pre/n_post = 148/144` auf die gesamte Regressionsstichprobe. `firms_pre/firms_post` enthalten dagegen Firmenzahlen des jeweiligen Distanzbins: beispielsweise 15/21 bei Distanz 0,005 und 12/17 bei 0,025. Das betrifft auch das lineare Modell, dessen Schätzstichprobe zwischen diesen Vorhersagen gleich bleibt. Beleg: `replication/code/12_q1_robustness.R`, Zeilen 398–400, übernimmt ausdrücklich `bin_firms_pre/post`; in `t031_reversal_distance.csv` heißen diese Angaben entsprechend eindeutig. Die Timing-Tabelle erläutert den Bedeutungswechsel nicht. Dadurch können lokale Bin-Fallzahlen als Firmenzahl der gesamten Schätzung gelesen werden. **Korrektur:** Gesamtfirmenzahlen und Bin-Unterstützung getrennt ausweisen und eindeutig benennen. Die geprüften Punktschätzungen und Konfidenzintervalle sind davon nicht betroffen.

## Abnahmekriterien

1. **T023-Reproduktion: hinsichtlich Output-Übereinstimmung belegt erfüllt.** `t031_baseline.csv` stimmt für beide Perioden bei b, SE, KI und Fallzahlen mit den entsprechenden Hauptzeilen von `t023_excess_mass.csv` überein. Post: b = 3,142854758, KI [1,012201362; 5,841138274]. Der Assert steht in `12_q1_robustness.R`, Zeilen 106–121. Tatsächliche Ausführung und Byteidentität: **nicht meine Rolle**; die gespeicherten Logs und das Hashmanifest dokumentieren diese Prüfungen, wurden hier aber nicht durch Neuausführung bestätigt.

2. **Vollständige Ergebnisdarstellung belegt erfüllt; konsistente Fallzahlbeschriftung nicht erfüllt.** Vorhanden sind alle 72 Gitterzellen mit fortlaufenden Indizes, genau eine markierte Baseline (Index 33), alle drei Stichproben für beide Perioden sowie 115 Firmenauslassungen. Die drei TeX-Tabellen stimmen bei dargestellten Werten, Vorzeichen und Rundungen mit ihren CSV-Fassungen überein. Einschränkung: Befund 1 zur Timing-CSV. Methodische Angemessenheit der Spezifikationen: **nicht meine Rolle**.

3. **Die Interpretation der Robustheitschecks ist durch die Outputs belegt erfüllt.**
   - Firmenstützung: post 118 Firmenstichtage, 43 Firmen, maximal fünf Beiträge je Firma; 24 Firmen zuvor nicht im Fenster (`t031_support.csv`).
   - Alle 115 Leave-one-out-KIs liegen oberhalb null; b liegt zwischen 2,840191 und 3,309627 (`t031_leave_one_out.csv`).
   - Beide eingeschränkten Stichproben behalten positive Post-KIs (`t031_samples.csv/.tex`).
   - 63/72 Gitter-KIs schließen null aus; neun enthalten null (`t031_grid.csv`).
   - Im Bin-Modell schließen die Differenz-KIs bei 0,005 und 0,015 null aus, bei 0,025 nicht; linear schließen alle drei null aus (`t031_reversal_distance.csv/.tex`).
   - Ohne 2020H2 bleibt das Bunching-KI positiv; für 2020H2 allein enthält es null. Ohne 2020H2 enthalten außerdem die drei angeforderten Bin-Distanzkontraste null (`t031_timing.csv/.tex`).

## Nicht geprüft

- Keine Schätzung, kein Build und keine Projektbefehle ausgeführt; keine Dateien geändert.
- Datenintegrität, Schätzerkorrektheit und Zuordnung der gemeldeten Änderungen außerhalb des Schreibbereichs: nicht meine Rolle. Die gemeldete Änderung von `state/STATE.md` wurde nicht unabhängig zeitlich rekonstruiert.
- PDF-Layout und grafische Koordinaten nicht visuell geprüft: Preview-Zugriff war nicht freigegeben. PDF-Beschriftungen wurden textuell gelesen.
- T031 ist im gelesenen Proposal-Text noch nicht eingebunden. Einbau und Kopien im Paper waren daher für diese Karte nicht prüfbar; `proposal/` gehört nicht zu ihrem Schreibbereich. Historische Ergebnisse anderer Karten wurden nicht vollständig erneut geprüft.