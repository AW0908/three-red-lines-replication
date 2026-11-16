## Rolle: consistency (claude, sonnet) – VERDICT: PASS


## Befunde

Keine inhaltlichen Inkonsistenzen zwischen Text und Outputs gefunden. Drei Hinweise ohne Einfluss auf das Urteil:

[number withheld]. **Rückverfolgbarkeit in [number withheld].** `06_preliminary_analysis.tex:15–18` nennt [number withheld] Firmenhalbjahre, [number withheld] erwartet, b = [number withheld] [[number withheld]; [number withheld]] und das Vorperioden-b = [number withheld] [[number withheld]; [number withheld]]. Die Werte stehen in `t023_excess_mass.csv` und stimmen mit der Zeile `post`/`pre` von `t043_integration.csv` (T0[number withheld]_baseline) überein. Die Tabelle `t0[number withheld]_excess_mass` ist aber aus dem Anhang entfernt, die Zahlen stehen also nur noch im Replikationspaket. Der Verweis über `tab:further_outputs` genügt für die Karte.
[number withheld]. **Formulierung in `04_empirical_model.tex:32`.** Dort steht „all eligible paired post-policy observations“, in [number withheld] jetzt „paired observations ([number withheld] firm-half-years, [number withheld] firms)“. Das ist sachlich dieselbe Stichprobe (`t029_counterfactual_bunching.csv`: n = [number withheld], [number withheld] Firmen).
[number withheld]. **„Crossers“ in [number withheld] und Anhang.** Der Text spricht durchgehend von „[number withheld] crossers“ bzw. „[number withheld] crossings“. Der Anhang (`results.tex`, Abschnitt Contract evidence) sagt ausdrücklich, dass die Stichprobe auch schuldengetriebene Crossings enthält. Das widerspricht sich nicht, ist aber für Leser nur im Anhang sichtbar.

## Abnahmekriterien

Nur soweit meine Rolle (Consistency) sie betrifft:

- **Zahlen im Text gegen Outputs (Kriterium [number withheld]): belegt erfüllt.** Ich habe geprüft:
  - Δb = [number withheld] [[number withheld]; [number withheld]] und „positiv in [number withheld] von [number withheld] Ziehungen“ (`t043_delta_b.csv`, `share_positive_all` = [number withheld]).
  - Alle fünf Spezifikationen bei [number withheld] mit Intervall über null. Bei [number withheld] und [number withheld] schließen alle Intervalle null ein.
  - Messfehler: simulierter Mittelwert [number withheld], Anteil [number withheld] % bei [number withheld] Paaren und [number withheld] % bei [number withheld] Paaren (`t043_meas_error.csv`).
  - Integrationsansatz: b_net [number withheld] [[number withheld]; [number withheld]], vorher [number withheld] [[number withheld]; [number withheld]], Δ [number withheld] [[number withheld]; [number withheld]]. Die Zerlegung [number withheld] = [number withheld] + [number withheld] stimmt (`t043_integration.csv`).
  - Trendvergleich: D_trend [number withheld] [[number withheld]; [number withheld]], Bin-Trend [number withheld] [[number withheld]; [number withheld]], b_trend [number withheld] [[number withheld]; [number withheld]] und [number withheld] als Ausgangswert (`t043_trend_cf.csv`).
  - Compliance: [number withheld] / [number withheld] / [number withheld] [[number withheld]; [number withheld]], Placebo [number withheld] und Differenz [number withheld] [[number withheld]; [number withheld]] (`t029_compliance.csv`). Gefrorene Excess Mass [number withheld] / [number withheld] / [number withheld] [[number withheld]; [number withheld]] (`t029_counterfactual_bunching.csv`).
  - Horizonte: [number withheld] von [number withheld] Zellen, die beiden Ausnahmen sind korrekt benannt (`t041_frozen_horizons.csv`).
  - Zerlegung: [number withheld] % gegen [number withheld] %, [number withheld] % mit fallender Verschuldung, MI-Anteil [number withheld] gegen [number withheld], Differenz [number withheld] [[number withheld]; [number withheld]], n = [number withheld] gegen [number withheld] (`t027_decomposition_rl1.csv`, `t027_tests.csv`).
  - Heterogenität: [number withheld] / [number withheld], [number withheld] / [number withheld], [number withheld] / [number withheld] (`t043_heterogeneity.csv`).
  - Cash Backing: [number withheld] % bei [number withheld] Firmenjahren, [number withheld] % gegen [number withheld] % bei [number withheld] gegen [number withheld] Firmenjahren (`t046_cash_backing_all.csv`).
  - T047: [number withheld] / [number withheld] / [number withheld] / [number withheld] / [number withheld], also [number withheld] von [number withheld]; [number withheld] von [number withheld] Mrd. RMB ([number withheld] %); [number withheld] von [number withheld] Firmenjahre (`t047_coding.csv`, `t047_attribution_totals.csv`).
  - Pilot: [number withheld] Transaktionen, davon [number withheld] U (summiert aus `t044_pilot_coding.csv`). [number withheld] Mrd. RMB, [number withheld] Mrd. ([number withheld] %), [number withheld] Mrd. (`t044_attribution_totals.csv`). Die Zeilen der Vergleichstabelle (D/G/H/E/U je Firma) stimmen mit `t044_pilot_coding.csv` überein.
  - Bunching-Zählungen [number withheld] / [number withheld] / [number withheld] (`t005_bunching_counts.csv`).
- **Trendformulierung in Abstract, Einleitung, [number withheld] und Fazit (Kriterium [number withheld]): belegt erfüllt.** Der Satz „did not exceed its pre-policy pace and, under the firm trend, was slower; compliance relied on this growth, not on an acceleration of it“ steht wortgleich in `01_introduction.tex`, `06_preliminary_analysis.tex` und `07_conclusion.tex`. Der Abstract (`main.tex`) sagt sinngleich „although that growth did not exceed its pre-policy pace“. Die Aussage passt zu den Outputs, weil D_trend negativ ist und der Bin-Trend-Intervall null einschließt. Nirgends wird ein kausaler Politikeffekt behauptet.
- **Innere Konsistenz: belegt erfüllt.** Stichprobenzahlen ([number withheld] / [number withheld], [number withheld] / [number withheld], [number withheld] / [number withheld], [number withheld] / [number withheld]), das Compliance-Share-Vokabular und die Tabellennoten sind einheitlich. Die Angabe, welche Gruppe ein Anteil beschreibt, ist durchgängig gesetzt ([number withheld] gegen [number withheld] Paare, [number withheld] gegen [number withheld] Firmenjahre).
- **Rework-[number withheld]-Ersetzungen, soweit konsistenzrelevant: belegt erfüllt.** Das betrifft Punkte [number withheld], [number withheld], [number withheld], [number withheld], [number withheld], [number withheld], [number withheld] und [number withheld]. Die Fundstellen im Text entsprechen der Karte, und [number withheld] / [number withheld] sind mit der CSV belegt.
- **Querverweise: belegt erfüllt.** Das Build-Protokoll `review/T045_latex.txt` meldet „übersetzt fehlerfrei“. `tab:further_outputs`, `tab:t0[number withheld]_*` und `tab:t0[number withheld]_cash` sind definiert. Der Verweis auf perpetual bonds in `05_context_data.tex:21` zeigt jetzt auf Appendix Table `tab:t0[number withheld]_robustness`.
- **AI-Appendix (Konsistenz mit Karten und Reviews): belegt erfüllt.** Die Worker- und Reviewer-Zuordnung von T043–T047 stimmt mit den Kartenköpfen überein, die T044-Verdikte (Data PASS, Est. und Cons. REWORK) mit `review/T044*.md`. Die Datumsangaben stimmen mit `state/approvals.log` überein. Die Tabelle ist nach Kartennummer sortiert.
- **Alle übrigen Kriterien** (Seitenzahl, `pdffonts`, Wortbudget, Sprache und Stil, Verifikationsstufen der handerhobenen Fakten): nicht meine Rolle.

## Nicht geprüft

- **Verifikationsstatus der handerhobenen Aussagen.** Ob `case_notes_verification.csv` die genannten Statement-IDs mit `yes/meaning` führt, habe ich nicht geprüft.
- **Quellenangaben in den Fußnoten.** Seitenzahlen und Datumsangaben der Ankündigungen und die Eigentumsanteile [number withheld] → [number withheld] % (Fall a) habe ich nicht geprüft. Ebenso nicht die [number withheld] % des MI-Zuwachses bei Nanshan und die [number withheld]-von-[number withheld]-Angabe zur CNKI-Suche (`screening.xlsx`).
- **Gerenderte Seiten und Schriften.** Ich habe das PDF nicht eingesehen, ebenso wenig Seitenumbruch, Seitenzahl und Schrifteinbettung. Den Build habe ich nur über `T045_latex.txt` bewertet. Das Protokoll ist sehr knapp, es enthält keine Overfull-Meldungen.
- **Python-Prüfung.** Der Python-Aufruf war nicht erlaubt, deshalb habe ich die CSVs nur mit Grep und Read geprüft. Zeilen mit sehr langen Feldern (`t044_magnitude.csv`) habe ich nicht vollständig abgeglichen.
