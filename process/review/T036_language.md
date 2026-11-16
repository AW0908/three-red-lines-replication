## Rolle: language (codex, high) – VERDICT: REWORK


## Befunde

[number withheld]. **Die Beschreibung des negativen Koeffizienten ist sprachlich richtungsunklar.** In `proposal/sections/06_preliminary_analysis.tex:146` steht „the RL1 coefficient grows to [number withheld]“, obwohl er von [number withheld] auf [number withheld] sinkt; sein Betrag steigt. Korrektur: „the RL1 coefficient becomes more negative, changing from [number withheld] to [number withheld]“. Entsprechend „the larger coefficient“ durch „the larger coefficient magnitude“ ersetzen. Auch `proposal/appendix/results.tex:99` sollte „the larger coefficient magnitudes“ verwenden. Die aktuelle Formulierung kann die Richtung der Veränderung missverständlich vermitteln.

[number withheld]. **Die Prozentnotation im Fließtext entspricht nicht durchgehend der verbindlichen Schreibregel.** `state/writing_rules.md:6` verlangt „percent“ im Fließtext. In `proposal/sections/06_preliminary_analysis.tex:26` steht `[number withheld]\%`, in Zeile [number withheld] `[number withheld]\%` und in Zeile [number withheld] ebenfalls `[number withheld]\%`. Korrektur: „[number withheld] percent confidence interval“, „[number withheld] percent level“ und „significant at [number withheld] percent“. Die übrigen Anteilsangaben verwenden bereits überwiegend „percent“.

[number withheld]. **Ein Vorbehalt bezieht sich grammatisch auf die Firmen statt auf die Schätzung.** In `proposal/sections/06_preliminary_analysis.tex:153` steht „post-policy crossings draw more of their equity from minority partners, although imprecisely“. „Imprecisely“ beschreibt hier sprachlich das Beschaffen von Eigenkapital. Korrektur: „post-policy crossings draw more of their equity from minority partners, although the estimated difference is imprecise“. Dadurch wird der statistische Vorbehalt eindeutig.

## Abnahmekriterien

[number withheld]. **Jede Zahl stimmt mit den CSVs überein:** nicht meine Rolle. Kein numerischer Abgleich vorgenommen.

[number withheld]. **Aussagen folgen den Schreibregeln; Vorbehalte sind vorhanden:** sprachlich **nicht erfüllt**, siehe Befunde [number withheld]–[number withheld]. Die zentrale Formulierung steht in `proposal/sections/06_preliminary_analysis.tex:125`. Die Vorbehalte zu [number withheld]/[number withheld] Spezifikationen, schwächerem Umkehrbefund und früherem Minderheitenwachstum stehen in Zeilen [number withheld], [number withheld] und [number withheld]. Ihre empirische Richtigkeit ist nicht meine Rolle.

[number withheld]. **Kein unverifiziertes handerhobenes Material:** Die sprachliche Statusdarstellung ist **belegt erfüllt**: `proposal/sections/06_preliminary_analysis.tex:134` berichtet ausdrücklich keine verifizierten Fälle und keine Transaktionsergebnisse. Die tatsächliche Verifizierungslage ist nicht meine Rolle.

[number withheld]. **Textbudget und fehlerfreie Übersetzung:** Der Fließtext liegt unter [number withheld] Wörtern; auch die Teilbudgets für [number withheld] und [number withheld] werden eingehalten. Drei Abbildungen und zwei Tabellen sind eingebunden. Die fehlerfreie Übersetzung ist technisch nicht meine Rolle, im vorliegenden Protokoll jedoch **nicht erfüllt**: `review/T036_latex.txt:1–5` dokumentiert die fehlende Datei `t0[number withheld]_excess_mass_rl1` und einen fatalen Abbruch.

## Nicht geprüft

- Variablendefinitionen, Stichproben, Schätzungen, CSV-Abgleich und Reproduzierbarkeit: Aufgaben der anderen Reviewerrollen.
- Herkunft und Zulässigkeit der gemeldeten Änderungen außerhalb des Schreibbereichs sowie der Änderung an `state/STATE.md`: nicht Gegenstand dieses Sprachurteils.
- Gerendertes Layout, Seitenumbrüche und abschließende Referenzauflösung: kein erfolgreich übersetztes PDF im vorliegenden Prüfprotokoll.
- Unverändert eingebundene Tabellen und Grafiken wurden nicht vollständig sprachlich geprüft. Die gründliche Sprachprüfung umfasst die beiden eingefrorenen LaTeX-Dateien.
- Keine Dateien geändert und keine Shell-, Analyse- oder Übersetzungsbefehle ausgeführt.