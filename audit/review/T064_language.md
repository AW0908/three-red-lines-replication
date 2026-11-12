## Rolle: language (claude, sonnet) – VERDICT: REWORK


Ich habe nur die Sprache geprüft. Gelesen habe ich `review/T064_proposal.diff` und `review/T064_latex.txt` (Übersetzung fehlerfrei) sowie die Grep-Treffer zu `references.bib`. Die unveränderten Teile der Dateien habe ich nicht gelesen. Es gibt keine sinnentstellenden Fehler, nur Kleinigkeiten und Typografie.

## Befunde

1. **Britische Schreibweise.** `sections/03_framework.tex`, Absatz nach dem Kleven-Zitat: „signalling" → „signaling". Das Dokument ist durchgehend amerikanisch („optimization", „behavioral").
2. **Interne Task-IDs in Tabellennoten.**
   - `tables/t058_attrition.tex`, Note: „T058 draws sample the full 136-developer universe…" → „These draws sample…".
   - `tables/t061_results.tex`, Note: „T058 subgroup intervals instead resample…" → „The subgroup intervals in Table~\ref{tab:t058_checks} instead resample…".
   - Task-IDs sind für Leser:innen nicht auflösbar.
3. **Bindestrich statt Minuszeichen.** Die neuen Appendix-Tabellen setzen „-0.88", „-0.57", „[-1.92, 0.67]" mit einfachem Bindestrich. Betroffen sind `tables/t063_control_sens.tex`, `t063_window.tex`, `t063_one_obs.tex` und `t063_noise.tex` (Zeile „No targeting (pre)"). Die übrigen Tabellen setzen `$-$0.18` bzw. `$[-1.67,0.44]$` ohne Leerzeichen nach dem Komma. Vorschlag: `$-$0.88` und `$[-1.92,0.67]$` durchgehend. In den Zeilenlabels „D all - C other" ist das Minus ebenfalls ein Bindestrich; besser `$-$`.
4. **Fehlendes „Appendix" in der Note von `tables/t051_robustness.tex`.** Die Note nennt „Appendix Table~\ref{tab:t061_control}" und danach „Table~\ref{tab:t063_window}" sowie „Tables~\ref{tab:t040_robustness}, \ref{tab:t043_integration} and \ref{tab:falsification}". Das sind Appendix-Tabellen und nicht Tabellen im Haupttext. Vorschlag: „Appendix Table~\ref{tab:t063_window}" und „Appendix Tables~\ref{…}".
5. **Serienkomma uneinheitlich.** `03_framework.tex`: „Firm-specific definitions, safety buffers, and signalling to lenders…" hat ein Komma vor „and". Im übrigen Text steht keines („counterparty, buyback, guarantee and shareholder-loan"). Vorschlag: Komma streichen.
6. **Jahresbereiche uneinheitlich.** „2021--22" (03), „2020--21" (07) und „2019--2021" (06) stehen nebeneinander. Vorschlag: eine Form, z. B. vierstellig „2021--2022".
7. **Holpriger Satz.** `06_preliminary_analysis.tex`: „coverage by wide simulation ranges is not a match to both observed statistics". Vorschlag: „and wide simulation ranges that cover both observed statistics do not amount to a match".
8. **Zweideutiges „distinct".** Dort: „Control changes at 0.70 and 0.60 are distinct, $-0.574$ … and $-0.571$". Vorschlag: „Control changes at 0.70 and 0.60 differ in the third decimal ($-0.574$ … and $-0.571$)".
9. **Mehrdeutiger Bezug.** `06`: „Constrained developers delayed supplier payments~\citep{su2026trade}, potentially contaminating construction and materials controls." Vorschlag: „…, which could contaminate…".
10. **Hinweis zu `appendix/ai_use.tex`.**
    - Zeile Nov. 1–2: „Replaced a noise explanation with its failed joint mean match" ist schwer lesbar. Vorschlag: „Dropped the measurement-noise explanation because no calibrated cell matched both statistics".
    - Der neue Absatz hat „\texttt{t061\_estimates.csv}'s modification time of 14:20:39". Vorschlag: „the modification time of \texttt{t061\_estimates.csv}, 14:20:39".
    - Die Interna „T061--T064" in der Tabelle sind für Außenstehende unklar. Vorschlag: einmal „task cards T061--T064" ausschreiben.
11. **Dateinamen unformatiert.** `tables/t063_one_obs.tex`, Note: „t063\_distinct\_firms.csv" und „t063\_one\_obs\_support.csv" ohne `\texttt{}`. In `t063_noise.tex` steht `\texttt{t063\_noise.csv}`. Vorschlag: einheitlich `\texttt`.
12. **Hinweise (inhaltlich, nicht meine Rolle).**
    - In `tables/t063_noise.tex` sind die Spaltensymbole $\pi$, $\beta$, $\Delta$ und die Spalte „Both ranges" in der Note nicht definiert. $\Delta$ kollidiert zudem mit $\Delta b$.
    - In `01_introduction.tex` wird „RL1" ohne Einführung („first red line (RL1)") verwendet.
    - Die Namensform „Guo et al.'s" in `02_literature.tex` passt zum Bib-Eintrag (Erstautor Guo, Key `jin2025deleveraging`). Sie ist nur ein Hinweis, falls das Zitat im PDF als „Guo et al." erscheint.

## Abnahmekriterien

- **Kriterium 1 (Zahlen aus CSVs, Zitate PI-bestätigt):** nicht meine Rolle.
- **Kriterium 2 (Seite 15, Build sauber):** Build sauber, `review/T064_latex.txt` meldet „übersetzt fehlerfrei". Die Seitenzahl habe ich nicht geprüft; sie liegt außerhalb meiner Rolle.
- **Kriterium 3 (Punkte 1–10 im Bericht):** nicht meine Rolle. Sprachlich geprüft habe ich die Texte zu den Punkten 1–9. Die Abstract-Länge von Punkt 7 habe ich nachgezählt: ca. 83 Wörter, also ≤ 100, belegt erfüllt.

## Nicht geprüft

- Die unveränderten Teile der Dateien, also alles außerhalb des Diffs. Das gilt auch für `main.tex` jenseits des Abstracts und für `references.bib`.
- Das PDF (Zeilenumbrüche und Erscheinungsbild der Tabellen).
- Zahlen, Zitate, Seitenumfang und die Pflichtpunkte 1–10 inhaltlich, weil das nicht meine Rolle ist.
