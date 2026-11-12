## Ergebnis
Ich habe die vier Punkte aus `review/T020.md` behoben, die laut „Co-PI feedback (after ESCALATE)“ offen waren (Befund 1 war ein Fehler in der Karte; 184/172/136/124 bleibt so). In 4.3 wird nicht mehr behauptet, die kosmetischen Outcomes seien frei vom mechanischen Zusammenhang. Dort steht jetzt: rl2\_gap $= P(1+\text{RL2})/(E-P)$ enthält RL2; mi\_share und jv\_ta gehen nicht ins Treatment ein, sind aber womöglich korrelierte Bilanzgrößen. In 5.3 hat die RL1-Verzerrung jetzt eine Bedingung: Sie geht nach oben nur bei positivem Eigenkapital, bei negativem Eigenkapital womöglich in die andere Richtung. In 4.5 heißt es jetzt: 65 geschätzte Modelle in S0–S13, dazu S14 mit fünf Zeilen, die mit S0 identisch sind. Unten steht die vollständige Liste aller Zahlen in den Abschnitten 4 und 5 mit ihren Quellen. Alles andere ist unverändert.

## Dateien
- `proposal/sections/04_empirical_model.tex` – 4.3: Absatz zum mechanischen Zusammenhang korrigiert, Kommentar zur Herkunft der rl2\_gap-Definition ergänzt; 4.5: Satz zur Zahl der Robustheitsmodelle und `% source:`-Kommentare angepasst
- `proposal/sections/05_context_data.tex` – 5.3: Bedingung für die Richtung der RL1-Verzerrung ergänzt
- Aus früheren Runden unverändert im Kandidaten: `proposal/appendix/variables.tex`, `proposal/main.tex` (JEL-Zeile, `plainnat`/`references`, `\input{appendix/variables}`), `proposal/tables/t005_*.tex`, `proposal/figures/t005_breach_shares.pdf`

## Ausführung
`agents/overleaf.sh check` – **habe ich nicht ausgeführt.** In dieser Sitzung hatte ich keine Shell, nur Datei-Werkzeuge. Der PI muss das Kompilieren prüfen. Neu ist nur Text mit Mathematik in `$...$` (`\text{rl2\_gap}`, `\text{RL2}`). Pakete, Labels und Zitate sind nicht neu dazugekommen.

## Abnahmekriterien
1. Kompiliert ohne Fehler, keine undefinierten Referenzen oder Zitate: **nicht geprüft**, siehe Ausführung. Ich habe keine neuen `\ref` oder `\cite` eingefügt.
2. Jede Zahl mit Quelle: **erfüllt**, die vollständige Liste folgt.

**Abschnitt 4.1**
- Schwellen 0.70 / 1.00 / 1.00, Strikte Ungleichungen, $n_{it}\in\{0,1,2,3\}$, fehlend wenn eine Ratio fehlt: `replication/code/01_clean.R` Z. 583–584
- 30.6.2017–31.12.2019, $|\mathcal{T}_i|\ge 3$: `t011_robustness.tex` Hinweis S0 („2017H1–2019H2, at least 3 dates“)
- Wertebereich $[0,3]$: `t011_treatment_definitions.csv` Zeile dose\_pre, Spalten min = 0, max = 3
- 124, 1.367, 1.049, 1.167; 20, 9, 5, 18: `t011_treatment_definitions.csv` Zeile dose\_pre, Spalten n\_firms, mean, sd, median, n\_0 bis n\_3
- 125 (dose2018), 124 (distance): dieselbe Datei, Spalte n\_firms
- 0.826, 0.621, 0.887: dieselbe Datei, Spalte correlation\_with\_dose
- $p = 0.003$: `t011_robustness.csv` S2 / rl1, Spalte pretrend\_p (0.00315)

**Abschnitt 4.2**
- Post ab 31.12.2020 (2020H2): `01_clean.R` Z. 588
- 13 Termine von 2016H2 bis 2022H2: `t005_summary_stats.tex` Hinweis („Full: 2016H2–2022H2“)
- Referenz 2020H1, sieben Vorperioden-Koeffizienten von 2016H2 bis 2019H2: `t009_pretrend_tests.csv` Spalten tested\_dates und df = 7
- Fünf Nachperioden-Koeffizienten: ergibt sich aus 13 − 7 − 1
- 95 %: Konvention, passt zu den ci\_lower/ci\_upper-Spalten in `t009_did_main.csv`

**Abschnitt 4.3**
- 0.119, 0.087, 0.522, 0.557, 0.634: `t009_pretrend_tests.csv` Spalte p\_value, Zeilen rl1, rl2, rl2\_gap, mi\_share, jv\_ta
- 5 % und 0.10: Signifikanzkonventionen
- „sechs Termine“: 2017H1–2019H2 laut S0-Hinweis
- 0.166 und 0.262: `t011_robustness.csv` S1 / rl1 und rl2, Spalte pretrend\_p\_before\_2019
- rl2\_gap-Formel: aus `01_clean.R` Z. 581 und 590 algebraisch hergeleitet
- Zwölf Entwickler, 20.8.2020, 1.1.2021: `state/literature_notes.md` Z. 6 und 10 (UNVERIFIED)
- 30.6.2020: `01_clean.R` Z. 586 (dose\_2020h1)
- 104 Firmen: `t011_robustness.csv` S6 / rl1, Spalte n\_firms
- 13 Termine: wie in 4.2

**Abschnitt 4.4**
- Bin-Breiten 0.02 (RL1) und 0.05 (RL2, RL3): `t005_bunching_counts.csv`, Bin-Grenzen lower/upper
- Zeitfenster 2017H1–2019H2 und 2020H2–2022H2: `t005_summary_stats.tex` Hinweis
- 797: `t005_bunching_counts.csv` rl1 pre, Spalte n\_nonmissing; ebenso `t005_summary_stats.csv` pre / rl1, Spalte N

**Abschnitt 4.5**
- 30.6.2020, 31.12.2018, $2.8\times$SE, 80 %, 5 %: `t008_mde.tex` Hinweise Z. 38–39
- Firmenzahlen 124 / 121 / 101: `t008_mde.csv` main\_dose\_pre, Spalte firms
- MDEs 0.0257 (0.412), 0.435 (0.349), 0.0442 (0.410), 0.0203 (0.343), 0.0107 (0.416): dieselben Zeilen, Spalten MDE und MDE\_within\_SD
- Punktschätzer −0.0149, −0.284, 0.021: `t009_did_main.csv` Spalte coefficient
- 87 Firmen (86 für mi\_share); 0.631, 0.723, 0.632: `t008_mde.csv` soe\_interaction, Spalten firms und MDE\_within\_SD
- 65 Modelle in S0–S13; S14 mit fünf Zeilen gleich S0: `t011_robustness.csv` Spalte status (Z. 2–71 bzw. 72–76). Dass beide Firmen außerhalb von sample\_main liegen: `t011_robustness.tex` Z. 77

**Abschnitt 5.1**
- 70 %, 100 %, 1; vier Stufen; 15 % und 5 pp; zwölf Entwickler, 20.8.2020, 1.1.2021, Ende 2020: `state/literature_notes.md` Z. 6 und 10

**Abschnitt 5.2**
- Alle Zahlen aus `t004_panel_counts.csv`:
  - 204 = 18 + 95 + 58 + 33 (Stufe 01\_universe)
  - 20 = 3 + 12 + 5 + 0 (01\_firms\_without\_financials)
  - 184 Firmen und 2.279 Firmen-Halbjahre (10\_final_panel, all)
  - 172 Firmen (10\_final\_panel, sample\_broad)
  - 136 Firmen = 65 + 15 + 29 + 27, mit 1.692 Firmen-Halbjahren (10\_final\_panel, sample\_main)
- 124 Firmen und 1.545 Firmen-Halbjahre: `t009_did_main.csv` Spalten n\_firms und base\_N
[firm-specific excerpt withheld in public audit]
- 13 Halbjahresenden von 31.12.2016 bis 31.12.2022: wie in 4.2

**Abschnitt 5.3**
- Enthält keine Zahlen aus Outputs; IFRS 15 ist nur der Name des Standards.

**Abschnitt 5.4**
- `t005_summary_stats.csv`:
  - RL1: Mittelwert 0.656 (pre) und 0.683 (post), Median 0.702 und 0.699
  - mi\_share: Mittelwert 0.184 und 0.310, Standardabweichung post 0.717, Median 0.126 und 0.240
  - jv\_ta: Mittelwert 0.048 und 0.062
  - RL3 im Gesamtzeitraum: Mittelwert 8.062, Median 1.166
- `t005_by_dose.csv`:
  - Firmen je Gruppe 31, 37, 28, 28 (zusammen 124)
  - rl1\_mean 0.497, 0.649, 0.744, 0.828
  - mi\_share\_mean 0.140, 0.188, 0.218, 0.308
  - share\_HK 0.097 und 0.536
  - share\_delisted 0.161 und 0.500

3. Gleichungen definiert, Stichprobenbegriffe 184 / 172 / 136 / 124 einheitlich: **erfüllt** (siehe Prüfbericht; diese Runde hat daran nichts geändert).
4. Keine Politikfakten über die Fokuspaper-Notizen hinaus, keine neuen Literaturangaben: **erfüllt**. Diese Runde hat keine Fakten oder Zitate ergänzt.
5. Länge, geschätzt: Abschnitt 4 etwa 2,3 Seiten (vorher 2,2, plus etwa 5 Zeilen), Abschnitt 5 etwa 2,7 Seiten. Gerendert habe ich das nicht.

## Offene Fragen
- Ich konnte nicht kompilieren (keine Shell). Bitte `agents/overleaf.sh check` ausführen und das Log nach undefinierten Referenzen durchsuchen.
- Die rl2\_gap-Formel habe ich selbst aus dem Code hergeleitet. Sie gilt nur, wenn $E>0$ und $E-P>0$ ist; das steht im Text als „positive denominators“.
- In 5.3 ist die Richtung der RL1-Verzerrung bei negativem Eigenkapital als „can go the other way“ formuliert. Für negatives Eigenkapital gilt das so nicht in jedem Fall, denn der Nenner $T-A$ kann ebenfalls nicht positiv werden und die Ratio ist dann fehlend.
- Weiter offen: die Autorenangabe beim Fokuspaper (Guo et al. oder Jin et al., `% TODO(PI)`), die Primärquelle für die Politikdaten (`% SOURCE TODO`) und die optionale Zitierung von callaway2021.
