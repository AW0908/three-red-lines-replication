## Ergebnis
Alle sieben Punkte der Karte sind in den Abschnitten 1–4.1 und 6 umgesetzt. Es gibt keine neuen Zahlen und keine neuen Literaturangaben, und der Build läuft sauber durch. **Abnahmekriterium 2 ist nicht erfüllt:** Der Haupttext endet mit einer Zeile auf Seite 16. Vor meinen Änderungen lief er schon um 8 Zeilen über. Seite 15 besteht jetzt nur noch aus Tabelle 6 und Abschnitt 7, und beide liegen außerhalb meines Schreibbereichs (Begründung unter „Offene Fragen“). Zum Ausgleich habe ich mehrere Sätze in den Abschnitten 1–3 und 6.5 ohne Inhaltsverlust gekürzt.

## Dateien
- `proposal/sections/01_introduction.tex` – Begriffe vereinheitlicht („compliant share“, „MI“), Satz zu den Politikfolgerungen ergänzt, drei Stellen gekürzt (Doppelzitat, zwei Wiederholungen)
- `proposal/sections/02_literature.tex` – Abschnitt beginnt mit dem ersten Literaturstrang; Suchverfahren und CNKI-Befund stehen jetzt im Schlussabsatz „How we searched“; leicht gekürzt
- `proposal/sections/03_framework.tex` – In 3.1 erklärt, warum oberhalb der Schwelle keine fehlende Masse sichtbar sein muss; ein Satz gestrichen, der in H3 wiederholt wird; H2-Satz gekürzt
- `proposal/sections/05_context_data.tex` – nur 4.1 neu geschrieben
- `proposal/sections/06_preliminary_analysis.tex` – nur der Trendabsatz in 6.2 und Abschnitt 6.5
- `review/T054_build/` – Build-Ausgabe

## Ausführung
`cd proposal && latexmk -interaction=nonstopmode -outdir=../review/T054_build main.tex`
[fenced excerpt withheld in public audit]
[fenced excerpt withheld in public audit]
Keine undefinierten Verweise und keine Zitier- oder Fehlermeldungen. Die einzige Warnung ist eine fehlende Kursivschrift für die chinesische Schrift im Anhang (`Font shape TU/SongtiSC(0)/m/it undefined`); sie bestand schon vorher.

## Abnahmekriterien
1. **Keine neuen Zahlen oder Literaturangaben; verschobene Zahlen unverändert und auf CSVs rückführbar – erfüllt.** Zahlen im neuen oder umformulierten Text:
   - 9.8, [4.7, 15.1], 5.6 (Intervall schließt null ein), 3.18 → 1.52 (Intervall über null), Bin-Trend-Intervall schließt null ein: `replication/outputs/tables/t043_trend_cf.csv` (level, 2019-12-31, firm_trend/bin_trend; D_trend −0.0980 [−0.1513, −0.0474], −0.0565 [−0.1190, 0.0095]; b_trend 1.522 [0.136, 3.336], 1.745 [−0.182, 3.346]; b_official_paired 3.18). Die Vorzeichen sind gegenüber D = gemeldet − Trend umgekehrt, weil der Text die Differenz als „höher als gemeldet“ formuliert; ein Kommentar im Text erklärt das.
   - 11.5 (Einleitung): `t029_compliance.csv`, unverändert.
   - „3 of 51“ (Abschnitt 2): `state/litsearch/screening.xlsx`, nur verschoben.
   - 0.70 sowie „all five specifications / placebo thresholds“ (6.5): `t043_delta_b.csv`, wie bisher in 6.1.
   - Messfehler-Variante (6.5): `t043_meas_error.csv` über `tables/t051_robustness.tex`.
   - Alle Zitierschlüssel gab es schon vorher; S&P Global China Ratings und China Securities Journal stehen unverändert als Fußnote ohne BibTeX-Eintrag.
2. **Haupttext endet spätestens auf Seite 15 – nicht erfüllt.**

   | Zeitpunkt | Ende Haupttext | Seitenanfänge (Abschnitte 1 / 2 / 3 / 4 / 5 / 6 / 7) |
   |---|---|---|
   | Vorher | Seite 16, 8 Zeilen | 1 / 2 / 3 / 5 / 7 / 9 / 15 |
   | Nachher | Seite 16, 1 Zeile | 1 / 2 / 3 / 5 / 7 / 9 / 15 |

   Wortzahlen je Datei (`wc -w`, Kommentare mitgezählt), vorher → nachher:

   | Datei | vorher | nachher |
   |---|---|---|
   | 01 | 656 | 663 |
   | 02 | 464 | 449 |
   | 03 | 747 | 775 |
   | 05 | 1132 | 1123 |
   | 06 | 1900 | 2006 |
   | 07 | 390 | 390 |

   Der Build selbst ist sauber.
3. **Je Punkt eine Zeile mit Datei:Zeile – erfüllt:**
   - P1: `05_context_data.tex:14` – 4.1 verweist für Schwellen und Obergrenzen auf Abschnitt 1. Neu sind: keine offiziellen Definitionen, Quellen in Fußnote (bisheriger geprüfter Wortlaut übernommen), unterschiedliche Firmendefinitionen mit Verweis auf 4.3, Stichtage. Kürzer als vorher.
   - P2: `02_literature.tex:5–20` – beginnt mit dem Focal Paper; „How we searched“ in Zeile 20 mit PRISMA-Abbildung, Abfragetabellen und dem Satz „3 of 51“.
   - P3: `03_framework.tex:20`.
   - P4: `06_preliminary_analysis.tex:46` – Ergebnis in Worten. $D_{\text{trend}}$ und $b_{\text{trend}}$ stehen nur noch in Tabelle 4.
   - P5: `01_introduction.tex:19` („compliant share“, „MI growth“), `02_literature.tex:18` („MI growth“), `06_preliminary_analysis.tex:46,115` („MI“, „firm trend“/„bin trend“; „bin-trend variant“ entfernt).
   - P6: `01_introduction.tex:19`, letzter Satz.
   - P7: `06_preliminary_analysis.tex:115` – Hauptgefahr je Befund und warum Befund 1 die prüfbaren Tests besteht; der Satz zur externen Validität bleibt inhaltlich erhalten, ist aber umformuliert.

## Offene Fragen
- **Seitenlimit (Entscheidung Co-PI):** Seite 14 ist voll (Text bis zur Fußzeile), und Tabelle 6 ([htbp]) passt dort nicht mehr hin. Seite 15 besteht damit nur aus Tabelle 6 und Abschnitt 7 mit `\Needspace{0.2\textheight}`. Kürzungen weiter vorn verpuffen in Leerräumen, die die Gleitobjekte an den Seitenenden 6, 7 und 12 erzeugen. Eine Zeile Überlauf bleibt.
  - Möglichkeiten außerhalb meines Schreibbereichs: Abschnitt 7 um eine Zeile kürzen, z. B. „rather than add many weakly documented ones“; Tabelle 6 kürzen (`tables/t049_threats.tex`); oder Abschnitt 6.3 bzw. 6.2 außerhalb des Trendabsatzes um etwa 3 Zeilen kürzen, damit 6.3 auf Seite 12 beginnt.
- **Punkt 5 nur teilweise umsetzbar:** Folgende Stellen konnte ich nicht ändern, weil sie außerhalb des Schreibbereichs liegen:
  - Abschnitt 5 (`04_empirical_model.tex:14,32,37,50`) schreibt mehrfach „minority interests“ aus.
  - In 6.2 heißt es außerhalb des Trendabsatzes noch „Minority interests make up…“ (Zeile 31).
  - Tabelle 6 nennt „mass-conserving fixed-point fit“, Abschnitt 5.1 „mass-conserving fixed-point checks“.
  - Die Tabellenzeilen heißen „firm-specific/bin-specific pre-policy trend“.

  Den Kernsatz „compliance … depends mechanically on minority-interest growth since 2019“ und die Überschrift von 6.2 habe ich bewusst nicht angepasst, weil `state/writing_rules.md` diesen Wortlaut vorschreibt.
- **Punkt 4, Wortlaut:** Statt „minority interests“ aus dem Vorschlagssatz der Karte steht „MI“, damit Punkt 5 eingehalten ist (MI in Abschnitt 6).
- **Punkt 1, Stichtage:** Keine Projektquelle sagt, an welchen Stichtagen die Aufsicht die Einhaltung prüft. Der Text sagt daher nur, dass wir an Halbjahres- und Jahresend-Stichtagen messen; dazu steht `% TODO(PI)` in `05_context_data.tex`. Weil die Abkürzung PBoC nirgends sonst vorkommt, steht dort jetzt „People's Bank of China … housing ministry“ ohne Abkürzung.
- **Für den Platz gestrichen:** Zwei Sätze habe ich wegen des Seitenlimits entfernt. Inhaltlich gehen sie nicht verloren, der Language-Review sollte die Streichungen aber bestätigen.
  - In der Einleitung: „Debt-like equity motivates the study, but its prevalence is not a quantified result.“ Absatz 4 sagt das weiter.
  - In 3.2: „Our balance-sheet data do not reveal κ.“ H3 sagt das weiter.
- **Git:** Ich habe `git log` nicht ausgeführt, weil die Worker-Regeln Git verbieten. Den geprüften Wortlaut und die Fußnote zu den Quellen habe ich aus dem aktuellen Text von 4.1 übernommen; er war dort noch vorhanden.
