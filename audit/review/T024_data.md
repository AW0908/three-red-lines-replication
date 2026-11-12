## Rolle: data (claude, opus) – VERDICT: PASS


## Befunde

Ich habe keinen Fehler in der Datenaufbereitung gefunden. Die folgenden Punkte sind nur Hinweise.

1. **Das Flag schließt Firmen nach Post-Werten aus, bei RL2 also nach dem Outcome selbst (Hinweis, Vorgabe der Karte).**
   - Die Regel `post rl2 > 5` (`07_rd.R:72–73`) entfernt Firmen wegen hoher Post-RL2-Werte, das heißt nach der abhängigen Variable der RL2-Zeile.
[firm-specific excerpt withheld in public audit]
   - Die Karte verlangt diese Regel (Runde 4, Punkt 1). Die Zeile ist als Sensitivitätsprüfung gekennzeichnet, und die Hauptstichprobe bleibt unverändert.
   - Wirkung: Die RL2-Ausschlusszeile schneidet das Outcome rechts ab. Sie ist kein Schätzer „ohne Ausreißer“ ohne Selektion. Wie das im Text zu deuten ist, prüft die Rolle consistency bzw. estimation.

2. **Extremwerte zum Stichtag 2019-12-31 erfasst das Flag nicht (gering, ohne Wirkung bei h = 0,10).**
[firm-specific excerpt withheld in public audit]
   - Beide liegen außerhalb von ±0,10 (x = 0,203 bzw. 0,213). Im primären Fenster hat keine Firma `base_rl2 > 5` oder `base_mi_share > 1`; das habe ich an allen Audit-Zeilen mit |x| ≤ 0,10 durchgesehen.
   - Wirkung: Nur die Spezifikation mit h = 0,15 und der Mittelwert als Laufvariable könnten betroffen sein. Das entspricht der Karte.

3. **Fehlendes `te` an einem Post-Stichtag zählt bei `n_post_te_nonpos` als 0 (gering).**
   - Ursache: `count_post_condition(..., na.rm = TRUE)` (`07_rd.R:68`).
   - Weil `rl2` und `mi_share` als `safe_ratio(·, te)` gebildet werden (`01_clean.R:581, 588`), sind beide an solchen Stichtagen ohnehin NA. Die Outcomes sind davon also nicht betroffen.

## Abnahmekriterien

Auflagen aus Runde 4 (Datenseite):

- **R4.1 `n_post_te_nonpos`, `n_post_mi_gt_te`, `flag_equity_problem` im Audit: belegt erfüllt.**
  - Code: `07_rd.R:67–76`; die Spalten stehen im Audit.
  - Ich habe die Flags von Hand am Audit nachgezählt:
    - 14 Firmen markiert: 000540, 000620, 000732, 000918, 002147, 0832, 1107, 1191!1, 1246, 3333, 3883, 600239, 600340, 600466.
    - 7 Firmen mit te ≤ 0 und 11 mit mi > te, wie im Bericht.
[firm-specific excerpt withheld in public audit]
[firm-specific excerpt withheld in public audit]
- **R4.2 Zwei Robustheitszeilen ohne markierte Firmen: belegt erfüllt (Fallzahlen).** Ich habe die Fallzahlen gegen das Audit nachgerechnet (`t024_rd_robustness.csv` Z. 62–63):
[firm-specific excerpt withheld in public audit]
  - **RL2, N 58 / 53:** Ausgangswert 59 / 63. Links fällt 1246 weg. Rechts fallen 10 markierte Firmen mit vorhandenem Δrl2 weg; 1107, 1191!1 und 3883 haben kein Δrl2. Deshalb sinkt `missing_outcome_right` von 8 auf 5.
  - **mi_share, N 61 / 55:** Ausgangswert 62 / 67. Links fällt 1246 weg, rechts fallen 12 Firmen weg; nur 1191!1 hat kein Δmi_share, deshalb ist `missing_outcome_right` = 3.
  - **N_eff 26 / 37 und 28 / 40:** Gegenüber der Hauptzeile (26 / 41 bzw. 28 / 44, `t024_rd_main.csv` Z. 4, 8) fallen genau die 4 markierten Firmen rechts im Fenster weg (000620, 002147, 600340, 600466) und links keine. Das stimmt mit der generierten Note „0 left, 4 right“ überein.
  - Ein `stopifnot` prüft die Zählungen (`07_rd.R:181–182`).
- **R4.3 Noten in `t024_rd_main.tex` / `t024_rd_fuzzy.tex`: belegt erfüllt.**
  - `t024_rd_main.tex` Z. 20 enthält beide Sätze wörtlich: zu Eigenkapital/D22 und „Log debt is undefined for zero debt.“
  - Die Fuzzy-Tabelle verwendet dieselben `common_notes` (`07_rd.R:366`).
  - Die Streichungen aus Runde 3 sind erhalten (kein Satz zu Juni-2020 und kein Bezug auf log assets in der Haupttabelle).
- **R4.4 Fallzahlen per sprintf, `state/` unverändert durch den Worker: belegt erfüllt.**
  - Fallzahlen: `07_rd.R:183–187` und `471–473`.
  - Die Änderung an `state/LIMITATIONS.md` sind die Einträge D22/D23 des Co-PI (Z. 59–60), wie die Karte vorsieht. `07_rd.R` liest die Datei nicht.

Allgemeine Kriterien:

1. **Fallzahlen nahe dem Cutoff: belegt erfüllt.**
   - 28 / 45 mit `stopifnot` (`07_rd.R:293`).
[firm-specific excerpt withheld in public audit]
2. **Reproduzierbarkeit: Datenseite belegt erfüllt.**
   - Das Panel wird nur gelesen (Hash-Prüfung `07_rd.R:13, 457`).
   - Fester Seed, relative Pfade, Ausgabe über ein Staging-Verzeichnis.
   - Byte-Identität zweier Läufe: nur laut `t024_verification.txt` Z. 2912–2915, nicht selbst nachgerechnet.
3. **Validitätschecks:** Datengrundlage gegenüber der Vorrunde unverändert (Dichtetest mit 135 Firmen, einseitige Placebo-Stichproben). Alles Weitere ist nicht meine Rolle.
4. **Interpretationsleitfaden:** nicht meine Rolle.

## Nicht geprüft

- **Byte-Identität der Läufe und der 65 übrigen Outputs:** nur über `t024_verification.txt` belegt, keine Hashes selbst berechnet (ich führe keine Befehle aus).
[firm-specific excerpt withheld in public audit]
- **Geänderte Dateien außerhalb des Schreibbereichs:** `replication/code/08_decomposition.R`, die `t027_*`-Outputs und `presentation/` stammen nach Lage der Dinge aus parallelen Karten (T027, Präsentation). Aus den Dateien selbst kann ich das nicht zuordnen. Das gehört zur Prüfung des Umfangs durch den Co-PI, nicht zur Datenrolle.
- **Schätzwerte, Konfidenzintervalle, TEX-Wortlaut außerhalb der Noten, Grafiken:** nicht meine Rolle.
