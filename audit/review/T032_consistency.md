## Rolle: consistency (codex, high) – VERDICT: PASS


## Befunde

1. Keine abnahmerelevante Inkonsistenz im geprüften Umfang gefunden. Die fünf CSVs enthalten 107 / 72 / 962 / 53 / 53 Datensätze; ihre aktuellen SHA-256-Prüfsummen stimmen mit `extraction_log.md`, Zeilen 96–104, überein. Die Dokumentzuordnung umfasst ausschließlich die 22 Manifestberichte von zehn Firmen.

[firm-specific excerpt withheld in public audit]

## Abnahmekriterien

1. **Belegt erfüllt im Konsistenzumfang.** Alle befüllten numerischen Erhebungsfelder haben passende Seitenfelder, einschließlich gesonderter Seiten für Konzern-NCI und Finanzübersichten. Die 22 Konzern-NCI-Werte wurden unabhängig gegen die angegebenen Textdumps abgeglichen; alle stimmen wörtlich überein (`extraction_log.md:827–848`). Zusätzlich geprüfte Tochtertabellen stimmen einschließlich Vorzeichen, Null und Einheit: etwa Huafa FY2020, PDF-Seite 260; Caixin H12021, Seite 135; China SCE FY2020, Seite 236; Xinhu FY2019, Seite 171; Nanshan FY2021, Seite 228. Die negative Dividende **−24.364.465,75** und die gedruckte **0,00** sind korrekt erhalten.

2. **Belegt erfüllt hinsichtlich Übereinstimmung und Kennzeichnung.** Sämtliche CSV-Datensätze verweisen auf Manifestberichte. Alle 962 Vertragsauszüge sind unveränderte Teilstrings der zitierten Textdumps und höchstens 300 Zeichen lang. Alle 34 numerischen Kennzahlenangaben samt Zitaten stehen auf den angegebenen Seiten. Panelvergleiche sind ausdrücklich gekennzeichnet; abweichende Kennzahlendefinitionen werden erläutert (`extraction_log.md:617–619`). Vollständigkeit der Extraktion und fachliche Kontextklassifikation: **nicht meine Rolle**.

3. **Belegt erfüllt.** Für sämtliche 22 Berichte ist eine NCI-Abstimmung dokumentiert. Die angegebenen Panelwerte stimmen mit `panel_firm_halfyear.csv` überein: 21 Übereinstimmungen und die ausdrücklich markierte Nanshan-Abweichung. Die 53 Registerdatensätze übernehmen aktuelle und gegebenenfalls vorherige Beträge samt Seiten konsistent aus `nci_subsidiaries.csv`.

4. **Belegt erfüllt.** `verified_by_PI` ist in sämtlichen Datensätzen aller fünf CSVs leer. Auch die vier Registerfelder für Identität und Quelle sind vollständig leer.

## Nicht geprüft

- Keine erneute PDF-Extraktion, visuelle PDF-Prüfung oder Ausführung des eingebetteten Reproduktionscodes; keine Dateien verändert.
- Datenbereinigung, Auswahlregeln und Schätzmethodik: nicht meine Rolle.
- Im Proposal wurden keine T032-Bezüge gefunden; deshalb keine T032-spezifischen Paper-Tabellen, Abbildungen oder Ergebnisquerverweise geprüft.
- Urheberschaft und Zeitpunkt der gemeldeten Änderungen außerhalb des Schreibbereichs sind aus dem aktuellen Dateistand nicht feststellbar. Die dokumentierte Protokollergänzung `group_affiliate` erklärt den Hashunterschied vollständig; eine historische Unverändertheit ist damit nicht unabhängig nachgewiesen.