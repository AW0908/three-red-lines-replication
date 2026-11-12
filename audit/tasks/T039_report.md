## Ergebnis

Die Rework-Punkte zu Einheiten, Zahlenbelegen, kompakter Haupttexttabelle und Sprache sowie die WoS/CNKI-Ergänzungen sind umgesetzt. Der selbst ausgeführte Build endet im Haupttext auf Seite 15; Anhang B umfasst Seiten 19–33, also 15 Seiten. Die drei Evidenzstufen bleiben getrennt; neue Schätzungen wurden nicht erzeugt.

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
- `review/T039_build/main.toc` – Abschnittsseiten.
- `review/T039_build/main.aux` – Referenzdaten.
- `review/T039_build/main.bbl` – Literaturverzeichnis.
- `review/T039_build/main.blg` – BibTeX-Protokoll.
- `review/T039_build/main.fdb_latexmk` – Build-Abhängigkeiten.
- `review/T039_build/main.fls` – Build-Dateiliste.
- `review/T039_build/main.out` – PDF-Lesezeichen.

## Ausführung

Der vorgeschriebene Befehl wurde selbst ausgeführt:

[fenced excerpt withheld in public audit]
[fenced excerpt withheld in public audit]

Letzte Ausgabezeilen der abschließenden Wiederholung:

[fenced excerpt withheld in public audit]
[fenced excerpt withheld in public audit]

Zusätzlich ausgeführt: tatsächliche Wortzählung mit `detex -l`, CSV-Abgleich, Prüfung aller Zitationsschlüssel und Quellenkopien sowie PDF-Rendering und Sichtprüfung. Temporäre Zähl- und Renderdateien liegen unter `/tmp/`.

## Abnahmekriterien

1. **Erfüllt:** Haupttext endet auf S. 15; Literaturverzeichnis beginnt auf S. 16. Anhang B umfasst S. 19–33, Anhang C beginnt auf S. 34. Der Build hat insgesamt 39 PDF-Seiten. `main.log` enthält keine Fehler, undefinierten Verweise/Zitate oder Overfull-Boxen. Haupttext: zwei Abbildungen und drei kompakte Tabellen mit fünf, sechs beziehungsweise sechs Daten-/Intervallzeilen.

2. **Erfüllt:** Vollständiger Zahlennachweis nachstehend. Verkürzte Ergebnisdateinamen beziehen sich auf `replication/outputs/tables/`. Wiederholungen derselben Aussage teilen denselben Nachweis; Anteilswerte werden für Prozent beziehungsweise Prozentpunkte mit 100 multipliziert.

| Bedeutung / Stelle | Zahl im Text | Quelldatei | Zeilenfilter und Spalte / Fundstelle |
|---|---|---|---|
| §§1,4: Hauptpanel | 136 Firmen; 1,692 Firma-Halbjahre | `t004_panel_counts.csv` | `stage=10_final_panel, sample=sample_main`; Summen von `n_firms` und `n_firm_dates` |
| §§1,4: Märkte | 80 A; 56 HK | `t030_coverage.csv` | `date=2016-12-31`; Summe `n_sample_main` nach `market=A/HK` |
| §§1,4: Panelzeit | 13 Halbjahre; December 31, 2016–December 31, 2022 | `t030_coverage.csv` | eindeutige `date` bis einschließlich 2022-12-31 |
| §§1,3,4: Politik | drei Linien; 70/100 Prozent; Cash/kurze Schulden ≥1; August 20, 2020; zwölf Symposiums-Entwickler; 15 Prozent, je Linie fünf Prozentpunkte weniger | `literature/01_three_red_lines/jin2025deleveraging.pdf` | S. 9, §2.2, Absätze 1–2; genaue RL2-Formel separat unten |
| §4: Start | January 1, 2021 | `literature/01_three_red_lines/jin2025deleveraging.pdf` | S. 2, Introduction |
| §4: Presse-Fußnote | October 28, 2020; December 25, 2020 | `tasks/T039.md`, Schritt 7; `state/STATE.md` | vorgegebene S&P-/China-Securities-Journal-Quellen |
[firm-specific excerpt withheld in public audit]
| §2: Liu-Stichprobe | 110 Entwickler | `literature/04_systematic_search/L060_Liu_2025.pdf` | Abstract, gedruckte S. 218 / PDF-S. 1; MI-Proxy S. 228–229 |
| §2: regulatorischer Ursprung | 2008 | `state/litsearch/screening.xlsx` | `id=L1238`; `ai_fulltext_summary`, `decision_ft=include`; PI via DeepL gelesen |
| §2: Suchabfragen | sechs WoS-, drei CNKI-Abfragen | `state/litsearch/search_log.csv` | `query_id=Q1…Q6/C1…C3`; Zeilenanzahl |
| §2: Suchzeiträume | 2000–2026; 2010–2026 | `state/litsearch/search_log.csv` | `date_range` der jeweiligen Abfragegruppe |
| §2: Treffer | 1,313 = 1,261 + 52 | `state/litsearch/prisma_counts.csv` | `identified`, `identified_Web of Science Core Collection`, `identified_CNKI`; `n` |
| §2: Duplikate / Screening | 66; 1,247 | `state/litsearch/prisma_counts.csv` | `duplicates_removed`, `screened_title_abstract`; `n` |
| §2: Volltextfluss | 33 gesucht; zwei nicht beschafft; 31 geprüft; sechs ausgeschlossen; 25 aufgenommen; sieben andere Wege | `state/litsearch/prisma_counts.csv`, `state/litsearch/prisma.tex` | CSV `fulltext_assessed=33` bezeichnet hier gesucht; `excluded_fulltext=8` = 2+6; `included=25`; übrige Zahlen in Diagrammknoten |
| §2: Kernjournale | drei von 51 | `state/litsearch/screening.xlsx` | `database=CNKI`: 51 Zeilen; `core_journal=yes`: L1201, L1237, L1238 |
| §2: PRISMA | 2020 | `proposal/references.bib` | `page2021prisma`, Titel |
| §3: Modellkonstanten | τ=0.70; 0.01 entspricht einem Prozentpunkt; κ∈[0,1]; 1−κ | `proposal/theory_note.tex` | Variablendefinitionen und κ-Erweiterung; theoretische Konstanten |
| §§4,6: Validierungsumfang | 64 Werte; 30 Firmen; Berichte 2020–2021 | `t040_validation.csv`, `t040_verification.txt` | `row_type=error, ratio=rl1, scope=all, metric=mean`; `n, n_firms`; Berichtszeit im Verifikationsprotokoll |
| §4: Nahbereich | 52 Werte; 60–80 Prozent | `t040_validation.csv` | `row_type=error, ratio=rl1, scope=published_rl1_060_080, metric=MAE`; `n`, Bereich im `scope` |
| §§4,6: Messfehler | 0.57 Prozentpunkte; 76.9 Prozent innerhalb eines Prozentpunkts | `t040_validation.csv` | gleicher Nahbereich; `metric=MAE/share_within_1pp`; `estimate` ×100 |
| §§4,6: Klassifikationsunterschiede | sechs von 64 | `t040_validation.csv` | `row_type=classification, ratio=rl1, scope=all`; Summe der beiden discordanten `estimate`-Zellen: 1+5; `n=64` |
| §4: mittlere Abweichung | 0.99 Prozentpunkte | `t040_validation.csv` | `row_type=error, ratio=rl1, scope=all, metric=mean`; `estimate` ×100 |
| §4: Perpetual-Abdeckung | 531 von 630 | `t023_coverage.csv` | `ratio=rl1, period=post`; `perp_missing, n_regulated` |
[firm-specific excerpt withheld in public audit]
| §4: Pilotberichte | 22 | `replication/data/raw/manual/handcollect/extraction_log.md` | verzeichnete Jahres-/Zwischenberichte |
| Tabelle 1: RL1 | 0.702, N=797; 0.699, N=630 | `t005_summary_stats.csv` | `variable=rl1, period=pre/post`; `median, N` |
| Tabelle 1: RL2 | 0.789, N=740; 0.748, N=575 | `t005_summary_stats.csv` | `variable=rl2, period=pre/post`; `median, N` |
| Tabelle 1: RL3 | 1.207, N=722; 1.060, N=586 | `t005_summary_stats.csv` | `variable=rl3, period=pre/post`; `median, N` |
| Tabelle 1: MI-Anteil | 0.126, N=770; 0.240, N=604 | `t005_summary_stats.csv` | `variable=mi_share, period=pre/post`; `median, N` |
| Tabelle 1: log Bilanzsumme | 23.987, N=480; 24.331, N=400 | `t005_summary_stats.csv` | `variable=log_ta, period=pre/post`; `median, N`; A-shares |
| §4: MI-Mittelwerte | 0.184; 0.310 | `t005_summary_stats.csv` | `variable=mi_share, period=pre/post`; `mean` |
| §5 / Notes: Inferenz | 999 Ziehungen; 95 Prozent | `t023_excess_mass.csv`, `t029_compliance.csv`, zugehörige TeX-Notes | Hauptspezifikationen; `bootstrap_draws`; Perzentilintervalle laut Notes |
| §§5,6: Zeitfenster | 2017H1–2019H2; 2020H2–2022H2 | `t023_excess_mass.tex`, `t029_compliance.tex` | Pre-/Post-Definitionen |
| §5 / Figure 1: Bunching | Grenze 0.70; Binbreite 0.01; Grad fünf; Fenster [0.66,0.70); Fit [0.40,1.00] | `t023_excess_mass.csv`, `.tex` | `ratio=rl1, sample_rule=main_sample, specification=main, threshold=0.7`; `threshold, bin_width, degree, window_lower, window_upper`; Fitgrenzen in Notes |
| §§5,6: Placeboschwellen | 0.60; 0.80 | `t023_excess_mass.csv` | `ratio=rl1, sample_rule=main_sample, specification=main, threshold=0.6/0.8` |
| §5: Frozen-Anker | Ende 2019; Ende 2016; Placebo 2017H2–2019H2 | `t029_compliance.csv`, `.tex` | `window=post/placebo, date=pooled, variant=all, metric=D`; `anchor`; Fenster in Notes |
| §5: sieben Vertragsmerkmale | sieben | `replication/data/raw/manual/handcollect/transactions.csv` | `repurchase_buyback`, `fixed_guaranteed_return`, `shortfall_makeup`, `put_redemption`, `listed_firm_guarantee`, `shareholder_loans_surplus_draw`, `exit_deadline` |
| §5: DiD-/RD-Zeitpunkte | 2017H1–2019H2; mid-2020 / end-2019 | `t009_did_main.tex`, `t024_rd_main.tex` | Definitionen von Dosis und erster Stufe |
| §§1,6,7 / Tabelle 2: Post-b | 3.14 [1.01;5.84]; 630 Beobachtungen; 132 Firmen; 118 beobachtet; 66.1 vorhergesagt | `t023_excess_mass.csv` | `ratio=rl1, period=post, threshold=0.7, sample_rule=main_sample, specification=main`; `b, ci_low, ci_high, n, firms, observed_window, counterfactual_window` |
| §§1,6: Pre-b | −0.88 [−1.85;0.43] | `t023_excess_mass.csv` | gleicher Filter, `period=pre`; `b, ci_low, ci_high` |
| §6: Dichtetest | −2.83; p=0.218 | `t024_rd_validity.csv` | `test=density_rddensity`; `estimate_bc, p_robust` |
| §6 / Tabelle 2: Leave-one-out | 2.84–3.31; alle Intervalle über null | `t031_leave_one_out.csv` | Minimum/Maximum `b`; alle `ci_low>0` |
| §6 / Tabelle 2: balanciert | 3.24 [1.02;6.19]; 13 Daten; 115 Firmen | `t031_samples.csv` | `sample=B_balanced13, period=post`; `b, ci_low, ci_high, firms` |
| §6: Spezifikationsgitter | 63 von 72 | `t031_grid.csv` | Anzahl `ci_excludes_zero=TRUE`; Gesamtzeilenzahl |
| §6: Stichtagsverlauf | 0.50 mid-2020; 1.48 end-2020; KI ohne eins ab end-2021 | `t041_bunching_by_date.csv` | `date=2020-06-30/2020-12-31`, `estimate`; für `date>=2021-12-31`, `ci_low>1` |
| §6 / Tabelle 2: eine Beobachtung je Firma | 998 von 999 | `t041_one_per_firm.csv` | `type=random_date_draw`: 999 Zeilen, davon 998 mit `estimate>0` |
| §6 / Tabelle 2: geringere Flexibilität | drei Varianten; 2.35–5.45; Intervalle über null | `t041_low_flex.csv` | `label=Narrow degree 1/Narrow degree 2/Local linear h=0.10`; Minimum/Maximum `b`; `ci_low>0` |
| Tabelle 2 Notes: Fits | Grad eins/zwei; [0.55,0.85] | `t041_low_flex.csv` | vorgenannte Varianten; `degree, fit_lower, fit_upper` |
| §6 / Tabelle 2: Perpetual-Schulden | 2.58 [0.52;5.13] | `t040_robustness.csv` | `scenario=perpetual, metric=T023_b`; `estimate, ci_low, ci_high` |
| §6: Umkehranteile | Fenster [0.68,0.70); 55.6 vor; 23.0 nach | `t023_reversal.csv` | `ratio=rl1, row_type=share, group=near, period=pre/post`; `lower, upper, estimate` ×100 |
| §6: Umkehrdifferenz | −32.6 [−53.7;−12.7] Prozentpunkte | `t023_reversal.csv` | `ratio=rl1, row_type=difference, period=post_minus_pre_near`; `estimate, ci_low, ci_high` ×100 |
| §6: Umkehr ohne 2020H2-Startdaten | −0.275 [−0.637;0.088]; −0.197 [−0.389;−0.004] | `t031_timing.csv` | `timing=ii_2021H1_2022H2, statistic=reversal_post_minus_pre, distance=0.005, model=bins001/linear`; `estimate, ci_low, ci_high` |
| §6: Post-Zerlegung | −0.107 Eigenkapital; −0.162 insgesamt; 33 Kreuzungen; 31 Firmen | `t027_decomposition_rl1.csv` | `ratio=rl1, cell=post_crossings, sample=all_events, metric=equity/total`; `median, n_events, n_firms` |
| §6: Pre-Zerlegung | −0.154 Eigenkapital; −0.218 insgesamt; 21 Kreuzungen; 19 Firmen | `t027_decomposition_rl1.csv` | gleicher Filter, `cell=pre_crossings`; `median, n_events, n_firms` |
| §6: EK dominiert | 69.7 nach; 57.1 vor | `t027_decomposition_rl1.csv` | `ratio=rl1, cell=post_crossings/pre_crossings, sample=all_events, metric=equity_over_half_decline`; `mean` ×100 |
| §6: MI-Anteil am EK-Term | 0.54 nach; 0.18 vor | `t027_decomposition_rl1.csv` | `ratio=rl1, cell=post_crossings/pre_crossings, sample=all_events, metric=equity_mi_share`; `median` |
| §6: MI-Anteilsdifferenz | 0.37 [−0.11;0.75] | `t027_tests.csv` | `ratio=rl1, comparison=post_crossings_minus_pre_crossings, sample=all_events, metric=equity_mi_share, statistic=median`; `estimate, ci_low, ci_high` |
| §6: Schulden fallen | 66.7 Prozent | `t027_decomposition_rl1.csv` | `ratio=rl1, cell=post_crossings, sample=all_events, metric=ibd_falling`; `mean` ×100 |
| §§1,6 / Tabelle 3: offizielles b | 3.18 [1.01;6.01] | `t029_counterfactual_bunching.csv` | `window=post, variant=all, scope=paired, specification=main, metric=official`; `estimate, ci_low, ci_high` |
| §§1,6,7 / Tabelle 3: Frozen-b | −0.52 [−1.83;1.08] | `t029_counterfactual_bunching.csv` | gleicher Filter, `metric=frozen`; `estimate, ci_low, ci_high` |
| §6 / Tabelle 3: b-Differenz | 3.71 [1.60;6.14] | `t029_counterfactual_bunching.csv` | gleicher Filter, `metric=official_minus_frozen`; `estimate, ci_low, ci_high` |
| §6 / Tabelle 3: Post offiziell | 51.2 [42.9;59.1] Prozent | `t029_compliance.csv` | `window=post, date=pooled, variant=all, metric=official`; `estimate, ci_low, ci_high` ×100 |
| §6 / Tabelle 3: Post frozen | 39.7 [31.9;48.2] Prozent | `t029_compliance.csv` | gleicher Filter, `metric=frozen`; `estimate, ci_low, ci_high` ×100 |
| §§1,6,7 / Tabelle 3: Post D | 11.5 [6.9;16.2] Prozentpunkte | `t029_compliance.csv` | gleicher Filter, `metric=D`; `estimate, ci_low, ci_high` ×100 |
| §6 / Tabelle 3: Placebo offiziell | 48.5 [39.9;56.8] Prozent | `t029_compliance.csv` | `window=placebo, date=pooled, variant=all, metric=official`; `estimate, ci_low, ci_high` ×100 |
| §6 / Tabelle 3: Placebo frozen | 44.5 [36.7;52.6] Prozent | `t029_compliance.csv` | gleicher Filter, `metric=frozen`; `estimate, ci_low, ci_high` ×100 |
| §§1,6,7 / Tabelle 3: Placebo D | 4.1 [1.3;7.3] Prozentpunkte | `t029_compliance.csv` | gleicher Filter, `metric=D`; `estimate, ci_low, ci_high` ×100 |
| §6 / Tabelle 3: gepaarte Stichproben | Post 602/129; Placebo 616/125 | `t029_compliance.csv` | `window=post/placebo, date=pooled, variant=all, metric=D`; `n, n_firms` |
| §6: Post minus Placebo | 7.4 [3.1;11.8] Prozentpunkte | `t029_compliance.csv` | `window=post_minus_placebo, date=pooled, variant=all, metric=D`; `estimate, ci_low, ci_high` ×100 |
| §6: D-Verlauf | 7.0 end-2020; 16.8 mid-2022 | `t029_compliance.csv` | `window=main_by_date, variant=all, metric=D, date=2020-12-31/2022-06-30`; `estimate` ×100 |
| §6: D mit Perpetual-Schulden | 9.3 [5.2;13.4] Prozentpunkte | `t040_robustness.csv` | `scenario=perpetual, metric=T029_D`; `estimate, ci_low, ci_high` ×100 |
| §6: gleiche Horizonte | 1.5, zwei, 2.5 Jahre; nach einem/drei Jahren nicht durchgängig | `t041_frozen_horizons.csv` | `type=post_minus_placebo, anchor=2016-12-31/2017-06-30`; `horizon=1.5/2/2.5`: `ci_low>0`; Juni-2017-Anker bei einem Jahr und Dezember-2016-Anker bei drei Jahren: KI umfasst null |
| §6: MI-Vortrend | 2016–2018; Ende 2019 | `t029_distance_es.csv` | `anchor=2019-12-31, outcome=mi, bin=3`; `date` in 2016–2018; Bin `0 <= g < 0.10`, Referenz `g < -0.10` |
| §6: finanzielle Notlage | 2021 | `literature/04_systematic_search/L002_Fan_2026.pdf` | Abstract, S. 1 |
| §6: DiD | −0.0149; SE 0.0101 | `t009_did_main.csv` | `outcome=rl1, term=dose_pre:post`; `coefficient, std_error` |
| §6: bedingter Vortrend | p=0.0002 | `t028_pretrend_controls.csv` | `outcome=rl1, specification=C3-date`; `p_value` |
| §6: RD | p=0.095; Grenze 0.70 Ende 2019; fuzzy mid-2020 | `t024_rd_main.csv`, `.tex` | `design=sharp, specification=fixed_0.10_primary, outcome=log_ibd`; `p_robust`; Zeitdefinitionen in Notes |

Jahreszahlen der Autor-Jahr-Zitate stammen aus den jeweiligen Einträgen in `proposal/references.bib`. RL1–RL3, H1–H3, Evidenzstufen, Firmenkennungen und automatisch erzeugte Verweiszähler sind Bezeichnungen, keine zusätzlichen Ergebniszahlen.

[firm-specific excerpt withheld in public audit]

| Aussage / Zahl | Statement-ID | Quelle / Fundstelle |
|---|---|---|
| Zehn purposiv ausgewählte Firmen; zwei im Text | Pilotdatei / Verifikationsumfang | `state/handcollect/pilot_purposive.csv`, `case_notes_verification.csv` |
[firm-specific excerpt withheld in public audit]
[firm-specific excerpt withheld in public audit]
[firm-specific excerpt withheld in public audit]
[firm-specific excerpt withheld in public audit]
[firm-specific excerpt withheld in public audit]
[firm-specific excerpt withheld in public audit]
[firm-specific excerpt withheld in public audit]
[firm-specific excerpt withheld in public audit]
[firm-specific excerpt withheld in public audit]
[firm-specific excerpt withheld in public audit]
[firm-specific excerpt withheld in public audit]
[firm-specific excerpt withheld in public audit]
[firm-specific excerpt withheld in public audit]

Die vollständigen Pfade der Fallquellen stehen in `replication/data/raw/manual/handcollect/case_notes.md`. Fußnotendaten und Seitenzahlen folgen den hier zugeordneten Dokumenten. Vorschläge beziehungsweise vertragliche Zeichnungen werden nicht als nachgewiesene Zahlungsströme dargestellt.

4. **Erfüllt:** Zentraler Claim unverändert in Abstract, Einleitung, 6.2 und Conclusion. Targeting, Composition und Substance sind ausdrücklich getrennt. Frozen-MI wird weder als kausaler Politikeffekt noch als Economic-Leverage-Ergebnis interpretiert. Die Matched-Firm-Schätzung steht ausschließlich im Anhang mit Selektionsvorbehalt.

5. **Erfüllt:** Methodenabsatz: 109 Wörter. PRISMA enthält WoS+CNKI und ist bytegleich zur freigegebenen Eingabe. Lin/Liu werden diskutiert; Wu ist ergänzt. Alle 26 verwendeten Zitationsschlüssel existieren. Der vorbestehende BibTeX-Dateiteil ist bytegleich; beide neuen Einträge wurden wörtlich angehängt. Alle 18 Tabellen- und 19 Abbildungsdateien mit Gegenstück unter `replication/outputs/` sind bytegleich zu ihren Quellen.

6. **Erfüllt:** Tatsächliche Wortzahlen:

| Abschnitt | Budget | Tatsächlich | Bereich ±10 Prozent |
|---|---:|---:|---:|
| 1 Introduction | 650 | 649 | 585–715 |
| 2 Literature | 700 | 635 | 630–770 |
| 3 Framework | 600 | 578 | 540–660 |
| 4 Context and data | 750 | 680 | 675–825 |
| 5 Empirical strategy | 750 | 676 | 675–825 |
| 6 Preliminary analysis | 1,900 | 1,712 | 1,710–2,090 |
| 7 Conclusion | 300 | 277 | 270–330 |

Zählmethode: Kommentare, komplette Tabellen-/Abbildungsumgebungen sowie balancierte Argumente von `footnote`, `caption`, `section`, `subsection` und `label` entfernen; verbleibenden Text über `detex -l` leiten und Whitespace-Tokens zählen. Abschnitt 6.3: **447 Wörter**, Abschnitt 6.4: **99 Wörter**.

Aus dem vorangegangenen Lauf entfernte Anhangfloats bleiben entfernt: Tabellen `t023_reversal`, `t031_samples`, `t031_timing`, `t027_decomposition_rl1`, `t029_counterfactual_bunching`, `t029_compliance`, `t011_robustness`, `t025_selection`, `t015_soe_heterogeneity`, `t019_soe_coefficients`; Abbildungen `t009_es_rl1`, `t009_es_rl2`, `t009_es_mi_share`, `t009_es_rl2_gap`, `t009_es_jv_ta`, `t005_bunching_rl2`, `t005_bunching_rl3`. Aus dem Haupttext war `t029_compliance_shares` entfernt worden. In diesem Rework wurden keine weiteren Ergebnisfloats entfernt; die vollständige Summary-Tabelle wurde in Anhang B verschoben.

Followups: P4-/Targeting-Korrekturen erhalten; Quoteneinheiten ausdrücklich definiert; WoS/CNKI-Finalisierung, neun Suchstrings, beide BibTeX-Ergänzungen, Wu-Einordnung und RL2-Firmenquelle erledigt. Der alte SOE-Satz einer entfernten Anhangtabelle ist nicht mehr anwendbar.

Review-Abgleich: **Consistency C1–C4 und Language L1–L7 behoben.** Frühere v2-Korrekturen bleiben erhalten: Vorschlagsstatus, offenes κ, ausschüttbarer Jahresgewinn, definierte RMB-/Fiscal-Year-Begriffe und ausschließlich yes/meaning-Fallbelege. Seitenumfang und Build wurden jetzt selbst geprüft.

## Offene Fragen

Keine Stopp-Bedingung ist eingetreten; T040 ist DELIVERED. Daten, Stichprobe, Forschungsfrage, Schätzungen und Kartenstatus wurden nicht geändert. `proposal/appendix/ai_use.tex` blieb bytegleich zur Startfassung.

Nicht erneut geprüft wurden die Schätzprogramme und chinesische Übersetzungen jenseits der PI-freigegebenen Statements. Die Wuxi-Bezugsgröße wurde anhand der Rework-Anweisung und Originalseite geprüft.

Vorbestehende BibTeX-Warnungen zu Monatsstrings (`june`, `july`, `sept`) und fehlenden Journalfeldern zweier Working Papers bleiben bestehen; deren Änderung liegt außerhalb der BibTeX-Schreibfreigabe. Undefinierte Zitate oder LaTeX-Verweise gibt es nicht.

Vorgeschlagener Eintrag für `AI_USAGE_LOG.md` nach Abnahme: „2026-10-28, Codex, T039 REWORK: Quoteneinheiten, kompakte Tabelle, finale WoS/CNKI-Dokumentation und Sprachbefunde überarbeitet; Zahlen gegen CSVs und PI-freigegebene Fallbelege geprüft, Quellenkopien kontrolliert, LaTeX gebaut und gerendert; keine neuen Schätzungen. Unabhängiges Review und PI-Abnahme ausstehend.“ Die Abkürzungsrestpunkte des AI-Anhangs gehören zur separaten T042-Nachpflege.