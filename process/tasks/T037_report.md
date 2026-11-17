## Ergebnis
Einleitung, Related Literature und Conclusion sind fertig geschrieben, außerdem ein neues Abstract mit [number withheld] Wörtern, fünf Keywords und die JEL-Zeile (G3[number withheld], G3[number withheld], R3[number withheld] unverändert). Alle drei Abschnitte folgen der finalen Forschungsfrage vom [number withheld]. und ordnen die Belege in drei Ebenen: Targeting, Zusammensetzung, ökonomische Substanz. Jeder Befund steht mit denselben Zahlen wie in Abschnitt [number withheld]. Die Kernaussage steht wörtlich so da, wie `state/writing_rules.md` sie vorgibt („compliance at the RL1 threshold depends mechanically on minority-interest growth since [number withheld]“), jeweils mit dem Hinweis, dass das kein kausaler Policy-Effekt ist. `main.tex` habe ich nicht kompiliert, weil der Worker kein Bash hat.

## Dateien
- `proposal/sections/01_introduction.tex` – Einleitung (Motivation, bekannte Reaktionen, Frage, drei Befunde, Beitrag, Gliederung), komplett neu
- `proposal/sections/02_literature.tex` – drei Literaturstränge plus ein Absatz zur Lücke; die alten Unterabschnitte (dazu gehörte ein Kontext-Strang zum Wohnungsboom, den die Karte nicht vorsieht) sind durch Fließtext ersetzt, komplett neu
- `proposal/sections/07_conclusion.tex` – Antwort auf drei Ebenen, Politik-Implikation, Grenzen, Plan bis zur finalen Fassung, komplett neu
- `proposal/main.tex` – nur Abstract mit Quellenkommentaren, Keywords und JEL-Zeile (JEL unverändert)

## Ausführung
Es gibt keinen Befehl, der Worker hat kein Bash. LaTeX wurde nicht kompiliert; das macht der PI nach Kriterium [number withheld]. Ich habe die Zahlen von Hand gegen `t029_compliance.csv` und `t029_counterfactual_bunching.csv` geprüft; sie stimmen mit Abschnitt [number withheld] überein. Jeden Literatur-Abstract, den der Text zusammenfasst, habe ich auf der ersten Seite des PDFs in `literature/` nachgelesen.

## Abnahmekriterien
[number withheld]. **Wortbudgets** – erfüllt nach Handzählung (Schätzwerte): Einleitung ca. [number withheld]/[number withheld], Literatur ca. [number withheld]/[number withheld], Conclusion ca. [number withheld]/[number withheld], Abstract [number withheld]/[number withheld] (genau gezählt). Ein automatischer Wortzähler lief nicht; T038 sollte das nachprüfen.
   **Keine neuen Keys** – erfüllt, `references.bib` ist unverändert. Verwendet habe ich nur vorhandene Keys: jin2[number withheld]deleveraging, shi2[number withheld]deleveraging, zeng2[number withheld]deleveraging, chu2[number withheld]leverage, zheng2[number withheld]three, dichev2[number withheld]largesample, bordeman2[number withheld]borrowers, owens2[number withheld]quarterend, kleven2[number withheld]bunching, acharya2[number withheld]securitization, mills2[number withheld]offbalance, huang2[number withheld]leverage.
[number withheld]. **Befunde wie in Abschnitt [number withheld], ohne Überinterpretation** – erfüllt. Zahlen im neuen Text und ihre Quellen:
   - [number withheld] Firmen – `replication/outputs/tables/t004_panel_counts.csv` ([number withheld]_final_panel, sample_main)
   - [number withheld] A-Shares / [number withheld] Hongkong – `replication/outputs/tables/t030_coverage.csv` (n_sample_main)
   - [number withheld] Halbjahresenden, [number withheld]–[number withheld] – wie in Abschnitt [number withheld] (`t004_panel_counts.csv`)
   - b = [number withheld] [[number withheld], [number withheld]] nach der Politik, [number withheld] davor – `replication/outputs/tables/t023_excess_mass.csv`
   - [number withheld] → [number withheld] (MI eingefroren) – `replication/outputs/tables/t029_counterfactual_bunching.csv` (post, all, paired, main)
   - [number withheld] pp nach der Politik, [number withheld] pp im Placebo – `replication/outputs/tables/t029_compliance.csv` (D pooled: [number withheld], [number withheld])
   - Die Schwellen [number withheld] % und [number withheld] % sind Regeldaten mit Literaturbeleg (jin2[number withheld]deleveraging, als UNVERIFIED markiert), keine Outputs.
[number withheld]. **PI kompiliert `main.tex` ohne Fehler** – nicht geprüft (kein Bash). Ich habe keine neuen Pakete verwendet. Die Labels sec:framework, sec:data, sec:empirical, sec:preliminary und sec:conclusion gibt es; `%` und `&` stehen nur in Kommentaren.

**`[cite]`-Marker für den PI** (sichtbar als `\textbf{[cite]}`, dazu jeweils ein Kommentar `% [CITE: ...]`):
- Cao & Ma ([number withheld]), *技术经济* \[number withheld]([number withheld]): [number withheld]–[number withheld] – in `01_introduction.tex` und `02_literature.tex`
- Kleven & Waseem ([number withheld]) – `02_literature.tex`
- Degeorge, Patel & Zeckhauser ([number withheld]) – `02_literature.tex`

## Offene Fragen
- **Autorenliste des Focal Papers:** Der BibTeX-Eintrag `jin2[number withheld]deleveraging` hat vier Autoren, das PDF fünf (Guo kommt dazu). Der Text erscheint deshalb als „Jin et al. ([number withheld])“. Dazu steht ein `TODO(PI)` in Einleitung und Literatur.
- **Jahr bei `chu2[number withheld]leverage`:** Der BibTeX-Eintrag hat `year=[number withheld]`, das PDF zeigt Band [number withheld] ([number withheld]). Im Text erscheint deshalb „Chu et al. ([number withheld])“; dazu steht ein Kommentar `NOTE(PI)`.
- **Prüfstand der Literatur:**
  - Die Ergebnisse von jin2[number withheld]deleveraging und huang2[number withheld]leverage stammen aus den Co-PI-Notizen, die der PI noch nicht verifiziert hat; im Text als `% UNVERIFIED` markiert.
  - dichev, bordeman, owens, acharya, mills, zeng und chu stehen nur auf Abstract-Ebene im Text und sind entsprechend markiert.
  - kleven2[number withheld]bunching ist nur Methodenreferenz; in PROJEKT_STAND [number withheld] steht „Zitat noch prüfen“.
- **Bewusst nicht zitiert:** ma2[number withheld]realestate (Abstract nicht abrufbar), chan2[number withheld]capital und huang2[number withheld]deleveraging (keine Projektnotizen). Die Kontext-Literatur (glaeser, fang, liu, rogoff, chen2[number withheld]) kommt im neuen Text nicht mehr vor, weil die Karte nur drei Stränge vorsieht. Ob sie wieder rein soll, entscheidet der PI.
- **Regeldetails ungeprüft:** Die Struktur der Schuldenwachstums-Caps je verletzter Linie ist wie in Abschnitt [number withheld] nur über das Focal Paper belegt und als UNVERIFIED markiert.
- **Formulierung im Abstract:** „compliance falls by [number withheld] percentage points“ meint den Nettoanteil der Beobachtungen, die offiziell konform sind, mit eingefrorenen MI aber nicht ([number withheld] vs. [number withheld] %, Tabelle `tab:frozen`). Die [number withheld] sind der Rundungswert aus der CSV ([number withheld]), nicht die Differenz der gerundeten Werte ([number withheld] − [number withheld] = [number withheld]). Ob „falls“ dem PI genau genug ist, bitte prüfen.
- **„Disappears“:** Abstract und Conclusion sagen „the excess mass disappears“. Das stützt sich darauf, dass b mit eingefrorenen MI bei [number withheld] liegt und das Intervall [[number withheld], [number withheld]] die Null einschließt.
- **Prozentangabe beim Intervall:** In der Einleitung steht „[number withheld] percent confidence interval“ (nach writing_rules), in Abschnitt [number withheld] dagegen „[number withheld]\%“. T038 sollte das vereinheitlichen.
