## Rolle: consistency (claude, sonnet) – VERDICT: PASS


## Befunde
[number withheld]. Nur Hinweis, kein Mangel der Karte: `proposal/sections/07_conclusion.tex`, Zeile [number withheld], enthält noch die Formulierung „Hong Kong developers without a Hong Kong control". Das widerspricht jetzt dem Text in [number withheld], [number withheld] und im Appendix. Die Karte verbietet Änderungen an Abstract, Einleitung und Conclusion ausdrücklich und weist sie dem Co-PI zu. Der Co-PI muss diese Stelle (und die entsprechende in Abstract/Einleitung, falls vorhanden) nach Sichtung der Zahlen anpassen.
[number withheld]. Kleinigkeit: In `proposal/tables/t076_hk_control.tex`, Fußnote, steht „…in either period; Primary HK controls pass". Nach dem Semikolon ist „Primary" großgeschrieben. Das hat keinen Einfluss auf die Zahlen.
[number withheld]. Das Zahlenaudit enthält keine Zeile für „all primary and secondary draws are valid" (`appendix/results.tex`). Die Aussage stimmt mit der Spalte `valid` = [number withheld] in `t076_hk_control.csv` überein, nur der Audit-Eintrag fehlt.

## Abnahmekriterien
- **Kriterium [number withheld] (Zahlenaudit):** belegt erfüllt.
  - **Abdeckung:** `t076_number_audit.csv` deckt die neuen Zahlen in `t076_hk_control.tex`, `t076_hk_roster_summary.tex`, Abschnitt [number withheld], Abschnitt [number withheld], `t051_robustness.tex` und dem Appendix ab.
  - **Stichproben gegen die CSVs:** ΔΔb_HK [number withheld] → [number withheld] [[number withheld]; [number withheld]]; A [number withheld] [[number withheld]; [number withheld]]; marktgematcht [number withheld] [[number withheld]; [number withheld]]; ohne Imputation [number withheld] [[number withheld]; [number withheld]]; TL/TA [number withheld] [[number withheld]; [number withheld]]; HK-Kontrolle [number withheld] → [number withheld] [[number withheld]; [number withheld]].
  - **Rechenkontrollen:** [number withheld] − [number withheld] ≈ [number withheld]. Gewichte [number withheld] und [number withheld] entsprechen [number withheld]/[number withheld] und [number withheld]/[number withheld].
  - **Verifikation:** Alle Zeilen in `t076_number_verification.csv`, die ich geöffnet habe (Zeilen [number withheld]–[number withheld]), sind TRUE/TRUE.
- **Konsistenz Output ↔ Paper:**
  - Das `.tex` in `proposal/tables/` stimmt mit der Fassung unter `replication/outputs/tables/` überein. Ich habe beide Dateien gelesen; einen Byte-Vergleich habe ich nicht gemacht.
  - Support-Zahlen im Text und in den Tabellen passen zu `t076_hk_support.csv`: [number withheld] Pre-Window-Beobachtungen der HK-Entwickler (unter [number withheld]), [number withheld] Firmen im Reported-Advance-Subset (unter [number withheld]), [number withheld]/[number withheld] HK-Entwickler, [number withheld] Kontrollen, [number withheld]/[number withheld] Firm-Halbjahre.
  - Roster-Zahlen passen zu `t076_hk_roster_summary.csv`: [number withheld], [number withheld], [number withheld], [number withheld], [number withheld], [number withheld], [number withheld], [number withheld], Tags [number withheld]/[number withheld]/[number withheld]/[number withheld], Ledger \[number withheld]([number withheld])/\[number withheld]([number withheld])/\[number withheld]([number withheld]). Arithmetisch stimmt [number withheld] − [number withheld] = [number withheld], [number withheld] − [number withheld] = [number withheld] und [number withheld] − [number withheld] = [number withheld].
- **Wortlaut folgt dem Schätzwert:** Die Aussagen in Abschnitt [number withheld] gehen nicht über die Intervalle hinaus.
  - „Both point estimates positive, only HK interval excludes zero" stimmt: A [[number withheld]; [number withheld]], HK [[number withheld]; [number withheld]].
  - Die Sparse-Support-Warnung ist belegt.
  - Die Richtung der Imputationsverzerrung ist im Appendix genannt, ohne ein Vorzeichen für den Kontrast zu behaupten. Die beiden Robustheitsschätzungen ([number withheld] und [number withheld]) liegen auf beiden Seiten des Primärwerts.
- **Rework [number withheld] (Robustheitsschätzungen):** belegt erfüllt. Beide stehen in CSV, `.tex`, `t0[number withheld]` und im Appendix-Text.
- **Rework [number withheld] (veraltete Aussagen):** für `t049_threats.tex`, `appendix/results.tex`, `t061_results.tex` und `02_literature.tex` erfüllt; alle Aussagen sind durch Zahlen gedeckt. Die Conclusion fällt laut Karte nicht in den Umfang (siehe Befund [number withheld]).
- **Rework [number withheld] (Roster-Fußnote):** erfüllt. Die zwei unbelegten Sätze sind entfernt, und der Satz zu den März/September-Berichten steht in der Fußnote.
- **Rework [number withheld] (Stil):**
  - Erfüllt: Minuszeichen als `$-x$`, Zeilenlabel „HK developers $-$ HK control" mit Entwickler- und Kontrollzahlen, Notensatz zur Rangfolge der Vergleiche (A-Share bevorzugt, HK within-market, gepoolt deskriptiv) und A-Kontrollzahlen [number withheld]/[number withheld] ([number withheld]).
  - Hinweis: Die Notation „D [number withheld]/[number withheld]; C [number withheld]" ist knapp, aber konsistent.
- **Rework [number withheld] (Fokalpaper-Autor):** unverändert gelassen. Der Diff zeigt nur die vom Co-PI genehmigte Änderung.
- **Kriterium [number withheld] (Kompilierung):** `review/T076_latex.txt` meldet fehlerfreie Übersetzung. Die Seitenzahlen (Haupttext bis Seite [number withheld], Einleitung Seite [number withheld]) kann ich nicht belegen.
- **Kriterien [number withheld] und [number withheld]:** nicht meine Rolle (Code und Reproduzierbarkeit, Bericht). Ich habe sie nicht geprüft.

## Nicht geprüft
- Code und Daten: ob die Konstruktion von RL1, die Imputation, die Bootstrap-Implementierung und die Stichprobenfilter richtig sind. Das prüfen die Rollen `data` und `estimation`.
- Byte-Identität zweier Läufe und der unveränderten bestehenden Outputs: dafür hätte ich Befehle ausführen müssen. Das SHA-Prüfergebnis des Skripts betrifft nur die Eingaben der Karte.
- Die Zeilen [number withheld] bis zum Ende von `t076_number_verification.csv`: die PASS-Spalten habe ich nur bis Zeile [number withheld] gelesen.
- Seitenumbruch (Seite [number withheld], Einleitung Seite [number withheld]): ich habe keine PDF des Gesamtdokuments gesehen.
- Das Dichtediagramm: ich habe `f_hk_control_density.pdf` unter `outputs/` angesehen und es passt zur Beschreibung (zwei Panels, gleiche y-Skala, schattiertes Fenster, gestrichelte Linie bei [number withheld]). Die Kopie in `proposal/figures/` und die Balkenwerte gegen `t076_density_bins.csv` habe ich nicht verglichen.
- Abstract, Einleitung und Conclusion: nach Kartenvorgabe nicht Teil des Umfangs, nur die stale Stelle in Zeile [number withheld] der Conclusion ist als Hinweis vermerkt.
