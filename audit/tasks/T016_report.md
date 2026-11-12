## Ergebnis
Die Tabelle im AI-Appendix passt jetzt rechnerisch in den Textbereich (451,26 pt von 452,97 pt). `\inputtable` und `\inputfigure` setzen Noten innerhalb des Floats, und beide READMEs sind angepasst. Ich konnte nicht kompilieren (Worker ohne Build); der Build bleibt Sache des PI mit `agents/overleaf.sh check`.

## Dateien
- `proposal/appendix/ai_use.tex` – Spaltenbreiten relativ zu `\linewidth` (Befund 1), Rechnung als Kommentar in Zeile 10, longtable in Zeile 11.
- `proposal/preamble.tex` – `\inputtable` (Z. 61–66) und `\inputfigure` (Z. 72–77) haben ein optionales erstes Argument `[<note>]`, das per `\floatnote` vor `\end{table}` bzw. `\end{figure}` gesetzt wird (Befund 4). Die Kommentarzeilen 58 und 70 sind angepasst.
- `proposal/tables/README.txt` – Notenargument und Warnung dokumentiert, `\floatnote` nicht nach dem Makro zu setzen.
- `proposal/figures/README.txt` – falsche Empfehlung (`\floatnote` nach `\inputfigure`) ersetzt durch das optionale Argument.

## Ausführung
Nicht ausgeführt: `agents/overleaf.sh check` kann ich nicht ausführen (kein Build, kein Netzwerk). Bestehende Aufrufe bleiben gültig, weil das neue Argument optional ist. Im Projekt gibt es bisher keine Aufrufe der Makros, nur Kommentare in `05_context_data.tex:4` und `03_framework.tex:3`.

Das Makro nutzt `\ifblank` aus `etoolbox`; das Paket wird in `preamble.tex:6` geladen, vor den Makros.

## Abnahmekriterien
1. **Compile: offen.** Der PI muss den Build laufen lassen. Das Hauptdokument hat keine Änderung außer der Präambel.
2. **Matrix Anforderung → Datei:Zeile: erfüllt.**

| Anforderung | Umsetzung |
|---|---|
| 12 pt | `main.tex:12` |
| Times | `preamble.tex:10,12` (newtxtext, newtxmath) |
| 1 in Rand (A4, begründet) | `preamble.tex:2,4` |
| 1,5-facher Zeilenabstand | `preamble.tex:43` |
| Einfacher Abstand für table, figure, longtable, Bibliographie | `preamble.tex:44–47` |
| Einfacher Abstand für Fußnoten und Captions | durch `setspace` (Kommentar `preamble.tex:48`) |
| Caption: fett, small, Tabelle oben, Abbildung unten | `preamble.tex:38–40` |
| Seitenzahlen, außer auf der Titelseite | `preamble.tex:55`, `main.tex:24` |
| Titelseite mit Titel, Autor, Kurs und Datum | `main.tex:17–19,23` |
| Abstract ≤100 Wörter, einfacher Abstand | `main.tex:26–32` (Platzhalter, Wortzählung als TODO `main.tex:28–29`) |
| 3–5 Keywords | `main.tex:34` |
| 12–15 Seiten (Entwurf), 15–20 (Final) | `main.tex:2`; offene Frage zur Zählung `main.tex:3–4` |
| Reihenfolge der Sektionen | `main.tex:39–44` |
| Introduction: erste drei Absätze (Frage und Methode, Motivation, Beitrag) | `sections/01_introduction.tex:5,6,7` |
| Related Literature mit Focal Paper | `sections/02_literature.tex:5` |
| Framework mit Graph | `sections/03_framework.tex:3,5` |
| Empirical Model: Gleichungen, Identifikation, Confounders | `sections/04_empirical_model.tex:5,6,7` |
| Context and Data: Hintergrund, Datenquellen, Summary Statistics, Descriptive Table | `sections/05_context_data.tex:6,7,8,9` |
| Preliminary Analysis | `sections/06_preliminary_analysis.tex:5,6` |
| Seitenbudgets | Zeile 3 jeder Section-Datei (1,5 / 2 / 1,5 / 2 / 3 / 3,5) |
| Bibliographie: einfacher Abstand, natbib | `main.tex:47–53` (Stil `plainnat`, auskommentiert bis zum ersten `\cite`), `preamble.tex:51–52` |
| AI-Appendix, sechs Spalten, in den Textbereich eingepasst | `appendix/ai_use.tex:10–13` |
| Tracked Changes | `main.tex:6–10`, `preamble.tex:83` (`\chg`) |
| Separate Response-Datei | `response_to_reviewers.tex:1–28` |

   **Rechnung zur Breite:** Der Textbereich beträgt 452,97 pt (A4 mit 1 in Rand). Die Spaltenbreiten summieren sich auf 0,09+0,09+0,17+0,24+0,17+0,17 = 0,93 · 452,97 pt = 421,26 pt. Dazu kommen 5 innere Abstände · 2 · 3 pt = 30 pt (`@{}` an beiden Rändern). Gesamt: 451,26 pt ≤ 452,97 pt.

3. **Test-Input-Pakete: unverändert erfüllt.** `t005_summary_stats` braucht booktabs und threeparttable (`preamble.tex:19,23`). `t009_did_main` braucht booktabs und graphicx (`preamble.tex:19,32`).
4. **Keine Prosa und keine Referenzen: erfüllt.** Es gibt keine neuen Texte oder `\cite`. Ich habe `references.bib` nicht geöffnet und nicht bearbeitet; Prüfsummen kann ich nicht berechnen, das prüft der Co-PI.
5. **Zahlen im neuen Text:** keine. Die Rechenwerte (452,97 pt usw.) stehen nur im Kommentar in `ai_use.tex` und stammen aus der Geometrie, nicht aus `replication/outputs/`.

## Offene Fragen
- Befund 2 betrifft nicht den Worker. Die Section-Dateien 01–06 liegen im Schreibbereich. Die Änderungen unter `replication/outputs/` stammen nach Angabe des Co-PI von T014. Die Prüfsummen für `sections/02–06` und `t009_did_main.tex` muss der Co-PI nachziehen.
- Ich habe das Makro nach der Co-PI-Vorgabe mit einem optionalen ersten Argument umgesetzt, nicht als viertes Pflichtargument, damit bestehende Aufrufe weiter gelten.
- `t009_did_main.tex` bringt weiter ein eigenes `table`-Environment ohne Caption, daher gilt für `\inputtablefloat` keine Notenfunktion. Das ist ein Punkt für eine spätere Replikationskarte.
- Offene Zählfrage für Titelseite, Bibliographie und Appendix bleibt beim PI (`main.tex:3–4`).
- Nicht geprüft: Kompilierung, Seitenbild und der Test-Input der Tabellen im Build.
