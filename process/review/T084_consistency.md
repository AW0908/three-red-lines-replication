## Rolle: consistency (declared=codex, effective=codex, high, Modell=Provider-Standard) – VERDICT: ESCALATE


## Befunde

[number withheld]. **Der vorliegende Kandidat entspricht nicht dem Freeze.** Die erneute Prüfung mit `shasum -a 256 -c review/T084_frozen.sha256` scheitert an den vier Dateien unter `public_release/process/` (Freeze, Zeilen [number withheld]–[number withheld]). Der unabhängige Manifestabgleich ergibt **[number withheld] fehlende Dateien unter `process/` und [number withheld] zusätzliche Dateien unter `process [number withheld]/`**. Sämtliche Dateien unter `process [number withheld]/` stimmen bytegleich mit den für `process/` inventarisierten Dateien überein; andere Manifest-Prüfsummenabweichungen wurden nicht gefunden. Damit sind unter anderem die Pfade in `public_release/README.md:[number withheld]–[number withheld]` und `public_release/MANIFEST.csv:3158–3159` falsch. Ursache und Verantwortlicher der Verlagerung sind nicht festgestellt. Die Kandidatenintegrität ist dennoch verletzt; `agents/review.sh:113–117` verlangt dafür ESCALATE.

[number withheld]. **Drei geschützte Eingaben weichen von der ursprünglichen Ausführungsbaseline ab.** Unabhängig bestätigt sind SHA-[number withheld]-Abweichungen für `replication/README.md`, `state/STATE.md` und `tasks/T082.md` gegenüber `review/T0[number withheld]_baseline.sha2[number withheld]:[number withheld]`. Die spätere T082-Abnahme ist in `state/approvals.log:250` dokumentiert, ersetzt aber keine Entscheidung über diese T084-Baseline. Dies belegt keine Verursachung durch den aktuellen Worker. Nach `agents/TEAM.md:43` und `agents/review.sh:120–125` erzwingen die Eingabeabweichungen trotzdem ESCALATE; eine neue Worker-Scopeprüfung hebt sie nicht auf.

[number withheld]. **Die Validierungsberichte beschreiben nicht mehr die tatsächliche Pfadstruktur.** `T084_ACCEPTANCE.json:2–5` meldet [number withheld] Prozessdateien und keine fehlenden Pflichtquellen; tatsächlich enthält `process/` keine Dateien. Von den [number withheld] Einträgen des Anonymitätsinventars verweisen **[number withheld] auf aktuell fehlende Pfade**. Die übrigen Dateien liegen unter dem nicht inventarisierten Präfix `process [number withheld]/`. Die historischen Scanergebnisse sind dadurch kein vollständiger, unmittelbar nachprüfbarer Nachweis für den aktuellen Kandidaten.

## Abnahmekriterien

[number withheld]. **Nicht vollständig erfüllt.** T077 ist in `public_release/README.md:27–36` ausdrücklich als noch nicht im Proposal enthalten gekennzeichnet. Sieben geprüfte Build-/Analysedateien einschließlich Skripten [number withheld]–[number withheld] stimmen mit `replication/` überein. Alle **[number withheld] HK-Dateien** entsprechen ihren dokumentierten Hashes; alle **[number withheld] akzeptierten Output-Freeze-Einträge** stimmen mit den aktuellen Originalen überein. Von [number withheld] freigegebenen Outputs sind [number withheld] bytegleich; beim verbleibenden Dokument wurden ausschließlich zwei lokale Benutzerpfade dokumentiert redigiert. Manifest und Freeze sind wegen Befund [number withheld] jedoch nicht aktuell.

[number withheld]. **Nicht erfüllt.** Der ausdrücklich verlangte Ordner `process/` enthält weder Governance-Dateien noch README. Die bytegleichen Inhalte unter `process [number withheld]/` ersetzen die vereinbarte Struktur nicht. Die vollständige Ausschlussprüfung gehört zur Datenrolle.

[number withheld]. **Nicht prüfbar für den aktuellen Kandidaten.** Scanberichte und dokumentierte Redaktionen liegen vor, beziehen sich jedoch auf die frühere Pfadstruktur. Eine eigenständige umfassende Prüfung auf Wind-Werte, Geheimnisse und Lizenzverletzungen ist nicht meine Rolle.

[number withheld]. **Nicht erfüllt als aktuelles Inventar.** Die dokumentierten Kategorien summieren sich korrekt auf [number withheld] Vorkommen in [number withheld] Dateien: [number withheld] Vorname, [number withheld] Nachname, vier Account und [number withheld] Initialen. Wegen der [number withheld] fehlgeleiteten Pfadangaben ist das Inventar aktuell nicht vollständig nachprüfbar.

[number withheld]. **Nicht belegt erfüllt.** Die drei Eingabeabweichungen bestehen fort. `T084_SCOPE_CHECK.json` dokumentiert keine Änderungen im betrachteten Worker-Lauf; das löst die ältere SHA-[number withheld]-Abweichung nicht auf. Ein Commit oder Push wurde in diesem Review nicht unabhängig ausgeschlossen.

## Nicht geprüft

- Kein Build, Scan- oder Analyseskript ausgeführt, da diese Dateien schreiben. Der dokumentierte Dry-Run weist erwartete Eingabestopps aus und behauptet zutreffend keine vollständige Reproduktion (`public_release/README.md:51–63`).
- Keine erneute Prüfung sämtlicher Proposal-Zahlen und Paper-Kopien: T084 verändert `proposal/` nicht.
- Datenrichtigkeit, Schätzmethoden, vollständige Sicherheitsprüfung und tatsächlicher Online-Spiegel sind nicht Gegenstand dieses Consistency-Reviews.
- Ursache und Zeitpunkt der Verlagerung nach `process [number withheld]/` sowie Herkunft sämtlicher Baselineänderungen nicht ermittelt.
- Prozessunabhängige Codex-Prüfung ohne Worker-Chat oder Dateiänderungen. Worker und Reviewer gehören derselben Modellfamilie an; korrelierte Fehler bleiben möglich.

Vor erneuter Abnahmeprüfung sind die Baselineabweichungen dem PI vorzulegen und anschließend die verbindliche Release-Struktur samt Inventaren und Freeze wiederherzustellen.