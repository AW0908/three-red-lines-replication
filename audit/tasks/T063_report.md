## Ergebnis

T063 ist umgesetzt: Simulationen, breites Ausschlussfenster, Branchenkontrollen, Ein-Beobachtung-Prüfung, Halbjahresverteilungen und Zahlenabgleiche liegen vor. Zwei abschließende Läufe erzeugen 29 byte-identische Ausgabedateien; sämtliche bisherigen Ausgaben und Rohdateien sind unverändert. Der Kartenstatus wurde nicht geändert.

## Dateien

- `replication/code/22_referee5.R` – vollständiger Offline-Lauf einschließlich Prüfungen.
- `replication/run_all.R` – Schritt 22 zuletzt ergänzt.
- `replication/run_all.sh` – Schritt 22 zuletzt ergänzt.
- `replication/README.md` – Verfahren, Annahmen und Ausgaben dokumentiert.
- `replication/outputs/tables/t063_reproduction.csv` – Eingangstests.
- `replication/outputs/tables/t063_noise_calibration.csv` – Fehlerverteilung und Normalparameter.
- `replication/outputs/tables/t063_noise_errors.csv` – vorhandene RL1-Validierungspaare.
- `replication/outputs/tables/t063_noise.csv` – sämtliche Simulationsvarianten mit Fensterbesetzungen.
- `replication/outputs/tables/t063_noise.tex` – Simulationstabelle.
- `replication/outputs/tables/t063_noise_draws.csv` – 198.000 Simulationsreplikationen.
- `replication/outputs/tables/t063_noise_histograms.csv` – mittlere simulierte Histogramme.
- `replication/outputs/tables/t063_noise_representatives.csv` – Auswahl der vier dargestellten Kombinationen.
- `replication/outputs/figures/t063_noise_shapes.pdf` – beobachtete und simulierte Verteilungen.
- `replication/outputs/tables/t063_window.csv` – breites Ausschlussfenster einschließlich Fallzahlen.
- `replication/outputs/tables/t063_window.tex` – entsprechende Ergebnistabelle.
- `replication/outputs/tables/t063_control_membership.csv` – Firmen und Branchenzuordnung.
- `replication/outputs/tables/t063_control_sens.csv` – beide Branchenkontrollen.
- `replication/outputs/tables/t063_control_sens.tex` – entsprechende Ergebnistabelle.
- `replication/outputs/tables/t063_bootstrap_draws.csv` – 59.940 Bootstrap-Statistiken.
- `replication/outputs/tables/t063_density_bins.csv` – beobachtete und angepasste Bin-Zahlen.
- `replication/outputs/tables/t063_distinct_firms.csv` – unterschiedliche Firmen im Schwellenfenster.
- `replication/outputs/tables/t063_one_obs.csv` – Ein-Beobachtung-Ergebnisse.
- `replication/outputs/tables/t063_one_obs.tex` – entsprechende Ergebnistabelle.
- `replication/outputs/tables/t063_one_obs_draws.csv` – Veränderungs- und Kontrastziehungen.
- `replication/outputs/tables/t063_one_obs_support.csv` – Fallzahlen jeder Beobachtungsauswahl.
- `replication/outputs/tables/t063_by_date.csv` – Schwellenfensteranteile nach Halbjahr.
- `replication/outputs/tables/t063_by_date_histograms.csv` – Halbjahreshistogramme.
- `replication/outputs/figures/t063_by_date.pdf` – Halbjahresverteilungen beider Populationen.
- `replication/outputs/tables/t063_reconcile.csv` – Zahlenabgleiche und Definitionen.
- `replication/outputs/tables/t063_interpretation.csv` – sieben englische Interpretationsabsätze.
- `replication/outputs/tables/t063_number_map.csv` – Zahl-Datei-Filter-Zuordnung.
- `replication/outputs/tables/t063_verification.csv` – 525 SHA-256-Nachweise.
- `replication/outputs/tables/t063_validation.txt` – Prüfungen und Verfahrensgrenzen.
- `tasks/T063_report.md` – ausführlicher Arbeitsbericht.

## Ausführung

Exakter Befehl, abschließend zweimal erfolgreich ausgeführt:

[fenced excerpt withheld in public audit]
[fenced excerpt withheld in public audit]

Letzte Ausgabe des Wiederholungslaufs, Exit-Code 0:

[fenced excerpt withheld in public audit]
[fenced excerpt withheld in public audit]

Zusätzlich geprüft: 17.982 Kontrastziehungen gegen ihre Komponenten, maximale Abweichung 8,35e−14; alle 525 Prüfsummen; Syntax beider Build-Einstiege. Beide Diagramm-PDFs wurden visuell geprüft; alle vier TeX-Tabellen kompilieren ohne überstehende Boxen.

## Abnahmekriterien

1. **Erfüllt:** Reproduktion von Δb = 4,020042 sowie ΔΔb = 4,593714 und 4,479751 in `t063_reproduction.csv`. Alle 392 bisherigen Ausgaben unverändert; Wiederholung 29/29 byte-identisch.
2. **Erfüllt:** 198 Simulationszellen mit jeweils 1.000 gültigen Replikationen, 16 Fensterzeilen, 16 Branchenzeilen, drei Ein-Beobachtung-Ergebnisse und 26 Datum-Gruppen-Zellen. Beobachtungszahlen, Firmenzahlen und tatsächliche Fensterbesetzungen stehen in den jeweiligen CSVs und Support-Dateien.
3. **Erfüllt unter der spezifischen Eingabevorgabe von Schritt 1:** keine zusätzlichen handerhobenen Daten verwendet und keine Rohdaten verändert. Die ausdrücklich vorgeschriebenen vorhandenen T040-Validierungsfehler wurden verwendet; die Auslegung des allgemeinen Wortlauts ist unten dokumentiert.

Schritt 1: Die Kalibrierung umfasst 64 RL1-Paare von 30 Firmen, Fehlermittelwert 0,009938 und SD 0,026425. Zwei empirische Kombinationen enthalten beide beobachteten Kennzahlen in ihren jeweiligen marginalen 95%-Simulationsbereichen: β=0,01, Δ=0,10, π=0,3 beziehungsweise 0,4 (`t063_noise.csv`, `parameter_id=48/49`). Der beste empirische Mittelwertabgleich liefert b=2,627 und oberhalb b=0,857 gegenüber beobachteten 3,143 und 1,750. Das bestätigt keinen gemeinsamen Mittelwertabgleich; die qualitative Vereinbarkeit bleibt von der Kalibrierungsannahme abhängig.

Schritt 2: Mit breitem Fit-Ausschluss und Masse unter 0,70 beträgt ΔΔb für alle/balancierte/A-Anteil-Entwickler 5,379 [2,475;8,924], 5,134 [1,997;8,857] und 3,273 [−0,362;7,724] (`t063_window.csv`, `control=control_all; mass_upper=0.7`). Das A-Anteil-Intervall umfasst null. Die gesamte ausgeschlossene Masse wird separat normalisiert und berichtet.

Schritt 3: Ohne Zulieferbranchen verbleiben 596 Kontrollfirmen; ausschließlich diese Branchen umfassen 156. Der volle Entwicklerkontrast ohne Zulieferer beträgt im Hauptfenster 4,589 [2,135;7,549], im breiten Fitfenster 5,520 [2,512;9,260] (`t063_control_sens.csv`, `group=developers_all; control=control_without_suppliers`). Weitere sektorale Schocks bleiben möglich.

Schritt 4: Im unteren Schwellenfenster stehen bei Entwicklern 35 unterschiedliche Firmen vor und 43 nach der Politik, bei Kontrollen 96 und 91 (`t063_distinct_firms.csv`). Mit einer Beobachtung je Firma und Periode hat ΔΔb den Median 4,654 und Auswahlperzentile [1,328;8,089] (`t063_one_obs.csv`). Diese Perzentile sind keine Stichproben-Konfidenzintervalle.

Schritt 5: Alle 13 Halbjahre sind für beide Populationen dargestellt. Die Histogramme verwenden 0,02-Bins und sämtliche endlichen RL1-Werte des Datums als Nenner (`t063_by_date.csv`). Zeitliche Verteilungsänderungen allein identifizieren keinen Politikeffekt.

[firm-specific excerpt withheld in public audit]

Schritt 7: Interpretationen und Zahlenbelege stehen in `t063_interpretation.csv` und `t063_number_map.csv`. Glatte kontrafaktische Dichten, vergleichbare kontrafaktische Änderungen und die Übertragbarkeit der Validierungsfehler bleiben explizite Annahmen.

## Offene Fragen

- Das nicht festgelegte π-Raster wurde als 0 bis 1 in 0,1-Schritten umgesetzt. Die berichtete Abdeckungsregel verwendet marginale Simulationsbereiche und ist kein gemeinsamer Test.
- Der Zielindikator wird einmal je Firma gezogen; Fehler erhalten ausschließlich bewegte Beobachtungen. β=0 bezeichnet den linksseitigen Grenzwert 0,70−1e−10.
- „No hand-collected data used“ wurde angesichts des vorgeschriebenen T040-Inputs als Verbot zusätzlicher handerhobener Daten ausgelegt. Ein Verbot auch dieser vorhandenen Validierungsdaten wäre mit Schritt 1 unvereinbar.
- Für den CNKI-Abgleich wurden Suchprotokoll und vorhandene `state/litsearch/screening.xlsx` ergänzend ausschließlich gelesen. Die 51 eindeutigen Artikel bestätigen keinen Peer-Review- oder Kernzeitschriftenstatus.
- Der vollständige historische Build wurde nicht ausgeführt; geprüft wurden der vorgeschriebene Einzellauf, seine Wiederholung und beide Build-Einstiege syntaktisch.
- Vorschlag für `AI_USAGE_LOG.md` nach Abnahme: „2026-11-01, Codex, T063: vorgegebene Simulationen und Robustheitsprüfungen; Reproduktions-, Komponenten-, Prüfsummen-, Wiederholungs- und Layoutkontrollen durchgeführt; Kalibrierungsannahmen dokumentiert.“ Die Logdatei liegt außerhalb des Schreibbereichs und wurde nicht verändert.