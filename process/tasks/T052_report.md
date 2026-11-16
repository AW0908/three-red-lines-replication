## Ergebnis
Absatz [number withheld] der Einleitung nennt jetzt die ökonomische Tragweite mit den beiden zitierten Quellen, und die Sätze stehen wörtlich wie in der Karte. Die Tabellennotiz folgt den Funden [number withheld]–[number withheld] des T051-Language-Reviews, und in [number withheld] ist der unklare Bezug behoben. Der Haupttext endet auf Seite [number withheld], der Build ist sauber.

## Dateien
- `proposal/sections/01_introduction.tex` – Absatz [number withheld]: Stakes-Sätze eingefügt. Gekürzt, damit der Haupttext auf Seite [number withheld] bleibt:
  - Der Satz zu Mitteilung und Inkrafttreten ist zu einem verschmolzen, mit einem Zitat.
  - Die Sätze zu Tier und Cap sind zu einem zusammengefasst.
  - „discrete“ und „There are two ways to get there“ (Fund [number withheld]) sind umformuliert.
  - Der Schlusssatz „Whether compliance is partly on paper …“ ist durch „so compliance may be partly ‘on paper’“ ersetzt, weil der neue Satz „supervisors misjudge exactly this exposure“ ihn inhaltlich abdeckt.
- `proposal/tables/t051_robustness.tex` – Notiz:
  - „[number withheld] percent CI“ und „Firm-bootstrap CIs, [number withheld] draws“.
  - Halbsatz zur Zeile [number withheld]: „mass-conserving fit: the counterfactual above the threshold is raised until total mass matches“.
  - Das Fragment „single dates: …“ ist ein ganzer Satz.
- `proposal/sections/06_preliminary_analysis.tex` – Zusammenfassungssatz: „simulated measurement error … shrinks the estimate“.
- `review/T0[number withheld]_build/` – Build-Ausgabe.

## Ausführung
`cd proposal && latexmk -interaction=nonstopmode -outdir=../review/T0[number withheld]_build main.tex`
Letzte Zeilen: „Latexmk: All targets (…/main.xdv …/main.pdf) are up-to-date“. Die Log-Datei enthält nur eine Font-Warnung (Songti-Kursiv), keine undefinierten Referenzen oder Zitate.

## Abnahmekriterien
[number withheld]. Haupttext endet auf Seite [number withheld] und der Build ist sauber: **erfüllt.** Die gedruckte Seite [number withheld] enthält das Ende der Conclusion („…through Peking University (Wind)“), danach folgen die References. Nach dem ersten Einfügen lief der Text noch [number withheld] Zeilen auf Seite [number withheld] über; die Kürzungen in Absatz [number withheld] haben das behoben.
[number withheld]. Beide Zitate lösen auf, sonst nichts Inhaltliches geändert: **erfüllt.** Im PDF stehen „(Rogoff and Yang, [number withheld])“ und „(Liu and Xiong, [number withheld])“, beide Einträge sind in `references.bib` vorhanden. Die Drei-Absatz-Regel ist unverändert.

Zahlen im neuen Text: nur „about [number withheld] percent“. Sie stammt aus Rogoff und Yang ([number withheld]), die der PI laut Karte am 2026-10-30 geprüft hat, und steht nicht in `replication/outputs/`. Alle anderen Zahlen waren schon vorher im Text, ihre `% source:`-Kommentare sind unverändert.

## Offene Fragen
- Die Karte schlägt vor, die Sätze zu RL2 und RL3 zu verschmelzen. Sie stehen im Text aber schon in einem Satz. Stattdessen habe ich die Sätze zu Tier und Cap zusammengefasst und den Satz zu Mitteilung und Inkrafttreten verschmolzen.
- Das zweite Zitat von `jin2[number withheld]deleveraging` im Satz zu Mitteilung und Inkrafttreten entfällt, weil der Satz nun mit einem Zitat schließt. Inhaltlich ändert sich daran nichts.
- Die Quell-PDFs unter `literature/[number withheld]_context/` habe ich nicht erneut gelesen; ich habe mich auf die PI-Entscheidung vom 2026-10-30 verlassen.
- Die Seitenangabe bezieht sich auf die gedruckte Nummerierung (PDF-Seite [number withheld] trägt die Nummer [number withheld]).
- Nicht umgesetzt, weil außerhalb des Schreibbereichs: die Funde [number withheld]–[number withheld] und [number withheld] des T051-Reviews. Das betrifft `06_preliminary_analysis.tex:45`, `04_empirical_model.tex:50` und `07_conclusion.tex`.
- Die Conclusion ist unverändert und enthält noch „we estimate no causal policy effect“ und „subsidiary equity“.
