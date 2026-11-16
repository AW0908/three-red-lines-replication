## Rolle: estimation (claude, opus) – VERDICT: PASS


## Befunde

Keine inhaltlichen Fehler in meiner Rolle (estimation). Rework-Punkt [number withheld] aus `review/T061_estimation.md` ist behoben:

[number withheld]. **Placebo-Ausschluss jetzt nach T023.** In `replication/code/21_diff_bunching.R:64–69` sind Massenfenster und Fit-Ausschluss jetzt getrennt:
   - `mass_window` umfasst die vier Bins unter dem Schwellenwert.
   - `excluded <- mass_window | (threshold != .[number withheld] & regulated_region)` mit `regulated_region` = [[number withheld]; [number withheld]).

   Das entspricht `06_bunching_tests.R:405–420`: `excluded <- test_window | (is_placebo & regulated_region)`, Masse nur über `mass`.

   Beobachtete Masse, kontrafaktische Masse und Normierung (`sum(mass_window)` = [number withheld]) laufen in Z. [number withheld]–[number withheld] ausschließlich über `mass_window`. Die Formel b = (obs − cf)/(cf/[number withheld]) ist identisch mit `06_bunching_tests.R:431/436`.

   Die Bin-Zahlen sind zur Laufzeit abgesichert (Z. [number withheld], Z. [number withheld]): [number withheld] Bins bei [number withheld], [number withheld] Bins bei den Placebos. Die beiden Placebo-Fenster [[number withheld]; [number withheld]) und [[number withheld]; [number withheld]) überschneiden sich nicht mit [[number withheld]; [number withheld]).

[number withheld]. **Kontraste bei [number withheld] inhaltlich unverändert.**
   - Kontrolle bei [number withheld]: b_pre [number withheld], b_post [number withheld], Δb [number withheld].
   - Drei ΔΔb: [number withheld] [[number withheld]; [number withheld]], [number withheld] [[number withheld]; [number withheld]] und [number withheld] [[number withheld]; [number withheld]].

   Alle Werte stimmen mit dem vorigen Estimation-Bericht überein. Die Arithmetik passt, z. B. [number withheld] − ([number withheld]) = [number withheld] (`t061_diff_bunching.csv`, Z. [number withheld]–[number withheld]).

   Die neue Logik berührt den RNG-Strom nicht: Die Gewichte werden vor `mass()` gezogen (Z. [number withheld], [number withheld]), und `mass()` selbst zieht keine Zufallszahlen.

## Abnahmekriterien

[number withheld]. **Reproduktion, byte-identische Altoutputs, zwei identische Läufe.**
   - Reproduktions-Assertion: belegt erfüllt (Z. [number withheld]; `t061_estimates.csv` Z. [number withheld]: [number withheld] / [number withheld] / [number withheld]).
   - Unabhängige Nachrechnung der sechs Kontrollschätzer mit `hist()/lm()/predict()`: im Code als Gate angelegt (Z. [number withheld]–[number withheld]), PASS laut `t061_validation.txt`. Die Datei wird jetzt über `textout()` vom Kartenbefehl erzeugt.
   - Byte-Identität und Wiederholungslauf: als Guards angelegt (Z. [number withheld]–[number withheld], [number withheld]–[number withheld]). Selbst ausführen konnte ich sie nicht.
[number withheld]. **Jede vorab festgelegte Variante mit N, Firmen und Fenstersupport.** Belegt erfüllt für alle [number withheld] Schätzzeilen und [number withheld] Kontraste.
   - Kontrolle: [number withheld]/[number withheld] pre und [number withheld]/[number withheld] post.
   - Support: [number withheld]/[number withheld] bei [number withheld], [number withheld]/[number withheld] bei [number withheld] und [number withheld]/[number withheld] bei [number withheld]; kein Low-Support-Flag.
   - Alle Bootstrap-Ziehungen gültig ([number withheld]/[number withheld]).
   - Die Placebos sind jetzt korrekt spezifiziert: Δb bei [number withheld] = [number withheld] [[number withheld]; [number withheld]], bei [number withheld] = [number withheld] [[number withheld]; [number withheld]].
   - `t061_results.tex` Z. [number withheld]–[number withheld], die Tabellennotiz, `t061_interpretation.csv` Schritt [number withheld] und `t061_number_map.csv` (Z. [number withheld]–[number withheld]) stimmen mit `t061_estimates.csv` überein.
[number withheld]. **Provenienz im MANIFEST:** nicht meine Rolle.

## Nicht geprüft

- Ich habe nichts ausgeführt. Ein Lesebefehl für SHA-[number withheld]-Hashes wurde verweigert. Deshalb habe ich nicht selbst gegengeprüft:
  - die Byte-Identität von `t061_diff_bunching.csv` und der [number withheld]-Ziehungen gegenüber dem vorigen Kandidaten (Bericht: SHA `[number withheld]d1[number withheld]a…`);
  - die Wiederholungsläufe.

  Inhaltlich stimmen die Werte mit dem vorigen Bericht auf allen angezeigten Stellen überein.
- Die Placebo-Ziehungen in `t061_bootstrap_draws.csv` habe ich nicht Zeile für Zeile gelesen; ich habe nur die Zusammenfassungen in `t061_estimates.csv` geprüft.
- Die κ-Schriftgrößen sind nicht meine Rolle. Ich habe nur gesehen, dass `t061_validation.txt` und `t061_interpretation.csv` Schritt [number withheld] übereinstimmen: [number withheld] / [number withheld] pt.
- Datenaufbereitung, MANIFEST, README, `run_all` und Sprache: nicht meine Rolle.
