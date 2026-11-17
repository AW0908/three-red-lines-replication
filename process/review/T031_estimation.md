## Rolle: estimation (claude, opus) – VERDICT: PASS


## Befunde

Ich habe keinen inhaltlichen Fehler in den Schätzungen gefunden. Die folgenden Punkte blockieren die Abnahme nicht. Sie sind nach Gewicht geordnet.

[number withheld]. **Sehr dünne Zellen im LPM bei Timing (iii) „[number withheld]H2 allein“.**
   - **Beleg:** In `t031_timing.csv` stammen die Kontraste `bins0[number withheld]` bei Distanz [number withheld] und [number withheld] im Post-Teil jeweils von nur [number withheld] Firmen (`firms_post = [number withheld]`). Insgesamt gibt es [number withheld] Post-Beobachtungen.
   - **Problem:** Das KI bei [number withheld] ([[number withheld]; [number withheld]]) schließt null aus. Es beruht aber auf einem CR1-Sandwich, das im Post-Bin praktisch nur [number withheld] Cluster hat. Die t-Freiheitsgrade sind G−[number withheld] über alle Cluster der Regression und überzeichnen damit die effektive Information im Kontrast (Code: `12_q1_robustness.R:280–294`).
   - **Folge:** Die Rechnung entspricht der Karte und dem T023-Vorgehen. Im Text sollten diese Zellen aber nicht als Beleg zählen. Der Bericht des Workers stützt seine Timing-Aussage nicht auf diese Zellen, daher ist das nur ein Hinweis für die Schreibkarte.

[number withheld]. **Spalten mit gemischter Bedeutung in `t031_timing.csv`.**
   - **Beleg:**
     - In den LPM-Zeilen (`firm_cluster_CR1_t`) enthalten `n_pre`/`n_post` die Fallzahl der ganzen Regression, z. B. [number withheld]/[number withheld].
     - `firms_pre`/`firms_post` enthalten dagegen die Firmenzahl im ausgewerteten Distanz-Bin, z. B. [number withheld]/[number withheld] (Code Z. [number withheld]–[number withheld]: `z$n_pre`, `z$bin_firms_pre`).
     - In den Zeilen `b_post` und `T0[number withheld]_near` beziehen sich beide Spaltenpaare auf dieselbe Stichprobe.
   - **Folge:** Die Werte sind richtig übertragen, die Spaltennamen aber irreführend. Das kann beim Zitieren von N und Firmenzahl zu Fehlern führen. Ich empfehle eine Umbenennung (z. B. `bin_firms_*`) in einer späteren Doku-Überarbeitung.

[number withheld]. **Gitter mit [number withheld]-Bins: Die vorgegebenen Fenster werden nicht genau getroffen.**
   - **Beleg:** `t031_grid.csv` Z. [number withheld]–[number withheld]:
     - Das nominelle Fenster [[number withheld]; [number withheld]) wird zu [[number withheld]; [number withheld]). Die Spezifikationen [number withheld]–[number withheld] sind deshalb mit [number withheld]–[number withheld] identisch.
     - Das nominelle Fenster [[number withheld]; [number withheld]) wird zu [[number withheld]; [number withheld]) (Spalten `actual_*`).
   - Das folgt aus der Mittelpunktregel von T023 und ist offen ausgewiesen. Es ist kein Fehler.
   - **Folge:** Die Spezifikationen [number withheld]–[number withheld] (KI enthält null) messen tatsächlich ein breiteres Fenster als vorgegeben. Das sollte man wissen, wenn man den Anteil [number withheld]/[number withheld] = [number withheld] % interpretiert.

[number withheld]. **Die Gitterabbildung hat eine gemeinsame y-Achse für drei verschiedene Bin-Einheiten** (`facet_wrap(..., scales = "free_x")`, Z. [number withheld]). Die Bildunterschrift weist darauf hin. Optisch wirken die [number withheld]-Werte dadurch größer. Das ist kein Schätzfehler.

### Geprüft und korrekt

- **T023-Reproduktion:**
  - Der Schätzer `mass_fit` entspricht `06_bunching_tests.R` Z. [number withheld]–[number withheld]: dieselben Bins, `poly()`-Basis, Ausschluss und Masse nach Bin-Mittelpunkt, Neuschätzung in jeder Ziehung, Gültigkeitsregel, b = Exzess / mittlere kontrafaktische Bin-Zahl.
  - Die Bootstrap-Gewichte werden mit demselben Seed und in derselben Reihenfolge erzeugt (`set.seed`, dann `replicate(tabulate(sample.int))`).
  - Ein Assert prüft b, SE, KI, gültige Ziehungen, n und Firmenzahl gegen `t023_excess_mass.csv` mit Toleranz [number withheld]e‑[number withheld] (Z. [number withheld]–[number withheld]). `t031_baseline.csv` stimmt damit überein: post b = [number withheld], KI [[number withheld]; [number withheld]].
- **Leave-one-out:**
  - Δb wird gegen b_post der Baseline gebildet.
  - Die fünf einflussreichsten Firmen sind konsistent: beobachtet [number withheld] = [number withheld] − [number withheld], kontrafaktische Masse unverändert [number withheld], also Δb = [number withheld]/[number withheld] = [number withheld].
  - Gleichstände werden deterministisch aufgelöst.
- **Stichproben:**
  - B (balanciert): n_pre [number withheld] = [number withheld] × [number withheld], n_post [number withheld] = [number withheld] × [number withheld].
  - C (mindestens [number withheld] Beobachtungen je Periode): Filter wie in der Karte.
  - Jede Stichprobe zieht im Bootstrap aus ihrer eigenen Firmenmenge.
- **Gitter:**
  - [number withheld] Zellen in fester Indexreihenfolge, genau eine Baseline (Index [number withheld]), identisch mit T023.
  - Das breite Fenster [[number withheld]; [number withheld]) schließt Bins aus, zählt Masse aber nur unterhalb von [number withheld], wie die T023-Spezifikation „wide“.
  - Die Umrechnung `b_in_0[number withheld]_bins = b·w/[number withheld]` ist korrekt.
- **Umkehrtest nach exakter Distanz:**
  - Die Zuordnung Bin ↔ Distanz ist korrekt ([[number withheld]; [number withheld]) ↔ ([number withheld]; [number withheld]]).
  - Beide Modelle sind voll mit Post interagiert: [number withheld] Bin-Dummies ohne Konstante bzw. Konstante plus Distanz.
  - Post-minus-Pre-Kontrast: L = design(post) − design(pre).
  - CR1 = G/(G−[number withheld])·(N−[number withheld])/(N−K), t(G−[number withheld]); das entspricht fixest.
  - Prüfung der Schätzbarkeit bei Rangdefizit ist vorhanden.
  - Ergebnis: \[number withheld](nächstes RL1 > [number withheld]), streng größer, ohne Überbrücken von Lücken.
- **Timing:**
  - Die Post-Masken entsprechen (i), (ii) und (iii); Pre ist immer [number withheld]H1–[number withheld]H2.
  - Die Zeile `T0[number withheld]_near` für (i) stimmt exakt mit `t023_reversal.csv` Z. [number withheld] überein ([number withheld]; [[number withheld]; [number withheld]]).
- **Übertragung in die TEX-Dateien:** Stichprobenweise geprüft, ob `t031_samples.tex`, `t031_reversal_distance.tex` und `t031_timing.tex` mit den CSV-Werten übereinstimmen. Sie stimmen.

## Abnahmekriterien

[number withheld]. **T023 reproduziert (Assert): belegt erfüllt.** Belege: Code Z. [number withheld]–[number withheld], `t031_baseline.csv`, `t031_verification.txt` Z. [number withheld] und [number withheld]. Byte-Gleichheit der bestehenden Ausgaben und zweier Läufe: nicht meine Rolle (consistency/data). Laut `t031_verification.txt` belegt; den Hash-Vergleich habe ich nicht selbst nachgerechnet.
[number withheld]. **Alle Gitterzellen und Stichproben berichtet, nur die Baseline hervorgehoben: belegt erfüllt.**
   - [number withheld] Zeilen in `t031_grid.csv`, `sum(baseline) == [number withheld]` per Assert (Z. [number withheld]–[number withheld]).
   - [number withheld] Zeilen in `t031_samples.csv`.
   - Die Abbildung markiert nur die Baseline (Code Z. [number withheld]–[number withheld]).
[number withheld]. **Klare Aussage je Check: belegt erfüllt, soweit es die Schätzungen betrifft.** Die Aussagen im Bericht (LOO [number withheld]/[number withheld], Stichproben [number withheld]/[number withheld], Gitter [number withheld]/[number withheld], Distanz binned [number withheld]/[number withheld] und linear [number withheld]/[number withheld], Timing (iii) b nicht gesichert) stimmen mit den CSV-Dateien überein. Einschränkung: siehe Befund [number withheld]. Formulierung und Sprache: nicht meine Rolle.

## Nicht geprüft

- Ich habe keine Befehle ausgeführt, weil Bash in diesem Lauf gesperrt war. Die Reproduktion der Zahlen, die SHA-[number withheld]-Vergleiche und die unabhängigen fixest-Prüfungen des Workers habe ich nicht nachgerechnet. Ich habe sie nur über die Konsistenz von Code und CSV-Werten plausibilisiert.
- Ich habe die PDF-Abbildungen nicht visuell geprüft.
- Datenaufbereitung (`panel_firm_halfyear.csv`, Definition von RL1 und `sample_main`): Rolle `data`. Das gilt auch für die nach dem Build geänderte `state/STATE.md` und die T032-Hinweise zur Perpetual-Behandlung in RL1.
- Schreibbereich und die vom Skript gemeldeten geänderten Dateien außerhalb davon: Rolle `consistency`.
