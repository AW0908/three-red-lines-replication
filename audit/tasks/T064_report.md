## Ergebnis

T064 ist umgesetzt: T063 wurde in Haupttext und Anhang integriert, der A-share-Vergleich erhält gleiches Gewicht und die Noise-Kalibrierung wird als fehlender gemeinsamer Mittelwertabgleich eingeordnet. Der Offenlegungsbefund betrifft öffentliche Informationen; der Schluss enthält den Registerplan. Der Build ist sauber, der Haupttext endet auf Seite 15 und der Abstract umfasst 83 Wörter.

## Dateien

- `proposal/main.tex` – ausschließlich Abstract überarbeitet.
- `proposal/sections/01_introduction.tex` – verständlichere Einführung, Marktvergleich und öffentliche Informationen.
- `proposal/sections/02_literature.tex` – Beitrag gegenüber Guo et al.; CNKI-Abgleich.
- `proposal/sections/03_framework.tex` – Kalibrierungsgrenzen und ungetestete Erklärungen.
- `proposal/sections/04_empirical_model.tex` – breites Fitfenster und Finanzierungssubstitutionsvorbehalt.
- `proposal/sections/05_context_data.tex` – institutioneller Hintergrund und endliche RL1-Werte.
- `proposal/sections/06_preliminary_analysis.tex` – T063-Ergebnisse und korrigierte Interpretation.
- `proposal/sections/07_conclusion.tex` – gewichtete Befunde und Registerplan.
- `proposal/tables/t050_identification.tex` – Tabellenumbruch und öffentliche Information.
- `proposal/tables/t050_counterfactuals.tex` – mehrzeilige Zeilenbeschriftungen.
- `proposal/tables/t051_robustness.tex` – beide Hauptfenster, A-shares und passende Anhangsverweise.
- `proposal/tables/t049_threats.tex` – Kalibrierungsgrenze.
- `proposal/tables/t061_results.tex` – getrennte Kontrolländerungen und Bootstrap-Erklärung.
- `proposal/tables/t058_checks.tex` – Bootstrap-Grundgesamtheit erläutert.
- `proposal/tables/t058_attrition.tex` – Bootstrap-Grundgesamtheit erläutert.
- `proposal/tables/t063_noise.tex` – ausgewählte Simulationszellen und Kalibrierungsgrenzen.
- `proposal/tables/t063_window.tex` – beide Massendefinitionen des breiten Fitfensters.
- `proposal/tables/t063_control_sens.tex` – Zulieferausschluss und Gegenprobe.
- `proposal/tables/t063_one_obs.tex` – Beobachtungsauswahl und unterschiedliche Fensterfirmen.
- `proposal/appendix/results.tex` – neue Tabellen und beide Halbjahresabbildungen.
- `proposal/appendix/ai_use.tex` – Prompt-Ausschnitte und Freigabebeispiele.
- `proposal/figures/t063_by_date.pdf` – byte-identische Kopie der zweiseitigen T063-Abbildung.
- `tasks/T064_report.md` – ausführlicher Bericht mit Zahlenbelegen.
- `review/T064_build/main.pdf` – gebautes PDF.
- `review/T064_build/main.aux`, `review/T064_build/main.bbl`, `review/T064_build/main.blg`, `review/T064_build/main.fdb_latexmk`, `review/T064_build/main.fls`, `review/T064_build/main.log`, `review/T064_build/main.out`, `review/T064_build/main.toc`, `review/T064_build/main.xdv` – Builddateien.
- `review/T064_build/qa_01.png`, `review/T064_build/qa_03.png`, `review/T064_build/qa_05.png`, `review/T064_build/qa_09.png`, `review/T064_build/qa_12.png`, `review/T064_build/qa_15.png`, `review/T064_build/qa_17.png`, `review/T064_build/qa_29.png`, `review/T064_build/qa_31.png`, `review/T064_build/qa_32.png`, `review/T064_build/qa_33.png`, `review/T064_build/qa_49.png`, `review/T064_build/qa_50.png`, `review/T064_build/qa_51.png`, `review/T064_build/qa_52.png` – visuelle Zwischenprüfung.
- `review/T064_build/final_29.png`, `review/T064_build/final_31.png`, `review/T064_build/final_32.png`, `review/T064_build/final_33.png`, `review/T064_build/final_34.png`, `review/T064_build/final_53.png` – gerenderte Endfassungen der zuletzt geänderten Anhangsseiten.

## Ausführung

Exakter Befehl, selbst ausgeführt; abschließender Kontrollaufruf mit Exit-Code 0:

[fenced excerpt withheld in public audit]
[fenced excerpt withheld in public audit]

Letzte Zeilen:

[fenced excerpt withheld in public audit]
[fenced excerpt withheld in public audit]

Der Übersetzungslauf erzeugte 53 PDF-Seiten einschließlich Literatur und Anhängen. Keine LaTeX-Warnungen, undefinierten Verweise, Overfull- oder Underfull-Boxen. `main.aux` bestätigt Haupttextende auf Seite 15; die betroffenen Tabellen und Seiten wurden visuell geprüft.

PDF-SHA-256: `be54ce8e8d06fdca52c982291f49dcb0d8506c8f30139ef386afa9d81801c0ba`.

## Abnahmekriterien

1. **Erfüllt für empirische Zahlen:** Neue T063-Tabellen wurden direkt aus den CSV-Zellen gerundet; die berichteten T063-Kontraste stimmen überein. Keine neuen Bibliografieeinträge. Neue institutionelle Aussagen folgen den PI-Bestätigungen. Plan- und Auditangaben stammen aus den ausdrücklich vorgeschriebenen Quellen.
2. **Erfüllt:** Haupttextende Seite 15; sauberer Build; Abstract 83 Wörter.
3. **Erfüllt:** Kartenpunkte 1–10 sind umgesetzt:

- **Punkt 1:** Abschnitte 3.1/6.1 und Tabelle B9 zeigen den fehlenden gemeinsamen Mittelwertabgleich. Validierungslücken werden von Firmenkontrollfehlern unterschieden. Definitionen, Puffer und Signalling bleiben Hypothesen; beide fehlgeschlagenen Notch-Vorhersagen bleiben erhalten.
- **Punkt 2:** Tabelle 3 zeigt beide Fitfenster; B11–B13 enthalten breites Fenster, Zulieferkontrollen und Beobachtungsauswahl samt Firmenzahlen. Tabellenverweise passen zu den genannten Checks.
- **Punkt 3:** Einleitung, 6.1 und Schluss berichten gepoolte und A-share-Kontraste nebeneinander. Hong Kong ist ausdrücklich deskriptiv. Zuliefer-Spillovers werden mit Su et al. und dem Ausschlusscheck diskutiert.
- **Punkt 4:** Abstract, Einleitung, Finding 3 und Schluss begrenzen den Befund auf öffentliche Informationen. Finding 3 nennt zusätzliche Aufsichtsberichte mit Chu et al.
- **Punkt 5:** Vier Sätze im Schluss nennen Auswahlregel, Abdeckungsziel, Registervariablen, Untergrenzen statt κ, 53 Einträge und den Dezembertermin.
- **Punkt 6:** Abschnitt 4.1 enthält vier Sätze zu Aufsichtsberichten, Pilot/Rollout, Compliancefrist und Aussetzung.
- **Punkt 7:** Einleitung erklärt Überschussmasse in Worten; κ- und Intervalldetails entfernt; Abstract unter 100 Wörtern.
- **Punkt 8:** Tabellenumbrüche und Figure-2-Notiz korrigiert; Zeilen-/RL1- und CNKI-Zahlen getrennt; Bootstrap-Unterschiede erklärt; Guo-Beitrag, Grid-Sensitivität und Substitutionsvorbehalt ergänzt.
- **Punkt 9:** Appendix C enthält belegte Prompt-Ausschnitte und zwei Freigabe-/Dateizeitbeispiele mit protokollierten SHA-256-Präfixen.
- **Punkt 10:** Einleitung, Theorieüberleitung, Ergebnisse und Schluss gestrafft; Seitenlimit bei unveränderter Präambel eingehalten.

Zahlenbelege des neuen beziehungsweise numerisch geänderten Textes; folgende CSV-Pfade liegen unter `replication/outputs/tables/`:

[firm-specific excerpt withheld in public audit]
- **CNKI:** 52 Datensätze und 51 Artikel: `t063_reconcile.csv`. Die bestehenden 3 Kernjournalartikel behalten ihren bisherigen Screening-Beleg.
- **Hauptkontraste:** 4.02, 4.59 und 4.48: `t063_reproduction.csv`. Intervalle [1.67,6.80], [2.15,7.47], [1.85,7.64] und A-share 2.67 [−0.22,6.35]: bestehende `t043_delta_b.csv`, `t061_diff_bunching.csv`.
- **Ausgangsbefund:** 118 Beobachtungen versus 66.1 vorhergesagt, b von −0.88 auf 3.14: bestehende `t023_excess_mass.csv`; Fensterzählung zusätzlich `t063_distinct_firms.csv`.
- **Kontrolländerungen:** −0.574 [−1.67,0.44] bei 0.70 und −0.571 [−1.62,0.36] bei 0.60: `t063_reconcile.csv`. Bei 0.80: 0.00 [−1.37,1.32] bei zwei Dezimalstellen, bestehende `t061_estimates.csv`.
- **Breites Fenster:** [0.66,0.74), Masse bis 0.70 beziehungsweise 0.74; Kontraste 5.38 [2.48,8.92], 5.13 [2.00,8.86], 3.27 [−0.36,7.72]: `t063_window.csv`. Alle weiteren Zellen von B11 stammen aus dessen 16 Zeilen.
- **Zulieferkontrollen:** 596 Firmen, 4.59 [2.13,7.55], 5.52 [2.51,9.26]; Gegenprobe 156 Firmen: `t063_control_sens.csv`. Alle Zellen von B12 stammen aus dessen 16 Zeilen.
- **Firmen und Beobachtungsauswahl:** 35/43 Entwickler und 96/91 Kontrollen: `t063_distinct_firms.csv`. Auswahlwerte 4.65 [1.33,8.09], 3.99 [1.21,7.15], −0.62 [−2.17,0.91], jeweils 999 gültige Ziehungen: `t063_one_obs.csv`.
- **Kalibrierung:** 64 Paare, 30 Firmen, Mittelwert +0.010, SD 0.026: `t063_noise_calibration.csv`.
- **Simulationstabelle B9:** Ergebnispaare −0.88/0.85, 2.63/0.86, 4.09/0.85, 3.07/1.43, 2.31/0.38, 4.32/0.11; beobachtet 3.14/1.75; π=0/0.2/0.3/0.4/0.5, β=0/0.01/0.02, Δ=0.05/0.10: `t063_noise.csv`, Parameter 1/48/49/127/168/180. Auswahl: `t063_noise_representatives.csv`. Zwei empirische/sechs normale Abdeckungszellen, 1,000 Replikationen und Seed 20261017: T063-Ausgaben.
- **Zeitverlauf:** 1.48–2.17: bestehende `t041_bunching_by_date.csv`. Neue Halbjahresdarstellungen einschließlich Fallzahlen, Daten und Binbreite 0.02: `t063_by_date.csv`, `t063_by_date_histograms.csv`.
- **Masse oberhalb:** 1.75 [0.10,4.02] und 0.85 [−0.66,2.97]: bestehende `t058_above.csv`; Punktwerte zusätzlich `t063_noise.csv`.
- **Weitere Checks:** Grid 72/69: `t058_grid_summary.csv`; Exit-Anteile 10.0/17.5 Prozent, zehn Firmen und p=1.00: `t058_attrition.csv`; Kalendercheck 4.26 [1.98,7.02]: `t058_window.csv`; Hong Kong 6.74 [3.00,12.25] beziehungsweise 8.61: `t058_standard.csv`; Pilot −1.53 [−10.45,7.36]: `t058_pilot.csv`; Intensität −1.30 [−5.29,2.87]: `t058_notch.csv`.
- **Tabelle 3, Levels:** 2.58 [0.52,5.13], 3.76 [1.60,6.15], −0.20 [−1.85,2.01]: bestehende `t040_robustness.csv`, `t043_integration.csv`, `t055_falsification.csv`. Support 797/630 (136), 480/400 (80), 690/575 (115), 630 (132), Kontrolle 4,512/3,760 (752): T061-/T063-Support gemäß Quellenkommentaren. Bootstrap-Ziehungen und Intervallniveau: jeweilige CSVs.
- **MI und Vertragsbefund:** 11.5 Prozentpunkte und Anker Ende 2019: bestehende `t029_compliance.csv`; Reklassifikationsanteil 0.28: `t055_kappa_break_even.csv`; 10 von 249 klassifizierbaren Transaktionen und 239/249 unbekannte: `t047_coding.csv`; Pilot 107/117 unbekannte: `t044_pilot_coding.csv`.
- **Historische Bootstrap-Intervalle:** A-shares [−0.41,5.41] versus [−0.38,5.30], balanciert [1.48,6.86] versus [1.63,6.99], bei Punktwerten 2.10 und 3.91: `t063_reconcile.csv`. T061 resampelt die Teilpopulation, T058 zunächst alle 136 Entwickler.
- **Institutionelle Zahlen:** Schwellen 70/100 Prozent, Caps 15 minus 5 Prozentpunkte und Pilot-/Rolloutdaten: vorhandene Literaturbelege. Ende 2023, Ende 2022 und Belegseite 550: PI-bestätigte Passagen von Su, Huang und Chu.
- **Plan:** mindestens die Hälfte, 2020–21, 53 Einträge, 25. Dezember: freigegebener Punkt 5 der Karte. Signalling-Hypothese für 2021–22: Punkt 1.
- **Audit:** 1. November 2026, Freigaben 13:55/15:03, Dateiänderungen 14:20:39/15:12:19 und Hashpräfixe `c64f717417f4`/`07224d79f642`: `state/approvals.log` und Dateimetadaten. Prompt-, Datums- und Modellangaben: `AI_USAGE_LOG.md`.

## Offene Fragen

- Die 53 Registereinträge wurden als PI-Vorgabe übernommen; die Registerliste wurde nicht neu gezählt. Institutionelle Quellenpassagen wurden aufgrund der expliziten PI-Bestätigungen verwendet, ohne die PDFs erneut zu lesen.
- Kleven und Waseem bleibt entsprechend dem Projektstatus als nur auf Abstract-Ebene geprüft markiert. Die zusätzliche Verwendung beschränkt sich auf die ausdrücklich verlangten Optimierungsfriktionen.
- Simulationen und Auswahlperzentile sind keine Stichproben-Konfidenzintervalle. Definitionen, Sicherheitspuffer und Signalling bleiben ungetestet. Das lokale Auditprotokoll ersetzt keine unveränderliche Präregistrierung.
- Kein Git und kein Netzwerk verwendet; keine Analyse, Stichprobe oder Rohdatei geändert. SHA-256-Vergleich bestätigt unveränderte Ergebnisdateien, Aufgabenkarte und Protokolle. Präambel und Bibliografie sind unverändert; Status bleibt `APPROVED`.
- Vorschlag für `AI_USAGE_LOG.md`: „2026-11-02, Codex, T064: freigegebene Textrevision mit T063-Ergebnissen; Marktvergleich, Kalibrierungsgrenzen, öffentliche Offenlegung und Registerplan präzisiert; Zahlen-, Build- und Layoutprüfung; Haupttext 15 Seiten, Abstract 83 Wörter.“ Die Logdatei liegt außerhalb des Schreibbereichs und wurde nicht verändert.