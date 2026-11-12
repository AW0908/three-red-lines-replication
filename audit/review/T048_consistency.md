## Rolle: consistency (claude, sonnet) – VERDICT: PASS

Ich habe alle Zahlen und Verweise der Rework-Änderungen geprüft und schließe jetzt den Prüfbericht ab.

VERDICT: PASS

## Befunde

Keine inhaltlichen Inkonsistenzen zwischen Text, Abbildung und Outputs gefunden. Drei Hinweise ohne Urteilsfolge:

[firm-specific excerpt withheld in public audit]
2. **Annahmenkasten in der Abbildung (`proposal/figures/toc_nef.tex:44–45`).** „New equity is genuine" und „new equity carries risk" stehen nebeneinander und sagen inhaltlich fast dasselbe. Der Absatz in `03_framework.tex` nennt beides getrennt. Das ist nicht falsch, aber redundant.
[firm-specific excerpt withheld in public audit]

## Abnahmekriterien

Nur soweit meine Rolle (Konsistenz Text ↔ Output ↔ Abbildung) betroffen ist:

1. **Abbildung nutzt nur Aussagen aus dem Text: belegt erfüllt.**
   - *Need* („High developer leverage") und externer Faktor („Sector distress from 2021") stehen in `L002_Fan_2026.pdf`, S. 1–2: „26 of the nation's top 100 real estate enterprises encountered financial distress in 2021", „high leverage, high debt".
   - *Aim* („Lower economic, not only reported, leverage") entspricht `03_framework.tex:24` (Abschnitt 3.2).
   - *Activities*: Schwellen, Caps und „January 1, 2021" stehen in `05_context_data.tex:11`.
   - „Group or partner capital" steht in `03_framework.tex:18`. „Opaque contract terms" deckt sich mit Finding 3 (239 von 249 Transaktionen U).
   - „Rollover risk", „systemic risk", „financial stability" und „COVID-19" sind aus Abbildung und Absatz entfernt (Rework 1, Punkt 2).
2. **Finding-3-Marker (Rework 1, Punkt 3): erfüllt.** Er steht im Annahmenkasten (`toc_nef.tex:45`). Der Pfeil zum Aim ist gestrichelt und mit „Not observed" beschriftet. Finding 1 steht am Pfeil Activities → Short-term, Finding 2 am Pfeil Short-term → Medium-term, passend zu den Abschnitten 6.1 und 6.2.
3. **Querverweise: erfüllt.** `\ref{sec:preliminary}`, `\ref{fig:toc_nef}` und `\citep{fan2026deleverage}` zeigen auf das Gemeinte. Der Build-Log meldet keine undefinierten Verweise. `fan2026deleverage` steht in `references.bib:70` und in `02_literature.tex`.
4. **Zahlen gegen Outputs: erfüllt.** Stichprobenhaft geprüft, alle stimmen:
   - **`t040_validation.csv`:** MAE 0,57 Punkte (n=52), 76,9 % innerhalb eines Punkts, 64 Werte von 30 Entwicklern, 52 Werte im Bereich 0,60–0,80, 6 Klassifikationsabweichungen (1+5), Mittelwert 0,99 Punkte.
   - **`t043_meas_error.csv`:** Mittel 2,01; Anteil 86 % bei 64 Paaren und 40 % bei 52 Paaren.
   - **`t043_trend_cf.csv`:** D_trend = −9,8 [−15,1; −4,7], b_trend = 1,52 [0,14; 3,34], Bin-Trend −5,6 [−11,9; 1,0] mit CI über null.
   - **`t046_cash_backing_all.csv`:** 79,5 % bei n=109; Crossers 96,6 % bei n=33; Others 80,8 % bei n=48.
   - **`t047_coding.csv`, Zeile pooled:** D=4 (D1 1, D2 2, unspezifiziert 1).
   - **`t044_attribution_totals.csv`:** 108,3 Mrd., 3,5 Mrd. (3,2 %), 104,8 Mrd.; neun Firmen.
   - Die Zahlen sind laut Diff nicht verändert worden. Es gibt nur sprachliche Umstellungen.
5. **Einheitlicher Kapitalbegriff: erfüllt.** „capital from minority shareholders" steht an allen genannten Stellen: 06:70, 06:88/89/91, Pilotabsatz, `t045_crosser_shares.tex`, `results.tex` (Begleittext, Tabellenkopf, Outputverzeichnis). Die Ausnahme „payment from minority shareholders" in `results.tex:146` ist sprachlich begründet und inhaltlich gleich.
6. **Wind: erfüllt.** Die erste Erwähnung (`05_context_data.tex:17`) erklärt „Wind Financial Terminal, a Chinese financial-data service".
7. **Haupttext ≤ 15 Seiten, keine Overfull-Box > 2 pt: nicht meine Rolle.** Der Log zeigt eine Overfull-Box mit 0,79 pt (`main.log:1815`), weitere nicht gefunden. Die Seitenzahl habe ich nicht selbst geprüft.
8. **Schreibregeln und Sprachpunkte (Rechtschreibung, Stil): nicht meine Rolle.**

## Nicht geprüft

- Die PDF-Ausgabe und die PNG-Dateien in `/tmp` habe ich nicht geöffnet. Ob die Abbildung lesbar ist und ob die Seitenzahl 15 stimmt, habe ich nicht verifiziert.
- Folienseiten 23–26 der Lecture-Datei habe ich nicht gelesen. Die Behauptung, dass die Folien keine publizierte Quelle nennen, bleibt unverifiziert. Die Fußnote zitiert die Vorlesung.
- Nicht jede Zahl in `06_preliminary_analysis.tex` wurde gegen ihre CSV geprüft, insbesondere Finding 1 und die Heterogenität (13,1 / 7,6 / 18,5 / 7,5 / 15,1 / 7,9). Diese Zeilen sind laut Diff unverändert gegenüber dem bereits begutachteten Stand.
- `review/T048_latex.txt` enthielt keine der gesuchten Meldungen. Ich habe das als Hinweis auf einen sauberen Lauf gewertet, aber nicht weiter ausgewertet.
- Der Noto-Zweig der CJK-Schrift wurde laut Bericht nicht auf Overleaf getestet und liegt außerhalb meiner Rolle.
- Der AI-Usage-Log-Vorschlag des Workers ist nicht umgesetzt; `AI_USAGE_LOG.md` habe ich nicht auf einen neuen Eintrag geprüft.
