## Ergebnis
Einleitung, Related Literature und Conclusion sind fertig geschrieben, außerdem ein neues Abstract mit 98 Wörtern, fünf Keywords und die JEL-Zeile (G32, G38, R31 unverändert). Alle drei Abschnitte folgen der finalen Forschungsfrage vom 23.10. und ordnen die Belege in drei Ebenen: Targeting, Zusammensetzung, ökonomische Substanz. Jeder Befund steht mit denselben Zahlen wie in Abschnitt 6. Die Kernaussage steht wörtlich so da, wie `state/writing_rules.md` sie vorgibt („compliance at the RL1 threshold depends mechanically on minority-interest growth since 2019“), jeweils mit dem Hinweis, dass das kein kausaler Policy-Effekt ist. `main.tex` habe ich nicht kompiliert, weil der Worker kein Bash hat.

## Dateien
- `proposal/sections/01_introduction.tex` – Einleitung (Motivation, bekannte Reaktionen, Frage, drei Befunde, Beitrag, Gliederung), komplett neu
- `proposal/sections/02_literature.tex` – drei Literaturstränge plus ein Absatz zur Lücke; die alten Unterabschnitte (dazu gehörte ein Kontext-Strang zum Wohnungsboom, den die Karte nicht vorsieht) sind durch Fließtext ersetzt, komplett neu
- `proposal/sections/07_conclusion.tex` – Antwort auf drei Ebenen, Politik-Implikation, Grenzen, Plan bis zur finalen Fassung, komplett neu
- `proposal/main.tex` – nur Abstract mit Quellenkommentaren, Keywords und JEL-Zeile (JEL unverändert)

## Ausführung
Es gibt keinen Befehl, der Worker hat kein Bash. LaTeX wurde nicht kompiliert; das macht der PI nach Kriterium 3. Ich habe die Zahlen von Hand gegen `t029_compliance.csv` und `t029_counterfactual_bunching.csv` geprüft; sie stimmen mit Abschnitt 6 überein. Jeden Literatur-Abstract, den der Text zusammenfasst, habe ich auf der ersten Seite des PDFs in `literature/` nachgelesen.

## Abnahmekriterien
1. **Wortbudgets** – erfüllt nach Handzählung (Schätzwerte): Einleitung ca. 665/700, Literatur ca. 565/600, Conclusion ca. 335/350, Abstract 98/100 (genau gezählt). Ein automatischer Wortzähler lief nicht; T038 sollte das nachprüfen.
   **Keine neuen Keys** – erfüllt, `references.bib` ist unverändert. Verwendet habe ich nur vorhandene Keys: jin2025deleveraging, shi2026deleveraging, zeng2026deleveraging, chu2025leverage, zheng2024three, dichev2002largesample, bordeman2022borrowers, owens2015quarterend, kleven2016bunching, acharya2013securitization, mills2005offbalance, huang2025leverage.
2. **Befunde wie in Abschnitt 6, ohne Überinterpretation** – erfüllt. Zahlen im neuen Text und ihre Quellen:
   - 136 Firmen – `replication/outputs/tables/t004_panel_counts.csv` (10_final_panel, sample_main)
   - 80 A-Shares / 56 Hongkong – `replication/outputs/tables/t030_coverage.csv` (n_sample_main)
   - 13 Halbjahresenden, 31.12.2016–31.12.2022 – wie in Abschnitt 4 (`t004_panel_counts.csv`)
   - b = 3.14 [1.01, 5.84] nach der Politik, −0.88 davor – `replication/outputs/tables/t023_excess_mass.csv`
   - 3.18 → −0.52 (MI eingefroren) – `replication/outputs/tables/t029_counterfactual_bunching.csv` (post, all, paired, main)
   - 11.5 pp nach der Politik, 4.1 pp im Placebo – `replication/outputs/tables/t029_compliance.csv` (D pooled: 0.1146, 0.0406)
   - Die Schwellen 70 % und 100 % sind Regeldaten mit Literaturbeleg (jin2025deleveraging, als UNVERIFIED markiert), keine Outputs.
3. **PI kompiliert `main.tex` ohne Fehler** – nicht geprüft (kein Bash). Ich habe keine neuen Pakete verwendet. Die Labels sec:framework, sec:data, sec:empirical, sec:preliminary und sec:conclusion gibt es; `%` und `&` stehen nur in Kommentaren.

**`[cite]`-Marker für den PI** (sichtbar als `\textbf{[cite]}`, dazu jeweils ein Kommentar `% [CITE: ...]`):
- Cao & Ma (2024), *技术经济* 43(11): 89–104 – in `01_introduction.tex` und `02_literature.tex`
- Kleven & Waseem (2013) – `02_literature.tex`
- Degeorge, Patel & Zeckhauser (1999) – `02_literature.tex`

## Offene Fragen
- **Autorenliste des Focal Papers:** Der BibTeX-Eintrag `jin2025deleveraging` hat vier Autoren, das PDF fünf (Guo kommt dazu). Der Text erscheint deshalb als „Jin et al. (2025)“. Dazu steht ein `TODO(PI)` in Einleitung und Literatur.
- **Jahr bei `chu2025leverage`:** Der BibTeX-Eintrag hat `year=2023`, das PDF zeigt Band 70 (2025). Im Text erscheint deshalb „Chu et al. (2023)“; dazu steht ein Kommentar `NOTE(PI)`.
- **Prüfstand der Literatur:**
  - Die Ergebnisse von jin2025deleveraging und huang2025leverage stammen aus den Co-PI-Notizen, die der PI noch nicht verifiziert hat; im Text als `% UNVERIFIED` markiert.
  - dichev, bordeman, owens, acharya, mills, zeng und chu stehen nur auf Abstract-Ebene im Text und sind entsprechend markiert.
  - kleven2016bunching ist nur Methodenreferenz; in PROJEKT_STAND 2.2 steht „Zitat noch prüfen“.
- **Bewusst nicht zitiert:** ma2025realestate (Abstract nicht abrufbar), chan2025capital und huang2026deleveraging (keine Projektnotizen). Die Kontext-Literatur (glaeser, fang, liu, rogoff, chen2020) kommt im neuen Text nicht mehr vor, weil die Karte nur drei Stränge vorsieht. Ob sie wieder rein soll, entscheidet der PI.
- **Regeldetails ungeprüft:** Die Struktur der Schuldenwachstums-Caps je verletzter Linie ist wie in Abschnitt 4 nur über das Focal Paper belegt und als UNVERIFIED markiert.
- **Formulierung im Abstract:** „compliance falls by 11.5 percentage points“ meint den Nettoanteil der Beobachtungen, die offiziell konform sind, mit eingefrorenen MI aber nicht (51.2 vs. 39.7 %, Tabelle `tab:frozen`). Die 11.5 sind der Rundungswert aus der CSV (0.1146), nicht die Differenz der gerundeten Werte (51.2 − 39.7 = 11.6). Ob „falls“ dem PI genau genug ist, bitte prüfen.
- **„Disappears“:** Abstract und Conclusion sagen „the excess mass disappears“. Das stützt sich darauf, dass b mit eingefrorenen MI bei −0.52 liegt und das Intervall [−1.83, 1.08] die Null einschließt.
- **Prozentangabe beim Intervall:** In der Einleitung steht „95 percent confidence interval“ (nach writing_rules), in Abschnitt 6 dagegen „95\%“. T038 sollte das vereinheitlichen.
