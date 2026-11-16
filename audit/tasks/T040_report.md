## Ergebnis

Die drei REWORK-Punkte sind behoben: Definitionszuordnung, Tabellenanmerkung und Build-Übersicht. Alle [number withheld] Kodierungen wurden auf falsch zugeordnete Definitionen geprüft; [number withheld] Metadatenzeilen wurden korrigiert, ohne Zahlenwerte oder Schätzlogik zu ändern. Nahe [number withheld] stützt die Validierung eine näherungsweise Übereinstimmung (MAE [number withheld] Prozentpunkte; [number withheld] % innerhalb eines Prozentpunkts), bei sechs abweichenden Schwellenklassifikationen. Die numerischen Ergebnisse sind unverändert: Mit Perpetual-Anpassung sinken b/D von [number withheld]/[number withheld] auf [number withheld]/[number withheld]; die ausgewählte Matching-Stichprobe ergibt [number withheld]/[number withheld].

## Dateien

- `replication/data/raw/manual/rl1_validation/published_coded.csv` – [number withheld] Definitions- und Metadatenkorrekturen.
- `replication/data/raw/manual/rl1_validation/coding_log.md` – vollständige Änderungsliste, Prüfverfahren und KI-Protokollvorschlag.
- `replication/code/13_rl1_validation.R` – präzisierte Coverage-Note und abgeschlossener PDF-Prüfstatus.
- `replication/README.md` – Schritt [number withheld] als letzter Build-Schritt.
- `replication/outputs/tables/t040_validation.tex` – korrigierte Tabellenanmerkung.
- `replication/outputs/tables/t040_matched_observations.csv` – korrigierte Metadaten übernommen.
- `replication/outputs/tables/t040_verification.txt` – aktualisierter Prüfstatus.
- `replication/outputs/tables/t040_execution.log` – Ausführungs- und Abnahmebelege ergänzt.
- `replication/outputs/tables/t040_hashes.csv` – Prüfsummen aktualisiert.
- `replication/outputs/tables/t040_validation.csv`, `replication/outputs/tables/t040_disagreements.csv` – erneut erzeugt, byteidentisch.
- `replication/outputs/tables/t040_robustness.csv`, `replication/outputs/tables/t040_robustness.tex` – erneut erzeugt, byteidentisch.
- `replication/outputs/figures/t040_constructed_vs_published.pdf` – erneut erzeugt, byteidentisch.

## Ausführung

[fenced excerpt withheld in public process copy]
[fenced excerpt withheld in public process copy]

Exitcode [number withheld]. Letzte Ausgabezeilen:

[fenced excerpt withheld in public process copy]
[fenced excerpt withheld in public process copy]

Alle [number withheld] Einträge des aktualisierten Prüfsummenmanifests wurden verifiziert.

## Abnahmekriterien

[number withheld]. **Erfüllt:** Alle [number withheld] eindeutigen Kodierungen haben vorhandene Quelldateien und positive PDF-Seitenangaben. Die Co-PI-Prüfung bestätigt [number withheld]/[number withheld] Werte; der einzelne `False`-Eintrag im Prüf-CSV ist laut Kartenrückmeldung durch „[number withheld] % = [number withheld]“ erklärt. Nicht erneut geprüft.
[number withheld]. **Erfüllt:** Assertions reproduzieren T023 b = [number withheld] und T029 D = [number withheld].
[number withheld]. **Erfüllt:** Validierungsurteil und Robustheitsänderungen sind dokumentiert. Die Matching-Ergebnisse bleiben eine selektive Robustheitsprüfung mit breiten [number withheld]-%-Intervallen: b [[number withheld]; [number withheld]], D [[number withheld]; [number withheld]].

Die Coverage-Note unterscheidet nun kodierte Werte von verfügbaren Paaren: RL2 [number withheld]/[number withheld], RL3 [number withheld]/[number withheld]. Die README-Übersicht entspricht der tatsächlichen Build-Reihenfolge.

## Offene Fragen

Keine offenen REWORK-Punkte. Der Gesamtbuild wurde nicht ausgeführt; Proposal-Anpassungen bleiben T039 vorbehalten. Firmenkonventionen und selektive Veröffentlichungsabdeckung begrenzen weiterhin die Interpretation; die Ergebnisse identifizieren keinen kausalen Politikeffekt. Kartenstatus unverändert `REWORK`; KI-Protokollvorschlag im `coding_log.md`.