## Rolle: data (claude, opus) – VERDICT: PASS


## Befunde
Keine inhaltlichen Fehler in der Datenaufbereitung. Drei kleinere Hinweise für den Co-PI. Keiner davon blockiert die Abnahme.

[firm-specific excerpt withheld in public process copy]
[number withheld]. **Ursache der zwei fehlenden Flow-Werte (geprüft und plausibel).** Beide Firmen haben ein Geschäftsjahresende im März (`fye_flag = TRUE`). Ihre Dezember-Zeilen haben die `report_date` [number withheld][number withheld], die Zeile 2019-12-31 sogar 2020-03-31 (Panel Zeilen [number withheld]–[number withheld] und [number withheld]–[number withheld]). Der Filter `flow_gate` (`10_controls.R:64`) schließt deshalb alle ihre Dezemberwerte aus, und der Filter `report_date ≤ 2019-12-31` (Zeile [number withheld]) streicht genau diese beiden [number withheld][number withheld]-Zeilen. Das passt zu `future_mapped_rows = [number withheld]` und `n_size = [number withheld]`. Die Regel ist korrekt und konservativ, sie schließt aber Firmen mit abweichendem Geschäftsjahr systematisch aus den Flow-Kontrollen aus. Das sollte in einem Satz im Text erwähnt werden.
[number withheld]. **soe_final ist nicht sicher vor [number withheld] bestimmt.** Die Karte schreibt soe_final vor, deshalb ist das kein Fehler des Workers. Die Variable kann aber spätere Offenlegungen enthalten (D9/D1[number withheld]). Kriterium [number withheld] („keine Post-Information in irgendeiner Kontrolle“) ist für diese Variable also nur eingeschränkt erfüllt. Code-Kommentar (Zeilen [number withheld]–[number withheld]) und TEX-Notiz legen das offen.

## Abnahmekriterien
[number withheld]. **C0 = T009, bestehende Outputs unverändert, zwei Läufe byte-identisch:** nicht meine Rolle (Schätzung und Reproduzierbarkeit). Datenseitig belegt: C0 nutzt dieselbe Stichprobe wie T009 (`sample_main & !is.na(dose_pre)`, Zeile [number withheld]). Die Assertion auf [number withheld] steht in Zeilen [number withheld]–[number withheld]. Die Hash-Prüfung der Inputs und der übrigen Outputs steht in Zeilen [number withheld]–[number withheld] und [number withheld]–[number withheld].
[number withheld]. **Alle X_i nur aus Daten ≤ 2019-12-31 (Assertion im Code):** für die fünf Finanzkontrollen belegt erfüllt.
   - Das Fenster `2017-06-30 ≤ date ≤ 2019-12-31` ist zusätzlich auf die tatsächliche `report_date` beschränkt. Beide Bedingungen werden vor der Berechnung per `stopifnot` geprüft (Zeilen [number withheld]–[number withheld]).
   - Laut `t028_control_summary.csv` liegen `max_date` und `max_report_date` für alle Variablen bei 2019-12-31.
   - Die Zeile 2016-12-31 ist korrekt ausgeschlossen.
   - Es werden nur Firmen mit mindestens [number withheld] Datumswerten gemittelt (Zeile [number withheld]).
   - Für die Flows ist ein Mittel aus genau drei Dezemberwerten ([number withheld]–[number withheld]) nötig. Das stimmt mit `flow_conventions` überein: [number withheld] Zeilen = [number withheld] Firmen × [number withheld].
   - Nenner: `ratio()` verlangt `ta > [number withheld]`, sonst NA. Negatives ni bleibt erhalten, das Vorzeichen stimmt.
   - Die Standardisierung über die [number withheld] Firmen ist per Assertion geprüft (Zeile [number withheld]).
   - Für soe_final siehe Befund [number withheld].
[number withheld]. **Stabilität und Pre-Trend im Bericht, alle sechs Spalten berichtet:** Interpretation ist nicht meine Rolle. Datenseitig: `t028_controls_did.csv` enthält [number withheld] Zeilen, C0–C5 für jedes Outcome, alle mit Status „estimated“.
[number withheld]. **Zahl der Firmen mit fehlenden X_i und der in C5 entfernten Firmen:** belegt erfüllt.
   - Fehlende Werte für Größe/ROA/Liquidität/Inventar/Umsatz: [number withheld]/[number withheld]/[number withheld]/[number withheld]/[number withheld]. SOE fehlt bei [number withheld] Firmen ([number withheld], [number withheld], [number withheld], [number withheld], [number withheld]).
   - C5 entfernt [number withheld] Firmen. Ich habe die [number withheld] `TRUE`-Einträge in `t028_firm_controls.csv` einzeln abgezählt.
[firm-specific excerpt withheld in public process copy]
   - Im JV-Sample sinkt die Zahl der Firmen von [number withheld] auf [number withheld] (`excluded_firms_from_C3 = [number withheld]`).
   - Dosisgruppen nach `floor(dose_pre + [number withheld])`: Stichproben stimmen ([number withheld]→[number withheld], [number withheld]→[number withheld], [number withheld]→[number withheld], [number withheld]→[number withheld]). Die Gruppen umfassen [number withheld]/[number withheld]/[number withheld]/[number withheld] = [number withheld] Firmen. Die fehlenden ROA- und SOE-Werte verteilen sich korrekt auf die Gruppen.
   - Merge: `f` ist eindeutig je `firm_id` (Zeile [number withheld]), Zuordnung per `match` (Zeile [number withheld]). Dass dose_pre, soe_final und market innerhalb jeder Firma konstant sind, wird per Assertion geprüft (Zeilen [number withheld]–[number withheld]). Dadurch entstehen keine verdoppelten oder verlorenen Firmen.

## Nicht geprüft
- Ich habe keinen Code ausgeführt (Rolle: nur lesen). Byte-Identität und Fallzahlen nach fixest (N, Singletons) sind nicht nachgerechnet.
- Die Mittelwerte der Balance-Tabelle habe ich nur stichprobenartig geprüft (Gruppenzuordnung, Missing-Verteilung), nicht alle [number withheld] Zeilen.
- Ob die Quellen ni und rev tatsächlich YTD melden, habe ich nicht an `01_clean.R` und den Rohdaten nachvollzogen. Ich habe es aus dem Code-Kommentar (Zeilen [number withheld]–[number withheld]) und der Karte übernommen.
- Die Änderung an `state/STATE.md` (SHA-Meldung des Skripts) liegt im Bereich des Co-PI. Das Skript prüft den Hash nur innerhalb eines Laufs. Das betrifft die Daten nicht.
- Regressionen, Event Study, Abbildungen und Textaussagen gehören nicht zu meiner Rolle.
