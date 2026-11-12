## Rolle: consistency (claude, sonnet) – VERDICT: PASS


## Befunde
Rolle Consistency: Ich habe keinen Widerspruch zwischen Outputs, TeX-Tabellen und Bericht gefunden. Es bleiben drei kleine Präzisionsmängel, die Anton oder der Co-PI beachten sollten, bevor T045 Zahlen in den Text übernimmt.

1. **Der Anteil 0,8648 hat im Bericht keinen Geltungsbereich.**
   - Beleg: Der Bericht schreibt unter Schritt 3: „The mean shift explains about 86 % (0.8648) of the attenuation of b_post.“
   - In `t043_meas_error.csv` gilt 0,8648 nur für `scope=all` (Zeilen 2 und 5). Für `scope=published_rl1_060_080` ist der Wert 0,4001 (Zeilen 8 und 11).
   - Folge: Wer 86 % ohne Scope zitiert, überzeichnet den Effekt für die nahe an der Schwelle liegenden Paare.
   - Die Zahl selbst stimmt.
2. **Der Satz zur Cash-Deckung ist stärker als die Tabelle.**
   - Beleg: Der Bericht schreibt: „Most of the minority-interest growth came with cash, so it was not purely an accounting relabeling.“
   - Das gedeckte Verhältnis gilt für Gruppe A als Brutto-Wert (1,05) und für Gruppe B (0,715 netto, `t043_cash_backing.csv` Zeilen 12 und 13).
   - Für Gruppe A fehlt das Netto-Verhältnis, weil bei zwei Firmen die Dividenden fehlen (Zeilen 2 und 3).
[firm-specific excerpt withheld in public audit]
   - Die Quote hängt außerdem an der ungeprüften RMB-Annahme für die HK-Firmen. Das steht im Bericht in der Überschrift, aber nicht im Satz.
   - Der Satz sollte auf die Gruppen A (brutto) und B eingeschränkt werden.
3. **Eine Zeile in `t043_delta_b.tex` zeigt die bedingte Inferenz nicht an.**
   - Beleg: Die Zeile „0.6000 degree7“ stützt sich auf 998 von 999 gültigen Ziehungen (`t043_delta_b.csv` Zeile 9, Status `conditional_on_valid_draws`).
   - In `t043_integration.tex` markiert ein Dolch solche Intervalle, hier fehlt er.
   - Die Tabellennote verweist dafür auf die CSV-Datei. Das ist vertretbar, aber uneinheitlich.

## Abnahmekriterien
Nur soweit meine Rolle betroffen ist.
1. **Reproduktions-Asserts:**
   - Belegt für die Konsistenz: Die Werte b_post 3,1429 und b_pre −0,8772 stehen in `t043_delta_b.csv` Zeile 2.
   - Alle 15 Zellen von `t043_delta_b.csv` (je Pre und Post) stimmen mit `t023_excess_mass.csv` (Sample `main_sample`) überein. Das gilt auch für die Baseline-CIs von Post: [1,0122; 5,8411] in `t043_integration.csv` Zeile 7 gegen `t023_excess_mass.csv` Zeile 17.
   - D = 0,1146 habe ich nicht geprüft; die Datei `t029_compliance.csv` war nicht Teil meiner Prüfung.
   - Byte-Identität und Laufbefehl gehören zur Rolle data oder estimation: nicht meine Rolle.
2. **Alle Varianten berichtet, Firmenzahlen neben jeder Schätzung:** belegt.
   - Zeilenzahlen: Δb 15, Integration 11, Messfehler 12, Heterogenität 12, Cash 12, Trend 20. Das deckt sich mit dem Bericht.
   - Jede Tabelle führt N und Firmen. Die TeX-Zellen decken sich mit den CSV-Werten für Δb, Integration, Messfehler, Heterogenität, Cash und Trend (stichprobenartig an allen Zeilen verglichen).
3. **Konvergenz, Fehlerverteilung, Seitenverweise:** belegt.
   - Die Integration konvergiert bei Post und Pre in 19 und 17 Iterationen; das Massenresiduum liegt bei etwa 5e-7 (`t043_integration.csv` Zeilen 3 und 8).
   - Die Fehlerverteilung hat N = 64 aus 30 Firmen, Mittel 0,0099 und SD 0,0264. Die Nah-Variante hat N = 52 aus 26 Firmen, Mittel 0,0044 und SD 0,0077.
   - Jeder Cash-Wert in `t043_cash_backing.csv` hat `pdf_page`, oder die Zelle ist als `[missing]` markiert.
4. **Keine neuen Daten, keine Handwerte verändert:** nicht meine Rolle.

**Bericht gegen Outputs:**
- Alle berichteten Zahlen in den Schritten 1 bis 5 und 7 stimmen mit den CSV- und TeX-Dateien überein.
  - Beispiele: Δb 4,02 / SE 1,27 / [1,67; 6,80]; b_net 3,76 und 0,20; Δb_net 3,56 [0,75; 6,49] mit Anteil > 0 von 0,996; Messfehler b_post 2,01 [1,27; 2,82]; D_trend −0,098 und −0,056.
  - Alle zehn Placebo-CIs enthalten null.
  - Die Heterogenitäts-Aussagen zu den CIs über null stimmen.
  - 8 Firmen ohne Eigentümerklasse und 14 ohne Klasse der anderen Linien sind in der CSV gezählt (82+46+8 = 136 und 70+52+14 = 136).
  - Die Startanpassungen 59,75/−27,69 und 48,90/−15,90 stimmen.
- Die Rework-4-Änderungen in `t043_integration.tex` sind vorhanden und stimmen mit den Zahlen überein.
  - Bei den T023-Baseline-Zeilen steht „--“ in B_net und [0,70; 0,74).
  - Das Residuum der Sekundärvariante ist gleich minus der Spalte [0,70; 0,74): −16,3005 gegen 16,3005 bei Post und −22,0414 gegen 22,0414 bei Pre.
- Die Aussagen sind vorsichtig formuliert:
  - Der Bericht nennt den Befund zur Trend-Gegenfaktische ausdrücklich negativ.
  - Er sagt, dass kein Placebo schätzbar ist.
  - Er nennt die Intervalle punktweise, ohne Mehrfachtest-Korrektur.
  - Er nennt die Messfehler-Perzentile Simulationsintervalle.

## Nicht geprüft
- Code-Korrektheit (`15_referee2.R`), Bootstrap-Implementierung, Datenbereinigung und Byte-Identität zweier Läufe. Das gehört zu den Rollen estimation und data, außerdem ist Bash gesperrt.
- Prüfsummen und die Guard-Datei (`t043_input_output_guards.csv`, 203 geschützte Ausgaben) sowie die Frage, woher die 3 zusätzlichen Dateien stammen.
- `t043_reproducibility.csv`, `t043_run*.log` und die PDF-Abbildung `t043_meas_error.pdf`. Die Abbildung habe ich nicht angesehen.
- Rohdatenwerte in `nci_cashflow.csv` gegen die PDF-Seiten, die Währung der HK-MI und der D-Wert 0,1146 gegen `t029_compliance.csv`.
- Ein Text in `proposal/` existiert für T043 noch nicht (folgt in T045). Querverweise mit `\ref` und `\cite` waren daher nicht prüfbar.
