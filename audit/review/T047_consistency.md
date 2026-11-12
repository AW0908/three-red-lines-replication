## Rolle: consistency (claude, sonnet) – VERDICT: PASS


Als Consistency-Reviewer habe ich geprüft, ob Bericht, Tabellen-CSVs, TeX-Fragmente, `case_notes.md`, README und Audit-Dateien zusammenpassen. Ich konnte keine Befehle ausführen (Bash war gesperrt); alles stammt aus Lesezugriffen. Die Zahlenzellen habe ich nicht vollständig durchgesehen, sondern gezielt gegen Stichproben abgeglichen.

## Befunde
Keine inhaltlichen Inkonsistenzen gefunden. Zwei Hinweise ohne Einfluss auf das Urteil:

1. `AI_USAGE_LOG.md` enthält nur den Eintrag vom 2026-10-29 zur Kartenerstellung (Zeile 12). Der Eintrag des Workers zum Rework steht nur als Vorschlag im Bericht (Rework-Vorschlag, Abschnitt „Offene Fragen“). Das ist Co-PI-Sache (Regel 5) und kein Mangel der Karte.
2. Die gekürzten Excerpts in den vier Gewinnaussagen (L402–L411) enthalten alle die Zeilenbezeichnung „少数股东损益“. Beim PI-Review steht in L405, L408 und L411 allerdings nur ein abgeschnittener Zeilenanfang. Die Zahl ist belegt, die Darstellung ist lediglich unschön.

## Abnahmekriterien
Nur soweit meine Rolle sie betrifft; Reproduzierbarkeit, Rubrikanwendung und PDF-Seitenprüfung gehören anderen Rollen.

[firm-specific excerpt withheld in public audit]
- **Kriterium 2** (Rubrik wie in T044): nicht meine Rolle. Inhaltlich konsistent sind die Zählungen: Im Pool D1/D2/D?/G/H/E/U = 1/2/1/5/0/1/239 plus 32 Grenzfälle stimmt die Summe aus den Firmenzeilen von `t047_coding.tex` (U-Summe 239, G = 2+2+1, D2 = 1+1, Grenzfälle = 16+2+14) mit der Pool-Zeile und dem Bericht überein. Die neuen Ereignisse (G = 1, E = 1, D1 = 1, 14 Grenzfälle) passen ebenfalls.
- **Kriterium 3** (T044-Dateien und bestehende Notizzeilen unverändert): nicht meine Rolle. Die neuen Zeilen L399–L411 in `case_notes.md` sind angehängt, und die Zeilennummern im Bericht treffen die Aussagen: L402/405/408/411 sind die Gewinnaussagen, und die 17 Pending-Zeilen entsprechen `t047_pending_*.csv`.
- **Kriterium 4** (Zerlegung, zwei byte-identische Läufe): teilweise belegt.
  - Die Kapital-Headline ist konsistent: 190,538.4 / 416.0 / 190,122.5 bei 20/33 Firmenjahren und 129,492.5 / 416.0 / 129,076.6 bei 15/27 Firmenjahren, mit Quoten 0,2183 % und 0,3212 % in CSV, TeX und Bericht.
  - Die 13 fehlenden Firmenjahre in `t047_attribution_totals.csv` entsprechen 33 − 20, die 12 bei den neuen Ereignissen entsprechen 27 − 15.
[firm-specific excerpt withheld in public audit]
[firm-specific excerpt withheld in public audit]
  - Pools sind in CSV, TeX und Bericht konsistent NA, wo eine Firmenkomponente fehlt.
  - Die zwei byte-identischen Läufe konnte ich nicht selbst prüfen.
- **Kriterium 5** (kein unverifizierter Wert als verifiziert): belegt, soweit prüfbar. Die vier Gewinnaussagen sind in `t047_pending_numeric.csv` mit `verified = FALSE` geführt, die Gesamtlabels der Magnitudenzeilen stehen bei „unverified“, und die TeX-Fußnoten weisen die Teilabdeckung ausdrücklich als unverifiziert aus.

Die Rework-Punkte zu meiner Rolle sind umgesetzt:
- **Einheiten und Definitionen:** In `t047_magnitude.tex` steht „RMB million“, und alle Spalten sind definiert, einschließlich Residuum = ΔMI − NCI-Gewinn + Dividenden − NCI-Kapital.
- **Fensterhinweis:** Er steht in TeX, Attributions-CSV, README und Bericht.
[firm-specific excerpt withheld in public audit]
- **NA statt 0:** Fehlende Werte erscheinen als „--“.
[firm-specific excerpt withheld in public audit]

## Nicht geprüft
- **Zahlenzellen:** Nicht alle 4.148 Zellen in `number_file_filter.csv`, nur die oben genannten Stichproben.
- **Proposal-Dokument:** Querverweise (`\ref`, `\cite`) und Zahlen im Proposal-Text konnte ich nicht prüfen, weil T047 keine Texteinbindung enthält.
- **Run-Dateien und Verifikationsdatei:** `verify_rework.py`, die Run-Hashes und die Integrität von `case_notes_verification.csv` habe ich nicht gelesen oder ausgeführt.
- **Code und Daten:** Richtigkeit von Code, Rohdaten und PDF-Excerpts bewerte ich nicht.
