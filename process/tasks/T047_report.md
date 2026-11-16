## Ergebnis

Die sieben Rework-Punkte für T047 sind umgesetzt. Verifikationslabels, NA-Zuordnungen, vier Gewinnbelege und Tabellenhinweise wurden korrigiert; Stichprobe und Kategorien bleiben unverändert. Beide Abschlussläufe liefern [number withheld]/[number withheld] byte-identische Ausgaben; vier numerische und [number withheld] qualitative PI-Prüfungen bleiben offen.

## Dateien

Alle in diesem Rework geänderten, erzeugten oder neu geschriebenen Dateien:

- `replication/README.md` – aktualisierter T047-Eintrag.
- `replication/code/18_crossers_coding.R` – Rework-Korrekturen und Prüfungen.
- `replication/data/raw/manual/handcollect/case_notes.md` – vier Ersatz-Aussagen angehängt.
- `replication/outputs/tables/t047_coding.csv` – Kategorien, Verifikationslabels und D1-Hinweis.
- `replication/outputs/tables/t047_coding.tex` – beschriftete Kodierungstabelle.
- `replication/outputs/tables/t047_magnitude.csv` – korrigierte NA- und Verifikationsregeln.
- `replication/outputs/tables/t047_magnitude.tex` – Einheiten, Spaltendefinitionen und Fensterhinweis.
- `replication/outputs/tables/t047_attribution_totals.csv` – Zuordnung für beobachtete Firmenjahre mit Fensterhinweis.
- `replication/outputs/tables/t047_pending_numeric.csv` – vier offene numerische Prüfungen.
- `replication/outputs/tables/t047_pending_qualitative.csv` – [number withheld] offene qualitative Prüfungen.
- `replication/outputs/tables/t047_pending_statements.csv` – [number withheld] offene Prüfungen insgesamt.
- `replication/outputs/audit/T047/README.md` – aktueller Audit-Wegweiser.
- `replication/outputs/audit/T047/accounting_checks.csv` – Zerlegungsidentitäten.
- `replication/outputs/audit/T047/allocation_checks.csv` – NA- und Verifikationsprüfungen.
- `replication/outputs/audit/T047/appended_statements.csv` – Aussagen mit neuer Spalte `superseded_by`.
- `replication/outputs/audit/T047/capital_firm_years_all.csv` – Kapitalabdeckung des Gesamtpools.
- `replication/outputs/audit/T047/capital_firm_years_new.csv` – Kapitalabdeckung der neuen Ereignisse.
- `replication/outputs/audit/T047/check_sample.csv` – unveränderte Stichprobe neu erzeugt.
- `replication/outputs/audit/T047/check_sample_review.csv` – erneute Worker-Seitenprüfung.
- `replication/outputs/audit/T047/component_ledger.csv` – Operanden und aktuelle Verifikationslabels.
- `replication/outputs/audit/T047/component_sources_input.csv` – vier korrigierte Gewinnbelege.
- `replication/outputs/audit/T047/event_transactions.csv` – Ereigniszuordnungen.
- `replication/outputs/audit/T047/evidence_checks.csv` – [number withheld] PDF-Auszugprüfungen.
- `replication/outputs/audit/T047/execution.log` – Ausgabe des zweiten Abschlusslaufs.
- `replication/outputs/audit/T047/finalize_rework_report.py` – Berichtserstellung und Dateiabgleich.
- `replication/outputs/audit/T047/firm_summaries.txt` – drei erzeugte Zeilen je Firma.
- `replication/outputs/audit/T047/input_integrity.csv` – Datei-, Präfix- und Zeilenintegrität.
- `replication/outputs/audit/T047/number_file_filter.csv` – Zahlenherkunft und Filter.
- `replication/outputs/audit/T047/output_manifest.csv` – vollständiges Dateiverzeichnis.
- `replication/outputs/audit/T047/pilot_reuse_checks.csv` – [number withheld] erneut geprüfte Pilot-Kategoriezahlen.
- `replication/outputs/audit/T047/preflight_summary.txt` – verbindliche Stichprobendefinition.
- `replication/outputs/audit/T047/rework_checks.csv` – [number withheld] gezielte Prüfungen.
- `replication/outputs/audit/T047/rework_integrity_overrides.csv` – begründete Checkpoints für Karte und Quellenkorrekturen.
- `replication/outputs/audit/T047/rework_notes_append.md` – neuer Notizblock.
- `replication/outputs/audit/T047/rework_notes_baseline.csv` – Notizpräfix vor Rework.
- `replication/outputs/audit/T047/rework_pages/600162.SH_FY2021_p73.png` – geprüfte Gewinnbelegseite.
- `replication/outputs/audit/T047/rework_pages/600325.SH_FY2021_p128.png` – geprüfte Gewinnbelegseite.
- `replication/outputs/audit/T047/rework_pages/600683.SH_FY2021_p90.png` – geprüfte Gewinnbelegseite.
- `replication/outputs/audit/T047/rework_pages/600773.SH_FY2021_p76.png` – geprüfte Gewinnbelegseite.
- `replication/outputs/audit/T047/rework_pdf_checks.csv` – visuelle Prüfung dieser vier Seiten.
- `replication/outputs/audit/T047/rework_profit_sources.py` – einmalige, gegen Wiederholung gesperrte Belegkorrektur.
- `replication/outputs/audit/T047/rework_scope_checks.csv` – abschließender Schreibbereichs- und Dateiabgleich.
- `replication/outputs/audit/T047/rework_start_files.csv` – Startinventar mit Prüfsummen.
- `replication/outputs/audit/T047/rework_verification_baseline.csv` – PI-Verifikationsdatei bei Rework-Beginn.
- `replication/outputs/audit/T047/run1.log` – erster erfolgreicher Abschlusslauf.
- `replication/outputs/audit/T047/run1_hashes.csv` – Prüfsummen nach Lauf [number withheld].
- `replication/outputs/audit/T047/run2.log` – zweiter erfolgreicher Abschlusslauf.
- `replication/outputs/audit/T047/run2_hashes.csv` – Prüfsummen nach Lauf [number withheld].
- `replication/outputs/audit/T047/sample_mapping.csv` – Ereignis-, Fenster- und Jahreszuordnung.
- `replication/outputs/audit/T047/source_inventory.csv` – lokale Quellenverfügbarkeit.
- `replication/outputs/audit/T047/statement_revisions.csv` – alte und neue Aussagen-IDs sowie korrigierte Auszüge.
- `replication/outputs/audit/T047/tex_validation.log` – erfolgreiche separate TeX-Prüfung.
- `replication/outputs/audit/T047/transaction_groups.csv` – Gruppenverifikation und historischer D1-Hinweis.
- `replication/outputs/audit/T047/two_run_checks.csv` – [number withheld]/[number withheld] Bytevergleiche.
- `replication/outputs/audit/T047/verification_checks.csv` – Verifikationsprüfung der Operanden.
- `replication/outputs/audit/T047/verification_row_checks.csv` – Identität der [number withheld] vorhandenen Verifikationszeilen.
- `replication/outputs/audit/T047/verify_rework.py` – zweifache Ausführung und gezielte Prüfungen.
- `tasks/T047_report.md` – vollständiger Rework-Bericht.

## Ausführung

Exakter Kartenbefehl, zweimal mit Exit [number withheld] ausgeführt:

[fenced excerpt withheld in public process copy]
[fenced excerpt withheld in public process copy]

Letzte sieben Ausgabezeilen des zweiten Laufs:

[fenced excerpt withheld in public process copy]
[fenced excerpt withheld in public process copy]

Zusätzlich ausgeführt:

[fenced excerpt withheld in public process copy]
[fenced excerpt withheld in public process copy]

Ergebnis: **[number withheld]/[number withheld] Bytevergleiche und [number withheld]/[number withheld] gezielte Prüfungen PASS**. Beide TeX-Fragmente bestehen zwei separate LaTeX-Prüfläufe ohne Fehler oder überbreite Zeilen. Poppler meldet Hinweise zu bestehenden PDF-Fonts und Optional Content; sämtliche angeforderten Auszüge passen.

## Abnahmekriterien

[firm-specific excerpt withheld in public process copy]

[number withheld]. **Erfüllt.** Die T044-Rework-[number withheld]-Rubrik reproduziert sämtliche Kategorien aus den Merkmalen. **[number withheld]/[number withheld]** Pilot-Kategoriezahlen und **[number withheld]/[number withheld]** monetäre Komponenten der sechs wiederverwendeten Fenster stimmen mit T044 überein. Stichprobe, Filter und Kategorien wurden nicht verändert.

[number withheld]. **Erfüllt nach der verbindlichen Rework-Regel.** **[number withheld]/[number withheld] Integritätsprüfungen PASS**: [number withheld] Datei-/Präfixhashes und die Zeilenintegrität der Verifikationsdatei. Das ursprüngliche **[number withheld]-Byte-Präfix** und sämtliche **[number withheld] Bytes** der Notizen vor diesem Rework bleiben erhalten. **[number withheld]/[number withheld]** vorhandene Verifikationszeilen behalten ID und Text; der Worker hat die PI-Datei byte-identisch gelassen. **[number withheld]/[number withheld] geschützte Dateien** sind unverändert. Zwei explizite Checkpoints dokumentieren die bereits vom Co-PI ergänzte Karte und die freigegebenen Quellenkorrekturen; die ursprüngliche Baseline bleibt erhalten.

[number withheld]. **Erfüllt.** **[number withheld]/[number withheld] Build-Ausgaben byte-identisch**. Vollständig sind **[number withheld]/[number withheld] Ereignis- und [number withheld]/[number withheld] Firmenzerlegungen**; die Identitätsabweichungen liegen unter **RMB [number withheld]**. Das Residuum ist definitorisch ΔMI − NCI-Gewinn + Dividenden − NCI-Kapital und damit keine unabhängige Quellenbestätigung. **[number withheld]/[number withheld] Magnitudenzeilen** bestehen die Zuordnungsprüfungen: Bei fehlendem Kapital bleiben alle neun Zuordnungsbeträge NA; auch beide strikten Pools bleiben NA.

[number withheld]. **Erfüllt.** Verifizierte Operanden sind an PI=yes, aktuellen Text und Zeilen-ID gebunden. **[number withheld]/[number withheld] Ledger-Zeilen** sind verifiziert; vier beobachtete Gewinnoperanden mit neuen Aussagen bleiben unverifiziert, [number withheld] Operanden fehlen. `cash_not_attributed` verlangt verifiziertes Kapital, verifizierte Zuordnung und sämtliche Kategorien des Firmenfensters. Eine leere Zuordnung zählt stets als unverifiziert. Sämtliche Zuordnungs- und Nichtzuordnungsbeträge bleiben gegenwärtig unverifiziert; es wurden keine PI-Entscheidungen gesetzt.

**Gepoolte Transaktionszahlen.** Gezählt werden eindeutige wirtschaftliche Gruppen. Grenzfälle und Abdeckungsmarker sind ausgeschlossen; gekennzeichnete Pläne und historische Vertragsbedingungen sind enthalten.

| Pool | D1 | D2 | D? | G | H | E | U | Nur Grenzfälle |
|---|---:|---:|---:|---:|---:|---:|---:|---:|
| Alle [number withheld] Ereignisse / [number withheld] Firmen | [number withheld] | [number withheld] | [number withheld] | [number withheld] | [number withheld] | [number withheld] | [number withheld] | [number withheld] |
| Neue [number withheld] Ereignisse / [number withheld] Firmen | [number withheld] | [number withheld] | [number withheld] | [number withheld] | [number withheld] | [number withheld] | [number withheld] | [number withheld] |

[firm-specific excerpt withheld in public process copy]

**Kapital-Headline, Mio. RMB; unverifiziert.** Englische Zahlenschreibweise; ausschließlich beobachtete Firmenjahre.

| Pool | Beobachtete / erforderliche Firmenjahre | NCI-Kapital | Zugeordnet | Nicht zugeordnet | Quote |
|---|---:|---:|---:|---:|---:|
| Alle Ereignisse | [number withheld]/[number withheld] | [number withheld] | [number withheld] | [number withheld] | [number withheld] % |
| Neue Ereignisse | [number withheld]/[number withheld] | [number withheld] | [number withheld] | [number withheld] | [number withheld] % |

[firm-specific excerpt withheld in public process copy]

Transaktionen werden bis `date1` gezählt, Geldströme bis Geschäftsjahresende. Die Zuordnungsquote ist deshalb eine **untere Schranke für das Geschäftsjahresfenster**. Dieser Hinweis steht auch in der Zuordnungstabelle und in TeX. Die strikten Gesamtpools einschließlich Zuordnungsbeträgen bleiben NA.

**Drei Zeilen je Firma.** Geldbeträge in Mio. RMB mit englischer Zahlenschreibweise. Betragsreihenfolge: ΔMI / NCI-Gewinn / NCI-Kapital / Dividenden / zugeordnet / Residuum. `--` bedeutet fehlend; Abdeckung bleibt bei allen Firmen U. Sämtliche Gesamtzeilen bleiben unverifiziert; einzelne Operanden haben eigene Labels in der CSV.

[fenced excerpt withheld in public process copy]
[fenced excerpt withheld in public process copy]

**Offene numerische PI-Prüfungen:**

| Firma | Zeilen in `case_notes.md` |
|---|---|
[firm-specific excerpt withheld in public process copy]
[firm-specific excerpt withheld in public process copy]
[firm-specific excerpt withheld in public process copy]
[firm-specific excerpt withheld in public process copy]

**Offene qualitative PI-Prüfungen:**

| Firma | Zeilen in `case_notes.md` |
|---|---|
[firm-specific excerpt withheld in public process copy]
[firm-specific excerpt withheld in public process copy]
[firm-specific excerpt withheld in public process copy]
[firm-specific excerpt withheld in public process copy]

[firm-specific excerpt withheld in public process copy]

[firm-specific excerpt withheld in public process copy]

**Zahl → Datei → Filter/Formel.** Alle **[number withheld] numerischen Tabellenzellen** sind in `replication/outputs/audit/T047/number_file_filter.csv` dokumentiert.

| Größe | Datei | Filter/Formel |
|---|---|---|
| Ereignisse, Firmen, Wiederverwendung | `replication/outputs/audit/T047/sample_mapping.csv` | exakter Vergleich von Firma und Ereignisfenster |
| Kategorien und D-Untertypen | `replication/outputs/tables/t047_coding.csv` | eindeutige Gruppen mit within-Eintrag; Grenzfälle separat |
| Zerlegungsoperanden | `replication/outputs/audit/T047/component_ledger.csv` | Firma + Geschäftsjahr + Kennzahl; Jahresvereinigung je Firma |
| Residuum | `replication/outputs/tables/t047_magnitude.csv` | ΔMI − Gewinn + Dividenden − Kapital |
| Beobachtetes Kapital | `replication/outputs/audit/T047/capital_firm_years_all.csv`, `replication/outputs/audit/T047/capital_firm_years_new.csv` | eindeutige Firma + Jahr; ausschließlich beobachtete Werte |
| Zugeordnetes Kapital | `replication/data/raw/manual/handcollect/crossers_coding.csv` | bezahlte Transaktionen innerhalb des Fensters und im passenden beobachteten Geschäftsjahr |
| Nicht zugeordnetes Kapital | `replication/outputs/tables/t047_attribution_totals.csv` | beobachtetes Kapital minus zugeordnete Zahlungen |
| Offene PI-Prüfungen | `replication/outputs/tables/t047_pending_statements.csv` | aktuelle verwendete Aussagen ohne ausreichende Verifikation; supersedierte IDs ausgeschlossen |

## Offene Fragen

- Vier numerische und [number withheld] qualitative PI-Prüfungen sowie die unabhängige Abnahme dieses Reworks stehen aus. Worker-Seitenchecks ersetzen diese Prüfungen nicht.
[firm-specific excerpt withheld in public process copy]
- Die lokale Offenlegung erlaubt keine vollständige Transaktionsinventur. U erlaubt keine Aussage über echte oder kosmetische Finanzierung. Die Stichprobe umfasst auch schuldgetriebene Crossings; die Ergebnisse sind deskriptiv.
[firm-specific excerpt withheld in public process copy]
- Gesamtbuild und Proposal-Einbindung wurden nicht ausgeführt, um geschützte T044-Ausgaben nicht neu zu schreiben. Die TeX-Fragmente wurden separat übersetzt. Der Kartenstatus bleibt `REWORK`.
- Vorschlag für den Co-PI zum außerhalb des Schreibbereichs liegenden `AI_USAGE_LOG.md`: „2026-10-30, Codex, T047 Rework: Verifikations- und NA-Regeln korrigiert, vier Gewinnbelege lokal geprüft und Ersatz-Aussagen angehängt, Tabellenhinweise präzisiert. Zwei R-Läufe byte-identisch; [number withheld] Quellenchecks und [number withheld] gezielte Prüfungen bestanden. Vier numerische und [number withheld] qualitative PI-Prüfungen sowie unabhängige Abnahme offen.“