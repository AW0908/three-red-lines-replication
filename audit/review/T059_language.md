## Rolle: language (claude, sonnet) – VERDICT: REWORK


## Befunde

Nur Sprache und Typografie (Rolle `language`). Es gibt keine sinnentstellenden Fehler, daher REWORK mit Liste.

1. **Falsch maskierter Apostroph in vier Tabellenfußnoten.** In LaTeX setzt `\'` einen Akut. Aus `region\'s` wird „regionś“ statt „region's“. Der Compile-Log zeigt dafür keinen Fehler.
   - `proposal/tables/t058_above.tex`, Zeile 29: `region\'s` → `region's`
   - `proposal/tables/t058_attrition.tex`, Zeile 19: `firm\'s` → `firm's`; `Fisher\'s` → `Fisher's`
   - `proposal/tables/t058_checks.tex`, Zeile 19: `Hong Kong\'s` → `Hong Kong's`
   - `proposal/tables/t058_symmetric.tex`, Zeile 34: `observation\'s` → `observation's`
   - Alle fünf Stellen auf `'` ändern (oder `\textquotesingle`). Das war bei diesem Text nur eine Stichprobe; `grep "\\\\'"` über `tables/` und `sections/` zeigt keine weiteren Treffer.

2. **Klammern in 6.1 nicht balanciert** (`proposal/sections/06_preliminary_analysis.tex`, Zeile 45): `is -1.30 ($[-5.29,2.87]$; contemporaneous classification also permits composition changes (Appendix Table~\ref{tab:t058_notch}).`
   - Die erste Klammer wird nie geschlossen.
   - Außerdem ist der Teilsatz unklar. Vorschlag: `is $-1.30$ ($[-5.29,2.87]$); contemporaneous classification also permits composition changes (Appendix Table~\ref{tab:t058_notch}).`

3. **Bindestrich statt Minuszeichen im Fließtext** (`proposal/sections/06_preliminary_analysis.tex`, Zeilen 43 und 45): `-1.53` und `-1.30` stehen als Text. Sie gehören in den Mathe-Modus (`$-1.53$`, `$-1.30$`), wie in den Tabellen und an anderen Stellen des Textes.

4. **Uneinheitliche Schreibweise von „nonpilot“.**
   - Text, Tabelle und Kommentar nutzen „pilot-minus-nonpilot“ und „Nonpilot“.
   - `tables/t058_pilot.tex` schreibt „Nonpilot: $b$, December 2020“, der Fließtext dagegen „pilot-minus-nonpilot“. Das ist intern konsistent, weicht aber von der Kartenwahl „non-pilot“ ab.
   - Entscheiden und überall gleich schreiben. Amerikanisch wäre „nonpilot“.

5. **Uneinheitliche Begriffe für Perpetual-Instrumente.** Der Text spricht von „perpetual bonds“ (Tabelle 3), „perpetual securities“ und „perpetual treatment“. Die Fußnote in `tables/t058_symmetric.tex` und `tables/t050_counterfactuals.tex` sagt „perpetuals“ (Zeile 34 bzw. Tabellenfußnote). Einen Begriff wählen, z. B. „perpetual bonds“.

6. **Kapitalisierung in Tabellenzeilen** (`tables/t058_symmetric.tex`): „Post, Parent equity“ und „Post, Both equity components“ haben ein großes zweites Wort. „Post, MI“ und „Post, Interest-bearing debt“ sind gemischt. Vorschlag: nach dem Komma klein („Post, parent equity“, „Post, both equity components“, „Post, interest-bearing debt“).

7. **Interner Aufgaben-Jargon in einer Papier-Fußnote** (`tables/t058_grid.tex`, Notiz): „All 72 T031 specifications“. „T031“ ist eine interne Karten-ID. Ersetzen durch „All 72 pre-specified specifications“ (so lautet auch die Figurenbeschriftung in `appendix/results.tex`).

8. **Unklare oder ungenau formulierte Sätze.**
   - `sections/03_framework.tex`, 3.2: „Holding $\kappa$ fixed and absent from costs, it leaves choices unchanged“. „it“ ist nicht eindeutig. Vorschlag: „Holding $\kappa$ fixed and outside the cost function, $\kappa$ leaves choices unchanged but makes the reported decline overstate economic deleveraging by $\kappa e$.“
   - `sections/03_framework.tex`, 3.1: „moves the developer to the green tier“. „green tier“ ist nirgends definiert, vorher im Text nur „tier“. Definieren oder umschreiben („to the top tier“).
   - `sections/07_conclusion.tex`: „removes excess mass, whose interval includes zero already from 0.09“. „whose“ bezieht sich grammatisch auf „excess mass“, gemeint ist der Break-even-Anteil. Vorschlag: „removes excess mass; the interval of this share already includes zero from 0.09“.
   - `sections/04_empirical_model.tex`: „Its break-even share removes excess mass“ nach Gleichung (kappa). Vorschlag: „The break-even share at which excess mass vanishes does not estimate debt-like financing.“
   - `sections/05_context_data.tex`, Sample-Absatz: „(Huafa, Section~\ref{subsec:pilot})“. Huafa wird an dieser Stelle nicht eingeführt (nur ein Querverweis). Vorschlag: „(e.g., Huafa, Section~…)“ mit einem Halbsatz Erklärung.

9. **Notation uneinheitlich** (`sections/04_empirical_model.tex`, Gleichung (kappa)): `\Delta MI_{it}`, `MI_{i,2019\mathrm{H}2}` stehen kursiv, Gleichung (frozen) davor nutzt `\text{MI}`. Einheitlich `\text{MI}` verwenden.

Hinweise (nicht Sprache im engeren Sinn):
   - Intro und Abstract: Der Abstract hat nach eigener Zählung unter 100 Wörter (Kartenvorgabe erfüllt).
   - Die Fußnoten der T058-Tabellen wiederholen denselben Einleitungssatz (999 Resamples, Seed, Pre/Post). Das ist bewusst, aber lang. Ein Verweis auf die erste Fußnote würde Platz sparen.
   - Im Anhang erscheinen „CSV“ und „row_id“ nur in Kommentaren, im Text „in the CSV“. Das ist für Leser des Proposals ohne Replikationspaket knapp; erwägenswert wäre „in the replication package“.

## Abnahmekriterien

1. Zahlen aus CSV, Zitate bestätigt: **nicht meine Rolle** (Rolle `consistency`). Die PI-Bestätigungen stehen auf der Karte und als Kommentare im Text.
2. Hauptteil endet auf Seite 15, Build sauber: **Build belegt** (`review/T059_latex.txt`: „übersetzt fehlerfrei“). Die Seitenzahl habe ich nicht geprüft, die Datei meldet nur den Erfolg des Builds. Die Fehler aus Befund 1 erzeugen keinen Compile-Fehler und sind deshalb nicht belegt „sauber“ im Sinne der Typografie.
3. Punkte 1–11 mit je einer Zeile im Bericht: **nicht meine Rolle**. Sprachlich sind die Formulierungen der Punkte 4 (Disclosure Audit), 6 (κ-Präzision) und 9 (Einleitungsabsatz) im Text umgesetzt. Die Textstellen stehen in Abstract, Einleitung, 3.2, 6.2 und Schluss.

## Nicht geprüft

- Das gebaute PDF habe ich nicht gesehen. Die Wirkung von `\'` (Befund 1) und die Seitenzahl sind aus dem Quelltext geschlossen, nicht am Layout bestätigt.
- Die Datei `appendix/results.tex` habe ich nur über den Diff gelesen, außerhalb der neuen Unterabschnitte also nicht.
- `proposal/references.bib` (neue Einträge): Rechtschreibung der Titel wirkt in Ordnung, Inhalt und Seitenangaben prüft die Rolle `consistency`.
- `proposal/figures/t058_grid.pdf` und das Literatur-PDF habe ich nicht geöffnet (Beschriftung der Abbildung stammt aus dem Diff).
- Die Abschnitte 01–07 habe ich bis auf die im Diff geänderten Stellen nicht vollständig gelesen. Unveränderte Absätze können eigene Sprachfehler haben, die hier nicht auftauchen.
- Die Abschnitte 5.2/6.3 mit Finding 3 (Zeilen ~100–140 in 06) liegen größtenteils außerhalb des Diffs.
