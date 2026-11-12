## Rolle: estimation (claude, opus) – VERDICT: PASS


## Befunde
Keine inhaltlichen Fehler in den Schätzungen gefunden. Die folgenden Hinweise sind nicht blockierend und nach Gewicht geordnet:

1. **Break-even im Placebo wird als „0“ ausgewiesen, ist aber kein Schwellenwert.** In `t055_kappa_break_even.csv` stehen für das Placebo `kappa_point=0` und `kappa_CI=0`. Das heißt nur: b ist schon bei κ=0 negativ (−1.0078), und das KI [−2.0442; 0.4142] enthält bereits null. Der Status steht daneben (`already_nonpositive_at_zero`, `CI_includes_zero_at_zero`), auch in der Fußnote von `t055_kappa.tex`. Im Text (T056) darf diese Zeile nicht als „Placebo κ* = 0“ neben das Post-κ* gestellt werden.
2. **b(κ=0) = 3.1818 statt 3.1429.** Das κ-Raster nutzt die gepaarte Stichprobe (602/129), die Headline-Zahl die volle Post-Stichprobe (630/132; `t055_falsification.csv`, `b_RL1`, post). Das ist richtig so, weil alle κ-Werte dieselbe Population brauchen, und es ist dokumentiert. Im Text muss aber klar sein, welches b gemeint ist.
3. **„Firms with reported RL1 in [0.60, 0.80]“ ist pro Firma-Halbjahr umgesetzt, nicht pro Firma** (`19_referee3.R:147`, `:160`). Das ist eine vertretbare Lesart, und die Tabellennote nennt sie. Ich habe keine Firmenvariante gefunden.
4. **b(κ) fällt im Post-Zeitraum nicht monoton.** Bei κ=0.6 liegt es bei −0.9712, bei κ=0.7 bei −0.7267 (`t055_kappa.csv`). Die Interpolation sucht deshalb ausdrücklich die erste Nullstelle ohne Monotonieannahme. Das ist korrekt und gekennzeichnet.
5. **Die Kontraste zum linearen Placebo-Trend sind nicht schätzbar.** Grund: keine Spenderfirmen mit Vorgeschichte (0/0 in `t055_linear_trend.csv`). Das entspricht T043 (`t043_trend_cf.csv`, Placebo-Anker NA) und ist ausgewiesen, nicht unterschlagen.

## Geprüfte Spezifikation (Estimation)
- **Bunching-Schätzer** (`19_referee3.R:36–52`): Er stimmt mit T043/T023 überein (`15_referee2.R:33–66`): Bins 0.01 über [0.40, 1.00], Polynom Grad 5 ohne das Fenster [0.66, 0.70), b = (obs − cf)/(cf/4). Im Bootstrap wird pro Ziehung neu geschätzt (`qr.coef` auf der Gewichtsmatrix).
- **Bootstrap**: `set.seed(20261016)` wird direkt vor `replicate` gesetzt, dazwischen gibt es keinen RNG-Aufruf. Die 999 Firmen-Gewichtsvektoren sind daher dieselben wie in T043. Alle Kontraste (post − placebo, RL1 − raw, post − pre) entstehen innerhalb derselben Ziehung, sind also gemeinsam bzw. gepaart gebootstrappt, wie die Karte verlangt.
- **Reproduktion**: b_post = 3.1429 und D = 0.1146 werden assertiert (Zeile 67–70), D zusätzlich gegen `t029_compliance.csv` mit Toleranz 1e-12. b_pre = −0.8772 stimmt mit der T043-Assertion −0.88 überein.
- **Schritt 1**: s = 100·(F − R), also frozen minus reported, Vorzeichen korrekt. Die IPW-Gewichte p_k/q_k in 0.02-Bins habe ich an `t055_mi_reweight_bins.csv` nachgerechnet, sie sind plausibel. Kein Zielbin ist ohne Placebo-Stützung. Der Kontrast ist eingeschränktes Post-D minus gewichtetes eingeschränktes Placebo-D, also gleiche Population auf beiden Seiten.
- **Schritt 2**: R(κ) = (N + κ·max(ΔMI, 0))/(N + E). Das ist die Formel der Karte, und E = te enthält MI (konsistent mit dem Nenner beim Einfrieren). Für κ=0 wird R(0) = R assertiert. Die Interpolation habe ich nachgerechnet:
  - Punkt: 0.2 + 0.1·0.7440/(0.7440 + 0.2289) = 0.27648 ✓
  - KI-Untergrenze: 0.1·1.0105/(1.0105 + 0.1450) = 0.08745 ✓
- **Schritt 3**: raw = tl/ta, `rl1_alt` wird nicht verwendet. Die Stichprobe ist für beide Definitionen identisch (assertiert in Zeile 236). Die RL1-Werte stimmen mit b0/bp überein (Zeile 249–250).
- **Schritt 4**: Die Umsetzung entspricht T043 Schritt 7 (`15_referee2.R:624–675`), nur ist `mi_anchor·exp(g·t)` durch `mi_anchor + slope·t` ersetzt. Die Steigung kommt aus einer OLS über 2016H2–2019H2 (mindestens 4 Beobachtungen, kein MI ≤ 0). Bin-Fallback, Fenster und Anker-MI sind dieselben wie in T043.
- **Schritt 5**: Alle 9 Zeilen in `t055_pretrend_tests.csv/.tex` stimmen Wert für Wert mit `t009_pretrend_tests.csv` und `t028_pretrend_controls.csv` überein (F, df, p, N). Das gilt auch für C3-date: p = 0.000222545565783325, F = 4.3894, df = 7,123, N = 1544/124. Es wurde nichts neu geschätzt.
- **Übertragung in die TeX-Tabellen**: Stichprobe geprüft, nämlich κ=0 und κ=0.3 für Post und Placebo, die Kontraste in `mi_shift` und die Zeilen in `falsification`. Alles entspricht den CSV-Zeilen. `bootstrap_draws.csv` hat 88 911 Zeilen = 89 Ergebniszeilen × 999 ✓.

## Abnahmekriterien
1. **Reproduktion, bytegleiche bestehende Outputs, zwei bytegleiche Läufe:** teilweise belegt. Die Reproduktions-Assertions stehen im Code und passen zu den abgelegten Werten. Die Hash-Prüfung der Eingaben und der bestehenden Outputs (Zeile 414–415) und der Vergleich der Wiederholung (Zeile 423–429) sind im Code vorhanden. Dass beide Läufe tatsächlich bytegleich waren, kann ich nicht selbst prüfen (siehe unten).
2. **Alle vorab festgelegten Varianten, N und Firmen bei jeder Schätzung, vollständiges κ-Raster:** belegt erfüllt. 16 Shift-, 44 κ- (2 Zeiträume × 11 κ × 2 Kennzahlen), 9 Falsifikations- und 20 Trendzeilen, alle mit n und firms bzw. benchmark_n und benchmark_firms. Die Placebo-Trends stehen als NA mit Status in der Tabelle.
3. **Keine Handdaten verwendet oder verändert:** belegt, soweit es meine Rolle betrifft. Die Eingabeliste (Zeile 7–11) enthält keine Handdaten. Die Datenaufbereitung selbst ist nicht meine Rolle.

## Nicht geprüft
- Ob zwei Läufe tatsächlich bytegleich waren und ob die SHA-256-Werte in `t055_verification.csv` stimmen: Als Reviewer führe ich keine Befehle aus.
- Ob `te`, `adv`, `mi`, `tl` und `ta` im Panel richtig gebildet sind: Das ist Aufgabe der Rolle `data`.
- Ob die Zahlen im Bericht zum Text passen, die Abbildung `t055_kappa.pdf` und die Änderungen an README und run_all: Das ist Aufgabe der Rolle `consistency`.
