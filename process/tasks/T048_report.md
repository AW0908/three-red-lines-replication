## Ergebnis

T048-Rework ist umgesetzt: Die NEF-Abbildung enthält die freigegebenen Aussagen, Finding [number withheld] steht bei der Risikoannahme, und die Kapitalbezeichnung ist vereinheitlicht. Der vorgeschriebene lokale Vollbuild gelingt mit dem CJK-Fallback; der Haupttext umfasst [number withheld] Seiten bei maximal [number withheld] pt Überbreite. Abbildung, betroffene Tabellen und chinesische Zeichen wurden im erzeugten PDF visuell geprüft.

## Dateien

- `proposal/main.tex` – ausschließlich die beiden freigegebenen CJK-Fontzeilen geändert.
- `proposal/figures/toc_nef.tex` – Schwarzweiß-Abbildung, belegter Kontext, Finding [number withheld] im Annahmenkasten und gestrichelter letzter Pfeil mit „Not observed“.
- `proposal/sections/03_framework.tex` – Absatz, Einführung der Findings und Vorlesungsfußnote überarbeitet.
- `proposal/sections/05_context_data.tex` – zweites Auftreten im Absatz zu „[number withheld] points“ korrigiert.
- `proposal/sections/06_preliminary_analysis.tex` – Kapitalbegriff vereinheitlicht; Erlöschen des Shimao-Undertakings auf dessen listing-triggered component präzisiert.
- `proposal/sections/t045_crosser_shares.tex` – Kapitalbegriff auch in der Erläuterung der Bruttobeiträge vereinheitlicht.
- `proposal/appendix/results.tex` – Begleittext, Pilotabsatz, Vergleichstabelle und Outputverzeichnis sprachlich vereinheitlicht.
- Aus der ersten T048-Runde beibehalten und geprüft: `proposal/preamble.tex` (TikZ), `proposal/sections/01_introduction.tex` (points), `proposal/references.bib` (Large-Sample).
- `tasks/T048_report.md` – Ausführungsbericht.
- `review/T048_build/main.pdf` – erfolgreicher Gesamtbuild; zugehörige Builddateien: `main.aux`, `main.bbl`, `main.blg`, `main.fdb_latexmk`, `main.fls`, `main.log`, `main.out`, `main.toc`, `main.xdv`.
- `/tmp/t048_rework_build.log`, `/tmp/t0[number withheld]_rework_changes.diff`, `/tmp/T0[number withheld]_rework_before/` – Buildausgabe und Änderungsbelege.
- `/tmp/t048_rework_final_page3.png`, `/tmp/t048_rework_final_page29.png`, `/tmp/t048_rework_final_page33.png`, `/tmp/t048_rework_final_comparison.png`, `/tmp/t048_rework_final_cjk.png`, `/tmp/t048_rework_final_substance.png` – endgültige Sichtprüfungen.
- `/tmp/t048_rework_page3.png`, `/tmp/t048_rework_page13.png`, `/tmp/t048_rework_text.txt`, `/tmp/t0[number withheld]_rework_final_bbox.html`, `/tmp/t0[number withheld]_comparison_bbox.html` – Zwischenprüfung und Positionsbelege.

## Ausführung

Vorgeschriebenen Befehl selbst ausgeführt, Exitcode **[number withheld]**:

[fenced excerpt withheld in public process copy]
[fenced excerpt withheld in public process copy]

Letzter Lauf mit identischem Befehl und Ausgabeumleitung nach `/tmp/t048_rework_build.log`. Letzte Ausgabezeilen:

[fenced excerpt withheld in public process copy]
[fenced excerpt withheld in public process copy]

Zusätzlich mit `pdftoppm`, `pdftotext` und `pdffonts` geprüft. STSongti-SC-Regular ist eingebettet; keine Ersatzschrift wurde über den Build-Aufruf eingeschleust.

## Abnahmekriterien

[number withheld]. **Erfüllt: Abbildung.** Vollständig schwarzweiß einschließlich Zitat, [number withheld]-pt-Kastentext, auf Haupttextseite [number withheld] visuell geprüft. Einschließlich Beschriftung und Note rund [number withheld] PDF-Punkte beziehungsweise [number withheld] der Satzspiegelhöhe, unter [number withheld]. Need, Aim und externer Faktor entsprechen Rework [number withheld]. Schwellen, Caps und Datum stehen im institutionellen Hintergrund; Anpassung und Gruppenkapital in Abschnitt [number withheld]; Vertrags- und Offenlegungsgrenzen in Finding [number withheld]. Hohe Verschuldung und „sector distress from [number withheld]“ zusätzlich an der lokalen PDF von Fan und Guo ([number withheld]), S. [number withheld]–[number withheld], geprüft. Finding [number withheld] steht ausschließlich bei der Risikoannahme; der letzte Pfeil ist gestrichelt und als nicht beobachtet gekennzeichnet.

[number withheld]. **Erfüllt: Vollbuild und Layout.** [number withheld] PDF-Seiten insgesamt; Haupttext endet auf gedruckter Seite **[number withheld]**, References beginnen auf Seite **[number withheld]**. Eine Overfull-hbox mit **[number withheld] pt**, keine über [number withheld] pt. Keine undefinierten Verweise/Zitate und keine „Missing character“-Meldungen. Belege: `review/T048_build/main.log` und `main.pdf`.

[number withheld]. **Erfüllt: Absatzbudget und Quellenfußnote.** Neuer Absatz: **[number withheld] Wörter**, Fußnote **[number withheld]**, zusammen **[number withheld]** nach TeX-Wortzählung; Verweise/Zitate jeweils ein Token. Folien [number withheld]–[number withheld] gelesen. Mangels publizierter Referenz auf den Folien wird die Vorlesung zitiert; Dozentenname am Syllabus geprüft, Kurstitel kursiv.

[number withheld]. **Erfüllt: sämtliche Sprachpunkte einzeln geprüft.**

| Punkt | Umsetzung/Beleg |
|---|---|
| Percentage points je Absatz | Einleitung: „[number withheld] points“; Validierungsabsatz: zweites Auftreten „[number withheld] points“. Abstract, Abschnitt [number withheld] und Schluss geprüft. |
| Mr. Hui einführen | Übertragung des Undertakings beschreibt seine Beziehung zum Fall; keine unbelegte Vorsitzendenrolle ergänzt. Aussagen L2[number withheld]–L2[number withheld] und Originalmitteilung S. [number withheld]–[number withheld] geprüft. |
| Erlöschen des Undertakings | „its listing-triggered component terminates and lapses if Shimao Services achieves its listing“. |
| Hängendes „showing“ | Eigener Satz „This shows substantial paid-in backing …“. |
| Messfehler | „Mean measurement error accounts for … across …“. |
| horizon-by-anchor | Beibehalten und geprüft. |
| Large-Sample | Bindestrich im BibTeX-Titel geprüft; keine weitere Bib-Änderung. |
| Call-Klausel | „If the call is not exercised, the investor may demand …“; gegen Fallnotizen L5[number withheld]–L5[number withheld] geprüft, Rechte und Einschränkungen unverändert. |
| Rongan | „list affiliates of its controller as partners“. |
| Kapitalbegriff | „capital from minority shareholders“ an sämtlichen benannten Stellen, einschließlich Pilotabsatz, Tabellenkopf und Outputverzeichnis. Explizite sprachliche Ausnahme: „no documented D/G/H/E payment from minority shareholders“. |
| `t044_magnitude.tex` | Laut `main.fls` nicht eingebunden; entsprechend der bedingten Vorgabe unverändert. |
| Wind | Erste Erwähnung erklärt den Terminal als chinesischen Finanzdatendienst. |
| Findings und Verben | „the three preliminary findings (Section …)“, „examines“, „None of the findings“ und „the data do not cover the long-term aim“. |
| Prozentzeichen | Tabellen weiterhin `\%`, Prosa „percent“, entsprechend `state/writing_rules.md`. |

[number withheld]. **Erfüllt: Zahlenquellen.** Keine empirischen Werte geändert. Die numerischen Tokenfolgen der in diesem Rework bearbeiteten bestehenden Dateien [number withheld], [number withheld], t0[number withheld] und Appendix stimmen mit dem Eingang überein.

| Zahlen im neuen beziehungsweise sprachlich geänderten Text | Quelle |
|---|---|
| Findings [number withheld]–[number withheld]; Abschnitts-/Abbildungsnummern; Lectures [number withheld]–[number withheld], slides [number withheld]–[number withheld] | Strukturelle Verweise beziehungsweise gelesene Vorlesungsdatei. |
| Drei Schwellen; January [number withheld], [number withheld] | Bestehender institutioneller Absatz, PI-verifiziert mit `jin2[number withheld]deleveraging`. |
| Sector distress from [number withheld]; Fan/Guo [number withheld] | `literature/04_systematic_search/L002_Fan_2026.pdf`, S. [number withheld]–[number withheld]. |
| [number withheld] points | `replication/outputs/tables/t043_trend_cf.csv`. |
| [number withheld]/[number withheld]; [number withheld]–[number withheld]; [number withheld]; [number withheld]/[number withheld]; [number withheld]; [number withheld]; [number withheld]; [number withheld]; [number withheld] | `replication/outputs/tables/t040_validation.csv`. |
| [number withheld]/[number withheld] Prozent; [number withheld]/[number withheld] Paare | `replication/outputs/tables/t043_meas_error.csv`. |
| [number withheld]/[number withheld]/[number withheld] Prozent; [number withheld]/[number withheld]/[number withheld] Firmenjahre; [number withheld]–[number withheld]/[number withheld]–[number withheld] | `replication/outputs/tables/t046_cash_backing_all.csv`. |
| Tabelle [number withheld]: D=[number withheld], D1=[number withheld], D2=[number withheld], unspecified=[number withheld]; G/H/E=[number withheld]/[number withheld]/[number withheld]; U=[number withheld]; [number withheld] ausgeschlossen; [number withheld]/[number withheld] Mrd.; [number withheld] Prozent; [number withheld]/[number withheld]; [number withheld] von [number withheld] | `replication/outputs/tables/t047_coding.csv`, `t047_magnitude.csv`; Cash/MI-Zeile aus `t046_cash_backing_all.csv`. |
| Alle t0[number withheld]-Anteile/Firmencodes; [number withheld] Prozent in der Note | `replication/outputs/tables/t047_magnitude.csv`; Tabellenwerte unverändert. |
| Pilot: [number withheld]/[number withheld]; neun Firmen; [number withheld]/[number withheld]/[number withheld] Mrd.; [number withheld]/[number withheld] Prozent | `replication/outputs/tables/t044_pilot_coding.csv`, `t044_attribution_totals.csv`, `t044_magnitude.csv`. |
| Vergleichstabelle: Firmencodes; Zählwerte [number withheld]/[number withheld]/[number withheld]/[number withheld]/[number withheld]/[number withheld]/[number withheld]; [number withheld]/[number withheld] Prozent; zwei D, davon eine D2 | `replication/outputs/tables/t044_pilot_coding.csv`, `t044_magnitude.csv`; nur Kopf/Note sprachlich geändert. |

## Offene Fragen

- Overleaf wurde nicht aufgerufen; der Noto-Zweig wurde dort nicht praktisch getestet. Lokal funktioniert der freigegebene Songti-Fallback einschließlich chinesischer Ausgabe.
- Die bestehende Warnung `Object @table.[number withheld] already defined` bleibt. Sie verhindert den Build nicht; die Tabellen-/Hyperlink-Infrastruktur wurde nicht verändert.
- Kein unabhängiges Review, Netzwerkzugriff oder Git/Overleaf-Abgleich durchgeführt. Kartenstatus unverändert; keine neuen Analysen oder Datenänderungen.
- Vorschlag für `AI_USAGE_LOG.md` außerhalb des Schreibbereichs: „2026-10-30, Codex, T048 Rework: NEF-Abbildung und Sprachpunkte nach Review korrigiert, Quellenstellen lokal geprüft, CJK-Fallback ergänzt; Vollbuild und PDF-Sichtprüfung erfolgreich ([number withheld] Haupttextseiten).“