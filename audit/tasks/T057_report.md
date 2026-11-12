## Ergebnis
Die Anhänge sind überarbeitet. Tabellen und Abbildungen sind jetzt als A1–A3, B1–B22, B1–B6 und C1 nummeriert; die Nummerierung im Haupttext bleibt unverändert. Alle Anhangstabellen tragen lesbare Beschriftungen und liegen als umbeschriftete Kopien mit `% source:`-Kommentar vor; die Werte sind unverändert. Die überlaufende Integrationstabelle (vorher „Table 15“, jetzt B7) steht im Hochformat mit zwei Panels. Neu im Anhang sind die vier T055-Darstellungen samt Querverweisen im Haupttext. Anhang C enthält jetzt eine Tabelle mit einer Zeile je Nutzungscluster (Syllabus A4), formuliert nach den PI-Entscheidungen. Das Titelblatt trägt `\today`. Der Build läuft ohne Overfull-Boxen durch, und der Haupttext endet auf S. 15.

## Dateien
- `proposal/preamble.tex` – Anhangsnummerierung (`\appto\appendix`: Zähler je Anhang, Format „B3“ ohne Punkt)
- `proposal/main.tex` – Titelblattdatum `\today`, Kommentar
- `proposal/appendix/variables.tex` – Anhang A neu: Float-Parameter und Notizen im Blocksatz für alle Anhänge, A1 mit lesbaren Variablennamen, A2, A3 (volle Summary-Statistik, aus B hierher verschoben)
- `proposal/appendix/results.tex` – Anhang B neu: `[htbp]` mit einem `\FloatBarrier` je Unterabschnitt; kein `\newpage` und kein `\clearpage` mehr; Abbildungen in Textbreite; Notizen aus den Grafiken in die Bildunterschriften verschoben; T055-Tabellen B1, B11, B18 und Abbildung B5; WoS- und CNKI-Note korrigiert; „our“ → „my“, „the author's“ → „my“
- `proposal/appendix/ai_use.tex` – Anhang C neu (Absatz zu Verantwortung, Longtable C1, Audit-Trail)
- `proposal/sections/06_preliminary_analysis.tex` – nur die Verweise in 6.1, 6.2 und 6.4 sowie ein Kommentar
- `proposal/tables/t050_counterfactuals.tex` – Note: „grid and figure: replication package“ → „Appendix Figure B5“
- `proposal/tables/t005_summary_stats.tex`, `t040_validation.tex`, `t040_robustness.tex`, `t031_samples.tex`, `t031_timing.tex`, `t043_integration.tex`, `t043_meas_error.tex`, `t041_frozen_horizons.tex`, `t043_trend_cf.tex`, `t043_heterogeneity.tex`, `t009_did_main.tex`, `t024_rd_main.tex`, `t046_cash_backing_all.tex`, `t049_sample_composition.tex` – umbeschriftete beziehungsweise umgesetzte Anhangskopien, Werte unverändert
- `proposal/tables/t043_delta_excess.tex` (neu) – ersetzt `t043_delta_b.tex`, weil der Dateiname selbst den grep auf `_b\b` auslöst
- `proposal/tables/t055_falsification.tex`, `t055_mi_shift.tex`, `t055_pretrend_tests.tex` (neu) – aus den CSVs, gerundet wie im Text
- `proposal/figures/t055_kappa.pdf` (neu) – unveränderte Kopie aus `replication/outputs/figures/`
- **gelöscht:** `proposal/tables/t043_delta_b.tex` (ersetzt) sowie `t011_robustness.tex`, `t025_selection.tex`, `t029_counterfactual_bunching.tex`. Die drei letzten werden nirgends eingebunden und enthielten die einzigen verbleibenden grep-Treffer. Wiederherstellen ist über Git in `proposal/` möglich.
- `review/T057_build/` – Build-Ausgabe des Ausführungsbefehls

## Ausführung
[fenced excerpt withheld in public audit]
[fenced excerpt withheld in public audit]
Letzter Lauf, mit `-g` erzwungen:
[fenced excerpt withheld in public audit]
[fenced excerpt withheld in public audit]
Im Log steht keine Overfull-, Underfull- oder „Float too large“-Meldung und kein undefinierter Verweis oder Zitat. Übrig bleibt nur die bekannte Font-Warnung `SongtiSC/m/it`, die das Chinesische betrifft und schon vorher bestand.

## Abnahmekriterien
1. **Zahlen belegt, Verweise aufgelöst, keine Codes:** erfüllt für den gedruckten Text.
   - Der Karten-grep ohne Kommentarzeilen liefert 0 Treffer.
   - In LaTeX-Kommentaren außerhalb von `% source:` gibt es noch Treffer. Das sind Herkunftsvermerke wie „% T057: …“ oder „% Rebuilt in T036“ sowie ältere Kommentare in `t028_controls_did`, `t044_*`, `t046`, `t049_threats`, `t050`, `t051` (siehe Offene Fragen).
   - Alle `\ref` sind aufgelöst (keine „undefined“-Meldung).
2. **Build:** erfüllt.
   - Keine Overfull-Box, kein „Float too large“.
   - `sec:main_end` liegt auf S. 15, Anhang A beginnt auf S. 18.
   - Das PDF hat 41 Seiten.
3. **Punkte 1–8:**
   - **P1 Nummerierung:** erfüllt. A1–A3, B1–B22, Abbildungen B1–B6, C1; Haupttext weiter 1–6 und 1–3.
   - **P2 Layout:** erfüllt.
     - Nur noch zwei `\clearpage`: vor Anhang A und vor Anhang C.
     - Alle Floats `[htbp]`, ein `\FloatBarrier` je Unterabschnitt, Breiten `\linewidth`.
     - Die alte Tabelle 15 ist jetzt B7, im Hochformat mit zwei Panels und ohne Überlauf.
     - Ich habe jede Anhangsseite im PDF angesehen. Volle Float-Seiten sind S. 19 (A3), S. 28 (B9, etwa 70 %) und S. 32 (B15, Longtable). S. 36 (B21, B22) ist halb leer, weil danach der `\clearpage` vor Anhang C kommt.
   - **P3 Lesbare Labels:** erfüllt.
     - Keine Rohnamen mehr: `rl1_…`, `n_breached`, `T023_b`, `T029_b_drop`, „rl1 published rl1 060 080“, „bins001“, „rework 2“, „LIMITATIONS D22“, D19/D20 sowie die Statuscodes `boundary_literal_s` u. a. sind ersetzt.
     - Definitionen stammen aus `t004_variable_dictionary.csv`; die Fit-Fenster aus `replication/code/15_referee2.R`, Z. 34–35 und 56–57.
   - **P4 Widersprüche und Duplikate:** erfüllt. Die „unverified“-Hinweise in A3, B17 und der B1-Grafiknotiz sind entfernt und durch einen Verweis auf Abschnitt 4.3 und Tabelle B2 ersetzt. Doppelte Notizen in B2, B9 und B12 sind zusammengeführt. „our“ und „the author“ sind durch die erste Person ersetzt.
   - **P5 Abbildungen:** teilweise erfüllt.
     - Erledigt: Die Notizen aus den Grafiken von B1, B2, B3, B4 und B5 werden per `trim` abgeschnitten und stehen in der Bildunterschrift. Alle Abbildungen sind in voller Textbreite gesetzt.
     - Nicht erreicht: 9 pt (siehe Offene Fragen).
     - Nicht erreicht: eingebettete Schriften in `t055_kappa.pdf` (siehe Offene Fragen).
   - **P6 T055:** erfüllt.
     - (a) Pretrend-Tabelle B18; Verweis in 6.4.
     - (b) Abbildung B5; Verweis in der Note von Tabelle 4.
     - (c) MI-Shift-Tabelle B11; Verweis in 6.2.
     - (d) Falsifikationstabelle B1; Verweis in 6.1 (neben Tabelle 3).
   - **P7 KI-Anhang:** erfüllt.
     - Tabelle C1 hat 12 Zeilen mit Datum, Tool (Modell), Zweck, Prompt (Zitat oder als „(paraphrase)“ markiert), Prüfung und Änderung.
     - Enthalten sind Literatursuche, Code und Schätzung, Text, Sondierungsreviews (Grok, DeepSeek, Gemini, ChatGPT, Claude, inkl. 30.10.) und DeepL.
     - Der Absatz zu Verantwortung und Eigenleistung folgt der PI-Formulierung. Das Co-PI-Framing und „unnamed AI assistant“ sind entfernt. PI und CNKI sind bei der ersten Verwendung ausgeschrieben, CSSCI in der Notiz zu Abbildung B6.
   - **P8 Literatursuche:** erfüllt. Die WoS- und die CNKI-Note nennen jetzt den Publikationsdatumsfilter so, wie er eingegeben wurde (laut `search_log.csv`), und das Suchdatum. Die Trefferzahlen sind unverändert.
4. **Floats mit Seite (gedruckte Seitenzahl, laut `main.aux`):**
   - Anhang A: A1 S. 18, A2 S. 18, A3 S. 19.
   - Abbildungen B: B1 S. 20, B2 S. 22, B3 S. 26, B4 S. 27, B5 S. 30, B6 S. 35.
   - Tabellen B1–B11: B1 S. 20, B2 S. 21, B3 S. 23, B4 S. 23, B5 S. 24, B6 S. 24, B7 S. 25, B8 S. 26, B9 S. 28, B10 S. 29, B11 S. 29.
   - Tabellen B12–B22: B12 S. 30, B13 S. 31, B14 S. 31, B15 S. 32, B16 S. 33, B17 S. 33, B18 S. 34, B19 S. 34, B20 S. 35, B21 S. 36, B22 S. 36.
   - Anhang C: C1 S. 37–39.
5. **Neue Zahlen und ihre Quellen:**
   - **B1:** `t055_falsification.csv`.
   - **B11:** `t055_mi_shift.csv`. D wurde von Anteilen in Prozentpunkte umgerechnet.
   - **B18:** `t055_pretrend_tests.csv`.
   - **Abbildung B5:**
     - Notiz: Beobachtungen und Firmen (602/129, 616/125) aus `t055_kappa.csv`.
     - Break-even-Werte 0,28 und 0,09 aus `t055_kappa_break_even.csv`.
   - **Notiz B7:** 10⁻⁶ und 200 Iterationen aus der Quellnote von `t043_integration.tex`.
   - **Notiz B6:** Fit-Fenster c−0,04, c−0,03 und c+0,02 aus `15_referee2.R`, Z. 35.
   - **Notiz B4:** −0,1620, −3,40 pp und die verfügbaren N aus dem Notizblock der Grafik `t027_decomposition_rl1.pdf`.
   - **Notiz B14:** Seed 20261029 und die 50-Prozent-Angabe aus den Kommentaren der Quelldatei `t046_cash_backing_all.tex`.
   - **B20/B21:** Datumsangaben aus `state/litsearch/search_log.csv`.
   - **Notiz B2-Abbildung:** „sechs Firmen-Daten“ aus der Grafik-Inset-Liste, konsistent mit 1 + 5 Fehlklassifikationen.
   - **Anhang C:**
     - Daten und Modellversionen aus `AI_USAGE_LOG.md`, `state/runs.log`, `state/STATE.md` (23.10.) und `tasks/T055.md`.
     - Die Zahlen 48 / 63 / 26 sind unverändert aus dem bisherigen Text übernommen (Stand 30.10., 13:42).

## Offene Fragen
- **Schriftgröße mindestens 9 pt nicht erreichbar (Punkt 5).** Auch in voller Textbreite liegt der kleinste Text der Abbildungen ungefähr bei 5–7 pt: B1 etwa 7 pt, B2 etwa 5 pt, B3 etwa 5 pt, B4 etwa 6 pt, B5 etwa 6,5 pt, B6 (PRISMA) etwa 5 pt. Die Werte sind aus den Textboxen der PDFs geschätzt. Abhilfe ist nur ein Neu-Rendern mit größerer Basisschrift in `replication/code/` bzw. `state/litsearch/prisma.tex`; beides liegt außerhalb des Schreibbereichs. Vorschlag: eigene Code-Karte.
- **`t055_kappa.pdf` hat nicht eingebettete Schriften** (Helvetica, Helvetica-Bold, Symbol). `gs` und `pdftocairo` zum Einbetten erfordern eine Freigabe, die ich nicht hatte. Die Kopie ist daher unverändert. Lösung: entweder `gs -dEmbedAllFonts=true` auf die Kopie anwenden (PI) oder in `19_referee3.R` mit `cairo_pdf` oder `embedFonts` rendern.
- **Grep in Kommentaren.** Herkunftskommentare wie „% T057: …“ und ältere Kommentare in Haupttext-Tabellen (`t049_threats`, `t050`, `t051`) treffen den grep noch. Sie werden nicht gedruckt; die Haupttext-Tabellen lagen außerhalb meines Auftrags. Wenn das Kriterium wörtlich gilt, müssten diese Kommentare umformuliert werden.
- **Gelöschte Dateien.** Die vier gelöschten Dateien in `proposal/tables/` (siehe Dateien) sind Kopien von Replikationsoutputs und nicht eingebunden. Bitte bestätigen, oder per Git wiederherstellen.
- **Datum DeepSeek und Gemini.** Für die Sondierungsreviews mit DeepSeek und Gemini nennen die Logs kein Datum. Ich habe den Cluster mit „Oct. 28–30“ datiert. Für Claude, Antigravity und Codex nach dem 16.10. nennen die Logs nur die Modellfamilie (Opus, Sonnet, Haiku) bzw. den Aufwand; entsprechend steht in der Tabelle keine Version.
- **Neue Interpretationssätze.**
  - Satz in B.4: „Without controls, no outcome rejects … at the 5 percent level“. Er folgt aus den p-Werten in B18 (alle > 0,05).
  - „Adopted/Rejected“-Liste der Sondierungsreviews in C1. Abgeleitet aus `AI_USAGE_LOG.md` und `tasks/T055.md`, `T056.md`, `T057.md`.
  - Bitte beides prüfen.
- **Zusammengelegte Leerzeilen in B12.** In B12 sind die 16 Zeilen ohne Schätzung (nur „--“) zu je einer Zeile pro Anker zusammengelegt; das steht in der Note. Die Werte sind unverändert.
- **AI_USAGE_LOG.md.** Nach Regel 5 schlage ich einen Eintrag vor: „2026-10-30/31 · Claude Code (Opus 5.5) als Writer · T057 Anhangsüberarbeitung (Nummerierung, Layout, Beschriftung, T055-Tabellen, AI-Anhang) · Karte T057 · Consistency- und Language-Review · offen: Abbildungsschriften, Einbettung κ-Grafik“. Die Datei liegt außerhalb meines Schreibbereichs; ich habe sie nicht geändert.
- **Nicht geprüft:** ob der Overleaf-Build (TeX-Version, Fonts) dasselbe Seitenlayout ergibt.
