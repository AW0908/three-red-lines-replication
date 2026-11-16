## Ergebnis

Die Perpetual-Korrektur wurde umgesetzt: Bei vorhandener Bilanzsumme und vollständig fehlenden Perpetual-Posten werden `perp` und `perp_mi` null gesetzt und durch `perp_missing` markiert. Das Panel enthält weiterhin **[number withheld] Finanzzeilen und [number withheld] Firmen**, jetzt mit **[number withheld] Spalten**; sämtliche Werte der [number withheld] nicht betroffenen Spalten sind unverändert. Zwei Wiederholungsläufe erzeugten byte-identische Ausgaben.

## Dateien

- `replication/code/01_clean.R` – Nullsetzung, Flag, Wörterbuchdefinitionen und Prüfungen ergänzt.
- `replication/data/processed/panel_firm_halfyear.csv` – korrigiertes Panel.
- `replication/outputs/tables/t004_panel_counts.csv` – aktualisierte NA- und Nennerzählungen.
- `replication/outputs/tables/t004_item_coverage.csv` – aktualisierte Abdeckung nach Nullsetzung.
- `replication/outputs/tables/t004_ownership_unresolved.csv` – erneut erzeugt, inhaltlich und byteweise unverändert; [number withheld] Registerfirmen.
- `replication/outputs/tables/t004_variable_dictionary.csv` – Definitionen aller [number withheld] Panelspalten.

## Ausführung

Exakter Befehl, zweimal ausgeführt:

[fenced excerpt withheld in public process copy]
[fenced excerpt withheld in public process copy]

Beide Läufe endeten mit Exit-Code [number withheld] und diesen letzten Zeilen:

[fenced excerpt withheld in public process copy]
[fenced excerpt withheld in public process copy]

SHA-[number withheld]-Prüfsummen waren zwischen beiden Läufen für alle fünf Ausgaben identisch:

| Ausgabe | SHA-[number withheld] |
|---|---|
| Panel | `b3bf2b5c2b21c215ed7eddbf7eecbfc0d4d8007e4e95bb2d4a1b9c82deaea5f1` |
| Panel counts | `a4c4cc8c7e9bd056db3977ece29f2ce9c7a88660cbe040224b7235c64759be2b` |
| Item coverage | `1998bbe073a60883f2ed121f416df2a951b5669006790c639de0ba4ccdc088e2` |
| Ownership unresolved | `db473180f041c9a5a255fc1d6cf9b090835cdc0ea7334cb6640343822d2743c9` |
| Variable dictionary | `9c787de0130d96941c3e11c73a919975fb00d597117e044ca575cc03a4d9cbb1` |

Eine separate R-Prüfung der gespeicherten CSV bestätigte zusätzlich Formeln, Baseline-Zuordnung, Flags, Zählungen, Abdeckung und Wörterbuch:

[fenced excerpt withheld in public process copy]
[fenced excerpt withheld in public process copy]

## Abnahmekriterien

[number withheld]. **Erfüllt:** Zwei fehlerfreie Läufe; alle fünf Ausgaben byte-identisch.

[number withheld]. **Erfüllt:** [number withheld] eindeutige Schlüssel `firm_id × date`, keine Duplikate, ausschließlich die [number withheld] Zielstichtage.

[firm-specific excerpt withheld in public process copy]

[number withheld]. **Erfüllt:** Die Zufallsziehung mit Seed `[number withheld]` ergab:

   | Firma | Datum |
   |---|---|
[firm-specific excerpt withheld in public process copy]
[firm-specific excerpt withheld in public process copy]
[firm-specific excerpt withheld in public process copy]
[firm-specific excerpt withheld in public process copy]
[firm-specific excerpt withheld in public process copy]
[firm-specific excerpt withheld in public process copy]
[firm-specific excerpt withheld in public process copy]
[firm-specific excerpt withheld in public process copy]
[firm-specific excerpt withheld in public process copy]
[firm-specific excerpt withheld in public process copy]

   Aus den gespeicherten Itemspalten nachgerechnet, einschließlich `ibd` aus `std` und `ltd`: maximale Abweichungen der zehn Zeilen `rl1 = [number withheld]`, `rl2 = [number withheld]`, `rl3 = [number withheld]`; damit jeweils unter `[number withheld]`. Auch über alle Panelzeilen bestehen die Formelprüfungen.

[number withheld]. **Erfüllt:** `n_breached` ausschließlich [number withheld]–[number withheld] oder NA. Beide Dosisvariablen sind firmenkonstant und entsprechen den vorgesehenen Baselinestichtagen; `post` entspricht exakt `date ≥ 2020-12-31`.

[number withheld]. **Erfüllt:** Alle [number withheld] A-Share-Zeilen haben `rl3_upper_bound = TRUE`. Bei allen [number withheld] Zeilen mit vorhandenem `rcash` ist das Flag FALSE.

[number withheld]. **Erfüllt:** Die abschließenden Zählungen in `t004_panel_counts.csv` stimmen mit dem Panel überein:

   | Markt | Status | Alle Zeilen | Broad | Main |
   |---|---|---:|---:|---:|
   | A | listed | [number withheld] | [number withheld] | [number withheld] |
   | A | delisted | [number withheld] | [number withheld] | [number withheld] |
   | HK | listed | [number withheld] | [number withheld] | [number withheld] |
   | HK | delisted | [number withheld] | [number withheld] | [number withheld] |
   | **Gesamt** | | **[number withheld]** | **[number withheld]** | **[number withheld]** |

   Weiterhin [number withheld] EastMoney- und [number withheld] Wind-Zeilen; [number withheld] Registerperioden ohne Finanzzeile werden ausschließlich gezählt.

   | Kennzahl | NA | Nenner ≤ [number withheld] |
   |---|---:|---:|
   | `rl1` | [number withheld] | [number withheld] |
   | `rl1_alt` | [number withheld] | [number withheld] |
   | `rl2` | [number withheld] | [number withheld] |
   | `rl2_adj` | [number withheld] | [number withheld] |
   | `rl3` | [number withheld] | [number withheld] |

   Die Korrektur setzt in **[number withheld] Zeilen** beide Perpetual-Variablen null. Komponentenzählungen behalten die ursprüngliche Missingness.

   | Variable | Vorher vorhanden | Jetzt vorhanden |
   |---|---:|---:|
   | `perp` | [number withheld] | [number withheld] |
   | `perp_mi` | [number withheld] | [number withheld] |
   | `rl2_adj` | [number withheld] | [number withheld] |
   | `rl2_gap` | [number withheld] | [number withheld] |
   | `perp_te` | [number withheld] | [number withheld] |

[number withheld]. **Erfüllt:** Firmenzahlen und Eigentümerabdeckung:

   | Markt | Status | Register main/broad | Panel main/broad | SOE bekannt, Panel broad |
   |---|---|---:|---:|---:|
   | A | listed | [number withheld] / [number withheld] | [number withheld] / [number withheld] | [number withheld] / [number withheld] |
   | A | delisted | [number withheld] / [number withheld] | [number withheld] / [number withheld] | [number withheld] / [number withheld] |
   | HK | listed | [number withheld] / [number withheld] | [number withheld] / [number withheld] | [number withheld] / [number withheld] |
   | HK | delisted | [number withheld] / [number withheld] | [number withheld] / [number withheld] | [number withheld] / [number withheld] |

   Im Panel: **[number withheld] Main- und [number withheld] Broad-Firmen**; SOE bekannt für **[number withheld]/[number withheld] = [number withheld] %** der breiten Stichprobe. Im Register: [number withheld] Main- und [number withheld] Broad-Firmen; SOE bekannt für [number withheld]/[number withheld] = [number withheld] %.

   Dosisverteilung nach Firmen; „ohne `adv_missing`“ entfernt Firmen mit mindestens einer betroffenen vorhandenen Panelperiode:

   | Stichprobe | dose [number withheld] | [number withheld] | [number withheld] | [number withheld] | NA |
   |---|---:|---:|---:|---:|---:|
   | main | [number withheld] | [number withheld] | [number withheld] | [number withheld] | [number withheld] |
   | main ohne `adv_missing` | [number withheld] | [number withheld] | [number withheld] | [number withheld] | [number withheld] |
   | broad | [number withheld] | [number withheld] | [number withheld] | [number withheld] | [number withheld] |
   | broad ohne `adv_missing` | [number withheld] | [number withheld] | [number withheld] | [number withheld] | [number withheld] |

   Abdeckung der Red-Line-Posten in `sample_main`, jeweils vorhandene Werte / Finanzzeilen:

   | Markt / Quelle | `ta`, `tl`, `te`, jeweils | `cash` | `std` | `ltd` | `adv` vor Nullsetzung |
   |---|---:|---:|---:|---:|---:|
   | A / EastMoney | [number withheld]/[number withheld] | [number withheld]/[number withheld] | [number withheld]/[number withheld] | [number withheld]/[number withheld] | [number withheld]/[number withheld] |
   | A / Wind | [number withheld]/[number withheld] | [number withheld]/[number withheld] | [number withheld]/[number withheld] | [number withheld]/[number withheld] | [number withheld]/[number withheld] |
   | HK / EastMoney | [number withheld]/[number withheld] | [number withheld]/[number withheld] | [number withheld]/[number withheld] | [number withheld]/[number withheld] | [number withheld]/[number withheld] |
   | HK / Wind | [number withheld]/[number withheld] | [number withheld]/[number withheld] | [number withheld]/[number withheld] | [number withheld]/[number withheld] | [number withheld]/[number withheld] |

   `rcash` ist bei A vollständig fehlend; bei HK-EastMoney in [number withheld]/[number withheld] und bei HK-Wind in [number withheld]/[number withheld] Hauptstichprobenzeilen vorhanden. Die Abdeckungstabelle enthält [number withheld] geprüfte Item-Markt-Quellen-Stichproben-Kombinationen; Perpetual-Abdeckung wird dort nach Nullsetzung ausgewiesen.

   `adv_missing` über alle vorhandenen Finanzzeilen:

   | Markt / Quelle | Fehlend / Zeilen | Anteil |
   |---|---:|---:|
   | A / EastMoney | [number withheld]/[number withheld] | [number withheld] % |
   | A / Wind | [number withheld]/[number withheld] | [number withheld] % |
   | HK / EastMoney | [number withheld]/[number withheld] | [number withheld] % |
   | HK / Wind | [number withheld]/[number withheld] | [number withheld] % |

   Vollständige Namenspräzisierungen gegenüber der ursprünglichen Schritt-[number withheld]-Tabelle, gemäß Co-PI:

   - HK `te`: `总权益` statt `股东权益`.
   - HK `std`: `短期贷款 + 应付票据`.
   - HK `ltd`: `长期贷款 + 应付票据(非流动) + 应付债券 + 可转换票据及债券 + 可转换债券及票据`.
   - HK `lease`: `融资租赁负债(流动) + 融资租赁负债(非流动)`; kein eigener HK-`notes`-Posten.
   - HK `inv`: `存货 + 发展中及待售物业`.
   - HK-Einkommensposten: `营业额`, `除税后溢利`, `少数股东损益`, `应占联营公司溢利 + 应占合营公司溢利`.
   - A-EastMoney `jv_inc`: `INVEST_JOINT_INCOME`.

   Keine weiteren Namensersetzungen; alle zugeordneten HK-Bilanznamen stehen im T003-Katalog und alle zugeordneten Wind-Namen existieren.

[number withheld]. **Nicht vollständig erfüllt:** Alle **[number withheld] regulären Dateien unter `Daten/`** und die vier dortigen Symlink-Ziele sind unverändert. Der identische Start-/Endwert des SHA-[number withheld]-Manifests über sortierte `Pfad\[number withheld]Datei-SHA2[number withheld]\n`-Einträge lautet:

[fenced excerpt withheld in public process copy]
[fenced excerpt withheld in public process copy]

   Außerhalb des Schreibbereichs änderte sich während des Laufs jedoch die projektweite `.DS_Store`; sie wurde vom Worker nicht bearbeitet, die Ursache wurde nicht festgestellt. Alle übrigen verglichenen Projektdateien außerhalb des Schreibbereichs blieben unverändert, einschließlich Aufgabenkarte und Status; automatisch geführter Bericht und Worker-Log waren vom Vergleich ausgenommen.

## Offene Fragen

[firm-specific excerpt withheld in public process copy]

**Cash:** In der HK-Hauptstichprobe fehlen Cash-Werte weiterhin in [number withheld]/[number withheld] Finanzzeilen: [number withheld] EastMoney und eine Wind. Die [number withheld] EastMoney-Fälle sind:

| Firma | Anzahl | Panelstichtage |
|---|---:|---|
[firm-specific excerpt withheld in public process copy]
[firm-specific excerpt withheld in public process copy]
[firm-specific excerpt withheld in public process copy]
[firm-specific excerpt withheld in public process copy]
[firm-specific excerpt withheld in public process copy]
[firm-specific excerpt withheld in public process copy]
[firm-specific excerpt withheld in public process copy]
[firm-specific excerpt withheld in public process copy]
[firm-specific excerpt withheld in public process copy]
[firm-specific excerpt withheld in public process copy]

Der T003-Posten `短期存款` ist bei allen [number withheld] Fällen vorhanden; `中长期存款` bei sechs und `受限制存款及现金` bei [number withheld]. `现金及等价物(非流动)` ist dort nie vorhanden. Gemäß Karte erfolgte keine Substitution. Insgesamt fehlen HK-EastMoney-Cash-Werte in [number withheld] Panelzeilen, davon [number withheld] außerhalb der Hauptstichprobe.

**Weitere Grenzen:** HK-Währungen bleiben `reported`; A-Restricted-Cash und manuelle Eigentümerkodierung bleiben offen. Die RL1-Formel bleibt `[unverified]`. Die HK-Bilanzzählung beträgt weiterhin [number withheld] statt [number withheld] Schlüssel; Differenz [number withheld] ist dokumentiert. Mangels überlappender EastMoney-/Wind-Finanzzeilen war kein numerischer Quellenvergleich möglich.

Die Pakete meldeten, unter R [number withheld] gebaut worden zu sein; beide Panel-Läufe und die abschließende CSV-Prüfung liefen erfolgreich. Die Ursache der `.DS_Store`-Änderung bleibt ungeklärt.

KI-Protokollvorschlag für den Co-PI: „T004: Codex ergänzte die freigegebene Perpetual-Nullsetzung samt Missingness-Flag, aktualisierte Panel und Prüftabellen und bestätigte zwei byte-identische Wiederholungsläufe. Formeln, unveränderte Panelspalten, Zählungen und Rohdatenintegrität wurden geprüft; eine externe `.DS_Store`-Änderung wurde dokumentiert.“