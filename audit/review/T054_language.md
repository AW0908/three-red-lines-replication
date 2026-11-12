## Rolle: language (claude, sonnet) – VERDICT: REWORK


Ich habe nur die Sprache geprüft. Die Dateien sind nicht verändert, und das Skript meldet die Übersetzung als fehlerfrei.

## Befunde

Es gibt keine sinnentstellenden Fehler. Alle Punkte sind Kleinigkeiten und Vorschläge.

1. **Term MI nicht durchgehend in Abschnitt 5–6 (Karte, Punkt 5).**
   - Die Karte verlangt „MI“ konsistent in Abschnitt 5–6. Im Fließtext steht dort noch ausgeschrieben:
     - `05_context_data.tex:24` „total equity including minority interests“
     - `05_context_data.tex:58` „the minority-interest share“
     - `05_context_data.tex:71` „The minority-interest share of equity rises“
     - `06_preliminary_analysis.tex:31` „minority-interest growth since 2019“ und „Minority interests make up“
   - Dagegen steht in `06_preliminary_analysis.tex:42` und `:46` „MI“.
   - Vorschlag: im Fließtext überall „MI“ schreiben, z. B. „MI share of equity“ und „MI growth“. Überschrift (`06:27`) und Bildunterschrift (`06:36`, `06:37`) können ausgeschrieben bleiben, wenn der PI das so will.
   - Die Tabellenzeile `05_context_data.tex:50` „Minority-interest share of equity“ ist ebenfalls ausgeschrieben.

2. **`06_preliminary_analysis.tex:115`: „its interval lies above zero at 0.70 but at neither placebo threshold“.**
   - Die Konstruktion ist holprig, und „but … neither“ ist doppelt verneint.
   - Vorschlag: „its interval lies above zero at 0.70 but not at either placebo threshold“.

3. **`01_introduction.tex:14`: „the exploratory result disclosure of economic substance“.**
   - Die Auslassung („the secondary result the mechanical role of MI, and …“) ist schwer lesbar. „Exploratory result disclosure“ liest sich wie ein Kompositum.
   - Vorschlag: „Our primary result is the change in excess mass at RL1; the secondary result is the mechanical role of MI; the exploratory result concerns how little disclosure reveals about economic substance.“
   - Die Vorversion dieses Satzes war klarer.

4. **`02_literature.tex:16`: „We combine the strands: we test RL1 excess mass, measure compliance's dependence on MI growth and separate documented contract terms from missing disclosure.“**
   - „compliance's dependence“ ist umständlich.
   - Die Reihe hat kein Komma vor „and“. Im amerikanischen Englisch ist das Serienkomma üblich, und die Einleitung verwendet es („banks, local governments …, and firms“).
   - Vorschlag: „We combine the strands: we test for RL1 excess mass, measure how far compliance depends on MI growth, and separate documented contract terms from missing disclosure.“
   - Das Serienkomma fehlt auch an anderen Stellen, z. B. „group equity, outside equity and conditional exits“ in `01:19`/`06` und „the counterparty, any buyback or put obligations, guarantees and shareholder loans“ in `07:10`. Die Schreibweise ist im Dokument gemischt, ich empfehle eine einheitliche Regel.

5. **`02_literature.tex:20`, Absatz „How we searched“.**
   - „(Appendix Figure~\ref{fig:prisma}, following Preferred Reporting Items for Systematic Reviews and Meta-Analyses, PRISMA, 2020~\citep{…}; Tables …)“ ist als Klammer überladen, und die Abkürzung steht zwischen Kommas.
   - „It documents coverage, not completeness.“: „It“ kann sich auf das Review oder das Verfahren beziehen.
   - Vorschlag: „The search protocol follows the Preferred Reporting Items for Systematic Reviews and Meta-Analyses (PRISMA) 2020 guidelines~\citep{page2021prisma} (Appendix Figure~\ref{fig:prisma}, Tables~\ref{tab:wos_queries}--\ref{tab:cnki_queries}). It documents coverage, not completeness.“
   - Auch „PRISMA“ im Fließtext sollte beim ersten Auftreten klar definiert sein. Das ist es, aber nur in der Klammer.

6. **`03_framework.tex:20`: „This noise and firm-specific ratio definitions (…) spread the bunched mass around the threshold … hence we report an empirical window and a mass-conserving fit“.**
   - „This noise“ hat einen entfernten Bezug, denn „noise“ steht im vorigen Satz.
   - „empirical window“ ist in Abschnitt 3 nicht eingeführt.
   - Vorschlag: „Noise and firm-specific ratio definitions … spread …; we therefore report both an empirical window and a mass-conserving fit …“. Der Verweis auf `\ref{subsec:bunching_design}` für das Fenster wäre hilfreich.

7. **`05_context_data.tex`, Absatz 4.1: „Section~\ref{sec:intro} sets out the thresholds and caps, which the People's Bank of China and the housing ministry communicated~\citep{…}.“**
   - Der Satz beginnt mit einem Querverweis. Der Relativsatz „which … communicated“ bezieht sich grammatisch auf „thresholds and caps“.
   - „housing ministry“ und „central bank“ sind informell. Die Abkürzung PBoC ist entfallen, während der Kommentar noch von der „PBoC announcement“ spricht. Das ist ein Hinweis, kein Fehler.
   - Vorschlag: „The People's Bank of China and the Ministry of Housing and Urban-Rural Development communicated the rules to twelve developers (thresholds and caps: Section~\ref{sec:intro}).“

8. **`06_preliminary_analysis.tex:46`: „Continued pre-policy growth is an assumption without a comparable trend placebo.“**
   - Der Satz ist knapp, das „without“ klingt wie „ohne“ und nicht wie „nicht schätzbar“.
   - Vorschlag: „Continued pre-policy growth is an assumption, and a comparable trend placebo cannot be estimated with the available history.“
   - Das wäre der Sinn der Vorversion.
   - Dazu ein Hinweis: „its interval includes zero“ nach „under the bin trend“ im Satz davor bezieht sich auf Excess mass, ist aber nahe an „5.6 points“ im vorigen Satz. Es ist verständlich, aber knapp.

9. **Hinweise, keine Sprachfehler (gehören anderen Rollen).**
   - `01_introduction.tex:10`: Das Zitat wurde in den Strichpunkt-Satz verschoben, die erste Teilaussage hat keine eigene Quelle mehr.
   - `03_framework.tex`: Der Satz „Our balance-sheet data do not reveal κ“ wurde gestrichen. Prüfen, ob das in H3 abgedeckt ist.
   - `05_context_data.tex`: Das `TODO(PI)` zur Berichtsdatenfrage bleibt offen.

## Abnahmekriterien

- **1. Keine neuen Zahlen oder Referenzen, verschobene Zahlen unverändert und auf CSVs rückführbar:** Nicht meine Rolle. Sprachlich sehe ich im Diff keine neuen Zahlen. Die Zahlen 9.8, 4.7, 15.1, 5.6, 3.18 und 1.52 habe ich nicht gegen die CSV geprüft.
- **2. Hauptteil endet auf Seite 15, Build sauber:** Der Build ist laut `review/T054_latex.txt` fehlerfrei, das ist belegt erfüllt. Die Seitenzahl habe ich nicht geprüft, denn das PDF habe ich nicht gelesen. Das ist „nicht prüfbar“.
- **3. Jeder Punkt 1–7 hat eine Zeile im Bericht mit Datei:Zeile:** Nicht meine Rolle. Ich habe `tasks/T054_report.md` nicht geprüft.
- **Sprachliche Umsetzung der Punkte:**
  - Punkte 1, 2, 3, 4, 6 und 7 sind inhaltlich umgesetzt, mit den oben genannten Formulierungsvorschlägen.
  - Punkt 5 ist nur teilweise erfüllt (Befund 1).
  - Die Schreibweisen „compliant share“, „mass-conserving fit“ und „firm trend“ sind durchgängig einheitlich. In 06:46 steht „common trend per ratio bin“ statt „bin trend“, das ist im Text vertretbar.

## Nicht geprüft

- Seitenzahl und Seitenumbruch des Hauptteils, da ich kein PDF gelesen habe.
- Rechtschreibung der Anhänge und der Tabellen, die nicht zu den eingefrorenen Dateien gehören.
- `06_preliminary_analysis.tex` über Zeile 50 hinaus und `04_empirical_model.tex`. Den vollständigen Fließtext der Dateien habe ich nicht Zeile für Zeile gelesen, nur den Diff, `06:1–50`, `07` und gezielte Suchen.
- Alle Zahlen, Zitationsschlüssel und Abbildungsverweise inhaltlich. Dass sie kompilieren, ergibt sich nur aus dem fehlerfreien Build.
