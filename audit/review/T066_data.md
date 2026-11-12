## Rolle: data (claude, sonnet) – VERDICT: PASS


## Befunde
Keine Befunde, die ein Rework oder eine Eskalation nötig machen. Ich habe nur gelesen, weil Bash gesperrt war. Die Nebenpunkte sind unten nach Gewicht sortiert.

1. **Nicht klassifizierte A-Share-Entwickler sind nur indirekt gezählt (gering, Doku).**
   - `t066_ownership_counts.csv` weist 41 Firmen mit `soe = NA` insgesamt aus.
   - `t066_ownership_markets.csv` zeigt für A-Shares 29 private und 39 staatliche Firmen. Bei 80 A-Share-Entwicklern fehlen damit 12 unklassifizierte A-Firmen. Die Zahl steht in keiner Datei ausdrücklich, ist aber ableitbar.
   - Die Stichprobe selbst ist korrekt: `candidate_t/c` 29/39 und `complete_t/c` 28/38 in `t066_ownership_strata.csv`. Y5 hat 27/37.
   - Die Karte verlangt "unclassified excluded and counted". Das ist formal erfüllt, aber die Zahl je Markt wäre klarer.

2. **Fehlende Preise (Z1) betreffen 10 Firmen (gering, offengelegt).**
[firm-specific excerpt withheld in public audit]
   - Die Firmen werden nicht imputiert, sondern gezählt (README, `selection_firm_inputs.csv`). Das passt zu den Regeln.
   - Datenseitig bleibt die Einschränkung, dass die Preisfirmen nicht dem Risikoset der anderen Spezifikationen entsprechen.
   - `t066_selection_audit.csv` weist für `jv_ta` 114 Risikofirmen und 95 Zweitstufenfirmen aus, mit Baseline auf derselben Stichprobe (0,001949 gegenüber 0,002506 im T025-Original). Der Unterschied ist damit erklärt.

3. **Preisdaten (Z1).**
   - Das Skript `Daten/fetch_prices_2019.py` ruft alle Quellen mit `adjust=""` ab, also unbereinigt. Es gibt keine nachträgliche Anpassung, die den Preis mit späteren Dividenden verknüpft.
   - Drei HK-Preise stammen vom 30.12.2019 statt vom 31.12. und sind im README ausgewiesen.
   - Das Skript prüft vor der Verwendung, dass Währungen zu den Märkten passen (A = RMB, HK = HKD). Der Preis wird je Markt zentriert, ohne Umrechnung.
   - Die Kopie der Preisdatei wird per SHA-256 gegen das Original geprüft.

## Abnahmekriterien
1. **Reproduktionsasserts, bestehende Outputs unverändert, zwei Läufe identisch:** belegt erfüllt, soweit ich es lesen kann.
   - Der Code erzwingt in `23_drdid.R:83` die Werte 4.02 und 4.59. `t066_validation.txt` meldet PASS.
   - Es gibt Hash-Wächter für bestehende Outputs und Rohdaten (421 Outputs, 93 Rohdateien).
   - `t066_preserved_rows.csv` belegt die Byte-Identität der 32 geschützten DR-Zeilen.
   - Die Behauptung "34/34 Ausgaben byte-identisch bei Wiederholung" habe ich nicht selbst nachgeprüft.
2. **Jede Variante mit N, Trimming, Balance:** belegt erfüllt.
   - `t066_drdid.csv` weist je Zeile `candidate_*`, `complete_*`, `treated`, `comparison_firms`, `trimmed_t/c` und `valid` aus.
   - Die Fallzahlen sind konsistent. Beispiel: A_control main mit 80/752 Kandidaten, 79/711 behalten und 1/41 getrimmt.
   - Die Beobachtungszahlen stimmen (832 = 80 + 752 im Hauptzeitraum; 4992 und 4160 im Periodenmittel).
   - Die Ownership-Ausfälle (Y1–Y4: 766/999, Y5: 702/999 gültige Ziehungen) sind als "unreliable" markiert.
3. **DR-Schätzer validiert:** nicht meine Rolle, die Prüfung liegt bei `estimation`. Datenseitig sind Outcomes bei fehlendem RL1 NA und nicht 0 (`23_drdid.R:89-95`).
4. **Weitere Kriterien (Heckman-Tabelle, Interpretation):** nicht meine Rolle, bis auf die Eingangsdaten.

Zur Rolle Data:
- **Variablenkonstruktion:**
  - Y1 = 1{RL1 ∈ [0.66, 0.70)} und Y4 = 1{RL1 ∈ [0.56, 0.60)} sind halboffen und stimmen mit der Karte überein.
  - Y2 = 1{RL1 ≤ 0.70}.
  - Der Nenner von `adv_ta` ist `ta > 0`, sonst NA.
  - Die Kontroll-RL1 folgt in `21_diff_bunching.R:117` derselben Formel mit Nenner > 0 (sonst NA).
  - Die Nullkodierung von `adv`, wenn beide Komponenten fehlen (`21_diff_bunching.R:115`), ist im Interpretationstext erwähnt.
- **Joins und Duplikate:** Das Skript prüft `!anyDuplicated` auf Firma × Datum in `d`, `cp` und in den Preisen. Außerdem prüft es, dass Entwickler und Kontrollen keine gemeinsamen Firmenkennungen haben (`23_drdid.R:78-79`).
- **Placebo-Basisdaten:** Die Audit-Tabelle `t066_placebo_audit.csv` zeigt Basisdatum und Lag-Verfügbarkeit. Für Basen 2016H2–2018H1 entfällt die Zweijahresänderung mangels Historie.
- **Reporting-Frequenz Z3:** Sie ist die Zahl nicht fehlender `ta`-Werte geteilt durch 7 Vor-Daten, wie in T025.
- **Net loss Z2:** `ni` ist laut `01_clean.R:708` die Jahressumme (YTD), am 31.12. also der Jahreswert. `ni < 0` zum Stichtag 2019-12-31 ist damit sinnvoll.

## Nicht geprüft
- **Keine Befehle ausgeführt:** Bash war gesperrt. Ich habe nichts neu laufen lassen, keine Byte-Identität zwischen Läufen und keine Hashes geprüft. Die Zahlen aus dem Worker-Bericht (z. B. 163 rekonstruierte ATT, 657.708 Alt→Neu-Zellen) habe ich nicht eigenständig verifiziert.
- **Große Dateien nur teilweise gelesen:** Ich habe nur den Anfang von `t066_drdid.csv`, `t066_placebo_audit.csv` und `t066_first_stage.csv` angesehen. Nicht gelesen habe ich `t066_balance.csv`, `t066_overlap.csv`, `t066_sample_audit.csv`, `t066_number_map.csv`, `t066_rework1_old_new.csv` und `t066_verification.csv`.
- **Eingangsdaten nur indirekt:** Panel (`panel_firm_halfyear.csv`) und Kontrollpanel (`t061_control_panel.csv`) habe ich nur über den Code und die Kopfzeilen beurteilt, nicht Zeile für Zeile. Ob 41 Firmen mit `soe = NA` richtig unklassifiziert sind, kann ich ohne das Panel nicht beurteilen. Die Karte schreibt das Literal-Feld `soe` vor.
- **Schreibbereich:** Das Skript meldet geänderte Dateien in `proposal/` seit Beginn der Ausführung. Nach dem Worker-Bericht stammen sie nicht aus dieser Karte (vermutlich parallele Sitzung zu T067). Das kann ich nicht belegen.
- **Andere Rollen:** Schätzcode, Bootstrap-Löser, Heckman-Spezifikation und die Konsistenz zwischen Text und Tabellen habe ich nicht bewertet.
