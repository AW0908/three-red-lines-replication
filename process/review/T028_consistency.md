## Rolle: consistency (claude, opus) – VERDICT: PASS


## Befunde
[number withheld]. **Geringfügig – fest eingetragene Zahlen in der TEX-Note.** In `replication/code/10_controls.R:303` und `:[number withheld]` stehen die Zahlen [number withheld], [number withheld], [number withheld], [number withheld], [number withheld] und [number withheld] als feste Zeichenketten. Sie werden nicht aus `result$slope_df` und `n_firms` berechnet. Auch die Unterdrückung des SE (`:[number withheld]`) hängt fest an `y == "jv_ta"` und nicht an der Bedingung `slope_df > n_firms`. In `:[number withheld]` steht „[number withheld] firms“ ebenfalls fest im Code. Im Moment stimmen alle Werte mit `t028_controls_did.csv` überein: slope_df [number withheld] für C4 bei rl1, rl2, rl2_gap und mi_share, [number withheld] für jv_ta; n_firms [number withheld], [number withheld] und [number withheld]; Event-Study [number withheld] Kontrollen + [number withheld] Dosis-Dummies = [number withheld]. Ändern sich aber Panel oder Spezifikation, veralten diese Angaben unbemerkt (Regel [number withheld]). Die Zahlen sollten künftig aus den Ergebnissen erzeugt werden. Für die jetzige Abnahme ist das kein Hindernis.
[number withheld]. **Geringfügig – C5-Note ungenau für JV.** Die TEX-Note (`t028_controls_did.tex:30`) spricht pauschal von „C3 excluding [number withheld] firms“. Bei jv_ta fallen aber nur [number withheld] Firmen aus dem Schätzsample, weil zwei der markierten Firmen dort schon fehlen. Die Zeile „N / Firms“ zeigt korrekt [number withheld] → [number withheld], und die CSV unterscheidet `excluded_firms_base` = [number withheld] und `excluded_firms_from_C3` = [number withheld]. Bericht und CSV sind also richtig, nur der Notetext ist ungenau.

## Abnahmekriterien
[number withheld]. **C0 = T009 / Byte-Identität:** Die Konsistenz habe ich belegt. Alle fünf C0-Koeffizienten, SEs, CIs, N und Firmenzahlen in `t028_controls_did.csv` stimmen ziffernweise mit `t009_did_main.csv` überein. Die Byte-Identität bestehender Outputs und die beiden identischen Läufe sind nicht meine Rolle.
[number withheld]. **X_i nur aus Daten ≤ 2019-12-31:** Die Konsistenz habe ich belegt. `t028_control_summary.csv` zeigt für alle fünf Kontrollen `max_date` und `max_report_date` = 2019-12-31. Die Notes in beiden TEX-Dateien und im README nennen dieselbe Regel und den Ausschluss von [number withheld] Zeilen. Die Assertion im Code selbst ist nicht meine Rolle.
[number withheld]. **Stabilität und Vortrendtests im Bericht, alle sechs Spalten:** belegt erfüllt.
   - Ich habe alle zehn Werte für „Änderung in Baseline-SE“ nachgerechnet, z. B. RL1 C3: ([number withheld] + [number withheld]) / [number withheld] = [number withheld]; RL2 C4 = [number withheld]; jv_ta C3 = [number withheld]. Sie stimmen mit `t028_coefficient_stability.csv` und mit der Tabelle im Bericht überein.
   - Die p-Werte der Vortrendtests stimmen mit `t028_pretrend_controls.csv` überein: RL1 C3-date p = [number withheld], mi_share p = [number withheld].
   - Alle [number withheld] Zellen erscheinen in CSV und TEX; die TEX-Zahlen entsprechen der CSV auf [number withheld] Nachkommastellen gerundet (alle Zellen geprüft); der JV-C4-SE steht wie verlangt als „--“.
   - Die Zahl der Kontroll-Freiheitsgrade passt zur Liste der entfernten Terme: C2 hat [number withheld] angeforderte Terme, [number withheld] entfernt, also [number withheld]; C3 [number withheld] − [number withheld] = [number withheld]; C5 [number withheld] − [number withheld] = [number withheld].
[number withheld]. **Fehlende X_i und C5-Abgänge berichtet:** belegt erfüllt.
   - Fehlende Werte [number withheld]/[number withheld]/[number withheld]/[number withheld]/[number withheld] und SOE [number withheld] stimmen mit `t028_balance.csv` und `t028_control_summary.csv` überein.
   - Die Gruppen [number withheld]/[number withheld]/[number withheld]/[number withheld] (Summe [number withheld]) stimmen mit der Zeile „Firms“ in der TEX-Tabelle überein.
   - C5: [number withheld] bzw. [number withheld] Firmen und N [number withheld]/[number withheld]/[number withheld]/[number withheld]/[number withheld] stimmen mit der CSV überein.

**Co-PI-REWORK-Punkte, soweit sie meine Rolle betreffen:**
- **Balance-Tabelle:** TEX und CSV sind konsistent; alle Mittelwerte und Korrelationen habe ich verglichen. Die Note nennt `floor(exposure + [number withheld])`.
- **Hinweise (a), (b), (c):** Sie stehen in der TEX-Note und im README (`README.md:636–655`). Die Zahlen darin stimmen mit den Outputs überein.
- **Umbenennung in „C3-date“:** umgesetzt in `t028_event_study_controls.csv`, `t028_pretrend_controls.csv` und in beiden Abbildungen (Legende und Untertitel).
- **Abbildungen gegen CSV:** Die Punkte und Intervalle beider PDFs entsprechen `t028_event_study_controls.csv`, z. B. RL1 C3-date [number withheld]H1 ≈ [number withheld] und mi_share C3-date [number withheld]H2 ≈ [number withheld] mit CI bis [number withheld]. Auch N und Firmen in der Bildunterschrift stimmen ([number withheld]/[number withheld], [number withheld]/[number withheld]).
- **Referenzperiode:** [number withheld]H1 (= 2020-06-30), in allen Dateien gleich.

**Nicht meine Rolle:**
- die Richtigkeit der Variablenkonstruktion und der Datenbereinigung;
- die Schätzspezifikation in fixest;
- Hash- und Byte-Prüfungen sowie der Schreibbereich.

## Nicht geprüft
- **Text in `proposal/`:** Diese Karte erzeugt keinen Proposal-Text. Ich habe also nur README, TEX-Notes, Abbildungen und den Worker-Bericht gegen die Outputs abgeglichen.
- **Anderer Dateistand:** Wegen des Leseverbots über Bash konnte ich nicht ausschließen, dass die Dateien auf der Festplatte vom eingefrorenen Stand abweichen. Ich habe die Dateien direkt gelesen.
- **`state/STATE.md`:** Die Datei hat sich laut SHA-[number withheld] während der Ausführung geändert. Inhalt und Folgen davon habe ich nicht geprüft, das ist nicht meine Rolle.
- **`tasks/T028_verification.txt`:** nicht gelesen.
