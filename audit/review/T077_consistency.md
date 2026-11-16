## Rolle: consistency (declared=codex, effective=codex, high, Modell=Provider-Standard) – VERDICT: ESCALATE


## Befunde

[number withheld]. **Offenes Schreibbereichssignal verhindert die Abnahme.** Die Laufprüfung meldet fünf Dateien außerhalb des freigegebenen Schreibbereichs: `MTPA Vault/.obsidian/app.json`, `appearance.json`, `core-plugins.json`, `graph.json` und `workspace.json`. Ihre Änderungszeiten liegen am [number withheld] zwischen [number withheld]:[number withheld]:[number withheld] und [number withheld]:[number withheld]:[number withheld]; die Eingabenbaseline stammt vom [number withheld], [number withheld]:[number withheld]:[number withheld]. Diese Pfade sind durch `tasks/T077.md:26–33` nicht freigegeben. `agents/review.sh:117–124` verlangt bei einem solchen Signal ausdrücklich `ESCALATE`.

   **Auswirkung:** Der PI muss die Herkunft und Behandlung dieser Änderungen klären. Änderungszeiten belegen weder eine Verursachung durch den Worker noch veränderte Forschungsergebnisse. Alle neun Baseline-Dateien und alle [number withheld] eingefrorenen Dateien stimmen aktuell mit ihren SHA-[number withheld]-Werten überein. Das Urteil beruht auf dem offenen Umfangsbefund, nicht auf einem gefundenen Schätzfehler.

[number withheld]. **Keine numerischen Widersprüche zwischen T077-Bericht und Outputs gefunden.** Alle **[number withheld] Zahlen** der vollständigen Ergebnistabelle in `tasks/T077_report.md:39–47` stimmen einschließlich Rundung, Vorzeichen und Einheit mit `t077_estimates.csv` überein. Die unabhängige Rekonstruktion sämtlicher [number withheld] Kontraste aus `t077_components.csv` ergibt maximal **[number withheld] × [number withheld]⁻¹⁴ Prozentpunkte** Abweichung; bei allen [number withheld] dynamischen Punktwerten maximal **[number withheld] × [number withheld]⁻¹³ Prozentpunkte**.

   Die Primärwerte sind korrekt wiedergegeben: A **[number withheld] [[number withheld]; [number withheld]] pp**, HK **[number withheld] [[number withheld]; [number withheld]] pp**, rohe p-Werte **[number withheld]/[number withheld]**, Holm jeweils **[number withheld]** (`t0[number withheld]_estimates.csv:[number withheld]`). Auch die ausdrücklich getrennten dynamischen Post-Mittel **[number withheld]/[number withheld] pp** stimmen.

[number withheld]. **Die geforderten Offenlegungen des Reworks sind vorhanden und konsistent.** Die Datenidentität von `primary/A` und `unbalanced_developers/A` wurde anhand des Analysepanels bestätigt. Die unterschiedlichen Inferenzwerte, die Referenzabhängigkeit und die nur diagnostische Bedeutung des Vorperiodentests werden erläutert (`tasks/T077_report.md:29–33`). Die berichteten oberen simultanen Grenzen für [number withheld]H1 entsprechen den Outputs: **[number withheld]** gegenüber **[number withheld] pp**. Unbelegte kausale Finanzierungs- oder Verschuldungsaussagen wurden im T077-Bericht nicht gefunden.

## Abnahmekriterien

[number withheld]. **Belegt erfüllt, soweit Konsistenz betroffen.** Estimand, Fenster, Perioden, Ergebnisvorkenntnis und Reihenfolge der zehn dynamischen Koeffizienten entsprechen dem Memo und `t077_specification.csv`. Die im Bericht und den Bildunterschriften genannten Firmenzahlen stimmen mit `t077_membership.csv` und dem gespeicherten Analysepanel überein: A **[number withheld]/[number withheld]**, HK **[number withheld]/[number withheld]**, HK ohne Imputation **[number withheld]/[number withheld]**, unbalancierte HK-Entwickler **[number withheld]**. Vorgelagerte Datenkorrektheit: **nicht meine Rolle**.

[number withheld]. **Belegt erfüllt hinsichtlich Berichterstattung.** Alle **[number withheld] Kontraste**, **[number withheld] Dynamikzeilen** und fünf Szenario-/Markt-Kombinationen sind vorhanden. Die fehlende lineare Kovarianz für unbalanciertes HK wird ausdrücklich ausgewiesen (`t077_diagnostics.csv:5`; Bericht:[number withheld]). Alle [number withheld] Tabellenzahlen stimmen. Methodische Vollständigkeit der Schätzung: **nicht meine Rolle**.

[number withheld]. **Insgesamt nicht abschließend belegt wegen Befund [number withheld].** Die Zellrekonstruktion erfüllt die Toleranz. Alle **[number withheld] relevanten Hash-Vergleichszeilen** des Rework-Nachweises passen zu den aktuellen Dateien; die **[number withheld] Statistikdateien** stimmen zusätzlich mit den tatsächlich gelesenen Archivfassungen überein. Die dokumentierten **[number withheld] Vergleiche zwischen endgültigen Läufen** sind konsistent. `t077_validation.csv` enthält **[number withheld] bestandene Prüfungen**. Deren vollständige methodische Validierung: **nicht meine Rolle**.

[number withheld]. **Belegt erfüllt hinsichtlich Output-/Textkonsistenz.** Aus den **[number withheld] gespeicherten Bootstrap-Kontrasten** rekonstruierte Perzentilintervalle stimmen maximal bis **[number withheld] × [number withheld]⁻¹⁴ pp** mit den Schätztabellen überein; sämtliche rohen p-Werte stimmen ebenfalls. Berichtete Ziehungszahlen, Sparse-Stützung und acht Nullzellen der HK-Sensitivität passen zu den Outputs. Statistische Angemessenheit des Bootstrapverfahrens: **nicht meine Rolle**.

[number withheld]. **Belegt erfüllt hinsichtlich Kennzeichnung und Interpretation.** Alle **[number withheld] Zeilen** in `t077_trend_sensitivity.csv` tragen `NOT RUN` mit Begründung. Der Bericht trennt das dynamische Sensitivitätsziel vom Primärschätzer und erklärt ausdrücklich, dass Nichtverwerfung parallele Trends nicht bestätigt. HonestDiD-Methodenvalidierung: **nicht meine Rolle**.

[number withheld]. **Belegt erfüllt im geprüften T077-Darstellungsumfang.** Alle sechs eingefrorenen PDFs wurden im Speicher gerendert und visuell geprüft. Firmenzahlen, Sparse-/Null-Legenden, Vergleichsskalen und Einheiten entsprechen den Darstellungsregeln. Die sechs Bildunterschriften unterscheiden Fensterwahrscheinlichkeiten von polynomialer Überschussmasse und nennen Survivor-/Current-listing-Selektion (`t077_figure_notes.csv:2–7`). Die Markeraggregation wird zutreffend erklärt (`26_identification.R:534–669`). Der Bericht trennt Konzentrationsänderungen von wirtschaftlicher Verschuldung und kausalen Finanzierungseffekten.

## Nicht geprüft

- Keine erneute Ausführung des schreibenden Analyseskripts. Wiederholbarkeit wurde anhand gespeicherter Laufbelege, Hashes und Archivdateien geprüft.
- Keine vollständige Daten-, Schätzmethoden- oder Identifikationsprüfung; diese gehört den anderen Spezialrollen.
- Keine vollständige Prüfung sämtlicher historischen Proposal-Zahlen. In `proposal/**/*.tex` bestehen keine expliziten T077-Verweise; Proposal-Integration ist laut Memo:[number withheld] eine separate Entscheidung.
- Herkunft und Inhaltsänderung der fünf Obsidian-Dateien sind ungeklärt; geprüft wurden deren Metadaten.
- Worker und Reviewer verwenden Codex; vollständige Modellunabhängigkeit besteht nicht, korrelierte Fehler bleiben möglich. Für tragende Schätzentscheidungen bleibt ein externes menschliches oder anderes Modell-Audit eine Option des PI.
- Keine Dateien geändert und kein Netzwerkzugriff.