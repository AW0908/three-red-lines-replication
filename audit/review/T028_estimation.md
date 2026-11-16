## Rolle: estimation (claude, opus) – VERDICT: PASS


## Befunde

Ich habe keine inhaltlichen Fehler in den Schätzungen gefunden. Zwei kleinere Hinweise, die das Urteil nicht ändern:

[number withheld]. **Feste Zahlen in der Tabellennote und bei der SE-Unterdrückung.** `10_controls.R:303–305` schreibt „[number withheld] / [number withheld] / [number withheld] / [number withheld] / [number withheld] / [number withheld]“ als festen Text in die TEX-Note. `10_controls.R:285` unterdrückt die SE über `y == "jv_ta"` und nicht über eine Regel wie `slope_df > n_firms`. Heute stimmen die Werte mit den Modellobjekten überein: In der CSV hat C4 bei rl1 `slope_df` [number withheld] und `n_firms` [number withheld], bei mi_share [number withheld] und [number withheld], bei jv_ta [number withheld] und [number withheld]. Für die Event Study ergibt sich [number withheld] + [number withheld] = [number withheld] (`control_df` [number withheld] in `t028_event_study_controls.csv`). Ändern sich Panel oder Kontrollen, würden die Note und die Unterdrückung aber unbemerkt veralten. Die Note müsste dann neu berechnet werden; die Schätzungen selbst betrifft das nicht.
[number withheld]. **Die Inferenz in C4 und C3-date ist nur eingeschränkt verlässlich.** Das ist korrekt dokumentiert. Die within-R² von C4 für mi_share liegt bei [number withheld], für rl2 bei [number withheld]. Das spricht für Überanpassung durch [number withheld] Steigungen bei rund [number withheld] Clustern. Note und README nennen die Grenze der CR1-SEs. Für die Interpretation im Proposal sollte C3 und nicht C4 die Hauptreferenz sein.

## Prüfung der Schätzungen

- **Spezifikation:**
  - C0 ist `y ~ dose_pre:post | firm_id + date`, geclustert nach `firm_id`, mit `fixef.rm = "singleton"`.
  - C1 bis C3 interagieren die Kontrollen mit `post`. Die Faktoren nutzen `i(..., post, ref=)` mit den Referenzen SOE = [number withheld] und Markt = A.
  - C4 ersetzt das durch `i(date, X, ref="2020-06-30")`.
  - C5 ist C3 auf der Stichprobe `!flag_equity_problem`. Die Regel nach D2[number withheld] (te ≤ [number withheld], mi > te, rl2 > [number withheld] an einem Post-Datum) steht in `10_controls.R:100–106`.
- **Abgezählte Parameter in C4 (rl1):** [number withheld] + [number withheld] × [number withheld] (z) + [number withheld] (m_roa) + [number withheld] × [number withheld] (SOE) + [number withheld] (Markt) = [number withheld]. Das stimmt mit `slope_df` überein. Die [number withheld] entfernten Terme sind die vier Fehlindikatoren ohne fehlende Werte × [number withheld] Daten. Bei jv_ta fallen zusätzlich `m_roa` für 2021-12-31 bis 2022-12-31 weg, also [number withheld]. In C2 und C3 fällt `post:m_sales` als redundant zu `m_roa` heraus, in C5 wird `post:m_roa` zur Konstante. Die neue Logik für `collinear_terms` (Z. [number withheld]–[number withheld]: angeforderte gegen geschätzte Namen, Assertion `requested = slope_df + dropped`) ist korrekt.
- **Stichprobe:** Für C1 bis C4 und die Event Study wird per Assertion geprüft, dass `obs()` identisch zu C0 ist (Z. [number withheld], [number withheld]). N und Firmenzahl in der CSV stammen aus `nobs(m)` und `obs(m)`. Für C5 ergeben sich [number withheld]/[number withheld], [number withheld]/[number withheld], [number withheld]/[number withheld], [number withheld]/[number withheld] und [number withheld]/[number withheld]. Bei jv_ta sind [number withheld] der [number withheld] markierten Firmen in der C3-Stichprobe, was zu `excluded_firms_from_C3` passt.
- **Abgleich mit T009:**
  - Die C0-Zeilen stimmen mit `t009_did_main.csv` überein; das prüft eine Assertion mit Toleranz [number withheld] (Z. [number withheld]–[number withheld]).
  - Die C0-Koeffizienten der Event Study sind identisch mit `t009_event_study.csv`. Stichprobe: rl1 2016-12-31 ergibt [number withheld], mi_share 2022-12-31 ergibt [number withheld].
  - Die C0-Vortrendtests sind identisch mit `t009_pretrend_tests.csv`: rl1 F = [number withheld], p = [number withheld]; mi_share F = [number withheld], p = [number withheld].
- **Inferenz:**
  - Die SEs sind firmengeclustert; das sichert eine Assertion auf `cov.scaled`-Typ ab. Die Freiheitsgrade sind G − [number withheld]: [number withheld], [number withheld], [number withheld] und in C5 [number withheld] bzw. [number withheld].
  - `confint` nutzt die t-Verteilung, im Einklang mit „cluster-t“ in der Abbildung.
  - Der Wald-Test verwendet ein Regex, das nur `date::<prä-Datum>:dose_pre` trifft. Assertionen prüfen, dass genau [number withheld] Terme gewählt werden und `df1 == [number withheld]`. Kontrollterme wie `date::…:z_size` werden nicht erfasst.
- **Identifikation:**
  - Die Referenzperiode 2020-06-30 ist durchgehend gleich.
  - Die Kontrollen sind Mittelwerte vor der Politik; das prüfen Assertionen auf `date` und `report_date` ≤ 2019-12-31. Es gibt keine gleichzeitigen Kontrollen.
  - Das Treatment wird nicht aus dem Outcome gebaut.
  - C5 selektiert auf Post-Outcomes; das ist als Sensitivitätsanalyse offengelegt.
- **Ausgabe:**
  - Die Stabilität ist korrekt berechnet: ([number withheld] − ([number withheld])) / [number withheld] = [number withheld] bei rl1.
  - Die TEX-Werte stimmen mit der CSV überein (gerundet auf [number withheld] Stellen). Die SE für jv_ta C4 steht als „--“.
  - Der p-Wert in der RL1-Note ([number withheld]) wird aus `pretrends` berechnet und nicht von Hand eingetragen.
  - Die REWORK-Vorgabe „keine Schätzung ändern“ ist nach den Dateien plausibel erfüllt. Nachrechnen gegen den Stand vor REWORK konnte ich nicht (siehe „Nicht geprüft“).

## Abnahmekriterien

[number withheld]. **C0 reproduziert T009 / byte-identische Builds:** Der Teil zu C0 ist belegt erfüllt (Assertion Z. [number withheld]–[number withheld], CSV-Werte, Abgleich der Event Study mit T009). Hashes der bestehenden Ausgaben und zwei identische Läufe: nicht meine Rolle. Der Code prüft die Hashes der geschützten Dateien per Assertion (Z. [number withheld]–[number withheld]).
[number withheld]. **X_i nur aus Daten ≤ 2019-12-31:** belegt erfüllt für die Finanzkontrollen (Z. [number withheld]–[number withheld], Assertions auf `date` und `report_date`). SOE und Markt sind statische Panelkategorien. Die Datierung von SOE ist als Einschränkung D9/D1[number withheld] offengelegt. Die Bewertung der Daten liegt bei der Rolle `data`.
[number withheld]. **Stabilitätsaussage und Vortrendtests, alle sechs Spalten:** belegt erfüllt, soweit es die Schätzung betrifft.
   - Es gibt [number withheld] Zellen; eine Assertion prüft, dass jede Spezifikation fünfmal vorkommt.
   - `t028_coefficient_stability.csv` deckt C3 und C4 ab.
   - Die Vortrendtests mit Kontrollen: rl1 p = [number withheld], mi_share p = [number withheld].
   - Die Hinweise auf den bedingten Vortrend bei RL1 stehen in der TEX-Note und im README (Z. [number withheld]–[number withheld]).
[number withheld]. **Fehlende X_i und in C5 ausgeschlossene Firmen gezählt:** Die Zahlen zu C5 sind belegt (`excluded_firms_base` [number withheld], `excluded_firms_from_C3`, [number withheld] bei jv_ta). Die Zählung fehlender Werte ist nicht meine Rolle.

## Nicht geprüft

- Ich habe die Skripte nicht ausgeführt (die Rolle erlaubt nur Lesen). Dass beide Läufe byte-identisch sind und die Schätzwerte dem Stand vor REWORK entsprechen, konnte ich deshalb nicht selbst nachrechnen.
- Den Inhalt der PDF-Abbildungen habe ich nicht gesichtet. Laut Code verwenden sie die Bezeichnung „C3-date“ und t-Intervalle aus `confint`.
- Die Änderung an `state/STATE.md` und die Dateien außerhalb des Schreibbereichs (`tasks/T028_verification.txt`) sind nicht meine Rolle.
- Die Datenaufbereitung (Konvention nur für Dezember-Flüsse, Balance-Gruppen, Zählung fehlender Werte) ist nicht meine Rolle.
