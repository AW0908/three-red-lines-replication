## Rolle: data (codex, medium) – VERDICT: ESCALATE


## Befunde

[firm-specific excerpt withheld in public audit]

2. **Die schreibgeschützte Entscheidungseingabe ist seit Aufgabenbeginn verändert; die internen Laufprüfungen decken diesen Zeitraum nicht ab.** `review/T041_baseline.sha256:3` weist für `state/STATE.md` den Hash `0d99685f…` aus; die aktuell gelesene Datei hat `f0666db1…`. Das Skript speichert Eingabeprüfsummen erst beim jeweiligen Programmstart und vergleicht sie am Laufende (`14_core_robustness.R:9–11,311–312`). Die Logmeldung „input hashes unchanged“ belegt deshalb nur Unverändertheit innerhalb dieser Läufe. Das Panel selbst ist unverändert. Eine numerische Ergebnisänderung folgt aus der STATE-Abweichung nicht, da deren Inhalt nicht zur Berechnung verwendet wird. Der Aufgabenbeginn betreffende Eingabeschutz ist dennoch verletzt; Zeitpunkt, Inhalt und Verantwortlichkeit der Änderung sind durch die vorliegenden Belege nicht abschließend geklärt.

## Abnahmekriterien

1. **Reproduktionsasserts, unveränderte bestehende Outputs, zwei byteidentische Läufe: teilweise belegt erfüllt.**  
   Die Assertions stehen in `14_core_robustness.R:114–118`; beide Buildlogs berichten **b = 3,142854757615** und **D = 0,114617940199**. `t041_hashes.csv` dokumentiert gleiche Prüfsummen für **183 geschützte Dateien** und **zehn Analyseartefakte über zwei Läufe**. Alle 193 aktuell gelesenen Dateien stimmen mit den dort abgelegten finalen Prüfsummen überein. Frühere Dateiversionen und die Ausführungen selbst wurden nicht erneut hergestellt. Die Unverändertheit sämtlicher Karteneingaben seit Aufgabenbeginn ist wegen Befund 2 **nicht erfüllt**.

2. **Alle vorgegebenen Varianten mit eindeutigen Firmenzahlen: hinsichtlich Datenaufbereitung belegt erfüllt; Variablenbedeutung unter Befund 1 offen.**

   - Das Panel enthält **2.279 Zeilen und 184 Firmen**, die Hauptstichprobe **1.692 Zeilen und 136 Firmen**, ohne doppelte Firmen-Stichtage. Die Hauptstichprobe entspricht `t004_panel_counts.csv:185–188`: 80 A- und 56 HK-Firmen.
   - Die Vorperiode enthält 798 Panelzeilen, davon **797 mit endlichem RL1**; post sind es **630 Beobachtungen aus 132 Firmen**. Keine zusätzliche Treatment-Verfügbarkeitsregel wird angewandt (`14_core_robustness.R:15–24,42–53`).
   - Alle **zwölf Halbjahre** sind enthalten. Die Firmenzahlen und beobachteten Fensterhäufigkeiten in `t041_bunching_by_date.csv` stimmen mit dem Panel überein. **0,66 ist eingeschlossen, 0,70 ausgeschlossen; fehlendes RL1 wird ausgeschlossen.**
   - Alle fünf Querschnitte sind vorhanden: **135/132/130/124/124 Firmen**. Die 999 Zufallsauswahlen berichten jeweils **n = Firmen = 132**; der Code wählt genau einen verfügbaren Post-Stichtag je Firma (`14_core_robustness.R:199–215`).
   - Baseline und alle drei einfacheren Dichtevarianten sind enthalten. Unterschiedliche Anpassungsbereiche werden durch `n_in_range` und `n_outside` ausgewiesen.
   - Die MI-Ankerzuordnung verwendet den eindeutigen Firmen-Stichtag-Schlüssel. Alle **14 verfügbaren Horizontzellen** stimmen hinsichtlich Fallzahlen und mechanischem D mit den gelesenen Panelwerten überein. Post verbleiben **128/124/119/119/112 Firmen**, beim Dezember-2016-Placebo **125/123/123/122/123**, beim Juni-2017-Placebo **122/120/120/120**.
   - Der Drei-Jahres-Horizont nach Juni 2017 fällt außerhalb des erlaubten Placebofensters und bleibt ausdrücklich unverfügbar. Vergleichsstichproben werden nicht stillschweigend auf gemeinsame Firmen beschränkt; beide Zellgrößen und deren Überschneidung stehen in der CSV.
   - Die Frozen-MI-Formel entspricht T029: positive N und E, endliche aktuelle und Anker-MI sowie positiver kontrafaktischer Gesamtnenner. Bei unverändertem MI entspricht das Kontrafaktum der offiziellen Quote; fehlende Anker werden nicht zu null ersetzt. D kann bei sinkendem MI negativ sein.
   - T041 führt keine neuen Imputationen ein. Bestehende fehlende Vorauszahlungen sind in der Hauptstichprobe bei **152 Beobachtungen** als null gespeichert und durch `adv_missing` markiert; dokumentiert in `state/LIMITATIONS.md`, D16.

3. **Bewertung des Überstehens jedes Checks ohne Überbehauptung: nicht meine Rolle.**  
   Die Bewertung von Schätzern, Konfidenzintervallen und Schlussfolgerungen gehört zum Estimation- beziehungsweise Consistency-Review.

## Nicht geprüft

- Keine Analyseskripte, Builds oder Shellbefehle ausgeführt; keine Dateien geändert.
- Keine vollständige erneute Prüfung der ursprünglichen EastMoney-/Wind-Rohdaten und Joins. T041 liest ausschließlich das bestehende Panel.
- Der Kaisa-Befund wurde am lokalen Berichtstext geprüft; dessen Übereinstimmung mit der PDF wurde nicht erneut visuell geprüft. Eine verbindliche Reguliererdefinition wurde nicht festgestellt.
- HK-Währungen und tatsächliche Berichtsstichtage wurden nicht erneut aus Geschäftsberichten validiert. Bestehende Einschränkungen D7 und D11 gelten fort.
- Bootstrap-Inferenz, Regressionen, PDF-Gestaltung und Textinterpretation: nicht meine Rolle.
- Die gemeldeten Änderungen außerhalb des Schreibbereichs sind anhand ihrer Änderungszeiten keinem Verursacher zuzuordnen. Eine vollständige historische Schreibbereichsprüfung ist damit nicht möglich.