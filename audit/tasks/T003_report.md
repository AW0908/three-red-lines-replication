## Ergebnis

Das Audit wurde umgesetzt; alle vier Tabellen wurden erzeugt und bei erneuter Ausführung bytegleich reproduziert. Sie enthalten 69 Firmen, 72 Abdeckungszeilen, 414 Geschäftsjahres-/Datumspaare und 254 Posten-/Datumsregelzeilen. Keine Firma wurde ausgeschlossen und keine Red-Line-Kennzahl berechnet.

## Dateien

- `replication/code/t003_audit_hk.py` – reproduzierbares Audit mit Eingabe- und Abnahmeprüfungen.
- `replication/outputs/tables/t003_hk_firms.csv` – 69 Firmen mit beiden Datumszählungen und Kennzeichnung von `02768`.
- `replication/outputs/tables/t003_hk_field_coverage.csv` – Feldabdeckung nach Quelle und Datumsregel.
- `replication/outputs/tables/t003_hk_fiscal_year_ends.csv` – beobachtete Datumspaare für elf Firmen mit abweichendem Geschäftsjahr.
- `replication/outputs/tables/t003_hk_items.csv` – sämtliche beobachteten Bilanzposten mit Firmenzahlen je Datumsregel.

## Ausführung

Exakter Befehl:

[fenced excerpt withheld in public audit]
[fenced excerpt withheld in public audit]

Letzte Ausgabezeilen:

[fenced excerpt withheld in public audit]
[fenced excerpt withheld in public audit]

Zusätzliche Prüfung:

[fenced excerpt withheld in public audit]
[fenced excerpt withheld in public audit]

## Abnahmekriterien

1. **Erfüllt:** 69 eindeutige fünfstellige Codes; ausschließlich `02019` und `03333` haben `source=both`.
2. **Erfüllt:** Beide Datumszählungen liegen zwischen 0 und 13.
3. **Erfüllt:** Genau eine Kennzeichnung für `02768`; Rohdatenname `国恩科技`.
4. **Erfüllt:** Alle Anteile entsprechen `n_present / n_total` und liegen in [0, 1]. Nenner sind innerhalb jeder Datumsregel-/Quellengruppe konstant.
5. **Erfüllt:** Abdeckung verwendet ausschließlich die 13 Zielstichtage.
6. **Erfüllt:** Alle elf Firmen mit abweichendem Geschäftsjahr sind enthalten, einschließlich `00221`, `00275`, `00278`, `00283`, `01246`.
7. **Erfüllt:** Vorgeschriebener Befehl läuft fehlerfrei; erneuter Lauf reproduziert alle vier CSV-Dateien mit identischen SHA-256-Prüfsummen.
8. **Erfüllt:** Pfad-/Inhaltsprüfsumme aller 7.317 Dateien unter `Daten/` vor und nach Ausführung identisch.

## Offene Fragen

`发展中物业` existiert nicht exakt. Die Abdeckung weist stattdessen den beobachteten ähnlichen Namen `发展中及待售物业` mit `match_type=closest_name_only` aus; eine inhaltliche Gleichsetzung wurde nicht vorgenommen.

Die 16 fehlenden, nicht wiederverwendeten HK-Codes sind: `00642`, `01369`, `00208`, `02606`, `00281`, `03992`, `08155`, `01589`, `00112`, `02103`, `00141`, `01838`, `02379`, `02118`, `00680`, `02278`. Zusätzlich fehlen sechs als wiederverwendet markierte Codes: `00020`, `06166`, `01191`, `06090`, `00800`, `00600`. Sie wurden ausschließlich berichtet und nicht als zusätzliche Firmenzeilen aufgenommen.

`first_date` und `last_date` beziehen sich auf sämtliche beobachteten `REPORT_DATE`-Werte. Quellenübergreifende Dubletten werden in der Firmentabelle zusammengeführt; die Abdeckung bleibt nach Eingabequelle getrennt.

Vorschlag für das KI-Protokoll nach Abnahme: „T003: Codex erstellte das lokale HK-Rohdatenaudit; Eingabeschemata, numerische Beträge, acht Abnahmekriterien, reproduzierbare Ausgaben und unveränderte Rohdaten geprüft.“