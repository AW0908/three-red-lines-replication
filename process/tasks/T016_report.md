## Ergebnis
Die Tabelle im AI-Appendix passt jetzt rechnerisch in den Textbereich ([number withheld] pt von [number withheld] pt). `\inputtable` und `\inputfigure` setzen Noten innerhalb des Floats, und beide READMEs sind angepasst. Ich konnte nicht kompilieren (Worker ohne Build); der Build bleibt Sache des PI mit `agents/overleaf.sh check`.

## Dateien
- `proposal/appendix/ai_use.tex` – Spaltenbreiten relativ zu `\linewidth` (Befund [number withheld]), Rechnung als Kommentar in Zeile [number withheld], longtable in Zeile [number withheld].
- `proposal/preamble.tex` – `\inputtable` (Z. [number withheld]–[number withheld]) und `\inputfigure` (Z. [number withheld]–[number withheld]) haben ein optionales erstes Argument `[<note>]`, das per `\floatnote` vor `\end{table}` bzw. `\end{figure}` gesetzt wird (Befund [number withheld]). Die Kommentarzeilen [number withheld] und [number withheld] sind angepasst.
- `proposal/tables/README.txt` – Notenargument und Warnung dokumentiert, `\floatnote` nicht nach dem Makro zu setzen.
- `proposal/figures/README.txt` – falsche Empfehlung (`\floatnote` nach `\inputfigure`) ersetzt durch das optionale Argument.

## Ausführung
Nicht ausgeführt: `agents/overleaf.sh check` kann ich nicht ausführen (kein Build, kein Netzwerk). Bestehende Aufrufe bleiben gültig, weil das neue Argument optional ist. Im Projekt gibt es bisher keine Aufrufe der Makros, nur Kommentare in `05_context_data.tex:4` und `03_framework.tex:3`.

Das Makro nutzt `\ifblank` aus `etoolbox`; das Paket wird in `preamble.tex:6` geladen, vor den Makros.

## Abnahmekriterien
[number withheld]. **Compile: offen.** Der PI muss den Build laufen lassen. Das Hauptdokument hat keine Änderung außer der Präambel.
[number withheld]. **Matrix Anforderung → Datei:Zeile: erfüllt.**

| Anforderung | Umsetzung |
|---|---|
| [number withheld] pt | `main.tex:12` |
| Times | `preamble.tex:[number withheld]` (newtxtext, newtxmath) |
| [number withheld] in Rand (A4, begründet) | `preamble.tex:[number withheld]` |
| [number withheld]-facher Zeilenabstand | `preamble.tex:43` |
| Einfacher Abstand für table, figure, longtable, Bibliographie | `preamble.tex:44–47` |
| Einfacher Abstand für Fußnoten und Captions | durch `setspace` (Kommentar `preamble.tex:48`) |
| Caption: fett, small, Tabelle oben, Abbildung unten | `preamble.tex:38–40` |
| Seitenzahlen, außer auf der Titelseite | `preamble.tex:55`, `main.tex:24` |
| Titelseite mit Titel, Autor, Kurs und Datum | `main.tex:[number withheld]–[number withheld]` |
| Abstract ≤[number withheld] Wörter, einfacher Abstand | `main.tex:26–32` (Platzhalter, Wortzählung als TODO `main.tex:28–29`) |
| [number withheld]–[number withheld] Keywords | `main.tex:34` |
| [number withheld]–[number withheld] Seiten (Entwurf), [number withheld]–[number withheld] (Final) | `main.tex:2`; offene Frage zur Zählung `main.tex:3–4` |
| Reihenfolge der Sektionen | `main.tex:39–44` |
| Introduction: erste drei Absätze (Frage und Methode, Motivation, Beitrag) | `sections/[number withheld]_introduction.tex:[number withheld]` |
| Related Literature mit Focal Paper | `sections/02_literature.tex:5` |
| Framework mit Graph | `sections/[number withheld]_framework.tex:[number withheld]` |
| Empirical Model: Gleichungen, Identifikation, Confounders | `sections/[number withheld]_empirical_model.tex:[number withheld]` |
| Context and Data: Hintergrund, Datenquellen, Summary Statistics, Descriptive Table | `sections/[number withheld]_context_data.tex:[number withheld]` |
| Preliminary Analysis | `sections/[number withheld]_preliminary_analysis.tex:[number withheld]` |
| Seitenbudgets | Zeile [number withheld] jeder Section-Datei ([number withheld] / [number withheld] / [number withheld] / [number withheld] / [number withheld] / [number withheld]) |
| Bibliographie: einfacher Abstand, natbib | `main.tex:47–53` (Stil `plainnat`, auskommentiert bis zum ersten `\cite`), `preamble.tex:51–52` |
| AI-Appendix, sechs Spalten, in den Textbereich eingepasst | `appendix/ai_use.tex:10–13` |
| Tracked Changes | `main.tex:6–10`, `preamble.tex:83` (`\chg`) |
| Separate Response-Datei | `response_to_reviewers.tex:1–28` |

   **Rechnung zur Breite:** Der Textbereich beträgt [number withheld] pt (A4 mit [number withheld] in Rand). Die Spaltenbreiten summieren sich auf [number withheld][number withheld][number withheld][number withheld][number withheld][number withheld] = [number withheld] · [number withheld] pt = [number withheld] pt. Dazu kommen [number withheld] innere Abstände · [number withheld] · [number withheld] pt = [number withheld] pt (`@{}` an beiden Rändern). Gesamt: [number withheld] pt ≤ [number withheld] pt.

[number withheld]. **Test-Input-Pakete: unverändert erfüllt.** `t0[number withheld]_summary_stats` braucht booktabs und threeparttable (`preamble.tex:[number withheld]`). `t0[number withheld]_did_main` braucht booktabs und graphicx (`preamble.tex:[number withheld]`).
[number withheld]. **Keine Prosa und keine Referenzen: erfüllt.** Es gibt keine neuen Texte oder `\cite`. Ich habe `references.bib` nicht geöffnet und nicht bearbeitet; Prüfsummen kann ich nicht berechnen, das prüft der Co-PI.
[number withheld]. **Zahlen im neuen Text:** keine. Die Rechenwerte ([number withheld] pt usw.) stehen nur im Kommentar in `ai_use.tex` und stammen aus der Geometrie, nicht aus `replication/outputs/`.

## Offene Fragen
- Befund [number withheld] betrifft nicht den Worker. Die Section-Dateien [number withheld]–[number withheld] liegen im Schreibbereich. Die Änderungen unter `replication/outputs/` stammen nach Angabe des Co-PI von T014. Die Prüfsummen für `sections/[number withheld]–[number withheld]` und `t009_did_main.tex` muss der Co-PI nachziehen.
- Ich habe das Makro nach der Co-PI-Vorgabe mit einem optionalen ersten Argument umgesetzt, nicht als viertes Pflichtargument, damit bestehende Aufrufe weiter gelten.
- `t009_did_main.tex` bringt weiter ein eigenes `table`-Environment ohne Caption, daher gilt für `\inputtablefloat` keine Notenfunktion. Das ist ein Punkt für eine spätere Replikationskarte.
- Offene Zählfrage für Titelseite, Bibliographie und Appendix bleibt beim PI (`main.tex:3–4`).
- Nicht geprüft: Kompilierung, Seitenbild und der Test-Input der Tabellen im Build.
