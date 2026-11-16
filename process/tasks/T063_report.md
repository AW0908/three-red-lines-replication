## Ergebnis

T063 ist umgesetzt: Simulationen, breites Ausschlussfenster, Branchenkontrollen, Ein-Beobachtung-Prüfung, Halbjahresverteilungen und Zahlenabgleiche liegen vor. Zwei abschließende Läufe erzeugen [number withheld] byte-identische Ausgabedateien; sämtliche bisherigen Ausgaben und Rohdateien sind unverändert. Der Kartenstatus wurde nicht geändert.

## Dateien

- `replication/code/22_referee5.R` – vollständiger Offline-Lauf einschließlich Prüfungen.
- `replication/run_all.R` – Schritt [number withheld] zuletzt ergänzt.
- `replication/run_all.sh` – Schritt [number withheld] zuletzt ergänzt.
- `replication/README.md` – Verfahren, Annahmen und Ausgaben dokumentiert.
- `replication/outputs/tables/t063_reproduction.csv` – Eingangstests.
- `replication/outputs/tables/t063_noise_calibration.csv` – Fehlerverteilung und Normalparameter.
- `replication/outputs/tables/t063_noise_errors.csv` – vorhandene RL1-Validierungspaare.
- `replication/outputs/tables/t063_noise.csv` – sämtliche Simulationsvarianten mit Fensterbesetzungen.
- `replication/outputs/tables/t063_noise.tex` – Simulationstabelle.
- `replication/outputs/tables/t063_noise_draws.csv` – [number withheld] Simulationsreplikationen.
- `replication/outputs/tables/t063_noise_histograms.csv` – mittlere simulierte Histogramme.
- `replication/outputs/tables/t063_noise_representatives.csv` – Auswahl der vier dargestellten Kombinationen.
- `replication/outputs/figures/t063_noise_shapes.pdf` – beobachtete und simulierte Verteilungen.
- `replication/outputs/tables/t063_window.csv` – breites Ausschlussfenster einschließlich Fallzahlen.
- `replication/outputs/tables/t063_window.tex` – entsprechende Ergebnistabelle.
- `replication/outputs/tables/t063_control_membership.csv` – Firmen und Branchenzuordnung.
- `replication/outputs/tables/t063_control_sens.csv` – beide Branchenkontrollen.
- `replication/outputs/tables/t063_control_sens.tex` – entsprechende Ergebnistabelle.
- `replication/outputs/tables/t063_bootstrap_draws.csv` – [number withheld] Bootstrap-Statistiken.
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
- `replication/outputs/tables/t063_verification.csv` – [number withheld] SHA-[number withheld]-Nachweise.
- `replication/outputs/tables/t063_validation.txt` – Prüfungen und Verfahrensgrenzen.
- `tasks/T063_report.md` – ausführlicher Arbeitsbericht.

## Ausführung

Exakter Befehl, abschließend zweimal erfolgreich ausgeführt:

[fenced excerpt withheld in public process copy]
[fenced excerpt withheld in public process copy]

Letzte Ausgabe des Wiederholungslaufs, Exit-Code [number withheld]:

[fenced excerpt withheld in public process copy]
[fenced excerpt withheld in public process copy]

Zusätzlich geprüft: [number withheld] Kontrastziehungen gegen ihre Komponenten, maximale Abweichung [number withheld]e−[number withheld]; alle [number withheld] Prüfsummen; Syntax beider Build-Einstiege. Beide Diagramm-PDFs wurden visuell geprüft; alle vier TeX-Tabellen kompilieren ohne überstehende Boxen.

## Abnahmekriterien

[number withheld]. **Erfüllt:** Reproduktion von Δb = [number withheld] sowie ΔΔb = [number withheld] und [number withheld] in `t063_reproduction.csv`. Alle [number withheld] bisherigen Ausgaben unverändert; Wiederholung [number withheld]/[number withheld] byte-identisch.
[number withheld]. **Erfüllt:** [number withheld] Simulationszellen mit jeweils [number withheld] gültigen Replikationen, [number withheld] Fensterzeilen, [number withheld] Branchenzeilen, drei Ein-Beobachtung-Ergebnisse und [number withheld] Datum-Gruppen-Zellen. Beobachtungszahlen, Firmenzahlen und tatsächliche Fensterbesetzungen stehen in den jeweiligen CSVs und Support-Dateien.
[number withheld]. **Erfüllt unter der spezifischen Eingabevorgabe von Schritt [number withheld]:** keine zusätzlichen handerhobenen Daten verwendet und keine Rohdaten verändert. Die ausdrücklich vorgeschriebenen vorhandenen T040-Validierungsfehler wurden verwendet; die Auslegung des allgemeinen Wortlauts ist unten dokumentiert.

Schritt [number withheld]: Die Kalibrierung umfasst [number withheld] RL1-Paare von [number withheld] Firmen, Fehlermittelwert [number withheld] und SD [number withheld]. Zwei empirische Kombinationen enthalten beide beobachteten Kennzahlen in ihren jeweiligen marginalen [number withheld]%-Simulationsbereichen: β=[number withheld], Δ=[number withheld], π=[number withheld] beziehungsweise [number withheld] (`t063_noise.csv`, `parameter_id=[number withheld]/[number withheld]`). Der beste empirische Mittelwertabgleich liefert b=[number withheld] und oberhalb b=[number withheld] gegenüber beobachteten [number withheld] und [number withheld]. Das bestätigt keinen gemeinsamen Mittelwertabgleich; die qualitative Vereinbarkeit bleibt von der Kalibrierungsannahme abhängig.

Schritt [number withheld]: Mit breitem Fit-Ausschluss und Masse unter [number withheld] beträgt ΔΔb für alle/balancierte/A-Anteil-Entwickler [number withheld] [[number withheld];[number withheld]], [number withheld] [[number withheld];[number withheld]] und [number withheld] [[number withheld];[number withheld]] (`t063_window.csv`, `control=control_all; mass_upper=[number withheld]`). Das A-Anteil-Intervall umfasst null. Die gesamte ausgeschlossene Masse wird separat normalisiert und berichtet.

Schritt [number withheld]: Ohne Zulieferbranchen verbleiben [number withheld] Kontrollfirmen; ausschließlich diese Branchen umfassen [number withheld]. Der volle Entwicklerkontrast ohne Zulieferer beträgt im Hauptfenster [number withheld] [[number withheld];[number withheld]], im breiten Fitfenster [number withheld] [[number withheld];[number withheld]] (`t063_control_sens.csv`, `group=developers_all; control=control_without_suppliers`). Weitere sektorale Schocks bleiben möglich.

Schritt [number withheld]: Im unteren Schwellenfenster stehen bei Entwicklern [number withheld] unterschiedliche Firmen vor und [number withheld] nach der Politik, bei Kontrollen [number withheld] und [number withheld] (`t063_distinct_firms.csv`). Mit einer Beobachtung je Firma und Periode hat ΔΔb den Median [number withheld] und Auswahlperzentile [[number withheld];[number withheld]] (`t063_one_obs.csv`). Diese Perzentile sind keine Stichproben-Konfidenzintervalle.

Schritt [number withheld]: Alle [number withheld] Halbjahre sind für beide Populationen dargestellt. Die Histogramme verwenden [number withheld]-Bins und sämtliche endlichen RL1-Werte des Datums als Nenner (`t063_by_date.csv`). Zeitliche Verteilungsänderungen allein identifizieren keinen Politikeffekt.

[firm-specific excerpt withheld in public process copy]

Schritt [number withheld]: Interpretationen und Zahlenbelege stehen in `t063_interpretation.csv` und `t063_number_map.csv`. Glatte kontrafaktische Dichten, vergleichbare kontrafaktische Änderungen und die Übertragbarkeit der Validierungsfehler bleiben explizite Annahmen.

## Offene Fragen

- Das nicht festgelegte π-Raster wurde als [number withheld] bis [number withheld] in [number withheld]-Schritten umgesetzt. Die berichtete Abdeckungsregel verwendet marginale Simulationsbereiche und ist kein gemeinsamer Test.
- Der Zielindikator wird einmal je Firma gezogen; Fehler erhalten ausschließlich bewegte Beobachtungen. β=[number withheld] bezeichnet den linksseitigen Grenzwert [number withheld][number withheld]e−[number withheld].
- „No hand-collected data used“ wurde angesichts des vorgeschriebenen T040-Inputs als Verbot zusätzlicher handerhobener Daten ausgelegt. Ein Verbot auch dieser vorhandenen Validierungsdaten wäre mit Schritt [number withheld] unvereinbar.
- Für den CNKI-Abgleich wurden Suchprotokoll und vorhandene `state/litsearch/screening.xlsx` ergänzend ausschließlich gelesen. Die [number withheld] eindeutigen Artikel bestätigen keinen Peer-Review- oder Kernzeitschriftenstatus.
- Der vollständige historische Build wurde nicht ausgeführt; geprüft wurden der vorgeschriebene Einzellauf, seine Wiederholung und beide Build-Einstiege syntaktisch.
- Vorschlag für `AI_USAGE_LOG.md` nach Abnahme: „2026-11-01, Codex, T063: vorgegebene Simulationen und Robustheitsprüfungen; Reproduktions-, Komponenten-, Prüfsummen-, Wiederholungs- und Layoutkontrollen durchgeführt; Kalibrierungsannahmen dokumentiert.“ Die Logdatei liegt außerhalb des Schreibbereichs und wurde nicht verändert.