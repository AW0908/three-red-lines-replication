## Rolle: language (claude, sonnet) – VERDICT: REWORK


Ich habe nur die Sprache geprüft. Gelesen habe ich `review/T0[number withheld]_proposal.diff` und `review/T064_latex.txt` (Übersetzung fehlerfrei) sowie die Grep-Treffer zu `references.bib`. Die unveränderten Teile der Dateien habe ich nicht gelesen. Es gibt keine sinnentstellenden Fehler, nur Kleinigkeiten und Typografie.

## Befunde

[number withheld]. **Britische Schreibweise.** `sections/03_framework.tex`, Absatz nach dem Kleven-Zitat: „signalling" → „signaling". Das Dokument ist durchgehend amerikanisch („optimization", „behavioral").
[number withheld]. **Interne Task-IDs in Tabellennoten.**
   - `tables/t058_attrition.tex`, Note: „T058 draws sample the full [number withheld]-developer universe…" → „These draws sample…".
   - `tables/t061_results.tex`, Note: „T058 subgroup intervals instead resample…" → „The subgroup intervals in Table~\ref{tab:t0[number withheld]_checks} instead resample…".
   - Task-IDs sind für Leser:innen nicht auflösbar.
[number withheld]. **Bindestrich statt Minuszeichen.** Die neuen Appendix-Tabellen setzen „[number withheld]", „[number withheld]", „[[number withheld], [number withheld]]" mit einfachem Bindestrich. Betroffen sind `tables/t063_control_sens.tex`, `t063_window.tex`, `t063_one_obs.tex` und `t063_noise.tex` (Zeile „No targeting (pre)"). Die übrigen Tabellen setzen `$-$[number withheld]` bzw. `$[[number withheld]]$` ohne Leerzeichen nach dem Komma. Vorschlag: `$-$[number withheld]` und `$[[number withheld]]$` durchgehend. In den Zeilenlabels „D all - C other" ist das Minus ebenfalls ein Bindestrich; besser `$-$`.
[number withheld]. **Fehlendes „Appendix" in der Note von `tables/t051_robustness.tex`.** Die Note nennt „Appendix Table~\ref{tab:t0[number withheld]_control}" und danach „Table~\ref{tab:t0[number withheld]_window}" sowie „Tables~\ref{tab:t0[number withheld]_robustness}, \ref{tab:t0[number withheld]_integration} and \ref{tab:falsification}". Das sind Appendix-Tabellen und nicht Tabellen im Haupttext. Vorschlag: „Appendix Table~\ref{tab:t0[number withheld]_window}" und „Appendix Tables~\ref{…}".
[number withheld]. **Serienkomma uneinheitlich.** `03_framework.tex`: „Firm-specific definitions, safety buffers, and signalling to lenders…" hat ein Komma vor „and". Im übrigen Text steht keines („counterparty, buyback, guarantee and shareholder-loan"). Vorschlag: Komma streichen.
[number withheld]. **Jahresbereiche uneinheitlich.** „[number withheld]-[number withheld]" ([number withheld]), „[number withheld]-[number withheld]" ([number withheld]) und „[number withheld]-[number withheld]" ([number withheld]) stehen nebeneinander. Vorschlag: eine Form, z. B. vierstellig „[number withheld]-[number withheld]".
[number withheld]. **Holpriger Satz.** `06_preliminary_analysis.tex`: „coverage by wide simulation ranges is not a match to both observed statistics". Vorschlag: „and wide simulation ranges that cover both observed statistics do not amount to a match".
[number withheld]. **Zweideutiges „distinct".** Dort: „Control changes at [number withheld] and [number withheld] are distinct, $[number withheld]$ … and $[number withheld]$". Vorschlag: „Control changes at [number withheld] and [number withheld] differ in the third decimal ($[number withheld]$ … and $[number withheld]$)".
[number withheld]. **Mehrdeutiger Bezug.** `[number withheld]`: „Constrained developers delayed supplier payments~\citep{su2[number withheld]trade}, potentially contaminating construction and materials controls." Vorschlag: „…, which could contaminate…".
[number withheld]. **Hinweis zu `appendix/ai_use.tex`.**
    - Zeile Nov. [number withheld]–[number withheld]: „Replaced a noise explanation with its failed joint mean match" ist schwer lesbar. Vorschlag: „Dropped the measurement-noise explanation because no calibrated cell matched both statistics".
    - Der neue Absatz hat „\texttt{t0[number withheld]\_estimates.csv}'s modification time of [number withheld]:[number withheld]:[number withheld]". Vorschlag: „the modification time of \texttt{t0[number withheld]\_estimates.csv}, [number withheld]:[number withheld]:[number withheld]".
    - Die Interna „T061--T064" in der Tabelle sind für Außenstehende unklar. Vorschlag: einmal „task cards T061--T064" ausschreiben.
[number withheld]. **Dateinamen unformatiert.** `tables/t063_one_obs.tex`, Note: „t0[number withheld]\_distinct\_firms.csv" und „t0[number withheld]\_one\_obs\_support.csv" ohne `\texttt{}`. In `t063_noise.tex` steht `\texttt{t063\_noise.csv}`. Vorschlag: einheitlich `\texttt`.
[number withheld]. **Hinweise (inhaltlich, nicht meine Rolle).**
    - In `tables/t063_noise.tex` sind die Spaltensymbole $\pi$, $\beta$, $\Delta$ und die Spalte „Both ranges" in der Note nicht definiert. $\Delta$ kollidiert zudem mit $\Delta b$.
    - In `01_introduction.tex` wird „RL1" ohne Einführung („first red line (RL1)") verwendet.
    - Die Namensform „Guo et al.'s" in `02_literature.tex` passt zum Bib-Eintrag (Erstautor Guo, Key `jin2[number withheld]deleveraging`). Sie ist nur ein Hinweis, falls das Zitat im PDF als „Guo et al." erscheint.

## Abnahmekriterien

- **Kriterium [number withheld] (Zahlen aus CSVs, Zitate PI-bestätigt):** nicht meine Rolle.
- **Kriterium [number withheld] (Seite [number withheld], Build sauber):** Build sauber, `review/T064_latex.txt` meldet „übersetzt fehlerfrei". Die Seitenzahl habe ich nicht geprüft; sie liegt außerhalb meiner Rolle.
- **Kriterium [number withheld] (Punkte [number withheld]–[number withheld] im Bericht):** nicht meine Rolle. Sprachlich geprüft habe ich die Texte zu den Punkten [number withheld]–[number withheld]. Die Abstract-Länge von Punkt [number withheld] habe ich nachgezählt: ca. [number withheld] Wörter, also ≤ [number withheld], belegt erfüllt.

## Nicht geprüft

- Die unveränderten Teile der Dateien, also alles außerhalb des Diffs. Das gilt auch für `main.tex` jenseits des Abstracts und für `references.bib`.
- Das PDF (Zeilenumbrüche und Erscheinungsbild der Tabellen).
- Zahlen, Zitate, Seitenumfang und die Pflichtpunkte [number withheld]–[number withheld] inhaltlich, weil das nicht meine Rolle ist.
