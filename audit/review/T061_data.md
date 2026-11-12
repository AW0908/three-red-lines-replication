## Rolle: data (claude, sonnet) – VERDICT: PASS


Status: ich habe Karte, Skript `21_diff_bunching.R`, Bereinigungsregeln, Coverage, Support, Ausfallliste, Eigentümerverfügbarkeit, MANIFEST und die Kontraste gelesen. Ich habe nichts ausgeführt.

## Befunde

1. **Geringfügig, kein Mangel:** `state/LIMITATIONS.md` enthält keinen Eintrag zur Kontroll-Imputation (fehlende Vorauszahlungen werden zu 0, 3–8 Firmen je Datum). Die Imputation ist trotzdem geflaggt (`adv_missing`, `t061_coverage.csv` Spalte `adv_imputed_zero`) und in `t061_cleaning_rules.csv` Regel 5 dokumentiert. `state/` liegt außerhalb des Worker-Schreibbereichs, daher ist das ein Hinweis an den Co-PI und kein Rework-Grund.
2. **Geringfügig, vom Worker offen gelegt:** Die MANIFEST-Abrufdaten beruhen teils auf Dateizeitstempeln und sind als "fetch date unverified" gekennzeichnet. Das betrifft `control_a_balance_sina.csv` und die Fetch-Skripte. Ich werte das als ehrliche Kennzeichnung.

## Abnahmekriterien

Bewertet nur, soweit sie meine Rolle (Daten) betreffen.

- **Variablenbedeutung (RL1):**
  - belegt erfüllt. Die Kontroll-Formel `(tl-adv)/(ta-adv)` mit Nenner > 0, sonst NA (`21_diff_bunching.R:113–117`) entspricht `01_clean.R:575` (`safe_ratio`) und `:580`.
  - Die Summe der Vorauszahlungskomponenten mit allen-fehlend → 0 entspricht der PI-Regel (`01_clean.R:543–546`).
  - In `t061_coverage.csv` gibt es keine nichtpositiven Nenner und keine fehlenden Aktiva oder Verbindlichkeiten.
- **Stichprobe und Fallzahlen:**
  - Der Skript-Assert `nrow(cp)==752*13` ist erfüllt: 752 Firmen mit je 14 Daten, davon 13 im Entwickler-Datumsset.
  - Roster und Ausfälle sind konsistent: 85+24+150+88+71+1+210+26+40+61+60 = 816 Roster-Firmen, 752 heruntergeladen, 64 fehlend (`t061_failure_by_sector.csv`, Assert auf 64 im Skript).
  - Überschneidungen mit der Entwickler-Panel-Firmenliste sind per Assert ausgeschlossen (Zeile 109).
  - Die Zeilen- und Datumsstruktur ist balanciert (Zeile 108).
  - Pre: 4.512 Beobachtungen und 752 Firmen. Post: 3.760 und 752 (`t061_support.csv`). Das passt zu 6 bzw. 5 Daten × 752.
  - Die 115 balancierten Entwickler sind per Assert fixiert und stimmen mit dem T058-Referenzwert überein (Zeile 167–168).
- **Filter und Ausschlüsse:**
  - Jede Regel steht in `t061_cleaning_rules.csv`, kein stiller Ausschluss. Werte außerhalb von [0,4; 1,0] bleiben in N und fehlen nur im Fit.
  - Alle 10 Fenster- und Fit-Bin-Ausschlüsse sind im Code nachvollziehbar.
  - Mass-Fenster und Fit-Ausschluss sind getrennt: 4 Bins für die Masse, bei den Placebos 10 Bins im Fit (Zeile 64–69). Das folgt `06_bunching_tests.R:408–420`.
  - Die Randpunkte stimmen: Fenster [0,66; 0,70) mit Bin-Mitten 0,665 bis 0,695, die letzte Bin enthält 1,0, und die Gleitkomma-Toleranz ist gesetzt.
- **Merges und Duplikate:**
  - Die Schlüssel `code × date` sind per Assert eindeutig (Zeile 107).
  - Die Zuordnung `board` ↔ Roster wird geprüft (Zeile 110).
  - `firm_id`-Suffixe (.SH, .SZ, .BJ) richten sich nach dem Code-Präfix.
- **Fehlende Werte:** Imputation nur bei Vorauszahlungen und geflaggt. Aktiva und Verbindlichkeiten bleiben NA (hier ohne Fälle). Kein Winsorizing, kein Trimmen.
- **Reproduktion der Entwicklerwerte:** belegt im Code (Assert Zeile 94 auf −0,88 / 3,14 / 4,02 vor jeder Kontrollschätzung). Der Bericht nennt −0,877187 / 3,142855 / 4,020042.
- **Eigentümerdaten (Schritt 5):** korrekt als nicht verfügbar behandelt. Panel, manuelle Kodierung und Wind ergeben 0 Treffer (`t061_ownership_availability.csv`), und es wird nichts aus Firmennamen abgeleitet.
- **Kriterium 3 (MANIFEST):** erfüllt, soweit meine Rolle reicht. Quelle, Datum und sha256 sind eingetragen, und das Skript prüft Hash und Größe aller Dateien (Zeile 9–11). Die Datumsunsicherheit ist offen markiert (Befund 2).
- **Kriterium 1 (Reproduktion/Byte-Identität) und Kriterium 2 (alle Varianten mit N und Support):**
  - Datenseitig belegt: Es gibt sechs Schätzzeilen mit N, Firmen und Fenster-Support sowie ein Low-Support-Flag (Schwelle 30, kein Flag gesetzt; Support 207/159, 324/269, 103/88).
  - Die Byte-Identität bewerte ich nicht (nicht meine Rolle).
- **Schätzung, Bootstrap-Logik, Text, Figur (Schritt 6):** nicht meine Rolle.

## Nicht geprüft

- Ich konnte keine Befehle ausführen. Der Lauf, die Byte-Identität und die Hashes sind daher nur aus Code und Bericht übernommen, nicht selbst nachvollzogen.
- Die Rohdaten (`control_a_balance_sina.csv` und die Sina-Listen) habe ich nicht Zeile für Zeile gegen die EastMoney-Quelle geprüft. Das ist offline nicht möglich.
- Ob die 64 Download-Ausfälle zufällig oder systematisch sind (Survivor-Selektion), ist Sache der Forschungsdesign-Bewertung. Die Ursachen sind nicht rekonstruierbar, und der Worker kennzeichnet das offen.
- Die Behauptung zu SOE-Warnlinien seit 2018 ist nicht geprüft.
- Das Layout der PDFs habe ich nicht angesehen.
