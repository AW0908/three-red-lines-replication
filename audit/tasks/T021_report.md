Alle Korrekturen sind eingearbeitet. Als letzten Schritt schreibe ich jetzt den Bericht.

## Ergebnis
Diese Überarbeitung behebt die Befunde aus den REWORK-Reviews (consistency + language) in `06_preliminary_analysis.tex` und `appendix/results.tex`. Geändert wurden die Bezeichnung der Stichprobe beim jv_ta-Verlust sowie zwei Satzanschlüsse (S2-Absatz, mi_gap). Dazu kommen amerikanische Schreibweise (toward/upward/winsorized, „June 30, 2020“), „share of observations with RL2“, `~\citep` und das Präsens im Fazitsatz von 6.2. Zahlen, Floats und die Struktur bleiben unverändert. Die generierte Tabelle `t011_robustness.tex` habe ich wie in der Karte vorgegeben nicht angefasst.

## Dateien
- `proposal/sections/06_preliminary_analysis.tex` – Zeilen 20, 24, 35, 52, 58, 65, 73, 96, 104 sprachlich und in der Stichprobenbezeichnung korrigiert
- `proposal/appendix/results.tex` – Datum in den Notizen der Abbildungen `fig:es_rl2_gap` und `fig:es_jv_ta` auf „June 30, 2020“ gesetzt
- `proposal/main.tex` – in dieser Überarbeitung nicht geändert (das `\input{appendix/results}` aus dem ersten Durchgang bleibt)

## Ausführung
`agents/overleaf.sh check` habe ich nicht ausgeführt: Laut Karte macht das der PI, und mir steht in dieser Sitzung kein Shell-Werkzeug zur Verfügung. Übersetzbarkeit: Es kamen keine neuen Pakete, Befehle oder Labels dazu. Neu ist nur `~` vor `\citep`, und ein `\ref{subsec:treatment}` wurde in einen eigenen Satz verschoben. Eine Suche (Grep) nach ` \citep`, `towards`, `upwards`, `winsoris`, `30 June` und `-ised` in beiden Dateien findet nichts mehr. Der einzige Treffer ist „disguised“, und das ist korrekt.

## Abnahmekriterien
1. **Übersetzung / `\ref`:** Noch nicht geprüft, das macht der PI mit `overleaf.sh check`. Es gibt keine neuen Verweisziele. Benutzt werden nur bestehende Labels (`subsec:treatment`, `subsec:power` usw., die schon im letzten Lauf aufgelöst wurden).
2. **Zahl → Quelle (Abschnitt 6 und Notizen im Anhang):**
   - `t005_bunching_counts.csv` (rl1): 4,5 % (36/797), 12,4 % (78/630), 6,4 %, 8,9 %, 10,9 %, 21,3 %; Schwelle 0,70; Bin-Breite 0,02. (rl2/rl3): 3,0 %, 3,8 %, 1,0 %, 1,2 %, 1,4 %, 2,4 %; Bin-Breite 0,05; Schwellen 0,95/1,00/1,05
   - Zeitfenster 2017H1–2019H2 / 2020H2–2022H2 in den Bunching-Notizen: `t005_bunching_counts.csv` (Spalte period, Definitionen pre/post)
   - `t009_did_main.csv`: RL1 −0,0149 (SE 0,0101; KI −0,0348 bis 0,0050; Mittel 0,663; N 1.544; 124 Firmen); RL2 −0,284 (0,145; −0,570 bis 0,003; 1,176); mi_share 0,0210 (0,0147; −0,0081 bis 0,0501; 0,181); rl2_gap 0,0108 (0,0352); jv_ta 0,0025 (0,0031), N 1.225, 101 Firmen; base_N 1.545, missing_outcome 317, singleton_rows 3. Nachgerechnet: 1.545 − 317 − 3 = 1.225 ✓
   - `t011_robustness.csv` (S0, p_value): 0,141; 0,052; 0,156; 0,760; 0,426
   - `t009_pretrend_tests.csv`: p zwischen 0,087 (rl2) und 0,634 (jv_ta)
   - `t009_event_study.csv`: RL1 −0,0118 (0,0060, 2020H2), −0,0187 (0,0068, 2021H1), −0,0025 (2022H2); RL2 0,235 (2017H2), −0,128 (2019H2); mi_share −0,0213 (2016H2), −0,0052 (2019H2); Referenzdatum 30.06.2020 (2020H1) und 95-%-KI in den Abbildungsnotizen (Haupttext und Anhang): Referenzperiode bzw. CI-Spalten derselben Datei
   - `t011_robustness.csv`: S5 RL1 −0,0189 (0,0085; p 0,028); S11 −0,0198 (0,0076; 0,010); RL2 S5 p 0,044, S3 p 0,021; mi_share S13 −0,0446 (45 Firmen), S5 0,0246 (0,026), S7 0,0320 (0,010), S8 0,0616 (0,011), S9 0,0316 (0,012), S10 0,0290 (0,014); S4: RL1 −0,0097, mi_share 0,0075, rl2_gap −0,0128 (p 0,573); pretrend_p S2 0,003, S3 0,006 / <0,001, S8 0,032, S6 <0,001, S9 0,002, S12 0,021, S7 0,004; Koeffizienten S2 0,0110, S8 0,0248; Spezifikationsnummern S1–S14
   - `t015_ownership_counts.csv`: 136 / 46 / 82 / 8
   - `t015_soe_heterogeneity.csv` (interaction): n 44 / 75; SOE RL1 −0,0290 (0,0109; −0,0507 bis −0,0074), RL2 −0,298 (0,127; −0,550 bis −0,046); privat −0,0057 (0,0166), −0,438 (0,307); mi_share 0,0036 / 0,0204; Differenzen −0,0233 (0,0199), 0,140 (0,333), 0,0168 (0,0389). (robustness_common_time_fe): −0,430, −0,0507
   - In dieser Überarbeitung ist keine Zahl neu dazugekommen oder geändert worden.
3. **Platzierung:** Erfüllt und unverändert. Im Haupttext stehen `fig:bunch_rl1`, `tab:did_main`, `fig:es_main` (drei Teilabbildungen) und `fig:soe_coef`. Im Anhang stehen `tab:robustness`, `tab:soe_het`, `fig:bunch_rl2`, `fig:bunch_rl3`, `fig:es_rl2_gap` und `fig:es_jv_ta`.
4. **Signifikanz / H4:** Erfüllt. Durch das Präsens ändert sich die Aussage nicht, sie bleibt „suggestive evidence … not as an established effect“. H4 bleibt ohne Vorzeichen (Z. 88).
5. **Länge:** Weiterhin geschätzt rund 5 Seiten mit Floats. Die Änderungen sind auf Satzebene, die Länge ist praktisch gleich. Gekürzt wird laut Karte (Feedback 4) später.

## Offene Fragen
- Der Language-Befund 6 (`t011_robustness.tex`: „Winsorise“, „1/99 percent“, „95 percent CIs“, `(t = 1,...,13)`) ist bewusst offen. Er gehört in eine spätere Code-Karte, die das an der Quelle in `replication/code/04_robustness.R` korrigiert.
- Die Abschnitte 4 und 5 enthalten vermutlich noch britische Schreibweise oder Datumsformate. Die habe ich nicht angefasst (spätere globale Sprachkarte).
- Die Kompilierung habe ich nicht selbst geprüft (PI: `agents/overleaf.sh check`).
- `tasks/T021_report.md` war vor dieser Überarbeitung leer. Die Zahlenliste oben habe ich deshalb aus den `% source:`-Kommentaren und dem Text neu zusammengestellt. Neu gegen die CSV-Dateien geprüft habe ich in diesem Durchgang nur `t009_did_main.csv`; alle anderen Werte hat das consistency-Review im letzten Durchgang bestätigt.
- Vorschlag für `AI_USAGE_LOG.md`: „2026-10-19: Claude (Worker) überarbeitet T021 nach consistency/language-Review: Stichprobenbezeichnung, US-Schreibweise, Satzanschlüsse, Zitier-Typografie; keine neuen Zahlen.“
