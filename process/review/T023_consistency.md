## Rolle: consistency (claude, opus) – VERDICT: PASS


## Befunde
Ich habe keinen Konsistenzfehler gefunden, der eine Überarbeitung erfordert. Es bleiben vier kleinere Hinweise, keiner davon blockiert die Abnahme:

[number withheld]. **Instabile Placebo-Werte im Bericht nicht als instabil markiert.** Der Bericht (`tasks/T023_report.md`, Tabelle Z. [number withheld]–[number withheld]) nennt für RL1_alt bei [number withheld] die korrigierten Werte b = [number withheld] (pre) und b = [number withheld] (post). Die Zahlen sind richtig. Beide Schätzungen beruhen aber auf weniger als [number withheld] % gültigen Bootstrap-Ziehungen: Laut `t023_excess_mass.csv` Z. [number withheld] sind es [number withheld] von [number withheld], Z. [number withheld] nur [number withheld], Status `unreliable_bootstrap_below_9[number withheld]pct`. Das trifft auch auf die alten Werte zu ([number withheld] und [number withheld] gültige Ziehungen, `t023_verification.txt` Z. [number withheld] und [number withheld]). In der TEX-Tabelle stehen diese Werte korrekt mit †. In der Tabelle des Berichts fehlt das Zeichen; der Hinweis steht nur pauschal in Z. [number withheld]. Wer die Werte in den Text übernimmt, muss den Vorbehalt mitnehmen.
[number withheld]. **Ein Wert in einer falsch benannten Spalte.** In `t023_placebo_definitions.tex` Z. [number withheld] und [number withheld] steht die Difference-in-Bunching ([number withheld] bzw. [number withheld]) in der Spalte „Below“. Inhaltlich ist das ein Differenzmaß. Die Tabellennote erklärt es („Change is …“), die Spaltenüberschrift ist trotzdem missverständlich.
[number withheld]. **Fehlender Vorbehalt beim Stichtagsvergleich.** Der Bericht schreibt „Kein besonderer Dezember-Gipfel“ (Z. [number withheld]). Die Werte stimmen: [number withheld] % im Juni gegen [number withheld] % im Dezember. Es gibt aber keinen formalen Test für den Unterschied zwischen Juni und Dezember. Das steht in `t023_verification.txt` Z. [number withheld], im Bericht selbst aber nicht.
[number withheld]. **Zahl der Firmen mit abweichendem Geschäftsjahr: Karte und Daten weichen ab.** Die Karte nennt [number withheld] Firmen mit `fye_flag`. In den Daten sind es [number withheld], davon [number withheld] in der Hauptstichprobe; die CSV-Spalte `flagged_firms_in_main_sample = [number withheld]` bestätigt das. Der Worker hat die Abweichung offen gemeldet. Karte bzw. `state/LIMITATIONS.md` sollte der Co-PI angleichen.

**Abgleich Bericht ↔ Outputs (alle stimmen):**
- **Difference-in-Bunching RL1:** [number withheld] [[number withheld]; [number withheld]]. Das entspricht `placebo_definitions.csv` Z. [number withheld], nachgerechnet als ([number withheld] − [number withheld]) − ([number withheld] − [number withheld]).
- **Difference-in-Bunching RL2:** [number withheld] mit [number withheld] Post-Firmen. Nachgerechnet als ([number withheld] − [number withheld]) − ([number withheld] − [number withheld]).
- **Stichtage:** [number withheld] / [number withheld] / [number withheld] / [number withheld] % (`reporting_dates.csv` Z. [number withheld], [number withheld], [number withheld], [number withheld]).
- **Umkehr:**
  - [number withheld]/[number withheld] = [number withheld] %; Kontrollgruppe [number withheld] %.
  - [number withheld]%-KI der Differenz [[number withheld]; [number withheld]] enthält null.
  - Vorperiode [number withheld] %.
- **Zusammensetzung:** log ibd [number withheld] (p = [number withheld]), log ta [number withheld] (p = [number withheld]).
- **Excess Mass:**
  - [number withheld] (SE [number withheld]), [number withheld] ([number withheld]) und [number withheld] ([number withheld]) stimmen.
  - Nachgerechnet: b = [number withheld]/[number withheld] = [number withheld].
- **Placebo-Werte alt und neu:** Alle [number withheld] Werte im Bericht stimmen mit `t023_verification.txt` und der CSV überein.
- **Zusammenfassende Zählungen:** [number withheld] Spezifikationen, [number withheld] ungültige Schätzung, [number withheld] Fits mit weniger als [number withheld] % gültigen Ziehungen ([number withheld] mit † plus [number withheld] mit „--“), gültige Ziehungen [number withheld]–[number withheld].
- **Rundung der Alternativschwelle:** [number withheld] → [number withheld], Fenster [[number withheld]; [number withheld]).

**TEX ↔ CSV:**
- `t023_excess_mass.tex`: Alle [number withheld] Zeilen (je b und SE für pre und post) stimmen auf vier Stellen mit der CSV überein. Die † stehen genau bei `bootstrap_meets_9[number withheld]pct = FALSE`, „--“ nur beim ungültigen Fit (wide, post, [number withheld], RL1_alt). Die Note nennt N = [number withheld]/[number withheld] (Full) und [number withheld]/[number withheld] (Paired); das entspricht der CSV.
- `t023_reversal.tex`: alle [number withheld] Zeilen identisch mit der CSV.
- `t023_placebo_definitions.tex`: alle Anteile identisch mit der CSV.
- Die Notes der Tabellen beschreiben Fenster, Ausschlussbereiche, Stichproben und Inferenzregeln so, wie sie in der CSV stehen, z. B. `regulated_region` [number withheld]–[number withheld] bzw. [number withheld]–[number withheld] und RL2-Inferenz erst ab [number withheld] Firmen.

**Abbildungen ↔ CSV:**
- `t023_excess_mass_rl1.pdf`: Die Balken im Fenster ([number withheld] + [number withheld] + [number withheld] + [number withheld] = [number withheld]) entsprechen `observed_window = [number withheld]`, die Bins [number withheld]–[number withheld] mit [number withheld] + [number withheld] = [number withheld] der T005-Zählung.
- `t023_bunching_rl1_vs_alt.pdf`: Der RL1-Post-Balken bei [[number withheld]; [number withheld]) liegt bei etwa [number withheld] % (CSV [number withheld]). Die Bildunterschrift nennt N [number withheld]/[number withheld] und die Schwelle [number withheld]; das passt zur CSV.

## Abnahmekriterien
[number withheld]. **Ausgaben vorhanden, reproduzierbar:** Alle geforderten Dateien sind vorhanden. Byte-Identität kann ich als Lesender nicht selbst prüfen; die SHA-[number withheld]-Werte aus drei Läufen stehen in `t023_verification.txt`. Die Reproduzierbarkeit selbst gehört nicht zu meiner Rolle.
[number withheld]. **Bestehende Outputs unverändert:** gehört nicht zu meiner Rolle.
[number withheld]. **Interpretation ohne Überzeichnung:** belegt erfüllt, soweit es meine Rolle betrifft.
   - Jede im Bericht genannte Zahl stimmt mit den Outputs überein, Effektrichtungen und Konfidenzintervalle sind richtig wiedergegeben.
   - Signifikanz wird nirgends behauptet, wo die Outputs keine zeigen.
   - Deskriptive Tests sind als deskriptiv gekennzeichnet.
   - Das Fazit („vereinbar mit Targeting, aber keine eindeutige Unterscheidung“) passt zu den Ergebnissen.
   - Einschränkung: Hinweise [number withheld] und [number withheld] oben.
[number withheld]. **T005-Zählungen:** belegt erfüllt.
   - `t005_bunching_counts.csv` Z. [number withheld]: [number withheld]/[number withheld] pre; Z. [number withheld]: [number withheld]/[number withheld] post.
   - `t023_histogram_bins.csv` und die Abbildung zeigen dieselben Werte.

## Nicht geprüft
- **Proposal-Text:** In `proposal/` werden keine T023-Zahlen zitiert (Suche nach „t0[number withheld]“ und den Kernwerten in `06_preliminary_analysis.tex` ohne Treffer). `theory_note.tex` beschreibt die T023-Tests nur qualitativ. Die Änderungen in `proposal/` stammen laut Co-PI aus T026 und gehören nicht zu dieser Prüfung.
- **Korrektheit von Code und Daten:** Ob Code und Daten richtig sind, gehört nicht zu meiner Rolle; dafür sind die Rollen data und estimation zuständig.
- **Vollständiger Abgleich großer CSVs:** `t023_excess_mass_bins.csv` und `t023_coverage.csv` habe ich nicht Zeile für Zeile gegen die Abbildungen abgeglichen, nur stichprobenartig über die Fenstersummen.
- **Byte-Identität und Hashes:** konnte ich nicht nachrechnen, weil ich keine Befehle ausführe.
