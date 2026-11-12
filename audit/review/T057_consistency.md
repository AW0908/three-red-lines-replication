## Rolle: consistency (codex, high) – VERDICT: REWORK


## Befunde

1. **Die Schriftvorgabe für Abbildungen ist nicht erfüllt.** `proposal/figures/t055_kappa.pdf` enthält Helvetica, Helvetica-Bold und Symbol ohne eingebettete Fontdateien (PDF-Objekte 10–12). Die Legendentexte haben im Original 10 pt; bei 648 bp Originalbreite und der Einbindung nach `proposal/appendix/results.tex:16` verbleiben ungefähr 7 pt. Damit unterschreitet bereits Abbildung B5 die geforderten 9 pt. Die bytegleiche Übernahme aus dem Replikationsoutput belegt die unveränderte Abbildung, erfüllt aber Punkt 5 der Karte nicht.

2. **Der gedruckte KI-Anhang nennt den Stichtag seiner Audit-Zahlen nicht ausreichend genau.** Die Zahlen 48 akzeptierte Karten, 63 Revisionsrunden und 26 Overrides in `proposal/appendix/ai_use.tex:46` entsprechen exakt dem Stand vom **30.10.2026, 13:42 Uhr**. Diese Uhrzeit steht nur im Quellenkommentar, Zeile 4. Der gedruckte Text spricht allgemein vom 30. Oktober „before this final revision“. Vor Beginn von T057 waren bereits 56 Karten akzeptiert und 33 Overrides protokolliert (`state/approvals.log:147–163`). Der Text muss den tatsächlichen historischen Stichtag nennen oder die Zahlen aktualisieren, damit seine zeitliche Bedeutung eindeutig bleibt.

3. **Das wörtliche Bereinigungskriterium ist nicht erfüllt.** Das Suchmuster aus Abnahmekriterium 1 trifft außerhalb von `% source:`-Zeilen noch auf 25 Zeilen zu, beispielsweise `proposal/appendix/results.tex:4`, `proposal/appendix/variables.tex:14` und `proposal/tables/t043_delta_excess.tex:2`. Sämtliche gefundenen Treffer sind Kommentare; im gedruckten Text fand ich keine Treffer. Das ist kein Fehler der Ergebnisse, verhindert aber die behauptete vollständige Erfüllung des ausdrücklich formulierten Quelltextkriteriums.

## Abnahmekriterien

1. **Zahlen, Verweise und bereinigte Bezeichnungen: nicht erfüllt insgesamt.** Die geprüften Tabellenwerte stimmen mit den zugehörigen CSVs überein, einschließlich Fallzahlen, Vorzeichen, Rundungen und Einheiten. Das gilt insbesondere für die neuen Tabellen B1, B11 und B18 sowie die umformatierten Ergebnistabellen. Die Umrechnung von D in Prozentpunkte ist korrekt. Alle geprüften `\ref`-/`\eqref`-Ziele sind im vorhandenen Build aufgelöst. Offen bleiben Befunde 2 und 3.

2. **Sauberer Build, keine Überläufe über 1 pt, Haupttext bis Seite 15: nicht vollständig prüfbar.** Das vorhandene `review/T057_build/main.log` enthält keine Overfull-Meldung und keine undefinierten Verweise oder Zitate. `main.aux:110` verortet das Haupttextende auf Seite 15. Eine vollständige visuelle Kontrolle aller Anhangsseiten wurde nicht vorgenommen.

3. **Berichtszeile zu jedem Punkt 1–8 und vollständige Float-Liste: belegt erfüllt.** `tasks/T057_report.md:40–70` enthält beides. Nummern und Startseiten stimmen mit dem vorhandenen `main.aux` überein.

Zu den Punkten der Karte:

- **P1 Nummerierung: belegt erfüllt.** `proposal/preamble.tex:89–93` und die Build-Referenzen zeigen A1–A3, B1–B22, Abbildungen B1–B6 und C1.
- **P2 Layout:** vollständige visuelle Layoutabnahme **nicht meine Rolle**; die verlangten Float-Strukturen und die Aufteilung von B7 sind im Quelltext vorhanden.
- **P3 Lesbare Labels: nicht erfüllt im wörtlichen Quelltextkriterium**, siehe Befund 3. Die gedruckten Bezeichnungen sind bereinigt.
- **P4 Widersprüche und Duplikate: belegt erfüllt hinsichtlich Konsistenz.** Definitionen und Validierungsverweise passen zu Abschnitt 4.3. Allgemeine Stilprüfung: **nicht meine Rolle**.
- **P5 Abbildungsschriften: nicht erfüllt**, siehe Befund 1.
- **P6 T055-Einbindungen: belegt erfüllt.** Haupttext und Tabellennote verweisen auf B1, B11, B18 beziehungsweise Abbildung B5; Werte und Notes stimmen mit den Quellen überein. Die neue Pretrend-Aussage entspricht den ausgewiesenen p-Werten.
- **P7 KI-Anhang: nicht vollständig erfüllt.** Die verlangten Spalten, Nutzungscluster und Verantwortungsangaben sind vorhanden; der Audit-Stichtag bleibt im gedruckten Text unklar.
- **P8 Literatursuchnotiz: belegt erfüllt.** Suchdaten, eingegebene Datumsfilter und Trefferzahlen entsprechen `state/litsearch/search_log.csv`.

## Nicht geprüft

- Keine Befehle oder neuen Builds ausgeführt und keine Dateien verändert. Code- und Datenkorrektheit sowie die Identifikationsstrategie wurden entsprechend der Spezialrolle nicht bewertet.
- Keine vollständige visuelle PDF-Abnahme oder erneute Prüfung sämtlicher unverändert übernommener Literatur- und Originalbelege.
- Die genauen Nutzungsdaten der externen DeepSeek- und Gemini-Reviews sind aus den gelesenen Logs nicht belegbar.
- Die 15 Dateien des Freeze-Manifests sind prüfsummengleich. Für zusätzlich gelesene, dort nicht enthaltene Dateien wurde deren vorhandene Fassung geprüft.
- `state/runs.log` wurde ausschließlich ergänzt: Der Baseline-Inhalt ist ein prüfsummengleicher Präfix der aktuellen Datei. Die übrigen gemeldeten Änderungen außerhalb des Schreibbereichs lassen sich anhand ihrer Änderungszeiten allein keinem Verursacher sicher zuordnen.