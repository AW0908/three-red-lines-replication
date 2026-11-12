## Rolle: consistency (claude, sonnet) – VERDICT: REWORK


## Befunde

1. **Bericht, Kriterium 5, letzter Absatz, nennt die `verified`-Zeilen der kompakten Tabelle falsch.**
[firm-specific excerpt withheld in public audit]
   - `t044_pilot_coding.tex` und `t044_pilot_coding.csv` zeigen drei Zeilen mit `verified`:
[firm-specific excerpt withheld in public audit]
[firm-specific excerpt withheld in public audit]
[firm-specific excerpt withheld in public audit]
[firm-specific excerpt withheld in public audit]
   - Beheben: Bericht korrigieren, ohne Neulauf.

2. **Offene Frage 4 des Berichts nennt einen Mangel, den Rework 4 nicht behebt.** Die CSV-Spalten `cash_D/G/E/U` der Magnitude-Tabelle tragen den Hinweis „0 = keine belegte Zuordnung, nicht keine Finanzierung“ nicht selbst. Der Bericht legt das offen und stellt es ausdrücklich außerhalb von Rework 4. Das ist kein Konsistenzfehler. Der Hinweis steht nur im TeX (Zeile „Unallocated zeros …“), nicht in der CSV, in der die Nullen auch stehen. Niedrige Priorität.

Alle übrigen Zahlen stimmen mit den Outputs überein:
[firm-specific excerpt withheld in public audit]
[firm-specific excerpt withheld in public audit]
[firm-specific excerpt withheld in public audit]
- **Zuordnungssumme:** Kapital von NCI über neun Firmen 108344,69 Mio.; zugeordnet 3500,00 Mio. (3,23 %), nicht zugeordnet 104844,69 Mio. (96,77 %). Das stimmt mit `t044_attribution_totals.csv`, Log und Bericht überein.
- **Gruppenzahlen:** Die Gruppenzahlen je Firma im Fenster (19, 14, 3, 7, 5, 3, 4, 5, 30, 27; zusammen 117) stimmen in `t044_firm_summaries.txt`, in der TeX-Tabelle (N, Rows, Bound.-unc.) und im Bericht überein. Zusammen mit den 28 datumsunsicheren Gruppen ergeben sich die 145 Gruppen des Logs.
[firm-specific excerpt withheld in public audit]
- **Rework-4-Punkt 2:** Die Transaktion 农华智慧 (`case_notes.md` L67–L70, Januar 2019) hat keine Zeile in den Zählungen. Der Bericht stellt sie getrennt dar und führt sie in der Pending-Liste. Die Prüfstichprobe hat 17 Zeilen: 12 D/G/H-Zeilen im Fenster (T033-006-01, T033-005-02/-03, T033-004-02/-03, T033-076-01, T033-074-01, T033-088-01, T033-083-01, T033-177-01, T033-140-01, T033-262-01) und 5 U-Zeilen.
- **Pending-Liste:** 28 Aussagen. Das stimmt mit `t044_pending_statements.csv` (29 Zeilen mit Kopf) und der Aufzählung nach Zeilen im Bericht überein: 1 + 5 + 6 + 5 + 4 + 4 + 3.
- **Läufe:** Die Logs sind per `cmp` identisch. `t044_reproducibility.csv` weist 19 Dateien aus.
[firm-specific excerpt withheld in public audit]

## Abnahmekriterien

1. Datei und Seite je Merkmal und Betrag, Stichprobe:
   - Konsistenz von Bericht und Check-Sample belegt (Seed 20261028, 17 Zeilen, alle D/G/H im Fenster plus 5 U).
   - Der Abgleich mit den PDF-Seiten gehört nicht zu meiner Rolle.
2. Rubrik wie geschrieben: nicht meine Rolle. Die Subtypen und Kategorien stimmen zwischen Check-Sample, Zusammenfassung und Tabelle überein.
3. Bestehende Zeilen byte-identisch: nicht meine Rolle. Der Bericht verweist auf die Integritätsprüfung im Skript; die Prüfsummen habe ich nicht neu berechnet.
4. Zwei Läufe identisch, Zerlegung geht auf: belegt erfüllt. Die Logs sind gleich, die Hash-Tabelle weist 19/19 aus, und die Identität habe ich für alle vollständigen Zeilen nachgerechnet.
5. Offene Aussagen gelistet, nichts Unverifiziertes als verifiziert: **teilweise erfüllt.**
   - Die Liste stimmt, und die Zeilen der Magnitude-Tabelle stehen alle auf `unverified`.
   - Die Beschreibung der verifizierten Zeilen der kompakten Tabelle ist unvollständig (Befund 1).

## Nicht geprüft

- Der Textabgleich mit den PDFs (65 Evidence-Checks, 17-Zeilen-Stichprobe) und die Korrektheit von Codierung, Rubrikanwendung und Daten. Das liegt bei den anderen Rollen.
- `case_notes.md` und `case_notes_verification.csv` habe ich nur stichprobenhaft gelesen (L60–L72). Die Byte-Identität der ursprünglichen Zeilen habe ich nicht selbst geprüft.
- Das Skript selbst habe ich nicht ausgeführt und nicht gelesen. Die Konsistenz der Zahlen habe ich an den erzeugten Dateien geprüft.
- Die Zeilennummern der 28 Pending-Aussagen habe ich nur anhand der Spalte `line` in `t044_pending_statements.csv` abgeglichen, nicht gegen `case_notes.md`.
- Eine Folgekonsistenz mit `proposal/` entfällt, weil T044 dort noch keinen Text liefert.
