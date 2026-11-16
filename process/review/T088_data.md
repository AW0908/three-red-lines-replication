## Rolle: data (declared=codex, effective=codex, high, Modell=Provider-Standard) – VERDICT: PASS


## Befunde

Das Urteil gilt ausschließlich für die Datenaufbereitung nach der freigegebenen Rework-[number withheld]-Fassung von T088. Keine zusätzlichen Implementierungsfehler gefunden. Folgende ausdrücklich behandelten Datenprobleme bleiben bestehen:

[firm-specific excerpt withheld in public process copy]

[number withheld]. **Zwei Quellenabweichungen bleiben ungelöst und vollständig ausgewiesen.** Der unabhängig rekonstruierte Vergleich ergibt T046: [number withheld]/[number withheld] Treffer innerhalb [number withheld] %; T047: [number withheld]/[number withheld]. Abweichungen betreffen Rongsheng [number withheld] und Suzhou New District [number withheld] (`t088_reconciliation_mismatches.csv`). Die Originalberichte bestätigen die dokumentierten Unterschiede; Rongsheng zeigt unterschiedliche Berichtsstände. Eine abschließende Ursachenklärung wird nicht behauptet (`t088_source_followup.csv`). Das Abnahmekriterium verlangt Vergleich und Offenlegung, keine vollständige Übereinstimmung.

[number withheld]. **Die beobachtete A-Stichprobe bleibt selektiv.** [number withheld] der [number withheld] Entwickler haben keine Cashflow-Statements. Ihr Above-Anteil beträgt [number withheld] %, gegenüber [number withheld] % bei den [number withheld] abgedeckten Firmen (`t088_selection.csv`). Die genehmigte Null-Imputation umfasst zusätzlich [number withheld] Zufluss- und vier Ausschüttungspositionen; sie ist keine Bestätigung tatsächlich ausgebliebener Zahlungen. Regeln und Sensitivitäten sind nachvollziehbar und in `state/LIMITATIONS.md:73` dokumentiert.

[number withheld]. **HK bleibt eine uneinheitliche, hinsichtlich der Normalisierung ungeprüfte Kandidatenreihe.** Zielgrößen- und Einheitenunsicherheit sind in `t088_hk_descriptive.csv` ausdrücklich gekennzeichnet. Alle Schätzungszeilen in `t088_estimates.csv` und `t088_event_study.csv` haben `sample=A`. Damit ist die PI-Entscheidung zum Ausschluss von HK und gepoolten Schätzungen umgesetzt.

## Abnahmekriterien

[number withheld]. **Belegt erfüllt.** Die Schlüssel des Ausgangspanels und des Cashflow-Panels stimmen vollständig überein: [number withheld] eindeutige Firma-Datum-Paare, [number withheld] Firmen. Für A ergeben sich unabhängig: [number withheld] relevante Firma-Halbjahre minus [number withheld] ohne Statement minus [number withheld] ohne verfügbaren Halbjahresfluss = **[number withheld] Beobachtungen aus [number withheld] Firmen**; davon pre [number withheld]/[number withheld], post [number withheld]/[number withheld]. Dies stimmt mit `t088_coverage.csv` überein. Sämtliche [number withheld] Fehlerprotokolle stimmen mit den Rohlogs überein. Genau [number withheld] Firmen erreichen mindestens acht Flüsse; daraus wird korrekt kein zusätzlicher Firmenfilter gemacht.

[number withheld]. **Belegt erfüllt.** Alle [number withheld] Firma-Datum-Vergleiche für Vanke, Poly und CM Shekou wurden unabhängig aus den Probe-Dateien rekonstruiert. Verfügbare Halbjahreswerte stimmen überein; [number withheld]H2 bleibt wegen fehlendem H1 fehlend. Zusätzlich stimmen alle [number withheld] A-Rohdatensätze zwischen JSON und CSV in den sieben verwendeten Feldern überein.

[number withheld]. **Belegt erfüllt.** Die sechs jährlichen Zuflusswerte für drei A-Firmen, [number withheld] und [number withheld], stimmen mit den Originalberichtsseiten überein. Zusätzlich wurden zwölf Kreditaufnahme-/Tilgungswerte bestätigt. Jahresbezug, Spaltenwahl und RMB-Einheit sind nachvollziehbar. T046-/T047-Überlappungen und Abweichungen wurden unabhängig rekonstruiert.

[number withheld]. **Belegt erfüllt, soweit datenbezogen.** Die erforderlichen Ergebniszeilen und Stichprobenangaben liegen vor. Zuflüsse, Ausschüttungen, Nettozuflüsse, Kreditflüsse, Schuldenquoten und Bilanzproxy wurden unabhängig nachgerechnet. Ebenso geprüft: drei Fehlwertregeln, verzögerte und feste Nenner, Baseline-RL1 und Treatment-Zuordnung. Keine Abweichungen außerhalb numerischer Rundung gefunden. Schätzer und Inferenz: **nicht meine Rolle**.

[number withheld]. **Belegt erfüllt, soweit datenbezogen.** Die HK-Prüftabelle dokumentiert mechanisch vier von fünf Treffern und zugleich das übergeordnete Schätzungsverbot. Nicht-Dezember-Geschäftsjahre werden firmenweise ausgeschlossen und vollständig gelistet. Event-Study-Stichprobe und Periodenausschlüsse entsprechen der Karte. Abbildungsdarstellung und Vortrendtest: **nicht meine Rolle**.

[number withheld]. **Belegt erfüllt hinsichtlich Datenreproduzierbarkeit.** Alle **[number withheld] eingefrorenen Dateien** und **[number withheld] Rohdatei-Prüfsummen** bestanden die eigene Prüfung, auch abschließend. Die Datenkonstruktion wurde unabhängig und ausschließlich im Speicher rekonstruiert. Synthetische Sollfälle bestätigten die Gegenrechnung für De-Kumulierung, fehlendes H1, Nullsetzungen, fehlende Statements, negative H2-Werte und ungültige Nenner. Relative Pfade, Seed und erfolgreiche Ausführung sind in Code und Ausführungslog dokumentiert.

[number withheld]. **R1: belegt erfüllt.** Keine HK- oder gepoolten Schätzungen; Unsicherheitskennzeichnung vorhanden.

[number withheld]. **R2: belegt erfüllt, soweit datenbezogen.** `primary_no_negative_h2` enthält sämtliche verlangten Ergebnisfelder. Unabhängig bestätigt: genau acht Beobachtungen entfernt, **N=[number withheld]**, weiterhin **[number withheld] Firmen**. Inferenzprüfung: **nicht meine Rolle**.

[number withheld]. **R3: belegt erfüllt.** Eigener Dateivergleich bestätigt [number withheld] bytegleiche und sechs einzeln dokumentierte geänderte Bestandsdateien sowie eine neue Bootstrap-Datei. Alle [number withheld] beibehaltenen A-Schätzungszeilen sind unverändert. Die Referenzverknüpfung zum Vorlauf wurde anhand von [number withheld] gespeicherten Prüfsummen bestätigt.

## Nicht geprüft

- Kein erneuter Download und kein vollständiger Analyselauf: Diese hätten Schreibnebenwirkungen. Auch ein R-Aufruf scheiterte bereits an der temporären Datei der Lesesandbox. Die unabhängigen Datenprüfungen liefen mit Python ausschließlich lesend und im Speicher.
- Keine vollständige Quellenprüfung aller Firmenberichte oder abschließende Erklärung sämtlicher negativer H2-Werte; keine HK-Währungs-/Skalenvalidierung.
- Regressionen, Kovarianzschätzer, Bootstrap-Inferenz, Identifikation und Abbildungsqualität sind nicht meine Rolle.
- Schreibbereichskontrolle beruht ergänzend auf den bereitgestellten Skriptprüfungen; keine vollständige historische Rekonstruktion gelöschter Dateien.
- Worker und Reviewer verwenden Codex, somit gleiche Modellfamilie und mögliche korrelierte Fehler. Dies ist Prozessunabhängigkeit, keine vollständige Modellunabhängigkeit. Ein externes menschliches oder anderes Modell-Audit bleibt dem PI insbesondere für die Schätzungen offen.
- Keine Dateien geändert. Vorgeschlagener KI-Nutzungseintrag: „[number withheld]: unabhängiger Codex-Data-Review T088; lesende Rekonstruktion von Rohdaten, Datenaufbereitung, Quellenabgleichen und Rework-Ergebnisvergleich.“