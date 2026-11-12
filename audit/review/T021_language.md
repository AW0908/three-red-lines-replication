## Rolle: language (codex, high) – VERDICT: REWORK


## Befunde

1. **Abkürzungen werden im neuen Fließtext nicht ausdrücklich eingeführt.**
   - `proposal/sections/06_preliminary_analysis.tex:35`: „SE“, „CI“ und „JV“ erscheinen ohne zugeordnete Langform. Vorschlag beim ersten Ergebnis: „standard error (SE) 0.0101; 95\% confidence interval (CI) …“. „317 lack JV values“ durch „317 lack joint-venture investment values“ ersetzen.
   - `proposal/sections/06_preliminary_analysis.tex:88`: „SOE“ wird verwendet, ohne ausdrücklich als „state-owned enterprise“ eingeführt zu werden. Vorschlag: „46 are classified as state-owned enterprises (SOEs), 82 as private …“.
   
   Das beeinträchtigt die eigenständige Verständlichkeit und erfüllt die vorgegebene Abkürzungsregel noch nicht vollständig. Frühere Verwendungen im Abstract beziehungsweise in Abschnitt 2 benötigen gegebenenfalls ebenfalls eine Einführung im späteren globalen Sprachdurchgang.

2. **Hinweis außerhalb des aktuellen Korrekturumfangs:** Die bereits zurückgestellten Sprachmängel der generierten Robustheitstabelle bestehen weiterhin:
   - `proposal/tables/t011_robustness.tex:62`: „95 percent CIs“ → `95\% confidence intervals`.
   - Zeile 67: `(t = 1,...,13)` → `$(t = 1,\ldots,13)$`.
   - Zeile 68: „Winsorise … at 1/99 percent“ → „Winsorize … at the 1st and 99th percentiles“.
   
   Dies bleibt gemäß `tasks/T021.md:83` Aufgabe einer späteren Code-Karte und begründet keine zusätzliche Nacharbeit innerhalb T021.

Die zuvor beanstandeten Satzanschlüsse, amerikanischen Schreibweisen, Datumsformate, Zitierabstände und das Präsens sind in den beiden bearbeiteten Textdateien korrigiert.

## Abnahmekriterien

1. **Übersetzung und aufgelöste Verweise:** Nicht meine Rolle. `review/T021_latex.txt:1` meldet eine fehlerfreie Übersetzung; eine vollständige Prüfung auf ungelöste Verweise ist daraus nicht ersichtlich.
2. **Vollständige Zahl–Quelle-Liste:** Nicht meine Rolle; die sachliche Vollständigkeit und Richtigkeit sind vom Consistency Reviewer zu prüfen.
3. **Platzierung der Tabellen und Abbildungen:** Nicht meine Rolle.
4. **Signifikanzbehauptungen und H4:** Sprachlich belegt erfüllt. Einschränkungen werden ausdrücklich formuliert (`06_preliminary_analysis.tex:35,58,96,100`); H4 bleibt ohne gerichtete Vorhersage (Zeile 88). Die Übereinstimmung mit den Schätzergebnissen ist nicht meine Rolle.
5. **Längenschätzung:** Im Bericht vorhanden (`tasks/T021_report.md:29`: rund fünf Seiten). Die spätere Kürzung ist laut Kartenfeedback zurückgestellt; die Layoutprüfung ist nicht meine Rolle.

## Nicht geprüft

- Variablenberechnung, Stichprobenfilter, Schätzungen, Datenintegrität und Reproduzierbarkeit: außerhalb der Spezialrolle.
- Herkunft und Zulässigkeit der gemeldeten Änderungen außerhalb des Schreibbereichs sowie der Änderung an `state/STATE.md`: nicht untersucht.
- Gerendertes PDF, Seitenumbrüche und tatsächliche Abschnittslänge: keine Sichtprüfung vorgenommen.
- Keine Dateien geändert und keine Shell-, Analyse- oder Übersetzungsbefehle ausgeführt.