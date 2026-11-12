## Rolle: data (claude, opus) – VERDICT: PASS

Ich habe die Daten jetzt geprüft und schreibe den Bericht.

VERDICT: PASS

## Befunde

Ich habe keinen inhaltlichen Fehler in der Datenaufbereitung gefunden. Die beiden Rework-Punkte, die meine Rolle betreffen (2: RL2-Zähler aus Nettoschuld, 5: HK-Wind-Guard), sind korrekt umgesetzt. Dazu drei Hinweise mit geringer Schwere:

[firm-specific excerpt withheld in public audit]
[firm-specific excerpt withheld in public audit]
[firm-specific excerpt withheld in public audit]
   - Der Guard (`08_decomposition.R:102–105`) prüft beide Endpunkte (`i` und `j`). Er läuft auch für die t−2-Ereignisse der Robustheitsprüfung, weil `events(r,2L)` dieselbe Funktion aufruft.
   - `market` ist in keiner Panelzeile NA. Das `na.rm=TRUE` in Zeile 104 kann den Fall also nicht stillschweigend verschlucken.
[firm-specific excerpt withheld in public audit]
2. **Der RL2-Zähler ist jetzt korrekt definiert.** `08_decomposition.R:149–152`: `dln_n = ln(net1) − ln(net0)` mit net = ibd − cash. `safe_log` liefert NA bei Werten ≤ 0, und `numerator_zero` ist NA, wenn die Nettoschuld an einem der beiden Stichtage nicht positiv ist.
   - Endpunkte gedanklich geprüft: Nettoschuld ≤ 0 an einem Stichtag ergibt NA, nicht 0. Ist ein Wert fehlend, ist `positive_net` FALSE, also ebenfalls NA.
   - In den Daten hat jedes der 64 RL2-Ereignisse positive Nettoschuld an beiden Stichtagen: „unavailable numerator-zero flags=0“ (`t027_identity_checks.txt:14`), `dln_n` ist für 28/28 und 36/36 Ereignisse verfügbar (`t027_decomposition_rl2.csv:7,41`).
   - Die Zerlegungskomponenten sind unverändert (`ibd/te1 − Δcash/te1 − net0·Δte/(te0·te1)`). Die maximalen Summenfehler liegen bei 4,4e-16.
3. **Zwei Fallzahlen sind fest eingetippt.** „2 events from 1 firm“ steht als Text in `08_decomposition.R:380` (TeX-Note) und `:452` (Bildnote). Die Werte stimmen mit `t027_events.csv:3` überein (`perp_observed_events=2`, `perp_observed_firms=1`). Bei einer Datenänderung würden sie aber nicht mitwandern. In der Testtabelle werden sie dagegen berechnet (`:402–403`). Das ist eher ein Punkt für die Consistency-Rolle und hat keinen Einfluss auf die Daten.

## Geprüft (Datenrolle)

- **Eingabe:** Eingelesen wird nur `data/processed/panel_firm_halfyear.csv`. Pflichtspalten und die Eindeutigkeit von (firm_id, date) prüft `stopifnot` (`:33–35`). Es gibt keine Merges.
- **Stichprobe und Perioden:** Der Code in `:71–76` ist gegenüber dem Stand, der die Datenprüfung bestanden hat, unverändert. Die Ereigniszahlen auch: RL1 33/31, 21/19, 281/74; RL2 28/27, 36/30 (`t027_events.csv`), identisch mit dem Worker-Bericht und dem früheren Datenreview.
- **Identitäten:** Keine Verletzung über 1 % (0/2.277 Zeilen im Panel, 0/1.691 in der Hauptstichprobe). Die Gegenhypothese „te ohne mi“ scheitert in allen 1.351 aussagekräftigen Zeilen. RL1 weicht von der Identitätsformel höchstens um 5,1e-8 ab.
- **Fehlende Werte:** Keine Werte werden ersetzt.
[firm-specific excerpt withheld in public audit]
  - Bei 15 RL1-Stayern ist das Eigenkapital nicht positiv. Ihre Logits bleiben NA.
- **Neuer Kontrast `equity_mi_share` (alle Ereignisse):**
  - Datenseitig korrekt abgegrenzt: `safe_div(dmi,de)` (`:136`) ergibt NA bei Δte = 0, und `:158–159` setzt den Anteil auf NA, wenn der Eigenkapitalterm fehlt oder 0 ist. Eine Einschränkung auf beobachtete Perpetuals gibt es hier nicht.
  - Die Fallzahlen (32 Post, 21 Pre) passen zu 33 Post-Kreuzungen minus der einen fehlenden mi-Beobachtung.

## Abnahmekriterien

1. **Identität und Komponentensummen bis 1e-10:** belegt erfüllt. Die `stopifnot`-Prüfungen stehen in `:172–179`. Der größte Fehler liegt bei 4,4e-16 (`t027_identity_checks.txt:13–14`). Unvollständig zerlegbare Ereignisse sind offen ausgewiesen und gehen auf die Daten zurück.
2. **Reproduzierbarkeit und Byte-Identität:** Der Code ist reproduzierbar angelegt: fester Seed (`:3`), relative Pfade, Schreiben im Binärmodus, PDF ohne Zeitstempel. Die SHA-Prüfung gegen veränderte Fremdoutputs steht in `:457–458`. Die Byte-Identität selbst habe ich nicht nachgerechnet (siehe „Nicht geprüft“).
3. **Interpretation und Annahmen zu mi/perp:** nicht meine Rolle. Datenseitig passen die Vorzeichen in den Interpretationsspalten zum Code.
4. **N je Zelle, Schwelle 20:** belegt erfüllt (33 ≥ 20, `t027_events.csv:2`).

## Nicht geprüft

- **Byte-Identität zweier Läufe und SHA-256-Listen in `t027_verification.txt`:** Ich durfte keine Befehle ausführen.
- **Rohdaten von HK-Wind:** Ob `少数股东权益` dort den Minderheitenanteil der Perpetuals enthält, habe ich nicht nachgesehen. Für die aktuellen Outputs spielt es keine Rolle, weil der Guard jeden betroffenen Endpunkt abfängt.
- **Berichtswährung der HK-Firmen über die Zeit (D7):** nicht geprüft.
- **Außerhalb meiner Rolle:** Bootstrap-Logik, Tests, Abbildung, TeX-Formulierungen, `proposal/theory_note.tex`, README und `AI_USAGE_LOG.md`. Dazu die vom Skript gemeldeten Änderungen an `state/STATE.md` und `state/LIMITATIONS.md` sowie an `presentation/` (vermutlich aus einer parallelen Sitzung). Diese Dateien liegen außerhalb der Datenaufbereitung; ob die Änderungen zulässig waren, sollten der Consistency-Reviewer bzw. der Co-PI bewerten.
