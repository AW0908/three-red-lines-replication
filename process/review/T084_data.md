## Rolle: data (declared=codex, effective=codex, high, Modell=Provider-Standard) – VERDICT: ESCALATE


## Befunde

[number withheld]. **Der Kandidat entspricht nicht mehr dem Freeze.** Die vier Dateien aus `review/T084_frozen.sha256:8–11` fehlen unter ihren eingefrorenen Pfaden: `public_release/process/{EXCLUDED.csv,README.md,SOURCE_INVENTORY.csv,THIRD_PARTY_DOCUMENTS.csv}`. Insgesamt fehlen sämtliche **[number withheld] manifestierten Prozessdateien** unter `process/`; stattdessen liegen [number withheld] bytegleiche Dateien unter `process [number withheld]/`. Die übrigen [number withheld] Payload-Dateien stimmen hinsichtlich Größe und SHA-[number withheld] mit dem Manifest überein. Damit sind Pfadstruktur, Manifest und Freeze inkonsistent. Die früheren Erfolgsangaben in `public_release/validation/T084_ACCEPTANCE.json:2–5` belegen den aktuellen Zustand nicht. Nach `agents/review.sh:113–121` erzwingt die Freeze-Abweichung `ESCALATE`. Ursache und Verursacher der Pfadänderung sind nicht festgestellt.

[number withheld]. **Drei schreibgeschützte Eingaben weichen weiterhin von der ursprünglichen Aufgabenbaseline ab.** Unabhängig bestätigt für `replication/README.md`, `state/STATE.md` und `tasks/T082.md` anhand `review/T0[number withheld]_baseline.sha2[number withheld]:[number withheld]`. Die übrigen fünf Baseline-Abweichungen liegen innerhalb des erlaubten Release-Schreibbereichs. `agents/TEAM.md:43` und `agents/review.sh:121–124` verlangen bei Eingabedrift `ESCALATE`. Der PI-Override in `state/approvals.log:250` betrifft T082; eine entsprechende Entscheidung zu T084 ist dort nicht dokumentiert. Dies belegt keine unerlaubte Änderung durch den T084-Worker, verhindert aber einen formalen PASS. Der engere aktuelle Laufvergleich in `T084_SCOPE_CHECK.json` ersetzt die ursprüngliche Baseline nicht.

**Nächster Schritt:** Der PI muss die Eingabedrift beurteilen; anschließend sind die vorgesehenen Releasepfade im regulären Ablauf wiederherzustellen und Kandidat, Manifest sowie Freeze erneut unabhängig zu prüfen. Keine Datei wurde durch diesen Review geändert.

## Abnahmekriterien

[number withheld]. **Nicht erfüllt – Manifest-/Pfadintegrität; Datenexport inhaltlich belegt.**
   
   Die unabhängige Rekonstruktion bestätigt:
   
   - Originalpanel: **[number withheld] Zeilen, [number withheld] Firmen, [number withheld] Spalten**. Entfernung aller [number withheld] Wind-Firmen ergibt exakt **[number withheld] Zeilen, [number withheld] Firmen, [number withheld] Spalten**; [number withheld] Zeilen und zwölf dokumentierte Spalten entfallen. Keine doppelten Firma-Datum-Schlüssel, keine gemischten Quellen innerhalb der entfernten Firmen. Jede erhaltene Zelle entspricht dem Original.
   - Fallzahlen stimmen mit `outputs/tables/t004_panel_counts.csv` überein: [number withheld] EastMoney- und [number withheld] Wind-Zeilen; Hauptstichprobe [number withheld] Zeilen.
   - RL1–RL3, `rl2_adj`, `mi_share`, `jv_ta`, Schuldenaggregate, Verletzungsindikatoren, Baseline-Dosen, `dose_pre` und `distance` wurden unabhängig nachgerechnet: **keine Abweichung**. Nichtpositive Nenner, fehlende Werte, Schwellen-Gleichheit und partielle Summen wurden geprüft. Imputationsflags bleiben erhalten.
   - Alle **[number withheld] HK-Rohdateien** stimmen mit Manifest und internen Originalen überein. Roh-Langdaten → breite Daten: **[number withheld] Werte einschließlich Missingness geprüft, keine Abweichung**. Stichtagszuordnung, Firmenkennungen, Kennzahlen und Mitgliedschaft reproduziert: [number withheld] Registerfirmen → [number withheld] berechtigte → [number withheld] mit Bilanzdaten → [number withheld] balancierte Firmen. Keine doppelten Schlüssel; [number withheld] Nullimputationen im balancierten Panel sind geflaggt.
   - Sämtliche verglichenen Release-Analyseskripte sind bytegleich mit ihren internen Quellen. Die [number withheld] dokumentierten akzeptierten Output-Freeze-Hashes stimmen mit den Originaldateien überein. T077 ist in `public_release/README.md:27–36` ausdrücklich separat gekennzeichnet.
   
   Die fehlenden Manifestpfade aus Befund [number withheld] verhindern dennoch die Erfüllung des Gesamtkriteriums.

[number withheld]. **Nicht erfüllt hinsichtlich der vorgeschriebenen Ablage.**
   
   Das verlangte `process/README.md` und die Prozessinventare fehlen am vorgesehenen Ort; die Dateien befinden sich bytegleich unter `process [number withheld]/`. Vollständigkeit und Verständlichkeit der Governance-Erzählung: **nicht meine Rolle**.

[number withheld]. **Nicht prüfbar als vollständige Freigabe des aktuellen Kandidaten.**
   
   Die Datenprüfungen bestätigen die dokumentierten Wind-Ausschlüsse des öffentlichen Panels. Alle [number withheld] als enthalten inventarisierten Outputs sind vorhanden; sämtliche [number withheld] als zurückgehalten inventarisierten Outputs fehlen. Die zwei Wind-behafteten Validierungsstreudiagramme fehlen ebenfalls; Ausschlussbeleg: `T084_GRAPHICAL_PROVENANCE.csv:2–5`. Keine Abweichung in diesen Datenexportprüfungen gefunden.
   
   Die alten Scanberichte beziehen sich jedoch auf eine inzwischen abweichende Pfadstruktur. Sie ersetzen keine abschließende Prüfung des wiederhergestellten, erneut eingefrorenen Kandidaten. Allgemeine Geheimnis-/Identitätssuche: **nicht meine Rolle**.

[number withheld]. **Nicht meine Rolle.**
   
   Vollständigkeit des Anonymitätsinventars und Beurteilung des Referee-Spiegels gehören zum Consistency-Review.

[number withheld]. **Nicht erfüllt hinsichtlich der unveränderten Eingabebaseline.**
   
   Siehe Befund [number withheld]. Die **[number withheld] Git-Verwaltungsdateien** stimmen dagegen mit dem gespeicherten Sitzungsausgangszustand überein; keine Git-Metadatenänderung festgestellt. Daraus allein lässt sich nicht jede historische Aktion ausschließen.

## Nicht geprüft

- Kein erneuter Release-/Analyse-/Dry-Run ausgeführt: Diese Programme schreiben Dateien. Vorliegende Dry-Run-Belege dokumentieren erwartete Stopps wegen fehlender lizenzierter Eingaben, keinen vollständigen erfolgreichen Neubau.
- Keine vollständige erneute Entwicklerpanel-Aufbereitung aus sämtlichen Rohquellen; geprüft wurden die exakte Exportauswahl, erhaltene Werte und Konstruktionen sowie die HK-Aufbereitung.
- Keine neue Prüfung manueller Codierungen gegen Drittanbieter-PDFs, keine Lizenzklärung und kein Zugriff auf vertrauliche fremde Arbeiten.
- Keine Bewertung von Regressionen, Identifikation, Inferenz oder Proposaltext; keine Onlineprüfung des anonymen Spiegels.
- Review mit Codex wie der Worker: Prozessunabhängigkeit, keine vollständige Modellunabhängigkeit; korrelierte Fehler bleiben möglich. Ein externes menschliches oder anderes Modell-Audit bleibt für High-Stakes-Estimation eine Option des PI.