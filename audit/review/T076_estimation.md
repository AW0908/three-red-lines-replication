## Rolle: estimation (claude, opus) – VERDICT: PASS


## Befunde
Keine Befunde, die die Schätzungen betreffen. Zwei Hinweise, die nichts blockieren:

[number withheld]. **Die Bootstrap-Ziehungen der TL/TA-Variante sind mit denen der Hauptschätzung gekoppelt.** Das ist gewollt und richtig. `25_hk_control.R:250` setzt `W$control_HK_unadjusted<-W$control_HK`. Die TL/TA-Variante nutzt also dieselben Firmenziehungen wie die Hauptkontrolle; nur `rl1` ist durch TL/TA ersetzt (`:[number withheld]–[number withheld]`). Die Variante mit berichteten Vorauszahlungen zieht ihre Gewichte dagegen neu, und zwar erst nach allen ursprünglichen Ziehungen (`:[number withheld]`). Deshalb bleiben alle bisherigen Ziehungen und die Hauptschätzung unverändert ([number withheld] [[number withheld]; [number withheld]], `t076_hk_control.csv`, Zeile [number withheld]). Die A-Share-Kontrastschätzung wird weiterhin gegen `t061_diff_bunching.csv` geprüft (Toleranz [number withheld], `:[number withheld]–[number withheld]`). Die beiden Intervalle der Robustheitsvarianten gelten nur einzeln (pointwise) und sind nicht für Mehrfachtests korrigiert. Die Tabellennote sagt das korrekt („pointwise percentile intervals“).
[number withheld]. **Die Hauptkontrollgruppe ist bei der TL/TA-Variante nicht nach ihrer RL1 definiert.** Die Firmen werden über die bereinigte RL1 ausgewählt ([number withheld] endpoints finite) und dann mit TL/TA geschätzt. Das entspricht dem Kartenwortlaut („advances ignored for controls“) und ist korrekt als „TL/TA on the primary control sample“ beschrieben (`t076_hk_control.tex`, Note). Ich nenne es nur zur Transparenz.

## Was ich nachgerechnet habe
- **Kontraste (Hauptschätzung und Varianten):** Der HK-Kontrast ist Δb der HK-Entwickler minus Δb der HK-Kontrolle: [number withheld] − [number withheld] = [number withheld] ✓. Für die Varianten folgt daraus Δb der Kontrolle = [number withheld] (berichtete Vorauszahlungen) bzw. [number withheld] (TL/TA). Die Entwicklerseite ist in allen drei Kontrasten derselbe Vektor `est$developers_HK$delta`, Ziehung für Ziehung ✓.
- **Variante „berichtete Vorauszahlungen“** (`:[number withheld]–[number withheld]`): Sie behält nur balancierte Firmen, bei denen `adv_missing` an keinem Stichtag gesetzt ist. `adv_missing` bedeutet: beide Vorauszahlungsposten fehlen. Das entspricht der Karte („at least one reported advance item at every endpoint“). Ein `stopifnot` prüft, dass es [number withheld] Zeilen je Firma und keine Imputation gibt ✓.
- **Marktgewichteter Durchschnitt:** Gewicht A = [number withheld]/[number withheld] = [number withheld]. [number withheld]·[number withheld] + [number withheld]·[number withheld] = [number withheld] ✓ (CSV [number withheld]).
- **Richtung der Imputationsverzerrung:** Setzt man fehlende Vorauszahlungen auf null, wird aus (TL−a)/(TA−a) der Wert TL/TA. Für a>[number withheld] und TL<TA ist das größer. Der Anhangtext gibt das richtig wieder (`results.tex:125`). Die TL/TA-Variante ist der Extremfall dieser Verzerrung ([number withheld] gegenüber [number withheld]).
- **Fallzahlen:** Die Fallzahlen in `t076_hk_control.tex` und `t051_robustness.tex` stimmen mit `t076_hk_support.csv` überein: [number withheld]/[number withheld] Firmen, [number withheld]/[number withheld] Beobachtungen, Fenster [number withheld]/[number withheld]; [number withheld] Firmen, Fenster [number withheld]/[number withheld]; Entwickler [number withheld]/[number withheld], Fenster [number withheld]/[number withheld].
- **Kennzeichnung geringer Datenstütze:** Die Low-Support-Flags (`:[number withheld]–[number withheld]`) sind den Zeilen in der richtigen Reihenfolge zugeordnet. Die Variante mit berichteten Vorauszahlungen ist als Kontrolle mit zu wenig Firmen markiert ([number withheld] < [number withheld]), alle HK-Kontraste wegen der [number withheld] Entwickler-Fensterbeobachtungen vor der Policy ✓.
- **Unabhängige Nachrechnung:** `validation` deckt jetzt auch beide neuen Gruppen ab (`support_groups`, `:[number withheld]–[number withheld]`, Toleranz [number withheld]).
- **Übertrag der Zahlen:** Schätzwert, CI-Grenzen und gültige Ziehungen kommen aus dem richtigen Term und der richtigen Zeile und sind korrekt gerundet. Das gilt für `t076_hk_control.tex`, `t051_robustness.tex:22–24` und `results.tex:127` (Audit-Zeilen [number withheld]–[number withheld], [number withheld]–[number withheld], [number withheld]–[number withheld]).
- **Aussagen im Text:** Die Formulierungen zur Schätzung (`06_preliminary_analysis.tex`: „only the Hong Kong interval excludes zero, with just [number withheld] …“) bleiben innerhalb dessen, was die Intervalle hergeben.

## Abnahmekriterien
[number withheld]. **Zweimal byte-identisch, bestehende Outputs unverändert:** Belegt erfüllt, soweit es meine Rolle betrifft. `t076_reproducibility.csv` zeigt [number withheld]/[number withheld] Dateien TRUE. Die Schutzprüfungen im Code (`protected_hash`, `oldraw_hash`) und der feste Seed sind vorhanden. Die Läufe selbst habe ich nicht ausgeführt.
[number withheld]. **Zahlenaudit:** Für die Schätzzahlen erfüllt (siehe oben). Die Vollständigkeit über alle Textstellen ist nicht meine Rolle.
[number withheld]. **Kompilierung und Seitenzahlen:** Nicht meine Rolle.
[number withheld]. **Bericht nennt Zählungen, Hauptschätzung, Datenstütze und Abweichungen:** Für Hauptschätzung, Datenstütze und Robustheitszahlen belegt erfüllt. Die übrigen Zählungen prüfe ich nicht in dieser Rolle.

Rework [number withheld]:
- **Punkt [number withheld] (zwei Robustheitsschätzungen):** Belegt erfüllt. Gleicher Schätzer und Seed, Ergebnisse in CSV/TEX, eine Zeile in t0[number withheld], Richtung der Verzerrung im Anhang genannt. Es gibt keine weiteren Spezifikationen.
- **Punkte [number withheld]–[number withheld]:** Die Teile mit Schätzbezug ([number withheld] Beobachtungen, Fallzahlen in t0[number withheld], Vorzeichen) sind korrekt. Wortlaut und Stil sind nicht meine Rolle.
- **Punkte [number withheld] und [number withheld]:** Nicht meine Rolle.

## Nicht geprüft
- Ich habe nichts selbst ausgeführt (Leserolle). Byte-Identität und Prüfsummen stützen sich auf die skripterzeugten CSVs.
- Den Inhalt der Bootstrap-Ziehungen in `t076_bootstrap_draws.csv` habe ich nicht Ziehung für Ziehung mit den Perzentilen abgeglichen.
- Datenaufbereitung (Zuordnung der Reporting-Dates, Roster-Ausschlüsse), Sprache und Layout prüfen andere Rollen.
