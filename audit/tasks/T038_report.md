## Ergebnis
Ich habe alle sieben Punkte aus dem Co-PI-Feedback umgesetzt. Ob der Haupttext jetzt höchstens 15 Seiten hat, weiß ich nicht: Ich konnte nicht bauen, die Länge ist also ungeprüft. Gekürzt habe ich in den Abschnitten 4–6 um grob 250 Wörter netto, das sind rund ½ Seite. Verlangt war etwa ¾ Seite. Die Schätzung ist unsicher, es kann also knapp daneben liegen.

## Dateien
- `proposal/sections/05_context_data.tex`
  - RL1 nutzt jetzt überall dasselbe Maß: Verbindlichkeiten ohne Anzahlungen geteilt durch Gesamtvermögen ohne Anzahlungen.
  - Die Unsicherheit betrifft jetzt die regulatorische Definition: Behandlung der Perpetual Bonds und genauer Nenner sind ungeprüft.
  - RL3 wurde präzisiert: nicht eingeschränkte Zahlungsmittel, wo ausgewiesen; sonst Gesamtzahlungsmittel als Obergrenze.
  - Gekürzt: Pilot-Absatz und ein Satzende bei den Summary Statistics.
- `proposal/sections/03_framework.tex` – "when both cost pairs yield interior solutions" eingefügt.
- `proposal/sections/04_empirical_model.tex`
  - CR1 ist eingeführt.
  - Die Stichprobe heißt jetzt "all eligible paired post-policy observations".
  - Der Satz zur Interpretationsregel ist gekürzt.
- `proposal/sections/06_preliminary_analysis.tex`
  - Gleiche Formulierung zur Stichprobe wie in Abschnitt 4.
  - Der letzte Absatz von 6.4 (RD, Attrition) ist auf einen Verweis mit der Aussage "suggestive debt reduction, p = 0.095; no differential decline in RL1" gekürzt.
  - Gekürzt: Discussion und Pilot-Absatz.
  - Gestrichen: der Satz "Of the officially compliant … 24.4 percent … 10.4 percent".
- `proposal/appendix/results.tex`
  - SOE ist eingeführt.
  - Der verschobene RD- und Attrition-Absatz steht als Lead-in von `app:res_exposure`, mit unveränderten Zahlen und `% source`-Kommentaren.
- `proposal/main.tex` – Titelseite jetzt "November 27, 2026".

## Ausführung
Kein Build: Ich habe keinen LaTeX-Lauf ausgeführt und keine Seitenzahl geprüft. Der Befehl für den PI bleibt: `cd proposal && latexmk -pdf -interaction=nonstopmode -outdir=../review/T038_build main.tex; cd ..`

## Abnahmekriterien
- **Followup-Punkte, Terminologie, Abkürzungen:** erfüllt für die sieben Punkte des Feedbacks.
- **Keine Zahl und keine Aussage geändert:** Zahlen sind unverändert, aber zwei Dinge sind weg oder verschoben.
  - Die RD- und Attrition-Zahlen stehen jetzt im Appendix statt im Haupttext.
  - Gestrichen wurden "24.4 percent [16.1, 33.1]" und "10.4 percent". Sie stammen aus `replication/outputs/tables/t029_compliance.csv` (`fail_given_official`), und der Quellkommentar im Text dazu bleibt stehen.
  - Der Consistency-Reviewer sollte diese zwei Stellen gezielt prüfen.
- **Haupttext höchstens 15 Seiten, keine Float- und Referenzfehler:** nicht geprüft, siehe oben.
- **Alle Zahlen im neuen Text:** nur die verschobenen, in den Dateien oben genannten Werte (`t024_rd_main.csv`, `t024_rd_robustness.csv`, `t025_selection.csv`). Neue Zahlen gibt es keine.

## Offene Fragen
- Falls die Conclusion im PI-Build weiter auf Seite 16 beginnt, sind weitere Kürzungen nötig. Naheliegend wäre 6.3, der Absatz "Persistence below the threshold" zu den Reversal-Tests.
- Ich habe in 04 den Halbsatz "no drop means it is achieved through other items" gestrichen. Sollte der Co-PI ihn als Teil der Vorab-Interpretationsregel für nötig halten, bitte wieder einfügen.
- Der Verweis `app:res_exposure` ist ein bestehendes Label, aber ich habe nicht mit LaTeX getestet, dass er auflöst.
