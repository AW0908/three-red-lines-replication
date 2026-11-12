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

[fenced excerpt withheld in public audit]
[fenced excerpt withheld in public audit]

Beide Läufe: Exit 0, jeweils 50,48 Sekunden. Letzte Ausgabe des zweiten Laufs:

[fenced excerpt withheld in public audit]
[fenced excerpt withheld in public audit]

## Abnahmekriterien

1. **Erfüllt.** C0 reproduziert alle 55 numerischen T009-Felder; maximale Abweichung `2,22e-15`. Alle 13 erzeugten T028-Artefakte sind zwischen beiden Builds byte-identisch. Die 95 übrigen Ausgaben und 20 Datendateien bleiben unverändert. Auch alle numerischen T028-Schätzergebnisse entsprechen exakt dem Stand vor REWORK.

2. **Für finanzielle Kontrollen erfüllt; für SOE nicht vollständig prüfbar.** Datumsassertions und Kontrollzusammenfassung bestätigen ausschließlich finanzielle Eingaben bis einschließlich `2019-12-31`. Die vorgeschriebene SOE-Kategorie bleibt wegen D9/D18 zeitlich eingeschränkt überprüfbar.

3. **Erfüllt.** Alle 30 C0–C5-Zellen bleiben enthalten. Änderungen gegenüber C0 in Baseline-SE-Einheiten:

   | Outcome | C3 | C4 | Einordnung |
   |---|---:|---:|---|
   | RL1 | −3,34 | −3,34 | Nicht stabil |
   | RL2 | −1,26 | −0,87 | Merklich kontrollsensitiv |
   | RL2 gap | +0,25 | +0,26 | Weitgehend stabil |
   | mi_share | −0,96 | −0,89 | Deutliche Abschwächung |
   | jv_ta | +1,33 | +1,10 | Merklich kontrollsensitiv |

   Der kontrollierte RL1-Vortrendtest verwirft mit `p = 0,000223`; der größere Koeffizient ist kein Beleg für einen stärkeren Policy-Effekt. Für mi_share verwirft der Test nicht (`p = 0,508751`). Überlappende Kontroll- und Vortrendfenster sowie die eingeschränkte CR1-Verlässlichkeit sind dokumentiert; JV-C4 verwendet 106 Steigungsparameter bei 101 Clustern.

4. **Erfüllt.** Fehlende finanzielle Kontrollwerte: Größe/ROA/Liquidität/Inventar/Umsatz = `0/2/0/0/2`; SOE fehlt bei fünf Firmen. C5 entfernt zwölf Firmen insgesamt, davon zehn im JV-Schätzsample (`101 → 91`). Die Balancegruppen enthalten nun `31/37/28/28` Firmen; alle 40 Balancezeilen wurden unabhängig nachgerechnet.

Beide TEX-Fragmente kompilieren ohne Überläufe. Tabellen und Abbildungen wurden visuell geprüft.

## Offene Fragen

- Keine neuen Umsetzungsfragen. SOE-Datierung und HK-Berichtswährungen bleiben bestehende Einschränkungen.
- Eine kausale Interpretation erfordert bedingte parallele Trends, keine Antizipation und keine verbleibenden dosisabhängigen Schocks. C5 selektiert anhand späterer Outcomes.
- `run_all.sh` wurde syntaktisch geprüft, nicht separat ausgeführt. Der Kartenstatus wurde nicht geändert.
- Vorschlag für `AI_USAGE_LOG.md`: „2026-10-23, Codex: T028-REWORK umgesetzt; unveränderte Schätzergebnisse, zwei vollständige Builds, Bytevergleiche und visuelle Ausgabekontrolle geprüft.“ Die Logdatei liegt außerhalb des Schreibbereichs.