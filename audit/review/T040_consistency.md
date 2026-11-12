## Rolle: consistency (codex, medium) – VERDICT: REWORK


## Befunde

1. **Die README nennt die abgeschlossene PDF-Stichprobe weiterhin ausstehend.** `replication/README.md:1067` sagt: „The required independent reviewer check of 25 published values remains pending.“ Dagegen dokumentieren die Co-PI-Rückmeldung in `tasks/T040.md` und `replication/outputs/tables/t040_verification.txt:12` den Abschluss mit 25/25 bestätigten Werten. Dadurch widerspricht die aktuelle Paketdokumentation dem dokumentierten Prüfstatus. Die README sollte den abgeschlossenen Co-PI-Check und dessen Beleg nennen. Keine Neuschätzung erforderlich.

Die beiden früheren Konsistenzbefunde sind behoben:

- Die Coverage-Note unterscheidet kodierte Werte und verfügbare Vergleichspaare korrekt: RL2 96/85, RL3 64/59 (`13_rl1_validation.R:182`, entsprechend in `t040_validation.tex`).
- Die Build-Übersicht führt `13_rl1_validation.R` zuletzt auf (`README.md:113`), übereinstimmend mit `run_all.R:18–21` und `run_all.sh:6`.

Die geprüften Zahlen in beiden TeX-Tabellen stimmen mit den CSV-Fassungen einschließlich Rundungen, Vorzeichen, Fallzahlen und Intervallen überein.

## Abnahmekriterien

1. **Datei und Seite je Kodierung; 25 PDF-Stichproben:** nicht meine Rolle. Der abgeschlossene Co-PI-Check wird gemäß Kartenrückmeldung nicht wiederholt. Der widersprüchliche Dokumentationsstatus ist Befund 1.

2. **T023 und T029 vor Varianten reproduzieren:** belegt erfüllt hinsichtlich Konsistenz. Assertions stehen in `13_rl1_validation.R:58–63`. Die Baseline in `t040_robustness.csv:2,6` stimmt mit `t023_excess_mass.csv:17` und `t029_compliance.csv:89` überein: b = 3,1428547576148 und D = 0,114617940199336; auch Fallzahlen und Intervalle stimmen.

3. **Klares Validierungsurteil und Veränderungen der Hauptergebnisse:** belegt erfüllt. `t040_verification.txt:10,14–28` entspricht den CSV-Outputs: nahe der Schwelle MAE 0,570 Prozentpunkte, 76,9 % innerhalb eines Prozentpunkts und sechs Klassifikationsabweichungen. Perpetual-Anpassung verändert b/D von 3,1429/0,1146 auf 2,5821/0,0930; die Matching-Stichprobe ergibt 8,8093/0,2700 bei 100 Beobachtungen und 20 Firmen. Selektive Abdeckung und mechanische Interpretation sind ausdrücklich benannt.

## Nicht geprüft

- Original-PDFs, Transkriptionsrichtigkeit, Datenbereinigung und rechnerische Schätzrichtigkeit: Zuständigkeit der Data- beziehungsweise Estimation-Rolle.
- Die erzeugte Scatter-PDF einschließlich tatsächlicher Beschriftungspositionen und visuellen Layouts.
- Vollständiger Zahlen-, Literatur- und Querverweisabgleich des Proposals. Die Aktualisierung des dortigen Pilotstands ist laut Kartenrückmeldung T039 zugeordnet.
- Erneute Ausführung, Gesamtbuild und unabhängige Hashprüfung: entsprechend der Reviewer-Vorgabe keine Befehle ausgeführt und keine Dateien verändert.
- Verursachung der gemeldeten Änderungen außerhalb des Schreibbereichs: Die mitgeteilten Änderungszeiten belegen keine Zuordnung zu T040.