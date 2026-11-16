## Rolle: estimation (claude, opus) – VERDICT: PASS


## Befunde
In meiner Rolle (Estimation) habe ich keine inhaltlichen Fehler gefunden. Hinweise, die das Urteil nicht ändern:

[number withheld]. **CI von Kontrast [number withheld] hängt an gültigen Ziehungen.** Das Perzentil-Intervall für `equity_mi_perp_share` wird nur aus [number withheld] von [number withheld] Ziehungen berechnet (`08_decomposition.R:277-278`). Fehlt die einzige Pre-Firma in einer Ziehung, fällt die Ziehung weg. Das Intervall gilt also nur unter der Bedingung, dass diese Firma gezogen wird. Code und Tabelle kennzeichnen das richtig: `inference_status=conditional_unreliable`, Zeile [number withheld] in `t027_tests.csv` und Fußnote in `t027_tests.tex`. Interpretieren lässt sich der Kontrast trotzdem nicht. Das muss so im Text stehen bleiben.
[number withheld]. **Prozentpunkt-Umrechnung ist eine Näherung.** Sie wird an der Stelle RL1 = [number withheld] ausgewertet und nicht je Ereignis (`08_decomposition.R:324`). [number withheld] × [number withheld] × [number withheld] = [number withheld] pp stimmt rechnerisch. Die Karte verlangt genau diese Form, und der Wert ist als Näherung beschriftet.
[number withheld]. **Satzzeichen in der RL1-Überschrift (nicht meine Rolle, nur notiert).** Vor „Change in logit(RL1)“ fehlt ein Punkt oder Doppelpunkt (`t027_decomposition_rl1.tex:2, 34, 66`). Das ist Sache des Language- bzw. Consistency-Reviews.

Was ich im Einzelnen geprüft habe:
- **Perioden:** Pre ist `date` 2017-06-30 bis 2019-12-31, Post ist 2020-12-31 bis 2022-12-31 (Z. [number withheld][number withheld]). Der Halbjahresindex `h = [number withheld]·Jahr + (Monat==[number withheld])` macht Übergänge zwingend aufeinanderfolgend. Bei lag [number withheld] ist ein fehlender Zwischenstand ausgeschlossen (Z. [number withheld][number withheld]).
- **RL1-Zerlegung:**
  - Gesamt: Δlogit = Δln N − Δln te.
  - Fremdkapitalseite: Δln N · ΔX/ΔN für ibd und für die übrigen Verbindlichkeiten.
  - Eigenkapitalseite: −Δln te · ΔX/Δte für Mutter-EK, mi und perp.
  - Das ist algebraisch exakt (Z. [number withheld][number withheld]). Die Summen werden mit `stopifnot` bis [number withheld] geprüft (Z. [number withheld][number withheld]). Der größte Fehler laut Identitätsbericht ist [number withheld].
- **RL2-Zerlegung:**
  - Formel: ΔR = ΔNet/te1 − Net0·Δte/(te0·te1), Code Z. [number withheld][number withheld]. Das entspricht der Kartengleichung.
  - `dln_n` beruht jetzt auf der Nettoschuld und ist NA, wenn die Nettoschuld zu einem der beiden Zeitpunkte ≤ [number withheld] ist (Z. [number withheld][number withheld], REWORK-Punkt [number withheld]).
  - Der Median Δln Nettoschuld beträgt [number withheld] (Post) und [number withheld] (Pre) und stimmt mit dem CSV überein.
- **Inferenz:** Cluster-Bootstrap über ganze Firmen mit B = [number withheld] und festem Seed (Z. [number withheld]). Die Ziehungen werden über beide Gruppen gemeinsam verwendet (Z. [number withheld], [number withheld][number withheld]), damit bleibt die Abhängigkeit von Firmen erhalten, die in Post und Pre vorkommen. Wiederholungsgewichte bilden den gewichteten Median korrekt ab. Perzentil-CI mit [number withheld] %, keine Sterne, keine Mehrfachtest-Korrektur, und das ist ausdrücklich benannt. Medianstatistiken für Δln N, Δln te und die mi(+perp)-Anteile, Mittelwert für den Anteil mit fallender Schuld: wie in der Karte verlangt.
- **Übertragung in die Ausgaben:** Alle [number withheld] Zeilen in `t027_tests.csv` passen zu `t027_tests.tex`, mit richtigem Term, richtiger Zeile und richtiger Rundung. Zum Beispiel ist [number withheld] − [number withheld] = [number withheld], und das CSV liefert dieselben Medianwerte wie `t027_decomposition_rl1.csv` (Z. [number withheld], [number withheld]). Post-N und Pre-N sind [number withheld]/[number withheld] für mi und [number withheld]/[number withheld] für mi+perp. Die Median- und Mittelwertspalten der TEX-Tabellen entsprechen dem CSV.
- **Keine Identifikationsprobleme im Code:** Die Ereignisse werden über den gespeicherten Ratio definiert, die Zerlegung über die Bilanzposten. Die Rundungsabweichung beträgt maximal [number withheld] (RL1) und [number withheld] (RL2). Es gibt keine Kontrollen, die erst nach dem Treatment entstehen, und keine kausale Aussage.

## Abnahmekriterien
[number withheld]. **Belegt erfüllt (Teil Schätzung).** Die Komponentensummen werden je Ereignis mit `stopifnot` ≤ [number withheld] geprüft, aber nur für Ereignisse mit allen Komponenten. Diese Einschränkung ist offen berichtet: [number withheld] RL1-Stayer haben te ≤ [number withheld], und je Kreuzungsart fehlt ein mi-Wert, siehe Zeilen [number withheld][number withheld] in `t027_identity_checks.txt`. Ob die Bilanzidentitäten selbst gelten, ist nicht meine Rolle (data).
[number withheld]. **Teilweise belegt.** Seed und gemeinsame Bootstrap-Matrix machen die Ergebnisse im Code deterministisch. Dass zwei Läufe byte-identisch sind, steht nur in `t027_verification.txt`. Selbst nachgerechnet habe ich das nicht. Ob die übrigen Outputs byte-identisch bleiben, prüft das Skript per SHA-[number withheld] (Z. [number withheld][number withheld]).
[number withheld]. **Erfüllt, soweit es meine Rolle betrifft.** Jede Statistik in CSV und TEX hat eine Interpretationsspalte, die sagt, welcher Wert für eine reale und welcher für eine kosmetische Anpassung spricht. Alle Ergebnisse sind als „descriptive“ gekennzeichnet. Kosmetisch heißen mi und perp nur unter den Annahmen der Theorienotiz. Die Formulierungen im Text prüft die Consistency-Rolle.
[number withheld]. **Belegt erfüllt.** N und Firmenzahl stehen je Zelle in `t027_events.csv` und je Statistik in den Zerlegungs-CSVs. Es gibt [number withheld] RL1-Post-Kreuzungen, also mindestens [number withheld].

## Nicht geprüft
- **Reproduzierbarkeit nicht selbst geprüft.** Ich habe weder `run_all.R` ausgeführt noch zwei Läufe verglichen. Ich habe einen Lesebefehl (`head`/`grep`) abgesetzt, der nichts verändert hat.
- **Nicht meine Rolle:**
  - Datenaufbereitung und Identitätsprüfungen
  - Ob der HK-Wind-Guard auf den Daten wirkt
  - `t027_robustness.csv`, `t027_debt_growth.csv` und `t027_event_audit.csv` im Detail. Die Codepfade dafür habe ich gelesen: Median vor der Winsorisierung, schmale Ereignisse nur bei Kreuzungen, lag-[number withheld]-Logik.
  - Die Abbildung
  - `proposal/theory_note.tex`
  - Ob die Änderungen an `AI_USAGE_LOG.md`, `state/STATE.md` und `state/LIMITATIONS.md` außerhalb des Schreibbereichs zulässig sind. Die Änderungen in `presentation/` und den T009–T023-Outputs stammen vermutlich vom Lauf `run_all.R` bzw. aus einer parallelen Sitzung.
