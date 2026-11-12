## Ergebnis

T019 einschließlich beider Nachträge ist umgesetzt. S14 entspricht exakt S0, da beide ausgeschlossenen Firmen bereits außerhalb von `sample_main` liegen. Projektlauf und Fresh-copy-Build endeten mit Exit 0; sämtliche nicht freigegebenen Ausgaben blieben bytegleich.

## Dateien

- `replication/code/02_estimate.R` – Caption/Label und einzelne Zentrierung.
- `replication/code/04_robustness.R` – S14 mit Assertions.
- `replication/code/05_heterogeneity.R` – SOE-Grafik und Tabellenmetadaten.
- `replication/code/t008_power.R` – zehn zusätzliche `main_dose_pre`-Zeilen.
- `replication/outputs/tables/t009_did_main.tex` – Tabellenmetadaten korrigiert.
- `replication/outputs/tables/t011_robustness.csv` – fünf S14-Zeilen ergänzt.
- `replication/outputs/tables/t011_robustness.tex` – S14 ergänzt.
- `replication/outputs/tables/t008_mde.csv` – zusätzliche MDEs.
- `replication/outputs/tables/t008_mde.tex` – zusätzliche MDEs und Erläuterung.
- `replication/outputs/tables/t015_soe_heterogeneity.tex` – Caption/Label ergänzt.
- `replication/outputs/figures/t019_soe_coefficients.pdf` – fünf Facetten mit Split-Schätzungen und 95%-Konfidenzintervallen.
- `replication/README.md` – Ausgabeliste, Robustheitsliste und Changelog.
- `/private/tmp/T019_rdw_bmwx/` – Vergleichskopien, Laufprotokolle, Prüfskripte, Diffs und SHA-256-Belege. `changed_sha256.csv` enthält alle zwölf neuen/geänderten Projektdateien.

## Ausführung

Exakter Ausführungsbefehl, Exit **0**:

[fenced excerpt withheld in public audit]
[fenced excerpt withheld in public audit]

Letzte Ausgabezeilen:

[fenced excerpt withheld in public audit]
[fenced excerpt withheld in public audit]

Fresh-copy-Build: ebenfalls Exit **0**, 8,27 Sekunden.

## Abnahmekriterien

[firm-specific excerpt withheld in public audit]
2. **Erfüllt:** Haupttabelle enthält genau eine Caption, `tab:did_main` und eine Zentrierung. Nach Rücknahme dieser erlaubten Änderungen ist sie bytegleich zum Original.
3. **Erfüllt:** PDF vorhanden und visuell geprüft. Alle zehn dargestellten Schätzwerte und Konfidenzintervalle entsprechen den CSV-Split-Zeilen; fünf Facetten mit freien y-Skalen.
4. **Erfüllt:** Frische Kopie baut erfolgreich. Alle 32 unverändert zu haltenden Vergleichsdateien einschließlich Panel sind bytegleich. Sämtliche 38 Projektausgaben entsprechen der frischen Kopie.
5. **Nachträge erfüllt:** Zehn `main_dose_pre`-MDE-Zeilen ergänzt; alle 14 bisherigen CSV- und TEX-Ergebniszeilen bytegleich. SOE-Tabelle ausschließlich um Caption und `tab:soe_het` ergänzt.

Belege: `fresh_comparison.csv`, `verification.json`, `plot_check.log` und `changed_sha256.csv` im genannten Belegverzeichnis.

## Offene Fragen

Keine Stopp-Bedingung eingetreten. Rohdaten und Aufgabenstatus wurden nicht verändert. Der Co-PI ergänzte während des Laufs die Karte um die ausdrückliche Erlaubnis paralleler T019/T020-Arbeit.

Die Konstruktion von `dose_pre` überlappt die Placebo-Periode; die ergänzten MDEs sind eine Präzisionsrechnung, kein unabhängiger Paralleltrendtest. Dies steht in den Tabellennotizen.

KI-Protokollvorschlag für den Co-PI: „2026-10-18, Codex: T019 umgesetzt; Verifikation durch vollständige Builds, Bytevergleiche, SHA-256 und grafische Werteprüfung.“