## Rolle: consistency (claude, sonnet) – VERDICT: PASS


## Befunde

Keine inhaltlichen Fehler zwischen Text und Outputs gefunden. Zwei Hinweise unter 1 und 2 liegen unter der REWORK-Schwelle.

1. **Gleiche Größe, zwei Intervalle:** Der balancierte Entwickler-Δb (3,91) steht in Tabelle 3 mit [1,48; 6,86] (`proposal/tables/t051_robustness.tex`). Das stimmt mit `t061_estimates.csv` überein (`developers_balanced_13_dates`: delta_ci 1,4758/6,8557). Im Appendix steht derselbe Wert mit [1,63; 6,99] (`proposal/tables/t058_attrition.tex:7,9`). Die Haupttabellennote benennt den Bootstrap-Unterschied ("joint control-comparison bootstrap"). Die Appendix-Tabelle erklärt ihn nicht. Das ist erklärt und kein Fehler, aber ein Leser kann es als Widerspruch lesen.
2. **Fehlerzahl der Kontrollfirmen:** Die Karte nennt 62 ausgeschlossene Firmen, die CSV belegt 64 fehlende Firmen. Die Spaltensummen in `t061_failure_by_sector.csv` ergeben 64 `missing_firms` und 62 `historical_errors_unavailable`. Der Text in Abschnitt 4.2 und Appendix B.2 nennt beide Zahlen korrekt mit ihrer jeweiligen Bedeutung.

## Abnahmekriterien

- **Kriterium 1, Zahlen aus CSVs:** belegt erfüllt. Ich habe gegen `t061_diff_bunching.csv` und `t061_estimates.csv` geprüft:
  - ΔΔb gesamt 4,59 [2,15; 7,47], balanciert 4,48 [1,85; 7,64], A-Share 2,67 [−0,22; 6,35] stimmen mit Text, Tabelle 3 und Tabelle B9 überein.
  - Kontrolle bei 0,70: b_pre −0,18, b_post −0,75, Δb −0,57.
  - Kontroll-Placebos: 0,60 mit −0,57 [−1,62; 0,36], 0,80 mit 0,003 [−1,37; 1,32].
  - Entwickler: 118 beobachtet gegenüber 66,1 prognostiziert, −0,88 → 3,14, Δb 4,02 [1,67; 6,80], Post-Niveau 3,14 [1,01; 5,84].
  - Stichprobenzahlen: 797/630 (136), 690/575 (115), Kontrolle 4.512/3.760 (752 Firmen), Fensterbeobachtungen 207/159, 324/269, 103/88, 67/118, 66/109, 50/63.
  - Die sechs Schätzzeilen und drei Kontrastzeilen in B9 stimmen mit den CSVs überein. Das Intervall des A-Share-Vergleichs schließt null ein, und der Text sagt das ausdrücklich.
- **Kriterium 2, Seite 15 und Build:** belegt erfüllt. `sec:main_end` steht in `review/T062_build/main.aux` auf Seite 15. Das Build-Log enthält keine Treffer für Warning, Undefined, Overfull oder Error. Tabelle 3 hat neun Ergebniszeilen, und die Fußnotenzählung "Rows 1–5 / 6–9" passt dazu.
- **Kriterium 3, Punkte 1–9:** belegt erfüllt, soweit meine Rolle reicht.
  - Der Bericht hat zu jedem Punkt eine Zeile. Gleichung, Tabellen 2/6, Abstract, Einleitung, Schluss, B.2 und die Verweise `app:res_control`/`tab:t061_control` sind im Diff erkennbar.
  - Das Abstract-Wortzählen habe ich nicht nachgezählt. Der Bericht gibt 87 Wörter an, der Text im Diff wirkt unter 100.
  - Die Kopien von `t061_control_density.pdf` sind byte-identisch (`cmp`).
  - Der Appendix-Text ist an `t061_failure_by_sector.csv` konsistent (816 Roster-Firmen, 752 geladen).
- **Innere Konsistenz:** erfüllt. Abstract, Einleitung und Schluss behaupten nur "rise absent among unregulated listed firms", was zu Δb −0,57 passt. Die schwächere A-Share-Evidenz steht in 6.1, in der Threats-Tabelle (Kontrollselektion) und in B9. Tabelle 2 und Tabelle 6 sind ohne Zahlen und passen zum Text. Die Wegfälle in Tabelle 3 (Ein-Beobachtung- und Messfehler-Zeile) lassen keine hängenden Verweise zurück. Der Verweis darauf im Appendix (`app:res_targeting`) bleibt bestehen.

## Nicht geprüft

- Die Richtigkeit von Code und Daten, Schreibbereich und Reproduzierbarkeit sind nicht meine Rolle.
- Das Layout der PDFs und die Seitenansicht habe ich nicht gesehen.
- Die Nummerierung "B9", "B4" und "B7" habe ich nicht gegen das gerenderte PDF geprüft.
- Die Dateien `t061_cleaning_rules.csv`, `t061_interpretation.csv` und `t061_number_map.csv` habe ich nicht geöffnet. Die Regel- und Fensterangaben (Pre 2017H1–2019H2, Post 2020H2–2022H2, Seed, Gradzahl) stützen sich auf `t061_estimates.csv` und `t061_results.tex`.
- Den Inhalt von `AI_USAGE_LOG.md` habe ich nicht geöffnet. Der Bericht meldet, dass der Eintrag dort noch aussteht.
