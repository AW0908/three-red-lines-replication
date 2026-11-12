## Ergebnis

T061 ist in Abstract, Einleitung, Abschnitte 4–6, Tabellen 2/3/6, Schluss und Appendix B integriert. Beide gleichrangigen Kontrollvergleiche sind positiv; beim A-Share-Vergleich wird das null einschließende Intervall ausdrücklich genannt. Der Haupttext endet auf Seite 15, der Abstract hat 87 Wörter und der Build ist warnungsfrei.

## Dateien

- `proposal/main.tex` – ausschließlich Abstract ergänzt.
- `proposal/sections/01_introduction.tex` – Kontrollvergleich und Kürzungen.
- `proposal/sections/04_empirical_model.tex` – Gleichung, Kontrollgruppe, Bootstrap und Identifikationsannahmen.
- `proposal/sections/05_context_data.tex` – Vergleichsestimand, Kontrollquelle und Auswahlgrenzen.
- `proposal/sections/06_preliminary_analysis.tex` – Kontrollresultate, korrigierte Placebos und Diskussion.
- `proposal/sections/07_conclusion.tex` – Kontrollbefund und Kürzungen.
- `proposal/tables/t050_identification.tex` – neue Identifikationszeile.
- `proposal/tables/t051_robustness.tex` – zwei gleichrangige Kontraste; neun Ergebniszeilen.
- `proposal/tables/t049_threats.tex` – gemeinsame Veränderungen gegenüber verbleibenden Sektorschocks und Kontrollselektion abgegrenzt.
- `proposal/tables/t061_results.tex` – Appendix-Kopie mit angepassten Beschriftungen und unveränderten Zahlen.
- `proposal/appendix/results.tex` – ausschließlich neuer Unterabschnitt B.2 mit Tabelle B9 und Abbildung B4.
- `proposal/figures/t061_control_density.pdf` – unveränderte Kopie der Kontrollgrafik.
- `proposal/figures/t055_kappa.pdf` – unveränderte Kopie der neu gerenderten κ-Grafik.
- `tasks/T062_report.md` – ausführlicher Bericht einschließlich Zahlenquellen.
- `review/T062_build/main.pdf` – geprüfter Gesamtbuild.
- `review/T062_build/main.log` – warnungsfreies LaTeX-Protokoll.
- `review/T062_build/main.aux`, `review/T062_build/main.bbl`, `review/T062_build/main.blg`, `review/T062_build/main.fdb_latexmk`, `review/T062_build/main.fls`, `review/T062_build/main.out`, `review/T062_build/main.toc`, `review/T062_build/main.xdv` – automatisch erzeugte Build- und Referenzbelege.

## Ausführung

Kartenbefehl selbst ausgeführt; Neuaufbau und abschließender Kontrolllauf jeweils mit Exit-Code 0:

[fenced excerpt withheld in public audit]
[fenced excerpt withheld in public audit]

Letzte Ausgabezeilen:

[fenced excerpt withheld in public audit]
[fenced excerpt withheld in public audit]

## Abnahmekriterien

1. **Erfüllt:** Sämtliche Zahlenzellen der sechs Schätzzeilen und drei Kontrastzeilen in Tabelle B9 wurden zeilenweise gegen die CSVs geprüft; die beiden neuen Haupttabellenzeilen ebenfalls. Die zitierten Tabellen enthalten die jeweiligen Ergebnisse.
2. **Erfüllt:** `sec:main_end` steht in `review/T062_build/main.aux` auf Seite 15. Keine LaTeX-/Paketwarnungen, undefinierten Verweise oder Overfull-/Underfull-Boxen. Geänderte Textseiten, Tabellen und Abbildungen visuell geprüft.
3. **Erfüllt:** Punkte 1–9 der Karte umgesetzt:

   - **Punkt 1:** Abschnitt 5.1 enthält Gleichung (2), identische Schätzkonventionen, Branchen, 752 balancierte Kontrollfirmen, gruppenweise Firmenresampling und die Annahme gleicher Veränderungen ohne Policy.
   - **Punkt 2:** Abschnitt 6.1 und Tabellen 3/B9 enthalten beide gleichrangigen Kontraste, Kontrollniveaus und korrigierte Placebos. Das A-Share-Intervall schließt ausdrücklich null ein. Zwei bisherige Robustheitszeilen wurden zugunsten der Kontraste entfernt; ihre Appendix-Belege bleiben erhalten.
   - **Punkt 3:** Tabellen 2/6 unterscheiden adressierte gemeinsame Veränderungen von entwicklerspezifischen Schocks und Survivor-Selektion.
   - **Punkt 4:** Abschnitte 4.1/5 definieren den Vergleich gegen unregulierte Firmen bei identischen Zeitfenstern.
   - **Punkt 5:** Kontrollbefund in Abstract, Einleitung und Schluss; Abstract 87 Wörter.
   - **Punkt 6:** Aktuelle Sina-Listen, balancierte Survivor-Kontrolle, fehlende HK-Kontrolle und nicht möglicher SOE-Split genannt. Die Abweichung bei den Ausfällen ist unten erläutert.
   - **Punkt 7:** Neuer Unterabschnitt B.2, Tabelle B9 und Kontrollgrafik B4; aktualisierte κ-Grafik B7. Beide PDF-Kopien stimmen byteweise mit ihren Quellen überein.
   - **Punkt 8:** Abschnitt 4.2 nennt Sina, EastMoney und identische RL1-Konstruktion mit Appendix-Verweis.
   - **Punkt 9:** Wiederholungen gekürzt; Haupttext weiterhin 15 Seiten.

Zahlen des neuen Kontrollvergleichs; CSV-Pfade jeweils unter `replication/outputs/tables/`:

| Zahlen im neuen Text und Tabelle B9 | Quelle |
|---|---|
| 752 Kontrollfirmen; 4.512/3.760 Beobachtungen | `t061_support.csv` |
| 64 fehlende Firmen; 62 ohne historischen Fehlergrund | `t061_failure_by_sector.csv`, Spaltensummen |
| Schwelle 0,70; Fenster [0,66; 0,70); Binbreite 0,01; Grad 5; Fit [0,40; 1,00]; 999 Ziehungen; Seed 20261016 | `t061_estimates.csv` |
| Pre 2017H1–2019H2; post 2020H2–2022H2; 13 Analysestichtage ab 2016H2 | `t061_cleaning_rules.csv`, Regeln 4/9 |
| Placebos 0,60/0,80; zusätzlicher Ausschluss [0,66; 0,72); vier Massen-Bins; Supportgrenze 30; 95%-Intervalle | `t061_interpretation.csv`, `t061_estimates.csv` |
| Kontrolle 0,70: −0,177/−0,750/−0,574 [−1,675; 0,439]; Support 207/159; Fließtext −0,18/−0,75/−0,57 | `t061_estimates.csv` |
| Kontrolle 0,60: 0,402/−0,169/−0,571 [−1,618; 0,364]; Support 324/269; Fließtext −0,57 [−1,62; 0,36] | `t061_estimates.csv` |
| Kontrolle 0,80: −0,559/−0,556/0,003 [−1,370; 1,316]; Support 103/88; Fließtext 0,003 [−1,37; 1,32] | `t061_estimates.csv` |
| Alle Entwickler: −0,877/3,143/4,020 [1,671; 6,797]; Support 67/118; Fließtext −0,88/3,14/4,02 [1,67; 6,80], Abstract 4,0; 118 beobachtet gegenüber 66,1 prognostiziert | `t061_estimates.csv` |
| Balancierte Entwickler: −0,662/3,244/3,906 [1,476; 6,856]; Support 66/109; Tabelle 3: 3,91 [1,48; 6,86] | `t061_estimates.csv` |
| A-Share-Entwickler: 0,151/2,247/2,096 [−0,405; 5,406]; Support 50/63 | `t061_estimates.csv` |
| ΔΔb gesamt: 4,594 [2,155; 7,469], Fließtext 4,59 [2,15; 7,47]; Entwickler-N 797/630 (136 Firmen) | `t061_diff_bunching.csv` |
| ΔΔb balanciert: 4,480 [1,850; 7,642], Fließtext 4,48 [1,85; 7,64]; N 690/575 (115 Firmen) | `t061_diff_bunching.csv` |
| ΔΔb A-Shares: 2,670 [−0,223; 6,354], Fließtext 2,67 [−0,22; 6,35] | `t061_diff_bunching.csv` |

Bereits belegte Zahlen wurden bei Kürzungen übernommen: Stichprobe 136/42/80/56, 1.692 und 13 (`t004_panel_counts.csv`, `t030_coverage.csv`); 630/531 (`t023_coverage.csv`); MI-Anker 2019, Compliance 11,5, κ 0,28/0,09 und 10/249 klassifizierbare Transaktionen (`t029_compliance.csv`, `t055_kappa_break_even.csv`, `t047_coding.csv`).

Die verbleibenden Robustheitswerte behalten ihre Quellenkommentare: −1,23/0,31 mit Intervallen [−4,26; 1,70]/[−1,16; 1,92] (`t043_delta_b.csv`); 3,54 [1,11; 6,76], 498/130 (`t031_timing.csv`); 2,58 [0,52; 5,13] (`t040_robustness.csv`); 3,76 [1,60; 6,15] (`t043_integration.csv`); −0,20 [−1,85; 2,01], Differenz 3,34 [0,32; 6,58] und Änderungsdifferenz 2,91 [−0,59; 6,25] (`t055_falsification.csv`); 72/69 und Median 3,92 (`t058_grid_summary.csv`). Die verbleibenden Level-Zeilen nutzen 630 Beobachtungen/132 Firmen. Bestehende institutionelle Datumsangaben und Literaturbelege wurden übernommen.

## Offene Fragen

- Die Karte nennt 62 ausgeschlossene Kontrollfirmen. Die CSVs belegen insgesamt **64** fehlende Firmen; **62** bezeichnet Fälle ohne rekonstruierbaren historischen Fehlergrund. Im Text stehen beide Größen mit ihrer jeweiligen Bedeutung.
- Der balancierte Entwickler-Δb-Wert bleibt 3,91. Tabelle 3 verwendet das T061-Bootstrapintervall [1,48; 6,86]; das bisherige T058-Intervall [1,63; 6,99] bleibt in dessen unveränderter Appendix-Tabelle. Die Haupttabellennote erklärt die unterschiedliche Bootstrap-Grundlage.
- Survivor-Selektion, Marktunterschiede und entwicklerspezifische Schocks bleiben Identifikationsgrenzen. Keine neue Schätzung, kein Netzwerkzugriff und kein Git; Rohdaten, Replikationsausgaben und Kartenstatus unverändert.
- Vorschlag für `AI_USAGE_LOG.md`: „Codex, T062: T061-Kontrollvergleich mit Annahmen und Einschränkungen ins Proposal integriert; Zahlen gegen CSVs, Schreibbereich, 15-Seiten-Grenze und PDF-Layout geprüft.“ Die Protokolldatei liegt außerhalb des Schreibbereichs und wurde nicht bearbeitet.