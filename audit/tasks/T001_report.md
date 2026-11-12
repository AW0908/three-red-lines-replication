## Ergebnis

Das Audit-Skript und beide CSV-Tabellen wurden erzeugt. Sie enthalten 89 Firmen und die Abdeckung von 16 Feldern über 1.155 Firmen-Stichtag-Zeilen. Keine Stopp-Bedingung trat ein.

## Dateien

- `code/t001_audit_a_shares.py` – reproduzierbares Audit mit Eingabeprüfungen.
- `output/tables/t001_a_firms.csv` – Firmenliste mit Stichtagsabdeckung und B-Share-Markierung.
- `output/tables/t001_a_field_coverage.csv` – Feldabdeckung einschließlich `ADVANCE_OR_CONTRACT`.

## Ausführung

Exakter Befehl, zweimal erfolgreich ausgeführt (Exit-Code 0):

[fenced excerpt withheld in public audit]
[fenced excerpt withheld in public audit]

Letzte Ausgabe:

[fenced excerpt withheld in public audit]
[fenced excerpt withheld in public audit]

## Abnahmekriterien

1. **Erfüllt:** Firmentabelle hat 89 Datenzeilen und 89 eindeutige Codes; entspricht der A-Share-Firmenliste.
2. **Erfüllt:** Alle ausgegebenen Codes sind sechsstellige Zeichenketten mit erhaltenen führenden Nullen. Die Abdeckungstabelle enthält gemäß vorgegebenem Schema keine Codes.
3. **Erfüllt:** `n_stichtage` liegt zwischen 11 und 13.
4. **Erfüllt:** Genau 9 Firmen sind als B-Shares markiert; ausschließlich Präfixe `200` oder `900`.
5. **Erfüllt:** 16 Abdeckungszeilen, jeweils `n_gesamt = 1155`. Alle Anteile entsprechen dem Quotienten und liegen zwischen 0 und 1.
6. **Erfüllt:** Ausschließlich die 13 freigegebenen Stichtage berücksichtigt. Alle Firmenzählungen, Datumsgrenzen und Feldzählungen separat gegen die Roh-CSV-Dateien geprüft.
7. **Erfüllt:** Beide Dateien wurden bei beiden Ausführungen neu geschrieben.
8. **Erfüllt:** Vorher-/Nachher-Vergleich aller 7.302 Dateieinträge unter `Daten/` ohne Änderung an Pfaden, Größen, Änderungszeiten, Inhalten oder Symlink-Zielen. Manifest-SHA-256: `1ca2909cf63955cfd2d66cc7adb2811af013cde3b408f46e6c92ff0125d84c21`.

## Offene Fragen

- `erster_stichtag` und `letzter_stichtag` beziehen sich auf Stichtage mit vorhandener, positiver Bilanzsumme, entsprechend `n_stichtage`.
- CSV speichert keine Spaltentypen; beim Tabellenimport muss `code` als Text eingelesen werden.
- Die Entwicklerabgrenzung bleibt Antons Entscheidung.
- Vorschlag für das KI-Protokoll nach Abnahme: „Codex implementierte T001; Firmen- und Feldabdeckung gegen Rohdaten geprüft, Ausführung wiederholt und Unverändertheit von `Daten/` bestätigt.“ `AI_USAGE_LOG.md` wurde wegen des begrenzten Schreibbereichs nicht geändert.