## Rolle: estimation (claude, opus) – VERDICT: PASS


## Befunde
In meiner Rolle (Estimation) habe ich keine inhaltlichen Fehler gefunden. Hinweise, die das Urteil nicht ändern:

1. **CI von Kontrast 4 hängt an gültigen Ziehungen.** Das Perzentil-Intervall für `equity_mi_perp_share` wird nur aus 634 von 999 Ziehungen berechnet (`08_decomposition.R:277-278`). Fehlt die einzige Pre-Firma in einer Ziehung, fällt die Ziehung weg. Das Intervall gilt also nur unter der Bedingung, dass diese Firma gezogen wird. Code und Tabelle kennzeichnen das richtig: `inference_status=conditional_unreliable`, Zeile 5 in `t027_tests.csv` und Fußnote in `t027_tests.tex`. Interpretieren lässt sich der Kontrast trotzdem nicht. Das muss so im Text stehen bleiben.
2. **Prozentpunkt-Umrechnung ist eine Näherung.** Sie wird an der Stelle RL1 = 0,70 ausgewertet und nicht je Ereignis (`08_decomposition.R:324`). −0,1620 × 0,21 × 100 = −3,40 pp stimmt rechnerisch. Die Karte verlangt genau diese Form, und der Wert ist als Näherung beschriftet.
3. **Satzzeichen in der RL1-Überschrift (nicht meine Rolle, nur notiert).** Vor „Change in logit(RL1)“ fehlt ein Punkt oder Doppelpunkt (`t027_decomposition_rl1.tex:2, 34, 66`). Das ist Sache des Language- bzw. Consistency-Reviews.

Was ich im Einzelnen geprüft habe:
- **Perioden:** Pre ist `date` 2017-06-30 bis 2019-12-31, Post ist 2020-12-31 bis 2022-12-31 (Z. 75-76). Der Halbjahresindex `h = 2·Jahr + (Monat==12)` macht Übergänge zwingend aufeinanderfolgend. Bei lag 2 ist ein fehlender Zwischenstand ausgeschlossen (Z. 88-90).
- **RL1-Zerlegung:**
  - Gesamt: Δlogit = Δln N − Δln te.
  - Fremdkapitalseite: Δln N · ΔX/ΔN für ibd und für die übrigen Verbindlichkeiten.
  - Eigenkapitalseite: −Δln te · ΔX/Δte für Mutter-EK, mi und perp.
  - Das ist algebraisch exakt (Z. 139-165). Die Summen werden mit `stopifnot` bis 1e-10 geprüft (Z. 172-179). Der größte Fehler laut Identitätsbericht ist 2,2e-16.
- **RL2-Zerlegung:**
  - Formel: ΔR = ΔNet/te1 − Net0·Δte/(te0·te1), Code Z. 153-155. Das entspricht der Kartengleichung.
  - `dln_n` beruht jetzt auf der Nettoschuld und ist NA, wenn die Nettoschuld zu einem der beiden Zeitpunkte ≤ 0 ist (Z. 149-152, REWORK-Punkt 2).
  - Der Median Δln Nettoschuld beträgt −0,1478 (Post) und −0,2197 (Pre) und stimmt mit dem CSV überein.
- **Inferenz:** Cluster-Bootstrap über ganze Firmen mit B = 999 und festem Seed (Z. 3). Die Ziehungen werden über beide Gruppen gemeinsam verwendet (Z. 257, 275-276), damit bleibt die Abhängigkeit von Firmen erhalten, die in Post und Pre vorkommen. Wiederholungsgewichte bilden den gewichteten Median korrekt ab. Perzentil-CI mit 95 %, keine Sterne, keine Mehrfachtest-Korrektur, und das ist ausdrücklich benannt. Medianstatistiken für Δln N, Δln te und die mi(+perp)-Anteile, Mittelwert für den Anteil mit fallender Schuld: wie in der Karte verlangt.
- **Übertragung in die Ausgaben:** Alle 7 Zeilen in `t027_tests.csv` passen zu `t027_tests.tex`, mit richtigem Term, richtiger Zeile und richtiger Rundung. Zum Beispiel ist 0,5450 − 0,1763 = 0,3687, und das CSV liefert dieselben Medianwerte wie `t027_decomposition_rl1.csv` (Z. 16, 50). Post-N und Pre-N sind 32/21 für mi und 10/2 für mi+perp. Die Median- und Mittelwertspalten der TEX-Tabellen entsprechen dem CSV.
- **Keine Identifikationsprobleme im Code:** Die Ereignisse werden über den gespeicherten Ratio definiert, die Zerlegung über die Bilanzposten. Die Rundungsabweichung beträgt maximal 1,7e-14 (RL1) und 2,1e-14 (RL2). Es gibt keine Kontrollen, die erst nach dem Treatment entstehen, und keine kausale Aussage.

## Abnahmekriterien
1. **Belegt erfüllt (Teil Schätzung).** Die Komponentensummen werden je Ereignis mit `stopifnot` ≤ 1e-10 geprüft, aber nur für Ereignisse mit allen Komponenten. Diese Einschränkung ist offen berichtet: 15 RL1-Stayer haben te ≤ 0, und je Kreuzungsart fehlt ein mi-Wert, siehe Zeilen 13-14 in `t027_identity_checks.txt`. Ob die Bilanzidentitäten selbst gelten, ist nicht meine Rolle (data).
2. **Teilweise belegt.** Seed und gemeinsame Bootstrap-Matrix machen die Ergebnisse im Code deterministisch. Dass zwei Läufe byte-identisch sind, steht nur in `t027_verification.txt`. Selbst nachgerechnet habe ich das nicht. Ob die übrigen Outputs byte-identisch bleiben, prüft das Skript per SHA-256 (Z. 457-458).
3. **Erfüllt, soweit es meine Rolle betrifft.** Jede Statistik in CSV und TEX hat eine Interpretationsspalte, die sagt, welcher Wert für eine reale und welcher für eine kosmetische Anpassung spricht. Alle Ergebnisse sind als „descriptive“ gekennzeichnet. Kosmetisch heißen mi und perp nur unter den Annahmen der Theorienotiz. Die Formulierungen im Text prüft die Consistency-Rolle.
4. **Belegt erfüllt.** N und Firmenzahl stehen je Zelle in `t027_events.csv` und je Statistik in den Zerlegungs-CSVs. Es gibt 33 RL1-Post-Kreuzungen, also mindestens 20.

## Nicht geprüft
- **Reproduzierbarkeit nicht selbst geprüft.** Ich habe weder `run_all.R` ausgeführt noch zwei Läufe verglichen. Ich habe einen Lesebefehl (`head`/`grep`) abgesetzt, der nichts verändert hat.
- **Nicht meine Rolle:**
  - Datenaufbereitung und Identitätsprüfungen
  - Ob der HK-Wind-Guard auf den Daten wirkt
  - `t027_robustness.csv`, `t027_debt_growth.csv` und `t027_event_audit.csv` im Detail. Die Codepfade dafür habe ich gelesen: Median vor der Winsorisierung, schmale Ereignisse nur bei Kreuzungen, lag-2-Logik.
  - Die Abbildung
  - `proposal/theory_note.tex`
  - Ob die Änderungen an `AI_USAGE_LOG.md`, `state/STATE.md` und `state/LIMITATIONS.md` außerhalb des Schreibbereichs zulässig sind. Die Änderungen in `presentation/` und den T009–T023-Outputs stammen vermutlich vom Lauf `run_all.R` bzw. aus einer parallelen Sitzung.
