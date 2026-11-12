## Rolle: data (codex, medium) – VERDICT: PASS


## Befunde

[firm-specific excerpt withheld in public audit]

2. **Der Merge verliert oder vervielfacht keine Kodierungen.** Die gelesenen Dateien enthalten 224 eindeutige Firma-Datum-Kennzahl-Schlüssel und eindeutige Firma-Datum-Schlüssel im Panel. Alle 224 Kodierungen finden einen Panel-Schlüssel; die Ausgabedatei enthält ebenfalls 224 eindeutige Zeilen. Die tatsächlichen Berichtsdaten stimmen für diese Beobachtungen mit den kodierten Stichtagen überein. Fehlende Kennzahlen bleiben fehlend: RL1 **64/64**, RL2 **85/96**, RL3 **59/64** verfügbare Vergleichspaare. Das entspricht `t040_validation.csv` und der Merge-Logik in `13_rl1_validation.R:65–94`.

3. **Filter und abgeleitete Daten sind nachvollziehbar.** Die Hauptstichprobe umfasst 1.692 Zeilen und 136 Firmen, davon 630 Post-Beobachtungen. Die positiven Original-N/E- und Gegenfaktualnenner-Bedingungen ergeben 602 Paare aus 129 Firmen. Die dokumentierte Matching-Regel ergibt 20 Firmen und 100 Post-Beobachtungen (`13_rl1_validation.R:51–60,117–129,144–156`; `t040_robustness.csv`). Keine zusätzliche stille Ausschlussregel gefunden.

4. **Die Perpetual-Behandlung entspricht der Karte.** Für 273 Hauptstichprobenzeilen mit beobachtetem Perpetual-Posten wird `(tl−adv+perp)/(ta−adv)` verwendet; fehlende Posten werden anhand von `perp_missing` erkannt und behalten die ursprüngliche Kennzahl (`13_rl1_validation.R:96–105,121–129`). Beobachtetes Null ergibt die ursprüngliche Formel, positive Perpetuals erhöhen bei positivem Nenner RL1, Nenner ≤ 0 ergeben NA. Die vorhandene Nullspeicherung fehlender Perpetuals ist in `state/LIMITATIONS.md:56` dokumentiert. Neue NA-zu-Null-Imputationen wurden nicht eingeführt.

## Abnahmekriterien

[firm-specific excerpt withheld in public audit]

2. **Reproduktion von T023/T029 vor Variation: nicht meine Rolle hinsichtlich Schätzung.** Die vorgeschalteten Assertions sind in `13_rl1_validation.R:58–63` vorhanden. Die zugrunde liegenden Datenfilter und Gegenfaktualvariablen wurden geprüft; die Ausgaben nennen b = 3,142854757615 und D = 0,114617940199.

3. **Klare Validierungsaussage und Robustheitsänderungen: belegt erfüllt hinsichtlich Datenvalidierung; Schätzungsbewertung nicht meine Rolle.** `t040_verification.txt` berichtet 52 schwellennahe Vergleiche aus 26 Firmen, MAE 0,570 Prozentpunkte und 76,9 % innerhalb eines Prozentpunkts. Die sechs Klassifikationsabweichungen sind einzeln in `t040_disagreements.csv` enthalten. Die Klassifikation zählt 37 beidseitig konforme, 21 beidseitig verletzende und 6 abweichende Beobachtungen. Selektive Veröffentlichungsabdeckung und unterschiedliche Firmenkonventionen werden ausdrücklich begrenzt.

4. **Stop-Bedingung: belegt nicht ausgelöst.** RL1 liegt für 30 Firmen vor; die Mindestzahl beträgt 15.

## Nicht geprüft

- Keine R-Skripte, Shell-Befehle oder Builds ausgeführt; numerische Schätzungen und Bootstrap-Inferenz bleiben der Estimation-Rolle vorbehalten.
- Ursprüngliche Panelerstellung aus EastMoney/Wind sowie sämtliche PDF-Transkriptionen nicht erneut vollständig geprüft. T040 verwendet das bestehende Panel unverändert.
- PDF-Abbildung und TeX-Layout nicht visuell geprüft.
- Ausschließliche Einhaltung des Schreibbereichs historisch nicht abschließend prüfbar: Die mitgeteilte Änderungszeitliste enthält auch `AI_USAGE_LOG.md` und Literaturdateien außerhalb des Kartenumfangs. Ohne Vorherstände beziehungsweise Änderungszuordnung lässt sich daraus keine Verursachung durch T040 belegen. Das PASS gilt für die geprüfte Datenaufbereitung.
- Keine Projektdatei verändert.