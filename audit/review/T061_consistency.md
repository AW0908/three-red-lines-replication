## Rolle: consistency (claude, sonnet) – VERDICT: PASS


## Befunde
1. **Kleiner Hinweis, nicht blockierend:** In `t061_estimates.csv` stehen bei den Placebo-Zeilen `exclusion_lower` und `exclusion_upper` auf 0,56 und 0,60 (0,76 und 0,80). Das ist nur das Massenfenster. Der zusätzliche Fit-Ausschluss [0,66; 0,72) steht nur in `t061_density_bins.csv` (Spalte `excluded`) und in `t061_variants.csv`, Zeilen 5–6. Wer allein die Estimates-Datei liest, sieht den Ausschluss nicht. Die Spaltennamen sind aber in Tex-Note und Interpretation eindeutig erklärt, und die Zahlen sind konsistent.

Sonst keine Inkonsistenz gefunden.

## Abnahmekriterien
Bewertet habe ich nur, was meine Rolle betrifft: Text ↔ Output und innere Konsistenz.

- **Tabelle `t061_results.tex` ↔ `t061_estimates.csv` und `t061_diff_bunching.csv`:** belegt erfüllt. Alle sechs Zeilen stimmen bei b_pre, b_post, Δb, KI und Support mit den CSV-Werten überein, Rundung und Vorzeichen eingeschlossen.
  - Kontrolle 0,70: −0,177 / −0,750 / −0,574 [−1,675; 0,439], Support 207/159.
  - Kontrolle 0,60: Δb −0,571 [−1,618; 0,364], Support 324/269.
  - Kontrolle 0,80: Δb 0,003 [−1,370; 1,316], Support 103/88.
  - Entwickler alle: 4,020 [1,671; 6,797]. Balanciert: 3,906 [1,476; 6,856]. A-Aktien: 2,096 [−0,405; 5,406].
  - ΔΔb-Kontraste: 4,594 [2,155; 7,469], 4,480 [1,850; 7,642] und 2,670 [−0,223; 6,354].
- **Placebo-Rework (T023-Konvention):** belegt erfüllt.
  - In `t061_density_bins.csv` sind für 0,60 (pre) und 0,80 (post) zehn Bins als `excluded` markiert, nämlich die vier eigenen Massenbins und die sechs Bins 0,665–0,715.
  - Die Massenbins sind getrennt markiert (`mass_window`).
  - Die beobachtete Masse stimmt mit den Bin-Zählungen überein: 75+85+86+78 = 324 bei 0,60 pre und 24+22+19+23 = 88 bei 0,80 post.
  - Die angepasste Masse 294,41 bei 0,60 pre ist die Summe der vier Bin-Fits.
  - Tex-Note, `t061_variants.csv` und `t061_interpretation.csv` (Schritt 2) beschreiben dieselbe Spezifikation.
- **Interpretation, Schritt 1:** belegt erfüllt. 816 Roster-Firmen, 752 balanciert (752×14 = 10528; 752×13 = 9776) und 64 fehlend (816 − 752 = 64) sind rechnerisch konsistent. Die Beobachtungen von 4.512 pre (752×6) und 3.760 post (752×5) entsprechen den Estimates.
- **Interpretation, Schritt 3 (Lesart):** belegt erfüllt. Die Aussagen folgen den KIs.
  - Die beiden Co-Primary-KIs liegen über null, das A-Aktien-KI schließt null ein.
  - Die Interpretation behauptet für den A-Aktien-Kontrast keine Signifikanz.
- **κ-Schriftangabe (Rework Punkt 2):** belegt erfüllt. `t061_kappa_render.csv`, `t061_interpretation.csv` (Schritt 6), `t061_validation.txt` und README nennen alle 9,600000 pt nativ und 9,627213 pt bei voller Satzbreite. Die Rechnung stimmt: 12×0,8 = 9,6 und 9,6×6,2677/6,25 = 9,627. Das ist ein errechneter Wert, kein gemessener. Die Angabe ist durchgängig als solcher gekennzeichnet. Die Datei `t061_validation.txt` existiert und gehört zu den Ausgaben des Kartenbefehls.
- **Kriterium 1 (Reproduktion, Byte-Identität):** nicht meine Rolle. Das Validierungsprotokoll und der Bericht behaupten PASS, ich habe nichts ausgeführt.
- **Kriterium 2 (Varianten mit N und Support):** soweit prüfbar belegt. Alle sechs Zeilen haben N, Firmen und Fenstersupport, in Estimates und Tabelle konsistent.
- **Kriterium 3 (MANIFEST):** nicht meine Rolle.

## Nicht geprüft
- Code, Datenbereinigung und Schätzlogik (`21_diff_bunching.R`, Rollen data und estimation).
- Byte-Identität, Hashes und Läufe. Ich darf keine Befehle ausführen.
- Die vollständige `t061_number_map.csv` (über 116.000 Zeilen). Ich habe nur Stichproben der Placebo-Zeilen gelesen, und diese stimmen mit den Estimates überein. Auch `t061_bootstrap_draws.csv` habe ich nicht im Einzelnen geprüft.
- Die PDFs (`t061_control_density.pdf`, `t055_kappa.pdf`), die ich nicht visuell geprüft habe. Ebenso nicht geprüft: MANIFEST, README außerhalb der κ-Passage und `AI_USAGE_LOG.md`.
