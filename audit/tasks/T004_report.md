## Ergebnis

Die Perpetual-Korrektur wurde umgesetzt: Bei vorhandener Bilanzsumme und vollständig fehlenden Perpetual-Posten werden `perp` und `perp_mi` null gesetzt und durch `perp_missing` markiert. Das Panel enthält weiterhin **2.279 Finanzzeilen und 184 Firmen**, jetzt mit **83 Spalten**; sämtliche Werte der 77 nicht betroffenen Spalten sind unverändert. Zwei Wiederholungsläufe erzeugten byte-identische Ausgaben.

## Dateien

- `replication/code/01_clean.R` – Nullsetzung, Flag, Wörterbuchdefinitionen und Prüfungen ergänzt.
- `replication/data/processed/panel_firm_halfyear.csv` – korrigiertes Panel.
- `replication/outputs/tables/t004_panel_counts.csv` – aktualisierte NA- und Nennerzählungen.
- `replication/outputs/tables/t004_item_coverage.csv` – aktualisierte Abdeckung nach Nullsetzung.
- `replication/outputs/tables/t004_ownership_unresolved.csv` – erneut erzeugt, inhaltlich und byteweise unverändert; 66 Registerfirmen.
- `replication/outputs/tables/t004_variable_dictionary.csv` – Definitionen aller 83 Panelspalten.

## Ausführung

Exakter Befehl, zweimal ausgeführt:

[fenced excerpt withheld in public audit]
[fenced excerpt withheld in public audit]

Beide Läufe endeten mit Exit-Code 0 und diesen letzten Zeilen:

[fenced excerpt withheld in public audit]
[fenced excerpt withheld in public audit]

SHA-256-Prüfsummen waren zwischen beiden Läufen für alle fünf Ausgaben identisch:

| Ausgabe | SHA-256 |
|---|---|
| Panel | `b3bf2b5c2b21c215ed7eddbf7eecbfc0d4d8007e4e95bb2d4a1b9c82deaea5f1` |
| Panel counts | `a4c4cc8c7e9bd056db3977ece29f2ce9c7a88660cbe040224b7235c64759be2b` |
| Item coverage | `1998bbe073a60883f2ed121f416df2a951b5669006790c639de0ba4ccdc088e2` |
| Ownership unresolved | `db473180f041c9a5a255fc1d6cf9b090835cdc0ea7334cb6640343822d2743c9` |
| Variable dictionary | `9c787de0130d96941c3e11c73a919975fb00d597117e044ca575cc03a4d9cbb1` |

Eine separate R-Prüfung der gespeicherten CSV bestätigte zusätzlich Formeln, Baseline-Zuordnung, Flags, Zählungen, Abdeckung und Wörterbuch:

[fenced excerpt withheld in public audit]
[fenced excerpt withheld in public audit]

## Abnahmekriterien

1. **Erfüllt:** Zwei fehlerfreie Läufe; alle fünf Ausgaben byte-identisch.

2. **Erfüllt:** 2.279 eindeutige Schlüssel `firm_id × date`, keine Duplikate, ausschließlich die 13 Zielstichtage.

[firm-specific excerpt withheld in public audit]

4. **Erfüllt:** Die Zufallsziehung mit Seed `20261016` ergab:

   | Firma | Datum |
   |---|---|
[firm-specific excerpt withheld in public audit]
[firm-specific excerpt withheld in public audit]
[firm-specific excerpt withheld in public audit]
[firm-specific excerpt withheld in public audit]
[firm-specific excerpt withheld in public audit]
[firm-specific excerpt withheld in public audit]
[firm-specific excerpt withheld in public audit]
[firm-specific excerpt withheld in public audit]
[firm-specific excerpt withheld in public audit]
[firm-specific excerpt withheld in public audit]

   Aus den gespeicherten Itemspalten nachgerechnet, einschließlich `ibd` aus `std` und `ltd`: maximale Abweichungen der zehn Zeilen `rl1 = 3,33e-16`, `rl2 = 1,33e-15`, `rl3 = 2,96e-12`; damit jeweils unter `1e-9`. Auch über alle Panelzeilen bestehen die Formelprüfungen.

5. **Erfüllt:** `n_breached` ausschließlich 0–3 oder NA. Beide Dosisvariablen sind firmenkonstant und entsprechen den vorgesehenen Baselinestichtagen; `post` entspricht exakt `date ≥ 2020-12-31`.

6. **Erfüllt:** Alle 1.272 A-Share-Zeilen haben `rl3_upper_bound = TRUE`. Bei allen 628 Zeilen mit vorhandenem `rcash` ist das Flag FALSE.

7. **Erfüllt:** Die abschließenden Zählungen in `t004_panel_counts.csv` stimmen mit dem Panel überein:

   | Markt | Status | Alle Zeilen | Broad | Main |
   |---|---|---:|---:|---:|
   | A | listed | 1.077 | 960 | 845 |
   | A | delisted | 195 | 195 | 195 |
   | HK | listed | 422 | 422 | 372 |
   | HK | delisted | 585 | 547 | 280 |
   | **Gesamt** | | **2.279** | **2.124** | **1.692** |

   Weiterhin 1.880 EastMoney- und 399 Wind-Zeilen; 373 Registerperioden ohne Finanzzeile werden ausschließlich gezählt.

   | Kennzahl | NA | Nenner ≤ 0 |
   |---|---:|---:|
   | `rl1` | 2 | 0 |
   | `rl1_alt` | 2 | 0 |
   | `rl2` | 254 | 31 |
   | `rl2_adj` | 254 | 31 |
   | `rl3` | 269 | 0 |

   Die Korrektur setzt in **1.984 Zeilen** beide Perpetual-Variablen null. Komponentenzählungen behalten die ursprüngliche Missingness.

   | Variable | Vorher vorhanden | Jetzt vorhanden |
   |---|---:|---:|
   | `perp` | 293 | 2.277 |
   | `perp_mi` | 0 | 1.984 |
   | `rl2_adj` | 293 | 2.025 |
   | `rl2_gap` | 293 | 2.025 |
   | `perp_te` | 293 | 2.246 |

8. **Erfüllt:** Firmenzahlen und Eigentümerabdeckung:

   | Markt | Status | Register main/broad | Panel main/broad | SOE bekannt, Panel broad |
   |---|---|---:|---:|---:|
   | A | listed | 69 / 85 | 65 / 74 | 65 / 74 |
   | A | delisted | 15 / 15 | 15 / 15 | 11 / 15 |
   | HK | listed | 29 / 33 | 29 / 33 | 26 / 33 |
   | HK | delisted | 28 / 51 | 27 / 50 | 7 / 50 |

   Im Panel: **136 Main- und 172 Broad-Firmen**; SOE bekannt für **109/172 = 63,37 %** der breiten Stichprobe. Im Register: 141 Main- und 184 Broad-Firmen; SOE bekannt für 118/184 = 64,13 %.

   Dosisverteilung nach Firmen; „ohne `adv_missing`“ entfernt Firmen mit mindestens einer betroffenen vorhandenen Panelperiode:

   | Stichprobe | dose 0 | 1 | 2 | 3 | NA |
   |---|---:|---:|---:|---:|---:|
   | main | 41 | 38 | 15 | 32 | 10 |
   | main ohne `adv_missing` | 37 | 27 | 11 | 27 | 6 |
   | broad | 52 | 49 | 17 | 38 | 16 |
   | broad ohne `adv_missing` | 42 | 34 | 13 | 30 | 8 |

   Abdeckung der Red-Line-Posten in `sample_main`, jeweils vorhandene Werte / Finanzzeilen:

   | Markt / Quelle | `ta`, `tl`, `te`, jeweils | `cash` | `std` | `ltd` | `adv` vor Nullsetzung |
   |---|---:|---:|---:|---:|---:|
   | A / EastMoney | 845/845 | 845/845 | 812/845 | 795/845 | 845/845 |
   | A / Wind | 195/195 | 195/195 | 185/195 | 160/195 | 185/195 |
   | HK / EastMoney | 517/517 | 425/517 | 516/517 | 511/517 | 445/517 |
   | HK / Wind | 134/135 | 134/135 | 129/135 | 118/135 | 65/135 |

   `rcash` ist bei A vollständig fehlend; bei HK-EastMoney in 435/517 und bei HK-Wind in 36/135 Hauptstichprobenzeilen vorhanden. Die Abdeckungstabelle enthält 160 geprüfte Item-Markt-Quellen-Stichproben-Kombinationen; Perpetual-Abdeckung wird dort nach Nullsetzung ausgewiesen.

   `adv_missing` über alle vorhandenen Finanzzeilen:

   | Markt / Quelle | Fehlend / Zeilen | Anteil |
   |---|---:|---:|
   | A / EastMoney | 0/1.077 | 0,00 % |
   | A / Wind | 10/195 | 5,13 % |
   | HK / EastMoney | 187/803 | 23,29 % |
   | HK / Wind | 136/204 | 66,67 % |

   Vollständige Namenspräzisierungen gegenüber der ursprünglichen Schritt-4-Tabelle, gemäß Co-PI:

   - HK `te`: `总权益` statt `股东权益`.
   - HK `std`: `短期贷款 + 应付票据`.
   - HK `ltd`: `长期贷款 + 应付票据(非流动) + 应付债券 + 可转换票据及债券 + 可转换债券及票据`.
   - HK `lease`: `融资租赁负债(流动) + 融资租赁负债(非流动)`; kein eigener HK-`notes`-Posten.
   - HK `inv`: `存货 + 发展中及待售物业`.
   - HK-Einkommensposten: `营业额`, `除税后溢利`, `少数股东损益`, `应占联营公司溢利 + 应占合营公司溢利`.
   - A-EastMoney `jv_inc`: `INVEST_JOINT_INCOME`.

   Keine weiteren Namensersetzungen; alle zugeordneten HK-Bilanznamen stehen im T003-Katalog und alle zugeordneten Wind-Namen existieren.

9. **Nicht vollständig erfüllt:** Alle **7.313 regulären Dateien unter `Daten/`** und die vier dortigen Symlink-Ziele sind unverändert. Der identische Start-/Endwert des SHA-256-Manifests über sortierte `Pfad\0Datei-SHA256\n`-Einträge lautet:

[fenced excerpt withheld in public audit]
[fenced excerpt withheld in public audit]

   Außerhalb des Schreibbereichs änderte sich während des Laufs jedoch die projektweite `.DS_Store`; sie wurde vom Worker nicht bearbeitet, die Ursache wurde nicht festgestellt. Alle übrigen verglichenen Projektdateien außerhalb des Schreibbereichs blieben unverändert, einschließlich Aufgabenkarte und Status; automatisch geführter Bericht und Worker-Log waren vom Vergleich ausgenommen.

## Offene Fragen

[firm-specific excerpt withheld in public audit]

**Cash:** In der HK-Hauptstichprobe fehlen Cash-Werte weiterhin in 93/652 Finanzzeilen: 92 EastMoney und eine Wind. Die 92 EastMoney-Fälle sind:

| Firma | Anzahl | Panelstichtage |
|---|---:|---|
[firm-specific excerpt withheld in public audit]
[firm-specific excerpt withheld in public audit]
[firm-specific excerpt withheld in public audit]
[firm-specific excerpt withheld in public audit]
[firm-specific excerpt withheld in public audit]
[firm-specific excerpt withheld in public audit]
[firm-specific excerpt withheld in public audit]
[firm-specific excerpt withheld in public audit]
[firm-specific excerpt withheld in public audit]
[firm-specific excerpt withheld in public audit]

Der T003-Posten `短期存款` ist bei allen 92 Fällen vorhanden; `中长期存款` bei sechs und `受限制存款及现金` bei 81. `现金及等价物(非流动)` ist dort nie vorhanden. Gemäß Karte erfolgte keine Substitution. Insgesamt fehlen HK-EastMoney-Cash-Werte in 118 Panelzeilen, davon 26 außerhalb der Hauptstichprobe.

**Weitere Grenzen:** HK-Währungen bleiben `reported`; A-Restricted-Cash und manuelle Eigentümerkodierung bleiben offen. Die RL1-Formel bleibt `[unverified]`. Die HK-Bilanzzählung beträgt weiterhin 803 statt 804 Schlüssel; Differenz −1 ist dokumentiert. Mangels überlappender EastMoney-/Wind-Finanzzeilen war kein numerischer Quellenvergleich möglich.

Die Pakete meldeten, unter R 4.6.1 gebaut worden zu sein; beide Panel-Läufe und die abschließende CSV-Prüfung liefen erfolgreich. Die Ursache der `.DS_Store`-Änderung bleibt ungeklärt.

KI-Protokollvorschlag für den Co-PI: „T004: Codex ergänzte die freigegebene Perpetual-Nullsetzung samt Missingness-Flag, aktualisierte Panel und Prüftabellen und bestätigte zwei byte-identische Wiederholungsläufe. Formeln, unveränderte Panelspalten, Zählungen und Rohdatenintegrität wurden geprüft; eine externe `.DS_Store`-Änderung wurde dokumentiert.“