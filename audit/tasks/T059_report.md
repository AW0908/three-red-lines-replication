## Ergebnis

T059 ist umgesetzt: Exposition und Pilotzeitraum sind präzisiert, T058 ist integriert, und Finding 3 ist als Offenlegungsprüfung formuliert. Der Haupttext endet auf Seite 15; sieben neue Anhangstabellen und die Spezifikationskurve ergänzen die Belege. Der Build ist warnungsfrei; Zahlen und Darstellung wurden geprüft.

## Dateien

- `proposal/main.tex` – ausschließlich Abstract überarbeitet; 80 Wörter.
- `proposal/sections/01_introduction.tex` – neuer Einstieg, Offenlegungsbefund und κ-Präzision.
- `proposal/sections/02_literature.tex` – Liu-Vergleich und Hongkong-Erweiterung.
- `proposal/sections/03_framework.tex` – Notch-Prognose, beidseitige Konzentration, endogenes κ, H2/H3.
- `proposal/sections/04_empirical_model.tex` – Expositionsfenster, κ-Gleichung und Offenlegungsprüfung.
- `proposal/sections/05_context_data.tex` – Pilot/Rollout, Estimand und Kürzungen.
- `proposal/sections/06_preliminary_analysis.tex` – T058-Ergebnisse einschließlich Gegenbefunden.
- `proposal/sections/07_conclusion.tex` – aufsichtsbezogene Interpretation und κ-Präzision.
- `proposal/references.bib` – Huang- und Su-Einträge ergänzt.
- `proposal/tables/t050_identification.tex` – Tabelle 2 überarbeitet.
- `proposal/tables/t051_robustness.tex` – Tabelle 3: balanciertes Δb und Gitter.
- `proposal/tables/t050_counterfactuals.tex` – Tabelle 4: symmetrische Benchmarks, kompaktere Spalten.
- `proposal/tables/t049_threats.tex` – Tabelle 6: Gitter, Attrition und Notch-Kontrast.
- `proposal/tables/t058_pilot.tex` – Tabelle B9.
- `proposal/tables/t058_notch.tex` – Tabelle B10.
- `proposal/tables/t058_symmetric.tex` – Tabelle B11.
- `proposal/tables/t058_attrition.tex` – Tabelle B12.
- `proposal/tables/t058_above.tex` – Tabelle B13.
- `proposal/tables/t058_checks.tex` – Tabelle B14.
- `proposal/tables/t058_grid.tex` – Tabelle B15.
- `proposal/figures/t058_grid.pdf` – byte-identische T058-Abbildung B4.
- `proposal/appendix/results.tex` – ausschließlich neue Untersektion B.2 eingefügt.
- `review/T059_build/` – fertige `main.pdf` samt Build-Hilfsdateien.
- `tasks/T059_report.md` – ausführlicher Bericht einschließlich Zahlennachweis.

## Ausführung

[fenced excerpt withheld in public audit]
[fenced excerpt withheld in public audit]

Letzte Ausgabe nach vollständigem Build und abschließender Wiederholung:

[fenced excerpt withheld in public audit]
[fenced excerpt withheld in public audit]

49 neue Tabellenzeilen wurden einschließlich Intervallen und Fallzahlen gegen die CSVs geprüft, außerdem zehn zentrale Textschätzungen samt Intervallen. Keine Warnungen, undefinierten Verweise oder Overfull-/Underfull-Meldungen im finalen Log. Titelblatt, sämtliche Haupttextseiten und die vier neuen Anhangsseiten wurden visuell geprüft.

## Abnahmekriterien

1. **Erfüllt:** Ergebniszahlen aus CSVs übernommen, Quellenkommentare ergänzt und neue Literaturverweise anhand der PI-bestätigten Originalpassagen kontrolliert.
2. **Erfüllt:** `sec:main_end` steht in `review/T059_build/main.aux` auf Seite **15**. Abstract: **80 Wörter**. Build warnungsfrei.
3. **Erfüllt:** Punkte 1–11 umgesetzt:

| Punkt | Beleg |
|---|---|
| 1 | Abschnitt 4.1/Tabelle 2 erläutern Exposition, Estimand und Pilot-Stichtag im Post-Fenster; 6.1/B9 berichten den unpräzisen Pilotkontrast. |
| 2 | Prognose in 3.1 erhalten; Kontrast −1.30 [−5.29, 2.87] in 6.1/B10 ausdrücklich nicht gestützt. |
| 3 | Endogenes κ in 3.2; fehlende Testbarkeit bei 10/249 Transaktionen; verlangte Reclassification-Gleichung in 5.2. H2 als Bilanzimplikation, H3 aus dem κ-Rahmen abgeleitet. |
| 4 | Finding 3, H3, Abstract, Einleitung und Schluss als Offenlegungsprüfung formuliert. |
| 5 | Mutter-Eigenkapital-/Schulden-Freeze in 6.2/Tabelle 4/B11; normalisierter MI-Vorsprung post gestützt, zusätzliche Zunahme gegenüber Placebo unpräzise. |
| 6 | Bei κ*=0.28 steht jeweils der Hinweis, dass das b-Intervall bereits ab κ=0.09 null einschließt. |
| 7 | Gitter, Attrition, Kalenderregel, Masse oberhalb und Standardprüfung eingebunden; saubereres unadjustiertes Änderungsplacebo benannt. Koinzidente Restriktionen gemäß Kartenalternative als Limitation. |
| 8 | Liu-Vergleich mit 110 Shanghai-/Shenzhen-Entwicklern, stetigem Wachstum und Hongkong-Erweiterung in Abschnitt 2. |
| 9 | Einleitung beginnt mit Compliance versus ökonomischem Schuldenabbau. |
| 10 | Neue Untersektion B.2, Tabellen B9–B15 und Abbildung B4; A/B-Nummerierung funktioniert. |
| 11 | Wiederholungen gekürzt; Abschnittsdateien sinken kommentarbereinigt von 5,941 auf 5,553 durch Leerraum getrennte Einheiten. Haupttext endet auf Seite 15. |

Zahlennachweis des überarbeiteten Texts; folgende CSV-Dateien liegen unter `replication/outputs/tables/`:

| Zahlen | Quelle |
|---|---|
| 136 Firmen; 42 delistet; 80 A-/56 HK-Firmen; 1,692 Firmen-Halbjahre | `t004_panel_counts.csv`, Hauptstichprobe |
| 13 Stichtage; Vor-/Nachperioden und Anker 2019/2016 | `t058_attrition.csv`, `t058_window.csv`, `t058_standard.csv`, `t058_symmetric.csv` |
| 11 Panel-Piloten; 4 Firmen/13 Post-Fensterbeobachtungen | `t058_pilot_mapping.csv`, `t058_pilot.csv` |
| Validierung: 64 Werte/30 Firmen, 6 Abweichungen; 52 Werte in [0.60,0.80], Fehler 0.57 pp, 76.9% innerhalb eines Punkts | `t040_validation.csv` |
| Δb 4.0/4.02 [1.67,6.80]; 999 Ziehungen | `t043_delta_b.csv`, Hauptspezifikation |
| Unadjustiertes b −0.20; RL1-b 3.14; Differenz 3.34 [0.32,6.58]; Änderungsdifferenz 2.91 [−0.59,6.25] | `t055_falsification.csv` |
| Zeitprofil vorab höchstens 1; danach 1.48–2.17 | `t041_bunching_by_date.csv` |
| Masse oberhalb 1.75 [0.10,4.02] post; 0.85 [−0.66,2.97] pre; Ausschluss [0.66,0.74) | `t058_above.csv`, `070_074` |
| 72/72 positive Änderungen; 69/72 Intervalle über null; Median 3.92 in 0.01-Bin-Einheiten | `t058_grid_summary.csv` |
| Balanciert 3.91 [1.63,6.99]; Austrittsanteile 10.0/17.5%; 10 Austritte; Fisher p=1.00 | `t058_attrition.csv` |
| 2020H1 zur Vorperiode hinzugefügt: 4.26 [1.98,7.02] | `t058_window.csv` |
| HK 6.74 [3.00,12.25], ohne imputierte Nullwerte 8.61; A 2.10 [−0.38,5.30] | `t058_standard.csv` |
| Pilotkontrast −1.53 [−10.45,7.36] | `t058_pilot.csv` |
| Notch-Kontrast −1.30 [−5.29,2.87] | `t058_notch.csv` |
| 33 Kreuzungen/31 Firmen; Eigenkapitalmehrheit 69.7%/57.1%; Schuldenrückgang 66.7% | `t027_decomposition_rl1.csv` |
| MI-Freeze: D=11.5 pp | `t029_compliance.csv`, auch `t058_symmetric.csv` |
| MI-induzierte Verschiebung 1.46/1.83 pp; Differenz −0.37 [−1.04,0.28] | `t055_mi_shift.csv` |
| Mutter-Freeze D=8.5 pp, b=−0.82; Schulden-Freeze D=−4.1 pp, b=2.11 | `t058_symmetric.csv` |
| Normalisierter MI-Vorsprung 10.05 [0.56,28.54]; zusätzliche Zunahme 8.74 [−0.85,27.08] | `t058_symmetric.csv` |
| κ*=0.28; Null im b-Intervall ab κ=0.09; Interpolation auf 0.1-Gitter | `t055_kappa_break_even.csv` |
| Deskriptive D-Werte 13.1/7.6, 18.5/7.5, 15.1/7.9 pp | `t043_heterogeneity.csv` |
| Kapitalzuflüsse 79.5%; 109 Firmenjahre 2019–2021 | `t046_cash_backing_all.csv` |
| 10 klassifizierbare von 249 Transaktionen | `t047_coding.csv` |

Institutionelle Zahlen und Daten stammen aus den PI-bestätigten Huang-/Su-/Chu-Passagen beziehungsweise dem bereits bestätigten Focal Paper. Lius 110 Entwickler und Seiten 218/228 stammen aus der bestätigten Liu-PDF. Konstanten und Grenzen der κ-Gleichung sind Definitionen.

Die zusätzlichen Tabellenzahlen sind über Quellenkommentare mit CSV-Zeilen verknüpft: B9 mit `t058_pilot.csv`, B10 mit `t058_notch.csv`, B11 mit `t058_symmetric.csv`, B12 mit `t058_attrition.csv`, B13 mit `t058_above.csv`, B14 mit `t058_window.csv`/`t058_standard.csv` und B15 mit sämtlichen Zeilen aus `t058_grid_summary.csv`.

## Offene Fragen

- Huang: Die Pilotliste mit Fußnote 24 steht in der lokalen PDF auf **Seite 12**, nicht auf der in der Karte genannten Seite 13.
- Das bestehende Post-Fenster enthält Dezember 2020 vor dem sektorweiten Rollout; dies ist ausdrücklich erklärt. Stichprobe und Analysen wurden nicht geändert.
- Hongkongs Standardwechsel liegt laut T058 innerhalb der Vorperiode. Der Text behauptet deshalb keinen unveränderten Standard über das gesamte Schätzfenster.
- Für die zusätzliche Tabellenzeile zu koinzidenten Restriktionen fehlt die entsprechende PI-Quellenbestätigung; gemäß Karte wurde die Limitationsklausel ohne Zitat verwendet.
- Unabhängiges Review und PI-Abnahme stehen aus. Kartenstatus und Rohdaten blieben unverändert; Git und Netzwerkzugriff wurden nicht verwendet.
- KI-Protokollvorschlag: „2026-10-31, Codex, T059: freigegebene Textrevision; T058 einschließlich Gegenbefunden integriert; CSV-Abgleich, LaTeX-Build und visuelle Prüfung durchgeführt.“ `AI_USAGE_LOG.md` liegt außerhalb des Schreibbereichs.