## Rolle: language (codex, high) – VERDICT: REWORK


## Befunde

1. **Der Haupttext überschreitet die Grenze von sechs Seiten.** `proposal/theory_note.tex:251`: Die Diskussion läuft in der erzeugten PDF auf Seite 7 weiter und endet dort mit „These extensions are left for future work.“ Erst anschließend beginnt die Bibliografie. Der Haupttext umfasst somit **sieben Seiten**, auch ohne Bibliografie und Anhänge. Das verletzt die ergänzte Vorgabe in `tasks/T026.md:115`. **Korrekturvorschlag:** Haupttext kürzen oder ausführliche Erläuterungen in Anhang B verschieben, bis die Diskussion spätestens auf Seite 6 endet; Schriftgröße und Zeilenabstand beibehalten. Beleg: Seite 7 von :codex-file-citation{path="/Users/<local>/Desktop/UNI/5. Semester PKU/Policy Analysis/review/T026_theory_build/theory_note.pdf" purpose="source"}.

2. **Amerikanische Schreibweise vereinheitlichen.** `proposal/theory_note.tex:374`: „after both sets of fixed effects have been **partialled out**“. **Korrekturvorschlag:** „after both sets of fixed effects have been **partialed out**“. Die bisherige Schreibweise entspricht der britischen Variante; die Rolle verlangt durchgehend amerikanisches Englisch.

## Abnahmekriterien

1. **Propositionen und vollständige algebraische Herleitung:** nicht meine Rolle. Sprachlich sind Aussagen und Beweise klar gegliedert; mathematische Richtigkeit nicht bewertet.

2. **Vorhersage–Test-Tabelle entspricht den geplanten Tests:** inhaltlich nicht meine Rolle. **Sprachlicher Teil belegt erfüllt:** verständliche Tabellenzeilen und zugeordnete Bedingungen in `proposal/theory_note.tex:205–243`; DiD und RD werden bei ihrer ersten Verwendung im Haupttext erklärt (`:198`).

3. **Eigenständig kompilierbar:** **belegt erfüllt anhand des vorhandenen Übersetzungsnachweises.** `review/T026_theory_build/theory_note.log:1247–1248` dokumentiert die erzeugte PDF mit 13 Seiten. Keine eigene Übersetzung durchgeführt.

4. **Keine Änderungen anderer Dateien:** nicht meine Rolle. Die mitgelieferten Integritätshinweise erlauben keine eindeutige Zuordnung der Änderungen zu T026.

5. **Ergänzung: Haupttext höchstens sechs Seiten:** **nicht erfüllt**, siehe Befund 1.

6. **Ergänzung: weder „Float too large“ noch „Overfull \hbox“:** **belegt erfüllt im vorhandenen vollständigen LaTeX-Log.**

7. **Frühere sprachliche Korrekturen:** **belegt erfüllt:** P1–P5 als getrennte Sätze (`:56`), H4 erläutert (`:176`), gekürzter Propositionstitel und Einstieg (`:181–183`), überarbeitete P5-Tabellenzeile (`:225`) sowie korrigierter Satz zu den Bilanzgrößen (`:364`).

## Nicht geprüft

- Mathematik, Variablendefinitionen, Stichprobe, Schätzcode und Übereinstimmung mit empirischen Ergebnissen: andere Spezialrollen.
- Urheberschaft der gemeldeten Änderungen außerhalb des Schreibbereichs sowie Änderungen an `STATE.md` und `LIMITATIONS.md`.
- Vollständige visuelle PDF-Prüfung auf Überlagerungen oder abgeschnittene Elemente; Seitenumfang anhand der vorhandenen PDF-Inhalte, Layoutwarnungen anhand des Logs geprüft.
- Die ausdrücklich ausgenommenen Altbefunde „stylised“ in `03_framework.tex` und „china“ in der Bibliografie sind keine Nacharbeitsforderungen an T026.
- Keine Dateien verändert und keine Shell- oder Analysebefehle ausgeführt.