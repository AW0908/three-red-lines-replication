## Ergebnis

Der Online Appendix hat ein Deckblatt auf A1 und ein separates Inhaltsverzeichnis auf A2; die Anhangsseiten laufen bis A36. Der gekürzte Haupttext endet auf Seite 15. Alle 48 Anhangsdisplays behalten ihre Nummern und sind referenziert; der Build enthält keine LaTeX-Warnungen oder übervollen Boxen.

## Dateien

- `proposal/main.tex` – Deckblatt, Anhangsseitenzählung und zweite Inhaltsübersicht.
- `proposal/preamble.tex` – getrennte Inhaltsdatei und ausreichend breite Seitenzahlenspalte.
- `proposal/appendix/results.tex` – acht fehlende Display-Verweise ergänzt; flexible Platzierung der Datumsabbildungen.
- `proposal/sections/02_literature.tex` – Anhangsverweise aktualisiert.
- `proposal/sections/03_framework.tex` – Anhangsverweis aktualisiert.
- `proposal/sections/04_empirical_model.tex` – Anhangsverweise aktualisiert.
- `proposal/sections/05_context_data.tex` – Anhangsverweise einschließlich Fußnote aktualisiert.
- `proposal/sections/06_preliminary_analysis.tex` – Verweise aktualisiert und Wiederholungen gekürzt.
- `proposal/sections/07_conclusion.tex` – Schlussfolgerung und Arbeitsplan gekürzt.
- `proposal/tables/t050_counterfactuals.tex` – Anhangsverweis aktualisiert.
- `proposal/tables/t051_robustness.tex` – Anhangsverweise aktualisiert.
- `tasks/T067_report.md` – vollständiger Bericht.
- `review/T067_build/main.pdf` – kompiliertes Dokument mit 55 PDF-Seiten.
- `review/T067_build/main.log`, `review/T067_build/build_stdout.log` – Build-Protokolle.
- `review/T067_build/main.aux`, `review/T067_build/main.toc`, `review/T067_build/main.atoc` – Label- und Inhaltsverzeichnisnachweise.
- `review/T067_build/main.bbl`, `review/T067_build/main.blg`, `review/T067_build/main.fdb_latexmk`, `review/T067_build/main.fls`, `review/T067_build/main.out`, `review/T067_build/main.xdv` – automatisch erzeugte Build-Dateien.
- `review/T067_build/qa/page-01.png` bis `review/T067_build/qa/page-55.png` sowie `review/T067_build/qa/contact-1.png` bis `review/T067_build/qa/contact-7.png` – gerenderte und visuell geprüfte Seiten.

## Ausführung

[fenced excerpt withheld in public audit]
[fenced excerpt withheld in public audit]

Exit-Code: 0. Letzte Ausgabe der abschließenden Wiederholung:

[fenced excerpt withheld in public audit]
[fenced excerpt withheld in public audit]

Der vollständige Build nach den Änderungen steht in `review/T067_build/build_stdout.log`. Zusätzlich wurden Labels, Textverweise, PDF-Seitenfolge und Warnungen geprüft sowie alle 55 Seiten gerendert und visuell kontrolliert.

## Abnahmekriterien

1. **Erfüllt:** Deckblatt A1, Anhangsübersicht A2, lückenlose Seitenzählung bis A36. Das Hauptinhaltsverzeichnis enthält genau einen „Online Appendix“-Eintrag; die separate Übersicht enthält zehn Abschnitts-/Unterabschnittseinträge. Keine unaufgelösten Verweise und keine unreferenzierten Anhangsdisplays.
2. **Erfüllt:** `sec:main_end` steht in `main.aux` auf Seite 15; Literatur auf Seiten 16–17. Exit-Code 0, null LaTeX-/Paketwarnungen und null Overfull-Boxen.
3. **Erfüllt:** Punkte 1–4 und sämtliche Display-Zuordnungen sind nachfolgend dokumentiert.

- **Punkt 1 – erfüllt:** Deckblatt mit Titel, Autor, Kurs, Datum und Abgrenzungssatz. Das Deckblatt zählt als A1. Seitenzahlen ohne Bindestrich; Floatnummern unverändert.
- **Punkt 2 – teilweise umgesetzt:** Acht fehlende Referenzen ergänzt; beide Datumsabbildungen verwenden `[htbp]`. Bestehende Abschnittsbarrieren, Breiten und Schriftgrößen bleiben erhalten. Umfassende Umordnung und Beseitigung sämtlicher dünn belegter Seiten zurückgestellt.
- **Punkt 3 – erfüllt:** Haupttextverweise einschließlich Tabellennoten verwenden „Online Appendix“ und aufgelöste Labels.
- **Punkt 4 – erfüllt:** Wiederholungen in Abschnitt 6 und der Schlussfolgerung gekürzt; Registerplan bleibt enthalten. Haupttext endet auf Seite 15.

„Alt“ bezeichnet den vor den Änderungen erzeugten Ausgangsbuild. Seitenangaben sind gedruckte Seitenzahlen. C1 läuft über drei Seiten.

| Display / Label | Nummer alt | Seite alt | Nummer neu | Seite neu |
|---|---|---|---|---|
| Tabelle `tab:variables` | A1 | 19 | A1 | A3 |
| Tabelle `tab:sample_composition` | A2 | 19 | A2 | A3 |
| Tabelle `tab:summary_full` | A3 | 20 | A3 | A4 |
| Abbildung `fig:excess_mass` | B1 | 21 | B1 | A5 |
| Tabelle `tab:falsification` | B1 | 21 | B1 | A5 |
| Tabelle `tab:t040_validation` | B2 | 22 | B2 | A6 |
| Abbildung `fig:t040_scatter` | B2 | 23 | B2 | A7 |
| Tabelle `tab:t040_robustness` | B3 | 24 | B3 | A8 |
| Tabelle `tab:t031_samples` | B4 | 24 | B4 | A8 |
| Tabelle `tab:t031_timing` | B5 | 25 | B5 | A9 |
| Tabelle `tab:t043_delta` | B6 | 25 | B6 | A9 |
| Tabelle `tab:t043_integration` | B7 | 26 | B7 | A10 |
| Tabelle `tab:t043_error` | B8 | 27 | B8 | A11 |
| Abbildung `fig:t043_error` | B3 | 27 | B3 | A11 |
| Tabelle `tab:t063_noise` | B9 | 28 | B9 | A12 |
| Tabelle `tab:t061_control` | B10 | 29 | B10 | A13 |
| Abbildung `fig:t061_control` | B4 | 29 | B4 | A13 |
| Abbildung `fig:t063_dates` | B5 | 30 | B5 | A14 |
| Abbildung `fig:t063_dates_control` | B6 | 31 | B6 | A15 |
| Tabelle `tab:t063_window` | B11 | 32 | B11 | A16 |
| Tabelle `tab:t063_suppliers` | B12 | 33 | B12 | A17 |
| Tabelle `tab:t063_one_obs` | B13 | 33 | B13 | A17 |
| Tabelle `tab:t058_pilot` | B14 | 34 | B14 | A18 |
| Tabelle `tab:t058_notch` | B15 | 34 | B15 | A18 |
| Tabelle `tab:t058_symmetric` | B16 | 35 | B16 | A19 |
| Tabelle `tab:t058_attrition` | B17 | 35 | B17 | A19 |
| Tabelle `tab:t058_above` | B18 | 36 | B18 | A20 |
| Tabelle `tab:t058_checks` | B19 | 36 | B19 | A20 |
| Tabelle `tab:t058_grid` | B20 | 37 | B20 | A21 |
| Abbildung `fig:t058_grid` | B7 | 37 | B7 | A21 |
| Abbildung `fig:t027_decomposition` | B8 | 38 | B8 | A22 |
| Tabelle `tab:t041_horizons` | B21 | 39 | B21 | A23 |
| Tabelle `tab:t045_rl2` | B22 | 40 | B22 | A24 |
| Tabelle `tab:mi_shift` | B23 | 40 | B23 | A24 |
| Abbildung `fig:kappa` | B9 | 41 | B9 | A25 |
| Tabelle `tab:t043_trend` | B24 | 42 | B24 | A26 |
| Tabelle `tab:t043_heterogeneity` | B25 | 42 | B25 | A26 |
| Tabelle `tab:t046_cash` | B26 | 43 | B26 | A27 |
| Tabelle `tab:t045_shares` | B27 | 44 | B27 | A28 |
| Tabelle `tab:t044_comparison` | B28 | 45 | B28 | A29 |
| Tabelle `tab:did_main` | B29 | 45 | B29 | A29 |
| Tabelle `tab:pretrend` | B30 | 46 | B30 | A30 |
| Tabelle `tab:t024_rd_main` | B31 | 46 | B31 | A30 |
| Abbildung `fig:prisma` | B10 | 47 | B10 | A31 |
| Tabelle `tab:wos_queries` | B32 | 47 | B32 | A31 |
| Tabelle `tab:cnki_queries` | B33 | 48 | B33 | A32 |
| Tabelle `tab:further_outputs` | B34 | 48 | B34 | A32 |
| Tabelle `tab:ai_use` | C1 | 49–51 | C1 | A33–A35 |

Keine empirischen Werte wurden ergänzt oder geändert. Die folgenden Werte bleiben in den gekürzten Ergebnis- und Schlussabsätzen stehen; Quellenkommentare sind erhalten. Quelldateien liegen unter `replication/outputs/tables/`.

| Werte / Bedeutung | Quelldatei |
|---|---|
| 4.59 [2.15, 7.47]; 2.67 [−0.22, 6.35]; 4.48 [1.85, 7.64] | `t061_diff_bunching.csv`; gepooltes Schlussfolgerungsergebnis auch `t063_reproduction.csv` |
| Schwellen 0.70 / 0.60 / 0.80; −0.574 [−1.67, 0.44], −0.571 [−1.62, 0.36], 0.00 [−1.37, 1.32] | `t063_reconcile.csv`, `t061_estimates.csv` |
| Fenster [0.66, 0.74); 5.38 [2.48, 8.92], 5.13 [2.00, 8.86], 3.27 [−0.36, 7.72] | `t063_window.csv` |
| 596 Kontrollen; 4.59 [2.13, 7.55], 5.52 [2.51, 9.26] | `t063_control_sens.csv` |
| 602 Beobachtungen / 129 Firmen; 3.18, −0.52, 3.71 [1.60, 6.14] | `t029_counterfactual_bunching.csv` |
| 11.5, 4.1, 7.4 [3.1, 11.8] Prozentpunkte; Placeboanker Ende 2016 | `t029_compliance.csv` |
| 9.8 [4.7, 15.1] und 5.6 Prozentpunkte; Wachstum nach 2019 | `t043_trend_cf.csv`, `t055_linear_trend.csv` |
| 8.5 und 4.1 Prozentpunkte; 10.05 [0.56, 28.54], 8.74 [−0.85, 27.08] | `t058_symmetric.csv` |
| 10 von 249 Transaktionen | `t047_coding.csv` |
| 0.28 des positiven MI-Wachstums nach 2019 | `t055_kappa_break_even.csv` |
| Schwelle 0.70 in der gekürzten Discussion | `t061_interpretation.csv`, `t055_mi_shift.csv` |

Bei ausschließlich umbenannten Verweisen bleiben die numerischen Sätze und Quellenkommentare unverändert. Automatische Seiten- und Displaynummern sind in `main.aux` belegt. Deckblatt: 15 Seiten aus `tasks/T067.md`; Kursjahr 2026 und Datum aus den vorhandenen Titelangaben beziehungsweise `\today`. Registerplan: mindestens die Hälfte des MI-Wachstums 2020–21, 53 Einträge und 25. Dezember sind unveränderte Arbeitsplanangaben aus `tasks/T064.md`, Punkt 5.

## Offene Fragen

Keine offenen Fragen zu den primären Abnahmekriterien. Der optionale vollständige Umbruch bleibt zurückgestellt, insbesondere für die dünn belegten Seiten A25, A27 und A36. Die gemischte Sensitivitätsgruppe B.3 bleibt vor Finding 2; ihre Umordnung würde die beizubehaltende Floatnummerierung betreffen.

Empirische Ausgangswerte und Literaturquellen wurden in dieser Layoutkarte nicht erneut anhand der Daten geprüft. Keine Rohdaten verändert, kein Git ausgeführt und Kartenstatus unverändert APPROVED.

Vorgeschlagener Eintrag für `AI_USAGE_LOG.md`, außerhalb des Schreibbereichs: „2026-11-02, Codex, T067: Online-Appendix-Deckblatt, separates Inhaltsverzeichnis und A-Seitenzählung implementiert; Haupttextformulierungen für Seite 15 gekürzt; Referenzen, 48 unveränderte Displaynummern, Build und PDF-Layout geprüft. Keine neuen empirischen Ergebnisse.“