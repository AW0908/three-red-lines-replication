## Rolle: consistency (codex, medium) – VERDICT: ESCALATE


## Befunde

[number withheld]. **Der Eingabestand ist nicht durchgehend eingefroren belegt.** Die übermittelte SHA-[number withheld]-Prüfung meldet `state/STATE.md` seit Ausführungsbeginn als verändert oder gelöscht. Diese Datei ist ausdrücklich Input der Karte und des Skripts (`replication/code/14_core_robustness.R`, Zeilen [number withheld]–[number withheld]). Die skriptinterne Prüfung vergleicht dagegen nur den Stand innerhalb eines einzelnen Laufs (Zeile [number withheld]). Auch `t041_hashes.csv` enthält keinen Vergleich für `state/STATE.md`. Damit schließen erfolgreiche Laufprüfungen die gemeldete Änderung seit Kartenbeginn nicht aus. Der PI muss die Änderung gegen den freigegebenen Ausgangsstand einordnen. Eine Auswirkung auf die Zahlen ist dadurch **nicht nachgewiesen**.

[number withheld]. **Keine numerischen Widersprüche innerhalb der geprüften T041-Ergebnisse gefunden.** Alle [number withheld] Datumszeilen, vier Dichteschätzer und [number withheld] Horizont-/Kontrastzeilen stimmen zwischen CSV und TeX einschließlich Firmenzahlen, Rundung, Vorzeichen und Intervallen überein. Die fünf Querschnitte stimmen ebenfalls überein. Aus den [number withheld] gespeicherten Datumsauswahlen ergeben sich [number withheld] positive Schätzungen, Mittelwert [number withheld] und Perzentile [[number withheld]; [number withheld]], passend zur TeX-Zusammenfassung. Das Integritätsproblem aus Befund [number withheld] bleibt davon unabhängig.

## Abnahmekriterien

[number withheld]. **Reproduktionsassertionen, bestehende Outputs und zwei identische Läufe: teilweise belegt erfüllt; Freigabestand nicht abschließend prüfbar.**
   - Beide Build-Logs enthalten identisch `b_post=[number withheld]` und `D=[number withheld]`.
   - `t041_hashes.csv` dokumentiert [number withheld] unveränderte Bestandsdateien und zehn über beide Läufe identische Analyseartefakte. Sämtliche [number withheld] aktuellen Datei-Hashes stimmen mit den gespeicherten Endwerten überein.
   - Die Unverändertheit von `state/STATE.md` seit Ausführungsbeginn ist dagegen nicht belegt; siehe Befund [number withheld].
   - Statistische Korrektheit der Reproduktion: **nicht meine Rolle**.

[number withheld]. **Alle vorgesehenen Varianten und Firmenzahlen: belegt erfüllt hinsichtlich Darstellung und Übereinstimmung.**
   - Vorhanden sind zwölf Halbjahre, fünf Querschnitte, [number withheld] Datumsauswahlen, vier Dichteschätzer und [number withheld] Horizont-/Kontrastzeilen.
   - Jede CSV-Schätzung weist Firmenzahlen aus; Horizontkontraste nennen beide Vergleichsstichproben.
   - Der nicht verfügbare Dreijahreshorizont des Juni-[number withheld]-Placebos ist ausdrücklich als fehlend dargestellt.
   - Notes unterscheiden das beobachtet/kontrafaktisch-Verhältnis, Überschussmasse \(b\), Compliance-Differenz \(D\) und die Datumsauswahlverteilung. Letztere wird ausdrücklich nicht als Konfidenzintervall interpretiert.
   - Auswahl und Berechnung der Varianten: **nicht meine Rolle**.

[number withheld]. **Differenzierte Bewertung jedes Checks: belegt erfüllt.**
   - `t041_verification.txt`, Zeilen [number withheld]–[number withheld], entspricht den Outputs: Die Intervalle für [number withheld]H2 und [number withheld]H1 enthalten [number withheld]; die angeforderten postpolitischen Querschnitte schließen null erst ab [number withheld]H2 aus; alle drei einfacheren Dichteschätzer haben positive Intervalluntergrenzen.
   - Gegen beide MI-Placebos sind die Differenzintervalle bei [number withheld]–[number withheld] Jahren positiv. Die Einschränkungen bei einem beziehungsweise drei Jahren werden korrekt genannt.
   - Die Interpretation beansprucht weder einen kausalen Policy-Effekt noch einen Nachweis ökonomischen Schuldenabbaus.

## Nicht geprüft

- Datenbereinigung, Schätzverfahren und Identifikationsannahmen: außerhalb der Consistency-Rolle; keine Analyseskripte ausgeführt.
- Gerenderte PDF-Darstellung: keine Sichtprüfung. Gespeicherte Beschriftungen und Zeichenkoordinaten wurden lesend geprüft.
- T041 ist noch nicht in `proposal/` eingebunden; die Karte verlangt diese Übernahme nicht. Ein vollständiger Audit älterer Proposal-Ergebnisse war nicht Gegenstand dieser Prüfung.
- Urheberschaft und Inhalt der gemeldeten Änderungen außerhalb des Schreibbereichs. Änderungszeiten allein belegen keine Inhaltsänderung durch den Worker. Der ursprüngliche Stand von `state/STATE.md` lag nicht zum Vergleich vor.