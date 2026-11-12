## Ergebnis

T011 wurde umgesetzt: 66 Schätzungen, vier vorgegebene NA-Zellen, Treatment-Zusammenfassungen und vier Event-Study-Abbildungen. S0 reproduziert T009 innerhalb der geforderten Toleranz; keine Stopp-Bedingung trat ein. Die endgültigen CSV- und TEX-Dateien sind nach zwei Läufen byte-identisch.

## Dateien

- `replication/code/04_robustness.R` – reproduzierbare Umsetzung von S0–S13 mit Assertions.
- `replication/outputs/tables/t011_robustness.csv` – vollständige Schätzergebnisse einschließlich SE, KI, p-Werten und Stichprobengrößen.
- `replication/outputs/tables/t011_robustness.tex` – Booktabs-Fragment mit Spezifikationsbeschreibungen.
- `replication/outputs/tables/t011_treatment_definitions.csv` – Verteilungen und Korrelationen der drei Alternativtreatments.
- `replication/outputs/figures/t011_es_rl1_dose2018.pdf` – RL1-Event-Study mit `dose2018`.
- `replication/outputs/figures/t011_es_rl1_distance.pdf` – RL1-Event-Study mit `distance`.
- `replication/outputs/figures/t011_es_mi_share_dose2018.pdf` – Minderheitenanteil-Event-Study mit `dose2018`.
- `replication/outputs/figures/t011_es_mi_share_distance.pdf` – Minderheitenanteil-Event-Study mit `distance`.

## Ausführung

Ausführungsbefehl:

[fenced excerpt withheld in public audit]
[fenced excerpt withheld in public audit]

Die endgültige Skriptfassung wurde zweimal erfolgreich ausgeführt. Letzte Ausgabezeilen:

[fenced excerpt withheld in public audit]
[fenced excerpt withheld in public audit]

SHA-256-Vergleich beider Läufe: alle drei CSV-/TEX-Dateien identisch. Das TEX-Fragment wurde zusätzlich erfolgreich ohne Overfull-/Underfull-Meldungen übersetzt; Tabelle und vier Abbildungen wurden visuell geprüft.

## Abnahmekriterien

1. **Erfüllt.** Zwei erfolgreiche Läufe der endgültigen Fassung; beide CSV-Dateien und das TEX-Fragment byte-identisch.
2. **Erfüllt.** Assertions für alle fünf S0-Outcomes bestanden. Größte absolute Abweichung gegenüber T009: Koeffizient `3,13e-17`, SE `2,78e-16`; gefordert jeweils höchstens `1e-12`.
3. **Erfüllt.** Im Skript genau ein `run_spec()`-Aufruf je Spezifikation; jeder Aufruf beginnt erneut beim Panel und verändert ausschließlich das angegebene Element.
4. **Erfüllt.** Firmenkonstanz aller Treatments durch Assertions geprüft. `dose_pre` liegt zwischen 0 und 3, `distance` zwischen 0 und 19,31927118.
5. **Erfüllt.** Winsorisierung getrennt je Stichtag mit 1./99. Perzentil, Quantiltyp 7. Unabhängig nachgezählte Änderungen: `rl1` 52, `rl2` 52, `rl2_gap` 28, `mi_share` 52, `jv_ta` 26.
6. **Erfüllt.** TEX enthält `\toprule` und `\bottomrule`, keine `\documentclass`; erfolgreiche Probeübersetzung.
7. **Erfüllt.** Vollständige Tabelle unten; SE und Koeffizienten-p-Werte zusätzlich in der CSV.
8. **Erfüllt für die eigenen Dateiänderungen.** Der Projektvergleich zeigt ausschließlich die acht freigegebenen Ergebnisdateien sowie das automatisch fortgeschriebene `tasks/T011_worker.log`. Beide Eingabeprüfsummen aus `review/T011_baseline.sha256` sind unverändert; Kartenstatus nicht bearbeitet.

Spezifikationen: S0 Baseline; S1 `dose2018`; S2 `dose_pre`; S3 `distance`; S4 Firmentrends; S5 Winsorisierung; S6 balanciertes Panel; S7 breite Stichprobe; S8 `dose_2020h1`; S9 ohne Firmen mit `adv_missing`; S10 ohne Firmen mit `fye_flag`; S11 alternatives RL1; S12 A-Shares; S13 HK.

Alle Koeffizienten und Konfidenzintervalle sind in Quoteneinheiten angegeben. Vortrend-p bezeichnet den gemeinsamen Test der sieben Termine vor der Referenz 2020-06-30; S4 ist gemäß Karte NA.

| Spec | Outcome | Koeffizient | 95%-KI | Vortrend-p | N | Firmen |
|---|---|---:|---|---:|---:|---:|
| S0 | rl1 | 0.011016 | [-0.014738, 0.036770] | 0.00315397 | 1575 | 126 |
| S0 | rl2 | -0.008203 | [-0.382422, 0.366015] | 0.235290 | 1544 | 126 |
| S0 | rl2_gap | 0.007320 | [-0.050243, 0.064883] | 0.387946 | 1544 | 126 |
| S0 | mi_share | 0.024786 | [-0.000515, 0.050088] | 0.579684 | 1519 | 124 |
| S0 | jv_ta | 0.001738 | [-0.004548, 0.008024] | 0.453522 | 1251 | 103 |
| S1 | rl1 | -0.007136 | [-0.026228, 0.011955] | 0.126592 | 1562 | 125 |
| S1 | rl2 | -0.202381 | [-0.463543, 0.058781] | 0.547431 | 1532 | 124 |
| S1 | rl2_gap | 0.008926 | [-0.048799, 0.066650] | 0.619781 | 1532 | 124 |
| S1 | mi_share | 0.013421 | [-0.012662, 0.039503] | 0.572706 | 1506 | 123 |
| S1 | jv_ta | 0.003610 | [-0.001547, 0.008766] | 0.300401 | 1251 | 103 |
| S2 | rl1 | -0.014909 | [-0.034838, 0.005019] | 0.118574 | 1544 | 124 |
| S2 | rl2 | -0.283814 | [-0.570381, 0.002754] | 0.0874608 | 1523 | 124 |
| S2 | rl2_gap | 0.010768 | [-0.058971, 0.080507] | 0.521804 | 1523 | 124 |
| S2 | mi_share | 0.021017 | [-0.008112, 0.050146] | 0.557171 | 1484 | 122 |
| S2 | jv_ta | 0.002506 | [-0.003708, 0.008720] | 0.633664 | 1225 | 101 |
| S3 | rl1 | -0.005773 | [-0.011804, 0.000259] | 0.00627013 | 1544 | 124 |
| S3 | rl2 | -0.192640 | [-0.355394, -0.029886] | 6.63411e-05 | 1523 | 124 |
| S3 | rl2_gap | 0.017295 | [-0.033232, 0.067822] | 0.332543 | 1523 | 124 |
| S3 | mi_share | 0.008998 | [-0.003116, 0.021111] | 0.427058 | 1484 | 122 |
| S3 | jv_ta | 0.000422 | [-0.001366, 0.002210] | 0.858644 | 1225 | 101 |
| S4 | rl1 | 0.001463 | [-0.023537, 0.026464] | NA | 1575 | 126 |
| S4 | rl2 | -0.043691 | [-0.431489, 0.344107] | NA | 1544 | 126 |
| S4 | rl2_gap | -0.008254 | [-0.044823, 0.028315] | NA | 1544 | 126 |
| S4 | mi_share | 0.012846 | [-0.007436, 0.033127] | NA | 1519 | 124 |
| S4 | jv_ta | 0.002703 | [-0.001475, 0.006881] | NA | 1251 | 103 |
| S5 | rl1 | 0.002180 | [-0.016497, 0.020856] | 0.00193012 | 1575 | 126 |
| S5 | rl2 | -0.029623 | [-0.318618, 0.259372] | 0.181111 | 1544 | 126 |
| S5 | rl2_gap | -0.007935 | [-0.034653, 0.018784] | 0.393618 | 1544 | 126 |
| S5 | mi_share | 0.026331 | [0.004617, 0.048046] | 0.395978 | 1519 | 124 |
| S5 | jv_ta | 0.002470 | [-0.003021, 0.007961] | 0.451866 | 1251 | 103 |
| S6 | rl1 | 0.008196 | [-0.013625, 0.030017] | 0.0122613 | 1391 | 107 |
| S6 | rl2 | 0.138849 | [-0.264001, 0.541699] | 0.0693804 | 1363 | 107 |
| S6 | rl2_gap | 0.009026 | [-0.057674, 0.075725] | 0.368028 | 1363 | 107 |
| S6 | mi_share | 0.023737 | [-0.003718, 0.051192] | 0.403636 | 1370 | 107 |
| S6 | jv_ta | 0.000816 | [-0.005691, 0.007324] | 0.536743 | 1182 | 94 |
| S7 | rl1 | 0.010211 | [-0.015636, 0.036058] | 0.000122097 | 1936 | 156 |
| S7 | rl2 | 0.063271 | [-0.282461, 0.409003] | 0.219876 | 1877 | 156 |
| S7 | rl2_gap | 0.006702 | [-0.043708, 0.057111] | 0.439272 | 1877 | 156 |
| S7 | mi_share | 0.030563 | [0.007743, 0.053383] | 0.217070 | 1819 | 151 |
| S7 | jv_ta | -0.000095 | [-0.007484, 0.007295] | 0.287106 | 1517 | 127 |
| S8 | rl1 | 0.024820 | [-0.002056, 0.051697] | 0.0315428 | 1544 | 122 |
| S8 | rl2 | 0.368156 | [-0.136726, 0.873039] | 0.487077 | 1514 | 122 |
| S8 | rl2_gap | 0.007722 | [-0.052425, 0.067869] | 0.0858961 | 1514 | 122 |
| S8 | mi_share | 0.061601 | [0.014490, 0.108711] | 0.0793485 | 1495 | 121 |
| S8 | jv_ta | 0.001707 | [-0.003698, 0.007112] | 0.363460 | 1220 | 99 |
| S9 | rl1 | 0.005769 | [-0.015555, 0.027094] | 0.00786078 | 1297 | 102 |
| S9 | rl2 | 0.052453 | [-0.332059, 0.436965] | 0.295281 | 1282 | 102 |
| S9 | rl2_gap | 0.007985 | [-0.053658, 0.069627] | 0.282057 | 1282 | 102 |
| S9 | mi_share | 0.031257 | [0.006697, 0.055817] | 0.535023 | 1269 | 101 |
| S9 | jv_ta | 0.001331 | [-0.005182, 0.007845] | 0.534856 | 1125 | 92 |
| S10 | rl1 | 0.011648 | [-0.014103, 0.037399] | 0.00384059 | 1542 | 123 |
| S10 | rl2 | 0.029847 | [-0.332971, 0.392666] | 0.228340 | 1511 | 123 |
| S10 | rl2_gap | 0.007500 | [-0.050023, 0.065022] | 0.367616 | 1511 | 123 |
| S10 | mi_share | 0.029033 | [0.006073, 0.051994] | 0.538978 | 1493 | 122 |
| S10 | jv_ta | 0.001719 | [-0.004572, 0.008011] | 0.438465 | 1236 | 101 |
| S11 | rl1 | 0.006268 | [-0.018015, 0.030551] | 0.0200404 | 1575 | 126 |
| S11 | rl2 | NA | NA | NA | NA | NA |
| S11 | rl2_gap | NA | NA | NA | NA | NA |
| S11 | mi_share | NA | NA | NA | NA | NA |
| S11 | jv_ta | NA | NA | NA | NA | NA |
| S12 | rl1 | 0.009669 | [-0.014180, 0.033517] | 0.0340289 | 1014 | 78 |
| S12 | rl2 | 0.259329 | [-0.234115, 0.752772] | 0.213038 | 1004 | 78 |
| S12 | rl2_gap | 0.015531 | [-0.068574, 0.099635] | 0.478267 | 1004 | 78 |
| S12 | mi_share | 0.026925 | [-0.004681, 0.058531] | 0.0478846 | 996 | 78 |
| S12 | jv_ta | 0.000123 | [-0.007126, 0.007372] | 0.718522 | 933 | 73 |
| S13 | rl1 | 0.014575 | [-0.054100, 0.083250] | 0.0458703 | 561 | 48 |
| S13 | rl2 | -1.023350 | [-2.147437, 0.100737] | 0.314392 | 540 | 48 |
| S13 | rl2_gap | -0.006789 | [-0.028060, 0.014483] | 0.283099 | 540 | 48 |
| S13 | mi_share | -0.021473 | [-0.124329, 0.081382] | 0.701868 | 523 | 46 |
| S13 | jv_ta | 0.010210 | [0.000666, 0.019755] | 0.309552 | 318 | 30 |

Zusätzlicher S1-Vortrendtest für die vier Termine **streng vor 2018-12-31**: `rl1` 0.166376; `rl2` 0.262438; `rl2_gap` 0.313474; `mi_share` 0.701686; `jv_ta` 0.740609.

## Offene Fragen

Keine blockierende offene Frage. Folgende Auslegungen sind im Skript dokumentiert:

- S1–S3 und S8 ersetzen auch die Anforderung eines nicht fehlenden Treatments; `dose` wird dabei nicht zusätzlich vorausgesetzt.
- Für `distance` werden mindestens drei nicht fehlende Termine je Kennzahl verlangt; jede Kennzahl wird vor Anwendung der Schwellenformel separat gemittelt.
- S5 verwendet die verfügbaren Outcome-Werte innerhalb jedes Stichtags der S0-Stichprobe.
- S9 und S10 schließen Firmen anhand ihrer gesamten vorhandenen Panelhistorie aus.

Die kausale Interpretation setzt parallele kontrafaktische Trends zwischen Treatment-Niveaus voraus; diese Annahme wurde durch die Robustheitsprüfungen nicht nachgewiesen. Eine unabhängige Reviewer-Prüfung steht noch aus.

Vorschlag für den späteren Eintrag in `AI_USAGE_LOG.md`: „Codex implementierte T011 gemäß freigegebener Karte; geprüft durch S0-Assertions gegen T009, zwei byte-identische Läufe, separate numerische Kontrollen sowie visuelle Prüfung der Tabelle und Abbildungen.“ Die Logdatei wurde wegen des begrenzten Schreibbereichs nicht bearbeitet.