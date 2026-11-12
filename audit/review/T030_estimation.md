## Rolle: estimation (claude, opus) – VERDICT: PASS

Ich prüfe gerade die Crossing-Zählung und die Pipeline-Einbindung von T030. Der Prüfbericht folgt.

VERDICT: PASS

## Befunde

Es gibt keine inhaltlichen Fehler in meiner Rolle (Schätzungen). Drei Hinweise für T029, keiner davon ist ein Mangel dieser Karte:

1. **`post` ist für 2023H1–2024H2 gleich 1.** `post` ist in `01b_extend.R:683` von den Finanzspalten ausgenommen. Deshalb übernimmt das Erweiterungspanel `post = date ≥ 2020-12-31` mechanisch. Ein Assert prüft das (Z. 701), und das Addendum dokumentiert es ausdrücklich als „NOT evidence original policy rules remained in force“. Was das bewirkt: Schätzt T029 `dose × post` auf `panel_firm_halfyear_ext.csv`, zählt das Erweiterungsfenster ohne weitere Angabe als Post-Periode. T029 muss also `post2` oder ein eigenes Fenster-Dummy mitführen, wie es die offene PI-Frage der Karte verlangt.
2. **Die Kreuzungszahlen sind keine Raten über ein stabiles Risikoset.** Die Zahl der Firmen unter Risiko sinkt von 53 (2022-12-31) auf 48–50 (2023–2024). Die Zahl der benachbarten RL1-Paare sinkt von 120 auf 96–101 (`t030_crossings_preview.csv`, Z. 13–17). Die 6 zusätzlichen Kreuzungen (2/2/1/1) entstehen in einem durch Datenlücken ausgedünnten Panel. Der Q2-Gewinn an Kreuzungen ist also klein, und das Risikoset ist selektiert.
3. **Randfall bei RL1 = 0,70.** Die Kreuzungsdefinition `previous_rl1 >= 0.70 & rl1 < 0.70` (Z. 751) folgt wörtlich der Karte. `b1` im Hauptpanel verwendet dagegen `rl1 > .70` (Z. 597). Eine Firma mit RL1 von genau 0,70 gilt also als „at risk“, aber nicht als Verletzerin. Praktisch spielt das wohl keine Rolle, weil Gleichheit bei stetigen Quoten kaum vorkommt. T029 sollte die Konvention aber einheitlich festlegen.

Geprüfte Punkte meiner Rolle ohne Befund:
- **Kreuzungslogik (Z. 747–757):** Die Nachbarschaft wird über `previous_index == half_index - 1L` auf dem Index der Zieltermine erzwungen. So werden Lücken aus fehlenden Zeilen bis 2022 und aus `has_row = FALSE` ab 2023 nicht überbrückt. Paare mit fehlendem RL1 sind ausgeschlossen. Die Zählungen sind innerlich stimmig: Die Paare je Datum liegen nie über der RL1-Zahl des Datums und des Vortermins in `t030_rl1_by_date.csv`. Die Summe 2023–2024 ergibt 6, wie im Bericht angegeben.
- **Dosis und Ownership:** `dose`, `dose_pre`, `dose2018`, `distance` und `soe_final` sind je Firma eingefroren und aus dem Hauptpanel übernommen (Z. 630–641, 680). Es gibt keine Treatment-Information aus der Zeit nach 2022 und keine Neuberechnung aus Outcomes des Erweiterungsfensters.
- **Überlappung:** Die Prüfung umfasst 89 Spalten × 2.279 Zeilen, einschließlich `post`, `dose`, `rl1`–`rl3`, `b1`–`b3` und `n_breached`. Alle Spalten sind `equal = TRUE` mit maximaler Differenz 0 (`t030_overlap_assert.csv`). Die Prüfung läuft dreimal: auf dem Panel, auf `ext` und auf der veröffentlichten CSV (Z. 674, 704, 787).
- **Keine Schätzungen:** Kein Skript in `code/` liest `panel_firm_halfyear_ext.csv`; die einzige Fundstelle ist der Schreibbefehl in `01b_extend.R:771`. In `01b_extend.R` gibt es keine Regressionen, Tests oder Konfidenzintervalle.
- **Pipeline:** `01b_extend.R` steht in `run_all.R:18` und `run_all.sh:6` direkt nach `01_clean.R` und vor allen Schätzskripten. Das Skript prüft vor und nach dem Schreiben per SHA-256, dass alle Rohdaten, das Hauptpanel und alle Outputs außer `t030_*` unverändert sind (Z. 8–11, 770, 788).

## Abnahmekriterien

1. **Hauptpanel und bisherige Outputs byte-identisch; Überlappungsprüfung bestanden: für meine Rolle belegt erfüllt.** Die Überlappungsprüfung ist in `t030_overlap_assert.csv` belegt (alle 89 Spalten TRUE, Differenz 0). Die SHA-256-Prüfung der vorhandenen Outputs innerhalb von 01b steht in Z. 770/788. `t030_verification.txt` meldet in Z. 25: „all 107 pre-existing outputs byte-identical to baseline“. Ein eigener Hash-Vergleich mit der Baseline war mir nicht möglich (siehe unten).
2. **Zwei Läufe byte-identisch: nicht meine Rolle.** Im Code gibt es nur deterministische Operationen und einen festen Seed (Z. 5). Das Manifest in `t030_verification.txt` (Z. 163 ff.) meldet identische Läufe; nachgerechnet habe ich das nicht.
3. **RL1-Firmen je Datum; Wind-only-Firmen benannt: belegt erfüllt, soweit meine Rolle betroffen ist.** Die Tabelle im Bericht stimmt Zeile für Zeile mit der Spalte `n_rl1` in `t030_rl1_by_date.csv` überein. Ob die Wind-only-Zuordnung richtig ist, gehört zur Rolle `data`.
4. **Keine Schätzungen: belegt erfüllt.** Siehe oben: Das Erweiterungspanel hat keinen Konsumenten unter den Schätzskripten, und es gibt nur Zählungen.

## Nicht geprüft

- Den SHA-256-Abgleich der 107 bisherigen Outputs mit der Baseline und den Vergleich der beiden Läufe konnte ich nicht selbst nachrechnen, weil die Shell in dieser Sitzung gesperrt ist. Ich stütze mich auf die Asserts im Skript und auf `t030_verification.txt`.
- Die Liste der Ausgabedateien außerhalb des Schreibbereichs (t009–t028), deren Änderungszeit neu ist, erklärt sich durch den vollständigen Neuaufbau mit `run_all.R`. Ob die Inhalte byte-identisch sind, konnte ich aus demselben Grund nicht nachrechnen.
- `state/STATE.md` hat sich seit Beginn der Ausführung geändert. Das ist eine Eingabe, kein Schreibziel der Karte; für die Schätzungen ist es nicht relevant, und ich habe es nicht bewertet.
- Datenaufbereitung (Item-Mapping, HK-Datumsregel, Attrition, Rundung von `dose_pre`), Coverage-Nenner, README und Sprache: nicht meine Rolle.
