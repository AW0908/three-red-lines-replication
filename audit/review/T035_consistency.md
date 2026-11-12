## Rolle: consistency (codex, high) – VERDICT: ESCALATE


## Befunde

1. **Die Karte enthält eine falsche Vorgabe zur RL1-Validierung.** `tasks/T035.md:45` verlangt „3 within 0.1 pp“. Die vier veröffentlichten RL1-Werte in `replication/data/raw/manual/handcollect/rl1_published.csv` ergeben jedoch folgende Abweichungen, Panel minus Veröffentlichung:

   | Firma / Datum | Abweichung in Prozentpunkten |
   |---|---:|
   | Kaisa, Ende 2019 | +0,0381 |
   | Xinhu, Ende 2020 | −0,0087 |
   | Kaisa, Ende 2020 | −0,5543 |
   | Xinhu, Ende 2019 | +9,2750 |

   Damit liegen **zwei**, nicht drei Werte innerhalb von 0,1 Prozentpunkten. `proposal/sections/05_context_data.tex:38` folgt korrekt der CSV. Die Karte muss vom PI korrigiert werden; der Text darf nicht auf drei passende Werte geändert werden. Dies begründet das Gesamturteil ESCALATE unabhängig von den folgenden Textmängeln.

2. **Die allgemeine Beschreibung von Inferenz und Zeitfenstern stimmt nicht mit allen Verfahren überein.** `proposal/sections/04_empirical_model.tex:9` erklärt pauschal 999 Firmen-Bootstrap-Ziehungen und eine Vorperiode 2017H1–2019H2. Tatsächlich verwenden:
   - DiD und Event Study analytische Firmencluster-Standardfehler und alle 13 Stichtage einschließlich 2016H2 und 2020H1 (`replication/code/02_estimate.R:19`, `:85`, `:98`);
   - die Distanz-Event-Study ebenfalls analytische Firmencluster-Inferenz (`replication/code/11_mechanism.R:100`, `:268`);
   - die Attritionsverfahren 499 Ziehungen (`replication/code/09_selection.R:10`);
   - die Distanz-Umkehrtests CR1-Intervalle mit t-Verteilung (`replication/code/12_q1_robustness.R:331`).

   Die Einleitung des Abschnitts suggeriert dadurch ein einheitliches Verfahren, das nicht implementiert ist. Zeitfenster und Inferenz müssen nach Verfahren abgegrenzt werden.

3. **Die Stichprobe des MI-Kontrafaktums wird zu weit beschrieben.** `proposal/sections/04_empirical_model.tex:27` behauptet, der Haupttest verwende „all post-policy observations“. Der Code verlangt positive, beobachtete Werte für \(N\) und \(E\), beobachtete aktuelle und eingefrorene Minderheitsanteile sowie einen positiven kontrafaktischen Nenner (`replication/code/11_mechanism.R:24`, `:116`, `:148`). `t029_compliance.csv`, Zeile `post / pooled / all / official`, weist 630 Kandidaten, 602 verwendete Beobachtungen, 129 Firmen und 28 ausgeschlossene Beobachtungen aus. Abschnitt 6 nennt diese Einschränkung bereits (`proposal/sections/06_preliminary_analysis.tex:87`). Abschnitt 5 muss dieselbe Stichprobe und ihre Zulässigkeitsbedingungen beschreiben.

4. **Die Zusammenfassung verallgemeinert das Symmetrieargument der Theorie-Note.** Laut `proposal/sections/03_framework.tex:16` lässt das Vertauschen der Anpassungskosten die Verteilung des berichteten Verhältnisses unverändert. Die Theorie-Note behauptet dies ausdrücklich nur, wenn bei beiden Kostenpaaren die innere Lösung gilt (`proposal/theory_note.tex:165`); sie verwendet quadratische Kosten und eine Obergrenze für \(e\) (`:79`, `:80`). Ohne diese Bedingungen ist der Satz im Haupttext stärker als das referenzierte Ergebnis. Die Einschränkung muss ergänzt werden.

5. **Die RL3-Definition verschweigt die tatsächlich verwendete Cash-Ersatzregel.** `proposal/sections/05_context_data.tex:34` beschreibt durchgehend Cash abzüglich restricted cash. Der Code ersetzt fehlendes restricted cash durch null (`replication/code/01_clean.R:582`); bei sämtlichen A-Share-Beobachtungen ist RL3 deshalb eine Obergrenze (`:763`). Auch die eingebundene Summary-Tabelle sagt „unrestricted cash only where available“ (`replication/outputs/tables/t005_summary_stats.tex:46`). Der Variablenabsatz muss diese Einschränkung übernehmen, damit Text und Tabelle dieselbe Messung beschreiben.

6. **Die Entfernung der Dosistabelle lässt einen dokumentierten Vorgabenkonflikt offen.** `state/STATE.md:33` verlangt die Tabelle nach Dosis im Haupttext und bezeichnet sie als Syllabus-Pflicht. T035 entfernt ihre Einbindung; `proposal/sections/05_context_data.tex:5` und `:6` dokumentieren dies lediglich als Kommentar und TODO. Eine andere Einbindung ist im gelesenen Hauptdokument und seinen Anhängen nicht vorhanden. Ob die spätere Schwerpunktverschiebung diese Vorgabe aufhebt, ist nicht ausdrücklich entschieden. Der PI muss den Konflikt klären; ein unsichtbarer TODO erfüllt die bestehende Vorgabe nicht.

## Abnahmekriterien

1. **Wortbudgets, Zahlenbelege, Zitierschlüssel: überwiegend belegt erfüllt; Kartenfehler offen.**
   - Alle drei Abschnitte liegen innerhalb ihrer Budgets einschließlich Toleranz. Die Textinspektion ohne Kommentare ergibt ungefähr 677, 896 und 878 durch Leerraum getrennte Tokens, einschließlich LaTeX und Formeln.
   - Stichprobenzahlen 136/80/56/1.692, Erweiterungsabdeckung 65/31, sechs zusätzliche Kreuzungen, 531 von 630 fehlende Perpetual-Posten sowie die genannten MDEs stimmen mit den jeweiligen CSVs überein.
   - Die Summary-Tabelle unter `proposal/tables/` ist bytegleich mit dem eingefrorenen Output. Sämtliche 288 numerischen Tabellenzellen stimmen mit der CSV auf vier Dezimalstellen überein. Die im Fließtext ausgewählten Werte sind korrekt gerundet.
   - Verwendet werden vorhandene Zitierschlüssel. Der sichtbare Quellenplatzhalter zur regulatorischen Perpetual-Behandlung ist vorhanden.
   - Die Validierungsdarstellung stimmt mit der CSV überein, widerspricht aber der falschen Kartenvorgabe; siehe Befund 1.

2. **Methoden exakt wie implementiert: nicht erfüllt.** Excess-Mass-Formel, Hauptfenster, Polynomgrad, Placebo-Ausschlussregion, 72 Robustheitsspezifikationen, Zerlegungsformel, eingefrorenes MI-Kontrafaktum, D-Statistik, Placebo-Anker und sieben Vertragsmerkmale stimmen grundsätzlich mit Karten und Code überein. Inferenz, Zeitfenster und Kontrafaktumsstichprobe sind jedoch unzutreffend verallgemeinert; siehe Befunde 2 und 3.

3. **Aussagen gemäß STATE, keine kausale oder ökonomische Überinterpretation: für die neu geschriebenen Kernaussagen belegt erfüllt.** Insbesondere `03_framework.tex:29`, `:31` und `04_empirical_model.tex:32` unterscheiden mechanische Abhängigkeit, echte Eigenkapitalzufuhr und unbekannte ökonomische Substanz ausdrücklich. Die Theorieeinschränkung und der offene Tabellenkonflikt bleiben gemäß Befunden 4 und 6 zu bearbeiten.

4. **`main.tex` kompiliert: laut bereitgestelltem Prüfartefakt belegt erfüllt.** `review/T035_latex.txt:1` meldet eine fehlerfreie Übersetzung. Keine eigene Übersetzung ausgeführt.

Weitere Vorgaben: Finaler Titel und Abschnittsreihenfolge sind vorhanden (`proposal/main.tex:24`, `:67`). Abschnitt 5 enthält genau vier nummerierte Gleichungen. Die Querverweise der neuen Abschnitte besitzen passende Ziele; `tab:summary` wird durch das Tabellenmakro gesetzt. Die alten Hypothesen wurden ersetzt.

## Nicht geprüft

- Keine Analysen, Projektbefehle oder LaTeX-Übersetzung ausgeführt; keine Dateien verändert.
- Datenrichtigkeit, Schätzkorrektheit und theoretische Beweise: nicht meine Rolle. Code wurde ausschließlich zum Abgleich mit der Beschreibung gelesen.
- Primärquellenprüfung der Politikregeln und Originalberichte sowie PI-Verifikation der vier veröffentlichten RL1-Werte nicht durchgeführt.
- Vollständige Zahlen- und Abbildungsprüfung der unveränderten beziehungsweise separat bearbeiteten Abschnitte außerhalb T035 nicht durchgeführt. Der Abstract enthält weiterhin das alte DiD-zentrierte Framing (`proposal/main.tex:43`); seine Überarbeitung ist laut `state/STATE.md:84` T037 zugeordnet.
- Urheberschaft der gemeldeten Änderungen außerhalb des Schreibbereichs nicht feststellbar. Die genannten Announcement-Dateien und vier Handcollection-Dateien entsprechen dem Schreibbereich von T033 (`tasks/T033.md:24`). Änderungszeiten allein belegen keinen Verstoß des T035-Workers.
- Der Overleaf-Diff enthält auch andere Kartenänderungen und erlaubt keine vollständige Zuordnung aller Änderungen zu T035.