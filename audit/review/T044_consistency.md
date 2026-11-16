## Rolle: consistency (claude, sonnet) – VERDICT: REWORK


## Befunde

[number withheld]. **Bericht, Kriterium [number withheld], letzter Absatz, nennt die `verified`-Zeilen der kompakten Tabelle falsch.**
[firm-specific excerpt withheld in public process copy]
   - `t044_pilot_coding.tex` und `t044_pilot_coding.csv` zeigen drei Zeilen mit `verified`:
[firm-specific excerpt withheld in public process copy]
[firm-specific excerpt withheld in public process copy]
[firm-specific excerpt withheld in public process copy]
[firm-specific excerpt withheld in public process copy]
   - Beheben: Bericht korrigieren, ohne Neulauf.

[number withheld]. **Offene Frage [number withheld] des Berichts nennt einen Mangel, den Rework [number withheld] nicht behebt.** Die CSV-Spalten `cash_D/G/E/U` der Magnitude-Tabelle tragen den Hinweis „[number withheld] = keine belegte Zuordnung, nicht keine Finanzierung“ nicht selbst. Der Bericht legt das offen und stellt es ausdrücklich außerhalb von Rework [number withheld]. Das ist kein Konsistenzfehler. Der Hinweis steht nur im TeX (Zeile „Unallocated zeros …“), nicht in der CSV, in der die Nullen auch stehen. Niedrige Priorität.

Alle übrigen Zahlen stimmen mit den Outputs überein:
[firm-specific excerpt withheld in public process copy]
[firm-specific excerpt withheld in public process copy]
[firm-specific excerpt withheld in public process copy]
- **Zuordnungssumme:** Kapital von NCI über neun Firmen [number withheld] Mio.; zugeordnet [number withheld] Mio. ([number withheld] %), nicht zugeordnet [number withheld] Mio. ([number withheld] %). Das stimmt mit `t044_attribution_totals.csv`, Log und Bericht überein.
- **Gruppenzahlen:** Die Gruppenzahlen je Firma im Fenster ([number withheld], [number withheld], [number withheld], [number withheld], [number withheld], [number withheld], [number withheld], [number withheld], [number withheld], [number withheld]; zusammen [number withheld]) stimmen in `t044_firm_summaries.txt`, in der TeX-Tabelle (N, Rows, Bound.-unc.) und im Bericht überein. Zusammen mit den [number withheld] datumsunsicheren Gruppen ergeben sich die [number withheld] Gruppen des Logs.
[firm-specific excerpt withheld in public process copy]
- **Rework-[number withheld]-Punkt [number withheld]:** Die Transaktion 农华智慧 (`case_notes.md` L6[number withheld]–L7[number withheld], Januar [number withheld]) hat keine Zeile in den Zählungen. Der Bericht stellt sie getrennt dar und führt sie in der Pending-Liste. Die Prüfstichprobe hat [number withheld] Zeilen: [number withheld] D/G/H-Zeilen im Fenster (T033[number withheld][number withheld], T033[number withheld][number withheld]/[number withheld], T033[number withheld][number withheld]/[number withheld], T033[number withheld][number withheld], T033[number withheld][number withheld], T033[number withheld][number withheld], T033[number withheld][number withheld], T033[number withheld][number withheld], T033[number withheld][number withheld], T033[number withheld][number withheld]) und [number withheld] U-Zeilen.
- **Pending-Liste:** [number withheld] Aussagen. Das stimmt mit `t044_pending_statements.csv` ([number withheld] Zeilen mit Kopf) und der Aufzählung nach Zeilen im Bericht überein: [number withheld] + [number withheld] + [number withheld] + [number withheld] + [number withheld] + [number withheld] + [number withheld].
- **Läufe:** Die Logs sind per `cmp` identisch. `t044_reproducibility.csv` weist [number withheld] Dateien aus.
[firm-specific excerpt withheld in public process copy]

## Abnahmekriterien

[number withheld]. Datei und Seite je Merkmal und Betrag, Stichprobe:
   - Konsistenz von Bericht und Check-Sample belegt (Seed [number withheld], [number withheld] Zeilen, alle D/G/H im Fenster plus [number withheld] U).
   - Der Abgleich mit den PDF-Seiten gehört nicht zu meiner Rolle.
[number withheld]. Rubrik wie geschrieben: nicht meine Rolle. Die Subtypen und Kategorien stimmen zwischen Check-Sample, Zusammenfassung und Tabelle überein.
[number withheld]. Bestehende Zeilen byte-identisch: nicht meine Rolle. Der Bericht verweist auf die Integritätsprüfung im Skript; die Prüfsummen habe ich nicht neu berechnet.
[number withheld]. Zwei Läufe identisch, Zerlegung geht auf: belegt erfüllt. Die Logs sind gleich, die Hash-Tabelle weist [number withheld]/[number withheld] aus, und die Identität habe ich für alle vollständigen Zeilen nachgerechnet.
[number withheld]. Offene Aussagen gelistet, nichts Unverifiziertes als verifiziert: **teilweise erfüllt.**
   - Die Liste stimmt, und die Zeilen der Magnitude-Tabelle stehen alle auf `unverified`.
   - Die Beschreibung der verifizierten Zeilen der kompakten Tabelle ist unvollständig (Befund [number withheld]).

## Nicht geprüft

- Der Textabgleich mit den PDFs ([number withheld] Evidence-Checks, [number withheld]-Zeilen-Stichprobe) und die Korrektheit von Codierung, Rubrikanwendung und Daten. Das liegt bei den anderen Rollen.
- `case_notes.md` und `case_notes_verification.csv` habe ich nur stichprobenhaft gelesen (L6[number withheld]–L7[number withheld]). Die Byte-Identität der ursprünglichen Zeilen habe ich nicht selbst geprüft.
- Das Skript selbst habe ich nicht ausgeführt und nicht gelesen. Die Konsistenz der Zahlen habe ich an den erzeugten Dateien geprüft.
- Die Zeilennummern der [number withheld] Pending-Aussagen habe ich nur anhand der Spalte `line` in `t044_pending_statements.csv` abgeglichen, nicht gegen `case_notes.md`.
- Eine Folgekonsistenz mit `proposal/` entfällt, weil T044 dort noch keinen Text liefert.
