## Rolle: data (claude, opus) – VERDICT: PASS


## Befunde

1. **Leicht – Imputation nicht in `state/LIMITATIONS.md` dokumentiert (Aufgabe für den Co-PI, kein Fehler des Workers).** In den Selektionsmodellen wird ein fehlendes Vorperiodenmittel auf 0 gesetzt und mit `pre_mean_missing` markiert (`09_selection.R:85–86`). Das betrifft 2 Firmen bei mi_share und 22 bei jv_ta (`t025_missing_predictors.csv`). Außerdem ersetzt `reported_2020h1` den Börsenstatus. Beides ist in der Audit-Datei (`t025_selection_audit.csv`, Spalte `pre_mean_missing`) und in der TEX-Note offengelegt. In `state/LIMITATIONS.md` gibt es dazu aber keinen Eintrag; nur D23 verweist allgemein auf „Attrition in T025“. `state/` liegt außerhalb des Schreibbereichs, deshalb sollte der Co-PI den Eintrag nachtragen.

2. **Leicht – die Lee-Selektion „≥ 1 Post-Beobachtung“ verdeckt einen Großteil der Attrition, um die es auf der Karte geht.** Die Karte begründet die Prüfung mit 6/28 gegenüber 2/31 fehlenden RL1-Werten in 2022H2. Das bestätigt `t025_attrition.csv:63,66`: Dosisgruppe 3 hat 22/28 beobachtet, Dosisgruppe 0 hat 29/31. Lee zählt eine Firma aber schon als beobachtet, wenn sie mindestens einen Post-Wert hat (`09_selection.R:275,279`). Die Beobachtungsquoten liegen deshalb bei 0,953 gegenüber 0,980, und getrimmt werden nur 2,7 % (`t025_lee_bounds.csv:2`). Firmen, die spät ausfallen, gehen nur mit ihren frühen Post-Werten ein. Das ist offengelegt (Lee-Note „Unequal reporting horizons remain“; Worker-Bericht, offene Fragen). Die Karte lässt diese Wahl zu. Bei der Interpretation sollte man aber wissen, dass die Lee-Bounds deshalb eng ausfallen.

3. **Hinweis – Änderungszeiten passen nicht zur Aussage des Workers.** Laut `t025_verification.txt:5` wurden die Nicht-T025-Outputs nie im Projektordner neu erzeugt. Die Prüfung nach Änderungszeit zeigt aber neu geschriebene Dateien t008–t027 in `replication/outputs/` und gleichzeitig Änderungen in `presentation/slides/`. Das deutet eher auf eine parallele Sitzung hin. Ich kann nur lesen und daher keine Prüfsummen berechnen. Ob die Dateien byte-identisch sind (Manifest in `t025_verification.txt:147–230`), muss der Co-PI mit SHA-256 abgleichen. Das betrifft nicht die Datenaufbereitung.

4. **Hinweis – `state/STATE.md` hat sich während der Ausführung geändert.** Das hat das Skript gemeldet. Die Datei enthält keine Daten, die in die Rechnung eingehen. Für die Datenaufbereitung ist das ohne Folgen.

## Prüfung der Datenaufbereitung

- **Rohdaten → Risikomenge:** Gelesen wird `panel_firm_halfyear.csv`, gefiltert auf `sample_main` und `!is.na(dose_pre)`. Es gibt keine doppelten Schlüssel (firm_id, date), es sind genau 124 Firmen, die Daten liegen im 13-Stichtage-Raster, und `post` beginnt mit 2020-12-31 (`09_selection.R:23–26`). Das Panel enthält nur echte Quellzeilen (`has_row` ist laut `01_clean.R:697` immer TRUE). Das volle Raster `g` mit 124 × 13 = 1612 Zeilen wird per `match` aufgefüllt, fehlende Zeilen werden zu NA, also s = 0 (`09_selection.R:68–75`). Die Attritionszahlen stimmen mit der Karte überein (6/28 und 2/31 für 2022H2).
- **Firmenmerkmale:** dose_pre und market sind je Firma konstant (Assert `:59`). Vorperiode heißt `date <= 2019-12-31`, das sind 7 Stichtage; 2020H1 gehört nicht dazu. Z = Anteil der Stichtage mit nicht-fehlendem `ta` / 7. Fehlende Zeilen zählen korrekt als 0. Z < 1 gilt für 7 Firmen (`t025_first_stage_diagnostics.csv`), Z variiert also (Assert `:75`). `pre_log_ta` ist für alle Firmen endlich (Assert `:88`). Dass log-Assets über die Märkte hinweg in unterschiedlichen Währungen stehen können, nennt die Note.
- **Merge:** `merge(g, f, by = "firm_id")` mit `f` eindeutig je Firma (über die IDs gebaut). Die Zeilenzahl 1612 wird danach geprüft (`:75`).
- **Dosisgruppen:** `floor(dose_pre + 0.5)` mit dose_pre ∈ [0, 3] (Assert in `04_robustness.R:51`) ergibt die Gruppen 0–3. Für 2017-12-31 summieren sie sich auf 124 (31 + 37 + 28 + 28).
[firm-specific excerpt withheld in public audit]
[firm-specific excerpt withheld in public audit]
- **S6:** Die Definition (`balanced = all(dates %in% d$date[d$has_row])`) entspricht `04_robustness.R:40`. Koeffizienten, N und Firmenzahlen in `t025_selection.csv` stimmen mit `t011_robustness.csv:32–36` überein, z. B. rl1 −0,0097727 bei N = 1352 und 104 Firmen.
- **Lee-Daten:** Gruppen: high bei dose_pre ≥ 2, low bei < 1, sonst middle; 43 + 51 + 30 = 124 bei rl1. Die Veränderung ist das verfügbare Post-Mittel minus das verfügbare Vorperioden-Mittel. Firmen ohne Vorperiodenmittel werden ausgeschlossen und gezählt (`excluded_no_pre_*`). Die Bootstrap-Indizes `ii` beziehen sich bei `g` und bei `lee_data` auf dieselbe Reihenfolge der IDs (`:320, :336`).

## Abnahmekriterien

1. Baseline = T009 auf 1e-12 genau: **belegt erfüllt**, soweit es die Daten betrifft. Die Stichprobe ist identisch mit `02_estimate.R`/T009 (Filter `:23`, Assert `:46`, maximale Abweichung 2,2e-15 laut `t025_baseline_validation.csv`). Den Schätzcode bewertet nicht meine Rolle.
2. Erste Stufe und Z berichtet, Seed gesetzt, zwei Läufe identisch: die Konstruktion von Z ist **belegt korrekt** (Variation vorhanden, 7 Firmen mit Z < 1). Die byte-identischen Läufe kann ich nicht prüfen (siehe unten). Die Schätzung der ersten Stufe gehört nicht zu meiner Rolle.
3. Bestehende Outputs byte-identisch: **nicht prüfbar** für mich, siehe Befund 3. Nicht meine Rolle.
4. Interpretation, wie stark β sich verschiebt: nicht meine Rolle.

## Nicht geprüft

- Prüfsummen und byte-identische Läufe: Ich darf keine Befehle ausführen, deshalb habe ich keine SHA-256 berechnet. Ich habe nur das Manifest des Workers gelesen.
[firm-specific excerpt withheld in public audit]
- Upstream-Definitionen aus `01_clean.R`, z. B. ob ein fehlendes jv „kein JV“ oder „nicht berichtet“ bedeutet und welche Währung `ta` hat: nicht Teil dieser Karte.
- Ob `run_all.R`/`run_all.sh` korrekt registriert sind und ob das README stimmt: nicht meine Rolle.
