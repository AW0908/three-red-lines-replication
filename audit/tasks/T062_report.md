## Ergebnis

T061 ist in Abstract, Einleitung, Abschnitte [number withheld]–[number withheld], Tabellen [number withheld]/[number withheld]/[number withheld], Schluss und Appendix B integriert. Beide gleichrangigen Kontrollvergleiche sind positiv; beim A-Share-Vergleich wird das null einschließende Intervall ausdrücklich genannt. Der Haupttext endet auf Seite [number withheld], der Abstract hat [number withheld] Wörter und der Build ist warnungsfrei.

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
- `proposal/appendix/results.tex` – ausschließlich neuer Unterabschnitt B.[number withheld] mit Tabelle B9 und Abbildung B4.
- `proposal/figures/t061_control_density.pdf` – unveränderte Kopie der Kontrollgrafik.
- `proposal/figures/t055_kappa.pdf` – unveränderte Kopie der neu gerenderten κ-Grafik.
- `tasks/T062_report.md` – ausführlicher Bericht einschließlich Zahlenquellen.
- `review/T062_build/main.pdf` – geprüfter Gesamtbuild.
- `review/T062_build/main.log` – warnungsfreies LaTeX-Protokoll.
- `review/T0[number withheld]_build/main.aux`, `review/T0[number withheld]_build/main.bbl`, `review/T0[number withheld]_build/main.blg`, `review/T0[number withheld]_build/main.fdb_latexmk`, `review/T0[number withheld]_build/main.fls`, `review/T0[number withheld]_build/main.out`, `review/T0[number withheld]_build/main.toc`, `review/T0[number withheld]_build/main.xdv` – automatisch erzeugte Build- und Referenzbelege.

## Ausführung

Kartenbefehl selbst ausgeführt; Neuaufbau und abschließender Kontrolllauf jeweils mit Exit-Code [number withheld]:

[fenced excerpt withheld in public process copy]
[fenced excerpt withheld in public process copy]

Letzte Ausgabezeilen:

[fenced excerpt withheld in public process copy]
[fenced excerpt withheld in public process copy]

## Abnahmekriterien

[number withheld]. **Erfüllt:** Sämtliche Zahlenzellen der sechs Schätzzeilen und drei Kontrastzeilen in Tabelle B9 wurden zeilenweise gegen die CSVs geprüft; die beiden neuen Haupttabellenzeilen ebenfalls. Die zitierten Tabellen enthalten die jeweiligen Ergebnisse.
[number withheld]. **Erfüllt:** `sec:main_end` steht in `review/T0[number withheld]_build/main.aux` auf Seite [number withheld]. Keine LaTeX-/Paketwarnungen, undefinierten Verweise oder Overfull-/Underfull-Boxen. Geänderte Textseiten, Tabellen und Abbildungen visuell geprüft.
[number withheld]. **Erfüllt:** Punkte [number withheld]–[number withheld] der Karte umgesetzt:

   - **Punkt [number withheld]:** Abschnitt [number withheld] enthält Gleichung ([number withheld]), identische Schätzkonventionen, Branchen, [number withheld] balancierte Kontrollfirmen, gruppenweise Firmenresampling und die Annahme gleicher Veränderungen ohne Policy.
   - **Punkt [number withheld]:** Abschnitt [number withheld] und Tabellen [number withheld]/B9 enthalten beide gleichrangigen Kontraste, Kontrollniveaus und korrigierte Placebos. Das A-Share-Intervall schließt ausdrücklich null ein. Zwei bisherige Robustheitszeilen wurden zugunsten der Kontraste entfernt; ihre Appendix-Belege bleiben erhalten.
   - **Punkt [number withheld]:** Tabellen [number withheld]/[number withheld] unterscheiden adressierte gemeinsame Veränderungen von entwicklerspezifischen Schocks und Survivor-Selektion.
   - **Punkt [number withheld]:** Abschnitte [number withheld]/[number withheld] definieren den Vergleich gegen unregulierte Firmen bei identischen Zeitfenstern.
   - **Punkt [number withheld]:** Kontrollbefund in Abstract, Einleitung und Schluss; Abstract [number withheld] Wörter.
   - **Punkt [number withheld]:** Aktuelle Sina-Listen, balancierte Survivor-Kontrolle, fehlende HK-Kontrolle und nicht möglicher SOE-Split genannt. Die Abweichung bei den Ausfällen ist unten erläutert.
   - **Punkt [number withheld]:** Neuer Unterabschnitt B.[number withheld], Tabelle B9 und Kontrollgrafik B4; aktualisierte κ-Grafik B7. Beide PDF-Kopien stimmen byteweise mit ihren Quellen überein.
   - **Punkt [number withheld]:** Abschnitt [number withheld] nennt Sina, EastMoney und identische RL1-Konstruktion mit Appendix-Verweis.
   - **Punkt [number withheld]:** Wiederholungen gekürzt; Haupttext weiterhin [number withheld] Seiten.

Zahlen des neuen Kontrollvergleichs; CSV-Pfade jeweils unter `replication/outputs/tables/`:

| Zahlen im neuen Text und Tabelle B9 | Quelle |
|---|---|
| [number withheld] Kontrollfirmen; [number withheld]/[number withheld] Beobachtungen | `t061_support.csv` |
| [number withheld] fehlende Firmen; [number withheld] ohne historischen Fehlergrund | `t061_failure_by_sector.csv`, Spaltensummen |
| Schwelle [number withheld]; Fenster [[number withheld]; [number withheld]); Binbreite [number withheld]; Grad [number withheld]; Fit [[number withheld]; [number withheld]]; [number withheld] Ziehungen; Seed [number withheld] | `t061_estimates.csv` |
| Pre [number withheld]H1–[number withheld]H2; post [number withheld]H2–[number withheld]H2; [number withheld] Analysestichtage ab [number withheld]H2 | `t061_cleaning_rules.csv`, Regeln [number withheld]/[number withheld] |
| Placebos [number withheld]/[number withheld]; zusätzlicher Ausschluss [[number withheld]; [number withheld]); vier Massen-Bins; Supportgrenze [number withheld]; [number withheld]%-Intervalle | `t061_interpretation.csv`, `t061_estimates.csv` |
| Kontrolle [number withheld]: [number withheld]/[number withheld]/[number withheld] [[number withheld]; [number withheld]]; Support [number withheld]/[number withheld]; Fließtext [number withheld]/[number withheld]/[number withheld] | `t061_estimates.csv` |
| Kontrolle [number withheld]: [number withheld]/[number withheld]/[number withheld] [[number withheld]; [number withheld]]; Support [number withheld]/[number withheld]; Fließtext [number withheld] [[number withheld]; [number withheld]] | `t061_estimates.csv` |
| Kontrolle [number withheld]: [number withheld]/[number withheld]/[number withheld] [[number withheld]; [number withheld]]; Support [number withheld]/[number withheld]; Fließtext [number withheld] [[number withheld]; [number withheld]] | `t061_estimates.csv` |
| Alle Entwickler: [number withheld]/[number withheld]/[number withheld] [[number withheld]; [number withheld]]; Support [number withheld]/[number withheld]; Fließtext [number withheld]/[number withheld]/[number withheld] [[number withheld]; [number withheld]], Abstract [number withheld]; [number withheld] beobachtet gegenüber [number withheld] prognostiziert | `t061_estimates.csv` |
| Balancierte Entwickler: [number withheld]/[number withheld]/[number withheld] [[number withheld]; [number withheld]]; Support [number withheld]/[number withheld]; Tabelle [number withheld]: [number withheld] [[number withheld]; [number withheld]] | `t061_estimates.csv` |
| A-Share-Entwickler: [number withheld]/[number withheld]/[number withheld] [[number withheld]; [number withheld]]; Support [number withheld]/[number withheld] | `t061_estimates.csv` |
| ΔΔb gesamt: [number withheld] [[number withheld]; [number withheld]], Fließtext [number withheld] [[number withheld]; [number withheld]]; Entwickler-N [number withheld]/[number withheld] ([number withheld] Firmen) | `t061_diff_bunching.csv` |
| ΔΔb balanciert: [number withheld] [[number withheld]; [number withheld]], Fließtext [number withheld] [[number withheld]; [number withheld]]; N [number withheld]/[number withheld] ([number withheld] Firmen) | `t061_diff_bunching.csv` |
| ΔΔb A-Shares: [number withheld] [[number withheld]; [number withheld]], Fließtext [number withheld] [[number withheld]; [number withheld]] | `t061_diff_bunching.csv` |

Bereits belegte Zahlen wurden bei Kürzungen übernommen: Stichprobe [number withheld]/[number withheld]/[number withheld]/[number withheld], [number withheld] und [number withheld] (`t004_panel_counts.csv`, `t030_coverage.csv`); [number withheld]/[number withheld] (`t023_coverage.csv`); MI-Anker [number withheld], Compliance [number withheld], κ [number withheld]/[number withheld] und [number withheld]/[number withheld] klassifizierbare Transaktionen (`t029_compliance.csv`, `t055_kappa_break_even.csv`, `t047_coding.csv`).

Die verbleibenden Robustheitswerte behalten ihre Quellenkommentare: [number withheld]/[number withheld] mit Intervallen [[number withheld]; [number withheld]]/[[number withheld]; [number withheld]] (`t043_delta_b.csv`); [number withheld] [[number withheld]; [number withheld]], [number withheld]/[number withheld] (`t031_timing.csv`); [number withheld] [[number withheld]; [number withheld]] (`t040_robustness.csv`); [number withheld] [[number withheld]; [number withheld]] (`t043_integration.csv`); [number withheld] [[number withheld]; [number withheld]], Differenz [number withheld] [[number withheld]; [number withheld]] und Änderungsdifferenz [number withheld] [[number withheld]; [number withheld]] (`t055_falsification.csv`); [number withheld]/[number withheld] und Median [number withheld] (`t058_grid_summary.csv`). Die verbleibenden Level-Zeilen nutzen [number withheld] Beobachtungen/[number withheld] Firmen. Bestehende institutionelle Datumsangaben und Literaturbelege wurden übernommen.

## Offene Fragen

- Die Karte nennt [number withheld] ausgeschlossene Kontrollfirmen. Die CSVs belegen insgesamt **[number withheld]** fehlende Firmen; **[number withheld]** bezeichnet Fälle ohne rekonstruierbaren historischen Fehlergrund. Im Text stehen beide Größen mit ihrer jeweiligen Bedeutung.
- Der balancierte Entwickler-Δb-Wert bleibt [number withheld]. Tabelle [number withheld] verwendet das T061-Bootstrapintervall [[number withheld]; [number withheld]]; das bisherige T058-Intervall [[number withheld]; [number withheld]] bleibt in dessen unveränderter Appendix-Tabelle. Die Haupttabellennote erklärt die unterschiedliche Bootstrap-Grundlage.
- Survivor-Selektion, Marktunterschiede und entwicklerspezifische Schocks bleiben Identifikationsgrenzen. Keine neue Schätzung, kein Netzwerkzugriff und kein Git; Rohdaten, Replikationsausgaben und Kartenstatus unverändert.
- Vorschlag für `AI_USAGE_LOG.md`: „Codex, T062: T061-Kontrollvergleich mit Annahmen und Einschränkungen ins Proposal integriert; Zahlen gegen CSVs, Schreibbereich, [number withheld]-Seiten-Grenze und PDF-Layout geprüft.“ Die Protokolldatei liegt außerhalb des Schreibbereichs und wurde nicht bearbeitet.