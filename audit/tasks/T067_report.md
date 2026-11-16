## Ergebnis

Der Online Appendix hat ein Deckblatt auf A1 und ein separates Inhaltsverzeichnis auf A2; die Anhangsseiten laufen bis A3[number withheld]. Der gekürzte Haupttext endet auf Seite [number withheld]. Alle [number withheld] Anhangsdisplays behalten ihre Nummern und sind referenziert; der Build enthält keine LaTeX-Warnungen oder übervollen Boxen.

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
- `review/T067_build/main.pdf` – kompiliertes Dokument mit [number withheld] PDF-Seiten.
- `review/T067_build/main.log`, `review/T067_build/build_stdout.log` – Build-Protokolle.
- `review/T0[number withheld]_build/main.aux`, `review/T0[number withheld]_build/main.toc`, `review/T0[number withheld]_build/main.atoc` – Label- und Inhaltsverzeichnisnachweise.
- `review/T0[number withheld]_build/main.bbl`, `review/T0[number withheld]_build/main.blg`, `review/T0[number withheld]_build/main.fdb_latexmk`, `review/T0[number withheld]_build/main.fls`, `review/T0[number withheld]_build/main.out`, `review/T0[number withheld]_build/main.xdv` – automatisch erzeugte Build-Dateien.
- `review/T067_build/qa/page-01.png` bis `review/T067_build/qa/page-55.png` sowie `review/T067_build/qa/contact-1.png` bis `review/T067_build/qa/contact-7.png` – gerenderte und visuell geprüfte Seiten.

## Ausführung

[fenced excerpt withheld in public process copy]
[fenced excerpt withheld in public process copy]

Exit-Code: [number withheld]. Letzte Ausgabe der abschließenden Wiederholung:

[fenced excerpt withheld in public process copy]
[fenced excerpt withheld in public process copy]

Der vollständige Build nach den Änderungen steht in `review/T067_build/build_stdout.log`. Zusätzlich wurden Labels, Textverweise, PDF-Seitenfolge und Warnungen geprüft sowie alle [number withheld] Seiten gerendert und visuell kontrolliert.

## Abnahmekriterien

[number withheld]. **Erfüllt:** Deckblatt A1, Anhangsübersicht A2, lückenlose Seitenzählung bis A3[number withheld]. Das Hauptinhaltsverzeichnis enthält genau einen „Online Appendix“-Eintrag; die separate Übersicht enthält zehn Abschnitts-/Unterabschnittseinträge. Keine unaufgelösten Verweise und keine unreferenzierten Anhangsdisplays.
[number withheld]. **Erfüllt:** `sec:main_end` steht in `main.aux` auf Seite [number withheld]; Literatur auf Seiten [number withheld]–[number withheld]. Exit-Code [number withheld], null LaTeX-/Paketwarnungen und null Overfull-Boxen.
[number withheld]. **Erfüllt:** Punkte [number withheld]–[number withheld] und sämtliche Display-Zuordnungen sind nachfolgend dokumentiert.

- **Punkt [number withheld] – erfüllt:** Deckblatt mit Titel, Autor, Kurs, Datum und Abgrenzungssatz. Das Deckblatt zählt als A1. Seitenzahlen ohne Bindestrich; Floatnummern unverändert.
- **Punkt [number withheld] – teilweise umgesetzt:** Acht fehlende Referenzen ergänzt; beide Datumsabbildungen verwenden `[htbp]`. Bestehende Abschnittsbarrieren, Breiten und Schriftgrößen bleiben erhalten. Umfassende Umordnung und Beseitigung sämtlicher dünn belegter Seiten zurückgestellt.
- **Punkt [number withheld] – erfüllt:** Haupttextverweise einschließlich Tabellennoten verwenden „Online Appendix“ und aufgelöste Labels.
- **Punkt [number withheld] – erfüllt:** Wiederholungen in Abschnitt [number withheld] und der Schlussfolgerung gekürzt; Registerplan bleibt enthalten. Haupttext endet auf Seite [number withheld].

„Alt“ bezeichnet den vor den Änderungen erzeugten Ausgangsbuild. Seitenangaben sind gedruckte Seitenzahlen. C1 läuft über drei Seiten.

| Display / Label | Nummer alt | Seite alt | Nummer neu | Seite neu |
|---|---|---|---|---|
| Tabelle `tab:variables` | A1 | [number withheld] | A1 | A3 |
| Tabelle `tab:sample_composition` | A2 | [number withheld] | A2 | A3 |
| Tabelle `tab:summary_full` | A3 | [number withheld] | A3 | A4 |
| Abbildung `fig:excess_mass` | B1 | [number withheld] | B1 | A5 |
| Tabelle `tab:falsification` | B1 | [number withheld] | B1 | A5 |
| Tabelle `tab:t0[number withheld]_validation` | B2 | [number withheld] | B2 | A6 |
| Abbildung `fig:t0[number withheld]_scatter` | B2 | [number withheld] | B2 | A7 |
| Tabelle `tab:t0[number withheld]_robustness` | B3 | [number withheld] | B3 | A8 |
| Tabelle `tab:t0[number withheld]_samples` | B4 | [number withheld] | B4 | A8 |
| Tabelle `tab:t0[number withheld]_timing` | B5 | [number withheld] | B5 | A9 |
| Tabelle `tab:t0[number withheld]_delta` | B6 | [number withheld] | B6 | A9 |
| Tabelle `tab:t0[number withheld]_integration` | B7 | [number withheld] | B7 | A1[number withheld] |
| Tabelle `tab:t0[number withheld]_error` | B8 | [number withheld] | B8 | A1[number withheld] |
| Abbildung `fig:t0[number withheld]_error` | B3 | [number withheld] | B3 | A1[number withheld] |
| Tabelle `tab:t0[number withheld]_noise` | B9 | [number withheld] | B9 | A1[number withheld] |
| Tabelle `tab:t0[number withheld]_control` | B1[number withheld] | [number withheld] | B1[number withheld] | A1[number withheld] |
| Abbildung `fig:t0[number withheld]_control` | B4 | [number withheld] | B4 | A1[number withheld] |
| Abbildung `fig:t0[number withheld]_dates` | B5 | [number withheld] | B5 | A1[number withheld] |
| Abbildung `fig:t0[number withheld]_dates_control` | B6 | [number withheld] | B6 | A1[number withheld] |
| Tabelle `tab:t0[number withheld]_window` | B1[number withheld] | [number withheld] | B1[number withheld] | A1[number withheld] |
| Tabelle `tab:t0[number withheld]_suppliers` | B1[number withheld] | [number withheld] | B1[number withheld] | A1[number withheld] |
| Tabelle `tab:t0[number withheld]_one_obs` | B1[number withheld] | [number withheld] | B1[number withheld] | A1[number withheld] |
| Tabelle `tab:t0[number withheld]_pilot` | B1[number withheld] | [number withheld] | B1[number withheld] | A1[number withheld] |
| Tabelle `tab:t0[number withheld]_notch` | B1[number withheld] | [number withheld] | B1[number withheld] | A1[number withheld] |
| Tabelle `tab:t0[number withheld]_symmetric` | B1[number withheld] | [number withheld] | B1[number withheld] | A1[number withheld] |
| Tabelle `tab:t0[number withheld]_attrition` | B1[number withheld] | [number withheld] | B1[number withheld] | A1[number withheld] |
| Tabelle `tab:t0[number withheld]_above` | B1[number withheld] | [number withheld] | B1[number withheld] | A2[number withheld] |
| Tabelle `tab:t0[number withheld]_checks` | B1[number withheld] | [number withheld] | B1[number withheld] | A2[number withheld] |
| Tabelle `tab:t0[number withheld]_grid` | B2[number withheld] | [number withheld] | B2[number withheld] | A2[number withheld] |
| Abbildung `fig:t0[number withheld]_grid` | B7 | [number withheld] | B7 | A2[number withheld] |
| Abbildung `fig:t0[number withheld]_decomposition` | B8 | [number withheld] | B8 | A2[number withheld] |
| Tabelle `tab:t0[number withheld]_horizons` | B2[number withheld] | [number withheld] | B2[number withheld] | A2[number withheld] |
| Tabelle `tab:t0[number withheld]_rl2` | B2[number withheld] | [number withheld] | B2[number withheld] | A2[number withheld] |
| Tabelle `tab:mi_shift` | B2[number withheld] | [number withheld] | B2[number withheld] | A2[number withheld] |
| Abbildung `fig:kappa` | B9 | [number withheld] | B9 | A2[number withheld] |
| Tabelle `tab:t0[number withheld]_trend` | B2[number withheld] | [number withheld] | B2[number withheld] | A2[number withheld] |
| Tabelle `tab:t0[number withheld]_heterogeneity` | B2[number withheld] | [number withheld] | B2[number withheld] | A2[number withheld] |
| Tabelle `tab:t0[number withheld]_cash` | B2[number withheld] | [number withheld] | B2[number withheld] | A2[number withheld] |
| Tabelle `tab:t0[number withheld]_shares` | B2[number withheld] | [number withheld] | B2[number withheld] | A2[number withheld] |
| Tabelle `tab:t0[number withheld]_comparison` | B2[number withheld] | [number withheld] | B2[number withheld] | A2[number withheld] |
| Tabelle `tab:did_main` | B2[number withheld] | [number withheld] | B2[number withheld] | A2[number withheld] |
| Tabelle `tab:pretrend` | B3[number withheld] | [number withheld] | B3[number withheld] | A3[number withheld] |
| Tabelle `tab:t0[number withheld]_rd_main` | B3[number withheld] | [number withheld] | B3[number withheld] | A3[number withheld] |
| Abbildung `fig:prisma` | B1[number withheld] | [number withheld] | B1[number withheld] | A3[number withheld] |
| Tabelle `tab:wos_queries` | B3[number withheld] | [number withheld] | B3[number withheld] | A3[number withheld] |
| Tabelle `tab:cnki_queries` | B3[number withheld] | [number withheld] | B3[number withheld] | A3[number withheld] |
| Tabelle `tab:further_outputs` | B3[number withheld] | [number withheld] | B3[number withheld] | A3[number withheld] |
| Tabelle `tab:ai_use` | C1 | [number withheld]–[number withheld] | C1 | A3[number withheld]–A3[number withheld] |

Keine empirischen Werte wurden ergänzt oder geändert. Die folgenden Werte bleiben in den gekürzten Ergebnis- und Schlussabsätzen stehen; Quellenkommentare sind erhalten. Quelldateien liegen unter `replication/outputs/tables/`.

| Werte / Bedeutung | Quelldatei |
|---|---|
| [number withheld] [[number withheld], [number withheld]]; [number withheld] [[number withheld], [number withheld]]; [number withheld] [[number withheld], [number withheld]] | `t061_diff_bunching.csv`; gepooltes Schlussfolgerungsergebnis auch `t063_reproduction.csv` |
| Schwellen [number withheld] / [number withheld] / [number withheld]; [number withheld] [[number withheld], [number withheld]], [number withheld] [[number withheld], [number withheld]], [number withheld] [[number withheld], [number withheld]] | `t063_reconcile.csv`, `t061_estimates.csv` |
| Fenster [[number withheld], [number withheld]); [number withheld] [[number withheld], [number withheld]], [number withheld] [[number withheld], [number withheld]], [number withheld] [[number withheld], [number withheld]] | `t063_window.csv` |
| [number withheld] Kontrollen; [number withheld] [[number withheld], [number withheld]], [number withheld] [[number withheld], [number withheld]] | `t063_control_sens.csv` |
| [number withheld] Beobachtungen / [number withheld] Firmen; [number withheld], [number withheld], [number withheld] [[number withheld], [number withheld]] | `t029_counterfactual_bunching.csv` |
| [number withheld], [number withheld], [number withheld] [[number withheld], [number withheld]] Prozentpunkte; Placeboanker Ende [number withheld] | `t029_compliance.csv` |
| [number withheld] [[number withheld], [number withheld]] und [number withheld] Prozentpunkte; Wachstum nach [number withheld] | `t043_trend_cf.csv`, `t055_linear_trend.csv` |
| [number withheld] und [number withheld] Prozentpunkte; [number withheld] [[number withheld], [number withheld]], [number withheld] [[number withheld], [number withheld]] | `t058_symmetric.csv` |
| [number withheld] von [number withheld] Transaktionen | `t047_coding.csv` |
| [number withheld] des positiven MI-Wachstums nach [number withheld] | `t055_kappa_break_even.csv` |
| Schwelle [number withheld] in der gekürzten Discussion | `t061_interpretation.csv`, `t055_mi_shift.csv` |

Bei ausschließlich umbenannten Verweisen bleiben die numerischen Sätze und Quellenkommentare unverändert. Automatische Seiten- und Displaynummern sind in `main.aux` belegt. Deckblatt: [number withheld] Seiten aus `tasks/T067.md`; Kursjahr [number withheld] und Datum aus den vorhandenen Titelangaben beziehungsweise `\today`. Registerplan: mindestens die Hälfte des MI-Wachstums [number withheld]–[number withheld], [number withheld] Einträge und [number withheld]. Dezember sind unveränderte Arbeitsplanangaben aus `tasks/T064.md`, Punkt [number withheld].

## Offene Fragen

Keine offenen Fragen zu den primären Abnahmekriterien. Der optionale vollständige Umbruch bleibt zurückgestellt, insbesondere für die dünn belegten Seiten A2[number withheld], A2[number withheld] und A3[number withheld]. Die gemischte Sensitivitätsgruppe B.[number withheld] bleibt vor Finding [number withheld]; ihre Umordnung würde die beizubehaltende Floatnummerierung betreffen.

Empirische Ausgangswerte und Literaturquellen wurden in dieser Layoutkarte nicht erneut anhand der Daten geprüft. Keine Rohdaten verändert, kein Git ausgeführt und Kartenstatus unverändert APPROVED.

Vorgeschlagener Eintrag für `AI_USAGE_LOG.md`, außerhalb des Schreibbereichs: „2026-11-02, Codex, T067: Online-Appendix-Deckblatt, separates Inhaltsverzeichnis und A-Seitenzählung implementiert; Haupttextformulierungen für Seite [number withheld] gekürzt; Referenzen, [number withheld] unveränderte Displaynummern, Build und PDF-Layout geprüft. Keine neuen empirischen Ergebnisse.“