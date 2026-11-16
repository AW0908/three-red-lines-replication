## Ergebnis

Das Audit wurde umgesetzt; alle vier Tabellen wurden erzeugt und bei erneuter Ausführung bytegleich reproduziert. Sie enthalten [number withheld] Firmen, [number withheld] Abdeckungszeilen, [number withheld] Geschäftsjahres-/Datumspaare und [number withheld] Posten-/Datumsregelzeilen. Keine Firma wurde ausgeschlossen und keine Red-Line-Kennzahl berechnet.

## Dateien

- `replication/code/t003_audit_hk.py` – reproduzierbares Audit mit Eingabe- und Abnahmeprüfungen.
- `replication/outputs/tables/t003_hk_firms.csv` – [number withheld] Firmen mit beiden Datumszählungen und Kennzeichnung von `[number withheld]`.
- `replication/outputs/tables/t003_hk_field_coverage.csv` – Feldabdeckung nach Quelle und Datumsregel.
- `replication/outputs/tables/t003_hk_fiscal_year_ends.csv` – beobachtete Datumspaare für elf Firmen mit abweichendem Geschäftsjahr.
- `replication/outputs/tables/t003_hk_items.csv` – sämtliche beobachteten Bilanzposten mit Firmenzahlen je Datumsregel.

## Ausführung

Exakter Befehl:

[fenced excerpt withheld in public process copy]
[fenced excerpt withheld in public process copy]

Letzte Ausgabezeilen:

[fenced excerpt withheld in public process copy]
[fenced excerpt withheld in public process copy]

Zusätzliche Prüfung:

[fenced excerpt withheld in public process copy]
[fenced excerpt withheld in public process copy]

## Abnahmekriterien

[number withheld]. **Erfüllt:** [number withheld] eindeutige fünfstellige Codes; ausschließlich `[number withheld]` und `[number withheld]` haben `source=both`.
[number withheld]. **Erfüllt:** Beide Datumszählungen liegen zwischen [number withheld] und [number withheld].
[number withheld]. **Erfüllt:** Genau eine Kennzeichnung für `[number withheld]`; Rohdatenname `国恩科技`.
[number withheld]. **Erfüllt:** Alle Anteile entsprechen `n_present / n_total` und liegen in [[number withheld], [number withheld]]. Nenner sind innerhalb jeder Datumsregel-/Quellengruppe konstant.
[number withheld]. **Erfüllt:** Abdeckung verwendet ausschließlich die [number withheld] Zielstichtage.
[number withheld]. **Erfüllt:** Alle elf Firmen mit abweichendem Geschäftsjahr sind enthalten, einschließlich `[number withheld]`, `[number withheld]`, `[number withheld]`, `[number withheld]`, `[number withheld]`.
[number withheld]. **Erfüllt:** Vorgeschriebener Befehl läuft fehlerfrei; erneuter Lauf reproduziert alle vier CSV-Dateien mit identischen SHA-[number withheld]-Prüfsummen.
[number withheld]. **Erfüllt:** Pfad-/Inhaltsprüfsumme aller [number withheld] Dateien unter `Daten/` vor und nach Ausführung identisch.

## Offene Fragen

`发展中物业` existiert nicht exakt. Die Abdeckung weist stattdessen den beobachteten ähnlichen Namen `发展中及待售物业` mit `match_type=closest_name_only` aus; eine inhaltliche Gleichsetzung wurde nicht vorgenommen.

Die [number withheld] fehlenden, nicht wiederverwendeten HK-Codes sind: `[number withheld]`, `[number withheld]`, `[number withheld]`, `[number withheld]`, `[number withheld]`, `[number withheld]`, `[number withheld]`, `[number withheld]`, `[number withheld]`, `[number withheld]`, `[number withheld]`, `[number withheld]`, `[number withheld]`, `[number withheld]`, `[number withheld]`, `[number withheld]`. Zusätzlich fehlen sechs als wiederverwendet markierte Codes: `[number withheld]`, `[number withheld]`, `[number withheld]`, `[number withheld]`, `[number withheld]`, `[number withheld]`. Sie wurden ausschließlich berichtet und nicht als zusätzliche Firmenzeilen aufgenommen.

`first_date` und `last_date` beziehen sich auf sämtliche beobachteten `REPORT_DATE`-Werte. Quellenübergreifende Dubletten werden in der Firmentabelle zusammengeführt; die Abdeckung bleibt nach Eingabequelle getrennt.

Vorschlag für das KI-Protokoll nach Abnahme: „T003: Codex erstellte das lokale HK-Rohdatenaudit; Eingabeschemata, numerische Beträge, acht Abnahmekriterien, reproduzierbare Ausgaben und unveränderte Rohdaten geprüft.“