## Rolle: estimation (claude, opus) – VERDICT: PASS


## Befunde

Ich habe keine inhaltlichen Fehler in den Schätzungen gefunden. Zwei kleinere Hinweise, die das Urteil nicht ändern:

1. **Feste Zahlen in der Tabellennote und bei der SE-Unterdrückung.** `10_controls.R:303–305` schreibt „109 / 124 / 122 / 120 / 106 / 101“ als festen Text in die TEX-Note. `10_controls.R:285` unterdrückt die SE über `y == "jv_ta"` und nicht über eine Regel wie `slope_df > n_firms`. Heute stimmen die Werte mit den Modellobjekten überein: In der CSV hat C4 bei rl1 `slope_df` 109 und `n_firms` 124, bei mi_share 109 und 122, bei jv_ta 106 und 101. Für die Event Study ergibt sich 12 + 108 = 120 (`control_df` 108 in `t028_event_study_controls.csv`). Ändern sich Panel oder Kontrollen, würden die Note und die Unterdrückung aber unbemerkt veralten. Die Note müsste dann neu berechnet werden; die Schätzungen selbst betrifft das nicht.
2. **Die Inferenz in C4 und C3-date ist nur eingeschränkt verlässlich.** Das ist korrekt dokumentiert. Die within-R² von C4 für mi_share liegt bei 0,93, für rl2 bei 0,81. Das spricht für Überanpassung durch 108 Steigungen bei rund 122 Clustern. Note und README nennen die Grenze der CR1-SEs. Für die Interpretation im Proposal sollte C3 und nicht C4 die Hauptreferenz sein.

## Prüfung der Schätzungen

- **Spezifikation:**
  - C0 ist `y ~ dose_pre:post | firm_id + date`, geclustert nach `firm_id`, mit `fixef.rm = "singleton"`.
  - C1 bis C3 interagieren die Kontrollen mit `post`. Die Faktoren nutzen `i(..., post, ref=)` mit den Referenzen SOE = 0 und Markt = A.
  - C4 ersetzt das durch `i(date, X, ref="2020-06-30")`.
  - C5 ist C3 auf der Stichprobe `!flag_equity_problem`. Die Regel nach D22 (te ≤ 0, mi > te, rl2 > 5 an einem Post-Datum) steht in `10_controls.R:100–106`.
- **Abgezählte Parameter in C4 (rl1):** 1 + 5 × 12 (z) + 12 (m_roa) + 2 × 12 (SOE) + 12 (Markt) = 109. Das stimmt mit `slope_df` überein. Die 48 entfernten Terme sind die vier Fehlindikatoren ohne fehlende Werte × 12 Daten. Bei jv_ta fallen zusätzlich `m_roa` für 2021-12-31 bis 2022-12-31 weg, also 106. In C2 und C3 fällt `post:m_sales` als redundant zu `m_roa` heraus, in C5 wird `post:m_roa` zur Konstante. Die neue Logik für `collinear_terms` (Z. 185–190: angeforderte gegen geschätzte Namen, Assertion `requested = slope_df + dropped`) ist korrekt.
- **Stichprobe:** Für C1 bis C4 und die Event Study wird per Assertion geprüft, dass `obs()` identisch zu C0 ist (Z. 192, 221). N und Firmenzahl in der CSV stammen aus `nobs(m)` und `obs(m)`. Für C5 ergeben sich 1391/112, 1381/112, 1381/112, 1344/110 und 1100/91. Bei jv_ta sind 10 der 12 markierten Firmen in der C3-Stichprobe, was zu `excluded_firms_from_C3` passt.
- **Abgleich mit T009:**
  - Die C0-Zeilen stimmen mit `t009_did_main.csv` überein; das prüft eine Assertion mit Toleranz 1e-12 (Z. 150–151).
  - Die C0-Koeffizienten der Event Study sind identisch mit `t009_event_study.csv`. Stichprobe: rl1 2016-12-31 ergibt −0,000249530759031531, mi_share 2022-12-31 ergibt 0,00547014715097684.
  - Die C0-Vortrendtests sind identisch mit `t009_pretrend_tests.csv`: rl1 F = 1,6854, p = 0,11857; mi_share F = 0,8389, p = 0,55717.
- **Inferenz:**
  - Die SEs sind firmengeclustert; das sichert eine Assertion auf `cov.scaled`-Typ ab. Die Freiheitsgrade sind G − 1: 123, 121, 100 und in C5 111 bzw. 109.
  - `confint` nutzt die t-Verteilung, im Einklang mit „cluster-t“ in der Abbildung.
  - Der Wald-Test verwendet ein Regex, das nur `date::<prä-Datum>:dose_pre` trifft. Assertionen prüfen, dass genau 7 Terme gewählt werden und `df1 == 7`. Kontrollterme wie `date::…:z_size` werden nicht erfasst.
- **Identifikation:**
  - Die Referenzperiode 2020-06-30 ist durchgehend gleich.
  - Die Kontrollen sind Mittelwerte vor der Politik; das prüfen Assertionen auf `date` und `report_date` ≤ 2019-12-31. Es gibt keine gleichzeitigen Kontrollen.
  - Das Treatment wird nicht aus dem Outcome gebaut.
  - C5 selektiert auf Post-Outcomes; das ist als Sensitivitätsanalyse offengelegt.
- **Ausgabe:**
  - Die Stabilität ist korrekt berechnet: (−0,048571 − (−0,014909)) / 0,010068 = −3,34 bei rl1.
  - Die TEX-Werte stimmen mit der CSV überein (gerundet auf 6 Stellen). Die SE für jv_ta C4 steht als „--“.
  - Der p-Wert in der RL1-Note (0,000223) wird aus `pretrends` berechnet und nicht von Hand eingetragen.
  - Die REWORK-Vorgabe „keine Schätzung ändern“ ist nach den Dateien plausibel erfüllt. Nachrechnen gegen den Stand vor REWORK konnte ich nicht (siehe „Nicht geprüft“).

## Abnahmekriterien

1. **C0 reproduziert T009 / byte-identische Builds:** Der Teil zu C0 ist belegt erfüllt (Assertion Z. 150–151, CSV-Werte, Abgleich der Event Study mit T009). Hashes der bestehenden Ausgaben und zwei identische Läufe: nicht meine Rolle. Der Code prüft die Hashes der geschützten Dateien per Assertion (Z. 332–333).
2. **X_i nur aus Daten ≤ 2019-12-31:** belegt erfüllt für die Finanzkontrollen (Z. 44–48, Assertions auf `date` und `report_date`). SOE und Markt sind statische Panelkategorien. Die Datierung von SOE ist als Einschränkung D9/D18 offengelegt. Die Bewertung der Daten liegt bei der Rolle `data`.
3. **Stabilitätsaussage und Vortrendtests, alle sechs Spalten:** belegt erfüllt, soweit es die Schätzung betrifft.
   - Es gibt 30 Zellen; eine Assertion prüft, dass jede Spezifikation fünfmal vorkommt.
   - `t028_coefficient_stability.csv` deckt C3 und C4 ab.
   - Die Vortrendtests mit Kontrollen: rl1 p = 0,000223, mi_share p = 0,509.
   - Die Hinweise auf den bedingten Vortrend bei RL1 stehen in der TEX-Note und im README (Z. 646–648).
4. **Fehlende X_i und in C5 ausgeschlossene Firmen gezählt:** Die Zahlen zu C5 sind belegt (`excluded_firms_base` 12, `excluded_firms_from_C3`, 10 bei jv_ta). Die Zählung fehlender Werte ist nicht meine Rolle.

## Nicht geprüft

- Ich habe die Skripte nicht ausgeführt (die Rolle erlaubt nur Lesen). Dass beide Läufe byte-identisch sind und die Schätzwerte dem Stand vor REWORK entsprechen, konnte ich deshalb nicht selbst nachrechnen.
- Den Inhalt der PDF-Abbildungen habe ich nicht gesichtet. Laut Code verwenden sie die Bezeichnung „C3-date“ und t-Intervalle aus `confint`.
- Die Änderung an `state/STATE.md` und die Dateien außerhalb des Schreibbereichs (`tasks/T028_verification.txt`) sind nicht meine Rolle.
- Die Datenaufbereitung (Konvention nur für Dezember-Flüsse, Balance-Gruppen, Zählung fehlender Werte) ist nicht meine Rolle.
