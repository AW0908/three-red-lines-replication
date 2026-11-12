## Rolle: language (claude, sonnet) – VERDICT: REWORK


## Befunde

1. **Fehlender Bezug von „Such equity“ (`proposal/sections/01_introduction.tex`, Zeile 6).** Die Karte verlangt, die Stakes-Sätze nach dem Satz über die zwei Wege einzufügen. Der Worker hat sie aber zwischen „…minority partners' equity in project companies, which lowers RL1 directly“ und „Such equity may share project risk…“ gesetzt. „Such equity“ bezieht sich damit über zwei Sätze zu Wirtschaftsanteil und Exposure hinweg auf die Minderheitsbeteiligungen zurück, und der Bezug ist nicht mehr eindeutig. Auch der Schlusssatz „so compliance may be partly ``on paper''“ hängt dadurch an der falschen Stelle.
   - Korrekturvorschlag: Die Sätze „Such equity may share…“ und „so compliance may be partly on paper“ direkt an den Satz über die zwei Wege anschließen. Danach „The stakes are large: …“ und „If reported compliance overstates deleveraging, supervisors misjudge exactly this exposure.“ als Abschluss des Absatzes. Das ist auch inhaltlich logischer, weil „on paper“ den Übergang zur Frage nach der Überbewertung der Deleveraging-Wirkung bildet.

2. **Grammatik und Zeichensetzung im Satz zur Cap (Zeile 6).** „…a tier that caps the annual growth of its interest-bearing debt at 15 percent when all three lines are met, minus 5 percentage points for each line breached.“ „minus 5 percentage points“ hängt grammatisch unklar an „when all three lines are met“.
   - Korrekturvorschlag: „…caps the annual growth of its interest-bearing debt at 15 percent minus 5 percentage points for each line breached.“ Die Aussage „at 15 percent when all three lines are met“ steht dann implizit im Nullfall. Alternativ: „…at 15 percent if all three lines are met and 5 percentage points lower for each line breached.“

3. **Schwer lesbarer Satz (Zeile 6).** „It can get below a threshold in two ways: it can repay debt, or it can raise equity, and that equity includes minority partners' equity…, which lowers RL1 directly.“ Der Satz hat Doppelpunkt, zwei Kommata mit „or“, ein „and that“ und einen Relativsatz.
   - Korrekturvorschlag: In zwei Sätze teilen: „It can get below a threshold in two ways: by repaying debt or by raising equity. The equity includes minority partners' equity in project companies, which lowers RL1 directly.“

4. **Leichter Hinweis, kein Fehler:** Die Kopfzeile der Tabelle verwendet „95\% CI / range“, die Fußnote „95 percent CI“. Das ist in Tabellenköpfen üblich, aber nicht einheitlich mit dem Fließtext. Die Abkürzung „CI“ ist in der Tabelle nicht definiert. Sie wird im Text erst später eingeführt, nämlich in Absatz 4 der Introduction.

## Abnahmekriterien

1. Main text endet auf Seite 15 und Build sauber: Build laut `review/T052_latex.txt` fehlerfrei. Die Seitenzahl ist nicht meine Rolle und nicht prüfbar.
2. Beide Zitate lösen auf, kein anderer Inhalt geändert:
   - Zitierschlüssel `rogoff2020peak` und `liu2018china` stehen im Text, und der Build meldet keine Fehler. Ob die Einträge in der Bibliografie existieren, ist nicht meine Rolle.
   - Bei „Inhalt unverändert“ zeigt der Diff, dass neben den vorgesehenen Änderungen auch Formulierungen in Absatz 1 umgeschrieben wurden. Das ist von Schritt 1 gedeckt („Shorten… elsewhere“). Der letzte Satz zur Bedeutung für Supervisors ist entfallen und durch den neuen Stakes-Satz ersetzt. Das ist inhaltlich Sache der Consistency-Rolle.
3. Schritt 2, Tabellennotiz: „95 percent CI“ und „Firm-bootstrap CIs, 999 draws“ sind umgesetzt. Die Erklärung der Fixed-Point-Zeile ist vorhanden. „Row 6“ trifft zu: Zeile 1 ist Δb, Zeile 6 ist „b_net: fixed point“, Zeile 7 ist die Measurement-Error-Zeile. Das passt zu „Rows 3 and 7“.
4. Schritt 2, Verweis in 6.1: „Table~\ref{tab:robustness}“ mit geschütztem Leerzeichen ist korrekt. Der Satz ist sprachlich in Ordnung („simulated measurement error … shrinks the estimate“), der Verweis damit bereinigt.

## Nicht geprüft

- Seitenumfang (Seite 15), PDF-Layout und Bibliografieeinträge, da kein Zugriff auf das PDF und ich keine Befehle ausführe.
- Inhaltliche Richtigkeit von „29 percent“ und der Aussage zu Liu und Xiong (2018). Die Quellen-PDFs habe ich nicht geöffnet, da das nicht meine Rolle ist. Die PI-Freigabe steht in der Karte.
