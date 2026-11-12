## Ergebnis

T033 wurde gezielt nachgebessert: 42 bestehende Zeilen korrigiert, der zweite Huixin-Verkäufer ergänzt und 343 Zeilen unverändert übernommen. Alle 307 ursprünglichen Default-Zeilen aus 147 Ankündigungen wurden nachgeprüft. Der vollständige Build und die abschließenden Quellenprüfungen bestehen.

## Dateien

- `replication/data/raw/manual/handcollect/transactions.csv` – 386 Transaktions-/Beteiligtenzeilen mit korrigierten Seitenbelegen.
- `replication/data/raw/manual/handcollect/extraction_log_T033.md` – reproduzierbarer Build, Änderungszählung, vollständiges Nachprüfprotokoll und Namensausnahmen.
- `replication/data/raw/manual/handcollect/announcements_triage.csv` – 279 Zeilen, unverändert neu erzeugt.
- `replication/data/raw/manual/handcollect/case_notes.md` – inhaltlich unverändert neu erzeugt.
- `Daten/announcements/<firm_id>/txt/` – 2.929 Seitentexte neu erzeugt.

Korrigierte bestehende Zeilen je Feld; die neue Verkäuferzeile ist jeweils ausgeschlossen:

| Feld | Anzahl |
|---|---:|
| `holder_type` | 26 |
| `relation_to_listed_firm` | 33 |
| `subsidiary` | 5 |
| `counterparty_name` | 3 |
| `ownership_after_pct` | 1 |
| `counterparty_ownership_before_pct` | 1 |
| `ownership_basis` | 1 |
| `amount_basis` | 1 |
| `exit_deadline` und beide Belegfelder | jeweils 1 |
| `notes` | 5 |
| `section_source_excerpt` | 4 |
| `field_evidence_json` | 42 |

## Ausführung

Exakter Befehl, ausgeführt aus dem Projektordner:

[fenced excerpt withheld in public audit]
[fenced excerpt withheld in public audit]

Letzte Ausgabezeilen:

[fenced excerpt withheld in public audit]
[fenced excerpt withheld in public audit]

Exit-Code: 0. Zusätzlich wurden Huixin-Namen, Verkäuferanteile und Zahlungsfristen unmittelbar gegen neu extrahierten PDF-Text geprüft.

## Abnahmekriterien

1. **Technisch erfüllt; erneute unabhängige Abnahme offen:** 1.954 wortgleiche Feldanker und 474 positive Vertragsbelege geprüft. Der vorhandene Review bestätigt bereits 30 Stichprobenwerte des vorherigen Exports.
2. **Erfüllt:** ausschließlich lokale Ankündigungen, T032-Eingaben und freigegebenes Protokoll; kein Netzwerkzugriff.
3. **Erfüllt:** neun Haichuan-Benchmarkzeilen erhalten und Quellenprüfungen bestanden.
4. **Erfüllt:** `verified_by_PI` in allen 279 Triage- und 386 Transaktionszeilen leer.

## Offene Fragen

Erneuter unabhängiger Review und PI-Verifikation stehen aus. Zwölf unlesbare Dokumente bleiben ungecodet; die Quote von 5,26 % unterschreitet die Stoppgrenze.

Die 16 langen englischen Namen wurden als belegte Längenausnahmen vollständig erhalten. Der gemeinsame Huixin-Kaufpreis und der resultierende Gruppenanteil dürfen über die beiden Verkäuferzeilen nicht summiert werden.

Ein Vorschlag für `AI_USAGE_LOG.md` steht im Extraktionslog; die Datei liegt außerhalb des Schreibbereichs und wurde nicht geändert.