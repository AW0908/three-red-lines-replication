## Ergebnis

Die REWORK-Punkte sind umgesetzt: einheitliche Dosisgruppen, vollständige Listen entfernter Terme, „C3-date“-Beschriftung und ergänzte Interpretationshinweise. Der JV-C4-Standardfehler erscheint in der TEX-Tabelle als „--“. Sämtliche numerischen Schätzergebnisse bleiben unverändert; zwei vollständige Builds liefern byte-identische T028-Artefakte.

## Dateien

- `replication/code/10_controls.R` – Gruppierung, Termprotokollierung, Beschriftungen und Tabellennoten korrigiert.
- `replication/README.md` – Interpretation, Inferenzgrenzen und Verifikationspfad aktualisiert.
- `replication/outputs/tables/t028_balance.csv` – korrigierte Dosisgruppen.
- `replication/outputs/tables/t028_balance.tex` – korrigierte Gruppen und Rundungsnotiz.
- `replication/outputs/tables/t028_firm_controls.csv` – korrigierte Gruppenzuordnung.
- `replication/outputs/tables/t028_controls_did.csv` – vollständige `collinear_terms`.
- `replication/outputs/tables/t028_controls_did.tex` – ergänzte Hinweise; JV-C4-SE unterdrückt.
- `replication/outputs/tables/t028_event_study_controls.csv` – Beschriftung „C3-date“.
- `replication/outputs/tables/t028_pretrend_controls.csv` – Beschriftung „C3-date“.
- `replication/outputs/figures/t028_es_rl1_controls.pdf` – Beschriftung korrigiert.
- `replication/outputs/figures/t028_es_mi_share_controls.pdf` – Beschriftung korrigiert.
- `tasks/T028_verification.txt` – verschobene und aktualisierte Prüfbelege einschließlich beider Build-Logs.
- `replication/outputs/tables/t028_verification.txt` – nach `tasks/` verschoben.

## Ausführung

Exakter Befehl, zweimal in vollständigen isolierten Prüfkopien ausgeführt:

[fenced excerpt withheld in public process copy]
[fenced excerpt withheld in public process copy]

Beide Läufe: Exit [number withheld], jeweils [number withheld] Sekunden. Letzte Ausgabe des zweiten Laufs:

[fenced excerpt withheld in public process copy]
[fenced excerpt withheld in public process copy]

## Abnahmekriterien

[number withheld]. **Erfüllt.** C0 reproduziert alle [number withheld] numerischen T009-Felder; maximale Abweichung `[number withheld]`. Alle [number withheld] erzeugten T028-Artefakte sind zwischen beiden Builds byte-identisch. Die [number withheld] übrigen Ausgaben und [number withheld] Datendateien bleiben unverändert. Auch alle numerischen T028-Schätzergebnisse entsprechen exakt dem Stand vor REWORK.

[number withheld]. **Für finanzielle Kontrollen erfüllt; für SOE nicht vollständig prüfbar.** Datumsassertions und Kontrollzusammenfassung bestätigen ausschließlich finanzielle Eingaben bis einschließlich `2019-12-31`. Die vorgeschriebene SOE-Kategorie bleibt wegen D9/D1[number withheld] zeitlich eingeschränkt überprüfbar.

[number withheld]. **Erfüllt.** Alle [number withheld] C0–C5-Zellen bleiben enthalten. Änderungen gegenüber C0 in Baseline-SE-Einheiten:

   | Outcome | C3 | C4 | Einordnung |
   |---|---:|---:|---|
   | RL1 | [number withheld] | [number withheld] | Nicht stabil |
   | RL2 | [number withheld] | [number withheld] | Merklich kontrollsensitiv |
   | RL2 gap | [number withheld] | [number withheld] | Weitgehend stabil |
   | mi_share | [number withheld] | [number withheld] | Deutliche Abschwächung |
   | jv_ta | [number withheld] | [number withheld] | Merklich kontrollsensitiv |

   Der kontrollierte RL1-Vortrendtest verwirft mit `p = [number withheld]`; der größere Koeffizient ist kein Beleg für einen stärkeren Policy-Effekt. Für mi_share verwirft der Test nicht (`p = [number withheld]`). Überlappende Kontroll- und Vortrendfenster sowie die eingeschränkte CR1-Verlässlichkeit sind dokumentiert; JV-C4 verwendet [number withheld] Steigungsparameter bei [number withheld] Clustern.

[number withheld]. **Erfüllt.** Fehlende finanzielle Kontrollwerte: Größe/ROA/Liquidität/Inventar/Umsatz = `[number withheld]/[number withheld]/[number withheld]/[number withheld]/[number withheld]`; SOE fehlt bei fünf Firmen. C5 entfernt zwölf Firmen insgesamt, davon zehn im JV-Schätzsample (`[number withheld] → [number withheld]`). Die Balancegruppen enthalten nun `[number withheld]/[number withheld]/[number withheld]/[number withheld]` Firmen; alle [number withheld] Balancezeilen wurden unabhängig nachgerechnet.

Beide TEX-Fragmente kompilieren ohne Überläufe. Tabellen und Abbildungen wurden visuell geprüft.

## Offene Fragen

- Keine neuen Umsetzungsfragen. SOE-Datierung und HK-Berichtswährungen bleiben bestehende Einschränkungen.
- Eine kausale Interpretation erfordert bedingte parallele Trends, keine Antizipation und keine verbleibenden dosisabhängigen Schocks. C5 selektiert anhand späterer Outcomes.
- `run_all.sh` wurde syntaktisch geprüft, nicht separat ausgeführt. Der Kartenstatus wurde nicht geändert.
- Vorschlag für `AI_USAGE_LOG.md`: „2026-10-23, Codex: T028-REWORK umgesetzt; unveränderte Schätzergebnisse, zwei vollständige Builds, Bytevergleiche und visuelle Ausgabekontrolle geprüft.“ Die Logdatei liegt außerhalb des Schreibbereichs.