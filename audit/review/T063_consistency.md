## Rolle: consistency (claude, sonnet) – VERDICT: REWORK


## Befunde

1. **Schlussfolgerung zu Schritt 1 geht über die Outputs hinaus.** Das Urteil lautet in `t063_interpretation.csv` (step 1) und in `T063_report.md`, die kalibrierte Simulation mache die beobachtete Form mit Targeting unter Ungenauigkeit „consistent“.
   - **Was die Outputs zeigen:** In `t063_noise.tex` und `t063_noise.csv` (Zeile `parameter_id=48`) liegt der beste empirische Mittelwertabgleich bei Mean b 2,627 (beobachtet 3,143) und Mean above 0,857 (beobachtet 1,750). Die Zelle ohne Politik (π=0) hat bereits Above 0,850.
   - **Folge:** Das Rauschen erzeugt also oberhalb von 0,70 praktisch keinen zusätzlichen Excess. Die zweite empirische „Yes“-Zelle (π=0,4) liegt bei Above 0,848, also ebenfalls auf dem Ausgangsniveau.
   - **Warum die Zellen als Treffer zählen:** Die „Yes“-Einstufung kommt allein daher, dass 1,75 im weiten marginalen 95%-Simulationsbereich liegt (−0,04 bis 1,79).
   - **Kein gemeinsamer Treffer:** Keine empirische Zelle trifft beide Mittelwerte. Zellen mit hohem Above (z. B. π=0,4, β=0, Δ=0,10: Above 3,22) verfehlen b (0,88).
   - **Was fehlt:** Die Karte verlangt: „if not, say so“. Der Text hält das Ergebnis offen, statt klar zu sagen, dass kein gemeinsamer Mittelwertabgleich gelingt und der Excess oberhalb nicht durch das Rauschen entsteht. Diese Aussage steht nur im Bericht an Anton, nicht in der Interpretation.
   - **Rest in derselben Passage:** Der Satz „normal grid has 6“ nennt Zellen mit Above 2,3–3,2 gegenüber 1,75 und sagt nicht, dass sie überschießen.
   - **Fix:** Interpretationssatz auf „no cell reproduces both observed means; marginal-range coverage is not a match“ umformulieren. Der Rest der Passage kann bleiben.

2. **Geringfügig: Pre/Post-Spalten in den Kontrast-Tabellen.** In `t063_window.tex` und `t063_control_sens.tex` zeigen die Zeilen „D all − C all“ die Entwickler-Pre/Post-Werte, die Spalte „Change“ dagegen den Kontrast (z. B. −0,676 / 4,103 / 5,379). Das ist in der Fußnote erklärt und stimmt mit den CSVs überein. Es kann beim Lesen irreführen, ist aber kein Zahlenfehler.

## Abnahmekriterien

- **Zahlen aus CSV, TeX und Interpretation (meine Rolle):** belegt erfüllt. Geprüft:
  - **Schritt 2:** 5,379 [2,475; 8,924], 5,134 [1,997; 8,857] und 3,273 [−0,362; 7,724] stimmen mit `t063_window.csv` und `t063_window.tex` überein.
  - **Schritt 3:** 4,589 [2,135; 7,549], 5,520 [2,512; 9,260], 4,561 [1,477; 7,676] und 5,113 [1,578; 8,865] stimmen mit `t063_control_sens.csv/.tex` überein. Die 596 und 156 Kontrollfirmen stimmen mit dem Bericht überein.
  - **Schritt 4:** Die Medianwerte und Perzentile stimmen mit `t063_one_obs.csv/.tex` überein. Die Distinct-Firmenzahlen 35/43 und 96/91 stehen in `t063_distinct_firms.csv`.
  - **Schritt 5, Querprobe:** Die Fensterzahlen in `t063_by_date.csv` summieren sich auf die Werte in `t063_window.csv` (Entwickler 67/118, Kontrolle 207/159). Es gibt 13 Daten je Gruppe, also 26 Zeilen.
  - **Schritt 6:** Alle Reconcile-Zahlen stimmen mit den Kartenvorgaben überein:
[firm-specific excerpt withheld in public audit]
    - CNKI 52 gegen 51 (`prisma_counts.csv` nennt 52);
    - CIs [−0,405; 5,406] gegen [−0,378; 5,297] sowie [1,476; 6,856] gegen [1,628; 6,985];
    - Kontroll-Δb −0,5737 gegen −0,5712.
  - **Schritt 1:** Die „Yes“-Zählung (2 empirische, 6 normale Zellen) stimmt mit `t063_noise.tex` überein. Die Panel-Titel der Abbildung stimmen mit den Tabellenzeilen überein. Dasselbe gilt für `t063_noise_representatives.csv`. Die Kalibrierungswerte N=64, Mittelwert 0,00994 und SD 0,02643 stimmen mit `t063_noise_calibration.csv` überein.
  - **Reproduktion:** Δb 4,0200 sowie ΔΔb 4,5937 und 4,4798 stehen in `t063_reproduction.csv` mit `assert_pass=TRUE`.
- **Kriterium 1** (Asserts, Byte-Identität, Wiederholung): Die Asserts sind in der CSV belegt. Byte-Identität und Zwei-Läufe-Vergleich konnte ich nicht prüfen (siehe unten).
- **Kriterium 2** (Varianten mit N, Firmen, Fensterbesetzung): belegt erfüllt. Die Spalten `group_*_n`, `_firms` und `_window_obs` stehen in den CSVs.
- **Kriterium 3** (keine handerhobenen Daten): nicht meine Rolle (Data-Rolle). Die T040-Eingabe ist in Schritt 1 vorgeschrieben.
- **Querverweise und Notation:** Die Fensterbezeichnungen [0.66,0.74) und Perioden sind in allen Tabellen konsistent. Die Pre/Post-Zeiträume (6 und 5 Halbjahre) passen zu `t063_by_date.csv`.

## Nicht geprüft

- Bash wurde verweigert. Byte-Identität, SHA-256-Nachweise, Wiederholungslauf und der Code in `22_referee5.R` sind nicht von mir geprüft. Das gehört ohnehin zu den Rollen `data` und `estimation`.
- Die Aufteilung 35 + 12 + 5 der CNKI-Treffer und die Duplikat-ID L1207 stehen nicht in `prisma_counts.csv` (dort nur 52). Sie stammen aus `screening.xlsx`, das ich nicht geöffnet habe.
- `t063_bootstrap_draws.csv` und die Draw-Dateien (Zeilenfilter, row_id 253/108) sowie `t063_number_map.csv` habe ich nicht Zelle für Zelle geprüft.
- `t063_by_date.pdf` habe ich nicht angesehen. Von der Datumsabbildung habe ich nur die CSV geprüft.
- `AI_USAGE_LOG.md` enthält noch keinen T063-Eintrag. Der Bericht schlägt ihn erst nach Abnahme vor. Das ist keine Anforderung der Karte.
