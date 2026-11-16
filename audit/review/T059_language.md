## Rolle: language (claude, sonnet) – VERDICT: REWORK


## Befunde

Nur Sprache und Typografie (Rolle `language`). Es gibt keine sinnentstellenden Fehler, daher REWORK mit Liste.

[number withheld]. **Falsch maskierter Apostroph in vier Tabellenfußnoten.** In LaTeX setzt `\'` einen Akut. Aus `region\'s` wird „regionś“ statt „region's“. Der Compile-Log zeigt dafür keinen Fehler.
   - `proposal/tables/t058_above.tex`, Zeile [number withheld]: `region\'s` → `region's`
   - `proposal/tables/t058_attrition.tex`, Zeile [number withheld]: `firm\'s` → `firm's`; `Fisher\'s` → `Fisher's`
   - `proposal/tables/t058_checks.tex`, Zeile [number withheld]: `Hong Kong\'s` → `Hong Kong's`
   - `proposal/tables/t058_symmetric.tex`, Zeile [number withheld]: `observation\'s` → `observation's`
   - Alle fünf Stellen auf `'` ändern (oder `\textquotesingle`). Das war bei diesem Text nur eine Stichprobe; `grep "\\\\'"` über `tables/` und `sections/` zeigt keine weiteren Treffer.

[number withheld]. **Klammern in [number withheld] nicht balanciert** (`proposal/sections/06_preliminary_analysis.tex`, Zeile [number withheld]): `is [number withheld] ($[[number withheld]]$; contemporaneous classification also permits composition changes (Appendix Table~\ref{tab:t0[number withheld]_notch}).`
   - Die erste Klammer wird nie geschlossen.
   - Außerdem ist der Teilsatz unklar. Vorschlag: `is $[number withheld]$ ($[[number withheld]]$); contemporaneous classification also permits composition changes (Appendix Table~\ref{tab:t0[number withheld]_notch}).`

[number withheld]. **Bindestrich statt Minuszeichen im Fließtext** (`proposal/sections/06_preliminary_analysis.tex`, Zeilen [number withheld] und [number withheld]): `[number withheld]` und `[number withheld]` stehen als Text. Sie gehören in den Mathe-Modus (`$[number withheld]$`, `$[number withheld]$`), wie in den Tabellen und an anderen Stellen des Textes.

[number withheld]. **Uneinheitliche Schreibweise von „nonpilot“.**
   - Text, Tabelle und Kommentar nutzen „pilot-minus-nonpilot“ und „Nonpilot“.
   - `tables/t058_pilot.tex` schreibt „Nonpilot: $b$, December [number withheld]“, der Fließtext dagegen „pilot-minus-nonpilot“. Das ist intern konsistent, weicht aber von der Kartenwahl „non-pilot“ ab.
   - Entscheiden und überall gleich schreiben. Amerikanisch wäre „nonpilot“.

[number withheld]. **Uneinheitliche Begriffe für Perpetual-Instrumente.** Der Text spricht von „perpetual bonds“ (Tabelle [number withheld]), „perpetual securities“ und „perpetual treatment“. Die Fußnote in `tables/t058_symmetric.tex` und `tables/t050_counterfactuals.tex` sagt „perpetuals“ (Zeile [number withheld] bzw. Tabellenfußnote). Einen Begriff wählen, z. B. „perpetual bonds“.

[number withheld]. **Kapitalisierung in Tabellenzeilen** (`tables/t058_symmetric.tex`): „Post, Parent equity“ und „Post, Both equity components“ haben ein großes zweites Wort. „Post, MI“ und „Post, Interest-bearing debt“ sind gemischt. Vorschlag: nach dem Komma klein („Post, parent equity“, „Post, both equity components“, „Post, interest-bearing debt“).

[number withheld]. **Interner Aufgaben-Jargon in einer Papier-Fußnote** (`tables/t058_grid.tex`, Notiz): „All [number withheld] T031 specifications“. „T031“ ist eine interne Karten-ID. Ersetzen durch „All [number withheld] pre-specified specifications“ (so lautet auch die Figurenbeschriftung in `appendix/results.tex`).

[number withheld]. **Unklare oder ungenau formulierte Sätze.**
   - `sections/03_framework.tex`, [number withheld]: „Holding $\kappa$ fixed and absent from costs, it leaves choices unchanged“. „it“ ist nicht eindeutig. Vorschlag: „Holding $\kappa$ fixed and outside the cost function, $\kappa$ leaves choices unchanged but makes the reported decline overstate economic deleveraging by $\kappa e$.“
   - `sections/03_framework.tex`, [number withheld]: „moves the developer to the green tier“. „green tier“ ist nirgends definiert, vorher im Text nur „tier“. Definieren oder umschreiben („to the top tier“).
   - `sections/07_conclusion.tex`: „removes excess mass, whose interval includes zero already from [number withheld]“. „whose“ bezieht sich grammatisch auf „excess mass“, gemeint ist der Break-even-Anteil. Vorschlag: „removes excess mass; the interval of this share already includes zero from [number withheld]“.
   - `sections/04_empirical_model.tex`: „Its break-even share removes excess mass“ nach Gleichung (kappa). Vorschlag: „The break-even share at which excess mass vanishes does not estimate debt-like financing.“
   - `sections/05_context_data.tex`, Sample-Absatz: „(Huafa, Section~\ref{subsec:pilot})“. Huafa wird an dieser Stelle nicht eingeführt (nur ein Querverweis). Vorschlag: „(e.g., Huafa, Section~…)“ mit einem Halbsatz Erklärung.

[number withheld]. **Notation uneinheitlich** (`sections/04_empirical_model.tex`, Gleichung (kappa)): `\Delta MI_{it}`, `MI_{i,[number withheld]\mathrm{H}[number withheld]}` stehen kursiv, Gleichung (frozen) davor nutzt `\text{MI}`. Einheitlich `\text{MI}` verwenden.

Hinweise (nicht Sprache im engeren Sinn):
   - Intro und Abstract: Der Abstract hat nach eigener Zählung unter [number withheld] Wörter (Kartenvorgabe erfüllt).
   - Die Fußnoten der T058-Tabellen wiederholen denselben Einleitungssatz ([number withheld] Resamples, Seed, Pre/Post). Das ist bewusst, aber lang. Ein Verweis auf die erste Fußnote würde Platz sparen.
   - Im Anhang erscheinen „CSV“ und „row_id“ nur in Kommentaren, im Text „in the CSV“. Das ist für Leser des Proposals ohne Replikationspaket knapp; erwägenswert wäre „in the replication package“.

## Abnahmekriterien

[number withheld]. Zahlen aus CSV, Zitate bestätigt: **nicht meine Rolle** (Rolle `consistency`). Die PI-Bestätigungen stehen auf der Karte und als Kommentare im Text.
[number withheld]. Hauptteil endet auf Seite [number withheld], Build sauber: **Build belegt** (`review/T059_latex.txt`: „übersetzt fehlerfrei“). Die Seitenzahl habe ich nicht geprüft, die Datei meldet nur den Erfolg des Builds. Die Fehler aus Befund [number withheld] erzeugen keinen Compile-Fehler und sind deshalb nicht belegt „sauber“ im Sinne der Typografie.
[number withheld]. Punkte [number withheld]–[number withheld] mit je einer Zeile im Bericht: **nicht meine Rolle**. Sprachlich sind die Formulierungen der Punkte [number withheld] (Disclosure Audit), [number withheld] (κ-Präzision) und [number withheld] (Einleitungsabsatz) im Text umgesetzt. Die Textstellen stehen in Abstract, Einleitung, [number withheld], [number withheld] und Schluss.

## Nicht geprüft

- Das gebaute PDF habe ich nicht gesehen. Die Wirkung von `\'` (Befund [number withheld]) und die Seitenzahl sind aus dem Quelltext geschlossen, nicht am Layout bestätigt.
- Die Datei `appendix/results.tex` habe ich nur über den Diff gelesen, außerhalb der neuen Unterabschnitte also nicht.
- `proposal/references.bib` (neue Einträge): Rechtschreibung der Titel wirkt in Ordnung, Inhalt und Seitenangaben prüft die Rolle `consistency`.
- `proposal/figures/t058_grid.pdf` und das Literatur-PDF habe ich nicht geöffnet (Beschriftung der Abbildung stammt aus dem Diff).
- Die Abschnitte [number withheld]–[number withheld] habe ich bis auf die im Diff geänderten Stellen nicht vollständig gelesen. Unveränderte Absätze können eigene Sprachfehler haben, die hier nicht auftauchen.
- Die Abschnitte [number withheld]/[number withheld] mit Finding [number withheld] (Zeilen ~[number withheld]–[number withheld] in [number withheld]) liegen größtenteils außerhalb des Diffs.
