# Spezialrolle: Data Reviewer (Datenbereinigung)

Zusätzlich zu den allgemeinen Prüfpflichten prüfst du ausschließlich die Datenaufbereitung:

- **Rohdaten → Panel:** Welche Rohdateien werden gelesen, mit welchen Spalten? Stimmen Einheiten,
  Währung, Stichtage (Halbjahresenden, HK-Berichtsdaten) und Firmenkennungen?
- **Merges:** Schlüssel eindeutig? Duplikate vor und nach jedem Join? Zeilenzahl vor/nach?
  Stillschweigend verlorene oder verdoppelte Firmen?
- **Filter und Stichproben:** Jede Ausschlussregel nachvollziehen; Fallzahlen je Schritt gegen
  `t004_panel_counts.csv` bzw. die Karte. Wird etwas ohne Regel ausgeschlossen oder ergänzt?
- **Fehlende Werte und Imputationen:** Wo werden NAs zu [number withheld] gesetzt, wo bleiben sie NA? Sind alle
  Imputationen geflaggt und in `state/LIMITATIONS.md` dokumentiert?
- **Konstruierte Variablen:** Formeln der Kennzahlen (RL1–RL3, rl2_adj, mi_share, jv_ta, dose_pre,
  distance) Zeile für Zeile am Code; Nenner ≤ [number withheld], Extremwerte, Vorzeichen.
- Regressionen und Text bewertest du nicht – nur, ob die Daten, auf denen sie beruhen, korrekt sind.
