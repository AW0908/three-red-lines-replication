## Rolle: estimation (claude, opus) – VERDICT: PASS


## Befunde

Ich habe keine Schätzfehler gefunden, die eine Nacharbeit innerhalb der Karte erfordern. Die folgenden Hinweise betreffen Interpretation und Kalibrierung. Sie blockieren nicht und sollten in T064 bzw. vom PI berücksichtigt werden.

1. **Die Simulationsergebnisse hängen von der unzentrierten, schiefen Fehlerverteilung ab (PI-Entscheidung, kein Codefehler).**
   - Die Fehler ε = constructed − published haben einen Mittelwert von +0,0099 und einen Median von 0,0012. Das Minimum liegt bei −0,0079, das Maximum bei 0,164 (`t063_noise_calibration.csv`, Zeilen 4–14).
   - ε wird unzentriert addiert (`22_referee5.R:166`). Damit schiebt das Rauschen bewegte Firmen systematisch über 0,70. Bei β = 0,01 hebt der Mittelwert den Puffer im Schnitt fast auf.
   - Die Normalverteilungsanpassung (μ = 0,0099, σ = 0,026, Z. 167) erzeugt dagegen deutlich negative Fehler, die im empirischen Träger nicht vorkommen. Deshalb unterscheiden sich die Ergebnisse stark:
     - empirisch: 2 Zellen treffen beide beobachteten Werte (ID 48/49);
     - normal: 6 Zellen treffen beide; die beste Normalzelle 127 trifft die Mittelwerte mit b = 3,07 / above = 1,43 nahezu.
   - Die Karte schreibt diese Kalibrierung vor, und der Worker dokumentiert „without centering“. Die Folgerung „beidseitige Überschussmasse ist mit unpräziser Steuerung vereinbar“ hängt aber direkt vom Vorzeichen und der Schiefe einer Messdifferenz ab, nicht von einem beobachteten Steuerungsfehler.
   - Empfehlung für T064: diese Abhängigkeit ausdrücklich nennen. Eine zentrierte Variante wäre eine neue Spezifikation und damit eine PI-Entscheidung.
2. **Die Übereinstimmungsregel berücksichtigt nur die Simulationsstreuung.**
   - Die Basisverteilung (797 Vorperioden-Beobachtungen) bleibt fix. Die Stichprobenunsicherheit von b_post (3,14) und above (1,75) geht nicht ein. Die Simulationsbereiche entsprechen außerdem n = 797, die Beobachtung hat n = 630.
   - Code und Tabellenfußnote kennzeichnen die Regel ausdrücklich als „descriptive, not a joint test“ (Z. 191–192, 234–235). Ausreichend benannt, also kein Mangel.
3. **„Excess on both sides“ ist eine Niveaugröße.**
   - Schon die unveränderte Vorperiodenverteilung hat above-b = 0,850 (π = 0 in `t063_noise.csv`, Zeile 2).
   - `mean_excess_both_sides` misst also nicht, was das Rauschen erzeugt. Der Interpretationstext sagt das korrekt (Z. 486–487); in T064 darf es nicht verloren gehen.
4. **Hinweis zur Konsistenz (nicht meine Rolle):** Der Worker-Bericht beschreibt in Schritt 1 nur den empirischen Mittelwertabgleich. Dass die Normalanpassung beide Mittelwerte nahezu trifft (Zelle 127), steht nur indirekt als Zählung im Interpretationstext.

## Geprüfte Schätzaspekte

**Spezifikation**
- `fit_counts` (Z. 97–105) bildet den T061-Schätzer nach: 0,01-Bins, Polynom 5. Grades über [0,40; 1,00], Ausschluss [0,66; upper), Masse [mlo; mhi), b = (obs − cf)/(cf/#Bins). Die Regel „ungültig bei pred ≤ 0“ ist identisch mit `21_diff_bunching.R:77–79`.
- Das Skript validiert unabhängig mit hist/lm/predict (Fehler < 1e-10, Z. 131–142). Bei upper = 0,70 prüft es Gleichheit mit `change()` aus T061 (Z. 140).
- Gegenprobe Simulation, π = 0: b = −0,877 (= b_pre), above = 0,850, below_wide = −0,676. Das entspricht T058 `070_074` pre.
- Gegenprobe Fenster: Entwickler post 4,103 / 5,755 = T058 `below_excess_b`/`total_excess_b` post. Die Fensterschätzungen sind damit über zwei unabhängige Skripte konsistent.
- Die Statistik „above“ (Ausschluss [0,66; 0,74), Masse [0,70; 0,74), Z. 187) entspricht der Definition von `t058_above` (`20_referee4.R:343–347`).

**Simulation**
- Das Targeting wird je Firma als Bernoulli gezogen; bewegt werden nur Beobachtungen in [0,70; 0,70 + Δ], gezielt auf 0,70 − β plus ε.
- Gemeinsame Zufallszahlen über alle Gitterzellen, fester Seed (seed + 1).
- Die Indizierung der empirischen Ziehung (`floor(u·n)+1`, mit `pmin`) ist korrekt.

**Stichprobe**
[firm-specific excerpt withheld in public audit]
- Kontrolle 4.512/752 bzw. 3.760/752. Ohne Zulieferer 596, nur Zulieferer 156 Firmen; disjunkt per `stopifnot` (Z. 305–306).
- N, Firmen und Fensterbesetzung stehen je Zeile in den CSVs. Die Ausschluss- und Massenbereiche sind als Spalten ausgewiesen.

**Inferenz**
- 999 Ziehungen ganzer Firmen, Vor- und Nachperiode gepaart, Populationen unabhängig.
- ΔΔb wird je Ziehung gebildet (`z$delta − zz$delta`, Z. 264), Perzentil-KI aus denselben Ziehungen, die als Draws abgelegt sind (Z. 270, 284).
- Mehrfachtests sind benannt („Pointwise CIs, no multiplicity adjustment“).
- Die Ein-Beobachtung-Perzentile sind korrekt als Auswahlverteilung, nicht als Stichproben-KI, gekennzeichnet.
- Die Auswahl `ii[sample.int(length(ii),…)]` vermeidet die `sample()`-Falle bei Firmen mit nur einer Beobachtung.

**Identifikation im Code**
- Keine Kontrollvariablen nach der Behandlung.
- Die Gruppenzugehörigkeit zu den Zulieferbranchen kommt aus `board`, nicht aus dem Outcome.
- Pre- und Post-Perioden laufen über `period_masks` aus T061.

**Ausgabe**
- `record()` überträgt Schätzung, KI und die Niveaus je Seite direkt aus den Modellobjekten.
- Die TeX-Tabellen ziehen dieselben Spalten. Stichprobe: `control_sens.tex`, „D all − C other“, 4,589 [2,135; 7,549], entspricht dem Bericht.
- Distinct firms 35/43/96/91 stimmen mit `window_firms` in `t063_window.csv` überein.

**Abgleich (Schritt 6)**
- Die KI von T061 und T058 werden aus den gespeicherten Draws nachgerechnet und gegen die Tabellen geprüft (< 1e-10, Z. 453–455).
- Die Kontrollschätzungen bei 0,70 und 0,60 sind verschieden (−0,57367 vs. −0,57118) und haben verschiedene Fit- und Massenbereiche.

## Abnahmekriterien

1. **Reproduktion / Byte-Identität**
   - Die Reproduktionsasserts sind belegt erfüllt: `22_referee5.R:79–87`. Δb = 4,020042, ΔΔb = 4,593714 und 4,479751; die Punktwerte stimmen mit `t061_estimates` auf 1e-10 überein.
   - Byte-Identität der bestehenden Ausgaben und zweier Läufe ist im Code als Guard angelegt (Z. 527–549). Selbst prüfen konnte ich sie nicht (siehe „Nicht geprüft“).
2. **Jede Variante mit N, Firmen und Fensterbesetzung:** belegt erfüllt, soweit Schätzungen betroffen.
   - 198 Simulationszellen, alle mit 1.000 gültigen Läufen.
   - 16 Zeilen Fenstertabelle, 16 Zeilen Branchentabelle, 3 Ein-Beobachtung-Zeilen, jeweils mit Besetzungsspalten.
   - Die Halbjahresverteilungen (Schritt 5) sind deskriptiv und nicht meine Rolle.
3. **Keine handerhobenen Daten:** nicht meine Rolle. Die T040-Validierungsdaten sind laut Karte vorgeschriebene Eingabe.

## Nicht geprüft

- **Byte-Identität zweier Läufe und unveränderte bestehende Ausgaben:** Ich darf keine Befehle ausführen. Grundlage ist nur die im Code angelegte Prüfung und die vom Worker berichtete Ausgabe.
  - Randnotiz (Reproduzierbarkeit, nicht meine Rolle): `t063_verification.csv` enthält Hashes von `README.md`, `run_all.R` und `run_all.sh`. Jede spätere Änderung daran verändert diese Ausgabedatei. Die Wiederholungsprüfung (Z. 543–544) wird dann stillschweigend übersprungen.
- Die Perzentile in `t063_bootstrap_draws.csv` und `t063_one_obs_draws.csv` habe ich nicht numerisch nachgerechnet. Geprüft habe ich nur, dass Draws und KI im Code aus demselben Objekt stammen.
- Datenaufbereitung, also die Branchenzuordnung über das Trennzeichen in `board`, die T040-Paare und der CNKI-Abgleich, gehört zu den Rollen data und consistency.
- Abbildung `t063_by_date.pdf`, TeX-Layout und Sprache habe ich nicht geprüft. `t063_noise_shapes.pdf` habe ich angesehen: vier Panels, darunter zwei Panels ohne Rauschen (frictionless), beobachtete gegen simulierte Verteilung.
