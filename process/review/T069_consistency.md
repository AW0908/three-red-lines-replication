## Rolle: consistency (claude, sonnet) – VERDICT: REWORK


Die geprüften Zahlen im Text stimmen mit den CSVs überein. Ein Kartenpunkt (\[number withheld](i), Appendix C) fehlt, dazu kommen drei kleine Formulierungsmängel.

## Befunde

[number withheld]. **Punkt \[number withheld](i) fehlt.** Der AI-Appendix-Absatz ist nicht geschrieben (`tasks/T069_report.md`, "Offene Fragen"). Der Bericht begründet das mit dem Schreibbereich, der nur `results.tex` erlaubt. Die Karte fordert den Absatz aber ausdrücklich. Abnahmekriterium [number withheld] ("Punkte [number withheld]–[number withheld] je mit einer Zeile") ist damit nur teilweise erfüllt. Das ist eine Entscheidung für den Co-PI oder PI: Schreibbereich erweitern oder den Punkt streichen. Der Absatz darf nur persönliche Prüfungen behaupten, die Anton bestätigt.

[number withheld]. **Nenner bei den Beträgen unklar** (`06_preliminary_analysis.tex:81`).
   - Der Text sagt, unter allen [number withheld] Crossern seien "just RMB [number withheld] billion of RMB [number withheld] billion in minority capital" zugeordnet.
   - `t047_attribution_totals.csv` (all_3[number withheld]_events_3[number withheld]_firms) weist [number withheld] nur für beobachtete Firmenjahre aus ([number withheld] von [number withheld]). Zugeordnet sind [number withheld] ([number withheld] %).
   - Das Beobachtungsproblem steht nur in der Tabellennote (Tabelle [number withheld]), nicht im Satz selbst. Der Satz liest sich wie eine Gesamtsumme.

[number withheld]. **"Pooled ΔΔb is [number withheld]" ist irreführend** (`06_preliminary_analysis.tex:18`).
   - [number withheld] [[number withheld], [number withheld]] ist `private_minus_SOE` aus `t066_ownership_bunching.csv`. Der Wert stimmt, aber es ist kein Vergleich Entwickler gegen Kontrolle.
   - Der Wert stimmt zufällig mit [number withheld] in Tabelle [number withheld] überein (A-Share, Co-main-Fit, `t051_robustness.tex:16`). Das stiftet Verwechslungsgefahr.
   - Im Text fehlt der Hinweis `low_support = TRUE` für die private Gruppe. Im Anhang (`results.tex:348`) steht er.

[number withheld]. **[number withheld] ist ein Gesamttest mit [number withheld] Freiheitsgraden** (`06_preliminary_analysis.tex:142`). Das nennt der Text nicht. Der größte Einzelwert liegt bei [number withheld], `jv_ta`/Z1. Die RL1-Erststufe von [number withheld] ist die Einzelstatistik für Z3. Außerdem sagt die Note zu `t0[number withheld]_heckman` "candidate-only Wald selects the model", gewählt ist bei `jv_ta` aber die Zeile `joint` (`t066_first_stage.csv`, selected = TRUE). Das ist leicht zu beheben.

## Abnahmekriterien

- **[number withheld]. Jede Zahl aus CSV, Verweise lösen auf:**
  - Belegt für die Textzahlen, die ich gegen die CSVs geprüft habe:
    - DR-DiD: [number withheld] [[number withheld], [number withheld]], [number withheld] [[number withheld], [number withheld]], Eigentümer-ATT [number withheld] [[number withheld], [number withheld]], Y2 [number withheld].
    - Vortrends: [number withheld] von [number withheld] Intervallen schließt null aus (Y2, 2016-12-31).
    - Heckman und Reporting-IPW: [number withheld] [[number withheld], [number withheld]], [number withheld], [number withheld], [number withheld] [[number withheld], [number withheld]].
    - ΔΔb und Bunching: [number withheld] [[number withheld], [number withheld]], [number withheld] [[number withheld], [number withheld]], [number withheld] (`t0[number withheld]_timing`, `ii_2[number withheld]H1_2[number withheld]H2`).
    - Offenlegung: [number withheld]/[number withheld], RMB [number withheld] von [number withheld] Mrd.
  - Die Placebos bei [number withheld] und [number withheld] haben Konfidenzintervalle, die null einschließen.
  - Die Sant'Anna-Zhao-Referenz steht in `references.bib`. Sie ist nur nach den Angaben der Karte eingetragen, das Original ist ungeprüft. Der LaTeX-Kommentar sagt das offen.
- **[number withheld]. Haupttext endet auf Seite [number withheld], Build sauber:** Der Build-Bericht meldet fehlerfreie Übersetzung (`review/T069_latex.txt`). Die Seitenzahl [number withheld] konnte ich nicht selbst prüfen, siehe unten.
- **[number withheld]. Punkte [number withheld]–[number withheld]:** teilweise erfüllt (Befund [number withheld]). Alle übrigen Punkte sind im Text auffindbar:
  - DR-DiD: Abschnitt [number withheld] (`04_empirical_model.tex:46`) und Tabelle [number withheld] (`t050_identification.tex`).
  - Evidenzhierarchie und Zielpopulationen: Tabelle [number withheld] und die Konklusion.
  - Sektorschock, Anwendung der [number withheld]H2-Regel und Heckman: `06_preliminary_analysis.tex`, Abschnitt Discussion.
  - Literatur und Fußnote: `02_literature.tex:8`.
  - [number withheld]/[number withheld] und Einheit der Regulierung: `[number withheld]_context_data.tex:[number withheld]`.
  - Look-through-Formulierung: `07_conclusion.tex:11`.
  - Replikation: Zeile [number withheld] von `05_context_data.tex`, nur per Stichwort gefunden, nicht gelesen.
- **Punkt \[number withheld](j), gemeinsamer Tabellenhelfer:** Die neuen Tabellen laufen über `\apptable`, ob das der T070-Helfer ist, habe ich nicht gegengeprüft.
- **Punkt [number withheld], Kürzungen und Schreibbereich:** nicht meine Rolle.

## Nicht geprüft

- Seitenzahl [number withheld], Seitenumbruch und Rendering der PDFs. Ich habe nur Quelldateien gelesen und keinen Befehl ausgeführt (Bash war nicht erlaubt).
- Die Zellen der meisten Anhangstabellen (`t0[number withheld]_dr_*`, `balance_*`, `first_*`, `lee`, `ownership`) gegen die CSVs. Ich habe nur Stichproben der Textzahlen und der Notes geprüft. Die Behauptung "[number withheld]/[number withheld] Zeilen stimmen" des Workers habe ich nicht nachvollzogen.
- Der Absatz zur Replikation (`05_context_data.tex:76`).
- Die Datei `AI_USAGE_LOG.md`, der Abschnitt Conclusion hinter Zeile [number withheld], der Abstract in `main.tex` und die Gleichungsnummern.
- Die Konsistenz von Abschnitt [number withheld] (`03_framework.tex`) mit dem neuen Text.
- Die Änderungen außerhalb des Schreibbereichs in `sections/*.tex`, nach dem Wortlaut der Karte erlaubt.
