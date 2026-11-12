## Rolle: data (codex, high) – VERDICT: PASS


## Befunde

1. **Keine neuen Mängel der Datenaufbereitung festgestellt.** Das Hauptpanel enthält 1.692 Beobachtungen von 136 Firmen ohne doppelte Firma-Stichtag-Schlüssel. Das entspricht `t004_panel_counts.csv`, Stufe `05_sample_main_has_data`: 195 + 845 + 280 + 372 Beobachtungen. Das Erweiterungspanel übernimmt alle 1.692 historischen Hauptstichprobenzeilen unverändert und enthält ebenfalls keine doppelten Schlüssel.

[firm-specific excerpt withheld in public audit]

3. **Die datenbezogenen Rework-Punkte sind behoben.** Teil C verwendet für D und die bedingte Ausfallquote den Post-Anker 2019 und den Placebo-Anker 2016 (`11_mechanism.R:399–422`). Die Zellgrößen beruhen auf tatsächlich verfügbaren Outcomes; bei der bedingten Quote zählen ausschließlich offiziell konforme Beobachtungen. Alle 28 `descriptive_small_cell`-Zeilen haben leere Konfidenzintervalle. `exclude_jump_dates` entfernt ausschließlich bekannte Sprungstichtage; spätere Bestände bleiben erhalten und werden entsprechend erläutert (`11_mechanism.R:104,147,460`).

4. **Kein Beleg für eine Veränderung der geschützten Analysedaten durch T029.** Alle 24 Dateien des eingefrorenen Manifests sowie alle 139 geschützten Daten-/Ausgabedateien des Verifikationsprotokolls stimmen aktuell mit ihren SHA-256-Werten überein. Gegenüber `review/T029_baseline.sha256` weicht ausschließlich `state/STATE.md` ab. Die parallel erfolgten Änderungen sind dort dokumentiert; eine vollständige Einhaltung des projektweiten Schreibstopps lässt sich daraus nicht bestätigen. Die Datenintegrität von T029 ist durch die geprüften Prüfsummen belegt.

## Abnahmekriterien

1. **Belegt erfüllt, soweit Datenrolle.** Der Gleichheits-Assert für unverändertes MI ist korrekt formuliert (`11_mechanism.R:122–128`). Der abgelegte Gleichheitsfehler beträgt maximal 2,22 × 10⁻¹⁶. `t029_counterfactual_bunching.csv` enthält für die T023-Replikation b = 3,1428547576148 bei 630 Beobachtungen; die Abgrenzung zur gültigen N/E-Stichprobe und zur gepaarten Stichprobe ist ausdrücklich ausgewiesen. Zwei vollständige Läufe und deren Bytegleichheit sind in `t029_verification.txt:3–9` dokumentiert; kein eigener Wiederholungslauf.

2. **Belegt erfüllt, soweit Datenrolle.**
   - Post-Vergleich: 630 Kandidaten → 602 gültige Paare, 129 Firmen. Placebo: 669 → 616 Paare, 125 Firmen (`t029_compliance.csv`).
   - Schuldenvergleich: dieselben offiziellen/frozen Paare; logarithmische Änderungen erfordern positive Schulden, skalierte Änderungen positive Basisaktiva (`11_mechanism.R:221–240`).
   - Distanzgruppen: vorbestimmtes RL1 mit beiden verlangten Ankern; sämtliche kumulierten Outcomes werden durch Ende-2019-Aktiva geteilt (`11_mechanism.R:249–262`).
   - Komponenten: ausschließlich unmittelbar aufeinanderfolgende gültige Halbjahre, keine Auswahl nach Crossing. Vorzeichen und stetige Grenzfälle bei ΔN = 0 beziehungsweise ΔE = 0 sind korrekt (`11_mechanism.R:293–318`).
   - Anreizgruppen: 20 `rl1_only`, 45 `rl1_plus`, fünf wegen fehlendem RL2/RL3 unklassifiziert; Ausschlüsse werden berichtet (`t029_coverage.txt:59`).
   - Alle sechs Ergebnis-CSV-Dateien enthalten Firmenzahlen für jede Zeile.

   Regressionsschätzung, Bootstrap-Inferenz und umfassende Textkonsistenz: **nicht meine Rolle**.

3. **Nicht meine Rolle.** Die inhaltliche Anwendung der Interpretationsregel und die Bewertung möglicher Überinterpretation gehören zur Estimation-/Consistency-Prüfung. Die dafür erforderlichen Post-/Placebo-Daten sind getrennt und korrekt verankert.

## Nicht geprüft

- Keine R-/Shell-Befehle, Analyseskripte oder LaTeX-Läufe ausgeführt; historische Zweilaufgleichheit anhand der vorhandenen Protokolle geprüft.
- Keine vollständige erneute Prüfung der vorgelagerten Rohdatenextraktion gegen Geschäftsberichte. T029 verwendet unveränderte, zuvor erstellte Panels.
- Ungeklärte HK-Berichtswährungen, A-Share-Restricted-Cash und ursprüngliche Imputationen bleiben bestehende Einschränkungen gemäß `state/LIMITATIONS.md` D6, D7, D16 und D19.
- Regressionsergebnisse, kausale Interpretation und visuelle PDF-Gestaltung wurden entsprechend der Spezialrolle nicht bewertet.