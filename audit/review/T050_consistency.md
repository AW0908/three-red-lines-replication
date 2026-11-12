## Rolle: consistency (claude, sonnet) – VERDICT: REWORK


## Befunde

1. **Punkt 0 (a), (b), (f) für `proposal/appendix/ai_use.tex` ist nicht umgesetzt.** Der Worker meldet das selbst (Bericht, „teilweise offen"). Die Datei gehört aber zu den eingefrorenen Dateien und enthält überholte Aussagen.
   - Zeile 6: „This writing pass (T049) awaits independent review and author acceptance." Das ist veraltet. `state/approvals.log` Zeile 147 verbucht T049 am 2026-10-30 14:03 als DELIVERED mit OVERRIDE. Verlangt ist „48 task cards accepted before this revision; T049 and T050 are this revision".
   - Zeile 21: „From October 13--30, 2026" statt „October 13 to 30, 2026".
   - Zeile 21: „Claude Haiku" statt „Claude Code (Haiku)". Der Anhang führt das Tool damit unter zwei Namen. Verlangt ist ein Name pro Tool.
   - Die Zeilen 7 und 21 und die Tabelle (Zeile 18) nennen ChatGPT und Grok schon. Das entspricht Punkt 0(a) und dem `AI_USAGE_LOG.md`-Eintrag vom 2026-10-30.
   - Die Karte hat `ai_use.tex` nicht in den Schreibbereich aufgenommen, obwohl Punkt 0 es verlangt. Das ist ein Kartenfehler, den der Co-PI beheben muss. Das Ergebnis bleibt trotzdem unvollständig.

2. **Notation: „Δb" ist in Abschnitt 6.1 doppelt belegt.** `06_preliminary_analysis.tex` Zeile ~27: „freezing MI lowers excess mass by $\Delta b=2.75$ $[0.63,5.10]$". Überall sonst ist $\Delta b$ die Post-minus-Pre-Änderung des Excess Mass (Zeilen 18, 36, Abschnitt 4, Intro, Conclusion).
   - Der Wert 2.75 mit CI [0.63, 5.10] stimmt mit `t040_robustness.csv` überein (Szenario perpetual, Metrik `T029_b_drop`: 2.746 [0.626, 5.098]).
   - Gemeint ist offiziell minus eingefroren (in Finding 2 „3.71"). Dieselbe Notation für zwei verschiedene Größen führt zu Fehllesungen.

3. **Der CNKI-Befund ist im Haupttext nicht mehr belegt.** Punkt 7 verlangt, ihn in Abschnitt 2 zu behalten. Der Diff zeigt, dass die Einleitung „Only 3 of 51 Chinese journal articles … CSSCI …" verloren hat. Abschnitt 2 sagt nur noch „limited core-journal coverage". Eine Suche nach „3 of 51" in `proposal/` findet keinen Treffer. Die Zahl steht nur noch als Kommentar. Das Ergebnis ist dadurch in keinem Text mehr belegt.

4. **Gegenfaktumstabelle: kein Wert für das Placebo-Excess-Mass.** Die Zelle „Excess mass b" der Placebo-Zeile bleibt „---", die Note erklärt das (`t050_counterfactuals.tex`). Das ist ehrlich und kein Fehler. Es erfüllt Punkt 3 aber nur teilweise: Nach der Karte „use levels where the CSVs give them" fehlt der Wert, weil kein Output existiert. Die Zeilen mit Differenzen und Levels sind gemischt. Die Note erklärt das und sagt, dass negatives $D$ höhere Compliance unter dem Trend bedeutet. Die Spaltenüberschrift „Compliant share / $D$" ist knapp, aber konsistent mit der Note.

5. **Kleinigkeit:** In `t049_threats.tex` Zeile 9 steht nach dem Semikolon großgeschrieben „Mass-conserving fixed-point fit". Das gehört in die Language-Rolle, nicht in meine.

## Abnahmekriterien

Soweit sie meine Rolle (Konsistenz) betreffen:

1. **Jede Zahl aus einer CSV: belegt erfüllt, mit den Ausnahmen aus Befund 2 und 3 (Notation und Beleg).** Gegen die CSVs geprüft:
   - `t041_bunching_by_date.csv`: Quotient vor 2020H2 jeweils ≤ 1 (0.43–0.96). Ab 2020-12-31 liegt er bei 1.477–2.172 (Text „1.48 to 2.17"). Der Gegenfaktum-Anteil ist konstant 0.1077.
   - `t031_samples.csv` (B_balanced13, post): 115 Firmen, b = 3.24 [1.02, 6.19].
   - `t041_one_per_firm.csv`: Anteil positiver Ziehungen 0.998999 (998 von 999). Die Datumsschätzungen −0.31, 1.74, 1.77, 3.55, 5.67 stimmen. Nur 2021H2 und 2022H1 haben CIs ohne Null.
   - `t040_robustness.csv` (perpetual): b = 2.58 [0.52, 5.13]; Drop = 2.75 [0.63, 5.10].
   - `t031_timing.csv`: 3.54 [1.11, 6.76] für 2021H1–2022H2; 1.74 [−0.67, 4.99] für 2020H2 allein.
   - `t043_trend_cf.csv`: Firmentrend D = −9.8 [−15.1, −4.7], b = 1.52 [0.14, 3.34]; Bin-Trend D = −5.6 [−11.9, 1.0], b = 1.74 [−0.18, 3.35].
   - `t029_counterfactual_bunching.csv`: 3.18 [1.01, 6.01], −0.52 [−1.83, 1.08], 3.71 [1.60, 6.14].
   - `t029_compliance.csv`: D = 11.5 pp (post) und 4.1 pp (Placebo, CI [1.3, 7.3]); Differenz 7.4 [3.1, 11.8].
2. **Haupttext ≤ 15 Seiten: nach Beleg erfüllt.** `main.aux` hat `sec:main_end` auf Seite 15. Das Log von `review/T050_latex.txt` meldet „übersetzt fehlerfrei". XeLaTeX-Build: `review/T050_build/main.log` enthält keine Overfull-Zeilen, die Suche fand nur die Output-Zeile. Seiten- und Wortzahl vorher/nachher stehen im Bericht (14 → 15 Seiten, 4.457 → 4.376 Wörter). Dort sind sie nur behauptet, nicht von mir nachgezählt.
3. **Punkte 1–7 je mit Zeile im Bericht: erfüllt.** Der Inhalt der Punkte aber nur teilweise:
   - **Punkt 0:** (a), (b), (f) offen (Befund 1), (c), (d), (e) belegt. (c): Intro Zeile 7 und `05_context_data.tex` nennen „136 developers listed during the sample period, 42 of them later delisted". Der Abstract behält „136 listed developers". (d): Die Umkehrsätze stimmen mit `t031_timing.csv` überein. In 2021H1–2022H2 schließt die Bins-Spezifikation Null ein, Linear und Near-Threshold bleiben negativ. (e): Die Conclusion enthält „under the firm trend, was slower".
   - **Punkt 1:** Die PDF-Kopie ist byteidentisch (`cmp`). Die Abbildung hat eine gestrichelte Linie bei August 2020 und keine Markierung für den 1. Januar 2021. Die Note sagt das ausdrücklich. Das Histogramm liegt in Appendix B mit Referenz „Appendix Figure \ref{fig:excess_mass}".
   - **Punkt 2:** Die vier Sätze sind vorhanden und zahlenrichtig, mit dem Notationsproblem aus Befund 2.
   - **Punkt 3:** Fünf Zeilen, Note vorhanden, Placebo-b fehlt (Befund 4).
   - **Punkt 4:** Identifikationstabelle mit vier Zeilen und den verlangten Spalten, ersetzt den Estimand-Absatz in `04_empirical_model.tex`.
   - **Punkt 5:** Hierarchie in Intro, Abschnitt 4 und Conclusion einheitlich.
   - **Punkt 6:** Abstract unverändert.
   - **Punkt 7:** Der Bericht gibt eine Kürzung von Abschnitt 2 von 536 auf 354 Wörter an, das sind −34 %. Das habe ich nicht nachgezählt. Befund 3 betrifft den entfallenen CNKI-Befund.
4. **Punkt 0(f) „one name per tool", „October 13 to 30, 2026": nicht erfüllt** (Befund 1). „Mass-conserving fixed-point fit" und „drop $N$" in der Threats-Tabelle: belegt erfüllt.

## Nicht geprüft

- Die Tabellenwerte von Anteilen in Prozent (51.2, 39.7, 44.5 und deren CIs) stehen nicht in den von mir gelesenen Zeilen von `t029_compliance.csv`. Ich habe sie nicht in einer Datei nachgewiesen. Sie wurden aus dem früheren, akzeptierten Tabellenstand übernommen.
- Wortzahlen und Seitenzahlen: nur Beleg über `main.aux` (Seite 15).
- Ob „no other content removed" in der Gesamtheit gilt. Der Diff gegen Overleaf enthält auch T049-Änderungen und lässt sich nicht sauber trennen.
- Rechtschreibung und Stil (Rolle `language`) und Code/Daten.
- `AI_USAGE_LOG.md` als Ganzes: nur Stichproben zu T049, T050 und Haiku.
