## Ergebnis

T032 wurde gegen das eingefrorene Protokoll erneut ausgeführt; alle fünf CSVs wurden bytegenau reproduziert. Das Extraktionslog dokumentiert jetzt den Protokollvergleich und den frischen Abgleich aller 5.777 Textdumps mit den 22 PDFs. Eingaben und Kartenstatus blieben unverändert.

## Dateien

- `replication/data/raw/manual/handcollect/nci_subsidiaries.csv` – erneut erzeugt, unverändert: 107 Zeilen.
- `replication/data/raw/manual/handcollect/nci_cashflow.csv` – erneut erzeugt, unverändert: 72 Zeilen.
- `replication/data/raw/manual/handcollect/contract_hits.csv` – erneut erzeugt, unverändert: 962 Treffer.
- `replication/data/raw/manual/handcollect/rl1_published.csv` – erneut erzeugt, unverändert: 53 Zeilen.
- `replication/data/raw/manual/handcollect/registry_todo.csv` – erneut erzeugt, unverändert: 53 Zeilen.
- `replication/data/raw/manual/handcollect/extraction_log.md` – Nachweise zum erneuten Lauf, Protokollvergleich und KI-Protokollvorschlag ergänzt.

## Ausführung

Vom Projektordner ausgeführt:

[fenced excerpt withheld in public audit]
[fenced excerpt withheld in public audit]

Letzte Ausgabezeilen:

[fenced excerpt withheld in public audit]
[fenced excerpt withheld in public audit]

Ein weiterer Aufbau reproduzierte auch das ergänzte Log bytegenau. Alle 26 Eingaben hatten vor und nach der Ausführung identische Prüfsummen.

## Abnahmekriterien

1. **Erfüllt:** Seitenbelege und 886 Zahlenprüfungen bestanden. Der bestehende Datenprüfbericht bestätigt zusätzlich 27 Zahlenvergleiche an den unveränderten CSVs. Alle 5.777 Textdumps stimmen mit frischer PDF-Extraktion überein.
2. **Erfüllt:** Ausschließlich die 22 freigegebenen Dokumente; Panelwerte nur für vorgesehene Vergleiche. Keine Imputation oder Gesellschafterinterpretation.
3. **Erfüllt:** 22 NCI-Abstimmungen im Log, davon 21 exakt und eine ausdrücklich markierte Abweichung.
4. **Erfüllt:** Alle `verified_by_PI`-Felder und Register-Identitätsfelder sind leer.

## Offene Fragen

- Nanshan FY2020: Bericht minus Panel bleibt −285.664.366,60 RMB; keine Anpassung vorgenommen.
- Veröffentlichte RL1-Abweichungen bei Xinhu FY2019 und Kaisa FY2020 sowie Kaisas widersprüchliche Gesamtergebnisangaben bleiben dokumentiert.
- Eine erneute unabhängige Konsistenzprüfung mit funktionierendem Dateizugriff, PI-Verifikation und Registerabfragen stehen aus.
- Die Protokolldifferenz ist vollständig durch die dokumentierte Ergänzung `group_affiliate` erklärbar; das Entfernen dieser Zeichenfolge rekonstruiert exakt die ursprüngliche Prüfsumme.