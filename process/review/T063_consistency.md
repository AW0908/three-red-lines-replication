## Rolle: consistency (claude, sonnet) – VERDICT: REWORK


## Befunde

[number withheld]. **Schlussfolgerung zu Schritt [number withheld] geht über die Outputs hinaus.** Das Urteil lautet in `t063_interpretation.csv` (step [number withheld]) und in `T063_report.md`, die kalibrierte Simulation mache die beobachtete Form mit Targeting unter Ungenauigkeit „consistent“.
   - **Was die Outputs zeigen:** In `t063_noise.tex` und `t063_noise.csv` (Zeile `parameter_id=[number withheld]`) liegt der beste empirische Mittelwertabgleich bei Mean b [number withheld] (beobachtet [number withheld]) und Mean above [number withheld] (beobachtet [number withheld]). Die Zelle ohne Politik (π=[number withheld]) hat bereits Above [number withheld].
   - **Folge:** Das Rauschen erzeugt also oberhalb von [number withheld] praktisch keinen zusätzlichen Excess. Die zweite empirische „Yes“-Zelle (π=[number withheld]) liegt bei Above [number withheld], also ebenfalls auf dem Ausgangsniveau.
   - **Warum die Zellen als Treffer zählen:** Die „Yes“-Einstufung kommt allein daher, dass [number withheld] im weiten marginalen [number withheld]%-Simulationsbereich liegt ([number withheld] bis [number withheld]).
   - **Kein gemeinsamer Treffer:** Keine empirische Zelle trifft beide Mittelwerte. Zellen mit hohem Above (z. B. π=[number withheld], β=[number withheld], Δ=[number withheld]: Above [number withheld]) verfehlen b ([number withheld]).
   - **Was fehlt:** Die Karte verlangt: „if not, say so“. Der Text hält das Ergebnis offen, statt klar zu sagen, dass kein gemeinsamer Mittelwertabgleich gelingt und der Excess oberhalb nicht durch das Rauschen entsteht. Diese Aussage steht nur im Bericht an Anton, nicht in der Interpretation.
   - **Rest in derselben Passage:** Der Satz „normal grid has [number withheld]“ nennt Zellen mit Above [number withheld]–[number withheld] gegenüber [number withheld] und sagt nicht, dass sie überschießen.
   - **Fix:** Interpretationssatz auf „no cell reproduces both observed means; marginal-range coverage is not a match“ umformulieren. Der Rest der Passage kann bleiben.

[number withheld]. **Geringfügig: Pre/Post-Spalten in den Kontrast-Tabellen.** In `t063_window.tex` und `t063_control_sens.tex` zeigen die Zeilen „D all − C all“ die Entwickler-Pre/Post-Werte, die Spalte „Change“ dagegen den Kontrast (z. B. [number withheld] / [number withheld] / [number withheld]). Das ist in der Fußnote erklärt und stimmt mit den CSVs überein. Es kann beim Lesen irreführen, ist aber kein Zahlenfehler.

## Abnahmekriterien

- **Zahlen aus CSV, TeX und Interpretation (meine Rolle):** belegt erfüllt. Geprüft:
  - **Schritt [number withheld]:** [number withheld] [[number withheld]; [number withheld]], [number withheld] [[number withheld]; [number withheld]] und [number withheld] [[number withheld]; [number withheld]] stimmen mit `t063_window.csv` und `t063_window.tex` überein.
  - **Schritt [number withheld]:** [number withheld] [[number withheld]; [number withheld]], [number withheld] [[number withheld]; [number withheld]], [number withheld] [[number withheld]; [number withheld]] und [number withheld] [[number withheld]; [number withheld]] stimmen mit `t063_control_sens.csv/.tex` überein. Die [number withheld] und [number withheld] Kontrollfirmen stimmen mit dem Bericht überein.
  - **Schritt [number withheld]:** Die Medianwerte und Perzentile stimmen mit `t063_one_obs.csv/.tex` überein. Die Distinct-Firmenzahlen [number withheld]/[number withheld] und [number withheld]/[number withheld] stehen in `t063_distinct_firms.csv`.
  - **Schritt [number withheld], Querprobe:** Die Fensterzahlen in `t063_by_date.csv` summieren sich auf die Werte in `t063_window.csv` (Entwickler [number withheld]/[number withheld], Kontrolle [number withheld]/[number withheld]). Es gibt [number withheld] Daten je Gruppe, also [number withheld] Zeilen.
  - **Schritt [number withheld]:** Alle Reconcile-Zahlen stimmen mit den Kartenvorgaben überein:
[firm-specific excerpt withheld in public process copy]
    - CNKI [number withheld] gegen [number withheld] (`prisma_counts.csv` nennt [number withheld]);
    - CIs [[number withheld]; [number withheld]] gegen [[number withheld]; [number withheld]] sowie [[number withheld]; [number withheld]] gegen [[number withheld]; [number withheld]];
    - Kontroll-Δb [number withheld] gegen [number withheld].
  - **Schritt [number withheld]:** Die „Yes“-Zählung ([number withheld] empirische, [number withheld] normale Zellen) stimmt mit `t063_noise.tex` überein. Die Panel-Titel der Abbildung stimmen mit den Tabellenzeilen überein. Dasselbe gilt für `t063_noise_representatives.csv`. Die Kalibrierungswerte N=[number withheld], Mittelwert [number withheld] und SD [number withheld] stimmen mit `t063_noise_calibration.csv` überein.
  - **Reproduktion:** Δb [number withheld] sowie ΔΔb [number withheld] und [number withheld] stehen in `t063_reproduction.csv` mit `assert_pass=TRUE`.
- **Kriterium [number withheld]** (Asserts, Byte-Identität, Wiederholung): Die Asserts sind in der CSV belegt. Byte-Identität und Zwei-Läufe-Vergleich konnte ich nicht prüfen (siehe unten).
- **Kriterium [number withheld]** (Varianten mit N, Firmen, Fensterbesetzung): belegt erfüllt. Die Spalten `group_*_n`, `_firms` und `_window_obs` stehen in den CSVs.
- **Kriterium [number withheld]** (keine handerhobenen Daten): nicht meine Rolle (Data-Rolle). Die T040-Eingabe ist in Schritt [number withheld] vorgeschrieben.
- **Querverweise und Notation:** Die Fensterbezeichnungen [[number withheld]) und Perioden sind in allen Tabellen konsistent. Die Pre/Post-Zeiträume ([number withheld] und [number withheld] Halbjahre) passen zu `t063_by_date.csv`.

## Nicht geprüft

- Bash wurde verweigert. Byte-Identität, SHA-[number withheld]-Nachweise, Wiederholungslauf und der Code in `22_referee5.R` sind nicht von mir geprüft. Das gehört ohnehin zu den Rollen `data` und `estimation`.
- Die Aufteilung [number withheld] + [number withheld] + [number withheld] der CNKI-Treffer und die Duplikat-ID L1[number withheld] stehen nicht in `prisma_counts.csv` (dort nur [number withheld]). Sie stammen aus `screening.xlsx`, das ich nicht geöffnet habe.
- `t063_bootstrap_draws.csv` und die Draw-Dateien (Zeilenfilter, row_id [number withheld]/[number withheld]) sowie `t063_number_map.csv` habe ich nicht Zelle für Zelle geprüft.
- `t063_by_date.pdf` habe ich nicht angesehen. Von der Datumsabbildung habe ich nur die CSV geprüft.
- `AI_USAGE_LOG.md` enthält noch keinen T063-Eintrag. Der Bericht schlägt ihn erst nach Abnahme vor. Das ist keine Anforderung der Karte.
