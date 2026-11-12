## Ergebnis

`03_figures.R` erzeugt die deskriptiven Tabellen, drei Bunching-Histogramme und den Verlauf der Verletzungsanteile. Die neun Ausgaben sind reproduzierbar; die vier PDFs wurden visuell geprüft.

## Dateien

- `replication/code/03_figures.R` – vollständiges R-Skript.
- `replication/outputs/tables/t005_summary_stats.csv` – Summary-Statistiken.
- `replication/outputs/tables/t005_summary_stats.tex` – LaTeX-Fragment.
- `replication/outputs/tables/t005_by_dose.csv` – deskriptive Tabelle nach Dosis.
- `replication/outputs/tables/t005_by_dose.tex` – LaTeX-Fragment mit Anmerkungen.
- `replication/outputs/tables/t005_bunching_counts.csv` – Bin-Zählungen, Anteile und Bereichsüberschreitungen.
- `replication/outputs/figures/t005_bunching_rl1.pdf` – Verteilung von Linie 1.
- `replication/outputs/figures/t005_bunching_rl2.pdf` – Verteilung von Linie 2.
- `replication/outputs/figures/t005_bunching_rl3.pdf` – Verteilung von Linie 3.
- `replication/outputs/figures/t005_breach_shares.pdf` – Verletzungsanteile über 13 Stichtage.

## Ausführung

Befehl, zweimal mit unverändertem finalem Skript ausgeführt:

[fenced excerpt withheld in public audit]
[fenced excerpt withheld in public audit]

Letzte Ausgabezeilen:

[fenced excerpt withheld in public audit]
[fenced excerpt withheld in public audit]

## Abnahmekriterien

1. **Erfüllt:** Beide abschließenden Läufe ohne Fehler oder Warnungen; alle neun aufgelisteten Ausgaben einschließlich PDFs SHA-256-identisch. Die Karte nennt irrtümlich zehn Ausgaben.
2. **Erfüllt:** Dosisgruppen 0–3: **41, 38, 15, 32**; Summe und „All“ jeweils **126**.
3. **Erfüllt durch Worker-Nachrechnung:** Alle zwölf Variablen über alle drei Zeitfenster unabhängig mit Python nachgerechnet; maximale absolute Abweichung **5,68 × 10⁻¹⁴**. Die unabhängige Reviewer-Prüfung steht aus.
4. **Erfüllt:** Alle sechs Anteilssummen einschließlich außerhalb liegender Werte entsprechen 1 innerhalb `1e-12`; gleiche Bin-Breiten und Schwellen als Bin-Kanten geprüft. Zusammenfassungszeilen der CSV werden dabei nicht nochmals addiert.
5. **Erfüllt:** Beide TEX-Dateien enthalten `\toprule`, `\bottomrule` und keine `\documentclass`.
6. **Erfüllt:** Anteile innerhalb ±1 Bin und Beobachtungen außerhalb:

| Verhältnis | Pre: ±1 Bin | Post: ±1 Bin | Außerhalb Pre | Außerhalb Post |
|---|---:|---:|---:|---:|
| rl1 | 87/797 = 10,9159 % | 134/630 = 21,2698 % | 38 | 37 |
| rl2 | 35/740 = 4,7297 % | 31/575 = 5,3913 % | 53 | 38 |
| rl3 | 17/722 = 2,3546 % | 21/586 = 3,5836 % | 131 | 110 |

7. **Nicht vollständig erfüllt im Gesamtordner:** Meine Schreibbefehle betrafen ausschließlich den Schreibbereich. Der Vorher-Nachher-Vergleich zeigt zusätzlich Änderungen an `MTPA Vault/.obsidian/graph.json`, `MTPA Vault/.obsidian/workspace.json` und `tasks/T005_worker.log`. Panel, Wörterbuch und Aufgabenkarte sind unverändert. Panel-SHA-256: `b3bf2b5c2b21c215ed7eddbf7eecbfc0d4d8007e4e95bb2d4a1b9c82deaea5f1`.

## Offene Fragen

±1 Bin bezeichnet das unmittelbar unterhalb und das unmittelbar oberhalb der Schwelle liegende Intervall. Bins sind links geschlossen und rechts offen; die letzte obere Bereichsgrenze ist eingeschlossen. Nenner sind die nichtfehlenden Werte je Kennzahl und Zeitraum; „All“ umfasst Firmen mit bekannter Dosis.

„Share delisted“ folgt der Co-PI-Rückmeldung: `listing == "delisted"`, Wind-Delistings 2017–2024. Die dokumentierten Einschränkungen zur rl1-Definition, zu Restricted Cash und zur HK-Währung bleiben bestehen.

Die zusätzlichen Dateiänderungen wurden nicht zurückgesetzt; ihre Verursachung wurde nicht geprüft. Vorschlag für das KI-Protokoll nach Abnahme: „Codex implementierte T005 in R; Prüfung durch zwei byteidentische Läufe, unabhängige Nachrechnung der Summary-Statistiken und visuelle PDF-Kontrolle; keine Regressionen oder Tests auf statistische Signifikanz.“