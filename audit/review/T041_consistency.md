## Rolle: consistency (codex, medium) – VERDICT: ESCALATE


## Befunde

1. **Der Eingabestand ist nicht durchgehend eingefroren belegt.** Die übermittelte SHA-256-Prüfung meldet `state/STATE.md` seit Ausführungsbeginn als verändert oder gelöscht. Diese Datei ist ausdrücklich Input der Karte und des Skripts (`replication/code/14_core_robustness.R`, Zeilen 9–11). Die skriptinterne Prüfung vergleicht dagegen nur den Stand innerhalb eines einzelnen Laufs (Zeile 312). Auch `t041_hashes.csv` enthält keinen Vergleich für `state/STATE.md`. Damit schließen erfolgreiche Laufprüfungen die gemeldete Änderung seit Kartenbeginn nicht aus. Der PI muss die Änderung gegen den freigegebenen Ausgangsstand einordnen. Eine Auswirkung auf die Zahlen ist dadurch **nicht nachgewiesen**.

2. **Keine numerischen Widersprüche innerhalb der geprüften T041-Ergebnisse gefunden.** Alle 12 Datumszeilen, vier Dichteschätzer und 25 Horizont-/Kontrastzeilen stimmen zwischen CSV und TeX einschließlich Firmenzahlen, Rundung, Vorzeichen und Intervallen überein. Die fünf Querschnitte stimmen ebenfalls überein. Aus den 999 gespeicherten Datumsauswahlen ergeben sich 998 positive Schätzungen, Mittelwert 3,1836 und Perzentile [1,0232; 5,8557], passend zur TeX-Zusammenfassung. Das Integritätsproblem aus Befund 1 bleibt davon unabhängig.

## Abnahmekriterien

1. **Reproduktionsassertionen, bestehende Outputs und zwei identische Läufe: teilweise belegt erfüllt; Freigabestand nicht abschließend prüfbar.**
   - Beide Build-Logs enthalten identisch `b_post=3.142854757615` und `D=0.114617940199`.
   - `t041_hashes.csv` dokumentiert 183 unveränderte Bestandsdateien und zehn über beide Läufe identische Analyseartefakte. Sämtliche 193 aktuellen Datei-Hashes stimmen mit den gespeicherten Endwerten überein.
   - Die Unverändertheit von `state/STATE.md` seit Ausführungsbeginn ist dagegen nicht belegt; siehe Befund 1.
   - Statistische Korrektheit der Reproduktion: **nicht meine Rolle**.

2. **Alle vorgesehenen Varianten und Firmenzahlen: belegt erfüllt hinsichtlich Darstellung und Übereinstimmung.**
   - Vorhanden sind zwölf Halbjahre, fünf Querschnitte, 999 Datumsauswahlen, vier Dichteschätzer und 25 Horizont-/Kontrastzeilen.
   - Jede CSV-Schätzung weist Firmenzahlen aus; Horizontkontraste nennen beide Vergleichsstichproben.
   - Der nicht verfügbare Dreijahreshorizont des Juni-2017-Placebos ist ausdrücklich als fehlend dargestellt.
   - Notes unterscheiden das beobachtet/kontrafaktisch-Verhältnis, Überschussmasse \(b\), Compliance-Differenz \(D\) und die Datumsauswahlverteilung. Letztere wird ausdrücklich nicht als Konfidenzintervall interpretiert.
   - Auswahl und Berechnung der Varianten: **nicht meine Rolle**.

3. **Differenzierte Bewertung jedes Checks: belegt erfüllt.**
   - `t041_verification.txt`, Zeilen 29–32, entspricht den Outputs: Die Intervalle für 2020H2 und 2021H1 enthalten 1; die angeforderten postpolitischen Querschnitte schließen null erst ab 2021H2 aus; alle drei einfacheren Dichteschätzer haben positive Intervalluntergrenzen.
   - Gegen beide MI-Placebos sind die Differenzintervalle bei 1,5–2,5 Jahren positiv. Die Einschränkungen bei einem beziehungsweise drei Jahren werden korrekt genannt.
   - Die Interpretation beansprucht weder einen kausalen Policy-Effekt noch einen Nachweis ökonomischen Schuldenabbaus.

## Nicht geprüft

- Datenbereinigung, Schätzverfahren und Identifikationsannahmen: außerhalb der Consistency-Rolle; keine Analyseskripte ausgeführt.
- Gerenderte PDF-Darstellung: keine Sichtprüfung. Gespeicherte Beschriftungen und Zeichenkoordinaten wurden lesend geprüft.
- T041 ist noch nicht in `proposal/` eingebunden; die Karte verlangt diese Übernahme nicht. Ein vollständiger Audit älterer Proposal-Ergebnisse war nicht Gegenstand dieser Prüfung.
- Urheberschaft und Inhalt der gemeldeten Änderungen außerhalb des Schreibbereichs. Änderungszeiten allein belegen keine Inhaltsänderung durch den Worker. Der ursprüngliche Stand von `state/STATE.md` lag nicht zum Vergleich vor.