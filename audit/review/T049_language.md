## Rolle: language (claude, sonnet) – VERDICT: REWORK


Ich habe nur die Sprache der Diff-Änderungen geprüft (`review/T049_proposal.diff` und die neuen Tabellen). Der Test-Build `review/T049_latex.txt` meldet "übersetzt fehlerfrei". Keiner der Funde ist sinnentstellend, deshalb REWORK statt mehr.

## Befunde

1. **Uneinheitlicher Begriff und undefinierter Name.** `proposal/tables/t049_threats.tex:9` schreibt "Chetty fixed-point fit". Der Haupttext nennt dasselbe Verfahren "mass-conserving fixed-point fit" (`06_preliminary_analysis.tex`, Finding 1), und "Chetty" wird im Haupttext nirgends eingeführt. Der Name kommt nur in Zeilen der Appendix-Tabelle `t043_integration.tex` vor.
   Vorschlag: "Mass-conserving fixed-point fit".

2. **Undefiniertes Symbol.** `proposal/tables/t049_threats.tex:13` schreibt "Frozen-MI comparison holds adjusted liabilities $N$ fixed". $N$ ist nirgends erklärt, und der Satz ist ohne $N$ vollständig.
   Vorschlag: "Frozen-MI comparison holds adjusted liabilities fixed". Das entspricht auch `04_empirical_model.tex` ("holds adjusted liabilities fixed").

3. **Typografie des Zeitraums.** `proposal/appendix/ai_use.tex`, Absatz "Dates, purposes and representative tasks": "From October 13--30, 2026". Der Halbgeviertstrich passt nicht zu "From".
   Vorschlag: "From October 13 to 30, 2026" oder "During October 13--30, 2026".

4. **Uneinheitliche Modellbezeichnung.** Dasselbe Haiku-Modell heißt in `ai_use.tex` einmal "Claude Haiku for the LaTeX skeleton", sonst "Claude Code (Haiku)" (Diff-Zeile 26, Vorversion). Die Tabelle nennt das Tool "Claude Code".
   Vorschlag: "Claude Code (Haiku)" durchgehend.

5. **Undefinierter Fachjargon.** `proposal/appendix/results.tex`, neuer Absatz "Reversal evidence is weaker …": "the binned model's exact-distance-adjusted differences". "Binned model" und "exact-distance-adjusted" sind an dieser Stelle nicht erklärt.
   Vorschlag: neutraler formulieren, etwa "the reversal differences from the binned-count model, adjusted for distance to the threshold". Ob das inhaltlich stimmt, prüft die Konsistenzrolle.

6. **Stilwiederholung.** `proposal/sections/07_conclusion.tex`, Plan für das Final Paper: Fünf Sätze beginnen mit "We will". Das ist nur ein Stilhinweis; "starting with the ten crossing events …" und die Feedback-Zeile lassen sich mit einem Nebensatz verbinden.

7. **Kleinigkeiten in den Tabellen.**
   - `proposal/tables/t049_sample_composition.tex`: Die Überschrift von Panel B hat eine leere dritte Spalte. Das ist optisch unschön, aber nicht falsch.
   - Die Caption schreibt "market/listing status" mit Schrägstrich, im Panel-Titel steht "Market and listing status". Eine einheitliche Form wäre besser.

## Abnahmekriterien

- **Sprachliche Konsistenz (Kriterium 4, "no causal language added"):** Im Diff keine neue kausale Formulierung gefunden. Die Zeilen "no causal composition effect" und "not evidence of debt-like equity" sind vorsichtig formuliert. Die inhaltliche Prüfung gehört der Konsistenzrolle.
- **LaTeX-Build ohne Fehler (Kriterium 3, Teil "kompiliert"):** Laut `review/T049_latex.txt` fehlerfrei. Die Angaben zu Seitenzahl, "Main text ends on page 14" und Overfull-Boxen sind dem Log nicht zu entnehmen.
- **Punkt 8 (Shimao-Formulierung):** sprachlich erfüllt. "a third party, Mr.~Hui," und "lapses if Shimao Services is listed" stehen im `\floatnote`.
- **Kriterien 1 und 2 (Berichtszeilen, Zahlen → CSV):** nicht meine Rolle.
- **Inhaltliche Punkte 1–7, 9–11:** sprachlich unauffällig außer den Funden oben; die inhaltliche Prüfung gehört einer anderen Rolle.

## Nicht geprüft

- Das kompilierte PDF (Seitenumbrüche, Lesbarkeit der NEF-Grafik im Druck). Mir liegen nur Diff und Quelltexte vor.
- Den unveränderten Teil der Dateien. Ich habe nur die Diff-Zeilen und die zwei neuen Tabellen gelesen.
- `AI_USAGE_LOG.md` und die CSV-Dateien. Sie sind für die Sprachrolle nicht relevant.
- Die Einhaltung des 130-Wörter-Limits und die Angabe "ten" gegenüber `source_inventory.csv`. Das gehört der Konsistenzrolle.
