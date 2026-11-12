## Rolle: data (claude, sonnet) – VERDICT: PASS


## Befunde

Alle Befunde sind geringfügig und betreffen die Rolle `data`. Keiner ändert die berichteten Quoten. Ich konnte keine Befehle ausführen (Bash war gesperrt) und habe nur gelesen. Zahlen habe ich nicht neu gerechnet, sondern an Code, CSVs und Verifikationstext gegengelesen.

1. **Strich-Werte sind trivial `exact`.**
   - Beleg: `extract_nci_cashflow.py:434` setzt `exact`, wenn `tok in pages[pg]`. Bei einem gedruckten Strich ist `tok` gleich `-`, und das steht auf praktisch jeder Seite. Die Werte sind also automatisch `exact`.
[firm-specific excerpt withheld in public audit]
   - Wirkung: Die Zahl 538 `exact` im Bericht enthält diese 31 Zeilen. Dass der Strich in der richtigen Spalte steht, belegt der Code nicht.
   - Die Stichproben, die ich ansehen konnte (Zeile 59: `- 490,000.00` ergibt aktuell 0 und Vorjahr 490.000), sind plausibel. Eine falsch zugeordnete Null bliebe im Code aber unentdeckt und ginge als 0 in die Quoten.
   - Empfehlung: Strich-Werte getrennt ausweisen (`exact` nur für Zahlenstrings) oder in die PI-Stichprobe aufnehmen. Das ist kein Blocker.

2. **Die `exact`-Prüfung ist eine Seitensubstring-Prüfung, keine Zeilen- oder Spaltenprüfung.**
   - Beleg: `extract_nci_cashflow.py:434` und `verify()` Zeile 509 prüfen nur die Seite.
   - Wirkung: Eine Zahl aus der falschen Spalte oder Zeile derselben Seite würde bestehen. Das entspricht der vom PI beschlossenen Regel („Level-String auf der zitierten Seite“). Die Restunsicherheit liegt bei der Stichprobe des PI.

3. **Gedruckte Seitenzahl teils zweifelhaft.**
[firm-specific excerpt withheld in public audit]
   - Wirkung: Das Kriterium verlangt die physische Seite; sie ist gesetzt und wird geprüft. Die gedruckte Seite ist Zusatzinformation, aber nicht überall verlässlich.

4. **Interne Konsistenz der Stichprobe stimmt.**
   - 96/90/68 positive Firma-Jahre ergeben 28/43/38 eingeschlossene, also 68/47/30 ausgeschlossene. Das passt zur Summe 109.
   - Crosser 33 plus übrige 48 ergeben 81 (Post).
   - Der Code prüft `G==136` und 31 Crosser, die alle in der Hauptstichprobe liegen. Er prüft Eindeutigkeit von Firma×Datum und Firma×Jahr×Metrik.
   - Der Berichtsvintage-Abgleich (`expected_report`, Zeilen 41–44) entspricht der Kartenregel.

5. **Hinweise ohne Mangel.**
   - **Crosser-Flag:** `crosser` markiert eine Firma über alle Jahre, auch für 2020 bei Firmen, die erst 2021 gekreuzt haben. Das ist eine Designentscheidung und im Bericht als Gruppierung nach Firma dokumentiert.
   - **Pre-Vergleich:** 2019 enthält nur A-Aktien (28/0), Post enthält 31 HK-Firma-Jahre. Die Pre/Post-Differenz ist deshalb auch eine Zusammensetzungsdifferenz. Der Bericht nennt das offen.
   - **Vintage:** ΔMI und Gewinn kommen aus dem Panel, die Cashflows aus FY2020 bzw. FY2021 (Vergleichsspalten, möglicherweise restated). Das steht nicht ausdrücklich in den Limitationen. Ich empfehle, es in `state/LIMITATIONS.md` oder im Text zu erwähnen.

## Abnahmekriterien

1. **Datei, Seite, Auszug, `extraction_check` per Code, Abdeckungstabelle.** Belegt erfüllt, mit Einschränkung zu Befund 1 und 3. Die Spalten file, pdf_page, printed_page, excerpt und extraction_check sind in der CSV vorhanden. Die Abdeckung steht in `t046_extraction_audit.csv`, im Skript wird 80·3+56·2 = 352 Firmen-Berichte, mal 2 Jahre, geprüft (Zeile 108).
2. **Pilotabgleich dokumentiert.** Belegt erfüllt. `17_cash_backing_all.R:126–154` behält alle 72 Pilotzeilen, benennt Fenster- und Metrikausschlüsse und weist 0 numerische und 0 Verfügbarkeitsdifferenzen im Überlapp aus.
3. **Zwei Läufe byte-identisch, bestehende Outputs unverändert.**
   - Teilweise geprüft: Der Skriptcode (`set.seed` Zeilen 8 und 201, Guards Zeilen 245–247) und `t046_reproducibility.csv` sowie die Verifikation sprechen dafür.
   - Ich habe selbst nicht gelaufen.
   - Die 232 Altdateien plus 9 T047-Dateien werden im Skript gehasht.
   - Die Guards schließen auch Dateien fremder Karten ein (T044, T047); das ist fragil, wenn parallel gearbeitet wird.
4. **Ratio of sums, Ausschlüsse gezählt, keine Imputation.** Belegt erfüllt.
   - Summenquoten stehen in Zeilen 174–175 und der Bootstrap in 177–178. Das Residuum ist ΔMI − Gewinn + Dividenden − Kapital (Zeile 72).
   - Fehlende Komponenten, Währung und Stichtag werden separat gezählt (Zeilen 184–188).
   - NAs bleiben NA. Gedruckter Strich wird 0, das ist laut Karte so gewollt.
[firm-specific excerpt withheld in public audit]
[firm-specific excerpt withheld in public audit]
6. Ergebnisse (a)–(d), Bericht, Tabellen, Abbildung, Anpassungen von `run_all` und README sowie der inhaltliche Teil der Bootstrap-Methodik: nicht meine Rolle (`estimation`/`consistency`).

## Nicht geprüft

[firm-specific excerpt withheld in public audit]
- Ich habe keine Befehle ausgeführt (Bash gesperrt) und kein Script, keinen Hash und keinen Python-Lauf selbst wiederholt.
- Die Spalten- und Zeilenzuordnung der A-Aktien-Konsolidierung (Mischbilanzen mit „合并及公司“-Spalten, `ncol=4`, Zeilen 393–396) habe ich nur im Code gelesen.
- Ob Panel-MI und Gewinn für HK in derselben Währung wie die Cashflows vorliegen, ist nur über den MI-Wert belegt (Währungsprüfung). Für `ni_mi` gibt es keine eigene Währungsprüfung.
[firm-specific excerpt withheld in public audit]
