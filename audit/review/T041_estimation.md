## Rolle: estimation (claude, sonnet) – VERDICT: PASS


## Befunde
Keine Befunde, die ein Rework nötig machen. Fünf Hinweise ohne Urteilsrelevanz:

[number withheld]. **Querschnitte mit Polynom Grad [number withheld] sind sehr unscharf.** Das Polynom wird auf nur ca. [number withheld]–[number withheld] Beobachtungen geschätzt (`t041_one_per_firm.tex`, Zeilen [number withheld]–[number withheld]). Die Intervalle sind entsprechend breit, zum Beispiel [[number withheld]; [number withheld]] bei [number withheld]H2. Der Text behandelt das korrekt als deskriptiv und überinterpretiert nicht. Die [number withheld]-Firmen-Schwelle greift nie, alle Zellen haben mindestens [number withheld] Firmen.
[number withheld]. **TeX-Zeile mit Firmenzahl "[number withheld]/[number withheld]".** Für den nicht verfügbaren Kontrast "Post minus 2017-06-30, [number withheld] years" zeigt die Spalte Firms "[number withheld]/[number withheld]", Schätzer und Intervall sind "--" (`14_core_robustness.R`, Zeile [number withheld]). Das ist nur kosmetisch. Die Nichtverfügbarkeit ist in CSV (`available=FALSE`) und Notiz dokumentiert.
[number withheld]. **Punktschätzer der Datumsverhältnisse vor der Politik schwanken stark.** [number withheld]H1 liegt bei [number withheld] (CI [[number withheld]; [number withheld]]), [number withheld]H1 bei [number withheld] (CI [[number withheld]; [number withheld]]), beide unter [number withheld]. Das stützt die Zurückhaltung des Workers bei "abrupt", spricht aber auch dafür, dass die gepoolte Prä-Dichte nicht perfekt trägt. Die Verifikationsdatei sagt das so nicht ausdrücklich. Die Aussage "kein statistisch abrupter Bruch" ist in jedem Fall vorsichtig genug.
[number withheld]. **Placebo-Differenzen vergleichen leicht unterschiedliche Firmenmengen.** Die Überlappung liegt bei [number withheld]–[number withheld] Firmen (`overlap_firms`, Spalte in `t041_frozen_horizons.csv`). Die gemeinsamen Bootstrap-Gewichte erhalten die Abhängigkeit, und der Worker dokumentiert das ("available cell samples may differ"). Das ist akzeptabel.
[number withheld]. **Veränderte Dateien außerhalb des Schreibbereichs.** Die Skriptmeldung nennt `Daten/annual_reports_all/*.pdf` und `proposal/references.bib`. `14_core_robustness.R` schreibt nur auf Ziele mit dem Präfix `t0[number withheld]_` (`stage()` mit `stopifnot(grepl('^t0[number withheld]_', ...))`). Die Änderungen stammen daher sehr wahrscheinlich aus parallelen Sitzungen (Datendownload, T040) und nicht aus T041. Das kann ich nicht belegen, der Co-PI sollte es prüfen.

## Abnahmekriterien

**Spezifikation, Stichprobe und Inferenz (meine Rolle):**
- **Bunching je Halbjahr (Schritt [number withheld]):** belegt erfüllt.
  - Die Prä-Periode ist 2017-06-30 bis 2019-12-31, Grad [number withheld], Fensterbins mit Mittelpunkt in [[number withheld]; [number withheld]). Das Beobachtungsfenster `rl1 >= .[number withheld] & < .[number withheld]` passt dazu.
  - Der Nenner sind alle endlichen RL1-Werte. Er ist für Beobachtung und Kontrafaktisch gleich konstruiert (Zeilen [number withheld]–[number withheld]).
  - Der Prä-Fit wird in jedem Bootstrap-Draw neu geschätzt (`pre_cf_draw`), die Firmengewichte sind gemeinsam. Das ist korrekte Neuschätzung.
  - [number withheld] Zeilen, [number withheld] gültige Draws, Firmenzahlen stehen daneben.
  - Die Abruptheit wird berichtet: [number withheld]H2 [number withheld] [[number withheld]; [number withheld]], [number withheld]H1 [number withheld] [[number withheld]; [number withheld]]. Beide Intervalle enthalten [number withheld]. Ab [number withheld]H2 schließt das CI die [number withheld] aus. Die Verifikationsdatei gibt das korrekt wieder.
- **Eine Beobachtung je Firma, Querschnitte ([number withheld]a):** belegt erfüllt.
  - [number withheld] Daten, jeweils mit T023-Baseline-Schätzer, Firmenzahlen [number withheld]/[number withheld]/[number withheld]/[number withheld]/[number withheld]. Die Zeilenzahl [number withheld] = [number withheld] + [number withheld] ist per `stopifnot` abgesichert.
  - Die Behauptung "Intervall erst bei [number withheld]H2 und [number withheld]H1 über null" stimmt mit den Tabellenwerten überein.
- **Eine Beobachtung je Firma, Zufallsziehungen ([number withheld]b):** belegt erfüllt.
  - Gezogen wird eine post-Beobachtung je Firma (`stopifnot(!anyDuplicated)`), n=[number withheld] Firmen je Draw, [number withheld] Draws mit Neuschätzung des Polynoms.
  - Dem Verteilungsintervall wird bewusst kein Bootstrap-CI zugeschrieben und das ist ausdrücklich so beschriftet.
  - Anteil b>[number withheld]: [number withheld]/[number withheld].
- **Niedrige Flexibilität (Schritt [number withheld]):** belegt erfüllt.
  - Grad [number withheld] und Grad [number withheld] auf [[number withheld]; [number withheld]], lokal linear mit Tricube und h=[number withheld] auf Bins außerhalb des Fensters, daneben die T023-Baseline.
  - Die Gewichtsmatrix des lokalen Fits (Zeilen [number withheld]–[number withheld]) ist rechnerisch korrekt: Intercept der gewichteten Regression am Zielpunkt.
  - Schätzer und CIs: [number withheld] [[number withheld]; [number withheld]], [number withheld] [[number withheld]; [number withheld]], [number withheld] [[number withheld]; [number withheld]], Baseline [number withheld] [[number withheld]; [number withheld]]. Die Aussage "alle CIs über null" stimmt.
  - Die Firmenzahl ist [number withheld] in allen Zeilen.
- **Eingefrorene MI mit gleichen Horizonten (Schritt [number withheld]):** belegt erfüllt.
  - Horizonte [number withheld] bis [number withheld] Jahre nach dem Anker, korrekte Datumszuordnung über `anchor_h`.
  - Placebo-Ankerdaten 2016-12-31 und 2017-06-30, Verfügbarkeit nur für 2017-12-31 bis 2019-12-31. Der [number withheld]-Jahres-Horizont zum Anker 2017-06-30 ist explizit nicht verfügbar und wird nicht extrapoliert.
  - Die gepaarten Differenzen nutzen dieselben Bootstrap-Gewichte (`a$draws - b$draws`).
  - Die Aussage "Differenzen positiv bei [number withheld]/[number withheld]/[number withheld] Jahren, nicht bei [number withheld] Jahren ([number withheld]) und nicht bei [number withheld] Jahr ([number withheld])" stimmt mit der CSV überein. Beispiel [number withheld], [number withheld] Jahre: [number withheld] [[number withheld]; [number withheld]].
- **Identifikation im Code:** keine stillschweigenden Verletzungen gefunden. Das Treatment (frozen) ist aus dem Anker-MI gebaut und nicht aus dem Outcome. Die Gültigkeitsdomäne N>[number withheld] und E>[number withheld] stimmt mit T029 überein.
- **Inferenz:** Das Clustering ist auf Firmenebene (ganze Historien), die Perzentilintervalle haben [number withheld] Draws, es gibt keine t- oder Normalverteilungsannahme. Mehrfachtests sind als nicht adjustiert benannt.
- **Ausgabe:** Die CSV-Werte sind konsistent mit den Skriptdefinitionen und den TeX-Tabellen. Die Zeilen und Spalten sind korrekt zugeordnet (Stichproben in `t041_one_per_firm.tex` gegen die CSV).

**Kriterium [number withheld] der Karte (Reproduktion, Byte-Identität):** belegt erfüllt.
- Die Reproduktions-Asserts stehen im Skript vor allen Analysen (Zeilen [number withheld]–[number withheld]).
- Die Ausgabe [number withheld] ergibt gerundet [number withheld], und D=[number withheld] ergibt [number withheld].
- `t041_hashes.csv` zeigt für alle [number withheld] erzeugten Artefakte identische SHA-[number withheld]-Werte in Lauf [number withheld] und Lauf [number withheld].
- Die geschützten Ausgaben sind per Hash unverändert. Das Skript prüft das zusätzlich selbst vor dem Schreiben.

**Kriterium [number withheld] (alle Varianten, Firmenzahlen):** belegt erfüllt. Alle vorab festgelegten Varianten sind berichtet, einschließlich Nichtverfügbarkeit und der negativen Werte.

**Kriterium [number withheld] (Ergebnis je Check ohne Overclaiming):** belegt erfüllt. Die Bewertung in `t041_verification.txt` (Zeilen [number withheld]–[number withheld]) ist differenziert und passt zu den Tabellen. Kausale Aussagen werden ausdrücklich verneint.

**Nicht meine Rolle:** Datenaufbereitung (Panel, sample_main) und Sprache.

## Nicht geprüft
- Ich konnte keine Befehle ausführen (Bash war gesperrt). Die Reproduzierbarkeit stütze ich auf die Hash-Tabelle `t041_hashes.csv` und die Logs, nicht auf einen eigenen Lauf.
- Die zugrundeliegenden Panel-Spalten (`rl1`, `tl`, `adv`, `te`, `mi`) habe ich nicht gegen Rohdaten geprüft.
- `06_bunching_tests.R`, `11_mechanism.R` und `12_q1_robustness.R` habe ich nicht neu gelesen. Die Übereinstimmung mit der T023-Konvention beruht darauf, dass die Reproduktionsasserts b=[number withheld] und D=[number withheld] im Skript bestanden sind.
- Das Kompilieren der TeX-Fragmente und das Rendering der PDFs habe ich nicht verifiziert. Die Abbildungen habe ich nicht angesehen.
- Ein vollständiger `run_all`-Neuaufbau wurde laut Worker nicht ausgeführt. Schritt [number withheld] steht in `run_all.R` (Zeile [number withheld]), ich habe `run_all.sh` und `README.md` nicht gelesen.
- Die Änderungen außerhalb des Schreibbereichs (Hinweis [number withheld]) und den `AI_USAGE_LOG.md`-Stand habe ich nicht geprüft.
