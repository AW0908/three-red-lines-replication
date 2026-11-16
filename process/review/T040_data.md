## Rolle: data (codex, medium) – VERDICT: PASS


## Befunde

[firm-specific excerpt withheld in public process copy]

[number withheld]. **Der Merge verliert oder vervielfacht keine Kodierungen.** Die gelesenen Dateien enthalten [number withheld] eindeutige Firma-Datum-Kennzahl-Schlüssel und eindeutige Firma-Datum-Schlüssel im Panel. Alle [number withheld] Kodierungen finden einen Panel-Schlüssel; die Ausgabedatei enthält ebenfalls [number withheld] eindeutige Zeilen. Die tatsächlichen Berichtsdaten stimmen für diese Beobachtungen mit den kodierten Stichtagen überein. Fehlende Kennzahlen bleiben fehlend: RL1 **[number withheld]/[number withheld]**, RL2 **[number withheld]/[number withheld]**, RL3 **[number withheld]/[number withheld]** verfügbare Vergleichspaare. Das entspricht `t040_validation.csv` und der Merge-Logik in `13_rl1_validation.R:65–94`.

[number withheld]. **Filter und abgeleitete Daten sind nachvollziehbar.** Die Hauptstichprobe umfasst [number withheld] Zeilen und [number withheld] Firmen, davon [number withheld] Post-Beobachtungen. Die positiven Original-N/E- und Gegenfaktualnenner-Bedingungen ergeben [number withheld] Paare aus [number withheld] Firmen. Die dokumentierte Matching-Regel ergibt [number withheld] Firmen und [number withheld] Post-Beobachtungen (`[number withheld]_rl1_validation.R:[number withheld]–[number withheld]–[number withheld]–[number withheld]`; `t040_robustness.csv`). Keine zusätzliche stille Ausschlussregel gefunden.

[number withheld]. **Die Perpetual-Behandlung entspricht der Karte.** Für [number withheld] Hauptstichprobenzeilen mit beobachtetem Perpetual-Posten wird `(tl−adv+perp)/(ta−adv)` verwendet; fehlende Posten werden anhand von `perp_missing` erkannt und behalten die ursprüngliche Kennzahl (`[number withheld]_rl1_validation.R:[number withheld]–[number withheld]–[number withheld]`). Beobachtetes Null ergibt die ursprüngliche Formel, positive Perpetuals erhöhen bei positivem Nenner RL1, Nenner ≤ [number withheld] ergeben NA. Die vorhandene Nullspeicherung fehlender Perpetuals ist in `state/LIMITATIONS.md:56` dokumentiert. Neue NA-zu-Null-Imputationen wurden nicht eingeführt.

## Abnahmekriterien

[firm-specific excerpt withheld in public process copy]

[number withheld]. **Reproduktion von T023/T029 vor Variation: nicht meine Rolle hinsichtlich Schätzung.** Die vorgeschalteten Assertions sind in `13_rl1_validation.R:58–63` vorhanden. Die zugrunde liegenden Datenfilter und Gegenfaktualvariablen wurden geprüft; die Ausgaben nennen b = [number withheld] und D = [number withheld].

[number withheld]. **Klare Validierungsaussage und Robustheitsänderungen: belegt erfüllt hinsichtlich Datenvalidierung; Schätzungsbewertung nicht meine Rolle.** `t040_verification.txt` berichtet [number withheld] schwellennahe Vergleiche aus [number withheld] Firmen, MAE [number withheld] Prozentpunkte und [number withheld] % innerhalb eines Prozentpunkts. Die sechs Klassifikationsabweichungen sind einzeln in `t040_disagreements.csv` enthalten. Die Klassifikation zählt [number withheld] beidseitig konforme, [number withheld] beidseitig verletzende und [number withheld] abweichende Beobachtungen. Selektive Veröffentlichungsabdeckung und unterschiedliche Firmenkonventionen werden ausdrücklich begrenzt.

[number withheld]. **Stop-Bedingung: belegt nicht ausgelöst.** RL1 liegt für [number withheld] Firmen vor; die Mindestzahl beträgt [number withheld].

## Nicht geprüft

- Keine R-Skripte, Shell-Befehle oder Builds ausgeführt; numerische Schätzungen und Bootstrap-Inferenz bleiben der Estimation-Rolle vorbehalten.
- Ursprüngliche Panelerstellung aus EastMoney/Wind sowie sämtliche PDF-Transkriptionen nicht erneut vollständig geprüft. T040 verwendet das bestehende Panel unverändert.
- PDF-Abbildung und TeX-Layout nicht visuell geprüft.
- Ausschließliche Einhaltung des Schreibbereichs historisch nicht abschließend prüfbar: Die mitgeteilte Änderungszeitliste enthält auch `AI_USAGE_LOG.md` und Literaturdateien außerhalb des Kartenumfangs. Ohne Vorherstände beziehungsweise Änderungszuordnung lässt sich daraus keine Verursachung durch T040 belegen. Das PASS gilt für die geprüfte Datenaufbereitung.
- Keine Projektdatei verändert.