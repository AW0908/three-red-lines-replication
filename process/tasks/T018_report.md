## Ergebnis
Ich habe die zwei Befunde aus `review/T018.md` behoben, und zwar so, wie es die zweite Co-PI-Rückmeldung verlangt: vereinfachen statt das Modell weiter flicken. [number withheld] enthält nur noch drei Teile: die Compliance-Bedingung, die Kostenfunktionen C_r(r), C_c(c) mit c ≤ c_bar und eine einzige qualitative Aussage. Diese lautet: Die Mischung aus realer und kosmetischer Anpassung hängt von den relativen Grenzkosten ab, und ob reale oder kosmetische Anpassung überwiegt, ist eine empirische Frage. In [number withheld] ist die Wirkung auf RL2 und RL3 beim JV-Kanal jetzt ausdrücklich unbestimmt (mit dem Gegenbeispiel des Reviewers). Beim Minderheitspartner-Kanal hängt die Wirkung jetzt daran, ob das Partnerkapital als Eigenkapital gebucht wird. Ich konnte den Ausführungsbefehl nicht laufen lassen (siehe Ausführung).

## Dateien
- `proposal/sections/03_framework.tex` – drei Änderungen:
  - [number withheld], Para [number withheld] (i) JV und (ii) Minderheitspartner: Wirkung auf die Kennzahlen nur noch unter Bedingungen formuliert.
  - Diagrammplan: Formulierung angepasst, weil nicht jede Maßnahme jede Kennzahl in Richtung Compliance bewegt.
  - [number withheld]: neu geschrieben, A1–A6 und M1–M4 gestrichen, keine komparative Statik und keine Aussage zur optimalen Mischung mehr.
  - [number withheld]: Die Verweise auf M- und A-Punkte sind durch die jeweils tragende Annahme in Worten ersetzt.

Andere Abschnittsdateien habe ich nicht geändert. Eine Suche nach `M1–M4`/`A1–A6` in `proposal/sections/` findet keine Treffer mehr.

## Ausführung
`agents/overleaf.sh check` habe ich **nicht ausgeführt**: In dieser Sitzung habe ich kein Shell-Werkzeug. Laut Karte führt der PI den Befehl aus (Kriterium [number withheld]). Außerhalb von Kommentaren habe ich keine Zeile geändert. Die Überschriften, Labels und Seitenbudgets, die im letzten Lauf übersetzt wurden (`review/T018_latex.txt`), sind also unverändert. Eine neue Übersetzung ist trotzdem nicht belegt.

## Abnahmekriterien
[number withheld]. **Unterabschnitte und Labels:** erfüllt, nicht verändert (`subsec:two_ways`, `subsec:stylised`, `subsec:hypotheses` sowie die [number withheld] Unterabschnitte in den anderen Dateien). Ob die Datei übersetzt, ist **noch nicht geprüft**, der PI muss den Befehl ausführen.
[number withheld]. **Bib-Keys in [number withheld]_framework.tex:** huang2[number withheld]leverage ✓, mills2[number withheld]offbalance ✓, owens2[number withheld]quarterend ✓, chen2[number withheld]financing ✓. Alle stehen in `proposal/references.bib`, wie der Prüfbericht bestätigt. Es gibt keine neuen Keys. Die anderen Dateien sind unverändert; ihre Keys hat `review/T018.md` bereits geprüft (Kriterium [number withheld]).
[number withheld]. **Zahlen im neuen Text:**
   - [number withheld], [number withheld] (Schwellen) → `replication/code/01_clean.R` und `t004_variable_dictionary.csv` (unverändert).
   - Das JV-Gedankenbeispiel (Aktiva [number withheld], Schulden [number withheld], Eigenkapital [number withheld], Cash [number withheld]; Projektaktiva [number withheld], Cash [number withheld], Schulden [number withheld], Beteiligung [number withheld]; RL2 [number withheld] → [number withheld]) ist eine Rechenillustration aus `review/T018.md`, Befund [number withheld], und keine Datenangabe. Im Kommentar ist es als solche gekennzeichnet. Ich habe nachgerechnet: ([number withheld][number withheld])/[number withheld] = [number withheld] und ([number withheld][number withheld])/[number withheld] = [number withheld].
   - Weitere neue Zahlen gibt es nicht.
[number withheld]. **Kein Fließtext, keine aktiven Zitate:** erfüllt. Alle neuen Zeilen beginnen mit `%`.

## Offene Fragen
- Im Diagrammplan und in [number withheld] habe ich kleine Folgeänderungen gemacht. Sie waren nötig, damit [number withheld] nicht mehr auf gestrichene M- und A-Punkte verweist und der Diagrammplan dem neuen JV-Befund nicht widerspricht. Die Rückmeldung sagt „Nothing else changes“; ich halte diese Änderungen für reine Konsistenzanpassungen ohne neuen Inhalt. Der Co-PI sollte das bestätigen.
- Bei (ii) habe ich angenommen: Wird das Partnerkapital als Verbindlichkeit gebucht, steigt RL1 (tl und ta steigen gleich stark, RL1 < [number withheld]), und `mi_share` erfasst nur den Fall, in dem es als Eigenkapital gebucht ist. Gegen die genaue Definition von `mi_share` in `01_clean.R` habe ich das nicht noch einmal geprüft.
- Den Kommentar `% TODO(PI): notation and whether the debt-growth cap enters the constraint` habe ich stehen lassen.
- Die H4-Formulierung muss laut Co-PI noch vom PI bestätigt werden.
- Die Übersetzung ist nicht geprüft (siehe Ausführung).
- Vorschlag für `AI_USAGE_LOG.md`: „2026-10-18 | Claude (Writer) | T018 REWORK [number withheld]: Gliederung in [number withheld]/[number withheld] vereinfacht und Kennzahlenrichtungen beim JV- und Minderheitspartner-Kanal nur noch bedingt formuliert, nur LaTeX-Kommentare.“
