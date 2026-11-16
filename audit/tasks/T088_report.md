## Ergebnis

T088 Rework [number withheld] wurde vollständig ausgeführt: HK bleibt ausschließlich deskriptiv, und die zusätzliche A-Schätzung ohne negative H2-Zuflüsse liegt vor. Die Hauptschätzung bleibt unverändert; sämtliche übrigen A-Regressionszeilen und die Event Study wurden exakt reproduziert. Die Lieferung ist durch numerische Gegenchecks, Eingabeprüfsummen und einen vollständigen Änderungsvergleich belegt.

## Dateien

Die vollständige Einzeldateiliste einschließlich sämtlicher Sicherungskopien und erneut extrahierter PDF-Seiten steht in `tasks/T088_validation/rework1_20261115T193611/file_list.csv`.

- `replication/code/30_mi_inflow.R` – Rework-Analyse, HK-Ausschluss und zusätzliche Robustheit.
- `replication/data/processed/cashflow_mi_halfyear.csv` – bytegleich reproduziertes Flusspanel.
- `replication/outputs/figures/t088_event_study.png` – bytegleich reproduzierte, visuell geprüfte Abbildung.
- `replication/outputs/tables/t088_estimates.csv` – Hauptschätzung, Robustheit und übrige A-Schätzungen; HK-/Poolzeilen entfernt.
- `replication/outputs/tables/t088_primary_table.md` – lesbare Ergebnistabelle einschließlich Robustheit.
- `replication/outputs/tables/t088_wild_draws_no_negative_h2.csv` – neue Bootstrap-Ziehungen der Robustheit.
- `replication/outputs/tables/t088_negative_h2.csv` – negative Fälle mit Firma, H1, Jahreswert, Rohquelle und Quellenbefund.
- `replication/outputs/tables/t088_hk_descriptive.csv` – deskriptive HK-Werte mit Mess- und Einheitenvorbehalt.
- `replication/outputs/tables/t088_hk_verification.csv` – Quellenvergleich und ausdrücklicher Ausschluss von HK-Schätzungen.
- `replication/outputs/tables/t088_input_integrity.csv` – Integrität einschließlich aktualisiertem Kartenhash.
- `replication/outputs/tables/t088_a_schema.csv` – Feldschema.
- `replication/outputs/tables/t088_annual_report_checks.csv` – Vergleich mit Geschäftsberichten.
- `replication/outputs/tables/t088_annual_report_values.csv` – extrahierte A-Berichtswerte und Seitenbelege.
- `replication/outputs/tables/t088_covariance_check.csv` – CR1-Kovarianzvergleich.
- `replication/outputs/tables/t088_coverage.csv` – Outcome-Abdeckung nach Markt und Periode.
- `replication/outputs/tables/t088_descriptives.csv` – Zuflüsse nach Datum und Gruppe.
- `replication/outputs/tables/t088_download_coverage.csv` – Downloadabdeckung.
- `replication/outputs/tables/t088_download_failures.csv` – sämtliche protokollierten Downloadfehler.
- `replication/outputs/tables/t088_event_study.csv` – A-Event-Study-Koeffizienten.
- `replication/outputs/tables/t088_field_mapping.csv` – dokumentierte Feldzuordnung.
- `replication/outputs/tables/t088_firm_flow_counts.csv` – verfügbare Flüsse je Firma.
- `replication/outputs/tables/t088_fye_exclusions.csv` – Geschäftsjahresausschlüsse.
- `replication/outputs/tables/t088_heterogeneity_definition.csv` – Definition der explorativen Heterogenität.
- `replication/outputs/tables/t088_hk_candidate_coverage.csv` – deskriptive HK-Kandidatenabdeckung.
- `replication/outputs/tables/t088_hk_report_values.csv` – HK-Berichtswerte und Seitenbelege.
- `replication/outputs/tables/t088_long_difference.csv` – Langdifferenzregressionen.
- `replication/outputs/tables/t088_long_difference_firms.csv` – deren Firmendaten.
- `replication/outputs/tables/t088_missing_rule_detail.csv` – einzelne Fehlwertentscheidungen.
- `replication/outputs/tables/t088_missing_rules.csv` – Häufigkeiten je Fehlwertregel.
- `replication/outputs/tables/t088_negative_h2_by_date.csv` – negative Fälle nach Datum.
- `replication/outputs/tables/t088_pretest.csv` – gemeinsamer Vortrendtest.
- `replication/outputs/tables/t088_probe_reproduction.csv` – exakter Probevergleich.
- `replication/outputs/tables/t088_raw_hashes.csv` – Rohdatenprüfsummen.
- `replication/outputs/tables/t088_reconciliation.csv` – vollständiger Handerhebungsabgleich.
- `replication/outputs/tables/t088_reconciliation_mismatches.csv` – sämtliche Nichttreffer.
- `replication/outputs/tables/t088_reconciliation_summary.csv` – Trefferanteile.
- `replication/outputs/tables/t088_selection.csv` – Vergleich abgedeckter und fehlender Firmen.
- `replication/outputs/tables/t088_selection_firms.csv` – zugehörige Firmendaten.
- `replication/outputs/tables/t088_sina_decision.csv` – dokumentierter EastMoney-Fallback.
- `replication/outputs/tables/t088_source_followup.csv` – Quellenvergleich unterschiedlicher Berichtsstände.
- `replication/outputs/tables/t088_stop_checks.csv` – Stopp-Prüfungen.
- `replication/outputs/tables/t088_substitution.csv` – Schulden- und Minderheitskapitalvergleich.
- `replication/outputs/tables/t088_top10.csv` – größte Zuflüsse.
- `replication/outputs/tables/t088_wild_draws.csv` – unveränderte primäre Bootstrap-Ziehungen.
- `tasks/T088_validation/verify.R` – numerische Gegenchecks einschließlich Robustheit.
- `tasks/T088_validation/finalize_rework1.py` – Integritäts-, Zeilen- und Dateivergleich.
- `tasks/T088_validation/methods.txt` – Methoden und Grenzen.
- `tasks/T088_validation/sessionInfo.txt` – R- und Paketversionen.
- `tasks/T088_validation/acceptance.csv` – mechanische Prüfung der ursprünglichen Kriterien.
- `tasks/T088_validation/numerical_checks.csv` – Ergebnisse der numerischen Gegenchecks.
- `tasks/T088_validation/current_validation.json` – aktuelle Prüfzusammenfassung.
- `tasks/T088_validation/artifacts.csv` – aktuelle Artefaktprüfsummen.
- `tasks/T088_validation/active_rework.txt` – Verweis auf diesen Lauf.
- `tasks/T088_validation/rework1_20261115T193611/analysis.log` – Analyselog.
- `tasks/T088_validation/rework1_20261115T193611/numerical.log` – Gegenchecklog.
- `tasks/T088_validation/rework1_20261115T193611/reference_191719.json` – bestätigte Referenz zum Vorlauf.
- `tasks/T088_validation/rework1_20261115T193611/inputs_before.json` – Eingabeprüfsummen vor Ausführung.
- `tasks/T088_validation/rework1_20261115T193611/input_integrity.csv` – Eingabevergleich.
- `tasks/T088_validation/rework1_20261115T193611/output_comparison.csv` – Vergleich sämtlicher bisheriger Ergebnisse.
- `tasks/T088_validation/rework1_20261115T193611/changed_rows.csv` – jede geänderte Tabellenzelle beziehungsweise hinzugefügte/entfernte Zeile.
- `tasks/T0[number withheld]_validation/rework1_2[number withheld]T1[number withheld]/changes.diff` – Code-, Methoden- und Textänderungen.
- `tasks/T088_validation/rework1_20261115T193611/deviations.md` – einzeln erklärte Abweichungen.
- `tasks/T088_validation/rework1_20261115T193611/acceptance.csv` – Kriterien einschließlich R1–R3.
- `tasks/T088_validation/rework1_20261115T193611/visual_checks.csv` – Abbildungsprüfung.
- `tasks/T088_validation/rework1_20261115T193611/summary.json` – Abschlusszusammenfassung.
- `tasks/T088_validation/rework1_20261115T193611/file_list.csv` – Einzeldateiverzeichnis einschließlich der gesicherten Vorstände unter `before/` und aller erneut erzeugten Textseiten unter `tasks/T0[number withheld]_validation/pdf/`.
- `tasks/T088_report.md` – dieser Worker-Bericht.

## Ausführung

Alle Befehle liefen mit Exitcode [number withheld]. Kein Download oder Netzwerkaufruf wurde ausgeführt.

[fenced excerpt withheld in public process copy]
[fenced excerpt withheld in public process copy]

Letzte Ausgabezeilen:

[fenced excerpt withheld in public process copy]
[fenced excerpt withheld in public process copy]

Numerischer Gegencheck:

[fenced excerpt withheld in public process copy]
[fenced excerpt withheld in public process copy]

[fenced excerpt withheld in public process copy]
[fenced excerpt withheld in public process copy]

Abschlussvergleich:

[fenced excerpt withheld in public process copy]
[fenced excerpt withheld in public process copy]

[fenced excerpt withheld in public process copy]
[fenced excerpt withheld in public process copy]

## Abnahmekriterien

Tabellennamen beziehen sich nachfolgend auf `replication/outputs/tables/`.

[number withheld]. **Erfüllt:** A vor der Policy: [number withheld] Beobachtungen/[number withheld] Firmen; danach: [number withheld]/[number withheld] (`t088_coverage.csv`, `market=A`, `period=pre/post`). HK-Kandidatenabdeckung steht separat in `t088_hk_candidate_coverage.csv`. Alle [number withheld] Fehlerzeilen stehen in `t088_download_failures.csv`.

[number withheld]. **Erfüllt:** Vanke, Poly und CM Shekou stimmen nach De-Kumulierung exakt mit den Probe-Rohwerten überein (`t088_probe_reproduction.csv`, alle `exact=TRUE`). Der Gegencheck rekonstruiert zusätzlich sämtliche A-Rohzuflüsse (`numerical_checks.csv`, `all_A_raw_to_halfyear`).

[number withheld]. **Erfüllt als vorgeschriebener Quellenvergleich:** Die Zuflüsse der drei A-Prüffirmen für [number withheld] und [number withheld] stimmen mit den zitierten Berichtsseiten überein (`t088_annual_report_checks.csv`, `metric=inflow`). T046: [number withheld]/[number withheld] innerhalb [number withheld] %, entsprechend [number withheld] %; T047: [number withheld]/[number withheld], entsprechend [number withheld] % (`t088_reconciliation_summary.csv`). Beide Nichttreffer bleiben vollständig ausgewiesen.

[number withheld]. **Erfüllt:** Haupttabelle und alle weiterhin vorgeschriebenen sekundären Ergebnisse liegen vor (`t088_estimates.csv`, `t088_long_difference.csv`, `t088_substitution.csv`). Haupt- und Robustheitswert stehen nebeneinander:

   | Zeile in `t088_estimates.csv` | β, pp | Cluster-SE | [number withheld]%-KI | Wild-p | N | Firmen |
   |---|---:|---:|---|---:|---:|---:|
   | `primary` | [number withheld] | [number withheld] | [[number withheld]; [number withheld]] | [number withheld] | [number withheld] | [number withheld] |
   | `primary_no_negative_h2` | [number withheld] | [number withheld] | [[number withheld]; [number withheld]] | [number withheld] | [number withheld] | [number withheld] |

[number withheld]. **Erfüllt gemäß Rework-Entscheidung:** Event Study und gemeinsamer Vortrendtest liegen vor; p = [number withheld] (`t088_pretest.csv`). Der historische HK-Vergleich ergibt mechanisch vier Treffer, erlaubt aber ausdrücklich keine Schätzung (`t088_hk_verification.csv`, `estimation_allowed=FALSE`).

[number withheld]. **Erfüllt:** End-to-end-Lauf erfolgreich; Seed [number withheld] und jeweils [number withheld] Bootstrap-Ziehungen gespeichert. Alle [number withheld] Rohdatenprüfsummen bestehen; [number withheld] geschützte Eingaben blieben unverändert (`rework1_20261115T193611/summary.json`). Numerische Gegenchecks verwenden zusätzlich `fixest` und direkte Bootstrap-Neuschätzungen.

- **R1 erfüllt:** Keine HK- oder gepoolten Zeilen in `t088_estimates.csv` oder `t088_event_study.csv`. HK ist deskriptiv und mit Zielgrößen- sowie Einheitenunsicherheit gekennzeichnet.

- **R2 erfüllt:** `primary_no_negative_h2` enthält sämtliche verlangten Kennzahlen. Nur die acht betroffenen Firma-Halbjahre wurden entfernt; dieselben Firmen bleiben enthalten (`t088_negative_h2.csv`; `numerical_checks.csv`).

- **R3 erfüllt:** Alle [number withheld] beibehaltenen A-Schätzungszeilen sind exakt unverändert. Von [number withheld] bisherigen Ergebnisdateien sind [number withheld] bytegleich. Die sechs Abweichungen betreffen ausschließlich `t088_estimates.csv`, `t088_hk_descriptive.csv`, `t088_hk_verification.csv`, `t088_negative_h2.csv`, `t088_primary_table.md` sowie den neuen Kartenhash in `t088_input_integrity.csv`. Jede Abweichung ist in `output_comparison.csv`, `changed_rows.csv` und `deviations.md` einzeln dokumentiert.

## Offene Fragen

[firm-specific excerpt withheld in public process copy]

- Die beiden Abweichungen zur Handerhebung bleiben bestehen. Unterschiedliche Berichtsstände sind dokumentiert; ihre Ursachen wurden nicht abschließend festgestellt (`t088_source_followup.csv`).

- HK-Währungs- und Skalengleichheit wurde nicht geprüft. Für Schätzungen ist diese Prüfung durch den HK-Ausschluss nicht benötigt; die deskriptive Normalisierung bleibt ausdrücklich ungeprüft.

- Ein abgeschlossenes Sina-Probeergebnis fehlt weiterhin. Der freigegebene EastMoney-Fallback wurde beibehalten (`t088_sina_decision.csv`). Der Mindestumfang ist erreicht; er ist keine zusätzliche Firmenfilterregel (`t088_stop_checks.csv`).

- Die Spezifikation ist outcome-informiert. Eine kausale Interpretation setzt parallele unbehandelte Zuflusstrends, stabile Messung und Selektion sowie keine differenziellen Krisen- oder Regulierungsschocks voraus. Der Vortrendtest bestätigt diese Annahmen nicht.

- Dies sind Worker-Prüfungen, keine unabhängige Abnahme. Kartenstatus, Rohdaten, Reviewberichte und Proposal wurden nicht geändert. Der T088-Eintrag in `state/LIMITATIONS.md` ist vorhanden und blieb unverändert.

- Vorgeschlagener KI-Nutzungseintrag: „[number withheld], Codex Worker T088 Rework [number withheld]: HK aus Schätzungen ausgeschlossen, vorgegebene Robustheit ohne negative H2-Zuflüsse umgesetzt, numerische Gegenchecks und vollständiger Ergebnisvergleich dokumentiert.“ `AI_USAGE_LOG.md` liegt außerhalb des Schreibbereichs und wurde nicht geändert.