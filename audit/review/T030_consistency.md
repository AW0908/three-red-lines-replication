## Rolle: consistency (claude, opus) – VERDICT: PASS


## Befunde

Ich habe keine inhaltlichen Widersprüche zwischen Code, Outputs, README und Worker-Bericht gefunden. Zwei Hinweise, die das Urteil nicht ändern:

1. **Hinweis, kein Fehler: `t030_verification.txt` liegt in `outputs/tables/`, wird aber nicht vom Code erzeugt.** Die Datei sagt das selbst (Zeile 1: „static, not rebuilt by the pipeline“), und die README dokumentiert es (Zeile 775). Sie ist also ein Prüfprotokoll und keine Ergebnistabelle. Der Text darf keine Zahlen aus dieser Datei übernehmen. Zitiert werden sollen die Zahlen aus den CSV-Dateien, die das Skript erzeugt.
2. **Hinweis zur Benennung: Die README nennt im Panel-Eintrag „original 89 columns retained“ (Zeile 770).** Das Panel hat 90 Spalten: die 89 bisherigen und `post2` (Kopfzeile von `panel_firm_halfyear_ext.csv`). Die Aussage stimmt, weil die 89 Spalten erhalten bleiben. Im Text sollte man aber „90 Spalten (89 + `post2`)“ schreiben, wie im Worker-Bericht.

Abgleich der Zahlen, alle stimmen überein:

- **RL1 je Stichtag:** Die Tabelle im Bericht stimmt für alle 17 Stichtage mit `n_rl1` in `t030_rl1_by_date.csv` überein, zum Beispiel 2019-06-30: 131 (Balance 132), 2023-06-30: 101 und 2024-12-31: 96.
- **Coverage, Summe der Zellen:** Für jeden Stichtag ergibt die Summe von `t030_coverage.csv` über Markt × Quelle `n_rl1_by_date`. Beispiele:
  - 2016-12-31: 65+15+40+13 = 133
  - 2019-06-30: 65+15+39+12 = 131
  - 2024-12-31: 65+0+31+0 = 96
- **Coverage, Nenner:** Er ist immer 65+15+43+13 = 136.
- **Attrition:** Die Summe von `n_present_2022h2` in `t030_attrition_2023_2024.csv` ist 11+29+33+25+22 = 120 und entspricht damit RL1 für 2022-12-31. Die Summen von `n_present` je Datum sind 101, 99, 98 und 96 und stimmen mit RL1 überein. `n_wind_only_no_export` ist an jedem Datum 2+3+4+4+4 = 17.
- **Fehlende EastMoney-Firmen:** Die Zahl `n_eastmoney_missing` (2, 4, 5, 7) passt Zeile für Zeile zu `t030_missing_firms.csv`. Bis 2024-12 kommen schrittweise hinzu: 1902 und 2599, dann 3333 und 6900, dann 2019, zuletzt 1207 und 1329. Auch die Zuordnung zu den gerundeten Dosisgruppen passt. Die Rundung `floor(dose_pre + 0.5)` (01b_extend.R:732) rundet Halbwerte aufwärts (2.5→3, 0.5→1). So steht es auch in der README (Zeile 797).
[firm-specific excerpt withheld in public audit]
- **Kreuzungen:** `t030_crossings_preview.csv` hat 16 Zeilen von 2017-06-30 bis 2024-12-31, wie in Karte und README angegeben („2017H1–2024H2“). Für die Erweiterung zeigt sie 2/2/1/1, zusammen 6, wie im Bericht. Die Definition im Code (01b_extend.R:750–751: benachbarte Stichtage, ≥0.70 → <0.70) entspricht Karte und README (Zeilen 797–800). Jeder Wert `n_adjacent_rl1_pairs` ist höchstens so groß wie das Minimum der RL1-Werte der beiden Stichtage.
- **Panelgröße:** 2279 + 4×184 = 3015 Zeilen. Das entspricht dem Bericht und dem Dictionary-Eintrag („full frozen firm register for four extension dates“). Die Zahlen 136 Haupt- und 172 Broad-Firmen sind in Addendum, README und Log gleich.
- **`post2`:** Der Code (Zeile 697, `date >= 2023-06-30`), das Addendum und die README beschreiben die Variable gleich. Keine dieser Stellen nennt den Zeitraum „post-policy“, wie es die offene PI-Frage der Karte verlangt.

## Abnahmekriterien

1. **Hauptpanel und Outputs byte-identisch, Overlap-Assert bestanden:** belegt erfüllt, soweit es meine Rolle betrifft.
   - `t030_overlap_assert.csv`: 89 Spalten × 2279 Zeilen, alle `equal=TRUE`, `max_absolute_difference=0`.
   - Der SHA-256 des Hauptpanels ist im Baseline-Manifest und im Lauf-Manifest gleich (`9b8686…`).
   - Die Bytegleichheit der übrigen Outputs habe ich nicht selbst nachgerechnet, sondern nur mit dem Manifest abgeglichen (siehe Nicht geprüft).
2. **Zwei Läufe byte-identisch:** nicht meine Rolle. Laut `t030_verification.txt` stimmen die Manifeste überein. Nachgerechnet habe ich das nicht.
3. **RL1 je Stichtag und Wind-only-Firmen benannt:** belegt erfüllt.
   - Die Tabelle im Bericht entspricht `t030_rl1_by_date.csv`.
   - Die 17 Wind-only-Firmen sind namentlich genannt und stimmen mit `t030_wind_only_firms.csv` und `t030_missing_firms.csv` überein.
   - Der Bericht hält klar fest, dass das Fehlen dieser Firmen „kein Nachweis wirtschaftlicher Attrition“ ist.
4. **Keine Schätzungen:** belegt erfüllt. Alle `t030_*`-Dateien enthalten nur Zählungen, Definitionen und Asserts, keine Koeffizienten.

## Nicht geprüft

- **Inhalt von `proposal/`:** Die Karte ändert keinen Text. Deshalb gibt es keinen Abgleich zwischen Zahlen im Text und den Outputs.
- **SHA-256-Werte und Bytegleichheit der beiden Läufe:** Ich durfte keine Befehle ausführen.
- **Ob die Werte im Extension-Panel richtig berechnet sind** (Item-Mapping, Imputation): Das ist Aufgabe der Rollen data und estimation.
- **Mapping-Audit der A-Aktien:** `t030_item_mapping_audit.csv` deckt nur die HK-Dateien von EastMoney ab, nicht die Posten der A-Aktien von 2023–2024. Das gehört zur Rolle data.
- **Rest von `t030_verification.txt`:** Ich habe nur die Zeilen 1–694 von 3799 gelesen. Die Zählungen und Manifeste stehen im gelesenen Teil.
- **Änderungen an `state/STATE.md` und an den älteren Output-Dateien laut mtime:** Das betrifft den Schreibbereich und die Integrität, also nicht meine Rolle. Laut Manifest sind die SHA-256-Werte der älteren Outputs unverändert. Eine neue mtime ohne andere Prüfsumme passt dazu, dass die Pipeline alles vollständig neu gebaut hat.
