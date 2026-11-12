## Rolle: consistency (codex, high) – VERDICT: ESCALATE


## Befunde

1. **Die Karte verlangt Anhangsänderungen außerhalb ihres Schreibbereichs.** `tasks/T056.md:28` erlaubt Abschnitte, Haupttexttabellen und bestimmte Bibliografieänderungen. Dagegen verlangt Zeile 44 ausdrücklich eine neue Prätrend-Tabelle im Anhang; Zeile 23 bezieht die Ich-Form ebenfalls auf Anhänge. Eine entsprechende Scope-Erweiterung ist in den gelesenen T056-Freigaben nicht dokumentiert (`state/approvals.log:160`). Die Prätrend-Tabelle fehlt tatsächlich. **Der PI muss Schreibbereich und Anforderungen miteinander vereinbaren; deshalb ESCALATE wegen eines Kartenwiderspruchs, nicht wegen falscher Schätzwerte.**

2. **Die Nachvollziehbarkeit der neuen Ergebnisse bleibt unvollständig.**
   - `proposal/sections/06_preliminary_analysis.tex:119` nennt korrekt \(p=0.0002\), verweist aber auf das Replikationspaket statt auf die ausdrücklich verlangte Anhangstabelle. Der Wert steht in `replication/outputs/tables/t055_pretrend_tests.csv:8`; die fertige LaTeX-Tabelle existiert dort ebenfalls, ist im Paper jedoch nicht eingebunden.
   - Die Falsifikationsdifferenzen \(3.34\,[0.32,6.58]\) und \(2.91\,[-0.59,6.25]\) in derselben Abschnittsdatei, Zeile 14, stehen nicht in der dort genannten Robustheitstabelle.
   - Die MI-Shift- und Reweighting-Werte in Zeile 51 haben keinen Haupttext- oder Anhangstabellennachweis.

   Die Werte stimmen mit den jeweiligen T055-CSVs überein. Quellenkommentare und Dateinamen ersetzen jedoch die geforderte Tabellenverknüpfung nicht.

3. **Die vorgeschriebene κ-Abbildung fehlt im Paper.** `replication/outputs/figures/t055_kappa.pdf` liegt vor, wird aber weder im Haupttext noch in `proposal/appendix/results.tex` eingebunden. `proposal/tables/t050_counterfactuals.tex:23` verweist lediglich auf das Replikationspaket. Damit ist Punkt 3(b) trotz korrekter Wiedergabe von \(\kappa^*\approx0.28\) und \(\kappa\approx0.09\) nicht vollständig umgesetzt.

4. **Ein bestehender Tabellenverweis deckt die genannten Zahlen nicht ab.** `proposal/sections/05_context_data.tex:70` nennt im Zusammenhang mit Tabelle 1 einen Anstieg des MI-Mittelwerts von 0.184 auf 0.310. Tabelle 1 enthält ausschließlich Mediane und Fallzahlen (Zeilen 45–52). Die Mittelwerte sind in `t005_summary_stats.csv:19` und `:31` sowie der vollständigen Anhangstabelle vorhanden. Der Absatz benötigt diesen Anhangsverweis oder eine Ergänzung der Haupttabelle.

## Abnahmekriterien

1. **Jede Zahl aus einer CSV; zitierte Tabellen enthalten die genannten Zahlen: nicht erfüllt.** Die geprüften T055-Zahlen sowie die Zahlen der überarbeiteten Tabellen 3 und 4 stimmen einschließlich Rundung, Vorzeichen und Einheiten mit den CSVs überein. Die Befunde 2 und 4 verhindern die vollständige Erfüllung.

2. **Haupttext spätestens Seite 15; sauberer Build: anhand der vorhandenen Buildartefakte belegt erfüllt.** `review/T056_build/main.aux:109–110` verortet Schluss und Haupttextende auf Seite 15. Das Buildlog enthält keine undefinierten Verweise oder Overfull-Boxen; vorhanden sind Fontwarnungen zur kursiven SongtiSC-Schrift. Der dokumentierte Build verwendet XeLaTeX, passend zu `proposal/latexmkrc`.

3. **Punkte 1–10 jeweils im Bericht behandelt: belegt erfüllt.** `tasks/T056_report.md` enthält zehn entsprechende Einträge. Das belegt deren Dokumentation, nicht ihre vollständige Umsetzung. Rollenbezogene Einzelprüfung:

   1. **Ich-Form:** nicht meine Rolle; sprachliche Prüfung durch Language Reviewer. Im Anhang stehen weiterhin „our“ (`appendix/results.tex:77`) und „The author“ (`appendix/ai_use.tex:5`).
   2. **H2-Aufteilung:** belegt erfüllt. Definitionen in `03_framework.tex:33`, Zuordnung in `04_empirical_model.tex:34–39`, Ergebnisdarstellung in `06_preliminary_analysis.tex:46–56` und Schluss in `07_conclusion.tex:9` stimmen überein.
   3. **T055-Integration:** Zahlen und Interpretation belegt erfüllt; insgesamt **nicht erfüllt**, weil κ-Abbildung und Tabellennachweise fehlen. Trendformabhängigkeit und unpräzise Falsifikationsänderung werden ausdrücklich genannt.
   4. **Robustheitstabelle:** belegt erfüllt. Neun Ergebniszeilen; beide Placebo-Schwellen und die unbereinigte Quote enthalten die passenden CSV-Werte (`t051_robustness.tex:23–33`).
   5. **Regulierte Einheit:** belegt erfüllt (`05_context_data.tex:20`), einschließlich Verweis auf Fall (a).
   6. **Repräsentativität:** belegt erfüllt (`01_introduction.tex:10`).
   7. **Machbarkeit und Nebenwirkungen:** inhaltlich belegt erfüllt, ausdrücklich als Überlegungen außerhalb der empirischen Evidenz formuliert (`07_conclusion.tex:12`).
   8. **Traceability:** **nicht erfüllt**. Die \(7.4\,[3.1,11.8]\) stehen korrekt in Tabelle 4; die Bin-Zahlen wurden aus Abschnitt 5 entfernt. Der vorgeschriebene Prätrend-Tabellenverweis fehlt.
   9. **Autorennotiz und Chetty-Verweise:** belegt erfüllt hinsichtlich Eintrag und Verweisziel (`references.bib:18–21`, `04_empirical_model.tex:30`, `t051_robustness.tex:33`).
   10. **Kürzungen und Seitenlimit:** anhand des Diffs und der Seitenmarker belegt erfüllt; sprachliche Qualität nicht meine Rolle.

Die verglichenen übernommenen Tabellen und Abbildungen sind byteidentisch mit ihren Gegenstücken unter `replication/outputs/`. Die neu zusammengestellten Haupttexttabellen wurden zahlenweise abgeglichen.

## Nicht geprüft

- Keine Befehle ausgeführt, keine Dateien geändert und keinen neuen Build gestartet; keine visuelle PDF-Prüfung.
- Keine Bewertung der Datenbereinigung, Schätzverfahren oder Identifikationsvalidität; diese liegen außerhalb der Consistency-Rolle.
- Keine erneute Primärquellenprüfung der Literatur und Vertragsdokumente; Vertragszahlen wurden gegen die abgelegten CSV-Nachweise geprüft.
- Keine vollständige erneute Zahlenprüfung unveränderter Anhangsteile und Literatur-Suchstatistiken.
- Vollständige Änderungsintegrität mangels gespeicherter Ausgangsprüfsummen nicht prüfbar. Die sieben gemeldeten Änderungen unter `proposal/sections/` liegen innerhalb des ausdrücklich erlaubten Schreibbereichs und belegen für sich keinen Scope-Verstoß.