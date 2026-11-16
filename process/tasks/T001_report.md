## Ergebnis

Das Audit-Skript und beide CSV-Tabellen wurden erzeugt. Sie enthalten [number withheld] Firmen und die Abdeckung von [number withheld] Feldern über [number withheld] Firmen-Stichtag-Zeilen. Keine Stopp-Bedingung trat ein.

## Dateien

- `code/t001_audit_a_shares.py` – reproduzierbares Audit mit Eingabeprüfungen.
- `output/tables/t001_a_firms.csv` – Firmenliste mit Stichtagsabdeckung und B-Share-Markierung.
- `output/tables/t001_a_field_coverage.csv` – Feldabdeckung einschließlich `ADVANCE_OR_CONTRACT`.

## Ausführung

Exakter Befehl, zweimal erfolgreich ausgeführt (Exit-Code [number withheld]):

[fenced excerpt withheld in public process copy]
[fenced excerpt withheld in public process copy]

Letzte Ausgabe:

[fenced excerpt withheld in public process copy]
[fenced excerpt withheld in public process copy]

## Abnahmekriterien

[number withheld]. **Erfüllt:** Firmentabelle hat [number withheld] Datenzeilen und [number withheld] eindeutige Codes; entspricht der A-Share-Firmenliste.
[number withheld]. **Erfüllt:** Alle ausgegebenen Codes sind sechsstellige Zeichenketten mit erhaltenen führenden Nullen. Die Abdeckungstabelle enthält gemäß vorgegebenem Schema keine Codes.
[number withheld]. **Erfüllt:** `n_stichtage` liegt zwischen [number withheld] und [number withheld].
[number withheld]. **Erfüllt:** Genau [number withheld] Firmen sind als B-Shares markiert; ausschließlich Präfixe `[number withheld]` oder `[number withheld]`.
[number withheld]. **Erfüllt:** [number withheld] Abdeckungszeilen, jeweils `n_gesamt = [number withheld]`. Alle Anteile entsprechen dem Quotienten und liegen zwischen [number withheld] und [number withheld].
[number withheld]. **Erfüllt:** Ausschließlich die [number withheld] freigegebenen Stichtage berücksichtigt. Alle Firmenzählungen, Datumsgrenzen und Feldzählungen separat gegen die Roh-CSV-Dateien geprüft.
[number withheld]. **Erfüllt:** Beide Dateien wurden bei beiden Ausführungen neu geschrieben.
[number withheld]. **Erfüllt:** Vorher-/Nachher-Vergleich aller [number withheld] Dateieinträge unter `Daten/` ohne Änderung an Pfaden, Größen, Änderungszeiten, Inhalten oder Symlink-Zielen. Manifest-SHA-[number withheld]: `1ca2909cf63955cfd2d66cc7adb2811af013cde3b408f46e6c92ff0125d84c21`.

## Offene Fragen

- `erster_stichtag` und `letzter_stichtag` beziehen sich auf Stichtage mit vorhandener, positiver Bilanzsumme, entsprechend `n_stichtage`.
- CSV speichert keine Spaltentypen; beim Tabellenimport muss `code` als Text eingelesen werden.
- Die Entwicklerabgrenzung bleibt Antons Entscheidung.
- Vorschlag für das KI-Protokoll nach Abnahme: „Codex implementierte T001; Firmen- und Feldabdeckung gegen Rohdaten geprüft, Ausführung wiederholt und Unverändertheit von `Daten/` bestätigt.“ `AI_USAGE_LOG.md` wurde wegen des begrenzten Schreibbereichs nicht geändert.