Historical pre-rework worker report. Superseded by T073 Rework 1, WITHHELD.md, OUTPUT_RECHECK.csv and CHECKS.json. Its old counts and commit refer to the previous candidate.

## Ergebnis

`public_release/` wurde erstellt und der ESCALATE-Konflikt gemäß PI-Entscheidung behoben. Von 411 geprüften Outputs sind 323 enthalten und 88 begründet zurückgehalten; das öffentliche Panel enthält 1.880 Zeilen, 150 Firmen und 77 Spalten. Git-Erstcommit `f9a664e` liegt auf `main`, das Arbeitsverzeichnis ist sauber; kein Push wurde ausgeführt.

## Dateien

- `public_release/MANIFEST.csv` – vollständige Einzelliste der 812 Nutzdateien mit Größen und SHA-256 sowie 88 zurückgehaltenen Einträgen.
- `public_release/README.md`, `public_release/REPRODUCIBILITY.csv` – Anleitung und Wind-Abhängigkeiten je Skript.
- `public_release/OUTPUT_INVENTORY.csv`, `public_release/WITHHELD.md` – vollständige Konfliktinventur und Ausschlussbegründungen.
- `public_release/data/processed/` – öffentliches Panel, entfernte Firmen und Spalten sowie Provenienzbelege.
- `public_release/data/raw/manual/DOCUMENTS.md` – Dokumentenregister mit vorhandenen Quellen- und Seitenangaben.
- `public_release/code/`, `public_release/data/`, `public_release/outputs/`, `public_release/audit/`, `public_release/software/` – freigegebene Archivbestandteile; jede einzelne Datei steht im MANIFEST.
- `public_release/release_tools/`, `public_release/validation/` – Build- und Prüfroutinen samt Ergebnissen.
- `public_release/LICENSE`, `public_release/LICENSE-data.md`, `public_release/.gitignore`, `public_release/.git/` – Lizenzen, Ausschlüsse und lokales Repository.
- `tasks/T073_report.md` – ausführlicher Worker-Bericht.

## Ausführung

Exakter Kartenbefehl, Exitcode 0:

[fenced excerpt withheld in public audit]
[fenced excerpt withheld in public audit]

Die Ausgabe endet mit dem README-Abschnitt `Privacy, licences and audit fidelity` und dem Satz:

[fenced excerpt withheld in public audit]
[fenced excerpt withheld in public audit]

Zusätzlich wurden Build, isolierte Dry Runs und Abschlussprüfung ausgeführt. Letzte Prüfausgabe:

[fenced excerpt withheld in public audit]
[fenced excerpt withheld in public audit]

## Abnahmekriterien

- **1 – erfüllt mit dokumentierten Grenzen:** MANIFEST vollständig; keine Wind-Exporte oder vollständigen Originalpanels enthalten. 34 Wind-Firmen und zwölf Wind-basierte Spalten entfernt; sämtliche erhaltenen Panelwerte stimmen zellweise mit dem Original überein.
- **Datenschutzprüfung – erfüllt im dokumentierten Scan:** null Treffer für geprüfte Geheimnismuster, E-Mail-Adressen und unbereinigte Benutzerpfade.
- **Größenprüfung – erfüllt:** 126.882.295 Bytes Nutzdaten; einschließlich Git 162.442.776 Bytes. Keine Datei über 50 MB.
- **Dry Run – erfüllt mit dokumentierten Blockern:** Setup, A-Share-Audit, Theme und R-Simulationstest erfolgreich. HK-Audit und Panel-Build stoppen erwartungsgemäß am fehlenden Wind-Register. Fetcher-Start wurde mit gesperrtem Netzwerk geprüft.
- **2 – erfüllt innerhalb des Schreibbereichs:** 985 geprüfte Eingaben unverändert; außerhalb des Release nur den ausdrücklich zugelassenen Worker-Bericht geschrieben. Kartenstatus unverändert.
- **Git-Zusatz – erfüllt:** ein Commit auf `main`, Ziel-Remote konfiguriert, Arbeitsverzeichnis sauber, kein Push.

## Offene Fragen

Die vollständigen wissenschaftlichen Ergebnisse benötigen Wind-Zugang und weitere in den Originalskripten verlangte Projektdateien beziehungsweise PDFs. Unklare firmenbezogene Outputs bleiben gemäß PI-Regel 6 zurückgehalten. Providerrechte wurden offline nicht neu geprüft; fehlende Dokumenten-URLs und Seitenangaben sind gekennzeichnet. Das MANIFEST schließt sich selbst und Git-Verwaltungsdateien aus; der Datenschutzscan deckt die dokumentierten Muster ab.