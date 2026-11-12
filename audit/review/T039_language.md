## Rolle: language (codex, high) – VERDICT: REWORK


## Befunde

1. **Konfidenzintervalle und Punktschätzungen werden sprachlich vermischt.** In `proposal/sections/06_preliminary_analysis.tex:92` heißt es „the comparison with the mid-2017 anchor includes zero“ beziehungsweise „the comparison with the end-2016 anchor is slightly negative and includes zero“. Eine Punktschätzung kann negativ sein; das Einschließen von null beschreibt dagegen das Konfidenzintervall. Die Formulierung verschleiert diese Unterscheidung. **Korrekturvorschlag:** „At one year, the confidence interval for the difference relative to the mid-2017 anchor includes zero; at three years, the estimated difference relative to the end-2016 anchor is slightly negative, and its confidence interval includes zero.“

## Abnahmekriterien

1. **Seitenlimits und Build:** nicht meine Rolle. Gerenderte Typografie **nicht prüfbar**, da keine PDF-Sichtprüfung durchgeführt wurde. `review/T039_latex.txt:1` bestätigt lediglich „LaTeX: übersetzt fehlerfrei.“

2. **Vollständiger Zahlennachweis:** nicht meine Rolle. Zahlen und Rundungen wurden nicht gegen die Ergebnisdateien geprüft. Die sprachliche Unterscheidung zwischen Schätzwert und Intervall ist an der unter Befund 1 genannten Stelle **nicht erfüllt**.

3. **Verifizierte Fallbelege in 6.3:** Quellenzuordnung und Übersetzungstreue nicht meine Rolle. Die zuvor beanstandete sprachliche Eindeutigkeit ist **belegt erfüllt**: Kapitalbeträge und Vorschlagsstatus sind klar zugeordnet (`06_preliminary_analysis.tex:126`), die Bezugsgröße der Wuxi-Verkaufsbedingung ist ausdrücklich genannt (`:128`), und die Baowan-Vertragsmerkmale sind verständlich formuliert (`:130`).

4. **Zentrale Aussage und drei Evidenzstufen:** im sprachlichen Prüfbereich **belegt erfüllt**. Die zentrale Formulierung steht in `proposal/main.tex:53`, `01_introduction.tex:23`, `06_preliminary_analysis.tex:71` und `07_conclusion.tex:10`. Die Eröffnungssätze der drei Befunde benennen ihre Evidenzstufe (`06_preliminary_analysis.tex:25,71,124`); kausale und wirtschaftliche Interpretationsgrenzen stehen insbesondere in `:92,132`.

5. **Literaturmethodik und Positionierung:** sprachlicher Anteil **belegt erfüllt**. AI, PRISMA, CNKI und CSSCI werden ausgeschrieben (`02_literature.tex:13,16`); Lin und Liu werden erkennbar eingeordnet (`:25,29`). Suchzahlen, Quellenpassung und BibTeX-Integrität sind nicht meine Rolle.

6. **Bericht und frühere Review-Befunde:** Der Sprachanteil des Review-Abgleichs ist **belegt erfüllt**. Die früheren Befunde L1–L7 sind an den betreffenden Stellen korrigiert: `06_preliminary_analysis.tex:128`; `04_empirical_model.tex:30`; `06_preliminary_analysis.tex:71,45`; `02_literature.tex:13`; `06_preliminary_analysis.tex:76`; `02_literature.tex:21`. Wortzählung und Dokumentationsvollständigkeit sind nicht meine Rolle.

**Zusätzliche Sprachvorgabe aus Schritt 10:** wegen Befund 1 **nicht vollständig erfüllt**. Im übrigen gelesenen Fließtext keine weiteren korrekturbedürftigen Rechtschreib-, Grammatik- oder Typografiebefunde gefunden.

## Nicht geprüft

- Variablenbedeutung, Stichprobenfilter, Datenintegrität, Schätzungen, Identifikation und Reproduzierbarkeit: außerhalb der Sprachrolle.
- Sachliche Literaturprüfung, chinesische Originalquellen und Übersetzungstreue.
- PDF-Layout, Seitenumfang und vollständige Build-Warnungen.
- Verursachung und Zulässigkeit der gemeldeten Eingabe- und Schreibbereichsänderungen.
- Die bereits dokumentierten Abkürzungsrestpunkte in `proposal/appendix/ai_use.tex` bleiben T042 zugeordnet; sie begründen dieses Urteil nicht.

Keine Dateien geändert und keine Shell- oder Build-Befehle ausgeführt. Vorgeschlagener KI-Protokolleintrag: „2026-10-28, Codex: unabhängige Sprachprüfung T039; frühere Sprachkorrekturen nachvollzogen, eine verbleibende Intervallformulierung beanstandet; ausschließlich lesend.“