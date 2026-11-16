## Ergebnis
Ich habe `proposal/theory_note.tex` nach `review/T034.md` und der Co-PI-Korrektur in der Karte überarbeitet. Beide Herleitungen, die laut Korrektur korrekt waren, sind unverändert: κ mit L = R₀ − d − ([number withheld]−κ)e und die Pufferstatik mit sign(dδ*/dσ) = sign((δ*/σ)² − [number withheld]). Im Puffer-Remark, in Tabellennote b und im Appendix B (zweiter Punkt) gelten die Puffer-Vorhersagen jetzt nur unter Bedingungen. Note g nennt eine Größenbedingung für das kontrafaktische Bunching bei eingefrorenen Minderheitsanteilen (MI). Note a enthält keine kanalspezifischen Vorzeichen ohne Zusatzannahme mehr. Der Abschnitt heißt jetzt „Tests run and planned“ und führt T033 als geplant. Alle Sprachkorrekturen sind übernommen. **Nicht kompiliert:** In dieser Sitzung hatte ich keine Shell.

## Dateien
- `proposal/theory_note.tex` – Rework nach dem Prüfbericht (einzige geänderte Datei; neuer Revisionskommentar im Kopf)

## Ausführung
Keine Ausführung. Ich hatte kein Shell-Werkzeug und konnte den Befehl `cd proposal && latexmk -pdf -interaction=nonstopmode -outdir=../review/T0[number withheld]_build theory_note.tex; cd ..` nicht selbst starten. Laut Karte kompiliert ohnehin der PI (Kriterium [number withheld]).

## Abnahmekriterien
[number withheld]. **Propositionen und Umbenennung – erfüllt (unverändert).** Annahmen, Algebra und Beweise habe ich nicht angefasst. Neue Textstellen verwenden nur d/e, α_d/α_e und κ.
[number withheld]. **κ- und Puffer-Remark – erfüllt nach Co-PI-Korrektur (a)/(b):**
   - Die κ-Gleichung L = τ + κe* bleibt.
   - Puffer: Der Bezug von „drawn“ ist jetzt eindeutig („ε is realized after the target is chosen“).
   - Bei σ > [number withheld] gibt es keinen Massepunkt; die Ratios konzentrieren sich um τ − δ* mit Streuung σ.
   - Excess Mass im Fenster setzt voraus, dass σ und δ* klein gegenüber der Fensterbreite sind.
   - Für Φ(−δ*/σ) unter dem Vergleichswert [number withheld]/[number withheld] heißt es nur noch „consistent with persistence“ und ausdrücklich nicht „fewer reversals than before the policy“.
   - Tabelle (Zeile Targeting, Note b) und Appendix B sind daran angepasst.
[number withheld]. **Testtabelle – erfüllt:**
   - Zeile Composition/P3: „weakens, to the extent that the minority-interest part of e moves firms out of the window“.
   - Note g ergänzt um die Größenbedingung und das Gegenbeispiel [number withheld] → [number withheld].
   - Note a: Vorzeichen für `mi_share`/`jv_ta` nur mit der Zusatzannahme zum Kanal (Verweis auf Appendix B, vierter Punkt).
   - Abschnitt, Caption und Einleitung sprechen von „run and planned“; Zeile Substance: „T032; T033 planned“ (T033 hat Status APPROVED).
   - Keine neuen empirischen Schätzwerte.
[number withheld]. **Kompilierung – nicht geprüft** (PI-Schritt, kein Shell-Zugang).

Sprachkorrekturen (Befunde [number withheld]–[number withheld]):
- Research-Question-Satz und „a simple model“ ersetzt.
- „equity contributed by a joint-venture partner“.
- Einheitlich „buyback“ und „partialed out“.
- Discussion-Satz zu „one ratio“ nach Vorschlag umgeschrieben.
- Die zwei Umformulierungen im Puffer-Remark übernommen.

Zahlen im neuen Text:
- `[[number withheld])` (Note b): RL1-Fenster, `% source: replication/outputs/tables/t029_counterfactual_bunching.csv` (window_lower = [number withheld], exclusion_upper = [number withheld], specification main).
- `[number withheld]`, `[number withheld]`, `[number withheld]` (Note g): illustrativ, so im Kommentar gekennzeichnet (Gegenbeispiel aus review/T034.md).
- `[number withheld]/[number withheld]`, `Φ([number withheld])`: modellinterne Konstanten, keine Daten.

## Offene Fragen
- **Seitenlimit (≤ [number withheld] Seiten Haupttext inkl. Tabelle) nicht geprüft.** Im alten Build stand die Tabelle auf S. [number withheld], die Beweise begannen auf S. [number withheld]. Netto sind etwa [number withheld]–[number withheld] Zeilen hinzugekommen (Puffer-Remark, Notes a/b/g, Appendix-Punkt liegt außerhalb des Haupttexts). Falls das Limit überschritten wird, lässt sich zuerst Note h oder Remark [number withheld] (Benchmark) kürzen. Ebenso offen: „Float too large“ oder Overfull hbox durch die längeren Tabellennoten.
- Die Fenstergrenzen [[number withheld]) erscheinen jetzt erstmals als Zahl in der Note. Die Karte nennt sie in Fix [number withheld] ausdrücklich; vorher galt „keine Zahlen außer illustrativen“. Ich behandle sie als Designparameter mit Quellkommentar.
- Die gemeldeten Änderungen an `proposal/appendix/results.tex` und `06_preliminary_analysis.tex` stammen nicht von T034, sondern aus der parallelen Karte T036.
