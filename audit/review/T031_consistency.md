## Rolle: consistency (codex, high) – VERDICT: REWORK


## Befunde

[number withheld]. **Die Timing-CSV verwendet uneinheitliche Bezugsgrößen für Beobachtungs- und Firmenzahlen.** In `replication/outputs/tables/t031_timing.csv`, Zeilen [number withheld]–[number withheld], beziehen sich `n_pre/n_post = [number withheld]/[number withheld]` auf die gesamte Regressionsstichprobe. `firms_pre/firms_post` enthalten dagegen Firmenzahlen des jeweiligen Distanzbins: beispielsweise [number withheld]/[number withheld] bei Distanz [number withheld] und [number withheld]/[number withheld] bei [number withheld]. Das betrifft auch das lineare Modell, dessen Schätzstichprobe zwischen diesen Vorhersagen gleich bleibt. Beleg: `replication/code/12_q1_robustness.R`, Zeilen [number withheld]–[number withheld], übernimmt ausdrücklich `bin_firms_pre/post`; in `t031_reversal_distance.csv` heißen diese Angaben entsprechend eindeutig. Die Timing-Tabelle erläutert den Bedeutungswechsel nicht. Dadurch können lokale Bin-Fallzahlen als Firmenzahl der gesamten Schätzung gelesen werden. **Korrektur:** Gesamtfirmenzahlen und Bin-Unterstützung getrennt ausweisen und eindeutig benennen. Die geprüften Punktschätzungen und Konfidenzintervalle sind davon nicht betroffen.

## Abnahmekriterien

[number withheld]. **T023-Reproduktion: hinsichtlich Output-Übereinstimmung belegt erfüllt.** `t031_baseline.csv` stimmt für beide Perioden bei b, SE, KI und Fallzahlen mit den entsprechenden Hauptzeilen von `t023_excess_mass.csv` überein. Post: b = [number withheld], KI [[number withheld]; [number withheld]]. Der Assert steht in `12_q1_robustness.R`, Zeilen [number withheld]–[number withheld]. Tatsächliche Ausführung und Byteidentität: **nicht meine Rolle**; die gespeicherten Logs und das Hashmanifest dokumentieren diese Prüfungen, wurden hier aber nicht durch Neuausführung bestätigt.

[number withheld]. **Vollständige Ergebnisdarstellung belegt erfüllt; konsistente Fallzahlbeschriftung nicht erfüllt.** Vorhanden sind alle [number withheld] Gitterzellen mit fortlaufenden Indizes, genau eine markierte Baseline (Index [number withheld]), alle drei Stichproben für beide Perioden sowie [number withheld] Firmenauslassungen. Die drei TeX-Tabellen stimmen bei dargestellten Werten, Vorzeichen und Rundungen mit ihren CSV-Fassungen überein. Einschränkung: Befund [number withheld] zur Timing-CSV. Methodische Angemessenheit der Spezifikationen: **nicht meine Rolle**.

[number withheld]. **Die Interpretation der Robustheitschecks ist durch die Outputs belegt erfüllt.**
   - Firmenstützung: post [number withheld] Firmenstichtage, [number withheld] Firmen, maximal fünf Beiträge je Firma; [number withheld] Firmen zuvor nicht im Fenster (`t031_support.csv`).
   - Alle [number withheld] Leave-one-out-KIs liegen oberhalb null; b liegt zwischen [number withheld] und [number withheld] (`t031_leave_one_out.csv`).
   - Beide eingeschränkten Stichproben behalten positive Post-KIs (`t031_samples.csv/.tex`).
   - [number withheld]/[number withheld] Gitter-KIs schließen null aus; neun enthalten null (`t031_grid.csv`).
   - Im Bin-Modell schließen die Differenz-KIs bei [number withheld] und [number withheld] null aus, bei [number withheld] nicht; linear schließen alle drei null aus (`t031_reversal_distance.csv/.tex`).
   - Ohne [number withheld]H2 bleibt das Bunching-KI positiv; für [number withheld]H2 allein enthält es null. Ohne [number withheld]H2 enthalten außerdem die drei angeforderten Bin-Distanzkontraste null (`t031_timing.csv/.tex`).

## Nicht geprüft

- Keine Schätzung, kein Build und keine Projektbefehle ausgeführt; keine Dateien geändert.
- Datenintegrität, Schätzerkorrektheit und Zuordnung der gemeldeten Änderungen außerhalb des Schreibbereichs: nicht meine Rolle. Die gemeldete Änderung von `state/STATE.md` wurde nicht unabhängig zeitlich rekonstruiert.
- PDF-Layout und grafische Koordinaten nicht visuell geprüft: Preview-Zugriff war nicht freigegeben. PDF-Beschriftungen wurden textuell gelesen.
- T031 ist im gelesenen Proposal-Text noch nicht eingebunden. Einbau und Kopien im Paper waren daher für diese Karte nicht prüfbar; `proposal/` gehört nicht zu ihrem Schreibbereich. Historische Ergebnisse anderer Karten wurden nicht vollständig erneut geprüft.