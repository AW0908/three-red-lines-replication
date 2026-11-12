## Rolle: estimation (codex, high) – VERDICT: PASS


## Befunde

1. **Keine schätzungsbezogenen Mängel gefunden. Rework 4 ist korrekt umgesetzt.** In `replication/outputs/tables/t043_integration.tex:7–14` stehen bei den T023-Baselines „--“ für B_net und [0.70,0.74). Die Note in Zeile 21 erklärt die fehlende Vergleichbarkeit und das richtige Vorzeichen des sekundären Massenresiduums. Beispielsweise entspricht dessen Post-Residuum −16.3005 dem negativen Wert der Spalte [0.70,0.74), +16.3005.

2. **Spezifikation und Inferenz entsprechen der zuletzt freigegebenen Karte.** Der gemeinsame Firmenbootstrap verwendet dieselben Gewichte für beide Perioden; Δb wird innerhalb jeder Ziehung gebildet (`replication/code/15_referee2.R:28–32,119–139`). Die Hauptintegration verwendet B_net über [0.66,0.74), vollständige Neuschätzung und die vorgeschriebene Normierung (`152–209,276–305,323–340`). Die Outputs zeigen Konvergenz nach 17 beziehungsweise 19 Iterationen und Gesamtmassenresiduen von 5.68e−7 beziehungsweise 5.41e−7 (`t043_integration.csv:3,8`). Das bedingte Intervall der Literal-s-Variante ist einschließlich 982/999 gültiger Ziehungen gekennzeichnet (`t043_integration.tex:15,21`).

3. **Die ausgewiesenen Stichproben und Variablenrichtungen sind nachvollziehbar.** Das Panel enthält vor der Politik 798 Hauptstichprobenzeilen, davon 797 mit endlichem RL1 aus 136 Firmen; danach 630 aus 132 Firmen. Davon liegen 713 beziehungsweise 557 Beobachtungen im Histogrammbereich. Dies stimmt mit `t043_delta_b.csv:2` und der Iterationsdiagnostik überein. D wird als offizielle minus kontrafaktische Compliance berechnet; fehlende Werte und nichtpositive Nenner werden ausgeschlossen (`15_referee2.R:74–82,654–674`). Bei unverändertem MI stimmen beide Quotienten überein; höheres kontrafaktisches MI senkt den kontrafaktischen Quotienten.

4. **Die Grenzen der Zusatzanalysen werden korrekt ausgewiesen.** Die Messfehlervarianten werden als Perturbationssimulationen mit Simulationsperzentilen behandelt, einschließlich Zentrierung und dokumentierter Transportannahme (`15_referee2.R:368–438`). Trendraten verwenden ausschließlich Daten bis zum Anker; Binmediane werden im Firmenbootstrap neu geschätzt (`624–702`). Die nicht schätzbaren Trend-Placebos und Differenzen bleiben fehlend (`t043_trend_cf.csv:6–21`). Punktweise, unbereinigte Intervalle werden im Bericht ausdrücklich benannt (`tasks/T043_report.md:51,66`).

## Abnahmekriterien

1. **Belegt erfüllt anhand der abgelegten Reproduktionsnachweise.** Assertions für b_post, b_pre, D und sämtliche 30 T023-Periodenschätzungen stehen in `15_referee2.R:83–88,123–126`; die erfolgreichen Prüfungen sind in `t043_run1.log:1–2,13–14` dokumentiert. Die aktuellen SHA-256-Werte aller 22 gelisteten Outputs stimmen mit beiden Laufspalten in `t043_reproducibility.csv:2–23` überein. Beide Logs sind ebenfalls byteidentisch. Die Unverändertheit geschützter Bestandsoutputs ist durch Guard-Code und Guard-Datei dokumentiert; historische Ausgangsstände wurden nicht unabhängig rekonstruiert.

2. **Belegt erfüllt im Prüfbereich Schätzung.** Alle 15 Δb-Zellen, elf Integrationszeilen, zwölf Simulationszeilen, zwölf Heterogenitätszellen und 20 Trendzeilen sind vorhanden. Beobachtungs- und Firmenzahlen werden ausgewiesen. Nichtkonvergenz und fehlende Placeboschätzungen werden erhalten. Cash-Quellenprüfung: **nicht meine Rolle**.

3. **Belegt erfüllt im Prüfbereich Schätzung.** Konvergenz, Iterationsverläufe und gültige Bootstrapziehungen sind dokumentiert. Die Fehlerverteilungen weisen N/Firmenzahl, Mittelwert und Standardabweichung aus: 64/30 beziehungsweise 52/26 (`t043_meas_error.csv:2,8`). Seitenreferenzen der Cash-Werte: **nicht meine Rolle**.

4. **Belegt erfüllt hinsichtlich des Schätzprogramms.** Der eigenständige Ausführungsweg liest lokale Dateien und enthält keinen Datenabruf; das eingebundene Setup definiert hierbei lediglich Funktionen. Integrität und Originaltreue handgesammelter Werte: **nicht meine Rolle**.

## Nicht geprüft

- Keine R-Skripte oder Shellbefehle ausgeführt und keine Dateien verändert. Keine unabhängige Neuschätzung; Laufnachweise wurden gelesen und aktuelle Dateiinhalte mit den gespeicherten Hashes verglichen.
- Historische Dateistände vor Rework 4 und die projektweite Herkunft sämtlicher Änderungen außerhalb des Schreibbereichs nicht unabhängig rekonstruiert.
- Datenbereinigung, Originalberichte, Währungsvalidierung, Cash-Transkription, Sprache und visuelles PDF-Layout nicht geprüft.
- Für `AI_USAGE_LOG.md` vorgeschlagen: „2026-10-29, Codex: unabhängiges Estimation-Review T043; Code, Stichproben, Inferenz und Outputs lesend geprüft; keine Änderungen oder Neuschätzung.“