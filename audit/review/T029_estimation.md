## Rolle: estimation (claude, opus) – VERDICT: PASS


## Befunde

1. **Hinweis (Kartendesign, kein Umsetzungsfehler, blockiert nicht): In Part C liegt der Klassifikationszeitpunkt innerhalb der Vergleichsfenster.**
   - Die Gruppen `rl1_only` und `rl1_plus` setzen RL1 > 0,70 am 2019-12-31 voraus (`11_mechanism.R` Z. 356–358).
   - Das Placebo-Fenster (Z. 166: 2017-12-31 bis 2019-12-31) und das Pre-Fenster (Z. 366: 2017-06-30 bis 2019-12-31) enthalten genau diesen Stichtag.
   - Für 2019H2 gilt in beiden Gruppen deshalb durch Konstruktion: C = 0, also `share_068_070` = 0, D = −C̃ ≤ 0, und `fail_given_official` ist nicht definiert.
   - Folge: Placebo-D und Pre-Anteil sind leicht nach unten verzerrt, die gruppenspezifischen Kontraste post − placebo und post − pre damit leicht nach oben. Grobe Schätzung für `share_068_070` (`rl1_only`, [0,60; 0,80]): Etwa 18 der 86 Pre-Beobachtungen sind Nullen durch Konstruktion. Ohne sie läge der Pre-Anteil bei etwa 0,059 statt 0,047. Das habe ich nur abgeschätzt, nicht nachgerechnet.
   - In der Differenz der Differenzen hebt sich die Verzerrung teilweise auf, weil beide Gruppen gleich konditioniert sind.
   - Die Umsetzung folgt der Karte (Co-PI-Feedback 1: Placebo „as in Part A“). Ich habe den Punkt in der ersten Prüfung übersehen.
   - Empfehlung an den Co-PI: 2019H2 aus den Vergleichsfenstern von Part C nehmen oder den Punkt in einem Satz der Notiz nennen. Für das Urteil ist das nicht nötig, Part C ist laut Karte deskriptiv.

2. **Alle Estimation-Befunde aus der ersten Runde sind behoben (Belege):**
   - **Anker (früher Befund 1):** Part C verwendet für D und `fail_given_official` jetzt post mit Anker 2019 gegenüber Placebo mit Anker 2016.
     - Code: Z. 400 und 408.
     - Absicherung: `stopifnot` in Z. 446 verhindert Pre-Zeilen für diese Kennzahlen.
     - In `t029_incentive.csv` gibt es keine Pre-Zeilen für diese Kennzahlen mehr. Die Anker-Spalte zeigt `2016-12-31` bzw. `2019_minus_2016`.
   - **Inferenzgrenze (früher Befund 2):**
     - `gate_counts` zählt die Firmen mit endlichem Outcome je Zelle (Z. 413).
     - Bei Einzelstatistiken muss jede Gruppe im selben Zeitraum mindestens 15 Firmen haben (Z. 418), bei Kontrasten jede der vier beteiligten Zellen (Z. 426, 433).
     - Alle `fail_given_official`-Zeilen haben 4–10 Firmen. Sie stehen als `descriptive_small_cell` ohne KI in der CSV und mit „--“ im TeX (z. B. `t029_incentive.tex` Z. 40–61).
   - **Paarung im Bootstrap:** Die Ziehungen der Kontraste und der Differenz der Differenzen werden aus derselben `boot`-Matrix differenziert (Z. 390, 433).
   - **Beispiel:** Differenz der Differenzen für D, [0,60; 0,80]: 0,0996 [−0,112; 0,298] bei 19/18 und 31/29 Firmen. Das stimmt mit der CSV überein.
   - **Part B (früher Befund 3 und Kleinpunkte):**
     - Die Vorperiodenkoeffizienten für MI im Bin 0 ≤ g < 0,10 (−0,0235; −0,0230; −0,0201; −0,0171), die Aussage „not a policy effect“ und „pointwise CIs, no multiple-testing correction“ stehen in `t029_distance_es.tex`.
     - Die Spalte `inference_note` steht in der CSV (Z. 284).
     - Die Spezifikation ist unverändert: Firmen- und Datums-FE, Referenz 2019-12-31 und Bin 1, Cluster nach Firma, t-Verteilung mit G−1 Freiheitsgraden.
   - **Berichtsreihenfolge:**
     - D post 0,11462, Placebo 0,04058, Differenz 0,07403 [0,03100; 0,11823] mit 129/125 Firmen (`t029_compliance.csv` Z. 89, 96, 100).
     - `fail_given_official`-Kontrast 0,1398 [0,0692; 0,2172] mit 79/71 Firmen (Z. 101).
     - Der Bericht gibt diese Werte korrekt wieder.

3. **Part A und Bunching sind unverändert und korrekt aus den Modellobjekten übertragen.**
   - b_official 3,1818 und b_frozen −0,5250, Differenz 3,7068 [1,6048; 6,1403], 999/999 gültige gepaarte Ziehungen (`t029_coverage.txt` Z. 67).
   - Das ist identisch mit der ersten Runde.
   - Die Abbruchbedingung zur Reproduktion von T023 (Z. 59–61) ist weiter aktiv.

## Abnahmekriterien

1. **Gleichheitsprüfung und Reproduktion von b = 3,14: belegt erfüllt (Schätzteil).**
   - Gleichheit: Z. 122–128.
   - Reproduktion: Z. 59–62, b = 3,142854757615.
   - Byte-Gleichheit bestehender Dateien und zweier Läufe: nicht meine Rolle.
2. **Alle Statistiken mit Firmenzahlen, keine Sterne: belegt erfüllt.**
   - Firmenzahlen stehen neben jeder Schätzung, bei Kontrasten zusätzlich die Vergleichszahlen.
   - Für die Differenz der Differenzen stehen alle vier Zellenzahlen in CSV und TeX.
   - Keine Sterne.
3. **Auslegungsregel und Placebo: Schätzteil belegt erfüllt.**
   - Das Placebo ist symmetrisch aufgebaut (Anker 2016 mit 2017H2–2019H2 gegenüber Anker 2019 mit 2020H2–2022H2).
   - Die Auslegungsregel steht vor den Ergebnissen.
   - Ob der Bericht übertreibt: Rolle `consistency`. Aus meiner Sicht übertreibt er nicht. Er nennt das positive Placebo und die Vortrends in Part B ausdrücklich.

## Nicht geprüft

- Keine Befehle ausgeführt. Ich habe nichts nachgerechnet, auch nicht die Größe der Verzerrung in Befund 1; die Angabe ist eine Abschätzung aus den Fallzahlen.
- Byte-Gleichheit und SHA-256-Belege in `t029_verification.txt`: nicht meine Rolle.
- Datenaufbereitung (`panel_firm_halfyear*.csv`, Sprung-Flag) und Erweiterungsabdeckung: Rolle `data`.
- PDFs nur am Code geprüft, nicht visuell.
- Sprache und Formulierung der TeX-Notizen, README, `run_all.*`, `AI_USAGE_LOG.md` und `proposal/` (Diff aus anderen Karten): nicht meine Rolle.
- Die gemeldeten Änderungen außerhalb des Schreibbereichs (`Daten/`, `handcollect/`, Ausgaben von T030) gehören laut Karte zu T032 und T030 und zum Co-PI. Ich habe sie nicht geprüft.
