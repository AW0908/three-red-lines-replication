## Ergebnis
Die Titelseite in `proposal/main.tex` ist neu aufgebaut: Titel, Autor, Kurs, Datum, Abstract mit 87 Wörtern und 5 Keywords, ohne Seitenzahl. Danach folgt das Inhaltsverzeichnis (nur Sections und Subsections, römische Seitenzahl). Die Introduction beginnt bei arabisch 1. Ich habe nichts kompiliert, weil ich kein Bash habe. `agents/overleaf.sh check` muss Anton laufen lassen.

## Dateien
- `proposal/main.tex` – Titelseite (`titlepage`), Abstract, Keywords, JEL-Kommentar, Inhaltsverzeichnis mit `tocdepth=2`, Seitennummerierung römisch → arabisch. Die Elemente `\title/\author/\date/\maketitle` sind ersetzt.
- `proposal/preamble.tex` – `hypertexnames=false` in `\hypersetup`, damit die Hyperref-Anker trotz Neustart der Seitenzählung eindeutig bleiben.

## Ausführung
`agents/overleaf.sh check` wurde nicht ausgeführt. Mir steht kein Bash zur Verfügung, die Aufgabenkarte sieht den Lauf durch den PI vor.

## Abnahmekriterien
1. **Abstract ≤ 100 Wörter, einzeilig: erfüllt (manuell gezählt: 87).** Gezählt wurden Whitespace-Tokens, Zahlen und Bindestrich-Wörter als je eins. Die Quellen stehen als Kommentare direkt über dem Abstract:
   - 124 Firmen: `t009_did_main.csv`, Spalte `n_firms`, Zeile `rl2`.
   - 0.284: `t009_did_main.csv`, Zeile `rl2`, `coefficient` = −0.28381.
   - CI −0.570 bis 0.003: dieselbe Zeile, −0.57038 bis 0.00275.
   - 4.5 % und 12.4 %: `t005_bunching_counts.csv`, `rl1`, `threshold_below` [0.68, 0.70), Anteil pre 0.04517 und post 0.12381.
2. **3–5 Keywords: erfüllt (5).** Three Red Lines; deleveraging; window dressing; property developers; China.
3. **Titelseite ohne Seitenzahl, Inhaltsverzeichnis auf eigener Seite, Introduction bei arabisch 1: im Code umgesetzt, aber nicht kompiliert.** Das Inhaltsverzeichnis steht auf Seite i.
4. **Kompilierung: offen.** Das muss Anton mit `agents/overleaf.sh check` prüfen.
5. **Keine Änderungen außerhalb des Schreibbereichs, keine erfundenen Ergebnisse oder Quellen: erfüllt.**

## Offene Fragen
- **Firmenzahl 184 nicht verifiziert:** In `replication/outputs/` und im README habe ich "184 Firmen im Panel" nicht gefunden, daher steht sie nicht im Abstract. Verifiziert ist nur n_firms = 124 aus `t009_did_main.csv`. Die Stop-Bedingung der Karte ("Zahl passt nicht zu den Dateien") greift deshalb für die 184. Der Co-PI sollte sie prüfen, falls sie in den Text soll.
- **Robustheit:** Wie vom Co-PI verlangt, steht im Abstract nichts zu stabilen Vorzeichen über die Robustheitsspezifikationen.
- **Kausal-Sprache:** Der Abstract sagt "net gearing fell by 0.284 more per additional pre-policy breached line" mit "imprecise" und "preliminary". Er behauptet keinen kausalen Effekt.
- **Bunching:** Das 0.70-Schwellenfenster ist [0.68, 0.70), also unterhalb der Schwelle. Der Abstract sagt deshalb "just below".
- **To-dos für Anton:** Die Marker `% TODO(PI)` stehen bei Titel, Student-ID/E-Mail und dem Datum 27 November 2026. `% OPEN QUESTION TO PI` fragt, ob das Inhaltsverzeichnis zum Seitenlimit zählt (Annahme: nein). JEL-Codes stehen nur als Kommentar.
- **Kleiner Code-Hinweis:** `\end{quote}` und `\vspace` stehen innerhalb von `singlespace`. Falls der Abstract in der Ausgabe zu breit oder zu eng wirkt, ist dort die Stellschraube.
- **Protokoll:** Eintrag in `AI_USAGE_LOG.md` vorschlagen: Abstract-Entwurf und LaTeX-Titelseite durch Claude.
