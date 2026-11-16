## Rolle: consistency (claude, sonnet) – VERDICT: REWORK


## Befunde

[number withheld]. **Punkt [number withheld] (a), (b), (f) für `proposal/appendix/ai_use.tex` ist nicht umgesetzt.** Der Worker meldet das selbst (Bericht, „teilweise offen"). Die Datei gehört aber zu den eingefrorenen Dateien und enthält überholte Aussagen.
   - Zeile [number withheld]: „This writing pass (T049) awaits independent review and author acceptance." Das ist veraltet. `state/approvals.log` Zeile [number withheld] verbucht T049 am 2026-10-30 14:03 als DELIVERED mit OVERRIDE. Verlangt ist „[number withheld] task cards accepted before this revision; T049 and T050 are this revision".
   - Zeile [number withheld]: „From October [number withheld]-[number withheld], [number withheld]" statt „October [number withheld] to [number withheld], [number withheld]".
   - Zeile [number withheld]: „Claude Haiku" statt „Claude Code (Haiku)". Der Anhang führt das Tool damit unter zwei Namen. Verlangt ist ein Name pro Tool.
   - Die Zeilen [number withheld] und [number withheld] und die Tabelle (Zeile [number withheld]) nennen ChatGPT und Grok schon. Das entspricht Punkt [number withheld](a) und dem `AI_USAGE_LOG.md`-Eintrag vom 2026-10-30.
   - Die Karte hat `ai_use.tex` nicht in den Schreibbereich aufgenommen, obwohl Punkt [number withheld] es verlangt. Das ist ein Kartenfehler, den der Co-PI beheben muss. Das Ergebnis bleibt trotzdem unvollständig.

[number withheld]. **Notation: „Δb" ist in Abschnitt [number withheld] doppelt belegt.** `06_preliminary_analysis.tex` Zeile ~[number withheld]: „freezing MI lowers excess mass by $\Delta b=[number withheld]$ $[[number withheld]]$". Überall sonst ist $\Delta b$ die Post-minus-Pre-Änderung des Excess Mass (Zeilen [number withheld], [number withheld], Abschnitt [number withheld], Intro, Conclusion).
   - Der Wert [number withheld] mit CI [[number withheld], [number withheld]] stimmt mit `t040_robustness.csv` überein (Szenario perpetual, Metrik `T0[number withheld]_b_drop`: [number withheld] [[number withheld], [number withheld]]).
   - Gemeint ist offiziell minus eingefroren (in Finding [number withheld] „[number withheld]"). Dieselbe Notation für zwei verschiedene Größen führt zu Fehllesungen.

[number withheld]. **Der CNKI-Befund ist im Haupttext nicht mehr belegt.** Punkt [number withheld] verlangt, ihn in Abschnitt [number withheld] zu behalten. Der Diff zeigt, dass die Einleitung „Only [number withheld] of [number withheld] Chinese journal articles … CSSCI …" verloren hat. Abschnitt [number withheld] sagt nur noch „limited core-journal coverage". Eine Suche nach „[number withheld] of [number withheld]" in `proposal/` findet keinen Treffer. Die Zahl steht nur noch als Kommentar. Das Ergebnis ist dadurch in keinem Text mehr belegt.

[number withheld]. **Gegenfaktumstabelle: kein Wert für das Placebo-Excess-Mass.** Die Zelle „Excess mass b" der Placebo-Zeile bleibt „---", die Note erklärt das (`t050_counterfactuals.tex`). Das ist ehrlich und kein Fehler. Es erfüllt Punkt [number withheld] aber nur teilweise: Nach der Karte „use levels where the CSVs give them" fehlt der Wert, weil kein Output existiert. Die Zeilen mit Differenzen und Levels sind gemischt. Die Note erklärt das und sagt, dass negatives $D$ höhere Compliance unter dem Trend bedeutet. Die Spaltenüberschrift „Compliant share / $D$" ist knapp, aber konsistent mit der Note.

[number withheld]. **Kleinigkeit:** In `t049_threats.tex` Zeile [number withheld] steht nach dem Semikolon großgeschrieben „Mass-conserving fixed-point fit". Das gehört in die Language-Rolle, nicht in meine.

## Abnahmekriterien

Soweit sie meine Rolle (Konsistenz) betreffen:

[number withheld]. **Jede Zahl aus einer CSV: belegt erfüllt, mit den Ausnahmen aus Befund [number withheld] und [number withheld] (Notation und Beleg).** Gegen die CSVs geprüft:
   - `t041_bunching_by_date.csv`: Quotient vor [number withheld]H2 jeweils ≤ [number withheld] ([number withheld]–[number withheld]). Ab 2020-12-31 liegt er bei [number withheld]–[number withheld] (Text „[number withheld] to [number withheld]"). Der Gegenfaktum-Anteil ist konstant [number withheld].
   - `t031_samples.csv` (B_balanced1[number withheld], post): [number withheld] Firmen, b = [number withheld] [[number withheld], [number withheld]].
   - `t041_one_per_firm.csv`: Anteil positiver Ziehungen [number withheld] ([number withheld] von [number withheld]). Die Datumsschätzungen [number withheld], [number withheld], [number withheld], [number withheld], [number withheld] stimmen. Nur [number withheld]H2 und [number withheld]H1 haben CIs ohne Null.
   - `t040_robustness.csv` (perpetual): b = [number withheld] [[number withheld], [number withheld]]; Drop = [number withheld] [[number withheld], [number withheld]].
   - `t031_timing.csv`: [number withheld] [[number withheld], [number withheld]] für [number withheld]H1–[number withheld]H2; [number withheld] [[number withheld], [number withheld]] für [number withheld]H2 allein.
   - `t043_trend_cf.csv`: Firmentrend D = [number withheld] [[number withheld], [number withheld]], b = [number withheld] [[number withheld], [number withheld]]; Bin-Trend D = [number withheld] [[number withheld], [number withheld]], b = [number withheld] [[number withheld], [number withheld]].
   - `t029_counterfactual_bunching.csv`: [number withheld] [[number withheld], [number withheld]], [number withheld] [[number withheld], [number withheld]], [number withheld] [[number withheld], [number withheld]].
   - `t029_compliance.csv`: D = [number withheld] pp (post) und [number withheld] pp (Placebo, CI [[number withheld], [number withheld]]); Differenz [number withheld] [[number withheld], [number withheld]].
[number withheld]. **Haupttext ≤ [number withheld] Seiten: nach Beleg erfüllt.** `main.aux` hat `sec:main_end` auf Seite [number withheld]. Das Log von `review/T050_latex.txt` meldet „übersetzt fehlerfrei". XeLaTeX-Build: `review/T050_build/main.log` enthält keine Overfull-Zeilen, die Suche fand nur die Output-Zeile. Seiten- und Wortzahl vorher/nachher stehen im Bericht ([number withheld] → [number withheld] Seiten, [number withheld] → [number withheld] Wörter). Dort sind sie nur behauptet, nicht von mir nachgezählt.
[number withheld]. **Punkte [number withheld]–[number withheld] je mit Zeile im Bericht: erfüllt.** Der Inhalt der Punkte aber nur teilweise:
   - **Punkt [number withheld]:** (a), (b), (f) offen (Befund [number withheld]), (c), (d), (e) belegt. (c): Intro Zeile [number withheld] und `05_context_data.tex` nennen „[number withheld] developers listed during the sample period, [number withheld] of them later delisted". Der Abstract behält „[number withheld] listed developers". (d): Die Umkehrsätze stimmen mit `t031_timing.csv` überein. In [number withheld]H1–[number withheld]H2 schließt die Bins-Spezifikation Null ein, Linear und Near-Threshold bleiben negativ. (e): Die Conclusion enthält „under the firm trend, was slower".
   - **Punkt [number withheld]:** Die PDF-Kopie ist byteidentisch (`cmp`). Die Abbildung hat eine gestrichelte Linie bei August [number withheld] und keine Markierung für den [number withheld]. Januar [number withheld]. Die Note sagt das ausdrücklich. Das Histogramm liegt in Appendix B mit Referenz „Appendix Figure \ref{fig:excess_mass}".
   - **Punkt [number withheld]:** Die vier Sätze sind vorhanden und zahlenrichtig, mit dem Notationsproblem aus Befund [number withheld].
   - **Punkt [number withheld]:** Fünf Zeilen, Note vorhanden, Placebo-b fehlt (Befund [number withheld]).
   - **Punkt [number withheld]:** Identifikationstabelle mit vier Zeilen und den verlangten Spalten, ersetzt den Estimand-Absatz in `04_empirical_model.tex`.
   - **Punkt [number withheld]:** Hierarchie in Intro, Abschnitt [number withheld] und Conclusion einheitlich.
   - **Punkt [number withheld]:** Abstract unverändert.
   - **Punkt [number withheld]:** Der Bericht gibt eine Kürzung von Abschnitt [number withheld] von [number withheld] auf [number withheld] Wörter an, das sind [number withheld] %. Das habe ich nicht nachgezählt. Befund [number withheld] betrifft den entfallenen CNKI-Befund.
[number withheld]. **Punkt [number withheld](f) „one name per tool", „October [number withheld] to [number withheld], [number withheld]": nicht erfüllt** (Befund [number withheld]). „Mass-conserving fixed-point fit" und „drop $N$" in der Threats-Tabelle: belegt erfüllt.

## Nicht geprüft

- Die Tabellenwerte von Anteilen in Prozent ([number withheld], [number withheld], [number withheld] und deren CIs) stehen nicht in den von mir gelesenen Zeilen von `t029_compliance.csv`. Ich habe sie nicht in einer Datei nachgewiesen. Sie wurden aus dem früheren, akzeptierten Tabellenstand übernommen.
- Wortzahlen und Seitenzahlen: nur Beleg über `main.aux` (Seite [number withheld]).
- Ob „no other content removed" in der Gesamtheit gilt. Der Diff gegen Overleaf enthält auch T049-Änderungen und lässt sich nicht sauber trennen.
- Rechtschreibung und Stil (Rolle `language`) und Code/Daten.
- `AI_USAGE_LOG.md` als Ganzes: nur Stichproben zu T049, T050 und Haiku.
