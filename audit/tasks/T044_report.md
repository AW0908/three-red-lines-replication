## Ergebnis
[firm-specific excerpt withheld in public audit]

## Dateien
- `replication/code/16_pilot_magnitude.R` – Rework 4: neue Spalte `boundary_uncertain_group_ids`; CSV-Notiz präzisiert; TeX-Spalte „Bound.-unc.“ mit Notiz; Firmenzusammenfassung sagt „in-window“ bzw. „boundary-uncertain groups (not counted)“
- `replication/README.md` – T044-Eintrag: Satz zu den datumsunsicheren Gruppen präzisiert und um die neue Spalte ergänzt
- `replication/outputs/tables/t044_pilot_coding.csv/.tex` – kompakte Tabelle Firma × Kategorie (neu erzeugt)
- `replication/outputs/tables/t044_magnitude.csv/.tex` – jährliche Zerlegung von ΔMI (neu erzeugt, inhaltlich unverändert)
- `replication/outputs/tables/t044_firm_summaries.txt` – Drei-Zeilen-Zusammenfassung je Firma (neu erzeugt)
- `replication/outputs/tables/t044_number_sources.csv` – Zuordnung Zahl → Datei → Filter (neu erzeugt)
- übrige `replication/outputs/tables/t044_*` (accounting_checks, attribution_totals, check_sample, component_statements, evidence_checks, group_merges, input_integrity(.json/_checks), pending_statements, subsidiary_coverage, transaction_groups, verification_baseline.json, verification_row_checks) – neu erzeugt; byte-identisch zu Rework 3, außer den Dateien, die die neue Spalte oder Notiz tragen
- `replication/outputs/tables/t044_run1.log`, `t044_run2.log`, `t044_reproducibility.csv` – Läufe und Hash-Vergleich von Rework 4
- `tasks/T044_report.md` – dieser Bericht

In Rework 4 nicht verändert: `pilot_coding.csv`, `case_notes.md`, `case_notes_verification.csv`, `run_all.R/.sh` (Schritt 16 steht schon zuletzt) und die Audit-Dateien in `outputs/audit/T044/`.

## Ausführung
[fenced excerpt withheld in public audit]
[fenced excerpt withheld in public audit]
Die letzten Zeilen (in beiden Läufen identisch, `cmp` der Logs ohne Unterschied):
[fenced excerpt withheld in public audit]
[fenced excerpt withheld in public audit]
`t044_reproducibility.csv`: 19 von 19 Skriptausgaben mit SHA-256 in beiden Läufen gleich. Logs, die Vergleichsdatei selbst und `outputs/audit/T044/` sind keine Skriptausgaben und gehören nicht zur Reproduzierbarkeitsaussage.

### Firmenzusammenfassungen (aus `t044_firm_summaries.txt`, Beträge in Mio. RMB, alle Figuren `unverified`)
[firm-specific excerpt withheld in public audit]
[firm-specific excerpt withheld in public audit]
[firm-specific excerpt withheld in public audit]
[firm-specific excerpt withheld in public audit]
[firm-specific excerpt withheld in public audit]
[firm-specific excerpt withheld in public audit]
[firm-specific excerpt withheld in public audit]
[firm-specific excerpt withheld in public audit]
[firm-specific excerpt withheld in public audit]
[firm-specific excerpt withheld in public audit]
[firm-specific excerpt withheld in public audit]
[firm-specific excerpt withheld in public audit]

[firm-specific excerpt withheld in public audit]
[firm-specific excerpt withheld in public audit]

### Zahl → Datei → Filter
| Zahl | Datei | Filter / Formel |
|---|---|---|
| ΔMI, mi_opening/closing | `data/processed/panel_firm_halfyear.csv` (`mi`) | firm_id; Stichtage = Geschäftsjahresende laut `reports_needed` |
| profit_nci | Panel (`ni_mi`) | nur Jahreswerte der Geschäftsjahre im Fenster |
| dividends_to_nci, capital_from_nci | `data/raw/manual/handcollect/nci_cashflow.csv` | Geschäftsjahre im Fenster; gedruckter Strich = 0; leer = NA |
| cash_D…cash_U | `pilot_coding.csv` | `paid_contribution_rmb` mit `paid_period` im Fenster; nur Gruppen im Fenster |
| residual | `t044_magnitude.csv` | ΔMI − Gewinn + Dividenden − Kapital |
| N, Rows, Beträge je Kategorie | `pilot_coding.csv` | record_type=transaction; Gruppe mit mindestens einer Zeile `within`; Kategorie = schwerste Kategorie der Gruppe |
| Bound.-unc. | `pilot_coding.csv` | Gruppen, deren Zeilen alle `uncertain_boundary` sind |
| Zuordnungssummen | `t044_magnitude.csv` | Firmenzeilen mit capital_from_nci ≠ NA |

Die vollständige Zuordnung je Zelle steht in `t044_number_sources.csv`.

## Abnahmekriterien
[firm-specific excerpt withheld in public audit]
2. **Rubrik wie geschrieben: erfüllt.** Das Skript leitet die Kategorie aus den Merkmalsspalten neu ab und prüft sie mit `stopifnot`. Der D-Subtyp kommt nur aus den Merkmalen, ohne Ausnahmen nach ID oder Text. Jede Zeile hat eine Begründung, die das entscheidende Merkmal nennt.
3. **Bestehende Zeilen unverändert: erfüllt.** Der Präfix-Hash von `case_notes.md` und die 46 ursprünglichen ID/Text-Zeilen von `case_notes_verification.csv` sind geprüft; Metadaten wurden nur durch den PI geändert (`t044_input_integrity_checks.csv`, alle PASS). In Rework 4 wurde keine der beiden Dateien angefasst.
4. **Zwei Läufe identisch, Zerlegung geht auf: erfüllt.** 19/19 Dateien sind byte-identisch (`t044_reproducibility.csv`). Die Identität ΔMI = Gewinn − Dividenden + Kapital + Residuum gilt bis auf 0,005 RMB für alle vollständigen Zeilen (`t044_accounting_checks.csv`).
5. **Offene Aussagen gelistet, nichts Unverifiziertes als verifiziert: erfüllt.** 28 Aussagen warten auf die PI-Prüfung (`t044_pending_statements.csv`), nach Zeilen in `case_notes.md`:
[firm-specific excerpt withheld in public audit]
[firm-specific excerpt withheld in public audit]
[firm-specific excerpt withheld in public audit]
[firm-specific excerpt withheld in public audit]
[firm-specific excerpt withheld in public audit]
[firm-specific excerpt withheld in public audit]
[firm-specific excerpt withheld in public audit]

[firm-specific excerpt withheld in public audit]

## Offene Fragen
1. **Befund 1 der Konsistenzprüfung:** Die Zählungen waren schon korrekt bereinigt (Prüfung: keine ID in `group_ids` gehört zu einer datumsunsicheren Gruppe). Unklar waren nur die Notizen und die fehlende Spalte in der TeX-Tabelle. Beides ist jetzt eindeutig. Die Zahlen blieben unverändert.
[firm-specific excerpt withheld in public audit]
[firm-specific excerpt withheld in public audit]
4. **Nullen in cash_D/G/E/U:** Eine 0 bedeutet „keine belegte Zahlungszuordnung“, nicht „keine solche Finanzierung“. Die TeX-Notiz sagt das; die CSV-Spalten der Magnitude-Tabelle tragen den Hinweis nicht selbst (Hinweis 4 der Datenprüfung; nicht Teil von Rework 4).
[firm-specific excerpt withheld in public audit]
6. **Abdeckung:** Für alle zehn Firmen bleibt die vollständige Aufzählung der Minderheitszeichnungen offen (U-Abdeckungsmarker). Es gibt keine Aussage zur Verbreitung über die zehn Firmen hinaus.
7. **Nicht von mir geprüft:** Die PDF-Seiten der Stichprobe habe ich in Rework 4 nicht erneut gelesen; das Ergebnis stammt aus der Prüfung in Rework 2 und dem automatischen Textabgleich in beiden Läufen. Der AI_USAGE_LOG-Eintrag (Befund 3) ist laut Co-PI erledigt; er steht als Zeile 13 in `AI_USAGE_LOG.md`.
