## Rolle: consistency (claude, opus) – VERDICT: PASS


## Befunde
Keine inhaltlichen Konsistenzfehler. Drei Hinweise zur Information, keiner davon blockiert:

1. **Prüfprotokoll und Skriptprüfung widersprechen sich bei `state/LIMITATIONS.md`.** Das Protokoll meldet in `t024_verification.txt:2916` „state/LIMITATIONS.md … unchanged“. Die Prüfsumme des Skripts meldet die Datei dagegen als verändert. Die beiden Aussagen beziehen sich auf unterschiedliche Ausgangszeitpunkte: das Protokoll auf den Beginn von Runde 4, das Skript auf den Beginn der Kartenausführung. Die Einträge D22 und D23 (`LIMITATIONS.md:59–60`) tragen das Datum 2026-10-21 und laut Karte (Runde 4, Punkt 4) schreibt sie der Co-PI. Ein Fehler des Workers ist nicht erkennbar. Der Co-PI sollte die Änderung trotzdem als seine eigene bestätigen.
2. **Die Note von `t024_rd_main.tex:20` nennt Werte, die die Tabelle nicht zeigt.** Dort steht „No significance stars; p-values unadjusted“, die Tabelle hat aber keine p-Spalte. Das stammt aus früheren Runden, die bereits PASS erhalten haben, und widerspricht keinem Output. Es ist nur ein redaktioneller Hinweis.
3. **Der neue Ausschluss steht in der README nur im Changelog.** Der Abschnitt zu `07_rd.R` (`README.md:490–499`) beschreibt die neuen Ausschlusszeilen für RL2 und mi_share nicht, sie stehen nur im Changelog (Zeile 771). Die Karte verlangt für die README nur Pipeline, Pakete, Outputs und Changelog, das ist also zulässig.

## Abnahmekriterien
- **Runde 4, Punkt 1 (Audit-Felder):** belegt erfüllt. `t024_firm_audit.csv` enthält `n_post_te_nonpos`, `n_post_mi_gt_te` und `flag_equity_problem`. Es gibt 136 Firmenzeilen, davon sind 14 markiert (Grep `,TRUE,`). Das stimmt mit „14/136“ im Bericht und in `verification.txt:2926` überein.
- **Runde 4, Punkt 2 (zwei Robustheitszeilen):** belegt erfüllt. In `t024_rd_robustness.csv:62–63` stimmen alle Werte mit dem Bericht und `verification.txt:2931–2932` überein:
  - RL2: N_eff 26/37, Punktschätzer 0.0188, BC 0.1911, KI [−0.3778; 0.7600], p 0.5102, MSE-Gate 16/27.
  - mi_share: N_eff 28/40, Punktschätzer −0.0319, BC −0.0427, KI [−0.1373; 0.0520], p 0.3768, MSE-Gate 17/32.
  
  Gegenprobe der Fallzahlen:
[firm-specific excerpt withheld in public audit]
  - Das passt zu den effektiven Fallzahlen: 41→37 (RL2) und 44→40 (mi_share) rechts, links unverändert.
  - Die Basisstichprobe sinkt von 64/71 auf 63/58, also um 14 Firmen. Das stimmt mit den 14 markierten Firmen überein.
  
  Die Haupttabelle ist unverändert: `t024_rd_main.tex` und `t024_rd_main.csv` haben dieselben Zahlen wie in den früheren Runden und im Bericht.
- **Runde 4, Punkt 3 (Notensätze):** belegt erfüllt. Beide Sätze stehen wortgleich zur Karte in `t024_rd_main.tex:20` und `t024_rd_fuzzy.tex:43`, ebenso „Log debt is undefined for zero debt.“ Die Vorgaben aus Runde 3 bleiben eingehalten:
  - Die Hauptnote enthält weder den Juni-2020-Satz noch log assets.
  - Die Fuzzy-Note enthält beide.
- **Runde 4, Punkt 4 (sprintf):** belegt erfüllt. Die Zählungen in der Note werden in `07_rd.R:184–187` per sprintf aus `f` erzeugt.
- **Punkt 1 der Karte (Fallzahlen 28/45):** belegt erfüllt. `t024_sample_counts.csv:4` zeigt 28/45. Die Abweichungen 28/44 (sharp) und 28/43 (fuzzy) sind erklärt, in `README.md:501–503` und in der CSV-Spalte `missing_outcome/missing_D`.
- **Punkt 2 der Karte (Reproduzierbarkeit):** nicht meine Rolle. Die Angaben 16/16 und 65/65 in `verification.txt:2912–2913` stimmen mit dem Bericht überein.
- **Punkt 3 der Karte (Validität):** belegt erfüllt, soweit es die Konsistenz betrifft.
  - Placebo bei +0,05: p = 0,0481 (`t024_rd_validity.csv:10`), entspricht „0,048“ im Bericht und „0.0481“ in `README.md:518`.
  - Dichtetest: p = 0,2181 (Zeile 2).
  - Vier Binomialfenster mit p < 0,05 (Fenster 2–5), wie in Bericht und README angegeben.
- **Punkt 4 der Karte (Interpretation):** belegt erfüllt.
  - Die Tabelle der Sharp-Schätzungen im Bericht stimmt Zeile für Zeile mit `t024_rd_main.csv` überein (Punktschätzer, BC, KI, p).
  - Die Wortwahl bleibt bei „suggestiv“ für RL1 (p = 0,073) und Log-Schuld (p = 0,095).
  - Für keine Schätzung wird Signifikanz behauptet, und alle robusten KIs der Haupttabelle enthalten 0.

## Nicht geprüft
- Text in `proposal/`: Diese Karte schreibt nichts in `proposal/`, deshalb gibt es keinen Abgleich zwischen Paper und Output.
- Ob die Zählungen 7/11/8 (nichtpositives Eigenkapital, mi > te, rl2 > 5) im Panel richtig sind und ob das Flag die richtigen Firmen markiert: Das ist Aufgabe des Data-Reviewers. Ich habe nur geprüft, dass Bericht, Protokoll und CSV dieselben Zahlen enthalten.
- PDF-Abbildungen und die TeX-Kompilierung: nicht angesehen bzw. nicht ausgeführt.
- Byte-Identität und SHA-256: Ich habe keine Befehle ausgeführt.
