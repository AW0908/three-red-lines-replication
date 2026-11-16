## Rolle: consistency (claude, sonnet) – VERDICT: PASS


(Rolle Consistency: Schätzung ↔ Output ↔ Text. Ich habe keine Befehle ausgeführt. Meine Bash-Anfrage für eine Nachrechnung wurde abgelehnt. Geprüft habe ich durch Lesen und Zählen mit Grep.)

## Befunde

Keine inhaltlichen Inkonsistenzen gefunden. Drei Hinweise ohne Urteilsrelevanz, schwerster zuerst:

[number withheld]. **Pre/Post-Vergleich auf verschiedenen Stichproben.** [number withheld] enthält [number withheld] A-Aktien-Firma-Jahre und [number withheld] HK-Fälle (`t046_cash_backing_all.csv`, Zeile "All [number withheld]": `excluded_hk_positive` = [number withheld]). Post enthält [number withheld] Firmen mit [number withheld] HK-Fällen. Der Bericht nennt das ausdrücklich unter "Offene Fragen". Der Proposal-Text darf (c) deshalb nicht als Vergleich derselben Firmen darstellen. Die Intervalle überlappen stark: [number withheld] liegt bei [[number withheld]; [number withheld]], Post bei [[number withheld]; [number withheld]].
[number withheld]. **Crosser gegen Übrige.** Die Intervalle überlappen: Crosser [[number withheld]; [number withheld]], Übrige [[number withheld]; [number withheld]]. Der Bericht formuliert korrekt deskriptiv ("keine kausale Aussage"). Ein Text, der einen Unterschied behauptet, wäre durch die Outputs nicht gedeckt.
[number withheld]. **`.tex`-Tabelle ohne (d).** Die Spalte "≥[number withheld] %" steht nur in der CSV, nicht in der `.tex`. Das ist laut Karte zulässig ("compact"). Bei Verwendung im Text muss die Zahl aus der CSV zitiert werden.

Zusätzlich offen und nicht Gegenstand dieser Rolle: Der vorgeschlagene Eintrag des Workers fehlt in `AI_USAGE_LOG.md`. Dort steht nur der Co-PI-Eintrag vom 2026-10-29 mit "Workers' outputs pending". Das Eintragen übernimmt der Co-PI.

## Abnahmekriterien

Geprüft wurde, soweit es meine Rolle betrifft: Bericht ↔ CSV ↔ `.tex` ↔ Verifikationsdatei ↔ Abbildung.

[number withheld]. **Werte mit Datei, Seite, Auszug und `extraction_check`:** Teilweise geprüft. In `t046_firm_years.csv` stehen Dateipfad, Seite und `exact`/`manual` je Komponente. Der Bericht ([number withheld] exact + [number withheld] manual = [number withheld] gedruckte Werte) und die Verifikation ([number withheld] exact / [number withheld] manual = [number withheld] Quellwerte) nennen zwei verschiedene, aber erklärbare Mengen. Die Code- und Extraktionsrichtigkeit bewerte ich nicht (Rolle `data`).
[number withheld]. **Pilotabgleich dokumentiert:** Bericht und `t046_verification.txt` stimmen überein ([number withheld] Zeilen = [number withheld] + [number withheld] + [number withheld] + [number withheld], [number withheld] Abweichungen). Die Datei `t046_pilot_crosscheck.csv` habe ich nicht geöffnet.
[number withheld]. **Zwei Läufe byte-identisch:** Die Verifikationsdatei nennt [number withheld]/[number withheld] identische Artefakte, der Bericht ebenso. Ich konnte das nicht selbst nachprüfen.
[number withheld]. **Ratios of sums, Ausschlüsse gezählt:** Erfüllt.
   - Rechnerisch bestätigt für die Zeilen "All [number withheld]–[number withheld]" und "Post".
   - ΔMI: [number withheld] + [number withheld] + [number withheld] = [number withheld] (Tabelle: [number withheld], Rundung).
   - Kapital: [number withheld] + [number withheld] + [number withheld] = [number withheld].
   - Residuum: [number withheld] − [number withheld] − [number withheld] = [number withheld].
   - ≥[number withheld] %: [number withheld] + [number withheld] + [number withheld] = [number withheld].
   - Crosser plus Übrige ergibt [number withheld] + [number withheld] = [number withheld] Firmen, [number withheld] + [number withheld] = [number withheld] Firma-Jahre, ΔMI [number withheld] + [number withheld] = [number withheld] und Kapital [number withheld] + [number withheld] = [number withheld], jeweils gleich "Post".
   - Ausschlüsse: [number withheld] − [number withheld] = [number withheld], [number withheld] − [number withheld] = [number withheld], [number withheld] − [number withheld] = [number withheld].
   - Eingeschlossene A/HK-Fälle: [number withheld] A + [number withheld] HK = [number withheld] ([number withheld]/[number withheld], [number withheld]/[number withheld], [number withheld]/[number withheld]).
[firm-specific excerpt withheld in public process copy]
[number withheld]. **`exact` = Level-String, `manual` für den PI gelistet:** Bericht und Verifikation nennen übereinstimmend [number withheld] manuelle Werte und [number withheld] PI-Stichprobenwerte. Beide Listen habe ich nicht geöffnet.

Konsistenz Text ↔ Output im Einzelnen:
- Alle [number withheld] Zeilen der Ergebnistabelle im Bericht (Prozent, ΔMI in Mrd., KI, ≥[number withheld] %) stimmen mit `t046_cash_backing_all.csv` und der `.tex` (auf drei Nachkommastellen) überein.
- Der Gesamtanteil [number withheld]/[number withheld] = [number withheld] % stimmt (CSV: [number withheld]). Der Post-Anteil [number withheld]/[number withheld] = [number withheld] % stimmt (CSV: [number withheld]).
- Die Fußnoten der `.tex` (absolute Dividenden, Residuendefinition, Seed, [number withheld] Ziehungen) stimmen zu README und Bericht.
- README-Eintrag T046 (Zeile [number withheld]): [number withheld] eindeutige Crosser-IDs, Seed [number withheld] und Gesamtbeschreibung sind konsistent mit Bericht und CSV.
- Abbildung `t046_cash_share.pdf`: Die Punkte stimmen mit der CSV überein.
  - Crosser: ≈[number withheld] ([number withheld]) und ≈[number withheld] ([number withheld]).
  - Übrige: ≈[number withheld] ([number withheld]) und ≈[number withheld] ([number withheld]).
  - Die Achsen und Konfidenzbänder passen zu den CSV-Werten, die Beschriftung beschreibt das Gezeigte.

## Nicht geprüft

- Code- und Datenrichtigkeit sowie Extraktion gegen die PDFs: Rolle `data` und `estimation`.
- Die Bootstrap-Perzentile habe ich nicht selbst neu berechnet, nur auf Plausibilität geprüft.
- Die Dateien `t046_pilot_crosscheck.csv`, `t046_comparative_2020.csv`, `t046_manual_values.csv`, `t046_pi_spotcheck_20.csv` und `t046_reproducibility.csv` habe ich nicht Zeile für Zeile abgeglichen. Der Bericht stützt sich dafür auf `t046_verification.txt`.
- Die Hash-Gleichheit der beiden Läufe konnte ich ohne Befehle nicht nachvollziehen.
- Den Schreibbereich (Kriterium Umfang) bewerte ich nicht. Die Änderungszeit-Liste des Systems zeigt viele Dateien außerhalb des Bereichs (z. B. `t0[number withheld]_*`, `T047`-Audit). Die Karte nennt dazu parallele Sitzungen und T047. Ob T046 sie verändert hat, prüft die Rolle `estimation` bzw. `data`.
