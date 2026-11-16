## Ergebnis
Ich habe die vier Punkte aus `review/T020.md` behoben, die laut „Co-PI feedback (after ESCALATE)“ offen waren (Befund [number withheld] war ein Fehler in der Karte; [number withheld]/[number withheld]/[number withheld]/[number withheld] bleibt so). In [number withheld] wird nicht mehr behauptet, die kosmetischen Outcomes seien frei vom mechanischen Zusammenhang. Dort steht jetzt: rl2\_gap $= P([number withheld]+\text{RL2})/(E-P)$ enthält RL2; mi\_share und jv\_ta gehen nicht ins Treatment ein, sind aber womöglich korrelierte Bilanzgrößen. In [number withheld] hat die RL1-Verzerrung jetzt eine Bedingung: Sie geht nach oben nur bei positivem Eigenkapital, bei negativem Eigenkapital womöglich in die andere Richtung. In [number withheld] heißt es jetzt: [number withheld] geschätzte Modelle in S0–S1[number withheld], dazu S1[number withheld] mit fünf Zeilen, die mit S0 identisch sind. Unten steht die vollständige Liste aller Zahlen in den Abschnitten [number withheld] und [number withheld] mit ihren Quellen. Alles andere ist unverändert.

## Dateien
- `proposal/sections/04_empirical_model.tex` – [number withheld]: Absatz zum mechanischen Zusammenhang korrigiert, Kommentar zur Herkunft der rl2\_gap-Definition ergänzt; [number withheld]: Satz zur Zahl der Robustheitsmodelle und `% source:`-Kommentare angepasst
- `proposal/sections/05_context_data.tex` – [number withheld]: Bedingung für die Richtung der RL1-Verzerrung ergänzt
- Aus früheren Runden unverändert im Kandidaten: `proposal/appendix/variables.tex`, `proposal/main.tex` (JEL-Zeile, `plainnat`/`references`, `\input{appendix/variables}`), `proposal/tables/t005_*.tex`, `proposal/figures/t005_breach_shares.pdf`

## Ausführung
`agents/overleaf.sh check` – **habe ich nicht ausgeführt.** In dieser Sitzung hatte ich keine Shell, nur Datei-Werkzeuge. Der PI muss das Kompilieren prüfen. Neu ist nur Text mit Mathematik in `$...$` (`\text{rl2\_gap}`, `\text{RL2}`). Pakete, Labels und Zitate sind nicht neu dazugekommen.

## Abnahmekriterien
[number withheld]. Kompiliert ohne Fehler, keine undefinierten Referenzen oder Zitate: **nicht geprüft**, siehe Ausführung. Ich habe keine neuen `\ref` oder `\cite` eingefügt.
[number withheld]. Jede Zahl mit Quelle: **erfüllt**, die vollständige Liste folgt.

**Abschnitt [number withheld]**
- Schwellen [number withheld] / [number withheld] / [number withheld], Strikte Ungleichungen, $n_{it}\in\{[number withheld]\}$, fehlend wenn eine Ratio fehlt: `replication/code/01_clean.R` Z. [number withheld]–[number withheld]
- [number withheld]–[number withheld], $|\mathcal{T}_i|\ge [number withheld]$: `t011_robustness.tex` Hinweis S0 („[number withheld]H1–[number withheld]H2, at least [number withheld] dates“)
- Wertebereich $[[number withheld]]$: `t011_treatment_definitions.csv` Zeile dose\_pre, Spalten min = [number withheld], max = [number withheld]
- [number withheld], [number withheld], [number withheld], [number withheld]; [number withheld], [number withheld], [number withheld], [number withheld]: `t011_treatment_definitions.csv` Zeile dose\_pre, Spalten n\_firms, mean, sd, median, n\_0 bis n\_3
- [number withheld] (dose2[number withheld]), [number withheld] (distance): dieselbe Datei, Spalte n\_firms
- [number withheld], [number withheld], [number withheld]: dieselbe Datei, Spalte correlation\_with\_dose
- $p = [number withheld]$: `t011_robustness.csv` S2 / rl1, Spalte pretrend\_p ([number withheld])

**Abschnitt [number withheld]**
- Post ab [number withheld] ([number withheld]H2): `01_clean.R` Z. [number withheld]
- [number withheld] Termine von [number withheld]H2 bis [number withheld]H2: `t005_summary_stats.tex` Hinweis („Full: [number withheld]H2–[number withheld]H2“)
- Referenz [number withheld]H1, sieben Vorperioden-Koeffizienten von [number withheld]H2 bis [number withheld]H2: `t009_pretrend_tests.csv` Spalten tested\_dates und df = [number withheld]
- Fünf Nachperioden-Koeffizienten: ergibt sich aus [number withheld] − [number withheld] − [number withheld]
- [number withheld] %: Konvention, passt zu den ci\_lower/ci\_upper-Spalten in `t009_did_main.csv`

**Abschnitt [number withheld]**
- [number withheld], [number withheld], [number withheld], [number withheld], [number withheld]: `t009_pretrend_tests.csv` Spalte p\_value, Zeilen rl1, rl2, rl2\_gap, mi\_share, jv\_ta
- [number withheld] % und [number withheld]: Signifikanzkonventionen
- „sechs Termine“: [number withheld]H1–[number withheld]H2 laut S0-Hinweis
- [number withheld] und [number withheld]: `t011_robustness.csv` S1 / rl1 und rl2, Spalte pretrend\_p\_before\_2[number withheld]
- rl2\_gap-Formel: aus `01_clean.R` Z. [number withheld] und [number withheld] algebraisch hergeleitet
- Zwölf Entwickler, [number withheld], [number withheld]: `state/literature_notes.md` Z. [number withheld] und [number withheld] (UNVERIFIED)
- [number withheld]: `01_clean.R` Z. [number withheld] (dose\_2[number withheld]h1)
- [number withheld] Firmen: `t011_robustness.csv` S6 / rl1, Spalte n\_firms
- [number withheld] Termine: wie in [number withheld]

**Abschnitt [number withheld]**
- Bin-Breiten [number withheld] (RL1) und [number withheld] (RL2, RL3): `t005_bunching_counts.csv`, Bin-Grenzen lower/upper
- Zeitfenster [number withheld]H1–[number withheld]H2 und [number withheld]H2–[number withheld]H2: `t005_summary_stats.tex` Hinweis
- [number withheld]: `t005_bunching_counts.csv` rl1 pre, Spalte n\_nonmissing; ebenso `t005_summary_stats.csv` pre / rl1, Spalte N

**Abschnitt [number withheld]**
- [number withheld], [number withheld], $[number withheld]\times$SE, [number withheld] %, [number withheld] %: `t008_mde.tex` Hinweise Z. [number withheld]–[number withheld]
- Firmenzahlen [number withheld] / [number withheld] / [number withheld]: `t008_mde.csv` main\_dose\_pre, Spalte firms
- MDEs [number withheld] ([number withheld]), [number withheld] ([number withheld]), [number withheld] ([number withheld]), [number withheld] ([number withheld]), [number withheld] ([number withheld]): dieselben Zeilen, Spalten MDE und MDE\_within\_SD
- Punktschätzer [number withheld], [number withheld], [number withheld]: `t009_did_main.csv` Spalte coefficient
- [number withheld] Firmen ([number withheld] für mi\_share); [number withheld], [number withheld], [number withheld]: `t008_mde.csv` soe\_interaction, Spalten firms und MDE\_within\_SD
- [number withheld] Modelle in S0–S1[number withheld]; S1[number withheld] mit fünf Zeilen gleich S0: `t011_robustness.csv` Spalte status (Z. [number withheld]–[number withheld] bzw. [number withheld]–[number withheld]). Dass beide Firmen außerhalb von sample\_main liegen: `t011_robustness.tex` Z. [number withheld]

**Abschnitt [number withheld]**
- [number withheld] %, [number withheld] %, [number withheld]; vier Stufen; [number withheld] % und [number withheld] pp; zwölf Entwickler, [number withheld], [number withheld], Ende [number withheld]: `state/literature_notes.md` Z. [number withheld] und [number withheld]

**Abschnitt [number withheld]**
- Alle Zahlen aus `t004_panel_counts.csv`:
  - [number withheld] = [number withheld] + [number withheld] + [number withheld] + [number withheld] (Stufe [number withheld]\_universe)
  - [number withheld] = [number withheld] + [number withheld] + [number withheld] + [number withheld] ([number withheld]\_firms\_without\_financials)
  - [number withheld] Firmen und [number withheld] Firmen-Halbjahre ([number withheld]\_final_panel, all)
  - [number withheld] Firmen ([number withheld]\_final\_panel, sample\_broad)
  - [number withheld] Firmen = [number withheld] + [number withheld] + [number withheld] + [number withheld], mit [number withheld] Firmen-Halbjahren ([number withheld]\_final\_panel, sample\_main)
- [number withheld] Firmen und [number withheld] Firmen-Halbjahre: `t009_did_main.csv` Spalten n\_firms und base\_N
[firm-specific excerpt withheld in public process copy]
- [number withheld] Halbjahresenden von [number withheld] bis [number withheld]: wie in [number withheld]

**Abschnitt [number withheld]**
- Enthält keine Zahlen aus Outputs; IFRS [number withheld] ist nur der Name des Standards.

**Abschnitt [number withheld]**
- `t005_summary_stats.csv`:
  - RL1: Mittelwert [number withheld] (pre) und [number withheld] (post), Median [number withheld] und [number withheld]
  - mi\_share: Mittelwert [number withheld] und [number withheld], Standardabweichung post [number withheld], Median [number withheld] und [number withheld]
  - jv\_ta: Mittelwert [number withheld] und [number withheld]
  - RL3 im Gesamtzeitraum: Mittelwert [number withheld], Median [number withheld]
- `t005_by_dose.csv`:
  - Firmen je Gruppe [number withheld], [number withheld], [number withheld], [number withheld] (zusammen [number withheld])
  - rl1\_mean [number withheld], [number withheld], [number withheld], [number withheld]
  - mi\_share\_mean [number withheld], [number withheld], [number withheld], [number withheld]
  - share\_HK [number withheld] und [number withheld]
  - share\_delisted [number withheld] und [number withheld]

[number withheld]. Gleichungen definiert, Stichprobenbegriffe [number withheld] / [number withheld] / [number withheld] / [number withheld] einheitlich: **erfüllt** (siehe Prüfbericht; diese Runde hat daran nichts geändert).
[number withheld]. Keine Politikfakten über die Fokuspaper-Notizen hinaus, keine neuen Literaturangaben: **erfüllt**. Diese Runde hat keine Fakten oder Zitate ergänzt.
[number withheld]. Länge, geschätzt: Abschnitt [number withheld] etwa [number withheld] Seiten (vorher [number withheld], plus etwa [number withheld] Zeilen), Abschnitt [number withheld] etwa [number withheld] Seiten. Gerendert habe ich das nicht.

## Offene Fragen
- Ich konnte nicht kompilieren (keine Shell). Bitte `agents/overleaf.sh check` ausführen und das Log nach undefinierten Referenzen durchsuchen.
- Die rl2\_gap-Formel habe ich selbst aus dem Code hergeleitet. Sie gilt nur, wenn $E>[number withheld]$ und $E-P>[number withheld]$ ist; das steht im Text als „positive denominators“.
- In [number withheld] ist die Richtung der RL1-Verzerrung bei negativem Eigenkapital als „can go the other way“ formuliert. Für negatives Eigenkapital gilt das so nicht in jedem Fall, denn der Nenner $T-A$ kann ebenfalls nicht positiv werden und die Ratio ist dann fehlend.
- Weiter offen: die Autorenangabe beim Fokuspaper (Guo et al. oder Jin et al., `% TODO(PI)`), die Primärquelle für die Politikdaten (`% SOURCE TODO`) und die optionale Zitierung von callaway2[number withheld].
