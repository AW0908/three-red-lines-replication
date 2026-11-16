## Ergebnis

T011 wurde umgesetzt: [number withheld] Schätzungen, vier vorgegebene NA-Zellen, Treatment-Zusammenfassungen und vier Event-Study-Abbildungen. S0 reproduziert T009 innerhalb der geforderten Toleranz; keine Stopp-Bedingung trat ein. Die endgültigen CSV- und TEX-Dateien sind nach zwei Läufen byte-identisch.

## Dateien

- `replication/code/04_robustness.R` – reproduzierbare Umsetzung von S0–S1[number withheld] mit Assertions.
- `replication/outputs/tables/t011_robustness.csv` – vollständige Schätzergebnisse einschließlich SE, KI, p-Werten und Stichprobengrößen.
- `replication/outputs/tables/t011_robustness.tex` – Booktabs-Fragment mit Spezifikationsbeschreibungen.
- `replication/outputs/tables/t011_treatment_definitions.csv` – Verteilungen und Korrelationen der drei Alternativtreatments.
- `replication/outputs/figures/t011_es_rl1_dose2018.pdf` – RL1-Event-Study mit `dose2[number withheld]`.
- `replication/outputs/figures/t011_es_rl1_distance.pdf` – RL1-Event-Study mit `distance`.
- `replication/outputs/figures/t011_es_mi_share_dose2018.pdf` – Minderheitenanteil-Event-Study mit `dose2[number withheld]`.
- `replication/outputs/figures/t011_es_mi_share_distance.pdf` – Minderheitenanteil-Event-Study mit `distance`.

## Ausführung

Ausführungsbefehl:

[fenced excerpt withheld in public process copy]
[fenced excerpt withheld in public process copy]

Die endgültige Skriptfassung wurde zweimal erfolgreich ausgeführt. Letzte Ausgabezeilen:

[fenced excerpt withheld in public process copy]
[fenced excerpt withheld in public process copy]

SHA-[number withheld]-Vergleich beider Läufe: alle drei CSV-/TEX-Dateien identisch. Das TEX-Fragment wurde zusätzlich erfolgreich ohne Overfull-/Underfull-Meldungen übersetzt; Tabelle und vier Abbildungen wurden visuell geprüft.

## Abnahmekriterien

[number withheld]. **Erfüllt.** Zwei erfolgreiche Läufe der endgültigen Fassung; beide CSV-Dateien und das TEX-Fragment byte-identisch.
[number withheld]. **Erfüllt.** Assertions für alle fünf S0-Outcomes bestanden. Größte absolute Abweichung gegenüber T009: Koeffizient `[number withheld]`, SE `[number withheld]`; gefordert jeweils höchstens `[number withheld]`.
[number withheld]. **Erfüllt.** Im Skript genau ein `run_spec()`-Aufruf je Spezifikation; jeder Aufruf beginnt erneut beim Panel und verändert ausschließlich das angegebene Element.
[number withheld]. **Erfüllt.** Firmenkonstanz aller Treatments durch Assertions geprüft. `dose_pre` liegt zwischen [number withheld] und [number withheld], `distance` zwischen [number withheld] und [number withheld].
[number withheld]. **Erfüllt.** Winsorisierung getrennt je Stichtag mit [number withheld]./[number withheld]. Perzentil, Quantiltyp [number withheld]. Unabhängig nachgezählte Änderungen: `rl1` [number withheld], `rl2` [number withheld], `rl2_gap` [number withheld], `mi_share` [number withheld], `jv_ta` [number withheld].
[number withheld]. **Erfüllt.** TEX enthält `\toprule` und `\bottomrule`, keine `\documentclass`; erfolgreiche Probeübersetzung.
[number withheld]. **Erfüllt.** Vollständige Tabelle unten; SE und Koeffizienten-p-Werte zusätzlich in der CSV.
[number withheld]. **Erfüllt für die eigenen Dateiänderungen.** Der Projektvergleich zeigt ausschließlich die acht freigegebenen Ergebnisdateien sowie das automatisch fortgeschriebene `tasks/T011_worker.log`. Beide Eingabeprüfsummen aus `review/T011_baseline.sha256` sind unverändert; Kartenstatus nicht bearbeitet.

Spezifikationen: S0 Baseline; S1 `dose2[number withheld]`; S2 `dose_pre`; S3 `distance`; S4 Firmentrends; S5 Winsorisierung; S6 balanciertes Panel; S7 breite Stichprobe; S8 `dose_2[number withheld]h1`; S9 ohne Firmen mit `adv_missing`; S1[number withheld] ohne Firmen mit `fye_flag`; S1[number withheld] alternatives RL1; S1[number withheld] A-Shares; S1[number withheld] HK.

Alle Koeffizienten und Konfidenzintervalle sind in Quoteneinheiten angegeben. Vortrend-p bezeichnet den gemeinsamen Test der sieben Termine vor der Referenz 2020-06-30; S4 ist gemäß Karte NA.

| Spec | Outcome | Koeffizient | [number withheld]%-KI | Vortrend-p | N | Firmen |
|---|---|---:|---|---:|---:|---:|
| S0 | rl1 | [number withheld] | [[number withheld], [number withheld]] | [number withheld] | [number withheld] | [number withheld] |
| S0 | rl2 | [number withheld] | [[number withheld], [number withheld]] | [number withheld] | [number withheld] | [number withheld] |
| S0 | rl2_gap | [number withheld] | [[number withheld], [number withheld]] | [number withheld] | [number withheld] | [number withheld] |
| S0 | mi_share | [number withheld] | [[number withheld], [number withheld]] | [number withheld] | [number withheld] | [number withheld] |
| S0 | jv_ta | [number withheld] | [[number withheld], [number withheld]] | [number withheld] | [number withheld] | [number withheld] |
| S1 | rl1 | [number withheld] | [[number withheld], [number withheld]] | [number withheld] | [number withheld] | [number withheld] |
| S1 | rl2 | [number withheld] | [[number withheld], [number withheld]] | [number withheld] | [number withheld] | [number withheld] |
| S1 | rl2_gap | [number withheld] | [[number withheld], [number withheld]] | [number withheld] | [number withheld] | [number withheld] |
| S1 | mi_share | [number withheld] | [[number withheld], [number withheld]] | [number withheld] | [number withheld] | [number withheld] |
| S1 | jv_ta | [number withheld] | [[number withheld], [number withheld]] | [number withheld] | [number withheld] | [number withheld] |
| S2 | rl1 | [number withheld] | [[number withheld], [number withheld]] | [number withheld] | [number withheld] | [number withheld] |
| S2 | rl2 | [number withheld] | [[number withheld], [number withheld]] | [number withheld] | [number withheld] | [number withheld] |
| S2 | rl2_gap | [number withheld] | [[number withheld], [number withheld]] | [number withheld] | [number withheld] | [number withheld] |
| S2 | mi_share | [number withheld] | [[number withheld], [number withheld]] | [number withheld] | [number withheld] | [number withheld] |
| S2 | jv_ta | [number withheld] | [[number withheld], [number withheld]] | [number withheld] | [number withheld] | [number withheld] |
| S3 | rl1 | [number withheld] | [[number withheld], [number withheld]] | [number withheld] | [number withheld] | [number withheld] |
| S3 | rl2 | [number withheld] | [[number withheld], [number withheld]] | [number withheld] | [number withheld] | [number withheld] |
| S3 | rl2_gap | [number withheld] | [[number withheld], [number withheld]] | [number withheld] | [number withheld] | [number withheld] |
| S3 | mi_share | [number withheld] | [[number withheld], [number withheld]] | [number withheld] | [number withheld] | [number withheld] |
| S3 | jv_ta | [number withheld] | [[number withheld], [number withheld]] | [number withheld] | [number withheld] | [number withheld] |
| S4 | rl1 | [number withheld] | [[number withheld], [number withheld]] | NA | [number withheld] | [number withheld] |
| S4 | rl2 | [number withheld] | [[number withheld], [number withheld]] | NA | [number withheld] | [number withheld] |
| S4 | rl2_gap | [number withheld] | [[number withheld], [number withheld]] | NA | [number withheld] | [number withheld] |
| S4 | mi_share | [number withheld] | [[number withheld], [number withheld]] | NA | [number withheld] | [number withheld] |
| S4 | jv_ta | [number withheld] | [[number withheld], [number withheld]] | NA | [number withheld] | [number withheld] |
| S5 | rl1 | [number withheld] | [[number withheld], [number withheld]] | [number withheld] | [number withheld] | [number withheld] |
| S5 | rl2 | [number withheld] | [[number withheld], [number withheld]] | [number withheld] | [number withheld] | [number withheld] |
| S5 | rl2_gap | [number withheld] | [[number withheld], [number withheld]] | [number withheld] | [number withheld] | [number withheld] |
| S5 | mi_share | [number withheld] | [[number withheld], [number withheld]] | [number withheld] | [number withheld] | [number withheld] |
| S5 | jv_ta | [number withheld] | [[number withheld], [number withheld]] | [number withheld] | [number withheld] | [number withheld] |
| S6 | rl1 | [number withheld] | [[number withheld], [number withheld]] | [number withheld] | [number withheld] | [number withheld] |
| S6 | rl2 | [number withheld] | [[number withheld], [number withheld]] | [number withheld] | [number withheld] | [number withheld] |
| S6 | rl2_gap | [number withheld] | [[number withheld], [number withheld]] | [number withheld] | [number withheld] | [number withheld] |
| S6 | mi_share | [number withheld] | [[number withheld], [number withheld]] | [number withheld] | [number withheld] | [number withheld] |
| S6 | jv_ta | [number withheld] | [[number withheld], [number withheld]] | [number withheld] | [number withheld] | [number withheld] |
| S7 | rl1 | [number withheld] | [[number withheld], [number withheld]] | [number withheld] | [number withheld] | [number withheld] |
| S7 | rl2 | [number withheld] | [[number withheld], [number withheld]] | [number withheld] | [number withheld] | [number withheld] |
| S7 | rl2_gap | [number withheld] | [[number withheld], [number withheld]] | [number withheld] | [number withheld] | [number withheld] |
| S7 | mi_share | [number withheld] | [[number withheld], [number withheld]] | [number withheld] | [number withheld] | [number withheld] |
| S7 | jv_ta | [number withheld] | [[number withheld], [number withheld]] | [number withheld] | [number withheld] | [number withheld] |
| S8 | rl1 | [number withheld] | [[number withheld], [number withheld]] | [number withheld] | [number withheld] | [number withheld] |
| S8 | rl2 | [number withheld] | [[number withheld], [number withheld]] | [number withheld] | [number withheld] | [number withheld] |
| S8 | rl2_gap | [number withheld] | [[number withheld], [number withheld]] | [number withheld] | [number withheld] | [number withheld] |
| S8 | mi_share | [number withheld] | [[number withheld], [number withheld]] | [number withheld] | [number withheld] | [number withheld] |
| S8 | jv_ta | [number withheld] | [[number withheld], [number withheld]] | [number withheld] | [number withheld] | [number withheld] |
| S9 | rl1 | [number withheld] | [[number withheld], [number withheld]] | [number withheld] | [number withheld] | [number withheld] |
| S9 | rl2 | [number withheld] | [[number withheld], [number withheld]] | [number withheld] | [number withheld] | [number withheld] |
| S9 | rl2_gap | [number withheld] | [[number withheld], [number withheld]] | [number withheld] | [number withheld] | [number withheld] |
| S9 | mi_share | [number withheld] | [[number withheld], [number withheld]] | [number withheld] | [number withheld] | [number withheld] |
| S9 | jv_ta | [number withheld] | [[number withheld], [number withheld]] | [number withheld] | [number withheld] | [number withheld] |
| S1[number withheld] | rl1 | [number withheld] | [[number withheld], [number withheld]] | [number withheld] | [number withheld] | [number withheld] |
| S1[number withheld] | rl2 | [number withheld] | [[number withheld], [number withheld]] | [number withheld] | [number withheld] | [number withheld] |
| S1[number withheld] | rl2_gap | [number withheld] | [[number withheld], [number withheld]] | [number withheld] | [number withheld] | [number withheld] |
| S1[number withheld] | mi_share | [number withheld] | [[number withheld], [number withheld]] | [number withheld] | [number withheld] | [number withheld] |
| S1[number withheld] | jv_ta | [number withheld] | [[number withheld], [number withheld]] | [number withheld] | [number withheld] | [number withheld] |
| S1[number withheld] | rl1 | [number withheld] | [[number withheld], [number withheld]] | [number withheld] | [number withheld] | [number withheld] |
| S1[number withheld] | rl2 | NA | NA | NA | NA | NA |
| S1[number withheld] | rl2_gap | NA | NA | NA | NA | NA |
| S1[number withheld] | mi_share | NA | NA | NA | NA | NA |
| S1[number withheld] | jv_ta | NA | NA | NA | NA | NA |
| S1[number withheld] | rl1 | [number withheld] | [[number withheld], [number withheld]] | [number withheld] | [number withheld] | [number withheld] |
| S1[number withheld] | rl2 | [number withheld] | [[number withheld], [number withheld]] | [number withheld] | [number withheld] | [number withheld] |
| S1[number withheld] | rl2_gap | [number withheld] | [[number withheld], [number withheld]] | [number withheld] | [number withheld] | [number withheld] |
| S1[number withheld] | mi_share | [number withheld] | [[number withheld], [number withheld]] | [number withheld] | [number withheld] | [number withheld] |
| S1[number withheld] | jv_ta | [number withheld] | [[number withheld], [number withheld]] | [number withheld] | [number withheld] | [number withheld] |
| S1[number withheld] | rl1 | [number withheld] | [[number withheld], [number withheld]] | [number withheld] | [number withheld] | [number withheld] |
| S1[number withheld] | rl2 | [number withheld] | [[number withheld], [number withheld]] | [number withheld] | [number withheld] | [number withheld] |
| S1[number withheld] | rl2_gap | [number withheld] | [[number withheld], [number withheld]] | [number withheld] | [number withheld] | [number withheld] |
| S1[number withheld] | mi_share | [number withheld] | [[number withheld], [number withheld]] | [number withheld] | [number withheld] | [number withheld] |
| S1[number withheld] | jv_ta | [number withheld] | [[number withheld], [number withheld]] | [number withheld] | [number withheld] | [number withheld] |

Zusätzlicher S1-Vortrendtest für die vier Termine **streng vor 2018-12-31**: `rl1` [number withheld]; `rl2` [number withheld]; `rl2_gap` [number withheld]; `mi_share` [number withheld]; `jv_ta` [number withheld].

## Offene Fragen

Keine blockierende offene Frage. Folgende Auslegungen sind im Skript dokumentiert:

- S1–S3 und S8 ersetzen auch die Anforderung eines nicht fehlenden Treatments; `dose` wird dabei nicht zusätzlich vorausgesetzt.
- Für `distance` werden mindestens drei nicht fehlende Termine je Kennzahl verlangt; jede Kennzahl wird vor Anwendung der Schwellenformel separat gemittelt.
- S5 verwendet die verfügbaren Outcome-Werte innerhalb jedes Stichtags der S0-Stichprobe.
- S9 und S1[number withheld] schließen Firmen anhand ihrer gesamten vorhandenen Panelhistorie aus.

Die kausale Interpretation setzt parallele kontrafaktische Trends zwischen Treatment-Niveaus voraus; diese Annahme wurde durch die Robustheitsprüfungen nicht nachgewiesen. Eine unabhängige Reviewer-Prüfung steht noch aus.

Vorschlag für den späteren Eintrag in `AI_USAGE_LOG.md`: „Codex implementierte T011 gemäß freigegebener Karte; geprüft durch S0-Assertions gegen T009, zwei byte-identische Läufe, separate numerische Kontrollen sowie visuelle Prüfung der Tabelle und Abbildungen.“ Die Logdatei wurde wegen des begrenzten Schreibbereichs nicht bearbeitet.