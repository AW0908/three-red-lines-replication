## Rolle: estimation (claude, opus) – VERDICT: PASS


## Befunde

Keine inhaltlichen Fehler in meiner Rolle (estimation). Rework-Punkt 1 aus `review/T061_estimation.md` ist behoben:

1. **Placebo-Ausschluss jetzt nach T023.** In `replication/code/21_diff_bunching.R:64–69` sind Massenfenster und Fit-Ausschluss jetzt getrennt:
   - `mass_window` umfasst die vier Bins unter dem Schwellenwert.
   - `excluded <- mass_window | (threshold != .70 & regulated_region)` mit `regulated_region` = [0,66; 0,72).

   Das entspricht `06_bunching_tests.R:405–420`: `excluded <- test_window | (is_placebo & regulated_region)`, Masse nur über `mass`.

   Beobachtete Masse, kontrafaktische Masse und Normierung (`sum(mass_window)` = 4) laufen in Z. 77–79 ausschließlich über `mass_window`. Die Formel b = (obs − cf)/(cf/4) ist identisch mit `06_bunching_tests.R:431/436`.

   Die Bin-Zahlen sind zur Laufzeit abgesichert (Z. 69, Z. 360): 4 Bins bei 0,70, 10 Bins bei den Placebos. Die beiden Placebo-Fenster [0,56; 0,60) und [0,76; 0,80) überschneiden sich nicht mit [0,66; 0,72).

2. **Kontraste bei 0,70 inhaltlich unverändert.**
   - Kontrolle bei 0,70: b_pre −0,177, b_post −0,750, Δb −0,574.
   - Drei ΔΔb: 4,594 [2,155; 7,469], 4,480 [1,850; 7,642] und 2,670 [−0,223; 6,354].

   Alle Werte stimmen mit dem vorigen Estimation-Bericht überein. Die Arithmetik passt, z. B. 4,020042 − (−0,573672) = 4,593714 (`t061_diff_bunching.csv`, Z. 2–4).

   Die neue Logik berührt den RNG-Strom nicht: Die Gewichte werden vor `mass()` gezogen (Z. 93, 157), und `mass()` selbst zieht keine Zufallszahlen.

## Abnahmekriterien

1. **Reproduktion, byte-identische Altoutputs, zwei identische Läufe.**
   - Reproduktions-Assertion: belegt erfüllt (Z. 94; `t061_estimates.csv` Z. 5: −0,877 / 3,143 / 4,020).
   - Unabhängige Nachrechnung der sechs Kontrollschätzer mit `hist()/lm()/predict()`: im Code als Gate angelegt (Z. 347–365), PASS laut `t061_validation.txt`. Die Datei wird jetzt über `textout()` vom Kartenbefehl erzeugt.
   - Byte-Identität und Wiederholungslauf: als Guards angelegt (Z. 336–339, 386–393). Selbst ausführen konnte ich sie nicht.
2. **Jede vorab festgelegte Variante mit N, Firmen und Fenstersupport.** Belegt erfüllt für alle 6 Schätzzeilen und 3 Kontraste.
   - Kontrolle: 4.512/752 pre und 3.760/752 post.
   - Support: 207/159 bei 0,70, 324/269 bei 0,60 und 103/88 bei 0,80; kein Low-Support-Flag.
   - Alle Bootstrap-Ziehungen gültig (999/999).
   - Die Placebos sind jetzt korrekt spezifiziert: Δb bei 0,60 = −0,571 [−1,618; 0,364], bei 0,80 = 0,003 [−1,370; 1,316].
   - `t061_results.tex` Z. 7–8, die Tabellennotiz, `t061_interpretation.csv` Schritt 2 und `t061_number_map.csv` (Z. 116378–116379) stimmen mit `t061_estimates.csv` überein.
3. **Provenienz im MANIFEST:** nicht meine Rolle.

## Nicht geprüft

- Ich habe nichts ausgeführt. Ein Lesebefehl für SHA-256-Hashes wurde verweigert. Deshalb habe ich nicht selbst gegengeprüft:
  - die Byte-Identität von `t061_diff_bunching.csv` und der 0,70-Ziehungen gegenüber dem vorigen Kandidaten (Bericht: SHA `20d1397a…`);
  - die Wiederholungsläufe.

  Inhaltlich stimmen die Werte mit dem vorigen Bericht auf allen angezeigten Stellen überein.
- Die Placebo-Ziehungen in `t061_bootstrap_draws.csv` habe ich nicht Zeile für Zeile gelesen; ich habe nur die Zusammenfassungen in `t061_estimates.csv` geprüft.
- Die κ-Schriftgrößen sind nicht meine Rolle. Ich habe nur gesehen, dass `t061_validation.txt` und `t061_interpretation.csv` Schritt 6 übereinstimmen: 9,600000 / 9,627213 pt.
- Datenaufbereitung, MANIFEST, README, `run_all` und Sprache: nicht meine Rolle.
