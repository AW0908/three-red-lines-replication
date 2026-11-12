## Rolle: estimation (claude, opus) – VERDICT: PASS


## Befunde
1. **(Kein Mangel, nur Hinweis.) Die Ausschlussvariante wählt Firmen nach Werten aus der Zeit nach der Maßnahme aus.** Eine Firma gilt als Problemfall, wenn sie zu einem Stichtag nach der Maßnahme te ≤ 0, mi > te oder rl2 > 5 aufweist (`07_rd.R:70–73`). Das sind Bilanzen von 2020H2–2022H2, also aus demselben Zeitraum wie die Outcomes. Die beiden neuen Zeilen schätzen damit auf einer Stichprobe, die von der Behandlung beeinflusst sein kann. Sie sind kein ITT für eine vorab festgelegte Population. Die Karte (Runde 4, Punkt 2) hat diese Variante ausdrücklich freigegeben. Sie steht nur in `t024_rd_robustness.csv`, und der Worker-Bericht nennt sie „Sensitivitätsprüfungen anhand von Post-Bilanzen“. Die Notiz in der CSV sagt „any post te <= 0 …“, nennt die Selektion nach der Maßnahme aber nicht ausdrücklich. Für die Interpretation im Text sollte das stehen. Das Urteil ändert sich dadurch nicht.

## Abnahmekriterien
Für meine Rolle sind nur die Auflagen der Runde 4 (Schätzungen) neu. Alle übrigen Schätzpunkte hatten in Runde 3 bereits PASS. Laut Prüfprotokoll sind sie byte-identisch (`t024_verification.txt:2912–2930`: 60 alte Robustheitszeilen identisch).

- **Runde 4 / 2: zwei Robustheitszeilen (sharp, h = 0,10, ohne markierte Firmen) – belegt erfüllt.**
  - Spezifikation: `fit_rd(..., h = 0.10)` setzt b = h, lokal linear, Dreieckskern, robust bias-korrigiert (`07_rd.R:87–94, 168`).
  - In der CSV (Zeilen 62–63) stehen p = 1, q = 2, h = b = 0,1. Koeffizient, BC-Schätzer, SE, KI, z und p werden aus `coef[1,1]`, `coef[3,1]`, `se[3,1]`, `ci[3,]`, `z[3,1]` und `pv[3,1]` übernommen, also aus den richtigen Zeilen.
  - Fallzahlen stimmen: RL2 hat N_eff 26/37 gegenüber 26/41 in der Hauptschätzung, mi_share 28/40 gegenüber 28/44. Die Differenz von 0 links und 4 rechts entspricht genau den markierten Firmen innerhalb ±0,10, die die Notiz nennt.
  - base_N 63/58 ergibt 121 Firmen, also 135 − 14 markierte. Die `stopifnot`-Prüfungen der Bilanz von Fallzahlen und Ausschlüssen (`07_rd.R:181–182`) greifen.
  - Die MSE-Prüfung mit 16/27 bzw. 17/32 Firmen liegt über der Mindestzahl von 10 je Seite. Eine unabhängige Nachrechnung ergibt dieselben Werte (`t024_verification.txt:2931–2932`).
  - Die Hauptschätzung bleibt unverändert: `t024_rd_main.tex` zeigt dieselben sechs Sharp-Zeilen wie im Bericht.
- **Runde 4 / 3: Tabellennotizen – belegt erfüllt** (`07_rd.R:329–330`). Beide Sätze stehen in `t024_rd_main.tex`, und `t024_rd_fuzzy.tex` übernimmt sie über `common_notes`.
- **Runde 4 / 4: Fallzahlen per sprintf – belegt erfüllt** (`07_rd.R:183–187`).
- **Kriterium 2: Reproduzierbarkeit – soweit belegbar erfüllt.** Fester Seed, die neuen Zeilen haben keine Zufallskomponente. Laut Protokoll sind beide Läufe byte-identisch. Die Läufe selbst konnte ich nicht nachvollziehen.
- **Kriterien 1, 3, 4 und Runde 4 / 1 (Firmenaudit):** nicht meine Rolle (data/consistency). Die Auditspalten verwende ich nur als Eingabe für den Ausschluss.

## Nicht geprüft
- Eigene Läufe von `rdrobust` oder `Rscript` habe ich nicht durchgeführt. Ich prüfe nur lesend, und Shell-Zugriff war gesperrt. Die Übereinstimmung mit den Modellobjekten beruht auf dem Code und auf der unabhängigen Nachrechnung im Prüfprotokoll.
- Die Richtigkeit der Flag-Berechnung auf Firmenebene (Datenaufbereitung) gehört zur Data-Rolle.
- Abbildungen und Kompilierung der TEX-Dateien habe ich nicht geprüft.
