## Ergebnis

Das Skript und beide Tabellen mit zehn Hauptanalysen und vier SOE-Interaktionen wurden erzeugt. Grundlage sind ausschließlich Vorpolitik-Daten: [number withheld] Beobachtungen von [number withheld] Firmen. Drei SOE-Interaktionen sind nach dem vorgegebenen Kriterium schwach gepowert.

## Dateien

- `replication/code/t008_power.R` – Placebo-Regressionen, Stichprobenprüfungen und Tabellenexport.
- `replication/outputs/tables/t008_mde.csv` – [number withheld] Zeilen mit SE, beiden Standardabweichungen und allen MDE-Maßen.
- `replication/outputs/tables/t008_mde.tex` – englisches Booktabs-Fragment mit Methodennotiz.

## Ausführung

Befehl, mit finalem Skript zweimal erfolgreich ausgeführt:

[fenced excerpt withheld in public process copy]
[fenced excerpt withheld in public process copy]

Letzte Ausgabe:

[fenced excerpt withheld in public process copy]
[fenced excerpt withheld in public process copy]

## Abnahmekriterien

[number withheld]. **Erfüllt:** CSV und TEX waren zwischen den beiden finalen Läufen byte-identisch. Das LaTeX-Fragment kompiliert mit [number withheld]pt und [number withheld]-Zoll-Rändern ohne übervolle Boxen.
[number withheld]. **Erfüllt:** Assertions vor jeder Regression begrenzen die Daten auf 2016-12-31 bis einschließlich 2020-06-30.
[number withheld]. **Erfüllt:** Unabhängige Prüfung der CSV bestätigt für alle [number withheld] Zeilen exakt `MDE = [number withheld] × SE`, beide SD-Verhältnisse und `[number withheld] × MDE`.
[number withheld]. **Erfüllt:** Beide Tabellen enthalten ausschließlich Präzisions- und MDE-Angaben, keine Placebo-Koeffizienten.
[number withheld]. **Erfüllt:** Pro zusätzlich verletzter Linie muss sich das jeweilige Outcome betragsmäßig mindestens wie folgt ändern, um unter der vorgegebenen Näherung detektierbar zu sein:

   - `rl1`: **[number withheld] Prozentpunkte**.
   - `rl2`: **[number withheld] Prozentpunkte**.
   - `rl2_adj`: **[number withheld] Prozentpunkte**.
   - `rl3`: **[number withheld] Verhältniseinheiten**, entsprechend [number withheld] Prozentpunkten.
   - `rl2_gap`: **[number withheld] Prozentpunkte**.
   - `mi_share`: **[number withheld] Prozentpunkte**.
   - `mi_gap`: **[number withheld] Prozentpunkte**.
   - `jv_ta`: **[number withheld] Prozentpunkte**.
   - `perp_te`: **[number withheld] Prozentpunkte**.
   - `inv_ta`: **[number withheld] Prozentpunkte**.

   Kein Hauptoutcome überschreitet [number withheld] Within-SD. Für den Unterschied der Dosiseffekte zwischen SOEs und privaten Firmen betragen die MDEs:

   - `rl1`: **[number withheld] Prozentpunkte**; [number withheld] Within-SD.
   - `rl2`: **[number withheld] Prozentpunkte**; **schwach gepowert**, [number withheld] Within-SD.
   - `rl2_gap`: **[number withheld] Prozentpunkte**; **schwach gepowert**, [number withheld] Within-SD.
   - `mi_share`: **[number withheld] Prozentpunkte**; **schwach gepowert**, [number withheld] Within-SD.

[number withheld]. **Nicht vollständig nachweisbar:** Meine Änderungen beschränken sich auf die drei freigegebenen Projektdateien. Der projektweite Vorher-Nachher-Vergleich registrierte zusätzlich Änderungen an neun T005-Ausgabedateien und `tasks/T008_worker.log`, die nicht durch meine Schreibbefehle entstanden. Diese Dateien wurden nicht zurückgesetzt.

## Offene Fragen

- Die [number withheld]-Firmen-Stoppregel wurde auf die gesamte Placebo-Stichprobe angewendet: [number withheld] Firmen. Die ausdrücklich verlangten SOE-Analysen umfassen aufgrund bekannter Eigentümerschaft [number withheld]–[number withheld] Firmen; die Hauptanalysen jeweils [number withheld]–[number withheld].
- Beide SDs verwenden die tatsächliche Regressionsstichprobe und den Nenner N−[number withheld]. Die Within-SD entfernt Firmen- und Zeit-Fixed-Effects gemeinsam.
- Die Übertragbarkeit der Vorpolitik-Präzision auf die Politikperiode bleibt eine Planungsannahme. Die MDEs sind keine geschätzten Politikeffekte.
- Vorschlag für den späteren KI-Protokolleintrag durch den Co-PI: „Codex implementierte T008; Wiederholung byte-identisch, CSV-Formeln und LaTeX-Kompilierung geprüft; unabhängiges Review ausstehend.“