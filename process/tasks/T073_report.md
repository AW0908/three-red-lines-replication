## Ergebnis

T073 Rework [number withheld] ist umgesetzt. Die Leave-one-out-Datei und die nicht ausreichend belegte manuelle Eigentümerdatei werden zurückgehalten; Provenienzangaben, MANIFEST und Prüfungen wurden erneuert. Neuer Git-Erstcommit: `e3ab3c7` auf `main`, sauberer Arbeitsbaum, kein Push.

## Dateien

Alle folgenden Release-Pfade liegen unter `public_release/`:

- `OUTPUT_INVENTORY.csv`, `WITHHELD.md`, `MANIFEST.csv` – korrigierte Klassifikation, Ausschlüsse und Prüfsummen.
- `outputs/tables/t031_leave_one_out.csv`, `data/raw/manual/ownership_manual_coding.csv` – entfernt; Originale unverändert.
- `data/raw/manual/DOCUMENTS.md`, `data/processed/REMOVED_COLUMNS.csv`, `data/raw/MANIFEST.csv`, `README.md` – Quellen und Ausschlussgründe ergänzt.
- `release_tools/build_release.py`, `release_tools/check_release.py`, `release_tools/dry_run.py` – Build und Prüfungen angepasst.
- `validation/OUTPUT_RECHECK.csv`, `validation/WITHHELD_INPUTS.csv`, `validation/CHECKS.json`, `validation/DATA_ID_MATCHES.csv`, `validation/DRY_RUN.md`, `validation/SOURCE_HASHES.csv` – erneuerte Prüfbelege.
- `audit/AI_USAGE_LOG.md`, `audit/review/T073.md`, `audit/review/T073_data.md`, `audit/runs.log`, `audit/tasks/T073.md` – aktualisierte, bereinigte Auditkopien.
- `audit/tasks/T073_report.md` – vorherigen Bericht als überholten Kandidatenbericht gekennzeichnet.
- `.git/` – Erstcommit neu aufgebaut; alte Commit-Objekte entfernt.
- `tasks/T073_report.md` im Projektordner – ausführlicher Worker-Bericht.

## Ausführung

Kartenbefehl ausgeführt, Exitcode [number withheld]:

[fenced excerpt withheld in public process copy]
[fenced excerpt withheld in public process copy]

Die letzte Ausgabezeile endet mit:

[fenced excerpt withheld in public process copy]
[fenced excerpt withheld in public process copy]

Zusätzlich ausgeführt:

[fenced excerpt withheld in public process copy]
[fenced excerpt withheld in public process copy]

Letzte Abschlussprüfungszeile:

[fenced excerpt withheld in public process copy]
[fenced excerpt withheld in public process copy]

## Abnahmekriterien

- **Rework [number withheld] – erfüllt:** Leave-one-out-Datei mit [number withheld] Firmenzeilen und [number withheld] entfernten IDs zurückgehalten. Alle [number withheld] verbleibenden Outputs erneut geprüft, einschließlich PDF-Textextraktion; keine weiteren entsprechenden Ausschlüsse. Verbleibende firmenbezogene Dateien mit jeweils null entfernten IDs:
  - `t061_control_panel.csv`: [number withheld] Zeilen.
  - `t061_download_failures.csv`: [number withheld] Zeilen.
  - `t063_control_membership.csv`: [number withheld] Zeilen.
- **Rework [number withheld] – erfüllt:** fünf Provenienzzeilen dokumentiert. Vier Datensätze behalten; manuelle Eigentümerdatei wegen unvollständigen Primärquellenbelegs zurückgehalten. Die Cashflow-Datei enthält keine `panel_mi_check`-Diagnosen.
- **Rework [number withheld] – erfüllt:** zwölf Spalten einzeln mit Quellen, Skriptzeilen und Begründungen dokumentiert; gemischte Eigentümerfelder konservativ entfernt.
- **Wind-Prüfung und MANIFEST – erfüllt unter der PI-Freigabe für Aggregate:** öffentliches Panel mit [number withheld] Zeilen, [number withheld] Firmen und [number withheld] Spalten; [number withheld] Firmen und zwölf Spalten entfernt. Erhaltene Panelwerte stimmen zellweise mit dem Original überein. Alle Nutzdatei-Hashes verifiziert.
- **Datenschutz – erfüllt im dokumentierten Scan:** null Treffer für geprüfte Geheimnis-, E-Mail- und unbereinigte Benutzerpfadmuster.
- **Größe – erfüllt:** [number withheld] Bytes Nutzdateien; einschließlich Git [number withheld] Bytes. Größte Datei: [number withheld] Bytes.
- **Dry Run – erfüllt mit dokumentierten Grenzen:** Setup, A-Share-Audit, Simulation und Theme abgeschlossen. HK-Audit und Panel-Build stoppen am fehlenden Wind-Register; Fetcher startet und stoppt an der blockierten Netzwerkgrenze.
- **Schreibbereich – erfüllt:** [number withheld] geprüfte Eingaben unverändert; außerhalb des Release ausschließlich den zugelassenen Bericht geschrieben. Kartenstatus unverändert.
- **Git – erfüllt:** ein Commit `e3ab3c7f5[number withheld]f3[number withheld]c9[number withheld]a9ef0a7bddcf0[number withheld]b9[number withheld]df4`, Branch `main`, [number withheld] versionierte Dateien, sauberer Arbeitsbaum, Ziel-Remote eingerichtet, kein Push.

## Offene Fragen

Für die zurückgehaltene Eigentümerdatei fehlen vollständige öffentliche Primärquellenbelege. PDFs und Providerrechte wurden offline nicht erneut geprüft; vollständige wissenschaftliche Reproduktion benötigt weiterhin Wind und weitere dokumentierte Eingaben.

Der historische Simulationstest meldet trotz erfolgreichem Ablauf eine vorpolitische Periode ohne Null im Intervall; das bleibt im Dry-Run-Protokoll sichtbar. MANIFEST schließt sich selbst und Git-Verwaltungsdateien aus.