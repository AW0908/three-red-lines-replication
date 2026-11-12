## Ergebnis

Die REWORK-Punkte von T012 sind umgesetzt: Fehlende geschützte Ausgaben werden erzeugt, identische Dateien bleiben unangetastet, abweichende führen zum Abbruch. Der Panel-Guard prüft gegen den festen T004-Hash; die T003-Angaben sind eingebettet, und die deskriptiven Gruppen verwenden `floor(dose_pre + 0.5)`. Zwei Projektläufe und zwei Neuaufbauten in einer temporären Kopie waren erfolgreich und lieferten identische Ergebnisse.

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
- `/private/tmp/t012_rework_q5rtdtrt/sha256_comparison.csv` – vollständige SHA-256-Vergleichstabelle aller vier Läufe.
- `/private/tmp/t012_rework_q5rtdtrt/changed_files.json` – festgestellte Projektänderungen.
- `/private/tmp/t012_rework_q5rtdtrt/audit_summary.json` – abschließende Prüfergebnisse.
- `/private/tmp/t012_rework_q5rtdtrt/scratch/replication/` – temporäre Replikationskopie; die 26 erzeugten Dateien stehen in der Vergleichstabelle.

## Ausführung

Vorgeschriebener Befehl, zweimal erfolgreich ausgeführt:

[fenced excerpt withheld in public audit]
[fenced excerpt withheld in public audit]

Letzte Ausgabezeilen:

[fenced excerpt withheld in public audit]
[fenced excerpt withheld in public audit]

Neuaufbau und Prüfungen:

[fenced excerpt withheld in public audit]
[fenced excerpt withheld in public audit]

Vor dem Neuaufbau wurden sämtliche Dateien unter `data/processed/`, `outputs/tables/` und `outputs/figures/` der Kopie gelöscht. `../Daten` wurde im temporären Elternverzeichnis auf die Projekt-Rohdaten verlinkt; dort existiert kein `tasks/`-Verzeichnis.

Prüfausgabe:

[fenced excerpt withheld in public audit]
[fenced excerpt withheld in public audit]

Die erste Schreibbereichskontrolle meldete das automatisch fortgeschriebene `tasks/T012_worker.log` als zusätzliche Änderung. Die abschließende Kontrolle berücksichtigte diesen Laufzeitbeleg ausdrücklich und bestand; andere Änderungen außerhalb des Schreibbereichs wurden nicht gefunden.

## Abnahmekriterien

1. **Erfüllt.** Alle vier Skripte liefen zweimal aus `replication/`. **16/16 Ausgabedateien im Schreibbereich** waren byte-identisch; außerdem blieben sämtliche **44 vorhandenen Ausgaben** zwischen den Projektläufen identisch.
2. **Erfüllt.** Panel: **2.279 Zeilen, 184 Firmen, 86 Spalten**. Die 83 bisherigen Spalten entsprechen bytegenau dem T004-Panel, SHA-256:  
   `b3bf2b5c2b21c215ed7eddbf7eecbfc0d4d8007e4e95bb2d4a1b9c82deaea5f1`.  
   `dose_pre ∈ [0,3]`, `distance ≥ 0` und Firmenkonstanz aller drei ergänzten Treatments wurden geprüft.
3. **Erfüllt.** Alle **70 ursprünglichen T011-Zellen** wurden vor der Umstellung reproduziert, einschließlich Stichprobengrößen und NA-Mustern. Maximale Abweichungen: Koeffizienten **6,66e−16**, Standardfehler **3,61e−16**. Neue S0 gegenüber Haupttabelle: Koeffizienten, Standardfehler und Vortrend-p bestanden die Assertions mit Toleranz `1e-12`.
4. **Erfüllt.** Beide T005-Summary-Dateien, Bunching-CSV und vier T005-PDFs entsprechen den freigegebenen Prüfsummen. Zusammen mit den drei geschützten T004-Tabellen: **10/10 unverändert**, auch ihre Änderungszeiten blieben beim Wiederholungslauf unverändert.
5. **Erfüllt.** Haupt- und Robustheitstabelle folgen unten. `dose_pre` ist für **162 Firmen insgesamt**, darunter **124 Hauptstichprobenfirmen**, verfügbar. Die gerundeten Gruppen enthalten jetzt **31 / 37 / 28 / 28 Firmen**.
6. **Für Worker-Änderungen erfüllt.** Genau vier Projektdateien wurden inhaltlich geändert, alle im Schreibbereich. Einzige zusätzliche Änderung war das automatisch fortgeschriebene `tasks/T012_worker.log`.

**Neuaufbau: SHA-256-Vergleich**

Pfade relativ zu `replication/`. „4/4 gleich“ bedeutet identische SHA-256 in beiden Projektläufen und beiden Läufen der temporären Kopie. Vollständige Hashes stehen in `sha256_comparison.csv`; hier sind die ersten zwölf Zeichen angegeben.

| Datei | SHA-256-Präfix | Vergleich |
|---|---|---|
| `data/processed/panel_firm_halfyear.csv` | `e1a5e2be4647` | 4/4 gleich |
| `outputs/tables/t004_panel_counts.csv` | `a4c4cc8c7e9b` | 4/4 gleich |
| `outputs/tables/t004_item_coverage.csv` | `1998bbe073a6` | 4/4 gleich |
| `outputs/tables/t004_ownership_unresolved.csv` | `db473180f041` | 4/4 gleich |
| `outputs/tables/t004_variable_dictionary.csv` | `33163fafd952` | 4/4 gleich |
| `outputs/tables/t005_summary_stats.csv` | `7049089e40a9` | 4/4 gleich |
| `outputs/tables/t005_summary_stats.tex` | `e3e7e4690c3e` | 4/4 gleich |
| `outputs/tables/t005_by_dose.csv` | `ed615ae7207d` | 4/4 gleich |
| `outputs/tables/t005_by_dose.tex` | `c96980fe9e91` | 4/4 gleich |
| `outputs/tables/t005_bunching_counts.csv` | `9a576142a4f9` | 4/4 gleich |
| `outputs/figures/t005_bunching_rl1.pdf` | `3cd175a43875` | 4/4 gleich |
| `outputs/figures/t005_bunching_rl2.pdf` | `e87754215c51` | 4/4 gleich |
| `outputs/figures/t005_bunching_rl3.pdf` | `5cee6251754e` | 4/4 gleich |
| `outputs/figures/t005_breach_shares.pdf` | `f7d6eecc5080` | 4/4 gleich |
| `outputs/tables/t009_did_main.csv` | `25a55c179fe8` | 4/4 gleich |
| `outputs/tables/t009_did_main.tex` | `ab88d54825e3` | 4/4 gleich |
| `outputs/tables/t009_event_study.csv` | `b7701453ec85` | 4/4 gleich |
| `outputs/tables/t009_pretrend_tests.csv` | `9e30d2700179` | 4/4 gleich |
| `outputs/figures/t009_es_rl1.pdf` | `a213b4782f53` | 4/4 gleich |
| `outputs/figures/t009_es_rl2.pdf` | `9a97532de927` | 4/4 gleich |
| `outputs/figures/t009_es_rl2_gap.pdf` | `ae8dc291ee26` | 4/4 gleich |
| `outputs/figures/t009_es_mi_share.pdf` | `0a36be0a5901` | 4/4 gleich |
| `outputs/figures/t009_es_jv_ta.pdf` | `e5f2bdfd6b99` | 4/4 gleich |
| `outputs/tables/t011_robustness.csv` | `b7f721509e01` | 4/4 gleich |
| `outputs/tables/t011_robustness.tex` | `f30d376f9f5a` | 4/4 gleich |
| `outputs/tables/t011_treatment_definitions.csv` | `0f8f7947a652` | 4/4 gleich |

**Haupttabelle**

Koeffizienten und 95%-Konfidenzintervalle in Quoteneinheiten. Vortrend-p: gemeinsamer Wald-Test der sieben Termine vor der Referenz 2020-06-30.

| Outcome | Koeffizient | 95%-KI | Vortrend-p | N/Firmen |
|---|---:|---|---:|---:|
| rl1 | −0.014909 | [−0.034838, 0.005019] | 0.118574 | 1544/124 |
| rl2 | −0.283814 | [−0.570381, 0.002754] | 0.0874608 | 1523/124 |
| rl2_gap | 0.010768 | [−0.058971, 0.080507] | 0.521804 | 1523/124 |
| mi_share | 0.021017 | [−0.008112, 0.050146] | 0.557171 | 1484/122 |
| jv_ta | 0.002506 | [−0.003708, 0.008720] | 0.633664 | 1225/101 |

**Umgestellte Robustheitstabelle**

Zellen: Koeffizient (firmengeclusterter Standardfehler). Vollständige Konfidenzintervalle, Vortrend-p und Stichprobengrößen stehen in `replication/outputs/tables/t011_robustness.csv`.

| Spec | rl1 | rl2 | rl2_gap | mi_share | jv_ta |
|---|---:|---:|---:|---:|---:|
| S0 | −0.014909 (0.010068) | −0.283814 (0.144772) | 0.010768 (0.035232) | 0.021017 (0.014713) | 0.002506 (0.003132) |
| S1 | −0.007136 (0.009646) | −0.202381 (0.131937) | 0.008926 (0.029162) | 0.013421 (0.013176) | 0.003610 (0.002600) |
| S2 | 0.011016 (0.013013) | −0.008203 (0.189083) | 0.007320 (0.029085) | 0.024786 (0.012782) | 0.001738 (0.003169) |
| S3 | −0.005773 (0.003047) | −0.192640 (0.082222) | 0.017295 (0.025526) | 0.008998 (0.006119) | 0.000422 (0.000901) |
| S4 | −0.009730 (0.007279) | −0.155327 (0.182940) | −0.012778 (0.022584) | 0.007527 (0.010359) | 0.002256 (0.002394) |
| S5 | −0.018932 (0.008519) | −0.237647 (0.116546) | −0.008425 (0.015746) | 0.024605 (0.010907) | 0.002987 (0.002962) |
| S6 | −0.009773 (0.011025) | −0.106813 (0.139802) | 0.013697 (0.042417) | 0.017620 (0.015807) | 0.001389 (0.003242) |
| S7 | −0.025009 (0.015010) | −0.235596 (0.124562) | 0.007338 (0.030578) | 0.032024 (0.012344) | 0.004301 (0.002952) |
| S8 | 0.024820 (0.013576) | 0.368156 (0.255022) | 0.007722 (0.030381) | 0.061601 (0.023794) | 0.001707 (0.002724) |
| S9 | −0.013874 (0.010581) | −0.203729 (0.129223) | 0.012156 (0.037670) | 0.031571 (0.012289) | 0.002300 (0.003233) |
| S10 | −0.013598 (0.010083) | −0.219824 (0.124650) | 0.011462 (0.035223) | 0.028953 (0.011658) | 0.002478 (0.003136) |
| S11 | −0.019770 (0.007566) | NA | NA | NA | NA |
| S12 | −0.012781 (0.010408) | 0.008996 (0.156468) | 0.022493 (0.053834) | 0.025617 (0.016431) | 0.001208 (0.003615) |
| S13 | −0.024310 (0.022333) | −1.257841 (0.651869) | −0.007257 (0.011873) | −0.044631 (0.071751) | übersprungen: 29 Firmen |

S0: `dose_pre`; S1: `dose2018`; S2: `dose` 2019; S3: `distance`; S4: Firmentrends; S5: Winsorisierung; S6: balanciertes Panel; S7: breite Stichprobe; S8: `dose_2020h1`; S9: ohne Firmen mit fehlenden Vorauszahlungen; S10: ohne abweichendes Geschäftsjahr; S11: alternatives RL1; S12: A-Shares; S13: HK.

## Offene Fragen

Keine blockierende offene Frage. Forschungsfrage, Stichprobe, Filter und Schätzverfahren wurden nicht geändert.

- JV/TA verliert weiterhin **320/1.545 Beobachtungen**: 317 wegen fehlender JV-Werte, drei durch Singleton-Entfernung. Keine Imputation.
- Parallele kontrafaktische Trends zwischen Treatment-Niveaus bleiben Identifikationsannahme. Der im Review genannte mechanische Zusammenhang zwischen `dose_pre` und den RL1-/RL2-Vorperioden bleibt bestehen.
- PDFs und LaTeX wurden in dieser REWORK-Runde nicht erneut visuell geprüft; sämtliche PDFs sind byte-identisch.
- Die unabhängige erneute Prüfung steht aus. Die temporären Prüfbelege wurden zur Nachvollziehbarkeit aufbewahrt.

Vorschlag für `AI_USAGE_LOG.md`: „Codex behob T012-REWORK: unabhängiger T004-Checksum-Guard, eigenständiger Neuaufbau ohne Aufgaben- oder T003-Ausgabedateien, geschützte Ausgaben bei Bedarf erzeugen und Rundung nach oben. Geprüft durch zwei Projektläufe, zwei temporäre Neuaufbauten, SHA-256-Vergleiche, T011-/S0-Assertions und zwei Negativtests.“ Die Logdatei wurde wegen des Schreibbereichs nicht bearbeitet.