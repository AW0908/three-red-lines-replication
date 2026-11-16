## Ergebnis

Das Replikationspaket baut alle [number withheld] Ausgaben aus einer frischen Kopie außerhalb des Projekts erfolgreich neu auf. Zwölf Entwicklungsdateien wurden unverändert ausgelagert; die vier T011-Abbildungen werden jetzt neu erzeugt. Bestehende Projektausgaben und `Daten/` sind nach Abschluss byte-identisch zum Ausgangszustand.

## Dateien

- `replication/code/04_robustness.R` – ergänzt vier T011-Event-Study-PDFs; Tabellen unverändert.
- `replication/code/provenance/t001_audit_a_shares.py` – verschoben; interne Ein-/Ausgabepfade.
- `replication/code/provenance/t003_audit_hk.py` – verschoben; interne Ein-/Ausgabepfade.
- `replication/code/provenance/t007_r_setup_check.R` – verschoben; Ausgabe nach `docs/provenance/`.
- `replication/docs/provenance/t001_a_firms.csv`, `replication/docs/provenance/t001_a_field_coverage.csv` – unverändert verschoben.
- `replication/docs/provenance/t003_hk_firms.csv`, `replication/docs/provenance/t003_hk_field_coverage.csv`, `replication/docs/provenance/t003_hk_fiscal_year_ends.csv`, `replication/docs/provenance/t003_hk_items.csv` – unverändert verschoben.
- `replication/docs/provenance/t007_r_packages.csv`, `replication/docs/provenance/t007_twfe_check.csv`, `replication/docs/provenance/t007_twfe_check.tex`, `replication/docs/provenance/t007_event_study_check.pdf` – unverändert verschoben.
- `replication/docs/provenance/t013_ownership_codex.csv`, `replication/docs/provenance/wind_nachholliste.csv` – unverändert verschoben.
- `replication/README.md` – Buildumfang, Laufzeit, Ordnerstruktur und Provenienz dokumentiert.

Prüfbelege liegen unter `/var/folders/zm/[number withheld]qc2[number withheld]n6[number withheld]l8fdpk4zdbt7x0[number withheld]gn/T/t0[number withheld]-evidence-jy6xbd0[number withheld]/`: `before.json`, `raw_check.txt`, `fresh_path.txt`, `fresh_run.log`, `fresh_result.json`, `fresh_comparison.csv`, `changes.json`, `verification.json`.

## Ausführung

[fenced excerpt withheld in public process copy]
[fenced excerpt withheld in public process copy]

Exitcode: **[number withheld]**. Letzte Ausgabezeilen:

[fenced excerpt withheld in public process copy]
[fenced excerpt withheld in public process copy]

Fresh-copy-Lauf: Exitcode **[number withheld]**, **[number withheld] Sekunden**; vollständiges Protokoll in `fresh_run.log`.

## Abnahmekriterien

[number withheld]. **Erfüllt:** Keine `../`-Referenz unter `replication/code/`, einschließlich Provenienzskripten.
[number withheld]. **Erfüllt:** Alle **[number withheld] Rohdateien** im Manifest; Größen und SHA-[number withheld] stimmen mit den Originalen überein.
[number withheld]. **Erfüllt:** **[number withheld]/[number withheld] Ausgaben** vollständig neu aufgebaut. Alle **[number withheld] CSV/TEX einschließlich Panel** und neun PDFs byte-identisch. Die vier ausdrücklich ausgenommenen T011-PDFs existieren und sind nicht leer; Unterschiede entstehen durch den ergänzten Plotstil und deterministische PDF-Metadaten.
[number withheld]. **Erfüllt:** Alle zehn direkt verwendeten R-Pakete stehen in Setup und Lockdatei. Installierte und dokumentierte Versionen stimmen überein.
[number withheld]. **Erfüllt:** `replication.Rproj` vorhanden; README beschreibt beide Startwege und gemessene Laufzeit.
[number withheld]. **Erfüllt:** **[number withheld] Dateien in `Daten/` unverändert**. Alle [number withheld] verbliebenen Projektausgaben stimmen abschließend mit ihren Ausgangshashes überein; zwölf verschobene Provenienzdateien ebenfalls.

## Offene Fragen

Windows wurde nicht praktisch getestet. R meldet für `data.table` und `readxl`, dass sie unter R [number withheld] gebaut wurden; beide Läufe unter R [number withheld] waren erfolgreich.

Die vier ursprünglichen T011-PDFs wurden nach dem Projektlauf wiederhergestellt, um die bestehenden Projektausgaben unverändert zu hinterlassen. Die neu erzeugten Fassungen liegen in der frischen Testkopie; deren Pfad steht in `fresh_path.txt`.

Vorschlag für das KI-Nutzungsprotokoll nach Abnahme: „Codex setzte T010 um: Provenienzdateien ausgelagert, T011-Abbildungen reproduzierbar ergänzt und vollständigen Offline-Neuaufbau mit SHA-[number withheld]-Vergleich geprüft.“