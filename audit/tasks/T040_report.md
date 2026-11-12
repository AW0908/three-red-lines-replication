## Ergebnis

Die drei REWORK-Punkte sind behoben: Definitionszuordnung, Tabellenanmerkung und Build-Übersicht. Alle 224 Kodierungen wurden auf falsch zugeordnete Definitionen geprüft; 17 Metadatenzeilen wurden korrigiert, ohne Zahlenwerte oder Schätzlogik zu ändern. Nahe 0,70 stützt die Validierung eine näherungsweise Übereinstimmung (MAE 0,570 Prozentpunkte; 76,9 % innerhalb eines Prozentpunkts), bei sechs abweichenden Schwellenklassifikationen. Die numerischen Ergebnisse sind unverändert: Mit Perpetual-Anpassung sinken b/D von 3,143/0,1146 auf 2,582/0,0930; die ausgewählte Matching-Stichprobe ergibt 8,809/0,270.

## Dateien

- `replication/data/raw/manual/rl1_validation/published_coded.csv` – 17 Definitions- und Metadatenkorrekturen.
- `replication/data/raw/manual/rl1_validation/coding_log.md` – vollständige Änderungsliste, Prüfverfahren und KI-Protokollvorschlag.
- `replication/code/13_rl1_validation.R` – präzisierte Coverage-Note und abgeschlossener PDF-Prüfstatus.
- `replication/README.md` – Schritt 13 als letzter Build-Schritt.
- `replication/outputs/tables/t040_validation.tex` – korrigierte Tabellenanmerkung.
- `replication/outputs/tables/t040_matched_observations.csv` – korrigierte Metadaten übernommen.
- `replication/outputs/tables/t040_verification.txt` – aktualisierter Prüfstatus.
- `replication/outputs/tables/t040_execution.log` – Ausführungs- und Abnahmebelege ergänzt.
- `replication/outputs/tables/t040_hashes.csv` – Prüfsummen aktualisiert.
- `replication/outputs/tables/t040_validation.csv`, `replication/outputs/tables/t040_disagreements.csv` – erneut erzeugt, byteidentisch.
- `replication/outputs/tables/t040_robustness.csv`, `replication/outputs/tables/t040_robustness.tex` – erneut erzeugt, byteidentisch.
- `replication/outputs/figures/t040_constructed_vs_published.pdf` – erneut erzeugt, byteidentisch.

## Ausführung

[fenced excerpt withheld in public audit]
[fenced excerpt withheld in public audit]

Exitcode 0. Letzte Ausgabezeilen:

[fenced excerpt withheld in public audit]
[fenced excerpt withheld in public audit]

Alle 14 Einträge des aktualisierten Prüfsummenmanifests wurden verifiziert.

## Abnahmekriterien

1. **Erfüllt:** Alle 224 eindeutigen Kodierungen haben vorhandene Quelldateien und positive PDF-Seitenangaben. Die Co-PI-Prüfung bestätigt 25/25 Werte; der einzelne `False`-Eintrag im Prüf-CSV ist laut Kartenrückmeldung durch „14.64 % = 0,1464“ erklärt. Nicht erneut geprüft.
2. **Erfüllt:** Assertions reproduzieren T023 b = 3,142854757615 und T029 D = 0,114617940199.
3. **Erfüllt:** Validierungsurteil und Robustheitsänderungen sind dokumentiert. Die Matching-Ergebnisse bleiben eine selektive Robustheitsprüfung mit breiten 95-%-Intervallen: b [1,757; 23,066], D [0,14; 0,41].

Die Coverage-Note unterscheidet nun kodierte Werte von verfügbaren Paaren: RL2 96/85, RL3 64/59. Die README-Übersicht entspricht der tatsächlichen Build-Reihenfolge.

## Offene Fragen

Keine offenen REWORK-Punkte. Der Gesamtbuild wurde nicht ausgeführt; Proposal-Anpassungen bleiben T039 vorbehalten. Firmenkonventionen und selektive Veröffentlichungsabdeckung begrenzen weiterhin die Interpretation; die Ergebnisse identifizieren keinen kausalen Politikeffekt. Kartenstatus unverändert `REWORK`; KI-Protokollvorschlag im `coding_log.md`.