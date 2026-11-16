## Ergebnis
Ich habe nur die TODO-Kommentare in `proposal/main.tex` ersetzt, wie die Rückmeldung des Co-PI es verlangt. Format, Präambel, Titelseite, Reihenfolge der Sections, Bibliographie-Block und Anhang sind unverändert. Die Datei habe ich nicht neu übersetzt, weil Bash in dieser Sitzung verweigert wurde.

## Dateien
- `proposal/main.tex` – TODO-Kommentare je Section durch die konkreten Pflichtinhalte aus `PROJEKT_STAND.md`, Abschnitt [number withheld], ersetzt.

`proposal/references.bib` habe ich nicht angefasst. Sie existiert aus dem ersten Stand.

## Ausführung
Der Befehl `agents/overleaf.sh check` konnte nicht laufen (Bash verweigert). Ich habe nur mit dem Edit-Werkzeug bearbeitet. Die Änderung betrifft nur Kommentarzeilen und eine Leerzeile.

## Abnahmekriterien
- [number withheld] (Übersetzung fehlerfrei): **nicht geprüft.** Es ist nur ein Kommentarwechsel; die Präambel und der übrige Code sind unverändert gegenüber dem vom Co-PI akzeptierten Stand. `agents/overleaf.sh check` muss noch laufen.
- [number withheld] (Präambel): erfüllt, unverändert (`article`, `[number withheld]pt`, Rand [number withheld]in, `\onehalfspacing`, `newtxtext`).
- [number withheld] (Reihenfolge): erfüllt, sechs Sections, danach Bibliographie-Block, danach Anhang.
- [number withheld] (Titelseite): erfüllt, unverändert (Titel mit `% TODO(PI): working title`, Autor, `abstract` einzeilig mit Platzhalter, Keywords-Zeile mit Platzhalter).
- [number withheld] (kein Fließtext, kein `\cite`): erfüllt. Es sind nur Kommentare im Text, die `.bib` hat keine Einträge, und es kommen keine Zahlen vor.
- [number withheld] (TODO je Section, deckt die Pflichtinhalte ab):
  - Introduction: [number withheld] TODOs (Frage und Methode, Motivation, Beitrag).
  - Related Literature: [number withheld] TODO (inkl. Focal Paper).
  - Theoretical Framework: [number withheld] TODO.
  - Empirical Model: [number withheld] TODOs (Gleichungen, Identifikation, Confounder).
  - Context and Data: [number withheld] TODOs (institutioneller Hintergrund, Quellen, Summary Statistics, deskriptive Tabelle).
  - Preliminary Analysis: [number withheld] TODOs (mindestens Summary Statistics, idealerweise erste Schätzungen).
  - Die Vorgaben stammen nur aus dem Absatz „Pflichtteile des Entwurfs“. Die zuvor allgemeine Zeile „as required by the syllabus“ in der Introduction habe ich gestrichen.
- [number withheld] (Titel): erfüllt, als Arbeitstitel markiert und ohne unmaskierte Sonderzeichen.
- [number withheld] (nichts anderes verändert): erfüllt.

Zahlen im neuen Text: keine.

## Offene Fragen
- Die Übersetzung mit `agents/overleaf.sh check` steht noch aus.
- Für das Theoretical Framework nennt `PROJEKT_STAND.md` keine Pflichtinhalte. Ich habe nichts erfunden, und der TODO sagt das so. Anton muss entscheiden, was dort hinein soll.
- Aus der Karte offen und unverändert: Ist der Arbeitstitel in Ordnung? Und ob Zhuang einen Zitierstil erwartet (hier `plainnat`).
- Die Präambel setzt `a4paper`. Die Karte verlangt nur [number withheld] Zoll Rand. Bitte entscheiden, ob Letter gewünscht ist.
