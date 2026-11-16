## Rolle: language (claude, sonnet) – VERDICT: REWORK


## Befunde

Die Befunde betreffen nur die Sprache. Ich habe `review/T0[number withheld]_proposal.diff`, `proposal/main.tex` (Titelseite und Anhangsdeckblatt) und die Zeilen der Karte gelesen und per Suche geprüft, ob nach der Umstellung noch Verweise ohne „Online" vorkommen. Keiner der Funde ist sinnentstellend, daher REWORK mit Liste.

[number withheld]. **Satzfragment** in `sections/06_preliminary_analysis.tex`, Absatz zu „Freezing parent equity…" (Zeile im Diff: `…([number withheld], $[[number withheld]]$); consistent with H2a, without supporting H2b (Online Appendix Table~\ref{tab:t0[number withheld]_symmetric}).`). Nach dem Semikolon fehlt ein Subjekt und ein Verb.
   - Vorschlag: `…; this is consistent with H2a but does not support H2b (Online Appendix Table~\ref{tab:t0[number withheld]_symmetric}).`

[number withheld]. **Unklarer Satz** in `sections/06_preliminary_analysis.tex`, Absatz zu den Trend-Benchmarks: `MI growth did not exceed its pre-policy pace; slower growth depends on the trend shape`.
   - „slower growth depends on" ist grammatisch holprig und sagt weniger als die Fassung davor („whether it was slower depends…").
   - Vorschlag: `…; whether it was slower depends on the trend shape (Online Appendix Table~\ref{tab:t0[number withheld]_trend}).`

[number withheld]. **Uneinheitlicher Begriff** in `sections/07_conclusion.tex`: `sector shocks remain`. Im übrigen Text (`[number withheld]`, Zusammenfassung der Threats-Tabelle, Absatz zu Zeile [number withheld] im Diff) heißt es „developer-specific shocks".
   - Vorschlag: `developer-specific shocks remain`.
   - Das ist zugleich ein inhaltlicher Hinweis, den ich nicht bewerte: „sector" und „developer-specific" meinen nicht dasselbe.

[number withheld]. **Kleinigkeit** in `sections/06_preliminary_analysis.tex`: `Smooth densities and equal counterfactual changes are required.`
   - Der Satz ist passiv und ohne Bezug. Der vorherige Satz benannte, was sie voraussetzt.
   - Vorschlag: `The comparison requires smooth densities and equal counterfactual changes.`

[number withheld]. **Kleinigkeit** in `sections/07_conclusion.tex`: `Neither economic leverage nor a causal policy effect is identified.` ist grammatisch korrekt, aber im Satzbau uneinheitlich zu den vorigen Sätzen in der ersten Person („I will…").
   - Das ist nur ein Hinweis, keine Korrektur nötig.

Ohne Fund:
- „Online Appendix" ist in allen geänderten Verweisen einheitlich. Die Suche nach „Appendix" ohne „Online" in `main.tex`, `sections/` und `tables/` ergab außerhalb von Kommentaren keinen Treffer.
- Amerikanische Schreibweise und `\today` sind durchgehend.
- Das Deckblatt ist stilistisch korrekt. Titel, Autor und Kursangabe stimmen mit der Titelseite überein.
- Geschützte Leerzeichen vor `\ref` sind in den neuen Sätzen gesetzt.

## Abnahmekriterien

[number withheld]. Verweise lösen auf, A-Seitenzahlen, Deckblatt und Anhangsinhaltsverzeichnis vorhanden: Der Build ist laut `review/T067_latex.txt` fehlerfrei. Im Quelltext sind Deckblatt (`main.tex`, Zeilen [number withheld]–[number withheld] im Diff), `\appendixcontents` und `\renewcommand{\thepage}{A\arabic{page}}` vorhanden. Die Satzfunktion ist nicht meine Rolle, die Sprache des Deckblatts ist in Ordnung.
[number withheld]. Hauptteil endet auf Seite [number withheld], keine Overfull-Boxes über [number withheld] pt: nicht meine Rolle.
[number withheld]. Punkte [number withheld]–[number withheld] mit je einer Zeile im Bericht und Liste aller Floats mit alter und neuer Nummer: nicht meine Rolle. Ich habe `tasks/T067_report.md` nicht geprüft.

## Nicht geprüft

- Das PDF und die Seitenzahlen. Ich führe keine Befehle aus und habe nur die Quelltexte und den Build-Bericht gelesen.
- Die Sprache der unveränderten Teile von `appendix/results.tex`, `appendix/variables.tex` und `appendix/ai_use.tex`. Gelesen habe ich nur die im Diff geänderten Stellen, die Anhangsverweise und die Titelseite.
- Der Eintrag in `AI_USAGE_LOG.md`. Er liegt nicht im Diff, und die Datei ist nicht Teil des Sprachprüfauftrags.
