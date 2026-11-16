## Rolle: estimation (claude, opus) – VERDICT: PASS


## Befunde

Ich habe keine Schätzfehler gefunden, die eine Nacharbeit innerhalb der Karte erfordern. Die folgenden Hinweise betreffen Interpretation und Kalibrierung. Sie blockieren nicht und sollten in T064 bzw. vom PI berücksichtigt werden.

[number withheld]. **Die Simulationsergebnisse hängen von der unzentrierten, schiefen Fehlerverteilung ab (PI-Entscheidung, kein Codefehler).**
   - Die Fehler ε = constructed − published haben einen Mittelwert von [number withheld] und einen Median von [number withheld]. Das Minimum liegt bei [number withheld], das Maximum bei [number withheld] (`t063_noise_calibration.csv`, Zeilen [number withheld]–[number withheld]).
   - ε wird unzentriert addiert (`22_referee5.R:166`). Damit schiebt das Rauschen bewegte Firmen systematisch über [number withheld]. Bei β = [number withheld] hebt der Mittelwert den Puffer im Schnitt fast auf.
   - Die Normalverteilungsanpassung (μ = [number withheld], σ = [number withheld], Z. [number withheld]) erzeugt dagegen deutlich negative Fehler, die im empirischen Träger nicht vorkommen. Deshalb unterscheiden sich die Ergebnisse stark:
     - empirisch: [number withheld] Zellen treffen beide beobachteten Werte (ID [number withheld]/[number withheld]);
     - normal: [number withheld] Zellen treffen beide; die beste Normalzelle [number withheld] trifft die Mittelwerte mit b = [number withheld] / above = [number withheld] nahezu.
   - Die Karte schreibt diese Kalibrierung vor, und der Worker dokumentiert „without centering“. Die Folgerung „beidseitige Überschussmasse ist mit unpräziser Steuerung vereinbar“ hängt aber direkt vom Vorzeichen und der Schiefe einer Messdifferenz ab, nicht von einem beobachteten Steuerungsfehler.
   - Empfehlung für T064: diese Abhängigkeit ausdrücklich nennen. Eine zentrierte Variante wäre eine neue Spezifikation und damit eine PI-Entscheidung.
[number withheld]. **Die Übereinstimmungsregel berücksichtigt nur die Simulationsstreuung.**
   - Die Basisverteilung ([number withheld] Vorperioden-Beobachtungen) bleibt fix. Die Stichprobenunsicherheit von b_post ([number withheld]) und above ([number withheld]) geht nicht ein. Die Simulationsbereiche entsprechen außerdem n = [number withheld], die Beobachtung hat n = [number withheld].
   - Code und Tabellenfußnote kennzeichnen die Regel ausdrücklich als „descriptive, not a joint test“ (Z. [number withheld]–[number withheld], [number withheld]–[number withheld]). Ausreichend benannt, also kein Mangel.
[number withheld]. **„Excess on both sides“ ist eine Niveaugröße.**
   - Schon die unveränderte Vorperiodenverteilung hat above-b = [number withheld] (π = [number withheld] in `t063_noise.csv`, Zeile [number withheld]).
   - `mean_excess_both_sides` misst also nicht, was das Rauschen erzeugt. Der Interpretationstext sagt das korrekt (Z. [number withheld]–[number withheld]); in T064 darf es nicht verloren gehen.
[number withheld]. **Hinweis zur Konsistenz (nicht meine Rolle):** Der Worker-Bericht beschreibt in Schritt [number withheld] nur den empirischen Mittelwertabgleich. Dass die Normalanpassung beide Mittelwerte nahezu trifft (Zelle [number withheld]), steht nur indirekt als Zählung im Interpretationstext.

## Geprüfte Schätzaspekte

**Spezifikation**
- `fit_counts` (Z. [number withheld]–[number withheld]) bildet den T061-Schätzer nach: [number withheld]-Bins, Polynom [number withheld]. Grades über [[number withheld]; [number withheld]], Ausschluss [[number withheld]; upper), Masse [mlo; mhi), b = (obs − cf)/(cf/#Bins). Die Regel „ungültig bei pred ≤ [number withheld]“ ist identisch mit `21_diff_bunching.R:77–79`.
- Das Skript validiert unabhängig mit hist/lm/predict (Fehler < [number withheld], Z. [number withheld]–[number withheld]). Bei upper = [number withheld] prüft es Gleichheit mit `change()` aus T061 (Z. [number withheld]).
- Gegenprobe Simulation, π = [number withheld]: b = [number withheld] (= b_pre), above = [number withheld], below_wide = [number withheld]. Das entspricht T058 `[number withheld]_0[number withheld]` pre.
- Gegenprobe Fenster: Entwickler post [number withheld] / [number withheld] = T058 `below_excess_b`/`total_excess_b` post. Die Fensterschätzungen sind damit über zwei unabhängige Skripte konsistent.
- Die Statistik „above“ (Ausschluss [[number withheld]; [number withheld]), Masse [[number withheld]; [number withheld]), Z. [number withheld]) entspricht der Definition von `t0[number withheld]_above` (`20_referee4.R:343–347`).

**Simulation**
- Das Targeting wird je Firma als Bernoulli gezogen; bewegt werden nur Beobachtungen in [[number withheld]; [number withheld] + Δ], gezielt auf [number withheld] − β plus ε.
- Gemeinsame Zufallszahlen über alle Gitterzellen, fester Seed (seed + [number withheld]).
- Die Indizierung der empirischen Ziehung (`floor(u·n)[number withheld]`, mit `pmin`) ist korrekt.

**Stichprobe**
[firm-specific excerpt withheld in public process copy]
- Kontrolle [number withheld]/[number withheld] bzw. [number withheld]/[number withheld]. Ohne Zulieferer [number withheld], nur Zulieferer [number withheld] Firmen; disjunkt per `stopifnot` (Z. [number withheld]–[number withheld]).
- N, Firmen und Fensterbesetzung stehen je Zeile in den CSVs. Die Ausschluss- und Massenbereiche sind als Spalten ausgewiesen.

**Inferenz**
- [number withheld] Ziehungen ganzer Firmen, Vor- und Nachperiode gepaart, Populationen unabhängig.
- ΔΔb wird je Ziehung gebildet (`z$delta − zz$delta`, Z. [number withheld]), Perzentil-KI aus denselben Ziehungen, die als Draws abgelegt sind (Z. [number withheld], [number withheld]).
- Mehrfachtests sind benannt („Pointwise CIs, no multiplicity adjustment“).
- Die Ein-Beobachtung-Perzentile sind korrekt als Auswahlverteilung, nicht als Stichproben-KI, gekennzeichnet.
- Die Auswahl `ii[sample.int(length(ii),…)]` vermeidet die `sample()`-Falle bei Firmen mit nur einer Beobachtung.

**Identifikation im Code**
- Keine Kontrollvariablen nach der Behandlung.
- Die Gruppenzugehörigkeit zu den Zulieferbranchen kommt aus `board`, nicht aus dem Outcome.
- Pre- und Post-Perioden laufen über `period_masks` aus T061.

**Ausgabe**
- `record()` überträgt Schätzung, KI und die Niveaus je Seite direkt aus den Modellobjekten.
- Die TeX-Tabellen ziehen dieselben Spalten. Stichprobe: `control_sens.tex`, „D all − C other“, [number withheld] [[number withheld]; [number withheld]], entspricht dem Bericht.
- Distinct firms [number withheld]/[number withheld]/[number withheld]/[number withheld] stimmen mit `window_firms` in `t063_window.csv` überein.

**Abgleich (Schritt [number withheld])**
- Die KI von T061 und T058 werden aus den gespeicherten Draws nachgerechnet und gegen die Tabellen geprüft (< [number withheld], Z. [number withheld]–[number withheld]).
- Die Kontrollschätzungen bei [number withheld] und [number withheld] sind verschieden ([number withheld] vs. [number withheld]) und haben verschiedene Fit- und Massenbereiche.

## Abnahmekriterien

[number withheld]. **Reproduktion / Byte-Identität**
   - Die Reproduktionsasserts sind belegt erfüllt: `22_referee5.R:79–87`. Δb = [number withheld], ΔΔb = [number withheld] und [number withheld]; die Punktwerte stimmen mit `t0[number withheld]_estimates` auf [number withheld] überein.
   - Byte-Identität der bestehenden Ausgaben und zweier Läufe ist im Code als Guard angelegt (Z. [number withheld]–[number withheld]). Selbst prüfen konnte ich sie nicht (siehe „Nicht geprüft“).
[number withheld]. **Jede Variante mit N, Firmen und Fensterbesetzung:** belegt erfüllt, soweit Schätzungen betroffen.
   - [number withheld] Simulationszellen, alle mit [number withheld] gültigen Läufen.
   - [number withheld] Zeilen Fenstertabelle, [number withheld] Zeilen Branchentabelle, [number withheld] Ein-Beobachtung-Zeilen, jeweils mit Besetzungsspalten.
   - Die Halbjahresverteilungen (Schritt [number withheld]) sind deskriptiv und nicht meine Rolle.
[number withheld]. **Keine handerhobenen Daten:** nicht meine Rolle. Die T040-Validierungsdaten sind laut Karte vorgeschriebene Eingabe.

## Nicht geprüft

- **Byte-Identität zweier Läufe und unveränderte bestehende Ausgaben:** Ich darf keine Befehle ausführen. Grundlage ist nur die im Code angelegte Prüfung und die vom Worker berichtete Ausgabe.
  - Randnotiz (Reproduzierbarkeit, nicht meine Rolle): `t063_verification.csv` enthält Hashes von `README.md`, `run_all.R` und `run_all.sh`. Jede spätere Änderung daran verändert diese Ausgabedatei. Die Wiederholungsprüfung (Z. [number withheld]–[number withheld]) wird dann stillschweigend übersprungen.
- Die Perzentile in `t063_bootstrap_draws.csv` und `t063_one_obs_draws.csv` habe ich nicht numerisch nachgerechnet. Geprüft habe ich nur, dass Draws und KI im Code aus demselben Objekt stammen.
- Datenaufbereitung, also die Branchenzuordnung über das Trennzeichen in `board`, die T040-Paare und der CNKI-Abgleich, gehört zu den Rollen data und consistency.
- Abbildung `t063_by_date.pdf`, TeX-Layout und Sprache habe ich nicht geprüft. `t063_noise_shapes.pdf` habe ich angesehen: vier Panels, darunter zwei Panels ohne Rauschen (frictionless), beobachtete gegen simulierte Verteilung.
