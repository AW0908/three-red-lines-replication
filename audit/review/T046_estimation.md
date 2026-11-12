## Rolle: estimation (claude, opus) – VERDICT: PASS


## Befunde

Ich habe keine Fehler in Spezifikation, Inferenz oder Ausgabe gefunden. Die folgenden Punkte blockieren nicht, sollten aber vor der Übernahme in T045 bei der Interpretation beachtet werden. Der schwerste steht zuerst.

1. **Vergleich (c) 2019 vs. 2020–2021 mischt einen Zeiteffekt mit einer anderen Zusammensetzung der Stichprobe.** 2019 enthält 0 HK-Firma-Jahre, 2020 enthält 17 und 2021 enthält 14 (Bericht, Abschnitt Ausschlüsse; `t046_cash_backing_all.csv` Zeile 2: `excluded_hk_positive=40`). Der Grund: Für 2018 gibt es keinen RMB-Beleg (`currency_at(id, 2018)` in `17_cash_backing_all.R:47–54`), weil die Berichte FY2020/FY2021 keinen MI-Bestand für 2018 enthalten. Damit ist der Sprung der Kapitalquote von 0,526 auf 0,880 teilweise ein Effekt der Zusammensetzung. Der Worker-Bericht nennt das, aber in der Fußnote der `.tex`-Tabelle (Zeilen 23–28) steht es nicht. Empfehlung: im Text ausdrücklich erwähnen oder eine Zeile „A-Aktien, Post 2020–2021“ als Vergleich mit gleicher Zusammensetzung ergänzen. Die Karte verlangt das nicht.
2. **Die Crosser-Gruppe ist über das Ergebnis selbst ausgewählt.** `crossers_post.csv` enthält Firmen, die 0,70 *durch MI* überschritten haben. Für diese Firmen sind ΔMI > 0 und große ΔMI fast schon per Definition gegeben, und das Flag gilt für 2020 und 2021 unabhängig vom Zeitpunkt des Überschreitens (`fy$crosser`, Zeile 78). Der Unterschied zwischen Crossern (0,966) und den übrigen Firmen (0,808) ist daher rein beschreibend und kein Gruppenvergleich bei gleichen Voraussetzungen. Die Karte erhebt keinen kausalen Anspruch; im Text sollte das trotzdem so formuliert werden.
[firm-specific excerpt withheld in public audit]
4. **Bedingung ΔMI > 0:** Der Anteil positiver Firma-Jahre unterscheidet sich je Jahr (96/90/68 von 136), und die Stichprobe wird über das Vorzeichen des Ergebnisses eingeschränkt. Das entspricht der Karte und dient nur dem Verständnis.

**Geprüft und korrekt:**
- **Gleichung:** Residual = ΔMI − Gewinn + Dividenden − Kapital (Zeile 72), wie in der Karte.
  - Dividenden gehen mit ihrem Betrag ein (`extract_nci_cashflow.py:432–433`), Kapital mit Vorzeichen. Das entspricht der T043-Konvention (`15_referee2.R:537`).
  - `ni_mi` ist kumuliert seit Jahresbeginn (`01_clean.R:708`). Die Dezemberzeile ist also der Jahresgewinn.
[firm-specific excerpt withheld in public audit]
- **Kennzahlen:** Es sind Verhältnisse von Summen (Zeilen 174–175). Zähler und Nenner nutzen dieselben vollständigen Firma-Jahre (`eligible`), und Kapital- wie Residuenquote haben dieselbe Basis.
- **Additivität:** ΔMI Crosser + Übrige 2020 = 156,011 + 183,778 = 339,789 Mrd. = Alle 2020. 2020 + 2021 = 602,393 Mrd. = Post. Crosser 2020 + 2021 = 272,822 Mrd.
- **Übertragung CSV → TEX → Bericht:** Alle 12 Zeilen stimmen in Punktschätzer und CI-Grenzen überein (Rundung auf 3 Stellen). Die Konsolenausgabe im Bericht entspricht der CSV.
- **Bootstrap:** B = 999, Seed 20261029, Mersenne-Twister wird ausdrücklich gesetzt. In jeder Zeile sind alle 999 Ziehungen gültig. Perzentil-CI mit `type=7`.
- **Fiskalische Endpunkte:** Es werden nur Endpunkte im Dezember verwendet (`report_date`-Prüfung, Zeilen 64–65), sodass kein Juni- oder März-Abschluss als Jahresfluss eingeht.
- **Kein Treatment aus dem Outcome gebaut:** Das Crosser-Flag kommt aus einer externen Datei. Es gibt keine Kontrollvariablen, die erst nach dem Treatment entstehen.

## Abnahmekriterien

1. **Fundstellen und Abdeckung:** nicht meine Rolle (Data). Stichprobenartig gesehen: Zeilen in `nci_cashflow_all.csv` haben Datei, Seite und Auszug, und `extraction_check` wird per Code gesetzt (`extract_nci_cashflow.py:434`).
2. **Pilot-Abgleich:** nicht meine Rolle. Die Vergleichslogik in `17_cash_backing_all.R:127–154` ist nachvollziehbar, und die Dividenden des Pilots werden ebenfalls über ihren Betrag verglichen.
3. **Zwei byte-identische Läufe:** Laut `t046_reproducibility.csv` sind alle 13 Artefakte identisch (Hashes stimmen überein). Seed und Ziehungen sind fest. Selbst ausgeführt habe ich das nicht (siehe unten).
4. **Verhältnisse von Summen, Ausschlüsse gezählt, keine Imputation:** belegt erfüllt. Siehe Zeilen 172–195; die Ausschlussspalten sind in der CSV, fehlende Komponenten führen zum Ausschluss und nicht zu einem Ersatzwert (Zeilen 70, 73).
5. **Regel zur Verifikation:** nicht meine Rolle. `t046_manual_values.csv` und `t046_pi_spotcheck_20.csv` werden per Code mit festem Seed erzeugt (Zeilen 110, 201–204).

## Nicht geprüft

- **Keine eigene Ausführung** (Rolle schreibgeschützt; Shell nicht verfügbar). Byte-Identität, Bootstrap-Quantile und alle Firma-Jahr-Summen habe ich nicht selbst nachgerechnet. Geprüft habe ich nur die Additivität der Aggregate und ein vollständiges Firma-Jahr.
[firm-specific excerpt withheld in public audit]
- **Herleitung der HK-Währung (`t046_currency_audit.csv`) und Bildung des Panels:** gehört zur Rolle Data.
- **Grafik `t046_cash_share.pdf`:** nicht visuell geprüft.
