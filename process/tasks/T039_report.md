## Ergebnis

Die Rework-Punkte zu Einheiten, Zahlenbelegen, kompakter Haupttexttabelle und Sprache sowie die WoS/CNKI-Ergänzungen sind umgesetzt. Der selbst ausgeführte Build endet im Haupttext auf Seite [number withheld]; Anhang B umfasst Seiten [number withheld]–[number withheld], also [number withheld] Seiten. Die drei Evidenzstufen bleiben getrennt; neue Schätzungen wurden nicht erzeugt.

## Dateien

- `proposal/sections/02_literature.tex` – finale Suchzahlen, Abkürzungen, Wu-Zitat und Zitationsleerstelle.
- `proposal/sections/03_framework.tex` – konsistente Quoteneinheiten für d, e und L.
- `proposal/sections/04_empirical_model.tex` – Interpretationsregel und Unsicherheit präzisiert.
- `proposal/sections/05_context_data.tex` – fünfzeilige Summary-Tabelle; RL2 durch Firmenbericht belegt.
- `proposal/sections/06_preliminary_analysis.tex` – Sprachbefunde, Messvalidierung und Beitragsinterpretation korrigiert.
- `proposal/main.tex` – Pakete für chinesische Suchstrings und Tabellenumbrüche.
- `proposal/appendix/results.tex` – vollständige Summary-Tabelle, CNKI-Abfragen und korrigierte Umbrüche.
- `proposal/theory_note.tex` – Quoteneinheiten ausdrücklich definiert.
- `proposal/references.bib` – ausschließlich die beiden freigegebenen Einträge wörtlich angehängt.
- `proposal/figures/prisma.pdf` – aktualisierte, bytegleiche Quellenkopie.
- `tasks/T039_report.md` – vollständiger Bericht.
- `review/T039_build/main.pdf` – Prüfbuild.
- `review/T039_build/main.log` – LaTeX-Protokoll.
- `review/T0[number withheld]_build/main.toc` – Abschnittsseiten.
- `review/T0[number withheld]_build/main.aux` – Referenzdaten.
- `review/T0[number withheld]_build/main.bbl` – Literaturverzeichnis.
- `review/T0[number withheld]_build/main.blg` – BibTeX-Protokoll.
- `review/T0[number withheld]_build/main.fdb_latexmk` – Build-Abhängigkeiten.
- `review/T0[number withheld]_build/main.fls` – Build-Dateiliste.
- `review/T0[number withheld]_build/main.out` – PDF-Lesezeichen.

## Ausführung

Der vorgeschriebene Befehl wurde selbst ausgeführt:

[fenced excerpt withheld in public process copy]
[fenced excerpt withheld in public process copy]

Letzte Ausgabezeilen der abschließenden Wiederholung:

[fenced excerpt withheld in public process copy]
[fenced excerpt withheld in public process copy]

Zusätzlich ausgeführt: tatsächliche Wortzählung mit `detex -l`, CSV-Abgleich, Prüfung aller Zitationsschlüssel und Quellenkopien sowie PDF-Rendering und Sichtprüfung. Temporäre Zähl- und Renderdateien liegen unter `/tmp/`.

## Abnahmekriterien

[number withheld]. **Erfüllt:** Haupttext endet auf S. [number withheld]; Literaturverzeichnis beginnt auf S. [number withheld]. Anhang B umfasst S. [number withheld]–[number withheld], Anhang C beginnt auf S. [number withheld]. Der Build hat insgesamt [number withheld] PDF-Seiten. `main.log` enthält keine Fehler, undefinierten Verweise/Zitate oder Overfull-Boxen. Haupttext: zwei Abbildungen und drei kompakte Tabellen mit fünf, sechs beziehungsweise sechs Daten-/Intervallzeilen.

[number withheld]. **Erfüllt:** Vollständiger Zahlennachweis nachstehend. Verkürzte Ergebnisdateinamen beziehen sich auf `replication/outputs/tables/`. Wiederholungen derselben Aussage teilen denselben Nachweis; Anteilswerte werden für Prozent beziehungsweise Prozentpunkte mit [number withheld] multipliziert.

| Bedeutung / Stelle | Zahl im Text | Quelldatei | Zeilenfilter und Spalte / Fundstelle |
|---|---|---|---|
| §§[number withheld]: Hauptpanel | [number withheld] Firmen; [number withheld] Firma-Halbjahre | `t004_panel_counts.csv` | `stage=[number withheld]_final_panel, sample=sample_main`; Summen von `n_firms` und `n_firm_dates` |
| §§[number withheld]: Märkte | [number withheld] A; [number withheld] HK | `t030_coverage.csv` | `date=2016-12-31`; Summe `n_sample_main` nach `market=A/HK` |
| §§[number withheld]: Panelzeit | [number withheld] Halbjahre; December [number withheld], [number withheld]–December [number withheld], [number withheld] | `t030_coverage.csv` | eindeutige `date` bis einschließlich 2022-12-31 |
| §§[number withheld]: Politik | drei Linien; [number withheld]/[number withheld] Prozent; Cash/kurze Schulden ≥[number withheld]; August [number withheld], [number withheld]; zwölf Symposiums-Entwickler; [number withheld] Prozent, je Linie fünf Prozentpunkte weniger | `literature/01_three_red_lines/jin2025deleveraging.pdf` | S. [number withheld], §[number withheld], Absätze [number withheld]–[number withheld]; genaue RL2-Formel separat unten |
| §[number withheld]: Start | January [number withheld], [number withheld] | `literature/01_three_red_lines/jin2025deleveraging.pdf` | S. [number withheld], Introduction |
| §[number withheld]: Presse-Fußnote | October [number withheld], [number withheld]; December [number withheld], [number withheld] | `tasks/T039.md`, Schritt [number withheld]; `state/STATE.md` | vorgegebene S&P-/China-Securities-Journal-Quellen |
[firm-specific excerpt withheld in public process copy]
| §[number withheld]: Liu-Stichprobe | [number withheld] Entwickler | `literature/04_systematic_search/L060_Liu_2025.pdf` | Abstract, gedruckte S. [number withheld] / PDF-S. [number withheld]; MI-Proxy S. [number withheld]–[number withheld] |
| §[number withheld]: regulatorischer Ursprung | [number withheld] | `state/litsearch/screening.xlsx` | `id=L1[number withheld]`; `ai_fulltext_summary`, `decision_ft=include`; PI via DeepL gelesen |
| §[number withheld]: Suchabfragen | sechs WoS-, drei CNKI-Abfragen | `state/litsearch/search_log.csv` | `query_id=Q1…Q6/C1…C3`; Zeilenanzahl |
| §[number withheld]: Suchzeiträume | [number withheld]–[number withheld]; [number withheld]–[number withheld] | `state/litsearch/search_log.csv` | `date_range` der jeweiligen Abfragegruppe |
| §[number withheld]: Treffer | [number withheld] = [number withheld] + [number withheld] | `state/litsearch/prisma_counts.csv` | `identified`, `identified_Web of Science Core Collection`, `identified_CNKI`; `n` |
| §[number withheld]: Duplikate / Screening | [number withheld]; [number withheld] | `state/litsearch/prisma_counts.csv` | `duplicates_removed`, `screened_title_abstract`; `n` |
| §[number withheld]: Volltextfluss | [number withheld] gesucht; zwei nicht beschafft; [number withheld] geprüft; sechs ausgeschlossen; [number withheld] aufgenommen; sieben andere Wege | `state/litsearch/prisma_counts.csv`, `state/litsearch/prisma.tex` | CSV `fulltext_assessed=[number withheld]` bezeichnet hier gesucht; `excluded_fulltext=[number withheld]` = [number withheld][number withheld]; `included=[number withheld]`; übrige Zahlen in Diagrammknoten |
| §[number withheld]: Kernjournale | drei von [number withheld] | `state/litsearch/screening.xlsx` | `database=CNKI`: [number withheld] Zeilen; `core_journal=yes`: L1[number withheld], L1[number withheld], L1[number withheld] |
| §[number withheld]: PRISMA | [number withheld] | `proposal/references.bib` | `page2[number withheld]prisma`, Titel |
| §[number withheld]: Modellkonstanten | τ=[number withheld]; [number withheld] entspricht einem Prozentpunkt; κ∈[[number withheld]]; [number withheld]−κ | `proposal/theory_note.tex` | Variablendefinitionen und κ-Erweiterung; theoretische Konstanten |
| §§[number withheld]: Validierungsumfang | [number withheld] Werte; [number withheld] Firmen; Berichte [number withheld]–[number withheld] | `t040_validation.csv`, `t040_verification.txt` | `row_type=error, ratio=rl1, scope=all, metric=mean`; `n, n_firms`; Berichtszeit im Verifikationsprotokoll |
| §[number withheld]: Nahbereich | [number withheld] Werte; [number withheld]–[number withheld] Prozent | `t040_validation.csv` | `row_type=error, ratio=rl1, scope=published_rl1_0[number withheld]_0[number withheld], metric=MAE`; `n`, Bereich im `scope` |
| §§[number withheld]: Messfehler | [number withheld] Prozentpunkte; [number withheld] Prozent innerhalb eines Prozentpunkts | `t040_validation.csv` | gleicher Nahbereich; `metric=MAE/share_within_1pp`; `estimate` ×[number withheld] |
| §§[number withheld]: Klassifikationsunterschiede | sechs von [number withheld] | `t040_validation.csv` | `row_type=classification, ratio=rl1, scope=all`; Summe der beiden discordanten `estimate`-Zellen: [number withheld][number withheld]; `n=[number withheld]` |
| §[number withheld]: mittlere Abweichung | [number withheld] Prozentpunkte | `t040_validation.csv` | `row_type=error, ratio=rl1, scope=all, metric=mean`; `estimate` ×[number withheld] |
| §[number withheld]: Perpetual-Abdeckung | [number withheld] von [number withheld] | `t023_coverage.csv` | `ratio=rl1, period=post`; `perp_missing, n_regulated` |
[firm-specific excerpt withheld in public process copy]
| §[number withheld]: Pilotberichte | [number withheld] | `replication/data/raw/manual/handcollect/extraction_log.md` | verzeichnete Jahres-/Zwischenberichte |
| Tabelle [number withheld]: RL1 | [number withheld], N=[number withheld]; [number withheld], N=[number withheld] | `t005_summary_stats.csv` | `variable=rl1, period=pre/post`; `median, N` |
| Tabelle [number withheld]: RL2 | [number withheld], N=[number withheld]; [number withheld], N=[number withheld] | `t005_summary_stats.csv` | `variable=rl2, period=pre/post`; `median, N` |
| Tabelle [number withheld]: RL3 | [number withheld], N=[number withheld]; [number withheld], N=[number withheld] | `t005_summary_stats.csv` | `variable=rl3, period=pre/post`; `median, N` |
| Tabelle [number withheld]: MI-Anteil | [number withheld], N=[number withheld]; [number withheld], N=[number withheld] | `t005_summary_stats.csv` | `variable=mi_share, period=pre/post`; `median, N` |
| Tabelle [number withheld]: log Bilanzsumme | [number withheld], N=[number withheld]; [number withheld], N=[number withheld] | `t005_summary_stats.csv` | `variable=log_ta, period=pre/post`; `median, N`; A-shares |
| §[number withheld]: MI-Mittelwerte | [number withheld]; [number withheld] | `t005_summary_stats.csv` | `variable=mi_share, period=pre/post`; `mean` |
| §[number withheld] / Notes: Inferenz | [number withheld] Ziehungen; [number withheld] Prozent | `t023_excess_mass.csv`, `t029_compliance.csv`, zugehörige TeX-Notes | Hauptspezifikationen; `bootstrap_draws`; Perzentilintervalle laut Notes |
| §§[number withheld]: Zeitfenster | [number withheld]H1–[number withheld]H2; [number withheld]H2–[number withheld]H2 | `t023_excess_mass.tex`, `t029_compliance.tex` | Pre-/Post-Definitionen |
| §[number withheld] / Figure [number withheld]: Bunching | Grenze [number withheld]; Binbreite [number withheld]; Grad fünf; Fenster [[number withheld]); Fit [[number withheld]] | `t023_excess_mass.csv`, `.tex` | `ratio=rl1, sample_rule=main_sample, specification=main, threshold=[number withheld]`; `threshold, bin_width, degree, window_lower, window_upper`; Fitgrenzen in Notes |
| §§[number withheld]: Placeboschwellen | [number withheld]; [number withheld] | `t023_excess_mass.csv` | `ratio=rl1, sample_rule=main_sample, specification=main, threshold=[number withheld]/[number withheld]` |
| §[number withheld]: Frozen-Anker | Ende [number withheld]; Ende [number withheld]; Placebo [number withheld]H2–[number withheld]H2 | `t029_compliance.csv`, `.tex` | `window=post/placebo, date=pooled, variant=all, metric=D`; `anchor`; Fenster in Notes |
| §[number withheld]: sieben Vertragsmerkmale | sieben | `replication/data/raw/manual/handcollect/transactions.csv` | `repurchase_buyback`, `fixed_guaranteed_return`, `shortfall_makeup`, `put_redemption`, `listed_firm_guarantee`, `shareholder_loans_surplus_draw`, `exit_deadline` |
| §[number withheld]: DiD-/RD-Zeitpunkte | [number withheld]H1–[number withheld]H2; mid-[number withheld] / end-[number withheld] | `t009_did_main.tex`, `t024_rd_main.tex` | Definitionen von Dosis und erster Stufe |
| §§[number withheld] / Tabelle [number withheld]: Post-b | [number withheld] [[number withheld];[number withheld]]; [number withheld] Beobachtungen; [number withheld] Firmen; [number withheld] beobachtet; [number withheld] vorhergesagt | `t023_excess_mass.csv` | `ratio=rl1, period=post, threshold=[number withheld], sample_rule=main_sample, specification=main`; `b, ci_low, ci_high, n, firms, observed_window, counterfactual_window` |
| §§[number withheld]: Pre-b | [number withheld] [[number withheld];[number withheld]] | `t023_excess_mass.csv` | gleicher Filter, `period=pre`; `b, ci_low, ci_high` |
| §[number withheld]: Dichtetest | [number withheld]; p=[number withheld] | `t024_rd_validity.csv` | `test=density_rddensity`; `estimate_bc, p_robust` |
| §[number withheld] / Tabelle [number withheld]: Leave-one-out | [number withheld]–[number withheld]; alle Intervalle über null | `t031_leave_one_out.csv` | Minimum/Maximum `b`; alle `ci_low>[number withheld]` |
| §[number withheld] / Tabelle [number withheld]: balanciert | [number withheld] [[number withheld];[number withheld]]; [number withheld] Daten; [number withheld] Firmen | `t031_samples.csv` | `sample=B_balanced1[number withheld], period=post`; `b, ci_low, ci_high, firms` |
| §[number withheld]: Spezifikationsgitter | [number withheld] von [number withheld] | `t031_grid.csv` | Anzahl `ci_excludes_zero=TRUE`; Gesamtzeilenzahl |
| §[number withheld]: Stichtagsverlauf | [number withheld] mid-[number withheld]; [number withheld] end-[number withheld]; KI ohne eins ab end-[number withheld] | `t041_bunching_by_date.csv` | `date=2020-06-30/2020-12-31`, `estimate`; für `date>=2021-12-31`, `ci_low>[number withheld]` |
| §[number withheld] / Tabelle [number withheld]: eine Beobachtung je Firma | [number withheld] von [number withheld] | `t041_one_per_firm.csv` | `type=random_date_draw`: [number withheld] Zeilen, davon [number withheld] mit `estimate>[number withheld]` |
| §[number withheld] / Tabelle [number withheld]: geringere Flexibilität | drei Varianten; [number withheld]–[number withheld]; Intervalle über null | `t041_low_flex.csv` | `label=Narrow degree [number withheld]/Narrow degree [number withheld]/Local linear h=[number withheld]`; Minimum/Maximum `b`; `ci_low>[number withheld]` |
| Tabelle [number withheld] Notes: Fits | Grad eins/zwei; [[number withheld]] | `t041_low_flex.csv` | vorgenannte Varianten; `degree, fit_lower, fit_upper` |
| §[number withheld] / Tabelle [number withheld]: Perpetual-Schulden | [number withheld] [[number withheld];[number withheld]] | `t040_robustness.csv` | `scenario=perpetual, metric=T0[number withheld]_b`; `estimate, ci_low, ci_high` |
| §[number withheld]: Umkehranteile | Fenster [[number withheld]); [number withheld] vor; [number withheld] nach | `t023_reversal.csv` | `ratio=rl1, row_type=share, group=near, period=pre/post`; `lower, upper, estimate` ×[number withheld] |
| §[number withheld]: Umkehrdifferenz | [number withheld] [[number withheld];[number withheld]] Prozentpunkte | `t023_reversal.csv` | `ratio=rl1, row_type=difference, period=post_minus_pre_near`; `estimate, ci_low, ci_high` ×[number withheld] |
| §[number withheld]: Umkehr ohne [number withheld]H2-Startdaten | [number withheld] [[number withheld];[number withheld]]; [number withheld] [[number withheld];[number withheld]] | `t031_timing.csv` | `timing=ii_2[number withheld]H1_2[number withheld]H2, statistic=reversal_post_minus_pre, distance=[number withheld], model=bins0[number withheld]/linear`; `estimate, ci_low, ci_high` |
| §[number withheld]: Post-Zerlegung | [number withheld] Eigenkapital; [number withheld] insgesamt; [number withheld] Kreuzungen; [number withheld] Firmen | `t027_decomposition_rl1.csv` | `ratio=rl1, cell=post_crossings, sample=all_events, metric=equity/total`; `median, n_events, n_firms` |
| §[number withheld]: Pre-Zerlegung | [number withheld] Eigenkapital; [number withheld] insgesamt; [number withheld] Kreuzungen; [number withheld] Firmen | `t027_decomposition_rl1.csv` | gleicher Filter, `cell=pre_crossings`; `median, n_events, n_firms` |
| §[number withheld]: EK dominiert | [number withheld] nach; [number withheld] vor | `t027_decomposition_rl1.csv` | `ratio=rl1, cell=post_crossings/pre_crossings, sample=all_events, metric=equity_over_half_decline`; `mean` ×[number withheld] |
| §[number withheld]: MI-Anteil am EK-Term | [number withheld] nach; [number withheld] vor | `t027_decomposition_rl1.csv` | `ratio=rl1, cell=post_crossings/pre_crossings, sample=all_events, metric=equity_mi_share`; `median` |
| §[number withheld]: MI-Anteilsdifferenz | [number withheld] [[number withheld];[number withheld]] | `t027_tests.csv` | `ratio=rl1, comparison=post_crossings_minus_pre_crossings, sample=all_events, metric=equity_mi_share, statistic=median`; `estimate, ci_low, ci_high` |
| §[number withheld]: Schulden fallen | [number withheld] Prozent | `t027_decomposition_rl1.csv` | `ratio=rl1, cell=post_crossings, sample=all_events, metric=ibd_falling`; `mean` ×[number withheld] |
| §§[number withheld] / Tabelle [number withheld]: offizielles b | [number withheld] [[number withheld];[number withheld]] | `t029_counterfactual_bunching.csv` | `window=post, variant=all, scope=paired, specification=main, metric=official`; `estimate, ci_low, ci_high` |
| §§[number withheld] / Tabelle [number withheld]: Frozen-b | [number withheld] [[number withheld];[number withheld]] | `t029_counterfactual_bunching.csv` | gleicher Filter, `metric=frozen`; `estimate, ci_low, ci_high` |
| §[number withheld] / Tabelle [number withheld]: b-Differenz | [number withheld] [[number withheld];[number withheld]] | `t029_counterfactual_bunching.csv` | gleicher Filter, `metric=official_minus_frozen`; `estimate, ci_low, ci_high` |
| §[number withheld] / Tabelle [number withheld]: Post offiziell | [number withheld] [[number withheld];[number withheld]] Prozent | `t029_compliance.csv` | `window=post, date=pooled, variant=all, metric=official`; `estimate, ci_low, ci_high` ×[number withheld] |
| §[number withheld] / Tabelle [number withheld]: Post frozen | [number withheld] [[number withheld];[number withheld]] Prozent | `t029_compliance.csv` | gleicher Filter, `metric=frozen`; `estimate, ci_low, ci_high` ×[number withheld] |
| §§[number withheld] / Tabelle [number withheld]: Post D | [number withheld] [[number withheld];[number withheld]] Prozentpunkte | `t029_compliance.csv` | gleicher Filter, `metric=D`; `estimate, ci_low, ci_high` ×[number withheld] |
| §[number withheld] / Tabelle [number withheld]: Placebo offiziell | [number withheld] [[number withheld];[number withheld]] Prozent | `t029_compliance.csv` | `window=placebo, date=pooled, variant=all, metric=official`; `estimate, ci_low, ci_high` ×[number withheld] |
| §[number withheld] / Tabelle [number withheld]: Placebo frozen | [number withheld] [[number withheld];[number withheld]] Prozent | `t029_compliance.csv` | gleicher Filter, `metric=frozen`; `estimate, ci_low, ci_high` ×[number withheld] |
| §§[number withheld] / Tabelle [number withheld]: Placebo D | [number withheld] [[number withheld];[number withheld]] Prozentpunkte | `t029_compliance.csv` | gleicher Filter, `metric=D`; `estimate, ci_low, ci_high` ×[number withheld] |
| §[number withheld] / Tabelle [number withheld]: gepaarte Stichproben | Post [number withheld]/[number withheld]; Placebo [number withheld]/[number withheld] | `t029_compliance.csv` | `window=post/placebo, date=pooled, variant=all, metric=D`; `n, n_firms` |
| §[number withheld]: Post minus Placebo | [number withheld] [[number withheld];[number withheld]] Prozentpunkte | `t029_compliance.csv` | `window=post_minus_placebo, date=pooled, variant=all, metric=D`; `estimate, ci_low, ci_high` ×[number withheld] |
| §[number withheld]: D-Verlauf | [number withheld] end-[number withheld]; [number withheld] mid-[number withheld] | `t029_compliance.csv` | `window=main_by_date, variant=all, metric=D, date=2020-12-31/2022-06-30`; `estimate` ×[number withheld] |
| §[number withheld]: D mit Perpetual-Schulden | [number withheld] [[number withheld];[number withheld]] Prozentpunkte | `t040_robustness.csv` | `scenario=perpetual, metric=T0[number withheld]_D`; `estimate, ci_low, ci_high` ×[number withheld] |
| §[number withheld]: gleiche Horizonte | [number withheld], zwei, [number withheld] Jahre; nach einem/drei Jahren nicht durchgängig | `t041_frozen_horizons.csv` | `type=post_minus_placebo, anchor=2016-12-31/2017-06-30`; `horizon=[number withheld]/[number withheld]/[number withheld]`: `ci_low>[number withheld]`; Juni-[number withheld]-Anker bei einem Jahr und Dezember-[number withheld]-Anker bei drei Jahren: KI umfasst null |
| §[number withheld]: MI-Vortrend | [number withheld]–[number withheld]; Ende [number withheld] | `t029_distance_es.csv` | `anchor=2019-12-31, outcome=mi, bin=[number withheld]`; `date` in [number withheld]–[number withheld]; Bin `[number withheld] <= g < [number withheld]`, Referenz `g < [number withheld]` |
| §[number withheld]: finanzielle Notlage | [number withheld] | `literature/04_systematic_search/L002_Fan_2026.pdf` | Abstract, S. [number withheld] |
| §[number withheld]: DiD | [number withheld]; SE [number withheld] | `t009_did_main.csv` | `outcome=rl1, term=dose_pre:post`; `coefficient, std_error` |
| §[number withheld]: bedingter Vortrend | p=[number withheld] | `t028_pretrend_controls.csv` | `outcome=rl1, specification=C3-date`; `p_value` |
| §[number withheld]: RD | p=[number withheld]; Grenze [number withheld] Ende [number withheld]; fuzzy mid-[number withheld] | `t024_rd_main.csv`, `.tex` | `design=sharp, specification=fixed_0.[number withheld]_primary, outcome=log_ibd`; `p_robust`; Zeitdefinitionen in Notes |

Jahreszahlen der Autor-Jahr-Zitate stammen aus den jeweiligen Einträgen in `proposal/references.bib`. RL1–RL3, H1–H3, Evidenzstufen, Firmenkennungen und automatisch erzeugte Verweiszähler sind Bezeichnungen, keine zusätzlichen Ergebniszahlen.

[firm-specific excerpt withheld in public process copy]

| Aussage / Zahl | Statement-ID | Quelle / Fundstelle |
|---|---|---|
| Zehn purposiv ausgewählte Firmen; zwei im Text | Pilotdatei / Verifikationsumfang | `state/handcollect/pilot_purposive.csv`, `case_notes_verification.csv` |
[firm-specific excerpt withheld in public process copy]
[firm-specific excerpt withheld in public process copy]
[firm-specific excerpt withheld in public process copy]
[firm-specific excerpt withheld in public process copy]
[firm-specific excerpt withheld in public process copy]
[firm-specific excerpt withheld in public process copy]
[firm-specific excerpt withheld in public process copy]
[firm-specific excerpt withheld in public process copy]
[firm-specific excerpt withheld in public process copy]
[firm-specific excerpt withheld in public process copy]
[firm-specific excerpt withheld in public process copy]
[firm-specific excerpt withheld in public process copy]
[firm-specific excerpt withheld in public process copy]

Die vollständigen Pfade der Fallquellen stehen in `replication/data/raw/manual/handcollect/case_notes.md`. Fußnotendaten und Seitenzahlen folgen den hier zugeordneten Dokumenten. Vorschläge beziehungsweise vertragliche Zeichnungen werden nicht als nachgewiesene Zahlungsströme dargestellt.

[number withheld]. **Erfüllt:** Zentraler Claim unverändert in Abstract, Einleitung, [number withheld] und Conclusion. Targeting, Composition und Substance sind ausdrücklich getrennt. Frozen-MI wird weder als kausaler Politikeffekt noch als Economic-Leverage-Ergebnis interpretiert. Die Matched-Firm-Schätzung steht ausschließlich im Anhang mit Selektionsvorbehalt.

[number withheld]. **Erfüllt:** Methodenabsatz: [number withheld] Wörter. PRISMA enthält WoS+CNKI und ist bytegleich zur freigegebenen Eingabe. Lin/Liu werden diskutiert; Wu ist ergänzt. Alle [number withheld] verwendeten Zitationsschlüssel existieren. Der vorbestehende BibTeX-Dateiteil ist bytegleich; beide neuen Einträge wurden wörtlich angehängt. Alle [number withheld] Tabellen- und [number withheld] Abbildungsdateien mit Gegenstück unter `replication/outputs/` sind bytegleich zu ihren Quellen.

[number withheld]. **Erfüllt:** Tatsächliche Wortzahlen:

| Abschnitt | Budget | Tatsächlich | Bereich ±[number withheld] Prozent |
|---|---:|---:|---:|
| [number withheld] Introduction | [number withheld] | [number withheld] | [number withheld]–[number withheld] |
| [number withheld] Literature | [number withheld] | [number withheld] | [number withheld]–[number withheld] |
| [number withheld] Framework | [number withheld] | [number withheld] | [number withheld]–[number withheld] |
| [number withheld] Context and data | [number withheld] | [number withheld] | [number withheld]–[number withheld] |
| [number withheld] Empirical strategy | [number withheld] | [number withheld] | [number withheld]–[number withheld] |
| [number withheld] Preliminary analysis | [number withheld] | [number withheld] | [number withheld]–[number withheld] |
| [number withheld] Conclusion | [number withheld] | [number withheld] | [number withheld]–[number withheld] |

Zählmethode: Kommentare, komplette Tabellen-/Abbildungsumgebungen sowie balancierte Argumente von `footnote`, `caption`, `section`, `subsection` und `label` entfernen; verbleibenden Text über `detex -l` leiten und Whitespace-Tokens zählen. Abschnitt [number withheld]: **[number withheld] Wörter**, Abschnitt [number withheld]: **[number withheld] Wörter**.

Aus dem vorangegangenen Lauf entfernte Anhangfloats bleiben entfernt: Tabellen `t0[number withheld]_reversal`, `t0[number withheld]_samples`, `t0[number withheld]_timing`, `t0[number withheld]_decomposition_rl1`, `t0[number withheld]_counterfactual_bunching`, `t0[number withheld]_compliance`, `t0[number withheld]_robustness`, `t0[number withheld]_selection`, `t0[number withheld]_soe_heterogeneity`, `t0[number withheld]_soe_coefficients`; Abbildungen `t0[number withheld]_es_rl1`, `t0[number withheld]_es_rl2`, `t0[number withheld]_es_mi_share`, `t0[number withheld]_es_rl2_gap`, `t0[number withheld]_es_jv_ta`, `t0[number withheld]_bunching_rl2`, `t0[number withheld]_bunching_rl3`. Aus dem Haupttext war `t0[number withheld]_compliance_shares` entfernt worden. In diesem Rework wurden keine weiteren Ergebnisfloats entfernt; die vollständige Summary-Tabelle wurde in Anhang B verschoben.

Followups: P4-/Targeting-Korrekturen erhalten; Quoteneinheiten ausdrücklich definiert; WoS/CNKI-Finalisierung, neun Suchstrings, beide BibTeX-Ergänzungen, Wu-Einordnung und RL2-Firmenquelle erledigt. Der alte SOE-Satz einer entfernten Anhangtabelle ist nicht mehr anwendbar.

Review-Abgleich: **Consistency C1–C4 und Language L1–L7 behoben.** Frühere v2-Korrekturen bleiben erhalten: Vorschlagsstatus, offenes κ, ausschüttbarer Jahresgewinn, definierte RMB-/Fiscal-Year-Begriffe und ausschließlich yes/meaning-Fallbelege. Seitenumfang und Build wurden jetzt selbst geprüft.

## Offene Fragen

Keine Stopp-Bedingung ist eingetreten; T040 ist DELIVERED. Daten, Stichprobe, Forschungsfrage, Schätzungen und Kartenstatus wurden nicht geändert. `proposal/appendix/ai_use.tex` blieb bytegleich zur Startfassung.

Nicht erneut geprüft wurden die Schätzprogramme und chinesische Übersetzungen jenseits der PI-freigegebenen Statements. Die Wuxi-Bezugsgröße wurde anhand der Rework-Anweisung und Originalseite geprüft.

Vorbestehende BibTeX-Warnungen zu Monatsstrings (`june`, `july`, `sept`) und fehlenden Journalfeldern zweier Working Papers bleiben bestehen; deren Änderung liegt außerhalb der BibTeX-Schreibfreigabe. Undefinierte Zitate oder LaTeX-Verweise gibt es nicht.

Vorgeschlagener Eintrag für `AI_USAGE_LOG.md` nach Abnahme: „2026-10-28, Codex, T039 REWORK: Quoteneinheiten, kompakte Tabelle, finale WoS/CNKI-Dokumentation und Sprachbefunde überarbeitet; Zahlen gegen CSVs und PI-freigegebene Fallbelege geprüft, Quellenkopien kontrolliert, LaTeX gebaut und gerendert; keine neuen Schätzungen. Unabhängiges Review und PI-Abnahme ausstehend.“ Die Abkürzungsrestpunkte des AI-Anhangs gehören zur separaten T042-Nachpflege.