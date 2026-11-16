## Rolle: language (claude, sonnet) – VERDICT: REWORK


Es gibt keine sinnentstellenden Sprachfehler, nur Kleinigkeiten (Rolle `language`). Alle zehn Ersetzungen aus Rework [number withheld] sind wörtlich umgesetzt. Neu aufgefallen sind Kleinigkeiten, vor allem die Regel „percentage points / points“ und ein paar Formulierungen.

## Befunde

[number withheld]. **Regel „percentage points beim ersten Auftreten je Absatz, danach points“ verletzt** (Rework [number withheld], Punkt [number withheld]). `proposal/sections/01_introduction.tex:19` hat „[number withheld] percentage points“ und danach „[number withheld] percentage points higher“; beide stehen im selben Absatz. Korrektur: „[number withheld] points higher“. In `[number withheld]_preliminary_analysis.tex:[number withheld]` und in `07_conclusion.tex:5` ist die Regel eingehalten.

[number withheld]. **„Mr.~Hui“ wird nicht eingeführt.** `06_preliminary_analysis.tex:91` (Tabellennote) und `:[number withheld]` nennen ihn, ohne seine Rolle zu nennen. Beim ersten Auftreten sollte die Rolle stehen, etwa „Shimao's chairman, Mr.~Hui“. Das ist ein inhaltlicher Hinweis: Die Rolle müssen Sie an der Quelle prüfen, ich habe sie nicht geprüft.

[number withheld]. **Überlanger Satz mit hängendem Partizip.** `06_preliminary_analysis.tex:70`: „…([number withheld] versus [number withheld] complete firm-years), showing substantial paid-in backing…“. „showing“ bezieht sich grammatisch nicht auf ein Subjekt. Vorschlag: Satz am Semikolon teilen und schreiben „This shows substantial paid-in backing among observed cases but leaves consolidation and the identity of the payer unresolved“.

[number withheld]. **Unklare Formulierung.** `06_preliminary_analysis.tex:20`: „The mean measurement error explains [number withheld] percent of the attenuation when all [number withheld] pairs are used, but [number withheld] percent when only the [number withheld] near-threshold pairs are used.“ Vorschlag: „Mean measurement error accounts for [number withheld] percent of the attenuation across all [number withheld] pairs but for [number withheld] percent across the [number withheld] near-threshold pairs.“

[number withheld]. **Bindestrich-Typografie.** `06_preliminary_analysis.tex:64`: „horizon--anchor cells“ mit Gedankenstrich. Ein Bindestrich oder „horizon-by-anchor“ wäre richtig, denn `--` steht für Bereiche. In `references.bib:42` steht „Large–Sample“ (Unicode-Halbgeviertstrich) im Titel von dichev2[number withheld]largesample. Es muss ein Bindestrich sein, sonst druckt die Literaturliste den falschen Strich.

[number withheld]. **Mehrdeutige Wörter.**
[firm-specific excerpt withheld in public process copy]
   - `appendix/results.tex:151`: „comparison joint ventures name affiliates of its controller“. „name“ ist unklar. Vorschlag: „list affiliates of its controller as partners“.

[number withheld]. **Uneinheitliche Begriffe.** `sections/t045_crosser_shares.tex:5` spricht in der Überschrift von „Attributed cash“, die Note (`:[number withheld]`) von „paid capital“ und `results.tex:146` von „payment“. Das Papier verwendet sonst „capital from minority shareholders“. Empfehlung: ein Begriff, „attributed capital“.

[number withheld]. **Nicht eingeführter Begriff.** „Wind“ in `appendix/ai_use.tex` (Zeile [number withheld] des Diffs) wird als Datenanbieter genannt, ohne eine Erklärung. Das ist eine Kleinigkeit, wenn der Begriff in Abschnitt [number withheld] schon erklärt ist, was ich nicht geprüft habe.

Kein Befund, sondern Bestätigung:
- Der Abstract hat [number withheld] Wörter und entspricht dem verbindlichen Wortlaut.
- „nonpositive“, „compliant share“ und „firm-half-years“ sind einheitlich.
- Die Kürzel CNKI, CSSCI, PI, Co-PI, DiD, RD, CI, PRISMA und AI sind beim ersten Auftreten ausgeschrieben.
- Die Anführungszeichen in `02_literature.tex:16` sind geschlossen.
- „Mr.~“ und die geschützten Leerzeichen vor `\ref` und `\cite` sind korrekt.
- Die AI-Appendix-Tabelle ist nach Kartennummer geordnet.
- Der amerikanische Sprachstand ist einheitlich.

## Abnahmekriterien

- **Kriterium [number withheld] (Review-Punkte A1–F, Zeile je Punkt im Bericht):** nicht meine Rolle.
- **Kriterium [number withheld] (jede Zahl in einer CSV):** nicht meine Rolle.
- **Kriterium [number withheld] (Abschnitt [number withheld] nur mit verifizierten Aussagen):** nicht meine Rolle. Die Formulierung der Verifikationsregel ist an vier Stellen identisch (`[number withheld]:[number withheld]`, `results.tex:143`, `ai_use.tex`, Karte). Das ist sprachlich belegt erfüllt.
- **Kriterium [number withheld] (XeLaTeX-Build ohne Fehler, Seitenzahl, `pdffonts`):** nicht meine Rolle. `review/T045_latex.txt` meldet „übersetzt fehlerfrei“.
- **Kriterium [number withheld] (keine kausale Beschreibung, Trendergebnis in Abstract, Einleitung, [number withheld] und Schluss):** sprachlich belegt erfüllt. Der einheitliche Satz „did not exceed its pre-policy pace and, under the firm trend, was slower…“ steht in `[number withheld]:[number withheld]`, `[number withheld]:[number withheld]` und `[number withheld]:[number withheld]`; der Abstract nennt „although that growth did not exceed its pre-policy pace“. Es steht kein Kausalwort („effect of the policy“) ohne Einschränkung.
- **Rework [number withheld], Punkte [number withheld]–[number withheld]:** belegt umgesetzt. Die Fundstellen sind `main.tex:52`, `[number withheld]:[number withheld]`, `[number withheld]:[number withheld]`, `[number withheld]:[number withheld]/[number withheld]/[number withheld]/[number withheld]/[number withheld]/[number withheld]`, `[number withheld]:[number withheld]` und `results.tex:143/146`.

## Nicht geprüft

- Der Quelltext der nicht eingefrorenen Dateien `03_framework.tex`, `04_empirical_model.tex` und `05_context_data.tex`. Dort habe ich nur gezielt nach „tier“ und κ gesucht, beides ist definiert.
- Der Text der Tabellen unter `proposal/tables/*.tex` und die Beschriftung der Abbildungen (PDF).
- Der ausgegebene PDF-Satz, also Überfüllungen, Seitenumbrüche und die Darstellung der chinesischen Zeichen. Nur das `latexmk`-Protokoll liegt vor, und das enthält eine einzige Zeile.
- Der Inhalt von `review/T0[number withheld]_proposal.diff` nach Zeile [number withheld]. `results.tex`, `ai_use.tex` und `variables.tex` habe ich direkt gelesen. Der Rest des Diffs betrifft vor allem die nicht eingefrorenen Abschnitte [number withheld] bis [number withheld].
- Die Richtigkeit der Eigennamen, Beträge und Quellenzitate. Das ist Aufgabe der Rolle `consistency`.
