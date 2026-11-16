## Rolle: data (claude, opus) – VERDICT: PASS

Ich habe die Daten jetzt geprüft und schreibe den Bericht.

VERDICT: PASS

## Befunde

Ich habe keinen inhaltlichen Fehler in der Datenaufbereitung gefunden. Die beiden Rework-Punkte, die meine Rolle betreffen ([number withheld]: RL2-Zähler aus Nettoschuld, [number withheld]: HK-Wind-Guard), sind korrekt umgesetzt. Dazu drei Hinweise mit geringer Schwere:

[firm-specific excerpt withheld in public process copy]
[firm-specific excerpt withheld in public process copy]
[firm-specific excerpt withheld in public process copy]
   - Der Guard (`08_decomposition.R:102–105`) prüft beide Endpunkte (`i` und `j`). Er läuft auch für die t−[number withheld]-Ereignisse der Robustheitsprüfung, weil `events(r,[number withheld]L)` dieselbe Funktion aufruft.
   - `market` ist in keiner Panelzeile NA. Das `na.rm=TRUE` in Zeile [number withheld] kann den Fall also nicht stillschweigend verschlucken.
[firm-specific excerpt withheld in public process copy]
[number withheld]. **Der RL2-Zähler ist jetzt korrekt definiert.** `08_decomposition.R:149–152`: `dln_n = ln(net1) − ln(net0)` mit net = ibd − cash. `safe_log` liefert NA bei Werten ≤ [number withheld], und `numerator_zero` ist NA, wenn die Nettoschuld an einem der beiden Stichtage nicht positiv ist.
   - Endpunkte gedanklich geprüft: Nettoschuld ≤ [number withheld] an einem Stichtag ergibt NA, nicht [number withheld]. Ist ein Wert fehlend, ist `positive_net` FALSE, also ebenfalls NA.
   - In den Daten hat jedes der [number withheld] RL2-Ereignisse positive Nettoschuld an beiden Stichtagen: „unavailable numerator-zero flags=[number withheld]“ (`t027_identity_checks.txt:14`), `dln_n` ist für [number withheld]/[number withheld] und [number withheld]/[number withheld] Ereignisse verfügbar (`t0[number withheld]_decomposition_rl2.csv:[number withheld]`).
   - Die Zerlegungskomponenten sind unverändert (`ibd/te1 − Δcash/te1 − net0·Δte/(te0·te1)`). Die maximalen Summenfehler liegen bei [number withheld].
[number withheld]. **Zwei Fallzahlen sind fest eingetippt.** „[number withheld] events from [number withheld] firm“ steht als Text in `08_decomposition.R:380` (TeX-Note) und `:[number withheld]` (Bildnote). Die Werte stimmen mit `t027_events.csv:3` überein (`perp_observed_events=[number withheld]`, `perp_observed_firms=[number withheld]`). Bei einer Datenänderung würden sie aber nicht mitwandern. In der Testtabelle werden sie dagegen berechnet (`:[number withheld]–[number withheld]`). Das ist eher ein Punkt für die Consistency-Rolle und hat keinen Einfluss auf die Daten.

## Geprüft (Datenrolle)

- **Eingabe:** Eingelesen wird nur `data/processed/panel_firm_halfyear.csv`. Pflichtspalten und die Eindeutigkeit von (firm_id, date) prüft `stopifnot` (`:[number withheld]–[number withheld]`). Es gibt keine Merges.
- **Stichprobe und Perioden:** Der Code in `:[number withheld]–[number withheld]` ist gegenüber dem Stand, der die Datenprüfung bestanden hat, unverändert. Die Ereigniszahlen auch: RL1 [number withheld]/[number withheld], [number withheld]/[number withheld], [number withheld]/[number withheld]; RL2 [number withheld]/[number withheld], [number withheld]/[number withheld] (`t027_events.csv`), identisch mit dem Worker-Bericht und dem früheren Datenreview.
- **Identitäten:** Keine Verletzung über [number withheld] % ([number withheld]/[number withheld] Zeilen im Panel, [number withheld]/[number withheld] in der Hauptstichprobe). Die Gegenhypothese „te ohne mi“ scheitert in allen [number withheld] aussagekräftigen Zeilen. RL1 weicht von der Identitätsformel höchstens um [number withheld] ab.
- **Fehlende Werte:** Keine Werte werden ersetzt.
[firm-specific excerpt withheld in public process copy]
  - Bei [number withheld] RL1-Stayern ist das Eigenkapital nicht positiv. Ihre Logits bleiben NA.
- **Neuer Kontrast `equity_mi_share` (alle Ereignisse):**
  - Datenseitig korrekt abgegrenzt: `safe_div(dmi,de)` (`:[number withheld]`) ergibt NA bei Δte = [number withheld], und `:[number withheld]–[number withheld]` setzt den Anteil auf NA, wenn der Eigenkapitalterm fehlt oder [number withheld] ist. Eine Einschränkung auf beobachtete Perpetuals gibt es hier nicht.
  - Die Fallzahlen ([number withheld] Post, [number withheld] Pre) passen zu [number withheld] Post-Kreuzungen minus der einen fehlenden mi-Beobachtung.

## Abnahmekriterien

[number withheld]. **Identität und Komponentensummen bis [number withheld]:** belegt erfüllt. Die `stopifnot`-Prüfungen stehen in `:[number withheld]–[number withheld]`. Der größte Fehler liegt bei [number withheld] (`t027_identity_checks.txt:13–14`). Unvollständig zerlegbare Ereignisse sind offen ausgewiesen und gehen auf die Daten zurück.
[number withheld]. **Reproduzierbarkeit und Byte-Identität:** Der Code ist reproduzierbar angelegt: fester Seed (`:[number withheld]`), relative Pfade, Schreiben im Binärmodus, PDF ohne Zeitstempel. Die SHA-Prüfung gegen veränderte Fremdoutputs steht in `:[number withheld]–[number withheld]`. Die Byte-Identität selbst habe ich nicht nachgerechnet (siehe „Nicht geprüft“).
[number withheld]. **Interpretation und Annahmen zu mi/perp:** nicht meine Rolle. Datenseitig passen die Vorzeichen in den Interpretationsspalten zum Code.
[number withheld]. **N je Zelle, Schwelle [number withheld]:** belegt erfüllt ([number withheld] ≥ [number withheld], `t027_events.csv:2`).

## Nicht geprüft

- **Byte-Identität zweier Läufe und SHA-[number withheld]-Listen in `t027_verification.txt`:** Ich durfte keine Befehle ausführen.
- **Rohdaten von HK-Wind:** Ob `少数股东权益` dort den Minderheitenanteil der Perpetuals enthält, habe ich nicht nachgesehen. Für die aktuellen Outputs spielt es keine Rolle, weil der Guard jeden betroffenen Endpunkt abfängt.
- **Berichtswährung der HK-Firmen über die Zeit (D7):** nicht geprüft.
- **Außerhalb meiner Rolle:** Bootstrap-Logik, Tests, Abbildung, TeX-Formulierungen, `proposal/theory_note.tex`, README und `AI_USAGE_LOG.md`. Dazu die vom Skript gemeldeten Änderungen an `state/STATE.md` und `state/LIMITATIONS.md` sowie an `presentation/` (vermutlich aus einer parallelen Sitzung). Diese Dateien liegen außerhalb der Datenaufbereitung; ob die Änderungen zulässig waren, sollten der Consistency-Reviewer bzw. der Co-PI bewerten.
