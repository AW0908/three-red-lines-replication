## Rolle: estimation (claude, opus) – VERDICT: PASS


## Befunde

Keine inhaltlichen Fehler in den Schätzungen. Alle vier Punkte aus dem vorigen Estimation-REWORK (`review/T023_estimation.md`) sind im Code und in den Outputs umgesetzt. Drei kleine Anmerkungen, keine davon verlangt Nacharbeit:

1. **Der Dagger steht nur am SE, nicht am Punktschätzer (gering).** Laut `06_bunching_tests.R:491–492` bekommt nur die SE-Zelle `$^{\dagger}$`, wenn weniger als 90 % der Ziehungen gültig sind. Der Wert `b` selbst, z. B. rl1_alt 0,80 degree7 mit 6,4024 und 7,8952 (`t023_excess_mass.tex:66`), steht ohne Markierung da. Die Note (`:73`) erklärt das. Sterne gibt es keine. In der CSV stehen `inference_status = "unreliable_bootstrap_below_90pct"` und `bootstrap_meets_90pct = FALSE` (`t023_excess_mass.csv:72, 74–76, 87, 89–90`). Die Karte verlangt „flag estimates … do not star them as reliable“. Das ist erfüllt, wenn man das SE-Flag als Flag der Schätzung liest.
2. **`na = "--"` gilt für die ganze Excess-Mass-CSV (gering).** `write_csv(excess, "excess_mass", na = "--")` (`:482`) schreibt auch dort `--`, wo eine Spalte gar nicht anwendbar ist, etwa `matched_cutoff_unrounded` für rl1 (`t023_excess_mass.csv:2–61`). Wer die Datei später einliest, muss `na.strings = "--"` setzen, sonst werden die Spalten zu Text. So steht es in Co-PI-Punkt 2. An den Zahlen ändert das nichts.
3. **Die Rangregel ist nicht ganz einheitlich (gering, dokumentiert).** Der Quantilrang nutzt `<= .70` (`:60`), die Bins nutzen `< .70`. Im Bootstrap bleibt der Cutoff fest. Beides steht in `t023_verification.txt:112` und in der TEX-Note der Definitionstabelle. Bei stetigen Quoten ist der Effekt vernachlässigbar.

**Die REWORK-Punkte im Einzelnen:**

- **Punkt 1, Placebo-Ausschluss:** `regulated_region` umfasst die Bin-Mitten in [0,66; 0,72) bei rl1 bzw. [0,49; 0,55) bei rl1_alt (`:405–408`). `excluded <- test_window | (is_placebo & regulated_region)` (`:416`). Die Masse bleibt auf das eigene Fenster unterhalb der Placebo-Schwelle beschränkt (`:417`). Ein `stopifnot` prüft den Ausschluss (`:419–420`). In der CSV stimmt `exclusion_bins` mit 10/9/12 bei den Placebos und 4/3/6 bei den regulierten Schwellen (z. B. `:7, 10, 11` gegen `:2, 5, 6`). Die Alt-Neu-Werte stehen in `t023_verification.txt:14–54`. Die Bericht-Tabelle gibt sie richtig wieder, z. B. rl1 post 0,60 main von −1,3254 auf −0,3387.
- **Punkt 2, ungültige Schätzungen:** Bei `!valid_point` werden SE und KI auf NA gesetzt (`:444`). Ein `stopifnot` sichert ab, dass jede ungültige Zeile auch einen nicht-finiten SE hat (`:480–481`). Die einzige ungültige Zeile ist rl1_alt post 0,80 wide (`t023_excess_mass.csv:91`). Dort stehen b, SE und KI als `--`, im TEX `-- & --` (`t023_excess_mass.tex:68`). Bei den 8 Fits unter 90 % stehen `bootstrap_meets_90pct = FALSE` und der Dagger. Das passt zu den 8 Daggern in den Zeilen 64 und 66–68 des TEX.
- **Punkt 3, gepaarte rl1-Schätzung:** `mass_samples` enthält rl1 auf der Hauptstichprobe und rl1 auf der gepaarten Stichprobe (`:398–400`). `bin_counts` filtert mit `rl1_pair` (`:382`). N ist 711/599 für rl1 gepaart und rl1_alt gepaart (CSV `:32, 47, 62, 77`) und 797/630 für die volle Stichprobe. Die TEX-Tabelle hat die Spalte „Sample“ (Full/Paired), und die drei Panels sind getrennt.
- **Punkt 4, Raster:** `mass_matched_cutoff = round(0.5335/0.01)*0.01 = 0.53` (`:397`). Das Fenster ist main [0,49; 0,53), narrow [0,50; 0,53), wide mit Ausschluss bis 0,55 (CSV `:62, 65, 66`). Die Rundung steht in der TEX-Note. `stopifnot(sum(mass) == round(spec$left/.01))` sichert genau 4 bzw. 3 Masse-Bins.

**Nachgerechnet bzw. am Code geprüft:**

- **Excess Mass, Formel:** rl1 post main: Exzess 51,92 / kontrafaktisch 16,52 je Bin = 3,1429 (CSV `:17`). Der Bootstrap passt das Polynom je Ziehung neu an (`:427`), mit derselben Normierung `cf_boot/sum(mass)` (`:436`), also konsistent zum Punktschätzer.
- **Difference-in-Bunching:** (0,130217 − 0,046414) − (0,066778 − 0,047820) = 0,064846. Das stimmt mit `difference_in_bunching` überein (`t023_placebo_definitions.csv:7`). Die Spaltenreihenfolge aus der verketteten Zuweisung (`:193–199`) habe ich geprüft: Die Zuweisung läuft über Spaltennamen, also landen die Werte unter dem richtigen Kopf.
- **Reversal:** Die Werte gegen die CSV geprüft: 14/61, 9/50, 20/36. Differenzen 0,0495 mit KI [−0,107; 0,198] und −0,3260 mit KI [−0,537; −0,127] (`t023_reversal.csv:4–8`). Die Ziehungen sind gepaart.
- **Composition:** CR1-Cluster-SE und t-Verteilung mit df = G − 1 (`:345–353`). log_ibd: Differenz 0,0023, p = 0,914, df = 81. log_ta: Differenz 0,0408, p = 0,0043 (`t023_composition.csv:2, 7`). Für perp_te ist die Inferenz unterdrückt.
- **Treatment aus Outcome, Post-Treatment-Kontrollen:** Keine Regressoren aus Post-Variablen. Die Entrant/Stayer-Gruppen werden aus rl1 gebildet und auf Bilanzposten verglichen. Der Code bezeichnet das als deskriptiv.

## Abnahmekriterien

1. **Outputs existieren, reproduzierbar:** belegt, soweit ich es ohne Ausführung prüfen kann. Alle Dateien aus Schritt 6 liegen vor. Der Seed ist fest (`:6`). Alle Bootstraps nutzen eine gemeinsame Gewichtsmatrix (`:36`). PDFs werden mit `timestamp = FALSE` geschrieben. Die Hash-Belege für zwei Läufe und eine frische Kopie stehen in `t023_verification.txt:177–190`. Die Byte-Identität selbst konnte ich nicht nachprüfen.
2. **Bestehende Outputs byte-identisch:** nicht meine Rolle. Ein Hash-Guard ist im Code eingebaut (`:12–14, 569–570`).
3. **Interpretation je Test ohne Überzeichnung:** belegt erfüllt, soweit es die Schätzungen betrifft. Zum vorigen Befund 1 sagt der Bericht jetzt, dass die korrigierten Placebo-KIs null einschließen und die früheren negativen Vorzeichen kein eigenständiger Beleg sind. Der Unterschied zwischen rl1 und rl1_alt sowie zwischen pre und post wird als „nicht formal getestet“ benannt. Mehrfachtests werden in jeder Note genannt. Die Gesamtaussage lautet „vereinbar mit Targeting, nicht identifizierend“.
4. **T005-Zählungen 36/797 und 78/630:** belegt erfüllt. Das `stopifnot` vergleicht gegen `t005_bunching_counts.csv` (`:201–208`).

## Nicht geprüft

- Byte-Identität und die Hashes: Dafür müsste ich Befehle ausführen.
- Inhalt der beiden PDF-Abbildungen: Ich habe nur den Code gelesen. Das Fenster [0,66; 0,70) und die Linie bei 0,70 passen zur Spezifikation main der vollen Stichprobe (`:474–476, 556–566`).
- Die unabhängige Nachrechnung des Workers mit rohen Potenzen (`t023_verification.txt:87–92`): Ich habe sie nicht nachvollzogen, nur Stichproben selbst nachgerechnet.
- Datenaufbereitung (rl1_alt/rl2_adj, adv/perp-Flags, fye_flag 10 statt 11 Firmen), Sprache und Abgleich mit `proposal/`: nicht meine Rolle.
- Änderungen an `state/STATE.md` und `state/LIMITATIONS.md` während der Ausführung sowie die Änderungen außerhalb des Schreibbereichs, die das Skript gemeldet hat (`proposal/`, `Daten/HK_delistet.xlsx`, Ausgaben von t008/t009/t011/t015/t019): nicht meine Rolle. Laut Hash-Protokoll des Workers sind die Inhalte der Ausgaben unverändert. Gemeldet wurde dort offenbar nur die Änderungszeit, weil die Dateien neu geschrieben wurden.
