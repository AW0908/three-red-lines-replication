## Ergebnis

T066 wurde in Haupttext und Online Appendix integriert. Der Haupttext endet auf Seite 15; der Build enthält keine übervollen Boxen oder offenen Verweise. Punkt 6(i), Appendix C, bleibt wegen des widersprüchlichen Schreibbereichs und der ausstehenden Bestätigung persönlicher Prüfungen offen.

## Dateien

- `proposal/sections/02_literature.tex` – Literaturabgrenzung und Versionsfußnote.
- `proposal/sections/04_empirical_model.tex` – DR-DiD, Balancierung, Outcomes, Annahmen und Eigentümerkontrast.
- `proposal/sections/05_context_data.tex` – Replikationszugang und Wind-Grenze.
- `proposal/sections/06_preliminary_analysis.tex` – Ergebnisse, Selektionssensitivität, Offenlegungsbeträge und Kürzungen.
- `proposal/sections/07_conclusion.tex` – Evidenzhierarchie und Risiken des Look-through-Vorschlags.
- `proposal/tables/t050_identification.tex` – zwei DR-DiD-Zeilen und Zielpopulationen.
- `proposal/tables/t051_robustness.tex` – präzisierte Anmerkung; numerische Tabellenzellen unverändert.
- `proposal/tables/t049_threats.tex` – volle Textbreite, Selektionsgrenze und Kürzungen.
- `proposal/tables/t069_dr_1.tex` – 32 DR-Zeilen, A-Shares versus Kontrolle.
- `proposal/tables/t069_dr_2.tex` – 32 DR-Zeilen, gepoolte Entwickler versus Kontrolle.
- `proposal/tables/t069_dr_3.tex` – 32 DR-Zeilen, A-Shares ohne Lieferantenbranchen.
- `proposal/tables/t069_dr_4.tex` – 32 DR-Zeilen, gepoolte Entwickler ohne Lieferantenbranchen.
- `proposal/tables/t069_dr_5.tex` – 40 Eigentümer-DR-Zeilen einschließlich fehlgeschlagener Schätzungen.
- `proposal/tables/t069_balance_1.tex` – Balance der Hauptvergleiche.
- `proposal/tables/t069_balance_2.tex` – Balance ohne Lieferantenbranchen.
- `proposal/tables/t069_balance_3.tex` – Balance des Eigentümervergleichs.
- `proposal/tables/t069_ownership.tex` – Eigentümer-Bunching über beide Märkte.
- `proposal/tables/t069_first_1.tex` – erste 18 Erststufen-Zeilen.
- `proposal/tables/t069_first_2.tex` – übrige 12 Erststufen-Zeilen.
- `proposal/tables/t069_heckman.tex` – fünf korrigierte Selektionsschätzungen.
- `proposal/tables/t069_reporting.tex` – neun stichprobengleiche Reporting-IPW-Vergleiche.
- `proposal/tables/t069_lee.tex` – bestehende Lee-Bounds.
- `proposal/figures/t066_overlap.pdf` – byte-identische Kopie aller zehn Overlap-Seiten.
- `proposal/figures/t066_pretrends.pdf` – byte-identische Kopie aller fünf Vortrend-Seiten.
- `proposal/appendix/results.tex` – Einbindung, Beschriftungen, Quellen und Annahmen.
- `proposal/references.bib` – ausschließlich `santanna2020doubly` ergänzt.
- `tasks/T069_report.md` – Worker-Bericht.
- `review/T069_build/main.pdf` – kompiliertes Dokument.
- `review/T069_build/main.log`, `review/T069_build/main.blg` – Build-Protokolle.
- `review/T069_build/main.aux`, `review/T069_build/main.atoc`, `review/T069_build/main.toc` – Labels und Verzeichnisse.
- `review/T069_build/main.bbl`, `review/T069_build/main.fdb_latexmk`, `review/T069_build/main.fls`, `review/T069_build/main.out`, `review/T069_build/main.xdv` – Build-Dateien.

## Ausführung

Exakter Kartenbefehl, Exit-Code 0:

[fenced excerpt withheld in public audit]
[fenced excerpt withheld in public audit]

Letzte nichtleere Ausgabezeilen:

[fenced excerpt withheld in public audit]
[fenced excerpt withheld in public audit]

Zusätzlich durchgeführt: CSV/LaTeX-Zellvergleich, Labelprüfung, PDF-Textextraktion und Sichtprüfung von 34 gerenderten Seiten einschließlich aller neuen Tabellen und Abbildungsseiten. Temporäre Belege liegen unter `/tmp/T069_qa/`, `/tmp/T069_before/` und `/tmp/T069_build_stdout.txt`. Keine Neuschätzung, kein Git und kein Netzwerk verwendet; Kartenstatus und Rohdaten unverändert.

## Abnahmekriterien

1. **Erfüllt hinsichtlich Zahlenübertrag und Referenzauflösung:** 168/168 DR-Zeilen, 30/30 Erststufen-Zeilen, 5/5 Heckman-Zeilen, 9/9 Reporting-Zeilen, 3/3 Eigentümer-Bunching-Zeilen und 5/5 Lee-Zeilen stimmen bei ausgewiesener Präzision mit ihren CSVs überein. 178 Main/Average-Balancezeilen sind bei identischen Diagnostiken zu 47 Druckzeilen zusammengeführt. Der Vortrendcheck bestätigt 1 von 24 A-Share-Intervallen ohne null. Sämtliche Zitate und Verweise lösen auf; die Originalprüfung der neuen Methodenreferenz bleibt offen.
2. **Erfüllt:** `sec:main_end` steht in `review/T069_build/main.aux` auf Seite 15. Das PDF umfasst insgesamt 74 Seiten. Keine Build-Fehler oder Overfull-/Underfull-Boxen; bestehende Font-Substitutionswarnungen bleiben.
3. **Teilweise erfüllt:** Alle Kartenpunkte außer 6(i) umgesetzt beziehungsweise dokumentiert:

- **Punkt 1:** DR-DiD mit Balancierung, Y1–Y4 und Identifikationsannahmen sowie Eigentümerkontrast in Abschnitt 5.
- **Punkt 2:** ATT, Intervalle, Balance und Vortrendcheck sowie Eigentümer-ATT und ΔΔb in 6.1; beide Vergleichszeilen in Tabelle 2. Die optionalen Zusatzzeilen in Tabelle 3 entfallen aus Platzgründen; vollständige Ergebnisse stehen im Anhang.
- **Punkt 3:** Keine brauchbare Heckman-Erststufe behauptet. Maximum χ² = 3.9954, RL1-Erststufe 1.8796, korrigierte Schätzungen, stichprobengleiche IPW-Differenzen und Lee-Bounds sind ausgewiesen.
- **Punkt 4:** Neue Tabellen B32–B45 und Abbildungen B10–B24 eingebunden. Bestehende T067-Nummerierung fortgeführt.
- **Punkt 5:** In der Karte nicht vorhanden.
- **Punkt 6:** (a) Evidenzhierarchie und Zielpopulationen präzisiert. (b) Verteilungsschock, Placebos, unregulierte Quote und zeitlicher Verlauf erläutert; Entwicklerschocks bleiben als Bedrohung. (c) 2020H2 als Post-Zeitraum und b = 3.54 ohne diese Periode genannt. (d) Transaktions- und Betragsabdeckung gemeinsam berichtet; Dokumentlücken, unvollständige Bedingungen und fehlende Zahlungszuordnung unterschieden. Die zugeordneten Beträge betreffen laut Tabelle 5 ausschließlich U. (e) Literaturabgrenzung und Versionsfußnote ergänzt. (f) Bestehende 531/630-Perpetual-Lücke und Abgrenzung der regulatorischen Einheit beibehalten. (g) Look-through als Untersuchungsvorschlag mit Risiken formuliert. (h) Replikationszugang beschrieben. **(i) Offen.** (j) Alle 14 neuen Tabellen nutzen den gemeinsamen `apptabular`-Helfer auf `\linewidth`.
- **Punkt 7:** Wiederholte Details insbesondere in 6.1–6.2 gekürzt, Abschnitt 5 und Tabelle 6 gestrafft. Ursprüngliche PI-Zusage zum weiteren Vorgehen beibehalten; Haupttext endet auf Seite 15.

Zahlenbelege im geänderten wissenschaftlichen Text; Quelldateien jeweils unter `replication/outputs/tables/`:

- **Abschnitt 5:** Outcome-Fenster `[0.66,0.70)`, `≤0.70`, `[0.56,0.60)` und Y1–Y4 aus `t066_drdid.csv`, Spalte `label`. Übernommene Perioden und Supportregeln sind Designmetadaten aus den T066-Tabellenanmerkungen und Abbildungen.
- **Abschnitt 6.1:** −0.88, 3.14, Δb 4.02 und [1.67,6.80] aus `t043_delta_b.csv`/`t023_excess_mass.csv`; 2.67 [−0.22,6.35] und 4.59 [2.15,7.47] aus `t061_diff_bunching.csv`.
- **Abschnitt 6.1 und Tabelle 2:** ATT −0.1023 [−0.3007,0.0599], −0.0704 [−0.1842,0.0183], Eigentümer-ATT −0.0464 [−0.2450,0.2687] und 0.2069 aus `t066_drdid.csv`, Hauptperiode, Y1/Y2. Vortrendzählung 1/24 aus derselben Datei und `t066_placebo_audit.csv`. Eigentümer-ΔΔb 3.27 [−1.85,9.05] aus `t066_ownership_bunching.csv`.
- **Abschnitt 6.2:** 602 Beobachtungen, 129 Firmen, 3.18, −0.52, Differenz 3.71 [1.60,6.14] und D = 11.5 aus `t029_counterfactual_bunching.csv`/`t029_compliance.csv`; MI-Verschiebungen 1.46/1.83 aus `t055_mi_shift.csv`; Freeze-Werte 8.5/4.1 aus `t058_symmetric.csv`; κ = 0.28/0.09 aus `t055_kappa_break_even.csv`. Beibehaltene Kreuzungszahlen 33, 31, 69.7, 57.1 und 66.7 aus `t027_decomposition_rl1.csv`/`t027_tests.csv`.
- **Abschnitt 6.3:** Pilot 107/117 aus `t044_pilot_coding.csv`; 31 Crossers, 10/249 Transaktionen und RMB 0.4 von 190.5 Milliarden aus `t047_coding.csv`/`t047_attribution_totals.csv`. D1/D2 sind Kategorienbezeichnungen.
- **Abschnitt 6.5:** Placebos 0.60/0.80 aus `t043_delta_b.csv`; unregulierte Quote aus `t055_falsification.csv`; Verlauf ab 2020H2 aus `t041_bunching_by_date.csv`/`t063_by_date.csv`; b = 3.54 aus `t031_timing.csv`. χ² 3.9954/1.8796 aus `t066_first_stage.csv`; −0.0219 [−0.0423,0.0025] aus `t066_heckman.csv`; 3.8369 [1.3611,6.8625], 3.9136 und −0.0767 [−0.5218,0.6850] aus `t066_reporting_same_sample_bunching.csv`.
- **Conclusion:** 2.67 [−0.22,6.35]/4.59 [2.15,7.47] aus `t061_diff_bunching.csv`; 11.5 aus `t029_compliance.csv`; 10/249 aus `t047_coding.csv`; 0.28 aus `t055_kappa_break_even.csv`. Zukunftszusagen sind unveränderte Planangaben.
- **Neue Anhangstabellen:** sämtliche Zellen aus `t066_drdid.csv`, `t066_balance.csv`, `t066_ownership_bunching.csv`, `t066_first_stage.csv`, `t066_heckman.csv`, `t066_reporting_same_sample_bunching.csv` und `t025_lee_bounds.csv`, zeilenweise geprüft. Eigentümerzahlen 52/43/41 und vier Hongkong-SOEs aus `t066_ownership_counts.csv`/`t066_ownership_markets.csv`; Bootstrapzahlen 999/499 und Seed 20261102 aus den Ergebnis-CSVs.
- **Bibliografische Zahlen:** 2020, 219(1), 101–122 sowie Focal-Paper-Datum 5.7.2026, fünf/vier Autoren und SSRN 5124537 sind Quellenmetadaten aus der freigegebenen Karte beziehungsweise dem bestehenden Focal-Paper-Eintrag.

## Offene Fragen

- **Appendix C:** Die Karte fordert den Absatz unter 6(i), erlaubt im Anhang jedoch nur `results.tex`. Die Klärungsfrage zur Erweiterung auf `ai_use.tex` und zum tatsächlichen Umfang persönlicher Prüfungen ist unbeantwortet. Daher dort keine Änderung und keine neue Behauptung umfassender persönlicher Prüfung.
- **Methodenreferenz:** Sant’Anna/Zhao wurde nach den bibliografischen Angaben der Karte ergänzt. Der Originaltext stand offline nicht zur Verfügung; dies ist im LaTeX als `UNVERIFIED` markiert.
- Schwache Ausschlussrestriktionen, unzuverlässige Eigentümer- und MI/JV-Heckman-Bootstraps sowie die fehlende Hongkong-Kontrolle bleiben ausdrücklich bestehen.
- Bestehende Font-Substitution für kursives Songti SC; keine sichtbaren Abschneidungen auf den geprüften Seiten.
- Vorschlag für `AI_USAGE_LOG.md`, außerhalb des Schreibbereichs: „2026-11-09, Codex, T069: Integration von DR-DiD, Eigentümerkontrast und Selektionssensitivität; Interpretation und Offenlegungsgrenzen präzisiert, CSV-Zellvergleich und PDF-Prüfung, Haupttext auf Seite 15. Appendix-C-Ergänzung wegen Schreibbereich und unbestätigter persönlicher Prüfungen offen.“