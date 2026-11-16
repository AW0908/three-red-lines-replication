## Ergebnis

T025 ist vollständig umgesetzt: Vergleichstabellen, Lee-Bounds, Bootstrap-Ergebnisse und Prüfnachweise liegen vor; Schritt [number withheld] ist in beiden Pipeline-Einstiegspunkten registriert. Heckman-SE und Konfidenzintervalle werden für `mi_share` und `jv_ta` wegen mehr als [number withheld] % fehlgeschlagener Draws unterdrückt. IPW und Lee-Bounds verwenden für jedes Outcome alle [number withheld] Draws.

## Dateien

Erzeugt beziehungsweise aktualisiert:

- `replication/code/09_selection.R` – Schätzung, Bootstrap-Regel, Diagnostik und Tabellen.
- `replication/run_all.R` – Schritt [number withheld] nach Schritt [number withheld].
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
- `replication/outputs/tables/t025_bootstrap_draws.csv` – alle [number withheld] Outcome-Draw-Ergebnisse.
- `replication/outputs/tables/t025_lee_audit.csv` – Firmenveränderungen und Gruppenzuordnung.
- `replication/outputs/tables/t025_verification.txt` – Ausführungsnachweise, Prüfungen und SHA-[number withheld]-Manifeste.

Überholte Dateien entfernt:

- `replication/outputs/tables/t025_bootstrap_partial.csv`
- `replication/outputs/tables/t025_point_estimates_incomplete.csv`
- `replication/outputs/tables/t025_lee_points_incomplete.csv`
- `replication/outputs/tables/t025_failed_probit.csv`
- `replication/outputs/tables/t025_failed_probit_risk.csv`
- `replication/outputs/tables/t025_input_stop.txt`
- `replication/outputs/tables/t025_stop_diagnostics.txt`

## Ausführung

Zweimal in isolierten Paketkopien unter `/tmp/t0[number withheld]_final_check/run1` und `/tmp/t0[number withheld]_final_check/run2`:

[fenced excerpt withheld in public process copy]
[fenced excerpt withheld in public process copy]

Beide Läufe: Exit [number withheld]. Letzte Ausgabe des zweiten Laufs:

[fenced excerpt withheld in public process copy]
[fenced excerpt withheld in public process copy]

Zusätzlich: unabhängiger Abgleich der Bootstrap-Ausfälle und S6-Ergebnisse, Bash-Syntaxprüfung und erfolgreiche LaTeX-Kompilierung beider Tabellen ohne Überbreiten.

## Abnahmekriterien

[number withheld]. **Erfüllt:** Alle numerischen Baseline-Spalten reproduzieren T009 innerhalb `[number withheld]`; maximale Abweichung `[number withheld]`. Beleg: `t025_baseline_validation.csv`.

[number withheld]. **Erfüllt:** Erste Stufe und Z sind berichtet; Seed `[number withheld]`. Alle elf erzeugten Analyseartefakte sind zwischen beiden vollständigen Builds byte-identisch. Heckman gültig/fehlgeschlagen:

   | Outcome | Gültig | Fehlgeschlagen |
   |---|---:|---:|
   | rl1 | [number withheld] | [number withheld] |
   | rl2 | [number withheld] | [number withheld] |
   | mi_share | [number withheld] | [number withheld] |
   | rl2_gap | [number withheld] | [number withheld] |
   | jv_ta | [number withheld] | [number withheld] |

   Für `mi_share` und `jv_ta` stehen SE und CI entsprechend der Kartenregel auf `NA` beziehungsweise `--`. Kein Draw wurde ersetzt.

[number withheld]. **Erfüllt:** Alle [number withheld] bisherigen Nicht-T025-Outputs sind im Projekt und beiden Build-Kopien byte-identisch. Die externe Prüfung umfasst zusätzlich die versteckte Datei `outputs/.DS_Store`, daher zählt sie eine Datei mehr als das R-Skript. Alle sechs geprüften Eingaben bleiben unverändert.

[number withheld]. **Erfüllt:** Verschiebung von β, gemessen in Baseline-SE:

   | Outcome | Heckman | IPW | S6 |
   |---|---:|---:|---:|
   | rl1 | [number withheld] | [number withheld] | [number withheld] |
   | rl2 | [number withheld] | [number withheld] | [number withheld] |
   | mi_share | [number withheld] | [number withheld] | [number withheld] |
   | rl2_gap | [number withheld] | [number withheld] | [number withheld] |
   | jv_ta | [number withheld] | [number withheld] | [number withheld] |

   IPW verändert die Punktschätzer vergleichsweise wenig. Die größeren Heckman-Verschiebungen zeigen wegen schwacher Ausschlussrestriktion und annähernder Kollinearität Fragilität; sie belegen keine Attritionsverzerrung. IPW gewichtet Zeilen innerhalb der Firmen: vor der Politik mit [number withheld], beobachtete Post-Zeilen mit den begrenzten inversen Beobachtungswahrscheinlichkeiten.

## Offene Fragen

Keine zusätzliche PI-Entscheidung erforderlich. Der Kartenstatus wurde nicht verändert.

Die Identifikationsannahmen bleiben ungeprüft: IPW benötigt bedingte Unabhängigkeit der Beobachtung und Positivität; Lee benötigt monotone Selektion und einen tragfähigen Gruppenvergleich. Lee verwendet mindestens eine Post-Beobachtung und erfasst späte Ausfälle deshalb nur eingeschränkt; seine binären Gruppenunterschiede sind keine Effekte je Dosiseinheit.

Während der Sitzung wurden außerdem Änderungen an `.DS_Store` und dem laufenden `tasks/T025_worker.log` beobachtet und protokolliert; diese Dateien wurden nicht zurückgesetzt.

Vorgeschlagener KI-Protokolleintrag nach Abnahme: „Codex setzte T025 einschließlich Bootstrap-Ausfallregel um; geprüft durch zwei vollständige Builds, Prüfsummen, unabhängige Draw- und Stichprobenabgleiche sowie LaTeX-Kompilierung.“