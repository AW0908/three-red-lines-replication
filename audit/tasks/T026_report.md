## Ergebnis
Ich habe in `proposal/theory_note.tex` alle Punkte aus `review/T026.md` (Runde [number withheld]) eingearbeitet.
- **Schätzung, Punkt [number withheld]:** Die Bedingung für `rl2_gap` bezieht sich jetzt auf die tatsächlich geschätzte Regression mit Firmen- und Datums-Fixed-Effects (TWFE) im unbalancierten Panel: Der mechanische Beitrag zum Koeffizienten darf nicht positiv sein. Die einfache Kovarianz mit der Dosis ist nur noch als Sonderfall genannt (balancierter Vergleich eines Datums vor und eines nach der Politik). Dort steht jetzt auch das Gegenbeispiel.
- **Schätzung, Punkt [number withheld]:** Die Aussage „the cleaner test …“ ist gestrichen. Der Text sagt jetzt, dass auch die Änderung des Wedge innerhalb einer Firma dieselbe Annahme braucht. Gegen die Mechanik robust wäre nur eine ausdrücklich definierte Bereinigung, die die geplanten Tests nicht enthalten.
- **Länge:** Den Haupttext habe ich gekürzt, damit er mit Tabelle in sechs Seiten passt. Ob das reicht, ist ungeprüft (siehe Offene Fragen).
- **Sprache:** Die P5-Tabellenzeile ist so formuliert, wie der Reviewer es vorgeschlagen hat.

## Dateien
- `proposal/theory_note.tex` – einzige geänderte Datei:
  - **Kopfkommentar:** Eintrag für diese Überarbeitung (Runde [number withheld]).
  - **Gekürzt, Inhalt gleich:** Einleitung, Remarks [number withheld]–[number withheld], Absätze nach Proposition [number withheld] und [number withheld], Abschnitt [number withheld], Diskussion.
  - **Tabelle:**
    - Spalten linksbündig (`>{\raggedright\arraybackslash}p{…}`).
    - Die Variablendefinitionen stehen jetzt als Tabellennotiz ohne Buchstaben in der Tabelle statt im Fließtext.
    - Neue P5-Zeile; Notizen a und f überarbeitet.
  - **Remark [number withheld] (Anhang B):** letzter Absatz neu geschrieben.
  - **Anhang B, erster und letzter Absatz:** Verweis auf die neue Bedingung.

## Ausführung
Nicht ausgeführt. In dieser Sitzung hatte ich kein Shell-Werkzeug, nur Lesen und Bearbeiten von Dateien. Deshalb konnte ich `cd proposal && latexmk -pdf -interaction=nonstopmode -outdir=../review/T0[number withheld]_theory_build theory_note.tex; cd ..` nicht starten. Laut Karte übersetzt ohnehin der PI. Es gibt also keine Ausgabe.

## Abnahmekriterien
[number withheld]. **Propositionen folgen aus den Annahmen: unverändert erfüllt.** Propositionen und Beweise in Anhang A habe ich nicht angefasst. Die neue Rechnung habe ich von Hand nachgeprüft:
   - P/(E(E−P))·|ΔN| = [number withheld]/[number withheld] = [number withheld]/[number withheld] bzw. [number withheld]/[number withheld] = [number withheld]/[number withheld]
   - [number withheld]/[number withheld] − [number withheld]/[number withheld] = [number withheld]/[number withheld] − [number withheld]/[number withheld] = [number withheld]/[number withheld]
   - Im balancierten Zwei-Perioden-Fall ist der Koeffizient Cov(Δy, dose)/Var(dose).
[number withheld]. **Vorhersage–Test-Tabelle:**
   - Notiz a und Anhang B stimmen jetzt mit der geschätzten TWFE-Spezifikation überein.
   - Die Aussage „cleaner test“ ist entfernt.
   - Die P5-Zeile lautet: „For adjusters, the decline in the reported ratio exceeds the decline in $L$“.
   - Ob damit alles erfüllt ist, entscheidet das nächste Review.
[number withheld]. **Stand-alone-Übersetzung: nicht geprüft**, weil ich keine Shell hatte.
   - Neu eingesetzt sind nur `>{…}`-Spalten (das Paket `array` steht in der Präambel) und ein `\item[]` in den `tablenotes`.
   - Ob der Haupttext höchstens sechs Seiten hat und ob „Float too large“ oder „Overfull \hbox“ verschwunden sind, ist offen. Geschätzt habe ich rund [number withheld] Zeilen Fließtext mit [number withheld]-fachem Abstand gestrichen; vorher fehlte etwa eine Tabellenseite.
[number withheld]. **Keine anderen Dateien geändert: erfüllt.** Ich habe nur `proposal/theory_note.tex` bearbeitet.

Zahlen im neuen oder geänderten Text:
- E = [number withheld], P = [number withheld] bzw. [number withheld], ΔN = [number withheld] bzw. [number withheld] und die Ergebnisse [number withheld]/[number withheld], [number withheld]/[number withheld], [number withheld]/[number withheld]: Rechenbeispiel aus der Rückmeldung des Co-PI in Runde [number withheld] (`tasks/T026.md`) und `review/T026.md`, keine Datenwerte. Der Quellkommentar über Remark [number withheld] steht schon im Text.
- „[number withheld] half-year dates“: schon vorher im Text; Quelle `replication/code/02_estimate.R`, nicht neu.
- RL1 = [number withheld]: institutioneller Schwellenwert, Quelle `jin2[number withheld]deleveraging`.

Neue Zahlen aus Daten habe ich keine eingefügt.

## Offene Fragen
- **Kompilieren und Seitenzahl prüfen.** Ich konnte nicht übersetzen. Der PI muss den Ausführungsbefehl starten und im Log prüfen:
  - Steht `tab:mapping` in der `.aux` auf Seite ≤ [number withheld], und endet die Diskussion auf Seite ≤ [number withheld]?
  - Steht im Log weder „Float too large“ noch „Overfull \hbox“?
  - Falls die Tabelle doch auf Seite [number withheld] rutscht: Am einfachsten lässt sich noch die Corollary [number withheld] samt Folgesatz in Anhang B verschieben. Das ist eine Entscheidung des Co-PI.
- **Gestrichene Sätze in Abschnitt [number withheld].** Drei Aussagen stehen nicht mehr im Fließtext von Abschnitt [number withheld], sondern nur noch in den Tabellennotizen a, b und e und in Anhang B: „g ist nicht das gemessene Treatment“, „Bins unter τ nur mit Sicherheitsabstand“ und „rl2_adj ist nur ein Teilmaß mit Wedge ungleich null“.
- **Notiz e ungeändert.** Sie verlangt „relative to each developer's pre-policy wedge“ weiterhin als Bedingung für P3 und P5. Für `rl2_gap` kommt über Notiz a zusätzlich die Annahme zum mechanischen Beitrag hinzu.
