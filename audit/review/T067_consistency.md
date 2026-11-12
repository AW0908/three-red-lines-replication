## Rolle: consistency (claude, sonnet) – VERDICT: REWORK


## Befunde

1. **Inhaltliche Abweichung in der Schlussfolgerung (`proposal/sections/07_conclusion.tex`, Diff Z. 392).**
   - Der Satz hieß vorher „developer-specific shocks remain“. Jetzt steht dort „Identification requires smooth densities, equal counterfactual changes and stable reporting; sector shocks remain.“
   - Das widerspricht dem Rest des Textes. Die Kontrollgruppe adressiert gerade gemeinsame Sektorschocks. Abschnitt 6.5 und Tabelle `tab:threats` nennen als verbleibende Bedrohung „developer-specific shocks“. In 6.1 steht dazu passend „Other property-related shocks remain“.
   - Wirkung: Die Aussage zur Identifikation ist in Konklusion und Discussion nicht mehr deckungsgleich. Behebung: „developer-specific shocks remain“ wiederherstellen.

2. **Kleine Abschwächung der Formulierung (gleiche Stelle).** „stable reporting selection“ wurde zu „stable reporting“. Das ist weniger präzise gegenüber der Abschnitt-4-Terminologie. Es ist keine Zahlabweichung und nur ein Hinweis.

3. **Unvollständige Zählung im Bericht.** Der Bericht nennt zehn Abschnitts-/Unterabschnittseinträge im Anhangsverzeichnis. `review/T067_build/main.atoc` enthält zwölf Zeilen, nämlich zehn Abschnitte/Unterabschnitte (A, B, B.1–B.7, C) plus zwei `\paragraph`-Einträge (Audit trail, Evidence of prospective specification). Die Zahl ist eine Zählweise-Frage und hat keine Auswirkung auf die Abnahme.

4. **Restverweise ohne „Online“.**
   - `proposal/sections/02_literature.tex:22` enthält „Appendix B“ nur in einem Kommentar. Das ist unkritisch.
   - `proposal/tables/t061_results.tex:27` enthält „Appendix~\ref{app:res_targeting}“ innerhalb einer Anhangstabelle. Das ist unkritisch.
   - Im gedruckten Haupttext fand ich keinen unqualifizierten Verweis. Die Grep-Suche deckte `sections/*.tex` und `tables/*.tex` ab. Die Einleitung enthält laut Treffern keinen Anhangsverweis.

## Abnahmekriterien

1. **Verweise, A-Seitenzählung, Deckblatt und Anhangsverzeichnis:** belegt erfüllt, soweit meine Rolle reicht.
   - `main.tex` Z. 93–116 enthält Deckblatt, `\renewcommand{\thepage}{A\arabic{page}}` und `\appendixcontents`.
   - `main.toc` enthält genau einen Eintrag „Online Appendix … A1“. `main.atoc` listet die Anhangsabschnitte mit A-Seiten (A3 bis A36).
   - `T067_latex.txt` meldet „übersetzt fehlerfrei“, also keine Warnungen zu unaufgelösten Verweisen. Das Deckblatt zählt als A1, wie der Bericht angibt.
2. **Haupttext endet auf Seite 15:** belegt. `main.aux` Z. 112: `sec:main_end` auf Seite 15. Die Prüfung auf überlange Boxen liegt nicht bei meiner Rolle. `T067_latex.txt` enthält keine Warnungen.
3. **Punkte 1–4 im Bericht, Liste der Floats mit alter und neuer Nummer und Seite:**
   - Bericht belegt vorhanden. Stichproben gegen `main.aux`: `fig:prisma` B10 auf A31 und `tab:ai_use` C1 auf A33 stimmen.
   - Die Liste der Displays im Bericht ist vollständig gelistet. Die Plausibilität gegen `main.aux` habe ich nur stichprobenartig geprüft.
   - Punkt 2 des Berichts ist als „teilweise umgesetzt“ ausgewiesen. Er ist laut Karte optional.
   - Zahlen im gekürzten Text:
     - 4.59 [2.15, 7.47]
     - 2.67 [−0.22, 6.35]
     - 4.48 [1.85, 7.64]
     - 11.5 / 4.1 / 7.4 [3.1, 11.8]
     - 9.8 [4.7, 15.1] / 5.6
     - 10 von 249
     - 0.28 (κ)
   - Diese sind im Text unverändert gegenüber dem Diff. Abstract und Conclusion stimmen darin überein. Dateiwerte unter `replication/outputs/` habe ich nicht erneut gelesen (siehe unten).

## Nicht geprüft

- Die Zahlen in `replication/outputs/tables/*.csv` konnte ich nicht gegen den Text abgleichen. Dazu hatte ich keinen Zugriff, weil Bash nicht erlaubt war und ich die CSVs nicht gelesen habe. Ich habe nur geprüft, dass die Zahlen im Text durch die Kürzungen nicht geändert wurden (Diff).
- Die Inhalte von `tables/t049_threats.tex` habe ich nicht gelesen. Die Aussage, dass Tabelle `tab:threats` „developer-specific shocks“ nennt, stützt sich auf den alten Text in Abschnitt 6.5 (Diff) und ist ungeprüft.
- Das gerenderte PDF habe ich nicht gesehen. Seitenzahlen kenne ich nur aus `.aux` und `.toc`.
- `appendix/results.tex` habe ich nur über den Diff geprüft (acht ergänzte Verweise). Die Vollständigkeit der Referenzierung aller 48 Displays ist nicht unabhängig bestätigt.
- Rechtschreibung und Stil sind nicht meine Rolle.
