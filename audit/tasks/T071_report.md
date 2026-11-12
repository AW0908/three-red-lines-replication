## Ergebnis

Das Appendix-Layout wurde überarbeitet und alle 35 Anhangseiten visuell geprüft. Zahlen, Captions, Labels und die 15 Haupttextseiten sind unverändert. Eine bestehende Overfull-Box im Haupttext verhindert die vollständige Abnahme.

## Dateien

- `proposal/appendix/variables.tex`, `proposal/appendix/results.tex`, `proposal/appendix/ai_use.tex` – Absatz-, Float- und Seitenlayout.
- `proposal/preamble.tex` – Appendix-Helfer für Tabellenbreite und Spaltenabstände.
- `proposal/tables/t005_summary_stats.tex`
- `proposal/tables/t009_did_main.tex`
- `proposal/tables/t024_rd_main.tex`
- `proposal/tables/t031_samples.tex`
- `proposal/tables/t031_timing.tex`
- `proposal/tables/t040_robustness.tex`
- `proposal/tables/t040_validation.tex`
- `proposal/tables/t041_frozen_horizons.tex`
- `proposal/tables/t043_delta_excess.tex`
- `proposal/tables/t043_heterogeneity.tex`
- `proposal/tables/t043_integration.tex`
- `proposal/tables/t043_meas_error.tex`
- `proposal/tables/t043_trend_cf.tex`
- `proposal/tables/t046_cash_backing_all.tex`
- `proposal/tables/t049_sample_composition.tex`
- `proposal/tables/t055_falsification.tex`
- `proposal/tables/t055_mi_shift.tex`
- `proposal/tables/t055_pretrend_tests.tex`
- `proposal/tables/t058_above.tex`
- `proposal/tables/t058_attrition.tex`
- `proposal/tables/t058_checks.tex`
- `proposal/tables/t058_grid.tex`
- `proposal/tables/t058_notch.tex`
- `proposal/tables/t058_pilot.tex`
- `proposal/tables/t058_symmetric.tex`
- `proposal/tables/t061_results.tex`
- `proposal/tables/t063_control_sens.tex`
- `proposal/tables/t063_noise.tex`
- `proposal/tables/t063_one_obs.tex`
- `proposal/tables/t063_window.tex`
- `proposal/tables/t070_crosser_shares.tex`

Die genannten Tabellen erhielten Spaltenabstände, Umbrüche oder angepasste Platzierung.

- `tasks/T071_report.md` – ausführlicher Bericht.
- `review/T071_pages/final.pdf` – geprüfter Build.
- `review/T071_pages/final-20.png` bis `review/T071_pages/final-54.png` – alle Anhangseiten bei 50 dpi.
- `review/T071_pages/final_contact_1.png` bis `review/T071_pages/final_contact_6.png` – Seitenübersichten.
- `review/T071_pages/final.txt`, `review/T071_pages/final_bbox.html`, `review/T071_pages/before_bbox.html` – PDF-Extraktionen.
- `review/T071_pages/verify.py` – reproduzierbarer Inhaltsvergleich.
- `review/T071_pages/verification.json`, `review/T071_pages/content_checks.json`, `review/T071_pages/number_inventory.json`, `review/T071_pages/build_checks.json` – Prüfnachweise.
- `review/T071_pages/page_checks.md`, `review/T071_pages/page_checks.json` – Einzelprüfung aller Seiten.
- `review/T071_pages/build.log` – Ausführungsprotokoll.
- `review/T071_build/main.{atoc,aux,bbl,blg,fdb_latexmk,fls,log,out,pdf,toc,xdv}` – aktualisierte Builddateien.

## Ausführung

[fenced excerpt withheld in public audit]
[fenced excerpt withheld in public audit]

Exit-Code: 0. Letzte Ausgabe:

[fenced excerpt withheld in public audit]
[fenced excerpt withheld in public audit]

Zusätzlich: `python3 review/T071_pages/verify.py` und vollständiges Appendix-Rendering mit `pdftoppm -r 50`.

## Abnahmekriterien

1. **Nicht vollständig erfüllt:** Der Anhang hat keine Overfull-Box > 1 pt, zusammenlaufenden Spalten oder verwaisten Einzelsätze. Inhaltsseiten erreichen etwa 60–98 % Füllung. Haupttext und Seitenende auf Seite 15 sind unverändert. Allerdings besteht im Haupttext weiterhin eine Overfull-Box von **20,83865 pt** in `proposal/sections/07_conclusion.tex`, Zeilen 8–9.
2. **Erfüllt:** Inhaltszahlen je Datei identisch; Tabellenzahlen zusätzlich in unveränderter Zeilenfolge. Alle Caption-/Label-Strings identisch. Vollständige Extraktionen und Vergleiche stehen in `number_inventory.json`, `content_checks.json` und `verification.json`.
3. **Erfüllt:** Jede Anhangseite wurde visuell geprüft; Füllschätzungen stehen unten.

Keine neuen empirischen Zahlen oder Literaturangaben wurden eingefügt. Bestehende Quellenkommentare sind erhalten.

Vorher/nachher vergleicht dieselbe Seitenposition; Tabellen können gewandert sein. A1/A2 sind Deckblatt und Inhaltsverzeichnis.

| Seite | Vorher | Nachher | Überlauf / zusammenlaufende Spalten / verwaister Text |
|---|---:|---:|---|
| A1 | 53 % | 53 % | nein / nein / nein |
| A2 | 30 % | 30 % | nein / nein / nein |
| A3 | 88 % | 88 % | nein / nein / nein |
| A4 | 88 % | 88 % | nein / nein / nein |
| A5 | 93 % | 97 % | nein / nein / nein |
| A6 | 92 % | 92 % | nein / nein / nein |
| A7 | 74 % | 98 % | nein / nein / nein |
| A8 | 78 % | 84 % | nein / nein / nein |
| A9 | 75 % | 75 % | nein / nein / nein |
| A10 | 91 % | 90 % | nein / nein / nein |
| A11 | 62 % | 97 % | nein / nein / nein |
| A12 | 89 % | 64 % | nein / nein / nein |
| A13 | 48 % | 96 % | nein / nein / nein |
| A14 | 72 % | 84 % | nein / nein / nein |
| A15 | 80 % | 68 % | nein / nein / nein |
| A16 | 81 % | 84 % | nein / nein / nein |
| A17 | 81 % | 65 % | nein / nein / nein |
| A18 | 81 % | 85 % | nein / nein / nein |
| A19 | 96 % | 75 % | nein / nein / nein |
| A20 | 81 % | 88 % | nein / nein / nein |
| A21 | 75 % | 63 % | nein / nein / nein |
| A22 | 91 % | 74 % | nein / nein / nein |
| A23 | 78 % | 81 % | nein / nein / nein |
| A24 | 98 % | 96 % | nein / nein / nein |
| A25 | 97 % | 60 % | nein / nein / nein |
| A26 | 99 % | 98 % | nein / nein / nein |
| A27 | 98 % | 76 % | nein / nein / nein |
| A28 | 96 % | 87 % | nein / nein / nein |
| A29 | 96 % | 75 % | nein / nein / nein |
| A30 | 93 % | 83 % | nein / nein / nein |
| A31 | 92 % | 63 % | nein / nein / nein |
| A32 | 95 % | 97 % | nein / nein / nein |
| A33 | 82 % | 91 % | nein / nein / nein |
| A34 | 98 % | 82 % | nein / nein / nein |
| A35 | 25 % | 63 % | nein / nein / nein |

## Offene Fragen

Die vorhandene Overfull-Box im Haupttext benötigt eine gesonderte Aufgabenkarte: Änderungen am Haupttext waren ausdrücklich ausgeschlossen. Kartenstatus unverändert: APPROVED.

Der vorhandene T071-Ausgangssnapshot wurde weiterverwendet; sein Preamble-Hash stimmt mit `review/T071_baseline.sha256` überein. Das automatisch erzeugte Deckblattdatum entspricht dem aktuellen Builddatum.

Vorgeschlagener KI-Nutzungseintrag, wegen des Schreibbereichs nicht selbst ergänzt: „2026-11-09, Codex, T071: Appendix-Layout und Sichtprüfung aller 35 Anhangseiten; Zahlen/Beschriftungen und Haupttext unverändert geprüft; bestehenden Haupttext-Überlauf dokumentiert.“