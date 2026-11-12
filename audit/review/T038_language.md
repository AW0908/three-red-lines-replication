## Rolle: language (codex, medium) – VERDICT: REWORK


## Befunde

1. **Die SOE-Einführung ist sprachlich missglückt.** `proposal/appendix/results.tex:124`: „state-owned enterprise (SOE) and private developers“ verbindet die Unternehmensbezeichnung im Singular mit „developers“. Vorschlag: „developers that are state-owned enterprises (SOEs) and private developers“. Damit ist die Abkürzung grammatisch eindeutig eingeführt.

2. **Zwei Sätze zur Aussagekraft des Bunchings sind unvollständig parallel formuliert.** `proposal/sections/03_framework.tex:16` und `proposal/theory_note.tex:170`: „shows that developers target the threshold, not by which means“. Der zweite Teil passt grammatisch nicht zu „shows that“. Vorschlag: „shows that developers target the threshold but does not reveal which adjustment they use“. Das verdeutlicht die beabsichtigte Unterscheidung ohne inhaltliche Änderung.

3. **Hinweis an die Consistency-Rolle: veralteter Hypothesenverweis.** `proposal/theory_note.tex:198` verweist auf „the proposal's ownership hypothesis (H4)“. Der geprüfte Hypothesenabschnitt in `proposal/sections/03_framework.tex:25–31` enthält nur H1–H3. Der Verweis führt Leser ins Leere. Vorschlag: den H4-Verweis nach Prüfung durch die Consistency-Rolle entfernen oder durch einen bestehenden Zielverweis ersetzen.

## Abnahmekriterien

1. **Alle Followup-Punkte erledigt oder begründet aufgeführt: im sprachlichen Teil nicht vollständig erfüllt.**
   - „at or below 0.70“: belegt umgesetzt, `proposal/sections/06_preliminary_analysis.tex:108,115`.
   - „becomes more negative“ und „coefficient magnitude“: belegt umgesetzt, ebenda:145 sowie `proposal/appendix/results.tex:112`.
   - „percent“ im Fließtext: an den beanstandeten Stellen umgesetzt, `proposal/sections/06_preliminary_analysis.tex:26,66,145`.
   - Die missverständliche Formulierung „although imprecisely“ entfällt; die Unsicherheit wird ausdrücklich beschrieben, ebenda:75,152.
   - Amerikanische Schreibweisen: in den geprüften Texten keine verbliebenen britischen Varianten festgestellt.
   - Begriffe und Abkürzungen sind überwiegend eingeführt: MI und frozen-MI counterfactual in `01_introduction.tex:20`, excess mass \(b\) und DiD in :28, RD in `02_literature.tex:17`, RL1–RL3 in `05_context_data.tex:14`, CR1 in `04_empirical_model.tex:10`, net compliance dependence \(D\) in :36. Die SOE-Formulierung benötigt Befund 1.
   - Die sprachlich nicht parallelen Sätze aus Befund 2 bleiben bestehen.
   - Layout, Tabellenhöhe, Inferenzdetails und mathematische Bedingungen: **nicht meine Rolle**.

2. **Keine Zahl oder Aussage geändert: nicht meine Rolle.** Der Overleaf-Diff umfasst erkennbar auch frühere Schreibarbeiten; daraus lässt sich die Änderungsmenge von T038 allein nicht zuverlässig abgrenzen.

3. **PI-Build ohne Float-/Referenzprobleme und Haupttext höchstens 15 Seiten: nicht meine Rolle; anhand des vorgelegten Berichts nicht prüfbar.** `review/T038_latex.txt:1` enthält lediglich „LaTeX: übersetzt fehlerfrei.“ Warnungsdetails und Seitenzahlen fehlen.

## Nicht geprüft

- Variablensemantik, Stichprobenfilter, Schätzungen, Zahlenkonsistenz und Reproduzierbarkeit: Zuständigkeit der anderen Review-Rollen.
- Gerendertes Layout, Seitenumfang des Proposals und Sieben-Seiten-Grenze der Theorienotiz: kein entsprechender Seitennachweis geprüft; keine Übersetzung ausgeführt.
- Sprachprüfung der eingebundenen generierten Tabellen und des Literaturverzeichnisses: nicht Teil der genannten eingefrorenen LaTeX-Dateien.
- Zuordnung der gemeldeten Änderungen außerhalb des Schreibbereichs und der veränderten Karteneingaben: aus der mitgelieferten Liste allein nicht feststellbar.
- Keine Dateien verändert und keine Shell-Befehle ausgeführt.