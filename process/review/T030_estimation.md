## Rolle: estimation (claude, opus) – VERDICT: PASS

Ich prüfe gerade die Crossing-Zählung und die Pipeline-Einbindung von T030. Der Prüfbericht folgt.

VERDICT: PASS

## Befunde

Es gibt keine inhaltlichen Fehler in meiner Rolle (Schätzungen). Drei Hinweise für T029, keiner davon ist ein Mangel dieser Karte:

[number withheld]. **`post` ist für [number withheld]H1–[number withheld]H2 gleich [number withheld].** `post` ist in `01b_extend.R:683` von den Finanzspalten ausgenommen. Deshalb übernimmt das Erweiterungspanel `post = date ≥ 2020-12-31` mechanisch. Ein Assert prüft das (Z. [number withheld]), und das Addendum dokumentiert es ausdrücklich als „NOT evidence original policy rules remained in force“. Was das bewirkt: Schätzt T029 `dose × post` auf `panel_firm_halfyear_ext.csv`, zählt das Erweiterungsfenster ohne weitere Angabe als Post-Periode. T029 muss also `post2` oder ein eigenes Fenster-Dummy mitführen, wie es die offene PI-Frage der Karte verlangt.
[number withheld]. **Die Kreuzungszahlen sind keine Raten über ein stabiles Risikoset.** Die Zahl der Firmen unter Risiko sinkt von [number withheld] (2022-12-31) auf [number withheld]–[number withheld] ([number withheld]–[number withheld]). Die Zahl der benachbarten RL1-Paare sinkt von [number withheld] auf [number withheld]–[number withheld] (`t030_crossings_preview.csv`, Z. [number withheld]–[number withheld]). Die [number withheld] zusätzlichen Kreuzungen ([number withheld]/[number withheld]/[number withheld]/[number withheld]) entstehen in einem durch Datenlücken ausgedünnten Panel. Der Q2-Gewinn an Kreuzungen ist also klein, und das Risikoset ist selektiert.
[number withheld]. **Randfall bei RL1 = [number withheld].** Die Kreuzungsdefinition `previous_rl1 >= [number withheld] & rl1 < [number withheld]` (Z. [number withheld]) folgt wörtlich der Karte. `b1` im Hauptpanel verwendet dagegen `rl1 > .[number withheld]` (Z. [number withheld]). Eine Firma mit RL1 von genau [number withheld] gilt also als „at risk“, aber nicht als Verletzerin. Praktisch spielt das wohl keine Rolle, weil Gleichheit bei stetigen Quoten kaum vorkommt. T029 sollte die Konvention aber einheitlich festlegen.

Geprüfte Punkte meiner Rolle ohne Befund:
- **Kreuzungslogik (Z. [number withheld]–[number withheld]):** Die Nachbarschaft wird über `previous_index == half_index - [number withheld]L` auf dem Index der Zieltermine erzwungen. So werden Lücken aus fehlenden Zeilen bis [number withheld] und aus `has_row = FALSE` ab [number withheld] nicht überbrückt. Paare mit fehlendem RL1 sind ausgeschlossen. Die Zählungen sind innerlich stimmig: Die Paare je Datum liegen nie über der RL1-Zahl des Datums und des Vortermins in `t030_rl1_by_date.csv`. Die Summe [number withheld]–[number withheld] ergibt [number withheld], wie im Bericht angegeben.
- **Dosis und Ownership:** `dose`, `dose_pre`, `dose2[number withheld]`, `distance` und `soe_final` sind je Firma eingefroren und aus dem Hauptpanel übernommen (Z. [number withheld]–[number withheld], [number withheld]). Es gibt keine Treatment-Information aus der Zeit nach [number withheld] und keine Neuberechnung aus Outcomes des Erweiterungsfensters.
- **Überlappung:** Die Prüfung umfasst [number withheld] Spalten × [number withheld] Zeilen, einschließlich `post`, `dose`, `rl1`–`rl3`, `b1`–`b3` und `n_breached`. Alle Spalten sind `equal = TRUE` mit maximaler Differenz [number withheld] (`t030_overlap_assert.csv`). Die Prüfung läuft dreimal: auf dem Panel, auf `ext` und auf der veröffentlichten CSV (Z. [number withheld], [number withheld], [number withheld]).
- **Keine Schätzungen:** Kein Skript in `code/` liest `panel_firm_halfyear_ext.csv`; die einzige Fundstelle ist der Schreibbefehl in `01b_extend.R:771`. In `01b_extend.R` gibt es keine Regressionen, Tests oder Konfidenzintervalle.
- **Pipeline:** `01b_extend.R` steht in `run_all.R:18` und `run_all.sh:6` direkt nach `01_clean.R` und vor allen Schätzskripten. Das Skript prüft vor und nach dem Schreiben per SHA-[number withheld], dass alle Rohdaten, das Hauptpanel und alle Outputs außer `t0[number withheld]_*` unverändert sind (Z. [number withheld]–[number withheld], [number withheld], [number withheld]).

## Abnahmekriterien

[number withheld]. **Hauptpanel und bisherige Outputs byte-identisch; Überlappungsprüfung bestanden: für meine Rolle belegt erfüllt.** Die Überlappungsprüfung ist in `t030_overlap_assert.csv` belegt (alle [number withheld] Spalten TRUE, Differenz [number withheld]). Die SHA-[number withheld]-Prüfung der vorhandenen Outputs innerhalb von [number withheld]b steht in Z. [number withheld]/[number withheld]. `t030_verification.txt` meldet in Z. [number withheld]: „all [number withheld] pre-existing outputs byte-identical to baseline“. Ein eigener Hash-Vergleich mit der Baseline war mir nicht möglich (siehe unten).
[number withheld]. **Zwei Läufe byte-identisch: nicht meine Rolle.** Im Code gibt es nur deterministische Operationen und einen festen Seed (Z. [number withheld]). Das Manifest in `t030_verification.txt` (Z. [number withheld] ff.) meldet identische Läufe; nachgerechnet habe ich das nicht.
[number withheld]. **RL1-Firmen je Datum; Wind-only-Firmen benannt: belegt erfüllt, soweit meine Rolle betroffen ist.** Die Tabelle im Bericht stimmt Zeile für Zeile mit der Spalte `n_rl1` in `t030_rl1_by_date.csv` überein. Ob die Wind-only-Zuordnung richtig ist, gehört zur Rolle `data`.
[number withheld]. **Keine Schätzungen: belegt erfüllt.** Siehe oben: Das Erweiterungspanel hat keinen Konsumenten unter den Schätzskripten, und es gibt nur Zählungen.

## Nicht geprüft

- Den SHA-[number withheld]-Abgleich der [number withheld] bisherigen Outputs mit der Baseline und den Vergleich der beiden Läufe konnte ich nicht selbst nachrechnen, weil die Shell in dieser Sitzung gesperrt ist. Ich stütze mich auf die Asserts im Skript und auf `t030_verification.txt`.
- Die Liste der Ausgabedateien außerhalb des Schreibbereichs (t0[number withheld]–t0[number withheld]), deren Änderungszeit neu ist, erklärt sich durch den vollständigen Neuaufbau mit `run_all.R`. Ob die Inhalte byte-identisch sind, konnte ich aus demselben Grund nicht nachrechnen.
- `state/STATE.md` hat sich seit Beginn der Ausführung geändert. Das ist eine Eingabe, kein Schreibziel der Karte; für die Schätzungen ist es nicht relevant, und ich habe es nicht bewertet.
- Datenaufbereitung (Item-Mapping, HK-Datumsregel, Attrition, Rundung von `dose_pre`), Coverage-Nenner, README und Sprache: nicht meine Rolle.
