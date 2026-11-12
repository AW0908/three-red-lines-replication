## Rolle: consistency (claude, sonnet) – VERDICT: REWORK


## Befunde

1. **KI-Protokoll passt nicht zum Anhang.** `proposal/appendix/ai_use.tex:15` und `:21` nennen ChatGPT und „The October 30 ChatGPT and Grok reviews“. Der Anhang verweist auf `AI_USAGE_LOG.md` als Beleg. Dort gibt es keinen ChatGPT-Eintrag und keinen T049-Eintrag. Die einzige Probe-Review-Zeile (Zeile 15) nennt Grok und „a second general-purpose AI assistant“ mit Datum 2026-10-28. Der im Bericht vorgeschlagene Eintrag wurde nicht angelegt. `AI_USAGE_LOG.md` müsste ergänzt werden. Es liegt laut Bericht außerhalb des Schreibbereichs, also über den Co-PI.
2. **Umkehrsatz nur für das Binned-Modell belegt.** `proposal/appendix/results.tex:111` sagt, die Differenzen seien nach Ausschluss von 2020H2 nicht von null unterscheidbar. `t031_timing.csv` zeigt für `ii_2021H1_2022H2`:
   - `bins001` schließt null in allen drei Distanzen ein.
   - `linear` schließt null in allen drei Distanzen aus (ci_high −0.0043/−0.0043/−0.0035).
   - `T023_near` schließt null aus (Zeile 11: [−0.499, −0.071]).

   Der Satz ist durch „binned model's“ eingegrenzt. Er verschweigt aber, dass zwei von drei Modellen die Umkehr weiter zeigen. Der Hinweis in `06_preliminary_analysis.tex:26` („which also reports reversal checks“) lässt das offen. Bitte das ausdrücklich sagen.
3. **Zählung im KI-Anhang widersprüchlich.** `ai_use.tex:32`: „Before this revision, the logs covered 49 task cards, including 48 accepted“. In `state/approvals.log` gibt es nur für T001–T048 ein DELIVERED. Die 49. Karte ist T049, also die vorliegende Revision. Das 48-Karten-Vorher widerspricht dem „49“. Bitte auf 48 bzw. 49 einschließlich der laufenden Karte vereinheitlichen. Bestätigt habe ich nur die 26 `OVERRIDE:`-Zeilen. Die 63 Rework-Runden konnte ich aus den eingefrorenen Dateien nicht nachrechnen (siehe „Nicht geprüft“).
4. **„136 listed developers“ gegen die neue Stichprobentabelle.** Die Einleitung (`01_introduction.tex:11`) und das Abstract (`main.tex:52`) sprechen von 136 gelisteten Entwicklern. `t049_sample_composition.tex` weist 15 delistete A-Share-Firmen und 27 delistete Hongkonger Firmen aus, zusammen 42. Das ist ein Wortlautkonflikt, kein Zahlenfehler. Bitte „listed (at some point)“ o. Ä. verwenden.
5. **Schlussfolgerung weicht von Abschnitt 6 ab.** `07_conclusion.tex:5` sagt „did not exceed its pre-policy pace“ ohne den Zusatz „under the firm trend, was slower“. Dieser steht in `06_preliminary_analysis.tex:62`. Die Trendzahlen (9,8 / 5,6) stehen nur noch in Abschnitt 6, nicht mehr in Einleitung und Schluss. Es ist ein kleiner Verlust an Präzision, kein Zahlenfehler.

## Abnahmekriterien

- **1. Jeder Punkt 1–8 hat eine Zeile im Bericht:** belegt erfüllt, nach Tabelle im Bericht (Zeilen 43–57). Die genannten Fundstellen habe ich im Diff wiedergefunden.
- **2. Jede Zahl steht in einer Output-CSV:** belegt erfüllt für die geprüften Zahlen. Gefunden habe ich:
  - Timing: 3,54 [1,11; 6,76] und 1,74 [−0,67; 4,99] (`t031_timing.csv`, Zeilen 10 und 18).
  - Δb = 4,02 [1,67; 6,80] (`t043_delta_b.csv`).
  - Messfehler: 64 Paare, 999 Simulationen, Mittel 2,01 (`t043_meas_error.csv`).
  - Chetty-Fit: 3,76 [1,60; 6,15] und 3,56 [0,75; 6,49] (`t043_integration.csv`).
  - „Sieben von neun“ (`t041_frozen_horizons.csv`: 4 + 3 Zellen mit ci_low > 0).
  - Stichprobe: Panel A 65/845, 15/195, 29/372, 27/280 (Summe 136 und 1692) und Panel B 82/46/3/2/2/1 (Summe 136), aus `t004_panel_counts.csv` (`10_final_panel`, `sample_main`) und `t015_ownership_counts.csv`.
  - Attributionssummen: 20 von 33 und 0,2 % (`t047_attribution_totals.csv`); 9 Firmen, 108,3 / 3,5 / 104,8 Mrd. und 3,2 % (`t044_attribution_totals.csv`).
  - Planungsgrößen: 53 Registereinträge (`registry_todo.csv`, 54 Zeilen mit Kopfzeile) und zehn Ereignisse mit `closing_report_local=FALSE` (`source_inventory.csv`).
  - Nicht erneut nachgerechnet habe ich 11,5 Prozentpunkte (`t029_compliance.csv`), die Heterogenitätswerte, 9,8/5,6 und 65,5 %.
- **3. Haupttext endet auf Seite 14; Build ohne Fehler:** belegt erfüllt. `main.aux` setzt `sec:main_end` und `tab:threats` auf Seite 14. `review/T049_latex.txt` meldet „übersetzt fehlerfrei“. Die Zeile im Inhaltsverzeichnis stimmt mit Seite 14 überein.
- **4. Keine kausale Sprache ergänzt:** soweit meine Rolle betroffen ist, belegt erfüllt. Die neuen Sätze (Threats-Tabelle, Abschnitt 6.1, H3) sind deskriptiv gehalten. Die Aussage „not driven by the announcement half-year“ folgt aus den CSV-Werten, weil das Intervall für 2020H2 allein null einschließt.
- **Punkt 4 der Karte (Plan Final Paper):** erfüllt, ca. 90 Wörter bei einer Grenze von 130. Die URL steht im Text, die Zahlen 53 und zehn stimmen.
- **Punkt 7 der Karte (KI-Anhang ≤ 2,5 Seiten):** laut Bericht zwei Seiten (34–35). Ob der Inhalt vollständig ist, bleibt wegen Befund 1 offen.
- **Threats-Tabelle (6 Zeilen):** erfüllt. Die Evidenzen entsprechen vorhandenen Ergebnissen.
- **Shimao-Satz:** erfüllt. Die Formulierung „a third party, Mr. Hui“ und „listing-triggered component lapses if Shimao Services is listed“ entspricht der Vorgabe. Der Verifikationsvermerk steht im Quelltext.
- **Sprache, Layout, Abbildung (Punkt 8):** nicht meine Rolle.

## Nicht geprüft

- **Zählung im KI-Anhang:** 63 Rework-Runden und 49 distinkte Worker-Task-IDs. Das Zählverfahren steht nur als Kommentar im Quelltext. `state/runs.log` hat sich laut Skript seit Beginn der Ausführung verändert und liegt nicht in den eingefrorenen Dateien.
- **PDF und Abbildung:** Seitenlayout und die NEF-Abbildung. Ich habe nur Quelltext und `.aux` gelesen.
- **Nicht erneut nachgerechnet:** 11,5 Prozentpunkte (`t029_compliance.csv`), die Heterogenitätswerte, 9,8 / 5,6 und 65,5 %. Das sind unveränderte Passagen aus früheren Karten oder Zahlen, die ich nur aus dem Bericht kenne.
- **Code und Daten:** Ob sie korrekt sind, bewerte ich in dieser Rolle nicht.
