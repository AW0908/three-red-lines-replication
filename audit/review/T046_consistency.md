## Rolle: consistency (claude, sonnet) – VERDICT: PASS


(Rolle Consistency: Schätzung ↔ Output ↔ Text. Ich habe keine Befehle ausgeführt. Meine Bash-Anfrage für eine Nachrechnung wurde abgelehnt. Geprüft habe ich durch Lesen und Zählen mit Grep.)

## Befunde

Keine inhaltlichen Inkonsistenzen gefunden. Drei Hinweise ohne Urteilsrelevanz, schwerster zuerst:

1. **Pre/Post-Vergleich auf verschiedenen Stichproben.** 2019 enthält 28 A-Aktien-Firma-Jahre und 0 HK-Fälle (`t046_cash_backing_all.csv`, Zeile "All 2019": `excluded_hk_positive` = 40). Post enthält 54 Firmen mit 31 HK-Fällen. Der Bericht nennt das ausdrücklich unter "Offene Fragen". Der Proposal-Text darf (c) deshalb nicht als Vergleich derselben Firmen darstellen. Die Intervalle überlappen stark: 2019 liegt bei [0,285; 1,144], Post bei [0,771; 1,000].
2. **Crosser gegen Übrige.** Die Intervalle überlappen: Crosser [0,843; 1,111], Übrige [0,660; 0,998]. Der Bericht formuliert korrekt deskriptiv ("keine kausale Aussage"). Ein Text, der einen Unterschied behauptet, wäre durch die Outputs nicht gedeckt.
3. **`.tex`-Tabelle ohne (d).** Die Spalte "≥50 %" steht nur in der CSV, nicht in der `.tex`. Das ist laut Karte zulässig ("compact"). Bei Verwendung im Text muss die Zahl aus der CSV zitiert werden.

Zusätzlich offen und nicht Gegenstand dieser Rolle: Der vorgeschlagene Eintrag des Workers fehlt in `AI_USAGE_LOG.md`. Dort steht nur der Co-PI-Eintrag vom 2026-10-29 mit "Workers' outputs pending". Das Eintragen übernimmt der Co-PI.

## Abnahmekriterien

Geprüft wurde, soweit es meine Rolle betrifft: Bericht ↔ CSV ↔ `.tex` ↔ Verifikationsdatei ↔ Abbildung.

1. **Werte mit Datei, Seite, Auszug und `extraction_check`:** Teilweise geprüft. In `t046_firm_years.csv` stehen Dateipfad, Seite und `exact`/`manual` je Komponente. Der Bericht (538 exact + 6 manual = 544 gedruckte Werte) und die Verifikation (720 exact / 6 manual = 726 Quellwerte) nennen zwei verschiedene, aber erklärbare Mengen. Die Code- und Extraktionsrichtigkeit bewerte ich nicht (Rolle `data`).
2. **Pilotabgleich dokumentiert:** Bericht und `t046_verification.txt` stimmen überein (72 Zeilen = 37 + 8 + 15 + 12, 0 Abweichungen). Die Datei `t046_pilot_crosscheck.csv` habe ich nicht geöffnet.
3. **Zwei Läufe byte-identisch:** Die Verifikationsdatei nennt 13/13 identische Artefakte, der Bericht ebenso. Ich konnte das nicht selbst nachprüfen.
4. **Ratios of sums, Ausschlüsse gezählt:** Erfüllt.
   - Rechnerisch bestätigt für die Zeilen "All 2019–2021" und "Post".
   - ΔMI: 188,27 + 339,79 + 262,60 = 790,66 (Tabelle: 790,67, Rundung).
   - Kapital: 99,02 + 291,09 + 238,78 = 628,89.
   - Residuum: 55,68 − 25,73 − 29,18 = 0,77.
   - ≥50 %: 16 + 30 + 31 = 77.
   - Crosser plus Übrige ergibt 20 + 34 = 54 Firmen, 33 + 48 = 81 Firma-Jahre, ΔMI 272,82 + 329,57 = 602,39 und Kapital 263,46 + 266,41 = 529,87, jeweils gleich "Post".
   - Ausschlüsse: 96 − 28 = 68, 90 − 43 = 47, 68 − 38 = 30.
   - Eingeschlossene A/HK-Fälle: 78 A + 31 HK = 109 (28/0, 26/17, 24/14).
[firm-specific excerpt withheld in public audit]
5. **`exact` = Level-String, `manual` für den PI gelistet:** Bericht und Verifikation nennen übereinstimmend 6 manuelle Werte und 20 PI-Stichprobenwerte. Beide Listen habe ich nicht geöffnet.

Konsistenz Text ↔ Output im Einzelnen:
- Alle 11 Zeilen der Ergebnistabelle im Bericht (Prozent, ΔMI in Mrd., KI, ≥50 %) stimmen mit `t046_cash_backing_all.csv` und der `.tex` (auf drei Nachkommastellen) überein.
- Der Gesamtanteil 77/109 = 70,6 % stimmt (CSV: 0,7064). Der Post-Anteil 61/81 = 75,3 % stimmt (CSV: 0,7531).
- Die Fußnoten der `.tex` (absolute Dividenden, Residuendefinition, Seed, 999 Ziehungen) stimmen zu README und Bericht.
- README-Eintrag T046 (Zeile 116): 31 eindeutige Crosser-IDs, Seed 20261029 und Gesamtbeschreibung sind konsistent mit Bericht und CSV.
- Abbildung `t046_cash_share.pdf`: Die Punkte stimmen mit der CSV überein.
  - Crosser: ≈0,92 (2020) und ≈1,03 (2021).
  - Übrige: ≈0,80 (2020) und ≈0,81 (2021).
  - Die Achsen und Konfidenzbänder passen zu den CSV-Werten, die Beschriftung beschreibt das Gezeigte.

## Nicht geprüft

- Code- und Datenrichtigkeit sowie Extraktion gegen die PDFs: Rolle `data` und `estimation`.
- Die Bootstrap-Perzentile habe ich nicht selbst neu berechnet, nur auf Plausibilität geprüft.
- Die Dateien `t046_pilot_crosscheck.csv`, `t046_comparative_2020.csv`, `t046_manual_values.csv`, `t046_pi_spotcheck_20.csv` und `t046_reproducibility.csv` habe ich nicht Zeile für Zeile abgeglichen. Der Bericht stützt sich dafür auf `t046_verification.txt`.
- Die Hash-Gleichheit der beiden Läufe konnte ich ohne Befehle nicht nachvollziehen.
- Den Schreibbereich (Kriterium Umfang) bewerte ich nicht. Die Änderungszeit-Liste des Systems zeigt viele Dateien außerhalb des Bereichs (z. B. `t044_*`, `T047`-Audit). Die Karte nennt dazu parallele Sitzungen und T047. Ob T046 sie verändert hat, prüft die Rolle `estimation` bzw. `data`.
