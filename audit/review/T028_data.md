## Rolle: data (claude, opus) – VERDICT: PASS


## Befunde
Keine inhaltlichen Fehler in der Datenaufbereitung. Drei kleinere Hinweise für den Co-PI. Keiner davon blockiert die Abnahme.

[firm-specific excerpt withheld in public audit]
2. **Ursache der zwei fehlenden Flow-Werte (geprüft und plausibel).** Beide Firmen haben ein Geschäftsjahresende im März (`fye_flag = TRUE`). Ihre Dezember-Zeilen haben die `report_date` 03-31, die Zeile 2019-12-31 sogar 2020-03-31 (Panel Zeilen 626–632 und 975–981). Der Filter `flow_gate` (`10_controls.R:64`) schließt deshalb alle ihre Dezemberwerte aus, und der Filter `report_date ≤ 2019-12-31` (Zeile 46) streicht genau diese beiden 2019-12-Zeilen. Das passt zu `future_mapped_rows = 2` und `n_size = 5`. Die Regel ist korrekt und konservativ, sie schließt aber Firmen mit abweichendem Geschäftsjahr systematisch aus den Flow-Kontrollen aus. Das sollte in einem Satz im Text erwähnt werden.
3. **soe_final ist nicht sicher vor 2020 bestimmt.** Die Karte schreibt soe_final vor, deshalb ist das kein Fehler des Workers. Die Variable kann aber spätere Offenlegungen enthalten (D9/D18). Kriterium 2 („keine Post-Information in irgendeiner Kontrolle“) ist für diese Variable also nur eingeschränkt erfüllt. Code-Kommentar (Zeilen 36–37) und TEX-Notiz legen das offen.

## Abnahmekriterien
1. **C0 = T009, bestehende Outputs unverändert, zwei Läufe byte-identisch:** nicht meine Rolle (Schätzung und Reproduzierbarkeit). Datenseitig belegt: C0 nutzt dieselbe Stichprobe wie T009 (`sample_main & !is.na(dose_pre)`, Zeile 27). Die Assertion auf 1e-12 steht in Zeilen 150–151. Die Hash-Prüfung der Inputs und der übrigen Outputs steht in Zeilen 17–20 und 332–333.
2. **Alle X_i nur aus Daten ≤ 2019-12-31 (Assertion im Code):** für die fünf Finanzkontrollen belegt erfüllt.
   - Das Fenster `2017-06-30 ≤ date ≤ 2019-12-31` ist zusätzlich auf die tatsächliche `report_date` beschränkt. Beide Bedingungen werden vor der Berechnung per `stopifnot` geprüft (Zeilen 44–48).
   - Laut `t028_control_summary.csv` liegen `max_date` und `max_report_date` für alle Variablen bei 2019-12-31.
   - Die Zeile 2016-12-31 ist korrekt ausgeschlossen.
   - Es werden nur Firmen mit mindestens 3 Datumswerten gemittelt (Zeile 77).
   - Für die Flows ist ein Mittel aus genau drei Dezemberwerten (2017–2019) nötig. Das stimmt mit `flow_conventions` überein: 366 Zeilen = 122 Firmen × 3.
   - Nenner: `ratio()` verlangt `ta > 0`, sonst NA. Negatives ni bleibt erhalten, das Vorzeichen stimmt.
   - Die Standardisierung über die 124 Firmen ist per Assertion geprüft (Zeile 84).
   - Für soe_final siehe Befund 3.
3. **Stabilität und Pre-Trend im Bericht, alle sechs Spalten berichtet:** Interpretation ist nicht meine Rolle. Datenseitig: `t028_controls_did.csv` enthält 30 Zeilen, C0–C5 für jedes Outcome, alle mit Status „estimated“.
4. **Zahl der Firmen mit fehlenden X_i und der in C5 entfernten Firmen:** belegt erfüllt.
   - Fehlende Werte für Größe/ROA/Liquidität/Inventar/Umsatz: 0/2/0/0/2. SOE fehlt bei 5 Firmen (000002, 000926, 600383, 600555, 600606).
   - C5 entfernt 12 Firmen. Ich habe die 12 `TRUE`-Einträge in `t028_firm_controls.csv` einzeln abgezählt.
[firm-specific excerpt withheld in public audit]
   - Im JV-Sample sinkt die Zahl der Firmen von 101 auf 91 (`excluded_firms_from_C3 = 10`).
   - Dosisgruppen nach `floor(dose_pre + 0.5)`: Stichproben stimmen (0.5→1, 1.5→2, 2.5→3, 2.25→2). Die Gruppen umfassen 31/37/28/28 = 124 Firmen. Die fehlenden ROA- und SOE-Werte verteilen sich korrekt auf die Gruppen.
   - Merge: `f` ist eindeutig je `firm_id` (Zeile 31), Zuordnung per `match` (Zeile 108). Dass dose_pre, soe_final und market innerhalb jeder Firma konstant sind, wird per Assertion geprüft (Zeilen 33–34). Dadurch entstehen keine verdoppelten oder verlorenen Firmen.

## Nicht geprüft
- Ich habe keinen Code ausgeführt (Rolle: nur lesen). Byte-Identität und Fallzahlen nach fixest (N, Singletons) sind nicht nachgerechnet.
- Die Mittelwerte der Balance-Tabelle habe ich nur stichprobenartig geprüft (Gruppenzuordnung, Missing-Verteilung), nicht alle 40 Zeilen.
- Ob die Quellen ni und rev tatsächlich YTD melden, habe ich nicht an `01_clean.R` und den Rohdaten nachvollzogen. Ich habe es aus dem Code-Kommentar (Zeilen 58–61) und der Karte übernommen.
- Die Änderung an `state/STATE.md` (SHA-Meldung des Skripts) liegt im Bereich des Co-PI. Das Skript prüft den Hash nur innerhalb eines Laufs. Das betrifft die Daten nicht.
- Regressionen, Event Study, Abbildungen und Textaussagen gehören nicht zu meiner Rolle.
