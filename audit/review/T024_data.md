## Rolle: data (claude, opus) – VERDICT: PASS


## Befunde

Ich habe keinen Fehler in der Datenaufbereitung gefunden. Die folgenden Punkte sind nur Hinweise.

[number withheld]. **Das Flag schließt Firmen nach Post-Werten aus, bei RL2 also nach dem Outcome selbst (Hinweis, Vorgabe der Karte).**
   - Die Regel `post rl2 > [number withheld]` (`07_rd.R:72–73`) entfernt Firmen wegen hoher Post-RL2-Werte, das heißt nach der abhängigen Variable der RL2-Zeile.
[firm-specific excerpt withheld in public process copy]
   - Die Karte verlangt diese Regel (Runde [number withheld], Punkt [number withheld]). Die Zeile ist als Sensitivitätsprüfung gekennzeichnet, und die Hauptstichprobe bleibt unverändert.
   - Wirkung: Die RL2-Ausschlusszeile schneidet das Outcome rechts ab. Sie ist kein Schätzer „ohne Ausreißer“ ohne Selektion. Wie das im Text zu deuten ist, prüft die Rolle consistency bzw. estimation.

[number withheld]. **Extremwerte zum Stichtag 2019-12-31 erfasst das Flag nicht (gering, ohne Wirkung bei h = [number withheld]).**
[firm-specific excerpt withheld in public process copy]
   - Beide liegen außerhalb von ±[number withheld] (x = [number withheld] bzw. [number withheld]). Im primären Fenster hat keine Firma `base_rl2 > [number withheld]` oder `base_mi_share > [number withheld]`; das habe ich an allen Audit-Zeilen mit |x| ≤ [number withheld] durchgesehen.
   - Wirkung: Nur die Spezifikation mit h = [number withheld] und der Mittelwert als Laufvariable könnten betroffen sein. Das entspricht der Karte.

[number withheld]. **Fehlendes `te` an einem Post-Stichtag zählt bei `n_post_te_nonpos` als [number withheld] (gering).**
   - Ursache: `count_post_condition(..., na.rm = TRUE)` (`07_rd.R:68`).
   - Weil `rl2` und `mi_share` als `safe_ratio(·, te)` gebildet werden (`01_clean.R:581, 588`), sind beide an solchen Stichtagen ohnehin NA. Die Outcomes sind davon also nicht betroffen.

## Abnahmekriterien

Auflagen aus Runde [number withheld] (Datenseite):

- **R4.[number withheld] `n_post_te_nonpos`, `n_post_mi_gt_te`, `flag_equity_problem` im Audit: belegt erfüllt.**
  - Code: `07_rd.R:67–76`; die Spalten stehen im Audit.
  - Ich habe die Flags von Hand am Audit nachgezählt:
    - [number withheld] Firmen markiert: [number withheld], [number withheld], [number withheld], [number withheld], [number withheld], [number withheld], [number withheld], [number withheld]![number withheld], [number withheld], [number withheld], [number withheld], [number withheld], [number withheld], [number withheld].
    - [number withheld] Firmen mit te ≤ [number withheld] und [number withheld] mit mi > te, wie im Bericht.
[firm-specific excerpt withheld in public process copy]
[firm-specific excerpt withheld in public process copy]
- **R4.[number withheld] Zwei Robustheitszeilen ohne markierte Firmen: belegt erfüllt (Fallzahlen).** Ich habe die Fallzahlen gegen das Audit nachgerechnet (`t024_rd_robustness.csv` Z. [number withheld]–[number withheld]):
[firm-specific excerpt withheld in public process copy]
  - **RL2, N [number withheld] / [number withheld]:** Ausgangswert [number withheld] / [number withheld]. Links fällt [number withheld] weg. Rechts fallen [number withheld] markierte Firmen mit vorhandenem Δrl2 weg; [number withheld], [number withheld]![number withheld] und [number withheld] haben kein Δrl2. Deshalb sinkt `missing_outcome_right` von [number withheld] auf [number withheld].
  - **mi_share, N [number withheld] / [number withheld]:** Ausgangswert [number withheld] / [number withheld]. Links fällt [number withheld] weg, rechts fallen [number withheld] Firmen weg; nur [number withheld]![number withheld] hat kein Δmi_share, deshalb ist `missing_outcome_right` = [number withheld].
  - **N_eff [number withheld] / [number withheld] und [number withheld] / [number withheld]:** Gegenüber der Hauptzeile ([number withheld] / [number withheld] bzw. [number withheld] / [number withheld], `t024_rd_main.csv` Z. [number withheld], [number withheld]) fallen genau die [number withheld] markierten Firmen rechts im Fenster weg ([number withheld], [number withheld], [number withheld], [number withheld]) und links keine. Das stimmt mit der generierten Note „[number withheld] left, [number withheld] right“ überein.
  - Ein `stopifnot` prüft die Zählungen (`07_rd.R:181–182`).
- **R4.[number withheld] Noten in `t024_rd_main.tex` / `t024_rd_fuzzy.tex`: belegt erfüllt.**
  - `t024_rd_main.tex` Z. [number withheld] enthält beide Sätze wörtlich: zu Eigenkapital/D2[number withheld] und „Log debt is undefined for zero debt.“
  - Die Fuzzy-Tabelle verwendet dieselben `common_notes` (`07_rd.R:366`).
  - Die Streichungen aus Runde [number withheld] sind erhalten (kein Satz zu Juni-[number withheld] und kein Bezug auf log assets in der Haupttabelle).
- **R4.[number withheld] Fallzahlen per sprintf, `state/` unverändert durch den Worker: belegt erfüllt.**
  - Fallzahlen: `07_rd.R:183–187` und `[number withheld]–[number withheld]`.
  - Die Änderung an `state/LIMITATIONS.md` sind die Einträge D2[number withheld]/D2[number withheld] des Co-PI (Z. [number withheld]–[number withheld]), wie die Karte vorsieht. `07_rd.R` liest die Datei nicht.

Allgemeine Kriterien:

[number withheld]. **Fallzahlen nahe dem Cutoff: belegt erfüllt.**
   - [number withheld] / [number withheld] mit `stopifnot` (`07_rd.R:293`).
[firm-specific excerpt withheld in public process copy]
[number withheld]. **Reproduzierbarkeit: Datenseite belegt erfüllt.**
   - Das Panel wird nur gelesen (Hash-Prüfung `07_rd.R:13, 457`).
   - Fester Seed, relative Pfade, Ausgabe über ein Staging-Verzeichnis.
   - Byte-Identität zweier Läufe: nur laut `t024_verification.txt` Z. [number withheld]–[number withheld], nicht selbst nachgerechnet.
[number withheld]. **Validitätschecks:** Datengrundlage gegenüber der Vorrunde unverändert (Dichtetest mit [number withheld] Firmen, einseitige Placebo-Stichproben). Alles Weitere ist nicht meine Rolle.
[number withheld]. **Interpretationsleitfaden:** nicht meine Rolle.

## Nicht geprüft

- **Byte-Identität der Läufe und der [number withheld] übrigen Outputs:** nur über `t024_verification.txt` belegt, keine Hashes selbst berechnet (ich führe keine Befehle aus).
[firm-specific excerpt withheld in public process copy]
- **Geänderte Dateien außerhalb des Schreibbereichs:** `replication/code/08_decomposition.R`, die `t0[number withheld]_*`-Outputs und `presentation/` stammen nach Lage der Dinge aus parallelen Karten (T027, Präsentation). Aus den Dateien selbst kann ich das nicht zuordnen. Das gehört zur Prüfung des Umfangs durch den Co-PI, nicht zur Datenrolle.
- **Schätzwerte, Konfidenzintervalle, TEX-Wortlaut außerhalb der Noten, Grafiken:** nicht meine Rolle.
