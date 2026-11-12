## Ergebnis

Die REWORK-Punkte sind umgesetzt: Geschützte PDFs werden auf Existenz und PDF-Kopfzeile geprüft; Byteabweichungen erzeugen standardmäßig eine Information, mit `MTPA_GUARDS=strict_pdf` einen Abbruch. Textguards bleiben standardmäßig streng. README korrigiert; alle 32 erzeugten Ausgaben bleiben bytegleich.

## Dateien

- `replication/code/00_setup.R` – PDF-Prüffunktion und optionaler strenger Bytevergleich.
- `replication/code/03_figures.R` – neue Prüfung für geschützte PDFs eingebunden.
- `replication/README.md` – PDF-Modi, R-Anforderungen, Paketstatus und primären Einstieg korrigiert.
- `/private/tmp/T014_rework_3ghhk2gb/` – Testskript, zwölf Laufprotokolle, Testkopien, SHA-256-Tabellen und Prüfbelege.

## Ausführung

Vorgeschriebenen Befehl selbst ausgeführt, Exit **0**:

[fenced excerpt withheld in public audit]
[fenced excerpt withheld in public audit]

Letzte Ausgabezeilen:

[fenced excerpt withheld in public audit]
[fenced excerpt withheld in public audit]

Zusätzliche Tests:

[fenced excerpt withheld in public audit]
[fenced excerpt withheld in public audit]

Abschluss: `PASS: all rework tests`. Exakte Befehle, Arbeitsverzeichnisse, Umgebungsvariablen und Exitcodes stehen in `test_results.json`.

## Abnahmekriterien

1. **Erfüllt.** Alle 14 Textschreibstellen verwenden weiterhin explizite Zeilenenden, unmittelbar oder über binäre Schreibhelfer:
   - `01_clean.R:600,775,780`
   - `02_estimate.R:149,150,151,186`
   - `03_figures.R:44,71`
   - `04_robustness.R:312,313,366`
   - `t008_power.R:84,125`

   In dieser Nacharbeit wurde keine Textschreibstelle verändert. Beleg: `write_calls.txt`.

2. **Erfüllt.** Frische Kopie mit gelöschten erzeugten Dateien: Exit **0**, **32/32 Ausgaben bytegleich**. Wiederholung mit `strict_pdf`: ebenfalls Exit **0**, **32/32 bytegleich**. Belege: `normal_sha256.csv`, `strict_pdf_unchanged_sha256.csv`.

3. **Erfüllt.** Frischer Build mit Test-Hook `MTPA_TEST_CRLF=1`: Exit **0**. Alle **19 CSV/TEX-Dateien** enthalten CRLF ohne einzelne LF-Zeilenumbrüche; normalisiert stimmen **32/32 Ausgaben** überein. Auch vorhandene LF-Ziele gegen CRLF-Neuausgaben bestehen die Guards über `source("run_all.R")` im Pfad mit Leerzeichen. Belege: `crlf_newlines.json`, `crlf_normalised_sha256.csv`, `crlf_mixed_normalised_sha256.csv`.

4. **Erfüllt.**
   - Numerischer Wert in geschützter CSV verändert: Standardmodus und `strict_pdf` jeweils Exit **1** mit Dateipfad; `warn` liefert Warnung und Exit **0**.
   - Geschützte PDF: Producer-Eintrag von R 4.6.0 auf R 4.4.0 geändert, bei gleicher Länge. Standardmodus: Informationsmeldung und Exit **0**; `strict_pdf`: klarer Abbruch, Exit **1**.
   - Manipulierte geschützte Dateien bleiben erhalten. Ungültige PDF-Kopfzeilen führen in allen drei Modi zu Exit **1**.

   Beleg: `test_results.json` und zugehörige Logs.

5. **Erfüllt.** Setup prüft ausschließlich die zehn `used`-Pakete; README kennzeichnet `did` und `rdrobust` als nicht benötigt. Lockdatei unverändert. Beleg: `static_checks.json`.

6. **Erfüllt.** Betriebssystemabschnitt dokumentiert PDF-Modi und getestete Versionen; Abschnitt 4 verlangt keine exakte R-Version 4.6.0. Veralteter Skeleton-Hinweis korrigiert, `run_all.R` als primärer Einstieg genannt. Keine widersprüchlichen Wind-Formulierungen; genau ein T010-Changelog-Eintrag. Beleg: `static_checks.json`.

7. **Erfüllt.** Unverändert: **7.317 Dateien in `Daten/`**, **17 Dateien in `replication/data/raw/`**, Panel und sämtliche Ausgaben. Aufgabenkarte einschließlich Status unverändert. Belege: `verification.json`, `project_outputs_sha256.csv`.

Alle genannten Belegdateien liegen unter `/private/tmp/T014_rework_3ghhk2gb/`.

## Offene Fragen

Kein echter Windows-Lauf und kein Lauf unter R 4.4/4.5 durchgeführt. Getestet wurde lokal mit R 4.6.0; unterschiedliche PDF-Producer-Metadaten wurden simuliert. Keine Stopp-Bedingung eingetreten; T004-Referenzhash unverändert.

Der Eintrag in `AI_USAGE_LOG.md` bleibt gemäß Co-PI-Rückmeldung dessen Aufgabe; die Datei wurde nicht geändert.