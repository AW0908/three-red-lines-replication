## Rolle: data (claude, sonnet) – VERDICT: PASS

Ich lese den Code und die Karte als Data-Reviewer und habe die Quellen der Variablen gegen `01_clean.R` und das Datenwörterbuch geprüft. Ich führe nichts aus, denn Bash ist in dieser Sitzung gesperrt. Die erzeugten Tabellen habe ich nur stichprobenartig angesehen.

VERDICT: PASS

## Befunde
Keine Befunde, die die Datenaufbereitung ungültig machen. Fünf Hinweise (H), schwerster zuerst:

[number withheld]. **H1 – Hohe Quote imputierter Nullwerte bei `adv` in Hongkong.** Die Quote steht in der TeX-Notiz (`20_referee4.R:474-476`): Hongkong [number withheld]/[number withheld] im Vorzeitraum und [number withheld]/[number withheld] im Nachzeitraum, A-Aktien [number withheld]/[number withheld] und [number withheld]/[number withheld]. Die Regel stammt aus `01_clean.R:543-546` (Entscheidung des PI vom 2016-10-16, Flag `adv_missing`). Der Code behandelt sie korrekt:
   - Die Baseline behält die Nullwerte (`20_referee4.R:413`).
   - Die Sensitivität schließt sie aus (`:[number withheld]`, `:[number withheld][number withheld]`).
   - Die Hongkong-Mediane verschieben sich stark (z. B. [number withheld] → [number withheld] am 2016-12-31).

   Δb für Hongkong hängt davon ab ([number withheld] → [number withheld]). Der Bericht benennt das. In `state/LIMITATIONS.md` sollte der Punkt stehen. Das konnte ich nicht prüfen.
[number withheld]. **H2 – Teilsummen bei der Verschuldung.** `debt` ist eine Teilsumme mit `na.rm=TRUE` (`:[number withheld][number withheld]`); NA gibt es nur, wenn alle vier Komponenten fehlen. Fehlt eine Komponente zum Ankerdatum, aber nicht heute, wird `delta` künstlich groß. Die Zahl dieser Zeilen steht als `partial_debt_rows` in der CSV (`:[number withheld]`). Der Code prüft, dass `debt` mit `ibd_ext` übereinstimmt (`:[number withheld]`). Das ist dokumentiert und sollte in `LIMITATIONS.md` stehen.
[number withheld]. **H3 – Normierung bei negativem Wachstum.** Die normierte Größe `D_pp_per_growth_pp_assets` wird bei einem negativen Median-Wachstum negativ und ist bei Median [number withheld] undefiniert (`:[number withheld]`). Die Note nennt beides (`:[number withheld]`). Bei der Interpretation der Differenztests ist das zu beachten.
[number withheld]. **H4 – Austritt und Dauerkontrolle.** Die Gruppen `exiting`, `continuing` und `earlier_exit` hängen an der letzten Berichtszeile. Fehlendes RL1 in der letzten Zeile wird über `last_rl1_date` abgefangen (`:[number withheld][number withheld]`). `earlier_exit` fließt nicht in den Vergleich ein (`:[number withheld]`). Die Definition ist in der Note dokumentiert.
[number withheld]. **H5 – Seazen-Behandlung.** Beide Seazen-Einheiten sind aus allen Kontrollgruppen ausgeschlossen (`:[number withheld]`), und das `stopifnot` gilt für alle Varianten. In `t058_sample_audit.csv` werden die Gruppen je Beobachtung geführt. Die Pilotzellen in `t058_sample_audit.csv` sind plausibel; Kontrollfirmen [number withheld]/[number withheld] und Kontroll-N [number withheld]/[number withheld] habe ich nicht gegen die CSV nachgezählt.

## Abnahmekriterien
[number withheld]. **Reproduktionsasserts:** im Code belegt (`:[number withheld][number withheld]`: b_post [number withheld], b_pre [number withheld], Δb [number withheld], D [number withheld], [number withheld] Beobachtungen, [number withheld] Firmen, Abgleich mit `t043_delta_b.csv`). Dass die Läufe byte-identisch sind, konnte ich nicht selbst prüfen. Der Code enthält Hash-Wächter für Eingaben und alte Outputs (`:[number withheld][number withheld]`) und gibt sie am Ende aus. Das stützt sich auf die Angaben des Skripts.
[number withheld]. **Varianten mit N, Firmen und Fensterfirmen, kleine Zellen markiert:** belegt. `record()` schreibt N, Firmen, Fensterbeobachtungen, Fensterfirmen und `small_cell` (`:[number withheld][number withheld]`). Das Gitter nutzt jetzt das tatsächliche Ausschlussfenster (`:[number withheld][number withheld]`), die Attrition-Bins zählen die jeweilige Bin (`:[number withheld][number withheld]`).
[number withheld]. **Pilotliste genau wie vorgegeben, keine anderen Handdaten:** belegt (`:[number withheld][number withheld]`, mit `stopifnot` auf [number withheld] Firmen und Zhongliang nicht im Panel). Seazen wird nur über die in der Datei genannte Sensitivitäts-ID ersetzt.
[number withheld]. **Rework [number withheld] bis [number withheld], soweit sie Daten betreffen:** erfüllt.
   - Punkt [number withheld]: Der Ausschluss deckt die ausgewertete Region ab (`:[number withheld]`, `:[number withheld][number withheld]`).
   - Punkt [number withheld]: Seazen wird aus den Kontrollen genommen (`:[number withheld]`).
   - Punkt [number withheld]: Bin-Zählungen werden verwendet.
   - Punkt [number withheld]: HK-Quellenlabels stimmen mit `[number withheld]_clean.R:[number withheld]` (`预收款项 + 合同负债`) überein, und die Nullwert-Sensitivität ist vorhanden.
   - Punkt [number withheld] und [number withheld] betreffen die Schätzung und die Darstellung, nicht meine Rolle.

## Nicht geprüft
- Ich konnte nichts ausführen und habe keine Dateien per Hash verglichen. Byte-Identität und die Zahlen in Bericht und CSVs habe ich nicht nachgerechnet.
- Die Formeln für RL1–RL3 und `rl2_adj` stammen aus `01_clean.R`, das ich nur ausschnittsweise gelesen habe. `20_referee4.R` prüft nur RL1 gegen `N/(N+te)` (`:[number withheld]`).
- Die Panel-Datei (`panel_firm_halfyear.csv`) und `state/pilot_developers.csv` habe ich nicht geöffnet. Die Fallzahlen [number withheld]/[number withheld] und [number withheld] Firmen stützen sich auf die `stopifnot`-Asserts im Skript.
- Die Quellen für den Pilotbeginn, den Rollout und den Standardwechsel (Huang [number withheld], Su/Wang/Yao [number withheld], Chu/Deng/Tsang [number withheld]) habe ich nicht gesehen. Diese Passagen muss der PI bestätigen, wie die Karte vermerkt.
- `AI_USAGE_LOG.md`, `README.md` und `run_all.*` habe ich nicht geprüft. Ob der Protokolleintrag zu T058 vorliegt, ist offen.
- Die Änderungszeit-Warnung des Skripts nennt viele Dateien in `proposal/`. Diese Änderungen liegen außerhalb meiner Rolle und müssen vom Co-PI als Folge der parallelen Karte T059 bewertet werden.
