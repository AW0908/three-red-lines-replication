## Ergebnis

Die freigegebenen Rework-[number withheld]-Punkte zu T077 sind umgesetzt: sechs überarbeitete und visuell geprüfte PDFs, separate Bildunterschriften, harte Produktionspfadtests und ergänzte Ergebnisoffenlegung. Alle [number withheld] unverändert zu haltenden statistischen CSVs stimmen mit Freeze und Archiv überein; alle [number withheld] endgültigen Laufartefakte sind über zwei Läufe byte-identisch und sämtliche [number withheld] Validierungen bestehen. HonestDiD bleibt NOT RUN; die erneute unabhängige Prüfung und PI-Abnahme stehen aus.

Primärer Kontrast: Veränderung von Z = L − (P6[number withheld] + P8[number withheld])/[number withheld] bei Entwicklern minus Veränderung bei Kontrollen, mit gleichen Firmen- und Stichtagsgewichten im balancierten Hauptpanel.

| Stichprobe | Markt | Kontrast (pp) | [number withheld]%-Intervall | p, unbereinigt |
|---|---|---:|---|---:|
| primary | A | [number withheld] | [[number withheld]; [number withheld]] | ≈[number withheld] |
| primary | HK | [number withheld] | [[number withheld]; [number withheld]] | ≈[number withheld] |
| unbalanced_developers | A | [number withheld] | [[number withheld]; [number withheld]] | ≈[number withheld] |
| unbalanced_developers | HK | [number withheld] | [[number withheld]; [number withheld]] | ≈[number withheld] |
| HK_no_imputation | HK | [number withheld] | [[number withheld]; [number withheld]] | ≈[number withheld] |

Quelle: `replication/outputs/tables/t077_estimates.csv`. Beide primären Holm-bereinigten p-Werte betragen [number withheld]. Alle [number withheld] Kontraste einschließlich Nullbefunden und separaten Placebo-Bezügen sind gespeichert; jede Schätzung hat [number withheld] gültige und null fehlgeschlagene Bootstrapziehungen.

Die Hauptstichprobe umfasst [number withheld] Entwickler/[number withheld] Kontrollen in A und [number withheld]/[number withheld] in HK. Die HK-Sensitivität ohne fehlende Vorauszahlungsposten umfasst [number withheld]/[number withheld] Firmen; das unbalancierte HK-Entwicklerpanel umfasst [number withheld] Firmen. Die gesamten A-Analysedaten sind zwischen Haupt- und Sensitivitätsanalyse identisch; die Inferenzunterschiede sind Monte-Carlo-Streuung.

Der gemeinsame Vorperiodentest ergibt gerundet A p≈[number withheld] und HK p≈[number withheld]. Die HK-Nichtverwerfung bestätigt parallele Trends nicht: Im unteren Zielfenster stehen vor der Politik nur [number withheld]–[number withheld] Entwickler pro Stichtag, insgesamt [number withheld] Firma-Stichtage. In A sind es [number withheld]–[number withheld] pro Stichtag.

Der untere Fensterkontrast L beträgt A [number withheld] [[number withheld]; [number withheld]] pp und HK [number withheld] [[number withheld]; [number withheld]] pp. Der größere A-Z-Kontrast entsteht zusätzlich durch relative Rückgänge bei P6[number withheld] ([number withheld] pp) und P8[number withheld] ([number withheld] pp). Der A-Anstieg erfolgt überwiegend spät; HK zeigt ihn bereits [number withheld]H2. Gemessen werden Konzentrationsänderungen ausgewiesener Quoten, keine Veränderungen wirtschaftlicher Verschuldung oder kausalen Finanzierungseffekte.

### Rework [number withheld]

**Darstellung.** Alle sechs PDFs wurden neu erzeugt, mit Poppler gerendert und vollständig visuell geprüft. Dünne Fensterzellen erscheinen hohl, Nullzellen als Kreuz; Legenden und Firmenzahlen stehen auf allen Panels. Die Hauptstichproben haben keine Nullzellen; acht Nullzellen liegen in der tabellarisch berichteten HK-Sensitivität ohne Imputation. In Z-Panels gilt die Warnung für irgendeine L/P6[number withheld]/P8[number withheld]-Komponente, in der Dynamik zusätzlich für beide Gruppen und die Referenz. In Verteilungen markieren Symbole Bins innerhalb eines Fensters, sobald ein beitragender Gruppen-/Stichtagswert des Fensters dünn oder null ist; sie prüfen keine Bin-Stützung. Die Bildunterschriften erklären diese Aggregation und die Beschränkung auf berichtsvollständige Survivor-Firmen bzw. aktuell gelistete Kontrollen. Erläuterungstexte stehen gemäß PI-Vorgabe außerhalb der Grafiken. Vergleichbare Panels verwenden auch marktübergreifend dieselben Skalen.

**Harte Tests.** Ein Panel aus drei Entwicklern und drei Kontrollen an [number withheld] Stichtagen läuft durch `yfun()`, `build()`, deterministische Gewichtsmatrizen und dieselben Perioden-/Referenzkontrastfunktionen wie die Produktion. Die unabhängigen rationalen Sollwerte für θ sind [number withheld]/[number withheld], [number withheld]/[number withheld] und [number withheld]/[number withheld] in Wahrscheinlichkeitseinheiten; außerdem werden alle zehn dynamischen Werte je Gewichtsspalte und die Nullreferenz geprüft. Maximaler Fehler: [number withheld]. Explizit kopierte Firmenhistorien liefern in balancierten und gezielt lückenhaften Testpanels für alle Outcomes, Stichtage und Kontraste exakt dieselben Ergebnisse wie die Gewichte (Fehler [number withheld]). Ein absichtlich stichtagsweise vertauschter Resample wird erkannt (Abweichung [number withheld]/[number withheld]). Fünf berechnete Grenztests prüfen jeweils Werte knapp unter, auf und über beiden Fenstergrenzen. `firm_histories_resampled` beruht nun auf expliziten Historienvergleichen einschließlich eines tatsächlichen Produktionsresamples. Alle [number withheld] Validierungszeilen bestehen. Die synthetischen Tests laufen nach den Schätzungen und verwenden keine Zufallszahlen.

**Monte-Carlo-Streuung.** `primary/A` und `unbalanced_developers/A` sind vollständig datenidentisch. Ihre verschiedenen p-Werte (ungefähr [number withheld] bzw. [number withheld]), Intervalle ([[number withheld]; [number withheld]] bzw. [[number withheld]; [number withheld]] pp), Vorperioden-Wald-p-Werte (gerundet [number withheld] bzw. [number withheld]) und simultanen kritischen Werte ([number withheld] bzw. [number withheld]) entstehen ausschließlich durch unterschiedliche Bootstrapziehungen bei B=[number withheld]. Insbesondere die Höhe des A-Vortrend-p-Werts und die beinahe nullberührende obere simultane Bandgrenze für [number withheld]H1 sind seed-empfindlich: [number withheld] gegenüber [number withheld] pp, bei gleichem dynamischen Punktschätzer. Diese Grenznähe trägt keine belastbare Einzelaussage. Die primären Holm-p-Werte betragen bei diesem Seed beide ungefähr [number withheld]; eine Stabilitätsprüfung über andere Seeds wurde nicht durchgeführt. Die exakten diskreten p-Werte bleiben in den CSVs erhalten.

**Referenz und Sensitivitätsziel.** [number withheld]H2 ist ein lokales Hoch der A-Entwickler-Z: [number withheld] % gegenüber [number withheld] % in [number withheld]H1 und [number withheld] % in [number withheld]H1. Die negativen A-Vorkoeffizienten hängen damit stark von der gewählten Referenz ab. Das für die Trendsensitivität/T078 festgelegte Post-Mittel gegenüber [number withheld]H2 beträgt A [number withheld] pp und HK [number withheld] pp. Es ist ein anderer Schätzer als θ mit Mittel der sechs Pre-Stichtage (A [number withheld] pp; HK [number withheld] pp). Eine spätere Sensitivitätsanalyse dieses dynamischen Ziels bewertet daher nicht unmittelbar den Primärschätzer.

**Diagnostik und Annahmen.** Der Vorperioden-Wald-Test verwendet die Bootstrap-Kovarianz und eine asymptotische χ²([number withheld])-Referenz; er ist nur diagnostisch, besonders bei kleinen HK-Entwicklergruppen ([number withheld] bzw. [number withheld] Firmen). Die fünf Szenario-/Markt-p-Werte sind gerundet [number withheld] / [number withheld] / [number withheld] / [number withheld] / [number withheld] in der Reihenfolge der untenstehenden Tabelle. Nichtverwerfung belegt keine parallelen Trends. `window_unique_firms` entspricht bei einem eindeutigen Firma-/Stichtagsschlüssel exakt `window_observations` und liefert keine zusätzliche Information. Für eine kausale Lesart wären gleiche unbehandelte Z-Trends innerhalb jedes Marktes, fehlende relevante Antizipation und Kontrollspillover, vergleichbare Messung sowie das Fehlen entwicklerspezifischer konkurrierender Schocks erforderlich. Diese Voraussetzungen sind nicht nachgewiesen; das Design ist ergebnisinformiert.

**Vollständige Ergebnisübersicht.** Alle [number withheld] Kontraste mit punktweisen [number withheld]%-Perzentilintervallen, in pp; RL1 ist die Niveauänderung der Quote mal [number withheld]. Sekundäre Outcomes sind diagnostisch, ohne zusätzliche Multiplizitätskorrektur. Z6[number withheld]=L−P6[number withheld] und Z8[number withheld]=L−P8[number withheld] werden beide berichtet.

| Outcome | Primär A | Primär HK | Unbalanciert A | Unbalanciert HK | HK ohne Imputation |
|---|---:|---:|---:|---:|---:|
| L | [number withheld] [[number withheld]; [number withheld]] | [number withheld] [[number withheld]; [number withheld]] | [number withheld] [[number withheld]; [number withheld]] | [number withheld] [[number withheld]; [number withheld]] | [number withheld] [[number withheld]; [number withheld]] |
| U | [number withheld] [[number withheld]; [number withheld]] | [number withheld] [[number withheld]; [number withheld]] | [number withheld] [[number withheld]; [number withheld]] | [number withheld] [[number withheld]; [number withheld]] | [number withheld] [[number withheld]; [number withheld]] |
| S | [number withheld] [[number withheld]; [number withheld]] | [number withheld] [[number withheld]; [number withheld]] | [number withheld] [[number withheld]; [number withheld]] | [number withheld] [[number withheld]; [number withheld]] | [number withheld] [[number withheld]; [number withheld]] |
| P6[number withheld] | [number withheld] [[number withheld]; [number withheld]] | [number withheld] [[number withheld]; [number withheld]] | [number withheld] [[number withheld]; [number withheld]] | [number withheld] [[number withheld]; [number withheld]] | [number withheld] [[number withheld]; [number withheld]] |
| P8[number withheld] | [number withheld] [[number withheld]; [number withheld]] | [number withheld] [[number withheld]; [number withheld]] | [number withheld] [[number withheld]; [number withheld]] | [number withheld] [[number withheld]; [number withheld]] | [number withheld] [[number withheld]; [number withheld]] |
| Z | [number withheld] [[number withheld]; [number withheld]] | [number withheld] [[number withheld]; [number withheld]] | [number withheld] [[number withheld]; [number withheld]] | [number withheld] [[number withheld]; [number withheld]] | [number withheld] [[number withheld]; [number withheld]] |
| Z6[number withheld] | [number withheld] [[number withheld]; [number withheld]] | [number withheld] [[number withheld]; [number withheld]] | [number withheld] [[number withheld]; [number withheld]] | [number withheld] [[number withheld]; [number withheld]] | [number withheld] [[number withheld]; [number withheld]] |
| Z8[number withheld] | [number withheld] [[number withheld]; [number withheld]] | [number withheld] [[number withheld]; [number withheld]] | [number withheld] [[number withheld]; [number withheld]] | [number withheld] [[number withheld]; [number withheld]] | [number withheld] [[number withheld]; [number withheld]] |
| RL1 | [number withheld] [[number withheld]; [number withheld]] | [number withheld] [[number withheld]; [number withheld]] | [number withheld] [[number withheld]; [number withheld]] | [number withheld] [[number withheld]; [number withheld]] | [number withheld] [[number withheld]; [number withheld]] |

Die positiven Z-Kontraste begleiten überwiegend positive L- und S-Kontraste, während U und die Placebo-Komponenten teils breite, null einschließende Intervalle haben. Der positive primäre A-Z-Kontrast enthält einen wesentlichen Beitrag rückläufiger Placebo-Konzentration. Die vollständige Dynamik einschließlich deskriptiver Stichtage, Punktintervalle und simultaner Bänder steht unverändert in `replication/outputs/tables/t077_dynamics.csv`.

## Dateien

Alle erneut erzeugten oder geänderten Projektdateien sind aufgeführt. Die historischen `t0[number withheld]_adoption_*`-Belege blieben unverändert.

- `replication/code/26_identification.R` – erweiterte Validierung und überarbeitete Abbildungen.
- `replication/outputs/tables/t077_analysis_panel.csv` – Analysepopulationen und Firmen-/Stichtagsmitgliedschaft.
- `replication/outputs/tables/t077_bootstrap_draws.csv` – gemeinsame Bootstrap-Kontraste.
- `replication/outputs/tables/t077_components.csv` – Gruppen-/Stichtagsmittel zur Rekonstruktion.
- `replication/outputs/tables/t077_covariance.csv` – Kovarianzmatrizen mit Datumsreihenfolge.
- `replication/outputs/tables/t077_density_bins.csv` – feste Verteilungsbins und vollständige Nenner.
- `replication/outputs/tables/t077_diagnostics.csv` – Vortrend-, Kovarianz- und Bootstrapdiagnostik.
- `replication/outputs/tables/t077_dynamic_draws_HK_no_imputation_HK.csv` – gemeinsame dynamische Ziehungen.
- `replication/outputs/tables/t077_dynamic_draws_primary_A.csv` – gemeinsame dynamische Ziehungen.
- `replication/outputs/tables/t077_dynamic_draws_primary_HK.csv` – gemeinsame dynamische Ziehungen.
- `replication/outputs/tables/t077_dynamic_draws_unbalanced_developers_A.csv` – gemeinsame dynamische Ziehungen.
- `replication/outputs/tables/t077_dynamic_draws_unbalanced_developers_HK.csv` – gemeinsame dynamische Ziehungen.
- `replication/outputs/tables/t077_dynamics.csv` – dynamische Schätzungen und Intervalle.
- `replication/outputs/tables/t077_estimates.csv` – sämtliche [number withheld] Kontraste.
- `replication/outputs/tables/t077_membership.csv` – Firmen- und Beobachtungszahlen.
- `replication/outputs/tables/t077_protected_files.csv` – aktualisierte Integritätsinventarliste.
- `replication/outputs/tables/t077_ratio_validation.csv` – Prüfung der RL1-Bilanzidentität.
- `replication/outputs/tables/t077_specification.csv` – Spezifikation und Ergebnisvorkenntnis.
- `replication/outputs/tables/t077_support.csv` – Zählungen, fehlende Posten, dünne und leere Zellen.
- `replication/outputs/tables/t077_trend_sensitivity.csv` – Trendsensitivität ausdrücklich NOT RUN.
- `replication/outputs/tables/t077_validation.csv` – [number withheld] berechnete Validierungsprüfungen.
- `replication/outputs/figures/t077_distributions_A.pdf` – Verteilung mit Fallzahl und Stützungsmarkern.
- `replication/outputs/figures/t077_distributions_HK.pdf` – Verteilung mit Fallzahl und Stützungsmarkern.
- `replication/outputs/figures/t077_dynamic_A.pdf` – Dynamik mit Fallzahlen und Stützungsmarkern.
- `replication/outputs/figures/t077_dynamic_HK.pdf` – Dynamik mit Fallzahlen und Stützungsmarkern.
- `replication/outputs/figures/t077_probabilities_A.pdf` – Fensterwahrscheinlichkeiten mit Fallzahlen und Stützungsmarkern.
- `replication/outputs/figures/t077_probabilities_HK.pdf` – Fensterwahrscheinlichkeiten mit Fallzahlen und Stützungsmarkern.
- `replication/outputs/tables/t077_figure_notes.csv` – sechs englische Bildunterschriften mit Stichprobenselektion und Markerdefinition.
- `replication/outputs/tables/t077_rework1_check.csv` – SHA-[number withheld]-Vergleiche gegen Freeze/Archiv und zwischen endgültigen Läufen; erlaubte Änderungen separat ausgewiesen.
- `replication/outputs/tables/t077_rework1_protected.csv` – [number withheld] SHA-[number withheld]-Schutzprüfungen.
- `replication/outputs/tables/t077_rework1_execution.txt` – Ausgaben, Exitcodes und Laufzeiten der drei Rework-Ausführungen.
- `tasks/T077_report.md` – fortgeführter Übernahme- und Reworkbericht.

Erhaltene historische Übernahmebelege:

- `replication/outputs/tables/t077_adoption_check.csv` – damaliger Archivvergleich.
- `replication/outputs/tables/t077_adoption_runs.csv` – Vergleich der damaligen beiden Läufe.
- `replication/outputs/tables/t077_adoption_protected.csv` – damalige SHA-[number withheld]-Schutzprüfung.
- `replication/outputs/tables/t077_adoption_execution.txt` – damalige Ausgabe und Laufzeit.

## Ausführung

[fenced excerpt withheld in public process copy]
[fenced excerpt withheld in public process copy]

Dreimal selbst offline ausgeführt, jeweils Exitcode [number withheld]: erster QA-Lauf [number withheld] s; nach einer reinen Legendenplatzierung zwei Läufe des endgültigen Skripts mit [number withheld] s und [number withheld] s. Letzte Ausgabe:

[fenced excerpt withheld in public process copy]
[fenced excerpt withheld in public process copy]

### Rework [number withheld] – Integritätsprüfung

- Alle [number withheld] unverändert zu haltenden statistischen CSVs stimmen in jedem der drei Läufe per SHA-[number withheld] mit dem Freeze überein; nach Abschluss auch direkt mit dem Übernahmearchiv.
- Die beiden endgültigen Läufe liefern [number withheld] byte-identische Artefakte: [number withheld] Statistik-CSVs, aktualisierte Validierung und Schutzinventarliste, neue Bildunterschriften und sechs PDFs. Auch PDF-Metadaten unterscheiden sich nicht.
- `replication/outputs/tables/t077_rework1_check.csv` enthält [number withheld] Vergleichs-/Inventarzeilen: [number withheld] Statistikvergleiche gegen Freeze, [number withheld] gegen Archiv, [number withheld] zwischen endgültigen Läufen, neun erlaubte Änderungen und drei neue Prüf-/Begleitdateien.
- [number withheld] bestehende geschützte Dateien wurden zusätzlich per SHA-[number withheld] vor/nach Rework geprüft: null Änderungen. Der wiederhergestellte STATE-Hash bleibt `f0666db1e9d212ae797a2f200594aae6aef601d1d6de2e697b85d84b0d608029`. Die interne MD5-Prüfung des Skripts umfasst [number withheld] Dateien; der zusätzliche SHA-[number withheld]-Nachweis deckt auch Projektregeln und Aufgabenkarte ab.
- Unabhängige Python-Rekonstruktion aller [number withheld] Kontraste aus neu gespeicherten Zellmitteln: maximal [number withheld] pp.
- HonestDiD bleibt in sämtlichen [number withheld] Zeilen NOT RUN.

### Übernahmeprüfung – bisheriger Bericht vor Rework [number withheld]

Die ursprüngliche Übernahme führte das damals unveränderte Skript zweimal mit Exitcode [number withheld] aus. Die Stichproben, Primärschätzungen und der maximale Zellrekonstruktionsfehler entsprechen den oben wiedergegebenen Werten.

- **Archivvergleich:** [number withheld] CSVs und sechs PDFs geprüft; [number withheld] Dateien waren byte-identisch. Dazu gehörten sämtliche [number withheld] damals erzeugten statistischen CSVs, alle sechs PDFs und die historische Reproduzierbarkeitsdatei. Die [number withheld] archivierten Ausgaben stimmten mit dem archivierten SHA2[number withheld]SUMS-Manifest überein.
- **Abweichung:** Ausschließlich die Schutzinventarliste wich ab: [number withheld] statt [number withheld] Pfade, also [number withheld] zusätzliche und keine entfernten. Acht gemeinsame Dateien unterschieden sich gegenüber dem Originallauf: sechs später durch T081 geänderte Proposal-Dateien sowie approvals.log und terminal.log. Diese historischen Änderungen wurden nicht zurückgesetzt.
- **Wiederholbarkeit:** Alle [number withheld] verglichenen CSV-/PDF-Dateien waren zwischen den damaligen beiden Läufen byte-identisch, einschließlich Inventarliste und PDF-Metadaten.
- **Schutzprüfung:** [number withheld] geschützte Dateien per SHA-[number withheld] geprüft: null Änderungen. Das damalige Analyseskript stimmte mit dem Archiv überein.
- **Laufzeit:** Zweiter Lauf [number withheld] Sekunden; für den ersten Lauf wurde keine separate Gesamtlaufzeit erfasst.
- **Trendsensitivität:** Alle [number withheld] Zeilen blieben NOT RUN: „HonestDiD not installed locally; no worker downloads“.

Die historische Übernahme änderte weder Skript noch Spezifikation, Stichprobe, Fenster, Seed, B oder Methode. Diese Selbstkontrollen ersetzten keinen unabhängigen Review.

## Abnahmekriterien

[number withheld]. **Erfüllt:** Spezifikation, Ergebnisvorkenntnis, exakte Mitgliedschaften und Stützung stimmen unverändert mit dem freigegebenen Memo überein. Genau zehn dynamische Inferenzkoeffizienten, fünf pre und fünf post; belegt durch `t077_specification.csv`, `t077_membership.csv` und `t077_support.csv`.
[number withheld]. **Erfüllt:** Beide primären Märkte und alle fünf Szenario-/Markt-Kombinationen mit neun Outcomes, [number withheld] Kontrasten und [number withheld] Dynamikzeilen sind gespeichert. Die undefinierte lineare HK-Kovarianz im unbalancierten Panel ist ausdrücklich NA.
[number withheld]. **Erfüllt als Worker-Selbstkontrolle:** [number withheld] Validierungen bestehen, einschließlich Produktionspfad/Sollwerten, Gewichtungs-/Historienvergleich und Fenstergrenzen. R-Zellrekonstruktion maximal [number withheld] pp, unabhängig in Python [number withheld] pp. Alle [number withheld] Statistikdateien sind unverändert gegenüber Freeze und Archiv; [number withheld] endgültige Laufartefakte sind byte-identisch; [number withheld] geschützte Dateien blieben unverändert.
[number withheld]. **Erfüllt:** Gemeinsame, nach Gruppe/Markt stratifizierte Ganzfirmenziehungen, B=[number withheld], null fehlgeschlagene Ziehungen, Punktintervalle, simultane Bänder, rohe und Holm-bereinigte primäre p-Werte sowie geordnete Kovarianzen sind gespeichert. Sparse-/Nullstützung und Monte-Carlo-Streuung sind offengelegt; Historienvergleiche werden tatsächlich berechnet.
[number withheld]. **Erfüllt gemäß NOT-RUN-Option:** HonestDiD fehlt lokal; Methodenausführung, Version und robuste Intervalle sind nicht verfügbar. Vorgesehen bleiben relative magnitude, Mbar={[number withheld]; [number withheld]; [number withheld]; [number withheld]; [number withheld]}, fünf pre/fünf post und das Post-Mittel gegenüber [number withheld]H2. Keine Ersatzmethode. Lineare Hauptpanel-Kovarianzen haben Rang [number withheld] und positive Eigenwerte; unbalanciertes HK bleibt nicht verfügbar. Sensitivitätsziel und θ werden getrennt.
[number withheld]. **Erfüllt in dieser Überarbeitung:** Alle sechs PDFs sind gerendert und visuell geprüft; Firmenzahlen, Sparse-/Null-Legenden, gemeinsame Vergleichsskalen und eindeutige Einheiten sind vorhanden. Stichprobenhinweise und Erläuterungen stehen gemäß Auftrag in `t077_figure_notes.csv`. Fensterwahrscheinlichkeiten, polynomiale Überschussmasse, Survivor-Population, alle Entwickler, Buchhaltungsmechanik und kausale Finanzierungseffekte werden getrennt. Ein unabhängiger Review bleibt erforderlich.

## Offene Fragen

- Die Reviewbefunde sind im freigegebenen Rework bearbeitet; erneute unabhängige Prüfung und PI-Abnahme stehen aus. Der Kartenstatus wurde nicht geändert. Die vom Co-PI wiederhergestellte STATE-Datei blieb unverändert.
- HonestDiD benötigt weiterhin eine gesonderte Abhängigkeits-/Methodenentscheidung. Keine zusätzliche Seed-/B-Sensitivität wurde geschätzt; Seed [number withheld] und B=[number withheld] bleiben fest.
- A-Vortrendproblem, Referenzabhängigkeit, dünne HK-Stützung, Bankenregulierung, entwicklerspezifische Schocks, Messänderungen und Survivor-Selektion begrenzen die kausale Interpretation. Der Firmenbootstrap erfasst keine unbeobachteten gemeinsamen Entwicklerschocks. Wirtschaftliche Verschuldung und schuldenähnliches Minderheitenkapital werden nicht identifiziert.
- Weitergehende Forschungs-/Proposal-Integration bleibt eine eigene PI-Entscheidung. Keine Installation, kein Netzwerk, kein Git-/Overleaf-Push und kein `agents/pi.sh` wurden ausgeführt.
- Historischer KI-Log-Vorschlag: „T077-Übernahme: unverändertes Skript zweimal offline reproduziert; statistische CSVs und PDFs archividentisch; aktualisierte Integritätsinventarliste offengelegt; SHA-[number withheld]-Schutzprüfung ohne Änderungen. Positive Konzentrationskontraste mit A-Vortrendproblem und dünner HK-Stützung; HonestDiD NOT RUN; Darstellungsgrenze und unabhängige Reviews offen.“
- Ergänzender KI-Log-Vorschlag: „T077 Rework [number withheld]: sechs Abbildungen um Firmenzahlen und Sparse-/Null-Markierungen ergänzt; Stichprobenhinweise in separate Bildunterschriften verschoben; harte Tests mit bekannten θ/θ_t und expliziten Firmenhistorien durch den Produktionspfad, [number withheld] Prüfungen bestanden. [number withheld] statistische CSVs unverändert gegenüber Freeze/Archiv, [number withheld] endgültige Artefakte über zwei Läufe byte-identisch, [number withheld] geschützte Dateien unverändert. A-Datenidentität mit reiner Monte-Carlo-Inferenzstreuung, Referenzabhängigkeit und abweichendes Trendsensitivitätsziel offengelegt. HonestDiD NOT RUN; erneute unabhängige Reviews ausstehend.“ `AI_USAGE_LOG.md` blieb außerhalb des Schreibbereichs unverändert.