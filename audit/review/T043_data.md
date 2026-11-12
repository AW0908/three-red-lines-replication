## Rolle: data (claude, sonnet) – VERDICT: PASS


Das ist der Prüfbericht der Rolle Data Reviewer. Ich habe nur gelesen und keine Befehle ausgeführt (Bash war verweigert). Zahlen aus den CSVs habe ich per Handrechnung gegen den Code geprüft.

## Befunde
Keine Befunde, die ein REWORK oder eine Eskalation rechtfertigen. Es bleiben drei kleinere Hinweise.

1. **Handerhobene Cash-Werte nicht durch den PI geprüft (Hinweis).**
   - `nci_cashflow.csv` hat die Spalte `verified_by_PI` überall leer.
[firm-specific excerpt withheld in public audit]
   - Der Wert geht in die Brutto-Quote von Gruppe A ein (`capital_delta_mi` = 1,0546).
   - Wirkung: nur auf die Quote von Gruppe A, nicht auf Gruppe B.
2. **HK-Währung (Hinweis, im Output korrekt gekennzeichnet).**
   - Die Panel-Währung der HK-MI-Werte ist nur als "reported" kodiert (`t043_cash_backing.csv`, Zeilen 4, 5 und 8: `currency_verified = FALSE`).
[firm-specific excerpt withheld in public audit]
[firm-specific excerpt withheld in public audit]
3. **Kosmetik.** Im Statusfeld der gepoolten Zeile fehlt ein Trennzeichen: "…no complete-case substitution ratios conditional…" (`15_referee2.R:598–600`). Das hat keine inhaltliche Wirkung.

Geprüft und in Ordnung:
- **Einheiten und Vorzeichen (Schritt 5):**
  - Der Parser behandelt Klammern als negativ (`parse_amount`, Zeile 515). Dividenden werden per `abs()` gedreht (Zeile 537).
  - `RMB 1,000` wird mit 1000 multipliziert, A-Aktien-Werte sind in RMB 1.
[firm-specific excerpt withheld in public audit]
  - Nachgerechnet: Gruppe-B-Summen 24,281 + 3,589 = 27,870 Mrd. Kapital und 2,174 + 0,112 = 2,286 Mrd. Dividenden; das stimmt mit dem CSV überein.
  - Nachgerechnet: Gruppe-A-ΔMI 32,68 + 3,345 + 5,447 + 16,395 = 57,87 Mrd. und Kapital 61,03 Mrd.; das stimmt mit dem CSV überein.
- **Fehlwerte:**
[firm-specific excerpt withheld in public audit]
[firm-specific excerpt withheld in public audit]
  - Es gibt keine Imputation, und Gruppe A hat korrekt keine Netto-Quote.
  - Die `pdf_page`-Prüfung ist als Assertion im Code (Zeile 546 und 751).
- **Fenster:**
  - Die Fenster folgen aus `reports_needed`: frühestes bis spätestes FY, Flüsse nur der Jahre danach.
[firm-specific excerpt withheld in public audit]
- **Stichproben und Merges:**
  - `sample_main`-Filter (Zeile 22), `firm_id × date` eindeutig (Zeile 24) und G = 136 Firmen.
  - Heterogenität: Private 82 + SOE 46 + 8 unklassifiziert = 136. A-Aktien 80 + HK 56 = 136. Beide Linien erfüllt 52 + mindestens eine verletzt 70 + 14 unklassifiziert = 136. Die Ausschlüsse sind gezählt.
  - Nenner und Einheiten der Konstruktion: N = tl − adv, official = N/(N+te), frozen mit MI vom 2019-12-31 und Nenner > 0 (Zeilen 74–82). Das reproduziert D = 0,1146 und gleicht per Assertion mit `t029_compliance.csv` ab (Zeile 88).
- **Reproduktionsasserts:**
  - b_post = 3,1429, b_pre = −0,8772 und D = 0,1146 stehen in den Zeilen 83–89.
  - Alle 15 Zellen von Schritt 1 werden gegen `t023_excess_mass.csv` geprüft (Zeile 126).
- **Messfehler-Verteilung:** N = 64 aus 30 Firmen, Mittel 0,00994, SD 0,02643. Die Nahbereichsvariante hat N = 52 aus 26 Firmen. Das stimmt mit dem CSV und dem Bericht überein.
- **Trend-Schritt:**
  - Es fließen nur Daten bis zum Anker ein (`h >= ah-6 & h <= ah`).
  - Firmen mit weniger als 4 Beobachtungen oder mit MI ≤ 0 fallen auf den Bin-Median zurück (13 Fallback-Firmen, davon 12 im Fenster, laut CSV).
  - Die Platzebo-Anker sind mangels Historie ausdrücklich "unavailable" und nicht null.
- **Datenintegrität:** Der Code arbeitet offline und liest nur die aufgeführten Eingaben. Die Guards fordern byte-identische Eingaben und Altausgaben (Zeilen 752 und 754). Die Eingaben sind laut Prüfskript unverändert.

## Abnahmekriterien
1. **Reproduktion, Altausgaben byte-identisch, zwei identische Läufe:** teilweise belegt.
   - Belegt sind die Asserts im Code und die Guard-Logik (Zeilen 83–88, 752). Die Guard-Datei und die Logs (Berichtsangabe: Hashes gleich) liegen vor.
   - Nicht von mir prüfbar: die tatsächliche Byte-Identität der zwei Läufe, siehe "Nicht geprüft".
2. **Alle Varianten berichtet, Firmenzahlen neben jeder Schätzung:** belegt.
   - Zeilenzahlen sind im Code erzwungen (Zeile 750): 15, 11, 12, 12, 12 und 20.
   - `firms`-Spalten stehen in `t043_heterogeneity.csv`, `t043_meas_error.csv`, `t043_trend_cf.csv` und `t043_cash_backing.csv`.
3. **Konvergenz, Fehlerverteilung (N, Mittel, SD), Seitenverweise:**
   - Fehlerverteilung mit N, Mittel und SD: belegt (`t043_meas_error.csv`).
   - Seitenverweise: belegt. Jeder verwendete Cash-Wert hat eine `pdf_page`, sonst "missing" (`t043_cash_backing.csv`, `source_references`).
   - Konvergenz von Schritt 2: nicht meine Rolle (Estimation). Ich habe nur den Code gelesen (`chetty_fit`, Zeilen 169–210), nicht die Ergebnisse.
4. **Keine neuen Daten, keine handerhobenen Werte geändert:** belegt. Der Code lädt nichts, und `nci_cashflow.csv` steht in der Eingabeliste mit SHA-256-Prüfung.
5. **Rest (Schätzmethodik, Textaussagen):** nicht meine Rolle.

## Nicht geprüft
- **Programmausführung:** Ich konnte nichts ausführen. Die Byte-Identität der zwei Läufe, die 203 geschützten Ausgaben und die Hashes in `t043_reproducibility.csv` habe ich nicht neu berechnet.
- **Originalwerte der Cash-Flow-Statements:** Ich habe sie nicht gegen die PDFs der Geschäftsberichte geprüft. Das ist nicht möglich und wegen leerem `verified_by_PI` ein offener Punkt.
- **Panel-Spalten:** Ich habe den Kopf von `panel_firm_halfyear.csv` nicht inspiziert, weil die Ausgabe zu lang war. Die Konstruktion von `rl1`, `rl2`, `rl3`, `mi` und `currency` im Aufbereitungsskript habe ich nicht Zeile für Zeile verfolgt.
  - Dass `rl2 <= 1 & rl3 >= 1` die beiden anderen roten Linien richtig kodiert, stützt sich nur auf die Beschriftung in `03_figures.R` ("Net debt / total equity", "Cash / short-term debt").
  - Dass `soe_final` als 0/1 eingelesen wird, folgt indirekt daraus, dass beide Gruppen im Output gefüllt sind.
- **Mess- und Konvergenzlogik:** Die Richtung der Fehlerverteilung (konstruiert minus veröffentlicht) und die Chetty-Iteration überlasse ich der Rolle Estimation.
- **Weitere Dateien:** `06_bunching_tests.R`, `run_all.*`, `README.md` und `AI_USAGE_LOG.md` habe ich nicht gelesen.
