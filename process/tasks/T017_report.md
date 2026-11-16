## Ergebnis
Die Titelseite in `proposal/main.tex` ist neu aufgebaut: Titel, Autor, Kurs, Datum, Abstract mit [number withheld] Wörtern und [number withheld] Keywords, ohne Seitenzahl. Danach folgt das Inhaltsverzeichnis (nur Sections und Subsections, römische Seitenzahl). Die Introduction beginnt bei arabisch [number withheld]. Ich habe nichts kompiliert, weil ich kein Bash habe. `agents/overleaf.sh check` muss Anton laufen lassen.

## Dateien
- `proposal/main.tex` – Titelseite (`titlepage`), Abstract, Keywords, JEL-Kommentar, Inhaltsverzeichnis mit `tocdepth=[number withheld]`, Seitennummerierung römisch → arabisch. Die Elemente `\title/\author/\date/\maketitle` sind ersetzt.
- `proposal/preamble.tex` – `hypertexnames=false` in `\hypersetup`, damit die Hyperref-Anker trotz Neustart der Seitenzählung eindeutig bleiben.

## Ausführung
`agents/overleaf.sh check` wurde nicht ausgeführt. Mir steht kein Bash zur Verfügung, die Aufgabenkarte sieht den Lauf durch den PI vor.

## Abnahmekriterien
[number withheld]. **Abstract ≤ [number withheld] Wörter, einzeilig: erfüllt (manuell gezählt: [number withheld]).** Gezählt wurden Whitespace-Tokens, Zahlen und Bindestrich-Wörter als je eins. Die Quellen stehen als Kommentare direkt über dem Abstract:
   - [number withheld] Firmen: `t009_did_main.csv`, Spalte `n_firms`, Zeile `rl2`.
   - [number withheld]: `t009_did_main.csv`, Zeile `rl2`, `coefficient` = [number withheld].
   - CI [number withheld] bis [number withheld]: dieselbe Zeile, [number withheld] bis [number withheld].
   - [number withheld] % und [number withheld] %: `t005_bunching_counts.csv`, `rl1`, `threshold_below` [[number withheld], [number withheld]), Anteil pre [number withheld] und post [number withheld].
[number withheld]. **[number withheld]–[number withheld] Keywords: erfüllt ([number withheld]).** Three Red Lines; deleveraging; window dressing; property developers; China.
[number withheld]. **Titelseite ohne Seitenzahl, Inhaltsverzeichnis auf eigener Seite, Introduction bei arabisch [number withheld]: im Code umgesetzt, aber nicht kompiliert.** Das Inhaltsverzeichnis steht auf Seite i.
[number withheld]. **Kompilierung: offen.** Das muss Anton mit `agents/overleaf.sh check` prüfen.
[number withheld]. **Keine Änderungen außerhalb des Schreibbereichs, keine erfundenen Ergebnisse oder Quellen: erfüllt.**

## Offene Fragen
- **Firmenzahl [number withheld] nicht verifiziert:** In `replication/outputs/` und im README habe ich "[number withheld] Firmen im Panel" nicht gefunden, daher steht sie nicht im Abstract. Verifiziert ist nur n_firms = [number withheld] aus `t009_did_main.csv`. Die Stop-Bedingung der Karte ("Zahl passt nicht zu den Dateien") greift deshalb für die [number withheld]. Der Co-PI sollte sie prüfen, falls sie in den Text soll.
- **Robustheit:** Wie vom Co-PI verlangt, steht im Abstract nichts zu stabilen Vorzeichen über die Robustheitsspezifikationen.
- **Kausal-Sprache:** Der Abstract sagt "net gearing fell by [number withheld] more per additional pre-policy breached line" mit "imprecise" und "preliminary". Er behauptet keinen kausalen Effekt.
- **Bunching:** Das [number withheld]-Schwellenfenster ist [[number withheld], [number withheld]), also unterhalb der Schwelle. Der Abstract sagt deshalb "just below".
- **To-dos für Anton:** Die Marker `% TODO(PI)` stehen bei Titel, Student-ID/E-Mail und dem Datum [number withheld] November [number withheld]. `% OPEN QUESTION TO PI` fragt, ob das Inhaltsverzeichnis zum Seitenlimit zählt (Annahme: nein). JEL-Codes stehen nur als Kommentar.
- **Kleiner Code-Hinweis:** `\end{quote}` und `\vspace` stehen innerhalb von `singlespace`. Falls der Abstract in der Ausgabe zu breit oder zu eng wirkt, ist dort die Stellschraube.
- **Protokoll:** Eintrag in `AI_USAGE_LOG.md` vorschlagen: Abstract-Entwurf und LaTeX-Titelseite durch Claude.
