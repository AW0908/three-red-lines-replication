## Rolle: language (claude, sonnet) – VERDICT: REWORK


Rolle: Language. Es gibt keine Rechtschreib- oder Grammatikfehler und keine sinnentstellenden Stellen. Die folgenden Funde sind kleine Stil- und Konsistenzpunkte. Der Build ist laut `review/T051_latex.txt` fehlerfrei. Die Funde [number withheld]–[number withheld] sollten vor der Abnahme behoben werden.

## Befunde

[number withheld]. **Uneinheitliche Schreibweise "[number withheld]%" und "[number withheld] percent" in der Tabellennotiz** (`proposal/tables/t051_robustness.tex:27`)
   - Die Notiz schreibt "([number withheld]\% CI ...)". Der gesamte Fließtext und alle anderen `\floatnote`s schreiben "[number withheld] percent", zum Beispiel `06_preliminary_analysis.tex:10` und `:[number withheld]`.
   - Die Karte erlaubt "[number withheld]%" nur im Tabellenkopf (Z. [number withheld]), nicht in der Notiz.
   - Vorschlag: "([number withheld] percent CI $[[number withheld]]$)".

[number withheld]. **Uneinheitlicher Begriff für das Bootstrap** (`t051_robustness.tex:27`)
   - "Whole-firm bootstrap CIs" kommt sonst nirgends vor. Der Text verwendet "firm-bootstrap" (`06_preliminary_analysis.tex:18`), "firm resampling" (`04_empirical_model.tex:50`) und "joint-bootstrap" (`[number withheld]:[number withheld]`).
   - Vorschlag: "Firm-bootstrap CIs, [number withheld] draws."

[number withheld]. **Knappe, ungeklärte Zeilenbezeichnung "fixed point"** (`t051_robustness.tex:24`)
   - "Post-policy $b_{\text{net}}$: fixed point" ist ohne die Vorlage der alten Prosa ("mass-conserving fixed-point fit") nicht verständlich.
   - Vorschlag: "mass-conserving fit" oder "fixed-point fit" und $b_{\text{net}}$ in der Notiz mit einem Halbsatz erklären.

[number withheld]. **Unklarer Bezug in der Zusammenfassung der Tabelle** (`06_preliminary_analysis.tex:25`)
   - "although measurement error of the size found in the validation shrinks it": Der Bezug von "it" ist unklar, und die Konstruktion ist schwerfällig.
   - Vorschlag: "although simulated measurement error of the size found in the validation shrinks the estimate."

[number withheld]. **Mehrdeutiges "but not" in Finding [number withheld]** (`06_preliminary_analysis.tex:45`)
   - Der Satz lautet: "Excess mass stays positive under the firm trend at $b_{\text{trend}}=[number withheld]$, down from [number withheld], with an interval above zero, but not under the bin trend." Unklar ist, ob "not" die Positivität oder das Intervall meint. Außerdem sind zu viele Einschübe gestapelt.
   - Vorschlag: "Under the firm trend, excess mass stays positive ($b_{\text{trend}}=[number withheld]$, down from [number withheld]) and its interval is above zero. Under the bin trend, the interval includes zero."

[number withheld]. **Holpriger Satz in [number withheld]** (`04_empirical_model.tex:50`)
   - "Sales shocks still move firms relative to the threshold even though the frozen benchmark holds adjusted liabilities fixed." Das "still … even though" ist unnötig und klingt nach Rechtfertigung.
   - Vorschlag: "The frozen benchmark holds adjusted liabilities fixed, but sales shocks still move firms relative to the threshold."
   - Außerdem verspricht "Each finding faces its own main threat" drei Bedrohungen, behandelt aber nur Finding [number withheld] und [number withheld]. Für Finding [number withheld] fehlt der Satz. Vorschlag: "Each finding faces its own main threat" streichen oder einen Satz zur Offenlegung ergänzen. Das ist ein inhaltlicher Hinweis.

[number withheld]. **Konklusion: schwache Formulierung "we estimate no causal policy effect"** (`07_conclusion.tex:9`)
   - Vorschlag: "we do not estimate a causal policy effect".
   - Das "which" in "…not evidence of debt-like equity, which remains a motivation" bezieht sich unklar auf "Missing terms" oder "debt-like equity". Vorschlag: "Missing terms are not evidence of debt-like equity; its prevalence remains a motivation, not a quantified result."

[number withheld]. **Konklusion: dreimal derselbe Satzanfang und wechselnde Begriffe** (`07_conclusion.tex:7`)
   - "For a supervisor," steht dreimal in einem Absatz. Variieren, zum Beispiel "Supervisors should therefore read …", "The count of compliant developers thus rests …".
   - "subsidiary equity" ist ein neuer Begriff. Sonst heißt es "minority equity" oder "minority interests". Vorschlag: "minority equity".
   - "although MI growth did not exceed its pre-policy pace" ist logisch ein loser Gegensatz zu "lowers compliance". Vorschlag: "and MI growth did not exceed its pre-policy pace" oder "even though".

[number withheld]. **Konklusion, letzter Absatz: Unklare Formulierung** (`07_conclusion.tex:14`)
   - "obtain the annual reports missing from the decompositions". Die Berichte fehlen nicht "aus" den Zerlegungen.
   - Vorschlag: "obtain the annual reports needed to complete the decompositions" (so stand es vorher).

[number withheld]. **Einleitung: Wiederholung von "discrete"** (`01_introduction.tex:6`)
    - "changes in discrete steps, … gains a discrete benefit". Vorschlag: "Because the cap changes in steps, a developer just above a threshold gains from moving just below it."
    - "There are two ways to get there." Der Bezug von "there" ist vage. Vorschlag: "A developer can get below a threshold in two ways: it can repay debt, or it can raise equity, …".
    - "the rules" kommt in zwei aufeinanderfolgenden Sätzen vor. Das ist akzeptabel, aber "them" oder "the policy" würde den Fluss verbessern.

[number withheld]. **Uneinheitliche Begriffe für Minority Interests** (`06_preliminary_analysis.tex:31, 45`)
    - Im Text stehen "Minority interests make up a median …", "Minority-interest growth" und "MI growth" nebeneinander. "MI" ist in der Einleitung (`01_introduction.tex:10`) definiert.
    - Die Notiz in `t051_robustness.tex` und der Abstract verwenden "minority-interest". Das ist mit dem Wechsel zu "MI" vereinbar. Eine einheitliche Verwendung wäre dennoch besser (Hinweis, keine Pflicht).

[number withheld]. **Kleinere Typografie** (Hinweis)
    - Im Tabellenkopf steht "Obs.\ (firms)", in den Zeilen steht "obs.\ per firm". Das ist akzeptabel, aber "observation per firm" ausgeschrieben wäre sauberer.
    - Die Notiz hat vier Sätze mit Doppelpunkten und Semikola. "Details: Appendix Tables~\ref{…}, \ref{…}, …; single dates: replication package." Der Teil nach dem Semikolon ist ein Fragment. Vorschlag: "Single dates are in the replication package."

## Abnahmekriterien

[number withheld]. Haupttext endet auf Seite [number withheld], Build sauber: nicht meine Rolle. Der Build ist fehlerfrei (`review/T051_latex.txt`: "übersetzt fehlerfrei"). Die Seitenzahl habe ich nicht geprüft.
[number withheld]. Zahlen der Robustheitstabelle gegen die CSVs: nicht meine Rolle.
[number withheld]. Drei-Absatz-Regel der Einleitung: sprachlich plausibel (Absatz [number withheld] Politik, Absatz [number withheld] Frage und Methode, Absatz [number withheld] Beitrag). Die inhaltliche Prüfung ist nicht meine Rolle.
[number withheld]. PI-Kommentare [number withheld]–[number withheld] jeweils mit einer Zeile im Bericht: nicht meine Rolle.
[number withheld]. Sprachliche Anforderungen aus dem Schreibleitfaden der Karte (amerikanisches Englisch, ein Intervall pro Satz, keine gestapelten Klammern):
   - Amerikanisches Englisch: erfüllt.
   - Ein Intervall pro Satz: erfüllt. Die Notiz hat nur ein Intervall, siehe Fund [number withheld] zum Format.
   - Gestapelte Klammern: in `[number withheld]:[number withheld]` und in der Notiz nur schwach (Funde [number withheld] und [number withheld]).
   - Teilweise erfüllt, siehe Funde [number withheld]–[number withheld].

## Nicht geprüft

- Die kompilierte PDF-Ausgabe. Ich habe nur die Quelldateien gelesen. Zeilen- und Seitenumbruch, Lesbarkeit der Achsenbeschriftung in Figure [number withheld] und die Größe von Table [number withheld] habe ich nicht gesehen.
- `proposal/main.tex`, `05_context_data.tex` und `appendix/results.tex` habe ich nur über das Diff und stichprobenartig gelesen. Die Änderungen dort sind sprachlich unauffällig. `agents/overleaf.sh` liegt außerhalb meiner Rolle.
- Abschnitt [number withheld] ab Finding [number withheld] (nur im Diff gesehen) und [number withheld]/[number withheld].
- Rechtschreibung der englischen `.bib`-Einträge und der Literaturliste.
