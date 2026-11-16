## Rolle: data (claude, opus) – VERDICT: PASS


## Befunde

[number withheld]. **Leicht – Imputation nicht in `state/LIMITATIONS.md` dokumentiert (Aufgabe für den Co-PI, kein Fehler des Workers).** In den Selektionsmodellen wird ein fehlendes Vorperiodenmittel auf [number withheld] gesetzt und mit `pre_mean_missing` markiert (`09_selection.R:85–86`). Das betrifft [number withheld] Firmen bei mi_share und [number withheld] bei jv_ta (`t025_missing_predictors.csv`). Außerdem ersetzt `reported_2[number withheld]h1` den Börsenstatus. Beides ist in der Audit-Datei (`t025_selection_audit.csv`, Spalte `pre_mean_missing`) und in der TEX-Note offengelegt. In `state/LIMITATIONS.md` gibt es dazu aber keinen Eintrag; nur D2[number withheld] verweist allgemein auf „Attrition in T025“. `state/` liegt außerhalb des Schreibbereichs, deshalb sollte der Co-PI den Eintrag nachtragen.

[number withheld]. **Leicht – die Lee-Selektion „≥ [number withheld] Post-Beobachtung“ verdeckt einen Großteil der Attrition, um die es auf der Karte geht.** Die Karte begründet die Prüfung mit [number withheld]/[number withheld] gegenüber [number withheld]/[number withheld] fehlenden RL1-Werten in [number withheld]H2. Das bestätigt `t0[number withheld]_attrition.csv:[number withheld]`: Dosisgruppe [number withheld] hat [number withheld]/[number withheld] beobachtet, Dosisgruppe [number withheld] hat [number withheld]/[number withheld]. Lee zählt eine Firma aber schon als beobachtet, wenn sie mindestens einen Post-Wert hat (`[number withheld]_selection.R:[number withheld]`). Die Beobachtungsquoten liegen deshalb bei [number withheld] gegenüber [number withheld], und getrimmt werden nur [number withheld] % (`t025_lee_bounds.csv:2`). Firmen, die spät ausfallen, gehen nur mit ihren frühen Post-Werten ein. Das ist offengelegt (Lee-Note „Unequal reporting horizons remain“; Worker-Bericht, offene Fragen). Die Karte lässt diese Wahl zu. Bei der Interpretation sollte man aber wissen, dass die Lee-Bounds deshalb eng ausfallen.

[number withheld]. **Hinweis – Änderungszeiten passen nicht zur Aussage des Workers.** Laut `t025_verification.txt:5` wurden die Nicht-T025-Outputs nie im Projektordner neu erzeugt. Die Prüfung nach Änderungszeit zeigt aber neu geschriebene Dateien t0[number withheld]–t0[number withheld] in `replication/outputs/` und gleichzeitig Änderungen in `presentation/slides/`. Das deutet eher auf eine parallele Sitzung hin. Ich kann nur lesen und daher keine Prüfsummen berechnen. Ob die Dateien byte-identisch sind (Manifest in `t025_verification.txt:147–230`), muss der Co-PI mit SHA-[number withheld] abgleichen. Das betrifft nicht die Datenaufbereitung.

[number withheld]. **Hinweis – `state/STATE.md` hat sich während der Ausführung geändert.** Das hat das Skript gemeldet. Die Datei enthält keine Daten, die in die Rechnung eingehen. Für die Datenaufbereitung ist das ohne Folgen.

## Prüfung der Datenaufbereitung

- **Rohdaten → Risikomenge:** Gelesen wird `panel_firm_halfyear.csv`, gefiltert auf `sample_main` und `!is.na(dose_pre)`. Es gibt keine doppelten Schlüssel (firm_id, date), es sind genau [number withheld] Firmen, die Daten liegen im [number withheld]-Stichtage-Raster, und `post` beginnt mit 2020-12-31 (`09_selection.R:23–26`). Das Panel enthält nur echte Quellzeilen (`has_row` ist laut `01_clean.R:697` immer TRUE). Das volle Raster `g` mit [number withheld] × [number withheld] = [number withheld] Zeilen wird per `match` aufgefüllt, fehlende Zeilen werden zu NA, also s = [number withheld] (`09_selection.R:68–75`). Die Attritionszahlen stimmen mit der Karte überein ([number withheld]/[number withheld] und [number withheld]/[number withheld] für [number withheld]H2).
- **Firmenmerkmale:** dose_pre und market sind je Firma konstant (Assert `:[number withheld]`). Vorperiode heißt `date <= 2019-12-31`, das sind [number withheld] Stichtage; [number withheld]H1 gehört nicht dazu. Z = Anteil der Stichtage mit nicht-fehlendem `ta` / [number withheld]. Fehlende Zeilen zählen korrekt als [number withheld]. Z < [number withheld] gilt für [number withheld] Firmen (`t025_first_stage_diagnostics.csv`), Z variiert also (Assert `:[number withheld]`). `pre_log_ta` ist für alle Firmen endlich (Assert `:[number withheld]`). Dass log-Assets über die Märkte hinweg in unterschiedlichen Währungen stehen können, nennt die Note.
- **Merge:** `merge(g, f, by = "firm_id")` mit `f` eindeutig je Firma (über die IDs gebaut). Die Zeilenzahl [number withheld] wird danach geprüft (`:[number withheld]`).
- **Dosisgruppen:** `floor(dose_pre + [number withheld])` mit dose_pre ∈ [[number withheld], [number withheld]] (Assert in `04_robustness.R:51`) ergibt die Gruppen [number withheld]–[number withheld]. Für 2017-12-31 summieren sie sich auf [number withheld] ([number withheld] + [number withheld] + [number withheld] + [number withheld]).
[firm-specific excerpt withheld in public process copy]
[firm-specific excerpt withheld in public process copy]
- **S6:** Die Definition (`balanced = all(dates %in% d$date[d$has_row])`) entspricht `04_robustness.R:40`. Koeffizienten, N und Firmenzahlen in `t025_selection.csv` stimmen mit `t011_robustness.csv:32–36` überein, z. B. rl1 [number withheld] bei N = [number withheld] und [number withheld] Firmen.
- **Lee-Daten:** Gruppen: high bei dose_pre ≥ [number withheld], low bei < [number withheld], sonst middle; [number withheld] + [number withheld] + [number withheld] = [number withheld] bei rl1. Die Veränderung ist das verfügbare Post-Mittel minus das verfügbare Vorperioden-Mittel. Firmen ohne Vorperiodenmittel werden ausgeschlossen und gezählt (`excluded_no_pre_*`). Die Bootstrap-Indizes `ii` beziehen sich bei `g` und bei `lee_data` auf dieselbe Reihenfolge der IDs (`:[number withheld], :[number withheld]`).

## Abnahmekriterien

[number withheld]. Baseline = T009 auf [number withheld] genau: **belegt erfüllt**, soweit es die Daten betrifft. Die Stichprobe ist identisch mit `02_estimate.R`/T009 (Filter `:[number withheld]`, Assert `:[number withheld]`, maximale Abweichung [number withheld] laut `t025_baseline_validation.csv`). Den Schätzcode bewertet nicht meine Rolle.
[number withheld]. Erste Stufe und Z berichtet, Seed gesetzt, zwei Läufe identisch: die Konstruktion von Z ist **belegt korrekt** (Variation vorhanden, [number withheld] Firmen mit Z < [number withheld]). Die byte-identischen Läufe kann ich nicht prüfen (siehe unten). Die Schätzung der ersten Stufe gehört nicht zu meiner Rolle.
[number withheld]. Bestehende Outputs byte-identisch: **nicht prüfbar** für mich, siehe Befund [number withheld]. Nicht meine Rolle.
[number withheld]. Interpretation, wie stark β sich verschiebt: nicht meine Rolle.

## Nicht geprüft

- Prüfsummen und byte-identische Läufe: Ich darf keine Befehle ausführen, deshalb habe ich keine SHA-[number withheld] berechnet. Ich habe nur das Manifest des Workers gelesen.
[firm-specific excerpt withheld in public process copy]
- Upstream-Definitionen aus `01_clean.R`, z. B. ob ein fehlendes jv „kein JV“ oder „nicht berichtet“ bedeutet und welche Währung `ta` hat: nicht Teil dieser Karte.
- Ob `run_all.R`/`run_all.sh` korrekt registriert sind und ob das README stimmt: nicht meine Rolle.
