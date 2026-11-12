## Rolle: consistency (claude, sonnet) – VERDICT: PASS


## Befunde

Keine inhaltlichen Inkonsistenzen zwischen Outputs, Abbildungen und Text gefunden. Zwei kleine Hinweise ohne Auswirkung auf das Urteil:

1. `proposal/appendix/results.tex`: Die Quellkommentare über den Abbildungen nennen teils noch die alten PDFs, z. B. `% source: replication/outputs/figures/t066_pretrends.pdf (page 1)` vor `f_pretrends`. Das sind nur Kommentare, kein Satztext. Die Zeile `% source: ...t066_drdid.csv (T072 rendering)` steht direkt darunter und ist korrekt.
2. Die Note zu `fig:t061_control` erwähnt die gepunktete graue Fit-Linie und die grauen Balken nicht. Beides ist über die gemeinsame Legende (Observed / Fit) im Bild selbst erklärt. Das ist akzeptabel.

## Abnahmekriterien

**Rework 1 (Note zu `f_pretrends`, B20–B24): belegt erfüllt.**
- Der Satz „Mechanical contrasts are omitted“ ist in allen fünf Notes entfernt (`results.tex` Z. 454, 462, 470, 478, 486). Das passt zu `t066_placebo_audit.csv`: Alle Zeilen haben `mechanical=FALSE`, und `count_in_intervals` ist durchgehend `TRUE`.
- Die Valid-Draw-Spannen in den Notes stimmen mit der Spalte `valid` in `t066_drdid.csv` (Zeilen `pre_*`) überein:

| Abbildung | Spanne in der Note | Spanne in `t066_drdid.csv` |
|---|---|---|
| A_control | 998–999 | 998–999 |
| all_control | 999–999 | 999 |
| A_control_no_suppliers | 948–998 | 948…998 |
| all_control_no_suppliers | 985–999 | 985…999 |
| private_SOE | 0–827 | 0 (2018-12-31) bis 827 |

**Rework 2 (Note zu `fig:bunching_date`): belegt erfüllt.**
- Die Note sagt „Controls (grey, right axis; all control firms): observed share in the same window“.
- Die Population `control_all` in `t063_by_date.csv` ist belegt. Der Code (`24_figures.R` Z. 94–96) nutzt `group=='control_all'` und `share_below`. Die Kopfzeile der CSV bestätigt `mass_below` = [0.66, 0.70), also „same window“.
- Der Halbsatz erklärt zugleich, dass keine Kontroll-Ratio und keine CIs gespeichert sind. Das deckt sich mit dem Fallback der Karte.
- Der Text in Abschnitt 06 („control stays broadly flat“) passt zur Grafik: Die Kontrollreihe liegt bei etwa 3,3–5,6 %.
- Das Datum „August 20“ steht in `05_context_data.tex` Z. 19. Die Schattierung von 2020-08-20 bis 2021-01-01 entspricht der Note.

**Rework 3 (`f_control_density`): belegt erfüllt.**
- Das PDF zeigt eine einzige Legende („Observed / Fit“) unter beiden Panels.
- Beide Panels haben identische y-Achsen (0–0,025). Im Code `control_ylim<-range(c(0,control_density$share,control_density$fitshare))` (Z. 180), angewendet auf beide Panels (Z. 183).
- Die Caption in `results.tex` Z. 96 („Shares of all finite firm-half-years per 0.01 bin … dashed line marks 0.70“) passt zur Grafik: gestrichelte Linie bei 0,70, Schattierung [0.66, 0.70).
- Das Audit nennt für die Grafik 11,3 pt Mindestschrift, 6,5 × 3,6 in.

**Rework 4 (Neulauf, Guards, Audit, Build): teilweise belegt, siehe „Nicht geprüft“.**
- `t072_figure_audit.csv` hat die 34 Seitenzeilen, die der Bericht nennt. Das Minimum der gedruckten Schrift liegt bei 9,257 pt. Ausgenommen sind PRISMA (4,73 pt, als `unchanged_diagram` ausgewiesen) und ToC-NEF.
- `review/T072_latex.txt` meldet fehlerfreie Übersetzung.
- Die Angabe „Hauptteil endet auf Seite 15“ ist für meine Rolle nicht prüfbar.

**Übrige Kriterien der Karte (Byte-Identität, Rekonstruktion, Schriftgrößen, Layout):** nicht meine Rolle bzw. nicht prüfbar.

## Nicht geprüft

- Ich konnte keine Befehle ausführen (Bash verweigert). Daher habe ich `t072_verification.csv` und `t072_reproducibility.csv` nicht gelesen und die Byte-Identität nicht selbst verifiziert. Ich habe auch nicht nachgezählt, dass der Haupttext auf Seite 15 endet.
- Die übrigen neuen Grafiken und Tabellenzahlen (Spec-Kurve, Dekomposition, κ, Overlap usw.) habe ich nicht Zahl für Zahl gegen ihre CSVs geprüft. Sie liegen außerhalb der vier Rework-Punkte, und die Karte verlangt nur diese.
- Ob die Grafikinhalte die CSV-Werte exakt wiedergeben, belegt nur der Plot-Hash im Audit. Ich habe die Hashes nicht neu berechnet.
