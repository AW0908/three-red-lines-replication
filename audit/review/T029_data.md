## Rolle: data (codex, high) – VERDICT: PASS


## Befunde

[number withheld]. **Keine neuen Mängel der Datenaufbereitung festgestellt.** Das Hauptpanel enthält [number withheld] Beobachtungen von [number withheld] Firmen ohne doppelte Firma-Stichtag-Schlüssel. Das entspricht `t004_panel_counts.csv`, Stufe `[number withheld]_sample_main_has_data`: [number withheld] + [number withheld] + [number withheld] + [number withheld] Beobachtungen. Das Erweiterungspanel übernimmt alle [number withheld] historischen Hauptstichprobenzeilen unverändert und enthält ebenfalls keine doppelten Schlüssel.

[firm-specific excerpt withheld in public process copy]

[number withheld]. **Die datenbezogenen Rework-Punkte sind behoben.** Teil C verwendet für D und die bedingte Ausfallquote den Post-Anker [number withheld] und den Placebo-Anker [number withheld] (`11_mechanism.R:399–422`). Die Zellgrößen beruhen auf tatsächlich verfügbaren Outcomes; bei der bedingten Quote zählen ausschließlich offiziell konforme Beobachtungen. Alle [number withheld] `descriptive_small_cell`-Zeilen haben leere Konfidenzintervalle. `exclude_jump_dates` entfernt ausschließlich bekannte Sprungstichtage; spätere Bestände bleiben erhalten und werden entsprechend erläutert (`[number withheld]_mechanism.R:[number withheld]`).

[number withheld]. **Kein Beleg für eine Veränderung der geschützten Analysedaten durch T029.** Alle [number withheld] Dateien des eingefrorenen Manifests sowie alle [number withheld] geschützten Daten-/Ausgabedateien des Verifikationsprotokolls stimmen aktuell mit ihren SHA-[number withheld]-Werten überein. Gegenüber `review/T029_baseline.sha256` weicht ausschließlich `state/STATE.md` ab. Die parallel erfolgten Änderungen sind dort dokumentiert; eine vollständige Einhaltung des projektweiten Schreibstopps lässt sich daraus nicht bestätigen. Die Datenintegrität von T029 ist durch die geprüften Prüfsummen belegt.

## Abnahmekriterien

[number withheld]. **Belegt erfüllt, soweit Datenrolle.** Der Gleichheits-Assert für unverändertes MI ist korrekt formuliert (`11_mechanism.R:122–128`). Der abgelegte Gleichheitsfehler beträgt maximal [number withheld] × [number withheld]⁻¹⁶. `t029_counterfactual_bunching.csv` enthält für die T023-Replikation b = [number withheld] bei [number withheld] Beobachtungen; die Abgrenzung zur gültigen N/E-Stichprobe und zur gepaarten Stichprobe ist ausdrücklich ausgewiesen. Zwei vollständige Läufe und deren Bytegleichheit sind in `t029_verification.txt:3–9` dokumentiert; kein eigener Wiederholungslauf.

[number withheld]. **Belegt erfüllt, soweit Datenrolle.**
   - Post-Vergleich: [number withheld] Kandidaten → [number withheld] gültige Paare, [number withheld] Firmen. Placebo: [number withheld] → [number withheld] Paare, [number withheld] Firmen (`t029_compliance.csv`).
   - Schuldenvergleich: dieselben offiziellen/frozen Paare; logarithmische Änderungen erfordern positive Schulden, skalierte Änderungen positive Basisaktiva (`11_mechanism.R:221–240`).
   - Distanzgruppen: vorbestimmtes RL1 mit beiden verlangten Ankern; sämtliche kumulierten Outcomes werden durch Ende-[number withheld]-Aktiva geteilt (`11_mechanism.R:249–262`).
   - Komponenten: ausschließlich unmittelbar aufeinanderfolgende gültige Halbjahre, keine Auswahl nach Crossing. Vorzeichen und stetige Grenzfälle bei ΔN = [number withheld] beziehungsweise ΔE = [number withheld] sind korrekt (`11_mechanism.R:293–318`).
   - Anreizgruppen: [number withheld] `rl1_only`, [number withheld] `rl1_plus`, fünf wegen fehlendem RL2/RL3 unklassifiziert; Ausschlüsse werden berichtet (`t029_coverage.txt:59`).
   - Alle sechs Ergebnis-CSV-Dateien enthalten Firmenzahlen für jede Zeile.

   Regressionsschätzung, Bootstrap-Inferenz und umfassende Textkonsistenz: **nicht meine Rolle**.

[number withheld]. **Nicht meine Rolle.** Die inhaltliche Anwendung der Interpretationsregel und die Bewertung möglicher Überinterpretation gehören zur Estimation-/Consistency-Prüfung. Die dafür erforderlichen Post-/Placebo-Daten sind getrennt und korrekt verankert.

## Nicht geprüft

- Keine R-/Shell-Befehle, Analyseskripte oder LaTeX-Läufe ausgeführt; historische Zweilaufgleichheit anhand der vorhandenen Protokolle geprüft.
- Keine vollständige erneute Prüfung der vorgelagerten Rohdatenextraktion gegen Geschäftsberichte. T029 verwendet unveränderte, zuvor erstellte Panels.
- Ungeklärte HK-Berichtswährungen, A-Share-Restricted-Cash und ursprüngliche Imputationen bleiben bestehende Einschränkungen gemäß `state/LIMITATIONS.md` D6, D7, D1[number withheld] und D1[number withheld].
- Regressionsergebnisse, kausale Interpretation und visuelle PDF-Gestaltung wurden entsprechend der Spezialrolle nicht bewertet.