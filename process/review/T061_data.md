## Rolle: data (claude, sonnet) – VERDICT: PASS


Status: ich habe Karte, Skript `21_diff_bunching.R`, Bereinigungsregeln, Coverage, Support, Ausfallliste, Eigentümerverfügbarkeit, MANIFEST und die Kontraste gelesen. Ich habe nichts ausgeführt.

## Befunde

[number withheld]. **Geringfügig, kein Mangel:** `state/LIMITATIONS.md` enthält keinen Eintrag zur Kontroll-Imputation (fehlende Vorauszahlungen werden zu [number withheld], [number withheld]–[number withheld] Firmen je Datum). Die Imputation ist trotzdem geflaggt (`adv_missing`, `t061_coverage.csv` Spalte `adv_imputed_zero`) und in `t061_cleaning_rules.csv` Regel [number withheld] dokumentiert. `state/` liegt außerhalb des Worker-Schreibbereichs, daher ist das ein Hinweis an den Co-PI und kein Rework-Grund.
[number withheld]. **Geringfügig, vom Worker offen gelegt:** Die MANIFEST-Abrufdaten beruhen teils auf Dateizeitstempeln und sind als "fetch date unverified" gekennzeichnet. Das betrifft `control_a_balance_sina.csv` und die Fetch-Skripte. Ich werte das als ehrliche Kennzeichnung.

## Abnahmekriterien

Bewertet nur, soweit sie meine Rolle (Daten) betreffen.

- **Variablenbedeutung (RL1):**
  - belegt erfüllt. Die Kontroll-Formel `(tl-adv)/(ta-adv)` mit Nenner > [number withheld], sonst NA (`21_diff_bunching.R:113–117`) entspricht `01_clean.R:575` (`safe_ratio`) und `:[number withheld]`.
  - Die Summe der Vorauszahlungskomponenten mit allen-fehlend → [number withheld] entspricht der PI-Regel (`01_clean.R:543–546`).
  - In `t061_coverage.csv` gibt es keine nichtpositiven Nenner und keine fehlenden Aktiva oder Verbindlichkeiten.
- **Stichprobe und Fallzahlen:**
  - Der Skript-Assert `nrow(cp)==[number withheld]*[number withheld]` ist erfüllt: [number withheld] Firmen mit je [number withheld] Daten, davon [number withheld] im Entwickler-Datumsset.
  - Roster und Ausfälle sind konsistent: [number withheld][number withheld][number withheld][number withheld][number withheld][number withheld][number withheld][number withheld][number withheld][number withheld][number withheld] = [number withheld] Roster-Firmen, [number withheld] heruntergeladen, [number withheld] fehlend (`t061_failure_by_sector.csv`, Assert auf [number withheld] im Skript).
  - Überschneidungen mit der Entwickler-Panel-Firmenliste sind per Assert ausgeschlossen (Zeile [number withheld]).
  - Die Zeilen- und Datumsstruktur ist balanciert (Zeile [number withheld]).
  - Pre: [number withheld] Beobachtungen und [number withheld] Firmen. Post: [number withheld] und [number withheld] (`t061_support.csv`). Das passt zu [number withheld] bzw. [number withheld] Daten × [number withheld].
  - Die [number withheld] balancierten Entwickler sind per Assert fixiert und stimmen mit dem T058-Referenzwert überein (Zeile [number withheld]–[number withheld]).
- **Filter und Ausschlüsse:**
  - Jede Regel steht in `t061_cleaning_rules.csv`, kein stiller Ausschluss. Werte außerhalb von [[number withheld]; [number withheld]] bleiben in N und fehlen nur im Fit.
  - Alle [number withheld] Fenster- und Fit-Bin-Ausschlüsse sind im Code nachvollziehbar.
  - Mass-Fenster und Fit-Ausschluss sind getrennt: [number withheld] Bins für die Masse, bei den Placebos [number withheld] Bins im Fit (Zeile [number withheld]–[number withheld]). Das folgt `06_bunching_tests.R:408–420`.
  - Die Randpunkte stimmen: Fenster [[number withheld]; [number withheld]) mit Bin-Mitten [number withheld] bis [number withheld], die letzte Bin enthält [number withheld], und die Gleitkomma-Toleranz ist gesetzt.
- **Merges und Duplikate:**
  - Die Schlüssel `code × date` sind per Assert eindeutig (Zeile [number withheld]).
  - Die Zuordnung `board` ↔ Roster wird geprüft (Zeile [number withheld]).
  - `firm_id`-Suffixe (.SH, .SZ, .BJ) richten sich nach dem Code-Präfix.
- **Fehlende Werte:** Imputation nur bei Vorauszahlungen und geflaggt. Aktiva und Verbindlichkeiten bleiben NA (hier ohne Fälle). Kein Winsorizing, kein Trimmen.
- **Reproduktion der Entwicklerwerte:** belegt im Code (Assert Zeile [number withheld] auf [number withheld] / [number withheld] / [number withheld] vor jeder Kontrollschätzung). Der Bericht nennt [number withheld] / [number withheld] / [number withheld].
- **Eigentümerdaten (Schritt [number withheld]):** korrekt als nicht verfügbar behandelt. Panel, manuelle Kodierung und Wind ergeben [number withheld] Treffer (`t061_ownership_availability.csv`), und es wird nichts aus Firmennamen abgeleitet.
- **Kriterium [number withheld] (MANIFEST):** erfüllt, soweit meine Rolle reicht. Quelle, Datum und sha2[number withheld] sind eingetragen, und das Skript prüft Hash und Größe aller Dateien (Zeile [number withheld]–[number withheld]). Die Datumsunsicherheit ist offen markiert (Befund [number withheld]).
- **Kriterium [number withheld] (Reproduktion/Byte-Identität) und Kriterium [number withheld] (alle Varianten mit N und Support):**
  - Datenseitig belegt: Es gibt sechs Schätzzeilen mit N, Firmen und Fenster-Support sowie ein Low-Support-Flag (Schwelle [number withheld], kein Flag gesetzt; Support [number withheld]/[number withheld], [number withheld]/[number withheld], [number withheld]/[number withheld]).
  - Die Byte-Identität bewerte ich nicht (nicht meine Rolle).
- **Schätzung, Bootstrap-Logik, Text, Figur (Schritt [number withheld]):** nicht meine Rolle.

## Nicht geprüft

- Ich konnte keine Befehle ausführen. Der Lauf, die Byte-Identität und die Hashes sind daher nur aus Code und Bericht übernommen, nicht selbst nachvollzogen.
- Die Rohdaten (`control_a_balance_sina.csv` und die Sina-Listen) habe ich nicht Zeile für Zeile gegen die EastMoney-Quelle geprüft. Das ist offline nicht möglich.
- Ob die [number withheld] Download-Ausfälle zufällig oder systematisch sind (Survivor-Selektion), ist Sache der Forschungsdesign-Bewertung. Die Ursachen sind nicht rekonstruierbar, und der Worker kennzeichnet das offen.
- Die Behauptung zu SOE-Warnlinien seit [number withheld] ist nicht geprüft.
- Das Layout der PDFs habe ich nicht angesehen.
