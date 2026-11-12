## Rolle: language (claude, sonnet) – VERDICT: REWORK


Ich habe die Sprache der LaTeX-Texte geprüft, vor allem anhand von `review/T062_proposal.diff`, plus die CSV-Werte, wo Zahlen im Text stehen. Die Übersetzung ist fehlerfrei (`review/T062_latex.txt`). Es gibt keine sinnentstellenden Fehler, aber mehrere Korrekturen.

## Befunde

1. **Interne Projektkürzel im einzureichenden Text.** `proposal/tables/t061_results.tex`, Fußnote: „following T023“ und „t061\_estimates.csv“. Eine Task-ID und ein Dateiname gehören nicht in ein Proposal.
   - Vorschlag: „following the placebo procedure in Appendix~\ref{app:res_targeting}“ oder die Verweise streichen.
   - Entsprechend „All six estimation rows have N, firms, in-range counts and actual threshold-window support in t061\_estimates.csv“ umformulieren: „Observation counts and window support are reported in the replication package.“
2. **Falsches Minuszeichen in `proposal/tables/t061_results.tex`.**
   - Die Tabelle setzt das Bindestrich-Minus: `-0.177`, `-0.750`, `-0.574`, `[-1.675, 0.439]`, `-0.223`, `-0.877` usw. Der Haupttext nutzt `$-0.88$` und `$[-0.59,6.25]$`.
   - Vorschlag: jede negative Zahl als `$-0.177$` bzw. `$[-1.675,0.439]$` setzen.
3. **Uneinheitliche Zahlenformate.**
   - In `proposal/tables/t061_results.tex` stehen drei Nachkommastellen (4.020, [1.671, 6.797], 4.594). Haupttext und Tabelle 3 (`proposal/tables/t051_robustness.tex`) nutzen zwei (4.02, 4.59).
   - Die Klammern haben ein Leerzeichen nach dem Komma (`[2.155, 7.469]`), im Text nicht (`$[2.15,7.47]$`). Spaltenüberschrift „95\% CI“ ohne Math ist in Ordnung, die Werte nicht.
   - Vorschlag: durchgehend zwei Stellen und das Format `$[a,b]$`. Wenn drei Stellen im Appendix gewollt sind, die Fußnote darauf hinweisen lassen.
4. **Uneinheitlicher Begriff „liability-to-assets ratio“.**
   - `proposal/main.tex`, Abstract: „liability-to-assets ratio“.
   - `proposal/sections/06_preliminary_analysis.tex`, Z. 19: „liability-to-asset ratio“.
   - `proposal/theory_note.tex`, Z. 76 (nicht im eingefrorenen Umfang): „liability-to-assets ratio“.
   - Vorschlag: überall „liability-to-assets ratio“.
5. **Schreibweise „difference-in-bunching“.**
   - Als Substantiv mit Bindestrichen konsistent verwendet, auch in der Gleichungsbeschriftung und im Appendix-Titel.
   - Aber `proposal/sections/04_empirical_model.tex` sagt „the difference-in-bunching at 0.70 is“, der Appendix-Titel „difference-in-bunching“ ohne Artikel, und `proposal/sections/06_preliminary_analysis.tex` „Their difference in pre-to-post changes“. Das ist akzeptabel, sollte aber bewusst so bleiben.
   - Hinweis: Bei der ersten Nennung in `proposal/sections/04_empirical_model.tex` fehlt die Klammerdefinition ($\Delta\Delta b$) im Satz selbst. Sie steht nur in der Gleichung. Vorschlag: „the difference-in-bunching, $\Delta\Delta b$, at 0.70 is“.
6. **Abkürzungen ohne Definition am neuen Auftreten.**
   - „SOE“ in `proposal/sections/05_context_data.tex`, Z. 28 und `proposal/sections/06_preliminary_analysis.tex`, Z. 150. Vorschlag: einmal „state-owned enterprise (SOE)“.
   - „HK“ in `proposal/tables/t049_threats.tex`, Z. 18. Der Fließtext schreibt „Hong Kong“. Vorschlag: „Hong Kong“ ausschreiben oder in der Tabelle konsistent „HK“ erklären.
   - „Wind“ und „AKShare“ stehen in `proposal/sections/05_context_data.tex` jetzt ohne die frühere Erklärung („Wind Financial Terminal, a Chinese financial-data service“). Die Streichung ist stilistisch vertretbar, aber „Wind“ ist so für Leser ohne Vorwissen nicht mehr erkennbar. Vorschlag: „the Wind financial-data service“.
7. **Stil: elliptische oder gedrängte Sätze durch die Kürzungen.**
   - `proposal/sections/04_empirical_model.tex`: „I bootstrap whole firms within each group, pairing periods; comparisons using all developers and balanced developers are co-primary because the control is balanced.“ Vorschlag: „I bootstrap whole firms within each group and keep each firm's two periods paired; the comparisons with all developers and with balanced developers are co-primary because the control panel is balanced.“
   - `proposal/sections/04_empirical_model.tex`: „Absent the policy, threshold concentration must have changed equally in both groups. Under this assumption, …“ Das ist eine Annahme, keine Feststellung. Vorschlag: „I assume that, absent the policy, threshold concentration would have changed equally in both groups.“
   - `proposal/sections/06_preliminary_analysis.tex`: „These support developer-specific concentration under smooth densities and equal counterfactual changes.“ Vorschlag: „These results support developer-specific concentration, given smooth densities and equal counterfactual changes.“
   - `proposal/sections/06_preliminary_analysis.tex`: „…and 0.003 $[-1.37,1.32]$, respectively; both intervals include zero (same table).“ Vorschlag: „(Appendix Table~\ref{tab:t061_control})“ statt „same table“.
   - `proposal/sections/01_introduction.tex`: „compare its change with unregulated firms“ ist schwer lesbar neben „relative to a smooth density“. Vorschlag: „compare its change with that of unregulated firms“.
8. **Interpunktion, Variante und Typografie.**
   - `proposal/sections/05_context_data.tex`: „December 2016 to December 2022“ gegenüber der früheren Schreibweise mit Datum. Das ist konsistent, kein Fehler.
   - Die Fußnote in `proposal/tables/t051_robustness.tex` beginnt mit „Rows 1--5: pre-to-post changes, with pre/post developer observations; …“. Ohne Verb ist das für eine Fußnote üblich, aber „pre-to-post changes, with pre/post developer observations“ ist unklar. Vorschlag: „Rows 1--5 show pre-to-post changes; the observation counts are pre/post developer observations.“
   - In derselben Fußnote steht „Pointwise firm-bootstrap intervals, 999 draws; comparisons resample firms within groups.“ Vorschlag: „Intervals are pointwise firm-bootstrap percentile intervals with 999 draws; comparisons resample firms within each group.“
   - Im Appendix (`proposal/appendix/results.tex`) schreibt der Text „I use the same analysis dates and cleaning rules as for developers: advance receipts and contract liabilities are summed, both missing components are set to zero and flagged, and nonpositive adjusted denominators give missing RL1.“ Das ist ein sehr langer Satz mit Doppelpunkt. Vorschlag: in zwei Sätze teilen.
   - Der Bildunterschrifttext in `proposal/appendix/results.tex` enthält „fifth-degree polynomial“, der Haupttext verwendet nirgends „degree“. Das ist kein Fehler, nur ein Hinweis.
9. **Hinweis (nicht meine Rolle, nur markiert).**
   - Die Aufgabenkarte nennt „62 roster firms without full coverage“. Die Texte nennen 64 Firmen ohne volle Abdeckung und 62 ohne verfügbare Fehlergründe. Die Summen in `replication/outputs/tables/t061_failure_by_sector.csv` stimmen mit dem Text überein (missing_firms 64, historical_errors_unavailable 62). Die Karte formuliert demnach ungenau, der Text ist korrekt.
   - Ich habe die Zahlen im Abstract (4.0), die ΔΔb-Werte (4.59/4.48/2.67) und ihre Konfidenzintervalle gegen `replication/outputs/tables/t061_diff_bunching.csv` geprüft. Sie stimmen. Die Beobachtungszahlen 4,512/3,760 und 752 Firmen stimmen ebenfalls.

## Abnahmekriterien

1. **Jede Zahl aus einer CSV; jede zitierte Tabelle enthält die zitierte Zahl.** Teilweise geprüft. Die ΔΔb-Werte, Intervalle, 752 Firmen, 4.512/3.760 Beobachtungen und 64/62 stimmen mit `t061_diff_bunching.csv` und `t061_failure_by_sector.csv` überein. Die Werte −0.57, −0.18, −0.75 und die Placebo-Werte −0.57/0.003 habe ich nur gegen die eingefrorene `proposal/tables/t061_results.tex` geprüft, nicht gegen `t061_estimates.csv`. Dort stehen sie konsistent. Das ist eine Aufgabe der Rolle consistency.
2. **Haupttext endet auf Seite 15; Build sauber.** Der Build ist sauber (`review/T062_latex.txt`). Die Seitenzahl konnte ich nicht prüfen (kein PDF-Zugriff in dieser Sitzung).
3. **Punkte 1–9 mit je einer Zeile im Bericht.** Nicht meine Rolle.

Sprachlich betrifft die Abnahme nur die Punkte oben. Der Abstract hat 87 Wörter (≤ 100 erfüllt).

## Nicht geprüft

- Seitenzahl des Haupttextes und Layout der beiden Abbildungen (`proposal/figures/t055_kappa.pdf`, `proposal/figures/t061_control_density.pdf`). Ich konnte keine PDF öffnen und keinen Befehl ausführen.
- Die vollständige Rechtschreibung in Teilen der Dateien, die der Diff nicht zeigt (z. B. unveränderte Passagen in `proposal/appendix/results.tex` und `proposal/sections/06_preliminary_analysis.tex`). Mehrere dieser Zeilen wurden als „Omitted long matching line“ abgeschnitten.
- Die inhaltliche Richtigkeit von Schätzung, Bootstrap und Datenroute (Rollen estimation, data). Ob die Zahlen in `t061_estimates.csv` mit allen Textstellen übereinstimmen, prüft die Rolle consistency.
- `AI_USAGE_LOG.md` habe ich nicht gelesen.
