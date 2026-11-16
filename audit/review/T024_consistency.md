## Rolle: consistency (claude, opus) – VERDICT: PASS


## Befunde
Keine inhaltlichen Konsistenzfehler. Drei Hinweise zur Information, keiner davon blockiert:

[number withheld]. **Prüfprotokoll und Skriptprüfung widersprechen sich bei `state/LIMITATIONS.md`.** Das Protokoll meldet in `t024_verification.txt:2916` „state/LIMITATIONS.md … unchanged“. Die Prüfsumme des Skripts meldet die Datei dagegen als verändert. Die beiden Aussagen beziehen sich auf unterschiedliche Ausgangszeitpunkte: das Protokoll auf den Beginn von Runde [number withheld], das Skript auf den Beginn der Kartenausführung. Die Einträge D2[number withheld] und D2[number withheld] (`LIMITATIONS.md:59–60`) tragen das Datum 2026-10-21 und laut Karte (Runde [number withheld], Punkt [number withheld]) schreibt sie der Co-PI. Ein Fehler des Workers ist nicht erkennbar. Der Co-PI sollte die Änderung trotzdem als seine eigene bestätigen.
[number withheld]. **Die Note von `t024_rd_main.tex:20` nennt Werte, die die Tabelle nicht zeigt.** Dort steht „No significance stars; p-values unadjusted“, die Tabelle hat aber keine p-Spalte. Das stammt aus früheren Runden, die bereits PASS erhalten haben, und widerspricht keinem Output. Es ist nur ein redaktioneller Hinweis.
[number withheld]. **Der neue Ausschluss steht in der README nur im Changelog.** Der Abschnitt zu `07_rd.R` (`README.md:490–499`) beschreibt die neuen Ausschlusszeilen für RL2 und mi_share nicht, sie stehen nur im Changelog (Zeile [number withheld]). Die Karte verlangt für die README nur Pipeline, Pakete, Outputs und Changelog, das ist also zulässig.

## Abnahmekriterien
- **Runde [number withheld], Punkt [number withheld] (Audit-Felder):** belegt erfüllt. `t024_firm_audit.csv` enthält `n_post_te_nonpos`, `n_post_mi_gt_te` und `flag_equity_problem`. Es gibt [number withheld] Firmenzeilen, davon sind [number withheld] markiert (Grep `,TRUE,`). Das stimmt mit „[number withheld]/[number withheld]“ im Bericht und in `verification.txt:2926` überein.
- **Runde [number withheld], Punkt [number withheld] (zwei Robustheitszeilen):** belegt erfüllt. In `t024_rd_robustness.csv:62–63` stimmen alle Werte mit dem Bericht und `verification.txt:2931–2932` überein:
  - RL2: N_eff [number withheld]/[number withheld], Punktschätzer [number withheld], BC [number withheld], KI [[number withheld]; [number withheld]], p [number withheld], MSE-Gate [number withheld]/[number withheld].
  - mi_share: N_eff [number withheld]/[number withheld], Punktschätzer [number withheld], BC [number withheld], KI [[number withheld]; [number withheld]], p [number withheld], MSE-Gate [number withheld]/[number withheld].
  
  Gegenprobe der Fallzahlen:
[firm-specific excerpt withheld in public process copy]
  - Das passt zu den effektiven Fallzahlen: [number withheld]→[number withheld] (RL2) und [number withheld]→[number withheld] (mi_share) rechts, links unverändert.
  - Die Basisstichprobe sinkt von [number withheld]/[number withheld] auf [number withheld]/[number withheld], also um [number withheld] Firmen. Das stimmt mit den [number withheld] markierten Firmen überein.
  
  Die Haupttabelle ist unverändert: `t024_rd_main.tex` und `t024_rd_main.csv` haben dieselben Zahlen wie in den früheren Runden und im Bericht.
- **Runde [number withheld], Punkt [number withheld] (Notensätze):** belegt erfüllt. Beide Sätze stehen wortgleich zur Karte in `t024_rd_main.tex:20` und `t024_rd_fuzzy.tex:43`, ebenso „Log debt is undefined for zero debt.“ Die Vorgaben aus Runde [number withheld] bleiben eingehalten:
  - Die Hauptnote enthält weder den Juni-[number withheld]-Satz noch log assets.
  - Die Fuzzy-Note enthält beide.
- **Runde [number withheld], Punkt [number withheld] (sprintf):** belegt erfüllt. Die Zählungen in der Note werden in `07_rd.R:184–187` per sprintf aus `f` erzeugt.
- **Punkt [number withheld] der Karte (Fallzahlen [number withheld]/[number withheld]):** belegt erfüllt. `t024_sample_counts.csv:4` zeigt [number withheld]/[number withheld]. Die Abweichungen [number withheld]/[number withheld] (sharp) und [number withheld]/[number withheld] (fuzzy) sind erklärt, in `README.md:501–503` und in der CSV-Spalte `missing_outcome/missing_D`.
- **Punkt [number withheld] der Karte (Reproduzierbarkeit):** nicht meine Rolle. Die Angaben [number withheld]/[number withheld] und [number withheld]/[number withheld] in `verification.txt:2912–2913` stimmen mit dem Bericht überein.
- **Punkt [number withheld] der Karte (Validität):** belegt erfüllt, soweit es die Konsistenz betrifft.
  - Placebo bei [number withheld]: p = [number withheld] (`t024_rd_validity.csv:10`), entspricht „[number withheld]“ im Bericht und „[number withheld]“ in `README.md:518`.
  - Dichtetest: p = [number withheld] (Zeile [number withheld]).
  - Vier Binomialfenster mit p < [number withheld] (Fenster [number withheld]–[number withheld]), wie in Bericht und README angegeben.
- **Punkt [number withheld] der Karte (Interpretation):** belegt erfüllt.
  - Die Tabelle der Sharp-Schätzungen im Bericht stimmt Zeile für Zeile mit `t024_rd_main.csv` überein (Punktschätzer, BC, KI, p).
  - Die Wortwahl bleibt bei „suggestiv“ für RL1 (p = [number withheld]) und Log-Schuld (p = [number withheld]).
  - Für keine Schätzung wird Signifikanz behauptet, und alle robusten KIs der Haupttabelle enthalten [number withheld].

## Nicht geprüft
- Text in `proposal/`: Diese Karte schreibt nichts in `proposal/`, deshalb gibt es keinen Abgleich zwischen Paper und Output.
- Ob die Zählungen [number withheld]/[number withheld]/[number withheld] (nichtpositives Eigenkapital, mi > te, rl2 > [number withheld]) im Panel richtig sind und ob das Flag die richtigen Firmen markiert: Das ist Aufgabe des Data-Reviewers. Ich habe nur geprüft, dass Bericht, Protokoll und CSV dieselben Zahlen enthalten.
- PDF-Abbildungen und die TeX-Kompilierung: nicht angesehen bzw. nicht ausgeführt.
- Byte-Identität und SHA-[number withheld]: Ich habe keine Befehle ausgeführt.
