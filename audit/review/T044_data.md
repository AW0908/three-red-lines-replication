## Rolle: data (claude, sonnet) – VERDICT: PASS


Ich habe nur die Datenaufbereitung geprüft. Ich habe keine PDFs gelesen, weil `pdftotext` und Python in dieser Sitzung gesperrt waren.

## Befunde
Keiner dieser Befunde ändert eine Kategorie oder eine Zahl der Tabellen.

[firm-specific excerpt withheld in public audit]
   - Der Auszug in `pilot_coding.csv` (S. 6) lautet: „绿城房产退出…将其持有的目标公司35%股权转让给本公司“. Er nennt keine Pflicht.
   - Die PI-verifizierte Aussage G6 (`case_notes.md` L105, in der Verifikationsdatei Zeile 53 auf Stufe meaning) sagt: „No fixed return or fixed buyback price is stated“.
   - Damit stützt die Codierung D auf eine Auslegung der Rubrik („mandatory“), nicht auf einen Wortlaut. Die Notiz in der Zeile und Offene Frage 3 im Bericht weisen darauf hin. Der PI hat D mit Subtyp D2 in Rework 2 und 3 ausdrücklich so entschieden. Ich werte das nicht als Fehler, aber die Kategorie braucht die Bestätigung des PI. In der Auswertung sollten es die Kategorien „D (Rubrik)“ und „PI-verifizierte Aussagen G1–G8“ nebeneinander stehen.

2. **Merkmale „not stated“, obwohl PI-verifizierte Aussagen sie belegen (T033-088-01).**
   - `substantial_minority_loans` steht auf „not stated“. L106 (verifiziert, S. 7) sagt, ein Teil der Zahlung sei ein Darlehen von Greentown.
   - `unrelated_prorata` steht auf „not stated“. L102 und L104 (verifiziert) nennen die 65:35-Teilung von Risiken, Gewinnen und Verlusten.
   - `minority_ownership_before/after` ist leer, obwohl der Anteil 35 % ist.
   - Die Kategorie D steht davor in der Rubrikreihenfolge, deshalb ändert sich nichts. Die Feldmatrix ist an diesen Stellen aber unvollständig.

3. **Nullen in `cash_D/G/E/U`.**
   - Sie bedeuten „keine belegte Zahlungszuordnung“. Die CSV trägt diesen Hinweis nicht selbst; nur die TeX-Notiz sagt es. Der Bericht räumt das ein (Offene Frage 4).

4. **Anteile bei ΔMI < 0.**
[firm-specific excerpt withheld in public audit]

5. **Die 150 Zeilen sind unterschiedlich belastbar.**
[firm-specific excerpt withheld in public audit]

## Abnahmekriterien
Soweit meine Rolle sie berührt:

1. **Datei und Seite je Merkmal und Betrag; Stichprobe:** belegt erfüllt, soweit ich es aus den Ausgaben prüfen konnte.
   - `t044_evidence_checks.csv` hat 65 Zeilen mit Datei, Seite, Auszug und `TRUE`, zum Beispiel für alle vier 海川-Beträge (4.950,25 / 49,75 / 19.800,995 / 199,005 Mio. RMB, S. 5, Summe 25 Mrd.).
   - Die Stichprobe in `t044_check_sample.csv` hat 17 Zeilen: alle D-, G- und H-Zeilen im Fenster plus 5 zufällige U. Das folgt Rework 2.
[firm-specific excerpt withheld in public audit]
   - Den Abgleich mit den PDFs selbst habe ich nicht wiederholt.
2. **Rubrik wie geschrieben:** überwiegend erfüllt, mit den Anmerkungen 1 und 2.
   - T033-006-01 ist D wegen Investor-Put (S. 5), Subtyp D2.
   - T033-083-01 ist D wegen Investor-Exit (S. 6), Subtyp D-unspecified.
   - T033-140-01 ist H. Die Call-Option der Emittentin zum Festpreis steht mit Seite und Auszug in `issuer_call_preset_price`; `preset_exit_not_project_value` = no mit S. 3 bzw. 5. Das entspricht der PI-Entscheidung aus Rework 3.
[firm-specific excerpt withheld in public audit]
3. **Bestehende Zeilen unverändert:** belegt erfüllt.
   - `t044_input_integrity_checks.csv`: Der Präfix von `case_notes.md` (14.612 Byte) hat den gespeicherten SHA-256.
   - Die 46 ursprünglichen Zeilen der Verifikationsdatei sind per ID und Text erhalten; Metadaten haben nur PI-Updates.
   - `nci_cashflow.csv`, `pilot_purposive.csv`, Panel und `transactions.csv` sind unverändert (SHA-256 gleich).
[firm-specific excerpt withheld in public audit]
4. **Zwei Läufe identisch; Zerlegung geht auf:** belegt erfüllt, soweit prüfbar.
   - `t044_reproducibility.csv` zeigt für die Dateien gleiche Hashes in beiden Läufen.
   - Ich habe fünf Residuen nachgerechnet; alle stimmen:
[firm-specific excerpt withheld in public audit]
[firm-specific excerpt withheld in public audit]
[firm-specific excerpt withheld in public audit]
[firm-specific excerpt withheld in public audit]
   - Die Eingaben stimmen mit `nci_cashflow.csv` überein, auch die Vorzeichen bei HK-Klammerwerten.
   - Den Lauf selbst habe ich nicht wiederholt.
5. **Offene Aussagen gelistet:** belegt erfüllt. `t044_pending_statements.csv` hat 28 Zeilen und der Bericht listet sie nach Zeilen in `case_notes.md`. Alle Firmenzeilen in `t044_magnitude.csv` stehen auf `unverified`, außer Teilkomponenten mit PI-Status.

Datenspezifisch:
[firm-specific excerpt withheld in public audit]
[firm-specific excerpt withheld in public audit]
[firm-specific excerpt withheld in public audit]
[firm-specific excerpt withheld in public audit]
- **Die restlichen Kriterien** (Schreibbereich, Text, Konsistenz mit Gleichungen) sind nicht meine Rolle.

## Nicht geprüft
- **PDF-Seiten:** `pdftotext`, Python und Lesen von PDFs waren gesperrt. Ich stütze mich auf `t044_evidence_checks.csv`, in dem das Skript Auszug und Seite automatisch abgleicht. Ob die 17 Stichprobenzeilen mit den Seiten übereinstimmen, habe ich nicht selbst gesehen; der Bericht räumt ein, dass der Worker sie in Rework 4 nicht erneut gelesen hat.
- **Skript:** Die 1.296 Zeilen von `16_pilot_magnitude.R` habe ich nur stichprobenartig gelesen, nicht Zeile für Zeile.
[firm-specific excerpt withheld in public audit]
[firm-specific excerpt withheld in public audit]
- **Wirkung von Nenner ≤ 0:** Die Prüfung der Formeln der Anteile (zum Beispiel Verhalten bei ΔMI nahe null) habe ich nicht an Randfällen getestet.
