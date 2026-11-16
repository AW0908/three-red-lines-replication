## Rolle: estimation (declared=claude, effective=claude, high, Modell=opus) – VERDICT: PASS


## Befunde

[number withheld]. **Kleinerer Punkt, blockiert nicht: Die „negative Kontrolle“ prüft weniger, als Bericht und Name behaupten.** `datewise_resampling_negative_control` (`replication/code/26_identification.R:479-482`) vergleicht nur Ziehung [number withheld] mit einer Kopie von Ziehung [number withheld], in der Stichtag [number withheld] durch den Wert aus Ziehung [number withheld] ersetzt ist. Die Abweichung von [number withheld]/[number withheld] (`t077_validation.csv:52`) zeigt nur, dass sich die beiden Ziehungen an diesem Datum unterscheiden. Eine Prüfroutine, die einen falschen Resample tatsächlich „erkennt“ (Bericht Z. [number withheld]), läuft dabei nicht. **Auswirkung:** keine. Die eigentliche Prüfung des Ganzfirmen-Resamplings leistet der Vergleich mit ausdrücklich kopierten Firmenhistorien (`:[number withheld][number withheld]`). Er läuft in balancierten und lückenhaften Panels für alle Outcomes, Stichtage und Kontraste, mit Fehler [number withheld] (`t077_validation.csv:50-51`). Diese Prüfung ist echt und nicht trivial. Bei einer Überarbeitung des Berichts sollte die Formulierung abgeschwächt werden.

[number withheld]. **Hinweis für den PI, kein Fehler: verbleibende Seed-Abhängigkeit und Modellabhängigkeit.** Monte-Carlo-Streuung, Referenzabhängigkeit und abweichendes Trendsensitivitätsziel sind jetzt offengelegt (Bericht Z. [number withheld]–[number withheld]). Eine Stabilitätsprüfung über weitere Seeds oder mit größerem B gibt es weiterhin nicht. Der Bericht sagt das ausdrücklich (Z. [number withheld], [number withheld]), und die Karte verlangt eine solche Prüfung nicht. Für eine spätere Proposal-Integration bleibt die Empfehlung: ein unabhängiger Neulauf mit anderem Seed oder größerem B (siehe „Nicht geprüft“).

Die Befunde [number withheld]–[number withheld] des vorigen Estimation-Reviews (`review/T077_estimation.md`) sind behoben:

- **Befund [number withheld], harter Test mit bekanntem Ergebnis: behoben.** Ich habe das synthetische Panel (`:[number withheld][number withheld]`) von Hand vollständig nachgerechnet:
  - Die Zuordnung `expand.grid` → `as.vector` ist spaltenweise, die Firma läuft also zuerst. Das passt.
  - Die Zuordnung z → rl1 nutzt [number withheld] (L), [number withheld]/[number withheld] (P6[number withheld]/P8[number withheld]) und [number withheld] (U). Damit ist Z jeweils exakt [number withheld] / [number withheld] / [number withheld].
  - **Originalziehung:**
    - Differenzen dev−ctl je Datum: [number withheld]/[number withheld], [number withheld], [number withheld]/[number withheld], [number withheld]/[number withheld], [number withheld], [number withheld]/[number withheld], [number withheld]/[number withheld] | [number withheld] | [number withheld]/[number withheld], [number withheld]/[number withheld], [number withheld]/[number withheld], [number withheld]/[number withheld], [number withheld]/[number withheld].
    - Pre-Mittel [number withheld]/[number withheld], Post-Mittel [number withheld]/[number withheld], also θ = [number withheld]/[number withheld] ✓.
    - Dynamik gegenüber [number withheld]H2 ([number withheld]/[number withheld]): ([number withheld]/[number withheld], [number withheld]/[number withheld], [number withheld], [number withheld]/[number withheld], [number withheld], [number withheld]/[number withheld], [number withheld], [number withheld]/[number withheld], [number withheld]/[number withheld], [number withheld]/[number withheld]) ✓.
  - **Ziehung [number withheld]** (Wd = ([number withheld]), Wc = ([number withheld])):
    - Pre [number withheld]/[number withheld], Post [number withheld]/[number withheld], also θ = [number withheld]/[number withheld] ✓.
    - Dynamik ([number withheld]/[number withheld], [number withheld], [number withheld]/[number withheld], [number withheld], [number withheld]/[number withheld], [number withheld]/[number withheld], [number withheld]/[number withheld], [number withheld], [number withheld], [number withheld]) ✓.
  - **Ziehung [number withheld]** (Wd = ([number withheld]), Wc = ([number withheld])):
    - Pre [number withheld]/[number withheld], Post [number withheld]/[number withheld], also θ = [number withheld]/[number withheld] ✓.
    - Dynamik ([number withheld]/[number withheld], [number withheld]/[number withheld], [number withheld]/[number withheld], [number withheld]/[number withheld], [number withheld]/[number withheld], [number withheld]/[number withheld], [number withheld]/[number withheld], [number withheld]/[number withheld], [number withheld]/[number withheld], [number withheld]/[number withheld]) ✓.
  - Der Test läuft durch `yfun()`, `build()` mit deterministischem W, `crossprod(W,z)/den`, `period_contrast()` und `reference_contrast()`. Genau diese Funktionen nutzt auch die Produktion (`:[number withheld]`, `:[number withheld]`).
  - `half_open_boundaries` wird jetzt tatsächlich berechnet: Werte je ±[number withheld] um beide Grenzen (`:[number withheld][number withheld]`).
  - `firm_histories_resampled` in den Diagnostics beruht auf einer echten Neuberechnung einer Bootstrapziehung über `rep()` (`:[number withheld][number withheld]`).
  - Die Tests verbrauchen keine Zufallszahlen. Sie laufen nach allen Schätzungen, und `build()` ruft nur dann `rmultinom` auf, wenn `W` NULL ist.
- **Befund [number withheld], Monte-Carlo-Streuung: offengelegt** (Bericht Z. [number withheld], [number withheld]). Die gerundeten Werte stimmen:
  - p-Werte [number withheld] / [number withheld],
  - Wald-p [number withheld] / [number withheld],
  - kritische Werte [number withheld] / [number withheld] (`t0[number withheld]_diagnostics.csv:[number withheld]`),
  - [number withheld]H1 obere simultane Grenze [number withheld] pp (`t077_dynamics.csv:72`).
- **Befund [number withheld], Referenzabhängigkeit und Sensitivitätsziel: offengelegt**, Zahlen nachgerechnet:
  - A-Entwickler-Z: [number withheld]H2 [number withheld] / [number withheld]H1 [number withheld] / [number withheld]H1 [number withheld] (`t0[number withheld]_components.csv:[number withheld]`).
  - Post-Mittel der dynamischen Z gegenüber [number withheld]H2:
    - A: ([number withheld] − [number withheld] + [number withheld] + [number withheld] + [number withheld])/[number withheld] = **[number withheld] pp** ✓
    - HK: ([number withheld] + [number withheld] + [number withheld] + [number withheld] + [number withheld])/[number withheld] = **[number withheld] pp** ✓
  - Konsistenzprüfung: Post-Mittel minus Mittel der sechs Pre-Koeffizienten (Referenz = [number withheld]) ergibt wieder θ:
    - A: [number withheld] + [number withheld] = [number withheld] ✓
    - HK: [number withheld] − [number withheld] = [number withheld] ✓
- **Befund [number withheld]: offengelegt.** Wald-Test mit Bootstrap-Kovarianz und χ²([number withheld]) als nur diagnostisch (Bericht Z. [number withheld]). Fünf Wald-p-Werte gerundet [number withheld] / [number withheld] / [number withheld] / [number withheld] / [number withheld] ✓ (`t077_diagnostics.csv:2-6`). `window_unique_firms` = `window_observations` ✓.

## Abnahmekriterien

[number withheld]. **Belegt erfüllt, soweit es meine Rolle betrifft.**
   - Fenster halboffen (`:[number withheld][number withheld]`), jetzt zusätzlich berechnet geprüft.
   - Pre = [number withheld] Daten, Post = [number withheld] Daten, [number withheld]H1 ausgeschlossen, Referenz [number withheld]H2.
   - Zehn dynamische Koeffizienten (`:[number withheld]`); Reihenfolge in `t077_specification.csv`.
   - Gleiche Gewichte je Firma und Datum; unabhängige Gewichtungsprüfung (`t077_validation.csv:58-75`).
   - Die Spezifikationsdatei ist byte-identisch mit dem Archiv.
[number withheld]. **Belegt erfüllt.**
   - [number withheld] Kontraste, alle `OK`, je [number withheld]/[number withheld] Ziehungen (`t077_estimates.csv`).
   - Die lineare Kovarianz für unbalanciertes HK ist ausdrücklich NA (`t077_diagnostics.csv:5`).
   - Die Berichtstabelle (Z. [number withheld]–[number withheld], [number withheld]–[number withheld]) stimmt mit `t077_estimates.csv` überein.
[number withheld]. **Belegt erfüllt, soweit es meine Rolle betrifft.**
   - Zellrekonstruktion max. [number withheld] (`t077_validation.csv:2-46`).
   - Synthetischer Produktionspfadtest gegen Sollwerte, von mir von Hand bestätigt.
   - Historienkopie-Test mit Fehler [number withheld]; alle [number withheld] Prüfungen sind `TRUE`.
   - Statistische Unverändertheit stichprobenartig selbst geprüft: Die Hashes von `t0[number withheld]_estimates`, `_dynamics`, `_bootstrap_draws` stimmen in drei Quellen überein:
     - `review/T0[number withheld]_frozen.sha2[number withheld]:[number withheld]`,
     - Archiv-Manifest `state/run_archive/.../SHA2[number withheld]SUMS:[number withheld]`,
     - `t077_rework1_check.csv`.

     Die Rework-Änderung hat die Schätzung damit nachweislich nicht verändert.
   - Byte-Identität zweier Läufe und Schutz der übrigen Dateien: nicht meine Rolle. Belegt ist das nur durch die Worker-Datei `t077_rework1_check.csv`.
[number withheld]. **Belegt erfüllt.**
   - Gemeinsame Ganzfirmenziehungen, nach Markt und Gruppe stratifiziert.
   - Simultane Bänder mit Max-|t| und festen Bootstrap-SE (`:[number withheld][number withheld]`); Stichprobe: [number withheld] − [number withheld] × [number withheld] = [number withheld] ✓.
   - Zentrierte zweiseitige p-Werte.
   - Holm: min([number withheld]; [number withheld] × [number withheld]) = [number withheld], max([number withheld]; [number withheld]) = [number withheld] ✓.
   - Fehlgeschlagene Ziehungen = [number withheld]; Seed-Abhängigkeit ist jetzt offengelegt.
[number withheld]. **Belegt erfüllt (NOT RUN).**
   - Alle [number withheld] Zeilen NOT RUN mit Begründung; keine Ersatzmethode.
   - Die Abweichung zwischen Sensitivitätsziel und θ ist offengelegt.
   - Der Bericht leitet aus nicht verworfenen Vortrends keine Kausalaussage ab (Z. [number withheld], [number withheld]).
[number withheld]. **Nicht meine Rolle** (Darstellung/Consistency). Die Trennung von Wahrscheinlichkeitskontrast und polynomialer Überschussmasse steht in `t077_figure_notes.csv`, gemäß Skript `:[number withheld]`. Die PDFs habe ich nicht visuell geprüft.

## Nicht geprüft

- **Nichts ausgeführt.** Kein R- oder Python-Lauf, nur Lesezugriff. Bootstrap-Perzentile, Kovarianzen und simultane kritische Werte habe ich nicht neu berechnet, sondern nur Formeln, Code-Algebra und Stichpunkte geprüft.
- **Byte-Identität zweier Läufe, Schutzinventar, PDF-Inhalte, `t077_figure_notes.csv`:** Rolle data/consistency. Meine Hash-Abgleiche (Kriterium [number withheld]) beschränken sich auf drei Statistikdateien und die Skriptdatei:
  - `26_identification.R` im Freeze = `e8f0[number withheld]ec2…`,
  - das ist identisch mit dem „after“-Wert in `t077_rework1_check.csv:109`.
- **Datenaufbereitung** (Herkunft von `rl1`/`adv_missing`, T076-Eignung): nicht meine Rolle.
- **Modellabhängigkeit:**
  - Worker ist Codex, Review Claude Opus. Das ist Prozessunabhängigkeit, keine vollständige Modellunabhängigkeit. Beide stützen sich auf dasselbe Memo, gemeinsame Spezifikationsfehler würden nicht auffallen.
  - Bei dieser High-Stakes-Schätzung (Primärkontrast, Vortrend-Diagnostik, A-Referenzabhängigkeit) bleibt dem PI die Option eines externen menschlichen Audits oder eines Audits durch ein anderes Modell.
  - Besonders lohnend wäre ein separat freigegebener Neulauf mit anderem Seed oder größerem B. Er würde zeigen, wie stark A-Vortrend-p und simultanes Band bei [number withheld]H1 streuen.
