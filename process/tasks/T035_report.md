## Ergebnis
Die Abschnitte [number withheld] (Theoretical Framework), [number withheld] (Context and Data, Datei [number withheld]) und [number withheld] (Empirical Strategy, Datei [number withheld]) sind auf die finale Fragestellung umgeschrieben. Sie folgen den drei Evidenzebenen (Targeting → Zusammensetzung → Substanz). Die Dosis-DiD, die RD und die Attritionsprüfung stehen nur noch als ergänzende Designs in [number withheld]. Die alten H1–H4 und der dosiszentrierte Identifikationstext sind entfernt. In `main.tex` stehen jetzt der finale Titel und die Reihenfolge [number withheld], [number withheld], [number withheld], [number withheld], [number withheld], [number withheld], [number withheld]. **Kompiliert habe ich nicht**, weil ich in dieser Sitzung kein Bash-Werkzeug hatte. Diesen Schritt macht laut Karte der PI.

## Dateien
- `proposal/main.tex` – Titel „Deleveraging on Paper? …“ und neue Reihenfolge der Abschnitte; sonst unverändert.
- `proposal/sections/03_framework.tex` – vollständig neu: Notch, Margen d und e, Bedingung g ≤ ḡ, Sicherheitspuffer, κ, H1–H3. Keine abgesetzten Gleichungen, keine Beweise.
- `proposal/sections/05_context_data.tex` – vollständig neu: Politikfakten, Stichprobe mit Erweiterung, RL1-Konstruktion und -Validierung, Einschränkungen D1[number withheld]/D2[number withheld]/D2[number withheld], Design des Pilots, Summary-Statistics-Tabelle unverändert.
- `proposal/sections/04_empirical_model.tex` – vollständig neu: [number withheld] Bunching, [number withheld] Zerlegung und eingefrorene Minderheitsanteile, [number withheld] Codierschema, [number withheld] ergänzende Designs. Genau [number withheld] nummerierte Gleichungen.

## Ausführung
Nicht ausgeführt, weil kein Shell-Zugang bestand. Befehl für den PI:
`cd proposal && latexmk -pdf -interaction=nonstopmode -outdir=../review/T0[number withheld]_build main.tex; cd ..`

## Abnahmekriterien
[number withheld]. **Wortbudgets (geschätzt, nicht maschinell gezählt):**
   - Abschnitt [number withheld]: etwa [number withheld] Wörter (Budget [number withheld]).
   - Abschnitt [number withheld]: etwa [number withheld] Wörter (Budget [number withheld]).
   - Abschnitt [number withheld]: etwa [number withheld] Wörter (Budget [number withheld], [number withheld] % = [number withheld]).
   - Es gibt keine neuen Zitierschlüssel, nur `jin2[number withheld]deleveraging` und `kleven2[number withheld]bunching`. Die fehlende Quelle zur Behandlung der Perpetuals steht als `\textbf{[cite]}` mit Kommentar „PI to verify“ im Text.
[number withheld]. **Methoden wie umgesetzt:**
   - Excess Mass b als Gesamtüberschuss geteilt durch den mittleren kontrafaktischen Bin, mit Ausschluss von [[number withheld], [number withheld]) bei den Placebos (`06_bunching_tests.R`, Z. [number withheld]–[number withheld]).
   - Robustheit wie in T031.
   - Logit-Zerlegung wie in T027.
   - R̃, D, Placebo-Anker [number withheld] und gepaarter Bootstrap wie in T029.
   - Codierfelder und die sieben Vertragsmerkmale wie in T032/T033.
   - DiD, Kontrollen, RD mit h = [number withheld], IPW/Heckman/Lee wie in T009/T028/T024/T025.
   - Die Interpretationsregel steht vor den Ergebnissen.
[number withheld]. **Keine Überinterpretation:** R̃ heißt ausdrücklich „mechanical accounting counterfactual“, ist kein Maß der ökonomischen Verschuldung und wird nicht kausal gelesen. Minderheitsanteile können echtes Eigenkapital sein. H3 gilt als offen.
[number withheld]. **Kompilierung:** nicht geprüft.

**Zahlen im neuen Text und ihre Quellen:**

| Zahl | Quelle |
|---|---|
| [number withheld], [number withheld] %, [number withheld] %, [number withheld] Prozentpunkte, [number withheld], [number withheld] | jin2[number withheld]deleveraging (als UNVERIFIED kommentiert) |
| [number withheld] Firmen, [number withheld] Firmen-Halbjahre | `t004_panel_counts.csv` |
| [number withheld] A-Shares / [number withheld] HK-Firmen | `t030_coverage.csv` (n_sample_main) |
| [number withheld] und [number withheld] Firmen Ende [number withheld] | `t030_coverage.csv` |
| [number withheld] zusätzliche Abwärtskreuzungen | `t030_crossings_preview.csv` ([number withheld][number withheld][number withheld][number withheld]) |
| [number withheld] / [number withheld] / [number withheld] Pp., [number withheld] % vs. [number withheld] % | `rl1_published.csv` |
| [number withheld] von [number withheld] Beobachtungen ohne Perpetual-Posten | `t023_coverage.csv` |
| [number withheld] Firmen, Gruppen [number withheld]/[number withheld]/[number withheld]/[number withheld] | `state/handcollect/pilot_purposive.csv` |
| [number withheld] Berichte | `extraction_log.md` / T032-Bericht |
| [number withheld]/[number withheld], [number withheld]/[number withheld], [number withheld]/[number withheld], [number withheld], [number withheld]/[number withheld] | `t0[number withheld]_summary_stats` |
| Bins [number withheld], [[number withheld], [number withheld]], Grad [number withheld], [[number withheld], [number withheld]), Placebos [number withheld]/[number withheld], [[number withheld], [number withheld]) | `t023_excess_mass.csv` / `06_bunching_tests.R` |
| [number withheld] Spezifikationen | `t031_grid.csv` |
| Bandbreite [number withheld] | `t024_rd_main.csv` |
| MDE [number withheld] (RL1) und [number withheld] (RL2) | `t008_mde.csv` |

## Offene Fragen
- **Die Vorgabe der Karte „[number withheld] within [number withheld] pp“ stimmt nicht mit den Daten überein.** In `rl1_published.csv` liegen nur [number withheld] von [number withheld] Werten innerhalb von [number withheld] Pp. (Kaisa [number withheld] mit [number withheld], Xinhu [number withheld] mit [number withheld]). Kaisa [number withheld] weicht um [number withheld] Pp. ab, Xinhu [number withheld] um [number withheld] Pp. Ich habe die Werte aus der Datei geschrieben. Alle Validierungswerte sind noch nicht vom PI geprüft, das steht auch im Text. Die Namen „Kaisa“ und „Xinhu“ stammen aus STATE.
- **Tabelle nach Dosis und Abbildung zu den Verletzungsanteilen sind aus dem Haupttext entfernt**, weil sie zum alten dosiszentrierten Design gehören. Laut STATE vom [number withheld]. ist die Tabelle nach Dosis aber Syllabus-Pflicht. Sie müsste daher in den Anhang, der nicht im Schreibbereich liegt. Ich habe `% TODO(PI)` gesetzt.
- **Keine TikZ-Abbildung:** `tikz` ist nicht in `preamble.tex` geladen, und die Präambel liegt nicht im Schreibbereich.
- **Labels:**
  - Behalten bzw. neu gesetzt: `eq:did`, `eq:es`, `subsec:treatment`, `subsec:power`, `subsec:variables`, `subsec:summary`, `subsec:institutions`, `subsec:hypotheses`, `tab:summary`.
  - Entfernt: `subsec:identification`, `subsec:equations`, `subsec:two_ways`, `subsec:stylised`, `tab:by_dose`, `fig:breach_shares`. Laut Grep werden sie nirgends außerhalb meiner Dateien referenziert.
  - `subsec:treatment` und `subsec:power` zeigen beide auf [number withheld].
- **Annahme:** Das Erweiterungsfenster [number withheld]–[number withheld] berichte ich gemäß T030 als separates Fenster, weil die Frage einer Lockerung nach [number withheld] unverifiziert ist.
- **Vorschlag für `AI_USAGE_LOG.md`:** „2026-10-26, Claude: T035 – Abschnitte [number withheld]–[number withheld] auf finale Fragestellung umgeschrieben; PI prüft Inhalt, Zahlenquellen und Kompilierung.“
