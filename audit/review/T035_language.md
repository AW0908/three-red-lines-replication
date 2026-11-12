## Rolle: language (codex, high) – VERDICT: REWORK


## Befunde

1. **Die sprachliche Definition von RL2 ist mehrdeutig.** In `proposal/sections/05_context_data.tex:14` steht „interest-bearing debt minus cash over equity“, in Zeile 34 entsprechend „minus cash over $E$“. Die Formulierung lässt offen, ob sich die Division auf die gesamte Differenz bezieht. **Korrektur:** „net gearing, defined as interest-bearing debt net of cash divided by total equity“; in Zeile 34: „RL2 is the ratio of interest-bearing debt net of cash to $E$“. Das macht Zähler und Nenner sprachlich eindeutig.

2. **Abkürzungen werden nicht durchgehend beim ersten Auftreten eingeführt.**
   - `proposal/sections/03_framework.tex:14`: „RL1“ erscheint vor seiner Erläuterung im nachfolgenden Datenabschnitt. Die vorherigen Abschnitte enthalten hierzu nur auskommentierte Planungsnotizen. **Korrektur:** „for the first red-line ratio (RL1), …“.
   - `proposal/sections/04_empirical_model.tex:54`: „RD“ wird verwendet, ohne die Abkürzung zuvor ausdrücklich einzuführen. **Korrektur in Zeile 51:** „A sharp regression discontinuity (RD) design compares …“.

3. **Ein Satz in H2 hat unnötig verschachtelten Satzbau.** `proposal/sections/03_framework.tex:29`: „which equity channel carries the adjustment it leaves open.“ Das nachgestellte Subjekt erschwert das Lesen. **Korrektur:** „The model predicts that compliers use both margins but leaves open which equity channel carries the adjustment.“

4. **Die Definition des Bunching-Maßes ist sprachlich schlecht an die Gleichung angebunden.** `proposal/sections/04_empirical_model.tex:16–21`: Auf „With …“ folgen die Gleichung und „the excess in units …, estimated separately …“. Die Funktion dieses Nachtrags bleibt unklar. **Korrektur:** Vor der Gleichung „With …, we define“; danach: „Here, $b$ measures excess mass in units of the average counterfactual bin count. We estimate it separately before and after the policy.“

5. **Übernommener Sprachhinweis zur Tabelle:** `replication/outputs/tables/t005_summary_stats.tex:46` verwendet die britische Schreibweise „winsorisation“. **Amerikanisch:** „winsorization“. Die eingebundene Kopie in `proposal/tables/t005_summary_stats.tex` ist identisch. Da T035 die unveränderte Übernahme der Tabelle verlangt, ist dies ein Hinweis für eine gesondert autorisierte Korrektur der Tabellenquelle.

## Abnahmekriterien

1. **Wortbudgets: belegt erfüllt hinsichtlich der Obergrenzen.** Orientierende Zählung des Fließtexts ohne Kommentare, Überschriften und abgesetzte Gleichungen, mit jeder Inlineformel als einem Token: Framework etwa 645, Context/Data etwa 862, Empirical Strategy etwa 789 Wörter. Zahlenherkunft und Bestand der Zitierschlüssel: **nicht meine Rolle**. Zitate und Verweise verwenden in den neuen Abschnitten geschützte Leerzeichen; Prozentangaben im Fließtext sind ausgeschrieben.

2. **Übereinstimmung der Methoden mit Implementierung und Karten: nicht meine Rolle.** Die sprachliche Eindeutigkeit der Variablendefinition und der Methodenbeschreibung ist wegen Befunden 1 und 4 noch **nicht erfüllt**.

3. **Zurückhaltende wissenschaftliche Formulierung: sprachlich belegt erfüllt.** `03_framework.tex:20,29,31` unterscheidet Eigenkapitalzufuhr und debt-like equity; `04_empirical_model.tex:32,36,51` benennt Interpretationsgrenzen und Bedingungen kausaler Aussagen. Fachlicher Abgleich mit STATE: **nicht meine Rolle**.

4. **Kompilierung: laut bereitgestelltem Protokoll belegt erfüllt.** `review/T035_latex.txt:1`: „LaTeX: übersetzt fehlerfrei.“ Keine eigene Übersetzung durchgeführt.

## Nicht geprüft

- Variablenberechnung, Stichprobenfilter, Fallzahlen, Schätzcode, Reproduzierbarkeit und Zahlenherkunft: außerhalb der Language-Rolle.
- Schreibbereichsverletzungen und Zuordnung der gemeldeten externen Änderungen zu T035: nicht unabhängig geprüft; Änderungszeiten allein belegen keine Urheberschaft.
- PDF-Seitenbild, Umbrüche und sichtbare Typografie: kein gerendertes Dokument geprüft.
- `proposal/theory_note.tex` als Kontext gelesen; keine erneute Abnahme der vorgelagerten Aufgabe T034.
- Keine Dateien verändert und keine Shell-, Analyse- oder Buildbefehle ausgeführt.