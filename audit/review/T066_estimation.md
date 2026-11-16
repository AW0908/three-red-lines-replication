## Rolle: estimation (claude, opus) – VERDICT: PASS


## Befunde

Für Rework [number withheld] gibt es keine inhaltlichen Mängel. Befund [number withheld] der Vorprüfung (`review/T066_estimation.md`) ist behoben. Die einzelnen Prüfschritte:

[number withheld]. **Ungewichtete Schätzung auf exakt derselben Stichprobe, mit demselben Schätzer.**
   - `23_drdid.R:670–671` ruft dieselbe Funktion `weighted_b` auf: dieselben Zeilen `gg`, dieselben `masks`, nur mit `ipw = rep([number withheld], nrow(gg))`.
   - Ein Assert prüft, dass Pre-Schätzung und Post-Fallzahlen (`n`, `firms`, `window_n`) gleich sind (`23_drdid.R:672–673`).
   - Im Code habe ich `weighted_b` mit dem Hauptschätzer `mass` (`21_diff_bunching.R:60–87`) verglichen. Bei Gewicht [number withheld] sind beide algebraisch gleich:
     - dieselben Bins ([number withheld]–[number withheld] in Schritten von [number withheld]);
     - dasselbe Fenster [[number withheld]; [number withheld]), dessen vier Bins aus dem Fit ausgeschlossen sind;
     - Polynom [number withheld]. Grades;
     - (Σh − Σpred)/mean(pred) entspricht (obs − cf)/(cf/[number withheld]);
     - dieselbe Gültigkeitsregel: pred im Fenster endlich und > [number withheld].
   - Das Ergebnis ist damit echtes ungewichtetes Bunching, nur auf der [number withheld]-Firmen-Risikomenge.
   - Plausibel ist auch: b_pre = [number withheld] liegt neben [number withheld] in der [number withheld]-Firmen-Stichprobe, also ein reiner Stichprobeneffekt.

[number withheld]. **Gepaarte Inferenz ist korrekt.**
   - Gewichtete und ungewichtete Werte stammen pro Ziehung aus demselben `hfit`-Aufruf (`23_drdid.R:714–718`). Sie nutzen dieselben `drawidx` und scheitern immer gemeinsam.
   - Ein Assert prüft, dass die Muster endlicher Werte gleich sind und die b_pre-Differenz null ist (`23_drdid.R:743–744`).
   - Die Konfidenzintervalle der Differenzen kommen aus den Differenzen der einzelnen Ziehungen (`paired_difference`, `23_drdid.R:742, 751–752`), nicht aus der Differenz der Intervallgrenzen.
   - In `t066_reporting_same_sample_bunching.csv` sind alle [number withheld]/[number withheld] Ziehungen gültig. Die Differenz von b_pre ist [number withheld] mit SE [number withheld]. Die Differenz von b_post entspricht der von Δb ([number withheld] [[number withheld]; [number withheld]]). Das muss so sein, weil die Pre-Gewichte [number withheld] sind.

[number withheld]. **Die Übertragung in die Ausgabe ist korrekt.**
   - Punktschätzer: `p$mass` bzw. `p$mass_unweighted` und ihre Differenz (`23_drdid.R:753–754`).
   - Die gewichteten Zeilen stimmen exakt mit der unveränderten Tabelle `t066_reporting_weighted_bunching.csv` überein. Ein Assert prüft das (`23_drdid.R:763–764`).
   - Die Differenz der Punktschätzer, [number withheld] − [number withheld] = [number withheld], stimmt mit der CSV überein.

[number withheld]. **Die Interpretation in Schritt [number withheld] trifft zu.**
   - Der Gewichtungseffekt wird nur aus dem Vergleich auf derselben Stichprobe gelesen.
   - [number withheld] heißt ausdrücklich „[number withheld]-firm main-sample“, und dazu steht, dass dieser Vergleich keinen Gewichtungseffekt isoliert (`t066_interpretation.csv` Zeile [number withheld]; README Z. [number withheld]–[number withheld]).
   - Der Satz „include zero“ wird bedingt erzeugt (`23_drdid.R:794`) und passt zu den Zahlen.
   - Den Vorbehalt zur schwachen ersten Stufe (Wald [number withheld] < [number withheld]) und zur unbelegten Ausschlussrestriktion behält der Text bei.

[number withheld]. **Hinweis, kein Fehler:** Die Spalten `pre_n`, `post_n` usw. in den Differenz- und ungewichteten Zeilen kommen aus `p$mass`, also aus der gewichteten Schätzung. Sie sind trotzdem richtig, weil der Assert in Z. [number withheld]–[number withheld] gleiche Fallzahlen sicherstellt.

## Abnahmekriterien

[number withheld]. **Reproduktion, byte-identische Ausgaben, zwei gleiche Läufe**
   - Die Reproduktions-Asserts stehen im Code (`23_drdid.R:90`).
   - Byte-Identität ist als Assert angelegt: die [number withheld] bestehenden T066-Dateien gegen den Hash-Stand vor Rework [number withheld] (`23_drdid.R:853–860`) und die gewichteten Zeilen gegen die alte Tabelle (Z. [number withheld]).
   - Ob die Läufe tatsächlich byte-identisch sind, kann ich nicht prüfen, weil ich nichts ausführe.
[number withheld]. **Jede Variante mit N, Trimming und Balance:** Für die neuen Zeilen belegt erfüllt. Jede Zeile hat risk_firms [number withheld], pre [number withheld]/[number withheld] und post [number withheld]/[number withheld], dazu valid/failed und eine Filterbeschreibung. Die DR-Zeilen sind unverändert und waren schon geprüft.
[number withheld]. **DR-Schätzer validiert:** Unverändert erfüllt (Abgleich mit dem Paket, Fehler [number withheld]·[number withheld]⁻¹⁵, siehe Vorprüfung).
[number withheld]. **Rework-[number withheld]-Vorgaben:** Belegt erfüllt. Ungewichtete Werte auf derselben Risikomenge, gleiche Funktion, gleiche Ziehungen, Differenz mit KI, Interpretation korrigiert, [number withheld] als [number withheld]-Firmen-Wert gekennzeichnet.

## Nicht geprüft

- **Tatsächliche Läufe:** Ob zwei Läufe byte-identisch sind und ob die Hash-Asserts beim Ausführen bestehen, habe ich nicht geprüft, weil ich keine Befehle ausführe.
- **Nachrechnung mit dem T061-Schätzer:** Die „unabhängige T061-Nachrechnung“ (Abweichung [number withheld]·[number withheld]⁻¹⁵) aus dem Bericht liegt nicht als Datei vor. Ich habe die Gleichheit nur algebraisch am Code geprüft.
- **Außerhalb meiner Rolle:** Datenaufbereitung, Schreibbereich, Sprache und die als geändert gemeldeten Dateien in `proposal/` und `MTPA Vault/`.
