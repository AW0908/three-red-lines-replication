## Rolle: estimation (claude, opus) – VERDICT: PASS


## Befunde
Ich habe keine Mängel gefunden, die eine Nacharbeit erfordern. Die folgenden Punkte blockieren die Abnahme nicht. Sie sind für die Darstellung relevant:

[number withheld]. **Die Intervalle in einer Zeile sind unterschiedlich berechnet.** Beleg: `t025_selection.tex`, Zeilen [number withheld]–[number withheld]. Baseline und S6 haben Cluster-t-Intervalle. Heckman und IPW haben Perzentil-Intervalle aus dem Bootstrap. Für IPW bei rl2 schließt das Intervall die Null aus ([number withheld] bis [number withheld]), das Baseline-Intervall nicht ([number withheld] bis [number withheld]). Die Note legt die Methode offen (Zeile [number withheld]). Im Text darf daraus aber keine „Signifikanz durch IPW“ werden. Die konditionale Cluster-SE für IPW liegt bei [number withheld] (`t025_selection.csv`, Zeile [number withheld], Spalte `clustered_std_error`). Sie ist kaum größer als die Baseline-SE.
[number withheld]. **IPW-Logit ohne Datumsdummies.** Beleg: `09_selection.R:95`. Deshalb ist p̂ innerhalb einer Firma über alle Post-Daten gleich, und die Gewichte erfassen keine Abwanderung, die mit der Zeit zunimmt. Das entspricht wörtlich Kartenschritt [number withheld] („pre-period characteristics“). Es ist also kein Verstoß, schwächt IPW aber als Korrektur genau der späten Attrition, um die es in der Karte geht ([number withheld]H2). Das sollte im Text als Einschränkung erscheinen.
[number withheld]. **Heckman-Shift bei mi_share ohne SE.** Beleg: `t025_selection.csv`, Zeile [number withheld]. Ausgewiesen ist eine Verschiebung von [number withheld] Baseline-SE. Die SE ist nach der Kartenregel unterdrückt ([number withheld] von [number withheld] Draws fehlgeschlagen). Die Verschiebung ist korrekt berechnet, sollte aber nicht ohne diesen Hinweis zitiert werden.

**Was ich im Code zur Schätzung nachvollzogen habe:**
- **Spezifikation.** Baseline ist `y ~ dose_pre:post | firm_id + date`, geclustert nach Firma, mit Entfernung der Singletons (Z. [number withheld]–[number withheld]). Der Abgleich mit T009 umfasst alle Spalten, mit Assert bei [number withheld] (Z. [number withheld]–[number withheld]). Die maximale Abweichung beträgt [number withheld] (`t025_baseline_validation.csv`).
- **Heckman.** Ein gepoolter Probit nur über die fünf Post-Daten (Z. [number withheld], [number withheld]). Regressoren sind dose_pre, das Vorperiodenmittel des Outcomes, das Vorperiodenmittel von log TA, Markt, Datumsdummies und Z, bei Bedarf der Missing-Indikator. Das entspricht der Korrektur nach dem ersten ESCALATE.
  - λ ist auf allen Nicht-Post-Zeilen [number withheld], auch [number withheld]H1, mit Assert (Z. [number withheld]–[number withheld]). Die Mills-Ratio wird auf Log-Skala berechnet, also numerisch stabil.
  - In die zweite Stufe geht ein einziges λ ein (Z. [number withheld]).
  - Die Beobachtungen der zweiten Stufe sind per `setequal` mit der Baseline identisch (Z. [number withheld]–[number withheld]).
- **Cluster-SE für Z (Z. [number withheld]–[number withheld]).** Der Score ist X·(Arbeitsresiduum × Arbeitsgewicht). Das ergibt für den Probit den korrekten Score. Bread ist `cov.unscaled` mit Dispersion [number withheld], die Korrektur für kleine Stichproben ist G/(G−[number withheld])·(N−[number withheld])/(N−K). Das ist korrekt.
- **Bootstrap.** [number withheld] Draws über ganze Firmen, Seed [number withheld] (Z. [number withheld]–[number withheld]). Doppelt gezogene Firmen bekommen eigene FE-IDs (Z. [number withheld]). Beide Stufen werden in jedem Draw neu geschätzt.
  - Die Ausfallregel entspricht dem dritten ESCALATE: Separation oder keine Konvergenz (Z. [number withheld]–[number withheld]). Fehlgeschlagene Draws werden ausgeschlossen, nicht ersetzt. Ab mehr als [number withheld] % Ausfällen werden SE und CI unterdrückt (Z. [number withheld]–[number withheld]).
  - IPW und Lee laufen auch in Draws, in denen Heckman fehlschlägt (Z. [number withheld]–[number withheld]). Laut Assert sind für IPW alle [number withheld] Draws gültig (Z. [number withheld]).
- **IPW.** Logit über die Post-Zeilen; Gewicht [number withheld]/p̂ nur für beobachtete Post-Zeilen, gestutzt am [number withheld]. und [number withheld]. Perzentil (Typ [number withheld]). Zeilen der Vorperiode haben Gewicht [number withheld] (Z. [number withheld]–[number withheld]). `reported_2[number withheld]h1` kommt nur im Logit vor, wie entschieden.
- **Lee-Bounds.** Die Gruppe mit der höheren Beobachtungsquote wird gestutzt, und die Richtung der Bounds stimmt in beiden Fällen.
  - Ist p1 ≤ p0, ergibt sich die untere Grenze als mean(x1) minus dem Mittel des oberen Anteils von x0. Beide Fälle habe ich gedanklich durchgerechnet (Z. [number withheld]–[number withheld]). Fraktionale Randmasse wird korrekt behandelt (Z. [number withheld]–[number withheld]).
  - Die Firmen werden mit denselben Indizes `ii` gezogen wie für Heckman und IPW.
- **Übertragung in die Ausgaben.** Koeffizienten, SE und CI der TEX-Datei stimmen Zeile für Zeile mit `t025_selection.csv` überein (stichprobenartig geprüft für rl1, rl2 und mi_share). Die S6-Zeilen entsprechen `t011_robustness.csv`, Zeilen [number withheld]–[number withheld], auch in N und Firmenzahl.
- **Verschiebungen.** Ich habe sie nachgerechnet:
  - Heckman rl2: ([number withheld] + [number withheld]) / [number withheld] = [number withheld]
  - IPW rl1: ([number withheld] + [number withheld]) / [number withheld] = [number withheld]

  Beide stimmen.

## Abnahmekriterien
[number withheld]. **Baseline reproduziert T009 exakt: belegt erfüllt.** Es gibt einen Assert mit Toleranz [number withheld] über alle numerischen Spalten (Z. [number withheld]–[number withheld]). Die maximale Abweichung beträgt [number withheld].
[number withheld]. **Erste Stufe und Ausschlussvariable berichtet, Bootstrap mit Seed, zwei Läufe byte-identisch.**
   - Erste Stufe: **belegt erfüllt.** `t025_first_stage_diagnostics.csv` enthält Koeffizient, Cluster-SE, z, p, die Zahl der Firmen mit Z < [number withheld] ([number withheld]) und das Label „weak exclusion“. Der Seed steht im Code.
   - Byte-Identität: nur belegt, soweit `t025_verification.txt` sie dokumentiert (gleiche SHA-[number withheld] über run1, run2 und Workspace). Ich habe die Läufe nicht selbst wiederholt.
[number withheld]. **Bestehende Outputs byte-identisch: nicht meine Rolle.** Im Code gibt es dafür einen Hash-Assert (Z. [number withheld]–[number withheld]). Die vom Skript gemeldeten Änderungen an t0[number withheld] und anderen Dateien nach Änderungszeit widersprechen dem nicht: Die SHA-[number withheld]-Werte sind laut Prüfprotokoll gleich. Das muss der Data- bzw. Consistency-Reviewer bestätigen.
[number withheld]. **Bericht ordnet die Verschiebungen in Baseline-SE ein: belegt erfüllt.** Der Worker-Bericht enthält eine Tabelle der Verschiebungen. Die Heckman-Verschiebungen sind als Fragilität eingeordnet, nicht als Beleg für Attritionsverzerrung, mit der Begründung der Kollinearität (Note in der TEX-Datei).

## Nicht geprüft
- **Ausführung:** Ich habe nichts ausgeführt, also auch die Byte-Identität zweier Läufe nicht selbst nachvollzogen. Ebenso ungeprüft sind die Zahl der Draws mit Separation, die tatsächliche Konvergenz in jedem Draw und die Inhalte von `t025_bootstrap_draws.csv` und `t025_selection_audit.csv` über eine Stichprobe hinaus.
- **Lee-Inferenz:** Ob die Lee-Hülle (Perzentile der Endpunkte) eine angemessene Inferenz ist, beurteile ich nicht über die offengelegte Einschränkung hinaus. Es ist kein Imbens–Manski-Intervall.
- **Andere Rollen:** Datenaufbereitung (Z, Vorperiodenmittel, `has_row`/S6-Definition, Attritionstabelle), README, Registrierung in `run_all` und Sprache gehören nicht zu meiner Rolle.
- **STATE.md:** Laut Skript wurde die Datei nach Beginn der Ausführung geändert. Für die Schätzung ist das nicht relevant. Laut Verifikation ist der Hash innerhalb der Läufe stabil; die Änderung stammt vermutlich vom Co-PI. Ich habe das nicht geprüft.
