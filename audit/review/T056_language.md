## Rolle: language (claude, sonnet) – VERDICT: REWORK


## Befunde

Language-Review, nur Sprache und Typografie. Es gibt keinen sinnentstellenden Fehler, daher REWORK mit Liste. Ich habe Dateien gelesen, keine Befehle ausgeführt. Die Zeilennummern stammen aus `review/T0[number withheld]_proposal.diff`. Das Bibtex-Feld und die Tabellen habe ich dort gelesen.

[number withheld]. **PRISMA wird nicht mehr definiert.** `proposal/sections/02_literature.tex`, Absatz „Search": Die Langform „Preferred Reporting Items for Systematic Reviews and Meta-Analyses" wurde gestrichen. Die Abkürzung steht jetzt als „PRISMA [number withheld]" ohne Definition beim ersten Auftreten. Das widerspricht der Rollenvorgabe „Abkürzungen beim ersten Auftreten definiert". Die Suche in Hauptteil und Anhang (`main.tex`, `sections/*.tex`, `appendix/*.tex`) findet die Langform nirgends mehr, auch nicht in der Anhangsüberschrift. Vorschlag: „following the Preferred Reporting Items for Systematic Reviews and Meta-Analyses (PRISMA) [number withheld]~\citep{page2[number withheld]prisma}".

[number withheld]. **Veralteter Satzteil in der Fußnote von `proposal/tables/t051_robustness.tex`.** Die Fußnote endet mit „single dates and the unadjusted ratio: replication package". Die Zeile „Level $b$: unadjusted ratio" steht aber jetzt als Zeile [number withheld] in der Tabelle. Vorschlag: „single dates: replication package".

[number withheld]. **Verschachtelte Klammern in `02_literature.tex`, Absatz „Search".** „(Appendix Figure…, Tables…; artificial intelligence (AI) screening assistance: Appendix~\ref{app:ai})" ist schwer lesbar. Vorschlag: den AI-Teil als eigenen Satz oder mit Komma anschließen („; AI screening assistance is disclosed in Appendix~\ref{app:ai}"). Die Langform „artificial intelligence" gehört dann vor die Klammer.

[number withheld]. **Zu knappe Stichworte in `proposal/tables/t049_threats.tex`.**
   - „Proximity still moves" ist unverständlich. Vorschlag: „Shocks still move firms relative to the threshold".
   - „Gaps may overstate" sollte lauten „Missing crisis reports may overstate concentration".
   - „Prior MI growth; density" ist als Zeilenkopf mehrdeutig. Vorschlag: „Prior MI growth; density near [number withheld]".
   - „Trend shape assumed" ist akzeptabel.

[number withheld]. **Zu knappe Stichworte in `proposal/tables/t050_counterfactuals.tex`.** Die Spalte „Reading" enthält „Density" und „Pre-policy". Sie ist als Aussage nicht lesbar. Vorschlag: „Reflects density near [number withheld]" und „Pre-policy dependence". Außerdem steht „pp" in der Spaltenüberschrift, die Fußnote definiert es aber nur als „percentage points (pp)". Das passt, ist aber die einzige Stelle mit „pp"; sonst steht im Text „points" oder „percentage points". Hinweis: vereinheitlichen.

[number withheld]. **Uneinheitliche Bezeichnung desselben Maßes.** Dieselbe Größe heißt im Text mal „percentage points", mal nur „points". Beispiele: „[number withheld] to [number withheld] points", „[number withheld] points", „[number withheld] versus [number withheld] points". Das ist verständlich, sollte aber einheitlich sein (je nach Stelle „percentage points" bzw. „points" nach dem ersten Auftreten).

[number withheld]. **Konjunktiv und Verb zu stark, `07_conclusion.tex`.** „the break-even share of [number withheld] indicates that such a rule would remove the concentration at RL1 if roughly a quarter … were debt-like". Der Wortlaut ist zu stark für einen Benchmark („indicates … would remove"). Vorschlag: „the break-even share of [number withheld] suggests that such a rule would matter: if roughly a quarter of post-[number withheld] minority equity were debt-like, the concentration at RL1 would disappear". Dies ist ein Stilhinweis, kein Fehler.

[number withheld]. **Unklarer Anschluss, `06_preliminary_analysis.tex`, Z. [number withheld].** „The reason is that $D$ also depends on…" bezieht sich auf den vorherigen Absatz („does not, however, show greater reliance"). Der Bezug ist durch den Absatzwechsel verdeckt. Vorschlag: „This is because $D$ also depends…" im selben Absatz oder „The reason is that…" mit explizitem Rückbezug („The post-minus-placebo difference reflects that $D$ also depends…").

[number withheld]. **Fehlende geschützte Leerzeichen und Typografie.** Keine Fehler gefunden. `~\ref`, `~\citet` und `~\citep` sind durchgehend gesetzt. Die Anführungszeichen sind ``…'', Gedankenstriche sind `--`. Das Pronomen ist durchgehend „I"/„my": In allen `.tex`-Dateien in `sections/` und `tables/` finde ich kein „we/our/us". Die Anhangsdatei `proposal/appendix/results.tex` Z. [number withheld] enthält noch „our ratios". Sie liegt nicht unter den eingefrorenen Dateien, die ich prüfen sollte, fällt aber unter Punkt [number withheld] der Karte („everywhere"). Das ist ein Hinweis an den Co-PI.

[number withheld]. **Rechtschreibung, Zeichensetzung, Variante.** Keine Verstöße gegen die amerikanische Schreibweise gefunden (z. B. „harmonized", „summarizes"). „net gearing", „Three Red Lines", „firm-half-years" und „RL1" sind durchgehend gleich geschrieben. Die Zahlenformate sind in Text und Tabellen jeweils in sich einheitlich („[number withheld] percent" im Text, „[number withheld]\%" in Tabellenköpfen, wie zuvor).

## Abnahmekriterien

[number withheld]. Jede Zahl aus einer CSV, jede zitierte Tabelle enthält die Zahl: nicht meine Rolle.
[number withheld]. Haupttext endet auf Seite [number withheld], Build sauber: `review/T056_latex.txt` meldet „übersetzt fehlerfrei" (Build sauber, belegt). Die Seitenzahl kann ich nicht prüfen, das ist nicht meine Rolle.
[number withheld]. Punkte [number withheld]–[number withheld] je mit einer Zeile im Bericht: nicht meine Rolle. Punkt [number withheld] (Ich-Form) ist in den geprüften Dateien belegt umgesetzt, mit der Ausnahme aus Befund [number withheld]. Punkt [number withheld] (H2a/H2b) ist in Abschnitt [number withheld], [number withheld], [number withheld] und Schluss einheitlich bezeichnet, mit „Finding [number withheld] (H2a)" in der Überschrift. Punkt [number withheld]: Das `note`-Feld von `jin2[number withheld]deleveraging` entspricht dem geforderten Wortlaut, der Schlüssel ist unverändert. Das Chetty-Bibtex-Feld enthält `{Danish}` geschützt und `--` im Seitenbereich.

## Nicht geprüft

- Inhalt und Zahlen (Rolle consistency), Schätzcode und Methodik.
- Die Seitenzahl des Haupttextes und das Layout; ich habe nur die Build-Meldung gesehen, nicht die PDF.
- `AI_USAGE_LOG.md` (Sprachprüfung der Einträge) und die Dateien in `proposal/appendix/` außerhalb der genannten Stichproben.
- Die vollständigen Dateien: Ich habe die Änderungen im Diff gelesen und die unveränderten Teile nur per Suche auf „we/our/us" und die oben genannten Muster geprüft. Rechtschreibfehler in unveränderten Passagen sind nicht systematisch ausgeschlossen.
