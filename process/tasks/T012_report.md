## Ergebnis

Die REWORK-Punkte von T012 sind umgesetzt: Fehlende geschützte Ausgaben werden erzeugt, identische Dateien bleiben unangetastet, abweichende führen zum Abbruch. Der Panel-Guard prüft gegen den festen T004-Hash; die T003-Angaben sind eingebettet, und die deskriptiven Gruppen verwenden `floor(dose_pre + [number withheld])`. Zwei Projektläufe und zwei Neuaufbauten in einer temporären Kopie waren erfolgreich und lieferten identische Ergebnisse.

## Dateien

Inhaltlich geändert:

- `replication/code/01_clean.R` – unabhängiger T004-Checksum-Guard, eingebettete T003-Angaben und Erzeugung fehlender geschützter Tabellen.
- `replication/code/03_figures.R` – Erzeugung fehlender geschützter Ausgaben und Rundung von Halbwerten nach oben.
- `replication/outputs/tables/t005_by_dose.csv` – aktualisierte Gruppenstatistik.
- `replication/outputs/tables/t005_by_dose.tex` – aktualisierte Gruppenstatistik und Rundungshinweis.

Die weiteren erzeugten Analyseausgaben sind vollständig in der Vergleichstabelle unten aufgeführt; ihre Projektinhalte blieben unverändert. `02_estimate.R`, `04_robustness.R`, Aufgabenstatus und Rohdaten wurden nicht geändert.

Temporäre Prüfbelege außerhalb des Projekts:

- `/private/tmp/t012_rework_q5rtdtrt/before.json` – Prüfsummen vor der Bearbeitung.
- `/private/tmp/t012_rework_q5rtdtrt/project.txt` – Projektpfad für den Prüfablauf.
- `/private/tmp/t012_rework_q5rtdtrt/verify.py` – Ablauf für Wiederholung, Neuaufbau und Negativtests.
- `/private/tmp/t012_rework_q5rtdtrt/final_audit.py` – abschließende Prüfsummen- und Schreibbereichskontrolle.
- `/private/tmp/t012_rework_q5rtdtrt/run1_sha256.json` – Ausgaben nach dem ersten Projektlauf.
- `/private/tmp/t012_rework_q5rtdtrt/run2.log` – zweiter Projektlauf.
- `/private/tmp/t012_rework_q5rtdtrt/scratch_run1.log` – erster Neuaufbau.
- `/private/tmp/t012_rework_q5rtdtrt/scratch_run2.log` – zweiter Lauf der temporären Kopie.
- `/private/tmp/t012_rework_q5rtdtrt/negative_01_clean.R.log` – Abbruch bei manipulierter T004-Ausgabe.
- `/private/tmp/t012_rework_q5rtdtrt/negative_03_figures.R.log` – Abbruch bei manipulierter T005-Ausgabe.
- `/private/tmp/t012_rework_q5rtdtrt/sha256_comparison.csv` – vollständige SHA-[number withheld]-Vergleichstabelle aller vier Läufe.
- `/private/tmp/t012_rework_q5rtdtrt/changed_files.json` – festgestellte Projektänderungen.
- `/private/tmp/t012_rework_q5rtdtrt/audit_summary.json` – abschließende Prüfergebnisse.
- `/private/tmp/t0[number withheld]_rework_q5rtdtrt/scratch/replication/` – temporäre Replikationskopie; die [number withheld] erzeugten Dateien stehen in der Vergleichstabelle.

## Ausführung

Vorgeschriebener Befehl, zweimal erfolgreich ausgeführt:

[fenced excerpt withheld in public process copy]
[fenced excerpt withheld in public process copy]

Letzte Ausgabezeilen:

[fenced excerpt withheld in public process copy]
[fenced excerpt withheld in public process copy]

Neuaufbau und Prüfungen:

[fenced excerpt withheld in public process copy]
[fenced excerpt withheld in public process copy]

Vor dem Neuaufbau wurden sämtliche Dateien unter `data/processed/`, `outputs/tables/` und `outputs/figures/` der Kopie gelöscht. `../Daten` wurde im temporären Elternverzeichnis auf die Projekt-Rohdaten verlinkt; dort existiert kein `tasks/`-Verzeichnis.

Prüfausgabe:

[fenced excerpt withheld in public process copy]
[fenced excerpt withheld in public process copy]

Die erste Schreibbereichskontrolle meldete das automatisch fortgeschriebene `tasks/T012_worker.log` als zusätzliche Änderung. Die abschließende Kontrolle berücksichtigte diesen Laufzeitbeleg ausdrücklich und bestand; andere Änderungen außerhalb des Schreibbereichs wurden nicht gefunden.

## Abnahmekriterien

[number withheld]. **Erfüllt.** Alle vier Skripte liefen zweimal aus `replication/`. **[number withheld]/[number withheld] Ausgabedateien im Schreibbereich** waren byte-identisch; außerdem blieben sämtliche **[number withheld] vorhandenen Ausgaben** zwischen den Projektläufen identisch.
[number withheld]. **Erfüllt.** Panel: **[number withheld] Zeilen, [number withheld] Firmen, [number withheld] Spalten**. Die [number withheld] bisherigen Spalten entsprechen bytegenau dem T004-Panel, SHA-[number withheld]:  
   `b3bf2b5c2b21c215ed7eddbf7eecbfc0d4d8007e4e95bb2d4a1b9c82deaea5f1`.  
   `dose_pre ∈ [[number withheld]]`, `distance ≥ [number withheld]` und Firmenkonstanz aller drei ergänzten Treatments wurden geprüft.
[number withheld]. **Erfüllt.** Alle **[number withheld] ursprünglichen T011-Zellen** wurden vor der Umstellung reproduziert, einschließlich Stichprobengrößen und NA-Mustern. Maximale Abweichungen: Koeffizienten **[number withheld]e−[number withheld]**, Standardfehler **[number withheld]e−[number withheld]**. Neue S0 gegenüber Haupttabelle: Koeffizienten, Standardfehler und Vortrend-p bestanden die Assertions mit Toleranz `[number withheld]`.
[number withheld]. **Erfüllt.** Beide T005-Summary-Dateien, Bunching-CSV und vier T005-PDFs entsprechen den freigegebenen Prüfsummen. Zusammen mit den drei geschützten T004-Tabellen: **[number withheld]/[number withheld] unverändert**, auch ihre Änderungszeiten blieben beim Wiederholungslauf unverändert.
[number withheld]. **Erfüllt.** Haupt- und Robustheitstabelle folgen unten. `dose_pre` ist für **[number withheld] Firmen insgesamt**, darunter **[number withheld] Hauptstichprobenfirmen**, verfügbar. Die gerundeten Gruppen enthalten jetzt **[number withheld] / [number withheld] / [number withheld] / [number withheld] Firmen**.
[number withheld]. **Für Worker-Änderungen erfüllt.** Genau vier Projektdateien wurden inhaltlich geändert, alle im Schreibbereich. Einzige zusätzliche Änderung war das automatisch fortgeschriebene `tasks/T012_worker.log`.

**Neuaufbau: SHA-[number withheld]-Vergleich**

Pfade relativ zu `replication/`. „[number withheld]/[number withheld] gleich“ bedeutet identische SHA-[number withheld] in beiden Projektläufen und beiden Läufen der temporären Kopie. Vollständige Hashes stehen in `sha256_comparison.csv`; hier sind die ersten zwölf Zeichen angegeben.

| Datei | SHA-[number withheld]-Präfix | Vergleich |
|---|---|---|
| `data/processed/panel_firm_halfyear.csv` | `e1a5e2be4[number withheld]` | [number withheld]/[number withheld] gleich |
| `outputs/tables/t004_panel_counts.csv` | `a4c4cc8c7e9b` | [number withheld]/[number withheld] gleich |
| `outputs/tables/t004_item_coverage.csv` | `[number withheld]bbe0[number withheld]a6` | [number withheld]/[number withheld] gleich |
| `outputs/tables/t004_ownership_unresolved.csv` | `db4[number withheld]f0[number withheld]` | [number withheld]/[number withheld] gleich |
| `outputs/tables/t004_variable_dictionary.csv` | `[number withheld]fafd9[number withheld]` | [number withheld]/[number withheld] gleich |
| `outputs/tables/t005_summary_stats.csv` | `[number withheld]a9` | [number withheld]/[number withheld] gleich |
| `outputs/tables/t005_summary_stats.tex` | `e3e7e4[number withheld]c3e` | [number withheld]/[number withheld] gleich |
| `outputs/tables/t005_by_dose.csv` | `ed6[number withheld]ae7[number withheld]d` | [number withheld]/[number withheld] gleich |
| `outputs/tables/t005_by_dose.tex` | `c9[number withheld]fe9e9[number withheld]` | [number withheld]/[number withheld] gleich |
| `outputs/tables/t005_bunching_counts.csv` | `[number withheld]a5[number withheld]a4f9` | [number withheld]/[number withheld] gleich |
| `outputs/figures/t005_bunching_rl1.pdf` | `[number withheld]cd1[number withheld]a4[number withheld]` | [number withheld]/[number withheld] gleich |
| `outputs/figures/t005_bunching_rl2.pdf` | `e8[number withheld]c5[number withheld]` | [number withheld]/[number withheld] gleich |
| `outputs/figures/t005_bunching_rl3.pdf` | `[number withheld]cee6[number withheld]e` | [number withheld]/[number withheld] gleich |
| `outputs/figures/t005_breach_shares.pdf` | `f7d6eecc5[number withheld]` | [number withheld]/[number withheld] gleich |
| `outputs/tables/t009_did_main.csv` | `[number withheld]a5[number withheld]c1[number withheld]fe8` | [number withheld]/[number withheld] gleich |
| `outputs/tables/t009_did_main.tex` | `ab8[number withheld]d5[number withheld]` | [number withheld]/[number withheld] gleich |
| `outputs/tables/t009_event_study.csv` | `b7[number withheld]ec8[number withheld]` | [number withheld]/[number withheld] gleich |
| `outputs/tables/t009_pretrend_tests.csv` | `[number withheld]d2[number withheld]` | [number withheld]/[number withheld] gleich |
| `outputs/figures/t009_es_rl1.pdf` | `a2[number withheld]b4[number withheld]f5[number withheld]` | [number withheld]/[number withheld] gleich |
| `outputs/figures/t009_es_rl2.pdf` | `[number withheld]a9[number withheld]de9[number withheld]` | [number withheld]/[number withheld] gleich |
| `outputs/figures/t009_es_rl2_gap.pdf` | `ae8dc2[number withheld]ee2[number withheld]` | [number withheld]/[number withheld] gleich |
| `outputs/figures/t009_es_mi_share.pdf` | `[number withheld]a3[number withheld]be0a5[number withheld]` | [number withheld]/[number withheld] gleich |
| `outputs/figures/t009_es_jv_ta.pdf` | `e5f2bdfd6b9[number withheld]` | [number withheld]/[number withheld] gleich |
| `outputs/tables/t011_robustness.csv` | `b7f7[number withheld]` | [number withheld]/[number withheld] gleich |
| `outputs/tables/t011_robustness.tex` | `f3[number withheld]d3[number withheld]f9f5a` | [number withheld]/[number withheld] gleich |
| `outputs/tables/t011_treatment_definitions.csv` | `[number withheld]f8f7[number withheld]a6[number withheld]` | [number withheld]/[number withheld] gleich |

**Haupttabelle**

Koeffizienten und [number withheld]%-Konfidenzintervalle in Quoteneinheiten. Vortrend-p: gemeinsamer Wald-Test der sieben Termine vor der Referenz 2020-06-30.

| Outcome | Koeffizient | [number withheld]%-KI | Vortrend-p | N/Firmen |
|---|---:|---|---:|---:|
| rl1 | [number withheld] | [[number withheld], [number withheld]] | [number withheld] | [number withheld]/[number withheld] |
| rl2 | [number withheld] | [[number withheld], [number withheld]] | [number withheld] | [number withheld]/[number withheld] |
| rl2_gap | [number withheld] | [[number withheld], [number withheld]] | [number withheld] | [number withheld]/[number withheld] |
| mi_share | [number withheld] | [[number withheld], [number withheld]] | [number withheld] | [number withheld]/[number withheld] |
| jv_ta | [number withheld] | [[number withheld], [number withheld]] | [number withheld] | [number withheld]/[number withheld] |

**Umgestellte Robustheitstabelle**

Zellen: Koeffizient (firmengeclusterter Standardfehler). Vollständige Konfidenzintervalle, Vortrend-p und Stichprobengrößen stehen in `replication/outputs/tables/t011_robustness.csv`.

| Spec | rl1 | rl2 | rl2_gap | mi_share | jv_ta |
|---|---:|---:|---:|---:|---:|
| S0 | [number withheld] ([number withheld]) | [number withheld] ([number withheld]) | [number withheld] ([number withheld]) | [number withheld] ([number withheld]) | [number withheld] ([number withheld]) |
| S1 | [number withheld] ([number withheld]) | [number withheld] ([number withheld]) | [number withheld] ([number withheld]) | [number withheld] ([number withheld]) | [number withheld] ([number withheld]) |
| S2 | [number withheld] ([number withheld]) | [number withheld] ([number withheld]) | [number withheld] ([number withheld]) | [number withheld] ([number withheld]) | [number withheld] ([number withheld]) |
| S3 | [number withheld] ([number withheld]) | [number withheld] ([number withheld]) | [number withheld] ([number withheld]) | [number withheld] ([number withheld]) | [number withheld] ([number withheld]) |
| S4 | [number withheld] ([number withheld]) | [number withheld] ([number withheld]) | [number withheld] ([number withheld]) | [number withheld] ([number withheld]) | [number withheld] ([number withheld]) |
| S5 | [number withheld] ([number withheld]) | [number withheld] ([number withheld]) | [number withheld] ([number withheld]) | [number withheld] ([number withheld]) | [number withheld] ([number withheld]) |
| S6 | [number withheld] ([number withheld]) | [number withheld] ([number withheld]) | [number withheld] ([number withheld]) | [number withheld] ([number withheld]) | [number withheld] ([number withheld]) |
| S7 | [number withheld] ([number withheld]) | [number withheld] ([number withheld]) | [number withheld] ([number withheld]) | [number withheld] ([number withheld]) | [number withheld] ([number withheld]) |
| S8 | [number withheld] ([number withheld]) | [number withheld] ([number withheld]) | [number withheld] ([number withheld]) | [number withheld] ([number withheld]) | [number withheld] ([number withheld]) |
| S9 | [number withheld] ([number withheld]) | [number withheld] ([number withheld]) | [number withheld] ([number withheld]) | [number withheld] ([number withheld]) | [number withheld] ([number withheld]) |
| S1[number withheld] | [number withheld] ([number withheld]) | [number withheld] ([number withheld]) | [number withheld] ([number withheld]) | [number withheld] ([number withheld]) | [number withheld] ([number withheld]) |
| S1[number withheld] | [number withheld] ([number withheld]) | NA | NA | NA | NA |
| S1[number withheld] | [number withheld] ([number withheld]) | [number withheld] ([number withheld]) | [number withheld] ([number withheld]) | [number withheld] ([number withheld]) | [number withheld] ([number withheld]) |
| S1[number withheld] | [number withheld] ([number withheld]) | [number withheld] ([number withheld]) | [number withheld] ([number withheld]) | [number withheld] ([number withheld]) | übersprungen: [number withheld] Firmen |

S0: `dose_pre`; S1: `dose2[number withheld]`; S2: `dose` [number withheld]; S3: `distance`; S4: Firmentrends; S5: Winsorisierung; S6: balanciertes Panel; S7: breite Stichprobe; S8: `dose_2[number withheld]h1`; S9: ohne Firmen mit fehlenden Vorauszahlungen; S1[number withheld]: ohne abweichendes Geschäftsjahr; S1[number withheld]: alternatives RL1; S1[number withheld]: A-Shares; S1[number withheld]: HK.

## Offene Fragen

Keine blockierende offene Frage. Forschungsfrage, Stichprobe, Filter und Schätzverfahren wurden nicht geändert.

- JV/TA verliert weiterhin **[number withheld]/[number withheld] Beobachtungen**: [number withheld] wegen fehlender JV-Werte, drei durch Singleton-Entfernung. Keine Imputation.
- Parallele kontrafaktische Trends zwischen Treatment-Niveaus bleiben Identifikationsannahme. Der im Review genannte mechanische Zusammenhang zwischen `dose_pre` und den RL1-/RL2-Vorperioden bleibt bestehen.
- PDFs und LaTeX wurden in dieser REWORK-Runde nicht erneut visuell geprüft; sämtliche PDFs sind byte-identisch.
- Die unabhängige erneute Prüfung steht aus. Die temporären Prüfbelege wurden zur Nachvollziehbarkeit aufbewahrt.

Vorschlag für `AI_USAGE_LOG.md`: „Codex behob T012-REWORK: unabhängiger T004-Checksum-Guard, eigenständiger Neuaufbau ohne Aufgaben- oder T003-Ausgabedateien, geschützte Ausgaben bei Bedarf erzeugen und Rundung nach oben. Geprüft durch zwei Projektläufe, zwei temporäre Neuaufbauten, SHA-[number withheld]-Vergleiche, T011-/S0-Assertions und zwei Negativtests.“ Die Logdatei wurde wegen des Schreibbereichs nicht bearbeitet.