## Ergebnis

T031 wurde umgesetzt: zwölf reproduzierbare Analyseausgaben, Pipeline-Anbindung und Prüfnachweise wurden erzeugt. Q1 übersteht Firmenauslassungen und Stichprobenrestriktionen; Sensitivitätsgitter, flexible Distanztests und [number withheld]H2 allein begrenzen die Robustheit.

## Dateien

- `replication/code/12_q1_robustness.R` – sämtliche T031-Berechnungen und Schutzprüfungen.
- `replication/run_all.R`, `replication/run_all.sh` – Schritt [number withheld] zuletzt registriert.
- `replication/README.md` – Pipeline, Ausgaben und Änderungsprotokoll.
- `replication/outputs/tables/t031_baseline.csv` – T023-Reproduktion.
- `replication/outputs/tables/t031_support.csv` – Firmenstützung und Eintritte.
- `replication/outputs/tables/t031_leave_one_out.csv` – alle Firmenauslassungen und Einflussrang.
- `replication/outputs/tables/t031_samples.csv`, `replication/outputs/tables/t031_samples.tex` – drei Stichproben, beide Perioden.
- `replication/outputs/tables/t031_grid.csv` – vollständiges Sensitivitätsgitter.
- `replication/outputs/tables/t031_reversal_distance.csv`, `replication/outputs/tables/t031_reversal_distance.tex` – Distanzmodelle und Kontraste.
- `replication/outputs/tables/t031_timing.csv`, `replication/outputs/tables/t031_timing.tex` – sämtliche Timingvarianten.
- `replication/outputs/figures/t031_grid.pdf` – alle [number withheld] Spezifikationen nach Index.
- `replication/outputs/figures/t031_reversal_distance.pdf` – prognostizierte Umkehrwahrscheinlichkeiten.
- `replication/outputs/tables/t031_build_attempt.log` – erklärter fehlgeschlagener erster Buildversuch.
- `replication/outputs/tables/t031_build_run1.log`, `replication/outputs/tables/t031_build_run2.log` – erfolgreiche Gesamtbuilds.
- `replication/outputs/tables/t031_hashes.csv` – SHA-[number withheld]-Vergleiche.
- `replication/outputs/tables/t031_verification.txt` – Abnahmeprüfungen, Validierung und Einschränkungen.

## Ausführung

Zweimal erfolgreich ausgeführt:

[fenced excerpt withheld in public process copy]
[fenced excerpt withheld in public process copy]

Letzte Ausgabe des zweiten Laufs:

[fenced excerpt withheld in public process copy]
[fenced excerpt withheld in public process copy]

## Abnahmekriterien

[number withheld]. **Erfüllt:** T023 einschließlich Bootstrap-KI reproduziert: \(b_\text{post}=[number withheld]{,}[number withheld]\), [number withheld]%-KI [[number withheld]; [number withheld]]. Während beider Gesamtbuilds blieben [number withheld] geschützte Dateien bytegleich; sämtliche zwölf T031-Analyseausgaben sind zwischen den Läufen byteidentisch. Belege: `t031_baseline.csv`, `t031_hashes.csv`.

[number withheld]. **Erfüllt:** Alle [number withheld] Gitterzellen, drei Stichproben und [number withheld] Firmenauslassungen berichtet. Ausschließlich die registrierte Baseline ist hervorgehoben. Alle [number withheld] Bootstrap-Ziehungen sind in diesen Fits gültig. Distanzregressionen stimmen mit unabhängigen `fixest`-Schätzungen bis auf höchstens \([number withheld]{,}[number withheld]\times1[number withheld]^{[number withheld]}\) überein; Tabellen und PDFs wurden geprüft.

[number withheld]. **Erfüllt:** Die Befunde je Check sind:

| Check | Befund für Q1 |
|---|---|
| Firmenstützung | Post: [number withheld] Firmenstichtage von [number withheld] Firmen, maximal fünf je Firma; [number withheld] Firmen waren zuvor nicht im Fenster. Deskriptive Stützung, kein KI-Test. |
| Leave-one-out | Übersteht alle [number withheld] Auslassungen: sämtliche Post-KIs oberhalb null; b zwischen [number withheld] und [number withheld]. |
| Stichprobenzusammensetzung | Übersteht beide Restriktionen: balanciert b = [number withheld] [[number withheld]; [number withheld]]; mindestens drei Beobachtungen je Periode b = [number withheld] [[number withheld]; [number withheld]]. |
| Sensitivitätsgitter | [number withheld]/[number withheld] KIs schließen null aus: [number withheld] %. Neun schließen null ein; universelle Spezifikationsrobustheit ist damit nicht gegeben. |
| Exakte Distanz | Binned-Modell: negative Differenz mit KI unter null bei [number withheld] und [number withheld]; bei [number withheld] enthält das KI null. Linear sind alle drei negativ signifikant: funktionale Form bleibt relevant. |
| Timing | Ohne [number withheld]H2 bleibt Bunching: b = [number withheld] [[number withheld]; [number withheld]]. Für [number withheld]H2 allein: [number withheld] [[number withheld]; [number withheld]], also nicht gesichert. Ohne [number withheld]H2 enthalten außerdem die flexiblen nahen Umkehrkontraste null. |

[firm-specific excerpt withheld in public process copy]

## Offene Fragen

- Bei [number withheld]-Bins schneiden einige nominelle Fenster einzelne Bins. Verwendet wurde die T023-Mittelpunktregel; nominelle und tatsächlich erfasste Grenzen sind vollständig ausgewiesen.
- Die Vergleiche bleiben deskriptiv: Glattheit und Polynomform werden angenommen; Berichtsselektion, Mean Reversion und Kalenderzusammensetzung bleiben mögliche Erklärungen.
- Nach beiden Builds wurde `state/STATE.md` extern ergänzt. Neue T032-Hinweise betreffen Abweichungen zur veröffentlichten RL1 und die Perpetual-Behandlung. Diese Quellen wurden hier nicht unabhängig geprüft; Panel und Analyseausgaben blieben unverändert.
- `status:` bleibt `APPROVED`. Unabhängiges Review und PI-Abnahme stehen aus.
- Vorschlag für das KI-Protokoll durch den Co-PI: „2026-10-26, Codex, T031 Q1-Robustheitscode und Ausgaben; geprüft durch zwei Gesamtbuilds, SHA-[number withheld], unabhängige fixest-Berechnungen und PDF/TeX-Sichtprüfung.“ `AI_USAGE_LOG.md` liegt außerhalb des Schreibbereichs.