## Rolle: estimation (claude, opus) – VERDICT: PASS


## Befunde
Ich habe keine Mängel gefunden, die eine Nacharbeit erfordern. Die folgenden Punkte blockieren die Abnahme nicht. Sie sind für die Darstellung relevant:

1. **Die Intervalle in einer Zeile sind unterschiedlich berechnet.** Beleg: `t025_selection.tex`, Zeilen 17–18. Baseline und S6 haben Cluster-t-Intervalle. Heckman und IPW haben Perzentil-Intervalle aus dem Bootstrap. Für IPW bei rl2 schließt das Intervall die Null aus (−0.682 bis −0.053), das Baseline-Intervall nicht (−0.570 bis 0.003). Die Note legt die Methode offen (Zeile 52). Im Text darf daraus aber keine „Signifikanz durch IPW“ werden. Die konditionale Cluster-SE für IPW liegt bei 0.159 (`t025_selection.csv`, Zeile 8, Spalte `clustered_std_error`). Sie ist kaum größer als die Baseline-SE.
2. **IPW-Logit ohne Datumsdummies.** Beleg: `09_selection.R:95`. Deshalb ist p̂ innerhalb einer Firma über alle Post-Daten gleich, und die Gewichte erfassen keine Abwanderung, die mit der Zeit zunimmt. Das entspricht wörtlich Kartenschritt 3 („pre-period characteristics“). Es ist also kein Verstoß, schwächt IPW aber als Korrektur genau der späten Attrition, um die es in der Karte geht (2022H2). Das sollte im Text als Einschränkung erscheinen.
3. **Heckman-Shift bei mi_share ohne SE.** Beleg: `t025_selection.csv`, Zeile 11. Ausgewiesen ist eine Verschiebung von −1.18 Baseline-SE. Die SE ist nach der Kartenregel unterdrückt (109 von 499 Draws fehlgeschlagen). Die Verschiebung ist korrekt berechnet, sollte aber nicht ohne diesen Hinweis zitiert werden.

**Was ich im Code zur Schätzung nachvollzogen habe:**
- **Spezifikation.** Baseline ist `y ~ dose_pre:post | firm_id + date`, geclustert nach Firma, mit Entfernung der Singletons (Z. 32–33). Der Abgleich mit T009 umfasst alle Spalten, mit Assert bei 1e-12 (Z. 44–46). Die maximale Abweichung beträgt 2.2e-15 (`t025_baseline_validation.csv`).
- **Heckman.** Ein gepoolter Probit nur über die fünf Post-Daten (Z. 134, 141). Regressoren sind dose_pre, das Vorperiodenmittel des Outcomes, das Vorperiodenmittel von log TA, Markt, Datumsdummies und Z, bei Bedarf der Missing-Indikator. Das entspricht der Korrektur nach dem ersten ESCALATE.
  - λ ist auf allen Nicht-Post-Zeilen 0, auch 2020H1, mit Assert (Z. 148–150). Die Mills-Ratio wird auf Log-Skala berechnet, also numerisch stabil.
  - In die zweite Stufe geht ein einziges λ ein (Z. 128).
  - Die Beobachtungen der zweiten Stufe sind per `setequal` mit der Baseline identisch (Z. 246–247).
- **Cluster-SE für Z (Z. 113–126).** Der Score ist X·(Arbeitsresiduum × Arbeitsgewicht). Das ergibt für den Probit den korrekten Score. Bread ist `cov.unscaled` mit Dispersion 1, die Korrektur für kleine Stichproben ist G/(G−1)·(N−1)/(N−K). Das ist korrekt.
- **Bootstrap.** 499 Draws über ganze Firmen, Seed 20261016 (Z. 318–319). Doppelt gezogene Firmen bekommen eigene FE-IDs (Z. 325). Beide Stufen werden in jedem Draw neu geschätzt.
  - Die Ausfallregel entspricht dem dritten ESCALATE: Separation oder keine Konvergenz (Z. 137–144). Fehlgeschlagene Draws werden ausgeschlossen, nicht ersetzt. Ab mehr als 10 % Ausfällen werden SE und CI unterdrückt (Z. 363–371).
  - IPW und Lee laufen auch in Draws, in denen Heckman fehlschlägt (Z. 333–336). Laut Assert sind für IPW alle 499 Draws gültig (Z. 395).
- **IPW.** Logit über die Post-Zeilen; Gewicht 1/p̂ nur für beobachtete Post-Zeilen, gestutzt am 1. und 99. Perzentil (Typ 7). Zeilen der Vorperiode haben Gewicht 1 (Z. 154–166). `reported_2020h1` kommt nur im Logit vor, wie entschieden.
- **Lee-Bounds.** Die Gruppe mit der höheren Beobachtungsquote wird gestutzt, und die Richtung der Bounds stimmt in beiden Fällen.
  - Ist p1 ≤ p0, ergibt sich die untere Grenze als mean(x1) minus dem Mittel des oberen Anteils von x0. Beide Fälle habe ich gedanklich durchgerechnet (Z. 190–198). Fraktionale Randmasse wird korrekt behandelt (Z. 170–176).
  - Die Firmen werden mit denselben Indizes `ii` gezogen wie für Heckman und IPW.
- **Übertragung in die Ausgaben.** Koeffizienten, SE und CI der TEX-Datei stimmen Zeile für Zeile mit `t025_selection.csv` überein (stichprobenartig geprüft für rl1, rl2 und mi_share). Die S6-Zeilen entsprechen `t011_robustness.csv`, Zeilen 32–36, auch in N und Firmenzahl.
- **Verschiebungen.** Ich habe sie nachgerechnet:
  - Heckman rl2: (−0.62757 + 0.28381) / 0.14477 = −2.374
  - IPW rl1: (−0.015182 + 0.014909) / 0.010068 = −0.027

  Beide stimmen.

## Abnahmekriterien
1. **Baseline reproduziert T009 exakt: belegt erfüllt.** Es gibt einen Assert mit Toleranz 1e-12 über alle numerischen Spalten (Z. 44–46). Die maximale Abweichung beträgt 2.2e-15.
2. **Erste Stufe und Ausschlussvariable berichtet, Bootstrap mit Seed, zwei Läufe byte-identisch.**
   - Erste Stufe: **belegt erfüllt.** `t025_first_stage_diagnostics.csv` enthält Koeffizient, Cluster-SE, z, p, die Zahl der Firmen mit Z < 1 (7) und das Label „weak exclusion“. Der Seed steht im Code.
   - Byte-Identität: nur belegt, soweit `t025_verification.txt` sie dokumentiert (gleiche SHA-256 über run1, run2 und Workspace). Ich habe die Läufe nicht selbst wiederholt.
3. **Bestehende Outputs byte-identisch: nicht meine Rolle.** Im Code gibt es dafür einen Hash-Assert (Z. 484–485). Die vom Skript gemeldeten Änderungen an t009 und anderen Dateien nach Änderungszeit widersprechen dem nicht: Die SHA-256-Werte sind laut Prüfprotokoll gleich. Das muss der Data- bzw. Consistency-Reviewer bestätigen.
4. **Bericht ordnet die Verschiebungen in Baseline-SE ein: belegt erfüllt.** Der Worker-Bericht enthält eine Tabelle der Verschiebungen. Die Heckman-Verschiebungen sind als Fragilität eingeordnet, nicht als Beleg für Attritionsverzerrung, mit der Begründung der Kollinearität (Note in der TEX-Datei).

## Nicht geprüft
- **Ausführung:** Ich habe nichts ausgeführt, also auch die Byte-Identität zweier Läufe nicht selbst nachvollzogen. Ebenso ungeprüft sind die Zahl der Draws mit Separation, die tatsächliche Konvergenz in jedem Draw und die Inhalte von `t025_bootstrap_draws.csv` und `t025_selection_audit.csv` über eine Stichprobe hinaus.
- **Lee-Inferenz:** Ob die Lee-Hülle (Perzentile der Endpunkte) eine angemessene Inferenz ist, beurteile ich nicht über die offengelegte Einschränkung hinaus. Es ist kein Imbens–Manski-Intervall.
- **Andere Rollen:** Datenaufbereitung (Z, Vorperiodenmittel, `has_row`/S6-Definition, Attritionstabelle), README, Registrierung in `run_all` und Sprache gehören nicht zu meiner Rolle.
- **STATE.md:** Laut Skript wurde die Datei nach Beginn der Ausführung geändert. Für die Schätzung ist das nicht relevant. Laut Verifikation ist der Hash innerhalb der Läufe stabil; die Änderung stammt vermutlich vom Co-PI. Ich habe das nicht geprüft.
