## Rolle: consistency (claude, opus) – VERDICT: PASS


## Befunde
Ich habe keinen Konsistenzfehler gefunden, der eine Überarbeitung erfordert. Es bleiben vier kleinere Hinweise, keiner davon blockiert die Abnahme:

1. **Instabile Placebo-Werte im Bericht nicht als instabil markiert.** Der Bericht (`tasks/T023_report.md`, Tabelle Z. 69–78) nennt für RL1_alt bei 0,80 die korrigierten Werte b = 1,1512 (pre) und b = 4,7594 (post). Die Zahlen sind richtig. Beide Schätzungen beruhen aber auf weniger als 90 % gültigen Bootstrap-Ziehungen: Laut `t023_excess_mass.csv` Z. 72 sind es 847 von 999, Z. 87 nur 549, Status `unreliable_bootstrap_below_90pct`. Das trifft auch auf die alten Werte zu (888 und 578 gültige Ziehungen, `t023_verification.txt` Z. 40 und 50). In der TEX-Tabelle stehen diese Werte korrekt mit †. In der Tabelle des Berichts fehlt das Zeichen; der Hinweis steht nur pauschal in Z. 82. Wer die Werte in den Text übernimmt, muss den Vorbehalt mitnehmen.
2. **Ein Wert in einer falsch benannten Spalte.** In `t023_placebo_definitions.tex` Z. 10 und 15 steht die Difference-in-Bunching (0,0648 bzw. −0,0051) in der Spalte „Below“. Inhaltlich ist das ein Differenzmaß. Die Tabellennote erklärt es („Change is …“), die Spaltenüberschrift ist trotzdem missverständlich.
3. **Fehlender Vorbehalt beim Stichtagsvergleich.** Der Bericht schreibt „Kein besonderer Dezember-Gipfel“ (Z. 59). Die Werte stimmen: 13,39 % im Juni gegen 11,70 % im Dezember. Es gibt aber keinen formalen Test für den Unterschied zwischen Juni und Dezember. Das steht in `t023_verification.txt` Z. 96, im Bericht selbst aber nicht.
4. **Zahl der Firmen mit abweichendem Geschäftsjahr: Karte und Daten weichen ab.** Die Karte nennt 11 Firmen mit `fye_flag`. In den Daten sind es 10, davon 4 in der Hauptstichprobe; die CSV-Spalte `flagged_firms_in_main_sample = 4` bestätigt das. Der Worker hat die Abweichung offen gemeldet. Karte bzw. `state/LIMITATIONS.md` sollte der Co-PI angleichen.

**Abgleich Bericht ↔ Outputs (alle stimmen):**
- **Difference-in-Bunching RL1:** 0,0648 [0,0174; 0,1153]. Das entspricht `placebo_definitions.csv` Z. 7, nachgerechnet als (0,1302 − 0,0464) − (0,0668 − 0,0478).
- **Difference-in-Bunching RL2:** −0,0051 mit 26 Post-Firmen. Nachgerechnet als (0,0505 − 0,0455) − (0,0404 − 0,0303).
- **Stichtage:** 13,39 / 11,70 / 13,60 / 11,89 % (`reporting_dates.csv` Z. 4, 5, 28, 29).
- **Umkehr:**
  - 14/61 = 22,95 %; Kontrollgruppe 18,00 %.
  - 95%-KI der Differenz [−0,107; 0,198] enthält null.
  - Vorperiode 55,56 %.
- **Zusammensetzung:** log ibd 0,0023 (p = 0,914), log ta 0,0408 (p = 0,0043).
- **Excess Mass:**
  - 3,1429 (SE 1,2667), 3,6607 (1,3665) und 0,0039 (0,6513) stimmen.
  - Nachgerechnet: b = 51,92/16,52 = 3,143.
- **Placebo-Werte alt und neu:** Alle 8 Werte im Bericht stimmen mit `t023_verification.txt` und der CSV überein.
- **Zusammenfassende Zählungen:** 90 Spezifikationen, 1 ungültige Schätzung, 8 Fits mit weniger als 90 % gültigen Ziehungen (7 mit † plus 1 mit „--“), gültige Ziehungen 350–999.
- **Rundung der Alternativschwelle:** 0,53350029 → 0,53, Fenster [0,49; 0,53).

**TEX ↔ CSV:**
- `t023_excess_mass.tex`: Alle 45 Zeilen (je b und SE für pre und post) stimmen auf vier Stellen mit der CSV überein. Die † stehen genau bei `bootstrap_meets_90pct = FALSE`, „--“ nur beim ungültigen Fit (wide, post, 0,80, RL1_alt). Die Note nennt N = 797/630 (Full) und 711/599 (Paired); das entspricht der CSV.
- `t023_reversal.tex`: alle 14 Zeilen identisch mit der CSV.
- `t023_placebo_definitions.tex`: alle Anteile identisch mit der CSV.
- Die Notes der Tabellen beschreiben Fenster, Ausschlussbereiche, Stichproben und Inferenzregeln so, wie sie in der CSV stehen, z. B. `regulated_region` 0,66–0,72 bzw. 0,49–0,55 und RL2-Inferenz erst ab 30 Firmen.

**Abbildungen ↔ CSV:**
- `t023_excess_mass_rl1.pdf`: Die Balken im Fenster (17 + 23 + 38 + 40 = 118) entsprechen `observed_window = 118`, die Bins 0,68–0,70 mit 38 + 40 = 78 der T005-Zählung.
- `t023_bunching_rl1_vs_alt.pdf`: Der RL1-Post-Balken bei [0,68; 0,70) liegt bei etwa 13 % (CSV 0,1302). Die Bildunterschrift nennt N 711/599 und die Schwelle 0,5335; das passt zur CSV.

## Abnahmekriterien
1. **Ausgaben vorhanden, reproduzierbar:** Alle geforderten Dateien sind vorhanden. Byte-Identität kann ich als Lesender nicht selbst prüfen; die SHA-256-Werte aus drei Läufen stehen in `t023_verification.txt`. Die Reproduzierbarkeit selbst gehört nicht zu meiner Rolle.
2. **Bestehende Outputs unverändert:** gehört nicht zu meiner Rolle.
3. **Interpretation ohne Überzeichnung:** belegt erfüllt, soweit es meine Rolle betrifft.
   - Jede im Bericht genannte Zahl stimmt mit den Outputs überein, Effektrichtungen und Konfidenzintervalle sind richtig wiedergegeben.
   - Signifikanz wird nirgends behauptet, wo die Outputs keine zeigen.
   - Deskriptive Tests sind als deskriptiv gekennzeichnet.
   - Das Fazit („vereinbar mit Targeting, aber keine eindeutige Unterscheidung“) passt zu den Ergebnissen.
   - Einschränkung: Hinweise 1 und 3 oben.
4. **T005-Zählungen:** belegt erfüllt.
   - `t005_bunching_counts.csv` Z. 21: 36/797 pre; Z. 66: 78/630 post.
   - `t023_histogram_bins.csv` und die Abbildung zeigen dieselben Werte.

## Nicht geprüft
- **Proposal-Text:** In `proposal/` werden keine T023-Zahlen zitiert (Suche nach „t023“ und den Kernwerten in `06_preliminary_analysis.tex` ohne Treffer). `theory_note.tex` beschreibt die T023-Tests nur qualitativ. Die Änderungen in `proposal/` stammen laut Co-PI aus T026 und gehören nicht zu dieser Prüfung.
- **Korrektheit von Code und Daten:** Ob Code und Daten richtig sind, gehört nicht zu meiner Rolle; dafür sind die Rollen data und estimation zuständig.
- **Vollständiger Abgleich großer CSVs:** `t023_excess_mass_bins.csv` und `t023_coverage.csv` habe ich nicht Zeile für Zeile gegen die Abbildungen abgeglichen, nur stichprobenartig über die Fenstersummen.
- **Byte-Identität und Hashes:** konnte ich nicht nachrechnen, weil ich keine Befehle ausführe.
