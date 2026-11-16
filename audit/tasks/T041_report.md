## Ergebnis

T041 ist umgesetzt: vier CSV-/TeX-Tabellenpaare, zwei Abbildungen und Reproduzierbarkeitsbelege wurden erzeugt. Der Bunching-Befund übersteht die einfacheren Dichteschätzer und die Beschränkung auf eine Beobachtung je Firma. Ein Anstieg ab [number withheld]H2 ist sichtbar, aber als abrupter Bruch statistisch nicht eindeutig belegt. Die ungewöhnliche MI-Abhängigkeit bestätigt sich gegenüber beiden Placebos bei [number withheld]–[number withheld] Jahren, jedoch nicht durchgehend über alle Horizonte.

## Dateien

- `replication/code/14_core_robustness.R` – vollständige Analyse mit Reproduktions- und Schreibschutzprüfungen.
- `replication/run_all.R`, `replication/run_all.sh` – Schritt [number withheld] zuletzt eingebunden.
- `replication/README.md` – Verfahren, Ausführung und Einschränkungen dokumentiert.
- `replication/outputs/tables/t041_bunching_by_date.csv`, `replication/outputs/tables/t041_bunching_by_date.tex` – halbjährliche Verhältnisse zur kontrafaktischen Dichte.
- `replication/outputs/tables/t041_one_per_firm.csv`, `replication/outputs/tables/t041_one_per_firm.tex` – fünf Querschnitte und [number withheld] zufällige Datumsauswahlen.
- `replication/outputs/tables/t041_low_flex.csv`, `replication/outputs/tables/t041_low_flex.tex` – Baseline und drei einfachere Dichteschätzer.
- `replication/outputs/tables/t041_frozen_horizons.csv`, `replication/outputs/tables/t041_frozen_horizons.tex` – gleiche Vergleichshorizonte und gepaarte Differenzen.
- `replication/outputs/figures/t041_bunching_by_date.pdf` – zeitlicher Bunching-Verlauf.
- `replication/outputs/figures/t041_frozen_horizons.pdf` – MI-Abhängigkeit nach Horizont.
- `replication/outputs/tables/t041_build_run1.log`, `replication/outputs/tables/t041_build_run2.log` – Ausführungsprotokolle.
- `replication/outputs/tables/t041_hashes.csv` – Prüfsummenvergleich für [number withheld] Dateien.
- `replication/outputs/tables/t041_verification.txt` – Prüfungen und Ergebnisbewertung.

## Ausführung

Aus `replication/`, zweimal ausgeführt; beide Läufe mit Exitcode [number withheld]:

[fenced excerpt withheld in public process copy]
[fenced excerpt withheld in public process copy]

Letzte Ausgabe:

[fenced excerpt withheld in public process copy]
[fenced excerpt withheld in public process copy]

## Abnahmekriterien

[number withheld]. **Erfüllt:** Beide Reproduktionsassertionen bestanden; zehn Analyseartefakte über zwei Läufe bytegleich; [number withheld] bestehende Daten-/Ergebnisdateien unverändert. Beleg: `t041_hashes.csv`.
[number withheld]. **Erfüllt:** Alle Varianten mit Firmenzahlen ausgewiesen. Enthalten sind zwölf Halbjahre, fünf Querschnitte, [number withheld] Datumsauswahlen, vier Dichteschätzer und [number withheld] Horizont-/Kontrastzeilen. Alle TeX-Fragmente kompilieren fehlerfrei.
[number withheld]. **Erfüllt:** Differenzierte Bewertung in `t041_verification.txt`:
   - **Timing:** Verhältnis [number withheld] bei [number withheld]H2 und [number withheld] bei [number withheld]H1; beide Intervalle enthalten noch [number withheld].
   - **Eine Beobachtung je Firma:** [number withheld]/[number withheld] Zufallsauswahlen positiv; Querschnittsintervalle erst bei [number withheld]H2 und [number withheld]H1 vollständig über null.
   - **Einfachere Dichten:** Alle drei Alternativen positiv, jeweils mit Intervall über null.
   - **MI-Placebos:** Positive Differenzintervalle gegenüber beiden Ankern bei [number withheld]–[number withheld] Jahren; nach drei Jahren gegenüber Ende [number withheld] keine Bestätigung.

## Offene Fragen

Der Drei-Jahres-Horizont des Juni-[number withheld]-Placebos liegt außerhalb des freigegebenen Vergleichsfensters und bleibt ausdrücklich unverfügbar. Als dokumentierte Implementierungsentscheidungen wurden beim lokalen linearen Fit Tricube-Gewichte und Bandbreite [number withheld] verwendet.

Ein vollständiger `run_all`-Neuaufbau wurde nicht ausgeführt; beide Einstiegsskripte wurden syntaktisch geprüft. Die Ergebnisse bleiben deskriptiv und belegen weder einen kausalen Policy-Effekt noch eine Änderung ökonomischer Verschuldung.

Vorgeschlagener KI-Logeintrag: „2026-10-27, Codex: T041 implementiert; zweimalige Ausführung, direkte numerische Nachrechnungen, TeX-/Grafikprüfung und SHA-[number withheld]-Vergleiche durchgeführt; Interpretation durch Anton zu prüfen.“ `AI_USAGE_LOG.md` wurde wegen des begrenzten Schreibbereichs nicht geändert.