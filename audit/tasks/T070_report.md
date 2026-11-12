## Ergebnis
Alle 38 Anhangstabellen stehen auf `\linewidth`, mit einheitlicher Körperschrift und kleineren Anmerkungen. B6, B7 und B12 wurden in fortgesetzte Teile aufgeteilt; B27 und C1 bleiben seitenübergreifende Tabellen. Zahlen, Labels und Haupttext sind unverändert; gemeinsame Tabellenhelfer für T069 stehen bereit.

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
- `review/T070_build/main.aux` – Labels und Seitenzuordnung.
- `review/T070_build/main.atoc` – Anhangsverzeichnis.
- `review/T070_build/main.toc` – Inhaltsverzeichnis.
- `review/T070_build/main.bbl` – erzeugtes Literaturverzeichnis.
- `review/T070_build/main.blg` – BibTeX-Protokoll.
- `review/T070_build/main.fls` – Build-Dateiverzeichnis.
- `review/T070_build/main.fdb_latexmk` – Build-Abhängigkeiten.
- `review/T070_build/main.out` – PDF-Verweisdaten.
- `review/T070_build/main.xdv` – Build-Zwischenprodukt.

## Ausführung

Exakter Befehl:

[fenced excerpt withheld in public audit]
[fenced excerpt withheld in public audit]

Letzte nichtleere Ausgabezeilen; Exit-Code 0:

[fenced excerpt withheld in public audit]
[fenced excerpt withheld in public audit]

Zusätzlich ausgeführt: Zahlenvergleich gegen den gesicherten Ausgangsstand, PDF-Textextraktion, Breitenmessung an PDF-Tabellenlinien und visuelle Prüfung der gerenderten Anhangsseiten. Temporäre Prüfdateien liegen unter `/tmp/T070_*` und `/tmp/t070_*`. Kein Git und kein Netzwerk verwendet.

## Abnahmekriterien

1. **Erfüllt:** alle 38 Tabellen auf `\linewidth`; gemessene Breite rund 450.73 PDF-Punkte, bei C1 rund 450.72 durch Koordinatenrundung. Build ohne LaTeX-Fehler; **0 Overfull-Boxen im Anhang**. Haupttext, Vorspann und Literaturverzeichnis sind auf den ersten 19 physischen PDF-Seiten textidentisch zum Ausgangsstand. Der Haupttext endet weiterhin auf Seite 15; Tables 1–6 wurden nicht bearbeitet.

2. **Erfüllt:** **2.871 Zahlentokens in Tabellenzeilen** aus 34 geprüften Dateien sind vor/nach identisch und in gleicher Reihenfolge. Der wiederholte B6-Spaltenkopf wurde beidseitig ausgeschlossen; Vorzeichenschreibweisen wurden vereinheitlicht, keine Zahlen gerundet oder umgerechnet. Zusätzlich stimmen **409 Zahlentokens in expliziten Tabellenanmerkungen** überein. SHA-256 der geordneten Tokenfolge, jeweils vor und nach:

   `377471edacdccf0c92b6e3179e3a08c12bffd4703e374b96aa19f35467e6ca92`

   Negative Nullen bleiben auch im PDF erhalten. Keine neuen empirischen Zahlen oder Literaturangaben im wissenschaftlichen Text; bestehende Quellenkommentare bleiben erhalten.

3. **Erfüllt:** vollständiges Tabelleninventar unten. Alte Breite: erste horizontale Tabellenlinie in PDF-Punkten, bei mehreren Teiltafeln die erste. Neues Format überall `\linewidth`; **TX** bezeichnet den gemeinsamen `apptabular`-Helfer mit `tabularx`, **LT** eine Langtabelle.

| Tabelle | Seite im Endstand | Alte Breite (PDF-pt) | Neues Format |
|---|---|---:|---|
| A1 | A3 | 444.64 | TX |
| A2 | A3 | 371.75 | TX |
| A3 | A4 | 419.06 | TX |
| B1 | A5 | 406.41 | TX |
| B2 | A6 | 331.33 | TX |
| B3 | A8 | 420.40 | TX |
| B4 | A8 | 318.56 | TX |
| B5 | A9 | 444.52 | TX |
| B6 | A9–A10 | 408.71 | TX, fortgesetzt |
| B7 | A10–A11 | 421.39 | TX, fortgesetzt |
| B8 | A12 | 449.96 | TX |
| B9 | A12 | 450.73 | TX |
| B10 | A14 | 450.73 | TX |
| B11 | A15 | 314.72 | TX |
| B12 | A15–A16 | 318.33 | TX, fortgesetzt |
| B13 | A19 | 289.63 | TX |
| B14 | A19 | 450.73 | TX |
| B15 | A19 | 450.73 | TX |
| B16 | A20 | 450.73 | TX |
| B17 | A20 | 450.73 | TX |
| B18 | A21 | 450.73 | TX |
| B19 | A21 | 450.73 | TX |
| B20 | A22 | 323.88 | TX |
| B21 | A24 | 293.89 | TX |
| B22 | A24 | 330.63 | TX |
| B23 | A25 | 377.81 | TX |
| B24 | A25 | 319.29 | TX |
| B25 | A26 | 342.70 | TX |
| B26 | A27 | 394.23 | TX |
| B27 | A27–A28 | 189.06 | LT |
| B28 | A28 | 269.85 | TX |
| B29 | A29 | 448.77 | TX |
| B30 | A29 | 311.34 | TX |
| B31 | A30 | 322.41 | TX |
| B32 | A31 | 404.96 | TX |
| B33 | A31 | 404.96 | TX |
| B34 | A31 | 434.16 | TX |
| C1 | A32–A34 | 449.03 | LT |

Zweispaltige Tabellen separat: **A1 – Variable definitions** und **B34 – Further robustness outputs in the replication package**. Beide bleiben eigenständig auf voller Textbreite.

## Offene Fragen

Keine inhaltlichen Entscheidungen erforderlich. Die bisherige Crosser-Datei unter `proposal/sections/` blieb unverändert; eingebunden wird ihre Layoutkopie im freigegebenen Tabellenordner.

Außerhalb des Anhangs bestehen weiterhin die bereits vorhandene Overfull-Meldung in `t049_threats.tex` (20.83865 pt) und Font-Substitutionswarnungen. Figuren wurden nicht bearbeitet; ihre Seitenpositionen ändern sich durch LaTeXs Float-Platzierung.

Vorschlag für `AI_USAGE_LOG.md`, außerhalb des Schreibbereichs: „2026-11-02, Codex, T070: Vereinheitlichung der Anhangstabellen auf volle Textbreite; keine Inhalts- oder Zahlenänderung; Zahlenvergleich, XeLaTeX-Build und visuelle PDF-Kontrolle.“