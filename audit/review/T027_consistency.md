## Rolle: consistency (claude, opus) – VERDICT: PASS

Prüfung abgeschlossen. Mein Urteil als Consistency-Reviewer ist PASS; die drei Hinweise unten ändern das Urteil nicht.

VERDICT: PASS

## Befunde

Text, Outputs und CSVs widersprechen sich nirgends. Alle vier Punkte aus dem vorigen REWORK der Rolle consistency sind behoben. Drei kleine Hinweise, keiner ändert eine Zahl:

1. **In `t027_tests.tex` ist unklar, worauf sich „For this contrast“ bezieht.** Der Satz kommt direkt nach dem allgemeinen Satz „All equity-change shares require nonzero equity changes. CSV reports coverage and valid draws.“ (`08_decomposition.R:401–402`). Seit es drei Anteils-Kontraste gibt, ist nicht eindeutig, welcher Kontrast gemeint ist. Gemeint ist der Perp-Kontrast (Zeile 4: 2 Pre-Ereignisse, 1 Firma, 634 von 999 Ziehungen gültig, laut `t027_tests.csv` Z. 5). Die Zeilenbeschriftung „conditional/unreliable“ löst die Frage zwar auf. Besser wäre trotzdem „For the minority plus perpetual share contrast, …“.
   - Verwandt: Der Satz in Z. 398 („the minority plus perpetual equity-change share use medians“) ist nicht mehr vollständig, weil auch die Mittelwert-Zeile des Minority-Kontrasts dazugekommen ist. Der folgende Satz ergänzt das aber.
2. **Zwei Zahlen sind von Hand eingetippt statt berechnet.**
   - Die Note der RL1-Pre-Tabelle sagt „2 events from 1 firm“ (`08_decomposition.R:380`).
   - Die Bildnote der Abbildung sagt „(2 events, 1 firm)“ (Z. 452).
   - Beide stimmen derzeit mit `t027_events.csv` Z. 3 überein (2, 1). Sie würden aber bei geänderten Daten nicht mitwandern (Arbeitsregel 4).
   - Die Tests-Note zieht dieselben Zahlen dagegen per `sprintf` aus `tests` (Z. 402–403).
3. **Den Captions fehlt ein Trennzeichen.**
   - RL1: „Accounting decomposition of RL1 post crossings Change in logit(RL1) = …“; zwischen „crossings“ und „Change“ fehlt ein Punkt (Z. 382–383).
   - RL2: Die Captions enden mit einem überflüssigen Leerzeichen.
   - Das ist eine Frage der Lesbarkeit, kein Widerspruch; die Rolle language prüft das genauer.

## Abnahmekriterien

**1. Identitätsprüfungen und Komponentensummen:** Die Richtigkeit gehört nicht zu meiner Rolle. Die Konsistenz ist belegt:
- `t027_identity_checks.txt` ist in sich stimmig: 0 Verletzungen; RL1: 335 Ereignisse, davon 15 ungültig; RL2: 64 Ereignisse, Zähler jetzt `ibd-cash` mit Positivitätsbedingung.
- Die Werte passen zu `n_missing` in `t027_decomposition_rl1.csv` (Stayer 281 → 266/73).
- Der RL2-Zähler ist im Code richtig auf Nettoschuld umgestellt (`08_decomposition.R:149–152`). Die CSV-Interpretation von `dln_n` ist bei RL2 entsprechend korrigiert (rl2.csv Z. 7, 22, 41, 56).
- Die Medianwerte decken sich mit dem Worker-Bericht (−0,1478 / −0,2197).

**2. Reproduzierbarkeit und byte-identische Outputs:** Nicht meine Rolle.

**3. Interpretation real vs. kosmetisch, deskriptive Kennzeichnung, Annahmen-Klausel:** Belegt erfüllt, soweit es meine Rolle betrifft.
- **Einheiten:** Alle drei RL1-Captions und Notes, die Tests-Caption und -Note sowie die Abbildung nennen „Change in logit(RL1) = Δln N − Δln te; all components in log-odds units“.
- **Prozentpunkt-Übersetzung:** Sie wird im Code berechnet (Z. 323–326). Nachgerechnet: 0,21 × (−0,16203) = −0,0340, also −3,40 pp, wie angegeben.
- **CSV:** `reported_total` lautet bei RL1 „logit change of the stored ratio“ (Z. 3, 18, 37, 52, 71, 86). Bei RL2 bleibt richtigerweise „Stored ratio change“.
- **Annahmen-Klausel:** Sie steht in allen Notes, in der Abbildung und im README.
- **Signifikanz:** Nirgends wird eine behauptet. Es gibt keine Sterne, und alle 7 Intervalle schließen 0 ein; das stimmt mit der CSV überein.
- **Zahlen in den TEX-Tabellen:** Ich habe jede Zelle von `t027_decomposition_rl1.tex` (3 Floats), `t027_decomposition_rl2.tex` (2 Floats) und `t027_tests.tex` (7 Zeilen) gegen die CSV geprüft. Werte, Rundung auf 4 Stellen, Vorzeichen, N und Firmen stimmen alle.
  - „−0.0000“ ist behoben (rl2.tex Z. 22: 0.0000).
  - Binäre Mediane erscheinen als „--“.
- **Neue Kontraste:** median 0,3687 [−0,1097; 0,7470] und mean 0,1460 [−0,4220; 0,7658]. N = 32 vs. 21; 1 fehlende Post-Beobachtung, entsprechend 33 − 32. Alles stimmt mit `t027_tests.csv` Z. 7–8 und rl1.csv Z. 16/50 überein; die Differenz 0,54499 − 0,17631 habe ich nachgerechnet.
- **Abbildung:** Die Stapel entsprechen den All-Events-Medianen der CSV.
  - Post: −0,0185 / −0,0068 / −0,0404 / −0,0365; der Stapel endet bei ≈ −0,102.
  - Pre: −0,0104 / −0,0156 / −0,0872 / −0,0076; Ende ≈ −0,121.
  - Stayer: −0,0129 / +0,0137 / +0,0089 / −0,0002.
  - Die Rauten (Mediantotal) liegen bei −0,162 / −0,218 / 0,011.
  - Die Fallzahlen 33/31, 21/19 und 281/74 entsprechen `t027_events.csv`. Die Abdeckung (33/33/32/32; 21/…; 266/…) stimmt mit `n_available` überein.
  - Die Perp-Teilstichprobe ist aus der Abbildung entfernt und als nicht interpretierbar gekennzeichnet.
- **Worker-Bericht:** Alle Zahlen habe ich in den Dateien wiedergefunden, darunter die RL1-Statistiktabelle, 11/33 (`ibd_rising` 0,3333 × 33), die Kontraste und die Fallzahlen.
- **README:** Z. 462–523 stimmt mit Code und Outputs überein: 7 Kontraste, 32/21, 90-%-Schwelle für gültige Ziehungen (634/999 ≈ 63 % → als unzuverlässig gekennzeichnet).

**4. N je Zelle:** Belegt erfüllt. `t027_events.csv` (33/31, 21/19, 281/74, 28/27, 36/30; Perp-Teilstichproben 10/10, 2/1, 42/16, 7/7, 5/4) stimmt mit `n_events`/`n_firms` in allen CSVs, den TEX-Tabellen und der Abbildung überein.

## Nicht geprüft

- **Richtigkeit von Code, Daten, Algebra und Bootstrap:** Das prüfen die Rollen data und estimation (beide PASS in der Vorrunde).
- **`t027_robustness.csv`:** Nur stichprobenhaft geprüft, und zwar die RL2-Zeilen `dln_n` in allen Varianten. Sie sind jetzt auf Nettoschuld bezogen, und die winsorisierten Mediane sind gleich den Basismedianen, wie im README beschrieben.
- **`t027_event_audit.csv`:** Nicht zeilenweise gelesen.
- **Übersetzte PDF der TEX-Tabellen:** Nicht angesehen. Laut `review/T027_latex.txt` lief die Übersetzung fehlerfrei.
- **`review/T027_proposal.diff`:** Die Änderungen in `proposal/` (`07_conclusion.tex`, `theory_note.tex`) enthalten keine T027-Zahlen. Sie stammen aus anderen Karten; T027 hat keinen Schreibbereich in `proposal/`.
- **Vom Skript gemeldete Änderungen:** `state/STATE.md`, `state/LIMITATIONS.md` und die Dateien unter `presentation/` und T009–T023 wurden laut Skript während der Ausführung geändert, liegen aber außerhalb des Schreibbereichs. Ihre Bewertung gehört nicht zu meiner Rolle. Der Co-PI sollte sie gegen parallele Sitzungen abgleichen.
- **`AI_USAGE_LOG.md`:** Nicht meine Rolle.
