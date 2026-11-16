## Rolle: estimation (claude, sonnet) – VERDICT: PASS

Ich schließe gerade die Prüfung des Estimation-Codes ab (Gleichung, Stichprobe, Bootstrap, Outputs). Ausführen darf ich nichts, ich lese nur.

VERDICT: PASS

## Befunde
Keine Befunde, die ein REWORK rechtfertigen. Die folgenden Punkte sind Hinweise und keine Mängel.

[number withheld]. **Perpetual-Szenario ist nur teilweise angewandt.** `rl1_perp` gilt nur für [number withheld] von [number withheld] Panelzeilen (`t040_verification.txt`: „Observed perpetual coverage [number withheld]/[number withheld]“). Im Post-Fenster sind es [number withheld] von [number withheld] Zeilen (`t040_validation.csv`, perpetual/post, n=[number withheld]). Der Rest fällt auf das ursprüngliche RL1 zurück (`13_rl1_validation.R:123-129`). Die Kennzahl ist damit über Firmen und Zeit gemischt. Der Rückgang von b von [number withheld] auf [number withheld] (CI [[number withheld], [number withheld]]) ist deshalb eine untere Abschätzung des Perpetual-Effekts. Das ist so freigegeben und in der TeX-Note benannt. Die Abdeckung von rund [number withheld] % im Post-Fenster steht dort nicht. Sie sollte im Text mit erscheinen.
[number withheld]. **Matched-Firms-Stichprobe ist klein und selektiv.** Sie umfasst [number withheld] Firmen und N=[number withheld] (`t040_robustness.csv`). Die Selektion läuft über den RL1-Fehler an den kodierten Daten, die im Post-Fenster liegen. Die Note nennt sie „selected-sample robustness“. Das Konfidenzintervall ist sehr breit: b=[number withheld] [[number withheld], [number withheld]], D=[number withheld] [[number withheld], [number withheld]]. Der Bootstrap über [number withheld] Cluster ist knapp. Das Ergebnis zeigt, dass b nach oben geht und nicht verschwindet. Es ist keine präzise Schätzung.
[number withheld]. **Hartkodierte Zahlen in der TeX-Note.** „RL2: [number withheld] coded, [number withheld] pairs; RL3: [number withheld] coded, [number withheld] pairs“ steht als Literal in `13_rl1_validation.R:182`. Die Werte stimmen mit `t040_validation.csv` überein ([number withheld][number withheld] und [number withheld][number withheld]). Sie werden aber nicht aus den Daten erzeugt, was gegen Regel [number withheld] verstößt. Das ist rein kosmetisch.
[number withheld]. **Gemeinsame Basis von `rl1_perp` und `base_off`.** `rl1_perp` nutzt den Nenner `ta−adv` (Zeile [number withheld]). `base_off` nutzt `N+te` (Zeile [number withheld]). Beide sind gleich, wenn `ta = tl + te` gilt. Das habe ich nicht an den Daten geprüft.

## Abnahmekriterien
- **Kriterium [number withheld] (Reproduktion von T023 und T029):** belegt erfüllt. `13_rl1_validation.R:61-62` prüft per `stopifnot` b=[number withheld] und D=[number withheld]. Die Werte sind [number withheld] und [number withheld] (`t040_execution.log:3`).
- **Spezifikation:**
  - Der Fit nutzt Grad [number withheld] und [number withheld]-Bins auf [[number withheld], [number withheld]]. Das Fenster [[number withheld], [number withheld]) ist ausgeschlossen (Zeilen [number withheld][number withheld]).
  - Die Schätzung nutzt `sample_main` und das Post-Fenster 2020-12-31 bis 2022-12-31. Das ist identisch zu T023/T029.
  - Die Konstruktion von `rl1_perp` ist (N+perp)/den (Zeile [number withheld]). Sie nutzt nur Zeilen mit beobachtetem `perp`; `perp_missing` und die Null-Falle werden korrekt behandelt (Zeile [number withheld]).
  - Der Frozen-MI-Nenner ist `den − mi + mi_2[number withheld]` (Zeile [number withheld]). Das passt zu `cfden`.
- **Stichprobe und Inferenz:**
  - N und Firmenzahlen sind konsistent ([number withheld] und [number withheld] für b, [number withheld] und [number withheld] für die gepaarten Größen). Die Differenz entsteht dadurch, dass beide Seiten gültig sein müssen.
  - Der Firm-Cluster-Bootstrap hat [number withheld] Ziehungen, einen festen Seed und ganze Firmen als Ziehungseinheit. In allen [number withheld] Szenario-Metrik-Zeilen sind [number withheld] von [number withheld] Ziehungen gültig.
  - Im Matched-Szenario wird `firms`, `G` und `boot` auf die Teilmenge neu gesetzt, und der Seed wird zurückgesetzt (Zeilen [number withheld][number withheld]). Das ist korrekt.
- **Ausgabe:** Koeffizienten und Konfidenzintervalle in CSV und TeX stammen aus denselben Objekten (`rob`). Die Zeilen in `t040_execution.log` stimmen mit `t040_robustness.csv` überein. D=[number withheld] entspricht [number withheld]/[number withheld] und D=[number withheld] entspricht [number withheld]/[number withheld]. Die [number withheld]×[number withheld]-Zählungen ([number withheld], [number withheld], [number withheld], [number withheld]) summieren sich auf [number withheld] und passen zu den [number withheld] Disagreements.
- **Kriterium [number withheld] (klare Aussage im Bericht):** belegt erfüllt. `t040_verification.txt` enthält die ASSESSMENT-Zeile: Näherung nahe [number withheld] gestützt (MAE [number withheld] pp, [number withheld] % innerhalb [number withheld] pp), exakte Klassifikation nicht validiert ([number withheld] Abweichungen).
- **Kriterium [number withheld] (Quellenangaben und [number withheld]-Werte-Stichprobe):** nicht meine Rolle. Das gilt auch für die Spot-Checks des Co-PI.
- **Umfang:** Die Schutz-Hashes aller Nicht-T040-Outputs und der Eingaben werden im Skript geprüft (`:[number withheld]`, [number withheld] Eingaben und [number withheld] geschützte Outputs). Die Hashes stimmen laut Log.

## Nicht geprüft
- Datenaufbereitung, Kodierung der Werte und PDF-Belege (Rolle `data`) sowie Sprache.
- Ob `ta = tl + te` im Panel überall gilt (Hinweis [number withheld]).
- Das PDF und die TeX-Dateien habe ich nicht gerendert.
- Das Skript habe ich nicht ausgeführt. Die Byte-Identität über zwei Läufe stützt sich nur auf die Angabe im Log.
- Die Datei `published_coded.csv` habe ich nur per Stichwortsuche auf Werte zwischen [number withheld] und [number withheld] gegengeprüft. Ein Grenzfall bei exakt [number withheld] ist dort nicht zu finden, die Zeilen aus dem Treffer-Filter lieferten keine Treffer. Dieser Filter war eng gefasst und beweist das nicht abschließend.
