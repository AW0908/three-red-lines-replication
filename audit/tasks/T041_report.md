## Ergebnis

T041 ist umgesetzt: vier CSV-/TeX-Tabellenpaare, zwei Abbildungen und Reproduzierbarkeitsbelege wurden erzeugt. Der Bunching-Befund übersteht die einfacheren Dichteschätzer und die Beschränkung auf eine Beobachtung je Firma. Ein Anstieg ab 2020H2 ist sichtbar, aber als abrupter Bruch statistisch nicht eindeutig belegt. Die ungewöhnliche MI-Abhängigkeit bestätigt sich gegenüber beiden Placebos bei 1,5–2,5 Jahren, jedoch nicht durchgehend über alle Horizonte.

## Dateien

- `replication/code/14_core_robustness.R` – vollständige Analyse mit Reproduktions- und Schreibschutzprüfungen.
- `replication/run_all.R`, `replication/run_all.sh` – Schritt 14 zuletzt eingebunden.
- `replication/README.md` – Verfahren, Ausführung und Einschränkungen dokumentiert.
- `replication/outputs/tables/t041_bunching_by_date.csv`, `replication/outputs/tables/t041_bunching_by_date.tex` – halbjährliche Verhältnisse zur kontrafaktischen Dichte.
- `replication/outputs/tables/t041_one_per_firm.csv`, `replication/outputs/tables/t041_one_per_firm.tex` – fünf Querschnitte und 999 zufällige Datumsauswahlen.
- `replication/outputs/tables/t041_low_flex.csv`, `replication/outputs/tables/t041_low_flex.tex` – Baseline und drei einfachere Dichteschätzer.
- `replication/outputs/tables/t041_frozen_horizons.csv`, `replication/outputs/tables/t041_frozen_horizons.tex` – gleiche Vergleichshorizonte und gepaarte Differenzen.
- `replication/outputs/figures/t041_bunching_by_date.pdf` – zeitlicher Bunching-Verlauf.
- `replication/outputs/figures/t041_frozen_horizons.pdf` – MI-Abhängigkeit nach Horizont.
- `replication/outputs/tables/t041_build_run1.log`, `replication/outputs/tables/t041_build_run2.log` – Ausführungsprotokolle.
- `replication/outputs/tables/t041_hashes.csv` – Prüfsummenvergleich für 193 Dateien.
- `replication/outputs/tables/t041_verification.txt` – Prüfungen und Ergebnisbewertung.

## Ausführung

Aus `replication/`, zweimal ausgeführt; beide Läufe mit Exitcode 0:

[fenced excerpt withheld in public audit]
[fenced excerpt withheld in public audit]

Letzte Ausgabe:

[fenced excerpt withheld in public audit]
[fenced excerpt withheld in public audit]

## Abnahmekriterien

1. **Erfüllt:** Beide Reproduktionsassertionen bestanden; zehn Analyseartefakte über zwei Läufe bytegleich; 183 bestehende Daten-/Ergebnisdateien unverändert. Beleg: `t041_hashes.csv`.
2. **Erfüllt:** Alle Varianten mit Firmenzahlen ausgewiesen. Enthalten sind zwölf Halbjahre, fünf Querschnitte, 999 Datumsauswahlen, vier Dichteschätzer und 25 Horizont-/Kontrastzeilen. Alle TeX-Fragmente kompilieren fehlerfrei.
3. **Erfüllt:** Differenzierte Bewertung in `t041_verification.txt`:
   - **Timing:** Verhältnis 1,48 bei 2020H2 und 1,57 bei 2021H1; beide Intervalle enthalten noch 1.
   - **Eine Beobachtung je Firma:** 998/999 Zufallsauswahlen positiv; Querschnittsintervalle erst bei 2021H2 und 2022H1 vollständig über null.
   - **Einfachere Dichten:** Alle drei Alternativen positiv, jeweils mit Intervall über null.
   - **MI-Placebos:** Positive Differenzintervalle gegenüber beiden Ankern bei 1,5–2,5 Jahren; nach drei Jahren gegenüber Ende 2016 keine Bestätigung.

## Offene Fragen

Der Drei-Jahres-Horizont des Juni-2017-Placebos liegt außerhalb des freigegebenen Vergleichsfensters und bleibt ausdrücklich unverfügbar. Als dokumentierte Implementierungsentscheidungen wurden beim lokalen linearen Fit Tricube-Gewichte und Bandbreite 0,10 verwendet.

Ein vollständiger `run_all`-Neuaufbau wurde nicht ausgeführt; beide Einstiegsskripte wurden syntaktisch geprüft. Die Ergebnisse bleiben deskriptiv und belegen weder einen kausalen Policy-Effekt noch eine Änderung ökonomischer Verschuldung.

Vorgeschlagener KI-Logeintrag: „2026-10-27, Codex: T041 implementiert; zweimalige Ausführung, direkte numerische Nachrechnungen, TeX-/Grafikprüfung und SHA-256-Vergleiche durchgeführt; Interpretation durch Anton zu prüfen.“ `AI_USAGE_LOG.md` wurde wegen des begrenzten Schreibbereichs nicht geändert.