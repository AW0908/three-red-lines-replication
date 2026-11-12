## Rolle: consistency (claude, sonnet) – VERDICT: REWORK


## Befunde

1. **Kaputte Apostrophe in Tabellennotizen (Darstellung).** In vier der neuen Anhangstabellen steht `\'s` statt `'s`: `proposal/tables/t058_above.tex:29` (region\'s), `t058_attrition.tex:19` (firm\'s), `t058_checks.tex:19` (Hong Kong\'s) und `t058_symmetric.tex:34`. In LaTeX setzt `\'` einen Akut auf das folgende Zeichen, es entsteht also „regionś" statt „region's". Die Fundstellen sind per Grep belegt. Ich habe das PDF nicht gesehen. Die Zahlen sind davon nicht betroffen, die Notizen sind aber fehlerhaft gesetzt. Der Bericht sagt, die Darstellung sei visuell geprüft worden.

2. **Aussage „Hongkong, wo die Konzentration am stärksten ist" geht über die Outputs hinaus.** Die Aussage steht in `02_literature.tex`. Belegt sind Hongkong 6.74 und A-Aktien 2.10. Die Differenz ist aber 4.64 [−0.65, 10.26] (`t058_standard.csv` Zeile 34, Tabelle B14), ihr Intervall schließt null ein. „Strongest" ist nur eine Aussage über Punktschätzer. Ohne imputierte Nullwerte ist die Differenz 6.51 [0.35, 13.34], also präzise, aber nur in dieser Variante. Der Text in 6.1 sagt dagegen sauber „exceeds the A-share point estimate". Die Aussage in Abschnitt 2 ist damit strenger als die in 6.1. Vorschlag: „where the point estimate is largest" oder die Differenz mit Intervall nennen.

3. **Fallzahl in der Notiz zu Tabelle B14 passt nicht zur Tabellenzeile.** Die Notiz nennt für Hongkong in der Vorperiode „81/318" Beobachtungen mit imputierter Null. Die Zeile „Baseline, Hong Kong" in derselben Tabelle und `t058_standard.csv` Zeile 30 führen für die Vorperiode 317 (56 Firmen). Die Differenz von einer Beobachtung kann ein gültiger Unterschied zwischen „alle Zeilen" und „Zeilen mit gültigem RL1" sein. Die Notiz erklärt ihn nicht. Den Zähler 81 habe ich in der CSV nicht wiedergefunden.

4. **Klammer nicht geschlossen** in `06_preliminary_analysis.tex`, Satz zum Notch-Kontrast: „(…; contemporaneous classification also permits composition changes (Appendix Table~…)." Die erste Klammer wird nie geschlossen. Das ist ein Sprachfehler und gehört eher zur Sprachrolle.

5. **Uneinheitliche Reihenfolge der Fallzahlen.** Tabelle 3 und die Notiz dazu nennen „pre/post". Die Anhangstabellen B9 bis B14 nennen „post/pre" bei Änderungen und „erste/Benchmark" bei Kontrasten. Jede Tabelle erklärt ihre Konvention in der Notiz, deshalb ist das kein Fehler. Es erschwert aber den Abgleich, zum Beispiel balanciertes Δb: „690/575" in Tabelle 3 gegen „575/690" in B12.

6. **Quellenangabe Huang.** Die Karte nennt S. 13, der Quellenkommentar in `05_context_data.tex` und der Bericht sagen S. 12 der lokalen PDF. Der Text zitiert keine Seite, es entsteht daher kein Zahlenfehler. Anton sollte den Unterschied bestätigen.

## Abnahmekriterien

1. **Jede Zahl aus einer CSV, jede zitierte Tabelle enthält die zitierte Zahl.**
   - Belegt erfüllt für alle Zahlen, die ich gegen die CSV geprüft habe:
     - Pilot-Kontrast −1.53 [−10.45, 7.36], 13 Beobachtungen aus 4 Firmen.
     - Notch-Kontrast −1.30 [−5.29, 2.87].
     - Masse oberhalb 1.75 und 0.85 (Tabelle B13).
     - Gitter 72/72 positiv, 69 Intervalle über null, Median 3.92. 0.958 × 72 = 69 stimmt.
     - Balanciertes Δb 3.91, Austrittsanteile 10.0 und 17.5, Fisher p = 1.00.
     - 2020H1 hinzugefügt: 4.26.
     - Hongkong 6.74 und 8.61, A-Aktien 2.10.
     - Parent-Equity-D 8.5 und Schulden-D −4.1 mit den Fallzahlen 602/129 und 592/127.
     - Normalisierte Kontraste 10.05 und 8.74.
   - Nicht geprüft habe ich die b-Werte −0.82 und 2.11 in Tabelle 4 (siehe unten).
   - Befund 3 betrifft die Fallzahl, Befund 2 eine nicht gedeckte Aussage.
   - Neue Zitate: Der Bericht und der Kartenabschnitt „PI confirmations" bestätigen sie. Die Primärquellen konnte ich nicht öffnen.
2. **Haupttext endet höchstens auf Seite 15, Build sauber.** Die Auswertung von `review/T059_latex.txt` ergab keinen Treffer auf undefined, Warning, Overfull, Underfull oder Citation. Die Seitenzahl 15 aus `main.aux` habe ich nicht selbst gelesen. Die Behauptung des Workers ist damit nicht eigenständig belegt. Befund 1 betrifft die Darstellung, nicht den Build.
3. **Punkte 1 bis 11 mit Zeile im Bericht.** Im Bericht belegt. Inhaltlich im Diff wiedergefunden, soweit meine Rolle reicht:
   - Pt 3, κ-Gleichung (5.2 bzw. 4.2) und H2/H3-Einordnung.
   - Pt 4, Offenlegungsprüfung in Abstract, Einleitung, Konklusion und H3.
   - Pt 6, κ*=0.28 stets zusammen mit „interval includes zero from 0.09" (Abschnitt 1, 6.2, Tabelle 4, Konklusion; im Abstract steht κ* nicht).
   - Pt 7, Zahlen zur Identifikationsverteidigung und Klausel zu koinzidenten Restriktionen ohne Zitat.
   - Pt 8, Liu mit Seiten 218/228 und 110 Entwicklern.
   - Pt 2, Notch-Prognose in 3.1 und Kontrast in 6.1.
   - Pt 5, Aussage „MI exceeds parent equity per unit of growth; post-minus-placebo imprecise". Passt zu Tabelle B11.
   - Befund 2 betrifft Punkt 8 (Hongkong-Aussage).
   - Nicht meine Rolle: Qualität der Kürzungen (Pt 11), Stil.

## Nicht geprüft

- Die b-Werte der Tabelle 4 (Parent-Equity-Freeze −0.82, Debt-Freeze 2.11) habe ich nicht gegen `t058_symmetric.csv` abgeglichen, weil ich nur die Zeilen mit D gelesen habe. Außerdem steht b nicht in Tabelle B11.
- Die übrigen Zeilen von `t058_attrition.csv`, `t058_notch.csv` und `t058_above.csv`: Ich habe die Tabellenwerte (zum Beispiel 3.02/4.32 in B10) nur mit den Aussagen im Bericht und im Text abgeglichen, nicht mit den CSV-Zeilen. Auch `t058_window.csv` und `t058_grid_summary.csv` habe ich nicht selbst geöffnet.
- Das gebaute PDF und die Seitenzahl 15 habe ich nicht gelesen, ebenso wenig die Rückmeldung, wie die `\'s`-Stellen tatsächlich gesetzt werden.
- Quellen Huang, Su, Chu und Liu habe ich nicht eingesehen. Die Seitenangaben beruhen auf der PI-Bestätigung aus der Karte.
- Ob Code und Daten korrekt sind, ist nicht meine Rolle.
