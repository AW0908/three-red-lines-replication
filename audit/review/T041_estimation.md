## Rolle: estimation (claude, sonnet) – VERDICT: PASS


## Befunde
Keine Befunde, die ein Rework nötig machen. Fünf Hinweise ohne Urteilsrelevanz:

1. **Querschnitte mit Polynom Grad 5 sind sehr unscharf.** Das Polynom wird auf nur ca. 120–135 Beobachtungen geschätzt (`t041_one_per_firm.tex`, Zeilen 6–10). Die Intervalle sind entsprechend breit, zum Beispiel [-0,67; 4,99] bei 2020H2. Der Text behandelt das korrekt als deskriptiv und überinterpretiert nicht. Die 60-Firmen-Schwelle greift nie, alle Zellen haben mindestens 124 Firmen.
2. **TeX-Zeile mit Firmenzahl "112/0".** Für den nicht verfügbaren Kontrast "Post minus 2017-06-30, 3 years" zeigt die Spalte Firms "112/0", Schätzer und Intervall sind "--" (`14_core_robustness.R`, Zeile 134). Das ist nur kosmetisch. Die Nichtverfügbarkeit ist in CSV (`available=FALSE`) und Notiz dokumentiert.
3. **Punktschätzer der Datumsverhältnisse vor der Politik schwanken stark.** 2019H1 liegt bei 0,43 (CI [0,13; 0,81]), 2020H1 bei 0,50 (CI [0,17; 0,92]), beide unter 1. Das stützt die Zurückhaltung des Workers bei "abrupt", spricht aber auch dafür, dass die gepoolte Prä-Dichte nicht perfekt trägt. Die Verifikationsdatei sagt das so nicht ausdrücklich. Die Aussage "kein statistisch abrupter Bruch" ist in jedem Fall vorsichtig genug.
4. **Placebo-Differenzen vergleichen leicht unterschiedliche Firmenmengen.** Die Überlappung liegt bei 107–119 Firmen (`overlap_firms`, Spalte in `t041_frozen_horizons.csv`). Die gemeinsamen Bootstrap-Gewichte erhalten die Abhängigkeit, und der Worker dokumentiert das ("available cell samples may differ"). Das ist akzeptabel.
5. **Veränderte Dateien außerhalb des Schreibbereichs.** Die Skriptmeldung nennt `Daten/annual_reports_all/*.pdf` und `proposal/references.bib`. `14_core_robustness.R` schreibt nur auf Ziele mit dem Präfix `t041_` (`stage()` mit `stopifnot(grepl('^t041_', ...))`). Die Änderungen stammen daher sehr wahrscheinlich aus parallelen Sitzungen (Datendownload, T040) und nicht aus T041. Das kann ich nicht belegen, der Co-PI sollte es prüfen.

## Abnahmekriterien

**Spezifikation, Stichprobe und Inferenz (meine Rolle):**
- **Bunching je Halbjahr (Schritt 1):** belegt erfüllt.
  - Die Prä-Periode ist 2017-06-30 bis 2019-12-31, Grad 5, Fensterbins mit Mittelpunkt in [0,66; 0,70). Das Beobachtungsfenster `rl1 >= .66 & < .7` passt dazu.
  - Der Nenner sind alle endlichen RL1-Werte. Er ist für Beobachtung und Kontrafaktisch gleich konstruiert (Zeilen 165–175).
  - Der Prä-Fit wird in jedem Bootstrap-Draw neu geschätzt (`pre_cf_draw`), die Firmengewichte sind gemeinsam. Das ist korrekte Neuschätzung.
  - 12 Zeilen, 999 gültige Draws, Firmenzahlen stehen daneben.
  - Die Abruptheit wird berichtet: 2020H2 1,48 [0,94; 2,08], 2021H1 1,57 [0,99; 2,22]. Beide Intervalle enthalten 1. Ab 2021H2 schließt das CI die 1 aus. Die Verifikationsdatei gibt das korrekt wieder.
- **Eine Beobachtung je Firma, Querschnitte (2a):** belegt erfüllt.
  - 5 Daten, jeweils mit T023-Baseline-Schätzer, Firmenzahlen 135/132/130/124/124. Die Zeilenzahl 1004 = 5 + 999 ist per `stopifnot` abgesichert.
  - Die Behauptung "Intervall erst bei 2021H2 und 2022H1 über null" stimmt mit den Tabellenwerten überein.
- **Eine Beobachtung je Firma, Zufallsziehungen (2b):** belegt erfüllt.
  - Gezogen wird eine post-Beobachtung je Firma (`stopifnot(!anyDuplicated)`), n=132 Firmen je Draw, 999 Draws mit Neuschätzung des Polynoms.
  - Dem Verteilungsintervall wird bewusst kein Bootstrap-CI zugeschrieben und das ist ausdrücklich so beschriftet.
  - Anteil b>0: 998/999.
- **Niedrige Flexibilität (Schritt 3):** belegt erfüllt.
  - Grad 1 und Grad 2 auf [0,55; 0,85], lokal linear mit Tricube und h=0,10 auf Bins außerhalb des Fensters, daneben die T023-Baseline.
  - Die Gewichtsmatrix des lokalen Fits (Zeilen 241–244) ist rechnerisch korrekt: Intercept der gewichteten Regression am Zielpunkt.
  - Schätzer und CIs: 5,45 [2,50; 9,03], 2,35 [0,39; 4,92], 2,88 [0,74; 5,59], Baseline 3,14 [1,01; 5,84]. Die Aussage "alle CIs über null" stimmt.
  - Die Firmenzahl ist 132 in allen Zeilen.
- **Eingefrorene MI mit gleichen Horizonten (Schritt 4):** belegt erfüllt.
  - Horizonte 1 bis 3 Jahre nach dem Anker, korrekte Datumszuordnung über `anchor_h`.
  - Placebo-Ankerdaten 2016-12-31 und 2017-06-30, Verfügbarkeit nur für 2017-12-31 bis 2019-12-31. Der 3-Jahres-Horizont zum Anker 2017-06-30 ist explizit nicht verfügbar und wird nicht extrapoliert.
  - Die gepaarten Differenzen nutzen dieselben Bootstrap-Gewichte (`a$draws - b$draws`).
  - Die Aussage "Differenzen positiv bei 1,5/2/2,5 Jahren, nicht bei 3 Jahren (2016) und nicht bei 1 Jahr (2017)" stimmt mit der CSV überein. Beispiel 2016, 3 Jahre: -0,007 [-0,086; 0,066].
- **Identifikation im Code:** keine stillschweigenden Verletzungen gefunden. Das Treatment (frozen) ist aus dem Anker-MI gebaut und nicht aus dem Outcome. Die Gültigkeitsdomäne N>0 und E>0 stimmt mit T029 überein.
- **Inferenz:** Das Clustering ist auf Firmenebene (ganze Historien), die Perzentilintervalle haben 999 Draws, es gibt keine t- oder Normalverteilungsannahme. Mehrfachtests sind als nicht adjustiert benannt.
- **Ausgabe:** Die CSV-Werte sind konsistent mit den Skriptdefinitionen und den TeX-Tabellen. Die Zeilen und Spalten sind korrekt zugeordnet (Stichproben in `t041_one_per_firm.tex` gegen die CSV).

**Kriterium 1 der Karte (Reproduktion, Byte-Identität):** belegt erfüllt.
- Die Reproduktions-Asserts stehen im Skript vor allen Analysen (Zeilen 114–118).
- Die Ausgabe 3,142854757615 ergibt gerundet 3,14, und D=0,114617940199 ergibt 0,1146.
- `t041_hashes.csv` zeigt für alle 10 erzeugten Artefakte identische SHA-256-Werte in Lauf 1 und Lauf 2.
- Die geschützten Ausgaben sind per Hash unverändert. Das Skript prüft das zusätzlich selbst vor dem Schreiben.

**Kriterium 2 (alle Varianten, Firmenzahlen):** belegt erfüllt. Alle vorab festgelegten Varianten sind berichtet, einschließlich Nichtverfügbarkeit und der negativen Werte.

**Kriterium 3 (Ergebnis je Check ohne Overclaiming):** belegt erfüllt. Die Bewertung in `t041_verification.txt` (Zeilen 28–34) ist differenziert und passt zu den Tabellen. Kausale Aussagen werden ausdrücklich verneint.

**Nicht meine Rolle:** Datenaufbereitung (Panel, sample_main) und Sprache.

## Nicht geprüft
- Ich konnte keine Befehle ausführen (Bash war gesperrt). Die Reproduzierbarkeit stütze ich auf die Hash-Tabelle `t041_hashes.csv` und die Logs, nicht auf einen eigenen Lauf.
- Die zugrundeliegenden Panel-Spalten (`rl1`, `tl`, `adv`, `te`, `mi`) habe ich nicht gegen Rohdaten geprüft.
- `06_bunching_tests.R`, `11_mechanism.R` und `12_q1_robustness.R` habe ich nicht neu gelesen. Die Übereinstimmung mit der T023-Konvention beruht darauf, dass die Reproduktionsasserts b=3,14 und D=0,1146 im Skript bestanden sind.
- Das Kompilieren der TeX-Fragmente und das Rendering der PDFs habe ich nicht verifiziert. Die Abbildungen habe ich nicht angesehen.
- Ein vollständiger `run_all`-Neuaufbau wurde laut Worker nicht ausgeführt. Schritt 14 steht in `run_all.R` (Zeile 21), ich habe `run_all.sh` und `README.md` nicht gelesen.
- Die Änderungen außerhalb des Schreibbereichs (Hinweis 5) und den `AI_USAGE_LOG.md`-Stand habe ich nicht geprüft.
