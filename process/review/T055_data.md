## Rolle: data (claude, sonnet) – VERDICT: PASS

Ich habe Karte, Worker-Bericht, `19_referee3.R`, die Konventionen aus `11_mechanism.R` und `15_referee2.R` sowie die Ausgabetabellen gelesen. Jetzt folgt das Urteil der Rolle `data`.

VERDICT: PASS

## Befunde
Keine inhaltlichen Fehler in der Datenaufbereitung gefunden. Es bleiben drei Hinweise ohne Einfluss auf das Urteil:

[firm-specific excerpt withheld in public process copy]
[number withheld]. **Pfad-Scope:** Der Platzhalter-Anker 2017-06-30 in der Trend-Tabelle ist über den Kartentext hinaus berechnet. Er liefert nur Zeilen mit n=[number withheld] (`NA`-Schätzer), und die Zeilen sind als nicht verfügbar gekennzeichnet. Das schadet nicht, bläht aber die Tabelle auf.
[number withheld]. **Dokumentation:** `state/LIMITATIONS.md` und `AI_USAGE_LOG.md` habe ich nicht eingesehen. Es sind keine neuen Imputationen im Skript, daher ist keine LIMITATIONS-Ergänzung nötig. Der Log-Eintrag steht laut Bericht noch aus, das ist erst nach Abnahme vorgesehen.

## Abnahmekriterien
Soweit meine Rolle betroffen ist:

- **Kriterium [number withheld], Reproduktion:** Belegt erfüllt. Das Skript prüft per `stopifnot` b_post=[number withheld], D=[number withheld], [number withheld] Beobachtungen und [number withheld] Firmen (Z. [number withheld]–[number withheld]). Der Vergleich mit T029 erfolgt auf [number withheld]. Eingaben und geschützte Outputs sind per SHA-[number withheld] gesichert (Z. [number withheld]–[number withheld], [number withheld]–[number withheld]). Die Verifikationsdatei bestätigt das. Ob zwei Läufe bytegleich sind, habe ich nicht selbst geprüft. Der Mechanismus dafür ist vorhanden: gestufte Dateien, Vergleich vor dem Überschreiben (Z. [number withheld]–[number withheld]).
- **Kriterium [number withheld], Varianten und Fallzahlen:** Belegt erfüllt.
  - Fallzahlen und Zeilenzahlen: Die Zeilenzahlen werden hart geprüft ([number withheld] Shift-, [number withheld] κ-, [number withheld] Falsifikations-, [number withheld] Trendzeilen), N und Firmen stehen in jeder Zeile.
  - Stichproben: Post [number withheld]/[number withheld] und Placebo [number withheld]/[number withheld]. Falsifikation Prä [number withheld]/[number withheld] und Post [number withheld]/[number withheld], mit der Prüfung, dass die Stichprobe identisch zur RL1-Stichprobe ist (Z. [number withheld]).
  - κ-Raster: Das Raster [number withheld]..[number withheld] in Schritten von [number withheld] ist vollständig, mit Prüfungen `x>=R` und `x(κ=[number withheld])=R`.
- **Kriterium [number withheld], keine Handdaten:** Belegt erfüllt. Das Skript liest nur das Panel und vorhandene Output-CSVs, ohne Downloads.

Prüfung der Konstruktionen am Code:
- **Eingefrorenes RL1:** `N/(N+te−mi+mi_anchor)` entspricht der Konvention aus `11_mechanism.R`. Anker end-[number withheld] und end-[number withheld] stimmen mit dem Placebo-Fenster [number withheld]H2–[number withheld]H2 überein. Nenner ≤ [number withheld] und fehlende Werte werden zu NA. Der Shift in Prozentpunkten (`[number withheld]*(F−R)`) hat das erwartete Vorzeichen.
- **κ-Umklassifizierung:** `(N+κ·max(ΔMI,[number withheld]))/(N+E)`. Der Nenner bleibt erhalten, die Prüfung auf Monotonie läuft.
- **Rohquote:** `tl/ta` mit `ta>[number withheld]`, nicht `rl1_alt`.
- **Lineare Trendregel:** Sie entspricht T043. Fenster sind [number withheld] Jahre, mindestens [number withheld] Beobachtungen und kein nichtpositives MI. Das Bin-Fallback, die Bins `[number withheld]_0[number withheld]`, `[number withheld]_0[number withheld]`, `[number withheld]_0[number withheld]` und der Anker am tatsächlichen Anker-MI stimmen mit `15_referee2.R` Z. [number withheld]–[number withheld] überein. Nur die Steigung ist hier linear in Niveaus statt log.
- **IPW-Gewichte:** Sie sind in jeder Bootstrapziehung neu berechnet, und fehlende Unterstützung macht die Ziehung ungültig.
- **Kopierte Pretrend-Tests:** Es sind [number withheld] Tests. Der Wert p(C3-date)=[number withheld] wird geprüft.
- **Build:** `19_referee3.R` steht in `run_all.sh` und `run_all.R` jeweils zuletzt.

## Nicht geprüft
- **Befehle:** Bash war in dieser Sitzung verweigert, ich habe nichts ausgeführt und die Byte-Gleichheit der beiden Läufe nicht selbst reproduziert.
- **Tabellen und PDF:** Ich habe `t055_kappa.csv`, `t055_bootstrap_draws.csv`, `t055_sample_audit.csv`, die `.tex`-Dateien und das PDF nicht zeilenweise gelesen.
- **Eingabepanel:** Die Rohdatenaufbereitung im Panel selbst (T004/T029) und die HK-Währungsfrage liegen außerhalb dieser Karte.
- **Schätzung, Konsistenz, Sprache:** Estimation-, Consistency- und Language-Aspekte, etwa die Bootstrap-Logik und die Interpretation im Bericht, sind nicht meine Rolle.
