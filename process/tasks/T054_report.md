## Ergebnis
Alle sieben Punkte der Karte sind in den Abschnitten [number withheld]–[number withheld] und [number withheld] umgesetzt. Es gibt keine neuen Zahlen und keine neuen Literaturangaben, und der Build läuft sauber durch. **Abnahmekriterium [number withheld] ist nicht erfüllt:** Der Haupttext endet mit einer Zeile auf Seite [number withheld]. Vor meinen Änderungen lief er schon um [number withheld] Zeilen über. Seite [number withheld] besteht jetzt nur noch aus Tabelle [number withheld] und Abschnitt [number withheld], und beide liegen außerhalb meines Schreibbereichs (Begründung unter „Offene Fragen“). Zum Ausgleich habe ich mehrere Sätze in den Abschnitten [number withheld]–[number withheld] und [number withheld] ohne Inhaltsverlust gekürzt.

## Dateien
- `proposal/sections/01_introduction.tex` – Begriffe vereinheitlicht („compliant share“, „MI“), Satz zu den Politikfolgerungen ergänzt, drei Stellen gekürzt (Doppelzitat, zwei Wiederholungen)
- `proposal/sections/02_literature.tex` – Abschnitt beginnt mit dem ersten Literaturstrang; Suchverfahren und CNKI-Befund stehen jetzt im Schlussabsatz „How we searched“; leicht gekürzt
- `proposal/sections/03_framework.tex` – In [number withheld] erklärt, warum oberhalb der Schwelle keine fehlende Masse sichtbar sein muss; ein Satz gestrichen, der in H3 wiederholt wird; H2-Satz gekürzt
- `proposal/sections/05_context_data.tex` – nur [number withheld] neu geschrieben
- `proposal/sections/06_preliminary_analysis.tex` – nur der Trendabsatz in [number withheld] und Abschnitt [number withheld]
- `review/T0[number withheld]_build/` – Build-Ausgabe

## Ausführung
`cd proposal && latexmk -interaction=nonstopmode -outdir=../review/T0[number withheld]_build main.tex`
[fenced excerpt withheld in public process copy]
[fenced excerpt withheld in public process copy]
Keine undefinierten Verweise und keine Zitier- oder Fehlermeldungen. Die einzige Warnung ist eine fehlende Kursivschrift für die chinesische Schrift im Anhang (`Font shape TU/SongtiSC([number withheld])/m/it undefined`); sie bestand schon vorher.

## Abnahmekriterien
[number withheld]. **Keine neuen Zahlen oder Literaturangaben; verschobene Zahlen unverändert und auf CSVs rückführbar – erfüllt.** Zahlen im neuen oder umformulierten Text:
   - [number withheld], [[number withheld], [number withheld]], [number withheld] (Intervall schließt null ein), [number withheld] → [number withheld] (Intervall über null), Bin-Trend-Intervall schließt null ein: `replication/outputs/tables/t043_trend_cf.csv` (level, 2019-12-31, firm_trend/bin_trend; D_trend [number withheld] [[number withheld], [number withheld]], [number withheld] [[number withheld], [number withheld]]; b_trend [number withheld] [[number withheld], [number withheld]], [number withheld] [[number withheld], [number withheld]]; b_official_paired [number withheld]). Die Vorzeichen sind gegenüber D = gemeldet − Trend umgekehrt, weil der Text die Differenz als „höher als gemeldet“ formuliert; ein Kommentar im Text erklärt das.
   - [number withheld] (Einleitung): `t029_compliance.csv`, unverändert.
   - „[number withheld] of [number withheld]“ (Abschnitt [number withheld]): `state/litsearch/screening.xlsx`, nur verschoben.
   - [number withheld] sowie „all five specifications / placebo thresholds“ ([number withheld]): `t043_delta_b.csv`, wie bisher in [number withheld].
   - Messfehler-Variante ([number withheld]): `t043_meas_error.csv` über `tables/t051_robustness.tex`.
   - Alle Zitierschlüssel gab es schon vorher; S&P Global China Ratings und China Securities Journal stehen unverändert als Fußnote ohne BibTeX-Eintrag.
[number withheld]. **Haupttext endet spätestens auf Seite [number withheld] – nicht erfüllt.**

   | Zeitpunkt | Ende Haupttext | Seitenanfänge (Abschnitte [number withheld] / [number withheld] / [number withheld] / [number withheld] / [number withheld] / [number withheld] / [number withheld]) |
   |---|---|---|
   | Vorher | Seite [number withheld], [number withheld] Zeilen | [number withheld] / [number withheld] / [number withheld] / [number withheld] / [number withheld] / [number withheld] / [number withheld] |
   | Nachher | Seite [number withheld], [number withheld] Zeile | [number withheld] / [number withheld] / [number withheld] / [number withheld] / [number withheld] / [number withheld] / [number withheld] |

   Wortzahlen je Datei (`wc -w`, Kommentare mitgezählt), vorher → nachher:

   | Datei | vorher | nachher |
   |---|---|---|
   | [number withheld] | [number withheld] | [number withheld] |
   | [number withheld] | [number withheld] | [number withheld] |
   | [number withheld] | [number withheld] | [number withheld] |
   | [number withheld] | [number withheld] | [number withheld] |
   | [number withheld] | [number withheld] | [number withheld] |
   | [number withheld] | [number withheld] | [number withheld] |

   Der Build selbst ist sauber.
[number withheld]. **Je Punkt eine Zeile mit Datei:Zeile – erfüllt:**
   - P1: `05_context_data.tex:14` – [number withheld] verweist für Schwellen und Obergrenzen auf Abschnitt [number withheld]. Neu sind: keine offiziellen Definitionen, Quellen in Fußnote (bisheriger geprüfter Wortlaut übernommen), unterschiedliche Firmendefinitionen mit Verweis auf [number withheld], Stichtage. Kürzer als vorher.
   - P2: `02_literature.tex:5–20` – beginnt mit dem Focal Paper; „How we searched“ in Zeile [number withheld] mit PRISMA-Abbildung, Abfragetabellen und dem Satz „[number withheld] of [number withheld]“.
   - P3: `03_framework.tex:20`.
   - P4: `06_preliminary_analysis.tex:46` – Ergebnis in Worten. $D_{\text{trend}}$ und $b_{\text{trend}}$ stehen nur noch in Tabelle [number withheld].
   - P5: `01_introduction.tex:19` („compliant share“, „MI growth“), `02_literature.tex:18` („MI growth“), `[number withheld]_preliminary_analysis.tex:[number withheld]` („MI“, „firm trend“/„bin trend“; „bin-trend variant“ entfernt).
   - P6: `01_introduction.tex:19`, letzter Satz.
   - P7: `06_preliminary_analysis.tex:115` – Hauptgefahr je Befund und warum Befund [number withheld] die prüfbaren Tests besteht; der Satz zur externen Validität bleibt inhaltlich erhalten, ist aber umformuliert.

## Offene Fragen
- **Seitenlimit (Entscheidung Co-PI):** Seite [number withheld] ist voll (Text bis zur Fußzeile), und Tabelle [number withheld] ([htbp]) passt dort nicht mehr hin. Seite [number withheld] besteht damit nur aus Tabelle [number withheld] und Abschnitt [number withheld] mit `\Needspace{[number withheld]\textheight}`. Kürzungen weiter vorn verpuffen in Leerräumen, die die Gleitobjekte an den Seitenenden [number withheld], [number withheld] und [number withheld] erzeugen. Eine Zeile Überlauf bleibt.
  - Möglichkeiten außerhalb meines Schreibbereichs: Abschnitt [number withheld] um eine Zeile kürzen, z. B. „rather than add many weakly documented ones“; Tabelle [number withheld] kürzen (`tables/t049_threats.tex`); oder Abschnitt [number withheld] bzw. [number withheld] außerhalb des Trendabsatzes um etwa [number withheld] Zeilen kürzen, damit [number withheld] auf Seite [number withheld] beginnt.
- **Punkt [number withheld] nur teilweise umsetzbar:** Folgende Stellen konnte ich nicht ändern, weil sie außerhalb des Schreibbereichs liegen:
  - Abschnitt [number withheld] (`[number withheld]_empirical_model.tex:[number withheld]`) schreibt mehrfach „minority interests“ aus.
  - In [number withheld] heißt es außerhalb des Trendabsatzes noch „Minority interests make up…“ (Zeile [number withheld]).
  - Tabelle [number withheld] nennt „mass-conserving fixed-point fit“, Abschnitt [number withheld] „mass-conserving fixed-point checks“.
  - Die Tabellenzeilen heißen „firm-specific/bin-specific pre-policy trend“.

  Den Kernsatz „compliance … depends mechanically on minority-interest growth since [number withheld]“ und die Überschrift von [number withheld] habe ich bewusst nicht angepasst, weil `state/writing_rules.md` diesen Wortlaut vorschreibt.
- **Punkt [number withheld], Wortlaut:** Statt „minority interests“ aus dem Vorschlagssatz der Karte steht „MI“, damit Punkt [number withheld] eingehalten ist (MI in Abschnitt [number withheld]).
- **Punkt [number withheld], Stichtage:** Keine Projektquelle sagt, an welchen Stichtagen die Aufsicht die Einhaltung prüft. Der Text sagt daher nur, dass wir an Halbjahres- und Jahresend-Stichtagen messen; dazu steht `% TODO(PI)` in `05_context_data.tex`. Weil die Abkürzung PBoC nirgends sonst vorkommt, steht dort jetzt „People's Bank of China … housing ministry“ ohne Abkürzung.
- **Für den Platz gestrichen:** Zwei Sätze habe ich wegen des Seitenlimits entfernt. Inhaltlich gehen sie nicht verloren, der Language-Review sollte die Streichungen aber bestätigen.
  - In der Einleitung: „Debt-like equity motivates the study, but its prevalence is not a quantified result.“ Absatz [number withheld] sagt das weiter.
  - In [number withheld]: „Our balance-sheet data do not reveal κ.“ H3 sagt das weiter.
- **Git:** Ich habe `git log` nicht ausgeführt, weil die Worker-Regeln Git verbieten. Den geprüften Wortlaut und die Fußnote zu den Quellen habe ich aus dem aktuellen Text von [number withheld] übernommen; er war dort noch vorhanden.
