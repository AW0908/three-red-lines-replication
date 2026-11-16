## Ergebnis

Die Netto-Compliance-Differenz D beträgt **[number withheld] Prozentpunkte post gegenüber [number withheld] im Placebo**; die Differenz beträgt **[number withheld] [[number withheld]; [number withheld]]** ([number withheld]/[number withheld] Firmen). Die bedingte Ausfallquote beträgt nach der Politik [number withheld] % gegenüber [number withheld] % im Placebo; ihr eigener Kontrast beträgt [number withheld] [[number withheld]; [number withheld]] ([number withheld]/[number withheld] Firmen). Teil C verwendet jetzt den Placebo-Anker [number withheld], prüft die Inferenzgrenze je tatsächlicher Statistikzelle und berichtet die Gruppenkontraste; Teil A bleibt numerisch unverändert.

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
- `replication/outputs/tables/t029_verification.txt` – Laufprotokolle, unabhängige Prüfungen und SHA-[number withheld]-Belege.
- `replication/outputs/figures/t029_compliance_shares.pdf` – unverbundenes Erweiterungsfenster ab [number withheld]H1.
- `replication/outputs/figures/t029_distance_es.pdf` – Halbjahresbeschriftungen und Inferenzhinweis.
- `replication/outputs/figures/t029_bunching_frozen.pdf` – neu erzeugt, bytegleich.

## Ausführung

Zweimal vollständig ausgeführt:

[fenced excerpt withheld in public process copy]
[fenced excerpt withheld in public process copy]

Letzte Ausgabe des zweiten Laufs:

[fenced excerpt withheld in public process copy]
[fenced excerpt withheld in public process copy]

## Abnahmekriterien

[number withheld]. **Erfüllt:** Gleichheitsfehler maximal [number withheld]e−[number withheld]; T023 reproduziert b = [number withheld]. Alle [number withheld] geschützten Daten-/Ausgabedateien bleiben bytegleich; sämtliche [number withheld] erzeugten T029-Artefakte sind zwischen beiden vollständigen Läufen bytegleich.
[number withheld]. **Erfüllt:** Vorgesehene Statistiken und Firmenzahlen sind ausgewiesen, ohne Sterne. Teil C enthält [number withheld] inferentielle und [number withheld] `descriptive_small_cell`-Zeilen; kleine Zellen haben keine Konfidenzintervalle und „--“ im TeX. Unabhängige Nachrechnung bestätigt alle Kennzahlen, Fallzahlen, Inferenzgrenzen und [number withheld] Bootstrap-Intervalle; maximaler Intervallfehler [number withheld]e−[number withheld].
[number withheld]. **Erfüllt:** Das gepaarte Bunching fällt von [number withheld] auf [number withheld]; Differenz [number withheld] [[number withheld]; [number withheld]], [number withheld] Firmen. Nach der vorgegebenen Regel hängt das Bunching damit mechanisch am MI-Wachstum seit [number withheld]. Das positive Placebo begrenzt die Interpretation zusätzlich: Die MI-Vorperiodenkoeffizienten für den knapp oberhalb liegenden Bin betragen [number withheld]H2 bis [number withheld]H1 [number withheld], [number withheld], [number withheld] und [number withheld]; alle punktweisen Intervalle schließen null aus. Diese Firmen bauten MI bereits vor [number withheld] schneller auf; Teil B beschreibt differenzielle Anpassung, keinen Policy-Effekt.

Alle vier TeX-Fragmente kompilieren ohne Warnungen; Tabellen und Abbildungen wurden visuell geprüft.

## Offene Fragen

Keine neue Stopp-Bedingung. Ungeklärte HK-Berichtswährungen, selektive Erweiterungsabdeckung und unbekannte Sprung-Flags bleiben dokumentiert. `exclude_jump_dates` entfernt ausschließlich Sprungdaten; spätere Daten behalten den Sprung im MI-Bestand. Minderheitsanteile können echtes Eigenkapital sein; die Kontrafaktuale messen weder erreichbare Bilanzen noch ökonomische Verschuldung.

Aufgabenkarte und Status `REWORK` wurden nicht verändert. Vorgeschlagener KI-Protokolleintrag: „2026-10-25, Codex: T029-Rework, korrigierte Placebo-Anker und Inferenzgrenzen, Dokumentation und Reproduzierbarkeitsprüfung.“ `AI_USAGE_LOG.md` liegt außerhalb des Schreibbereichs und wurde nicht geändert.