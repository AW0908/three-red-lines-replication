## Rolle: language (claude, sonnet) – VERDICT: REWORK


## Befunde

[number withheld]. **Fehlender Bezug von „Such equity“ (`proposal/sections/01_introduction.tex`, Zeile [number withheld]).** Die Karte verlangt, die Stakes-Sätze nach dem Satz über die zwei Wege einzufügen. Der Worker hat sie aber zwischen „…minority partners' equity in project companies, which lowers RL1 directly“ und „Such equity may share project risk…“ gesetzt. „Such equity“ bezieht sich damit über zwei Sätze zu Wirtschaftsanteil und Exposure hinweg auf die Minderheitsbeteiligungen zurück, und der Bezug ist nicht mehr eindeutig. Auch der Schlusssatz „so compliance may be partly ``on paper''“ hängt dadurch an der falschen Stelle.
   - Korrekturvorschlag: Die Sätze „Such equity may share…“ und „so compliance may be partly on paper“ direkt an den Satz über die zwei Wege anschließen. Danach „The stakes are large: …“ und „If reported compliance overstates deleveraging, supervisors misjudge exactly this exposure.“ als Abschluss des Absatzes. Das ist auch inhaltlich logischer, weil „on paper“ den Übergang zur Frage nach der Überbewertung der Deleveraging-Wirkung bildet.

[number withheld]. **Grammatik und Zeichensetzung im Satz zur Cap (Zeile [number withheld]).** „…a tier that caps the annual growth of its interest-bearing debt at [number withheld] percent when all three lines are met, minus [number withheld] percentage points for each line breached.“ „minus [number withheld] percentage points“ hängt grammatisch unklar an „when all three lines are met“.
   - Korrekturvorschlag: „…caps the annual growth of its interest-bearing debt at [number withheld] percent minus [number withheld] percentage points for each line breached.“ Die Aussage „at [number withheld] percent when all three lines are met“ steht dann implizit im Nullfall. Alternativ: „…at [number withheld] percent if all three lines are met and [number withheld] percentage points lower for each line breached.“

[number withheld]. **Schwer lesbarer Satz (Zeile [number withheld]).** „It can get below a threshold in two ways: it can repay debt, or it can raise equity, and that equity includes minority partners' equity…, which lowers RL1 directly.“ Der Satz hat Doppelpunkt, zwei Kommata mit „or“, ein „and that“ und einen Relativsatz.
   - Korrekturvorschlag: In zwei Sätze teilen: „It can get below a threshold in two ways: by repaying debt or by raising equity. The equity includes minority partners' equity in project companies, which lowers RL1 directly.“

[number withheld]. **Leichter Hinweis, kein Fehler:** Die Kopfzeile der Tabelle verwendet „[number withheld]\% CI / range“, die Fußnote „[number withheld] percent CI“. Das ist in Tabellenköpfen üblich, aber nicht einheitlich mit dem Fließtext. Die Abkürzung „CI“ ist in der Tabelle nicht definiert. Sie wird im Text erst später eingeführt, nämlich in Absatz [number withheld] der Introduction.

## Abnahmekriterien

[number withheld]. Main text endet auf Seite [number withheld] und Build sauber: Build laut `review/T052_latex.txt` fehlerfrei. Die Seitenzahl ist nicht meine Rolle und nicht prüfbar.
[number withheld]. Beide Zitate lösen auf, kein anderer Inhalt geändert:
   - Zitierschlüssel `rogoff2[number withheld]peak` und `liu2[number withheld]china` stehen im Text, und der Build meldet keine Fehler. Ob die Einträge in der Bibliografie existieren, ist nicht meine Rolle.
   - Bei „Inhalt unverändert“ zeigt der Diff, dass neben den vorgesehenen Änderungen auch Formulierungen in Absatz [number withheld] umgeschrieben wurden. Das ist von Schritt [number withheld] gedeckt („Shorten… elsewhere“). Der letzte Satz zur Bedeutung für Supervisors ist entfallen und durch den neuen Stakes-Satz ersetzt. Das ist inhaltlich Sache der Consistency-Rolle.
[number withheld]. Schritt [number withheld], Tabellennotiz: „[number withheld] percent CI“ und „Firm-bootstrap CIs, [number withheld] draws“ sind umgesetzt. Die Erklärung der Fixed-Point-Zeile ist vorhanden. „Row [number withheld]“ trifft zu: Zeile [number withheld] ist Δb, Zeile [number withheld] ist „b_net: fixed point“, Zeile [number withheld] ist die Measurement-Error-Zeile. Das passt zu „Rows [number withheld] and [number withheld]“.
[number withheld]. Schritt [number withheld], Verweis in [number withheld]: „Table~\ref{tab:robustness}“ mit geschütztem Leerzeichen ist korrekt. Der Satz ist sprachlich in Ordnung („simulated measurement error … shrinks the estimate“), der Verweis damit bereinigt.

## Nicht geprüft

- Seitenumfang (Seite [number withheld]), PDF-Layout und Bibliografieeinträge, da kein Zugriff auf das PDF und ich keine Befehle ausführe.
- Inhaltliche Richtigkeit von „[number withheld] percent“ und der Aussage zu Liu und Xiong ([number withheld]). Die Quellen-PDFs habe ich nicht geöffnet, da das nicht meine Rolle ist. Die PI-Freigabe steht in der Karte.
