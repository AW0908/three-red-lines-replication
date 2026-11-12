## Rolle: consistency (claude, opus) – VERDICT: PASS


## Befunde
1. **Geringfügig – fest eingetragene Zahlen in der TEX-Note.** In `replication/code/10_controls.R:303` und `:305` stehen die Zahlen 109, 124, 122, 120, 106 und 101 als feste Zeichenketten. Sie werden nicht aus `result$slope_df` und `n_firms` berechnet. Auch die Unterdrückung des SE (`:285`) hängt fest an `y == "jv_ta"` und nicht an der Bedingung `slope_df > n_firms`. In `:274` steht „124 firms“ ebenfalls fest im Code. Im Moment stimmen alle Werte mit `t028_controls_did.csv` überein: slope_df 109 für C4 bei rl1, rl2, rl2_gap und mi_share, 106 für jv_ta; n_firms 124, 122 und 101; Event-Study 108 Kontrollen + 12 Dosis-Dummies = 120. Ändern sich aber Panel oder Spezifikation, veralten diese Angaben unbemerkt (Regel 4). Die Zahlen sollten künftig aus den Ergebnissen erzeugt werden. Für die jetzige Abnahme ist das kein Hindernis.
2. **Geringfügig – C5-Note ungenau für JV.** Die TEX-Note (`t028_controls_did.tex:30`) spricht pauschal von „C3 excluding 12 firms“. Bei jv_ta fallen aber nur 10 Firmen aus dem Schätzsample, weil zwei der markierten Firmen dort schon fehlen. Die Zeile „N / Firms“ zeigt korrekt 101 → 91, und die CSV unterscheidet `excluded_firms_base` = 12 und `excluded_firms_from_C3` = 10. Bericht und CSV sind also richtig, nur der Notetext ist ungenau.

## Abnahmekriterien
1. **C0 = T009 / Byte-Identität:** Die Konsistenz habe ich belegt. Alle fünf C0-Koeffizienten, SEs, CIs, N und Firmenzahlen in `t028_controls_did.csv` stimmen ziffernweise mit `t009_did_main.csv` überein. Die Byte-Identität bestehender Outputs und die beiden identischen Läufe sind nicht meine Rolle.
2. **X_i nur aus Daten ≤ 2019-12-31:** Die Konsistenz habe ich belegt. `t028_control_summary.csv` zeigt für alle fünf Kontrollen `max_date` und `max_report_date` = 2019-12-31. Die Notes in beiden TEX-Dateien und im README nennen dieselbe Regel und den Ausschluss von 2 Zeilen. Die Assertion im Code selbst ist nicht meine Rolle.
3. **Stabilität und Vortrendtests im Bericht, alle sechs Spalten:** belegt erfüllt.
   - Ich habe alle zehn Werte für „Änderung in Baseline-SE“ nachgerechnet, z. B. RL1 C3: (−0,048571 + 0,014909) / 0,010068 = −3,34; RL2 C4 = −0,87; jv_ta C3 = +1,33. Sie stimmen mit `t028_coefficient_stability.csv` und mit der Tabelle im Bericht überein.
   - Die p-Werte der Vortrendtests stimmen mit `t028_pretrend_controls.csv` überein: RL1 C3-date p = 0,000223, mi_share p = 0,508751.
   - Alle 30 Zellen erscheinen in CSV und TEX; die TEX-Zahlen entsprechen der CSV auf 6 Nachkommastellen gerundet (alle Zellen geprüft); der JV-C4-SE steht wie verlangt als „--“.
   - Die Zahl der Kontroll-Freiheitsgrade passt zur Liste der entfernten Terme: C2 hat 10 angeforderte Terme, 4 entfernt, also 6; C3 13 − 4 = 9; C5 13 − 5 = 8.
4. **Fehlende X_i und C5-Abgänge berichtet:** belegt erfüllt.
   - Fehlende Werte 0/2/0/0/2 und SOE 5 stimmen mit `t028_balance.csv` und `t028_control_summary.csv` überein.
   - Die Gruppen 31/37/28/28 (Summe 124) stimmen mit der Zeile „Firms“ in der TEX-Tabelle überein.
   - C5: 12 bzw. 10 Firmen und N 1391/1381/1381/1344/1100 stimmen mit der CSV überein.

**Co-PI-REWORK-Punkte, soweit sie meine Rolle betreffen:**
- **Balance-Tabelle:** TEX und CSV sind konsistent; alle Mittelwerte und Korrelationen habe ich verglichen. Die Note nennt `floor(exposure + 0.5)`.
- **Hinweise (a), (b), (c):** Sie stehen in der TEX-Note und im README (`README.md:636–655`). Die Zahlen darin stimmen mit den Outputs überein.
- **Umbenennung in „C3-date“:** umgesetzt in `t028_event_study_controls.csv`, `t028_pretrend_controls.csv` und in beiden Abbildungen (Legende und Untertitel).
- **Abbildungen gegen CSV:** Die Punkte und Intervalle beider PDFs entsprechen `t028_event_study_controls.csv`, z. B. RL1 C3-date 2017H1 ≈ 0,056 und mi_share C3-date 2022H2 ≈ 0,051 mit CI bis 0,133. Auch N und Firmen in der Bildunterschrift stimmen (1544/124, 1484/122).
- **Referenzperiode:** 2020H1 (= 2020-06-30), in allen Dateien gleich.

**Nicht meine Rolle:**
- die Richtigkeit der Variablenkonstruktion und der Datenbereinigung;
- die Schätzspezifikation in fixest;
- Hash- und Byte-Prüfungen sowie der Schreibbereich.

## Nicht geprüft
- **Text in `proposal/`:** Diese Karte erzeugt keinen Proposal-Text. Ich habe also nur README, TEX-Notes, Abbildungen und den Worker-Bericht gegen die Outputs abgeglichen.
- **Anderer Dateistand:** Wegen des Leseverbots über Bash konnte ich nicht ausschließen, dass die Dateien auf der Festplatte vom eingefrorenen Stand abweichen. Ich habe die Dateien direkt gelesen.
- **`state/STATE.md`:** Die Datei hat sich laut SHA-256 während der Ausführung geändert. Inhalt und Folgen davon habe ich nicht geprüft, das ist nicht meine Rolle.
- **`tasks/T028_verification.txt`:** nicht gelesen.
