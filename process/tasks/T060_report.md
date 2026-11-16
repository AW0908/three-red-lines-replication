## Ergebnis

`Daten/fetch_control.py` implementiert den Kontrollgruppenabruf mit Branchenfilter, Wiederaufnahme, Anfragepausen, Retries und Abdeckungsbericht. Elf isolierte Offline-Prüfungen bestanden, einschließlich eines Ablaufs mit [number withheld] synthetischen Testfirmen; diese Testdaten wurden gelöscht. Der echte Download scheiterte beim Branchenlistenabruf an einem DNS-Fehler.

## Dateien

- `Daten/fetch_control.py` – Downloadskript.
- `Daten/control/fetch_control.log` – Ausführungs- und Fehlerprotokoll.
- `Daten/control/test_run.txt` – vollständige Ausgabe des abschließenden Testlaufs.
- `Daten/control/offline_checks.txt` – Ergebnisse der elf Offline-Prüfungen.
- `Daten/control/input_hashes.json` – SHA-[number withheld] der sieben erfassten Eingaben.
- `Daten/control/scope_before.json` – anfänglicher Metadatenstand außerhalb des Schreibbereichs.
- `Daten/control/scope_check.json` – Eingabe- und Schreibbereichsvergleich.
- `tasks/T060_report.md` – Worker-Bericht.

## Ausführung

Aus dem Projektordner:

[fenced excerpt withheld in public process copy]
[fenced excerpt withheld in public process copy]

Exit-Code: `[number withheld]`. Letzte Ausgabezeile:

[fenced excerpt withheld in public process copy]
[fenced excerpt withheld in public process copy]

Exakter Fehlerkern: `ConnectionError`, verursacht durch `NameResolutionError`:

[fenced excerpt withheld in public process copy]
[fenced excerpt withheld in public process copy]

Vollständige Fehlermeldung einschließlich Request-URL: `Daten/control/test_run.txt`.

Zusätzlich ausgeführt:

[fenced excerpt withheld in public process copy]
[fenced excerpt withheld in public process copy]

Exit-Code `[number withheld]`; HK wurde ausdrücklich als „not available“ protokolliert und übersprungen.

## Abnahmekriterien

[number withheld]. **Erfüllt über die erlaubte Netzwerkfehler-Alternative.** Vorgeschriebener Test ausgeführt, genauer Fehler dokumentiert. Kein erfolgreicher empirischer Download. Die elf Offline-Prüfungen belegen separat Filter, Stichtage, Feldzuordnung, Ausgabeerzeugung, Wiederaufnahme, Fehlerbehandlung und Anfragepausen.

[number withheld]. **Erfüllt.** Identisch zum Entwicklerpanel:
   `ta = "TOTAL_ASSETS"`, `tl = "TOTAL_LIABILITIES"`, `adv = c("ADVANCE_RECEIVABLES", "CONTRACT_LIAB")`.
   Das Skript speichert beide Vorauszahlungskomponenten getrennt mit ursprünglicher Fehlwertstruktur. Summierung, die bestehende Nullimputation bei vollständig fehlenden Komponenten und Berechnung von `(tl-adv)/(ta-adv)` bleiben T061 vorbehalten.

[number withheld]. **Erfüllt für meine Schreibzugriffe.** Nur Dateien im freigegebenen Schreibbereich wurden geschrieben; der Kartenstatus blieb unverändert. Alle sieben erfassten Eingaben sind SHA-[number withheld]-identisch. Der projektweite Metadatenvergleich zeigt allerdings [number withheld] parallele Änderungen außerhalb des Schreibbereichs, aufgelistet in `scope_check.json`; diese Dateien habe ich nicht geschrieben.

## Offene Fragen

- Anton muss den echten [number withheld]-Firmen-Test mit Netzwerk wiederholen. Laufzeit je Firma und Gesamthochrechnung sind ohne heruntergeladene Firmen und bekannte Populationsgröße nicht bestimmbar.
- Die festgelegten EastMoney-Boardnamen sind online noch ungeprüft. Fehlende Boards führen zum Stopp. Nach erfolgreichem Katalogabruf schreibt das Skript `board_list.csv` vor dem Bilanzabruf; der Vollabruf verlangt die interaktive PI-Bestätigung und protokolliert sie. Wegen des frühen DNS-Fehlers wurden hier noch keine echten Branchen-, Firmen-, Bilanz- oder Coverage-Dateien erzeugt.
- Eigentümerangaben bleiben fehlend, da der Branchenmitglieder-Endpunkt sie nicht liefert. Aktuelle Boardmitgliedschaft bleibt eine Survivorship-Einschränkung.
- HK-Branchenlisten sind über die installierte AKShare-Version nicht verfügbar; keine Ersatzpopulation wurde verwendet.
- KI-Protokollvorschlag für den Co-PI: „Codex, T060: Kontrollgruppen-Downloadskript implementiert; elf lokale Prüfungen bestanden; echter Test durch DNS-Fehler blockiert; keine empirischen Ergebnisse erzeugt.“ `AI_USAGE_LOG.md` liegt außerhalb des Schreibbereichs und wurde nicht geändert.