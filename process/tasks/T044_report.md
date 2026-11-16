## Ergebnis
[firm-specific excerpt withheld in public process copy]

## Dateien
- `replication/code/16_pilot_magnitude.R` – Rework [number withheld]: neue Spalte `boundary_uncertain_group_ids`; CSV-Notiz präzisiert; TeX-Spalte „Bound.-unc.“ mit Notiz; Firmenzusammenfassung sagt „in-window“ bzw. „boundary-uncertain groups (not counted)“
- `replication/README.md` – T044-Eintrag: Satz zu den datumsunsicheren Gruppen präzisiert und um die neue Spalte ergänzt
- `replication/outputs/tables/t044_pilot_coding.csv/.tex` – kompakte Tabelle Firma × Kategorie (neu erzeugt)
- `replication/outputs/tables/t044_magnitude.csv/.tex` – jährliche Zerlegung von ΔMI (neu erzeugt, inhaltlich unverändert)
- `replication/outputs/tables/t044_firm_summaries.txt` – Drei-Zeilen-Zusammenfassung je Firma (neu erzeugt)
- `replication/outputs/tables/t044_number_sources.csv` – Zuordnung Zahl → Datei → Filter (neu erzeugt)
- übrige `replication/outputs/tables/t0[number withheld]_*` (accounting_checks, attribution_totals, check_sample, component_statements, evidence_checks, group_merges, input_integrity(.json/_checks), pending_statements, subsidiary_coverage, transaction_groups, verification_baseline.json, verification_row_checks) – neu erzeugt; byte-identisch zu Rework [number withheld], außer den Dateien, die die neue Spalte oder Notiz tragen
- `replication/outputs/tables/t044_run1.log`, `t044_run2.log`, `t044_reproducibility.csv` – Läufe und Hash-Vergleich von Rework [number withheld]
- `tasks/T044_report.md` – dieser Bericht

In Rework [number withheld] nicht verändert: `pilot_coding.csv`, `case_notes.md`, `case_notes_verification.csv`, `run_all.R/.sh` (Schritt [number withheld] steht schon zuletzt) und die Audit-Dateien in `outputs/audit/T044/`.

## Ausführung
[fenced excerpt withheld in public process copy]
[fenced excerpt withheld in public process copy]
Die letzten Zeilen (in beiden Läufen identisch, `cmp` der Logs ohne Unterschied):
[fenced excerpt withheld in public process copy]
[fenced excerpt withheld in public process copy]
`t044_reproducibility.csv`: [number withheld] von [number withheld] Skriptausgaben mit SHA-[number withheld] in beiden Läufen gleich. Logs, die Vergleichsdatei selbst und `outputs/audit/T044/` sind keine Skriptausgaben und gehören nicht zur Reproduzierbarkeitsaussage.

### Firmenzusammenfassungen (aus `t044_firm_summaries.txt`, Beträge in Mio. RMB, alle Figuren `unverified`)
[firm-specific excerpt withheld in public process copy]
[firm-specific excerpt withheld in public process copy]
[firm-specific excerpt withheld in public process copy]
[firm-specific excerpt withheld in public process copy]
[firm-specific excerpt withheld in public process copy]
[firm-specific excerpt withheld in public process copy]
[firm-specific excerpt withheld in public process copy]
[firm-specific excerpt withheld in public process copy]
[firm-specific excerpt withheld in public process copy]
[firm-specific excerpt withheld in public process copy]
[firm-specific excerpt withheld in public process copy]
[firm-specific excerpt withheld in public process copy]

[firm-specific excerpt withheld in public process copy]
[firm-specific excerpt withheld in public process copy]

### Zahl → Datei → Filter
| Zahl | Datei | Filter / Formel |
|---|---|---|
| ΔMI, mi_opening/closing | `data/processed/panel_firm_halfyear.csv` (`mi`) | firm_id; Stichtage = Geschäftsjahresende laut `reports_needed` |
| profit_nci | Panel (`ni_mi`) | nur Jahreswerte der Geschäftsjahre im Fenster |
| dividends_to_nci, capital_from_nci | `data/raw/manual/handcollect/nci_cashflow.csv` | Geschäftsjahre im Fenster; gedruckter Strich = [number withheld]; leer = NA |
| cash_D…cash_U | `pilot_coding.csv` | `paid_contribution_rmb` mit `paid_period` im Fenster; nur Gruppen im Fenster |
| residual | `t044_magnitude.csv` | ΔMI − Gewinn + Dividenden − Kapital |
| N, Rows, Beträge je Kategorie | `pilot_coding.csv` | record_type=transaction; Gruppe mit mindestens einer Zeile `within`; Kategorie = schwerste Kategorie der Gruppe |
| Bound.-unc. | `pilot_coding.csv` | Gruppen, deren Zeilen alle `uncertain_boundary` sind |
| Zuordnungssummen | `t044_magnitude.csv` | Firmenzeilen mit capital_from_nci ≠ NA |

Die vollständige Zuordnung je Zelle steht in `t044_number_sources.csv`.

## Abnahmekriterien
[firm-specific excerpt withheld in public process copy]
[number withheld]. **Rubrik wie geschrieben: erfüllt.** Das Skript leitet die Kategorie aus den Merkmalsspalten neu ab und prüft sie mit `stopifnot`. Der D-Subtyp kommt nur aus den Merkmalen, ohne Ausnahmen nach ID oder Text. Jede Zeile hat eine Begründung, die das entscheidende Merkmal nennt.
[number withheld]. **Bestehende Zeilen unverändert: erfüllt.** Der Präfix-Hash von `case_notes.md` und die [number withheld] ursprünglichen ID/Text-Zeilen von `case_notes_verification.csv` sind geprüft; Metadaten wurden nur durch den PI geändert (`t044_input_integrity_checks.csv`, alle PASS). In Rework [number withheld] wurde keine der beiden Dateien angefasst.
[number withheld]. **Zwei Läufe identisch, Zerlegung geht auf: erfüllt.** [number withheld]/[number withheld] Dateien sind byte-identisch (`t044_reproducibility.csv`). Die Identität ΔMI = Gewinn − Dividenden + Kapital + Residuum gilt bis auf [number withheld] RMB für alle vollständigen Zeilen (`t044_accounting_checks.csv`).
[number withheld]. **Offene Aussagen gelistet, nichts Unverifiziertes als verifiziert: erfüllt.** [number withheld] Aussagen warten auf die PI-Prüfung (`t044_pending_statements.csv`), nach Zeilen in `case_notes.md`:
[firm-specific excerpt withheld in public process copy]
[firm-specific excerpt withheld in public process copy]
[firm-specific excerpt withheld in public process copy]
[firm-specific excerpt withheld in public process copy]
[firm-specific excerpt withheld in public process copy]
[firm-specific excerpt withheld in public process copy]
[firm-specific excerpt withheld in public process copy]

[firm-specific excerpt withheld in public process copy]

## Offene Fragen
[number withheld]. **Befund [number withheld] der Konsistenzprüfung:** Die Zählungen waren schon korrekt bereinigt (Prüfung: keine ID in `group_ids` gehört zu einer datumsunsicheren Gruppe). Unklar waren nur die Notizen und die fehlende Spalte in der TeX-Tabelle. Beides ist jetzt eindeutig. Die Zahlen blieben unverändert.
[firm-specific excerpt withheld in public process copy]
[firm-specific excerpt withheld in public process copy]
[number withheld]. **Nullen in cash_D/G/E/U:** Eine [number withheld] bedeutet „keine belegte Zahlungszuordnung“, nicht „keine solche Finanzierung“. Die TeX-Notiz sagt das; die CSV-Spalten der Magnitude-Tabelle tragen den Hinweis nicht selbst (Hinweis [number withheld] der Datenprüfung; nicht Teil von Rework [number withheld]).
[firm-specific excerpt withheld in public process copy]
[number withheld]. **Abdeckung:** Für alle zehn Firmen bleibt die vollständige Aufzählung der Minderheitszeichnungen offen (U-Abdeckungsmarker). Es gibt keine Aussage zur Verbreitung über die zehn Firmen hinaus.
[number withheld]. **Nicht von mir geprüft:** Die PDF-Seiten der Stichprobe habe ich in Rework [number withheld] nicht erneut gelesen; das Ergebnis stammt aus der Prüfung in Rework [number withheld] und dem automatischen Textabgleich in beiden Läufen. Der AI_USAGE_LOG-Eintrag (Befund [number withheld]) ist laut Co-PI erledigt; er steht als Zeile [number withheld] in `AI_USAGE_LOG.md`.
