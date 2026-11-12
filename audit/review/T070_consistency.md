## Rolle: consistency (claude, sonnet) – VERDICT: REWORK


## Befunde

1. **Zwei Bereichsangaben in `variables.tex` sind kaputt (Zeilen 29 und 30).**
   - Ursprünglich stand dort `(0--3)` und `2017H1--2019H2`. Jetzt steht dort `(0-$-3$)` und `2017H1-$-2019$H2`.
   - Das setzt einen Bindestrich und danach ein Minuszeichen, also etwa „0-−3“ und „2017H1-−2019H2“.
   - Das sieht aus wie ein Überbleibsel der Vorzeichen-Vereinheitlichung. Es ändert den Text der Variablendefinitionen (Tabelle `tab:variables`), obwohl die Karte nur Layout erlaubt.
   - Die Zahlenprüfung des Workers hat das nicht erkannt, weil die Ziffern gleich bleiben (`0`, `3`, `2017`, `2019`). Sie prüft nur Zahlen-Token, nicht Satzzeichen.
   - Behebung: `--` wiederherstellen (`0--3`, `2017H1--2019H2`).

2. **In mehreren Spaltenköpfen fehlt das Leerzeichen vor der Formel (Label-Schreibweise geändert).**
   - `t043_delta_excess.tex`: `Pre$b$`, `Post$b$`, `Share$>0$`. Vorher stand dort `Pre $b$`, `Post $b$`, `Share $>0$`.
   - `t063_noise.tex`: `Mean$b$`, vorher `Mean $b$`.
   - `t040_validation.tex`, Panel D: `Published$\leq 0.70$` und `Published$>0.70$`, vorher mit Leerzeichen.
   - Das zeigt sich als „Preb“, „Share>0“ und „Published≤0.70“. Es ist kosmetisch, aber die Beschriftung ist nicht mehr dieselbe wie vorher.
   - Behebung: Leerzeichen setzen, zum Beispiel `\apphead{Pre $b$}`.

3. **Die Vor- und Nachprüfung des Workers deckt Satzzeichen und Labels nicht ab.** Befund 1 entkam nur, weil die Prüfung auf Zahlen-Token beschränkt war. Die Karte verlangt aber „Labels' meaning unchanged“. Eine Label-Diff (Text ohne Layoutmakros) wäre nötig gewesen.

## Abnahmekriterien

1. **Alle Tabellen auf `\linewidth`, Build sauber, Haupttext unverändert und endet auf Seite 15:** nicht meine Rolle. Das ist Layout, Build und Seitenzahl. Ich habe `review/T070_latex.txt` nach Overfull- und Undefined-Meldungen durchsucht und keine gefunden, die Seitenzahl aber nicht geprüft.
2. **Keine Zahl in den Tabellen geändert:** nur teilweise belegt. Beim Lesen von `review/T070_proposal.diff` stimmen alle Zahlenwerte der von mir gesichteten Tabellen vor und nach der Änderung überein. Das gilt auch für Zeilenreihenfolge, `\label`s und Captions, auch bei den Fortsetzungsteilen von `t043_delta_excess`, `t043_integration` und `t063_control_sens`.
   - Die Umstellung von `$-$` auf `-` in S-Spalten und umgekehrt ist Typografie. Der Wert bleibt gleich, auch bei `-0.0000`.
   - Text ändert sich in den Befunden 1 und 2, und die sind der Grund für REWORK.
3. **Bericht mit Tabellenliste, Seite, alter Breite, neuem Format und den zwei zweispaltigen Tabellen:** belegt, soweit der Bericht das enthält.
   - Die Liste in `tasks/T070_report.md` ist vollständig.
   - Ob die Werte in der Spalte „Alte Breite“ und die Seitenangaben stimmen, ist nicht meine Rolle und nicht geprüft.

## Nicht geprüft

- Das Kompilat `main.pdf`. Ich habe keine Befehle ausgeführt, also auch keine Seitenzuordnung, keine Breitenmessung und keine Darstellung der Tabellen kontrolliert.
- Die Ziffernfolgen im Haupttext gegen `replication/outputs/` (nicht Teil der Karte, Haupttext ist unverändert).
- Die Dateien `replication/outputs/**` und T066. Sie liegen nicht im Schreibbereich von T070, und das Zeitstempel-Signal dazu stammt offenbar von der parallelen Karte.
- Einzelne Tabellen jenseits des Diffs, etwa der vollständige Dateikopf von `results.tex` (Zeilen vor 139). Ich habe nur die Hunks im Diff gelesen.
