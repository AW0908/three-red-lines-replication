## Rolle: consistency (codex, medium) – VERDICT: REWORK


## Befunde

[number withheld]. **Der Haupttext überschreitet weiterhin die Grenze von [number withheld] Seiten.** Die Conclusion beginnt laut `review/T0[number withheld]_build/main.toc:[number withheld]` auf Seite [number withheld]. `review/T038_build/main.log:1149–1152` zeigt jedoch `07_conclusion.tex [15]) [16]` vor dem Einlesen des Literaturverzeichnisses. Zusammen mit dem `\clearpage` vor der Bibliografie (`proposal/main.tex:77`) belegt dies: Der Haupttext endet auf Seite [number withheld]. Der Beginn der Conclusion auf Seite [number withheld] genügt nicht zur Erfüllung des Längenkriteriums.

[number withheld]. **Die Theory Note verweist auf eine nicht mehr vorhandene Hypothese H4.** `proposal/theory_note.tex:198` bezeichnet die unbestimmte Richtung des Eigentümereffekts als „the proposal's ownership hypothesis (H4)“. Das Proposal definiert ausschließlich H1, H2 und H3 (`proposal/sections/03_framework.tex:27–31`). Der Verweis passt damit nicht zum aktuellen Hypothesensystem. Er sollte auf die ergänzende Eigentumsanalyse beziehungsweise die eigene Modellvorhersage P4 bezogen werden.

## Abnahmekriterien

[number withheld]. **Jeder Followup-Punkt umgesetzt oder begründet aufgeführt: teilweise belegt erfüllt.**
   - Die konsistenzrelevanten Präzisierungen stehen im Ergebnis: RL1 und RL3 (`[number withheld]_context_data.tex:[number withheld]`), Bedingung innerer Lösungen (`03_framework.tex:16`), gepaarte Stichprobe (`04_empirical_model.tex:31`, `06_preliminary_analysis.tex:87`), Compliance einschließlich Gleichheit (`[number withheld]_preliminary_analysis.tex:[number withheld]`) sowie relevante Distanz \(\kappa e^*\) (`theory_note.tex:264`).
   - Vorzeichen und Interpretation der kontrollierten RL1-Schätzung sind präzisiert (`06_preliminary_analysis.tex:145`, `appendix/results.tex:112`).
   - Die Hypothesenverweise sind noch nicht durchgehend konsistent; siehe Befund [number withheld].
   - Reine Sprachkorrekturen: **nicht meine Rolle**. Die verlangte Endseite der Theory Note ist **nicht prüfbar**, siehe unten.

[number withheld]. **Keine Zahl oder Aussage geändert: nicht vollständig prüfbar; geprüfte Ergebniszahlen stimmen mit den Outputs überein.**
   - Die Compliancewerte und Intervalle in `[number withheld]_preliminary_analysis.tex:[number withheld]–[number withheld]` entsprechen `t029_compliance.csv` und `t029_counterfactual_bunching.csv`, einschließlich [number withheld] Beobachtungen/[number withheld] Firmen, [number withheld]/[number withheld] im Placebo sowie [number withheld] ausgeschlossenen Paaren.
   - Die nach `appendix/results.tex:77` verschobenen RD- und Attritionswerte entsprechen `t024_rd_main.csv`, `t024_rd_robustness.csv` und `t025_selection.csv`.
   - Die geprüften Bunching-, Robustheits-, Zerlegungs-, DiD- und Summary-Statistics-Zahlen stimmen in Rundung, Richtung und Einheit mit ihren genannten CSVs überein.
   - Alle [number withheld] vorhandenen LaTeX-Tabellenkopien und [number withheld] PDF-Abbildungskopien in `proposal/` sind bytegleich mit den gleichnamigen Outputs.
   - Ein vollständiger Änderungsnachweis gegenüber dem unmittelbaren Stand vor T038 fehlt: `review/T0[number withheld]_proposal.diff` vergleicht mit dem letzten Overleaf-Stand und enthält auch frühere inhaltliche Überarbeitungen. Er erlaubt daher keine eindeutige Zuordnung aller Änderungen zu T038.

[number withheld]. **Build ohne übergroße Floats und undefinierte Referenzen; Haupttext höchstens [number withheld] Seiten: nicht erfüllt.**
   - Im vorhandenen `review/T038_build/main.log` stehen keine Meldungen „Float too large“, keine undefinierten Referenzen/Zitate und keine Overfull-Meldungen.
   - Der Haupttext umfasst weiterhin [number withheld] Seiten; siehe Befund [number withheld].

## Nicht geprüft

- Keine Analyse, Übersetzung oder sonstigen Shell-Befehle ausgeführt; keine Dateien geändert.
- Kein aktueller Build der Theory Note vorgelegt; ihr Ende auf Seite [number withheld] ist nicht belegt.
- Keine vollständige Prüfung sämtlicher generierter Anhangstabellenzellen gegen CSVs; die Bytegleichheit der Kopien ersetzt diesen Abgleich nicht.
- Literaturbehauptungen gegen Originalquellen sowie Datenbereinigung, Schätzcode und Identifikationsvalidität: nicht meine Rolle.
- Die gemeldeten Änderungen an Karteneingaben und Dateien außerhalb des Schreibbereichs lassen sich anhand der vorliegenden Belege keinem Verursacher zuordnen. Unveränderte Eingaben und ausschließliche Bearbeitung im Schreibbereich sind deshalb nicht bestätigt.