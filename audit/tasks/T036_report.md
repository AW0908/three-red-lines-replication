## Ergebnis
Ich habe Abschnitt 6 (`06_preliminary_analysis.tex`) nach den drei Evidenzebenen neu geschrieben: 6.1 Threshold targeting, 6.2 Composition of compliance, 6.3 Transaction-level evidence (pilot), 6.4 Supplementary exposure evidence, 6.5 Discussion. Im Haupttext stehen 3 Abbildungen und 2 kompakte, von Hand aus CSV-Werten gebaute Tabellen (Robustheit T031; offizielle vs. eingefrorene Minderheitsanteile, T029). Der Anhang „Additional Results“ ist neu aufgebaut und folgt der Gliederung von Abschnitt 6. Er bindet die vollständigen Tabellen von T023, T031, T027, T029, T009, T011, T028, T024, T025 und T015 per `\input` ein, außerdem `t031_grid.pdf`, `t029_distance_es.pdf`, `t027_decomposition_rl1.pdf` und die bisherigen Event-Study-, SOE- und RL2/RL3-Abbildungen, jeweils mit einem Einleitungssatz. Abschnitt 6.3 enthält keine Fälle, weil keine PI-verifizierten Fälle vorliegen; dort stehen nur das Pilotdesign und `% TODO(PI)`.

## Dateien
- `proposal/sections/06_preliminary_analysis.tex` – Abschnitt 6 vollständig neu (ca. 1.640 Wörter Fließtext ohne Kommentare, Tabellen und Bildunterschriften; Budget 1.800). Die Labels `subsec:bunching`, `subsec:did_main` und `subsec:heterogeneity` bleiben erhalten, weil `03_framework.tex` auf sie verweist.
- `proposal/appendix/results.tex` – Anhang neu, mit Unterabschnitten `app:res_targeting`, `app:res_composition` und `app:res_exposure` sowie `\extrafloats{100}` und `\clearpage` vor den Blöcken mit sehr vielen Tabellen-Floats.

## Ausführung
Ich hatte keinen Shell-Zugriff (Worker ohne Bash), daher konnte ich nicht kompilieren. Der Kopierbefehl aus der Karte (Abschnitt „Before the worker starts“) ist **noch nicht ausgeführt**: In `proposal/tables/` und `proposal/figures/` fehlen t023_*, t027_*, t029_*, t031_*, t028_*, t024_*, t025_* sowie die sechs neuen PDFs. Ohne diese Dateien bricht `main.tex` an `\input`/`\includegraphics` ab.

## Abnahmekriterien
1. **Zahlen stimmen mit den CSVs überein:** erfüllt nach eigener Prüfung. Über jedem Absatz steht ein `% source:`-Kommentar mit Datei, Zeile und Spalte. Liste der Zahlen im neuen Text:
   - `t023_excess_mass.csv`: Nachperiode 3.14 [1.01, 5.84], N 630, 132 Firmen, beobachtet 118 vs. vorhergesagt 66.1; Vorperiode −0.88 [−1.85, 0.43]; Spezifikationsspanne 2.41–3.97; rl1_alt 0.00 [−1.15, 1.39], Schwelle 0.53.
   - `t031_support.csv`: 118 Firmen-Halbjahre, 43 Firmen, höchstens 5 je Firma.
   - `t031_leave_one_out.csv`: Spanne 2.84–3.31.
   - `t031_grid.csv`: 63 von 72.
   - `t031_samples.csv`: 3.24 [1.02, 6.19] bei 115 Firmen; 3.10 [0.93, 5.56] bei 124 Firmen.
   - `t031_timing.csv`: 3.54 [1.11, 6.76]; 1.74 [−0.67, 4.99]; −0.275 [−0.637, 0.088]; −0.197 [−0.389, −0.004].
   - `t023_reversal.csv`: 55.6 / 23.0 Prozent, −32.6 [−53.7, −12.7]; Vergleichsbin 17.3 / 18.0 Prozent.
   - `t024_rd_validity.csv`: −2.83, p = 0.218; Binomialtests in 4 von 10 Fenstern p < 0.05.
   - `t027_decomposition_rl1.csv` und `t027_tests.csv`: 33 Ereignisse/31 Firmen und 21/19; −0.107 von −0.162 sowie −0.154 von −0.218; 69.7 / 57.1 Prozent; 0.54 vs. 0.18, Differenz 0.37 [−0.11, 0.75]; 66.7 / 57.1 Prozent.
   - `t029_counterfactual_bunching.csv`: 602 Beobachtungen, 129 Firmen; 3.18 [1.01, 6.01]; −0.52 [−1.83, 1.08]; Differenz 3.71 [1.60, 6.14].
   - `t029_compliance.csv`: 28 ausgeschlossene Beobachtungen; 51.2 / 39.7 / 11.5 Prozent mit KIs; Placebo 48.5 / 44.5 / 4.1 mit KIs, 616 Beobachtungen, 125 Firmen; Differenz Post minus Placebo 7.4 [3.1, 11.8]; 7.0 und 16.8 Punkte nach Stichtag; 24.4 [16.1, 33.1] vs. 10.4 Prozent.
   - `t009_did_main.csv`: −0.0149 (0.0101), −0.284 (0.145), 0.0210 (0.0147).
   - `t028_controls_did.tex` und `t028_pretrend_controls.csv`: −0.0486 (0.0127), p = 0.0002.
   - `t024_rd_main.csv` und `t024_rd_robustness.csv`: 28 Firmen unter / 44 über der Schwelle; −0.39 [−0.82, 0.06], p = 0.095; RL1 0.035 [−0.008, 0.179]; RL2 0.50 → 0.02; Minderheitsanteil 0.035 → −0.032.
   - `t025_selection.csv`: IPW −0.0152, −0.335, 0.0198.
2. **writing_rules und Vorbehalte:** erfüllt. Die zentrale Aussage steht wörtlich im Text, mit dem Zusatz „not causal / not economic leverage“. Die Vorbehalte sind enthalten: Vorperioden-Trend aus Teil B, Gitter 63/72, schwächerer Umkehrbefund unter Modellen mit exakter Distanz. Die Identifikationsannahmen stehen im selben Absatz wie die jeweilige Aussage: glatte Dichte bei 0.70, Parallel Trends, Stetigkeit für die RD, fehlende kausale Lesart für das eingefrorene Kontrafaktum. Keine Aufzählungslisten.
3. **Kein unverifiziertes handerhobenes Material:** erfüllt. `transactions.csv` und `case_notes.md` existieren nicht, und T033 ist nicht geliefert. Den Huafa-Fall aus STATE (noch nicht PI-verifiziert) und den Kaisa-Wert aus T032 habe ich nicht verwendet.
4. **Budget erfüllt; Kompilieren offen:** Das Budget ist eingehalten (≈1.640 von 1.800 Wörtern, 6.4 ≈245 von 300, 6.5 ≈235 von 250, 3 Abbildungen, 2 Tabellen). Ob `main.tex` fehlerfrei kompiliert, ist **nicht geprüft**. Das muss der PI tun, nachdem er die Dateien kopiert hat.

## Offene Fragen
- **„About 70 percent“ (T027) steht in keiner CSV als einzelne Zahl.** Das Verhältnis der Mediane ergibt ca. 66 % (post) bzw. 71 % (pre), aber Mediane sind nicht additiv. Ich habe deshalb die Medianwerte direkt angegeben und zusätzlich den Anteil „Eigenkapital > Hälfte des Rückgangs“ (69.7 / 57.1 %).
- **Gitter: STATE stimmt nicht mit der CSV überein.** STATE nennt als Ursache der 9 nicht signifikanten Zellen „u. a. breitere 0,02-Bins“. Laut CSV liegen sie gleichmäßig auf alle Bin-Breiten verteilt (je 3) und haben alle das weiteste Ausschlussfenster [0.65, 0.70) mit Grad 7 oder Grad 5 auf [0.50, 0.90]. Der Text folgt der CSV.
- **Vorzeichen der RD für RL1:** Der Punktschätzer ist positiv (+0.035). Ich habe geschrieben „no differential decline“ und die Schuldenreduktion nur über log interest-bearing debt belegt.
- **Abschnitt 6.3:** `% TODO(PI): insert verified cases` mit Fußnoten (Firma, Datum, Titel), sobald T033 geliefert und vom PI verifiziert ist. Die Perpetual-Frage in 6.5 ist allgemein formuliert, ohne T032-Firma und ohne Zahl.
- **Anhang:**
  - `t023_excess_mass` (drei Teiltabellen mit langer Note) steckt in einer einzigen Float und könnte „Float too large“ auslösen. Das ist nur eine Warnung.
  - `\extrafloats` setzt einen LaTeX-Kernel ab 2015 voraus (Overleaf erfüllt das).
  - Die Floats aus T027/T029 haben kein Label. Der Text verweist deshalb auf den Unterabschnitt `app:res_composition`.
- **Altes Material:** `t005_bunching_rl1.pdf` und die frühere SOE-Diskussion habe ich aus dem Haupttext entfernt. Die SOE-Abbildung und -Tabelle stehen jetzt im Anhang. Die Verweise in `03_framework.tex` bleiben auflösbar; ihr Wortlaut („H3/H4“ usw.) gehört zu T035.
- **AI-Log:** Ein Eintrag in `AI_USAGE_LOG.md` für diese Schreibkarte steht noch aus (Co-PI/PI).
