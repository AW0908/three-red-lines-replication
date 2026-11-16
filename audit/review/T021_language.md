## Rolle: language (codex, high) – VERDICT: REWORK


## Befunde

[number withheld]. **Abkürzungen werden im neuen Fließtext nicht ausdrücklich eingeführt.**
   - `proposal/sections/06_preliminary_analysis.tex:35`: „SE“, „CI“ und „JV“ erscheinen ohne zugeordnete Langform. Vorschlag beim ersten Ergebnis: „standard error (SE) [number withheld]; [number withheld]\% confidence interval (CI) …“. „[number withheld] lack JV values“ durch „[number withheld] lack joint-venture investment values“ ersetzen.
   - `proposal/sections/06_preliminary_analysis.tex:88`: „SOE“ wird verwendet, ohne ausdrücklich als „state-owned enterprise“ eingeführt zu werden. Vorschlag: „[number withheld] are classified as state-owned enterprises (SOEs), [number withheld] as private …“.
   
   Das beeinträchtigt die eigenständige Verständlichkeit und erfüllt die vorgegebene Abkürzungsregel noch nicht vollständig. Frühere Verwendungen im Abstract beziehungsweise in Abschnitt [number withheld] benötigen gegebenenfalls ebenfalls eine Einführung im späteren globalen Sprachdurchgang.

[number withheld]. **Hinweis außerhalb des aktuellen Korrekturumfangs:** Die bereits zurückgestellten Sprachmängel der generierten Robustheitstabelle bestehen weiterhin:
   - `proposal/tables/t011_robustness.tex:62`: „[number withheld] percent CIs“ → `[number withheld]\% confidence intervals`.
   - Zeile [number withheld]: `(t = [number withheld],...,[number withheld])` → `$(t = [number withheld],\ldots,[number withheld])$`.
   - Zeile [number withheld]: „Winsorise … at [number withheld]/[number withheld] percent“ → „Winsorize … at the [number withheld]st and [number withheld]th percentiles“.
   
   Dies bleibt gemäß `tasks/T021.md:83` Aufgabe einer späteren Code-Karte und begründet keine zusätzliche Nacharbeit innerhalb T021.

Die zuvor beanstandeten Satzanschlüsse, amerikanischen Schreibweisen, Datumsformate, Zitierabstände und das Präsens sind in den beiden bearbeiteten Textdateien korrigiert.

## Abnahmekriterien

[number withheld]. **Übersetzung und aufgelöste Verweise:** Nicht meine Rolle. `review/T021_latex.txt:1` meldet eine fehlerfreie Übersetzung; eine vollständige Prüfung auf ungelöste Verweise ist daraus nicht ersichtlich.
[number withheld]. **Vollständige Zahl–Quelle-Liste:** Nicht meine Rolle; die sachliche Vollständigkeit und Richtigkeit sind vom Consistency Reviewer zu prüfen.
[number withheld]. **Platzierung der Tabellen und Abbildungen:** Nicht meine Rolle.
[number withheld]. **Signifikanzbehauptungen und H4:** Sprachlich belegt erfüllt. Einschränkungen werden ausdrücklich formuliert (`[number withheld]_preliminary_analysis.tex:[number withheld]`); H4 bleibt ohne gerichtete Vorhersage (Zeile [number withheld]). Die Übereinstimmung mit den Schätzergebnissen ist nicht meine Rolle.
[number withheld]. **Längenschätzung:** Im Bericht vorhanden (`tasks/T021_report.md:29`: rund fünf Seiten). Die spätere Kürzung ist laut Kartenfeedback zurückgestellt; die Layoutprüfung ist nicht meine Rolle.

## Nicht geprüft

- Variablenberechnung, Stichprobenfilter, Schätzungen, Datenintegrität und Reproduzierbarkeit: außerhalb der Spezialrolle.
- Herkunft und Zulässigkeit der gemeldeten Änderungen außerhalb des Schreibbereichs sowie der Änderung an `state/STATE.md`: nicht untersucht.
- Gerendertes PDF, Seitenumbrüche und tatsächliche Abschnittslänge: keine Sichtprüfung vorgenommen.
- Keine Dateien geändert und keine Shell-, Analyse- oder Übersetzungsbefehle ausgeführt.