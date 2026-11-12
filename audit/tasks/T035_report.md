## Ergebnis
Die Abschnitte 3 (Theoretical Framework), 4 (Context and Data, Datei 05) und 5 (Empirical Strategy, Datei 04) sind auf die finale Fragestellung umgeschrieben. Sie folgen den drei Evidenzebenen (Targeting → Zusammensetzung → Substanz). Die Dosis-DiD, die RD und die Attritionsprüfung stehen nur noch als ergänzende Designs in 5.4. Die alten H1–H4 und der dosiszentrierte Identifikationstext sind entfernt. In `main.tex` stehen jetzt der finale Titel und die Reihenfolge 01, 02, 03, 05, 04, 06, 07. **Kompiliert habe ich nicht**, weil ich in dieser Sitzung kein Bash-Werkzeug hatte. Diesen Schritt macht laut Karte der PI.

## Dateien
- `proposal/main.tex` – Titel „Deleveraging on Paper? …“ und neue Reihenfolge der Abschnitte; sonst unverändert.
- `proposal/sections/03_framework.tex` – vollständig neu: Notch, Margen d und e, Bedingung g ≤ ḡ, Sicherheitspuffer, κ, H1–H3. Keine abgesetzten Gleichungen, keine Beweise.
- `proposal/sections/05_context_data.tex` – vollständig neu: Politikfakten, Stichprobe mit Erweiterung, RL1-Konstruktion und -Validierung, Einschränkungen D19/D20/D22, Design des Pilots, Summary-Statistics-Tabelle unverändert.
- `proposal/sections/04_empirical_model.tex` – vollständig neu: 5.1 Bunching, 5.2 Zerlegung und eingefrorene Minderheitsanteile, 5.3 Codierschema, 5.4 ergänzende Designs. Genau 4 nummerierte Gleichungen.

## Ausführung
Nicht ausgeführt, weil kein Shell-Zugang bestand. Befehl für den PI:
`cd proposal && latexmk -pdf -interaction=nonstopmode -outdir=../review/T035_build main.tex; cd ..`

## Abnahmekriterien
1. **Wortbudgets (geschätzt, nicht maschinell gezählt):**
   - Abschnitt 3: etwa 700 Wörter (Budget 700).
   - Abschnitt 4: etwa 870 Wörter (Budget 900).
   - Abschnitt 5: etwa 930 Wörter (Budget 900, +10 % = 990).
   - Es gibt keine neuen Zitierschlüssel, nur `jin2025deleveraging` und `kleven2016bunching`. Die fehlende Quelle zur Behandlung der Perpetuals steht als `\textbf{[cite]}` mit Kommentar „PI to verify“ im Text.
2. **Methoden wie umgesetzt:**
   - Excess Mass b als Gesamtüberschuss geteilt durch den mittleren kontrafaktischen Bin, mit Ausschluss von [0.66, 0.72) bei den Placebos (`06_bunching_tests.R`, Z. 372–436).
   - Robustheit wie in T031.
   - Logit-Zerlegung wie in T027.
   - R̃, D, Placebo-Anker 2016 und gepaarter Bootstrap wie in T029.
   - Codierfelder und die sieben Vertragsmerkmale wie in T032/T033.
   - DiD, Kontrollen, RD mit h = 0,10, IPW/Heckman/Lee wie in T009/T028/T024/T025.
   - Die Interpretationsregel steht vor den Ergebnissen.
3. **Keine Überinterpretation:** R̃ heißt ausdrücklich „mechanical accounting counterfactual“, ist kein Maß der ökonomischen Verschuldung und wird nicht kausal gelesen. Minderheitsanteile können echtes Eigenkapital sein. H3 gilt als offen.
4. **Kompilierung:** nicht geprüft.

**Zahlen im neuen Text und ihre Quellen:**

| Zahl | Quelle |
|---|---|
| 0.70, 100 %, 15 %, 5 Prozentpunkte, 20.08.2020, 01.01.2021 | jin2025deleveraging (als UNVERIFIED kommentiert) |
| 136 Firmen, 1.692 Firmen-Halbjahre | `t004_panel_counts.csv` |
| 80 A-Shares / 56 HK-Firmen | `t030_coverage.csv` (n_sample_main) |
| 65 und 31 Firmen Ende 2024 | `t030_coverage.csv` |
| 6 zusätzliche Abwärtskreuzungen | `t030_crossings_preview.csv` (2+2+1+1) |
| 0,04 / 0,01 / 9,27 Pp., 70,3 % vs. 69,7 % | `rl1_published.csv` |
| 531 von 630 Beobachtungen ohne Perpetual-Posten | `t023_coverage.csv` |
| 10 Firmen, Gruppen 4/2/2/2 | `state/handcollect/pilot_purposive.csv` |
| 22 Berichte | `extraction_log.md` / T032-Bericht |
| 0.702/0.699, 0.126/0.240, 0.184/0.310, 0.717, 8.062/1.166 | `t005_summary_stats` |
| Bins 0,01, [0.40, 1.00], Grad 5, [0.66, 0.70), Placebos 0,60/0,80, [0.66, 0.72) | `t023_excess_mass.csv` / `06_bunching_tests.R` |
| 72 Spezifikationen | `t031_grid.csv` |
| Bandbreite 0,10 | `t024_rd_main.csv` |
| MDE 0,0257 (RL1) und 0,435 (RL2) | `t008_mde.csv` |

## Offene Fragen
- **Die Vorgabe der Karte „3 within 0.1 pp“ stimmt nicht mit den Daten überein.** In `rl1_published.csv` liegen nur 2 von 4 Werten innerhalb von 0,1 Pp. (Kaisa 2019 mit 0,04, Xinhu 2020 mit 0,01). Kaisa 2020 weicht um −0,55 Pp. ab, Xinhu 2019 um +9,27 Pp. Ich habe die Werte aus der Datei geschrieben. Alle Validierungswerte sind noch nicht vom PI geprüft, das steht auch im Text. Die Namen „Kaisa“ und „Xinhu“ stammen aus STATE.
- **Tabelle nach Dosis und Abbildung zu den Verletzungsanteilen sind aus dem Haupttext entfernt**, weil sie zum alten dosiszentrierten Design gehören. Laut STATE vom 18.10. ist die Tabelle nach Dosis aber Syllabus-Pflicht. Sie müsste daher in den Anhang, der nicht im Schreibbereich liegt. Ich habe `% TODO(PI)` gesetzt.
- **Keine TikZ-Abbildung:** `tikz` ist nicht in `preamble.tex` geladen, und die Präambel liegt nicht im Schreibbereich.
- **Labels:**
  - Behalten bzw. neu gesetzt: `eq:did`, `eq:es`, `subsec:treatment`, `subsec:power`, `subsec:variables`, `subsec:summary`, `subsec:institutions`, `subsec:hypotheses`, `tab:summary`.
  - Entfernt: `subsec:identification`, `subsec:equations`, `subsec:two_ways`, `subsec:stylised`, `tab:by_dose`, `fig:breach_shares`. Laut Grep werden sie nirgends außerhalb meiner Dateien referenziert.
  - `subsec:treatment` und `subsec:power` zeigen beide auf 5.4.
- **Annahme:** Das Erweiterungsfenster 2023–2024 berichte ich gemäß T030 als separates Fenster, weil die Frage einer Lockerung nach 2022 unverifiziert ist.
- **Vorschlag für `AI_USAGE_LOG.md`:** „2026-10-26, Claude: T035 – Abschnitte 3–5 auf finale Fragestellung umgeschrieben; PI prüft Inhalt, Zahlenquellen und Kompilierung.“
