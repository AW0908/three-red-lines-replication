## Rolle: consistency (claude, opus) – VERDICT: PASS


## Befunde
1. **(Hinweis, kein Mangel)** `t025_verification.txt` meldet „6/6 card/estimation inputs unchanged … including state/STATE.md“. Die SHA-256-Prüfung des Skripts meldet dagegen, dass `state/STATE.md` seit Beginn der Ausführung verändert wurde. Wahrscheinlich ist das eine spätere Änderung durch Co-PI oder PI: Die Karte enthält Korrekturen vom 2026-10-21. Der Verifikationstext ist damit eine Momentaufnahme und nicht mehr aktuell. Die Zahlen in den Tabellen betrifft das nicht. Ob sich die Änderung auf Inhalte auswirkt, muss der Co-PI klären.
2. **(Hinweis für späteren Text)** Das IPW-Perzentil-Intervall für rl2 schließt die Null aus: [−0.681991, −0.053441] (`t025_selection.csv`, Zeile 8). Das Baseline-Intervall schließt sie ein: [−0.570381, 0.002754]. Die Lee-Hülle für rl2 ist vollständig negativ: [−1.448939, −0.188338]. Die Hülle für mi_share ist vollständig positiv: [0.011478, 0.136830]. Bericht und TEX-Notes behaupten an keiner Stelle Signifikanz. Wenn diese Ergebnisse in `proposal/` übernommen werden, darf daraus keine Signifikanz des Haupteffekts abgeleitet werden. Lee-Bounds sind laut Note ausdrücklich nicht mit β vergleichbar.

Sonst habe ich keine Abweichungen zwischen Outputs, TEX-Tabellen, Notes und Bericht gefunden. Im Einzelnen:
- **`t025_selection.tex` gegen `t025_selection.csv`:** Alle 20 Koeffizienten, SE, CI-Grenzen, N/Firmen und Draws (gültig/fehlgeschlagen) stimmen nach Rundung auf 6 Stellen überein. Für mi_share und jv_ta ist die Heckman-SE in der CSV `NA` und im TEX `--`. Das entspricht der Bootstrap-Regel der Karte.
- **Baseline gegen `t009_did_main.csv`:** Koeffizient, SE, CI und N stimmen für alle fünf Outcomes überein. Maximale Abweichung laut `t025_baseline_validation.csv`: 2.2e-15.
- **S6 gegen `t011_robustness.csv`:** Koeffizient, SE, CI, N und Firmenzahl stimmen für alle fünf Outcomes überein.
- **Diagnostik-Panel im TEX gegen `t025_first_stage_diagnostics.csv`:** Die Werte für Z (Koeffizient, Cluster-SE, z, p) stimmen überein. Auch die Aussagen der Note treffen zu: Z ist durchgehend negativ und nirgends signifikant (p 0.169–0.401), 7 Firmen haben Z < 1. Fehlende Vorperiodenmittel betreffen bei mi_share 2 Firmen mit 2 beobachteten Post-Zeilen, bei jv_ta 22 Firmen mit 2 Post-Zeilen. Das deckt sich mit der Diagnose-CSV und mit `t025_missing_predictors.csv`.
- **`t025_lee_bounds.tex` gegen `t025_lee_bounds.csv`:** Die Grenzen, die Hülle (`outer_ci_*` = untere Grenze von `lower_ci` und obere Grenze von `upper_ci`, wie in der Note beschrieben), die Risikozahlen und die Raten stimmen überein. Auch die innere Konsistenz passt:
  - Risikomenge: 43 + 51 + 30 ausgeschlossene mittlere Firmen = 124. Bei mi_share kommt 1 Firma ohne Vorperiodenwerte hinzu, bei jv_ta 9 + 6.
  - Getrimmt wird jeweils die Gruppe mit der höheren Beobachtungsrate (bei jv_ta die hohe, sonst die niedrige).
  - Trimmanteil rl1: (0.980392 − 0.953488) / 0.980392 = 0.027442 ✓.
  - Der ungetrimmte Wert liegt jeweils zwischen den Grenzen.
- **Verschiebungen in Baseline-SE im Bericht (Kriterium 4):** Alle 15 Werte stimmen mit `shift_in_baseline_se` überein. Nachgerechnet für Heckman rl1: (−0.021908 + 0.014909) / 0.010068 = −0.695 ✓.
- **Attrition:** Die Ausgangszahl der Karte (2022H2, gerundete Dosis 3 gegen 0: 6/28 gegen 2/31 fehlend bei rl1) wird in `t025_attrition.csv` reproduziert.
- **Notation:** Die Dosis-Definition (2017H1–2019H2) stimmt mit der T009-Note überein. Post beginnt 2020H2. Z verwendet 7 Vorperiodentermine (2016H2–2019H2). Die IPW-Ersatzvariable `reported_2020h1` ist wie von der Karte gefordert offengelegt. Die drei geforderten Sätze (schwache Exclusion, Kollinearität von λ, IPW-Gewichtung innerhalb der Firmen) stehen in der Note.
- **Label und Querverweise:** `tab:selection` und `tab:lee_bounds` sind eindeutig. Es gibt keine `\cite`-Befehle, und die Sonderzeichen sind escaped (`mi\_share`, `rl2\_gap`, `jv\_ta`).
- **README:** Pipeline-Zeile, Output-Tabelle und Changelog beschreiben die tatsächlichen Dateien. Schritt 09 steht in `run_all.R` und in `run_all.sh` direkt nach 08.

## Abnahmekriterien
1. **Baseline reproduziert T009 (1e-12):** belegt erfüllt, soweit es die Konsistenz betrifft. Die Zahlen sind identisch, und `t025_baseline_validation.csv` weist eine maximale Abweichung von 2.2e-15 aus. Ob die Assertion im Code korrekt umgesetzt ist, gehört nicht zu meiner Rolle (estimation).
2. **Erste Stufe und Exclusion-Kandidat berichtet; Bootstrap mit Seed; zwei Läufe byte-identisch:** Die erste Stufe und Z sind in CSV und TEX konsistent berichtet, der Seed 20261016 wird in der Note genannt (belegt). Die Byte-Identität der beiden Läufe ist nicht meine Rolle; sie ist nur im Verifikationstext behauptet.
3. **Bestehende Outputs byte-identisch:** nicht meine Rolle (siehe auch „Nicht geprüft“).
4. **Bericht interpretiert die Verschiebung relativ zur Baseline-SE:** belegt erfüllt. Die Zahlen stimmen mit der CSV überein, und die Deutung „Fragilität, keine Attritionsverzerrung“ passt zur TEX-Note.

## Nicht geprüft
- **Byte-Identität der bestehenden Outputs:** Das Skript meldet Änderungen der Zeitstempel an zahlreichen bestehenden Outputs, etwa `t009_did_main.csv` und `t011_*`. Laut Worker sind sie byte-identisch. SHA-Werte habe ich nicht verglichen; das ist Aufgabe der Rollen data und estimation bzw. der Prüfsummen. Die mir vorliegenden Inhalte von `t009_did_main.csv` und `t011_robustness.csv` stimmen mit T025 überein.
- **Inhalt der Änderung an `state/STATE.md`:** nicht geprüft.
- **Korrektheit von Code, Probit, Bootstrap und Lee-Trimmung:** nicht meine Rolle. Geprüft habe ich nur, ob Outputs und Text übereinstimmen.
- **Zahlen aus T025 in `proposal/`:** Die Karte berührt `proposal/` nicht, deshalb gab es keinen Proposal-Text zu prüfen.
- **LaTeX-Kompilierung der Tabellen:** nicht selbst ausgeführt.
