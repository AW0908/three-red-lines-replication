## Rolle: data (claude, sonnet) – VERDICT: PASS


Das ist die Prüfung der Datenaufbereitung (Rolle `data`). Ich habe nur gelesen, nichts ausgeführt.

## Befunde

Keine inhaltlichen Fehler in der Datenaufbereitung gefunden. Drei Hinweise ohne Rework-Bedarf:

[number withheld]. **Fehlerverteilung ε ist rechtsschief und hat positiven Mittelwert.** In `t063_noise_calibration.csv` liegen N=[number withheld] Paare von [number withheld] Firmen vor. Der Mittelwert ist [number withheld], der Median [number withheld], das Maximum [number withheld]. Das Skript wendet ε unzentriert auf alle bewegten Beobachtungen an (`22_referee5.R:166-167`). Damit verschiebt es bewegte Firmen systematisch nach oben. Das ist im Code und im Interpretationstext offen als Annahme ausgewiesen. Die Vorzeichenkonvention passt: constructed = published + ε, und die beobachtete Kennzahl ist die konstruierte. Die Validierungsstichprobe ist klein und selektiert, was bei der Interpretation zu beachten ist.
[number withheld]. **`pi` und `Delta` sind nicht durch die Karte vorgegeben.** Das π-Raster [number withheld]–[number withheld] in Schritten von [number withheld] hat der Worker selbst gewählt. Das ist unter „Offene Fragen“ des Berichts offengelegt und hier nicht fehlerhaft.
[number withheld]. **Zusätzliche Lektüre von `screening.xlsx`.** Das Skript liest sie für den CNKI-Abgleich (`22_referee5.R:431`). Sie ist als Eingabe gehasht und unverändert, und die Karte nennt nur `prisma_counts.csv`. Der Zugriff ist nur lesend und auf Schritt [number withheld]b begrenzt.

## Abnahmekriterien

Soweit sie meine Rolle betreffen:

[number withheld]. **Reproduktion, byte-identisch (Rolle `data` / `consistency`):** belegt erfüllt, soweit ich es am Code sehen kann.
   - `t063_reproduction.csv` zeigt Δb=[number withheld], ΔΔb=[number withheld] und [number withheld].
   - Die Asserts stehen vor jeder neuen Zufallsoperation (`22_referee5.R:79-87`).
   - Die Ziehungen aus `21_diff_bunching.R` werden reproduziert, weil `weights()` in derselben Reihenfolge aufgerufen wird.
   - Alle bestehenden Ausgaben und alle Rohdateien werden vor und nach dem Lauf per SHA-[number withheld] verglichen (`22_referee5.R:527-530`).
   - Die Wiederholung wird per Hash gegen die gestagten Dateien verglichen (`22_referee5.R:544-548`).
   - Die Wiederholung selbst habe ich nicht ausgeführt, ich stütze mich auf Code und Berichtstext.
[number withheld]. **Jede Variante mit N, Firmen und Fensterbesetzung:** belegt erfüllt.
   - `t063_control_sens.csv` enthält je Zeile `*_n`, `*_firms`, `*_window_obs`, `*_window_firms`, `*_exclusion_*` und die gefitteten Massen.
   - Die Stützen der Einzel-Beobachtungs-Ziehungen stehen in `t063_one_obs_support.csv`.
   - Die Zahl der Datum-Gruppen-Zellen und die Firmenzahlen je Datum stehen in `t063_by_date.csv`.
[number withheld]. **Keine handerhobenen Daten verwendet oder verändert:** belegt erfüllt, mit einer Einschränkung. `data/raw/manual` wird nur gehasht, nicht gelesen. Die T040-Validierungsfehler sind von Schritt [number withheld] vorgeschrieben.

Weitere Belege zur Datenaufbereitung:

- **Stichprobe:**
[firm-specific excerpt withheld in public process copy]
  - Kontrolle: [number withheld] Firmen, davon [number withheld] ohne und [number withheld] mit Zulieferbranche (`t063_control_membership.csv`, [number withheld] Zeilen mit den drei Labels). Die Aufteilung wird per `stopifnot` auf Vollständigkeit und Disjunktheit geprüft (`22_referee5.R:305-306`).
  - Gültige Firmen im unteren Schwellenfenster: Entwickler [number withheld] vor und [number withheld] nach der Politik, Kontrollen [number withheld] und [number withheld]. Das passt zu `t063_distinct_firms.csv` und `t063_by_date.csv`.
- **Konstruierte Variablen:** Die RL1-Formel wird nicht neu berechnet, sie kommt aus dem Panel bzw. aus `t061_control_panel.csv`. Die Fensterlogik ist halboffen `[[number withheld]; [number withheld])`, der Fit schließt `[[number withheld]; upper)` aus (`22_referee5.R:98-99`). Der Code prüft das gegen eine unabhängige `hist`/`lm`/`predict`-Version (max. Fehler [number withheld], `t063_validation.txt`).
- **Imputationen:** Es gibt keine neuen. Die Kontroll-Vorauszahlungen werden wie in T061 mit [number withheld] imputiert (`21_diff_bunching.R:115`), unverändert und dort geflaggt.
- **Einzel-Beobachtung je Firma:** Die Stichprobe umfasst alle endlichen RL1-Werte einer Firma, auch solche außerhalb [[number withheld]; [number withheld]]. Dann wird `hist_counts` angewendet (`22_referee5.R:348-350`). Das ist konsistent und im Code kommentiert. `sample.int` statt `sample` verhindert die bekannte Fehlindizierung bei Firmen mit genau einer Beobachtung.
- **Reconcile:**
  - Die Intervallpaare T061/T058 werden aus den Ziehungen nachgerechnet und per `stopifnot` gegen die Tabellen geprüft (`22_referee5.R:454-455`). Die Werte [number withheld]/[number withheld] gegenüber [number withheld]/[number withheld] sind plausibel unterschiedlich.
  - Die beiden Kontrolländerungen sind bei [number withheld] und [number withheld] verschieden und ausdrücklich als zwei Schätzungen ausgewiesen.
  - CNKI: [number withheld] Datensätze, [number withheld] eindeutige, L1[number withheld] in C1 und C3.

## Nicht geprüft

- Ich habe nichts ausgeführt (Rollenvorgabe) und keine Zahlenwerte in `t063_noise.csv`, `t063_window.csv` oder `t063_by_date.csv` selbst nachgerechnet. Die Aussage „[number withheld] von [number withheld] empirischen Zellen passen“ beruht auf Bericht und Skriptausgabe.
- Die Qualität der Schätzung und der Simulation (Rolle `estimation`) sowie die Konsistenz zwischen Zahlen, Text und Interpretation (Rolle `consistency`).
- Die Rohdaten selbst (Download der Sina-Rosters, `MANIFEST.csv`), weil die Karte sie nicht ändert.
- Die Korrektheit der Branchenlabels im Roster. Ich habe nur gesehen, dass die drei Labels als exakte Tokens [number withheld] Firmen treffen. Kombinierte Labels mit anderem Trennzeichen als `; | ,` würden nicht erkannt, die Membership-Datei zeigt aber nur Einzellabels.
- Die Figuren (`t063_by_date.pdf`, `t063_noise_shapes.pdf`) habe ich nicht angesehen.
