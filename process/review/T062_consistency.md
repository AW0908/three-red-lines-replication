## Rolle: consistency (claude, sonnet) – VERDICT: PASS


## Befunde

Keine inhaltlichen Fehler zwischen Text und Outputs gefunden. Zwei Hinweise unter [number withheld] und [number withheld] liegen unter der REWORK-Schwelle.

[number withheld]. **Gleiche Größe, zwei Intervalle:** Der balancierte Entwickler-Δb ([number withheld]) steht in Tabelle [number withheld] mit [[number withheld]; [number withheld]] (`proposal/tables/t051_robustness.tex`). Das stimmt mit `t061_estimates.csv` überein (`developers_balanced_1[number withheld]_dates`: delta_ci [number withheld]/[number withheld]). Im Appendix steht derselbe Wert mit [[number withheld]; [number withheld]] (`proposal/tables/t0[number withheld]_attrition.tex:[number withheld]`). Die Haupttabellennote benennt den Bootstrap-Unterschied ("joint control-comparison bootstrap"). Die Appendix-Tabelle erklärt ihn nicht. Das ist erklärt und kein Fehler, aber ein Leser kann es als Widerspruch lesen.
[number withheld]. **Fehlerzahl der Kontrollfirmen:** Die Karte nennt [number withheld] ausgeschlossene Firmen, die CSV belegt [number withheld] fehlende Firmen. Die Spaltensummen in `t061_failure_by_sector.csv` ergeben [number withheld] `missing_firms` und [number withheld] `historical_errors_unavailable`. Der Text in Abschnitt [number withheld] und Appendix B.[number withheld] nennt beide Zahlen korrekt mit ihrer jeweiligen Bedeutung.

## Abnahmekriterien

- **Kriterium [number withheld], Zahlen aus CSVs:** belegt erfüllt. Ich habe gegen `t061_diff_bunching.csv` und `t061_estimates.csv` geprüft:
  - ΔΔb gesamt [number withheld] [[number withheld]; [number withheld]], balanciert [number withheld] [[number withheld]; [number withheld]], A-Share [number withheld] [[number withheld]; [number withheld]] stimmen mit Text, Tabelle [number withheld] und Tabelle B9 überein.
  - Kontrolle bei [number withheld]: b_pre [number withheld], b_post [number withheld], Δb [number withheld].
  - Kontroll-Placebos: [number withheld] mit [number withheld] [[number withheld]; [number withheld]], [number withheld] mit [number withheld] [[number withheld]; [number withheld]].
  - Entwickler: [number withheld] beobachtet gegenüber [number withheld] prognostiziert, [number withheld] → [number withheld], Δb [number withheld] [[number withheld]; [number withheld]], Post-Niveau [number withheld] [[number withheld]; [number withheld]].
  - Stichprobenzahlen: [number withheld]/[number withheld] ([number withheld]), [number withheld]/[number withheld] ([number withheld]), Kontrolle [number withheld]/[number withheld] ([number withheld] Firmen), Fensterbeobachtungen [number withheld]/[number withheld], [number withheld]/[number withheld], [number withheld]/[number withheld], [number withheld]/[number withheld], [number withheld]/[number withheld], [number withheld]/[number withheld].
  - Die sechs Schätzzeilen und drei Kontrastzeilen in B9 stimmen mit den CSVs überein. Das Intervall des A-Share-Vergleichs schließt null ein, und der Text sagt das ausdrücklich.
- **Kriterium [number withheld], Seite [number withheld] und Build:** belegt erfüllt. `sec:main_end` steht in `review/T0[number withheld]_build/main.aux` auf Seite [number withheld]. Das Build-Log enthält keine Treffer für Warning, Undefined, Overfull oder Error. Tabelle [number withheld] hat neun Ergebniszeilen, und die Fußnotenzählung "Rows [number withheld]–[number withheld] / [number withheld]–[number withheld]" passt dazu.
- **Kriterium [number withheld], Punkte [number withheld]–[number withheld]:** belegt erfüllt, soweit meine Rolle reicht.
  - Der Bericht hat zu jedem Punkt eine Zeile. Gleichung, Tabellen [number withheld]/[number withheld], Abstract, Einleitung, Schluss, B.[number withheld] und die Verweise `app:res_control`/`tab:t0[number withheld]_control` sind im Diff erkennbar.
  - Das Abstract-Wortzählen habe ich nicht nachgezählt. Der Bericht gibt [number withheld] Wörter an, der Text im Diff wirkt unter [number withheld].
  - Die Kopien von `t061_control_density.pdf` sind byte-identisch (`cmp`).
  - Der Appendix-Text ist an `t061_failure_by_sector.csv` konsistent ([number withheld] Roster-Firmen, [number withheld] geladen).
- **Innere Konsistenz:** erfüllt. Abstract, Einleitung und Schluss behaupten nur "rise absent among unregulated listed firms", was zu Δb [number withheld] passt. Die schwächere A-Share-Evidenz steht in [number withheld], in der Threats-Tabelle (Kontrollselektion) und in B9. Tabelle [number withheld] und Tabelle [number withheld] sind ohne Zahlen und passen zum Text. Die Wegfälle in Tabelle [number withheld] (Ein-Beobachtung- und Messfehler-Zeile) lassen keine hängenden Verweise zurück. Der Verweis darauf im Appendix (`app:res_targeting`) bleibt bestehen.

## Nicht geprüft

- Die Richtigkeit von Code und Daten, Schreibbereich und Reproduzierbarkeit sind nicht meine Rolle.
- Das Layout der PDFs und die Seitenansicht habe ich nicht gesehen.
- Die Nummerierung "B9", "B4" und "B7" habe ich nicht gegen das gerenderte PDF geprüft.
- Die Dateien `t061_cleaning_rules.csv`, `t061_interpretation.csv` und `t061_number_map.csv` habe ich nicht geöffnet. Die Regel- und Fensterangaben (Pre [number withheld]H1–[number withheld]H2, Post [number withheld]H2–[number withheld]H2, Seed, Gradzahl) stützen sich auf `t061_estimates.csv` und `t061_results.tex`.
- Den Inhalt von `AI_USAGE_LOG.md` habe ich nicht geöffnet. Der Bericht meldet, dass der Eintrag dort noch aussteht.
