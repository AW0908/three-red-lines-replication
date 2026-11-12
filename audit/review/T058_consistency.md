## Rolle: consistency (claude, sonnet) – VERDICT: PASS


## Befunde

Keine inhaltlichen Inkonsistenzen zwischen Schätzung, Output und Text gefunden. Hinweise ohne Urteilsrelevanz, schwerster zuerst:

1. **Delta-b-Zeilen der Pilotgruppe ohne B-Flag** (`t058_pilot.tex`, Zeilen 9, 36, 63): Die Zellen b pre und b post tragen „SB“, die zugehörige Δb-Zeile nur „S“. Ihr Intervall [−6.366, 10.589] speist sich aus denselben Bootstrap-Ziehungen. Ob einzelne Ziehungen ohne Fenstermasse eingehen, habe ich nicht geprüft. Die Notiz nennt nur b-Zellen. Der Befund ist für die Lesart harmlos, weil „S“ die Zelle ohnehin als deskriptiv markiert.
2. **Fallzahl pre bei Hongkong:** Die TeX-Notiz in `t058_standard.tex` nennt 318 Hongkong-Zeilen pre, die Tabelle zeigt N = 317 für b pre (`t058_standard.tex`, Zeile 47). Die Notiz zählt alle Hauptstichprobenzeilen, die Tabelle nur Zeilen mit endlichem RL1. Das ist plausibel, aber nicht ausdrücklich gesagt.
3. **Perimeter:** Der Bericht listet 30 Ausgabedateien. Davon sind `t058_grid.pdf` und `t058_attrition.pdf` hier nicht als eingefroren geführt. Ich habe sie nicht geprüft.

## Abnahmekriterien

Meine Rolle betrifft Übereinstimmung von Zahlen, Text und Outputs.

1. **Reproduktionsasserts** (b_post 3.14, b_pre −0.88, Δb 4.02, D 0.1146, 602 Paare, 129 Firmen): belegt in `t058_reproduction.csv`, alle sechs Zeilen `assert_pass = TRUE`. Dieselben Werte stehen in `t058_window.csv`, `t058_attrition.tex` (4.020) und der Grid-Basiszeile (Spezifikation 33, Δb = 4.02004).
   - Byte-Identität und Zwei-Läufe-Identität: nicht meine Rolle. Das prüft das Skript per SHA-256 (`t058_verification.csv`).
2. **Alle Varianten mit N, Firmen und Fensterfirmen, kleine Zellen markiert:** belegt in den TeX-Tabellen. Jede Zeile hat N, Firmen, „Window N (firms)“ und die Spalte S.
   - Rework-Punkt 1 (Masse oberhalb): zwölf Zeilen in `t058_above.csv/.tex`. Alle Werte und Intervalle stimmen mit der Berichtstabelle und der Interpretation überein.
   - Rework-Punkt 2 (Seazen): Kontroll-N pre/post 725/570 und Firmen 124/120 in allen drei Varianten identisch. Pilot-Δb 2.452 minus 3.984 ergibt −1.531 (Rundung). Seazen A-Share: 2.806 − 3.984 = −1.178. Die 368/999 Nullmassen-Ziehungen am 2020-12-31 stehen in `t058_pilot.csv`.
   - Rework-Punkt 3 (symmetrische Tests): Die Kontraste folgen aus den normalisierten D-Werten.
     - MI − Mutter-EK: 17.038 − 6.993 = 10.045 (post), 2.960 − 1.651 = 1.309 (Placebo), Differenz 8.737.
     - MI − gemeinsames Einfrieren: 12.966 (post), 1.375 (Placebo), Differenz 11.591.
     - Die Normalisierung stimmt: 100 · 0.1146 / 0.673 = 17.03.
   - Rework-Punkt 4 (Grid): 72/72 positiv. Die Summe der Zähler nach Dimension ergibt jeweils 69/72 mit Intervall über null. Die Min/Median/Max-Werte der TeX-Tabelle (2.316 / 3.921 / 6.300) stimmen mit dem Bericht überein. Die Reskalierung ist konsistent: 12.55 nativ bei Breite 0.005 wird 6.28. Die Zählungen im Ausschlussfenster stimmen mit dem Bericht überein (Spezifikation 1: 52/101).
   - Rework-Punkt 5 (Attrition): Die Bin-Zählungen sind 0,0,0,1,0,2,3,1,0,1,1,0 für Austretende und 2,4,2,3,10,25,18,10,14,6,3,5 für Fortbestehende, wie im Bericht. Der Anteil nahe der Schwelle ist 0.100 gegenüber 0.175 mit Fisher p = 1. Balanciertes Δb 3.906 und LOCF-Δb 3.992 stimmen mit der Interpretation überein.
   - Rework-Punkt 6 (Standard): Die Hongkong-Quellenlabels sind in der TeX-Notiz und im README korrigiert. Δb Hongkong 6.741 → 8.610, A-Share 2.096, Differenz 4.645 → 6.514, alle wie berichtet. Die Imputationszahlen sind in der Notiz und im Interpretationstext identisch. Die Subtraktionen passen: Hongkong pre 318 − 81 = 237, post 230 − 29 = 201; A-Share 480 − 6 = 474, 400 − 2 = 398. Die Beispielmediane (0.0806 → 0.1713 und 0.1786 → 0.1789) stimmen mit der TeX-Tabelle überein.
   - Notch und Window: Die Differenz −1.303 stimmt mit 3.018 − 4.320. Die Richtung der Aussage „unterstützt die erwartete Gruppe nicht“ passt zum Vorzeichen. Window: Nur Juni 2020 ergibt b = −2.351, mit Juni in pre ergibt sich Δb = 4.263, wie im Text.
3. **Pilotliste genau wie vorgegeben:** Die Fallzahlen sind konsistent (11 Pilotfirmen, 11/11 in allen Varianten). Die Pilotliste selbst und die Zuordnung (`t058_pilot_mapping.csv`) habe ich nicht gegen `state/pilot_developers.csv` abgeglichen.
   - Interne Konsistenz: nicht beanstandet.

Weitere Konsistenzprüfungen ohne Befund:
- Die Stichprobenzahlen sind in allen Tabellen identisch (797/136 pre, 630/132 post, 602/129 gepaart).
- Das Fenster [0.66, 0.70) und die Bootstrap-Angaben (999 Ziehungen, Seed 20261016) sind in jeder Notiz gleich.
- Die Notiz zu `t058_above.tex` (Fit schließt [0.66, obere Grenze) aus) passt zu `actual_exclusion_*` im CSV.
- Die Interpretationstexte behaupten keine Signifikanz, die die Outputs nicht zeigen. Nicht belegte Mechanismen sind ausdrücklich als nicht identifiziert gekennzeichnet.
- Die Berichtsaussage zum Zeitpunkt der Pilotkonzentration („nicht belegt“) entspricht den breiten Intervallen in `t058_pilot.tex`.

## Nicht geprüft

- Ob Code und Daten korrekt sind (Bootstrap-Logik, Ausschluss von Seazen im Code, Klassifikation der Notch-Gruppen), ist nicht meine Rolle.
- Die Abbildungen `t058_grid.pdf` und `t058_attrition.pdf` habe ich nicht angesehen.
- Die 301 Zeilen von `t058_number_map.csv` habe ich nur stichprobenartig geprüft (Mappings für „above“).
- `t058_bootstrap_draws.csv` (300.699 Zeilen) und die Hash-Datei habe ich nicht neu berechnet.
- Der Eintrag in `AI_USAGE_LOG.md` für T058 fehlt. Der Bericht bestätigt, dass die Datei außerhalb des Schreibbereichs liegt und der Co-PI den Eintrag ergänzt.
- Die Quellenangaben zu Pilotbeginn, Rollout und Standardumstellung sind laut Bericht ungeprüft. Der PI muss sie bestätigen.
- `proposal/` enthält noch keine T058-Texte (die kommen in T059). Zahlen im Proposal-Text konnte ich deshalb nicht gegen Outputs prüfen.
