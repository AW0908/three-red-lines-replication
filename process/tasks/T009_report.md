## Ergebnis

T009 ist umgesetzt: fünf gepoolte DiD-Schätzungen, [number withheld] Event-Study-Koeffizienten, fünf gemeinsame Vortrendtests und fünf PDF-Abbildungen wurden erzeugt. Alle gepoolten [number withheld]%-Konfidenzintervalle enthalten null; die Ergebnisse stehen ohne weitergehende Interpretation unten.

## Dateien

- `replication/code/02_estimate.R` – Schätzungen, Stichprobenprüfungen und Exporte.
- `replication/outputs/tables/t009_did_main.csv` – DiD-Ergebnisse, Stichprobengrößen, Prä-Mittelwerte und Ausfälle.
- `replication/outputs/tables/t009_did_main.tex` – mit `modelsummary` erzeugtes booktabs-Fragment samt Anmerkungen.
- `replication/outputs/tables/t009_event_study.csv` – zwölf Koeffizienten je Outcome samt SE und Konfidenzintervallen.
- `replication/outputs/tables/t009_pretrend_tests.csv` – gemeinsame Wald-F-Tests samt Freiheitsgraden und getesteten Daten.
- `replication/outputs/figures/t009_es_rl1.pdf` – Event Study für `rl1`.
- `replication/outputs/figures/t009_es_rl2.pdf` – Event Study für `rl2`.
- `replication/outputs/figures/t009_es_rl2_gap.pdf` – Event Study für `rl2_gap`.
- `replication/outputs/figures/t009_es_mi_share.pdf` – Event Study für `mi_share`.
- `replication/outputs/figures/t009_es_jv_ta.pdf` – Event Study für `jv_ta`.

## Ausführung

Exakter Befehl, mit der finalen Skriptfassung zweimal erfolgreich ausgeführt:

[fenced excerpt withheld in public process copy]
[fenced excerpt withheld in public process copy]

Letzte Ausgabezeilen:

[fenced excerpt withheld in public process copy]
[fenced excerpt withheld in public process copy]

## Abnahmekriterien

[number withheld]. **Erfüllt.** Beide finalen Läufe endeten mit Exitcode [number withheld]. SHA-[number withheld]-Prüfsummen aller drei CSV-Dateien und der TEX-Datei waren zwischen den Läufen identisch.
[number withheld]. **Erfüllt.** Sämtliche Modelle verwenden ausschließlich `sample_main == TRUE` mit nicht fehlender `dose`, Firmen- und Datums-Fixed-Effects sowie firmengeclusterte Standardfehler. Skript und Tabellenanmerkungen dokumentieren diese Spezifikation und die Paralleltrendannahme.
[number withheld]. **Erfüllt.** Koeffizient und SE wurden für alle fünf Outcomes aus den Skript-Modellobjekten gegen den CSV-Export geprüft, mit Toleranz `[number withheld]`. Auszüge aus den mit [number withheld] signifikanten Stellen gedruckten Modellobjekten, jeweils für `dose:post`:

[fenced excerpt withheld in public process copy]
[fenced excerpt withheld in public process copy]

   Die vollständigen Ausdrucke nennen jeweils `Clustered (firm_id)`.
[number withheld]. **Erfüllt.** `t009_event_study.csv` enthält genau [number withheld] Zeilen, zwölf je Outcome; die Referenz `2020-06-30` ist ausgeschlossen. Alle fünf PDFs zeigen [number withheld] Stichtage einschließlich des auf null normalisierten Referenzpunkts, [number withheld]%-KIs, Nulllinie und gestrichelter Politikgrenze. Alle PDFs wurden gerendert und visuell geprüft.
[number withheld]. **Erfüllt.** Genau ein gemeinsamer `fixest::wald`-Test je Outcome, jeweils über sieben Koeffizienten für Stichtage strikt vor `2020-06-30`. Die CSV enthält fünf Zeilen sowie Zähler- und Nennerfreiheitsgrade.
[number withheld]. **Erfüllt.** Das TEX-Fragment enthält `\toprule` und `\bottomrule`, aber keine `\documentclass`.
[number withheld]. **Erfüllt.** Ergebnisse je zusätzlicher verletzter Linie, in Quoteneinheiten:

   | Outcome | Koeffizient | [number withheld]%-KI | Vortrend-p | N | Firmen |
   |---|---:|---:|---:|---:|---:|
   | `rl1` | [number withheld] | [[number withheld]; [number withheld]] | [number withheld] | [number withheld] | [number withheld] |
   | `rl2` | [number withheld] | [[number withheld]; [number withheld]] | [number withheld] | [number withheld] | [number withheld] |
   | `rl2_gap` | [number withheld] | [[number withheld]; [number withheld]] | [number withheld] | [number withheld] | [number withheld] |
   | `mi_share` | [number withheld] | [[number withheld]; [number withheld]] | [number withheld] | [number withheld] | [number withheld] |
   | `jv_ta` | [number withheld] | [[number withheld]; [number withheld]] | [number withheld] | [number withheld] | [number withheld] |

   N und Firmenzahlen gelten jeweils auch für die zugehörige Event Study.
[number withheld]. **Nicht erfüllt als globaler Unverändertheitsnachweis.** Meine Schreiboperationen betrafen ausschließlich die zehn freigegebenen Dateien. Der Vorher-nachher-Vergleich zeigte jedoch parallele Änderungen an `proposal/references.bib`, `review/T008_reviewer.log`, `state/terminal.log` und `tasks/T009_worker.log`; diese Dateien habe ich nicht bearbeitet. Eingabepanel und Aufgabenkarte blieben unverändert, einschließlich `status: APPROVED`.

## Offene Fragen

- **Ausfälle:** Ausgangsbasis sind [number withheld] Beobachtungen bei [number withheld] Firmen. Bei `rl1` entfällt eine Beobachtung, bei `rl2` und `rl2_gap` jeweils [number withheld] wegen fehlender Outcomes. Bei `mi_share` entfallen [number withheld] fehlende Outcomes und eine Singleton-Beobachtung. Bei `jv_ta` entfallen [number withheld] fehlende Outcomes und drei Singletons, insgesamt **[number withheld]/[number withheld] = [number withheld] %**. In allen [number withheld] Zeilen fehlt der JV-Eingangswert; in einer davon fehlt zusätzlich die Bilanzsumme. Dieser über [number withheld] % liegende Ausfall ist damit erklärt; es wurden keine Werte imputiert. Alle Modelle behalten mindestens [number withheld] Firmen.
- Die parallelen Änderungen außerhalb des Schreibbereichs müssen vor dem Einfrieren des Review-Pakets zugeordnet werden; ich habe sie nicht zurückgesetzt.
- Die RL1-Definition bleibt entsprechend dem Projektstand gegenüber einer Primärquelle ungeprüft und ist so gekennzeichnet. Eine Einbindung und Kompilierung des TEX-Fragments im Proposal wurde nicht geprüft.
- Vorschlag für das KI-Protokoll nach Abnahme: „Codex implementierte T009; geprüft durch wiederholte Ausführung, bytegleiche Tabellenexporte, Abgleich mit Modellobjekten und visuelle PDF-Kontrolle; unabhängiges Review ausstehend.“ `AI_USAGE_LOG.md` blieb außerhalb des Schreibbereichs unverändert.