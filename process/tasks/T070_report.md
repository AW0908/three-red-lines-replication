## Ergebnis
Alle [number withheld] Anhangstabellen stehen auf `\linewidth`, mit einheitlicher Körperschrift und kleineren Anmerkungen. B6, B7 und B1[number withheld] wurden in fortgesetzte Teile aufgeteilt; B2[number withheld] und C1 bleiben seitenübergreifende Tabellen. Zahlen, Labels und Haupttext sind unverändert; gemeinsame Tabellenhelfer für T069 stehen bereit.

## Dateien

- `proposal/preamble.tex` – gemeinsame Tabellenhelfer und Dezimalausrichtung.
- `proposal/appendix/variables.tex` – Tabellenformat.
- `proposal/appendix/results.tex` – Tabellenformat, Einbindung und Platzierung.
- `proposal/appendix/ai_use.tex` – volle Breite der Langtabelle.
- `proposal/tables/t005_summary_stats.tex` – Tabellenformat.
- `proposal/tables/t009_did_main.tex` – Tabellenformat.
- `proposal/tables/t024_rd_main.tex` – Tabellenformat.
- `proposal/tables/t031_samples.tex` – Tabellenformat.
- `proposal/tables/t031_timing.tex` – Tabellenformat.
- `proposal/tables/t040_robustness.tex` – Tabellenformat.
- `proposal/tables/t040_validation.tex` – Tabellenformat.
- `proposal/tables/t041_frozen_horizons.tex` – Tabellenformat.
- `proposal/tables/t043_delta_excess.tex` – Format und Fortsetzung.
- `proposal/tables/t043_heterogeneity.tex` – Tabellenformat.
- `proposal/tables/t043_integration.tex` – Format und Fortsetzung.
- `proposal/tables/t043_meas_error.tex` – Tabellenformat.
- `proposal/tables/t043_trend_cf.tex` – Tabellenformat.
- `proposal/tables/t046_cash_backing_all.tex` – Tabellenformat und Booktabs-Linien.
- `proposal/tables/t049_sample_composition.tex` – Tabellenformat.
- `proposal/tables/t055_falsification.tex` – Tabellenformat.
- `proposal/tables/t055_mi_shift.tex` – Tabellenformat.
- `proposal/tables/t055_pretrend_tests.tex` – Tabellenformat.
- `proposal/tables/t058_above.tex` – Tabellenformat.
- `proposal/tables/t058_attrition.tex` – Tabellenformat.
- `proposal/tables/t058_checks.tex` – Tabellenformat.
- `proposal/tables/t058_grid.tex` – Tabellenformat.
- `proposal/tables/t058_notch.tex` – Tabellenformat.
- `proposal/tables/t058_pilot.tex` – Tabellenformat.
- `proposal/tables/t058_symmetric.tex` – Tabellenformat.
- `proposal/tables/t061_results.tex` – Tabellenformat.
- `proposal/tables/t063_control_sens.tex` – Format und Fortsetzung.
- `proposal/tables/t063_noise.tex` – Tabellenformat.
- `proposal/tables/t063_one_obs.tex` – Tabellenformat.
- `proposal/tables/t063_window.tex` – Tabellenformat.
- `proposal/tables/t070_crosser_shares.tex` – reine Layoutkopie der unveränderten Datei unter `proposal/sections/`.
- `tasks/T070_report.md` – Bericht und Prüfbelege.
- `review/T070_build/main.pdf` – kompiliertes Dokument.
- `review/T070_build/main.log` – Build-Protokoll.
- `review/T0[number withheld]_build/main.aux` – Labels und Seitenzuordnung.
- `review/T0[number withheld]_build/main.atoc` – Anhangsverzeichnis.
- `review/T0[number withheld]_build/main.toc` – Inhaltsverzeichnis.
- `review/T0[number withheld]_build/main.bbl` – erzeugtes Literaturverzeichnis.
- `review/T0[number withheld]_build/main.blg` – BibTeX-Protokoll.
- `review/T0[number withheld]_build/main.fls` – Build-Dateiverzeichnis.
- `review/T0[number withheld]_build/main.fdb_latexmk` – Build-Abhängigkeiten.
- `review/T0[number withheld]_build/main.out` – PDF-Verweisdaten.
- `review/T0[number withheld]_build/main.xdv` – Build-Zwischenprodukt.

## Ausführung

Exakter Befehl:

[fenced excerpt withheld in public process copy]
[fenced excerpt withheld in public process copy]

Letzte nichtleere Ausgabezeilen; Exit-Code [number withheld]:

[fenced excerpt withheld in public process copy]
[fenced excerpt withheld in public process copy]

Zusätzlich ausgeführt: Zahlenvergleich gegen den gesicherten Ausgangsstand, PDF-Textextraktion, Breitenmessung an PDF-Tabellenlinien und visuelle Prüfung der gerenderten Anhangsseiten. Temporäre Prüfdateien liegen unter `/tmp/T0[number withheld]_*` und `/tmp/t0[number withheld]_*`. Kein Git und kein Netzwerk verwendet.

## Abnahmekriterien

[number withheld]. **Erfüllt:** alle [number withheld] Tabellen auf `\linewidth`; gemessene Breite rund [number withheld] PDF-Punkte, bei C1 rund [number withheld] durch Koordinatenrundung. Build ohne LaTeX-Fehler; **[number withheld] Overfull-Boxen im Anhang**. Haupttext, Vorspann und Literaturverzeichnis sind auf den ersten [number withheld] physischen PDF-Seiten textidentisch zum Ausgangsstand. Der Haupttext endet weiterhin auf Seite [number withheld]; Tables [number withheld]–[number withheld] wurden nicht bearbeitet.

[number withheld]. **Erfüllt:** **[number withheld] Zahlentokens in Tabellenzeilen** aus [number withheld] geprüften Dateien sind vor/nach identisch und in gleicher Reihenfolge. Der wiederholte B6-Spaltenkopf wurde beidseitig ausgeschlossen; Vorzeichenschreibweisen wurden vereinheitlicht, keine Zahlen gerundet oder umgerechnet. Zusätzlich stimmen **[number withheld] Zahlentokens in expliziten Tabellenanmerkungen** überein. SHA-[number withheld] der geordneten Tokenfolge, jeweils vor und nach:

   `377471edacdccf0c92b6e3179e3a08c12bffd4703e374b96aa19f35467e6ca92`

   Negative Nullen bleiben auch im PDF erhalten. Keine neuen empirischen Zahlen oder Literaturangaben im wissenschaftlichen Text; bestehende Quellenkommentare bleiben erhalten.

[number withheld]. **Erfüllt:** vollständiges Tabelleninventar unten. Alte Breite: erste horizontale Tabellenlinie in PDF-Punkten, bei mehreren Teiltafeln die erste. Neues Format überall `\linewidth`; **TX** bezeichnet den gemeinsamen `apptabular`-Helfer mit `tabularx`, **LT** eine Langtabelle.

| Tabelle | Seite im Endstand | Alte Breite (PDF-pt) | Neues Format |
|---|---|---:|---|
| A1 | A3 | [number withheld] | TX |
| A2 | A3 | [number withheld] | TX |
| A3 | A4 | [number withheld] | TX |
| B1 | A5 | [number withheld] | TX |
| B2 | A6 | [number withheld] | TX |
| B3 | A8 | [number withheld] | TX |
| B4 | A8 | [number withheld] | TX |
| B5 | A9 | [number withheld] | TX |
| B6 | A9–A1[number withheld] | [number withheld] | TX, fortgesetzt |
| B7 | A1[number withheld]–A1[number withheld] | [number withheld] | TX, fortgesetzt |
| B8 | A1[number withheld] | [number withheld] | TX |
| B9 | A1[number withheld] | [number withheld] | TX |
| B1[number withheld] | A1[number withheld] | [number withheld] | TX |
| B1[number withheld] | A1[number withheld] | [number withheld] | TX |
| B1[number withheld] | A1[number withheld]–A1[number withheld] | [number withheld] | TX, fortgesetzt |
| B1[number withheld] | A1[number withheld] | [number withheld] | TX |
| B1[number withheld] | A1[number withheld] | [number withheld] | TX |
| B1[number withheld] | A1[number withheld] | [number withheld] | TX |
| B1[number withheld] | A2[number withheld] | [number withheld] | TX |
| B1[number withheld] | A2[number withheld] | [number withheld] | TX |
| B1[number withheld] | A2[number withheld] | [number withheld] | TX |
| B1[number withheld] | A2[number withheld] | [number withheld] | TX |
| B2[number withheld] | A2[number withheld] | [number withheld] | TX |
| B2[number withheld] | A2[number withheld] | [number withheld] | TX |
| B2[number withheld] | A2[number withheld] | [number withheld] | TX |
| B2[number withheld] | A2[number withheld] | [number withheld] | TX |
| B2[number withheld] | A2[number withheld] | [number withheld] | TX |
| B2[number withheld] | A2[number withheld] | [number withheld] | TX |
| B2[number withheld] | A2[number withheld] | [number withheld] | TX |
| B2[number withheld] | A2[number withheld]–A2[number withheld] | [number withheld] | LT |
| B2[number withheld] | A2[number withheld] | [number withheld] | TX |
| B2[number withheld] | A2[number withheld] | [number withheld] | TX |
| B3[number withheld] | A2[number withheld] | [number withheld] | TX |
| B3[number withheld] | A3[number withheld] | [number withheld] | TX |
| B3[number withheld] | A3[number withheld] | [number withheld] | TX |
| B3[number withheld] | A3[number withheld] | [number withheld] | TX |
| B3[number withheld] | A3[number withheld] | [number withheld] | TX |
| C1 | A3[number withheld]–A3[number withheld] | [number withheld] | LT |

Zweispaltige Tabellen separat: **A1 – Variable definitions** und **B3[number withheld] – Further robustness outputs in the replication package**. Beide bleiben eigenständig auf voller Textbreite.

## Offene Fragen

Keine inhaltlichen Entscheidungen erforderlich. Die bisherige Crosser-Datei unter `proposal/sections/` blieb unverändert; eingebunden wird ihre Layoutkopie im freigegebenen Tabellenordner.

Außerhalb des Anhangs bestehen weiterhin die bereits vorhandene Overfull-Meldung in `t049_threats.tex` ([number withheld] pt) und Font-Substitutionswarnungen. Figuren wurden nicht bearbeitet; ihre Seitenpositionen ändern sich durch LaTeXs Float-Platzierung.

Vorschlag für `AI_USAGE_LOG.md`, außerhalb des Schreibbereichs: „2026-11-02, Codex, T070: Vereinheitlichung der Anhangstabellen auf volle Textbreite; keine Inhalts- oder Zahlenänderung; Zahlenvergleich, XeLaTeX-Build und visuelle PDF-Kontrolle.“