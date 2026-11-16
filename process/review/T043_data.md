## Rolle: data (claude, sonnet) – VERDICT: PASS


Das ist der Prüfbericht der Rolle Data Reviewer. Ich habe nur gelesen und keine Befehle ausgeführt (Bash war verweigert). Zahlen aus den CSVs habe ich per Handrechnung gegen den Code geprüft.

## Befunde
Keine Befunde, die ein REWORK oder eine Eskalation rechtfertigen. Es bleiben drei kleinere Hinweise.

[number withheld]. **Handerhobene Cash-Werte nicht durch den PI geprüft (Hinweis).**
   - `nci_cashflow.csv` hat die Spalte `verified_by_PI` überall leer.
[firm-specific excerpt withheld in public process copy]
   - Der Wert geht in die Brutto-Quote von Gruppe A ein (`capital_delta_mi` = [number withheld]).
   - Wirkung: nur auf die Quote von Gruppe A, nicht auf Gruppe B.
[number withheld]. **HK-Währung (Hinweis, im Output korrekt gekennzeichnet).**
   - Die Panel-Währung der HK-MI-Werte ist nur als "reported" kodiert (`t043_cash_backing.csv`, Zeilen [number withheld], [number withheld] und [number withheld]: `currency_verified = FALSE`).
[firm-specific excerpt withheld in public process copy]
[firm-specific excerpt withheld in public process copy]
[number withheld]. **Kosmetik.** Im Statusfeld der gepoolten Zeile fehlt ein Trennzeichen: "…no complete-case substitution ratios conditional…" (`15_referee2.R:598–600`). Das hat keine inhaltliche Wirkung.

Geprüft und in Ordnung:
- **Einheiten und Vorzeichen (Schritt [number withheld]):**
  - Der Parser behandelt Klammern als negativ (`parse_amount`, Zeile [number withheld]). Dividenden werden per `abs()` gedreht (Zeile [number withheld]).
  - `RMB [number withheld]` wird mit [number withheld] multipliziert, A-Aktien-Werte sind in RMB [number withheld].
[firm-specific excerpt withheld in public process copy]
  - Nachgerechnet: Gruppe-B-Summen [number withheld] + [number withheld] = [number withheld] Mrd. Kapital und [number withheld] + [number withheld] = [number withheld] Mrd. Dividenden; das stimmt mit dem CSV überein.
  - Nachgerechnet: Gruppe-A-ΔMI [number withheld] + [number withheld] + [number withheld] + [number withheld] = [number withheld] Mrd. und Kapital [number withheld] Mrd.; das stimmt mit dem CSV überein.
- **Fehlwerte:**
[firm-specific excerpt withheld in public process copy]
[firm-specific excerpt withheld in public process copy]
  - Es gibt keine Imputation, und Gruppe A hat korrekt keine Netto-Quote.
  - Die `pdf_page`-Prüfung ist als Assertion im Code (Zeile [number withheld] und [number withheld]).
- **Fenster:**
  - Die Fenster folgen aus `reports_needed`: frühestes bis spätestes FY, Flüsse nur der Jahre danach.
[firm-specific excerpt withheld in public process copy]
- **Stichproben und Merges:**
  - `sample_main`-Filter (Zeile [number withheld]), `firm_id × date` eindeutig (Zeile [number withheld]) und G = [number withheld] Firmen.
  - Heterogenität: Private [number withheld] + SOE [number withheld] + [number withheld] unklassifiziert = [number withheld]. A-Aktien [number withheld] + HK [number withheld] = [number withheld]. Beide Linien erfüllt [number withheld] + mindestens eine verletzt [number withheld] + [number withheld] unklassifiziert = [number withheld]. Die Ausschlüsse sind gezählt.
  - Nenner und Einheiten der Konstruktion: N = tl − adv, official = N/(N+te), frozen mit MI vom 2019-12-31 und Nenner > [number withheld] (Zeilen [number withheld]–[number withheld]). Das reproduziert D = [number withheld] und gleicht per Assertion mit `t029_compliance.csv` ab (Zeile [number withheld]).
- **Reproduktionsasserts:**
  - b_post = [number withheld], b_pre = [number withheld] und D = [number withheld] stehen in den Zeilen [number withheld]–[number withheld].
  - Alle [number withheld] Zellen von Schritt [number withheld] werden gegen `t023_excess_mass.csv` geprüft (Zeile [number withheld]).
- **Messfehler-Verteilung:** N = [number withheld] aus [number withheld] Firmen, Mittel [number withheld], SD [number withheld]. Die Nahbereichsvariante hat N = [number withheld] aus [number withheld] Firmen. Das stimmt mit dem CSV und dem Bericht überein.
- **Trend-Schritt:**
  - Es fließen nur Daten bis zum Anker ein (`h >= ah-[number withheld] & h <= ah`).
  - Firmen mit weniger als [number withheld] Beobachtungen oder mit MI ≤ [number withheld] fallen auf den Bin-Median zurück ([number withheld] Fallback-Firmen, davon [number withheld] im Fenster, laut CSV).
  - Die Platzebo-Anker sind mangels Historie ausdrücklich "unavailable" und nicht null.
- **Datenintegrität:** Der Code arbeitet offline und liest nur die aufgeführten Eingaben. Die Guards fordern byte-identische Eingaben und Altausgaben (Zeilen [number withheld] und [number withheld]). Die Eingaben sind laut Prüfskript unverändert.

## Abnahmekriterien
[number withheld]. **Reproduktion, Altausgaben byte-identisch, zwei identische Läufe:** teilweise belegt.
   - Belegt sind die Asserts im Code und die Guard-Logik (Zeilen [number withheld]–[number withheld], [number withheld]). Die Guard-Datei und die Logs (Berichtsangabe: Hashes gleich) liegen vor.
   - Nicht von mir prüfbar: die tatsächliche Byte-Identität der zwei Läufe, siehe "Nicht geprüft".
[number withheld]. **Alle Varianten berichtet, Firmenzahlen neben jeder Schätzung:** belegt.
   - Zeilenzahlen sind im Code erzwungen (Zeile [number withheld]): [number withheld], [number withheld], [number withheld], [number withheld], [number withheld] und [number withheld].
   - `firms`-Spalten stehen in `t043_heterogeneity.csv`, `t043_meas_error.csv`, `t043_trend_cf.csv` und `t043_cash_backing.csv`.
[number withheld]. **Konvergenz, Fehlerverteilung (N, Mittel, SD), Seitenverweise:**
   - Fehlerverteilung mit N, Mittel und SD: belegt (`t043_meas_error.csv`).
   - Seitenverweise: belegt. Jeder verwendete Cash-Wert hat eine `pdf_page`, sonst "missing" (`t043_cash_backing.csv`, `source_references`).
   - Konvergenz von Schritt [number withheld]: nicht meine Rolle (Estimation). Ich habe nur den Code gelesen (`chetty_fit`, Zeilen [number withheld]–[number withheld]), nicht die Ergebnisse.
[number withheld]. **Keine neuen Daten, keine handerhobenen Werte geändert:** belegt. Der Code lädt nichts, und `nci_cashflow.csv` steht in der Eingabeliste mit SHA-[number withheld]-Prüfung.
[number withheld]. **Rest (Schätzmethodik, Textaussagen):** nicht meine Rolle.

## Nicht geprüft
- **Programmausführung:** Ich konnte nichts ausführen. Die Byte-Identität der zwei Läufe, die [number withheld] geschützten Ausgaben und die Hashes in `t043_reproducibility.csv` habe ich nicht neu berechnet.
- **Originalwerte der Cash-Flow-Statements:** Ich habe sie nicht gegen die PDFs der Geschäftsberichte geprüft. Das ist nicht möglich und wegen leerem `verified_by_PI` ein offener Punkt.
- **Panel-Spalten:** Ich habe den Kopf von `panel_firm_halfyear.csv` nicht inspiziert, weil die Ausgabe zu lang war. Die Konstruktion von `rl1`, `rl2`, `rl3`, `mi` und `currency` im Aufbereitungsskript habe ich nicht Zeile für Zeile verfolgt.
  - Dass `rl2 <= [number withheld] & rl3 >= [number withheld]` die beiden anderen roten Linien richtig kodiert, stützt sich nur auf die Beschriftung in `03_figures.R` ("Net debt / total equity", "Cash / short-term debt").
  - Dass `soe_final` als [number withheld]/[number withheld] eingelesen wird, folgt indirekt daraus, dass beide Gruppen im Output gefüllt sind.
- **Mess- und Konvergenzlogik:** Die Richtung der Fehlerverteilung (konstruiert minus veröffentlicht) und die Chetty-Iteration überlasse ich der Rolle Estimation.
- **Weitere Dateien:** `06_bunching_tests.R`, `run_all.*`, `README.md` und `AI_USAGE_LOG.md` habe ich nicht gelesen.
