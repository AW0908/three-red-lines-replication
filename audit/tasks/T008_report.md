## Ergebnis

Das Skript und beide Tabellen mit zehn Hauptanalysen und vier SOE-Interaktionen wurden erzeugt. Grundlage sind ausschließlich Vorpolitik-Daten: 986 Beobachtungen von 126 Firmen. Drei SOE-Interaktionen sind nach dem vorgegebenen Kriterium schwach gepowert.

## Dateien

- `replication/code/t008_power.R` – Placebo-Regressionen, Stichprobenprüfungen und Tabellenexport.
- `replication/outputs/tables/t008_mde.csv` – 14 Zeilen mit SE, beiden Standardabweichungen und allen MDE-Maßen.
- `replication/outputs/tables/t008_mde.tex` – englisches Booktabs-Fragment mit Methodennotiz.

## Ausführung

Befehl, mit finalem Skript zweimal erfolgreich ausgeführt:

[fenced excerpt withheld in public audit]
[fenced excerpt withheld in public audit]

Letzte Ausgabe:

[fenced excerpt withheld in public audit]
[fenced excerpt withheld in public audit]

## Abnahmekriterien

1. **Erfüllt:** CSV und TEX waren zwischen den beiden finalen Läufen byte-identisch. Das LaTeX-Fragment kompiliert mit 12pt und 1-Zoll-Rändern ohne übervolle Boxen.
2. **Erfüllt:** Assertions vor jeder Regression begrenzen die Daten auf 2016-12-31 bis einschließlich 2020-06-30.
3. **Erfüllt:** Unabhängige Prüfung der CSV bestätigt für alle 14 Zeilen exakt `MDE = 2.8 × SE`, beide SD-Verhältnisse und `3 × MDE`.
4. **Erfüllt:** Beide Tabellen enthalten ausschließlich Präzisions- und MDE-Angaben, keine Placebo-Koeffizienten.
5. **Erfüllt:** Pro zusätzlich verletzter Linie muss sich das jeweilige Outcome betragsmäßig mindestens wie folgt ändern, um unter der vorgegebenen Näherung detektierbar zu sein:

   - `rl1`: **2,044 Prozentpunkte**.
   - `rl2`: **35,117 Prozentpunkte**.
   - `rl2_adj`: **35,255 Prozentpunkte**.
   - `rl3`: **7,515 Verhältniseinheiten**, entsprechend 751,501 Prozentpunkten.
   - `rl2_gap`: **3,595 Prozentpunkte**.
   - `mi_share`: **1,771 Prozentpunkte**.
   - `mi_gap`: **22,592 Prozentpunkte**.
   - `jv_ta`: **1,051 Prozentpunkte**.
   - `perp_te`: **0,877 Prozentpunkte**.
   - `inv_ta`: **2,071 Prozentpunkte**.

   Kein Hauptoutcome überschreitet 0,5 Within-SD. Für den Unterschied der Dosiseffekte zwischen SOEs und privaten Firmen betragen die MDEs:

   - `rl1`: **1,499 Prozentpunkte**; 0,254 Within-SD.
   - `rl2`: **23,450 Prozentpunkte**; **schwach gepowert**, 0,631 Within-SD.
   - `rl2_gap`: **8,221 Prozentpunkte**; **schwach gepowert**, 0,723 Within-SD.
   - `mi_share`: **3,175 Prozentpunkte**; **schwach gepowert**, 0,632 Within-SD.

6. **Nicht vollständig nachweisbar:** Meine Änderungen beschränken sich auf die drei freigegebenen Projektdateien. Der projektweite Vorher-Nachher-Vergleich registrierte zusätzlich Änderungen an neun T005-Ausgabedateien und `tasks/T008_worker.log`, die nicht durch meine Schreibbefehle entstanden. Diese Dateien wurden nicht zurückgesetzt.

## Offene Fragen

- Die 100-Firmen-Stoppregel wurde auf die gesamte Placebo-Stichprobe angewendet: 126 Firmen. Die ausdrücklich verlangten SOE-Analysen umfassen aufgrund bekannter Eigentümerschaft 86–87 Firmen; die Hauptanalysen jeweils 103–126.
- Beide SDs verwenden die tatsächliche Regressionsstichprobe und den Nenner N−1. Die Within-SD entfernt Firmen- und Zeit-Fixed-Effects gemeinsam.
- Die Übertragbarkeit der Vorpolitik-Präzision auf die Politikperiode bleibt eine Planungsannahme. Die MDEs sind keine geschätzten Politikeffekte.
- Vorschlag für den späteren KI-Protokolleintrag durch den Co-PI: „Codex implementierte T008; Wiederholung byte-identisch, CSV-Formeln und LaTeX-Kompilierung geprüft; unabhängiges Review ausstehend.“