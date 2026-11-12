## Rolle: data (claude, sonnet) – VERDICT: PASS


## Befunde

Keine inhaltlichen Datenfehler gefunden. Nebenbefunde, keiner davon blockierend:

1. **Money-Pools sind strikt NA.** `18_crossers_coding.R:303-308` bildet die Pools über alle 33 Ereignisse bzw. 31 Firmen mit `strict_sum`. Fehlt bei einer Firma eine Komponente, ist der ganze Pool NA. Das ist nach Rework 1 Punkt 2 gewollt und korrekt. Die belastbare Gesamtzahl ist damit nur die Teilabdeckungs-Headline (`t047_attribution_totals.csv`: 20 von 33 beobachtete Firmenjahre, 190.538 Mio. RMB NCI-Kapital, 416,0 Mio. zugeordnet). Die Headline ist im CSV (Spalte `note`) und im TeX-Fußtext als Teilabdeckung markiert.
[firm-specific excerpt withheld in public audit]
[firm-specific excerpt withheld in public audit]
[firm-specific excerpt withheld in public audit]

## Abnahmekriterien (soweit Datenrolle)

1. **Feature-, Betrags-, Datei-, Seiten- und Auszugbelege: belegt erfüllt.** `18_crossers_coding.R:88-140` erzwingt Datei, Seite und Auszug für jedes Merkmal ungleich „not stated“ und für jeden Betrag. Jeder Auszug wird per `pdftotext` gegen die physische Seite geprüft und ist Pflicht (`stopifnot(all(evidence_check$text_match))`). Laut Bericht 199 von 199 PASS.
2. **Check-Stichprobe: belegt erfüllt.** `check_sample.csv` enthält alle D/G/H-Zeilen und 5 zufällige U-Zeilen mit festem Seed. `check_sample_review.csv` muss laut Zeile 160 vollständig PASS sein.
3. **Rubrik exakt wie T044: belegt erfüllt.** Die Kategorie wird in den Zeilen 76-82 aus den Merkmalen neu berechnet und mit `category` verglichen. Der D-Untertyp folgt aus den Merkmalen (Zeilen 84-86), ohne ID- oder Text-Ausnahmen. `h_features` enthält `issuer_call_preset_price` nach Rework 3.
4. **Fensterlogik und Sample: belegt erfüllt.** Die Zeilen 24-32 prüfen per `stopifnot` genau 33 Ereignisse, 31 Firmen, 6 exakte Pilotfenster und 27 neu kodierte Ereignisse. `fy0` und `fy1` sind für Halbjahresenden korrekt (z. B. date0 2021-06-30 ergibt fy0 2020). Mehrfach-Ereignis-Firmen nutzen die Jahresvereinigung, sodass kein Geschäftsjahr doppelt zählt (Zeile 293).
5. **Merges und Dubletten: belegt erfüllt.** Transaktions-IDs sind eindeutig (Zeilen 20, 36). Der Operanden-Lookup verlangt genau eine Zeile (`nrow(z)==1L`). Für bezahlte Beträge gibt es einen Dublettencheck (Zeile 257).
6. **NA statt 0 (Rework 1.2): belegt erfüllt.** Bei fehlendem Kapital sind alle `cash_*`-Spalten NA (Zeilen 274, 278). Die Pools nutzen `strict_sum`. `allocation_checks.csv` hat 92 geprüfte Zeilen, Bedingung `missing_ok`.
[firm-specific excerpt withheld in public audit]
8. **Verifikationslabel `cash_not_attributed` (Rework 1.1): belegt erfüllt.** Zeilen 286-287 verlangen: Kapital verifiziert, Zuordnung verifiziert, alle Kategoriegruppen des Firmenfensters verifiziert. Eine leere Zuordnung zählt immer als unverifiziert (Zeile 281). Das Bestehen ist per `stopifnot` in `remainder_ok` erzwungen.
[firm-specific excerpt withheld in public audit]
[firm-specific excerpt withheld in public audit]
[firm-specific excerpt withheld in public audit]
12. **Fensterhinweis (Rework 1.5) und TeX-Labels (Rework 1.6): belegt erfüllt.** Beide stehen in den Zeilen 347 und 399. Die Einheit „RMB million“ und die Residual-Formel sind in beiden Texten definiert.
13. **Zwei Läufe byte-identisch, Zerlegung geschlossen:** Die Zerlegung ist im Code geprüft (Zeile 329, Abweichung unter 0,005 für vollständige Firmen). Die Byte-Identität ist nur über `two_run_checks.csv` und `run1/run2_hashes.csv` angegeben, die ich nicht nachgerechnet habe. Siehe „Nicht geprüft“.
14. **Kein unverifizierter Wert als verifiziert: belegt erfüllt.** `verified()` bindet an PI-Zeile, aktuellen Text und Level. Eine leere ID-Menge ergibt unverifiziert. Das Label ändert sich nur über Statement-Zeilen mit `status=yes`, `verified_by=PI` und passendem Text.
15. **Integrität geschützter Dateien (Kriterium 3):** Nach der Rework-Regel zeilenweise geprüft (Zeilen 413-444). Die Karte und `component_sources_input.csv` laufen über dokumentierte Overrides.

Nicht meine Rolle: Schätzung, Text-Konsistenz und Sprache.

## Nicht geprüft

- Ich konnte keine Befehle ausführen (Bash verweigert). Der Rscript-Lauf, die Byte-Identität der beiden Läufe und die Hashes (`two_run_checks.csv`) sind deshalb nicht von mir reproduziert worden.
- PDF-Seiten und Auszüge habe ich nicht selbst gegen die Originale geprüft, außer über die Konsistenz der Ledger-Zeilen. Das gilt auch für die 199 Textmatches und die 16 Stichprobenzeilen.
[firm-specific excerpt withheld in public audit]
- Die inhaltliche Kodierung der einzelnen Transaktionen (Rubrik-Entscheidungen jenseits der Formelprüfung) liegt außerhalb meiner Rolle.
- Eine Zeilenzählung der Rohdaten (z. B. alle 224 Verifikationszeilen) habe ich nicht nachgerechnet.
