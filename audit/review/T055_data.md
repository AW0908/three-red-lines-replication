## Rolle: data (claude, sonnet) – VERDICT: PASS

Ich habe Karte, Worker-Bericht, `19_referee3.R`, die Konventionen aus `11_mechanism.R` und `15_referee2.R` sowie die Ausgabetabellen gelesen. Jetzt folgt das Urteil der Rolle `data`.

VERDICT: PASS

## Befunde
Keine inhaltlichen Fehler in der Datenaufbereitung gefunden. Es bleiben drei Hinweise ohne Einfluss auf das Urteil:

[firm-specific excerpt withheld in public audit]
2. **Pfad-Scope:** Der Platzhalter-Anker 2017-06-30 in der Trend-Tabelle ist über den Kartentext hinaus berechnet. Er liefert nur Zeilen mit n=0 (`NA`-Schätzer), und die Zeilen sind als nicht verfügbar gekennzeichnet. Das schadet nicht, bläht aber die Tabelle auf.
3. **Dokumentation:** `state/LIMITATIONS.md` und `AI_USAGE_LOG.md` habe ich nicht eingesehen. Es sind keine neuen Imputationen im Skript, daher ist keine LIMITATIONS-Ergänzung nötig. Der Log-Eintrag steht laut Bericht noch aus, das ist erst nach Abnahme vorgesehen.

## Abnahmekriterien
Soweit meine Rolle betroffen ist:

- **Kriterium 1, Reproduktion:** Belegt erfüllt. Das Skript prüft per `stopifnot` b_post=3,14, D=0,1146, 602 Beobachtungen und 129 Firmen (Z. 67–70). Der Vergleich mit T029 erfolgt auf 1e-12. Eingaben und geschützte Outputs sind per SHA-256 gesichert (Z. 13–16, 414–415). Die Verifikationsdatei bestätigt das. Ob zwei Läufe bytegleich sind, habe ich nicht selbst geprüft. Der Mechanismus dafür ist vorhanden: gestufte Dateien, Vergleich vor dem Überschreiben (Z. 418–430).
- **Kriterium 2, Varianten und Fallzahlen:** Belegt erfüllt.
  - Fallzahlen und Zeilenzahlen: Die Zeilenzahlen werden hart geprüft (16 Shift-, 44 κ-, 9 Falsifikations-, 20 Trendzeilen), N und Firmen stehen in jeder Zeile.
  - Stichproben: Post 602/129 und Placebo 616/125. Falsifikation Prä 797/136 und Post 630/132, mit der Prüfung, dass die Stichprobe identisch zur RL1-Stichprobe ist (Z. 236).
  - κ-Raster: Das Raster 0..1 in Schritten von 0,1 ist vollständig, mit Prüfungen `x>=R` und `x(κ=0)=R`.
- **Kriterium 3, keine Handdaten:** Belegt erfüllt. Das Skript liest nur das Panel und vorhandene Output-CSVs, ohne Downloads.

Prüfung der Konstruktionen am Code:
- **Eingefrorenes RL1:** `N/(N+te−mi+mi_anchor)` entspricht der Konvention aus `11_mechanism.R`. Anker end-2019 und end-2016 stimmen mit dem Placebo-Fenster 2017H2–2019H2 überein. Nenner ≤ 0 und fehlende Werte werden zu NA. Der Shift in Prozentpunkten (`100*(F−R)`) hat das erwartete Vorzeichen.
- **κ-Umklassifizierung:** `(N+κ·max(ΔMI,0))/(N+E)`. Der Nenner bleibt erhalten, die Prüfung auf Monotonie läuft.
- **Rohquote:** `tl/ta` mit `ta>0`, nicht `rl1_alt`.
- **Lineare Trendregel:** Sie entspricht T043. Fenster sind 3 Jahre, mindestens 4 Beobachtungen und kein nichtpositives MI. Das Bin-Fallback, die Bins `060_066`, `066_074`, `074_080` und der Anker am tatsächlichen Anker-MI stimmen mit `15_referee2.R` Z. 632–643 überein. Nur die Steigung ist hier linear in Niveaus statt log.
- **IPW-Gewichte:** Sie sind in jeder Bootstrapziehung neu berechnet, und fehlende Unterstützung macht die Ziehung ungültig.
- **Kopierte Pretrend-Tests:** Es sind 9 Tests. Der Wert p(C3-date)=0,0002 wird geprüft.
- **Build:** `19_referee3.R` steht in `run_all.sh` und `run_all.R` jeweils zuletzt.

## Nicht geprüft
- **Befehle:** Bash war in dieser Sitzung verweigert, ich habe nichts ausgeführt und die Byte-Gleichheit der beiden Läufe nicht selbst reproduziert.
- **Tabellen und PDF:** Ich habe `t055_kappa.csv`, `t055_bootstrap_draws.csv`, `t055_sample_audit.csv`, die `.tex`-Dateien und das PDF nicht zeilenweise gelesen.
- **Eingabepanel:** Die Rohdatenaufbereitung im Panel selbst (T004/T029) und die HK-Währungsfrage liegen außerhalb dieser Karte.
- **Schätzung, Konsistenz, Sprache:** Estimation-, Consistency- und Language-Aspekte, etwa die Bootstrap-Logik und die Interpretation im Bericht, sind nicht meine Rolle.
