## Rolle: data (claude, opus) – VERDICT: PASS


## Befunde

Ich habe keine Fehler in der Datenaufbereitung gefunden. Die folgenden Punkte sind Hinweise für Co-PI und PI, keine Mängel innerhalb der Karte. Der schwerste steht zuerst.

1. **Die Firmen fallen in der Erweiterung nicht zufällig weg. Der Ausfall hängt stark mit der Behandlungsintensität zusammen.** Beleg: `t030_attrition_2023_2024.csv`. Betrachtet sind Firmen der Hauptstichprobe, die 2022H2 berichtet haben. Bis 2024-12-31 fehlen in der Gruppe dose_pre_rounded = 3 acht von 22 Firmen (−36 %). In der Gruppe dose 0 fehlen drei von 29 (−10 %), in der Gruppe dose 1 sechs von 33.
[firm-specific excerpt withheld in public audit]
   - Das Kartenziel „covers the default wave“ wird deshalb nur teilweise erreicht.
   - Die Daten selbst sind korrekt aufbereitet, und das Problem ist offen ausgewiesen. Für T029 (Q2) ist es aber eine Frage der Stichprobenauswahl. Ob die Wind-Exporte für die delisteten A-Aktien über 2022 hinaus verlängert werden, ist neue Datenbeschaffung und damit eine Entscheidung des PI.
2. **Das Erweiterungspanel ist bei den Zeilen ohne Daten nicht symmetrisch aufgebaut.**
   - Bis 2022H2 enthält es nur beobachtete Zeilen; die 2.279 Zeilen haben alle `has_row=TRUE`.
   - Für 2023H1–2024H2 enthält es dagegen das volle Register von 184 × 4 = 736 Zeilen, auch die mit `has_row=FALSE`. Beleg: `01b_extend.R:679`, `:691–696`; zusammen 3.015 Zeilen.
[firm-specific excerpt withheld in public audit]
   - Das ist in `t030_dictionary_addendum.csv` beschrieben und erfüllt Kartenschritt 3. Jeder nachgelagerte Code muss aber auf `has_row == TRUE` filtern. Sonst stimmen Fallzahlen oder Balance-Prüfungen pro Stichtag nicht. Das sollte als Hinweis in die T029-Karte.
3. **Die RL2-Abdeckung bei den HK-Firmen sinkt 2024 deutlich.** Beleg: `t030_coverage.csv`, HK/eastmoney. n_rl2 liegt bei 28/36 (2023H1) und 27/34 (2023H2), dann bei 21/33 (2024H1) und 21/31 (2024H2).
   - Ein Teil erklärt sich durch fehlende Barmittel (`cash`) in den Halbjahresberichten großer HK-Entwickler: 0688, 0884, 0960, 1107, 1777, 3883, 3900 und 1207 (`t030_verification.txt`, Liste „HK EastMoney missing cash“).
   - Dasselbe Muster gibt es schon im Hauptfenster. Es folgt der bestehenden Regel, ohne Ersatzposten.
   - Der Rest geht vermutlich auf `te ≤ 0` zurück: `safe_ratio` setzt RL2 dann auf NA. Das habe ich nicht geprüft. Es wäre ein weiterer Auswahleffekt bei den notleidenden Firmen.
4. **`state/LIMITATIONS.md` enthält noch keinen Eintrag zu T030.** Die Datei liegt außerhalb des Schreibbereichs, also kein Fehler des Workers. Der Co-PI sollte drei Punkte nachtragen:
   - die Wind-only-Lücke nach 2022H2,
   - die NA-Konvention für leere Erweiterungszeilen (adv/perp werden dort nicht imputiert),
   - die nach dose_pre ungleich verteilte Attrition.
5. **Die Prüfung auf neue Posten deckt nur neue Bezeichnungen ab.** Beleg: `01b_extend.R:612–628`. Sie findet keine Verschiebung zwischen schon bekannten HK-Posten, etwa von `现金及等价物` zu `短期存款`. Das entspricht der Stop-Bedingung der Karte und ist daher kein Mangel. Die Lücken bei `cash` in Punkt 3 könnten aber so entstanden sein.
6. **Kleinigkeiten:**
   - `t030_verification.txt` ist eine statische Belegdatei in `outputs/tables/` und wird von keinem Skript erzeugt. So wurde es schon bei T023–T027 gehandhabt.
   - Das SHA-Manifest enthält `outputs/.DS_Store`.

## Datenprüfung im Einzelnen (Data-Rolle)

- **Bereinigungsblock:** `01b_extend.R:24–34` prüft zur Laufzeit, dass der Block zwischen den Markern zeilengleich mit `01_clean.R` ist. Geändert sind nur `target_dates` (17 Stichtage, `:17–18`). Datumszuordnung, Postenzuordnung, Imputation von Vorauszahlungen (adv) und Perpetuals (perp) sowie die Formeln für RL1–RL3, rl2_adj, mi_share, jv_ta und `safe_ratio` (Nenner ≤ 0 → NA) stammen damit nachweislich aus 01.
- **Schlüssel und Merges:**
  - `unique_key` prüft auf jeder Stufe. Im Log gibt es 0 Datums-Kollisionen bei HK und 0 bei Wind.
  - Bei HK haben 1.002 Bilanzschlüssel einen Wert für die Bilanzsumme (ta), 1.002 von 1.002.
  - Am Ende gilt `!anyDuplicated(firm_id, date)`, die Firmenmenge entspricht dem eingefrorenen Hauptpanel (`:699–703`) und die statischen Spalten sind je Firma eindeutig.
- **Überlappung:** `t030_overlap_assert.csv` vergleicht 89 Spalten × 2.279 Zeilen. Fehlende Werte stimmen überall überein, die größte Abweichung ist 0. Der Vergleich läuft dreimal: auf dem neu bereinigten Panel (Statusspalten wie dose und soe nicht überschrieben, also ein echter Test), auf `ext` und auf der veröffentlichten CSV.
- **Firmenkreis:**
  - Keine neuen Firmen: Die Zahl der HK-Bilanzen aus EastMoney sinkt von 38 (2022H2) auf 36, 34, 33 und 31. Die Differenz entspricht genau den Firmen mit `eastmoney_no_report` in `t030_missing_firms.csv`.
  - Die A-Aktien aus EastMoney sind an allen 17 Stichtagen 65/65.
  - Für die Hauptstichprobe gilt n_sample_main = 136 je Stichtag.
- **Wind-only:**
  - Definition: alle Zeilen des Hauptpanels haben `source == "wind"` (`:689–690`).
  - 34 Firmen, davon 28 in der Hauptstichprobe (15 A, 13 HK). Von diesen 28 haben 17 noch 2022H2 berichtet; nachgezählt in `t030_wind_only_firms.csv`.
  - `stopifnot` stellt sicher, dass keine dieser Firmen nach 2022 `has_row=TRUE` hat.
- **Keine Imputation bei leeren Zeilen:** `:684–695`. Alle Finanzfelder und Flags sind NA, die Komponentenzähler 0; geprüft per `stopifnot` und an den Beispielzeilen.
- **Konstruierte Variablen:**
  - dose, dose2018, dose_pre, distance und die Eigentumsvariablen werden per firm_id aus dem Hauptpanel übernommen. Für Erweiterungszeilen gibt es keine Neueinstufung.
  - `post` bleibt die mechanische Regel ≥ 2020-12-31. `post2` gilt ab 2023-06-30.
  - Die Rundung von dose_pre (`floor(x+0.5)`) folgt der Konvention aus T005/T012.
- **Kreuzungen:** Gezählt wird nur zwischen direkt benachbarten Stichtagen; Lücken werden nicht überbrückt (`:747–751`). In der Erweiterung kommen 2/2/1/1 dazu. Die Zahl der Paare je Stichtag passt zu n_rl1 des Vorstichtags.

## Abnahmekriterien

1. **Hauptpanel und Outputs byte-identisch, Überlappungsprüfung bestanden:** belegt erfüllt, soweit die Datenseite betroffen ist.
   - Die Überlappungsprüfung besteht; das zeigen `t030_overlap_assert.csv` und die drei Prüfungen im Code.
   - Der SHA-256-Wert des Hauptpanels ist in Baseline und beiden Läufen gleich (`9b8686…`). Zur Laufzeit von 01b prüft `protected_hash` (`:770`, `:788`) die Rohdaten, das Hauptpanel und die bisherigen Outputs.
   - Die Byte-Gleichheit aller 107 Outputs nach dem vollständigen `run_all` habe ich nur stichprobenhaft am Manifest in `t030_verification.txt` abgeglichen (Baseline gleich Lauf), nicht selbst nachgerechnet.
2. **Zwei Läufe byte-identisch:** nicht meine Rolle. Das Manifest der Läufe 1/2 liegt vor, ich habe es nicht selbst erzeugt.
3. **RL1-Fallzahlen je Stichtag und Wind-only-Firmen:** belegt erfüllt. Die RL1-Zahlen stimmen mit `t030_coverage.csv` überein, summiert über Markt und Quelle: zum Beispiel 2023-06-30 65 + 36 = 101 und 2024-12-31 65 + 31 = 96. Die 17 Wind-only-Firmen aus dem Bericht sind dieselben wie in `t030_missing_firms.csv` mit dem Grund `wind_only_no_export_after_2022h2`.
4. **Keine Schätzungen:** belegt erfüllt für 01b. Der Code enthält nur Zählungen, keine Regressionsaufrufe. Die Bewertung insgesamt ist nicht meine Rolle.

## Nicht geprüft

- **SHA-256-Werte:** Ich habe keine Befehle ausgeführt und deshalb keine Hashwerte selbst berechnet. Die Angaben zu Byte-Gleichheit und Reproduzierbarkeit beruhen auf dem Code (`protected_hash`, `stopifnot`) und dem Manifest des Workers.
- **Ursache der fehlenden RL2-Werte 2024 bei HK:** Wie viele davon auf `te ≤ 0` und wie viele auf fehlende `cash` zurückgehen, habe ich nicht aufgeschlüsselt.
- **Rohdaten:** Ob die EastMoney-Rohdateien für 2023–2024 Restatements oder geänderte Postenbelegungen enthalten, die in den Bezeichnungen nicht sichtbar sind, konnte ich nicht prüfen.
- **Änderung an `state/STATE.md`:** Laut Verifikationsprotokoll stammt sie aus einer parallelen Sitzung. Ob das stimmt, habe ich nicht geprüft; `state/` liegt außerhalb der Datenrolle.
- **Estimation-, Consistency- und Language-Aspekte:** gehören zu den anderen Reviewer-Rollen.
