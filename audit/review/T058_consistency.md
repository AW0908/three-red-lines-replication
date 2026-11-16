## Rolle: consistency (claude, sonnet) – VERDICT: PASS


## Befunde

Keine inhaltlichen Inkonsistenzen zwischen Schätzung, Output und Text gefunden. Hinweise ohne Urteilsrelevanz, schwerster zuerst:

[number withheld]. **Delta-b-Zeilen der Pilotgruppe ohne B-Flag** (`t058_pilot.tex`, Zeilen [number withheld], [number withheld], [number withheld]): Die Zellen b pre und b post tragen „SB“, die zugehörige Δb-Zeile nur „S“. Ihr Intervall [[number withheld], [number withheld]] speist sich aus denselben Bootstrap-Ziehungen. Ob einzelne Ziehungen ohne Fenstermasse eingehen, habe ich nicht geprüft. Die Notiz nennt nur b-Zellen. Der Befund ist für die Lesart harmlos, weil „S“ die Zelle ohnehin als deskriptiv markiert.
[number withheld]. **Fallzahl pre bei Hongkong:** Die TeX-Notiz in `t058_standard.tex` nennt [number withheld] Hongkong-Zeilen pre, die Tabelle zeigt N = [number withheld] für b pre (`t058_standard.tex`, Zeile [number withheld]). Die Notiz zählt alle Hauptstichprobenzeilen, die Tabelle nur Zeilen mit endlichem RL1. Das ist plausibel, aber nicht ausdrücklich gesagt.
[number withheld]. **Perimeter:** Der Bericht listet [number withheld] Ausgabedateien. Davon sind `t058_grid.pdf` und `t058_attrition.pdf` hier nicht als eingefroren geführt. Ich habe sie nicht geprüft.

## Abnahmekriterien

Meine Rolle betrifft Übereinstimmung von Zahlen, Text und Outputs.

[number withheld]. **Reproduktionsasserts** (b_post [number withheld], b_pre [number withheld], Δb [number withheld], D [number withheld], [number withheld] Paare, [number withheld] Firmen): belegt in `t058_reproduction.csv`, alle sechs Zeilen `assert_pass = TRUE`. Dieselben Werte stehen in `t058_window.csv`, `t058_attrition.tex` ([number withheld]) und der Grid-Basiszeile (Spezifikation [number withheld], Δb = [number withheld]).
   - Byte-Identität und Zwei-Läufe-Identität: nicht meine Rolle. Das prüft das Skript per SHA-[number withheld] (`t058_verification.csv`).
[number withheld]. **Alle Varianten mit N, Firmen und Fensterfirmen, kleine Zellen markiert:** belegt in den TeX-Tabellen. Jede Zeile hat N, Firmen, „Window N (firms)“ und die Spalte S.
   - Rework-Punkt [number withheld] (Masse oberhalb): zwölf Zeilen in `t058_above.csv/.tex`. Alle Werte und Intervalle stimmen mit der Berichtstabelle und der Interpretation überein.
   - Rework-Punkt [number withheld] (Seazen): Kontroll-N pre/post [number withheld]/[number withheld] und Firmen [number withheld]/[number withheld] in allen drei Varianten identisch. Pilot-Δb [number withheld] minus [number withheld] ergibt [number withheld] (Rundung). Seazen A-Share: [number withheld] − [number withheld] = [number withheld]. Die [number withheld]/[number withheld] Nullmassen-Ziehungen am 2020-12-31 stehen in `t058_pilot.csv`.
   - Rework-Punkt [number withheld] (symmetrische Tests): Die Kontraste folgen aus den normalisierten D-Werten.
     - MI − Mutter-EK: [number withheld] − [number withheld] = [number withheld] (post), [number withheld] − [number withheld] = [number withheld] (Placebo), Differenz [number withheld].
     - MI − gemeinsames Einfrieren: [number withheld] (post), [number withheld] (Placebo), Differenz [number withheld].
     - Die Normalisierung stimmt: [number withheld] · [number withheld] / [number withheld] = [number withheld].
   - Rework-Punkt [number withheld] (Grid): [number withheld]/[number withheld] positiv. Die Summe der Zähler nach Dimension ergibt jeweils [number withheld]/[number withheld] mit Intervall über null. Die Min/Median/Max-Werte der TeX-Tabelle ([number withheld] / [number withheld] / [number withheld]) stimmen mit dem Bericht überein. Die Reskalierung ist konsistent: [number withheld] nativ bei Breite [number withheld] wird [number withheld]. Die Zählungen im Ausschlussfenster stimmen mit dem Bericht überein (Spezifikation [number withheld]: [number withheld]/[number withheld]).
   - Rework-Punkt [number withheld] (Attrition): Die Bin-Zählungen sind [number withheld] für Austretende und [number withheld] für Fortbestehende, wie im Bericht. Der Anteil nahe der Schwelle ist [number withheld] gegenüber [number withheld] mit Fisher p = [number withheld]. Balanciertes Δb [number withheld] und LOCF-Δb [number withheld] stimmen mit der Interpretation überein.
   - Rework-Punkt [number withheld] (Standard): Die Hongkong-Quellenlabels sind in der TeX-Notiz und im README korrigiert. Δb Hongkong [number withheld] → [number withheld], A-Share [number withheld], Differenz [number withheld] → [number withheld], alle wie berichtet. Die Imputationszahlen sind in der Notiz und im Interpretationstext identisch. Die Subtraktionen passen: Hongkong pre [number withheld] − [number withheld] = [number withheld], post [number withheld] − [number withheld] = [number withheld]; A-Share [number withheld] − [number withheld] = [number withheld], [number withheld] − [number withheld] = [number withheld]. Die Beispielmediane ([number withheld] → [number withheld] und [number withheld] → [number withheld]) stimmen mit der TeX-Tabelle überein.
   - Notch und Window: Die Differenz [number withheld] stimmt mit [number withheld] − [number withheld]. Die Richtung der Aussage „unterstützt die erwartete Gruppe nicht“ passt zum Vorzeichen. Window: Nur Juni [number withheld] ergibt b = [number withheld], mit Juni in pre ergibt sich Δb = [number withheld], wie im Text.
[number withheld]. **Pilotliste genau wie vorgegeben:** Die Fallzahlen sind konsistent ([number withheld] Pilotfirmen, [number withheld]/[number withheld] in allen Varianten). Die Pilotliste selbst und die Zuordnung (`t058_pilot_mapping.csv`) habe ich nicht gegen `state/pilot_developers.csv` abgeglichen.
   - Interne Konsistenz: nicht beanstandet.

Weitere Konsistenzprüfungen ohne Befund:
- Die Stichprobenzahlen sind in allen Tabellen identisch ([number withheld]/[number withheld] pre, [number withheld]/[number withheld] post, [number withheld]/[number withheld] gepaart).
- Das Fenster [[number withheld], [number withheld]) und die Bootstrap-Angaben ([number withheld] Ziehungen, Seed [number withheld]) sind in jeder Notiz gleich.
- Die Notiz zu `t058_above.tex` (Fit schließt [[number withheld], obere Grenze) aus) passt zu `actual_exclusion_*` im CSV.
- Die Interpretationstexte behaupten keine Signifikanz, die die Outputs nicht zeigen. Nicht belegte Mechanismen sind ausdrücklich als nicht identifiziert gekennzeichnet.
- Die Berichtsaussage zum Zeitpunkt der Pilotkonzentration („nicht belegt“) entspricht den breiten Intervallen in `t058_pilot.tex`.

## Nicht geprüft

- Ob Code und Daten korrekt sind (Bootstrap-Logik, Ausschluss von Seazen im Code, Klassifikation der Notch-Gruppen), ist nicht meine Rolle.
- Die Abbildungen `t058_grid.pdf` und `t058_attrition.pdf` habe ich nicht angesehen.
- Die [number withheld] Zeilen von `t058_number_map.csv` habe ich nur stichprobenartig geprüft (Mappings für „above“).
- `t058_bootstrap_draws.csv` ([number withheld] Zeilen) und die Hash-Datei habe ich nicht neu berechnet.
- Der Eintrag in `AI_USAGE_LOG.md` für T058 fehlt. Der Bericht bestätigt, dass die Datei außerhalb des Schreibbereichs liegt und der Co-PI den Eintrag ergänzt.
- Die Quellenangaben zu Pilotbeginn, Rollout und Standardumstellung sind laut Bericht ungeprüft. Der PI muss sie bestätigen.
- `proposal/` enthält noch keine T058-Texte (die kommen in T059). Zahlen im Proposal-Text konnte ich deshalb nicht gegen Outputs prüfen.
