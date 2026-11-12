## Ergebnis

T031 wurde umgesetzt: zwölf reproduzierbare Analyseausgaben, Pipeline-Anbindung und Prüfnachweise wurden erzeugt. Q1 übersteht Firmenauslassungen und Stichprobenrestriktionen; Sensitivitätsgitter, flexible Distanztests und 2020H2 allein begrenzen die Robustheit.

## Dateien

- `replication/code/12_q1_robustness.R` – sämtliche T031-Berechnungen und Schutzprüfungen.
- `replication/run_all.R`, `replication/run_all.sh` – Schritt 12 zuletzt registriert.
- `replication/README.md` – Pipeline, Ausgaben und Änderungsprotokoll.
- `replication/outputs/tables/t031_baseline.csv` – T023-Reproduktion.
- `replication/outputs/tables/t031_support.csv` – Firmenstützung und Eintritte.
- `replication/outputs/tables/t031_leave_one_out.csv` – alle Firmenauslassungen und Einflussrang.
- `replication/outputs/tables/t031_samples.csv`, `replication/outputs/tables/t031_samples.tex` – drei Stichproben, beide Perioden.
- `replication/outputs/tables/t031_grid.csv` – vollständiges Sensitivitätsgitter.
- `replication/outputs/tables/t031_reversal_distance.csv`, `replication/outputs/tables/t031_reversal_distance.tex` – Distanzmodelle und Kontraste.
- `replication/outputs/tables/t031_timing.csv`, `replication/outputs/tables/t031_timing.tex` – sämtliche Timingvarianten.
- `replication/outputs/figures/t031_grid.pdf` – alle 72 Spezifikationen nach Index.
- `replication/outputs/figures/t031_reversal_distance.pdf` – prognostizierte Umkehrwahrscheinlichkeiten.
- `replication/outputs/tables/t031_build_attempt.log` – erklärter fehlgeschlagener erster Buildversuch.
- `replication/outputs/tables/t031_build_run1.log`, `replication/outputs/tables/t031_build_run2.log` – erfolgreiche Gesamtbuilds.
- `replication/outputs/tables/t031_hashes.csv` – SHA-256-Vergleiche.
- `replication/outputs/tables/t031_verification.txt` – Abnahmeprüfungen, Validierung und Einschränkungen.

## Ausführung

Zweimal erfolgreich ausgeführt:

[fenced excerpt withheld in public audit]
[fenced excerpt withheld in public audit]

Letzte Ausgabe des zweiten Laufs:

[fenced excerpt withheld in public audit]
[fenced excerpt withheld in public audit]

## Abnahmekriterien

1. **Erfüllt:** T023 einschließlich Bootstrap-KI reproduziert: \(b_\text{post}=3{,}142855\), 95%-KI [1,012201; 5,841138]. Während beider Gesamtbuilds blieben 209 geschützte Dateien bytegleich; sämtliche zwölf T031-Analyseausgaben sind zwischen den Läufen byteidentisch. Belege: `t031_baseline.csv`, `t031_hashes.csv`.

2. **Erfüllt:** Alle 72 Gitterzellen, drei Stichproben und 115 Firmenauslassungen berichtet. Ausschließlich die registrierte Baseline ist hervorgehoben. Alle 999 Bootstrap-Ziehungen sind in diesen Fits gültig. Distanzregressionen stimmen mit unabhängigen `fixest`-Schätzungen bis auf höchstens \(2{,}17\times10^{-15}\) überein; Tabellen und PDFs wurden geprüft.

3. **Erfüllt:** Die Befunde je Check sind:

| Check | Befund für Q1 |
|---|---|
| Firmenstützung | Post: 118 Firmenstichtage von 43 Firmen, maximal fünf je Firma; 24 Firmen waren zuvor nicht im Fenster. Deskriptive Stützung, kein KI-Test. |
| Leave-one-out | Übersteht alle 115 Auslassungen: sämtliche Post-KIs oberhalb null; b zwischen 2,840 und 3,310. |
| Stichprobenzusammensetzung | Übersteht beide Restriktionen: balanciert b = 3,244 [1,017; 6,190]; mindestens drei Beobachtungen je Periode b = 3,096 [0,926; 5,561]. |
| Sensitivitätsgitter | 63/72 KIs schließen null aus: 87,5 %. Neun schließen null ein; universelle Spezifikationsrobustheit ist damit nicht gegeben. |
| Exakte Distanz | Binned-Modell: negative Differenz mit KI unter null bei 0,005 und 0,015; bei 0,025 enthält das KI null. Linear sind alle drei negativ signifikant: funktionale Form bleibt relevant. |
| Timing | Ohne 2020H2 bleibt Bunching: b = 3,541 [1,105; 6,760]. Für 2020H2 allein: 1,743 [−0,672; 4,993], also nicht gesichert. Ohne 2020H2 enthalten außerdem die flexiblen nahen Umkehrkontraste null. |

[firm-specific excerpt withheld in public audit]

## Offene Fragen

- Bei 0,02-Bins schneiden einige nominelle Fenster einzelne Bins. Verwendet wurde die T023-Mittelpunktregel; nominelle und tatsächlich erfasste Grenzen sind vollständig ausgewiesen.
- Die Vergleiche bleiben deskriptiv: Glattheit und Polynomform werden angenommen; Berichtsselektion, Mean Reversion und Kalenderzusammensetzung bleiben mögliche Erklärungen.
- Nach beiden Builds wurde `state/STATE.md` extern ergänzt. Neue T032-Hinweise betreffen Abweichungen zur veröffentlichten RL1 und die Perpetual-Behandlung. Diese Quellen wurden hier nicht unabhängig geprüft; Panel und Analyseausgaben blieben unverändert.
- `status:` bleibt `APPROVED`. Unabhängiges Review und PI-Abnahme stehen aus.
- Vorschlag für das KI-Protokoll durch den Co-PI: „2026-10-26, Codex, T031 Q1-Robustheitscode und Ausgaben; geprüft durch zwei Gesamtbuilds, SHA-256, unabhängige fixest-Berechnungen und PDF/TeX-Sichtprüfung.“ `AI_USAGE_LOG.md` liegt außerhalb des Schreibbereichs.