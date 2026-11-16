## Rolle: language (claude, sonnet) – VERDICT: REWORK


## Befunde

Ich habe nur die Sprache geprüft (Rechtschreibung, Stil, Terminologie, LaTeX-Typografie). Es gibt keine sinnentstellenden Fehler, aber mehrere kleine Mängel, die behoben werden sollten. Zeilenangaben beziehen sich auf die eingefrorenen Dateien.

[number withheld]. **Minuszeichen im Textmodus (Typografie).** Negative Zahlen stehen als Bindestrich (`[number withheld]`) statt als `$-$`. Das ist ein kurzer Strich und kein Minuszeichen und passt nicht zu den Mathe-Minuszeichen in `t055_falsification.tex` und `t055_mi_shift.tex`.
   - `proposal/tables/t043_delta_excess.tex` Zeilen [number withheld]–[number withheld], auch in den Intervallen `[[number withheld], [number withheld]]`.
   - `proposal/tables/t005_summary_stats.tex`, z. B. `[number withheld]`, `[number withheld]`.
   - `proposal/tables/t031_timing.tex` Zeilen [number withheld]–[number withheld].
   - `proposal/tables/t041_frozen_horizons.tex` Zeilen [number withheld], [number withheld], [number withheld], [number withheld].
   - Vorschlag: `$-$` bzw. `$[number withheld]$` setzen, wie in den neu erstellten T055-Tabellen.

[number withheld]. **Prozentschreibweise uneinheitlich.** Die Notes schreiben „percent“ (`[number withheld] percent`, `[number withheld] percent`, `[number withheld] percent`). Spaltenköpfe und Zellen nutzen `[number withheld]\% CI` und `[number withheld]\%`.
   - `t043_delta_excess.tex` Zeile [number withheld], `t055_mi_shift.tex` Zeile [number withheld] und `t031_timing.tex` Zeile [number withheld] haben `[number withheld]\% CI` im Kopf.
   - `t050_counterfactuals.tex` Zeile [number withheld] und Zeile [number withheld] haben `[number withheld]\% CI` und `[number withheld]\%` in der Zelle.
   - `results.tex` Zeilen [number withheld]–[number withheld] haben `[number withheld]\%` in den Zellen.
   - Eine Variante pro Dokument wählen. Zahlen in Zellen und Köpfen mit `\%` sind in Tabellen üblich, dann muss aber auch der Fließtext der Notes entscheiden.

[number withheld]. **Unklare oder holprige Formulierungen.**
   - `results.tex` Zeile [number withheld] (Note zu `tab:pretrend`): „Panel B repeats the specification without controls from the controlled analysis, so that both input tables are shown in full.“ ist schwer verständlich. Vorschlag: „Panel B repeats the no-controls specification next to the controlled one for comparison.“
   - Dieselbe Tabelle: Panel A heißt „Baseline dose event study“ und enthält nur „No controls“. Panel B heißt „with controls“ und enthält ebenfalls „No controls“-Zeilen (`t055_pretrend_tests.tex` Zeilen [number withheld]–[number withheld]). Das ist verwirrend. Vorschlag: Panel B als „Dose event study, with and without controls“ benennen.
   - `results.tex` Zeile [number withheld]: „For contrasts, N and Firms show the first and the benchmark population.“ Vorschlag: „For differences, N and Firms give the numbers for the first and the second period (benchmark) population.“ Die Formulierung „first and the benchmark“ ist unklar.
   - `t043_delta_excess.tex` Zeile [number withheld]: „Invalid draws are counted without replacement“ ist unverständlich. Vorschlag: „Invalid draws are not replaced and are counted as failures.“ Vgl. `t041_frozen_horizons.tex` Zeile [number withheld]: „Invalid draws are not replaced“.
   - AI-Tabelle (`ai_use.tex`, Zeile „Oct. [number withheld]–[number withheld]“): „Required grouping by economic transaction…“ hat kein Subjekt. Vorschlag: „I required grouping…“. Die Spalte soll in der ersten Person stehen.

[number withheld]. **Abkürzungen in den Appendizes nicht bei Erstverwendung definiert** (Appendix soll nach Karte selbstständig lesbar sein).
   - „MI“ erscheint in `results.tex` Zeile [number withheld], `t041_frozen_horizons.tex` Zeile [number withheld], `t050_counterfactuals.tex` und anderen. Es ist nur im Haupttext ausgeschrieben. In den Tabellen steht an anderer Stelle „minority interests“, in den Captions „Minority-interest …“. Vorschlag: „minority interest (MI)“ bei der ersten Appendix-Verwendung oder im Variablenverzeichnis ergänzen.
   - „RD“ (Zeile [number withheld]) und „DiD“ sind ebenfalls nicht erklärt. „Regression discontinuity (RD)“ ergänzen.
   - Die Kategorien „D, G, H, E, U“ stehen in `results.tex` Zeilen [number withheld] und [number withheld] ohne Erklärung. Ein Satz oder ein Verweis auf die Definition fehlt.

[number withheld]. **Terminologie.**
   - Die Variablentabelle nennt „Perpetuals / equity“ und die Fußnote „perpetual bonds“. Die Variablennamen sind einheitlich und lesbar. „Perpetuals“ als Kurzform aber vereinheitlichen, z. B. „Perpetual bonds / equity“.
   - `results.tex` Zeile [number withheld]: „the shift of each firm's RL1 caused by MI growth“. Der Text ist überall sonst als deskriptiv gekennzeichnet. Vorschlag: „attributable to MI growth“ oder „due to“ (wie in Abschnitt [number withheld]).
   - `$B_{net}$` und `$\Delta b_{net}$` (Zeile [number withheld] der Diff, Note zu `tab:t0[number withheld]_integration`) sollten `$B_{\text{net}}$` heißen, damit der Index aufrecht gesetzt wird.

[number withheld]. **Kleinigkeiten.**
   - AI-Tabelle: „Oct.“ in den Datumsspalten, sonst überall „October“. In Tabellen ist die Abkürzung zulässig, aber „Oct.\ [number withheld]-[number withheld]“ bei „Date ([number withheld])“ konsequent halten. Hier ist es konsistent, nur als Hinweis.
   - `results.tex` Zeile [number withheld]: „Of Xinhu's two D transactions …“. Xinhu kommt in der Tabelle nicht vor (Hinweis, inhaltlich).
   - `results.tex` Zeile [number withheld] nennt „Sample restrictions, less flexible density fits and estimates by reporting date are documented here or in the replication package“. Die Aussage ist unspezifisch. Hinweis.

## Abnahmekriterien

- **Kriterium [number withheld] (Zahlen aus CSV, Verweise, keine Workflow-Codes):** nicht meine Rolle (Konsistenz). Sprachlich fiel kein Workflow-Code im sichtbaren Text auf. `T0xx` steht nur in `%`-Kommentaren.
- **Kriterium [number withheld] (Build, Overfull-Boxen, Seitenzahl):** nicht meine Rolle. Ich habe `review/T057_latex.txt` nur nach „Overfull“ und „Undefined“ durchsucht und nichts gefunden.
- **Kriterium [number withheld], Punkt [number withheld] (erste Person):** belegt erfüllt. In `appendix/*.tex` kommt weder „our“ noch „we“ vor. „my constructed ratios“ steht in `results.tex` Zeile [number withheld].
- **Kriterium [number withheld], Punkt [number withheld]/[number withheld] (Sprache der AI-Tabelle, Abkürzungen PI, CNKI, CSSCI):** erfüllt. PI wird in `ai_use.tex` ausgeschrieben, CNKI in der Caption von `tab:cnki_queries`, CSSCI in der PRISMA-Note. Die Spalte „Model“ ist konsistent (kein „version not recorded“). Einzelner Mangel: Befund [number withheld] (fehlendes Subjekt).
- **Punkt [number withheld] (WoS-Note):** sprachlich einwandfrei. Suchdatum und Filter sind getrennt genannt.
- **Typografie (`~` vor `\ref`, Anführungszeichen):** belegt erfüllt. Ein Grep nach Leerzeichen vor `\ref`, `\eqref`, `\cite` in `appendix/` ergab keine Treffer. Anführungszeichen sind ``…'' gesetzt. Es gibt keine britischen Schreibweisen in `appendix/`.
- Alle übrigen Kriterien: nicht meine Rolle.

## Nicht geprüft

- Die Tabellen `t0[number withheld]_samples`, `t0[number withheld]_*`, `t0[number withheld]_trend_cf`, `t0[number withheld]_heterogeneity`, `t0[number withheld]_meas_error`, `t0[number withheld]_integration`, `t0[number withheld]_cash_backing_all` und `sections/t0[number withheld]_crosser_shares` habe ich nur in den Notes der `results.tex` bzw. teilweise gesehen, nicht im vollen Wortlaut. Die Tabellenkörper dort habe ich nicht gelesen.
- Das gebaute PDF und die Abbildungen (`t055_kappa.pdf` und andere) habe ich nicht gesehen. Schriftgrößen und Beschriftungen innerhalb der Grafiken sind daher ungeprüft.
- `AI_USAGE_LOG.md` und `replication/code/15_referee2.R` habe ich nicht gelesen. Beide gehören nicht zum Kernbereich der Sprachprüfung.
- Der Haupttext (außer den geänderten Zeilen in `06_preliminary_analysis.tex`) ist nicht Teil der Karte und wurde nicht geprüft.
