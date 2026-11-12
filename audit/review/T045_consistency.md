## Rolle: consistency (claude, sonnet) – VERDICT: PASS


## Befunde

Keine inhaltlichen Inkonsistenzen zwischen Text und Outputs gefunden. Drei Hinweise ohne Einfluss auf das Urteil:

1. **Rückverfolgbarkeit in 6.1.** `06_preliminary_analysis.tex:15–18` nennt 118 Firmenhalbjahre, 66,1 erwartet, b = 3,14 [1,01; 5,84] und das Vorperioden-b = −0,88 [−1,85; 0,43]. Die Werte stehen in `t023_excess_mass.csv` und stimmen mit der Zeile `post`/`pre` von `t043_integration.csv` (T023_baseline) überein. Die Tabelle `t023_excess_mass` ist aber aus dem Anhang entfernt, die Zahlen stehen also nur noch im Replikationspaket. Der Verweis über `tab:further_outputs` genügt für die Karte.
2. **Formulierung in `04_empirical_model.tex:32`.** Dort steht „all eligible paired post-policy observations“, in 6.2 jetzt „paired observations (602 firm-half-years, 129 firms)“. Das ist sachlich dieselbe Stichprobe (`t029_counterfactual_bunching.csv`: n = 602, 129 Firmen).
3. **„Crossers“ in 6.3 und Anhang.** Der Text spricht durchgehend von „31 crossers“ bzw. „33 crossings“. Der Anhang (`results.tex`, Abschnitt Contract evidence) sagt ausdrücklich, dass die Stichprobe auch schuldengetriebene Crossings enthält. Das widerspricht sich nicht, ist aber für Leser nur im Anhang sichtbar.

## Abnahmekriterien

Nur soweit meine Rolle (Consistency) sie betrifft:

- **Zahlen im Text gegen Outputs (Kriterium 2): belegt erfüllt.** Ich habe geprüft:
  - Δb = 4,02 [1,67; 6,80] und „positiv in 999 von 999 Ziehungen“ (`t043_delta_b.csv`, `share_positive_all` = 1).
  - Alle fünf Spezifikationen bei 0,70 mit Intervall über null. Bei 0,60 und 0,80 schließen alle Intervalle null ein.
  - Messfehler: simulierter Mittelwert 2,01, Anteil 86 % bei 64 Paaren und 40 % bei 52 Paaren (`t043_meas_error.csv`).
  - Integrationsansatz: b_net 3,76 [1,60; 6,15], vorher 0,20 [−1,60; 2,36], Δ 3,56 [0,75; 6,49]. Die Zerlegung 63,84 = 50,14 + 13,69 stimmt (`t043_integration.csv`).
  - Trendvergleich: D_trend −9,8 [−15,1; −4,7], Bin-Trend −5,6 [−11,9; 1,0], b_trend 1,52 [0,14; 3,34] und 3,18 als Ausgangswert (`t043_trend_cf.csv`).
  - Compliance: 51,2 / 39,7 / 11,5 [6,9; 16,2], Placebo 4,1 und Differenz 7,4 [3,1; 11,8] (`t029_compliance.csv`). Gefrorene Excess Mass 3,18 / −0,52 / 3,71 [1,60; 6,14] (`t029_counterfactual_bunching.csv`).
  - Horizonte: 7 von 9 Zellen, die beiden Ausnahmen sind korrekt benannt (`t041_frozen_horizons.csv`).
  - Zerlegung: 69,7 % gegen 57,1 %, 66,7 % mit fallender Verschuldung, MI-Anteil 0,54 gegen 0,18, Differenz 0,37 [−0,11; 0,75], n = 32 gegen 21 (`t027_decomposition_rl1.csv`, `t027_tests.csv`).
  - Heterogenität: 13,1 / 7,6, 18,5 / 7,5, 15,1 / 7,9 (`t043_heterogeneity.csv`).
  - Cash Backing: 79,5 % bei 109 Firmenjahren, 96,6 % gegen 80,8 % bei 33 gegen 48 Firmenjahren (`t046_cash_backing_all.csv`).
  - T047: 4 / 5 / 0 / 1 / 239, also 10 von 249; 0,4 von 190,5 Mrd. RMB (0,2 %); 20 von 33 Firmenjahre (`t047_coding.csv`, `t047_attribution_totals.csv`).
  - Pilot: 117 Transaktionen, davon 107 U (summiert aus `t044_pilot_coding.csv`). 108,3 Mrd. RMB, 3,5 Mrd. (3,2 %), 104,8 Mrd. (`t044_attribution_totals.csv`). Die Zeilen der Vergleichstabelle (D/G/H/E/U je Firma) stimmen mit `t044_pilot_coding.csv` überein.
  - Bunching-Zählungen 134 / 31 / 21 (`t005_bunching_counts.csv`).
- **Trendformulierung in Abstract, Einleitung, 6.2 und Fazit (Kriterium 5): belegt erfüllt.** Der Satz „did not exceed its pre-policy pace and, under the firm trend, was slower; compliance relied on this growth, not on an acceleration of it“ steht wortgleich in `01_introduction.tex`, `06_preliminary_analysis.tex` und `07_conclusion.tex`. Der Abstract (`main.tex`) sagt sinngleich „although that growth did not exceed its pre-policy pace“. Die Aussage passt zu den Outputs, weil D_trend negativ ist und der Bin-Trend-Intervall null einschließt. Nirgends wird ein kausaler Politikeffekt behauptet.
- **Innere Konsistenz: belegt erfüllt.** Stichprobenzahlen (602 / 129, 616 / 125, 630 / 132, 33 / 31), das Compliance-Share-Vokabular und die Tabellennoten sind einheitlich. Die Angabe, welche Gruppe ein Anteil beschreibt, ist durchgängig gesetzt (64 gegen 52 Paare, 33 gegen 48 Firmenjahre).
- **Rework-4-Ersetzungen, soweit konsistenzrelevant: belegt erfüllt.** Das betrifft Punkte 1, 2, 4, 5, 6, 8, 9 und 10. Die Fundstellen im Text entsprechen der Karte, und 602 / 129 sind mit der CSV belegt.
- **Querverweise: belegt erfüllt.** Das Build-Protokoll `review/T045_latex.txt` meldet „übersetzt fehlerfrei“. `tab:further_outputs`, `tab:t043_*` und `tab:t046_cash` sind definiert. Der Verweis auf perpetual bonds in `05_context_data.tex:21` zeigt jetzt auf Appendix Table `tab:t040_robustness`.
- **AI-Appendix (Konsistenz mit Karten und Reviews): belegt erfüllt.** Die Worker- und Reviewer-Zuordnung von T043–T047 stimmt mit den Kartenköpfen überein, die T044-Verdikte (Data PASS, Est. und Cons. REWORK) mit `review/T044*.md`. Die Datumsangaben stimmen mit `state/approvals.log` überein. Die Tabelle ist nach Kartennummer sortiert.
- **Alle übrigen Kriterien** (Seitenzahl, `pdffonts`, Wortbudget, Sprache und Stil, Verifikationsstufen der handerhobenen Fakten): nicht meine Rolle.

## Nicht geprüft

- **Verifikationsstatus der handerhobenen Aussagen.** Ob `case_notes_verification.csv` die genannten Statement-IDs mit `yes/meaning` führt, habe ich nicht geprüft.
- **Quellenangaben in den Fußnoten.** Seitenzahlen und Datumsangaben der Ankündigungen und die Eigentumsanteile 49,75 → 50,20 % (Fall a) habe ich nicht geprüft. Ebenso nicht die 65,5 % des MI-Zuwachses bei Nanshan und die 3-von-51-Angabe zur CNKI-Suche (`screening.xlsx`).
- **Gerenderte Seiten und Schriften.** Ich habe das PDF nicht eingesehen, ebenso wenig Seitenumbruch, Seitenzahl und Schrifteinbettung. Den Build habe ich nur über `T045_latex.txt` bewertet. Das Protokoll ist sehr knapp, es enthält keine Overfull-Meldungen.
- **Python-Prüfung.** Der Python-Aufruf war nicht erlaubt, deshalb habe ich die CSVs nur mit Grep und Read geprüft. Zeilen mit sehr langen Feldern (`t044_magnitude.csv`) habe ich nicht vollständig abgeglichen.
