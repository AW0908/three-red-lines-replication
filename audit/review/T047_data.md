## Rolle: data (claude, sonnet) – VERDICT: PASS


## Befunde

Keine inhaltlichen Datenfehler gefunden. Nebenbefunde, keiner davon blockierend:

[number withheld]. **Money-Pools sind strikt NA.** `18_crossers_coding.R:303-308` bildet die Pools über alle [number withheld] Ereignisse bzw. [number withheld] Firmen mit `strict_sum`. Fehlt bei einer Firma eine Komponente, ist der ganze Pool NA. Das ist nach Rework [number withheld] Punkt [number withheld] gewollt und korrekt. Die belastbare Gesamtzahl ist damit nur die Teilabdeckungs-Headline (`t047_attribution_totals.csv`: [number withheld] von [number withheld] beobachtete Firmenjahre, [number withheld] Mio. RMB NCI-Kapital, [number withheld] Mio. zugeordnet). Die Headline ist im CSV (Spalte `note`) und im TeX-Fußtext als Teilabdeckung markiert.
[firm-specific excerpt withheld in public process copy]
[firm-specific excerpt withheld in public process copy]
[firm-specific excerpt withheld in public process copy]

## Abnahmekriterien (soweit Datenrolle)

[number withheld]. **Feature-, Betrags-, Datei-, Seiten- und Auszugbelege: belegt erfüllt.** `18_crossers_coding.R:88-140` erzwingt Datei, Seite und Auszug für jedes Merkmal ungleich „not stated“ und für jeden Betrag. Jeder Auszug wird per `pdftotext` gegen die physische Seite geprüft und ist Pflicht (`stopifnot(all(evidence_check$text_match))`). Laut Bericht [number withheld] von [number withheld] PASS.
[number withheld]. **Check-Stichprobe: belegt erfüllt.** `check_sample.csv` enthält alle D/G/H-Zeilen und [number withheld] zufällige U-Zeilen mit festem Seed. `check_sample_review.csv` muss laut Zeile [number withheld] vollständig PASS sein.
[number withheld]. **Rubrik exakt wie T044: belegt erfüllt.** Die Kategorie wird in den Zeilen [number withheld][number withheld] aus den Merkmalen neu berechnet und mit `category` verglichen. Der D-Untertyp folgt aus den Merkmalen (Zeilen [number withheld][number withheld]), ohne ID- oder Text-Ausnahmen. `h_features` enthält `issuer_call_preset_price` nach Rework [number withheld].
[number withheld]. **Fensterlogik und Sample: belegt erfüllt.** Die Zeilen [number withheld][number withheld] prüfen per `stopifnot` genau [number withheld] Ereignisse, [number withheld] Firmen, [number withheld] exakte Pilotfenster und [number withheld] neu kodierte Ereignisse. `fy0` und `fy1` sind für Halbjahresenden korrekt (z. B. date0 2021-06-30 ergibt fy0 [number withheld]). Mehrfach-Ereignis-Firmen nutzen die Jahresvereinigung, sodass kein Geschäftsjahr doppelt zählt (Zeile [number withheld]).
[number withheld]. **Merges und Dubletten: belegt erfüllt.** Transaktions-IDs sind eindeutig (Zeilen [number withheld], [number withheld]). Der Operanden-Lookup verlangt genau eine Zeile (`nrow(z)==[number withheld]L`). Für bezahlte Beträge gibt es einen Dublettencheck (Zeile [number withheld]).
[number withheld]. **NA statt [number withheld] (Rework [number withheld]): belegt erfüllt.** Bei fehlendem Kapital sind alle `cash_*`-Spalten NA (Zeilen [number withheld], [number withheld]). Die Pools nutzen `strict_sum`. `allocation_checks.csv` hat [number withheld] geprüfte Zeilen, Bedingung `missing_ok`.
[firm-specific excerpt withheld in public process copy]
[number withheld]. **Verifikationslabel `cash_not_attributed` (Rework [number withheld]): belegt erfüllt.** Zeilen [number withheld][number withheld] verlangen: Kapital verifiziert, Zuordnung verifiziert, alle Kategoriegruppen des Firmenfensters verifiziert. Eine leere Zuordnung zählt immer als unverifiziert (Zeile [number withheld]). Das Bestehen ist per `stopifnot` in `remainder_ok` erzwungen.
[firm-specific excerpt withheld in public process copy]
[firm-specific excerpt withheld in public process copy]
[firm-specific excerpt withheld in public process copy]
[number withheld]. **Fensterhinweis (Rework [number withheld]) und TeX-Labels (Rework [number withheld]): belegt erfüllt.** Beide stehen in den Zeilen [number withheld] und [number withheld]. Die Einheit „RMB million“ und die Residual-Formel sind in beiden Texten definiert.
[number withheld]. **Zwei Läufe byte-identisch, Zerlegung geschlossen:** Die Zerlegung ist im Code geprüft (Zeile [number withheld], Abweichung unter [number withheld] für vollständige Firmen). Die Byte-Identität ist nur über `two_run_checks.csv` und `run1/run2_hashes.csv` angegeben, die ich nicht nachgerechnet habe. Siehe „Nicht geprüft“.
[number withheld]. **Kein unverifizierter Wert als verifiziert: belegt erfüllt.** `verified()` bindet an PI-Zeile, aktuellen Text und Level. Eine leere ID-Menge ergibt unverifiziert. Das Label ändert sich nur über Statement-Zeilen mit `status=yes`, `verified_by=PI` und passendem Text.
[number withheld]. **Integrität geschützter Dateien (Kriterium [number withheld]):** Nach der Rework-Regel zeilenweise geprüft (Zeilen [number withheld][number withheld]). Die Karte und `component_sources_input.csv` laufen über dokumentierte Overrides.

Nicht meine Rolle: Schätzung, Text-Konsistenz und Sprache.

## Nicht geprüft

- Ich konnte keine Befehle ausführen (Bash verweigert). Der Rscript-Lauf, die Byte-Identität der beiden Läufe und die Hashes (`two_run_checks.csv`) sind deshalb nicht von mir reproduziert worden.
- PDF-Seiten und Auszüge habe ich nicht selbst gegen die Originale geprüft, außer über die Konsistenz der Ledger-Zeilen. Das gilt auch für die [number withheld] Textmatches und die [number withheld] Stichprobenzeilen.
[firm-specific excerpt withheld in public process copy]
- Die inhaltliche Kodierung der einzelnen Transaktionen (Rubrik-Entscheidungen jenseits der Formelprüfung) liegt außerhalb meiner Rolle.
- Eine Zeilenzählung der Rohdaten (z. B. alle [number withheld] Verifikationszeilen) habe ich nicht nachgerechnet.
