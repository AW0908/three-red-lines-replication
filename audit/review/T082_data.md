## Rolle: data (declared=codex, effective=codex, high, Modell=Provider-Standard) – VERDICT: ESCALATE


## Befunde

[number withheld]. **Die Eingabebaseline ist verletzt; die dokumentierte Governance-Ausnahme hebt diesen Eskalationsgrund nicht auf.** Die SHA-[number withheld]-Werte für `state/LIMITATIONS.md` und `state/STATE.md` weichen von `review/T082_baseline.sha256:16–17` ab. Unabhängig rekonstruiert: Die ursprünglichen [number withheld] beziehungsweise [number withheld] Zeilen sind bytegleich erhalten; ausschließlich nachfolgende Abschnitte wurden ergänzt. Das belegt keinen Datenfehler und keinen Schreibverstoß des aktuellen Workers. Dennoch verlangen `agents/TEAM.md:43` und `agents/review.sh:120–124` bei Eingabedrift ESCALATE. Die PI-Ausnahme in `state/STATE.md:125–126` erklärt die SHA-Prüfung ausdrücklich für unverändert. **Nächster Schritt:** Anton entscheidet über diese konkrete historische Baselineabweichung; keine Prüfsumme zurücksetzen.

## Abnahmekriterien

Bewertet wird **Neufassung [number withheld] einschließlich Ergänzungen [number withheld] und [number withheld]**, soweit die Datenrolle betroffen ist.

| Kriterium | Bewertung und Beleg |
|---|---|
| **[number withheld]. Vier erfolgreiche Einzeltests; ausschließlich erlaubte Unterschiede** | **Belegt erfüllt im Datenumfang.** Logs bestätigen Exit [number withheld] für [number withheld]/[number withheld] aus Lauf [number withheld] sowie [number withheld]/[number withheld] aus Lauf [number withheld]. Aktuelle Quellen stimmen mit den getesteten Quellen überein. Unabhängig nachgeprüft: sämtliche [number withheld] beziehungsweise [number withheld] inventarisierten Dateien der erhaltenen Testkopien entsprechen ihren Vergleichshashes; alle [number withheld] aufbereiteten Datendateien sind bytegleich (`t082_r6_check.csv`, `t082_r7_check.csv`). |
| **[number withheld]. Proposal und Präsentation der Kopien unverändert** | **Belegt erfüllt im inventarisierten Umfang.** Je Kopie stimmen alle [number withheld] externen Dateien mit dem Vorher-Inventar überein. Der Standardmodus von [number withheld] endet vor dem Proposal-Lese-/Patchblock (`replication/code/25_hk_control.R:481–498`). |
| **[number withheld]. Dieselben [number withheld] Build-Schritte** | **Nicht meine Rolle.** Ergänzend unabhängig bestätigt: gleiche Reihenfolge aller drei Einstiegspunkte und identische eingebettete Quelltexte; [number withheld] steht an Position [number withheld]. |
| **[number withheld]. Lockfile und README** | **Hinsichtlich Datenbeschreibung belegt erfüllt.** RL1-Formel und RL3-Richtung stimmen in `replication/README.md:[number withheld]–[number withheld]–[number withheld]` mit den Variablendefinitionen überein. Vollständige Paket- und redaktionelle Prüfung: **nicht meine Rolle**. |
| **[number withheld]. Schreibbereich und Ausführungsgrenzen** | **Nicht vollständig erfüllt:** historische Eingabedrift gemäß Befund [number withheld]. Die inventarisierten Forschungsdateien entsprechen dagegen dem Lauf-[number withheld]-Abschlussstand; alle [number withheld] früheren T082-Belege sind erhalten. Die Aufgabenkarte hat inzwischen den regulären Status CANDIDATE. |
| **E4[number withheld]. Inventarausnahmen einzeln belegt** | **Belegt erfüllt.** Eigener Vergleich bestätigt T066: [number withheld] → [number withheld] Zeilen, keine Löschung, vier geänderte Hashzellen; T072: [number withheld] → [number withheld], keine Löschung, sechs Hashzellen. Alle `unchanged`-Flags sind wahr. `t066_validation.txt` unterscheidet sich ausschließlich im erlaubten Inventarsatz. Alle [number withheld] übrigen T066-/T072-Dateivergleiche sind bytegleich. |
| **E4[number withheld]. Exakt drei README-Korrekturen** | **Belegt erfüllt hinsichtlich Datenbeschreibung.** Der unabhängig im Speicher erzeugte Diff entspricht exakt `replication/outputs/tables/t0[number withheld]_r8_README.diff` und enthält drei Änderungsblöcke. |
| **E4[number withheld]. Statistische Ausgaben und geschützte Bereiche unverändert** | **Belegt erfüllt im inventarisierten Umfang des aktuellen Laufs.** Die gespeicherten Hashes der statistischen Vergleichsdateien sowie von `proposal/`, `public_release/` und `Daten/` stimmen. |

Zusätzliche unabhängige Datenprüfungen ergaben keinen inhaltlichen Fehler:

- **Rohdaten und Schlüssel:** Alle [number withheld] HK-MANIFEST-Einträge stimmen nach SHA-[number withheld] und Dateigröße. Interne und externe Preiskopie stimmen mit dem MANIFEST überein (`23_drdid.R:21–33`).
- **HK-Aufbereitung:** [number withheld] Rohdatenvergleiche sowie sämtliche [number withheld] Panelzeilen einschließlich Datumszuordnung, Firmenkennungen, RL1, Vorauszahlungssummen und Missing-Flags bestätigt. Aus [number withheld] Firmen mit Bilanzdaten entstehen [number withheld] balancierte Kontrollen; [number withheld] ihrer Firma-Stichtage haben beide Vorauszahlungsposten fehlend. Dies entspricht `t076_hk_roster_summary.csv` und `state/LIMITATIONS.md:66–71`.
- **Variablenalgebra:** RL1, RL1-alt, RL2, RL2-adj, RL3, MI-Anteil, JV-Anteil und RL2-Lücke für alle [number withheld] gespeicherten Panelzeilen unabhängig nachgerechnet; `dose_pre` und `distance` für [number withheld] Firmen bestätigt. Nenner ≤ [number withheld] und fehlende Zähler bleiben fehlend. Hauptstichprobe: [number withheld] eindeutige Firma-Stichtage, [number withheld] Firmen, davon [number withheld] A und [number withheld] HK.

## Nicht geprüft

- Kein neuer Analyse- oder Build-Lauf; ausschließlich lesende Prüfungen der Dateien und erhaltenen Testkopien.
- Keine vollständige erneute Prüfung sämtlicher historischer Rohdatenimporte, Originalabschlüsse oder Währungsangaben außerhalb der T082-Änderungen.
- Keine Laufzeittests der Fallbacks oder Integrationsmodi.
- Keine Bewertung von Regressionen, Identifikation oder Proposaltexten.
- Neun PDF-Vergleiche bestätigen identische Streams und ausschließlich erlaubte Metadatenunterschiede. Vier PDFs wurden erhalten, nicht regeneriert; keine eigene visuelle Prüfung.
- Worker und Reviewer gehören zur Codex-/GPT-Modellfamilie: Prozessunabhängigkeit, keine vollständige Modellunabhängigkeit; korrelierte Fehler bleiben möglich. Ein externes menschliches oder anderes Modell-Audit bleibt vor tragender kausaler Verwendung eine Option des PI.
- Der Freeze aller [number withheld] Dateien war bei beiden Kontrollen unverändert. Keine Datei wurde geändert.