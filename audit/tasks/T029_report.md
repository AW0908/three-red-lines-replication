## Ergebnis

Die Netto-Compliance-Differenz D beträgt **11,46 Prozentpunkte post gegenüber 4,06 im Placebo**; die Differenz beträgt **7,40 [3,10; 11,82]** (129/125 Firmen). Die bedingte Ausfallquote beträgt nach der Politik 24,35 % gegenüber 10,37 % im Placebo; ihr eigener Kontrast beträgt 0,140 [0,069; 0,217] (79/71 Firmen). Teil C verwendet jetzt den Placebo-Anker 2016, prüft die Inferenzgrenze je tatsächlicher Statistikzelle und berichtet die Gruppenkontraste; Teil A bleibt numerisch unverändert.

## Dateien

- `replication/code/11_mechanism.R` – freigegebene Korrekturen und zusätzliche TeX-Ausgaben.
- `replication/README.md` – aktualisierte Pipeline-, Ausgabe- und Changelog-Angaben.
- `replication/outputs/tables/t029_compliance.csv`, `replication/outputs/tables/t029_compliance.tex` – umbenannte Ausschlussvariante, korrigierte Noten und Placebo-Fallzahlen.
- `replication/outputs/tables/t029_counterfactual_bunching.csv`, `replication/outputs/tables/t029_counterfactual_bunching.tex` – Variantenname und Erklärung gleicher Bunching-Werte bei unterschiedlichem N.
- `replication/outputs/tables/t029_debt_benchmark.csv` – Variantenname korrigiert.
- `replication/outputs/tables/t029_distance_es.csv`, `replication/outputs/tables/t029_distance_es.tex` – Inferenzhinweis und explizite MI-Vorperiodenbefunde.
- `replication/outputs/tables/t029_incentive.csv`, `replication/outputs/tables/t029_incentive.tex` – korrigierte Anker, Gruppenkontraste und zellenspezifische Inferenzgrenzen.
- `replication/outputs/tables/t029_distance_components.csv` – neu erzeugt, bytegleich.
- `replication/outputs/tables/t029_coverage.txt` – aktualisierte Definitionen, Grenzen und Befunde.
- `replication/outputs/tables/t029_verification.txt` – Laufprotokolle, unabhängige Prüfungen und SHA-256-Belege.
- `replication/outputs/figures/t029_compliance_shares.pdf` – unverbundenes Erweiterungsfenster ab 2023H1.
- `replication/outputs/figures/t029_distance_es.pdf` – Halbjahresbeschriftungen und Inferenzhinweis.
- `replication/outputs/figures/t029_bunching_frozen.pdf` – neu erzeugt, bytegleich.

## Ausführung

Zweimal vollständig ausgeführt:

[fenced excerpt withheld in public audit]
[fenced excerpt withheld in public audit]

Letzte Ausgabe des zweiten Laufs:

[fenced excerpt withheld in public audit]
[fenced excerpt withheld in public audit]

## Abnahmekriterien

1. **Erfüllt:** Gleichheitsfehler maximal 2,22e−16; T023 reproduziert b = 3,142854757615. Alle 139 geschützten Daten-/Ausgabedateien bleiben bytegleich; sämtliche 14 erzeugten T029-Artefakte sind zwischen beiden vollständigen Läufen bytegleich.
2. **Erfüllt:** Vorgesehene Statistiken und Firmenzahlen sind ausgewiesen, ohne Sterne. Teil C enthält 52 inferentielle und 28 `descriptive_small_cell`-Zeilen; kleine Zellen haben keine Konfidenzintervalle und „--“ im TeX. Unabhängige Nachrechnung bestätigt alle Kennzahlen, Fallzahlen, Inferenzgrenzen und 52 Bootstrap-Intervalle; maximaler Intervallfehler 4,44e−16.
3. **Erfüllt:** Das gepaarte Bunching fällt von 3,18 auf −0,52; Differenz 3,71 [1,60; 6,14], 129 Firmen. Nach der vorgegebenen Regel hängt das Bunching damit mechanisch am MI-Wachstum seit 2019. Das positive Placebo begrenzt die Interpretation zusätzlich: Die MI-Vorperiodenkoeffizienten für den knapp oberhalb liegenden Bin betragen 2016H2 bis 2018H1 −0,0235, −0,0230, −0,0201 und −0,0171; alle punktweisen Intervalle schließen null aus. Diese Firmen bauten MI bereits vor 2020 schneller auf; Teil B beschreibt differenzielle Anpassung, keinen Policy-Effekt.

Alle vier TeX-Fragmente kompilieren ohne Warnungen; Tabellen und Abbildungen wurden visuell geprüft.

## Offene Fragen

Keine neue Stopp-Bedingung. Ungeklärte HK-Berichtswährungen, selektive Erweiterungsabdeckung und unbekannte Sprung-Flags bleiben dokumentiert. `exclude_jump_dates` entfernt ausschließlich Sprungdaten; spätere Daten behalten den Sprung im MI-Bestand. Minderheitsanteile können echtes Eigenkapital sein; die Kontrafaktuale messen weder erreichbare Bilanzen noch ökonomische Verschuldung.

Aufgabenkarte und Status `REWORK` wurden nicht verändert. Vorgeschlagener KI-Protokolleintrag: „2026-10-25, Codex: T029-Rework, korrigierte Placebo-Anker und Inferenzgrenzen, Dokumentation und Reproduzierbarkeitsprüfung.“ `AI_USAGE_LOG.md` liegt außerhalb des Schreibbereichs und wurde nicht geändert.