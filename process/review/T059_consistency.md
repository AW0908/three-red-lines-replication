## Rolle: consistency (claude, sonnet) – VERDICT: REWORK


## Befunde

[number withheld]. **Kaputte Apostrophe in Tabellennotizen (Darstellung).** In vier der neuen Anhangstabellen steht `\'s` statt `'s`: `proposal/tables/t058_above.tex:29` (region\'s), `t058_attrition.tex:19` (firm\'s), `t058_checks.tex:19` (Hong Kong\'s) und `t058_symmetric.tex:34`. In LaTeX setzt `\'` einen Akut auf das folgende Zeichen, es entsteht also „regionś" statt „region's". Die Fundstellen sind per Grep belegt. Ich habe das PDF nicht gesehen. Die Zahlen sind davon nicht betroffen, die Notizen sind aber fehlerhaft gesetzt. Der Bericht sagt, die Darstellung sei visuell geprüft worden.

[number withheld]. **Aussage „Hongkong, wo die Konzentration am stärksten ist" geht über die Outputs hinaus.** Die Aussage steht in `02_literature.tex`. Belegt sind Hongkong [number withheld] und A-Aktien [number withheld]. Die Differenz ist aber [number withheld] [[number withheld], [number withheld]] (`t058_standard.csv` Zeile [number withheld], Tabelle B1[number withheld]), ihr Intervall schließt null ein. „Strongest" ist nur eine Aussage über Punktschätzer. Ohne imputierte Nullwerte ist die Differenz [number withheld] [[number withheld], [number withheld]], also präzise, aber nur in dieser Variante. Der Text in [number withheld] sagt dagegen sauber „exceeds the A-share point estimate". Die Aussage in Abschnitt [number withheld] ist damit strenger als die in [number withheld]. Vorschlag: „where the point estimate is largest" oder die Differenz mit Intervall nennen.

[number withheld]. **Fallzahl in der Notiz zu Tabelle B1[number withheld] passt nicht zur Tabellenzeile.** Die Notiz nennt für Hongkong in der Vorperiode „[number withheld]/[number withheld]" Beobachtungen mit imputierter Null. Die Zeile „Baseline, Hong Kong" in derselben Tabelle und `t058_standard.csv` Zeile [number withheld] führen für die Vorperiode [number withheld] ([number withheld] Firmen). Die Differenz von einer Beobachtung kann ein gültiger Unterschied zwischen „alle Zeilen" und „Zeilen mit gültigem RL1" sein. Die Notiz erklärt ihn nicht. Den Zähler [number withheld] habe ich in der CSV nicht wiedergefunden.

[number withheld]. **Klammer nicht geschlossen** in `06_preliminary_analysis.tex`, Satz zum Notch-Kontrast: „(…; contemporaneous classification also permits composition changes (Appendix Table~…)." Die erste Klammer wird nie geschlossen. Das ist ein Sprachfehler und gehört eher zur Sprachrolle.

[number withheld]. **Uneinheitliche Reihenfolge der Fallzahlen.** Tabelle [number withheld] und die Notiz dazu nennen „pre/post". Die Anhangstabellen B9 bis B1[number withheld] nennen „post/pre" bei Änderungen und „erste/Benchmark" bei Kontrasten. Jede Tabelle erklärt ihre Konvention in der Notiz, deshalb ist das kein Fehler. Es erschwert aber den Abgleich, zum Beispiel balanciertes Δb: „[number withheld]/[number withheld]" in Tabelle [number withheld] gegen „[number withheld]/[number withheld]" in B1[number withheld].

[number withheld]. **Quellenangabe Huang.** Die Karte nennt S. [number withheld], der Quellenkommentar in `05_context_data.tex` und der Bericht sagen S. [number withheld] der lokalen PDF. Der Text zitiert keine Seite, es entsteht daher kein Zahlenfehler. Anton sollte den Unterschied bestätigen.

## Abnahmekriterien

[number withheld]. **Jede Zahl aus einer CSV, jede zitierte Tabelle enthält die zitierte Zahl.**
   - Belegt erfüllt für alle Zahlen, die ich gegen die CSV geprüft habe:
     - Pilot-Kontrast [number withheld] [[number withheld], [number withheld]], [number withheld] Beobachtungen aus [number withheld] Firmen.
     - Notch-Kontrast [number withheld] [[number withheld], [number withheld]].
     - Masse oberhalb [number withheld] und [number withheld] (Tabelle B1[number withheld]).
     - Gitter [number withheld]/[number withheld] positiv, [number withheld] Intervalle über null, Median [number withheld]. [number withheld] × [number withheld] = [number withheld] stimmt.
     - Balanciertes Δb [number withheld], Austrittsanteile [number withheld] und [number withheld], Fisher p = [number withheld].
     - [number withheld]H1 hinzugefügt: [number withheld].
     - Hongkong [number withheld] und [number withheld], A-Aktien [number withheld].
     - Parent-Equity-D [number withheld] und Schulden-D [number withheld] mit den Fallzahlen [number withheld]/[number withheld] und [number withheld]/[number withheld].
     - Normalisierte Kontraste [number withheld] und [number withheld].
   - Nicht geprüft habe ich die b-Werte [number withheld] und [number withheld] in Tabelle [number withheld] (siehe unten).
   - Befund [number withheld] betrifft die Fallzahl, Befund [number withheld] eine nicht gedeckte Aussage.
   - Neue Zitate: Der Bericht und der Kartenabschnitt „PI confirmations" bestätigen sie. Die Primärquellen konnte ich nicht öffnen.
[number withheld]. **Haupttext endet höchstens auf Seite [number withheld], Build sauber.** Die Auswertung von `review/T059_latex.txt` ergab keinen Treffer auf undefined, Warning, Overfull, Underfull oder Citation. Die Seitenzahl [number withheld] aus `main.aux` habe ich nicht selbst gelesen. Die Behauptung des Workers ist damit nicht eigenständig belegt. Befund [number withheld] betrifft die Darstellung, nicht den Build.
[number withheld]. **Punkte [number withheld] bis [number withheld] mit Zeile im Bericht.** Im Bericht belegt. Inhaltlich im Diff wiedergefunden, soweit meine Rolle reicht:
   - Pt [number withheld], κ-Gleichung ([number withheld] bzw. [number withheld]) und H2/H3-Einordnung.
   - Pt [number withheld], Offenlegungsprüfung in Abstract, Einleitung, Konklusion und H3.
   - Pt [number withheld], κ*=[number withheld] stets zusammen mit „interval includes zero from [number withheld]" (Abschnitt [number withheld], [number withheld], Tabelle [number withheld], Konklusion; im Abstract steht κ* nicht).
   - Pt [number withheld], Zahlen zur Identifikationsverteidigung und Klausel zu koinzidenten Restriktionen ohne Zitat.
   - Pt [number withheld], Liu mit Seiten [number withheld]/[number withheld] und [number withheld] Entwicklern.
   - Pt [number withheld], Notch-Prognose in [number withheld] und Kontrast in [number withheld].
   - Pt [number withheld], Aussage „MI exceeds parent equity per unit of growth; post-minus-placebo imprecise". Passt zu Tabelle B1[number withheld].
   - Befund [number withheld] betrifft Punkt [number withheld] (Hongkong-Aussage).
   - Nicht meine Rolle: Qualität der Kürzungen (Pt [number withheld]), Stil.

## Nicht geprüft

- Die b-Werte der Tabelle [number withheld] (Parent-Equity-Freeze [number withheld], Debt-Freeze [number withheld]) habe ich nicht gegen `t058_symmetric.csv` abgeglichen, weil ich nur die Zeilen mit D gelesen habe. Außerdem steht b nicht in Tabelle B1[number withheld].
- Die übrigen Zeilen von `t058_attrition.csv`, `t058_notch.csv` und `t058_above.csv`: Ich habe die Tabellenwerte (zum Beispiel [number withheld]/[number withheld] in B1[number withheld]) nur mit den Aussagen im Bericht und im Text abgeglichen, nicht mit den CSV-Zeilen. Auch `t058_window.csv` und `t058_grid_summary.csv` habe ich nicht selbst geöffnet.
- Das gebaute PDF und die Seitenzahl [number withheld] habe ich nicht gelesen, ebenso wenig die Rückmeldung, wie die `\'s`-Stellen tatsächlich gesetzt werden.
- Quellen Huang, Su, Chu und Liu habe ich nicht eingesehen. Die Seitenangaben beruhen auf der PI-Bestätigung aus der Karte.
- Ob Code und Daten korrekt sind, ist nicht meine Rolle.
