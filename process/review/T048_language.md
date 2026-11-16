## Rolle: language (claude, sonnet) – VERDICT: REWORK


Es sind nur Wortlaut- und Typografiefunde; ein sinnentstellender Fehler ist nicht dabei. Ich habe ausschließlich `review/T0[number withheld]_proposal.diff` gelesen, dazu die Karte, `t047_magnitude.tex`, [number withheld]:[number withheld]–[number withheld] und per Grep die Stellen mit „Hui“, „Wind“, „makecell“ und „attributed capital“. Den Bericht des Workers, das Build-Log und die PNGs habe ich nicht gelesen; Bash war nicht erlaubt.

## Befunde

[number withheld]. **Shimao-Fußnote, Satz mit „its listing“.** Die Floatnote in `sections/06_preliminary_analysis.tex` (Diff-Zeile [number withheld]) sagt: „its listing-triggered component terminates and lapses if Shimao Services achieves its listing; the undertaking is not evidence …“.
   - „terminates and lapses“ ist doppelt gemoppelt.
   - „its listing“ ist mehrdeutig, denn gemeint ist der Börsengang von Shimao Services, nicht der von Shimao.
   - Vorschlag: „its listing-triggered component lapses if Shimao Services is listed; the undertaking is therefore not evidence of an outstanding year-end group position.“
   - Der Satz hat nach dem Semikolon einen zweiten Hauptsatz. Besser ist ein Punkt oder „and therefore“.

[number withheld]. **„Mr.~Hui“ wird nirgends eingeführt.** Der Fund betrifft denselben Satz wie Befund [number withheld] und Zeile [number withheld] derselben Datei.
   - Die Fußnote (Diff-Zeile [number withheld]) nennt „was transferred to Mr.~Hui“, aber nicht, wer das ist.
   - Zeile [number withheld] wiederholt „subsequently transferred to Mr.~Hui“ ohne Einführung.
   - Die Karte verlangte entweder „Shimao's chairman, Mr.~Hui“ oder „Mr.~Hui, to whom the undertaking was transferred“. Beides steht so nicht im Text.
   - Vorschlag: Beim ersten Auftreten (Floatnote, die steht vor Zeile [number withheld]) „transferred to a third party, Mr.~Hui,“ schreiben, oder die Rolle einsetzen, falls sie verifiziert ist. Zeile [number withheld] kann dann bei „Mr.~Hui“ bleiben.

[number withheld]. **Uneinheitliche Begriffe im Anhang (t0[number withheld]_magnitude.tex).** Dort stehen weiter „NCI capital“, „Attributed capital“, „Observed NCI capital“ und „cash capital received from non-controlling investors“. Die Karte verlangte einen Begriff („capital from minority shareholders“) und schloss `t044_magnitude.tex` nur bedingt ein. `tables/t047_magnitude.tex:42–43` und `tables/t047_coding.tex:42` habe ich nicht im Detail geprüft. Für die Karte reicht ein Hinweis. Außerdem fehlt eine Definition von „NCI“; im Haupttext steht durchgehend „MI“. Vorschlag: „NCI“ beim ersten Auftreten definieren oder durch „MI“ ersetzen. Das gilt nur, wenn die Tabelle im PDF eingebunden ist (nicht geprüft).

[number withheld]. **Redundanz in `figures/toc_nef.tex`.** „Not observed“ steht dreimal: im Aim-Kasten, am gestrichelten Pfeil und in der Floatnote („The dashed final link is not observed“). Eine Stelle im Kasten und eine am Pfeil genügen. Der Pfeil-Tag sollte etwa „Not observed (assumed)“ lauten oder entfallen.

[number withheld]. **Gleichklang in den Bildunterschriften.** „Findings [number withheld]-[number withheld] refer to Section~\ref{sec:preliminary}“ passt zur Vorgabe. „Finding [number withheld]: new equity carries risk“ ist aber Aussage („carries risk“) neben Annahme („new equity is genuine“) in einem Kasten. Die Satzform ist uneinheitlich: ein Kasten hat Fragmente mit Semikolon, ein anderer mit „Adjustment:/Assessment:“. Vorschlag: Alle Einträge als Fragmente ohne Satzzeichen am Ende schreiben.

[number withheld]. **Kleinere Stil- und Typografiefunde.**
   - `results.tex` (Diff-Zeile [number withheld]): „Other category shares have no matched amount of capital from minority shareholders.“ klingt schwer. Besser: „No capital from minority shareholders is matched to the other categories.“
   - `results.tex` (Diff-Zeile [number withheld]): „no documented D/G/H/E payment from minority shareholders is matched to a fiscal-year cash-flow line“. Hier sind „payment“ und „capital“ gemischt. Besser: „no documented D/G/H/E transaction is matched to capital from minority shareholders in a fiscal-year cash-flow line“.
   - Floatnote Diff-Zeile [number withheld]: „gross, before dividends“ steht direkt nach „Complete ratios of gross capital …“. „gross“ ist doppelt. Besser: „…; all amounts are gross, before dividends.“
   - `01_introduction.tex`: In den ersten zwei Sätzen steht „percentage points“ einmal, danach nur „points“. Das entspricht der Regel „percentage points je Absatz einmal“ und ist in Ordnung.
   - `references.bib`: Der Bindestrich in „Large-Sample“ ist behoben. In `pages=` stehen weiter Unicode-En-Dashes (`[number withheld]–[number withheld]`). Das ist bei BibTeX/pdfLaTeX riskant, zählt aber nicht zu den Sprachpunkten. Nur als Hinweis.

## Abnahmekriterien

[number withheld]. Figure s/w, lesbar, Aussagen im Text verankert: nicht meine Rolle. Sprachlich sind Beschriftungen und Kastentexte verständlich, aber siehe Befund [number withheld] und [number withheld].
[number withheld]. Seitenzahl und Overfull-Boxen: nicht meine Rolle, nicht geprüft.
[number withheld]. Alle Sprachpunkte mit Zeile im Bericht:
   - Prozentpunkt-Regel: Haupttext erfüllt (Intro, [number withheld], [number withheld]:[number withheld]); der Bericht wurde nicht gelesen.
   - „horizon-by-anchor“: belegt ([number withheld], Diff-Zeile [number withheld]).
   - Dangling „showing“ gesplittet: belegt ([number withheld], Diff-Zeile [number withheld]).
   - [number withheld]:[number withheld] umformuliert: belegt (Diff-Zeile [number withheld]).
   - [number withheld]:[number withheld] „If the call is not exercised, …“: belegt (Diff-Zeile [number withheld]).
   - „list affiliates … as partners“: belegt (Diff-Zeile [number withheld]).
   - Wind erklärt: belegt ([number withheld], Diff-Zeile [number withheld]).
   - „Mr. Hui“ eingeführt: nicht erfüllt, siehe Befund [number withheld].
   - Ein Kapitalbegriff: im Haupttext und in `results.tex` überwiegend durchgesetzt, nicht in `t047_magnitude.tex`, siehe Befund [number withheld].
   - Die Zeilen im Bericht selbst nicht geprüft.

## Nicht geprüft

- Bericht `tasks/T048_report.md`, Build-Log und PNGs: nicht gelesen.
- Gesamte Rechtschreibung der unveränderten Abschnitte: nur Diff-Zeilen und Stichproben.
- Seitenzahl, Overfull-Boxen, Rendering der Figur, CJK-Schriften im PDF.
- Inhaltliche Richtigkeit der Aussagen in der Figur: Aufgabe der Consistency-Rolle.
- Ob `t047_magnitude.tex` im PDF eingebunden ist.
