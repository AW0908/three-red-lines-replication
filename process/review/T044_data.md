## Rolle: data (claude, sonnet) – VERDICT: PASS


Ich habe nur die Datenaufbereitung geprüft. Ich habe keine PDFs gelesen, weil `pdftotext` und Python in dieser Sitzung gesperrt waren.

## Befunde
Keiner dieser Befunde ändert eine Kategorie oder eine Zahl der Tabellen.

[firm-specific excerpt withheld in public process copy]
   - Der Auszug in `pilot_coding.csv` (S. [number withheld]) lautet: „绿城房产退出…将其持有的目标公司[number withheld]%股权转让给本公司“. Er nennt keine Pflicht.
   - Die PI-verifizierte Aussage G6 (`case_notes.md` L1[number withheld], in der Verifikationsdatei Zeile [number withheld] auf Stufe meaning) sagt: „No fixed return or fixed buyback price is stated“.
   - Damit stützt die Codierung D auf eine Auslegung der Rubrik („mandatory“), nicht auf einen Wortlaut. Die Notiz in der Zeile und Offene Frage [number withheld] im Bericht weisen darauf hin. Der PI hat D mit Subtyp D2 in Rework [number withheld] und [number withheld] ausdrücklich so entschieden. Ich werte das nicht als Fehler, aber die Kategorie braucht die Bestätigung des PI. In der Auswertung sollten es die Kategorien „D (Rubrik)“ und „PI-verifizierte Aussagen G1–G8“ nebeneinander stehen.

[number withheld]. **Merkmale „not stated“, obwohl PI-verifizierte Aussagen sie belegen (T033[number withheld][number withheld]).**
   - `substantial_minority_loans` steht auf „not stated“. L1[number withheld] (verifiziert, S. [number withheld]) sagt, ein Teil der Zahlung sei ein Darlehen von Greentown.
   - `unrelated_prorata` steht auf „not stated“. L1[number withheld] und L1[number withheld] (verifiziert) nennen die [number withheld]:[number withheld]-Teilung von Risiken, Gewinnen und Verlusten.
   - `minority_ownership_before/after` ist leer, obwohl der Anteil [number withheld] % ist.
   - Die Kategorie D steht davor in der Rubrikreihenfolge, deshalb ändert sich nichts. Die Feldmatrix ist an diesen Stellen aber unvollständig.

[number withheld]. **Nullen in `cash_D/G/E/U`.**
   - Sie bedeuten „keine belegte Zahlungszuordnung“. Die CSV trägt diesen Hinweis nicht selbst; nur die TeX-Notiz sagt es. Der Bericht räumt das ein (Offene Frage [number withheld]).

[number withheld]. **Anteile bei ΔMI < [number withheld].**
[firm-specific excerpt withheld in public process copy]

[number withheld]. **Die [number withheld] Zeilen sind unterschiedlich belastbar.**
[firm-specific excerpt withheld in public process copy]

## Abnahmekriterien
Soweit meine Rolle sie berührt:

[number withheld]. **Datei und Seite je Merkmal und Betrag; Stichprobe:** belegt erfüllt, soweit ich es aus den Ausgaben prüfen konnte.
   - `t044_evidence_checks.csv` hat [number withheld] Zeilen mit Datei, Seite, Auszug und `TRUE`, zum Beispiel für alle vier 海川-Beträge ([number withheld] / [number withheld] / [number withheld] / [number withheld] Mio. RMB, S. [number withheld], Summe [number withheld] Mrd.).
   - Die Stichprobe in `t044_check_sample.csv` hat [number withheld] Zeilen: alle D-, G- und H-Zeilen im Fenster plus [number withheld] zufällige U. Das folgt Rework [number withheld].
[firm-specific excerpt withheld in public process copy]
   - Den Abgleich mit den PDFs selbst habe ich nicht wiederholt.
[number withheld]. **Rubrik wie geschrieben:** überwiegend erfüllt, mit den Anmerkungen [number withheld] und [number withheld].
   - T033[number withheld][number withheld] ist D wegen Investor-Put (S. [number withheld]), Subtyp D2.
   - T033[number withheld][number withheld] ist D wegen Investor-Exit (S. [number withheld]), Subtyp D-unspecified.
   - T033[number withheld][number withheld] ist H. Die Call-Option der Emittentin zum Festpreis steht mit Seite und Auszug in `issuer_call_preset_price`; `preset_exit_not_project_value` = no mit S. [number withheld] bzw. [number withheld]. Das entspricht der PI-Entscheidung aus Rework [number withheld].
[firm-specific excerpt withheld in public process copy]
[number withheld]. **Bestehende Zeilen unverändert:** belegt erfüllt.
   - `t044_input_integrity_checks.csv`: Der Präfix von `case_notes.md` ([number withheld] Byte) hat den gespeicherten SHA-[number withheld].
   - Die [number withheld] ursprünglichen Zeilen der Verifikationsdatei sind per ID und Text erhalten; Metadaten haben nur PI-Updates.
   - `nci_cashflow.csv`, `pilot_purposive.csv`, Panel und `transactions.csv` sind unverändert (SHA-[number withheld] gleich).
[firm-specific excerpt withheld in public process copy]
[number withheld]. **Zwei Läufe identisch; Zerlegung geht auf:** belegt erfüllt, soweit prüfbar.
   - `t044_reproducibility.csv` zeigt für die Dateien gleiche Hashes in beiden Läufen.
   - Ich habe fünf Residuen nachgerechnet; alle stimmen:
[firm-specific excerpt withheld in public process copy]
[firm-specific excerpt withheld in public process copy]
[firm-specific excerpt withheld in public process copy]
[firm-specific excerpt withheld in public process copy]
   - Die Eingaben stimmen mit `nci_cashflow.csv` überein, auch die Vorzeichen bei HK-Klammerwerten.
   - Den Lauf selbst habe ich nicht wiederholt.
[number withheld]. **Offene Aussagen gelistet:** belegt erfüllt. `t044_pending_statements.csv` hat [number withheld] Zeilen und der Bericht listet sie nach Zeilen in `case_notes.md`. Alle Firmenzeilen in `t044_magnitude.csv` stehen auf `unverified`, außer Teilkomponenten mit PI-Status.

Datenspezifisch:
[firm-specific excerpt withheld in public process copy]
[firm-specific excerpt withheld in public process copy]
[firm-specific excerpt withheld in public process copy]
[firm-specific excerpt withheld in public process copy]
- **Die restlichen Kriterien** (Schreibbereich, Text, Konsistenz mit Gleichungen) sind nicht meine Rolle.

## Nicht geprüft
- **PDF-Seiten:** `pdftotext`, Python und Lesen von PDFs waren gesperrt. Ich stütze mich auf `t044_evidence_checks.csv`, in dem das Skript Auszug und Seite automatisch abgleicht. Ob die [number withheld] Stichprobenzeilen mit den Seiten übereinstimmen, habe ich nicht selbst gesehen; der Bericht räumt ein, dass der Worker sie in Rework [number withheld] nicht erneut gelesen hat.
- **Skript:** Die [number withheld] Zeilen von `16_pilot_magnitude.R` habe ich nur stichprobenartig gelesen, nicht Zeile für Zeile.
[firm-specific excerpt withheld in public process copy]
[firm-specific excerpt withheld in public process copy]
- **Wirkung von Nenner ≤ [number withheld]:** Die Prüfung der Formeln der Anteile (zum Beispiel Verhalten bei ΔMI nahe null) habe ich nicht an Randfällen getestet.
