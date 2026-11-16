## Rolle: estimation (claude, opus) – VERDICT: PASS


## Befunde

Ich habe keine Fehler in Spezifikation, Inferenz oder Ausgabe gefunden. Die folgenden Punkte blockieren nicht, sollten aber vor der Übernahme in T045 bei der Interpretation beachtet werden. Der schwerste steht zuerst.

[number withheld]. **Vergleich (c) [number withheld] vs. [number withheld]–[number withheld] mischt einen Zeiteffekt mit einer anderen Zusammensetzung der Stichprobe.** [number withheld] enthält [number withheld] HK-Firma-Jahre, [number withheld] enthält [number withheld] und [number withheld] enthält [number withheld] (Bericht, Abschnitt Ausschlüsse; `t046_cash_backing_all.csv` Zeile [number withheld]: `excluded_hk_positive=[number withheld]`). Der Grund: Für [number withheld] gibt es keinen RMB-Beleg (`currency_at(id, [number withheld])` in `17_cash_backing_all.R:47–54`), weil die Berichte FY2[number withheld]/FY2[number withheld] keinen MI-Bestand für [number withheld] enthalten. Damit ist der Sprung der Kapitalquote von [number withheld] auf [number withheld] teilweise ein Effekt der Zusammensetzung. Der Worker-Bericht nennt das, aber in der Fußnote der `.tex`-Tabelle (Zeilen [number withheld]–[number withheld]) steht es nicht. Empfehlung: im Text ausdrücklich erwähnen oder eine Zeile „A-Aktien, Post [number withheld]–[number withheld]“ als Vergleich mit gleicher Zusammensetzung ergänzen. Die Karte verlangt das nicht.
[number withheld]. **Die Crosser-Gruppe ist über das Ergebnis selbst ausgewählt.** `crossers_post.csv` enthält Firmen, die [number withheld] *durch MI* überschritten haben. Für diese Firmen sind ΔMI > [number withheld] und große ΔMI fast schon per Definition gegeben, und das Flag gilt für [number withheld] und [number withheld] unabhängig vom Zeitpunkt des Überschreitens (`fy$crosser`, Zeile [number withheld]). Der Unterschied zwischen Crossern ([number withheld]) und den übrigen Firmen ([number withheld]) ist daher rein beschreibend und kein Gruppenvergleich bei gleichen Voraussetzungen. Die Karte erhebt keinen kausalen Anspruch; im Text sollte das trotzdem so formuliert werden.
[firm-specific excerpt withheld in public process copy]
[number withheld]. **Bedingung ΔMI > [number withheld]:** Der Anteil positiver Firma-Jahre unterscheidet sich je Jahr ([number withheld]/[number withheld]/[number withheld] von [number withheld]), und die Stichprobe wird über das Vorzeichen des Ergebnisses eingeschränkt. Das entspricht der Karte und dient nur dem Verständnis.

**Geprüft und korrekt:**
- **Gleichung:** Residual = ΔMI − Gewinn + Dividenden − Kapital (Zeile [number withheld]), wie in der Karte.
  - Dividenden gehen mit ihrem Betrag ein (`extract_nci_cashflow.py:432–433`), Kapital mit Vorzeichen. Das entspricht der T043-Konvention (`15_referee2.R:537`).
  - `ni_mi` ist kumuliert seit Jahresbeginn (`01_clean.R:708`). Die Dezemberzeile ist also der Jahresgewinn.
[firm-specific excerpt withheld in public process copy]
- **Kennzahlen:** Es sind Verhältnisse von Summen (Zeilen [number withheld]–[number withheld]). Zähler und Nenner nutzen dieselben vollständigen Firma-Jahre (`eligible`), und Kapital- wie Residuenquote haben dieselbe Basis.
- **Additivität:** ΔMI Crosser + Übrige [number withheld] = [number withheld] + [number withheld] = [number withheld] Mrd. = Alle [number withheld]. [number withheld] + [number withheld] = [number withheld] Mrd. = Post. Crosser [number withheld] + [number withheld] = [number withheld] Mrd.
- **Übertragung CSV → TEX → Bericht:** Alle [number withheld] Zeilen stimmen in Punktschätzer und CI-Grenzen überein (Rundung auf [number withheld] Stellen). Die Konsolenausgabe im Bericht entspricht der CSV.
- **Bootstrap:** B = [number withheld], Seed [number withheld], Mersenne-Twister wird ausdrücklich gesetzt. In jeder Zeile sind alle [number withheld] Ziehungen gültig. Perzentil-CI mit `type=[number withheld]`.
- **Fiskalische Endpunkte:** Es werden nur Endpunkte im Dezember verwendet (`report_date`-Prüfung, Zeilen [number withheld]–[number withheld]), sodass kein Juni- oder März-Abschluss als Jahresfluss eingeht.
- **Kein Treatment aus dem Outcome gebaut:** Das Crosser-Flag kommt aus einer externen Datei. Es gibt keine Kontrollvariablen, die erst nach dem Treatment entstehen.

## Abnahmekriterien

[number withheld]. **Fundstellen und Abdeckung:** nicht meine Rolle (Data). Stichprobenartig gesehen: Zeilen in `nci_cashflow_all.csv` haben Datei, Seite und Auszug, und `extraction_check` wird per Code gesetzt (`extract_nci_cashflow.py:434`).
[number withheld]. **Pilot-Abgleich:** nicht meine Rolle. Die Vergleichslogik in `17_cash_backing_all.R:127–154` ist nachvollziehbar, und die Dividenden des Pilots werden ebenfalls über ihren Betrag verglichen.
[number withheld]. **Zwei byte-identische Läufe:** Laut `t046_reproducibility.csv` sind alle [number withheld] Artefakte identisch (Hashes stimmen überein). Seed und Ziehungen sind fest. Selbst ausgeführt habe ich das nicht (siehe unten).
[number withheld]. **Verhältnisse von Summen, Ausschlüsse gezählt, keine Imputation:** belegt erfüllt. Siehe Zeilen [number withheld]–[number withheld]; die Ausschlussspalten sind in der CSV, fehlende Komponenten führen zum Ausschluss und nicht zu einem Ersatzwert (Zeilen [number withheld], [number withheld]).
[number withheld]. **Regel zur Verifikation:** nicht meine Rolle. `t046_manual_values.csv` und `t046_pi_spotcheck_20.csv` werden per Code mit festem Seed erzeugt (Zeilen [number withheld], [number withheld]–[number withheld]).

## Nicht geprüft

- **Keine eigene Ausführung** (Rolle schreibgeschützt; Shell nicht verfügbar). Byte-Identität, Bootstrap-Quantile und alle Firma-Jahr-Summen habe ich nicht selbst nachgerechnet. Geprüft habe ich nur die Additivität der Aggregate und ein vollständiges Firma-Jahr.
[firm-specific excerpt withheld in public process copy]
- **Herleitung der HK-Währung (`t046_currency_audit.csv`) und Bildung des Panels:** gehört zur Rolle Data.
- **Grafik `t046_cash_share.pdf`:** nicht visuell geprüft.
