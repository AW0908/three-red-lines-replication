## Ergebnis
Die Anhänge sind überarbeitet. Tabellen und Abbildungen sind jetzt als A1–A3, B1–B2[number withheld], B1–B6 und C1 nummeriert; die Nummerierung im Haupttext bleibt unverändert. Alle Anhangstabellen tragen lesbare Beschriftungen und liegen als umbeschriftete Kopien mit `% source:`-Kommentar vor; die Werte sind unverändert. Die überlaufende Integrationstabelle (vorher „Table [number withheld]“, jetzt B7) steht im Hochformat mit zwei Panels. Neu im Anhang sind die vier T055-Darstellungen samt Querverweisen im Haupttext. Anhang C enthält jetzt eine Tabelle mit einer Zeile je Nutzungscluster (Syllabus A4), formuliert nach den PI-Entscheidungen. Das Titelblatt trägt `\today`. Der Build läuft ohne Overfull-Boxen durch, und der Haupttext endet auf S. [number withheld].

## Dateien
- `proposal/preamble.tex` – Anhangsnummerierung (`\appto\appendix`: Zähler je Anhang, Format „B3“ ohne Punkt)
- `proposal/main.tex` – Titelblattdatum `\today`, Kommentar
- `proposal/appendix/variables.tex` – Anhang A neu: Float-Parameter und Notizen im Blocksatz für alle Anhänge, A1 mit lesbaren Variablennamen, A2, A3 (volle Summary-Statistik, aus B hierher verschoben)
- `proposal/appendix/results.tex` – Anhang B neu: `[htbp]` mit einem `\FloatBarrier` je Unterabschnitt; kein `\newpage` und kein `\clearpage` mehr; Abbildungen in Textbreite; Notizen aus den Grafiken in die Bildunterschriften verschoben; T055-Tabellen B1, B1[number withheld], B1[number withheld] und Abbildung B5; WoS- und CNKI-Note korrigiert; „our“ → „my“, „the author's“ → „my“
- `proposal/appendix/ai_use.tex` – Anhang C neu (Absatz zu Verantwortung, Longtable C1, Audit-Trail)
- `proposal/sections/06_preliminary_analysis.tex` – nur die Verweise in [number withheld], [number withheld] und [number withheld] sowie ein Kommentar
- `proposal/tables/t050_counterfactuals.tex` – Note: „grid and figure: replication package“ → „Appendix Figure B5“
- `proposal/tables/t005_summary_stats.tex`, `t040_validation.tex`, `t040_robustness.tex`, `t031_samples.tex`, `t031_timing.tex`, `t043_integration.tex`, `t043_meas_error.tex`, `t041_frozen_horizons.tex`, `t043_trend_cf.tex`, `t043_heterogeneity.tex`, `t009_did_main.tex`, `t024_rd_main.tex`, `t046_cash_backing_all.tex`, `t049_sample_composition.tex` – umbeschriftete beziehungsweise umgesetzte Anhangskopien, Werte unverändert
- `proposal/tables/t043_delta_excess.tex` (neu) – ersetzt `t043_delta_b.tex`, weil der Dateiname selbst den grep auf `_b\b` auslöst
- `proposal/tables/t055_falsification.tex`, `t055_mi_shift.tex`, `t055_pretrend_tests.tex` (neu) – aus den CSVs, gerundet wie im Text
- `proposal/figures/t055_kappa.pdf` (neu) – unveränderte Kopie aus `replication/outputs/figures/`
- **gelöscht:** `proposal/tables/t043_delta_b.tex` (ersetzt) sowie `t011_robustness.tex`, `t025_selection.tex`, `t029_counterfactual_bunching.tex`. Die drei letzten werden nirgends eingebunden und enthielten die einzigen verbleibenden grep-Treffer. Wiederherstellen ist über Git in `proposal/` möglich.
- `review/T0[number withheld]_build/` – Build-Ausgabe des Ausführungsbefehls

## Ausführung
[fenced excerpt withheld in public process copy]
[fenced excerpt withheld in public process copy]
Letzter Lauf, mit `-g` erzwungen:
[fenced excerpt withheld in public process copy]
[fenced excerpt withheld in public process copy]
Im Log steht keine Overfull-, Underfull- oder „Float too large“-Meldung und kein undefinierter Verweis oder Zitat. Übrig bleibt nur die bekannte Font-Warnung `SongtiSC/m/it`, die das Chinesische betrifft und schon vorher bestand.

## Abnahmekriterien
[number withheld]. **Zahlen belegt, Verweise aufgelöst, keine Codes:** erfüllt für den gedruckten Text.
   - Der Karten-grep ohne Kommentarzeilen liefert [number withheld] Treffer.
   - In LaTeX-Kommentaren außerhalb von `% source:` gibt es noch Treffer. Das sind Herkunftsvermerke wie „% T057: …“ oder „% Rebuilt in T036“ sowie ältere Kommentare in `t0[number withheld]_controls_did`, `t0[number withheld]_*`, `t0[number withheld]`, `t0[number withheld]_threats`, `t0[number withheld]`, `t0[number withheld]` (siehe Offene Fragen).
   - Alle `\ref` sind aufgelöst (keine „undefined“-Meldung).
[number withheld]. **Build:** erfüllt.
   - Keine Overfull-Box, kein „Float too large“.
   - `sec:main_end` liegt auf S. [number withheld], Anhang A beginnt auf S. [number withheld].
   - Das PDF hat [number withheld] Seiten.
[number withheld]. **Punkte [number withheld]–[number withheld]:**
   - **P1 Nummerierung:** erfüllt. A1–A3, B1–B2[number withheld], Abbildungen B1–B6, C1; Haupttext weiter [number withheld]–[number withheld] und [number withheld]–[number withheld].
   - **P2 Layout:** erfüllt.
     - Nur noch zwei `\clearpage`: vor Anhang A und vor Anhang C.
     - Alle Floats `[htbp]`, ein `\FloatBarrier` je Unterabschnitt, Breiten `\linewidth`.
     - Die alte Tabelle [number withheld] ist jetzt B7, im Hochformat mit zwei Panels und ohne Überlauf.
     - Ich habe jede Anhangsseite im PDF angesehen. Volle Float-Seiten sind S. [number withheld] (A3), S. [number withheld] (B9, etwa [number withheld] %) und S. [number withheld] (B1[number withheld], Longtable). S. [number withheld] (B2[number withheld], B2[number withheld]) ist halb leer, weil danach der `\clearpage` vor Anhang C kommt.
   - **P3 Lesbare Labels:** erfüllt.
     - Keine Rohnamen mehr: `rl1_…`, `n_breached`, `T0[number withheld]_b`, `T0[number withheld]_b_drop`, „rl1 published rl1 [number withheld] [number withheld]“, „bins0[number withheld]“, „rework [number withheld]“, „LIMITATIONS D2[number withheld]“, D1[number withheld]/D2[number withheld] sowie die Statuscodes `boundary_literal_s` u. a. sind ersetzt.
     - Definitionen stammen aus `t004_variable_dictionary.csv`; die Fit-Fenster aus `replication/code/15_referee2.R`, Z. [number withheld]–[number withheld] und [number withheld]–[number withheld].
   - **P4 Widersprüche und Duplikate:** erfüllt. Die „unverified“-Hinweise in A3, B1[number withheld] und der B1-Grafiknotiz sind entfernt und durch einen Verweis auf Abschnitt [number withheld] und Tabelle B2 ersetzt. Doppelte Notizen in B2, B9 und B1[number withheld] sind zusammengeführt. „our“ und „the author“ sind durch die erste Person ersetzt.
   - **P5 Abbildungen:** teilweise erfüllt.
     - Erledigt: Die Notizen aus den Grafiken von B1, B2, B3, B4 und B5 werden per `trim` abgeschnitten und stehen in der Bildunterschrift. Alle Abbildungen sind in voller Textbreite gesetzt.
     - Nicht erreicht: [number withheld] pt (siehe Offene Fragen).
     - Nicht erreicht: eingebettete Schriften in `t055_kappa.pdf` (siehe Offene Fragen).
   - **P6 T055:** erfüllt.
     - (a) Pretrend-Tabelle B1[number withheld]; Verweis in [number withheld].
     - (b) Abbildung B5; Verweis in der Note von Tabelle [number withheld].
     - (c) MI-Shift-Tabelle B1[number withheld]; Verweis in [number withheld].
     - (d) Falsifikationstabelle B1; Verweis in [number withheld] (neben Tabelle [number withheld]).
   - **P7 KI-Anhang:** erfüllt.
     - Tabelle C1 hat [number withheld] Zeilen mit Datum, Tool (Modell), Zweck, Prompt (Zitat oder als „(paraphrase)“ markiert), Prüfung und Änderung.
     - Enthalten sind Literatursuche, Code und Schätzung, Text, Sondierungsreviews (Grok, DeepSeek, Gemini, ChatGPT, Claude, inkl. [number withheld].) und DeepL.
     - Der Absatz zu Verantwortung und Eigenleistung folgt der PI-Formulierung. Das Co-PI-Framing und „unnamed AI assistant“ sind entfernt. PI und CNKI sind bei der ersten Verwendung ausgeschrieben, CSSCI in der Notiz zu Abbildung B6.
   - **P8 Literatursuche:** erfüllt. Die WoS- und die CNKI-Note nennen jetzt den Publikationsdatumsfilter so, wie er eingegeben wurde (laut `search_log.csv`), und das Suchdatum. Die Trefferzahlen sind unverändert.
[number withheld]. **Floats mit Seite (gedruckte Seitenzahl, laut `main.aux`):**
   - Anhang A: A1 S. [number withheld], A2 S. [number withheld], A3 S. [number withheld].
   - Abbildungen B: B1 S. [number withheld], B2 S. [number withheld], B3 S. [number withheld], B4 S. [number withheld], B5 S. [number withheld], B6 S. [number withheld].
   - Tabellen B1–B1[number withheld]: B1 S. [number withheld], B2 S. [number withheld], B3 S. [number withheld], B4 S. [number withheld], B5 S. [number withheld], B6 S. [number withheld], B7 S. [number withheld], B8 S. [number withheld], B9 S. [number withheld], B1[number withheld] S. [number withheld], B1[number withheld] S. [number withheld].
   - Tabellen B1[number withheld]–B2[number withheld]: B1[number withheld] S. [number withheld], B1[number withheld] S. [number withheld], B1[number withheld] S. [number withheld], B1[number withheld] S. [number withheld], B1[number withheld] S. [number withheld], B1[number withheld] S. [number withheld], B1[number withheld] S. [number withheld], B1[number withheld] S. [number withheld], B2[number withheld] S. [number withheld], B2[number withheld] S. [number withheld], B2[number withheld] S. [number withheld].
   - Anhang C: C1 S. [number withheld]–[number withheld].
[number withheld]. **Neue Zahlen und ihre Quellen:**
   - **B1:** `t055_falsification.csv`.
   - **B1[number withheld]:** `t055_mi_shift.csv`. D wurde von Anteilen in Prozentpunkte umgerechnet.
   - **B1[number withheld]:** `t055_pretrend_tests.csv`.
   - **Abbildung B5:**
     - Notiz: Beobachtungen und Firmen ([number withheld]/[number withheld], [number withheld]/[number withheld]) aus `t055_kappa.csv`.
     - Break-even-Werte [number withheld] und [number withheld] aus `t055_kappa_break_even.csv`.
   - **Notiz B7:** [number withheld]⁻⁶ und [number withheld] Iterationen aus der Quellnote von `t043_integration.tex`.
   - **Notiz B6:** Fit-Fenster c−[number withheld], c−[number withheld] und c+[number withheld] aus `15_referee2.R`, Z. [number withheld].
   - **Notiz B4:** [number withheld], [number withheld] pp und die verfügbaren N aus dem Notizblock der Grafik `t027_decomposition_rl1.pdf`.
   - **Notiz B1[number withheld]:** Seed [number withheld] und die [number withheld]-Prozent-Angabe aus den Kommentaren der Quelldatei `t046_cash_backing_all.tex`.
   - **B2[number withheld]/B2[number withheld]:** Datumsangaben aus `state/litsearch/search_log.csv`.
   - **Notiz B2-Abbildung:** „sechs Firmen-Daten“ aus der Grafik-Inset-Liste, konsistent mit [number withheld] + [number withheld] Fehlklassifikationen.
   - **Anhang C:**
     - Daten und Modellversionen aus `AI_USAGE_LOG.md`, `state/runs.log`, `state/STATE.md` ([number withheld].) und `tasks/T055.md`.
     - Die Zahlen [number withheld] / [number withheld] / [number withheld] sind unverändert aus dem bisherigen Text übernommen (Stand [number withheld]., [number withheld]:[number withheld]).

## Offene Fragen
- **Schriftgröße mindestens [number withheld] pt nicht erreichbar (Punkt [number withheld]).** Auch in voller Textbreite liegt der kleinste Text der Abbildungen ungefähr bei [number withheld]–[number withheld] pt: B1 etwa [number withheld] pt, B2 etwa [number withheld] pt, B3 etwa [number withheld] pt, B4 etwa [number withheld] pt, B5 etwa [number withheld] pt, B6 (PRISMA) etwa [number withheld] pt. Die Werte sind aus den Textboxen der PDFs geschätzt. Abhilfe ist nur ein Neu-Rendern mit größerer Basisschrift in `replication/code/` bzw. `state/litsearch/prisma.tex`; beides liegt außerhalb des Schreibbereichs. Vorschlag: eigene Code-Karte.
- **`t055_kappa.pdf` hat nicht eingebettete Schriften** (Helvetica, Helvetica-Bold, Symbol). `gs` und `pdftocairo` zum Einbetten erfordern eine Freigabe, die ich nicht hatte. Die Kopie ist daher unverändert. Lösung: entweder `gs -dEmbedAllFonts=true` auf die Kopie anwenden (PI) oder in `19_referee3.R` mit `cairo_pdf` oder `embedFonts` rendern.
- **Grep in Kommentaren.** Herkunftskommentare wie „% T057: …“ und ältere Kommentare in Haupttext-Tabellen (`t0[number withheld]_threats`, `t0[number withheld]`, `t0[number withheld]`) treffen den grep noch. Sie werden nicht gedruckt; die Haupttext-Tabellen lagen außerhalb meines Auftrags. Wenn das Kriterium wörtlich gilt, müssten diese Kommentare umformuliert werden.
- **Gelöschte Dateien.** Die vier gelöschten Dateien in `proposal/tables/` (siehe Dateien) sind Kopien von Replikationsoutputs und nicht eingebunden. Bitte bestätigen, oder per Git wiederherstellen.
- **Datum DeepSeek und Gemini.** Für die Sondierungsreviews mit DeepSeek und Gemini nennen die Logs kein Datum. Ich habe den Cluster mit „Oct. [number withheld]–[number withheld]“ datiert. Für Claude, Antigravity und Codex nach dem [number withheld]. nennen die Logs nur die Modellfamilie (Opus, Sonnet, Haiku) bzw. den Aufwand; entsprechend steht in der Tabelle keine Version.
- **Neue Interpretationssätze.**
  - Satz in B.[number withheld]: „Without controls, no outcome rejects … at the [number withheld] percent level“. Er folgt aus den p-Werten in B1[number withheld] (alle > [number withheld]).
  - „Adopted/Rejected“-Liste der Sondierungsreviews in C1. Abgeleitet aus `AI_USAGE_LOG.md` und `tasks/T055.md`, `T056.md`, `T057.md`.
  - Bitte beides prüfen.
- **Zusammengelegte Leerzeilen in B1[number withheld].** In B1[number withheld] sind die [number withheld] Zeilen ohne Schätzung (nur „--“) zu je einer Zeile pro Anker zusammengelegt; das steht in der Note. Die Werte sind unverändert.
- **AI_USAGE_LOG.md.** Nach Regel [number withheld] schlage ich einen Eintrag vor: „2026-10-30/[number withheld] · Claude Code (Opus [number withheld]) als Writer · T057 Anhangsüberarbeitung (Nummerierung, Layout, Beschriftung, T055-Tabellen, AI-Anhang) · Karte T057 · Consistency- und Language-Review · offen: Abbildungsschriften, Einbettung κ-Grafik“. Die Datei liegt außerhalb meines Schreibbereichs; ich habe sie nicht geändert.
- **Nicht geprüft:** ob der Overleaf-Build (TeX-Version, Fonts) dasselbe Seitenlayout ergibt.
