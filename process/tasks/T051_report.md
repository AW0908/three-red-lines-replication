## Ergebnis
Ich habe T051 nach dem Prüfbericht nachgearbeitet. Die Robustheitstabelle heißt jetzt „Robustness of post-policy excess mass at RL1“. In der ersten Zeile steht die direkte Veränderung Δb = [number withheld] [[number withheld], [number withheld]], die übrigen sechs Zeilen tragen die Beschriftung „Post-policy b“. Für „one observation per firm“ steht jetzt die Fallzahl [number withheld] ([number withheld]). Die Notiz besteht aus kurzen Sätzen und enthält nur noch ein Intervall. Die Zusatzzahlen zu Einzeldaten, [number withheld]H2 allein, eingefrorenem MI mit Perpetuals und Δb_net stehen nicht mehr in der Notiz, sondern sind über einen Verweis erreichbar. Die Sprachpunkte [number withheld], [number withheld], [number withheld], [number withheld] und [number withheld] sind umgesetzt, Punkt [number withheld] ist mit der neuen Notiz erledigt. Rework-Punkt [number withheld] (Satz zu den wirtschaftlichen Folgen) habe ich nicht umgesetzt, weil die Lesebestätigung des PI noch fehlt.

## Dateien
- `proposal/tables/t051_robustness.tex` – Titel, Δb-Zeile, Zeilenbeschriftungen, N = [number withheld] ([number withheld]), gekürzte Notiz mit einem Intervall, Quellkommentare
- `proposal/sections/06_preliminary_analysis.tex` – Finding [number withheld]: „Two patterns qualify this result:“ und neue Klammer zum Appendix; Finding [number withheld]: nur noch ein „interval“ je Satz
- `proposal/sections/04_empirical_model.tex` – [number withheld]: zweimal „the main threat is …“ und „are exposed to“ statt „share“
- `proposal/sections/07_conclusion.tex` – neuer erster Satz, keine wörtliche Wiederholung von [number withheld] mehr; „how the developer chose to report …“ ist zu „reporting choices“ verdichtet. Der Schluss ist gestrafft, damit er auf Seite [number withheld] endet (siehe Offene Fragen).
- `proposal/sections/01_introduction.tex` – geprüft, im Ergebnis unverändert (ein Probeeinschub zu Sprachhinweis [number withheld] ist wieder entfernt)
- `tasks/T051_report.md` – dieser Bericht

## Ausführung
`cd proposal && latexmk -interaction=nonstopmode -outdir=../review/T0[number withheld]_build main.tex`
[fenced excerpt withheld in public process copy]
[fenced excerpt withheld in public process copy]
In `main.log` gibt es keine Treffer für Warning, Overfull, Underfull oder undefined. In `main.aux` steht `sec:conclusion` auf Seite [number withheld] und `sec:main_end` ebenfalls auf Seite [number withheld].

## Abnahmekriterien
[number withheld]. **Erfüllt.** Der Haupttext endet auf Seite [number withheld] und der Build läuft sauber. Zwischenstand: Nach den ersten Rework-Änderungen lag `sec:main_end` auf Seite [number withheld]. Ich habe deshalb Notiz und Schluss gekürzt, ohne Zahlen zu ändern.
   Wortzahlen je Datei, roh mit `wc -w`, Kommentare eingeschlossen, gleiche Methode wie im ersten Bericht. „Vor T051“ habe ich aus `review/T0[number withheld]_proposal.diff` zurückgerechnet, da kein Git verwendet wird:

   | Abschnitt | Vor T051 | Nach T051 (jetzt) |
   |---|---|---|
   | [number withheld] Introduction | [number withheld] | [number withheld] |
   | [number withheld] Literature | [number withheld] | [number withheld] |
   | [number withheld] Framework | [number withheld] | [number withheld] |
   | [number withheld] Context and Data (`05_context_data.tex`) | [number withheld] | [number withheld] |
   | [number withheld] Empirical Strategy (`04_empirical_model.tex`) | [number withheld] | [number withheld] |
   | [number withheld] Preliminary Analysis | [number withheld] | [number withheld] |
   | [number withheld] Conclusion | [number withheld] | [number withheld] |
   | Tabelle `t051_robustness.tex` (neu) | – | [number withheld] |

   Seitenanfänge jetzt: [number withheld] → S. [number withheld], [number withheld] → S. [number withheld], [number withheld] → S. [number withheld], [number withheld] → S. [number withheld], [number withheld] → S. [number withheld], [number withheld] → S. [number withheld], [number withheld] → S. [number withheld], [number withheld]/[number withheld] → S. [number withheld], [number withheld] → S. [number withheld], [number withheld] → S. [number withheld], [number withheld] → S. [number withheld], [number withheld] → S. [number withheld], [number withheld] → S. [number withheld], [number withheld] → S. [number withheld], Ende → S. [number withheld]. Tabelle [number withheld] steht auf S. [number withheld], Tabelle [number withheld] auf S. [number withheld], Abbildung [number withheld] auf S. [number withheld]. Die Seitenanfänge vor T051 kann ich nicht belegen, weil der alte Build überschrieben ist.

[number withheld]. **Erfüllt.** Jede Zahl in der Robustheitstabelle mit Quelldatei und Auswahl:
   - Zeile [number withheld]: [number withheld] [[number withheld], [number withheld]] und [number withheld]/[number withheld] ([number withheld]) → `t043_delta_b.csv`, threshold=[number withheld], specification=main: delta_b [number withheld], ci [number withheld]/[number withheld], n_pre [number withheld], n_post [number withheld], firms_union [number withheld]
   - Zeile [number withheld]: [number withheld] [[number withheld], [number withheld]] und [number withheld] ([number withheld]) → `t031_samples.csv`, B_balanced1[number withheld], post
   - Zeile [number withheld]: [number withheld]/[number withheld], [[number withheld], [number withheld]] und [number withheld] ([number withheld]) → `t041_one_per_firm.csv`, random_date_draw: share [number withheld], q0[number withheld] [number withheld], q9[number withheld] [number withheld], n = firms = [number withheld]
   - Zeile [number withheld]: [number withheld] [[number withheld], [number withheld]] und [number withheld] ([number withheld]) → `t031_timing.csv`, b_post, T023, ii_2[number withheld]H1_2[number withheld]H2
   - Zeile [number withheld]: [number withheld] [[number withheld], [number withheld]] und [number withheld] ([number withheld]) → `t040_robustness.csv`, perpetual, T0[number withheld]_b
   - Zeile [number withheld]: [number withheld] [[number withheld], [number withheld]] und [number withheld] ([number withheld]) → `t043_integration.csv`, chetty_net, post
   - Zeile [number withheld]: [number withheld] [[number withheld], [number withheld]] und [number withheld] ([number withheld]) → `t043_meas_error.csv`, all, uncentered, b_post (mean, p0[number withheld], p9[number withheld])
   - Notiz: [number withheld] [[number withheld], [number withheld]] → `t031_samples.csv`, A_all, post (identisch mit b_post in `t043_delta_b.csv`); [number withheld] Ziehungen und [number withheld] Validierungspaare → `t043_meas_error.csv` und `t041_one_per_firm.csv`

   Neue Zahlen im Fließtext gibt es nicht. Δb [number withheld] [[number withheld], [number withheld]] und [number withheld] im Schluss waren schon vorher da, Quelle wie im Schluss-Kommentar.

[number withheld]. **Erfüllt, unverändert gegenüber dem ersten Durchgang.** Absatz [number withheld] bringt die Motivation („Whether compliance is partly ‚on paper' therefore matters for supervisors …“). Absatz [number withheld] bringt Frage und Methode („We ask whether developers targeted RL1 …; we proceed in three steps …“). Absatz [number withheld] bringt den Beitrag.

[number withheld]. **PI-Kommentare [number withheld]–[number withheld]:**
   [number withheld]. Titelzeile „Research proposal“: erfüllt (erster Durchgang).
   [number withheld]. Zeile im Inhaltsverzeichnis entfernt: erfüllt (erster Durchgang).
   [number withheld]. Einleitung mit Politik und Anreiz: erfüllt, etwa [number withheld] Wörter. Der Satz zu den wirtschaftlichen Folgen fehlt noch, weil die PI-Bestätigung aussteht.
   [number withheld]. Robustheitstabelle: erfüllt mit [number withheld] Zeilen. Δb steht in der ersten Zeile, die Notiz hat ein Intervall, in [number withheld] und [number withheld] steht höchstens ein Intervall pro Satz.
   [number withheld]. [number withheld] bis [number withheld] als Fließtext: erfüllt, [number withheld] nach den Sprachhinweisen nachgeschärft.
   [number withheld]. Tabelle [number withheld] in Normalgröße auf voller Breite: erfüllt (erster Durchgang).
   [number withheld]. Abbildung [number withheld] mit `[number withheld]\linewidth`: erfüllt (erster Durchgang).
   [number withheld]. Schluss in der Reihenfolge primär – sekundär – explorativ, mit Grenzen und nächsten Schritten: erfüllt, ohne neue Zahlen. Das Ziel „ein Drittel Seite länger“ ist nur teilweise erreicht (siehe Offene Fragen).

## Offene Fragen
- **Rework-Punkt [number withheld] (Satz zu den wirtschaftlichen Folgen) ist nicht umgesetzt.** Unter „PI decisions“ steht noch „(pending)“. Falls er nachgereicht wird, muss der Text an anderer Stelle um etwa [number withheld]–[number withheld] Zeilen gekürzt werden, denn Seite [number withheld] ist jetzt genau voll.
- **Die Zusatzzahlen sind nicht in den Appendix verschoben worden.** Die Karte verbietet Änderungen am Appendix. Die Notiz verweist deshalb auf die vorhandenen Appendix-Tabellen (`tab:t0[number withheld]_samples`, `tab:t0[number withheld]_timing`, `tab:t0[number withheld]_robustness`, `tab:t0[number withheld]_integration`). Diese enthalten bereits [number withheld]H2 allein, eingefrorenes MI mit Perpetuals und Δb_net. Für die Einzeldaten verweist die Notiz auf das Replikationspaket, weil es im Appendix keine Tabelle für `t041_one_per_firm.csv` gibt. Das sollte die Appendix-Karte nachholen.
- **Der Schluss ist kürzer, als PI-Kommentar [number withheld] verlangt.** Gegenüber dem Stand vor T051 sind es nur noch [number withheld] Wörter, also ungefähr ein Fünftel bis ein Viertel Seite statt eines Drittels. Gekürzt habe ich, weil die Kopfzeile der Robustheitstabelle schon eine Zeile Seite [number withheld] erreichte und das Seitenlimit hart ist. Dafür habe ich aus dem Schluss den Satz „We will incorporate the instructor's and referees' feedback.“ entfernt. Gekürzt sind außerdem „not feasible balance sheets“ (jetzt „the MI benchmarks are accounting comparisons“) und der Halbsatz „under the firm trend, was slower“. Beides steht weiterhin in [number withheld] und in der Notiz zu Abbildung [number withheld]. Bitte prüfen, ob die Kürzungen inhaltlich akzeptabel sind.
- Sprachhinweis [number withheld] („[number withheld] in ratio units“) habe ich aus Platzgründen nicht umgesetzt; er war als Hinweis markiert, nicht als Fehler.
- Die Meldung „außerhalb des Schreibbereichs“ zu `proposal/appendix/results.tex` und den Abschnittsdateien betrifft nicht diesen Rework. `appendix/results.tex` habe ich nicht verändert. Die Abschnittsdateien liegen laut Karte im Schreibbereich (`proposal/sections/*.tex`).
- Die Lesbarkeit der Achsenbeschriftung von Abbildung [number withheld] im Druck habe ich nicht visuell geprüft, nur die Breite im Code.
- Die Wortzahlen „vor T051“ sind von Hand aus dem Diff zurückgerechnet (aktuelle Zählung minus hinzugefügte plus entfernte Wörter). Abweichungen von ±[number withheld]–[number withheld] Wörtern je Abschnitt sind möglich.
