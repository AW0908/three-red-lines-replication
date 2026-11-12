## Ergebnis

T048-Rework ist umgesetzt: Die NEF-Abbildung enthält die freigegebenen Aussagen, Finding 3 steht bei der Risikoannahme, und die Kapitalbezeichnung ist vereinheitlicht. Der vorgeschriebene lokale Vollbuild gelingt mit dem CJK-Fallback; der Haupttext umfasst 15 Seiten bei maximal 0,79266 pt Überbreite. Abbildung, betroffene Tabellen und chinesische Zeichen wurden im erzeugten PDF visuell geprüft.

## Dateien

- `proposal/main.tex` – ausschließlich die beiden freigegebenen CJK-Fontzeilen geändert.
- `proposal/figures/toc_nef.tex` – Schwarzweiß-Abbildung, belegter Kontext, Finding 3 im Annahmenkasten und gestrichelter letzter Pfeil mit „Not observed“.
- `proposal/sections/03_framework.tex` – Absatz, Einführung der Findings und Vorlesungsfußnote überarbeitet.
- `proposal/sections/05_context_data.tex` – zweites Auftreten im Absatz zu „0.99 points“ korrigiert.
- `proposal/sections/06_preliminary_analysis.tex` – Kapitalbegriff vereinheitlicht; Erlöschen des Shimao-Undertakings auf dessen listing-triggered component präzisiert.
- `proposal/sections/t045_crosser_shares.tex` – Kapitalbegriff auch in der Erläuterung der Bruttobeiträge vereinheitlicht.
- `proposal/appendix/results.tex` – Begleittext, Pilotabsatz, Vergleichstabelle und Outputverzeichnis sprachlich vereinheitlicht.
- Aus der ersten T048-Runde beibehalten und geprüft: `proposal/preamble.tex` (TikZ), `proposal/sections/01_introduction.tex` (points), `proposal/references.bib` (Large-Sample).
- `tasks/T048_report.md` – Ausführungsbericht.
- `review/T048_build/main.pdf` – erfolgreicher Gesamtbuild; zugehörige Builddateien: `main.aux`, `main.bbl`, `main.blg`, `main.fdb_latexmk`, `main.fls`, `main.log`, `main.out`, `main.toc`, `main.xdv`.
- `/tmp/t048_rework_build.log`, `/tmp/t048_rework_changes.diff`, `/tmp/T048_rework_before/` – Buildausgabe und Änderungsbelege.
- `/tmp/t048_rework_final_page3.png`, `/tmp/t048_rework_final_page29.png`, `/tmp/t048_rework_final_page33.png`, `/tmp/t048_rework_final_comparison.png`, `/tmp/t048_rework_final_cjk.png`, `/tmp/t048_rework_final_substance.png` – endgültige Sichtprüfungen.
- `/tmp/t048_rework_page3.png`, `/tmp/t048_rework_page13.png`, `/tmp/t048_rework_text.txt`, `/tmp/t048_rework_final_bbox.html`, `/tmp/t048_comparison_bbox.html` – Zwischenprüfung und Positionsbelege.

## Ausführung

Vorgeschriebenen Befehl selbst ausgeführt, Exitcode **0**:

[fenced excerpt withheld in public audit]
[fenced excerpt withheld in public audit]

Letzter Lauf mit identischem Befehl und Ausgabeumleitung nach `/tmp/t048_rework_build.log`. Letzte Ausgabezeilen:

[fenced excerpt withheld in public audit]
[fenced excerpt withheld in public audit]

Zusätzlich mit `pdftoppm`, `pdftotext` und `pdffonts` geprüft. STSongti-SC-Regular ist eingebettet; keine Ersatzschrift wurde über den Build-Aufruf eingeschleust.

## Abnahmekriterien

1. **Erfüllt: Abbildung.** Vollständig schwarzweiß einschließlich Zitat, 9-pt-Kastentext, auf Haupttextseite 3 visuell geprüft. Einschließlich Beschriftung und Note rund 234 PDF-Punkte beziehungsweise 0,34 der Satzspiegelhöhe, unter 0,45. Need, Aim und externer Faktor entsprechen Rework 1. Schwellen, Caps und Datum stehen im institutionellen Hintergrund; Anpassung und Gruppenkapital in Abschnitt 3; Vertrags- und Offenlegungsgrenzen in Finding 3. Hohe Verschuldung und „sector distress from 2021“ zusätzlich an der lokalen PDF von Fan und Guo (2026), S. 1–2, geprüft. Finding 3 steht ausschließlich bei der Risikoannahme; der letzte Pfeil ist gestrichelt und als nicht beobachtet gekennzeichnet.

2. **Erfüllt: Vollbuild und Layout.** 38 PDF-Seiten insgesamt; Haupttext endet auf gedruckter Seite **15**, References beginnen auf Seite **16**. Eine Overfull-hbox mit **0,79266 pt**, keine über 2 pt. Keine undefinierten Verweise/Zitate und keine „Missing character“-Meldungen. Belege: `review/T048_build/main.log` und `main.pdf`.

3. **Erfüllt: Absatzbudget und Quellenfußnote.** Neuer Absatz: **92 Wörter**, Fußnote **21**, zusammen **113** nach TeX-Wortzählung; Verweise/Zitate jeweils ein Token. Folien 23–26 gelesen. Mangels publizierter Referenz auf den Folien wird die Vorlesung zitiert; Dozentenname am Syllabus geprüft, Kurstitel kursiv.

4. **Erfüllt: sämtliche Sprachpunkte einzeln geprüft.**

| Punkt | Umsetzung/Beleg |
|---|---|
| Percentage points je Absatz | Einleitung: „9.8 points“; Validierungsabsatz: zweites Auftreten „0.99 points“. Abstract, Abschnitt 6 und Schluss geprüft. |
| Mr. Hui einführen | Übertragung des Undertakings beschreibt seine Beziehung zum Fall; keine unbelegte Vorsitzendenrolle ergänzt. Aussagen L278–L279 und Originalmitteilung S. 2–3 geprüft. |
| Erlöschen des Undertakings | „its listing-triggered component terminates and lapses if Shimao Services achieves its listing“. |
| Hängendes „showing“ | Eigener Satz „This shows substantial paid-in backing …“. |
| Messfehler | „Mean measurement error accounts for … across …“. |
| horizon-by-anchor | Beibehalten und geprüft. |
| Large-Sample | Bindestrich im BibTeX-Titel geprüft; keine weitere Bib-Änderung. |
| Call-Klausel | „If the call is not exercised, the investor may demand …“; gegen Fallnotizen L54–L55 geprüft, Rechte und Einschränkungen unverändert. |
| Rongan | „list affiliates of its controller as partners“. |
| Kapitalbegriff | „capital from minority shareholders“ an sämtlichen benannten Stellen, einschließlich Pilotabsatz, Tabellenkopf und Outputverzeichnis. Explizite sprachliche Ausnahme: „no documented D/G/H/E payment from minority shareholders“. |
| `t044_magnitude.tex` | Laut `main.fls` nicht eingebunden; entsprechend der bedingten Vorgabe unverändert. |
| Wind | Erste Erwähnung erklärt den Terminal als chinesischen Finanzdatendienst. |
| Findings und Verben | „the three preliminary findings (Section …)“, „examines“, „None of the findings“ und „the data do not cover the long-term aim“. |
| Prozentzeichen | Tabellen weiterhin `\%`, Prosa „percent“, entsprechend `state/writing_rules.md`. |

5. **Erfüllt: Zahlenquellen.** Keine empirischen Werte geändert. Die numerischen Tokenfolgen der in diesem Rework bearbeiteten bestehenden Dateien 05, 06, t045 und Appendix stimmen mit dem Eingang überein.

| Zahlen im neuen beziehungsweise sprachlich geänderten Text | Quelle |
|---|---|
| Findings 1–3; Abschnitts-/Abbildungsnummern; Lectures 5–6, slides 25–26 | Strukturelle Verweise beziehungsweise gelesene Vorlesungsdatei. |
| Drei Schwellen; January 1, 2021 | Bestehender institutioneller Absatz, PI-verifiziert mit `jin2025deleveraging`. |
| Sector distress from 2021; Fan/Guo 2026 | `literature/04_systematic_search/L002_Fan_2026.pdf`, S. 1–2. |
| 9.8 points | `replication/outputs/tables/t043_trend_cf.csv`. |
| 64/30; 2020–2021; 52; 0.60/0.80; 0.57; 76.9; 6; 0.70; 0.99 | `replication/outputs/tables/t040_validation.csv`. |
| 86/40 Prozent; 64/52 Paare | `replication/outputs/tables/t043_meas_error.csv`. |
| 79.5/96.6/80.8 Prozent; 109/33/48 Firmenjahre; 2019–2021/2020–2021 | `replication/outputs/tables/t046_cash_backing_all.csv`. |
| Tabelle 3: D=4, D1=1, D2=2, unspecified=1; G/H/E=5/0/1; U=239; 32 ausgeschlossen; 0.4/190.5 Mrd.; 0.2 Prozent; 33/31; 20 von 33 | `replication/outputs/tables/t047_coding.csv`, `t047_magnitude.csv`; Cash/MI-Zeile aus `t046_cash_backing_all.csv`. |
| Alle t045-Anteile/Firmencodes; 100 Prozent in der Note | `replication/outputs/tables/t047_magnitude.csv`; Tabellenwerte unverändert. |
| Pilot: 117/107; neun Firmen; 108.3/3.5/104.8 Mrd.; 3.2/65.5 Prozent | `replication/outputs/tables/t044_pilot_coding.csv`, `t044_attribution_totals.csv`, `t044_magnitude.csv`. |
| Vergleichstabelle: Firmencodes; Zählwerte 0/1/2/3/4/27/29; 0.0/65.5 Prozent; zwei D, davon eine D2 | `replication/outputs/tables/t044_pilot_coding.csv`, `t044_magnitude.csv`; nur Kopf/Note sprachlich geändert. |

## Offene Fragen

- Overleaf wurde nicht aufgerufen; der Noto-Zweig wurde dort nicht praktisch getestet. Lokal funktioniert der freigegebene Songti-Fallback einschließlich chinesischer Ausgabe.
- Die bestehende Warnung `Object @table.18 already defined` bleibt. Sie verhindert den Build nicht; die Tabellen-/Hyperlink-Infrastruktur wurde nicht verändert.
- Kein unabhängiges Review, Netzwerkzugriff oder Git/Overleaf-Abgleich durchgeführt. Kartenstatus unverändert; keine neuen Analysen oder Datenänderungen.
- Vorschlag für `AI_USAGE_LOG.md` außerhalb des Schreibbereichs: „2026-10-30, Codex, T048 Rework: NEF-Abbildung und Sprachpunkte nach Review korrigiert, Quellenstellen lokal geprüft, CJK-Fallback ergänzt; Vollbuild und PDF-Sichtprüfung erfolgreich (15 Haupttextseiten).“