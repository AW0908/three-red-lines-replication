## Ergebnis
Ich habe T051 nach dem Prüfbericht nachgearbeitet. Die Robustheitstabelle heißt jetzt „Robustness of post-policy excess mass at RL1“. In der ersten Zeile steht die direkte Veränderung Δb = 4.02 [1.67, 6.80], die übrigen sechs Zeilen tragen die Beschriftung „Post-policy b“. Für „one observation per firm“ steht jetzt die Fallzahl 132 (132). Die Notiz besteht aus kurzen Sätzen und enthält nur noch ein Intervall. Die Zusatzzahlen zu Einzeldaten, 2020H2 allein, eingefrorenem MI mit Perpetuals und Δb_net stehen nicht mehr in der Notiz, sondern sind über einen Verweis erreichbar. Die Sprachpunkte 1, 2, 6, 7 und 8 sind umgesetzt, Punkt 3 ist mit der neuen Notiz erledigt. Rework-Punkt 2 (Satz zu den wirtschaftlichen Folgen) habe ich nicht umgesetzt, weil die Lesebestätigung des PI noch fehlt.

## Dateien
- `proposal/tables/t051_robustness.tex` – Titel, Δb-Zeile, Zeilenbeschriftungen, N = 132 (132), gekürzte Notiz mit einem Intervall, Quellkommentare
- `proposal/sections/06_preliminary_analysis.tex` – Finding 1: „Two patterns qualify this result:“ und neue Klammer zum Appendix; Finding 2: nur noch ein „interval“ je Satz
- `proposal/sections/04_empirical_model.tex` – 5.5: zweimal „the main threat is …“ und „are exposed to“ statt „share“
- `proposal/sections/07_conclusion.tex` – neuer erster Satz, keine wörtliche Wiederholung von 6.1 mehr; „how the developer chose to report …“ ist zu „reporting choices“ verdichtet. Der Schluss ist gestrafft, damit er auf Seite 15 endet (siehe Offene Fragen).
- `proposal/sections/01_introduction.tex` – geprüft, im Ergebnis unverändert (ein Probeeinschub zu Sprachhinweis 9 ist wieder entfernt)
- `tasks/T051_report.md` – dieser Bericht

## Ausführung
`cd proposal && latexmk -interaction=nonstopmode -outdir=../review/T051_build main.tex`
[fenced excerpt withheld in public audit]
[fenced excerpt withheld in public audit]
In `main.log` gibt es keine Treffer für Warning, Overfull, Underfull oder undefined. In `main.aux` steht `sec:conclusion` auf Seite 15 und `sec:main_end` ebenfalls auf Seite 15.

## Abnahmekriterien
1. **Erfüllt.** Der Haupttext endet auf Seite 15 und der Build läuft sauber. Zwischenstand: Nach den ersten Rework-Änderungen lag `sec:main_end` auf Seite 16. Ich habe deshalb Notiz und Schluss gekürzt, ohne Zahlen zu ändern.
   Wortzahlen je Datei, roh mit `wc -w`, Kommentare eingeschlossen, gleiche Methode wie im ersten Bericht. „Vor T051“ habe ich aus `review/T051_proposal.diff` zurückgerechnet, da kein Git verwendet wird:

   | Abschnitt | Vor T051 | Nach T051 (jetzt) |
   |---|---|---|
   | 1 Introduction | 457 | 648 |
   | 2 Literature | 464 | 464 |
   | 3 Framework | 747 | 747 |
   | 4 Context and Data (`05_context_data.tex`) | 1112 | 1132 |
   | 5 Empirical Strategy (`04_empirical_model.tex`) | 824 | 1013 |
   | 6 Preliminary Analysis | 2011 | 1898 |
   | 7 Conclusion | 256 | 317 |
   | Tabelle `t051_robustness.tex` (neu) | – | 338 |

   Seitenanfänge jetzt: 1 → S. 1, 2 → S. 2, 3 → S. 3, 4 → S. 5, 4.5 → S. 7, 5 → S. 7, 5.3 → S. 8, 5.4/5.5 → S. 9, 6 → S. 9, 6.2 → S. 11, 6.3 → S. 13, 6.4 → S. 14, 6.5 → S. 15, 7 → S. 15, Ende → S. 15. Tabelle 1 steht auf S. 6, Tabelle 3 auf S. 10, Abbildung 3 auf S. 12. Die Seitenanfänge vor T051 kann ich nicht belegen, weil der alte Build überschrieben ist.

2. **Erfüllt.** Jede Zahl in der Robustheitstabelle mit Quelldatei und Auswahl:
   - Zeile 1: 4.02 [1.67, 6.80] und 797/630 (136) → `t043_delta_b.csv`, threshold=0.7, specification=main: delta_b 4.020, ci 1.671/6.797, n_pre 797, n_post 630, firms_union 136
   - Zeile 2: 3.24 [1.02, 6.19] und 575 (115) → `t031_samples.csv`, B_balanced13, post
   - Zeile 3: 998/999, [1.02, 5.86] und 132 (132) → `t041_one_per_firm.csv`, random_date_draw: share 0.998999, q025 1.023, q975 5.856, n = firms = 132
   - Zeile 4: 3.54 [1.11, 6.76] und 498 (130) → `t031_timing.csv`, b_post, T023, ii_2021H1_2022H2
   - Zeile 5: 2.58 [0.52, 5.13] und 630 (132) → `t040_robustness.csv`, perpetual, T023_b
   - Zeile 6: 3.76 [1.60, 6.15] und 630 (132) → `t043_integration.csv`, chetty_net, post
   - Zeile 7: 2.01 [1.27, 2.82] und 630 (132) → `t043_meas_error.csv`, all, uncentered, b_post (mean, p025, p975)
   - Notiz: 3.14 [1.01, 5.84] → `t031_samples.csv`, A_all, post (identisch mit b_post in `t043_delta_b.csv`); 999 Ziehungen und 64 Validierungspaare → `t043_meas_error.csv` und `t041_one_per_firm.csv`

   Neue Zahlen im Fließtext gibt es nicht. Δb 4.02 [1.67, 6.80] und 11.5 im Schluss waren schon vorher da, Quelle wie im Schluss-Kommentar.

3. **Erfüllt, unverändert gegenüber dem ersten Durchgang.** Absatz 1 bringt die Motivation („Whether compliance is partly ‚on paper' therefore matters for supervisors …“). Absatz 2 bringt Frage und Methode („We ask whether developers targeted RL1 …; we proceed in three steps …“). Absatz 3 bringt den Beitrag.

4. **PI-Kommentare 1–8:**
   1. Titelzeile „Research proposal“: erfüllt (erster Durchgang).
   2. Zeile im Inhaltsverzeichnis entfernt: erfüllt (erster Durchgang).
   3. Einleitung mit Politik und Anreiz: erfüllt, etwa +190 Wörter. Der Satz zu den wirtschaftlichen Folgen fehlt noch, weil die PI-Bestätigung aussteht.
   4. Robustheitstabelle: erfüllt mit 7 Zeilen. Δb steht in der ersten Zeile, die Notiz hat ein Intervall, in 6.1 und 6.2 steht höchstens ein Intervall pro Satz.
   5. 5.3 bis 5.5 als Fließtext: erfüllt, 5.5 nach den Sprachhinweisen nachgeschärft.
   6. Tabelle 1 in Normalgröße auf voller Breite: erfüllt (erster Durchgang).
   7. Abbildung 3 mit `0.85\linewidth`: erfüllt (erster Durchgang).
   8. Schluss in der Reihenfolge primär – sekundär – explorativ, mit Grenzen und nächsten Schritten: erfüllt, ohne neue Zahlen. Das Ziel „ein Drittel Seite länger“ ist nur teilweise erreicht (siehe Offene Fragen).

## Offene Fragen
- **Rework-Punkt 2 (Satz zu den wirtschaftlichen Folgen) ist nicht umgesetzt.** Unter „PI decisions“ steht noch „(pending)“. Falls er nachgereicht wird, muss der Text an anderer Stelle um etwa 2–3 Zeilen gekürzt werden, denn Seite 15 ist jetzt genau voll.
- **Die Zusatzzahlen sind nicht in den Appendix verschoben worden.** Die Karte verbietet Änderungen am Appendix. Die Notiz verweist deshalb auf die vorhandenen Appendix-Tabellen (`tab:t031_samples`, `tab:t031_timing`, `tab:t040_robustness`, `tab:t043_integration`). Diese enthalten bereits 2020H2 allein, eingefrorenes MI mit Perpetuals und Δb_net. Für die Einzeldaten verweist die Notiz auf das Replikationspaket, weil es im Appendix keine Tabelle für `t041_one_per_firm.csv` gibt. Das sollte die Appendix-Karte nachholen.
- **Der Schluss ist kürzer, als PI-Kommentar 8 verlangt.** Gegenüber dem Stand vor T051 sind es nur noch +61 Wörter, also ungefähr ein Fünftel bis ein Viertel Seite statt eines Drittels. Gekürzt habe ich, weil die Kopfzeile der Robustheitstabelle schon eine Zeile Seite 16 erreichte und das Seitenlimit hart ist. Dafür habe ich aus dem Schluss den Satz „We will incorporate the instructor's and referees' feedback.“ entfernt. Gekürzt sind außerdem „not feasible balance sheets“ (jetzt „the MI benchmarks are accounting comparisons“) und der Halbsatz „under the firm trend, was slower“. Beides steht weiterhin in 6.2 und in der Notiz zu Abbildung 3. Bitte prüfen, ob die Kürzungen inhaltlich akzeptabel sind.
- Sprachhinweis 9 („0.70 in ratio units“) habe ich aus Platzgründen nicht umgesetzt; er war als Hinweis markiert, nicht als Fehler.
- Die Meldung „außerhalb des Schreibbereichs“ zu `proposal/appendix/results.tex` und den Abschnittsdateien betrifft nicht diesen Rework. `appendix/results.tex` habe ich nicht verändert. Die Abschnittsdateien liegen laut Karte im Schreibbereich (`proposal/sections/*.tex`).
- Die Lesbarkeit der Achsenbeschriftung von Abbildung 3 im Druck habe ich nicht visuell geprüft, nur die Breite im Code.
- Die Wortzahlen „vor T051“ sind von Hand aus dem Diff zurückgerechnet (aktuelle Zählung minus hinzugefügte plus entfernte Wörter). Abweichungen von ±1–2 Wörtern je Abschnitt sind möglich.
