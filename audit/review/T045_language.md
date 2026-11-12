## Rolle: language (claude, sonnet) – VERDICT: REWORK


Es gibt keine sinnentstellenden Sprachfehler, nur Kleinigkeiten (Rolle `language`). Alle zehn Ersetzungen aus Rework 4 sind wörtlich umgesetzt. Neu aufgefallen sind Kleinigkeiten, vor allem die Regel „percentage points / points“ und ein paar Formulierungen.

## Befunde

1. **Regel „percentage points beim ersten Auftreten je Absatz, danach points“ verletzt** (Rework 4, Punkt 7). `proposal/sections/01_introduction.tex:19` hat „11.5 percentage points“ und danach „9.8 percentage points higher“; beide stehen im selben Absatz. Korrektur: „9.8 points higher“. In `06_preliminary_analysis.tex:42,61,67` und in `07_conclusion.tex:5` ist die Regel eingehalten.

2. **„Mr.~Hui“ wird nicht eingeführt.** `06_preliminary_analysis.tex:91` (Tabellennote) und `:115` nennen ihn, ohne seine Rolle zu nennen. Beim ersten Auftreten sollte die Rolle stehen, etwa „Shimao's chairman, Mr.~Hui“. Das ist ein inhaltlicher Hinweis: Die Rolle müssen Sie an der Quelle prüfen, ich habe sie nicht geprüft.

3. **Überlanger Satz mit hängendem Partizip.** `06_preliminary_analysis.tex:70`: „…(33 versus 48 complete firm-years), showing substantial paid-in backing…“. „showing“ bezieht sich grammatisch nicht auf ein Subjekt. Vorschlag: Satz am Semikolon teilen und schreiben „This shows substantial paid-in backing among observed cases but leaves consolidation and the identity of the payer unresolved“.

4. **Unklare Formulierung.** `06_preliminary_analysis.tex:20`: „The mean measurement error explains 86 percent of the attenuation when all 64 pairs are used, but 40 percent when only the 52 near-threshold pairs are used.“ Vorschlag: „Mean measurement error accounts for 86 percent of the attenuation across all 64 pairs but for 40 percent across the 52 near-threshold pairs.“

5. **Bindestrich-Typografie.** `06_preliminary_analysis.tex:64`: „horizon--anchor cells“ mit Gedankenstrich. Ein Bindestrich oder „horizon-by-anchor“ wäre richtig, denn `--` steht für Bereiche. In `references.bib:42` steht „Large–Sample“ (Unicode-Halbgeviertstrich) im Titel von dichev2002largesample. Es muss ein Bindestrich sein, sonst druckt die Literaturliste den falschen Strich.

6. **Mehrdeutige Wörter.**
[firm-specific excerpt withheld in public audit]
   - `appendix/results.tex:151`: „comparison joint ventures name affiliates of its controller“. „name“ ist unklar. Vorschlag: „list affiliates of its controller as partners“.

7. **Uneinheitliche Begriffe.** `sections/t045_crosser_shares.tex:5` spricht in der Überschrift von „Attributed cash“, die Note (`:40`) von „paid capital“ und `results.tex:146` von „payment“. Das Papier verwendet sonst „capital from minority shareholders“. Empfehlung: ein Begriff, „attributed capital“.

8. **Nicht eingeführter Begriff.** „Wind“ in `appendix/ai_use.tex` (Zeile 10 des Diffs) wird als Datenanbieter genannt, ohne eine Erklärung. Das ist eine Kleinigkeit, wenn der Begriff in Abschnitt 5 schon erklärt ist, was ich nicht geprüft habe.

Kein Befund, sondern Bestätigung:
- Der Abstract hat 88 Wörter und entspricht dem verbindlichen Wortlaut.
- „nonpositive“, „compliant share“ und „firm-half-years“ sind einheitlich.
- Die Kürzel CNKI, CSSCI, PI, Co-PI, DiD, RD, CI, PRISMA und AI sind beim ersten Auftreten ausgeschrieben.
- Die Anführungszeichen in `02_literature.tex:16` sind geschlossen.
- „Mr.~“ und die geschützten Leerzeichen vor `\ref` und `\cite` sind korrekt.
- Die AI-Appendix-Tabelle ist nach Kartennummer geordnet.
- Der amerikanische Sprachstand ist einheitlich.

## Abnahmekriterien

- **Kriterium 1 (Review-Punkte A1–F, Zeile je Punkt im Bericht):** nicht meine Rolle.
- **Kriterium 2 (jede Zahl in einer CSV):** nicht meine Rolle.
- **Kriterium 3 (Abschnitt 6.3 nur mit verifizierten Aussagen):** nicht meine Rolle. Die Formulierung der Verifikationsregel ist an vier Stellen identisch (`06:76`, `results.tex:143`, `ai_use.tex`, Karte). Das ist sprachlich belegt erfüllt.
- **Kriterium 4 (XeLaTeX-Build ohne Fehler, Seitenzahl, `pdffonts`):** nicht meine Rolle. `review/T045_latex.txt` meldet „übersetzt fehlerfrei“.
- **Kriterium 5 (keine kausale Beschreibung, Trendergebnis in Abstract, Einleitung, 6.2 und Schluss):** sprachlich belegt erfüllt. Der einheitliche Satz „did not exceed its pre-policy pace and, under the firm trend, was slower…“ steht in `01:19`, `06:61` und `07:5`; der Abstract nennt „although that growth did not exceed its pre-policy pace“. Es steht kein Kausalwort („effect of the policy“) ohne Einschränkung.
- **Rework 4, Punkte 1–10:** belegt umgesetzt. Die Fundstellen sind `main.tex:52`, `01:19`, `02:16`, `06:42/61/67/91/97/61`, `07:5` und `results.tex:143/146`.

## Nicht geprüft

- Der Quelltext der nicht eingefrorenen Dateien `03_framework.tex`, `04_empirical_model.tex` und `05_context_data.tex`. Dort habe ich nur gezielt nach „tier“ und κ gesucht, beides ist definiert.
- Der Text der Tabellen unter `proposal/tables/*.tex` und die Beschriftung der Abbildungen (PDF).
- Der ausgegebene PDF-Satz, also Überfüllungen, Seitenumbrüche und die Darstellung der chinesischen Zeichen. Nur das `latexmk`-Protokoll liegt vor, und das enthält eine einzige Zeile.
- Der Inhalt von `review/T045_proposal.diff` nach Zeile 407. `results.tex`, `ai_use.tex` und `variables.tex` habe ich direkt gelesen. Der Rest des Diffs betrifft vor allem die nicht eingefrorenen Abschnitte 03 bis 05.
- Die Richtigkeit der Eigennamen, Beträge und Quellenzitate. Das ist Aufgabe der Rolle `consistency`.
