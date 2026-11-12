## Ergebnis

T009 ist umgesetzt: fünf gepoolte DiD-Schätzungen, 60 Event-Study-Koeffizienten, fünf gemeinsame Vortrendtests und fünf PDF-Abbildungen wurden erzeugt. Alle gepoolten 95%-Konfidenzintervalle enthalten null; die Ergebnisse stehen ohne weitergehende Interpretation unten.

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

[fenced excerpt withheld in public audit]
[fenced excerpt withheld in public audit]

Letzte Ausgabezeilen:

[fenced excerpt withheld in public audit]
[fenced excerpt withheld in public audit]

## Abnahmekriterien

1. **Erfüllt.** Beide finalen Läufe endeten mit Exitcode 0. SHA-256-Prüfsummen aller drei CSV-Dateien und der TEX-Datei waren zwischen den Läufen identisch.
2. **Erfüllt.** Sämtliche Modelle verwenden ausschließlich `sample_main == TRUE` mit nicht fehlender `dose`, Firmen- und Datums-Fixed-Effects sowie firmengeclusterte Standardfehler. Skript und Tabellenanmerkungen dokumentieren diese Spezifikation und die Paralleltrendannahme.
3. **Erfüllt.** Koeffizient und SE wurden für alle fünf Outcomes aus den Skript-Modellobjekten gegen den CSV-Export geprüft, mit Toleranz `1e-13`. Auszüge aus den mit 17 signifikanten Stellen gedruckten Modellobjekten, jeweils für `dose:post`:

[fenced excerpt withheld in public audit]
[fenced excerpt withheld in public audit]

   Die vollständigen Ausdrucke nennen jeweils `Clustered (firm_id)`.
4. **Erfüllt.** `t009_event_study.csv` enthält genau 60 Zeilen, zwölf je Outcome; die Referenz `2020-06-30` ist ausgeschlossen. Alle fünf PDFs zeigen 13 Stichtage einschließlich des auf null normalisierten Referenzpunkts, 95%-KIs, Nulllinie und gestrichelter Politikgrenze. Alle PDFs wurden gerendert und visuell geprüft.
5. **Erfüllt.** Genau ein gemeinsamer `fixest::wald`-Test je Outcome, jeweils über sieben Koeffizienten für Stichtage strikt vor `2020-06-30`. Die CSV enthält fünf Zeilen sowie Zähler- und Nennerfreiheitsgrade.
6. **Erfüllt.** Das TEX-Fragment enthält `\toprule` und `\bottomrule`, aber keine `\documentclass`.
7. **Erfüllt.** Ergebnisse je zusätzlicher verletzter Linie, in Quoteneinheiten:

   | Outcome | Koeffizient | 95%-KI | Vortrend-p | N | Firmen |
   |---|---:|---:|---:|---:|---:|
   | `rl1` | 0,011016 | [−0,014738; 0,036770] | 0,003154 | 1.575 | 126 |
   | `rl2` | −0,008203 | [−0,382422; 0,366015] | 0,235290 | 1.544 | 126 |
   | `rl2_gap` | 0,007320 | [−0,050243; 0,064883] | 0,387946 | 1.544 | 126 |
   | `mi_share` | 0,024786 | [−0,000515; 0,050088] | 0,579684 | 1.519 | 124 |
   | `jv_ta` | 0,001738 | [−0,004548; 0,008024] | 0,453522 | 1.251 | 103 |

   N und Firmenzahlen gelten jeweils auch für die zugehörige Event Study.
8. **Nicht erfüllt als globaler Unverändertheitsnachweis.** Meine Schreiboperationen betrafen ausschließlich die zehn freigegebenen Dateien. Der Vorher-nachher-Vergleich zeigte jedoch parallele Änderungen an `proposal/references.bib`, `review/T008_reviewer.log`, `state/terminal.log` und `tasks/T009_worker.log`; diese Dateien habe ich nicht bearbeitet. Eingabepanel und Aufgabenkarte blieben unverändert, einschließlich `status: APPROVED`.

## Offene Fragen

- **Ausfälle:** Ausgangsbasis sind 1.576 Beobachtungen bei 126 Firmen. Bei `rl1` entfällt eine Beobachtung, bei `rl2` und `rl2_gap` jeweils 32 wegen fehlender Outcomes. Bei `mi_share` entfallen 56 fehlende Outcomes und eine Singleton-Beobachtung. Bei `jv_ta` entfallen 322 fehlende Outcomes und drei Singletons, insgesamt **325/1.576 = 20,621827 %**. In allen 322 Zeilen fehlt der JV-Eingangswert; in einer davon fehlt zusätzlich die Bilanzsumme. Dieser über 5 % liegende Ausfall ist damit erklärt; es wurden keine Werte imputiert. Alle Modelle behalten mindestens 100 Firmen.
- Die parallelen Änderungen außerhalb des Schreibbereichs müssen vor dem Einfrieren des Review-Pakets zugeordnet werden; ich habe sie nicht zurückgesetzt.
- Die RL1-Definition bleibt entsprechend dem Projektstand gegenüber einer Primärquelle ungeprüft und ist so gekennzeichnet. Eine Einbindung und Kompilierung des TEX-Fragments im Proposal wurde nicht geprüft.
- Vorschlag für das KI-Protokoll nach Abnahme: „Codex implementierte T009; geprüft durch wiederholte Ausführung, bytegleiche Tabellenexporte, Abgleich mit Modellobjekten und visuelle PDF-Kontrolle; unabhängiges Review ausstehend.“ `AI_USAGE_LOG.md` blieb außerhalb des Schreibbereichs unverändert.