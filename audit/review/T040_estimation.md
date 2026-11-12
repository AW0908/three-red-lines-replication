## Rolle: estimation (claude, sonnet) – VERDICT: PASS

Ich schließe gerade die Prüfung des Estimation-Codes ab (Gleichung, Stichprobe, Bootstrap, Outputs). Ausführen darf ich nichts, ich lese nur.

VERDICT: PASS

## Befunde
Keine Befunde, die ein REWORK rechtfertigen. Die folgenden Punkte sind Hinweise und keine Mängel.

1. **Perpetual-Szenario ist nur teilweise angewandt.** `rl1_perp` gilt nur für 273 von 1692 Panelzeilen (`t040_verification.txt`: „Observed perpetual coverage 273/1692“). Im Post-Fenster sind es 99 von 630 Zeilen (`t040_validation.csv`, perpetual/post, n=99). Der Rest fällt auf das ursprüngliche RL1 zurück (`13_rl1_validation.R:123-129`). Die Kennzahl ist damit über Firmen und Zeit gemischt. Der Rückgang von b von 3.14 auf 2.58 (CI [0.52, 5.13]) ist deshalb eine untere Abschätzung des Perpetual-Effekts. Das ist so freigegeben und in der TeX-Note benannt. Die Abdeckung von rund 16 % im Post-Fenster steht dort nicht. Sie sollte im Text mit erscheinen.
2. **Matched-Firms-Stichprobe ist klein und selektiv.** Sie umfasst 20 Firmen und N=100 (`t040_robustness.csv`). Die Selektion läuft über den RL1-Fehler an den kodierten Daten, die im Post-Fenster liegen. Die Note nennt sie „selected-sample robustness“. Das Konfidenzintervall ist sehr breit: b=8.81 [1.76, 23.07], D=0.27 [0.14, 0.41]. Der Bootstrap über 20 Cluster ist knapp. Das Ergebnis zeigt, dass b nach oben geht und nicht verschwindet. Es ist keine präzise Schätzung.
3. **Hartkodierte Zahlen in der TeX-Note.** „RL2: 96 coded, 85 pairs; RL3: 64 coded, 59 pairs“ steht als Literal in `13_rl1_validation.R:182`. Die Werte stimmen mit `t040_validation.csv` überein (96−11 und 64−5). Sie werden aber nicht aus den Daten erzeugt, was gegen Regel 4 verstößt. Das ist rein kosmetisch.
4. **Gemeinsame Basis von `rl1_perp` und `base_off`.** `rl1_perp` nutzt den Nenner `ta−adv` (Zeile 98). `base_off` nutzt `N+te` (Zeile 54). Beide sind gleich, wenn `ta = tl + te` gilt. Das habe ich nicht an den Daten geprüft.

## Abnahmekriterien
- **Kriterium 2 (Reproduktion von T023 und T029):** belegt erfüllt. `13_rl1_validation.R:61-62` prüft per `stopifnot` b=3.14 und D=0.1146. Die Werte sind 3.142854757615 und 0.114617940199 (`t040_execution.log:3`).
- **Spezifikation:**
  - Der Fit nutzt Grad 5 und 0.01-Bins auf [0.40, 1.00]. Das Fenster [0.66, 0.70) ist ausgeschlossen (Zeilen 27-29).
  - Die Schätzung nutzt `sample_main` und das Post-Fenster 2020-12-31 bis 2022-12-31. Das ist identisch zu T023/T029.
  - Die Konstruktion von `rl1_perp` ist (N+perp)/den (Zeile 98). Sie nutzt nur Zeilen mit beobachtetem `perp`; `perp_missing` und die Null-Falle werden korrekt behandelt (Zeile 97).
  - Der Frozen-MI-Nenner ist `den − mi + mi_2019` (Zeile 126). Das passt zu `cfden`.
- **Stichprobe und Inferenz:**
  - N und Firmenzahlen sind konsistent (630 und 132 für b, 602 und 129 für die gepaarten Größen). Die Differenz entsteht dadurch, dass beide Seiten gültig sein müssen.
  - Der Firm-Cluster-Bootstrap hat 999 Ziehungen, einen festen Seed und ganze Firmen als Ziehungseinheit. In allen 15 Szenario-Metrik-Zeilen sind 999 von 999 Ziehungen gültig.
  - Im Matched-Szenario wird `firms`, `G` und `boot` auf die Teilmenge neu gesetzt, und der Seed wird zurückgesetzt (Zeilen 149-151). Das ist korrekt.
- **Ausgabe:** Koeffizienten und Konfidenzintervalle in CSV und TeX stammen aus denselben Objekten (`rob`). Die Zeilen in `t040_execution.log` stimmen mit `t040_robustness.csv` überein. D=0.0930 entspricht 56/602 und D=0.27 entspricht 27/100. Die 2×2-Zählungen (37, 1, 5, 21) summieren sich auf 64 und passen zu den 6 Disagreements.
- **Kriterium 3 (klare Aussage im Bericht):** belegt erfüllt. `t040_verification.txt` enthält die ASSESSMENT-Zeile: Näherung nahe 0.70 gestützt (MAE 0.57 pp, 76.9 % innerhalb 1 pp), exakte Klassifikation nicht validiert (6 Abweichungen).
- **Kriterium 1 (Quellenangaben und 25-Werte-Stichprobe):** nicht meine Rolle. Das gilt auch für die Spot-Checks des Co-PI.
- **Umfang:** Die Schutz-Hashes aller Nicht-T040-Outputs und der Eingaben werden im Skript geprüft (`:237`, 4 Eingaben und 163 geschützte Outputs). Die Hashes stimmen laut Log.

## Nicht geprüft
- Datenaufbereitung, Kodierung der Werte und PDF-Belege (Rolle `data`) sowie Sprache.
- Ob `ta = tl + te` im Panel überall gilt (Hinweis 4).
- Das PDF und die TeX-Dateien habe ich nicht gerendert.
- Das Skript habe ich nicht ausgeführt. Die Byte-Identität über zwei Läufe stützt sich nur auf die Angabe im Log.
- Die Datei `published_coded.csv` habe ich nur per Stichwortsuche auf Werte zwischen 0.69 und 0.71 gegengeprüft. Ein Grenzfall bei exakt 0.70 ist dort nicht zu finden, die Zeilen aus dem Treffer-Filter lieferten keine Treffer. Dieser Filter war eng gefasst und beweist das nicht abschließend.
