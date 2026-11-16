## Rolle: data (claude, sonnet) – VERDICT: PASS


I checked this by reading the code and outputs only. I ran no commands, because Bash was denied.

## Befunde
Keine inhaltlichen Datenfehler gefunden. Drei kleine Hinweise, keiner davon blockierend:

[number withheld]. **Zeilenzahl der Robustheitsstichprobe nicht im t0[number withheld]-Hinweis.** Die Teilstichprobe „advance item reported at every endpoint“ hat nur [number withheld] Firmen (`t076_hk_support.csv`, Zeile `control_HK_no_imputation`) und ist als `low_support=TRUE` geflaggt. Der Appendix-Text und die Tabellennote in `t076_hk_control.tex` sagen das ausdrücklich. Die Zeile „HK advance checks“ in `t051_robustness.tex` und deren Note erwähnen es nicht. Ein Leser von t0[number withheld] allein sieht die [number withheld] [[number withheld], [number withheld]] ohne den Hinweis auf geringe Stützung. Das ist eine Darstellungsfrage und betrifft nicht die Daten.
[number withheld]. **Tie-Regel der Datumszuordnung.** `nearest_halfyear` (`01_clean.R:26-38`) bildet gleich weit entfernte Stichtage auf den früheren Endpunkt ab: [number withheld]. → [number withheld]., [number withheld]. → [number withheld]. Das gilt identisch für HK-Entwickler, weil dieselbe Funktion aus `01_clean.R` verwendet wird. Es ist konsistent und kein Fehler. Der Satz „nearest June/December“ in der roster-Note ist bei Ties aber nicht ganz präzise.
[number withheld]. **`mapped_rows_outside = [number withheld]`.** Die Rohdaten sind offenbar schon beim Download auf das Fenster begrenzt. Der Filter in `25_hk_control.R:130` greift daher nie. Der Abgleich der Rohdateien gegen die Wide-Datei (`:[number withheld][number withheld]`, [number withheld] Werte) bestätigt aber, dass nichts verloren geht.

## Abnahmekriterien
Nur soweit meine Rolle (Daten) betroffen ist.

- **Schritt [number withheld], Daten kopiert:** belegt erfüllt.
  - `25_hk_control.R:82-98` kopiert byte-genau per SHA-[number withheld], überschreibt nie und prüft die MANIFEST.
  - Die Roster-Zahlen sind konsistent: [number withheld] − [number withheld] = [number withheld] (`t076_hk_roster_summary.csv`), [number withheld] − [number withheld] = [number withheld], und [number withheld] + [number withheld] = [number withheld].
  - Die Rollen-Asserts (`:[number withheld][number withheld]`) sind eindeutig: keine doppelten Codes, setequal zur HKEX-Liste, Codes < [number withheld].
- **RL1-Konstruktion (`:[number withheld][number withheld]`):** belegt erfüllt. Sie entspricht `21_diff_bunching.R:113-117`.
  - Vorzeichen und Richtung stimmen: RL1 = (TL − adv)/(TA − adv).
  - Nenner ≤ [number withheld] oder fehlend ergibt NA.
  - Die Regel „beide Komponenten fehlen → [number withheld] und geflaggt“ ist dieselbe wie bei `control_A_Sina`.
- **Stichprobe, Balanced-Regel:** belegt erfüllt.
  - [number withheld] Firmen mit [number withheld] endlichen RL1-Werten (`:[number withheld][number withheld]`).
  - Pre [number withheld] × [number withheld] = [number withheld] und post [number withheld] × [number withheld] = [number withheld] Firm-Halbjahre stimmen mit `t076_hk_support.csv` überein.
- **Rework [number withheld] (differenzielle Imputation):** belegt erfüllt.
  - (a) Die No-Imputation-Menge verlangt `!adv_missing` an allen [number withheld] Endpunkten (`:[number withheld][number withheld]`) und ergibt [number withheld] Firmen.
  - (b) Die unadjustierte Quote TL/TA behält dieselben [number withheld] Firmen und dieselben Gewichte (`:[number withheld][number withheld]`, `:[number withheld]`).
  - Die Draws für beide Varianten werden nach den ursprünglichen Draws angehängt (`:[number withheld][number withheld]`), die primären Draws bleiben also unverändert.
  - Der Anteil von [number withheld]/[number withheld] = [number withheld] % stimmt mit der Karte überein.
  - Die Bias-Richtung (Null-Advances erhöhen das Kontroll-RL1, wenn TL < TA) ist im Appendix genannt, aber vorsichtig formuliert.
- **Rework [number withheld] (veraltete „no HK control“-Aussagen):** belegt erfüllt. Laut `review/T0[number withheld]_proposal.diff` sind die Stellen in `t049_threats.tex`, `appendix/results.tex`, `t061_results.tex` und `02_literature.tex` ersetzt. Die Autorenänderung beim Focal Paper ist unverändert gelassen.
- **Rework [number withheld] (Roster-Note):** belegt erfüllt. Die zwei nicht belegten Sätze fehlen. Der Satz zu März/September-Berichten ist ergänzt. Die Ledger-Zahlen (spot [number withheld] ([number withheld]), validation [number withheld] ([number withheld]), wide_validation [number withheld] ([number withheld])) stimmen mit der CSV überein.
- **Rework [number withheld] (Stil):** belegt erfüllt, soweit ich es am Tex-Text sehen kann.
  - `$[number withheld]$` ist in math gesetzt.
  - Die Zeilenbezeichnung „HK developers $-$ HK control“ steht in t0[number withheld].
  - Die Entwickler- und Kontrollzahlen „D [number withheld]/[number withheld]; C [number withheld]“ sowie die A-Kontroll-Zahlen [number withheld]/[number withheld] ([number withheld]) stehen in der Note.
- **Reproduzierbarkeit (Kriterium [number withheld]):** teilweise nur indirekt belegt. `t076_reproducibility.csv` meldet [number withheld] byte-identische Staged-Dateien, `t076_verification.csv` [number withheld] unveränderte bestehende Outputs, und `:[number withheld][number withheld]` erzwingt das per Assert. Ich habe die zweimalige Ausführung nicht selbst wiederholt.
- **Number Audit (Kriterium [number withheld]):** laut `t076_build_checks.csv` [number withheld] verifizierte Zeilen, alle `pass=TRUE`. Das Skript prüft dabei Quellwert und gedruckten Text. Ich habe nicht alle [number withheld] Zeilen einzeln nachgeprüft.
- **Build (Kriterium [number withheld]):** laut `t076_build_checks.csv` [number withheld] Fehler, Haupttext endet auf Seite [number withheld], Einleitung auf Seite [number withheld], [number withheld] Overfull-Boxen. Das ist ein Skriptbefund. Die PDF habe ich nicht geöffnet.
- **Kriterium [number withheld] (Bericht):** nicht meine Rolle.
- **Estimation, Inferenz und Textaussagen:** nicht meine Rolle (Estimation- und Consistency-Reviewer).

## Nicht geprüft
- Ich habe das Skript nicht ausgeführt und keine zweite Ausführung auf Byte-Identität verglichen. Das war nicht möglich, weil Bash gesperrt war.
- Ich habe nicht jede der [number withheld] Audit-Zeilen und nicht die einzelnen Rohdateien unter `replication/data/raw/control_hk/raw/` nachgeprüft. Die Zeilen-für-Zeilen-Validierung der Wide-Werte gegen die Rohdaten stützt sich auf die Asserts im Skript (`:[number withheld][number withheld]`).
- Das gerenderte PDF und die Abbildung habe ich nicht angesehen. `t076_visual_check.csv` und `t076_validation.csv` habe ich nicht gelesen.
- Ob die Roster-Klassifikation (Immobilien, Finanzen, A+H) inhaltlich korrekt ist, habe ich nicht geprüft. Das hängt an den PI-Rohdaten (`industry`, `reason`), die das Skript nur auf Konsistenz prüft.
- Regressionen, Bootstrap-Code und Textwortlaut habe ich nicht bewertet.
