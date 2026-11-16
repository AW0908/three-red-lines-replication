## Rolle: consistency (claude, sonnet) – VERDICT: REWORK


## Befunde

[number withheld]. **Zwei Bereichsangaben in `variables.tex` sind kaputt (Zeilen [number withheld] und [number withheld]).**
   - Ursprünglich stand dort `([number withheld]-[number withheld])` und `[number withheld]H1-[number withheld]H2`. Jetzt steht dort `([number withheld]-$[number withheld]$)` und `[number withheld]H1-$[number withheld]$H2`.
   - Das setzt einen Bindestrich und danach ein Minuszeichen, also etwa „[number withheld]-[number withheld]“ und „[number withheld]H1-[number withheld]H2“.
   - Das sieht aus wie ein Überbleibsel der Vorzeichen-Vereinheitlichung. Es ändert den Text der Variablendefinitionen (Tabelle `tab:variables`), obwohl die Karte nur Layout erlaubt.
   - Die Zahlenprüfung des Workers hat das nicht erkannt, weil die Ziffern gleich bleiben (`[number withheld]`, `[number withheld]`, `[number withheld]`, `[number withheld]`). Sie prüft nur Zahlen-Token, nicht Satzzeichen.
   - Behebung: `--` wiederherstellen (`[number withheld]-[number withheld]`, `[number withheld]H1-[number withheld]H2`).

[number withheld]. **In mehreren Spaltenköpfen fehlt das Leerzeichen vor der Formel (Label-Schreibweise geändert).**
   - `t043_delta_excess.tex`: `Pre$b$`, `Post$b$`, `Share$>[number withheld]$`. Vorher stand dort `Pre $b$`, `Post $b$`, `Share $>[number withheld]$`.
   - `t063_noise.tex`: `Mean$b$`, vorher `Mean $b$`.
   - `t040_validation.tex`, Panel D: `Published$\leq [number withheld]$` und `Published$>[number withheld]$`, vorher mit Leerzeichen.
   - Das zeigt sich als „Preb“, „Share>[number withheld]“ und „Published≤[number withheld]“. Es ist kosmetisch, aber die Beschriftung ist nicht mehr dieselbe wie vorher.
   - Behebung: Leerzeichen setzen, zum Beispiel `\apphead{Pre $b$}`.

[number withheld]. **Die Vor- und Nachprüfung des Workers deckt Satzzeichen und Labels nicht ab.** Befund [number withheld] entkam nur, weil die Prüfung auf Zahlen-Token beschränkt war. Die Karte verlangt aber „Labels' meaning unchanged“. Eine Label-Diff (Text ohne Layoutmakros) wäre nötig gewesen.

## Abnahmekriterien

[number withheld]. **Alle Tabellen auf `\linewidth`, Build sauber, Haupttext unverändert und endet auf Seite [number withheld]:** nicht meine Rolle. Das ist Layout, Build und Seitenzahl. Ich habe `review/T070_latex.txt` nach Overfull- und Undefined-Meldungen durchsucht und keine gefunden, die Seitenzahl aber nicht geprüft.
[number withheld]. **Keine Zahl in den Tabellen geändert:** nur teilweise belegt. Beim Lesen von `review/T0[number withheld]_proposal.diff` stimmen alle Zahlenwerte der von mir gesichteten Tabellen vor und nach der Änderung überein. Das gilt auch für Zeilenreihenfolge, `\label`s und Captions, auch bei den Fortsetzungsteilen von `t0[number withheld]_delta_excess`, `t0[number withheld]_integration` und `t0[number withheld]_control_sens`.
   - Die Umstellung von `$-$` auf `-` in S-Spalten und umgekehrt ist Typografie. Der Wert bleibt gleich, auch bei `[number withheld]`.
   - Text ändert sich in den Befunden [number withheld] und [number withheld], und die sind der Grund für REWORK.
[number withheld]. **Bericht mit Tabellenliste, Seite, alter Breite, neuem Format und den zwei zweispaltigen Tabellen:** belegt, soweit der Bericht das enthält.
   - Die Liste in `tasks/T070_report.md` ist vollständig.
   - Ob die Werte in der Spalte „Alte Breite“ und die Seitenangaben stimmen, ist nicht meine Rolle und nicht geprüft.

## Nicht geprüft

- Das Kompilat `main.pdf`. Ich habe keine Befehle ausgeführt, also auch keine Seitenzuordnung, keine Breitenmessung und keine Darstellung der Tabellen kontrolliert.
- Die Ziffernfolgen im Haupttext gegen `replication/outputs/` (nicht Teil der Karte, Haupttext ist unverändert).
- Die Dateien `replication/outputs/**` und T066. Sie liegen nicht im Schreibbereich von T070, und das Zeitstempel-Signal dazu stammt offenbar von der parallelen Karte.
- Einzelne Tabellen jenseits des Diffs, etwa der vollständige Dateikopf von `results.tex` (Zeilen vor [number withheld]). Ich habe nur die Hunks im Diff gelesen.
