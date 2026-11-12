## Rolle: language (claude, sonnet) – VERDICT: REWORK


## Befunde

Language-Review, nur Sprache und Typografie. Es gibt keinen sinnentstellenden Fehler, daher REWORK mit Liste. Ich habe Dateien gelesen, keine Befehle ausgeführt. Die Zeilennummern stammen aus `review/T056_proposal.diff`. Das Bibtex-Feld und die Tabellen habe ich dort gelesen.

1. **PRISMA wird nicht mehr definiert.** `proposal/sections/02_literature.tex`, Absatz „Search": Die Langform „Preferred Reporting Items for Systematic Reviews and Meta-Analyses" wurde gestrichen. Die Abkürzung steht jetzt als „PRISMA 2020" ohne Definition beim ersten Auftreten. Das widerspricht der Rollenvorgabe „Abkürzungen beim ersten Auftreten definiert". Die Suche in Hauptteil und Anhang (`main.tex`, `sections/*.tex`, `appendix/*.tex`) findet die Langform nirgends mehr, auch nicht in der Anhangsüberschrift. Vorschlag: „following the Preferred Reporting Items for Systematic Reviews and Meta-Analyses (PRISMA) 2020~\citep{page2021prisma}".

2. **Veralteter Satzteil in der Fußnote von `proposal/tables/t051_robustness.tex`.** Die Fußnote endet mit „single dates and the unadjusted ratio: replication package". Die Zeile „Level $b$: unadjusted ratio" steht aber jetzt als Zeile 9 in der Tabelle. Vorschlag: „single dates: replication package".

3. **Verschachtelte Klammern in `02_literature.tex`, Absatz „Search".** „(Appendix Figure…, Tables…; artificial intelligence (AI) screening assistance: Appendix~\ref{app:ai})" ist schwer lesbar. Vorschlag: den AI-Teil als eigenen Satz oder mit Komma anschließen („; AI screening assistance is disclosed in Appendix~\ref{app:ai}"). Die Langform „artificial intelligence" gehört dann vor die Klammer.

4. **Zu knappe Stichworte in `proposal/tables/t049_threats.tex`.**
   - „Proximity still moves" ist unverständlich. Vorschlag: „Shocks still move firms relative to the threshold".
   - „Gaps may overstate" sollte lauten „Missing crisis reports may overstate concentration".
   - „Prior MI growth; density" ist als Zeilenkopf mehrdeutig. Vorschlag: „Prior MI growth; density near 0.70".
   - „Trend shape assumed" ist akzeptabel.

5. **Zu knappe Stichworte in `proposal/tables/t050_counterfactuals.tex`.** Die Spalte „Reading" enthält „Density" und „Pre-policy". Sie ist als Aussage nicht lesbar. Vorschlag: „Reflects density near 0.70" und „Pre-policy dependence". Außerdem steht „pp" in der Spaltenüberschrift, die Fußnote definiert es aber nur als „percentage points (pp)". Das passt, ist aber die einzige Stelle mit „pp"; sonst steht im Text „points" oder „percentage points". Hinweis: vereinheitlichen.

6. **Uneinheitliche Bezeichnung desselben Maßes.** Dieselbe Größe heißt im Text mal „percentage points", mal nur „points". Beispiele: „7.0 to 14.4 points", „5.6 points", „13.1 versus 7.6 points". Das ist verständlich, sollte aber einheitlich sein (je nach Stelle „percentage points" bzw. „points" nach dem ersten Auftreten).

7. **Konjunktiv und Verb zu stark, `07_conclusion.tex`.** „the break-even share of 0.28 indicates that such a rule would remove the concentration at RL1 if roughly a quarter … were debt-like". Der Wortlaut ist zu stark für einen Benchmark („indicates … would remove"). Vorschlag: „the break-even share of 0.28 suggests that such a rule would matter: if roughly a quarter of post-2019 minority equity were debt-like, the concentration at RL1 would disappear". Dies ist ein Stilhinweis, kein Fehler.

8. **Unklarer Anschluss, `06_preliminary_analysis.tex`, Z. 51.** „The reason is that $D$ also depends on…" bezieht sich auf den vorherigen Absatz („does not, however, show greater reliance"). Der Bezug ist durch den Absatzwechsel verdeckt. Vorschlag: „This is because $D$ also depends…" im selben Absatz oder „The reason is that…" mit explizitem Rückbezug („The post-minus-placebo difference reflects that $D$ also depends…").

9. **Fehlende geschützte Leerzeichen und Typografie.** Keine Fehler gefunden. `~\ref`, `~\citet` und `~\citep` sind durchgehend gesetzt. Die Anführungszeichen sind ``…'', Gedankenstriche sind `--`. Das Pronomen ist durchgehend „I"/„my": In allen `.tex`-Dateien in `sections/` und `tables/` finde ich kein „we/our/us". Die Anhangsdatei `proposal/appendix/results.tex` Z. 77 enthält noch „our ratios". Sie liegt nicht unter den eingefrorenen Dateien, die ich prüfen sollte, fällt aber unter Punkt 1 der Karte („everywhere"). Das ist ein Hinweis an den Co-PI.

10. **Rechtschreibung, Zeichensetzung, Variante.** Keine Verstöße gegen die amerikanische Schreibweise gefunden (z. B. „harmonized", „summarizes"). „net gearing", „Three Red Lines", „firm-half-years" und „RL1" sind durchgehend gleich geschrieben. Die Zahlenformate sind in Text und Tabellen jeweils in sich einheitlich („95 percent" im Text, „95\%" in Tabellenköpfen, wie zuvor).

## Abnahmekriterien

1. Jede Zahl aus einer CSV, jede zitierte Tabelle enthält die Zahl: nicht meine Rolle.
2. Haupttext endet auf Seite 15, Build sauber: `review/T056_latex.txt` meldet „übersetzt fehlerfrei" (Build sauber, belegt). Die Seitenzahl kann ich nicht prüfen, das ist nicht meine Rolle.
3. Punkte 1–10 je mit einer Zeile im Bericht: nicht meine Rolle. Punkt 1 (Ich-Form) ist in den geprüften Dateien belegt umgesetzt, mit der Ausnahme aus Befund 9. Punkt 2 (H2a/H2b) ist in Abschnitt 3, 4.3, 6.2 und Schluss einheitlich bezeichnet, mit „Finding 2 (H2a)" in der Überschrift. Punkt 9: Das `note`-Feld von `jin2025deleveraging` entspricht dem geforderten Wortlaut, der Schlüssel ist unverändert. Das Chetty-Bibtex-Feld enthält `{Danish}` geschützt und `--` im Seitenbereich.

## Nicht geprüft

- Inhalt und Zahlen (Rolle consistency), Schätzcode und Methodik.
- Die Seitenzahl des Haupttextes und das Layout; ich habe nur die Build-Meldung gesehen, nicht die PDF.
- `AI_USAGE_LOG.md` (Sprachprüfung der Einträge) und die Dateien in `proposal/appendix/` außerhalb der genannten Stichproben.
- Die vollständigen Dateien: Ich habe die Änderungen im Diff gelesen und die unveränderten Teile nur per Suche auf „we/our/us" und die oben genannten Muster geprüft. Rechtschreibfehler in unveränderten Passagen sind nicht systematisch ausgeschlossen.
