## Ergebnis

T025 ist vollständig umgesetzt: Vergleichstabellen, Lee-Bounds, Bootstrap-Ergebnisse und Prüfnachweise liegen vor; Schritt 09 ist in beiden Pipeline-Einstiegspunkten registriert. Heckman-SE und Konfidenzintervalle werden für `mi_share` und `jv_ta` wegen mehr als 10 % fehlgeschlagener Draws unterdrückt. IPW und Lee-Bounds verwenden für jedes Outcome alle 499 Draws.

## Dateien

Erzeugt beziehungsweise aktualisiert:

- `replication/code/09_selection.R` – Schätzung, Bootstrap-Regel, Diagnostik und Tabellen.
- `replication/run_all.R` – Schritt 09 nach Schritt 08.
- `replication/run_all.sh` – gleiche Reihenfolge.
- `replication/README.md` – Pipeline, Outputs und Changelog.
- `replication/outputs/tables/t025_attrition.csv` – Beobachtungsquoten nach Datum und Dosisgruppe.
- `replication/outputs/tables/t025_baseline_validation.csv` – Abgleich mit T009.
- `replication/outputs/tables/t025_first_stage_diagnostics.csv` – Probit und Ausschlussvariable.
- `replication/outputs/tables/t025_missing_predictors.csv` – fehlende Vorperiodenmittel.
- `replication/outputs/tables/t025_selection_audit.csv` – Risikomenge, Wahrscheinlichkeiten, Mills-Ratio und Gewichte.
- `replication/outputs/tables/t025_selection.csv` – Koeffizienten, SE, Intervalle und Bootstrap-Ausfälle.
- `replication/outputs/tables/t025_selection.tex` – Vergleichstabelle mit Annahmen und Einschränkungen.
- `replication/outputs/tables/t025_lee_bounds.csv` – Grenzen und Bootstrap-Intervalle.
- `replication/outputs/tables/t025_lee_bounds.tex` – Lee-Tabelle mit Annahmen.
- `replication/outputs/tables/t025_bootstrap_draws.csv` – alle 2.495 Outcome-Draw-Ergebnisse.
- `replication/outputs/tables/t025_lee_audit.csv` – Firmenveränderungen und Gruppenzuordnung.
- `replication/outputs/tables/t025_verification.txt` – Ausführungsnachweise, Prüfungen und SHA-256-Manifeste.

Überholte Dateien entfernt:

- `replication/outputs/tables/t025_bootstrap_partial.csv`
- `replication/outputs/tables/t025_point_estimates_incomplete.csv`
- `replication/outputs/tables/t025_lee_points_incomplete.csv`
- `replication/outputs/tables/t025_failed_probit.csv`
- `replication/outputs/tables/t025_failed_probit_risk.csv`
- `replication/outputs/tables/t025_input_stop.txt`
- `replication/outputs/tables/t025_stop_diagnostics.txt`

## Ausführung

Zweimal in isolierten Paketkopien unter `/tmp/t025_final_check/run1` und `/tmp/t025_final_check/run2`:

[fenced excerpt withheld in public audit]
[fenced excerpt withheld in public audit]

Beide Läufe: Exit 0. Letzte Ausgabe des zweiten Laufs:

[fenced excerpt withheld in public audit]
[fenced excerpt withheld in public audit]

Zusätzlich: unabhängiger Abgleich der Bootstrap-Ausfälle und S6-Ergebnisse, Bash-Syntaxprüfung und erfolgreiche LaTeX-Kompilierung beider Tabellen ohne Überbreiten.

## Abnahmekriterien

1. **Erfüllt:** Alle numerischen Baseline-Spalten reproduzieren T009 innerhalb `1e-12`; maximale Abweichung `2,22e-15`. Beleg: `t025_baseline_validation.csv`.

2. **Erfüllt:** Erste Stufe und Z sind berichtet; Seed `20261016`. Alle elf erzeugten Analyseartefakte sind zwischen beiden vollständigen Builds byte-identisch. Heckman gültig/fehlgeschlagen:

   | Outcome | Gültig | Fehlgeschlagen |
   |---|---:|---:|
   | rl1 | 499 | 0 |
   | rl2 | 499 | 0 |
   | mi_share | 390 | 109 |
   | rl2_gap | 499 | 0 |
   | jv_ta | 427 | 72 |

   Für `mi_share` und `jv_ta` stehen SE und CI entsprechend der Kartenregel auf `NA` beziehungsweise `--`. Kein Draw wurde ersetzt.

3. **Erfüllt:** Alle 83 bisherigen Nicht-T025-Outputs sind im Projekt und beiden Build-Kopien byte-identisch. Die externe Prüfung umfasst zusätzlich die versteckte Datei `outputs/.DS_Store`, daher zählt sie eine Datei mehr als das R-Skript. Alle sechs geprüften Eingaben bleiben unverändert.

4. **Erfüllt:** Verschiebung von β, gemessen in Baseline-SE:

   | Outcome | Heckman | IPW | S6 |
   |---|---:|---:|---:|
   | rl1 | −0,695 | −0,027 | +0,510 |
   | rl2 | −2,374 | −0,357 | +1,223 |
   | mi_share | −1,182 | −0,085 | −0,231 |
   | rl2_gap | +0,025 | −0,018 | +0,083 |
   | jv_ta | −0,063 | +0,073 | −0,357 |

   IPW verändert die Punktschätzer vergleichsweise wenig. Die größeren Heckman-Verschiebungen zeigen wegen schwacher Ausschlussrestriktion und annähernder Kollinearität Fragilität; sie belegen keine Attritionsverzerrung. IPW gewichtet Zeilen innerhalb der Firmen: vor der Politik mit 1, beobachtete Post-Zeilen mit den begrenzten inversen Beobachtungswahrscheinlichkeiten.

## Offene Fragen

Keine zusätzliche PI-Entscheidung erforderlich. Der Kartenstatus wurde nicht verändert.

Die Identifikationsannahmen bleiben ungeprüft: IPW benötigt bedingte Unabhängigkeit der Beobachtung und Positivität; Lee benötigt monotone Selektion und einen tragfähigen Gruppenvergleich. Lee verwendet mindestens eine Post-Beobachtung und erfasst späte Ausfälle deshalb nur eingeschränkt; seine binären Gruppenunterschiede sind keine Effekte je Dosiseinheit.

Während der Sitzung wurden außerdem Änderungen an `.DS_Store` und dem laufenden `tasks/T025_worker.log` beobachtet und protokolliert; diese Dateien wurden nicht zurückgesetzt.

Vorgeschlagener KI-Protokolleintrag nach Abnahme: „Codex setzte T025 einschließlich Bootstrap-Ausfallregel um; geprüft durch zwei vollständige Builds, Prüfsummen, unabhängige Draw- und Stichprobenabgleiche sowie LaTeX-Kompilierung.“