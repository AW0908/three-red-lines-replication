## Rolle: consistency (claude, opus) – VERDICT: PASS

Prüfung abgeschlossen. Mein Urteil als Consistency-Reviewer ist PASS; die drei Hinweise unten ändern das Urteil nicht.

VERDICT: PASS

## Befunde

Text, Outputs und CSVs widersprechen sich nirgends. Alle vier Punkte aus dem vorigen REWORK der Rolle consistency sind behoben. Drei kleine Hinweise, keiner ändert eine Zahl:

[number withheld]. **In `t027_tests.tex` ist unklar, worauf sich „For this contrast“ bezieht.** Der Satz kommt direkt nach dem allgemeinen Satz „All equity-change shares require nonzero equity changes. CSV reports coverage and valid draws.“ (`08_decomposition.R:401–402`). Seit es drei Anteils-Kontraste gibt, ist nicht eindeutig, welcher Kontrast gemeint ist. Gemeint ist der Perp-Kontrast (Zeile [number withheld]: [number withheld] Pre-Ereignisse, [number withheld] Firma, [number withheld] von [number withheld] Ziehungen gültig, laut `t027_tests.csv` Z. [number withheld]). Die Zeilenbeschriftung „conditional/unreliable“ löst die Frage zwar auf. Besser wäre trotzdem „For the minority plus perpetual share contrast, …“.
   - Verwandt: Der Satz in Z. [number withheld] („the minority plus perpetual equity-change share use medians“) ist nicht mehr vollständig, weil auch die Mittelwert-Zeile des Minority-Kontrasts dazugekommen ist. Der folgende Satz ergänzt das aber.
[number withheld]. **Zwei Zahlen sind von Hand eingetippt statt berechnet.**
   - Die Note der RL1-Pre-Tabelle sagt „[number withheld] events from [number withheld] firm“ (`08_decomposition.R:380`).
   - Die Bildnote der Abbildung sagt „([number withheld] events, [number withheld] firm)“ (Z. [number withheld]).
   - Beide stimmen derzeit mit `t027_events.csv` Z. [number withheld] überein ([number withheld], [number withheld]). Sie würden aber bei geänderten Daten nicht mitwandern (Arbeitsregel [number withheld]).
   - Die Tests-Note zieht dieselben Zahlen dagegen per `sprintf` aus `tests` (Z. [number withheld]–[number withheld]).
[number withheld]. **Den Captions fehlt ein Trennzeichen.**
   - RL1: „Accounting decomposition of RL1 post crossings Change in logit(RL1) = …“; zwischen „crossings“ und „Change“ fehlt ein Punkt (Z. [number withheld]–[number withheld]).
   - RL2: Die Captions enden mit einem überflüssigen Leerzeichen.
   - Das ist eine Frage der Lesbarkeit, kein Widerspruch; die Rolle language prüft das genauer.

## Abnahmekriterien

**[number withheld]. Identitätsprüfungen und Komponentensummen:** Die Richtigkeit gehört nicht zu meiner Rolle. Die Konsistenz ist belegt:
- `t027_identity_checks.txt` ist in sich stimmig: [number withheld] Verletzungen; RL1: [number withheld] Ereignisse, davon [number withheld] ungültig; RL2: [number withheld] Ereignisse, Zähler jetzt `ibd-cash` mit Positivitätsbedingung.
- Die Werte passen zu `n_missing` in `t027_decomposition_rl1.csv` (Stayer [number withheld] → [number withheld]/[number withheld]).
- Der RL2-Zähler ist im Code richtig auf Nettoschuld umgestellt (`08_decomposition.R:149–152`). Die CSV-Interpretation von `dln_n` ist bei RL2 entsprechend korrigiert (rl2.csv Z. [number withheld], [number withheld], [number withheld], [number withheld]).
- Die Medianwerte decken sich mit dem Worker-Bericht ([number withheld] / [number withheld]).

**[number withheld]. Reproduzierbarkeit und byte-identische Outputs:** Nicht meine Rolle.

**[number withheld]. Interpretation real vs. kosmetisch, deskriptive Kennzeichnung, Annahmen-Klausel:** Belegt erfüllt, soweit es meine Rolle betrifft.
- **Einheiten:** Alle drei RL1-Captions und Notes, die Tests-Caption und -Note sowie die Abbildung nennen „Change in logit(RL1) = Δln N − Δln te; all components in log-odds units“.
- **Prozentpunkt-Übersetzung:** Sie wird im Code berechnet (Z. [number withheld]–[number withheld]). Nachgerechnet: [number withheld] × ([number withheld]) = [number withheld], also [number withheld] pp, wie angegeben.
- **CSV:** `reported_total` lautet bei RL1 „logit change of the stored ratio“ (Z. [number withheld], [number withheld], [number withheld], [number withheld], [number withheld], [number withheld]). Bei RL2 bleibt richtigerweise „Stored ratio change“.
- **Annahmen-Klausel:** Sie steht in allen Notes, in der Abbildung und im README.
- **Signifikanz:** Nirgends wird eine behauptet. Es gibt keine Sterne, und alle [number withheld] Intervalle schließen [number withheld] ein; das stimmt mit der CSV überein.
- **Zahlen in den TEX-Tabellen:** Ich habe jede Zelle von `t027_decomposition_rl1.tex` ([number withheld] Floats), `t027_decomposition_rl2.tex` ([number withheld] Floats) und `t027_tests.tex` ([number withheld] Zeilen) gegen die CSV geprüft. Werte, Rundung auf [number withheld] Stellen, Vorzeichen, N und Firmen stimmen alle.
  - „[number withheld]“ ist behoben (rl2.tex Z. [number withheld]: [number withheld]).
  - Binäre Mediane erscheinen als „--“.
- **Neue Kontraste:** median [number withheld] [[number withheld]; [number withheld]] und mean [number withheld] [[number withheld]; [number withheld]]. N = [number withheld] vs. [number withheld]; [number withheld] fehlende Post-Beobachtung, entsprechend [number withheld] − [number withheld]. Alles stimmt mit `t027_tests.csv` Z. [number withheld]–[number withheld] und rl1.csv Z. [number withheld]/[number withheld] überein; die Differenz [number withheld] − [number withheld] habe ich nachgerechnet.
- **Abbildung:** Die Stapel entsprechen den All-Events-Medianen der CSV.
  - Post: [number withheld] / [number withheld] / [number withheld] / [number withheld]; der Stapel endet bei ≈ [number withheld].
  - Pre: [number withheld] / [number withheld] / [number withheld] / [number withheld]; Ende ≈ [number withheld].
  - Stayer: [number withheld] / [number withheld] / [number withheld] / [number withheld].
  - Die Rauten (Mediantotal) liegen bei [number withheld] / [number withheld] / [number withheld].
  - Die Fallzahlen [number withheld]/[number withheld], [number withheld]/[number withheld] und [number withheld]/[number withheld] entsprechen `t027_events.csv`. Die Abdeckung ([number withheld]/[number withheld]/[number withheld]/[number withheld]; [number withheld]/…; [number withheld]/…) stimmt mit `n_available` überein.
  - Die Perp-Teilstichprobe ist aus der Abbildung entfernt und als nicht interpretierbar gekennzeichnet.
- **Worker-Bericht:** Alle Zahlen habe ich in den Dateien wiedergefunden, darunter die RL1-Statistiktabelle, [number withheld]/[number withheld] (`ibd_rising` [number withheld] × [number withheld]), die Kontraste und die Fallzahlen.
- **README:** Z. [number withheld]–[number withheld] stimmt mit Code und Outputs überein: [number withheld] Kontraste, [number withheld]/[number withheld], [number withheld]-%-Schwelle für gültige Ziehungen ([number withheld]/[number withheld] ≈ [number withheld] % → als unzuverlässig gekennzeichnet).

**[number withheld]. N je Zelle:** Belegt erfüllt. `t027_events.csv` ([number withheld]/[number withheld], [number withheld]/[number withheld], [number withheld]/[number withheld], [number withheld]/[number withheld], [number withheld]/[number withheld]; Perp-Teilstichproben [number withheld]/[number withheld], [number withheld]/[number withheld], [number withheld]/[number withheld], [number withheld]/[number withheld], [number withheld]/[number withheld]) stimmt mit `n_events`/`n_firms` in allen CSVs, den TEX-Tabellen und der Abbildung überein.

## Nicht geprüft

- **Richtigkeit von Code, Daten, Algebra und Bootstrap:** Das prüfen die Rollen data und estimation (beide PASS in der Vorrunde).
- **`t027_robustness.csv`:** Nur stichprobenhaft geprüft, und zwar die RL2-Zeilen `dln_n` in allen Varianten. Sie sind jetzt auf Nettoschuld bezogen, und die winsorisierten Mediane sind gleich den Basismedianen, wie im README beschrieben.
- **`t027_event_audit.csv`:** Nicht zeilenweise gelesen.
- **Übersetzte PDF der TEX-Tabellen:** Nicht angesehen. Laut `review/T027_latex.txt` lief die Übersetzung fehlerfrei.
- **`review/T0[number withheld]_proposal.diff`:** Die Änderungen in `proposal/` (`07_conclusion.tex`, `theory_note.tex`) enthalten keine T027-Zahlen. Sie stammen aus anderen Karten; T027 hat keinen Schreibbereich in `proposal/`.
- **Vom Skript gemeldete Änderungen:** `state/STATE.md`, `state/LIMITATIONS.md` und die Dateien unter `presentation/` und T009–T023 wurden laut Skript während der Ausführung geändert, liegen aber außerhalb des Schreibbereichs. Ihre Bewertung gehört nicht zu meiner Rolle. Der Co-PI sollte sie gegen parallele Sitzungen abgleichen.
- **`AI_USAGE_LOG.md`:** Nicht meine Rolle.
