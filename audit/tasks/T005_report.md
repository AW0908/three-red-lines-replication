## Ergebnis

`03_figures.R` erzeugt die deskriptiven Tabellen, drei Bunching-Histogramme und den Verlauf der Verletzungsanteile. Die neun Ausgaben sind reproduzierbar; die vier PDFs wurden visuell geprüft.

## Dateien

- `replication/code/03_figures.R` – vollständiges R-Skript.
- `replication/outputs/tables/t005_summary_stats.csv` – Summary-Statistiken.
- `replication/outputs/tables/t005_summary_stats.tex` – LaTeX-Fragment.
- `replication/outputs/tables/t005_by_dose.csv` – deskriptive Tabelle nach Dosis.
- `replication/outputs/tables/t005_by_dose.tex` – LaTeX-Fragment mit Anmerkungen.
- `replication/outputs/tables/t005_bunching_counts.csv` – Bin-Zählungen, Anteile und Bereichsüberschreitungen.
- `replication/outputs/figures/t005_bunching_rl1.pdf` – Verteilung von Linie [number withheld].
- `replication/outputs/figures/t005_bunching_rl2.pdf` – Verteilung von Linie [number withheld].
- `replication/outputs/figures/t005_bunching_rl3.pdf` – Verteilung von Linie [number withheld].
- `replication/outputs/figures/t005_breach_shares.pdf` – Verletzungsanteile über [number withheld] Stichtage.

## Ausführung

Befehl, zweimal mit unverändertem finalem Skript ausgeführt:

[fenced excerpt withheld in public process copy]
[fenced excerpt withheld in public process copy]

Letzte Ausgabezeilen:

[fenced excerpt withheld in public process copy]
[fenced excerpt withheld in public process copy]

## Abnahmekriterien

[number withheld]. **Erfüllt:** Beide abschließenden Läufe ohne Fehler oder Warnungen; alle neun aufgelisteten Ausgaben einschließlich PDFs SHA-[number withheld]-identisch. Die Karte nennt irrtümlich zehn Ausgaben.
[number withheld]. **Erfüllt:** Dosisgruppen [number withheld]–[number withheld]: **[number withheld], [number withheld], [number withheld], [number withheld]**; Summe und „All“ jeweils **[number withheld]**.
[number withheld]. **Erfüllt durch Worker-Nachrechnung:** Alle zwölf Variablen über alle drei Zeitfenster unabhängig mit Python nachgerechnet; maximale absolute Abweichung **[number withheld] × [number withheld]⁻¹⁴**. Die unabhängige Reviewer-Prüfung steht aus.
[number withheld]. **Erfüllt:** Alle sechs Anteilssummen einschließlich außerhalb liegender Werte entsprechen [number withheld] innerhalb `[number withheld]`; gleiche Bin-Breiten und Schwellen als Bin-Kanten geprüft. Zusammenfassungszeilen der CSV werden dabei nicht nochmals addiert.
[number withheld]. **Erfüllt:** Beide TEX-Dateien enthalten `\toprule`, `\bottomrule` und keine `\documentclass`.
[number withheld]. **Erfüllt:** Anteile innerhalb ±[number withheld] Bin und Beobachtungen außerhalb:

| Verhältnis | Pre: ±[number withheld] Bin | Post: ±[number withheld] Bin | Außerhalb Pre | Außerhalb Post |
|---|---:|---:|---:|---:|
| rl1 | [number withheld]/[number withheld] = [number withheld] % | [number withheld]/[number withheld] = [number withheld] % | [number withheld] | [number withheld] |
| rl2 | [number withheld]/[number withheld] = [number withheld] % | [number withheld]/[number withheld] = [number withheld] % | [number withheld] | [number withheld] |
| rl3 | [number withheld]/[number withheld] = [number withheld] % | [number withheld]/[number withheld] = [number withheld] % | [number withheld] | [number withheld] |

[number withheld]. **Nicht vollständig erfüllt im Gesamtordner:** Meine Schreibbefehle betrafen ausschließlich den Schreibbereich. Der Vorher-Nachher-Vergleich zeigt zusätzlich Änderungen an `MTPA Vault/.obsidian/graph.json`, `MTPA Vault/.obsidian/workspace.json` und `tasks/T005_worker.log`. Panel, Wörterbuch und Aufgabenkarte sind unverändert. Panel-SHA-[number withheld]: `b3bf2b5c2b21c215ed7eddbf7eecbfc0d4d8007e4e95bb2d4a1b9c82deaea5f1`.

## Offene Fragen

±[number withheld] Bin bezeichnet das unmittelbar unterhalb und das unmittelbar oberhalb der Schwelle liegende Intervall. Bins sind links geschlossen und rechts offen; die letzte obere Bereichsgrenze ist eingeschlossen. Nenner sind die nichtfehlenden Werte je Kennzahl und Zeitraum; „All“ umfasst Firmen mit bekannter Dosis.

„Share delisted“ folgt der Co-PI-Rückmeldung: `listing == "delisted"`, Wind-Delistings [number withheld]–[number withheld]. Die dokumentierten Einschränkungen zur rl1-Definition, zu Restricted Cash und zur HK-Währung bleiben bestehen.

Die zusätzlichen Dateiänderungen wurden nicht zurückgesetzt; ihre Verursachung wurde nicht geprüft. Vorschlag für das KI-Protokoll nach Abnahme: „Codex implementierte T005 in R; Prüfung durch zwei byteidentische Läufe, unabhängige Nachrechnung der Summary-Statistiken und visuelle PDF-Kontrolle; keine Regressionen oder Tests auf statistische Signifikanz.“