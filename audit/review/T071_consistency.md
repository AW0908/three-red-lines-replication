## Rolle: consistency (claude, sonnet) – VERDICT: PASS


## Befunde

[number withheld]. **Overfull-Box im Haupttext (Hinweis, kein Mangel meiner Rolle).** `review/T071_build/main.log:1909` meldet Overfull [number withheld] pt in `proposal/sections/07_conclusion.tex`, Zeilen [number withheld]–[number withheld]. Die Datei erscheint nicht in `review/T0[number withheld]_proposal.diff`. Der Überlauf liegt also im Overleaf-Stand und nicht in dieser Karte. Der Worker hat ihn korrekt offen gelassen, aber Kriterium [number withheld] ist deshalb formal nicht vollständig erfüllt. Es ist die einzige Overfull-Meldung im Log. Das ist eine Layoutfrage für Co-PI und PI.
[number withheld]. **Einleitungsabsätze (Layout).** In den Unterabschnitten „Threshold targeting“, „Composition of compliance“ und „Control“ führen die zusammengezogenen Absätze nicht jeden Float ein (Regel [number withheld]). In „Threshold targeting“ fehlen `fig:excess_mass` und `tab:t0[number withheld]_noise`, in „Composition“ `fig:t0[number withheld]_kappa` und `tab:t0[number withheld]_cash`. Die Reihenfolge der genannten Floats stimmt mit der Reihenfolge der Floats überein. Inhaltlich stimmt alles; das ist eine Prüfpunkt für die Rolle `language`.

## Abnahmekriterien

- **Zahlen unverändert (Kriterium [number withheld], meine Rolle): belegt erfüllt.** Ich habe die entfernten und hinzugefügten Zeilen im Diff verglichen. Die entfernten Zeilen sind nur Umbau von `apptabular` zu `appstar`/`tabular*`. Die Datenzeilen kommen mit denselben Werten und derselben Reihenfolge wieder. Das gilt für:
  - `t0[number withheld]_meas_error` (Zeilen [number withheld]–[number withheld]),
  - `t0[number withheld]_cash_backing_all` ([number withheld]–[number withheld]; Schätzer über Intervall in `\makecell[r]`),
  - `t0[number withheld]_falsification` ([number withheld]–[number withheld]),
  - `t0[number withheld]_mi_shift` ([number withheld]–[number withheld]; nur Leerzeichen nach dem Komma im Intervall),
  - `t0[number withheld]_results` ([number withheld]–[number withheld]),
  - `t0[number withheld]_control_sens` ([number withheld]–[number withheld], [number withheld]–[number withheld]),
  - `t0[number withheld]_window` ([number withheld]–[number withheld]).
  In `t0[number withheld]_meas_error` ist nur „Cen\-tered“ mit einem Trennhinweis versehen, und die Intervalle sind nach dem Komma umbrochen.
- **Captions und Labels unverändert: belegt erfüllt.** Der Diff enthält keine geänderte `\caption`- oder `\label`-Zeile. Die `\floatnote`-Texte wurden nur verschoben. `tab:t0[number withheld]_shares` und die Notes in `t070_crosser_shares.tex` sind textgleich.
- **Textabsätze: belegt erfüllt.** Die zusammengezogenen Absätze in `results.tex` und `ai_use.tex` enthalten die ursprünglichen Sätze wörtlich in unveränderter Reihenfolge. Es sind keine Zahlen oder Aussagen hinzugekommen oder weggefallen. Die Verweise `\ref` und `\eqref` bleiben unverändert (`eq:did`, `tab:did_main`, `tab:pretrend`, `tab:t0[number withheld]_rd_main`, `tab:further_outputs`, `tab:t0[number withheld]_grid` usw.). Das Log meldet keine undefinierten Referenzen und keine mehrfach definierten Labels.
- **Haupttext unverändert: belegt erfüllt, soweit der Diff reicht.** Der Diff enthält keine Datei in `sections/`. Die Seitenzahl [number withheld] habe ich nicht geprüft.
- **Overfull > [number withheld] pt: nicht erfüllt (siehe Befund [number withheld]).** Der Anhang selbst hat laut Log keinen.
- **Füllstände, Laufzeilen, verwaiste Sätze, Bildmaße (Regeln [number withheld]–[number withheld] und Kriterien [number withheld]/[number withheld]): nicht meine Rolle.** Die Spaltenaufteilung (Schätzer | Intervall bzw. gestapelt) ist im Quelltext erkennbar umgesetzt.

## Nicht geprüft

- Die gerenderten Seiten in `review/T0[number withheld]_pages/` und die Füllschätzungen der Tabelle im Bericht. Ich habe keine Bilder angesehen, und das PDF habe ich nicht neu gebaut.
- Die Behauptung, der Haupttext ende auf Seite [number withheld].
- `number_inventory.json` und `verify.py`. Ich habe die Zahlen direkt im Diff verglichen.
- Die Tabellen `t0[number withheld]`, `t0[number withheld]`, `t0[number withheld]`, `t0[number withheld]`, `t0[number withheld]`, `t0[number withheld]`, `t0[number withheld]_delta_excess`, `t0[number withheld]_heterogeneity`, `t0[number withheld]_integration`, `t0[number withheld]_trend_cf`, `t0[number withheld]`, `t0[number withheld]_pretrend_tests`, `t0[number withheld]_*` und `t0[number withheld]_noise`, `t0[number withheld]_one_obs`. Ich habe nur die entfernten Zeilen durchsucht, und dort sind keine Datenzeilen verschwunden. Die hinzugefügten Zeilen habe ich dort nicht einzeln gelesen.
- Ob Zahlen im Anhang noch zu den CSVs unter `replication/outputs/` passen. Die Karte ändert keine Werte, und ein solcher Abgleich war nicht Teil des Diffs.
