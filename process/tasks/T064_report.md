## Ergebnis

T064 ist umgesetzt: T063 wurde in Haupttext und Anhang integriert, der A-share-Vergleich erhält gleiches Gewicht und die Noise-Kalibrierung wird als fehlender gemeinsamer Mittelwertabgleich eingeordnet. Der Offenlegungsbefund betrifft öffentliche Informationen; der Schluss enthält den Registerplan. Der Build ist sauber, der Haupttext endet auf Seite [number withheld] und der Abstract umfasst [number withheld] Wörter.

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
- `review/T0[number withheld]_build/main.aux`, `review/T0[number withheld]_build/main.bbl`, `review/T0[number withheld]_build/main.blg`, `review/T0[number withheld]_build/main.fdb_latexmk`, `review/T0[number withheld]_build/main.fls`, `review/T064_build/main.log`, `review/T0[number withheld]_build/main.out`, `review/T0[number withheld]_build/main.toc`, `review/T0[number withheld]_build/main.xdv` – Builddateien.
- `review/T064_build/qa_01.png`, `review/T064_build/qa_03.png`, `review/T064_build/qa_05.png`, `review/T064_build/qa_09.png`, `review/T064_build/qa_12.png`, `review/T064_build/qa_15.png`, `review/T064_build/qa_17.png`, `review/T064_build/qa_29.png`, `review/T064_build/qa_31.png`, `review/T064_build/qa_32.png`, `review/T064_build/qa_33.png`, `review/T064_build/qa_49.png`, `review/T064_build/qa_50.png`, `review/T064_build/qa_51.png`, `review/T064_build/qa_52.png` – visuelle Zwischenprüfung.
- `review/T064_build/final_29.png`, `review/T064_build/final_31.png`, `review/T064_build/final_32.png`, `review/T064_build/final_33.png`, `review/T064_build/final_34.png`, `review/T064_build/final_53.png` – gerenderte Endfassungen der zuletzt geänderten Anhangsseiten.

## Ausführung

Exakter Befehl, selbst ausgeführt; abschließender Kontrollaufruf mit Exit-Code [number withheld]:

[fenced excerpt withheld in public process copy]
[fenced excerpt withheld in public process copy]

Letzte Zeilen:

[fenced excerpt withheld in public process copy]
[fenced excerpt withheld in public process copy]

Der Übersetzungslauf erzeugte [number withheld] PDF-Seiten einschließlich Literatur und Anhängen. Keine LaTeX-Warnungen, undefinierten Verweise, Overfull- oder Underfull-Boxen. `main.aux` bestätigt Haupttextende auf Seite [number withheld]; die betroffenen Tabellen und Seiten wurden visuell geprüft.

PDF-SHA-[number withheld]: `be54ce8e8d06fdca52c982291f49dcb0d8506c8f30139ef386afa9d81801c0ba`.

## Abnahmekriterien

[number withheld]. **Erfüllt für empirische Zahlen:** Neue T063-Tabellen wurden direkt aus den CSV-Zellen gerundet; die berichteten T063-Kontraste stimmen überein. Keine neuen Bibliografieeinträge. Neue institutionelle Aussagen folgen den PI-Bestätigungen. Plan- und Auditangaben stammen aus den ausdrücklich vorgeschriebenen Quellen.
[number withheld]. **Erfüllt:** Haupttextende Seite [number withheld]; sauberer Build; Abstract [number withheld] Wörter.
[number withheld]. **Erfüllt:** Kartenpunkte [number withheld]–[number withheld] sind umgesetzt:

- **Punkt [number withheld]:** Abschnitte [number withheld]/[number withheld] und Tabelle B9 zeigen den fehlenden gemeinsamen Mittelwertabgleich. Validierungslücken werden von Firmenkontrollfehlern unterschieden. Definitionen, Puffer und Signalling bleiben Hypothesen; beide fehlgeschlagenen Notch-Vorhersagen bleiben erhalten.
- **Punkt [number withheld]:** Tabelle [number withheld] zeigt beide Fitfenster; B1[number withheld]–B1[number withheld] enthalten breites Fenster, Zulieferkontrollen und Beobachtungsauswahl samt Firmenzahlen. Tabellenverweise passen zu den genannten Checks.
- **Punkt [number withheld]:** Einleitung, [number withheld] und Schluss berichten gepoolte und A-share-Kontraste nebeneinander. Hong Kong ist ausdrücklich deskriptiv. Zuliefer-Spillovers werden mit Su et al. und dem Ausschlusscheck diskutiert.
- **Punkt [number withheld]:** Abstract, Einleitung, Finding [number withheld] und Schluss begrenzen den Befund auf öffentliche Informationen. Finding [number withheld] nennt zusätzliche Aufsichtsberichte mit Chu et al.
- **Punkt [number withheld]:** Vier Sätze im Schluss nennen Auswahlregel, Abdeckungsziel, Registervariablen, Untergrenzen statt κ, [number withheld] Einträge und den Dezembertermin.
- **Punkt [number withheld]:** Abschnitt [number withheld] enthält vier Sätze zu Aufsichtsberichten, Pilot/Rollout, Compliancefrist und Aussetzung.
- **Punkt [number withheld]:** Einleitung erklärt Überschussmasse in Worten; κ- und Intervalldetails entfernt; Abstract unter [number withheld] Wörtern.
- **Punkt [number withheld]:** Tabellenumbrüche und Figure-[number withheld]-Notiz korrigiert; Zeilen-/RL1- und CNKI-Zahlen getrennt; Bootstrap-Unterschiede erklärt; Guo-Beitrag, Grid-Sensitivität und Substitutionsvorbehalt ergänzt.
- **Punkt [number withheld]:** Appendix C enthält belegte Prompt-Ausschnitte und zwei Freigabe-/Dateizeitbeispiele mit protokollierten SHA-[number withheld]-Präfixen.
- **Punkt [number withheld]:** Einleitung, Theorieüberleitung, Ergebnisse und Schluss gestrafft; Seitenlimit bei unveränderter Präambel eingehalten.

Zahlenbelege des neuen beziehungsweise numerisch geänderten Textes; folgende CSV-Pfade liegen unter `replication/outputs/tables/`:

[firm-specific excerpt withheld in public process copy]
- **CNKI:** [number withheld] Datensätze und [number withheld] Artikel: `t063_reconcile.csv`. Die bestehenden [number withheld] Kernjournalartikel behalten ihren bisherigen Screening-Beleg.
- **Hauptkontraste:** [number withheld], [number withheld] und [number withheld]: `t063_reproduction.csv`. Intervalle [[number withheld]], [[number withheld]], [[number withheld]] und A-share [number withheld] [[number withheld]]: bestehende `t043_delta_b.csv`, `t061_diff_bunching.csv`.
- **Ausgangsbefund:** [number withheld] Beobachtungen versus [number withheld] vorhergesagt, b von [number withheld] auf [number withheld]: bestehende `t023_excess_mass.csv`; Fensterzählung zusätzlich `t063_distinct_firms.csv`.
- **Kontrolländerungen:** [number withheld] [[number withheld]] bei [number withheld] und [number withheld] [[number withheld]] bei [number withheld]: `t063_reconcile.csv`. Bei [number withheld]: [number withheld] [[number withheld]] bei zwei Dezimalstellen, bestehende `t061_estimates.csv`.
- **Breites Fenster:** [[number withheld]), Masse bis [number withheld] beziehungsweise [number withheld]; Kontraste [number withheld] [[number withheld]], [number withheld] [[number withheld]], [number withheld] [[number withheld]]: `t063_window.csv`. Alle weiteren Zellen von B1[number withheld] stammen aus dessen [number withheld] Zeilen.
- **Zulieferkontrollen:** [number withheld] Firmen, [number withheld] [[number withheld]], [number withheld] [[number withheld]]; Gegenprobe [number withheld] Firmen: `t063_control_sens.csv`. Alle Zellen von B1[number withheld] stammen aus dessen [number withheld] Zeilen.
- **Firmen und Beobachtungsauswahl:** [number withheld]/[number withheld] Entwickler und [number withheld]/[number withheld] Kontrollen: `t063_distinct_firms.csv`. Auswahlwerte [number withheld] [[number withheld]], [number withheld] [[number withheld]], [number withheld] [[number withheld]], jeweils [number withheld] gültige Ziehungen: `t063_one_obs.csv`.
- **Kalibrierung:** [number withheld] Paare, [number withheld] Firmen, Mittelwert [number withheld], SD [number withheld]: `t063_noise_calibration.csv`.
- **Simulationstabelle B9:** Ergebnispaare [number withheld]/[number withheld], [number withheld]/[number withheld], [number withheld]/[number withheld], [number withheld]/[number withheld], [number withheld]/[number withheld], [number withheld]/[number withheld]; beobachtet [number withheld]/[number withheld]; π=[number withheld]/[number withheld]/[number withheld]/[number withheld]/[number withheld], β=[number withheld]/[number withheld]/[number withheld], Δ=[number withheld]/[number withheld]: `t063_noise.csv`, Parameter [number withheld]/[number withheld]/[number withheld]/[number withheld]/[number withheld]/[number withheld]. Auswahl: `t063_noise_representatives.csv`. Zwei empirische/sechs normale Abdeckungszellen, [number withheld] Replikationen und Seed [number withheld]: T063-Ausgaben.
- **Zeitverlauf:** [number withheld]–[number withheld]: bestehende `t041_bunching_by_date.csv`. Neue Halbjahresdarstellungen einschließlich Fallzahlen, Daten und Binbreite [number withheld]: `t063_by_date.csv`, `t063_by_date_histograms.csv`.
- **Masse oberhalb:** [number withheld] [[number withheld]] und [number withheld] [[number withheld]]: bestehende `t058_above.csv`; Punktwerte zusätzlich `t063_noise.csv`.
- **Weitere Checks:** Grid [number withheld]/[number withheld]: `t058_grid_summary.csv`; Exit-Anteile [number withheld]/[number withheld] Prozent, zehn Firmen und p=[number withheld]: `t058_attrition.csv`; Kalendercheck [number withheld] [[number withheld]]: `t058_window.csv`; Hong Kong [number withheld] [[number withheld]] beziehungsweise [number withheld]: `t058_standard.csv`; Pilot [number withheld] [[number withheld]]: `t058_pilot.csv`; Intensität [number withheld] [[number withheld]]: `t058_notch.csv`.
- **Tabelle [number withheld], Levels:** [number withheld] [[number withheld]], [number withheld] [[number withheld]], [number withheld] [[number withheld]]: bestehende `t040_robustness.csv`, `t043_integration.csv`, `t055_falsification.csv`. Support [number withheld]/[number withheld] ([number withheld]), [number withheld]/[number withheld] ([number withheld]), [number withheld]/[number withheld] ([number withheld]), [number withheld] ([number withheld]), Kontrolle [number withheld]/[number withheld] ([number withheld]): T061-/T063-Support gemäß Quellenkommentaren. Bootstrap-Ziehungen und Intervallniveau: jeweilige CSVs.
- **MI und Vertragsbefund:** [number withheld] Prozentpunkte und Anker Ende [number withheld]: bestehende `t029_compliance.csv`; Reklassifikationsanteil [number withheld]: `t055_kappa_break_even.csv`; [number withheld] von [number withheld] klassifizierbaren Transaktionen und [number withheld]/[number withheld] unbekannte: `t047_coding.csv`; Pilot [number withheld]/[number withheld] unbekannte: `t044_pilot_coding.csv`.
- **Historische Bootstrap-Intervalle:** A-shares [[number withheld]] versus [[number withheld]], balanciert [[number withheld]] versus [[number withheld]], bei Punktwerten [number withheld] und [number withheld]: `t063_reconcile.csv`. T061 resampelt die Teilpopulation, T058 zunächst alle [number withheld] Entwickler.
- **Institutionelle Zahlen:** Schwellen [number withheld]/[number withheld] Prozent, Caps [number withheld] minus [number withheld] Prozentpunkte und Pilot-/Rolloutdaten: vorhandene Literaturbelege. Ende [number withheld], Ende [number withheld] und Belegseite [number withheld]: PI-bestätigte Passagen von Su, Huang und Chu.
- **Plan:** mindestens die Hälfte, [number withheld]–[number withheld], [number withheld] Einträge, [number withheld]. Dezember: freigegebener Punkt [number withheld] der Karte. Signalling-Hypothese für [number withheld]–[number withheld]: Punkt [number withheld].
- **Audit:** [number withheld]. November [number withheld], Freigaben [number withheld]:[number withheld]/[number withheld]:[number withheld], Dateiänderungen [number withheld]:[number withheld]:[number withheld]/[number withheld]:[number withheld]:[number withheld] und Hashpräfixe `c6[number withheld]f7[number withheld]f4`/`[number withheld]d7[number withheld]f6[number withheld]`: `state/approvals.log` und Dateimetadaten. Prompt-, Datums- und Modellangaben: `AI_USAGE_LOG.md`.

## Offene Fragen

- Die [number withheld] Registereinträge wurden als PI-Vorgabe übernommen; die Registerliste wurde nicht neu gezählt. Institutionelle Quellenpassagen wurden aufgrund der expliziten PI-Bestätigungen verwendet, ohne die PDFs erneut zu lesen.
- Kleven und Waseem bleibt entsprechend dem Projektstatus als nur auf Abstract-Ebene geprüft markiert. Die zusätzliche Verwendung beschränkt sich auf die ausdrücklich verlangten Optimierungsfriktionen.
- Simulationen und Auswahlperzentile sind keine Stichproben-Konfidenzintervalle. Definitionen, Sicherheitspuffer und Signalling bleiben ungetestet. Das lokale Auditprotokoll ersetzt keine unveränderliche Präregistrierung.
- Kein Git und kein Netzwerk verwendet; keine Analyse, Stichprobe oder Rohdatei geändert. SHA-[number withheld]-Vergleich bestätigt unveränderte Ergebnisdateien, Aufgabenkarte und Protokolle. Präambel und Bibliografie sind unverändert; Status bleibt `APPROVED`.
- Vorschlag für `AI_USAGE_LOG.md`: „2026-11-02, Codex, T064: freigegebene Textrevision mit T063-Ergebnissen; Marktvergleich, Kalibrierungsgrenzen, öffentliche Offenlegung und Registerplan präzisiert; Zahlen-, Build- und Layoutprüfung; Haupttext [number withheld] Seiten, Abstract [number withheld] Wörter.“ Die Logdatei liegt außerhalb des Schreibbereichs und wurde nicht verändert.