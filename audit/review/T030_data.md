## Rolle: data (claude, opus) – VERDICT: PASS


## Befunde

Ich habe keine Fehler in der Datenaufbereitung gefunden. Die folgenden Punkte sind Hinweise für Co-PI und PI, keine Mängel innerhalb der Karte. Der schwerste steht zuerst.

[number withheld]. **Die Firmen fallen in der Erweiterung nicht zufällig weg. Der Ausfall hängt stark mit der Behandlungsintensität zusammen.** Beleg: `t030_attrition_2023_2024.csv`. Betrachtet sind Firmen der Hauptstichprobe, die [number withheld]H2 berichtet haben. Bis 2024-12-31 fehlen in der Gruppe dose_pre_rounded = [number withheld] acht von [number withheld] Firmen ([number withheld] %). In der Gruppe dose [number withheld] fehlen drei von [number withheld] ([number withheld] %), in der Gruppe dose [number withheld] sechs von [number withheld].
[firm-specific excerpt withheld in public process copy]
   - Das Kartenziel „covers the default wave“ wird deshalb nur teilweise erreicht.
   - Die Daten selbst sind korrekt aufbereitet, und das Problem ist offen ausgewiesen. Für T029 (Q2) ist es aber eine Frage der Stichprobenauswahl. Ob die Wind-Exporte für die delisteten A-Aktien über [number withheld] hinaus verlängert werden, ist neue Datenbeschaffung und damit eine Entscheidung des PI.
[number withheld]. **Das Erweiterungspanel ist bei den Zeilen ohne Daten nicht symmetrisch aufgebaut.**
   - Bis [number withheld]H2 enthält es nur beobachtete Zeilen; die [number withheld] Zeilen haben alle `has_row=TRUE`.
   - Für [number withheld]H1–[number withheld]H2 enthält es dagegen das volle Register von [number withheld] × [number withheld] = [number withheld] Zeilen, auch die mit `has_row=FALSE`. Beleg: `01b_extend.R:679`, `:[number withheld]–[number withheld]`; zusammen [number withheld] Zeilen.
[firm-specific excerpt withheld in public process copy]
   - Das ist in `t030_dictionary_addendum.csv` beschrieben und erfüllt Kartenschritt [number withheld]. Jeder nachgelagerte Code muss aber auf `has_row == TRUE` filtern. Sonst stimmen Fallzahlen oder Balance-Prüfungen pro Stichtag nicht. Das sollte als Hinweis in die T029-Karte.
[number withheld]. **Die RL2-Abdeckung bei den HK-Firmen sinkt [number withheld] deutlich.** Beleg: `t030_coverage.csv`, HK/eastmoney. n_rl2 liegt bei [number withheld]/[number withheld] ([number withheld]H1) und [number withheld]/[number withheld] ([number withheld]H2), dann bei [number withheld]/[number withheld] ([number withheld]H1) und [number withheld]/[number withheld] ([number withheld]H2).
   - Ein Teil erklärt sich durch fehlende Barmittel (`cash`) in den Halbjahresberichten großer HK-Entwickler: [number withheld], [number withheld], [number withheld], [number withheld], [number withheld], [number withheld], [number withheld] und [number withheld] (`t030_verification.txt`, Liste „HK EastMoney missing cash“).
   - Dasselbe Muster gibt es schon im Hauptfenster. Es folgt der bestehenden Regel, ohne Ersatzposten.
   - Der Rest geht vermutlich auf `te ≤ [number withheld]` zurück: `safe_ratio` setzt RL2 dann auf NA. Das habe ich nicht geprüft. Es wäre ein weiterer Auswahleffekt bei den notleidenden Firmen.
[number withheld]. **`state/LIMITATIONS.md` enthält noch keinen Eintrag zu T030.** Die Datei liegt außerhalb des Schreibbereichs, also kein Fehler des Workers. Der Co-PI sollte drei Punkte nachtragen:
   - die Wind-only-Lücke nach [number withheld]H2,
   - die NA-Konvention für leere Erweiterungszeilen (adv/perp werden dort nicht imputiert),
   - die nach dose_pre ungleich verteilte Attrition.
[number withheld]. **Die Prüfung auf neue Posten deckt nur neue Bezeichnungen ab.** Beleg: `01b_extend.R:612–628`. Sie findet keine Verschiebung zwischen schon bekannten HK-Posten, etwa von `现金及等价物` zu `短期存款`. Das entspricht der Stop-Bedingung der Karte und ist daher kein Mangel. Die Lücken bei `cash` in Punkt [number withheld] könnten aber so entstanden sein.
[number withheld]. **Kleinigkeiten:**
   - `t030_verification.txt` ist eine statische Belegdatei in `outputs/tables/` und wird von keinem Skript erzeugt. So wurde es schon bei T023–T027 gehandhabt.
   - Das SHA-Manifest enthält `outputs/.DS_Store`.

## Datenprüfung im Einzelnen (Data-Rolle)

- **Bereinigungsblock:** `01b_extend.R:24–34` prüft zur Laufzeit, dass der Block zwischen den Markern zeilengleich mit `01_clean.R` ist. Geändert sind nur `target_dates` ([number withheld] Stichtage, `:[number withheld]–[number withheld]`). Datumszuordnung, Postenzuordnung, Imputation von Vorauszahlungen (adv) und Perpetuals (perp) sowie die Formeln für RL1–RL3, rl2_adj, mi_share, jv_ta und `safe_ratio` (Nenner ≤ [number withheld] → NA) stammen damit nachweislich aus [number withheld].
- **Schlüssel und Merges:**
  - `unique_key` prüft auf jeder Stufe. Im Log gibt es [number withheld] Datums-Kollisionen bei HK und [number withheld] bei Wind.
  - Bei HK haben [number withheld] Bilanzschlüssel einen Wert für die Bilanzsumme (ta), [number withheld] von [number withheld].
  - Am Ende gilt `!anyDuplicated(firm_id, date)`, die Firmenmenge entspricht dem eingefrorenen Hauptpanel (`:[number withheld]–[number withheld]`) und die statischen Spalten sind je Firma eindeutig.
- **Überlappung:** `t030_overlap_assert.csv` vergleicht [number withheld] Spalten × [number withheld] Zeilen. Fehlende Werte stimmen überall überein, die größte Abweichung ist [number withheld]. Der Vergleich läuft dreimal: auf dem neu bereinigten Panel (Statusspalten wie dose und soe nicht überschrieben, also ein echter Test), auf `ext` und auf der veröffentlichten CSV.
- **Firmenkreis:**
  - Keine neuen Firmen: Die Zahl der HK-Bilanzen aus EastMoney sinkt von [number withheld] ([number withheld]H2) auf [number withheld], [number withheld], [number withheld] und [number withheld]. Die Differenz entspricht genau den Firmen mit `eastmoney_no_report` in `t030_missing_firms.csv`.
  - Die A-Aktien aus EastMoney sind an allen [number withheld] Stichtagen [number withheld]/[number withheld].
  - Für die Hauptstichprobe gilt n_sample_main = [number withheld] je Stichtag.
- **Wind-only:**
  - Definition: alle Zeilen des Hauptpanels haben `source == "wind"` (`:[number withheld]–[number withheld]`).
  - [number withheld] Firmen, davon [number withheld] in der Hauptstichprobe ([number withheld] A, [number withheld] HK). Von diesen [number withheld] haben [number withheld] noch [number withheld]H2 berichtet; nachgezählt in `t030_wind_only_firms.csv`.
  - `stopifnot` stellt sicher, dass keine dieser Firmen nach [number withheld] `has_row=TRUE` hat.
- **Keine Imputation bei leeren Zeilen:** `:[number withheld]–[number withheld]`. Alle Finanzfelder und Flags sind NA, die Komponentenzähler [number withheld]; geprüft per `stopifnot` und an den Beispielzeilen.
- **Konstruierte Variablen:**
  - dose, dose2[number withheld], dose_pre, distance und die Eigentumsvariablen werden per firm_id aus dem Hauptpanel übernommen. Für Erweiterungszeilen gibt es keine Neueinstufung.
  - `post` bleibt die mechanische Regel ≥ 2020-12-31. `post2` gilt ab 2023-06-30.
  - Die Rundung von dose_pre (`floor(x+[number withheld])`) folgt der Konvention aus T005/T012.
- **Kreuzungen:** Gezählt wird nur zwischen direkt benachbarten Stichtagen; Lücken werden nicht überbrückt (`:[number withheld]–[number withheld]`). In der Erweiterung kommen [number withheld]/[number withheld]/[number withheld]/[number withheld] dazu. Die Zahl der Paare je Stichtag passt zu n_rl1 des Vorstichtags.

## Abnahmekriterien

[number withheld]. **Hauptpanel und Outputs byte-identisch, Überlappungsprüfung bestanden:** belegt erfüllt, soweit die Datenseite betroffen ist.
   - Die Überlappungsprüfung besteht; das zeigen `t030_overlap_assert.csv` und die drei Prüfungen im Code.
   - Der SHA-[number withheld]-Wert des Hauptpanels ist in Baseline und beiden Läufen gleich (`[number withheld]b8[number withheld]…`). Zur Laufzeit von [number withheld]b prüft `protected_hash` (`:[number withheld]`, `:[number withheld]`) die Rohdaten, das Hauptpanel und die bisherigen Outputs.
   - Die Byte-Gleichheit aller [number withheld] Outputs nach dem vollständigen `run_all` habe ich nur stichprobenhaft am Manifest in `t030_verification.txt` abgeglichen (Baseline gleich Lauf), nicht selbst nachgerechnet.
[number withheld]. **Zwei Läufe byte-identisch:** nicht meine Rolle. Das Manifest der Läufe [number withheld]/[number withheld] liegt vor, ich habe es nicht selbst erzeugt.
[number withheld]. **RL1-Fallzahlen je Stichtag und Wind-only-Firmen:** belegt erfüllt. Die RL1-Zahlen stimmen mit `t030_coverage.csv` überein, summiert über Markt und Quelle: zum Beispiel 2023-06-30 [number withheld] + [number withheld] = [number withheld] und 2024-12-31 [number withheld] + [number withheld] = [number withheld]. Die [number withheld] Wind-only-Firmen aus dem Bericht sind dieselben wie in `t030_missing_firms.csv` mit dem Grund `wind_only_no_export_after_2[number withheld]h2`.
[number withheld]. **Keine Schätzungen:** belegt erfüllt für [number withheld]b. Der Code enthält nur Zählungen, keine Regressionsaufrufe. Die Bewertung insgesamt ist nicht meine Rolle.

## Nicht geprüft

- **SHA-[number withheld]-Werte:** Ich habe keine Befehle ausgeführt und deshalb keine Hashwerte selbst berechnet. Die Angaben zu Byte-Gleichheit und Reproduzierbarkeit beruhen auf dem Code (`protected_hash`, `stopifnot`) und dem Manifest des Workers.
- **Ursache der fehlenden RL2-Werte [number withheld] bei HK:** Wie viele davon auf `te ≤ [number withheld]` und wie viele auf fehlende `cash` zurückgehen, habe ich nicht aufgeschlüsselt.
- **Rohdaten:** Ob die EastMoney-Rohdateien für [number withheld]–[number withheld] Restatements oder geänderte Postenbelegungen enthalten, die in den Bezeichnungen nicht sichtbar sind, konnte ich nicht prüfen.
- **Änderung an `state/STATE.md`:** Laut Verifikationsprotokoll stammt sie aus einer parallelen Sitzung. Ob das stimmt, habe ich nicht geprüft; `state/` liegt außerhalb der Datenrolle.
- **Estimation-, Consistency- und Language-Aspekte:** gehören zu den anderen Reviewer-Rollen.
