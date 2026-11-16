## Rolle: data (claude, sonnet) – VERDICT: PASS


## Befunde

Alle Befunde sind geringfügig und betreffen die Rolle `data`. Keiner ändert die berichteten Quoten. Ich konnte keine Befehle ausführen (Bash war gesperrt) und habe nur gelesen. Zahlen habe ich nicht neu gerechnet, sondern an Code, CSVs und Verifikationstext gegengelesen.

[number withheld]. **Strich-Werte sind trivial `exact`.**
   - Beleg: `extract_nci_cashflow.py:434` setzt `exact`, wenn `tok in pages[pg]`. Bei einem gedruckten Strich ist `tok` gleich `-`, und das steht auf praktisch jeder Seite. Die Werte sind also automatisch `exact`.
[firm-specific excerpt withheld in public process copy]
   - Wirkung: Die Zahl [number withheld] `exact` im Bericht enthält diese [number withheld] Zeilen. Dass der Strich in der richtigen Spalte steht, belegt der Code nicht.
   - Die Stichproben, die ich ansehen konnte (Zeile [number withheld]: `- [number withheld]` ergibt aktuell [number withheld] und Vorjahr [number withheld]), sind plausibel. Eine falsch zugeordnete Null bliebe im Code aber unentdeckt und ginge als [number withheld] in die Quoten.
   - Empfehlung: Strich-Werte getrennt ausweisen (`exact` nur für Zahlenstrings) oder in die PI-Stichprobe aufnehmen. Das ist kein Blocker.

[number withheld]. **Die `exact`-Prüfung ist eine Seitensubstring-Prüfung, keine Zeilen- oder Spaltenprüfung.**
   - Beleg: `extract_nci_cashflow.py:434` und `verify()` Zeile [number withheld] prüfen nur die Seite.
   - Wirkung: Eine Zahl aus der falschen Spalte oder Zeile derselben Seite würde bestehen. Das entspricht der vom PI beschlossenen Regel („Level-String auf der zitierten Seite“). Die Restunsicherheit liegt bei der Stichprobe des PI.

[number withheld]. **Gedruckte Seitenzahl teils zweifelhaft.**
[firm-specific excerpt withheld in public process copy]
   - Wirkung: Das Kriterium verlangt die physische Seite; sie ist gesetzt und wird geprüft. Die gedruckte Seite ist Zusatzinformation, aber nicht überall verlässlich.

[number withheld]. **Interne Konsistenz der Stichprobe stimmt.**
   - [number withheld]/[number withheld]/[number withheld] positive Firma-Jahre ergeben [number withheld]/[number withheld]/[number withheld] eingeschlossene, also [number withheld]/[number withheld]/[number withheld] ausgeschlossene. Das passt zur Summe [number withheld].
   - Crosser [number withheld] plus übrige [number withheld] ergeben [number withheld] (Post).
   - Der Code prüft `G==[number withheld]` und [number withheld] Crosser, die alle in der Hauptstichprobe liegen. Er prüft Eindeutigkeit von Firma×Datum und Firma×Jahr×Metrik.
   - Der Berichtsvintage-Abgleich (`expected_report`, Zeilen [number withheld]–[number withheld]) entspricht der Kartenregel.

[number withheld]. **Hinweise ohne Mangel.**
   - **Crosser-Flag:** `crosser` markiert eine Firma über alle Jahre, auch für [number withheld] bei Firmen, die erst [number withheld] gekreuzt haben. Das ist eine Designentscheidung und im Bericht als Gruppierung nach Firma dokumentiert.
   - **Pre-Vergleich:** [number withheld] enthält nur A-Aktien ([number withheld]/[number withheld]), Post enthält [number withheld] HK-Firma-Jahre. Die Pre/Post-Differenz ist deshalb auch eine Zusammensetzungsdifferenz. Der Bericht nennt das offen.
   - **Vintage:** ΔMI und Gewinn kommen aus dem Panel, die Cashflows aus FY2[number withheld] bzw. FY2[number withheld] (Vergleichsspalten, möglicherweise restated). Das steht nicht ausdrücklich in den Limitationen. Ich empfehle, es in `state/LIMITATIONS.md` oder im Text zu erwähnen.

## Abnahmekriterien

[number withheld]. **Datei, Seite, Auszug, `extraction_check` per Code, Abdeckungstabelle.** Belegt erfüllt, mit Einschränkung zu Befund [number withheld] und [number withheld]. Die Spalten file, pdf_page, printed_page, excerpt und extraction_check sind in der CSV vorhanden. Die Abdeckung steht in `t046_extraction_audit.csv`, im Skript wird [number withheld]·[number withheld][number withheld]·[number withheld] = [number withheld] Firmen-Berichte, mal [number withheld] Jahre, geprüft (Zeile [number withheld]).
[number withheld]. **Pilotabgleich dokumentiert.** Belegt erfüllt. `17_cash_backing_all.R:126–154` behält alle [number withheld] Pilotzeilen, benennt Fenster- und Metrikausschlüsse und weist [number withheld] numerische und [number withheld] Verfügbarkeitsdifferenzen im Überlapp aus.
[number withheld]. **Zwei Läufe byte-identisch, bestehende Outputs unverändert.**
   - Teilweise geprüft: Der Skriptcode (`set.seed` Zeilen [number withheld] und [number withheld], Guards Zeilen [number withheld]–[number withheld]) und `t046_reproducibility.csv` sowie die Verifikation sprechen dafür.
   - Ich habe selbst nicht gelaufen.
   - Die [number withheld] Altdateien plus [number withheld] T047-Dateien werden im Skript gehasht.
   - Die Guards schließen auch Dateien fremder Karten ein (T044, T047); das ist fragil, wenn parallel gearbeitet wird.
[number withheld]. **Ratio of sums, Ausschlüsse gezählt, keine Imputation.** Belegt erfüllt.
   - Summenquoten stehen in Zeilen [number withheld]–[number withheld] und der Bootstrap in [number withheld]–[number withheld]. Das Residuum ist ΔMI − Gewinn + Dividenden − Kapital (Zeile [number withheld]).
   - Fehlende Komponenten, Währung und Stichtag werden separat gezählt (Zeilen [number withheld]–[number withheld]).
   - NAs bleiben NA. Gedruckter Strich wird [number withheld], das ist laut Karte so gewollt.
[firm-specific excerpt withheld in public process copy]
[firm-specific excerpt withheld in public process copy]
[number withheld]. Ergebnisse (a)–(d), Bericht, Tabellen, Abbildung, Anpassungen von `run_all` und README sowie der inhaltliche Teil der Bootstrap-Methodik: nicht meine Rolle (`estimation`/`consistency`).

## Nicht geprüft

[firm-specific excerpt withheld in public process copy]
- Ich habe keine Befehle ausgeführt (Bash gesperrt) und kein Script, keinen Hash und keinen Python-Lauf selbst wiederholt.
- Die Spalten- und Zeilenzuordnung der A-Aktien-Konsolidierung (Mischbilanzen mit „合并及公司“-Spalten, `ncol=[number withheld]`, Zeilen [number withheld]–[number withheld]) habe ich nur im Code gelesen.
- Ob Panel-MI und Gewinn für HK in derselben Währung wie die Cashflows vorliegen, ist nur über den MI-Wert belegt (Währungsprüfung). Für `ni_mi` gibt es keine eigene Währungsprüfung.
[firm-specific excerpt withheld in public process copy]
