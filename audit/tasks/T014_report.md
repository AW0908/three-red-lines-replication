## Ergebnis

Die REWORK-Punkte sind umgesetzt: Geschützte PDFs werden auf Existenz und PDF-Kopfzeile geprüft; Byteabweichungen erzeugen standardmäßig eine Information, mit `MTPA_GUARDS=strict_pdf` einen Abbruch. Textguards bleiben standardmäßig streng. README korrigiert; alle [number withheld] erzeugten Ausgaben bleiben bytegleich.

## Dateien

- `replication/code/00_setup.R` – PDF-Prüffunktion und optionaler strenger Bytevergleich.
- `replication/code/03_figures.R` – neue Prüfung für geschützte PDFs eingebunden.
- `replication/README.md` – PDF-Modi, R-Anforderungen, Paketstatus und primären Einstieg korrigiert.
- `/private/tmp/T0[number withheld]_rework_3ghhk2gb/` – Testskript, zwölf Laufprotokolle, Testkopien, SHA-[number withheld]-Tabellen und Prüfbelege.

## Ausführung

Vorgeschriebenen Befehl selbst ausgeführt, Exit **[number withheld]**:

[fenced excerpt withheld in public process copy]
[fenced excerpt withheld in public process copy]

Letzte Ausgabezeilen:

[fenced excerpt withheld in public process copy]
[fenced excerpt withheld in public process copy]

Zusätzliche Tests:

[fenced excerpt withheld in public process copy]
[fenced excerpt withheld in public process copy]

Abschluss: `PASS: all rework tests`. Exakte Befehle, Arbeitsverzeichnisse, Umgebungsvariablen und Exitcodes stehen in `test_results.json`.

## Abnahmekriterien

[number withheld]. **Erfüllt.** Alle [number withheld] Textschreibstellen verwenden weiterhin explizite Zeilenenden, unmittelbar oder über binäre Schreibhelfer:
   - `[number withheld]_clean.R:[number withheld]`
   - `[number withheld]_estimate.R:[number withheld]`
   - `[number withheld]_figures.R:[number withheld]`
   - `[number withheld]_robustness.R:[number withheld]`
   - `t0[number withheld]_power.R:[number withheld]`

   In dieser Nacharbeit wurde keine Textschreibstelle verändert. Beleg: `write_calls.txt`.

[number withheld]. **Erfüllt.** Frische Kopie mit gelöschten erzeugten Dateien: Exit **[number withheld]**, **[number withheld]/[number withheld] Ausgaben bytegleich**. Wiederholung mit `strict_pdf`: ebenfalls Exit **[number withheld]**, **[number withheld]/[number withheld] bytegleich**. Belege: `normal_sha256.csv`, `strict_pdf_unchanged_sha256.csv`.

[number withheld]. **Erfüllt.** Frischer Build mit Test-Hook `MTPA_TEST_CRLF=[number withheld]`: Exit **[number withheld]**. Alle **[number withheld] CSV/TEX-Dateien** enthalten CRLF ohne einzelne LF-Zeilenumbrüche; normalisiert stimmen **[number withheld]/[number withheld] Ausgaben** überein. Auch vorhandene LF-Ziele gegen CRLF-Neuausgaben bestehen die Guards über `source("run_all.R")` im Pfad mit Leerzeichen. Belege: `crlf_newlines.json`, `crlf_normalised_sha256.csv`, `crlf_mixed_normalised_sha256.csv`.

[number withheld]. **Erfüllt.**
   - Numerischer Wert in geschützter CSV verändert: Standardmodus und `strict_pdf` jeweils Exit **[number withheld]** mit Dateipfad; `warn` liefert Warnung und Exit **[number withheld]**.
   - Geschützte PDF: Producer-Eintrag von R [number withheld] auf R [number withheld] geändert, bei gleicher Länge. Standardmodus: Informationsmeldung und Exit **[number withheld]**; `strict_pdf`: klarer Abbruch, Exit **[number withheld]**.
   - Manipulierte geschützte Dateien bleiben erhalten. Ungültige PDF-Kopfzeilen führen in allen drei Modi zu Exit **[number withheld]**.

   Beleg: `test_results.json` und zugehörige Logs.

[number withheld]. **Erfüllt.** Setup prüft ausschließlich die zehn `used`-Pakete; README kennzeichnet `did` und `rdrobust` als nicht benötigt. Lockdatei unverändert. Beleg: `static_checks.json`.

[number withheld]. **Erfüllt.** Betriebssystemabschnitt dokumentiert PDF-Modi und getestete Versionen; Abschnitt [number withheld] verlangt keine exakte R-Version [number withheld]. Veralteter Skeleton-Hinweis korrigiert, `run_all.R` als primärer Einstieg genannt. Keine widersprüchlichen Wind-Formulierungen; genau ein T010-Changelog-Eintrag. Beleg: `static_checks.json`.

[number withheld]. **Erfüllt.** Unverändert: **[number withheld] Dateien in `Daten/`**, **[number withheld] Dateien in `replication/data/raw/`**, Panel und sämtliche Ausgaben. Aufgabenkarte einschließlich Status unverändert. Belege: `verification.json`, `project_outputs_sha256.csv`.

Alle genannten Belegdateien liegen unter `/private/tmp/T0[number withheld]_rework_3ghhk2gb/`.

## Offene Fragen

Kein echter Windows-Lauf und kein Lauf unter R [number withheld]/[number withheld] durchgeführt. Getestet wurde lokal mit R [number withheld]; unterschiedliche PDF-Producer-Metadaten wurden simuliert. Keine Stopp-Bedingung eingetreten; T004-Referenzhash unverändert.

Der Eintrag in `AI_USAGE_LOG.md` bleibt gemäß Co-PI-Rückmeldung dessen Aufgabe; die Datei wurde nicht geändert.