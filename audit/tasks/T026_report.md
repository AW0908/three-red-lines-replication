## Ergebnis
Ich habe in `proposal/theory_note.tex` alle Punkte aus `review/T026.md` (Runde 4) eingearbeitet.
- **Schätzung, Punkt 1:** Die Bedingung für `rl2_gap` bezieht sich jetzt auf die tatsächlich geschätzte Regression mit Firmen- und Datums-Fixed-Effects (TWFE) im unbalancierten Panel: Der mechanische Beitrag zum Koeffizienten darf nicht positiv sein. Die einfache Kovarianz mit der Dosis ist nur noch als Sonderfall genannt (balancierter Vergleich eines Datums vor und eines nach der Politik). Dort steht jetzt auch das Gegenbeispiel.
- **Schätzung, Punkt 2:** Die Aussage „the cleaner test …“ ist gestrichen. Der Text sagt jetzt, dass auch die Änderung des Wedge innerhalb einer Firma dieselbe Annahme braucht. Gegen die Mechanik robust wäre nur eine ausdrücklich definierte Bereinigung, die die geplanten Tests nicht enthalten.
- **Länge:** Den Haupttext habe ich gekürzt, damit er mit Tabelle in sechs Seiten passt. Ob das reicht, ist ungeprüft (siehe Offene Fragen).
- **Sprache:** Die P5-Tabellenzeile ist so formuliert, wie der Reviewer es vorgeschlagen hat.

## Dateien
- `proposal/theory_note.tex` – einzige geänderte Datei:
  - **Kopfkommentar:** Eintrag für diese Überarbeitung (Runde 5).
  - **Gekürzt, Inhalt gleich:** Einleitung, Remarks 1–3, Absätze nach Proposition 4 und 5, Abschnitt 4, Diskussion.
  - **Tabelle:**
    - Spalten linksbündig (`>{\raggedright\arraybackslash}p{…}`).
    - Die Variablendefinitionen stehen jetzt als Tabellennotiz ohne Buchstaben in der Tabelle statt im Fließtext.
    - Neue P5-Zeile; Notizen a und f überarbeitet.
  - **Remark 4 (Anhang B):** letzter Absatz neu geschrieben.
  - **Anhang B, erster und letzter Absatz:** Verweis auf die neue Bedingung.

## Ausführung
Nicht ausgeführt. In dieser Sitzung hatte ich kein Shell-Werkzeug, nur Lesen und Bearbeiten von Dateien. Deshalb konnte ich `cd proposal && latexmk -pdf -interaction=nonstopmode -outdir=../review/T026_theory_build theory_note.tex; cd ..` nicht starten. Laut Karte übersetzt ohnehin der PI. Es gibt also keine Ausgabe.

## Abnahmekriterien
1. **Propositionen folgen aus den Annahmen: unverändert erfüllt.** Propositionen und Beweise in Anhang A habe ich nicht angefasst. Die neue Rechnung habe ich von Hand nachgeprüft:
   - P/(E(E−P))·|ΔN| = 20/9900 = 1/495 bzw. 120/9000 = 1/75
   - 1/75 − 1/495 = 33/2475 − 5/2475 = 28/2475
   - Im balancierten Zwei-Perioden-Fall ist der Koeffizient Cov(Δy, dose)/Var(dose).
2. **Vorhersage–Test-Tabelle:**
   - Notiz a und Anhang B stimmen jetzt mit der geschätzten TWFE-Spezifikation überein.
   - Die Aussage „cleaner test“ ist entfernt.
   - Die P5-Zeile lautet: „For adjusters, the decline in the reported ratio exceeds the decline in $L$“.
   - Ob damit alles erfüllt ist, entscheidet das nächste Review.
3. **Stand-alone-Übersetzung: nicht geprüft**, weil ich keine Shell hatte.
   - Neu eingesetzt sind nur `>{…}`-Spalten (das Paket `array` steht in der Präambel) und ein `\item[]` in den `tablenotes`.
   - Ob der Haupttext höchstens sechs Seiten hat und ob „Float too large“ oder „Overfull \hbox“ verschwunden sind, ist offen. Geschätzt habe ich rund 30 Zeilen Fließtext mit 1,5-fachem Abstand gestrichen; vorher fehlte etwa eine Tabellenseite.
4. **Keine anderen Dateien geändert: erfüllt.** Ich habe nur `proposal/theory_note.tex` bearbeitet.

Zahlen im neuen oder geänderten Text:
- E = 100, P = 1 bzw. 10, ΔN = −20 bzw. −12 und die Ergebnisse 1/495, 1/75, 28/2475: Rechenbeispiel aus der Rückmeldung des Co-PI in Runde 4 (`tasks/T026.md`) und `review/T026.md`, keine Datenwerte. Der Quellkommentar über Remark 4 steht schon im Text.
- „13 half-year dates“: schon vorher im Text; Quelle `replication/code/02_estimate.R`, nicht neu.
- RL1 = 0,70: institutioneller Schwellenwert, Quelle `jin2025deleveraging`.

Neue Zahlen aus Daten habe ich keine eingefügt.

## Offene Fragen
- **Kompilieren und Seitenzahl prüfen.** Ich konnte nicht übersetzen. Der PI muss den Ausführungsbefehl starten und im Log prüfen:
  - Steht `tab:mapping` in der `.aux` auf Seite ≤ 6, und endet die Diskussion auf Seite ≤ 6?
  - Steht im Log weder „Float too large“ noch „Overfull \hbox“?
  - Falls die Tabelle doch auf Seite 7 rutscht: Am einfachsten lässt sich noch die Corollary 1 samt Folgesatz in Anhang B verschieben. Das ist eine Entscheidung des Co-PI.
- **Gestrichene Sätze in Abschnitt 4.** Drei Aussagen stehen nicht mehr im Fließtext von Abschnitt 4, sondern nur noch in den Tabellennotizen a, b und e und in Anhang B: „g ist nicht das gemessene Treatment“, „Bins unter τ nur mit Sicherheitsabstand“ und „rl2_adj ist nur ein Teilmaß mit Wedge ungleich null“.
- **Notiz e ungeändert.** Sie verlangt „relative to each developer's pre-policy wedge“ weiterhin als Bedingung für P3 und P5. Für `rl2_gap` kommt über Notiz a zusätzlich die Annahme zum mechanischen Beitrag hinzu.
