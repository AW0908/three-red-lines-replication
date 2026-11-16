Der Haupttext endet jetzt auf S. [number withheld], und der Build läuft ohne Overfull-Boxen und ohne undefinierte Verweise durch. Jetzt folgt der Bericht.

## Ergebnis
Ich habe T056 in `proposal/` umgesetzt. Neu sind die Ich-Form, die Aufteilung in H2a (gestützt) und H2b (nicht gestützt) und die vier T055-Ergebnisse (dichteunabhängiger MI-Shift, κ-Break-even, Falsifikation mit der unbereinigten Quote, lineare Trends). Damit liest sich Finding [number withheld] neu: Die Differenz von $D$ zwischen Post und Placebo ([number withheld]) gilt nicht mehr als Beleg für eine stärkere Abhängigkeit von MI. Hinzu kommen Placebo-Schwellen und die unbereinigte Quote in Tabelle [number withheld], ein Satz zur regulierten Einheit, Machbarkeit und Nebenwirkungen im Fazit, die Chetty-Quelle und die Autorennotiz zum Focal Paper. Die Abschnitte [number withheld]–[number withheld] und `t050_counterfactuals.tex` hatte schon ein früher abgebrochener Lauf um [number withheld]:[number withheld]–[number withheld]:[number withheld] bearbeitet; ich habe sie geprüft, korrigiert und für das Seitenlimit gekürzt. Der Haupttext endet auf S. [number withheld] (`sec:main_end` steht auf S. [number withheld] in `main.aux`).

## Dateien
- `proposal/sections/01_introduction.tex` – vom abgebrochenen Vorlauf: Ich-Form, Satz zur Repräsentativität, neue Lesart von Finding [number withheld] und κ; von mir nur geprüft
- `proposal/sections/02_literature.tex` – Ich-Form im Absatz „Search“ (behebt eine Overfull-Box), Kürzungen in der ersten bis dritten Literaturlinie
- `proposal/sections/03_framework.tex` – vom Vorlauf: H2a/H2b, κ-Break-even als empirisches Gegenstück; von mir nur geprüft
- `proposal/sections/04_empirical_model.tex` – vom Vorlauf: Bin-Zahlen gestrichen, Chetty-Zitat, H2b-Maße. Von mir: Overfull behoben, [number withheld]-Ende, [number withheld] und [number withheld] gekürzt, Einleitung ohne die Doppelung zu Abschnitt [number withheld]
- `proposal/sections/05_context_data.tex` – vom Vorlauf: Satz zur regulierten Einheit (Huafa). Von mir: [number withheld] und [number withheld] gekürzt
- `proposal/sections/06_preliminary_analysis.tex` – Ich-Form, Überschrift von Finding [number withheld] (H2a), Falsifikationsabsatz in [number withheld], MI-Shift/Reweighting, Trend- und κ-Absätze in [number withheld], Satz zu den horizontgleichen Vergleichen gestrichen, Fallbeispiele in [number withheld] und die Notiz zu Tabelle [number withheld] gekürzt, Quellkommentar zum Prätrendtest, [number withheld] neu gefasst, Abbildungen [number withheld] und [number withheld] etwas kleiner
- `proposal/sections/07_conclusion.tex` – Ich-Form, H2a/H2b, κ mit Look-through verknüpft, zwei Sätze zu Machbarkeit und Nebenwirkungen
- `proposal/tables/t050_counterfactuals.tex` (Tabelle [number withheld]) – vom Vorlauf: Zeilen für linearen Trend, κ und Post minus Placebo. Von mir: kompakter gesetzt, Satz zur Trendform in der Notiz, toter Verweis `fig:t0[number withheld]_kappa` entfernt
- `proposal/tables/t051_robustness.tex` (Tabelle [number withheld]) – Zeile für die Placebos [number withheld]/[number withheld] und Zeile für die unbereinigte Quote (jetzt [number withheld] Zeilen), Zeilennummern in der Notiz angepasst, Chetty-Zitat
- `proposal/tables/t049_threats.tex` (Tabelle [number withheld]) – unbereinigte Quote und neue Zeile „Prior MI growth; density“, Einträge gekürzt
- `proposal/references.bib` – `chetty2[number withheld]adjustment` ergänzt, `note` von `jin2[number withheld]deleveraging` ersetzt (Schlüssel bleibt)
- `review/T0[number withheld]_build/` – Build-Ausgabe

## Ausführung
[fenced excerpt withheld in public process copy]
[fenced excerpt withheld in public process copy]
Ausgabe des letzten Laufs: `Latexmk: All targets (.../main.xdv .../main.pdf) are up-to-date` (Exit [number withheld]). Das Log enthält keine Overfull-Boxen, keine undefinierten Verweise oder Zitate. Es bleiben nur zwei Font-Warnungen zu SongtiSC kursiv (CJK im Anhang); die gab es schon vorher. In `main.aux` stehen `sec:conclusion` und `sec:main_end` jeweils auf S. [number withheld].

## Abnahmekriterien
**[number withheld]. Jede Zahl aus einer CSV, und jede zitierte Tabelle enthält die zitierte Zahl: erfüllt, mit einer Einschränkung (siehe Offene Fragen).** Neue Zahlen und ihre Quellen:
- [number withheld] [[number withheld]; [number withheld]]; [number withheld] [[number withheld]; [number withheld]] bei [number withheld]; [number withheld] [[number withheld]; [number withheld]] bei [number withheld] – `t043_delta_b.csv` (Tabelle [number withheld])
- [number withheld] [[number withheld]; [number withheld]], [number withheld] ([number withheld]) – `t055_falsification.csv` b_raw_tl_ta, post (Tabelle [number withheld])
- [number withheld], [number withheld] [[number withheld]; [number withheld]] und [number withheld] [[number withheld]; [number withheld]] – `t055_falsification.csv` (Text in [number withheld])
- [number withheld], [number withheld], [number withheld] [[number withheld]; [number withheld]], [number withheld] und [number withheld] – `t055_mi_shift.csv` mean_shift_pp
- [number withheld], [number withheld], [number withheld] und [number withheld] [[number withheld]; [number withheld]] – `t055_mi_shift.csv` D, D_reweighted, D_post_minus_reweighted_placebo
- $D$ = [number withheld] [[number withheld]; [number withheld]] und [number withheld] [[number withheld]; [number withheld]]; $b$ = [number withheld] [[number withheld]; [number withheld]] und [number withheld] [[number withheld]; [number withheld]] – `t055_linear_trend.csv` (Tabelle [number withheld])
- κ* = [number withheld] und [number withheld] – `t055_kappa_break_even.csv` (Tabelle [number withheld], Text in [number withheld], Fazit)
- [number withheld] [[number withheld]; [number withheld]], [number withheld], [number withheld], [number withheld] %, [number withheld] % [[number withheld]; [number withheld]], [number withheld] % und [number withheld] % – `t029_compliance.csv` (Zeilen [number withheld]–[number withheld], gegengeprüft; stehen in Tabelle [number withheld])
- p = [number withheld] – `t055_pretrend_tests.csv` rl1, C3-date

**[number withheld]. Haupttext endet spätestens auf S. [number withheld], Build sauber: erfüllt.**

**[number withheld]. Punkte [number withheld]–[number withheld] je mit einer Zeile:**
[number withheld]. **Ich-Form:** erfüllt in allen Dateien unter `sections/` und `tables/`; kein „we/our/the author“ mehr (per Grep geprüft). Im Anhang nicht umgesetzt (siehe Offene Fragen).
[number withheld]. **H2-Aufteilung:** erfüllt; dieselben Bezeichnungen in [number withheld], [number withheld], [number withheld] und im Fazit, Überschrift von Finding [number withheld] „(H2a)“.
[number withheld]. **T055 einarbeiten:** (a) erfüllt in [number withheld], in der Einleitung (Vorlauf), in [number withheld] und in Tabelle [number withheld]; „Post minus Placebo“ steht nirgends mehr als Beleg. (b) erfüllt in [number withheld], [number withheld] und im Fazit; die Abbildung ist weder im Haupttext (kein Platz) noch im Anhang (siehe Offene Fragen). (c) erfüllt in [number withheld], die unpräzise Δb-Differenz ist genannt. (d) „did not exceed“ als robuste Aussage, Trendform-Hinweis einmal in [number withheld] und in der Notiz zu Tabelle [number withheld]. (e) erfüllt.
[number withheld]. **Robustheitstabelle:** erfüllt, [number withheld] Zeilen. Die beiden Placebos teilen sich eine Zeile, damit die Grenze von [number withheld] Zeilen hält.
[number withheld]. **Regulierte Einheit:** erfüllt in [number withheld] (Vorlauf), mit Verweis auf Fall (a).
[number withheld]. **Repräsentativität:** erfüllt in der Einleitung, Absatz [number withheld] (Vorlauf).
[number withheld]. **Machbarkeit und Nebenwirkungen:** erfüllt im Fazit, als Abwägungen formuliert.
[number withheld]. **Nachvollziehbarkeit:** Die [number withheld] steht in Tabelle [number withheld]. Die Bin-Zahlen ([number withheld]/[number withheld]/[number withheld]) sind gestrichen. Beim Prätrend-p-Wert steht im Text der Verweis auf die Ausgabe `t0[number withheld]_pretrend_tests` im Replikationspaket statt auf eine Anhangstabelle (siehe Offene Fragen).
[number withheld]. **Autorennotiz:** erfüllt, Wortlaut aus der Karte, Schlüssel `jin2[number withheld]deleveraging` unverändert.
[number withheld]. **Kürzungen:** erfüllt; Abschnitt [number withheld], [number withheld]/[number withheld], [number withheld]/[number withheld], Fallbeispiele in [number withheld], Notizen zu Tabelle [number withheld] und [number withheld], Tabelle [number withheld] und das Fazit gestrafft. Der Satz zu den horizontgleichen Vergleichen ([number withheld] von [number withheld]) ist gestrichen, weil er Post-minus-Placebo-$D$ als Evidenz präsentierte.

## Offene Fragen
- **Anhang liegt außerhalb des Schreibbereichs.** Die Karte verlangt die Ich-Form auch im Anhang, die κ-Abbildung „otherwise Appendix B“ und eine neue Anhangstabelle `t0[number withheld]_pretrend_tests`. Der Schreibbereich nennt aber nur `sections/*.tex`, `tables/` und `references.bib`. Ich habe `proposal/appendix/` deshalb nicht angefasst. Stattdessen verweisen Text bzw. Tabellennotiz an zwei Stellen auf das Replikationspaket: beim p-Wert in [number withheld] und beim κ-Raster in Tabelle [number withheld]. Im Anhang stehen weiter „we/our“ (z. B. `appendix/results.tex`, Z. [number withheld]). Für eine Folgekarte nötig: `t055_pretrend_tests.tex` und `t055_kappa.pdf` in `appendix/results.tex` einbinden und die beiden Verweise umstellen. Danach prüfen, ob S. [number withheld] hält.
- **Zahlen ohne Haupttabelle:** Die MI-Shift- und Reweighting-Zahlen sowie die Differenzen der Falsifikation ([number withheld] und [number withheld]) stehen im Text nur mit Verweis auf das Replikationspaket bzw. im Quellkommentar. Keine Haupt- oder Anhangstabelle enthält sie.
- **Vorlauf:** Die Änderungen an [number withheld], [number withheld] und dem größten Teil von [number withheld]/[number withheld] stammen aus einem abgebrochenen Lauf ohne Bericht. Ich habe sie gelesen und ihre Zahlen geprüft, aber nicht Wort für Wort gegen die Baseline (`review/T056_baseline.sha256`) verglichen.
- **Bib-Eintrag Chetty et al. ([number withheld]):** Den Titel („Adjustment Costs, Firm Responses, and Micro vs. Macro Labor Supply Elasticities: Evidence from Danish Tax Records“) und die Autorennamen habe ich ergänzt; die Karte nennt nur Zeitschrift, Band, Seiten und WP-Nummer. Bitte an der NBER-Seite gegenprüfen.
- **Tabelle [number withheld]:** Die Zeilen [number withheld]–[number withheld] heißen jetzt „Level $b$“ statt „Post-policy $b$“, damit die Tabelle in die Breite passt; die Notiz erklärt das.
- **Tabelle [number withheld]:** Für die Seitengrenze habe ich die Einträge stark gekürzt (z. B. „Gaps may overstate“). Bitte prüfen, ob das sprachlich trägt.
- **Abstract** in `main.tex` (außerhalb des Schreibbereichs) bleibt unverändert; laut Karte passt sein Wortlaut schon.
- **Vorschlag für `AI_USAGE_LOG.md`:** „2026-10-30, Claude (Writer), T056: T055-Ergebnisse in Abschnitte [number withheld]–[number withheld] eingearbeitet, H2a/H2b, Ich-Form, Robustheits- und Gefährdungstabelle ergänzt, Kürzungen auf [number withheld] Seiten; Zahlen aus `replication/outputs/tables/`.“
