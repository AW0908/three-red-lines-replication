## Rolle: estimation (codex, high) – VERDICT: PASS


## Befunde

Keine verbleibenden Mängel innerhalb der Spezialrolle Schätzung gefunden. Das Urteil betrifft ausschließlich die schätzungsbezogenen Aspekte von T026.

Die beiden bisherigen Einwände sind behoben: Die Bedingung zum mechanischen Beitrag zu `rl2_gap` bezieht sich jetzt auf die tatsächlich geschätzte TWFE-Regression im unbalancierten Panel. Der Text stellt außerdem ausdrücklich klar, dass Veränderungen innerhalb derselben Firma diese Mechanik nicht beseitigen (`proposal/theory_note.tex:370–374`).

## Abnahmekriterien

[number withheld]. **Propositionen und algebraische Herleitungen: belegt erfüllt.** Kostenminimum, Kapazitätsgrenze, Compliance-Cutoff, Verteilungsabbildung und Ownership-Ableitungen folgen aus den angegebenen Annahmen (`proposal/theory_note.tex:264–332`). Die Übergänge bei \(g=[number withheld]\), \(g=g_c\) und \(g=\bar g\) sind konsistent; Gleichgültigkeit wird ausdrücklich zugunsten der Compliance aufgelöst (`:[number withheld]`). Die Erweiterung um einen bestehenden Wedge definiert \(\Delta L=L_0-L\) korrekt und trennt unveränderte Entscheidungen von verschobenen Leverage-Niveaus (`:[number withheld]–[number withheld]`). Ableitung und Gegenbeispiel zur mechanischen Wedge-Veränderung stimmen (`:[number withheld]–[number withheld]`).

[number withheld]. **Vorhersage–Test-Zuordnung: belegt erfüllt, soweit schätzungsbezogen.**
   
   - Outcome-Niveaus, `dose_pre`, Firmen- und Datums-Fixed-Effects entsprechen dem Referenzcode. Die Event Study verwendet den [number withheld] als Referenz; der gemeinsame Vortrendtest umfasst ausschließlich die sieben früheren Termine (`replication/code/[number withheld]_estimate.R:[number withheld]–[number withheld]–[number withheld]`; `proposal/theory_note.tex:340`).
   - Die Schätzstichprobe wird über `sample_main` und vorhandene `dose_pre` definiert; fehlende Outcomes und Singletons werden je Outcome berücksichtigt (`[number withheld]_estimate.R:[number withheld]–[number withheld]–[number withheld]`). Für `rl2_gap` stimmen CSV und vorhandener Modellprotokollausdruck überein: Koeffizient **[number withheld]**, SE **[number withheld]**, **[number withheld] Beobachtungen, [number withheld] Firmen** (`replication/outputs/tables/t009_did_main.csv:4`; `tasks/T012_worker.log:5310–5326`). Der TEX-Export enthält dieselben gerundeten Werte (`t009_did_main.tex:10–15`).
   - Firmenclustering, modellbasierte t-Konfidenzintervalle und gemeinsame Waldtests sind im Code erkennbar. T023 verwendet gemeinsame Firmenresamples für gepaarte Definitionsvergleiche und benennt die fehlende Mehrfachtestkorrektur (`02_estimate.R:85–123`; `[number withheld]_bunching_tests.R:[number withheld]–[number withheld]–[number withheld]`).
   - Die Grenzen der Interpretation sind ausdrücklich genannt: Dosis ist nicht gleich Abstand zur Schwelle; die Anpassungsreaktion ist nicht monoton; `rl2_adj` erfasst nur den Perpetual-Kanal; der RD-Sprung folgt nicht aus dem Modell (`theory_note.tex:[number withheld]–[number withheld]–[number withheld]`). Die Zuordnung zu T023–T025 passt zu deren geplanten Tests.

[number withheld]. **Stand-alone-Übersetzung und Layout: nicht meine Rolle.** Der vorhandene Build meldet [number withheld] Gesamtseiten; das Log enthält weder „Float too large“ noch „Overfull \hbox“. Die Tabelle und der Beginn der Diskussion liegen auf Seite [number withheld], der Beweisanhang beginnt auf Seite [number withheld] (`review/T0[number withheld]_theory_build/theory_note.aux:[number withheld]–[number withheld]`; `theory_note.log:1247–1248`). Die genaue Haupttextlänge wurde nicht visuell abgenommen.

[number withheld]. **Keine Änderungen außerhalb des Schreibbereichs: nicht meine Rolle.** Die übermittelten Integritätsmeldungen nennen veränderte Karteneingaben und zahlreiche weitere Dateien. Dieses fachliche PASS bestätigt weder deren Urheberschaft noch die Integrität des gesamten Arbeitsstands.

## Nicht geprüft

- Keine Befehle, Neuschätzungen oder Übersetzungen ausgeführt; keine Dateien geändert.
- Modellobjekte und tatsächliche Schätzstichproben nicht neu erzeugt. Numerischer Abgleich erfolgte mit abgelegten Outputs und vorhandenem Modellprotokoll.
- Keine vollständige Neuabnahme von T009, T015 oder T023.
- Datenaufbereitung, Sprache, Originalquellen, visuelles Layout und Zuordnung der gemeldeten Änderungen: nicht meine Rolle.