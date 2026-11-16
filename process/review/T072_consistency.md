## Rolle: consistency (claude, sonnet) – VERDICT: PASS


## Befunde

Keine inhaltlichen Inkonsistenzen zwischen Outputs, Abbildungen und Text gefunden. Zwei kleine Hinweise ohne Auswirkung auf das Urteil:

[number withheld]. `proposal/appendix/results.tex`: Die Quellkommentare über den Abbildungen nennen teils noch die alten PDFs, z. B. `% source: replication/outputs/figures/t066_pretrends.pdf (page 1)` vor `f_pretrends`. Das sind nur Kommentare, kein Satztext. Die Zeile `% source: ...t066_drdid.csv (T072 rendering)` steht direkt darunter und ist korrekt.
[number withheld]. Die Note zu `fig:t0[number withheld]_control` erwähnt die gepunktete graue Fit-Linie und die grauen Balken nicht. Beides ist über die gemeinsame Legende (Observed / Fit) im Bild selbst erklärt. Das ist akzeptabel.

## Abnahmekriterien

**Rework [number withheld] (Note zu `f_pretrends`, B2[number withheld]–B2[number withheld]): belegt erfüllt.**
- Der Satz „Mechanical contrasts are omitted“ ist in allen fünf Notes entfernt (`results.tex` Z. [number withheld], [number withheld], [number withheld], [number withheld], [number withheld]). Das passt zu `t066_placebo_audit.csv`: Alle Zeilen haben `mechanical=FALSE`, und `count_in_intervals` ist durchgehend `TRUE`.
- Die Valid-Draw-Spannen in den Notes stimmen mit der Spalte `valid` in `t066_drdid.csv` (Zeilen `pre_*`) überein:

| Abbildung | Spanne in der Note | Spanne in `t066_drdid.csv` |
|---|---|---|
| A_control | [number withheld]–[number withheld] | [number withheld]–[number withheld] |
| all_control | [number withheld]–[number withheld] | [number withheld] |
| A_control_no_suppliers | [number withheld]–[number withheld] | [number withheld]…[number withheld] |
| all_control_no_suppliers | [number withheld]–[number withheld] | [number withheld]…[number withheld] |
| private_SOE | [number withheld]–[number withheld] | [number withheld] (2018-12-31) bis [number withheld] |

**Rework [number withheld] (Note zu `fig:bunching_date`): belegt erfüllt.**
- Die Note sagt „Controls (grey, right axis; all control firms): observed share in the same window“.
- Die Population `control_all` in `t063_by_date.csv` ist belegt. Der Code (`24_figures.R` Z. [number withheld]–[number withheld]) nutzt `group=='control_all'` und `share_below`. Die Kopfzeile der CSV bestätigt `mass_below` = [[number withheld], [number withheld]), also „same window“.
- Der Halbsatz erklärt zugleich, dass keine Kontroll-Ratio und keine CIs gespeichert sind. Das deckt sich mit dem Fallback der Karte.
- Der Text in Abschnitt [number withheld] („control stays broadly flat“) passt zur Grafik: Die Kontrollreihe liegt bei etwa [number withheld]–[number withheld] %.
- Das Datum „August [number withheld]“ steht in `05_context_data.tex` Z. [number withheld]. Die Schattierung von 2020-08-20 bis 2021-01-01 entspricht der Note.

**Rework [number withheld] (`f_control_density`): belegt erfüllt.**
- Das PDF zeigt eine einzige Legende („Observed / Fit“) unter beiden Panels.
- Beide Panels haben identische y-Achsen ([number withheld]–[number withheld]). Im Code `control_ylim<-range(c([number withheld],control_density$share,control_density$fitshare))` (Z. [number withheld]), angewendet auf beide Panels (Z. [number withheld]).
- Die Caption in `results.tex` Z. [number withheld] („Shares of all finite firm-half-years per [number withheld] bin … dashed line marks [number withheld]“) passt zur Grafik: gestrichelte Linie bei [number withheld], Schattierung [[number withheld], [number withheld]).
- Das Audit nennt für die Grafik [number withheld] pt Mindestschrift, [number withheld] × [number withheld] in.

**Rework [number withheld] (Neulauf, Guards, Audit, Build): teilweise belegt, siehe „Nicht geprüft“.**
- `t072_figure_audit.csv` hat die [number withheld] Seitenzeilen, die der Bericht nennt. Das Minimum der gedruckten Schrift liegt bei [number withheld] pt. Ausgenommen sind PRISMA ([number withheld] pt, als `unchanged_diagram` ausgewiesen) und ToC-NEF.
- `review/T072_latex.txt` meldet fehlerfreie Übersetzung.
- Die Angabe „Hauptteil endet auf Seite [number withheld]“ ist für meine Rolle nicht prüfbar.

**Übrige Kriterien der Karte (Byte-Identität, Rekonstruktion, Schriftgrößen, Layout):** nicht meine Rolle bzw. nicht prüfbar.

## Nicht geprüft

- Ich konnte keine Befehle ausführen (Bash verweigert). Daher habe ich `t072_verification.csv` und `t072_reproducibility.csv` nicht gelesen und die Byte-Identität nicht selbst verifiziert. Ich habe auch nicht nachgezählt, dass der Haupttext auf Seite [number withheld] endet.
- Die übrigen neuen Grafiken und Tabellenzahlen (Spec-Kurve, Dekomposition, κ, Overlap usw.) habe ich nicht Zahl für Zahl gegen ihre CSVs geprüft. Sie liegen außerhalb der vier Rework-Punkte, und die Karte verlangt nur diese.
- Ob die Grafikinhalte die CSV-Werte exakt wiedergeben, belegt nur der Plot-Hash im Audit. Ich habe die Hashes nicht neu berechnet.
