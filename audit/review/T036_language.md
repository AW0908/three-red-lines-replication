## Rolle: language (codex, high) – VERDICT: REWORK


## Befunde

1. **Die Beschreibung des negativen Koeffizienten ist sprachlich richtungsunklar.** In `proposal/sections/06_preliminary_analysis.tex:146` steht „the RL1 coefficient grows to −0.0486“, obwohl er von −0.0149 auf −0.0486 sinkt; sein Betrag steigt. Korrektur: „the RL1 coefficient becomes more negative, changing from −0.0149 to −0.0486“. Entsprechend „the larger coefficient“ durch „the larger coefficient magnitude“ ersetzen. Auch `proposal/appendix/results.tex:99` sollte „the larger coefficient magnitudes“ verwenden. Die aktuelle Formulierung kann die Richtung der Veränderung missverständlich vermitteln.

2. **Die Prozentnotation im Fließtext entspricht nicht durchgehend der verbindlichen Schreibregel.** `state/writing_rules.md:6` verlangt „percent“ im Fließtext. In `proposal/sections/06_preliminary_analysis.tex:26` steht `95\%`, in Zeile 66 `5\%` und in Zeile 146 ebenfalls `5\%`. Korrektur: „95 percent confidence interval“, „5 percent level“ und „significant at 5 percent“. Die übrigen Anteilsangaben verwenden bereits überwiegend „percent“.

3. **Ein Vorbehalt bezieht sich grammatisch auf die Firmen statt auf die Schätzung.** In `proposal/sections/06_preliminary_analysis.tex:153` steht „post-policy crossings draw more of their equity from minority partners, although imprecisely“. „Imprecisely“ beschreibt hier sprachlich das Beschaffen von Eigenkapital. Korrektur: „post-policy crossings draw more of their equity from minority partners, although the estimated difference is imprecise“. Dadurch wird der statistische Vorbehalt eindeutig.

## Abnahmekriterien

1. **Jede Zahl stimmt mit den CSVs überein:** nicht meine Rolle. Kein numerischer Abgleich vorgenommen.

2. **Aussagen folgen den Schreibregeln; Vorbehalte sind vorhanden:** sprachlich **nicht erfüllt**, siehe Befunde 1–3. Die zentrale Formulierung steht in `proposal/sections/06_preliminary_analysis.tex:125`. Die Vorbehalte zu 63/72 Spezifikationen, schwächerem Umkehrbefund und früherem Minderheitenwachstum stehen in Zeilen 35, 62 und 125. Ihre empirische Richtigkeit ist nicht meine Rolle.

3. **Kein unverifiziertes handerhobenes Material:** Die sprachliche Statusdarstellung ist **belegt erfüllt**: `proposal/sections/06_preliminary_analysis.tex:134` berichtet ausdrücklich keine verifizierten Fälle und keine Transaktionsergebnisse. Die tatsächliche Verifizierungslage ist nicht meine Rolle.

4. **Textbudget und fehlerfreie Übersetzung:** Der Fließtext liegt unter 1.800 Wörtern; auch die Teilbudgets für 6.4 und 6.5 werden eingehalten. Drei Abbildungen und zwei Tabellen sind eingebunden. Die fehlerfreie Übersetzung ist technisch nicht meine Rolle, im vorliegenden Protokoll jedoch **nicht erfüllt**: `review/T036_latex.txt:1–5` dokumentiert die fehlende Datei `t023_excess_mass_rl1` und einen fatalen Abbruch.

## Nicht geprüft

- Variablendefinitionen, Stichproben, Schätzungen, CSV-Abgleich und Reproduzierbarkeit: Aufgaben der anderen Reviewerrollen.
- Herkunft und Zulässigkeit der gemeldeten Änderungen außerhalb des Schreibbereichs sowie der Änderung an `state/STATE.md`: nicht Gegenstand dieses Sprachurteils.
- Gerendertes Layout, Seitenumbrüche und abschließende Referenzauflösung: kein erfolgreich übersetztes PDF im vorliegenden Prüfprotokoll.
- Unverändert eingebundene Tabellen und Grafiken wurden nicht vollständig sprachlich geprüft. Die gründliche Sprachprüfung umfasst die beiden eingefrorenen LaTeX-Dateien.
- Keine Dateien geändert und keine Shell-, Analyse- oder Übersetzungsbefehle ausgeführt.