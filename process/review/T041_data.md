## Rolle: data (codex, medium) – VERDICT: ESCALATE


## Befunde

[firm-specific excerpt withheld in public process copy]

[number withheld]. **Die schreibgeschützte Entscheidungseingabe ist seit Aufgabenbeginn verändert; die internen Laufprüfungen decken diesen Zeitraum nicht ab.** `review/T041_baseline.sha256:3` weist für `state/STATE.md` den Hash `[number withheld]d9[number withheld]f…` aus; die aktuell gelesene Datei hat `f0[number withheld]db1…`. Das Skript speichert Eingabeprüfsummen erst beim jeweiligen Programmstart und vergleicht sie am Laufende (`[number withheld]_core_robustness.R:[number withheld]–[number withheld]–[number withheld]`). Die Logmeldung „input hashes unchanged“ belegt deshalb nur Unverändertheit innerhalb dieser Läufe. Das Panel selbst ist unverändert. Eine numerische Ergebnisänderung folgt aus der STATE-Abweichung nicht, da deren Inhalt nicht zur Berechnung verwendet wird. Der Aufgabenbeginn betreffende Eingabeschutz ist dennoch verletzt; Zeitpunkt, Inhalt und Verantwortlichkeit der Änderung sind durch die vorliegenden Belege nicht abschließend geklärt.

## Abnahmekriterien

[number withheld]. **Reproduktionsasserts, unveränderte bestehende Outputs, zwei byteidentische Läufe: teilweise belegt erfüllt.**  
   Die Assertions stehen in `14_core_robustness.R:114–118`; beide Buildlogs berichten **b = [number withheld]** und **D = [number withheld]**. `t041_hashes.csv` dokumentiert gleiche Prüfsummen für **[number withheld] geschützte Dateien** und **zehn Analyseartefakte über zwei Läufe**. Alle [number withheld] aktuell gelesenen Dateien stimmen mit den dort abgelegten finalen Prüfsummen überein. Frühere Dateiversionen und die Ausführungen selbst wurden nicht erneut hergestellt. Die Unverändertheit sämtlicher Karteneingaben seit Aufgabenbeginn ist wegen Befund [number withheld] **nicht erfüllt**.

[number withheld]. **Alle vorgegebenen Varianten mit eindeutigen Firmenzahlen: hinsichtlich Datenaufbereitung belegt erfüllt; Variablenbedeutung unter Befund [number withheld] offen.**

   - Das Panel enthält **[number withheld] Zeilen und [number withheld] Firmen**, die Hauptstichprobe **[number withheld] Zeilen und [number withheld] Firmen**, ohne doppelte Firmen-Stichtage. Die Hauptstichprobe entspricht `t004_panel_counts.csv:185–188`: [number withheld] A- und [number withheld] HK-Firmen.
   - Die Vorperiode enthält [number withheld] Panelzeilen, davon **[number withheld] mit endlichem RL1**; post sind es **[number withheld] Beobachtungen aus [number withheld] Firmen**. Keine zusätzliche Treatment-Verfügbarkeitsregel wird angewandt (`[number withheld]_core_robustness.R:[number withheld]–[number withheld]–[number withheld]`).
   - Alle **zwölf Halbjahre** sind enthalten. Die Firmenzahlen und beobachteten Fensterhäufigkeiten in `t041_bunching_by_date.csv` stimmen mit dem Panel überein. **[number withheld] ist eingeschlossen, [number withheld] ausgeschlossen; fehlendes RL1 wird ausgeschlossen.**
   - Alle fünf Querschnitte sind vorhanden: **[number withheld]/[number withheld]/[number withheld]/[number withheld]/[number withheld] Firmen**. Die [number withheld] Zufallsauswahlen berichten jeweils **n = Firmen = [number withheld]**; der Code wählt genau einen verfügbaren Post-Stichtag je Firma (`14_core_robustness.R:199–215`).
   - Baseline und alle drei einfacheren Dichtevarianten sind enthalten. Unterschiedliche Anpassungsbereiche werden durch `n_in_range` und `n_outside` ausgewiesen.
   - Die MI-Ankerzuordnung verwendet den eindeutigen Firmen-Stichtag-Schlüssel. Alle **[number withheld] verfügbaren Horizontzellen** stimmen hinsichtlich Fallzahlen und mechanischem D mit den gelesenen Panelwerten überein. Post verbleiben **[number withheld]/[number withheld]/[number withheld]/[number withheld]/[number withheld] Firmen**, beim Dezember-[number withheld]-Placebo **[number withheld]/[number withheld]/[number withheld]/[number withheld]/[number withheld]**, beim Juni-[number withheld]-Placebo **[number withheld]/[number withheld]/[number withheld]/[number withheld]**.
   - Der Drei-Jahres-Horizont nach Juni [number withheld] fällt außerhalb des erlaubten Placebofensters und bleibt ausdrücklich unverfügbar. Vergleichsstichproben werden nicht stillschweigend auf gemeinsame Firmen beschränkt; beide Zellgrößen und deren Überschneidung stehen in der CSV.
   - Die Frozen-MI-Formel entspricht T029: positive N und E, endliche aktuelle und Anker-MI sowie positiver kontrafaktischer Gesamtnenner. Bei unverändertem MI entspricht das Kontrafaktum der offiziellen Quote; fehlende Anker werden nicht zu null ersetzt. D kann bei sinkendem MI negativ sein.
   - T041 führt keine neuen Imputationen ein. Bestehende fehlende Vorauszahlungen sind in der Hauptstichprobe bei **[number withheld] Beobachtungen** als null gespeichert und durch `adv_missing` markiert; dokumentiert in `state/LIMITATIONS.md`, D1[number withheld].

[number withheld]. **Bewertung des Überstehens jedes Checks ohne Überbehauptung: nicht meine Rolle.**  
   Die Bewertung von Schätzern, Konfidenzintervallen und Schlussfolgerungen gehört zum Estimation- beziehungsweise Consistency-Review.

## Nicht geprüft

- Keine Analyseskripte, Builds oder Shellbefehle ausgeführt; keine Dateien geändert.
- Keine vollständige erneute Prüfung der ursprünglichen EastMoney-/Wind-Rohdaten und Joins. T041 liest ausschließlich das bestehende Panel.
- Der Kaisa-Befund wurde am lokalen Berichtstext geprüft; dessen Übereinstimmung mit der PDF wurde nicht erneut visuell geprüft. Eine verbindliche Reguliererdefinition wurde nicht festgestellt.
- HK-Währungen und tatsächliche Berichtsstichtage wurden nicht erneut aus Geschäftsberichten validiert. Bestehende Einschränkungen D7 und D1[number withheld] gelten fort.
- Bootstrap-Inferenz, Regressionen, PDF-Gestaltung und Textinterpretation: nicht meine Rolle.
- Die gemeldeten Änderungen außerhalb des Schreibbereichs sind anhand ihrer Änderungszeiten keinem Verursacher zuzuordnen. Eine vollständige historische Schreibbereichsprüfung ist damit nicht möglich.