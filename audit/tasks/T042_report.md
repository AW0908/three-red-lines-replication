## Ergebnis

Die REWORK-Punkte wurden behoben: Quellenzuordnung und Kartenmapping sind vollständig enthalten, T039/T040 sind auf dem dokumentierten Freigabestand und die CNKI-Suche ist ergänzt. Der englische Appendix enthält weiterhin [number withheld] Nutzungszeilen in sechs Spalten und umfasst vier Seiten. Der isolierte Gesamtbuild endet mit Exit-Code [number withheld] und ohne LaTeX-Fehler oder Overfull-Boxen; vorhandene Warnungen außerhalb des Appendix sind unten abgegrenzt.

## Dateien

- `proposal/appendix/ai_use.tex` – aktualisierte Nutzungserklärung, Stichtag und Sprachkorrekturen.
- `tasks/T042_report.md` – Quellen je Zeile, vollständiges Kartenmapping, Prüfbelege und konkrete Logvorschläge.

## Ausführung

[fenced excerpt withheld in public process copy]
[fenced excerpt withheld in public process copy]

Der Kartenbefehl wurde in vollständigen lokalen Proposal-Kopien unter `/private/tmp/t0[number withheld]_rework/before/` und `/private/tmp/t0[number withheld]_rework/after/` ausgeführt, jeweils mit Exit-Code [number withheld]. Im Projekt wurden damit keine generierten Build-Dateien geschrieben. Der gebaute Appendix ist bytegleich mit `proposal/appendix/ai_use.tex`.

Letzte Zeilen des abschließenden Befehls:

[fenced excerpt withheld in public process copy]
[fenced excerpt withheld in public process copy]

Der vollständige Erstbuild meldet [number withheld] undefinierte Referenzen und [number withheld] undefinierte Zitate außerhalb des AI-Anhangs. Die Warnungen sind im Vorher-/Nachher-Build identisch; beide haben [number withheld] LaTeX-Fehler und [number withheld] Overfull-Boxen. Alle vier Anhangseiten wurden mit `pdftoppm` gerendert und visuell geprüft: PDF-Seiten [number withheld]–[number withheld], gedruckte Seiten [number withheld]–[number withheld], keine abgeschnittenen Zellen oder Überlappungen. Die Einleitung hat [number withheld] Wörter. Die Build- und Renderbelege liegen temporär unter `/private/tmp/t0[number withheld]_rework/`.

## Abnahmekriterien

[number withheld]. **Erfüllt:** Die folgende Tabelle ordnet R0[number withheld]–R2[number withheld] konkrete Quellenstellen zu. Quellenangaben mit Komma bezeichnen einzelne Zeilen; Bereiche beziehen sich auf Kartentitel/Toolzuordnung und Co-PI-Feedback. Freigabe- und Abnahmezeilen stehen zusätzlich im Kartenmapping.
[number withheld]. **Erfüllt:** Dokumentierte Rollenurteile, Gesamturteile und PI-Overrides werden unterschieden. T039 ist erneut freigegeben, noch nicht abgenommen; T040 ist per Override abgenommen; T042 bleibt im REWORK mit ausstehendem Re-Review und PI-Abnahme. Frühere Prüfungen wurden anhand der Dokumentation nachvollzogen, nicht erneut durchgeführt.
[number withheld]. **Erfüllt:** Mengenvergleich ergibt [number withheld]/[number withheld] unterschiedliche APPROVED-Karten, keine fehlende und keine zusätzliche Karte. Alle wiederholten Freigaben sind im Mapping erfasst.
[number withheld]. **Erfüllt für den Schreibbereich:** Englisch, sechs Spalten, [number withheld] Wörter Einleitung, vier Anhangseiten, keine neuen Fehler/Overfull-Boxen; alle Seiten visuell geprüft. Bestehende offene Verweise/Zitate außerhalb des Schreibbereichs sind nicht behoben.
[number withheld]. **Erfüllt:** Ausformulierte Logvorschläge stehen unten; `AI_USAGE_LOG.md` bleibt unverändert. Der WoS-Eintrag existiert bereits und wird als Präzisierung statt als fehlender Eintrag behandelt.

**R0[number withheld]–R2[number withheld] → Quellen.** Für jede genannte Karte liefern die folgenden Stellen Titel/Tools, Änderungen und Urteile. Datums- und Override-Belege werden über das anschließende Kartenmapping verbunden. Bei reinen Kartenbelegen steht im Appendix „documented via task card“.

| Zeile | Quellen (Datei:Zeile) |
|---|---|
| R0[number withheld] | `AI_USAGE_LOG.md:22-23` |
| R0[number withheld] | `AI_USAGE_LOG.md:21`; `agents/TEAM.md:131-136` |
| R0[number withheld] | `AI_USAGE_LOG.md:19` |
| R0[number withheld] | `AI_USAGE_LOG.md:[number withheld]`; `tasks/T001.md:3-8`; `tasks/T001.md:81-83`; `review/T001.md:9`; `tasks/T003.md:3-8`; `tasks/T003.md:89-100`; `review/T003.md:10` |
| R0[number withheld] | `AI_USAGE_LOG.md:18`; `tasks/T002.md:3-8`; `tasks/T002.md:87-109`; `review/T002.md:10`; `tasks/T006.md:3-8`; `tasks/T006.md:115-123`; `review/T006.md:10` |
| R0[number withheld] | `AI_USAGE_LOG.md:17`; `tasks/T007.md:3-8`; `tasks/T007.md:80-91`; `review/T007.md:10` |
| R0[number withheld] | `AI_USAGE_LOG.md:15`; `tasks/T004.md:3-8`; `tasks/T004.md:161-209`; `review/T004.md:10` |
| R0[number withheld] | `state/STATE.md:24`; `tasks/T005.md:3-8`; `tasks/T005.md:91-100`; `review/T005.md:10`; `tasks/T008.md:3-8`; `tasks/T008.md:70-73`; `review/T008.md:10`; `tasks/T009.md:3-8`; `tasks/T009.md:83-86`; `review/T009.md:10`; `tasks/T011.md:3-8`; `tasks/T011.md:99-102`; `review/T011.md:10`; `tasks/T012.md:3-8`; `tasks/T012.md:91-121`; `review/T012.md:10` |
| R0[number withheld] | `tasks/T010.md:3-8`; `tasks/T010.md:104-117`; `review/T010.md:10`; `tasks/T014.md:3-8`; `tasks/T014.md:67-79`; `review/T014.md:10`; `tasks/T022.md:3-8`; `tasks/T022.md:53-55`; `review/T0[number withheld].md:[number withheld]` |
| R1[number withheld] | `state/STATE.md:26-28`; `tasks/T013.md:3-8`; `tasks/T013.md:75-82`; `review/T013.md:10`; `tasks/T015.md:3-8`; `tasks/T015.md:68-84`; `review/T015.md:10`; `tasks/T019.md:3-8`; `tasks/T019.md:60-67`; `review/T019.md:10` |
| R1[number withheld] | `AI_USAGE_LOG.md:13-14` |
| R1[number withheld] | `tasks/T016.md:3-8`; `tasks/T016.md:69-82`; `review/T016.md:10`; `tasks/T017.md:3-8`; `tasks/T017.md:64-80`; `review/T017.md:10`; `tasks/T018.md:3-8`; `tasks/T018.md:96-118`; `review/T018.md:10`; `tasks/T020.md:3-8`; `tasks/T020.md:70-96`; `review/T020.md:10`; `tasks/T021.md:3-8`; `tasks/T021.md:69-88`; `review/T0[number withheld].md:[number withheld]` |
| R1[number withheld] | `state/STATE.md:[number withheld][number withheld][number withheld]`; `tasks/T023.md:3-8`; `tasks/T023.md:62-77`; `review/T0[number withheld].md:[number withheld]`; `tasks/T024.md:3-8`; `tasks/T024.md:63-92`; `review/T0[number withheld].md:[number withheld]`; `tasks/T025.md:3-8`; `tasks/T025.md:60-88`; `review/T0[number withheld].md:[number withheld]`; `tasks/T027.md:3-8`; `tasks/T027.md:115-129`; `review/T0[number withheld].md:[number withheld]`; `tasks/T028.md:3-8`; `tasks/T028.md:82-95`; `review/T0[number withheld].md:[number withheld]` |
| R1[number withheld] | `tasks/T026.md:3-8`; `tasks/T026.md:69-120`; `review/T0[number withheld].md:[number withheld]`; `tasks/T034.md:3-8`; `tasks/T034.md:51-69`; `review/T0[number withheld].md:[number withheld]` |
| R1[number withheld] | `state/STATE.md:63-70` |
| R1[number withheld] | `tasks/T030.md:3-8`; `tasks/T030.md:59-61`; `review/T0[number withheld].md:[number withheld]` |
| R1[number withheld] | `tasks/T029.md:3-8`; `tasks/T029.md:102-119`; `review/T0[number withheld].md:[number withheld]` |
| R1[number withheld] | `state/STATE.md:82-83`; `tasks/T031.md:3-8`; `tasks/T031.md:88-90`; `review/T0[number withheld].md:[number withheld]`; `tasks/T041.md:3-8`; `tasks/T041.md:54-56`; `review/T0[number withheld].md:[number withheld]` |
| R1[number withheld] | `state/STATE.md:74-89`; `tasks/T032.md:3-8`; `tasks/T032.md:68-75`; `review/T0[number withheld].md:[number withheld]`; `tasks/T033.md:3-8`; `tasks/T033.md:77-89`; `review/T0[number withheld].md:[number withheld]` |
| R2[number withheld] | `tasks/T039.md:48`; `state/STATE.md:89` |
| R2[number withheld] | `state/STATE.md:84-89`; `tasks/T035.md:3-8`; `tasks/T035.md:64-66`; `review/T0[number withheld].md:[number withheld]`; `tasks/T036.md:3-8`; `tasks/T036.md:69-71`; `review/T0[number withheld].md:[number withheld]`; `tasks/T037.md:3-8`; `tasks/T037.md:51-53`; `review/T0[number withheld].md:[number withheld]`; `tasks/T038.md:3-8`; `tasks/T038.md:59-71`; `review/T0[number withheld].md:[number withheld]` |
| R2[number withheld] | `tasks/T039.md:13-16`; `state/approvals.log:112-113`; `tasks/T039.md:3-8`; `tasks/T039.md:80-82`; `review/T0[number withheld].md:[number withheld]` |
| R2[number withheld] | `tasks/T040.md:78-83`; `state/approvals.log:113`; `tasks/T040.md:3-8`; `tasks/T040.md:71-83`; `review/T0[number withheld].md:[number withheld]` |
| R2[number withheld] | `AI_USAGE_LOG.md:12`; `state/litsearch/PROTOCOL.md:12-35`; `state/litsearch/search_log.csv:2-10` |
| R2[number withheld] | `tasks/T042.md:64-69`; `review/T0[number withheld].md:[number withheld]`; `tasks/T042.md:3-8`; `tasks/T042.md:62-71`; `review/T0[number withheld].md:[number withheld]` |

Zusätzlich zu R2[number withheld]: `state/litsearch/cnki_screening.xlsx`, Blatt [number withheld], `E1:E5[number withheld]` (englische Titel), `G1:H5[number withheld]` (KI-Vorschläge/Gründe), `I1:J5[number withheld]` (PI-Entscheidungen), `L1:L5[number withheld]` (Kernzeitschriftenstatus). XLSX besitzt keine Textzeilennummern; deshalb werden Blatt und Zellbereiche angegeben. Die [number withheld] Treffer sind die Summe der Suchtreffer C1–C3 ([number withheld] + [number withheld] + [number withheld]), keine Behauptung über die Zahl einzigartiger Screening-Datensätze.

Einleitung/Legende: `agents/TEAM.md:[number withheld][number withheld][number withheld]`, `state/STATE.md:[number withheld]`, `AGENTS.md:86-96`, `AI_USAGE_LOG.md:12-23`. Der Syllabus-AI-Abschnitt auf gedruckter Seite [number withheld] wurde lokal gelesen. Die jüngere Kostenregel präzisiert die ältere allgemeine Regel verschiedener Tools. Der Stichtag ist der [number withheld]; letzter Eintrag im unveränderten Freigabelog: [number withheld]:[number withheld] (`state/approvals.log:113`).

**Karte → Zeile und Freigaben.** Alle Zeilennummern in der letzten Spalte beziehen sich auf `state/approvals.log`; A = APPROVED, D = DELIVERED (ggf. mit Override). Wiederholte A-Einträge zählen als dieselbe Karte.

| Karte | Zeile | Freigaben / Abnahme (Logzeilen) |
|---|---|---|
| T001 | R0[number withheld] | A: [number withheld]; D: [number withheld] |
| T002 | R0[number withheld] | A: [number withheld]; D: [number withheld] |
| T003 | R0[number withheld] | A: [number withheld]; D: [number withheld] |
| T004 | R0[number withheld] | A: [number withheld]; D: [number withheld] |
| T005 | R0[number withheld] | A: [number withheld]; D: [number withheld] |
| T006 | R0[number withheld] | A: [number withheld]; D: [number withheld] |
| T007 | R0[number withheld] | A: [number withheld]; D: [number withheld] |
| T008 | R0[number withheld] | A: [number withheld]; D: [number withheld] |
| T009 | R0[number withheld] | A: [number withheld]; D: [number withheld] |
| T010 | R0[number withheld] | A: [number withheld]; D: [number withheld] |
| T011 | R0[number withheld] | A: [number withheld]; D: [number withheld] |
| T012 | R0[number withheld] | A: [number withheld]; D: [number withheld] |
| T013 | R1[number withheld] | A: [number withheld]; D: [number withheld] |
| T014 | R0[number withheld] | A: [number withheld]; D: [number withheld] |
| T015 | R1[number withheld] | A: [number withheld]; D: [number withheld] |
| T016 | R1[number withheld] | A: [number withheld]; D: [number withheld] |
| T017 | R1[number withheld] | A: [number withheld]; D: [number withheld] |
| T018 | R1[number withheld] | A: [number withheld]; D: [number withheld] |
| T019 | R1[number withheld] | A: [number withheld]; D: [number withheld] |
| T020 | R1[number withheld] | A: [number withheld], [number withheld]; D: [number withheld] |
| T021 | R1[number withheld] | A: [number withheld]; D: [number withheld] |
| T022 | R0[number withheld] | A: [number withheld]; D: [number withheld] |
| T023 | R1[number withheld] | A: [number withheld], [number withheld]; D: [number withheld] |
| T024 | R1[number withheld] | A: [number withheld], [number withheld], [number withheld]; D: [number withheld] |
| T025 | R1[number withheld] | A: [number withheld], [number withheld], [number withheld], [number withheld]; D: [number withheld] |
| T026 | R1[number withheld] | A: [number withheld], [number withheld], [number withheld], [number withheld], [number withheld]; D: [number withheld] |
| T027 | R1[number withheld] | A: [number withheld]; D: [number withheld] |
| T028 | R1[number withheld] | A: [number withheld]; D: [number withheld] |
| T029 | R1[number withheld] | A: [number withheld]; D: [number withheld] |
| T030 | R1[number withheld] | A: [number withheld]; D: [number withheld] |
| T031 | R1[number withheld] | A: [number withheld]; D: [number withheld] |
| T032 | R1[number withheld] | A: [number withheld], [number withheld]; D: [number withheld] |
| T033 | R1[number withheld] | A: [number withheld], [number withheld]; D: [number withheld] |
| T034 | R1[number withheld] | A: [number withheld], [number withheld]; D: [number withheld] |
| T035 | R2[number withheld] | A: [number withheld]; D: [number withheld] |
| T036 | R2[number withheld] | A: [number withheld]; D: [number withheld] |
| T037 | R2[number withheld] | A: [number withheld]; D: [number withheld] |
| T038 | R2[number withheld] | A: [number withheld], [number withheld]; D: [number withheld] |
| T039 | R2[number withheld] | A: [number withheld], [number withheld]; D: keine |
| T040 | R2[number withheld] | A: [number withheld]; D: [number withheld] |
| T041 | R1[number withheld] | A: [number withheld]; D: [number withheld] |
| T042 | R2[number withheld] | A: [number withheld]; D: keine |

**Zahlen im bearbeiteten Text → Quellen.** Keine empirischen Ergebniszahlen wurden neu eingefügt. Die ausdrücklich geforderte Suchtrefferzahl stammt aus dem Suchprotokoll; es gibt dafür keine Quelldatei unter `replication/outputs/`.

| Zahlen / Kennungen | Quelle |
|---|---|
| Jahr [number withheld]; alle Daten/Datumsbereiche R0[number withheld]–R2[number withheld] | `AI_USAGE_LOG.md:12-23`, oben zugeordnete STATE-Stellen und sämtliche A/D-Zeilen des Kartenmappings |
| Stichtag October [number withheld], [number withheld]; [number withheld]:[number withheld] | `state/approvals.log:113` |
| T039: Oct. [number withheld], [number withheld]:[number withheld]; erfüllte Voraussetzung Oct. [number withheld] | `state/approvals.log:112-113`; `tasks/T039.md:16` |
| T040: Oct. [number withheld] | `state/approvals.log:113` |
| CNKI [number withheld] journal hits (= [number withheld] + [number withheld] + [number withheld]) | `state/litsearch/search_log.csv:8-10`, Spalte hits; Summe ohne Deduplizierung |
| October [number withheld] in der Review-Legende | `agents/TEAM.md:131-136`; `state/STATE.md:79` |
| Opus [number withheld]; GPT-[number withheld]-Sol; Gemini [number withheld] Flash; Haiku/T006 | `AI_USAGE_LOG.md:17-23` |
| Two script errors | `AI_USAGE_LOG.md:21` |
| T001–T042 | Kartenkennungen, vollständiges Mapping oben; keine Ergebniszahlen |
| RL1/RL3 | Kennzahlennamen aus den zugeordneten Karten; keine Ergebniszahlen |
| [number withheld]pt; [number withheld]/[number withheld]/[number withheld] linewidth; [number withheld] und [number withheld]pt | Unveränderte Satzparameter bzw. deren Breitenrechnung in `proposal/appendix/ai_use.tex:11-14`; keine Forschungszahlen |

**Vorgeschlagene Logzeilen für den PI.** CC/CX/CL entsprechen der Appendix-Legende; nicht ausdrücklich belegte Modelle bleiben offen. Die Vorschläge dokumentieren vergangene Nutzung, erteilen keine Freigaben.

| Datum | Tool / Modell | Zweck und repräsentative Aufgabe | Dokumentierte Prüfung | Änderung / verworfen |
|---|---|---|---|---|
| 2026-10-23 | Andere KI; Tool/Modell nicht dokumentiert | Lösungsansatz zum Projekt; Anton brachte die Antwort ein. | Co-PI glich Vorschläge mit dem Projektstand ab; bereits umgesetzter Cluster-Bootstrap und additive Zerlegung waren der externen Beratung unbekannt. Keine unabhängige Validierung der Antwort dokumentiert. | Renditelückentest gestrichen; Frozen-MI-Kontrafaktum, Robustheit, Vertragsmerkmale, RL1-Validierung und Theorieanpassungen priorisiert. Quelle: `state/STATE.md:63-70` (R1[number withheld]). |
| Prüfung dokumentiert 2026-10-27; genauer Übersetzungstag offen | DeepL, vom PI genutzt; Modell offen | Chinesische Fallbelege lesen und ihre Bedeutung prüfen. | Huafa und Nanshan auf Bedeutung geprüft; Xinhu nur auf übereinstimmende Textstellen. Quellen: `tasks/T039.md:48`, `state/STATE.md:89` (R2[number withheld]). | Xinhu bis zur Inhaltsprüfung aus den Proposal-Fällen ausgeschlossen; keine Prävalenzschätzung aus dem gezielten Piloten. |
| 2026-10-27 (Präzisierung des vorhandenen Eintrags) | Claude Code, Opus [number withheld] laut Log | Web of Science: Suchstrings, Zusammenführen/Deduplizieren, Titel-/Abstract- und Volltextvorschläge, PRISMA-Zählung. | Anton führte die Suchen durch; Exporte/Screenshots und Suchprotokoll archiviert; PI entscheidet über Aufnahme und prüft PDFs. | KI-Vorschläge bleiben beratend; regelbasierte Ausschlüsse sind korrigierbar; PRISMA verwendet PI-Entscheidungen. Quelle: `AI_USAGE_LOG.md:12`, `state/litsearch/search_log.csv:2-7` (R2[number withheld]). |
| 2026-10-28 | Claude Code; Modell nicht gesondert dokumentiert | CNKI C1–C3: KI-Vorschläge und englische Titelübersetzungen für das Screening. | Suchprotokoll/Exporte: [number withheld] Journal-Treffer vor Deduplizierung; Screening trennt KI-Vorschlag, PI-Entscheidung und Kernzeitschriftenstatus. | CSSCI-/Peking-University-Kernzeitschriftenkriterium anwenden; KI-Aufnahmevorschlag ist keine PI-Entscheidung und keine Volltextprüfung. Quellen: `state/litsearch/search_log.csv:8-10`, `state/litsearch/PROTOCOL.md:23-26`, `state/litsearch/cnki_screening.xlsx`, Spalten E–L (R2[number withheld]). |
| [number withheld], Oct. [number withheld]–[number withheld] | CX; AG; Claude; Modelle soweit nicht belegt offen | T005, T008, T009, T011, T012: descriptives, power, DiD, event studies and robustness. | Review PASS; PI accepted; documented via task card. | Main exposure changed to pre-policy average; scratch build repaired; joint pre-trend caveat retained. Quellen: R0[number withheld] oben. |
| [number withheld], Oct. [number withheld]–[number withheld] | CX; Claude; Modelle soweit nicht belegt offen | T010/T014/T022: standalone build, Windows portability and safe LaTeX notes. | Review PASS; PI accepted; documented via task card. | Fresh-copy rebuild completed; PDF guards relaxed by decision; special characters escaped. Quellen: R0[number withheld] oben. |
| [number withheld], Oct. [number withheld]–[number withheld] | CX; Claude; CC; Modelle soweit nicht belegt offen | T013/T015/T019: independent coding, panel merge, heterogeneity and final code items. | T013 REWORK; PI override: resolve coding conflict by reports; T015/T019 PASS and accepted. | Ownership-specific time effects replace restricted model; ambiguous controllers excluded from heterogeneity. Documented via task card. Quellen: R1[number withheld] oben. |
| [number withheld], Oct. [number withheld]–[number withheld] | CL; CX; CC; Modelle soweit nicht belegt offen | T016–T018/T020/T021: format, title page, outline, data, strategy and results. | T016 PASS; others REWORK, accepted by PI overrides for scope, corrected comments, wording or length. | Mechanism directions corrected; abbreviations added; length deferred. Documented via task card. Quellen: R1[number withheld] oben. |
| [number withheld], Oct. [number withheld]–[number withheld] | CX; Claude; Modelle soweit nicht belegt offen | T023–T025/T027/T028: targeting tests, RD, selection, decomposition and controls. | All reviews: PASS; PI accepted; documented via task card. | Definition placebos qualified; weak fuzzy RD labeled; selection correction revised; pre-trend caveats retained. Quellen: R1[number withheld] oben. |
| [number withheld], Oct. [number withheld]–[number withheld] | CL; CX; Modelle soweit nicht belegt offen | T026/T034: model real and cosmetic compliance and link predictions to tests. | Estimation PASS; overall REWORK; PI overrides: remaining length, spelling and table note. | Pre-existing wedge, conditional predictions, debt-like equity mapping and buffer derivative corrected. Documented via task card. Quellen: R1[number withheld] oben. |
| [number withheld], Oct. [number withheld] | CX; Claude; Modelle soweit nicht belegt offen | T030: extend existing EastMoney panel beyond main analysis window. | Review PASS; PI accepted; documented via task card. | Wind-only missing periods left missing; extension kept separate from main window. Quellen: R1[number withheld] oben. |
| [number withheld], Oct. [number withheld]–[number withheld] | CX; Claude; Modelle soweit nicht belegt offen | T029: freeze minority interests and compare compliance and predetermined distance groups. | All reviews: PASS; PI accepted; documented via task card. | Anchor bias and small-cell inference corrected; pre-policy differences preclude causal policy claim. Quellen: R1[number withheld] oben. |
| [number withheld], Oct. [number withheld]–[number withheld] | CX; Claude; Modelle soweit nicht belegt offen | T031/T041: firm support, timing, density flexibility and matched-horizon placebos. | Estimation PASS; PI overrides: RL1-definition issue, labels and unrelated STATE change. | Definition question assigned to T040; limits of robustness retained. Documented via task card. Quellen: R1[number withheld] oben. |
| [number withheld], Oct. [number withheld]–[number withheld] | CX; Modelle soweit nicht belegt offen | T032/T033: extract report and announcement evidence with page citations. | Consistency PASS; T032 ESCALATE, T033 REWORK; PI overrides: old baseline and missing secondary bank financing. | Relationship coding corrected; missing financing documented as limitation; PI verification required. Documented via task card. Quellen: R1[number withheld] oben. |
| [number withheld], Oct. [number withheld]–[number withheld] | CL; CX; CC; Modelle soweit nicht belegt offen | T035–T038: rewrite framework, data, results, introduction, literature and conclusion; polish. | REWORK or ESCALATE; PI overrides: card error, consistent numbers and remaining layout/language items. | RL1/RL3 caveats and wording corrected; residual length and case text assigned to T039. Documented via task card. Quellen: R2[number withheld] oben. |
| [number withheld], Oct. [number withheld]–[number withheld] | CL; CX; Modelle soweit nicht belegt offen | T039: verified cases, final restructuring, validation, search and cuts. | Earlier draft REWORK; revised card approved Oct. [number withheld], [number withheld]:[number withheld]; no PI delivery logged. | Earlier version superseded; T040 delivery prerequisite met Oct. [number withheld]. Documented via task card. Quellen: R2[number withheld] oben. |
| [number withheld], Oct. [number withheld]–[number withheld] | CX; Claude; CC; Modelle soweit nicht belegt offen | T040: code firms' published ratios and rerun key results under perpetual-debt convention. | Data/estimation PASS; consistency REWORK; Co-PI PDF check; PI accepted Oct. [number withheld] by override. | Definition/coverage wording corrected; override leaves stale README check note to follow-up. Documented via task card. Quellen: R2[number withheld] oben. |
| [number withheld], Oct. [number withheld]–[number withheld] | CX; Modelle soweit nicht belegt offen | T042: compile this statement from log, cards, verdicts and approvals. | Initial reviews: REWORK; local LaTeX/layout check; re-review and PI acceptance pending. | Added source mapping, log proposals, current status and CNKI search after review; undocumented details unspecified. Quellen: R2[number withheld] oben. |
| 2026-10-26 | Claude Code / Teamtools | Reviewregeln nach PI-Kostenentscheidung anpassen. | PI-Entscheidung in `state/STATE.md:79`; Regeln in `agents/TEAM.md:131-136`. | Nicht schätzende Rollen dürfen das Worker-Tool in frischer lesender Sitzung nutzen; dokumentarische Reworks nach Estimation-PASS mit Co-PI-Prüfung und begründetem Override. |
| 2026-10-27 | Claude Code; Modell nicht gesondert dokumentiert | Literaturmetadaten anhand PI-BibTeX, gelesener Fassung und PDF-Zitierhinweis aktualisieren. | `state/STATE.md:91-93` nennt die Grundlagen; keine unabhängige Vollprüfung behauptet. | Schlüssel vereinheitlicht, Autoren/Jahre und englische Metadaten angepasst; offene Literaturfragen bleiben offen. |

## Offene Fragen

- Toolname, Modell und Originalprompt der externen KI-Beratung vom [number withheld]. Oktober fehlen. Die externe Entwurfsrückmeldung vom [number withheld]. Oktober nennt keine Herkunft; sie wurde deshalb nicht zusätzlich einer KI zugeschrieben.
- DeepL-Nutzung und Prüfabschluss sind belegt, der genaue Übersetzungstag und die Modellversion nicht. Der [number withheld]. Oktober bezeichnet den dokumentierten Prüfabschluss.
- Die Quellen belegen Vertraulichkeitsregeln und lokale Verarbeitung, aber keinen vollständigen Übertragungsnachweis für Wind-Daten. Die Einleitung behält diese Beleggrenze bei; es wurde keine historische Zusicherung erfunden.
- Der Co-PI aktualisiert den Appendix vor Abgabe erneut. T039 hat keine DELIVERED-Zeile, T042 benötigt nach diesem Rework den regulären Review und die PI-Abnahme. Die Kartenstatus wurden nicht geändert.
- Die [number withheld] offenen Referenzen und [number withheld] offenen Zitate im Gesamtproposal liegen außerhalb dieser Karte. Der isolierte Ausgangs- und Endstand hat dieselben Warnungen; für eine spätere geänderte Gesamtfassung ist erneut zu kompilieren.
- Keine früheren Schätzungen, Literaturvolltexte oder Inhaltskodierungen erneut geprüft. Nur dokumentierte Prüfungen nachvollzogen; kein Netzwerk, kein Git, kein Overleaf-Abgleich. Die vier gesicherten Eingaben (AI-Log, Freigabelog, Suchlog, T042-Karte) blieben während des Reworks hashgleich.