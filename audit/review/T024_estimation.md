## Rolle: estimation (claude, opus) – VERDICT: PASS


## Befunde
[number withheld]. **(Kein Mangel, nur Hinweis.) Die Ausschlussvariante wählt Firmen nach Werten aus der Zeit nach der Maßnahme aus.** Eine Firma gilt als Problemfall, wenn sie zu einem Stichtag nach der Maßnahme te ≤ [number withheld], mi > te oder rl2 > [number withheld] aufweist (`07_rd.R:70–73`). Das sind Bilanzen von [number withheld]H2–[number withheld]H2, also aus demselben Zeitraum wie die Outcomes. Die beiden neuen Zeilen schätzen damit auf einer Stichprobe, die von der Behandlung beeinflusst sein kann. Sie sind kein ITT für eine vorab festgelegte Population. Die Karte (Runde [number withheld], Punkt [number withheld]) hat diese Variante ausdrücklich freigegeben. Sie steht nur in `t024_rd_robustness.csv`, und der Worker-Bericht nennt sie „Sensitivitätsprüfungen anhand von Post-Bilanzen“. Die Notiz in der CSV sagt „any post te <= [number withheld] …“, nennt die Selektion nach der Maßnahme aber nicht ausdrücklich. Für die Interpretation im Text sollte das stehen. Das Urteil ändert sich dadurch nicht.

## Abnahmekriterien
Für meine Rolle sind nur die Auflagen der Runde [number withheld] (Schätzungen) neu. Alle übrigen Schätzpunkte hatten in Runde [number withheld] bereits PASS. Laut Prüfprotokoll sind sie byte-identisch (`t024_verification.txt:2912–2930`: [number withheld] alte Robustheitszeilen identisch).

- **Runde [number withheld] / [number withheld]: zwei Robustheitszeilen (sharp, h = [number withheld], ohne markierte Firmen) – belegt erfüllt.**
  - Spezifikation: `fit_rd(..., h = [number withheld])` setzt b = h, lokal linear, Dreieckskern, robust bias-korrigiert (`07_rd.R:87–94, 168`).
  - In der CSV (Zeilen [number withheld]–[number withheld]) stehen p = [number withheld], q = [number withheld], h = b = [number withheld]. Koeffizient, BC-Schätzer, SE, KI, z und p werden aus `coef[[number withheld]]`, `coef[[number withheld]]`, `se[[number withheld]]`, `ci[[number withheld],]`, `z[[number withheld]]` und `pv[[number withheld]]` übernommen, also aus den richtigen Zeilen.
  - Fallzahlen stimmen: RL2 hat N_eff [number withheld]/[number withheld] gegenüber [number withheld]/[number withheld] in der Hauptschätzung, mi_share [number withheld]/[number withheld] gegenüber [number withheld]/[number withheld]. Die Differenz von [number withheld] links und [number withheld] rechts entspricht genau den markierten Firmen innerhalb ±[number withheld], die die Notiz nennt.
  - base_N [number withheld]/[number withheld] ergibt [number withheld] Firmen, also [number withheld] − [number withheld] markierte. Die `stopifnot`-Prüfungen der Bilanz von Fallzahlen und Ausschlüssen (`07_rd.R:181–182`) greifen.
  - Die MSE-Prüfung mit [number withheld]/[number withheld] bzw. [number withheld]/[number withheld] Firmen liegt über der Mindestzahl von [number withheld] je Seite. Eine unabhängige Nachrechnung ergibt dieselben Werte (`t024_verification.txt:2931–2932`).
  - Die Hauptschätzung bleibt unverändert: `t024_rd_main.tex` zeigt dieselben sechs Sharp-Zeilen wie im Bericht.
- **Runde [number withheld] / [number withheld]: Tabellennotizen – belegt erfüllt** (`07_rd.R:329–330`). Beide Sätze stehen in `t024_rd_main.tex`, und `t024_rd_fuzzy.tex` übernimmt sie über `common_notes`.
- **Runde [number withheld] / [number withheld]: Fallzahlen per sprintf – belegt erfüllt** (`07_rd.R:183–187`).
- **Kriterium [number withheld]: Reproduzierbarkeit – soweit belegbar erfüllt.** Fester Seed, die neuen Zeilen haben keine Zufallskomponente. Laut Protokoll sind beide Läufe byte-identisch. Die Läufe selbst konnte ich nicht nachvollziehen.
- **Kriterien [number withheld], [number withheld], [number withheld] und Runde [number withheld] / [number withheld] (Firmenaudit):** nicht meine Rolle (data/consistency). Die Auditspalten verwende ich nur als Eingabe für den Ausschluss.

## Nicht geprüft
- Eigene Läufe von `rdrobust` oder `Rscript` habe ich nicht durchgeführt. Ich prüfe nur lesend, und Shell-Zugriff war gesperrt. Die Übereinstimmung mit den Modellobjekten beruht auf dem Code und auf der unabhängigen Nachrechnung im Prüfprotokoll.
- Die Richtigkeit der Flag-Berechnung auf Firmenebene (Datenaufbereitung) gehört zur Data-Rolle.
- Abbildungen und Kompilierung der TEX-Dateien habe ich nicht geprüft.
