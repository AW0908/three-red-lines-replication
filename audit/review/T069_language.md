## Rolle: language (claude, sonnet) – VERDICT: REWORK


Ich habe nur die Sprache geprüft, und zwar anhand von `review/T0[number withheld]_proposal.diff` und der Tabellen `t0[number withheld]_heckman`, `t0[number withheld]_first_1`, `t0[number withheld]_reporting`, `t0[number withheld]_dr_1`. Die Sprachfehler sind behebbare Kleinigkeiten, nichts davon entstellt den Sinn. Zeilennummern der Dateien lagen mir nicht vor, deshalb gebe ich die Fundstelle als Datei plus wörtliches Zitat an.

## Befunde

[number withheld]. **Britische Schreibweise** (`proposal/sections/05_context_data.tex`, Abschnitt zur Replikation): „An external referee without a Wind licence can rerun …". Das Dokument ist durchgehend amerikanisch, im selben Absatz steht „Wind data are licensed". Korrektur: „license".

[number withheld]. **Abkürzungen ohne Definition beim ersten Auftreten**
   - `04_empirical_model.tex`: Der Satz „I also estimate doubly robust DiD following \citet{santanna2[number withheld]doubly}" führt „DR-DiD" nicht ein. Danach steht „DR-DiD" in [number withheld] („exact market stratification for DR-DiD"), in [number withheld], in `t0[number withheld]_identification` und in den Appendix-Titeln. Korrektur: „doubly robust DiD (DR-DiD)".
   - „ATT" wird in [number withheld] („DR-DiD yields ATT $[number withheld]$ …") und in `t0[number withheld]_identification` benutzt, aber nirgends in den geprüften Dateien definiert. Korrektur: „average treatment effect on the treated (ATT)" beim ersten Auftreten in [number withheld].
   - „CI" wurde in [number withheld] gekürzt. Der Satz mit „([number withheld] percent confidence interval, CI …)" ist weggefallen, und der neue erste Fund lautet „([number withheld] percent CI …)". Wenn „CI" nicht schon in der Einleitung definiert ist, fehlt die Definition. Das habe ich nicht prüfen können.
   - „IPW" steht in [number withheld] („Reporting-IPW gives …") und in `t0[number withheld]_reporting`, ist aber nicht definiert. Im Appendix heißt es nur „inverse-probability-tilting" und „inverse-probability-of-reporting". Korrektur: „inverse-probability-of-reporting weighting (IPW)" bei der ersten Nennung. Im Appendix-Titel „Reporting weights" und in der Tabelle „Reporting-IPW" sollte derselbe Begriff stehen.

[number withheld]. **Uneinheitlicher Begriff und Notation**
   - `04_empirical_model.tex`: Die Gleichung heißt jetzt nur noch „difference-in-bunching", das Symbol $\Delta\Delta b$ wird nicht mehr eingeführt. [number withheld] verwendet es weiter („pooled $\Delta\Delta b$ is [number withheld]"). Korrektur: „… difference-in-bunching, $\Delta\Delta b$, is" wiederherstellen.
   - `02_literature.tex`: Der Text spricht von „Guo et al.", der Zitierschlüssel lautet `jin2[number withheld]deleveraging`, und die Fußnote nennt „Guo, Jin, Ru, Yang and Zou". Die Namensform ist ohne Definition uneinheitlich. Korrektur: „Guo et al." beim ersten Auftreten direkt hinter `\citet` einführen oder durchgehend die Form verwenden, die `\citet` ausgibt. Das ist eine Frage für die Consistency-Rolle; ich markiere sie nur als Hinweis.

[number withheld]. **Typografie in den Tabellen**
   - `t069_balance_1.tex` und `t069_balance_2.tex` enthalten Werte wie `$[number withheld]$` (Spalte „Weighted"). Korrektur: `$[number withheld]$`, ein negatives Vorzeichen bei Null ist irreführend.
   - Die Tabellenköpfe verwenden „[number withheld]\% CI", der Fließtext dagegen „[number withheld] percent". In `t049_threats.tex` steht außerdem „[number withheld]/[number withheld]\%". Korrektur: eine Form wählen, im Fließtext „percent". In Tabellen ist „\%" üblich und vertretbar, aber dann überall.

[number withheld]. **Stil**
   - `02_literature.tex`: „Guo et al. identify the causal effect of breaching the lines under their treatment design's parallel-trends assumption" ist schwerfällig. Vorschlag: „under the parallel-trends assumption of their treatment design".
   - `07_conclusion.tex`: „tightening finance for viable projects". Vorschlag: „tightening financing".
   - `06_preliminary_analysis.tex`: „Lee bounds remain a sensitivity check … ; none validates attrition correction." Das Bezugswort von „none" ist unklar. Vorschlag: „neither the Lee bounds nor the weights validate an attrition correction."
   - `results.tex`, Anfang des neuen Unterabschnitts: „The improved panel estimator uses …" und „No row in the current audit is an algebraic identity." Beide Sätze sind für Außenstehende unklar. „Improved" wäre „panel DR-DiD estimator" (Sant'Anna and Zhao [number withheld]). Der zweite Satz sollte sagen, was gemeint ist, oder gestrichen werden.
   - `06_preliminary_analysis.tex`: „imprecisely estimated" und „an imprecise estimate" ist stilistisch in Ordnung. Dagegen ist „the pooled contrast gains precision from Hong Kong developers, who lack a Hong Kong control" korrekt und verständlich.

[number withheld]. **Hinweis ohne Sprachbezug, nicht meine Rolle:** `t050_identification.tex` nennt „Y2 $[number withheld]$" für den Ownership-ATT. Der Text in [number withheld] nennt dort nur Y1 ($[number withheld]$) und „ΔΔb". Ob [number withheld] mit `t066_drdid.csv` übereinstimmt, ist Sache der Consistency-Rolle. Das Vorzeichen wechselt gegenüber dem Y2-Wert der Entwickler-Kontrolle ($[number withheld]$) und ist plausibel, aber ungeprüft.

## Abnahmekriterien

[number withheld]. Zahlen aus CSV, Referenzen lösen auf: nicht meine Rolle. Die Bib-Eintragung `santanna2[number withheld]doubly` ist vorhanden und im Text zitiert.
[number withheld]. Hauptteil endet auf Seite [number withheld], Build sauber: nicht meine Rolle. Den Build-Log (`review/T069_latex.txt`) habe ich nicht auf Warnungen ausgewertet. Meine Suche nach „Warning" und „Overfull" lieferte keine Treffer, aber der Bash-Aufruf zum Lesen der Datei wurde verweigert und die Grep-Suche war die einzige Prüfung.
[number withheld]. Punkte [number withheld]–[number withheld] je mit Zeile im Bericht: nicht meine Rolle. Sprachlich sind die Texte zu den Punkten [number withheld](a)–(h) vorhanden und verständlich. Den Absatz zu [number withheld](i) (Appendix C) habe ich nicht gefunden. `main.tex` und der AI-Appendix tauchen im Diff nicht auf. Ob [number withheld](i) geschrieben wurde, prüft die Consistency-Rolle.

## Nicht geprüft

- Die Seitenzählung und die Kompilierung.
- Die übrigen Appendix-Tabellen (`t0[number withheld]_dr_2` bis `t0[number withheld]_dr_5`, `t0[number withheld]_first_2`, `t0[number withheld]_lee`, `t0[number withheld]_ownership`, `t0[number withheld]_balance_3`). Die Fußnoten der DR-Tabellen sind identisch und wurden einmal gelesen, die anderen Tabellen nicht Zeile für Zeile.
- `main.tex` (Abstract), `AI_USAGE_LOG.md` und der Appendix C, weil sie nicht im Diff stehen.
- Die Zeilennummern in den Quelldateien. Ich konnte die Quelldateien nicht per Bash zeilenweise ausgeben, die Fundstellen sind deshalb als Zitate angegeben.
- Das Diff-Ende (Zeilen [number withheld]–[number withheld]). Dort stehen vermutlich die übrigen neuen Tabellen, die ich nicht gelesen habe.
