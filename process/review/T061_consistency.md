## Rolle: consistency (claude, sonnet) – VERDICT: PASS


## Befunde
[number withheld]. **Kleiner Hinweis, nicht blockierend:** In `t061_estimates.csv` stehen bei den Placebo-Zeilen `exclusion_lower` und `exclusion_upper` auf [number withheld] und [number withheld] ([number withheld] und [number withheld]). Das ist nur das Massenfenster. Der zusätzliche Fit-Ausschluss [[number withheld]; [number withheld]) steht nur in `t061_density_bins.csv` (Spalte `excluded`) und in `t061_variants.csv`, Zeilen [number withheld]–[number withheld]. Wer allein die Estimates-Datei liest, sieht den Ausschluss nicht. Die Spaltennamen sind aber in Tex-Note und Interpretation eindeutig erklärt, und die Zahlen sind konsistent.

Sonst keine Inkonsistenz gefunden.

## Abnahmekriterien
Bewertet habe ich nur, was meine Rolle betrifft: Text ↔ Output und innere Konsistenz.

- **Tabelle `t061_results.tex` ↔ `t061_estimates.csv` und `t061_diff_bunching.csv`:** belegt erfüllt. Alle sechs Zeilen stimmen bei b_pre, b_post, Δb, KI und Support mit den CSV-Werten überein, Rundung und Vorzeichen eingeschlossen.
  - Kontrolle [number withheld]: [number withheld] / [number withheld] / [number withheld] [[number withheld]; [number withheld]], Support [number withheld]/[number withheld].
  - Kontrolle [number withheld]: Δb [number withheld] [[number withheld]; [number withheld]], Support [number withheld]/[number withheld].
  - Kontrolle [number withheld]: Δb [number withheld] [[number withheld]; [number withheld]], Support [number withheld]/[number withheld].
  - Entwickler alle: [number withheld] [[number withheld]; [number withheld]]. Balanciert: [number withheld] [[number withheld]; [number withheld]]. A-Aktien: [number withheld] [[number withheld]; [number withheld]].
  - ΔΔb-Kontraste: [number withheld] [[number withheld]; [number withheld]], [number withheld] [[number withheld]; [number withheld]] und [number withheld] [[number withheld]; [number withheld]].
- **Placebo-Rework (T023-Konvention):** belegt erfüllt.
  - In `t061_density_bins.csv` sind für [number withheld] (pre) und [number withheld] (post) zehn Bins als `excluded` markiert, nämlich die vier eigenen Massenbins und die sechs Bins [number withheld]–[number withheld].
  - Die Massenbins sind getrennt markiert (`mass_window`).
  - Die beobachtete Masse stimmt mit den Bin-Zählungen überein: [number withheld][number withheld][number withheld][number withheld] = [number withheld] bei [number withheld] pre und [number withheld][number withheld][number withheld][number withheld] = [number withheld] bei [number withheld] post.
  - Die angepasste Masse [number withheld] bei [number withheld] pre ist die Summe der vier Bin-Fits.
  - Tex-Note, `t061_variants.csv` und `t061_interpretation.csv` (Schritt [number withheld]) beschreiben dieselbe Spezifikation.
- **Interpretation, Schritt [number withheld]:** belegt erfüllt. [number withheld] Roster-Firmen, [number withheld] balanciert ([number withheld]×[number withheld] = [number withheld]; [number withheld]×[number withheld] = [number withheld]) und [number withheld] fehlend ([number withheld] − [number withheld] = [number withheld]) sind rechnerisch konsistent. Die Beobachtungen von [number withheld] pre ([number withheld]×[number withheld]) und [number withheld] post ([number withheld]×[number withheld]) entsprechen den Estimates.
- **Interpretation, Schritt [number withheld] (Lesart):** belegt erfüllt. Die Aussagen folgen den KIs.
  - Die beiden Co-Primary-KIs liegen über null, das A-Aktien-KI schließt null ein.
  - Die Interpretation behauptet für den A-Aktien-Kontrast keine Signifikanz.
- **κ-Schriftangabe (Rework Punkt [number withheld]):** belegt erfüllt. `t061_kappa_render.csv`, `t061_interpretation.csv` (Schritt [number withheld]), `t061_validation.txt` und README nennen alle [number withheld] pt nativ und [number withheld] pt bei voller Satzbreite. Die Rechnung stimmt: [number withheld]×[number withheld] = [number withheld] und [number withheld]×[number withheld]/[number withheld] = [number withheld]. Das ist ein errechneter Wert, kein gemessener. Die Angabe ist durchgängig als solcher gekennzeichnet. Die Datei `t061_validation.txt` existiert und gehört zu den Ausgaben des Kartenbefehls.
- **Kriterium [number withheld] (Reproduktion, Byte-Identität):** nicht meine Rolle. Das Validierungsprotokoll und der Bericht behaupten PASS, ich habe nichts ausgeführt.
- **Kriterium [number withheld] (Varianten mit N und Support):** soweit prüfbar belegt. Alle sechs Zeilen haben N, Firmen und Fenstersupport, in Estimates und Tabelle konsistent.
- **Kriterium [number withheld] (MANIFEST):** nicht meine Rolle.

## Nicht geprüft
- Code, Datenbereinigung und Schätzlogik (`21_diff_bunching.R`, Rollen data und estimation).
- Byte-Identität, Hashes und Läufe. Ich darf keine Befehle ausführen.
- Die vollständige `t061_number_map.csv` (über [number withheld] Zeilen). Ich habe nur Stichproben der Placebo-Zeilen gelesen, und diese stimmen mit den Estimates überein. Auch `t061_bootstrap_draws.csv` habe ich nicht im Einzelnen geprüft.
- Die PDFs (`t061_control_density.pdf`, `t055_kappa.pdf`), die ich nicht visuell geprüft habe. Ebenso nicht geprüft: MANIFEST, README außerhalb der κ-Passage und `AI_USAGE_LOG.md`.
