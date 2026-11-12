## Rolle: language (claude, sonnet) – VERDICT: REWORK


## Befunde

Ich habe nur die Sprache geprüft (Rechtschreibung, Stil, Terminologie, LaTeX-Typografie). Es gibt keine sinnentstellenden Fehler, aber mehrere kleine Mängel, die behoben werden sollten. Zeilenangaben beziehen sich auf die eingefrorenen Dateien.

1. **Minuszeichen im Textmodus (Typografie).** Negative Zahlen stehen als Bindestrich (`-0.8772`) statt als `$-$`. Das ist ein kurzer Strich und kein Minuszeichen und passt nicht zu den Mathe-Minuszeichen in `t055_falsification.tex` und `t055_mi_shift.tex`.
   - `proposal/tables/t043_delta_excess.tex` Zeilen 10–26, auch in den Intervallen `[-4.2554, 1.7049]`.
   - `proposal/tables/t005_summary_stats.tex`, z. B. `-0.1866`, `-0.0264`.
   - `proposal/tables/t031_timing.tex` Zeilen 12–18.
   - `proposal/tables/t041_frozen_horizons.tex` Zeilen 16, 18, 19, 32.
   - Vorschlag: `$-$` bzw. `$-0.8772$` setzen, wie in den neu erstellten T055-Tabellen.

2. **Prozentschreibweise uneinheitlich.** Die Notes schreiben „percent“ (`95 percent`, `90 percent`, `3.2 percent`). Spaltenköpfe und Zellen nutzen `95\% CI` und `0.0\%`.
   - `t043_delta_excess.tex` Zeile 8, `t055_mi_shift.tex` Zeile 7 und `t031_timing.tex` Zeile 9 haben `95\% CI` im Kopf.
   - `t050_counterfactuals.tex` Zeile 14 und Zeile 13 haben `95\% CI` und `51.2\%` in der Zelle.
   - `results.tex` Zeilen 141–146 haben `0.0\%` in den Zellen.
   - Eine Variante pro Dokument wählen. Zahlen in Zellen und Köpfen mit `\%` sind in Tabellen üblich, dann muss aber auch der Fließtext der Notes entscheiden.

3. **Unklare oder holprige Formulierungen.**
   - `results.tex` Zeile 169 (Note zu `tab:pretrend`): „Panel B repeats the specification without controls from the controlled analysis, so that both input tables are shown in full.“ ist schwer verständlich. Vorschlag: „Panel B repeats the no-controls specification next to the controlled one for comparison.“
   - Dieselbe Tabelle: Panel A heißt „Baseline dose event study“ und enthält nur „No controls“. Panel B heißt „with controls“ und enthält ebenfalls „No controls“-Zeilen (`t055_pretrend_tests.tex` Zeilen 10–21). Das ist verwirrend. Vorschlag: Panel B als „Dose event study, with and without controls“ benennen.
   - `results.tex` Zeile 100: „For contrasts, N and Firms show the first and the benchmark population.“ Vorschlag: „For differences, N and Firms give the numbers for the first and the second period (benchmark) population.“ Die Formulierung „first and the benchmark“ ist unklar.
   - `t043_delta_excess.tex` Zeile 30: „Invalid draws are counted without replacement“ ist unverständlich. Vorschlag: „Invalid draws are not replaced and are counted as failures.“ Vgl. `t041_frozen_horizons.tex` Zeile 41: „Invalid draws are not replaced“.
   - AI-Tabelle (`ai_use.tex`, Zeile „Oct. 23–30“): „Required grouping by economic transaction…“ hat kein Subjekt. Vorschlag: „I required grouping…“. Die Spalte soll in der ersten Person stehen.

4. **Abkürzungen in den Appendizes nicht bei Erstverwendung definiert** (Appendix soll nach Karte selbstständig lesbar sein).
   - „MI“ erscheint in `results.tex` Zeile 99, `t041_frozen_horizons.tex` Zeile 41, `t050_counterfactuals.tex` und anderen. Es ist nur im Haupttext ausgeschrieben. In den Tabellen steht an anderer Stelle „minority interests“, in den Captions „Minority-interest …“. Vorschlag: „minority interest (MI)“ bei der ersten Appendix-Verwendung oder im Variablenverzeichnis ergänzen.
   - „RD“ (Zeile 168) und „DiD“ sind ebenfalls nicht erklärt. „Regression discontinuity (RD)“ ergänzen.
   - Die Kategorien „D, G, H, E, U“ stehen in `results.tex` Zeilen 126 und 140 ohne Erklärung. Ein Satz oder ein Verweis auf die Definition fehlt.

5. **Terminologie.**
   - Die Variablentabelle nennt „Perpetuals / equity“ und die Fußnote „perpetual bonds“. Die Variablennamen sind einheitlich und lesbar. „Perpetuals“ als Kurzform aber vereinheitlichen, z. B. „Perpetual bonds / equity“.
   - `results.tex` Zeile 99: „the shift of each firm's RL1 caused by MI growth“. Der Text ist überall sonst als deskriptiv gekennzeichnet. Vorschlag: „attributable to MI growth“ oder „due to“ (wie in Abschnitt 6.2).
   - `$B_{net}$` und `$\Delta b_{net}$` (Zeile 231 der Diff, Note zu `tab:t043_integration`) sollten `$B_{\text{net}}$` heißen, damit der Index aufrecht gesetzt wird.

6. **Kleinigkeiten.**
   - AI-Tabelle: „Oct.“ in den Datumsspalten, sonst überall „October“. In Tabellen ist die Abkürzung zulässig, aber „Oct.\ 13--14“ bei „Date (2026)“ konsequent halten. Hier ist es konsistent, nur als Hinweis.
   - `results.tex` Zeile 148: „Of Xinhu's two D transactions …“. Xinhu kommt in der Tabelle nicht vor (Hinweis, inhaltlich).
   - `results.tex` Zeile 79 nennt „Sample restrictions, less flexible density fits and estimates by reporting date are documented here or in the replication package“. Die Aussage ist unspezifisch. Hinweis.

## Abnahmekriterien

- **Kriterium 1 (Zahlen aus CSV, Verweise, keine Workflow-Codes):** nicht meine Rolle (Konsistenz). Sprachlich fiel kein Workflow-Code im sichtbaren Text auf. `T0xx` steht nur in `%`-Kommentaren.
- **Kriterium 2 (Build, Overfull-Boxen, Seitenzahl):** nicht meine Rolle. Ich habe `review/T057_latex.txt` nur nach „Overfull“ und „Undefined“ durchsucht und nichts gefunden.
- **Kriterium 3, Punkt 4 (erste Person):** belegt erfüllt. In `appendix/*.tex` kommt weder „our“ noch „we“ vor. „my constructed ratios“ steht in `results.tex` Zeile 76.
- **Kriterium 3, Punkt 7/8 (Sprache der AI-Tabelle, Abkürzungen PI, CNKI, CSSCI):** erfüllt. PI wird in `ai_use.tex` ausgeschrieben, CNKI in der Caption von `tab:cnki_queries`, CSSCI in der PRISMA-Note. Die Spalte „Model“ ist konsistent (kein „version not recorded“). Einzelner Mangel: Befund 3 (fehlendes Subjekt).
- **Punkt 8 (WoS-Note):** sprachlich einwandfrei. Suchdatum und Filter sind getrennt genannt.
- **Typografie (`~` vor `\ref`, Anführungszeichen):** belegt erfüllt. Ein Grep nach Leerzeichen vor `\ref`, `\eqref`, `\cite` in `appendix/` ergab keine Treffer. Anführungszeichen sind ``…'' gesetzt. Es gibt keine britischen Schreibweisen in `appendix/`.
- Alle übrigen Kriterien: nicht meine Rolle.

## Nicht geprüft

- Die Tabellen `t031_samples`, `t040_*`, `t043_trend_cf`, `t043_heterogeneity`, `t043_meas_error`, `t043_integration`, `t046_cash_backing_all` und `sections/t045_crosser_shares` habe ich nur in den Notes der `results.tex` bzw. teilweise gesehen, nicht im vollen Wortlaut. Die Tabellenkörper dort habe ich nicht gelesen.
- Das gebaute PDF und die Abbildungen (`t055_kappa.pdf` und andere) habe ich nicht gesehen. Schriftgrößen und Beschriftungen innerhalb der Grafiken sind daher ungeprüft.
- `AI_USAGE_LOG.md` und `replication/code/15_referee2.R` habe ich nicht gelesen. Beide gehören nicht zum Kernbereich der Sprachprüfung.
- Der Haupttext (außer den geänderten Zeilen in `06_preliminary_analysis.tex`) ist nicht Teil der Karte und wurde nicht geprüft.
