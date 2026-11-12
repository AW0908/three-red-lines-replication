## Rolle: consistency (claude, sonnet) – VERDICT: PASS


Ich prüfe nur Übereinstimmung von Outputs, Tabellen und Bericht (Consistency-Rolle). Ich konnte nur lesen: Bash wurde mir verweigert, ich habe nichts ausgeführt.

## Befunde
Keine inhaltlichen Inkonsistenzen gefunden. Kleinere Hinweise, alle ohne Rework-Bedarf:

1. `AI_USAGE_LOG.md` enthält keinen T055-Eintrag (Grep ohne Treffer). Der Bericht schlägt den Eintrag selbst für die Zeit nach der Abnahme vor. Das ist Sache des Co-PI.
2. `b_official_paired` in `t055_linear_trend.csv` ist 3,1818, die Reproduktion der vollen Stichprobe ist 3,1429. Der Bericht nennt den Grund, nämlich gepaarte gegenüber voller Stichprobe. b(κ=0) = 3,1818 stimmt damit überein.
3. Die Placebo-Zeilen der Linear-Trend-Tabelle sind „unavailable" (N=0). Das ist als Status ausgewiesen und im Bericht benannt. Es ist keine Inkonsistenz, aber im Text (T056) ehrlich als „nicht schätzbar" zu führen.

## Abnahmekriterien
- **Kriterium 2 (Varianten, N/Firmen, κ-Raster): belegt erfüllt.**
  - Das κ-Raster hat 11 Werte × 2 Kennzahlen × 2 Perioden = 44 Zeilen (`t055_kappa.csv`). Die `.tex`-Fassung zeigt dieselben Zahlen, zum Beispiel b(0) = 3,1818 [1,0105; 6,0136].
  - Shift, Falsifikation und Trend sind vollständig. Das T009-Fehlen von N und Firmen ist als „--" gekennzeichnet und nicht erfunden.
- **Zahlen im Bericht gegen die CSVs: belegt erfüllt.**
  - Shift: 1,4600 gegenüber 1,8305, Differenz −0,3704 [−1,0358; 0,2790]. D reweighted: 0,1444, Differenz 0,0426 [−0,0410; 0,1243].
  - κ: b fällt von 3,1818 auf −1,1228, Compliance von 51,16 % auf 36,71 %.
  - κ*: Punkt 0,2765, linear zwischen 0,2 und 0,3 nachgerechnet, CI 0,0875 nachgerechnet.
  - Falsifikation: 3,1429 gegenüber −0,2013, Unterschied 3,3441 [0,3171; 6,5782], Δ-Differenz 2,9108 [−0,5880; 6,2459].
  - Trend: D_trend 0,0133, b_trend 1,3547, Bin-Variante 0,0365 und −0,0961.
  - Prätrend: p = 0,000222545565783325.
- **Kopierte Prätrendtests: belegt erfüllt.** Alle 9 Zeilen in `t055_pretrend_tests.csv` und `.tex` stimmen mit `t009_pretrend_tests.csv` und `t028_pretrend_controls.csv` überein (F, df, p, N, Firmen).
- **Textaussagen: belegt erfüllt.** Die Deutungen im Bericht überziehen nicht. Kein Post-Anstieg bei der dichteunabhängigen Kennzahl, die Falsifikationsdifferenz der Anstiege ist unklar, und die Trend-KIs enthalten null.
- **Kriterium 1 (Reproduktion, Bytegleichheit) und Kriterium 3 (keine Handdaten): nicht meine Rolle.** Die Behauptungen im Bericht habe ich nicht unabhängig verifiziert.

## Nicht geprüft
- Code-Korrektheit, Daten und Bootstrap-Implementierung (Rollen `data` und `estimation`).
- Bytegleichheit der Läufe und Hashes in `t055_verification.csv`; dafür hätte ich Befehle ausführen müssen.
- Die Abbildung `t055_kappa.pdf`.
- `t055_mi_shift.tex`, `t055_linear_trend.tex`, die übrigen Hilfstabellen und `t055_number_map.csv` habe ich nicht Zeile für Zeile gegen die CSVs abgeglichen.
- Inhalt von `README.md`, `run_all.R` und `run_all.sh`. Die Einbindung von Schritt 19 als letzter Schritt habe ich nicht verifiziert (der Befehl dafür wurde verweigert).
- Es gibt noch keinen Proposal-Text mit T055-Zahlen, daher gab es keine `\ref`/`\cite`-Querverweise zu prüfen. Das folgt in T056/T057.
