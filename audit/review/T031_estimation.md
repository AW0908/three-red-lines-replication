## Rolle: estimation (claude, opus) – VERDICT: PASS


## Befunde

Ich habe keinen inhaltlichen Fehler in den Schätzungen gefunden. Die folgenden Punkte blockieren die Abnahme nicht. Sie sind nach Gewicht geordnet.

1. **Sehr dünne Zellen im LPM bei Timing (iii) „2020H2 allein“.**
   - **Beleg:** In `t031_timing.csv` stammen die Kontraste `bins001` bei Distanz 0,015 und 0,025 im Post-Teil jeweils von nur 3 Firmen (`firms_post = 3`). Insgesamt gibt es 29 Post-Beobachtungen.
   - **Problem:** Das KI bei 0,015 ([−0,772; −0,287]) schließt null aus. Es beruht aber auf einem CR1-Sandwich, das im Post-Bin praktisch nur 3 Cluster hat. Die t-Freiheitsgrade sind G−1 über alle Cluster der Regression und überzeichnen damit die effektive Information im Kontrast (Code: `12_q1_robustness.R:280–294`).
   - **Folge:** Die Rechnung entspricht der Karte und dem T023-Vorgehen. Im Text sollten diese Zellen aber nicht als Beleg zählen. Der Bericht des Workers stützt seine Timing-Aussage nicht auf diese Zellen, daher ist das nur ein Hinweis für die Schreibkarte.

2. **Spalten mit gemischter Bedeutung in `t031_timing.csv`.**
   - **Beleg:**
     - In den LPM-Zeilen (`firm_cluster_CR1_t`) enthalten `n_pre`/`n_post` die Fallzahl der ganzen Regression, z. B. 148/144.
     - `firms_pre`/`firms_post` enthalten dagegen die Firmenzahl im ausgewerteten Distanz-Bin, z. B. 15/21 (Code Z. 399–400: `z$n_pre`, `z$bin_firms_pre`).
     - In den Zeilen `b_post` und `T023_near` beziehen sich beide Spaltenpaare auf dieselbe Stichprobe.
   - **Folge:** Die Werte sind richtig übertragen, die Spaltennamen aber irreführend. Das kann beim Zitieren von N und Firmenzahl zu Fehlern führen. Ich empfehle eine Umbenennung (z. B. `bin_firms_*`) in einer späteren Doku-Überarbeitung.

3. **Gitter mit 0,02-Bins: Die vorgegebenen Fenster werden nicht genau getroffen.**
   - **Beleg:** `t031_grid.csv` Z. 50–67:
     - Das nominelle Fenster [0,67; 0,70) wird zu [0,66; 0,70). Die Spezifikationen 49–54 sind deshalb mit 55–60 identisch.
     - Das nominelle Fenster [0,65; 0,70) wird zu [0,64; 0,70) (Spalten `actual_*`).
   - Das folgt aus der Mittelpunktregel von T023 und ist offen ausgewiesen. Es ist kein Fehler.
   - **Folge:** Die Spezifikationen 64–66 (KI enthält null) messen tatsächlich ein breiteres Fenster als vorgegeben. Das sollte man wissen, wenn man den Anteil 63/72 = 87,5 % interpretiert.

4. **Die Gitterabbildung hat eine gemeinsame y-Achse für drei verschiedene Bin-Einheiten** (`facet_wrap(..., scales = "free_x")`, Z. 246). Die Bildunterschrift weist darauf hin. Optisch wirken die 0,005-Werte dadurch größer. Das ist kein Schätzfehler.

### Geprüft und korrekt

- **T023-Reproduktion:**
  - Der Schätzer `mass_fit` entspricht `06_bunching_tests.R` Z. 378–444: dieselben Bins, `poly()`-Basis, Ausschluss und Masse nach Bin-Mittelpunkt, Neuschätzung in jeder Ziehung, Gültigkeitsregel, b = Exzess / mittlere kontrafaktische Bin-Zahl.
  - Die Bootstrap-Gewichte werden mit demselben Seed und in derselben Reihenfolge erzeugt (`set.seed`, dann `replicate(tabulate(sample.int))`).
  - Ein Assert prüft b, SE, KI, gültige Ziehungen, n und Firmenzahl gegen `t023_excess_mass.csv` mit Toleranz 1e‑10 (Z. 113–121). `t031_baseline.csv` stimmt damit überein: post b = 3,142855, KI [1,012; 5,841].
- **Leave-one-out:**
  - Δb wird gegen b_post der Baseline gebildet.
  - Die fünf einflussreichsten Firmen sind konsistent: beobachtet 113 = 118 − 5, kontrafaktische Masse unverändert 66,08, also Δb = −5/16,52 = −0,3027.
  - Gleichstände werden deterministisch aufgelöst.
- **Stichproben:**
  - B (balanciert): n_pre 690 = 115 × 6, n_post 575 = 115 × 5.
  - C (mindestens 3 Beobachtungen je Periode): Filter wie in der Karte.
  - Jede Stichprobe zieht im Bootstrap aus ihrer eigenen Firmenmenge.
- **Gitter:**
  - 72 Zellen in fester Indexreihenfolge, genau eine Baseline (Index 33), identisch mit T023.
  - Das breite Fenster [0,66; 0,72) schließt Bins aus, zählt Masse aber nur unterhalb von 0,70, wie die T023-Spezifikation „wide“.
  - Die Umrechnung `b_in_001_bins = b·w/0,01` ist korrekt.
- **Umkehrtest nach exakter Distanz:**
  - Die Zuordnung Bin ↔ Distanz ist korrekt ([0,69; 0,70) ↔ (0; 0,01]).
  - Beide Modelle sind voll mit Post interagiert: 10 Bin-Dummies ohne Konstante bzw. Konstante plus Distanz.
  - Post-minus-Pre-Kontrast: L = design(post) − design(pre).
  - CR1 = G/(G−1)·(N−1)/(N−K), t(G−1); das entspricht fixest.
  - Prüfung der Schätzbarkeit bei Rangdefizit ist vorhanden.
  - Ergebnis: 1(nächstes RL1 > 0,70), streng größer, ohne Überbrücken von Lücken.
- **Timing:**
  - Die Post-Masken entsprechen (i), (ii) und (iii); Pre ist immer 2017H1–2019H2.
  - Die Zeile `T023_near` für (i) stimmt exakt mit `t023_reversal.csv` Z. 8 überein (−0,326047; [−0,5366; −0,1271]).
- **Übertragung in die TEX-Dateien:** Stichprobenweise geprüft, ob `t031_samples.tex`, `t031_reversal_distance.tex` und `t031_timing.tex` mit den CSV-Werten übereinstimmen. Sie stimmen.

## Abnahmekriterien

1. **T023 reproduziert (Assert): belegt erfüllt.** Belege: Code Z. 113–121, `t031_baseline.csv`, `t031_verification.txt` Z. 9 und 20. Byte-Gleichheit der bestehenden Ausgaben und zweier Läufe: nicht meine Rolle (consistency/data). Laut `t031_verification.txt` belegt; den Hash-Vergleich habe ich nicht selbst nachgerechnet.
2. **Alle Gitterzellen und Stichproben berichtet, nur die Baseline hervorgehoben: belegt erfüllt.**
   - 72 Zeilen in `t031_grid.csv`, `sum(baseline) == 1` per Assert (Z. 232–233).
   - 6 Zeilen in `t031_samples.csv`.
   - Die Abbildung markiert nur die Baseline (Code Z. 241–245).
3. **Klare Aussage je Check: belegt erfüllt, soweit es die Schätzungen betrifft.** Die Aussagen im Bericht (LOO 115/115, Stichproben 3/3, Gitter 63/72, Distanz binned 2/3 und linear 3/3, Timing (iii) b nicht gesichert) stimmen mit den CSV-Dateien überein. Einschränkung: siehe Befund 1. Formulierung und Sprache: nicht meine Rolle.

## Nicht geprüft

- Ich habe keine Befehle ausgeführt, weil Bash in diesem Lauf gesperrt war. Die Reproduktion der Zahlen, die SHA-256-Vergleiche und die unabhängigen fixest-Prüfungen des Workers habe ich nicht nachgerechnet. Ich habe sie nur über die Konsistenz von Code und CSV-Werten plausibilisiert.
- Ich habe die PDF-Abbildungen nicht visuell geprüft.
- Datenaufbereitung (`panel_firm_halfyear.csv`, Definition von RL1 und `sample_main`): Rolle `data`. Das gilt auch für die nach dem Build geänderte `state/STATE.md` und die T032-Hinweise zur Perpetual-Behandlung in RL1.
- Schreibbereich und die vom Skript gemeldeten geänderten Dateien außerhalb davon: Rolle `consistency`.
