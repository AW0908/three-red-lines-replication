## Rolle: estimation (claude, opus) – VERDICT: PASS


## Befunde

Ich habe keine Mängel gefunden, die die Schätzungen betreffen. Die sechs Rework-Punkte der Karte sind im Code und in den Outputs umgesetzt (alles in `20_referee4.R`):

1. **Schritt 6 (Masse oberhalb 0,70), behoben.** `sp$exclusion_upper <- upper` (Z. 345). Damit fällt [0,66; upper) vollständig aus dem Polynomfit (`mass_est`, Z. 55, 63–65). Unterhalb, oberhalb und gesamt kommen aus derselben Spezifikation `sp` (Z. 346, 353). Für jede Region und Periode wird der Fit neu gerechnet, mit identischer Ausschlussmenge, also auch mit identischem Kontrafaktum. Die Fensterzählungen in `t058_above.tex` passen zusammen: 67+110=177, 67+255=322, 118+91=209, 118+195=313. Die alten In-Sample-Zeilen sind entfernt, und die Tabellennotiz sagt das. Die Normalisierung erfolgt je Region („b need not add“) und ist offengelegt. Kleiner Schönheitsfehler ohne Wirkung: `small_cell` stützt sich in diesen Zeilen auf die Firmen in [0,66; 0,70), nicht auf die bewertete Region (`record`, Z. 140). Alle Regionen haben aber ≥ 35 Firmen, deshalb ändert sich kein Flag.
2. **Schritt 1 (Seazen), behoben.** `control <- !d$firm_id %in% union(ids0, ids_s)` (Z. 189) schließt in jeder Variante beide Seazen-Einheiten aus den Kontrollen aus. Die Kontroll-N sinken von 731/575 auf 725/570, die Firmen von 125/121 auf 124/120 (`t058_pilot.tex`, Z. 10–12, 37–39). Die Pilot-Punktschätzungen bleiben gleich. Das B-Flag wird über Nullmassen-Ziehungen bestimmt (`abs(z+4)<1e-10`, Z. 486). Das ist richtig, weil bei 4 Massen-Bins und obs=0 genau b = (0−cf)/(cf/4) = −4 herauskommt. Die Notiz erklärt die konstruktionsbedingte Grenze.
3. **Schritt 3 (symmetrische Tests), behoben.** Die Kontraste `a$norm − b$norm` und `vv$post − vv$placebo` laufen über dieselbe Matrix `W` (Z. 431–449). Nachgerechnet aus `t058_symmetric.csv`: 17,038−6,993=10,045; 2,960−1,651=1,309; 10,045−1,309=8,737; 17,038−4,072=12,966; 2,960−1,584=1,375; 12,966−1,375=11,591. Alle Zeilen haben 999/999 gültige Ziehungen (Z. 58–63).
4. **Schritt 7 (Grid), behoben.** `window_obs/firms_*` zählen jetzt das tatsächliche Ausschlussfenster (Z. 369–373). Beispiel Spezifikation 1: 52/101 bei Fenster [0,67; 0,70), identisch mit `mass_obs`. Die TEX-Tabelle zeigt `min_001/median_001/max_001`. Die Umrechnung b·bw/0,01 stimmt: Bei halber Binbreite halbiert sich der mittlere kontrafaktische Bin-Inhalt, und b verdoppelt sich. Die Notiz beschreibt die variierten Dimensionen.
5. **Schritt 4 (Attrition), behoben.** `window_obs/window_firms/small_cell` beziehen sich in den `bin_share`-Zeilen auf den jeweiligen Bin (Z. 295–297). Die Zählungen summieren sich zu 10 austretenden und 120 fortbestehenden Firmen.
[firm-specific excerpt withheld in public audit]

Weiterhin korrekt (unverändert seit der ersten Prüfung): Schätzer nach T023-Konvention, Reproduktions-Asserts (Z. 86–90), gemeinsamer Firmen-Bootstrap mit Neuschätzung je Ziehung. Neue Zeilen werden angehängt (IDs 255 ff.), ohne zusätzliche Zufallsziehungen nach dem Aufbau von `W`. Die ursprünglichen Zeilen und Ziehungen bleiben deshalb reproduzierbar.

## Abnahmekriterien

1. **Reproduktion, alte Outputs byte-identisch, zwei Läufe byte-identisch:** Laut Code belegt (Asserts Z. 86–90; Hash-Gates Z. 637; Wiederholungsprüfung Z. 641–647). `t058_attrition.tex` Z. 7–9 zeigt −0,877 / 3,143 / 4,020. Die Läufe selbst sind nicht nachvollziehbar (siehe unten).
2. **Varianten mit N, Firmen und Fensterfirmen, kleine Zellen markiert:** Für die Schätzzeilen belegt erfüllt. Die Variante aus Schritt 6 mit echtem Kontrafaktum ist jetzt vorhanden. Die Grid- und Attrition-Fensterzählungen sind korrigiert.
3. **Pilotliste wie in `state/pilot_developers.csv`:** Die IDs werden unverändert eingelesen (Z. 175–181). Der Ausschluss der Zwillingseinheit entspricht Rework-Punkt 2. Datenintegrität im Übrigen: nicht meine Rolle.

## Nicht geprüft

- Bash war gesperrt. Ich habe deshalb die Byte-Identität zweier Läufe, die Hashes in `t058_verification.csv` und die Bootstrap-Perzentile nicht selbst nachgerechnet. Geprüft habe ich Code, TEX/CSV-Ausgaben und Punktschätzungen von Hand.
- Die Debt-Normalisierung, post, hat eine obere KI-Grenze von genau 0,000 bei 998/999 gültigen Ziehungen (`t058_symmetric.csv` Z. 22). Das ist kein Rework-Punkt und war schon in der Vorrunde so; die Ursache (Ziehungen mit D = 0) habe ich nicht verifiziert.
- Die Änderungen unter `proposal/` außerhalb des Schreibbereichs, `AI_USAGE_LOG.md`, die Datenaufbereitung und die Sprache sind nicht meine Rolle. Die Änderungen unter `proposal/` stammen vermutlich aus einer parallelen Sitzung (T059). Das sollten die Rollen data/consistency bzw. der Co-PI klären.
