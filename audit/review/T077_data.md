## Rolle: data (declared=codex, effective=codex, high, Modell=Provider-Standard) – VERDICT: ESCALATE


## Befunde

[number withheld]. **Ungeklärte Schreibbereichsabweichung verhindert PASS.** Die fünf Dateien `MTPA Vault/.obsidian/{app,appearance,core-plugins,graph,workspace}.json` liegen außerhalb des freigegebenen Schreibbereichs (`tasks/T077.md:26–33`). Ihre Änderungszeiten liegen am [number withheld] zwischen [number withheld]:[number withheld]:[number withheld] und [number withheld]:[number withheld]:[number withheld], nach der Eingabebaseline vom [number withheld], [number withheld]:[number withheld]:[number withheld]. Dies bestätigt die gemeldete zeitliche Abweichung, beweist jedoch weder eine Änderung durch den Worker noch einen Einfluss auf Forschungsdaten. `agents/TEAM.md:43` und `agents/review.sh:118–124` verlangen hierfür ESCALATE. Der PI muss Herkunft und Behandlung dieser Abweichung klären; die Baseline darf nicht stillschweigend erneuert werden.

In der geprüften T077-Datenaufbereitung wurde kein zusätzlicher inhaltlicher Fehler gefunden. Alle [number withheld] eingefrorenen Dateien und neun Baseline-Eingaben stimmen vor und nach der Prüfung mit ihren SHA-[number withheld]-Prüfsummen überein.

## Abnahmekriterien

[number withheld]. **Belegt erfüllt, soweit Datenrolle.** Die Auswahl aus den drei Eingabepanels reproduziert sämtliche [number withheld] gespeicherten Analysezeilen einschließlich RL1 und `adv_missing`; die Szenario-/Markt-/Gruppen-/Firmen-/Datumsschlüssel sind eindeutig. Grundlage: `26_identification.R:64–134`, `t077_analysis_panel.csv`, `t077_membership.csv`.

[firm-specific excerpt withheld in public process copy]
   - Primär A: [number withheld] Entwickler/[number withheld] Zeilen und [number withheld] Kontrollen/[number withheld] Zeilen.
   - Primär HK: [number withheld] Entwickler/[number withheld] Zeilen und [number withheld] Kontrollen/[number withheld] Zeilen.
   - Unbalanciert HK: [number withheld] Entwickler/[number withheld] endliche Beobachtungen.
   - HK ohne Imputation: [number withheld] Entwickler/[number withheld] Zeilen und [number withheld] Kontrollen/[number withheld] Zeilen.

   HK-Kontrollen werden korrekt über `eligible & balanced_1[number withheld]` ausgewählt. Perioden, Fenster und zehn dynamische Inferenzdaten stimmen mit dem Memo überein.

[number withheld]. **Belegt erfüllt, soweit Datenrolle.** Alle [number withheld] Zellmittel und Stützungszeilen wurden aus Einzelbeobachtungen rekonstruiert. Fallzahlen, Imputationsflags, Sparse-/Nullflags und Verteilungsschwänze stimmen. Alle [number withheld] Verteilungsbins verwenden den vollständigen jeweiligen Nenner. Acht Nullfensterzellen liegen ausschließlich in `HK_no_imputation`.

   RL1 entspricht `(TL−adv)/(TA−adv)`; maximale Abweichung zur unabhängigen Berechnung: [number withheld]×[number withheld]⁻¹³. Endliche Eingangsquoten haben positive Nenner. Extreme Quoten bleiben entsprechend der Spezifikation erhalten. Vorauszahlungsimputationen sind geflaggt und in `state/LIMITATIONS.md`, D1[number withheld] und D-HK, dokumentiert. Die HK-Datumszuordnung stimmt mit der nächsten kalenderzeitlichen Halbjahresgrenze überein.

[number withheld]. **Teilweise belegt erfüllt; insgesamt wegen Befund [number withheld] nicht erfüllt.** Unabhängige Rekonstruktion sämtlicher [number withheld] Kontraste: maximaler Fehler [number withheld]×[number withheld]⁻¹⁴ Prozentpunkte; bei [number withheld] dynamischen Werten maximal [number withheld]×[number withheld]⁻¹³. Primärwerte: A [number withheld] pp, HK [number withheld] pp.

   Die synthetischen Sollwerte `[number withheld]/[number withheld]`, `[number withheld]/[number withheld]`, `[number withheld]/[number withheld]` und sämtliche zugehörigen dynamischen Sollwerte wurden mit rationaler Arithmetik bestätigt. Die gespeicherten [number withheld] Validierungen bestehen; der Code prüft tatsächlich Grenzen und Historienvervielfachung (`26_identification.R:402–511`). Alle [number withheld] geschützten Statistikdateien sind unabhängig archividentisch. Die [number withheld] dokumentierten Vergleiche der endgültigen beiden Läufe stimmen mit den aktuellen Dateien überein. Eine globale Aussage „keine Änderungen außerhalb des Schreibbereichs“ ist dennoch nicht zulässig.

[number withheld]. **Belegt erfüllt hinsichtlich Datenkonsistenz; inferenzielle Bewertung nicht meine Rolle.** Alle [number withheld] Kontrastziehungen erfüllen die gemeinsamen Outcome-Identitäten. Die fünf dynamischen Ziehungsdateien enthalten jeweils [number withheld] Ziehungen in korrekter Reihenfolge. Bootstrap-Kovarianzen wurden unabhängig in Wahrscheinlichkeit² rekonstruiert, maximaler Fehler [number withheld]×[number withheld]⁻¹⁷; alle fünf Matrizen sind positiv definit. Die verfügbaren linearen Firmenkovarianzen stimmen ebenfalls. Für unbalanciert/HK sind sämtliche [number withheld] Einträge ausdrücklich NA. Grundlage: `t077_bootstrap_draws.csv`, `t0[number withheld]_dynamic_draws_*`, `t077_covariance.csv`.

[number withheld]. **NOT-RUN-Option belegt erfüllt.** Alle [number withheld] Zeilen in `t077_trend_sensitivity.csv` kennzeichnen die fehlende lokale HonestDiD-Abhängigkeit ausdrücklich; Intervalle bleiben NA. Methodenvalidierung und kausale Interpretation sind nicht meine Rolle.

[number withheld]. **Belegt erfüllt hinsichtlich Stichprobenhinweisen und Dateneinheiten.** `t077_figure_notes.csv` benennt berichtsvollständige Survivor-Populationen, aktuell gelistete Kontrollen, vollständige Nenner und Sparse-/Nullmarkierungen. Der Produktionscode verwendet Wahrscheinlichkeiten beziehungsweise Prozentpunkte. Visuelle Gestaltung und übrige Textbewertung sind nicht meine Rolle.

## Nicht geprüft

- Kein vollständiger Analyselauf: Er würde Dateien schreiben. Reproduzierbarkeit wurde anhand des Codes, gespeicherter Laufnachweise, Hashvergleiche und unabhängiger Berechnungen im Arbeitsspeicher geprüft.
- Ursprüngliche Rohbelege und die vollständigen vorgelagerten T004-/T061-/T076-Aufbereitungen wurden nicht erneut auditiert. T077 übernimmt deren bestehende Panels.
- Urheberschaft und Inhaltsänderungen der fünf Obsidian-Dateien sind ungeklärt. Änderungszeiten erlauben keine Zuschreibung.
- Keine Regressionen, kausale Identifikation oder visuelle PDF-Abnahme geprüft.
- Worker und Reviewer verwenden Codex derselben Modellfamilie. Dies ist Prozessunabhängigkeit, keine vollständige Modellunabhängigkeit; korrelierte Fehler bleiben möglich. Ein externes menschliches oder anderes Modell-Audit bleibt eine PI-Option.
- Keine Dateien geändert, kein Netz verwendet. KI-Log-Vorschlag: „T077 unabhängig auf Datenkonsistenz geprüft; Auswahl, Zellwerte, Kontraste und Kovarianzen bestätigt; ESCALATE wegen ungeklärter Schreibbereichsabweichung bei fünf Obsidian-Dateien.“