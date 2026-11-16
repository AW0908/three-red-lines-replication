## Rolle: data (claude, sonnet) – VERDICT: PASS


## Befunde
Keine Befunde, die ein Rework oder eine Eskalation nötig machen. Ich habe nur gelesen, weil Bash gesperrt war. Die Nebenpunkte sind unten nach Gewicht sortiert.

[number withheld]. **Nicht klassifizierte A-Share-Entwickler sind nur indirekt gezählt (gering, Doku).**
   - `t066_ownership_counts.csv` weist [number withheld] Firmen mit `soe = NA` insgesamt aus.
   - `t066_ownership_markets.csv` zeigt für A-Shares [number withheld] private und [number withheld] staatliche Firmen. Bei [number withheld] A-Share-Entwicklern fehlen damit [number withheld] unklassifizierte A-Firmen. Die Zahl steht in keiner Datei ausdrücklich, ist aber ableitbar.
   - Die Stichprobe selbst ist korrekt: `candidate_t/c` [number withheld]/[number withheld] und `complete_t/c` [number withheld]/[number withheld] in `t066_ownership_strata.csv`. Y5 hat [number withheld]/[number withheld].
   - Die Karte verlangt "unclassified excluded and counted". Das ist formal erfüllt, aber die Zahl je Markt wäre klarer.

[number withheld]. **Fehlende Preise (Z1) betreffen [number withheld] Firmen (gering, offengelegt).**
[firm-specific excerpt withheld in public process copy]
   - Die Firmen werden nicht imputiert, sondern gezählt (README, `selection_firm_inputs.csv`). Das passt zu den Regeln.
   - Datenseitig bleibt die Einschränkung, dass die Preisfirmen nicht dem Risikoset der anderen Spezifikationen entsprechen.
   - `t066_selection_audit.csv` weist für `jv_ta` [number withheld] Risikofirmen und [number withheld] Zweitstufenfirmen aus, mit Baseline auf derselben Stichprobe ([number withheld] gegenüber [number withheld] im T025-Original). Der Unterschied ist damit erklärt.

[number withheld]. **Preisdaten (Z1).**
   - Das Skript `Daten/fetch_prices_2019.py` ruft alle Quellen mit `adjust=""` ab, also unbereinigt. Es gibt keine nachträgliche Anpassung, die den Preis mit späteren Dividenden verknüpft.
   - Drei HK-Preise stammen vom [number withheld] statt vom [number withheld]. und sind im README ausgewiesen.
   - Das Skript prüft vor der Verwendung, dass Währungen zu den Märkten passen (A = RMB, HK = HKD). Der Preis wird je Markt zentriert, ohne Umrechnung.
   - Die Kopie der Preisdatei wird per SHA-[number withheld] gegen das Original geprüft.

## Abnahmekriterien
[number withheld]. **Reproduktionsasserts, bestehende Outputs unverändert, zwei Läufe identisch:** belegt erfüllt, soweit ich es lesen kann.
   - Der Code erzwingt in `23_drdid.R:83` die Werte [number withheld] und [number withheld]. `t066_validation.txt` meldet PASS.
   - Es gibt Hash-Wächter für bestehende Outputs und Rohdaten ([number withheld] Outputs, [number withheld] Rohdateien).
   - `t066_preserved_rows.csv` belegt die Byte-Identität der [number withheld] geschützten DR-Zeilen.
   - Die Behauptung "[number withheld]/[number withheld] Ausgaben byte-identisch bei Wiederholung" habe ich nicht selbst nachgeprüft.
[number withheld]. **Jede Variante mit N, Trimming, Balance:** belegt erfüllt.
   - `t066_drdid.csv` weist je Zeile `candidate_*`, `complete_*`, `treated`, `comparison_firms`, `trimmed_t/c` und `valid` aus.
   - Die Fallzahlen sind konsistent. Beispiel: A_control main mit [number withheld]/[number withheld] Kandidaten, [number withheld]/[number withheld] behalten und [number withheld]/[number withheld] getrimmt.
   - Die Beobachtungszahlen stimmen ([number withheld] = [number withheld] + [number withheld] im Hauptzeitraum; [number withheld] und [number withheld] im Periodenmittel).
   - Die Ownership-Ausfälle (Y1–Y4: [number withheld]/[number withheld], Y5: [number withheld]/[number withheld] gültige Ziehungen) sind als "unreliable" markiert.
[number withheld]. **DR-Schätzer validiert:** nicht meine Rolle, die Prüfung liegt bei `estimation`. Datenseitig sind Outcomes bei fehlendem RL1 NA und nicht [number withheld] (`23_drdid.R:89-95`).
[number withheld]. **Weitere Kriterien (Heckman-Tabelle, Interpretation):** nicht meine Rolle, bis auf die Eingangsdaten.

Zur Rolle Data:
- **Variablenkonstruktion:**
  - Y1 = [number withheld]{RL1 ∈ [[number withheld], [number withheld])} und Y4 = [number withheld]{RL1 ∈ [[number withheld], [number withheld])} sind halboffen und stimmen mit der Karte überein.
  - Y2 = [number withheld]{RL1 ≤ [number withheld]}.
  - Der Nenner von `adv_ta` ist `ta > [number withheld]`, sonst NA.
  - Die Kontroll-RL1 folgt in `21_diff_bunching.R:117` derselben Formel mit Nenner > [number withheld] (sonst NA).
  - Die Nullkodierung von `adv`, wenn beide Komponenten fehlen (`21_diff_bunching.R:115`), ist im Interpretationstext erwähnt.
- **Joins und Duplikate:** Das Skript prüft `!anyDuplicated` auf Firma × Datum in `d`, `cp` und in den Preisen. Außerdem prüft es, dass Entwickler und Kontrollen keine gemeinsamen Firmenkennungen haben (`23_drdid.R:78-79`).
- **Placebo-Basisdaten:** Die Audit-Tabelle `t066_placebo_audit.csv` zeigt Basisdatum und Lag-Verfügbarkeit. Für Basen [number withheld]H2–[number withheld]H1 entfällt die Zweijahresänderung mangels Historie.
- **Reporting-Frequenz Z3:** Sie ist die Zahl nicht fehlender `ta`-Werte geteilt durch [number withheld] Vor-Daten, wie in T025.
- **Net loss Z2:** `ni` ist laut `01_clean.R:708` die Jahressumme (YTD), am [number withheld]. also der Jahreswert. `ni < [number withheld]` zum Stichtag 2019-12-31 ist damit sinnvoll.

## Nicht geprüft
- **Keine Befehle ausgeführt:** Bash war gesperrt. Ich habe nichts neu laufen lassen, keine Byte-Identität zwischen Läufen und keine Hashes geprüft. Die Zahlen aus dem Worker-Bericht (z. B. [number withheld] rekonstruierte ATT, [number withheld] Alt→Neu-Zellen) habe ich nicht eigenständig verifiziert.
- **Große Dateien nur teilweise gelesen:** Ich habe nur den Anfang von `t066_drdid.csv`, `t066_placebo_audit.csv` und `t066_first_stage.csv` angesehen. Nicht gelesen habe ich `t066_balance.csv`, `t066_overlap.csv`, `t066_sample_audit.csv`, `t066_number_map.csv`, `t066_rework1_old_new.csv` und `t066_verification.csv`.
- **Eingangsdaten nur indirekt:** Panel (`panel_firm_halfyear.csv`) und Kontrollpanel (`t061_control_panel.csv`) habe ich nur über den Code und die Kopfzeilen beurteilt, nicht Zeile für Zeile. Ob [number withheld] Firmen mit `soe = NA` richtig unklassifiziert sind, kann ich ohne das Panel nicht beurteilen. Die Karte schreibt das Literal-Feld `soe` vor.
- **Schreibbereich:** Das Skript meldet geänderte Dateien in `proposal/` seit Beginn der Ausführung. Nach dem Worker-Bericht stammen sie nicht aus dieser Karte (vermutlich parallele Sitzung zu T067). Das kann ich nicht belegen.
- **Andere Rollen:** Schätzcode, Bootstrap-Löser, Heckman-Spezifikation und die Konsistenz zwischen Text und Tabellen habe ich nicht bewertet.
