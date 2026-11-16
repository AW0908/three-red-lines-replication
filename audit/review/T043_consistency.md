## Rolle: consistency (claude, sonnet) – VERDICT: PASS


## Befunde
Rolle Consistency: Ich habe keinen Widerspruch zwischen Outputs, TeX-Tabellen und Bericht gefunden. Es bleiben drei kleine Präzisionsmängel, die Anton oder der Co-PI beachten sollten, bevor T045 Zahlen in den Text übernimmt.

[number withheld]. **Der Anteil [number withheld] hat im Bericht keinen Geltungsbereich.**
   - Beleg: Der Bericht schreibt unter Schritt [number withheld]: „The mean shift explains about [number withheld] % ([number withheld]) of the attenuation of b_post.“
   - In `t043_meas_error.csv` gilt [number withheld] nur für `scope=all` (Zeilen [number withheld] und [number withheld]). Für `scope=published_rl1_0[number withheld]_0[number withheld]` ist der Wert [number withheld] (Zeilen [number withheld] und [number withheld]).
   - Folge: Wer [number withheld] % ohne Scope zitiert, überzeichnet den Effekt für die nahe an der Schwelle liegenden Paare.
   - Die Zahl selbst stimmt.
[number withheld]. **Der Satz zur Cash-Deckung ist stärker als die Tabelle.**
   - Beleg: Der Bericht schreibt: „Most of the minority-interest growth came with cash, so it was not purely an accounting relabeling.“
   - Das gedeckte Verhältnis gilt für Gruppe A als Brutto-Wert ([number withheld]) und für Gruppe B ([number withheld] netto, `t043_cash_backing.csv` Zeilen [number withheld] und [number withheld]).
   - Für Gruppe A fehlt das Netto-Verhältnis, weil bei zwei Firmen die Dividenden fehlen (Zeilen [number withheld] und [number withheld]).
[firm-specific excerpt withheld in public process copy]
   - Die Quote hängt außerdem an der ungeprüften RMB-Annahme für die HK-Firmen. Das steht im Bericht in der Überschrift, aber nicht im Satz.
   - Der Satz sollte auf die Gruppen A (brutto) und B eingeschränkt werden.
[number withheld]. **Eine Zeile in `t043_delta_b.tex` zeigt die bedingte Inferenz nicht an.**
   - Beleg: Die Zeile „[number withheld] degree7“ stützt sich auf [number withheld] von [number withheld] gültigen Ziehungen (`t043_delta_b.csv` Zeile [number withheld], Status `conditional_on_valid_draws`).
   - In `t043_integration.tex` markiert ein Dolch solche Intervalle, hier fehlt er.
   - Die Tabellennote verweist dafür auf die CSV-Datei. Das ist vertretbar, aber uneinheitlich.

## Abnahmekriterien
Nur soweit meine Rolle betroffen ist.
[number withheld]. **Reproduktions-Asserts:**
   - Belegt für die Konsistenz: Die Werte b_post [number withheld] und b_pre [number withheld] stehen in `t043_delta_b.csv` Zeile [number withheld].
   - Alle [number withheld] Zellen von `t043_delta_b.csv` (je Pre und Post) stimmen mit `t023_excess_mass.csv` (Sample `main_sample`) überein. Das gilt auch für die Baseline-CIs von Post: [[number withheld]; [number withheld]] in `t043_integration.csv` Zeile [number withheld] gegen `t023_excess_mass.csv` Zeile [number withheld].
   - D = [number withheld] habe ich nicht geprüft; die Datei `t029_compliance.csv` war nicht Teil meiner Prüfung.
   - Byte-Identität und Laufbefehl gehören zur Rolle data oder estimation: nicht meine Rolle.
[number withheld]. **Alle Varianten berichtet, Firmenzahlen neben jeder Schätzung:** belegt.
   - Zeilenzahlen: Δb [number withheld], Integration [number withheld], Messfehler [number withheld], Heterogenität [number withheld], Cash [number withheld], Trend [number withheld]. Das deckt sich mit dem Bericht.
   - Jede Tabelle führt N und Firmen. Die TeX-Zellen decken sich mit den CSV-Werten für Δb, Integration, Messfehler, Heterogenität, Cash und Trend (stichprobenartig an allen Zeilen verglichen).
[number withheld]. **Konvergenz, Fehlerverteilung, Seitenverweise:** belegt.
   - Die Integration konvergiert bei Post und Pre in [number withheld] und [number withheld] Iterationen; das Massenresiduum liegt bei etwa [number withheld] (`t043_integration.csv` Zeilen [number withheld] und [number withheld]).
   - Die Fehlerverteilung hat N = [number withheld] aus [number withheld] Firmen, Mittel [number withheld] und SD [number withheld]. Die Nah-Variante hat N = [number withheld] aus [number withheld] Firmen, Mittel [number withheld] und SD [number withheld].
   - Jeder Cash-Wert in `t043_cash_backing.csv` hat `pdf_page`, oder die Zelle ist als `[missing]` markiert.
[number withheld]. **Keine neuen Daten, keine Handwerte verändert:** nicht meine Rolle.

**Bericht gegen Outputs:**
- Alle berichteten Zahlen in den Schritten [number withheld] bis [number withheld] und [number withheld] stimmen mit den CSV- und TeX-Dateien überein.
  - Beispiele: Δb [number withheld] / SE [number withheld] / [[number withheld]; [number withheld]]; b_net [number withheld] und [number withheld]; Δb_net [number withheld] [[number withheld]; [number withheld]] mit Anteil > [number withheld] von [number withheld]; Messfehler b_post [number withheld] [[number withheld]; [number withheld]]; D_trend [number withheld] und [number withheld].
  - Alle zehn Placebo-CIs enthalten null.
  - Die Heterogenitäts-Aussagen zu den CIs über null stimmen.
  - [number withheld] Firmen ohne Eigentümerklasse und [number withheld] ohne Klasse der anderen Linien sind in der CSV gezählt ([number withheld][number withheld][number withheld] = [number withheld] und [number withheld][number withheld][number withheld] = [number withheld]).
  - Die Startanpassungen [number withheld]/[number withheld] und [number withheld]/[number withheld] stimmen.
- Die Rework-[number withheld]-Änderungen in `t043_integration.tex` sind vorhanden und stimmen mit den Zahlen überein.
  - Bei den T023-Baseline-Zeilen steht „--“ in B_net und [[number withheld]; [number withheld]).
  - Das Residuum der Sekundärvariante ist gleich minus der Spalte [[number withheld]; [number withheld]): [number withheld] gegen [number withheld] bei Post und [number withheld] gegen [number withheld] bei Pre.
- Die Aussagen sind vorsichtig formuliert:
  - Der Bericht nennt den Befund zur Trend-Gegenfaktische ausdrücklich negativ.
  - Er sagt, dass kein Placebo schätzbar ist.
  - Er nennt die Intervalle punktweise, ohne Mehrfachtest-Korrektur.
  - Er nennt die Messfehler-Perzentile Simulationsintervalle.

## Nicht geprüft
- Code-Korrektheit (`15_referee2.R`), Bootstrap-Implementierung, Datenbereinigung und Byte-Identität zweier Läufe. Das gehört zu den Rollen estimation und data, außerdem ist Bash gesperrt.
- Prüfsummen und die Guard-Datei (`t043_input_output_guards.csv`, [number withheld] geschützte Ausgaben) sowie die Frage, woher die [number withheld] zusätzlichen Dateien stammen.
- `t043_reproducibility.csv`, `t043_run*.log` und die PDF-Abbildung `t043_meas_error.pdf`. Die Abbildung habe ich nicht angesehen.
- Rohdatenwerte in `nci_cashflow.csv` gegen die PDF-Seiten, die Währung der HK-MI und der D-Wert [number withheld] gegen `t029_compliance.csv`.
- Ein Text in `proposal/` existiert für T043 noch nicht (folgt in T045). Querverweise mit `\ref` und `\cite` waren daher nicht prüfbar.
