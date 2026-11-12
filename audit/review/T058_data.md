## Rolle: data (claude, sonnet) – VERDICT: PASS

Ich lese den Code und die Karte als Data-Reviewer und habe die Quellen der Variablen gegen `01_clean.R` und das Datenwörterbuch geprüft. Ich führe nichts aus, denn Bash ist in dieser Sitzung gesperrt. Die erzeugten Tabellen habe ich nur stichprobenartig angesehen.

VERDICT: PASS

## Befunde
Keine Befunde, die die Datenaufbereitung ungültig machen. Fünf Hinweise (H), schwerster zuerst:

1. **H1 – Hohe Quote imputierter Nullwerte bei `adv` in Hongkong.** Die Quote steht in der TeX-Notiz (`20_referee4.R:474-476`): Hongkong 81/318 im Vorzeitraum und 29/230 im Nachzeitraum, A-Aktien 6/480 und 2/400. Die Regel stammt aus `01_clean.R:543-546` (Entscheidung des PI vom 2016-10-16, Flag `adv_missing`). Der Code behandelt sie korrekt:
   - Die Baseline behält die Nullwerte (`20_referee4.R:413`).
   - Die Sensitivität schließt sie aus (`:461`, `:471-472`).
   - Die Hongkong-Mediane verschieben sich stark (z. B. 0,081 → 0,171 am 2016-12-31).

   Δb für Hongkong hängt davon ab (6,74 → 8,61). Der Bericht benennt das. In `state/LIMITATIONS.md` sollte der Punkt stehen. Das konnte ich nicht prüfen.
2. **H2 – Teilsummen bei der Verschuldung.** `debt` ist eine Teilsumme mit `na.rm=TRUE` (`:229-230`); NA gibt es nur, wenn alle vier Komponenten fehlen. Fehlt eine Komponente zum Ankerdatum, aber nicht heute, wird `delta` künstlich groß. Die Zahl dieser Zeilen steht als `partial_debt_rows` in der CSV (`:261`). Der Code prüft, dass `debt` mit `ibd_ext` übereinstimmt (`:231`). Das ist dokumentiert und sollte in `LIMITATIONS.md` stehen.
3. **H3 – Normierung bei negativem Wachstum.** Die normierte Größe `D_pp_per_growth_pp_assets` wird bei einem negativen Median-Wachstum negativ und ist bei Median 0 undefiniert (`:248`). Die Note nennt beides (`:496`). Bei der Interpretation der Differenztests ist das zu beachten.
4. **H4 – Austritt und Dauerkontrolle.** Die Gruppen `exiting`, `continuing` und `earlier_exit` hängen an der letzten Berichtszeile. Fehlendes RL1 in der letzten Zeile wird über `last_rl1_date` abgefangen (`:278-283`). `earlier_exit` fließt nicht in den Vergleich ein (`:290`). Die Definition ist in der Note dokumentiert.
5. **H5 – Seazen-Behandlung.** Beide Seazen-Einheiten sind aus allen Kontrollgruppen ausgeschlossen (`:189`), und das `stopifnot` gilt für alle Varianten. In `t058_sample_audit.csv` werden die Gruppen je Beobachtung geführt. Die Pilotzellen in `t058_sample_audit.csv` sind plausibel; Kontrollfirmen 124/120 und Kontroll-N 725/570 habe ich nicht gegen die CSV nachgezählt.

## Abnahmekriterien
1. **Reproduktionsasserts:** im Code belegt (`:85-90`: b_post 3,14, b_pre −0,88, Δb 4,02, D 0,1146, 602 Beobachtungen, 129 Firmen, Abgleich mit `t043_delta_b.csv`). Dass die Läufe byte-identisch sind, konnte ich nicht selbst prüfen. Der Code enthält Hash-Wächter für Eingaben und alte Outputs (`:21-24`) und gibt sie am Ende aus. Das stützt sich auf die Angaben des Skripts.
2. **Varianten mit N, Firmen und Fensterfirmen, kleine Zellen markiert:** belegt. `record()` schreibt N, Firmen, Fensterbeobachtungen, Fensterfirmen und `small_cell` (`:131-148`). Das Gitter nutzt jetzt das tatsächliche Ausschlussfenster (`:369-373`), die Attrition-Bins zählen die jeweilige Bin (`:295-297`).
3. **Pilotliste genau wie vorgegeben, keine anderen Handdaten:** belegt (`:175-181`, mit `stopifnot` auf 11 Firmen und Zhongliang nicht im Panel). Seazen wird nur über die in der Datei genannte Sensitivitäts-ID ersetzt.
4. **Rework 1 bis 6, soweit sie Daten betreffen:** erfüllt.
   - Punkt 1: Der Ausschluss deckt die ausgewertete Region ab (`:345`, `:351-355`).
   - Punkt 2: Seazen wird aus den Kontrollen genommen (`:189`).
   - Punkt 5: Bin-Zählungen werden verwendet.
   - Punkt 6: HK-Quellenlabels stimmen mit `01_clean.R:410,424` (`预收款项 + 合同负债`) überein, und die Nullwert-Sensitivität ist vorhanden.
   - Punkt 3 und 4 betreffen die Schätzung und die Darstellung, nicht meine Rolle.

## Nicht geprüft
- Ich konnte nichts ausführen und habe keine Dateien per Hash verglichen. Byte-Identität und die Zahlen in Bericht und CSVs habe ich nicht nachgerechnet.
- Die Formeln für RL1–RL3 und `rl2_adj` stammen aus `01_clean.R`, das ich nur ausschnittsweise gelesen habe. `20_referee4.R` prüft nur RL1 gegen `N/(N+te)` (`:90`).
- Die Panel-Datei (`panel_firm_halfyear.csv`) und `state/pilot_developers.csv` habe ich nicht geöffnet. Die Fallzahlen 602/129 und 136 Firmen stützen sich auf die `stopifnot`-Asserts im Skript.
- Die Quellen für den Pilotbeginn, den Rollout und den Standardwechsel (Huang 2023, Su/Wang/Yao 2026, Chu/Deng/Tsang 2025) habe ich nicht gesehen. Diese Passagen muss der PI bestätigen, wie die Karte vermerkt.
- `AI_USAGE_LOG.md`, `README.md` und `run_all.*` habe ich nicht geprüft. Ob der Protokolleintrag zu T058 vorliegt, ist offen.
- Die Änderungszeit-Warnung des Skripts nennt viele Dateien in `proposal/`. Diese Änderungen liegen außerhalb meiner Rolle und müssen vom Co-PI als Folge der parallelen Karte T059 bewertet werden.
