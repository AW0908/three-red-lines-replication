## Rolle: estimation (claude, opus) – VERDICT: PASS


## Befunde

Für Rework 2 gibt es keine inhaltlichen Mängel. Befund 1 der Vorprüfung (`review/T066_estimation.md`) ist behoben. Die einzelnen Prüfschritte:

1. **Ungewichtete Schätzung auf exakt derselben Stichprobe, mit demselben Schätzer.**
   - `23_drdid.R:670–671` ruft dieselbe Funktion `weighted_b` auf: dieselben Zeilen `gg`, dieselben `masks`, nur mit `ipw = rep(1, nrow(gg))`.
   - Ein Assert prüft, dass Pre-Schätzung und Post-Fallzahlen (`n`, `firms`, `window_n`) gleich sind (`23_drdid.R:672–673`).
   - Im Code habe ich `weighted_b` mit dem Hauptschätzer `mass` (`21_diff_bunching.R:60–87`) verglichen. Bei Gewicht 1 sind beide algebraisch gleich:
     - dieselben Bins (0,40–1,00 in Schritten von 0,01);
     - dasselbe Fenster [0,66; 0,70), dessen vier Bins aus dem Fit ausgeschlossen sind;
     - Polynom 5. Grades;
     - (Σh − Σpred)/mean(pred) entspricht (obs − cf)/(cf/4);
     - dieselbe Gültigkeitsregel: pred im Fenster endlich und > 0.
   - Das Ergebnis ist damit echtes ungewichtetes Bunching, nur auf der 124-Firmen-Risikomenge.
   - Plausibel ist auch: b_pre = −0,6212 liegt neben −0,8772 in der 136-Firmen-Stichprobe, also ein reiner Stichprobeneffekt.

2. **Gepaarte Inferenz ist korrekt.**
   - Gewichtete und ungewichtete Werte stammen pro Ziehung aus demselben `hfit`-Aufruf (`23_drdid.R:714–718`). Sie nutzen dieselben `drawidx` und scheitern immer gemeinsam.
   - Ein Assert prüft, dass die Muster endlicher Werte gleich sind und die b_pre-Differenz null ist (`23_drdid.R:743–744`).
   - Die Konfidenzintervalle der Differenzen kommen aus den Differenzen der einzelnen Ziehungen (`paired_difference`, `23_drdid.R:742, 751–752`), nicht aus der Differenz der Intervallgrenzen.
   - In `t066_reporting_same_sample_bunching.csv` sind alle 499/499 Ziehungen gültig. Die Differenz von b_pre ist 0 mit SE 0. Die Differenz von b_post entspricht der von Δb (−0,0767 [−0,5218; 0,6850]). Das muss so sein, weil die Pre-Gewichte 1 sind.

3. **Die Übertragung in die Ausgabe ist korrekt.**
   - Punktschätzer: `p$mass` bzw. `p$mass_unweighted` und ihre Differenz (`23_drdid.R:753–754`).
   - Die gewichteten Zeilen stimmen exakt mit der unveränderten Tabelle `t066_reporting_weighted_bunching.csv` überein. Ein Assert prüft das (`23_drdid.R:763–764`).
   - Die Differenz der Punktschätzer, 3,2157 − 3,2924 = −0,0767, stimmt mit der CSV überein.

4. **Die Interpretation in Schritt 3 trifft zu.**
   - Der Gewichtungseffekt wird nur aus dem Vergleich auf derselben Stichprobe gelesen.
   - 4,0200 heißt ausdrücklich „136-firm main-sample“, und dazu steht, dass dieser Vergleich keinen Gewichtungseffekt isoliert (`t066_interpretation.csv` Zeile 4; README Z. 1731–1733).
   - Der Satz „include zero“ wird bedingt erzeugt (`23_drdid.R:794`) und passt zu den Zahlen.
   - Den Vorbehalt zur schwachen ersten Stufe (Wald 3,9954 < 10) und zur unbelegten Ausschlussrestriktion behält der Text bei.

5. **Hinweis, kein Fehler:** Die Spalten `pre_n`, `post_n` usw. in den Differenz- und ungewichteten Zeilen kommen aus `p$mass`, also aus der gewichteten Schätzung. Sie sind trotzdem richtig, weil der Assert in Z. 672–673 gleiche Fallzahlen sicherstellt.

## Abnahmekriterien

1. **Reproduktion, byte-identische Ausgaben, zwei gleiche Läufe**
   - Die Reproduktions-Asserts stehen im Code (`23_drdid.R:90`).
   - Byte-Identität ist als Assert angelegt: die 32 bestehenden T066-Dateien gegen den Hash-Stand vor Rework 2 (`23_drdid.R:853–860`) und die gewichteten Zeilen gegen die alte Tabelle (Z. 763).
   - Ob die Läufe tatsächlich byte-identisch sind, kann ich nicht prüfen, weil ich nichts ausführe.
2. **Jede Variante mit N, Trimming und Balance:** Für die neuen Zeilen belegt erfüllt. Jede Zeile hat risk_firms 124, pre 728/124 und post 575/121, dazu valid/failed und eine Filterbeschreibung. Die DR-Zeilen sind unverändert und waren schon geprüft.
3. **DR-Schätzer validiert:** Unverändert erfüllt (Abgleich mit dem Paket, Fehler 1,17·10⁻¹⁵, siehe Vorprüfung).
4. **Rework-2-Vorgaben:** Belegt erfüllt. Ungewichtete Werte auf derselben Risikomenge, gleiche Funktion, gleiche Ziehungen, Differenz mit KI, Interpretation korrigiert, 4,02 als 136-Firmen-Wert gekennzeichnet.

## Nicht geprüft

- **Tatsächliche Läufe:** Ob zwei Läufe byte-identisch sind und ob die Hash-Asserts beim Ausführen bestehen, habe ich nicht geprüft, weil ich keine Befehle ausführe.
- **Nachrechnung mit dem T061-Schätzer:** Die „unabhängige T061-Nachrechnung“ (Abweichung 5,77·10⁻¹⁵) aus dem Bericht liegt nicht als Datei vor. Ich habe die Gleichheit nur algebraisch am Code geprüft.
- **Außerhalb meiner Rolle:** Datenaufbereitung, Schreibbereich, Sprache und die als geändert gemeldeten Dateien in `proposal/` und `MTPA Vault/`.
