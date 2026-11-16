## Ergebnis

T032 wurde gegen das eingefrorene Protokoll erneut ausgeführt; alle fünf CSVs wurden bytegenau reproduziert. Das Extraktionslog dokumentiert jetzt den Protokollvergleich und den frischen Abgleich aller [number withheld] Textdumps mit den [number withheld] PDFs. Eingaben und Kartenstatus blieben unverändert.

## Dateien

- `replication/data/raw/manual/handcollect/nci_subsidiaries.csv` – erneut erzeugt, unverändert: [number withheld] Zeilen.
- `replication/data/raw/manual/handcollect/nci_cashflow.csv` – erneut erzeugt, unverändert: [number withheld] Zeilen.
- `replication/data/raw/manual/handcollect/contract_hits.csv` – erneut erzeugt, unverändert: [number withheld] Treffer.
- `replication/data/raw/manual/handcollect/rl1_published.csv` – erneut erzeugt, unverändert: [number withheld] Zeilen.
- `replication/data/raw/manual/handcollect/registry_todo.csv` – erneut erzeugt, unverändert: [number withheld] Zeilen.
- `replication/data/raw/manual/handcollect/extraction_log.md` – Nachweise zum erneuten Lauf, Protokollvergleich und KI-Protokollvorschlag ergänzt.

## Ausführung

Vom Projektordner ausgeführt:

[fenced excerpt withheld in public process copy]
[fenced excerpt withheld in public process copy]

Letzte Ausgabezeilen:

[fenced excerpt withheld in public process copy]
[fenced excerpt withheld in public process copy]

Ein weiterer Aufbau reproduzierte auch das ergänzte Log bytegenau. Alle [number withheld] Eingaben hatten vor und nach der Ausführung identische Prüfsummen.

## Abnahmekriterien

[number withheld]. **Erfüllt:** Seitenbelege und [number withheld] Zahlenprüfungen bestanden. Der bestehende Datenprüfbericht bestätigt zusätzlich [number withheld] Zahlenvergleiche an den unveränderten CSVs. Alle [number withheld] Textdumps stimmen mit frischer PDF-Extraktion überein.
[number withheld]. **Erfüllt:** Ausschließlich die [number withheld] freigegebenen Dokumente; Panelwerte nur für vorgesehene Vergleiche. Keine Imputation oder Gesellschafterinterpretation.
[number withheld]. **Erfüllt:** [number withheld] NCI-Abstimmungen im Log, davon [number withheld] exakt und eine ausdrücklich markierte Abweichung.
[number withheld]. **Erfüllt:** Alle `verified_by_PI`-Felder und Register-Identitätsfelder sind leer.

## Offene Fragen

- Nanshan FY2[number withheld]: Bericht minus Panel bleibt [number withheld] RMB; keine Anpassung vorgenommen.
- Veröffentlichte RL1-Abweichungen bei Xinhu FY2[number withheld] und Kaisa FY2[number withheld] sowie Kaisas widersprüchliche Gesamtergebnisangaben bleiben dokumentiert.
- Eine erneute unabhängige Konsistenzprüfung mit funktionierendem Dateizugriff, PI-Verifikation und Registerabfragen stehen aus.
- Die Protokolldifferenz ist vollständig durch die dokumentierte Ergänzung `group_affiliate` erklärbar; das Entfernen dieser Zeichenfolge rekonstruiert exakt die ursprüngliche Prüfsumme.