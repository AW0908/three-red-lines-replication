## Rolle: consistency (claude, sonnet) – VERDICT: REWORK


Die geprüften Zahlen im Text stimmen mit den CSVs überein. Ein Kartenpunkt (6(i), Appendix C) fehlt, dazu kommen drei kleine Formulierungsmängel.

## Befunde

1. **Punkt 6(i) fehlt.** Der AI-Appendix-Absatz ist nicht geschrieben (`tasks/T069_report.md`, "Offene Fragen"). Der Bericht begründet das mit dem Schreibbereich, der nur `results.tex` erlaubt. Die Karte fordert den Absatz aber ausdrücklich. Abnahmekriterium 3 ("Punkte 1–7 je mit einer Zeile") ist damit nur teilweise erfüllt. Das ist eine Entscheidung für den Co-PI oder PI: Schreibbereich erweitern oder den Punkt streichen. Der Absatz darf nur persönliche Prüfungen behaupten, die Anton bestätigt.

2. **Nenner bei den Beträgen unklar** (`06_preliminary_analysis.tex:81`).
   - Der Text sagt, unter allen 31 Crossern seien "just RMB 0.4 billion of RMB 190.5 billion in minority capital" zugeordnet.
   - `t047_attribution_totals.csv` (all_33_events_31_firms) weist 190,538,421,139 nur für beobachtete Firmenjahre aus (20 von 33). Zugeordnet sind 415,961,000 (0,218 %).
   - Das Beobachtungsproblem steht nur in der Tabellennote (Tabelle 5), nicht im Satz selbst. Der Satz liest sich wie eine Gesamtsumme.

3. **"Pooled ΔΔb is 3.27" ist irreführend** (`06_preliminary_analysis.tex:18`).
   - 3,27 [−1.85, 9.05] ist `private_minus_SOE` aus `t066_ownership_bunching.csv`. Der Wert stimmt, aber es ist kein Vergleich Entwickler gegen Kontrolle.
   - Der Wert stimmt zufällig mit 3.27 in Tabelle 3 überein (A-Share, Co-main-Fit, `t051_robustness.tex:16`). Das stiftet Verwechslungsgefahr.
   - Im Text fehlt der Hinweis `low_support = TRUE` für die private Gruppe. Im Anhang (`results.tex:348`) steht er.

4. **3.9954 ist ein Gesamttest mit 3 Freiheitsgraden** (`06_preliminary_analysis.tex:142`). Das nennt der Text nicht. Der größte Einzelwert liegt bei 3.57, `jv_ta`/Z1. Die RL1-Erststufe von 1.8796 ist die Einzelstatistik für Z3. Außerdem sagt die Note zu `t069_heckman` "candidate-only Wald selects the model", gewählt ist bei `jv_ta` aber die Zeile `joint` (`t066_first_stage.csv`, selected = TRUE). Das ist leicht zu beheben.

## Abnahmekriterien

- **1. Jede Zahl aus CSV, Verweise lösen auf:**
  - Belegt für die Textzahlen, die ich gegen die CSVs geprüft habe:
    - DR-DiD: −0.1023 [−0.3007, 0.0599], −0.0704 [−0.1842, 0.0183], Eigentümer-ATT −0.0464 [−0.2450, 0.2687], Y2 0.2069.
    - Vortrends: 1 von 24 Intervallen schließt null aus (Y2, 2016-12-31).
    - Heckman und Reporting-IPW: −0.0219 [−0.0423, 0.0025], 3.8369, 3.9136, −0.0767 [−0.5218, 0.6850].
    - ΔΔb und Bunching: 2.67 [−0.22, 6.35], 4.59 [2.15, 7.47], 3.54 (`t031_timing`, `ii_2021H1_2022H2`).
    - Offenlegung: 10/249, RMB 0.4 von 190.5 Mrd.
  - Die Placebos bei 0.60 und 0.80 haben Konfidenzintervalle, die null einschließen.
  - Die Sant'Anna-Zhao-Referenz steht in `references.bib`. Sie ist nur nach den Angaben der Karte eingetragen, das Original ist ungeprüft. Der LaTeX-Kommentar sagt das offen.
- **2. Haupttext endet auf Seite 15, Build sauber:** Der Build-Bericht meldet fehlerfreie Übersetzung (`review/T069_latex.txt`). Die Seitenzahl 15 konnte ich nicht selbst prüfen, siehe unten.
- **3. Punkte 1–7:** teilweise erfüllt (Befund 1). Alle übrigen Punkte sind im Text auffindbar:
  - DR-DiD: Abschnitt 4 (`04_empirical_model.tex:46`) und Tabelle 2 (`t050_identification.tex`).
  - Evidenzhierarchie und Zielpopulationen: Tabelle 3 und die Konklusion.
  - Sektorschock, Anwendung der 2020H2-Regel und Heckman: `06_preliminary_analysis.tex`, Abschnitt Discussion.
  - Literatur und Fußnote: `02_literature.tex:8`.
  - 531/630 und Einheit der Regulierung: `05_context_data.tex:26,70`.
  - Look-through-Formulierung: `07_conclusion.tex:11`.
  - Replikation: Zeile 76 von `05_context_data.tex`, nur per Stichwort gefunden, nicht gelesen.
- **Punkt 6(j), gemeinsamer Tabellenhelfer:** Die neuen Tabellen laufen über `\apptable`, ob das der T070-Helfer ist, habe ich nicht gegengeprüft.
- **Punkt 7, Kürzungen und Schreibbereich:** nicht meine Rolle.

## Nicht geprüft

- Seitenzahl 15, Seitenumbruch und Rendering der PDFs. Ich habe nur Quelldateien gelesen und keinen Befehl ausgeführt (Bash war nicht erlaubt).
- Die Zellen der meisten Anhangstabellen (`t069_dr_*`, `balance_*`, `first_*`, `lee`, `ownership`) gegen die CSVs. Ich habe nur Stichproben der Textzahlen und der Notes geprüft. Die Behauptung "168/168 Zeilen stimmen" des Workers habe ich nicht nachvollzogen.
- Der Absatz zur Replikation (`05_context_data.tex:76`).
- Die Datei `AI_USAGE_LOG.md`, der Abschnitt Conclusion hinter Zeile 13, der Abstract in `main.tex` und die Gleichungsnummern.
- Die Konsistenz von Abschnitt 3 (`03_framework.tex`) mit dem neuen Text.
- Die Änderungen außerhalb des Schreibbereichs in `sections/*.tex`, nach dem Wortlaut der Karte erlaubt.
