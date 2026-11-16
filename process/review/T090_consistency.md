## Rolle: consistency (declared=codex, effective=codex, medium, Modell=Provider-Standard) – VERDICT: PASS


## Befunde

[number withheld]. **Keine Abweichungen zwischen den lesbaren Tabellen und den CSV-Outputs gefunden.** Alle [number withheld] Datenzeilen in `replication/outputs/tables/t090_primary_table.md:7–30` stimmen hinsichtlich Medianen, Fallzahlen, Differenzen, Vorzeichen, Rundung und Intervallgrenzen mit `t090_distributions.csv` beziehungsweise `t090_contrasts.csv` überein. Alle [number withheld] Datenzeilen in `t090_validation_table.md:7–38` stimmen mit `t090_validation.csv` überein.

[number withheld]. **Fallzahlen und deskriptive Aussagen werden durch die abgelegten Dateien gestützt.** Unabhängig und ausschließlich im Arbeitsspeicher nachgerechnet: sämtliche [number withheld] Verteilungs-/Grenzwertzeilen aus dem Indikatorpanel sowie sämtliche [number withheld] Validierungszeilen aus `t090_validation_links.csv`; keine Abweichungen bei den geprüften Fallzahlen und Statistiken. Das Panel enthält [number withheld] Firma-Halbjahre aus [number withheld] Firmen. Die Aussage fehlender konsistenter diagnostischer Trennung in `t090_validation_table.md:40–42` ist mit den Outputs vereinbar: beobachtete Wachstums- und Zinsflags sind an den Ereignisendpunkten null; Ausschüttungsflags fehlen bei D/G/E.

[number withheld]. **Die eingeschränkte Bedeutung von Indikator [number withheld] ist korrekt offengelegt.** `t090_methods.md:15–16` und `t090_primary_table.md:32` bezeichnen die Messgröße ausdrücklich als ausgewiesenen Zinsaufwand ohne kapitalisierte Zinsen und schließen HK aus. Die Texte behaupten weder vollständige Finanzierungskosten noch den Nachweis versteckter Schulden. Ob diese Messgröße die Forschungsanforderung hinreichend erfüllt, entscheidet die Estimation-Rolle beziehungsweise der PI; dieses Konsistenz-PASS ersetzt diese Entscheidung nicht.

## Abnahmekriterien

[number withheld]. **Belegt erfüllt hinsichtlich Dokumentationskonsistenz.** `t090_definitions.csv` enthält Definitionen, Quellenfelder, Einheiten und Fehlwertregeln für alle sechs Teilmaße. Diese entsprechen den Formeln in `replication/code/32_red_flags.R:94–100` und den Erläuterungen in `t090_methods.md:9–16`. Fachliche Richtigkeit der Ausgangsdaten: nicht meine Rolle.

[number withheld]. **Belegt erfüllt hinsichtlich Übereinstimmung und Offenlegung.** Die vier Grenzwerte in `t090_cutoff_definitions.csv` entsprechen der Karte. Gruppenformeln, Anker und Perioden sind in `t090_methods.md:5–8` dokumentiert und entsprechen dem Code, Zeilen [number withheld]–[number withheld]. Die Beschränkung des Wachstumstests auf positive MI-Zuwächse ist ausdrücklich ausgewiesen. Methodische Zulässigkeit dieser Nennerkonvention: nicht meine Rolle.

[number withheld]. **Belegt erfüllt hinsichtlich Tabellen- und Textkonsistenz.** [number withheld] Verteilungszeilen und [number withheld] Grenzwertzeilen decken beide Märkte, beide Perioden und drei Gruppen ab; HK-Auslassungen sind gekennzeichnet. Fallzahlen und Punktschätzer wurden unabhängig rekonstruiert. Die lesbare Haupttabelle übernimmt die CSV-Intervallgrenzen korrekt. Die eingeschränkte Zinsmessung bleibt der unter Befund [number withheld] genannten fachlichen Entscheidung vorbehalten.

[number withheld]. **Belegt erfüllt.** Validierungstabellen für D/G/E/U liegen vor. Überlappende Kategorien, unbekannter Status U und geringe Abdeckung werden korrekt beschrieben (`t0[number withheld]_validation_table.md:[number withheld]–[number withheld]`). Keine überprüfte T090-Ergebnispassage bezeichnet eine Firma als Nutzer versteckter Schulden.

[number withheld]. **Belegt erfüllt für bestehende Outputs und Freeze.** Alle [number withheld] Freeze-Dateien und vier Eingabebaseline-Dateien stimmen mit ihren SHA-[number withheld]-Werten überein. Im zusätzlichen Schutzverzeichnis stimmen [number withheld] von [number withheld] Dateien; allein `tasks/T090.md` weicht vom früheren Kartenstand ab. Bestehende geschützte Outputs sind unverändert. Die vier ersetzten Vorlaufartefakte sind in `t090_artifacts.csv` aufgeführt; sämtliche dortigen Dateihashes sowie die acht gesicherten Backup-Inhalte wurden bestätigt.

## Nicht geprüft

- Keine vollständige Prüfung älterer Proposal-Ergebnisse. Die gezielte Suche ergab keine T090-Bezüge im Proposal; eine Integration der neuen Ergebnisse war nicht Gegenstand dieser Karte.
- Keine erneute Analyseausführung, Datenvalidierung oder Beurteilung der Identifikation und Bootstrap-Methode. Diese Punkte gehören zu den anderen Fachrollen.
- Kein unabhängiger Abgleich der Intervalle mit dem RDS-Inhalt: Der lesend beabsichtigte R-Aufruf scheiterte bereits an der temporären Datei des R-Starts. Die Intervallübernahme CSV → Markdown wurde vollständig geprüft; Worker-Verifikationstabellen gelten nicht als unabhängiger Inferenznachweis.
- Kein Netzwerkzugriff und keine externe Quellenprüfung. Keine Datei wurde geändert.
- Reviewer und Worker gehören zur Codex-Modellfamilie. Es besteht Prozessunabhängigkeit, keine vollständige Modellunabhängigkeit; korrelierte Fehler bleiben möglich. Ein externes menschliches oder anderes Modell-Audit bleibt dem PI als zusätzliche Option offen.