## Rolle: consistency (codex, medium) – VERDICT: REWORK


## Befunde

[number withheld]. **Die README nennt die abgeschlossene PDF-Stichprobe weiterhin ausstehend.** `replication/README.md:1067` sagt: „The required independent reviewer check of [number withheld] published values remains pending.“ Dagegen dokumentieren die Co-PI-Rückmeldung in `tasks/T040.md` und `replication/outputs/tables/t040_verification.txt:12` den Abschluss mit [number withheld]/[number withheld] bestätigten Werten. Dadurch widerspricht die aktuelle Paketdokumentation dem dokumentierten Prüfstatus. Die README sollte den abgeschlossenen Co-PI-Check und dessen Beleg nennen. Keine Neuschätzung erforderlich.

Die beiden früheren Konsistenzbefunde sind behoben:

- Die Coverage-Note unterscheidet kodierte Werte und verfügbare Vergleichspaare korrekt: RL2 [number withheld]/[number withheld], RL3 [number withheld]/[number withheld] (`13_rl1_validation.R:182`, entsprechend in `t040_validation.tex`).
- Die Build-Übersicht führt `13_rl1_validation.R` zuletzt auf (`README.md:113`), übereinstimmend mit `run_all.R:18–21` und `run_all.sh:6`.

Die geprüften Zahlen in beiden TeX-Tabellen stimmen mit den CSV-Fassungen einschließlich Rundungen, Vorzeichen, Fallzahlen und Intervallen überein.

## Abnahmekriterien

[number withheld]. **Datei und Seite je Kodierung; [number withheld] PDF-Stichproben:** nicht meine Rolle. Der abgeschlossene Co-PI-Check wird gemäß Kartenrückmeldung nicht wiederholt. Der widersprüchliche Dokumentationsstatus ist Befund [number withheld].

[number withheld]. **T023 und T029 vor Varianten reproduzieren:** belegt erfüllt hinsichtlich Konsistenz. Assertions stehen in `13_rl1_validation.R:58–63`. Die Baseline in `t0[number withheld]_robustness.csv:[number withheld]` stimmt mit `t023_excess_mass.csv:17` und `t029_compliance.csv:89` überein: b = [number withheld] und D = [number withheld]; auch Fallzahlen und Intervalle stimmen.

[number withheld]. **Klares Validierungsurteil und Veränderungen der Hauptergebnisse:** belegt erfüllt. `t0[number withheld]_verification.txt:[number withheld]–[number withheld]` entspricht den CSV-Outputs: nahe der Schwelle MAE [number withheld] Prozentpunkte, [number withheld] % innerhalb eines Prozentpunkts und sechs Klassifikationsabweichungen. Perpetual-Anpassung verändert b/D von [number withheld]/[number withheld] auf [number withheld]/[number withheld]; die Matching-Stichprobe ergibt [number withheld]/[number withheld] bei [number withheld] Beobachtungen und [number withheld] Firmen. Selektive Abdeckung und mechanische Interpretation sind ausdrücklich benannt.

## Nicht geprüft

- Original-PDFs, Transkriptionsrichtigkeit, Datenbereinigung und rechnerische Schätzrichtigkeit: Zuständigkeit der Data- beziehungsweise Estimation-Rolle.
- Die erzeugte Scatter-PDF einschließlich tatsächlicher Beschriftungspositionen und visuellen Layouts.
- Vollständiger Zahlen-, Literatur- und Querverweisabgleich des Proposals. Die Aktualisierung des dortigen Pilotstands ist laut Kartenrückmeldung T039 zugeordnet.
- Erneute Ausführung, Gesamtbuild und unabhängige Hashprüfung: entsprechend der Reviewer-Vorgabe keine Befehle ausgeführt und keine Dateien verändert.
- Verursachung der gemeldeten Änderungen außerhalb des Schreibbereichs: Die mitgeteilten Änderungszeiten belegen keine Zuordnung zu T040.