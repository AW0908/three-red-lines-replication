## Rolle: language (claude, sonnet) – VERDICT: REWORK


## Befunde
Rolle `language`: Ich habe `presentation/slides/main.tex` gelesen. Es gibt keine sinnentstellenden Fehler und keine Tippfehler. Die Rechtschreibung ist durchgehend amerikanisch, und die Anführungszeichen und Gedankenstriche (`--`) sind korrekt. Die folgenden Punkte sind Stil- und Konsistenzmängel, die sich beheben lassen.

[number withheld]. **Abkürzungen nicht beim ersten Auftreten definiert** (Regel der Rolle). Auf den Folien selbst, nicht nur in den Kommentaren, fehlt die Definition von:
   - `MI` (Z. [number withheld] Titel „Freezing MI…“, Z. [number withheld]/[number withheld] „MI growth“). Z. [number withheld] und Z. [number withheld] sagen nur „minority equity“, `MI` wird nie eingeführt. Vorschlag: Z. [number withheld] „Freezing minority interests (MI) lowers…“ oder durchgehend „minority equity“.
   - `pp` (Z. [number withheld]). Vorschlag: „percentage points“ oder „[number withheld] pp“ mit „percentage points“ in der Zeile darunter (Z. [number withheld]).
   - `HK` (Z. [number withheld] „A-share + HK“). Vorschlag: „A-share and Hong Kong“.
   - `Δb` und `ΔΔb` (Z. [number withheld], [number withheld], [number withheld], [number withheld]). Die Folien erklären `b` nirgends, die Definition steht nur im Kommentar Z. [number withheld]. Vorschlag: Z. [number withheld] ergänzen mit „bunching $b$; $\Delta\Delta b$ = difference-in-bunching“.
   - `CI(s)` (Z. [number withheld], [number withheld]), `DR-DiD` (Z. [number withheld]), `SOE` (Z. [number withheld]), `IPW` (Z. [number withheld]). Vorschlag: einmal ausschreiben, z. B. „doubly robust DiD“ und „state-owned enterprises (SOE)“, oder im Tabellenkopf kurz auflösen.
   - `crossers` (Z. [number withheld]) ist Jargon ohne Einführung. Vorschlag: „firms crossing the [number withheld]% line“.
[number withheld]. **Inkonsistente Schreibweise der Schwelle.** Z. [number withheld] und [number withheld] schreiben „[number withheld]\%“ bzw. „$\le [number withheld]\%$“, Z. [number withheld] schreibt „Below $[number withheld]$“. Vorschlag: durchgehend „[number withheld]\%“, oder „[number withheld]“ nur zusammen mit der Variablen RL1.
[number withheld]. **Uneinheitliche Bezeichnung der drei Linien.** Z. [number withheld] beschriftet nur „RL1“. „Net gearing“ und „Cash / short-term debt“ (Z. [number withheld], [number withheld]) tragen kein Label, obwohl die Kommentare RL3 verwenden. Vorschlag: „RL2: net gearing ≤ [number withheld]%“ und „RL3: cash / short-term debt ≥ [number withheld]“. Dann ist auch die Schreibweise der Zeilen einheitlich: „Net gearing“ gegenüber „Cash / short-term debt“ unterscheidet sich im Leerzeichen um den Schrägstrich, während Z. [number withheld] „N/(N+E)“ ohne Leerzeichen schreibt.
[number withheld]. **Satzfragmente mit uneinheitlicher Zeichensetzung in den Quellzeilen.** Z. [number withheld] „Different axes; pointwise [number withheld]\% CIs.“ und Z. [number withheld] „Separate scales.“ sind knapp, aber akzeptabel. Z. [number withheld] setzt die Intervalle als „[number withheld]\ [[number withheld]]“ ohne Mathematikmodus, während „$[[number withheld]]$“ im Mathematikmodus steht. Der Minuszeichen-Effekt ist hier unkritisch, aber die Formatierung sollte vereinheitlicht werden (alle Intervalle in `$…$`).
[number withheld]. **Begriffsvariation „minority equity“ / „minority interest(s)“ / „MI“.** Die Folien wechseln zwischen den drei Formen (Z. [number withheld], [number withheld], [number withheld]). Vorschlag: eine Form festlegen, z. B. „minority equity (MI)“ bei erstem Auftreten in Frame [number withheld].
[number withheld]. **Hinweis, nicht Teil meiner Rolle (inhaltlich):** Die Titel von Frame [number withheld] („Public disclosure would make compliance easier to assess“) und die Stichpunkte darunter beschreiben Arbeitsschritte statt Politikimplikation. Die Karte verlangt „disclosure as main policy implication“. Das sollte die Rolle `consistency` bewerten.

## Abnahmekriterien
- Kriterium [number withheld] (Kompilierung, Frame-Anzahl): nicht meine Rolle. Die Frame-Anzahl in `main.tex` ist [number withheld] Hauptframes plus [number withheld] Backup-Frames (Z. [number withheld]–[number withheld]).
- Kriterium [number withheld] (Zahlen-Audit): nicht meine Rolle.
- Kriterium [number withheld] (Sichtprüfung): nicht meine Rolle.
- Kriterium [number withheld] (Bericht, Sprechzeit): nicht meine Rolle. Die Kommentarzeile Z. [number withheld] summiert [number withheld] Sekunden, was zu den geforderten [number withheld]–[number withheld] Minuten passt.
- Stil-Vorgabe der Karte „American spelling“ und „Speaker notes als LaTeX-Kommentare in English“: belegt erfüllt (z. B. „normalized“ Z. [number withheld], „color“ im Theme-Block).
- Stil-Vorgabe „Max ~[number withheld] Wörter Fließtext pro Frame“: aus sprachlicher Sicht eingehalten, soweit gezählt.

## Nicht geprüft
- Die gerenderten PNGs und `main.pdf`: Ich habe nur den Quelltext gelesen. Ob die Folientexte im PDF tatsächlich so umbrechen, ob es Overfull-Boxes gibt oder ob Zeichen fehlerhaft dargestellt werden, habe ich nicht gesehen.
- `tasks/T068_report.md`, `T068_number_audit.csv` und `T068_verification.json`: Sprache dort nicht geprüft, da die Rolle auf die LaTeX-Texte beschränkt ist.
- Inhaltliche Richtigkeit der Zahlen: nicht meine Rolle.
