## Ergebnis

Die vier REWORK-Punkte sind umgesetzt: fünf unbelegte Sätze entfernt, die Kontrollpopulation in Figure 2 benannt und B4 mit gemeinsamer Legende sowie identischer y-Skalierung versehen. Rendering und Proposal-Build gelingen; der Haupttext endet weiterhin auf Seite 15.

## Dateien

- `replication/code/24_figures.R` – B4-Legende und y-Skalierung.
- `replication/outputs/figures/f_control_density.pdf` – aktualisierte B4.
- `proposal/figures/f_control_density.pdf` – identische Proposal-Kopie.
- `proposal/sections/06_preliminary_analysis.tex` – Zusatz „all control firms“.
- `proposal/appendix/results.tex` – Auslassungsbehauptung in fünf Notes entfernt.
- `replication/outputs/tables/t072_verification.csv` – erneuerte Byte-Guards.
- `replication/outputs/tables/t072_reproducibility.csv` – Vergleich beider aktuellen Läufe.
- `replication/outputs/tables/t072_visual_check.csv` – aktualisierter B4-Sichtprüfungsbeleg.
- `tasks/T072_report.md` – aktualisierter Bericht.

## Ausführung

Zweimal ausgeführt, jeweils Exitcode 0:

[fenced excerpt withheld in public audit]
[fenced excerpt withheld in public audit]

Letzte Ausgabe:

[fenced excerpt withheld in public audit]
[fenced excerpt withheld in public audit]

Proposal-Build, Exitcode 0:

[fenced excerpt withheld in public audit]
[fenced excerpt withheld in public audit]

[fenced excerpt withheld in public audit]
[fenced excerpt withheld in public audit]

## Abnahmekriterien

1. **Erfüllt:** B4 hat eine gemeinsame Legende und identische y-Achsengrenzen. Haupttextende auf Seite **15**, References ab Seite 16; keine undefinierten Verweise oder Overfull-Boxen.
2. **Erfüllt:** Audit unverändert mit **34 Seitenzeilen**. Kleinste empirische Druckschrift **9,257 pt**, bei B4 **11,308 pt**. Geplottete Werte unverändert.
3. **Erfüllt:** **459 historische Outputs** unverändert; zwei aktuelle Läufe liefern **44/44 byte-identische Dateien**. Alle **32 Rekonstruktionschecks** bestehen, maximale Abweichung **1,954 × 10⁻¹⁴**.
4. **Erfüllt:** Geänderte B4 erneut gerendert und angesehen; keine überlappenden oder abgeschnittenen Beschriftungen. Die übrigen **33 Grafikseiten** stimmen byte-identisch mit den zuvor sichtgeprüften PDFs überein. Betroffene Proposal-Layoutstellen zusätzlich geprüft.

Alle vier REWORK-Punkte erfüllt. Zahlen im neu ergänzten LaTeX-Text: **keine**. „All control firms“ ist durch `replication/outputs/tables/t063_by_date.csv`, Gruppe `control_all`, belegt. Keine `.bib`-Änderung.

## Offene Fragen

Keine neue offene Frage. Bestehende Einschränkungen bleiben: erlaubte PRISMA-Diagrammausnahme mit kleiner Schrift sowie zwei bekannte LaTeX-Schriftwarnungen zur chinesischen Kursivschrift.

Kein vollständiger Analyse-Build, Netzwerkzugriff, Git oder Overleaf-Abgleich. Kartenstatus bleibt `REWORK`.

KI-Log-Vorschlag für den Co-PI: „T072 REWORK 1: Abbildungsnoten und B4 korrigiert; Rekonstruktion, Byte-Identität, Audit, Sichtprüfung und Haupttextende geprüft.“ `AI_USAGE_LOG.md` blieb außerhalb des Schreibbereichs unverändert.