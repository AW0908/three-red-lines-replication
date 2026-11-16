# Zusatz für Schreibaufgaben (Worker schreibt in `proposal/`)

`proposal/` ist ein Git-Klon des Overleaf-Projekts. Du bearbeitest dort nur die LaTeX-Dateien, die
im Schreibbereich der Karte stehen. Du führst kein Git aus; Abgleich mit Overleaf macht das Skript.

- **Sprache und Form:** Englisch, wissenschaftlicher Stil eines Economics-Papers. Vorgaben des
  Syllabus: [number withheld]-facher Zeilenabstand, [number withheld] Zoll Rand, [number withheld]pt Times New Roman; Entwurf [number withheld]–[number withheld] Seiten.
- **Jede Zahl hat eine Quelle im Projekt.** Zahlen, Tabellen und Abbildungen stammen nur aus
  Dateien unter `replication/outputs/`. Direkt darüber steht ein LaTeX-Kommentar `% source: replication/outputs/...`.
  Keine Zahl aus dem Gedächtnis, keine gerundete Schätzung, kein „ungefähr“.
- **Jede Literaturangabe ist belegt.** Zitiert wird nur, was in `PROJEKT_STAND.md` oder
  `literature/` mit Quelle steht. Den dort vermerkten Prüfstatus übernimmst du: Was als ungeprüft
  oder „nur Abstract“ markiert ist, bekommt im Text den Kommentar `% UNVERIFIED: ...` und darf
  keine Aussage tragen, die über den Abstract hinausgeht.
- **Keine neuen inhaltlichen Entscheidungen.** Forschungsfrage, Estimand, Stichprobe und
  Identifikationsannahmen übernimmst du aus `PROJEKT_STAND.md` und `state/STATE.md`. Fehlt etwas,
  schreibst du `% TODO(PI): ...` an die Stelle und nennst es im Bericht unter „Offene Fragen“.
- **Annahmen beim Namen nennen.** Wo der Text einen kausalen Effekt behauptet, steht die
  Identifikationsannahme im selben Absatz.
- **LaTeX muss übersetzbar bleiben.** Sonderzeichen maskieren (`_`, `%`, `&`), nur Pakete nutzen,
  die in der Präambel stehen oder die du dort ergänzt, wenn die Präambel im Schreibbereich liegt.
- Im Bericht unter „Dateien“ jede geänderte `.tex`- oder `.bib`-Datei nennen, unter
  „Abnahmekriterien“ zusätzlich: Liste aller Zahlen im neuen Text mit ihrer Quelldatei.
