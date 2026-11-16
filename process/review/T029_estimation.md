## Rolle: estimation (claude, opus) – VERDICT: PASS


## Befunde

[number withheld]. **Hinweis (Kartendesign, kein Umsetzungsfehler, blockiert nicht): In Part C liegt der Klassifikationszeitpunkt innerhalb der Vergleichsfenster.**
   - Die Gruppen `rl1_only` und `rl1_plus` setzen RL1 > [number withheld] am 2019-12-31 voraus (`11_mechanism.R` Z. [number withheld]–[number withheld]).
   - Das Placebo-Fenster (Z. [number withheld]: 2017-12-31 bis 2019-12-31) und das Pre-Fenster (Z. [number withheld]: 2017-06-30 bis 2019-12-31) enthalten genau diesen Stichtag.
   - Für [number withheld]H2 gilt in beiden Gruppen deshalb durch Konstruktion: C = [number withheld], also `share_0[number withheld]_0[number withheld]` = [number withheld], D = −C̃ ≤ [number withheld], und `fail_given_official` ist nicht definiert.
   - Folge: Placebo-D und Pre-Anteil sind leicht nach unten verzerrt, die gruppenspezifischen Kontraste post − placebo und post − pre damit leicht nach oben. Grobe Schätzung für `share_0[number withheld]_0[number withheld]` (`rl1_only`, [[number withheld]; [number withheld]]): Etwa [number withheld] der [number withheld] Pre-Beobachtungen sind Nullen durch Konstruktion. Ohne sie läge der Pre-Anteil bei etwa [number withheld] statt [number withheld]. Das habe ich nur abgeschätzt, nicht nachgerechnet.
   - In der Differenz der Differenzen hebt sich die Verzerrung teilweise auf, weil beide Gruppen gleich konditioniert sind.
   - Die Umsetzung folgt der Karte (Co-PI-Feedback [number withheld]: Placebo „as in Part A“). Ich habe den Punkt in der ersten Prüfung übersehen.
   - Empfehlung an den Co-PI: [number withheld]H2 aus den Vergleichsfenstern von Part C nehmen oder den Punkt in einem Satz der Notiz nennen. Für das Urteil ist das nicht nötig, Part C ist laut Karte deskriptiv.

[number withheld]. **Alle Estimation-Befunde aus der ersten Runde sind behoben (Belege):**
   - **Anker (früher Befund [number withheld]):** Part C verwendet für D und `fail_given_official` jetzt post mit Anker [number withheld] gegenüber Placebo mit Anker [number withheld].
     - Code: Z. [number withheld] und [number withheld].
     - Absicherung: `stopifnot` in Z. [number withheld] verhindert Pre-Zeilen für diese Kennzahlen.
     - In `t029_incentive.csv` gibt es keine Pre-Zeilen für diese Kennzahlen mehr. Die Anker-Spalte zeigt `2016-12-31` bzw. `[number withheld]_minus_2[number withheld]`.
   - **Inferenzgrenze (früher Befund [number withheld]):**
     - `gate_counts` zählt die Firmen mit endlichem Outcome je Zelle (Z. [number withheld]).
     - Bei Einzelstatistiken muss jede Gruppe im selben Zeitraum mindestens [number withheld] Firmen haben (Z. [number withheld]), bei Kontrasten jede der vier beteiligten Zellen (Z. [number withheld], [number withheld]).
     - Alle `fail_given_official`-Zeilen haben [number withheld]–[number withheld] Firmen. Sie stehen als `descriptive_small_cell` ohne KI in der CSV und mit „--“ im TeX (z. B. `t029_incentive.tex` Z. [number withheld]–[number withheld]).
   - **Paarung im Bootstrap:** Die Ziehungen der Kontraste und der Differenz der Differenzen werden aus derselben `boot`-Matrix differenziert (Z. [number withheld], [number withheld]).
   - **Beispiel:** Differenz der Differenzen für D, [[number withheld]; [number withheld]]: [number withheld] [[number withheld]; [number withheld]] bei [number withheld]/[number withheld] und [number withheld]/[number withheld] Firmen. Das stimmt mit der CSV überein.
   - **Part B (früher Befund [number withheld] und Kleinpunkte):**
     - Die Vorperiodenkoeffizienten für MI im Bin [number withheld] ≤ g < [number withheld] ([number withheld]; [number withheld]; [number withheld]; [number withheld]), die Aussage „not a policy effect“ und „pointwise CIs, no multiple-testing correction“ stehen in `t029_distance_es.tex`.
     - Die Spalte `inference_note` steht in der CSV (Z. [number withheld]).
     - Die Spezifikation ist unverändert: Firmen- und Datums-FE, Referenz 2019-12-31 und Bin [number withheld], Cluster nach Firma, t-Verteilung mit G−[number withheld] Freiheitsgraden.
   - **Berichtsreihenfolge:**
     - D post [number withheld], Placebo [number withheld], Differenz [number withheld] [[number withheld]; [number withheld]] mit [number withheld]/[number withheld] Firmen (`t029_compliance.csv` Z. [number withheld], [number withheld], [number withheld]).
     - `fail_given_official`-Kontrast [number withheld] [[number withheld]; [number withheld]] mit [number withheld]/[number withheld] Firmen (Z. [number withheld]).
     - Der Bericht gibt diese Werte korrekt wieder.

[number withheld]. **Part A und Bunching sind unverändert und korrekt aus den Modellobjekten übertragen.**
   - b_official [number withheld] und b_frozen [number withheld], Differenz [number withheld] [[number withheld]; [number withheld]], [number withheld]/[number withheld] gültige gepaarte Ziehungen (`t029_coverage.txt` Z. [number withheld]).
   - Das ist identisch mit der ersten Runde.
   - Die Abbruchbedingung zur Reproduktion von T023 (Z. [number withheld]–[number withheld]) ist weiter aktiv.

## Abnahmekriterien

[number withheld]. **Gleichheitsprüfung und Reproduktion von b = [number withheld]: belegt erfüllt (Schätzteil).**
   - Gleichheit: Z. [number withheld]–[number withheld].
   - Reproduktion: Z. [number withheld]–[number withheld], b = [number withheld].
   - Byte-Gleichheit bestehender Dateien und zweier Läufe: nicht meine Rolle.
[number withheld]. **Alle Statistiken mit Firmenzahlen, keine Sterne: belegt erfüllt.**
   - Firmenzahlen stehen neben jeder Schätzung, bei Kontrasten zusätzlich die Vergleichszahlen.
   - Für die Differenz der Differenzen stehen alle vier Zellenzahlen in CSV und TeX.
   - Keine Sterne.
[number withheld]. **Auslegungsregel und Placebo: Schätzteil belegt erfüllt.**
   - Das Placebo ist symmetrisch aufgebaut (Anker [number withheld] mit [number withheld]H2–[number withheld]H2 gegenüber Anker [number withheld] mit [number withheld]H2–[number withheld]H2).
   - Die Auslegungsregel steht vor den Ergebnissen.
   - Ob der Bericht übertreibt: Rolle `consistency`. Aus meiner Sicht übertreibt er nicht. Er nennt das positive Placebo und die Vortrends in Part B ausdrücklich.

## Nicht geprüft

- Keine Befehle ausgeführt. Ich habe nichts nachgerechnet, auch nicht die Größe der Verzerrung in Befund [number withheld]; die Angabe ist eine Abschätzung aus den Fallzahlen.
- Byte-Gleichheit und SHA-[number withheld]-Belege in `t029_verification.txt`: nicht meine Rolle.
- Datenaufbereitung (`panel_firm_halfyear*.csv`, Sprung-Flag) und Erweiterungsabdeckung: Rolle `data`.
- PDFs nur am Code geprüft, nicht visuell.
- Sprache und Formulierung der TeX-Notizen, README, `run_all.*`, `AI_USAGE_LOG.md` und `proposal/` (Diff aus anderen Karten): nicht meine Rolle.
- Die gemeldeten Änderungen außerhalb des Schreibbereichs (`Daten/`, `handcollect/`, Ausgaben von T030) gehören laut Karte zu T032 und T030 und zum Co-PI. Ich habe sie nicht geprüft.
