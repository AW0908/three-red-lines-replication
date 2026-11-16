## Rolle: consistency (declared=codex, effective=codex, high, Modell=Provider-Standard) – VERDICT: PASS


## Befunde

[number withheld]. **Keine Abweichung zwischen Fallmemo und aktuellen Zusammenfassungen gefunden.** `replication/outputs/audit/T079/case_memo.md:4–5` stimmt mit `replication/outputs/tables/t079_coverage.csv:2` überein: [number withheld] Mrd. RMB ausgewählter MI-Zuwachs bei [number withheld] Mrd. RMB Nenner, [number withheld] % Auswahlabdeckung, sieben Firmenjahre und [number withheld] Mrd. RMB beobachteter Minderheitenkapitalzufluss. Alle sieben fallbezogenen Zahlenpaare sind richtig auf drei Dezimalstellen gerundet.

[number withheld]. **Nullbeträge und Vertragskategorien werden konsistent interpretiert.** Die [number withheld] Zahlungs-/Lückenzeilen enthalten elf Kandidaten und acht ungeklärte Fälle; kein Zahlungsbetrag ist bestätigt. Die Nullsummen in `t079_coverage.csv:2` bezeichnen daher fehlende bestätigte Zuordnung. Das Memo erklärt diese Grenze ausdrücklich (`case_memo.md:6`). Die Kategorien D2=[number withheld], G=[number withheld] und U=[number withheld] stimmen zwischen `t079_terms.csv`, `t079_category_amounts.csv:2–8` und `t079_term_completeness.csv` überein. Huajing wird konsistent als U behandelt; die frühere E-Interpretation wird im Reconciliation-Log ausdrücklich supersediert.

[number withheld]. **Der Gesamtbuild bleibt blockiert; diese Einschränkung wird korrekt berichtet.** `replication/outputs/audit/T079/worker_20261115/execution_status.csv:2–3` dokumentiert zweimal Exit [number withheld]. `run2.log:13–15` nennt [number withheld] historische Abweichungen, davon [number withheld] ohne Ausnahme. Das Memo verschweigt dies nicht (`case_memo.md:40`). Der vorliegende PASS bewertet ausschließlich die Consistency-Rolle; er bestätigt weder einen erfolgreichen Gesamtbuild noch die historische Datenintegrität.

## Abnahmekriterien

[number withheld]. **Belegt erfüllt hinsichtlich Zahlen und Darstellung.** Unabhängig aus den gespeicherten Endpunktwerten rekonstruiert: D = [number withheld] RMB. Die ersten sechs Fälle erreichen [number withheld] %, sieben Fälle [number withheld] %. Die Zusammenfassungen weisen [number withheld] Kandidaten, [number withheld] zulässige Firmenjahre und [number withheld] Ausschlüsse aus. Auswahl-, Zahlungs- und Klassifikationsabdeckung bleiben getrennt. Die zeitliche Reihenfolge von Freeze und Erstkodierung: **nicht meine Rolle**.

[number withheld]. **Belegt erfüllt hinsichtlich fallübergreifender Konsistenz.** Dieselben sieben Firmenjahre erscheinen in Auswahl, Fallzusammenfassung, Suchabdeckung und Endpoint-Lückenledger. Fehlende Belege werden ausdrücklich bezeichnet. Vollständigkeit und Qualität der tatsächlichen Quellensuche: **nicht meine Rolle**.

[number withheld]. **Belegt erfüllt hinsichtlich Beträgen, Zählungen und Interpretation.** Unbestätigte Beträge werden nicht als bestätigte Zuflüsse dargestellt; Vertragszahlen werden nicht mit Zahlungsbeträgen gleichgesetzt. Dokumentarische Zahlungsgültigkeit und historische Unverändertheit sämtlicher früherer Outputs: **nicht meine Rolle**; der Integritätsblocker bleibt ausgewiesen.

[number withheld]. **Belegt erfüllt hinsichtlich Übereinstimmung.** Kategorien, Transaktionsstatus und Einschränkungen passen zwischen Memo und Ledgers zusammen. Alle [number withheld] Quellenbehauptungen bleiben `PI_verification=pending`; ihre gemeinsamen Felder stimmen mit den Evidenzzeilen überein. Keine kausale, populationsbezogene oder Hidden-Debt-Prävalenzaussage gefunden. Inhaltliche Richtigkeit der Rubrik und Originalquellen: **nicht meine Rolle**.

[number withheld]. **Belegt erfüllt hinsichtlich Reproduzierbarkeitsdarstellung und begrenzter Schlussfolgerungen.** Alle [number withheld] gespeicherten Zusammenfassungen haben identische Hashes zwischen beiden Läufen; diese Hashes stimmen auch mit den aktuellen Dateien überein. Alle [number withheld] Dateien des Kandidaten-Freeze sind unverändert. Die [number withheld]-zeilige Retrieval-Queue liegt vor. Fehlgeschlagene Gesamtbuilds werden ausdrücklich offengelegt; Kriterium [number withheld] erlaubt die Dokumentation genauer Blocker.

## Nicht geprüft

- Keine Analyseskripte oder Builds ausgeführt, da sie Dateien schreiben.
- Keine eigenständige Prüfung chinesischer Vertragsbedeutungen, Original-PDF-Inhalte oder statistischer beziehungsweise buchhalterischer Implementierung.
- Keine vollständige Proposal-Prüfung: T079 integriert laut Karte nichts in `proposal/`; dort wurden keine Verweise auf T079 oder seine neuen Kernzahlen gefunden.
- Die historische Herkunft sämtlicher Integritätsabweichungen wurde nicht unabhängig geklärt.
- Worker und Reviewer verwenden dieselbe Codex-/GPT-Modellfamilie. Es besteht Prozessunabhängigkeit mit verbleibendem Risiko korrelierter Fehler; vollständige Modellunabhängigkeit wird nicht behauptet.