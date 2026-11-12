Der Haupttext endet jetzt auf S. 15, und der Build läuft ohne Overfull-Boxen und ohne undefinierte Verweise durch. Jetzt folgt der Bericht.

## Ergebnis
Ich habe T056 in `proposal/` umgesetzt. Neu sind die Ich-Form, die Aufteilung in H2a (gestützt) und H2b (nicht gestützt) und die vier T055-Ergebnisse (dichteunabhängiger MI-Shift, κ-Break-even, Falsifikation mit der unbereinigten Quote, lineare Trends). Damit liest sich Finding 2 neu: Die Differenz von $D$ zwischen Post und Placebo (7,4) gilt nicht mehr als Beleg für eine stärkere Abhängigkeit von MI. Hinzu kommen Placebo-Schwellen und die unbereinigte Quote in Tabelle 3, ein Satz zur regulierten Einheit, Machbarkeit und Nebenwirkungen im Fazit, die Chetty-Quelle und die Autorennotiz zum Focal Paper. Die Abschnitte 01–05 und `t050_counterfactuals.tex` hatte schon ein früher abgebrochener Lauf um 21:50–21:53 bearbeitet; ich habe sie geprüft, korrigiert und für das Seitenlimit gekürzt. Der Haupttext endet auf S. 15 (`sec:main_end` steht auf S. 15 in `main.aux`).

## Dateien
- `proposal/sections/01_introduction.tex` – vom abgebrochenen Vorlauf: Ich-Form, Satz zur Repräsentativität, neue Lesart von Finding 2 und κ; von mir nur geprüft
- `proposal/sections/02_literature.tex` – Ich-Form im Absatz „Search“ (behebt eine Overfull-Box), Kürzungen in der ersten bis dritten Literaturlinie
- `proposal/sections/03_framework.tex` – vom Vorlauf: H2a/H2b, κ-Break-even als empirisches Gegenstück; von mir nur geprüft
- `proposal/sections/04_empirical_model.tex` – vom Vorlauf: Bin-Zahlen gestrichen, Chetty-Zitat, H2b-Maße. Von mir: Overfull behoben, 5.2-Ende, 5.3 und 5.5 gekürzt, Einleitung ohne die Doppelung zu Abschnitt 1
- `proposal/sections/05_context_data.tex` – vom Vorlauf: Satz zur regulierten Einheit (Huafa). Von mir: 4.2 und 4.4 gekürzt
- `proposal/sections/06_preliminary_analysis.tex` – Ich-Form, Überschrift von Finding 2 (H2a), Falsifikationsabsatz in 6.1, MI-Shift/Reweighting, Trend- und κ-Absätze in 6.2, Satz zu den horizontgleichen Vergleichen gestrichen, Fallbeispiele in 6.3 und die Notiz zu Tabelle 5 gekürzt, Quellkommentar zum Prätrendtest, 6.5 neu gefasst, Abbildungen 2 und 3 etwas kleiner
- `proposal/sections/07_conclusion.tex` – Ich-Form, H2a/H2b, κ mit Look-through verknüpft, zwei Sätze zu Machbarkeit und Nebenwirkungen
- `proposal/tables/t050_counterfactuals.tex` (Tabelle 4) – vom Vorlauf: Zeilen für linearen Trend, κ und Post minus Placebo. Von mir: kompakter gesetzt, Satz zur Trendform in der Notiz, toter Verweis `fig:t055_kappa` entfernt
- `proposal/tables/t051_robustness.tex` (Tabelle 3) – Zeile für die Placebos 0,60/0,80 und Zeile für die unbereinigte Quote (jetzt 9 Zeilen), Zeilennummern in der Notiz angepasst, Chetty-Zitat
- `proposal/tables/t049_threats.tex` (Tabelle 6) – unbereinigte Quote und neue Zeile „Prior MI growth; density“, Einträge gekürzt
- `proposal/references.bib` – `chetty2011adjustment` ergänzt, `note` von `jin2025deleveraging` ersetzt (Schlüssel bleibt)
- `review/T056_build/` – Build-Ausgabe

## Ausführung
[fenced excerpt withheld in public audit]
[fenced excerpt withheld in public audit]
Ausgabe des letzten Laufs: `Latexmk: All targets (.../main.xdv .../main.pdf) are up-to-date` (Exit 0). Das Log enthält keine Overfull-Boxen, keine undefinierten Verweise oder Zitate. Es bleiben nur zwei Font-Warnungen zu SongtiSC kursiv (CJK im Anhang); die gab es schon vorher. In `main.aux` stehen `sec:conclusion` und `sec:main_end` jeweils auf S. 15.

## Abnahmekriterien
**1. Jede Zahl aus einer CSV, und jede zitierte Tabelle enthält die zitierte Zahl: erfüllt, mit einer Einschränkung (siehe Offene Fragen).** Neue Zahlen und ihre Quellen:
- 4,02 [1,67; 6,80]; −1,23 [−4,26; 1,70] bei 0,60; 0,31 [−1,16; 1,92] bei 0,80 – `t043_delta_b.csv` (Tabelle 3)
- −0,20 [−1,85; 2,01], 630 (132) – `t055_falsification.csv` b_raw_tl_ta, post (Tabelle 3)
- 3,14, 3,34 [0,32; 6,58] und 2,91 [−0,59; 6,25] – `t055_falsification.csv` (Text in 6.1)
- 1,46, 1,83, −0,37 [−1,04; 0,28], 2,40 und 2,38 – `t055_mi_shift.csv` mean_shift_pp
- 7,0, 14,4, 18,7 und 4,3 [−4,1; 12,4] – `t055_mi_shift.csv` D, D_reweighted, D_post_minus_reweighted_placebo
- $D$ = 1,3 [−2,9; 5,6] und 3,7 [−2,6; 8,4]; $b$ = 1,35 [−0,30; 3,28] und −0,10 [−1,40; 1,79] – `t055_linear_trend.csv` (Tabelle 4)
- κ* = 0,28 und 0,09 – `t055_kappa_break_even.csv` (Tabelle 4, Text in 6.2, Fazit)
- 7,4 [3,1; 11,8], 11,5, 4,1, 51,2 %, 39,7 % [31,9; 48,2], 44,5 % und 48,5 % – `t029_compliance.csv` (Zeilen 86–100, gegengeprüft; stehen in Tabelle 4)
- p = 0,0002 – `t055_pretrend_tests.csv` rl1, C3-date

**2. Haupttext endet spätestens auf S. 15, Build sauber: erfüllt.**

**3. Punkte 1–10 je mit einer Zeile:**
1. **Ich-Form:** erfüllt in allen Dateien unter `sections/` und `tables/`; kein „we/our/the author“ mehr (per Grep geprüft). Im Anhang nicht umgesetzt (siehe Offene Fragen).
2. **H2-Aufteilung:** erfüllt; dieselben Bezeichnungen in 3.3, 5.2, 6.2 und im Fazit, Überschrift von Finding 2 „(H2a)“.
3. **T055 einarbeiten:** (a) erfüllt in 6.2, in der Einleitung (Vorlauf), in 6.5 und in Tabelle 6; „Post minus Placebo“ steht nirgends mehr als Beleg. (b) erfüllt in 6.2, 3.2 und im Fazit; die Abbildung ist weder im Haupttext (kein Platz) noch im Anhang (siehe Offene Fragen). (c) erfüllt in 6.1, die unpräzise Δb-Differenz ist genannt. (d) „did not exceed“ als robuste Aussage, Trendform-Hinweis einmal in 6.2 und in der Notiz zu Tabelle 4. (e) erfüllt.
4. **Robustheitstabelle:** erfüllt, 9 Zeilen. Die beiden Placebos teilen sich eine Zeile, damit die Grenze von 9 Zeilen hält.
5. **Regulierte Einheit:** erfüllt in 4.2 (Vorlauf), mit Verweis auf Fall (a).
6. **Repräsentativität:** erfüllt in der Einleitung, Absatz 2 (Vorlauf).
7. **Machbarkeit und Nebenwirkungen:** erfüllt im Fazit, als Abwägungen formuliert.
8. **Nachvollziehbarkeit:** Die 7,4 steht in Tabelle 4. Die Bin-Zahlen (134/31/21) sind gestrichen. Beim Prätrend-p-Wert steht im Text der Verweis auf die Ausgabe `t055_pretrend_tests` im Replikationspaket statt auf eine Anhangstabelle (siehe Offene Fragen).
9. **Autorennotiz:** erfüllt, Wortlaut aus der Karte, Schlüssel `jin2025deleveraging` unverändert.
10. **Kürzungen:** erfüllt; Abschnitt 2, 4.2/4.4, 5.3/5.5, Fallbeispiele in 6.3, Notizen zu Tabelle 4 und 5, Tabelle 6 und das Fazit gestrafft. Der Satz zu den horizontgleichen Vergleichen (7 von 9) ist gestrichen, weil er Post-minus-Placebo-$D$ als Evidenz präsentierte.

## Offene Fragen
- **Anhang liegt außerhalb des Schreibbereichs.** Die Karte verlangt die Ich-Form auch im Anhang, die κ-Abbildung „otherwise Appendix B“ und eine neue Anhangstabelle `t055_pretrend_tests`. Der Schreibbereich nennt aber nur `sections/*.tex`, `tables/` und `references.bib`. Ich habe `proposal/appendix/` deshalb nicht angefasst. Stattdessen verweisen Text bzw. Tabellennotiz an zwei Stellen auf das Replikationspaket: beim p-Wert in 6.4 und beim κ-Raster in Tabelle 4. Im Anhang stehen weiter „we/our“ (z. B. `appendix/results.tex`, Z. 77). Für eine Folgekarte nötig: `t055_pretrend_tests.tex` und `t055_kappa.pdf` in `appendix/results.tex` einbinden und die beiden Verweise umstellen. Danach prüfen, ob S. 15 hält.
- **Zahlen ohne Haupttabelle:** Die MI-Shift- und Reweighting-Zahlen sowie die Differenzen der Falsifikation (3,34 und 2,91) stehen im Text nur mit Verweis auf das Replikationspaket bzw. im Quellkommentar. Keine Haupt- oder Anhangstabelle enthält sie.
- **Vorlauf:** Die Änderungen an 01, 03 und dem größten Teil von 04/05 stammen aus einem abgebrochenen Lauf ohne Bericht. Ich habe sie gelesen und ihre Zahlen geprüft, aber nicht Wort für Wort gegen die Baseline (`review/T056_baseline.sha256`) verglichen.
- **Bib-Eintrag Chetty et al. (2011):** Den Titel („Adjustment Costs, Firm Responses, and Micro vs. Macro Labor Supply Elasticities: Evidence from Danish Tax Records“) und die Autorennamen habe ich ergänzt; die Karte nennt nur Zeitschrift, Band, Seiten und WP-Nummer. Bitte an der NBER-Seite gegenprüfen.
- **Tabelle 3:** Die Zeilen 3–9 heißen jetzt „Level $b$“ statt „Post-policy $b$“, damit die Tabelle in die Breite passt; die Notiz erklärt das.
- **Tabelle 6:** Für die Seitengrenze habe ich die Einträge stark gekürzt (z. B. „Gaps may overstate“). Bitte prüfen, ob das sprachlich trägt.
- **Abstract** in `main.tex` (außerhalb des Schreibbereichs) bleibt unverändert; laut Karte passt sein Wortlaut schon.
- **Vorschlag für `AI_USAGE_LOG.md`:** „2026-10-30, Claude (Writer), T056: T055-Ergebnisse in Abschnitte 1–7 eingearbeitet, H2a/H2b, Ich-Form, Robustheits- und Gefährdungstabelle ergänzt, Kürzungen auf 15 Seiten; Zahlen aus `replication/outputs/tables/`.“
