## Ergebnis

Das separate Erweiterungspanel bis 2024H2 wurde mit 3.015 Zeilen, 184 Firmen und 90 Spalten erzeugt. Hauptpanel und sämtliche 107 bisherigen Ausgabedateien bleiben byte-identisch. Die Erweiterung enthält sechs zusätzliche RL1-Abwärtskreuzungen; T030 erzeugt keine neuen Schätzungen.

## Dateien

- `replication/code/01b_extend.R` – Erweiterung mit identischen Bereinigungsregeln und Prüfungen.
- `replication/data/processed/panel_firm_halfyear_ext.csv` – separates Erweiterungspanel.
- `replication/run_all.R`, `replication/run_all.sh` – 01b unmittelbar nach 01 integriert.
- `replication/README.md` – Pipeline, Ausgaben und Änderungsprotokoll ergänzt.
- `replication/outputs/tables/t030_coverage.csv` – Abdeckung nach Datum, Markt und Quelle.
- `replication/outputs/tables/t030_attrition_2023_2024.csv` – fehlende Ende-2022-Berichterstatter nach gerundeter Dosis.
- `replication/outputs/tables/t030_crossings_preview.csv` – ausschließlich Schwellenkreuzungszahlen.
- `replication/outputs/tables/t030_dictionary_addendum.csv` – ergänzte Variablendefinitionen.
- `replication/outputs/tables/t030_rl1_by_date.csv` – RL1-Abdeckung je Stichtag.
- `replication/outputs/tables/t030_wind_only_firms.csv` – sämtliche Wind-only-Firmen und Datenlücken.
- `replication/outputs/tables/t030_missing_firms.csv` – fehlende Firmen mit Quellenbegründung.
- `replication/outputs/tables/t030_item_mapping_audit.csv` – Prüfung der HK-Postennamen.
- `replication/outputs/tables/t030_overlap_assert.csv` – Vergleich aller 89 bisherigen Spalten.
- `replication/outputs/tables/t030_verification.txt` – vollständige Laufprotokolle, SHA-256-Prüfsummen und unabhängige Kontrollzählungen.

## Ausführung

Zwei vollständige Läufe vom Projektordner aus:

[fenced excerpt withheld in public audit]
[fenced excerpt withheld in public audit]

Beide Exitcode 0; Laufzeiten 52,94 und 51,03 Sekunden. Letzte Ausgabe des zweiten Laufs:

[fenced excerpt withheld in public audit]
[fenced excerpt withheld in public audit]

## Abnahmekriterien

1. **Erfüllt:** Hauptpanel und 107 bisherige Outputs byte-identisch. Überlappungsprüfung: 2.279 Zeilen × 89 Spalten, maximale numerische Differenz **0**.
2. **Erfüllt:** Alle 119 verarbeiteten Daten- und Ausgabedateien stimmen zwischen beiden vollständigen Läufen byte-identisch überein.
3. **Erfüllt:** RL1-Abdeckung der Hauptstichprobe:

   | Stichtag | Firmen mit RL1 |
   |---|---:|
   | 2016-12-31 | 133 |
   | 2017-06-30 | 129 |
   | 2017-12-31 | 136 |
   | 2018-06-30 | 131 |
   | 2018-12-31 | 135 |
   | 2019-06-30 | 131 |
   | 2019-12-31 | 135 |
   | 2020-06-30 | 131 |
   | 2020-12-31 | 132 |
   | 2021-06-30 | 130 |
   | 2021-12-31 | 124 |
   | 2022-06-30 | 124 |
   | 2022-12-31 | 120 |
   | 2023-06-30 | 101 |
   | 2023-12-31 | 99 |
   | 2024-06-30 | 98 |
   | 2024-12-31 | 96 |

   **34 Wind-only-Firmen**, davon **28 Hauptstichprobenfirmen**, haben keine Exporte nach 2022H2. Für alle vier neuen Stichtage gilt `has_row=FALSE`, ohne imputierte Finanzwerte.

[firm-specific excerpt withheld in public audit]
4. **Erfüllt:** T030 liefert ausschließlich Datenaufbereitung, Abdeckungsprüfungen und Zählungen. Zusätzliche Kreuzungen: **2 / 2 / 1 / 1** für 2023H1–2024H2.

## Offene Fragen

Die Lockerung der Three Red Lines nach 2022 bleibt vom PI zu verifizieren. Deshalb kennzeichnet `post2` ein separates Erweiterungsfenster; eine unveränderte politische Behandlung wird nicht unterstellt. Auch die wirtschaftlichen Ursachen fehlender EastMoney-Berichte wurden nicht untersucht.

Vorschlag für `AI_USAGE_LOG.md`: „23.10.2026, Codex, T030: separates Erweiterungspanel bis 2024H2 implementiert; historische Überlappung, Quellenlücken und zwei vollständige Builds durch Prüfsummen und unabhängige Kontrollzählungen geprüft.“ Das Log liegt außerhalb des Schreibbereichs und wurde nicht geändert.