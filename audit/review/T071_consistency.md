## Rolle: consistency (claude, sonnet) – VERDICT: PASS


## Befunde

1. **Overfull-Box im Haupttext (Hinweis, kein Mangel meiner Rolle).** `review/T071_build/main.log:1909` meldet Overfull 20,84 pt in `proposal/sections/07_conclusion.tex`, Zeilen 8–9. Die Datei erscheint nicht in `review/T071_proposal.diff`. Der Überlauf liegt also im Overleaf-Stand und nicht in dieser Karte. Der Worker hat ihn korrekt offen gelassen, aber Kriterium 1 ist deshalb formal nicht vollständig erfüllt. Es ist die einzige Overfull-Meldung im Log. Das ist eine Layoutfrage für Co-PI und PI.
2. **Einleitungsabsätze (Layout).** In den Unterabschnitten „Threshold targeting“, „Composition of compliance“ und „Control“ führen die zusammengezogenen Absätze nicht jeden Float ein (Regel 2). In „Threshold targeting“ fehlen `fig:excess_mass` und `tab:t063_noise`, in „Composition“ `fig:t055_kappa` und `tab:t046_cash`. Die Reihenfolge der genannten Floats stimmt mit der Reihenfolge der Floats überein. Inhaltlich stimmt alles; das ist eine Prüfpunkt für die Rolle `language`.

## Abnahmekriterien

- **Zahlen unverändert (Kriterium 2, meine Rolle): belegt erfüllt.** Ich habe die entfernten und hinzugefügten Zeilen im Diff verglichen. Die entfernten Zeilen sind nur Umbau von `apptabular` zu `appstar`/`tabular*`. Die Datenzeilen kommen mit denselben Werten und derselben Reihenfolge wieder. Das gilt für:
  - `t043_meas_error` (Zeilen 2106–2129),
  - `t046_cash_backing_all` (2339–2362; Schätzer über Intervall in `\makecell[r]`),
  - `t055_falsification` (2495–2500),
  - `t055_mi_shift` (2597–2630; nur Leerzeichen nach dem Komma im Intervall),
  - `t061_results` (3282–3293),
  - `t063_control_sens` (3411–3428, 3499–3516),
  - `t063_window` (3721–3818).
  In `t043_meas_error` ist nur „Cen\-tered“ mit einem Trennhinweis versehen, und die Intervalle sind nach dem Komma umbrochen.
- **Captions und Labels unverändert: belegt erfüllt.** Der Diff enthält keine geänderte `\caption`- oder `\label`-Zeile. Die `\floatnote`-Texte wurden nur verschoben. `tab:t045_shares` und die Notes in `t070_crosser_shares.tex` sind textgleich.
- **Textabsätze: belegt erfüllt.** Die zusammengezogenen Absätze in `results.tex` und `ai_use.tex` enthalten die ursprünglichen Sätze wörtlich in unveränderter Reihenfolge. Es sind keine Zahlen oder Aussagen hinzugekommen oder weggefallen. Die Verweise `\ref` und `\eqref` bleiben unverändert (`eq:did`, `tab:did_main`, `tab:pretrend`, `tab:t024_rd_main`, `tab:further_outputs`, `tab:t058_grid` usw.). Das Log meldet keine undefinierten Referenzen und keine mehrfach definierten Labels.
- **Haupttext unverändert: belegt erfüllt, soweit der Diff reicht.** Der Diff enthält keine Datei in `sections/`. Die Seitenzahl 15 habe ich nicht geprüft.
- **Overfull > 1 pt: nicht erfüllt (siehe Befund 1).** Der Anhang selbst hat laut Log keinen.
- **Füllstände, Laufzeilen, verwaiste Sätze, Bildmaße (Regeln 1–4 und Kriterien 1/3): nicht meine Rolle.** Die Spaltenaufteilung (Schätzer | Intervall bzw. gestapelt) ist im Quelltext erkennbar umgesetzt.

## Nicht geprüft

- Die gerenderten Seiten in `review/T071_pages/` und die Füllschätzungen der Tabelle im Bericht. Ich habe keine Bilder angesehen, und das PDF habe ich nicht neu gebaut.
- Die Behauptung, der Haupttext ende auf Seite 15.
- `number_inventory.json` und `verify.py`. Ich habe die Zahlen direkt im Diff verglichen.
- Die Tabellen `t005`, `t009`, `t024`, `t031`, `t040`, `t041`, `t043_delta_excess`, `t043_heterogeneity`, `t043_integration`, `t043_trend_cf`, `t049`, `t055_pretrend_tests`, `t058_*` und `t063_noise`, `t063_one_obs`. Ich habe nur die entfernten Zeilen durchsucht, und dort sind keine Datenzeilen verschwunden. Die hinzugefügten Zeilen habe ich dort nicht einzeln gelesen.
- Ob Zahlen im Anhang noch zu den CSVs unter `replication/outputs/` passen. Die Karte ändert keine Werte, und ein solcher Abgleich war nicht Teil des Diffs.
