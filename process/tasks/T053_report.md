## Ergebnis
Ich habe die Conclusion (`proposal/sections/07_conclusion.tex`) als Policy Conclusion neu geschrieben. Sie hat jetzt diese Reihenfolge: Frage, drei gewichtete Ergebnisse, zwei als Implikationen formulierte Policy-Empfehlungen (Offenlegung und Look-through-Messung), Übertragbarkeit, Grenzen und ein Plan in einem Satz. In Absatz [number withheld] der Introduction habe ich die Befunde [number withheld] und [number withheld] aus `review/T052_language.md` behoben. Der Build läuft fehlerfrei durch. Der Hauptteil endet auf Seite [number withheld], allerdings **ohne Puffer**: Die erste Fassung endete auf Seite [number withheld], deshalb musste ich die Conclusion kürzen, bis sie unter der bisherigen Länge lag. Die Vorgabe „plus at most one third of a page“ war nicht nutzbar, weil der erwartete halbe Seitenpuffer im aktuellen Satz nicht mehr besteht.

## Dateien
- `proposal/sections/07_conclusion.tex` – Conclusion vollständig neu geschrieben
- `proposal/sections/01_introduction.tex` – Absatz [number withheld]: Sätze umgestellt und Satz zum Tier umformuliert
- `review/T0[number withheld]_build/` – Build-Ausgabe (`main.pdf`, `main.log`, `main.aux`)
- `proposal/sections/06_preliminary_analysis.tex` – nicht geändert (siehe Offene Fragen)

## Ausführung
[fenced excerpt withheld in public process copy]
[fenced excerpt withheld in public process copy]
Letzte Zeile: `Latexmk: All targets (.../review/T053_build/main.xdv .../main.pdf) are up-to-date` ([number withheld] Seiten, [number withheld] KB). Im Log gibt es keine `!`-Fehler und keine undefinierten Referenzen oder Zitate. Es bleibt nur die bereits bekannte Font-Warnung zu `SongtiSC/it`. In `main.aux` steht: `\newlabel{sec:main_end}{{[number withheld]}{[number withheld]}...}`.

**Neue Conclusion im Wortlaut:**

> We asked whether developers targeted RL1 and what their compliance consists of. In our primary result, excess mass just below the threshold rises by [number withheld] ([number withheld] percent CI $[[number withheld]]$), indicating targeting if the counterfactual density is smooth and reporting selection stable. In the secondary result, freezing MI at end-[number withheld] lowers compliance by [number withheld] percentage points, although MI growth did not exceed its pre-policy pace and, under the firm trend, was slower. In the exploratory result, public filings classify the terms of only [number withheld] of [number withheld] equity transactions.
>
> If the red lines are to measure risk, our findings suggest two implications. First, supervisors could require developers to report, for material non-wholly-owned subsidiaries, the counterparty, buyback or put obligations, guarantees and shareholder loans, which our coding needed and seldom found. Second, a look-through ratio could count minority equity with buyback, guaranteed-return or shortfall terms as debt, so that compliance would track economic leverage more closely. Their effects, costs and feasibility are outside this proposal. Loan covenants and bank capital ratios raise the same question of which adjustments count, since reported ratios respond to such thresholds~\citep{dichev2[number withheld]largesample, owens2[number withheld]quarterend}.
>
> We estimate no causal policy effect, do not observe economic leverage, and do not read missing terms as evidence of debt-like equity. For the final paper, we will trace the partners behind the largest unclassified MI increases in the national enterprise credit registry (\url{https://gsxt.gov.cn}) and obtain the closing reports missing for ten crossing events.

**Änderungen in der Introduction (Absatz [number withheld]):**
- Befund [number withheld]: Die Sätze „Such equity may share project risk … resemble debt, so compliance may be partly ``on paper''.“ stehen jetzt direkt nach dem Satz zu den zwei Wegen. Danach folgen „The stakes are large: …“ und „If reported compliance overstates deleveraging, supervisors misjudge exactly this exposure.“ als Schluss. Die Reihenfolge ist damit: Policy → Anreiz → zwei Wege → Art dieses Eigenkapitals → was auf dem Spiel steht.
- Befund [number withheld]: „…caps the annual growth of its interest-bearing debt at [number withheld] percent, minus [number withheld] percentage points for each line breached.“ Die Wendung „when all three lines are met“ ist gestrichen.
- Sonst ist nichts geändert. Befund [number withheld] aus T052 (Satz zu den zwei Wegen teilen) stand nicht in der Karte und ist unverändert.

## Abnahmekriterien
[number withheld]. **Keine neuen Zahlen oder Quellen; Empfehlungen als Implikationen formuliert: erfüllt.** Zahlen im neuen Text:
   - [number withheld] und das KI [[number withheld]; [number withheld]] stammen aus `replication/outputs/tables/t043_delta_b.csv` ([number withheld], main) und stehen schon in Introduction und Abschnitt [number withheld].
   - [number withheld] Prozentpunkte stammen aus `replication/outputs/tables/t029_compliance.csv` (all, pooled, post, D) und stehen schon in Introduction und Abstract.
   - [number withheld] von [number withheld] stammt aus `replication/outputs/tables/t047_coding.csv` (pooled, all_3[number withheld]_events_3[number withheld]_firms; D+G+H+E = [number withheld], all = [number withheld]) und steht schon im Abstract und in [number withheld] ([number withheld] von [number withheld] U).
   - „end-[number withheld]“ und „firm trend“ stammen aus `replication/outputs/tables/t043_trend_cf.csv`.
   - „ten crossing events“ stammt aus `replication/outputs/audit/T047/source_inventory.csv` (closing_report_local = FALSE: [number withheld]) und stand schon in der alten Conclusion.
   - [number withheld] kommt im Text nicht mehr vor.
   - Zitate: nur vorhandene Schlüssel aus Abschnitt [number withheld] (`dichev2[number withheld]largesample`, `owens2[number withheld]quarterend`), mit dem Kommentar `% UNVERIFIED` wie in Abschnitt [number withheld].
   - Die Empfehlungen sind als Implikationen formuliert („our findings suggest“, „could require“, „would track“). Wirkung, Kosten und Machbarkeit sind ausdrücklich ausgeklammert.
[number withheld]. **Hauptteil endet spätestens auf Seite [number withheld], Build sauber: erfüllt.** `sec:main_end` steht auf Seite [number withheld], das Log ist fehlerfrei. Es bleibt kein Zeilenpuffer.
[number withheld]. **Bericht zitiert die Conclusion vollständig und listet die Änderungen in der Introduction: erfüllt** (siehe oben).

## Offene Fragen
- **Seitenumfang:** Um auf Seite [number withheld] zu bleiben, habe ich gegenüber der alten Fassung gekürzt. Weggefallen sind:
  - die Liste von [number withheld] Unternehmen,
  - der Hinweis „document a few large transactions in depth“,
  - der Satz „All data are public or licensed through Peking University (Wind)“ (die Wind-Lizenz steht in Abschnitt [number withheld], Zeile [number withheld]),
  - die Begründungen der Grenzen (DiD/RD identifizieren nichts; Schulden von Partnern und Joint Ventures sind nicht beobachtet).

  Diese Begründungen stehen weiter in [number withheld] und in Tabelle [number withheld]. Die Conclusion ist jetzt kürzer als vorher und nicht, wie in der Karte vorgesehen, um bis zu eine Drittelseite länger. Wenn die PI mehr Text will, muss an anderer Stelle Platz geschaffen werden.
- **Verweis auf Abschnitt [number withheld]:** [number withheld] (Discussion) enthält keine Sätze zum Plan, deshalb gibt es nichts zu kürzen und kein sinnvolles Verweisziel. Ich habe keinen Verweis gesetzt und `06_preliminary_analysis.tex` nicht geändert. Falls die Details zum Plan in [number withheld] stehen sollen, braucht das eine eigene Karte.
- **Weggefallene Aussage:** Der Satz für Aufseher „a reported RL1 just below [number withheld] may thus reflect reporting choices“ ist weggefallen. Seine Aussage steckt jetzt im Absatz zu den Policy-Implikationen.
- **Übertragbarkeitssatz:** Er stützt sich auf `dichev2[number withheld]largesample` und `owens2[number withheld]quarterend`, die nur auf Abstract-Ebene geprüft sind. Die Aussage („reported ratios respond to such thresholds“) geht nicht über das hinaus, was Abschnitt [number withheld] schon behauptet. Owens und Wu behandeln Repo-Geschäfte zum Quartalsende, nicht Kapitalquoten im engeren Sinn. Das Beispiel „bank capital ratios“ stammt aus der Karte. Bitte von der PI prüfen lassen.
- **„closing reports missing“:** Die Quelle sagt „lokal nicht vorhanden“ (closing_report_local = FALSE), nicht „gar nicht veröffentlicht“. Der Text sagt nur „missing“ und behauptet nicht, dass die Berichte nicht veröffentlicht wurden.
