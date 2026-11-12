## Rolle: estimation (codex, high) – VERDICT: PASS


## Befunde

1. Keine verbleibenden methodischen Mängel im Prüfbereich dieser Rolle gefunden. Die früher beanstandeten Aussagen wurden entsprechend der korrigierten Karte eingeschränkt. Das Urteil betrifft die theoretischen Herleitungen und ihre Zuordnung zu empirischen Tests; T034 enthält keine neue Regression.

## Abnahmekriterien

1. **Propositionen und Umbenennung – belegt erfüllt.** Kostenminimum, Compliance-Grenze, Anpassungsanteile und Eigentumsableitungen folgen aus A1–A5; die Beweise sind nachvollziehbar (`proposal/theory_note.tex:288–356`). Die aktive Modellnotation verwendet durchgehend d/e und α_d/α_e. Alte Bezeichnungen stehen nur in historischen Kommentaren.

2. **κ- und Pufferbemerkung – hinsichtlich mathematischer Korrektheit belegt erfüllt.**
   - Aus \(L=R_0-d-(1-\kappa)e\) folgen für Anpassende \(L=\tau+\kappa e^*\) und \(\Delta R-\Delta L=\kappa e^*\). Die Endpunkte κ = 0 und κ = 1 sind korrekt erläutert (`proposal/theory_note.tex:212–216`).
   - Die beschränkte Pufferoptimierung, ihre Randbedingung und die bedingte vergleichende Statik sind korrekt. Der Text unterscheidet Zielwert und verrauschte Beobachtung, behauptet keinen Massepunkt unter Normalrauschen und leitet keine gegenüber der Vorperiode geringere Umkehrwahrscheinlichkeit ab (`:148`).
   - Redaktionelle Minimalität: **nicht meine Rolle**.

3. **Testtabelle – im methodischen Prüfbereich belegt erfüllt.**
   - Das MI-Kontrafaktum wird zutreffend als mechanischer Vergleich unabhängig von κ eingeordnet. Die Intervallvorhersage enthält jetzt die erforderliche Größenbedingung samt korrektem Gegenbeispiel (`proposal/theory_note.tex:240–266`). Das Messfenster `[0.66,0.70)` entspricht `replication/code/11_mechanism.R:497` und `t029_counterfactual_bunching.csv:2–5`.
   - Kanalabhängige Vorzeichen, die mechanische Veränderung von `rl2_gap` und die begrenzte Aussagekraft der Eigentumsinteraktion sind ausdrücklich eingeschränkt (`:258–264`, `:369–406`).
   - Die ergänzende DiD-Beschreibung mit Firmen- und Zeit-Fixed-Effects entspricht `replication/code/02_estimate.R:85–90`.
   - Keine neuen empirischen Schätzwerte in der Notiz gefunden. Vollständiger Status-, Literatur- und Zahlenabgleich: **nicht meine Rolle**.

4. **Kompilierung, Seitenlimit und Layout – nicht meine Rolle.** `review/T034_latex.txt:1` meldet eine fehlerfreie Übersetzung; Seitenzahl und Layout wurden hier nicht verifiziert.

## Nicht geprüft

- Keine Befehle, Neuschätzungen oder Kompilation ausgeführt; keine Dateien verändert.
- Modellobjekte, tatsächliche Schätzstichproben, NA-/Singleton-Verluste, N, Firmenzahlen und vollständige Ergebnisübertragung früherer Karten nicht erneut geprüft.
- Datenaufbereitung, Sprache und Originalquellenprüfung liegen außerhalb der Spezialrolle.
- Die gemeldete Änderung an `state/STATE.md` und Änderungen außerhalb des Schreibbereichs wurden hinsichtlich Inhalt, Urheberschaft und Auswirkung auf den eingefrorenen Stand nicht verifiziert. Daraus wird hier kein Verstoß durch T034 abgeleitet.
- Vorgeschlagener KI-Log-Eintrag: „T034: unabhängige methodische Prüfung der überarbeiteten Theorie und Testzuordnung; ausschließlich lesend, keine Neuschätzung.“