## Ergebnis

Das separate Erweiterungspanel bis [number withheld]H2 wurde mit [number withheld] Zeilen, [number withheld] Firmen und [number withheld] Spalten erzeugt. Hauptpanel und sämtliche [number withheld] bisherigen Ausgabedateien bleiben byte-identisch. Die Erweiterung enthält sechs zusätzliche RL1-Abwärtskreuzungen; T030 erzeugt keine neuen Schätzungen.

## Dateien

- `replication/code/01b_extend.R` – Erweiterung mit identischen Bereinigungsregeln und Prüfungen.
- `replication/data/processed/panel_firm_halfyear_ext.csv` – separates Erweiterungspanel.
- `replication/run_all.R`, `replication/run_all.sh` – [number withheld]b unmittelbar nach [number withheld] integriert.
- `replication/README.md` – Pipeline, Ausgaben und Änderungsprotokoll ergänzt.
- `replication/outputs/tables/t030_coverage.csv` – Abdeckung nach Datum, Markt und Quelle.
- `replication/outputs/tables/t030_attrition_2023_2024.csv` – fehlende Ende-[number withheld]-Berichterstatter nach gerundeter Dosis.
- `replication/outputs/tables/t030_crossings_preview.csv` – ausschließlich Schwellenkreuzungszahlen.
- `replication/outputs/tables/t030_dictionary_addendum.csv` – ergänzte Variablendefinitionen.
- `replication/outputs/tables/t030_rl1_by_date.csv` – RL1-Abdeckung je Stichtag.
- `replication/outputs/tables/t030_wind_only_firms.csv` – sämtliche Wind-only-Firmen und Datenlücken.
- `replication/outputs/tables/t030_missing_firms.csv` – fehlende Firmen mit Quellenbegründung.
- `replication/outputs/tables/t030_item_mapping_audit.csv` – Prüfung der HK-Postennamen.
- `replication/outputs/tables/t030_overlap_assert.csv` – Vergleich aller [number withheld] bisherigen Spalten.
- `replication/outputs/tables/t030_verification.txt` – vollständige Laufprotokolle, SHA-[number withheld]-Prüfsummen und unabhängige Kontrollzählungen.

## Ausführung

Zwei vollständige Läufe vom Projektordner aus:

[fenced excerpt withheld in public process copy]
[fenced excerpt withheld in public process copy]

Beide Exitcode [number withheld]; Laufzeiten [number withheld] und [number withheld] Sekunden. Letzte Ausgabe des zweiten Laufs:

[fenced excerpt withheld in public process copy]
[fenced excerpt withheld in public process copy]

## Abnahmekriterien

[number withheld]. **Erfüllt:** Hauptpanel und [number withheld] bisherige Outputs byte-identisch. Überlappungsprüfung: [number withheld] Zeilen × [number withheld] Spalten, maximale numerische Differenz **[number withheld]**.
[number withheld]. **Erfüllt:** Alle [number withheld] verarbeiteten Daten- und Ausgabedateien stimmen zwischen beiden vollständigen Läufen byte-identisch überein.
[number withheld]. **Erfüllt:** RL1-Abdeckung der Hauptstichprobe:

   | Stichtag | Firmen mit RL1 |
   |---|---:|
   | 2016-12-31 | [number withheld] |
   | 2017-06-30 | [number withheld] |
   | 2017-12-31 | [number withheld] |
   | 2018-06-30 | [number withheld] |
   | 2018-12-31 | [number withheld] |
   | 2019-06-30 | [number withheld] |
   | 2019-12-31 | [number withheld] |
   | 2020-06-30 | [number withheld] |
   | 2020-12-31 | [number withheld] |
   | 2021-06-30 | [number withheld] |
   | 2021-12-31 | [number withheld] |
   | 2022-06-30 | [number withheld] |
   | 2022-12-31 | [number withheld] |
   | 2023-06-30 | [number withheld] |
   | 2023-12-31 | [number withheld] |
   | 2024-06-30 | [number withheld] |
   | 2024-12-31 | [number withheld] |

   **[number withheld] Wind-only-Firmen**, davon **[number withheld] Hauptstichprobenfirmen**, haben keine Exporte nach [number withheld]H2. Für alle vier neuen Stichtage gilt `has_row=FALSE`, ohne imputierte Finanzwerte.

[firm-specific excerpt withheld in public process copy]
[number withheld]. **Erfüllt:** T030 liefert ausschließlich Datenaufbereitung, Abdeckungsprüfungen und Zählungen. Zusätzliche Kreuzungen: **[number withheld] / [number withheld] / [number withheld] / [number withheld]** für [number withheld]H1–[number withheld]H2.

## Offene Fragen

Die Lockerung der Three Red Lines nach [number withheld] bleibt vom PI zu verifizieren. Deshalb kennzeichnet `post2` ein separates Erweiterungsfenster; eine unveränderte politische Behandlung wird nicht unterstellt. Auch die wirtschaftlichen Ursachen fehlender EastMoney-Berichte wurden nicht untersucht.

Vorschlag für `AI_USAGE_LOG.md`: „[number withheld], Codex, T030: separates Erweiterungspanel bis [number withheld]H2 implementiert; historische Überlappung, Quellenlücken und zwei vollständige Builds durch Prüfsummen und unabhängige Kontrollzählungen geprüft.“ Das Log liegt außerhalb des Schreibbereichs und wurde nicht geändert.