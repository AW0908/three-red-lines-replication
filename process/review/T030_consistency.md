## Rolle: consistency (claude, opus) – VERDICT: PASS


## Befunde

Ich habe keine inhaltlichen Widersprüche zwischen Code, Outputs, README und Worker-Bericht gefunden. Zwei Hinweise, die das Urteil nicht ändern:

[number withheld]. **Hinweis, kein Fehler: `t030_verification.txt` liegt in `outputs/tables/`, wird aber nicht vom Code erzeugt.** Die Datei sagt das selbst (Zeile [number withheld]: „static, not rebuilt by the pipeline“), und die README dokumentiert es (Zeile [number withheld]). Sie ist also ein Prüfprotokoll und keine Ergebnistabelle. Der Text darf keine Zahlen aus dieser Datei übernehmen. Zitiert werden sollen die Zahlen aus den CSV-Dateien, die das Skript erzeugt.
[number withheld]. **Hinweis zur Benennung: Die README nennt im Panel-Eintrag „original [number withheld] columns retained“ (Zeile [number withheld]).** Das Panel hat [number withheld] Spalten: die [number withheld] bisherigen und `post2` (Kopfzeile von `panel_firm_halfyear_ext.csv`). Die Aussage stimmt, weil die [number withheld] Spalten erhalten bleiben. Im Text sollte man aber „[number withheld] Spalten ([number withheld] + `post2`)“ schreiben, wie im Worker-Bericht.

Abgleich der Zahlen, alle stimmen überein:

- **RL1 je Stichtag:** Die Tabelle im Bericht stimmt für alle [number withheld] Stichtage mit `n_rl1` in `t030_rl1_by_date.csv` überein, zum Beispiel 2019-06-30: [number withheld] (Balance [number withheld]), 2023-06-30: [number withheld] und 2024-12-31: [number withheld].
- **Coverage, Summe der Zellen:** Für jeden Stichtag ergibt die Summe von `t030_coverage.csv` über Markt × Quelle `n_rl1_by_date`. Beispiele:
  - 2016-12-31: [number withheld][number withheld][number withheld][number withheld] = [number withheld]
  - 2019-06-30: [number withheld][number withheld][number withheld][number withheld] = [number withheld]
  - 2024-12-31: [number withheld][number withheld][number withheld][number withheld] = [number withheld]
- **Coverage, Nenner:** Er ist immer [number withheld][number withheld][number withheld][number withheld] = [number withheld].
- **Attrition:** Die Summe von `n_present_2[number withheld]h2` in `t030_attrition_2023_2024.csv` ist [number withheld][number withheld][number withheld][number withheld][number withheld] = [number withheld] und entspricht damit RL1 für 2022-12-31. Die Summen von `n_present` je Datum sind [number withheld], [number withheld], [number withheld] und [number withheld] und stimmen mit RL1 überein. `n_wind_only_no_export` ist an jedem Datum [number withheld][number withheld][number withheld][number withheld][number withheld] = [number withheld].
- **Fehlende EastMoney-Firmen:** Die Zahl `n_eastmoney_missing` ([number withheld], [number withheld], [number withheld], [number withheld]) passt Zeile für Zeile zu `t030_missing_firms.csv`. Bis [number withheld][number withheld] kommen schrittweise hinzu: [number withheld] und [number withheld], dann [number withheld] und [number withheld], dann [number withheld], zuletzt [number withheld] und [number withheld]. Auch die Zuordnung zu den gerundeten Dosisgruppen passt. Die Rundung `floor(dose_pre + [number withheld])` ([number withheld]b_extend.R:[number withheld]) rundet Halbwerte aufwärts ([number withheld]→[number withheld], [number withheld]→[number withheld]). So steht es auch in der README (Zeile [number withheld]).
[firm-specific excerpt withheld in public process copy]
- **Kreuzungen:** `t030_crossings_preview.csv` hat [number withheld] Zeilen von 2017-06-30 bis 2024-12-31, wie in Karte und README angegeben („[number withheld]H1–[number withheld]H2“). Für die Erweiterung zeigt sie [number withheld]/[number withheld]/[number withheld]/[number withheld], zusammen [number withheld], wie im Bericht. Die Definition im Code ([number withheld]b_extend.R:[number withheld]–[number withheld]: benachbarte Stichtage, ≥[number withheld] → <[number withheld]) entspricht Karte und README (Zeilen [number withheld]–[number withheld]). Jeder Wert `n_adjacent_rl1_pairs` ist höchstens so groß wie das Minimum der RL1-Werte der beiden Stichtage.
- **Panelgröße:** [number withheld] + [number withheld]×[number withheld] = [number withheld] Zeilen. Das entspricht dem Bericht und dem Dictionary-Eintrag („full frozen firm register for four extension dates“). Die Zahlen [number withheld] Haupt- und [number withheld] Broad-Firmen sind in Addendum, README und Log gleich.
- **`post2`:** Der Code (Zeile [number withheld], `date >= 2023-06-30`), das Addendum und die README beschreiben die Variable gleich. Keine dieser Stellen nennt den Zeitraum „post-policy“, wie es die offene PI-Frage der Karte verlangt.

## Abnahmekriterien

[number withheld]. **Hauptpanel und Outputs byte-identisch, Overlap-Assert bestanden:** belegt erfüllt, soweit es meine Rolle betrifft.
   - `t030_overlap_assert.csv`: [number withheld] Spalten × [number withheld] Zeilen, alle `equal=TRUE`, `max_absolute_difference=[number withheld]`.
   - Der SHA-[number withheld] des Hauptpanels ist im Baseline-Manifest und im Lauf-Manifest gleich (`[number withheld]b8[number withheld]…`).
   - Die Bytegleichheit der übrigen Outputs habe ich nicht selbst nachgerechnet, sondern nur mit dem Manifest abgeglichen (siehe Nicht geprüft).
[number withheld]. **Zwei Läufe byte-identisch:** nicht meine Rolle. Laut `t030_verification.txt` stimmen die Manifeste überein. Nachgerechnet habe ich das nicht.
[number withheld]. **RL1 je Stichtag und Wind-only-Firmen benannt:** belegt erfüllt.
   - Die Tabelle im Bericht entspricht `t030_rl1_by_date.csv`.
   - Die [number withheld] Wind-only-Firmen sind namentlich genannt und stimmen mit `t030_wind_only_firms.csv` und `t030_missing_firms.csv` überein.
   - Der Bericht hält klar fest, dass das Fehlen dieser Firmen „kein Nachweis wirtschaftlicher Attrition“ ist.
[number withheld]. **Keine Schätzungen:** belegt erfüllt. Alle `t0[number withheld]_*`-Dateien enthalten nur Zählungen, Definitionen und Asserts, keine Koeffizienten.

## Nicht geprüft

- **Inhalt von `proposal/`:** Die Karte ändert keinen Text. Deshalb gibt es keinen Abgleich zwischen Zahlen im Text und den Outputs.
- **SHA-[number withheld]-Werte und Bytegleichheit der beiden Läufe:** Ich durfte keine Befehle ausführen.
- **Ob die Werte im Extension-Panel richtig berechnet sind** (Item-Mapping, Imputation): Das ist Aufgabe der Rollen data und estimation.
- **Mapping-Audit der A-Aktien:** `t030_item_mapping_audit.csv` deckt nur die HK-Dateien von EastMoney ab, nicht die Posten der A-Aktien von [number withheld]–[number withheld]. Das gehört zur Rolle data.
- **Rest von `t030_verification.txt`:** Ich habe nur die Zeilen [number withheld]–[number withheld] von [number withheld] gelesen. Die Zählungen und Manifeste stehen im gelesenen Teil.
- **Änderungen an `state/STATE.md` und an den älteren Output-Dateien laut mtime:** Das betrifft den Schreibbereich und die Integrität, also nicht meine Rolle. Laut Manifest sind die SHA-[number withheld]-Werte der älteren Outputs unverändert. Eine neue mtime ohne andere Prüfsumme passt dazu, dass die Pipeline alles vollständig neu gebaut hat.
