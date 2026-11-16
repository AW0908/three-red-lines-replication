## Rolle: consistency (codex, high) – VERDICT: ESCALATE


## Befunde

[number withheld]. **Die Karte enthält eine falsche Vorgabe zur RL1-Validierung.** `tasks/T035.md:45` verlangt „[number withheld] within [number withheld] pp“. Die vier veröffentlichten RL1-Werte in `replication/data/raw/manual/handcollect/rl1_published.csv` ergeben jedoch folgende Abweichungen, Panel minus Veröffentlichung:

   | Firma / Datum | Abweichung in Prozentpunkten |
   |---|---:|
   | Kaisa, Ende [number withheld] | [number withheld] |
   | Xinhu, Ende [number withheld] | [number withheld] |
   | Kaisa, Ende [number withheld] | [number withheld] |
   | Xinhu, Ende [number withheld] | [number withheld] |

   Damit liegen **zwei**, nicht drei Werte innerhalb von [number withheld] Prozentpunkten. `proposal/sections/05_context_data.tex:38` folgt korrekt der CSV. Die Karte muss vom PI korrigiert werden; der Text darf nicht auf drei passende Werte geändert werden. Dies begründet das Gesamturteil ESCALATE unabhängig von den folgenden Textmängeln.

[number withheld]. **Die allgemeine Beschreibung von Inferenz und Zeitfenstern stimmt nicht mit allen Verfahren überein.** `proposal/sections/04_empirical_model.tex:9` erklärt pauschal [number withheld] Firmen-Bootstrap-Ziehungen und eine Vorperiode [number withheld]H1–[number withheld]H2. Tatsächlich verwenden:
   - DiD und Event Study analytische Firmencluster-Standardfehler und alle [number withheld] Stichtage einschließlich [number withheld]H2 und [number withheld]H1 (`replication/code/02_estimate.R:19`, `:[number withheld]`, `:[number withheld]`);
   - die Distanz-Event-Study ebenfalls analytische Firmencluster-Inferenz (`replication/code/11_mechanism.R:100`, `:[number withheld]`);
   - die Attritionsverfahren [number withheld] Ziehungen (`replication/code/09_selection.R:10`);
   - die Distanz-Umkehrtests CR1-Intervalle mit t-Verteilung (`replication/code/12_q1_robustness.R:331`).

   Die Einleitung des Abschnitts suggeriert dadurch ein einheitliches Verfahren, das nicht implementiert ist. Zeitfenster und Inferenz müssen nach Verfahren abgegrenzt werden.

[number withheld]. **Die Stichprobe des MI-Kontrafaktums wird zu weit beschrieben.** `proposal/sections/04_empirical_model.tex:27` behauptet, der Haupttest verwende „all post-policy observations“. Der Code verlangt positive, beobachtete Werte für \(N\) und \(E\), beobachtete aktuelle und eingefrorene Minderheitsanteile sowie einen positiven kontrafaktischen Nenner (`replication/code/11_mechanism.R:24`, `:[number withheld]`, `:[number withheld]`). `t029_compliance.csv`, Zeile `post / pooled / all / official`, weist [number withheld] Kandidaten, [number withheld] verwendete Beobachtungen, [number withheld] Firmen und [number withheld] ausgeschlossene Beobachtungen aus. Abschnitt [number withheld] nennt diese Einschränkung bereits (`proposal/sections/06_preliminary_analysis.tex:87`). Abschnitt [number withheld] muss dieselbe Stichprobe und ihre Zulässigkeitsbedingungen beschreiben.

[number withheld]. **Die Zusammenfassung verallgemeinert das Symmetrieargument der Theorie-Note.** Laut `proposal/sections/03_framework.tex:16` lässt das Vertauschen der Anpassungskosten die Verteilung des berichteten Verhältnisses unverändert. Die Theorie-Note behauptet dies ausdrücklich nur, wenn bei beiden Kostenpaaren die innere Lösung gilt (`proposal/theory_note.tex:165`); sie verwendet quadratische Kosten und eine Obergrenze für \(e\) (`:[number withheld]`, `:[number withheld]`). Ohne diese Bedingungen ist der Satz im Haupttext stärker als das referenzierte Ergebnis. Die Einschränkung muss ergänzt werden.

[number withheld]. **Die RL3-Definition verschweigt die tatsächlich verwendete Cash-Ersatzregel.** `proposal/sections/05_context_data.tex:34` beschreibt durchgehend Cash abzüglich restricted cash. Der Code ersetzt fehlendes restricted cash durch null (`replication/code/01_clean.R:582`); bei sämtlichen A-Share-Beobachtungen ist RL3 deshalb eine Obergrenze (`:[number withheld]`). Auch die eingebundene Summary-Tabelle sagt „unrestricted cash only where available“ (`replication/outputs/tables/t005_summary_stats.tex:46`). Der Variablenabsatz muss diese Einschränkung übernehmen, damit Text und Tabelle dieselbe Messung beschreiben.

[number withheld]. **Die Entfernung der Dosistabelle lässt einen dokumentierten Vorgabenkonflikt offen.** `state/STATE.md:33` verlangt die Tabelle nach Dosis im Haupttext und bezeichnet sie als Syllabus-Pflicht. T035 entfernt ihre Einbindung; `proposal/sections/05_context_data.tex:5` und `:[number withheld]` dokumentieren dies lediglich als Kommentar und TODO. Eine andere Einbindung ist im gelesenen Hauptdokument und seinen Anhängen nicht vorhanden. Ob die spätere Schwerpunktverschiebung diese Vorgabe aufhebt, ist nicht ausdrücklich entschieden. Der PI muss den Konflikt klären; ein unsichtbarer TODO erfüllt die bestehende Vorgabe nicht.

## Abnahmekriterien

[number withheld]. **Wortbudgets, Zahlenbelege, Zitierschlüssel: überwiegend belegt erfüllt; Kartenfehler offen.**
   - Alle drei Abschnitte liegen innerhalb ihrer Budgets einschließlich Toleranz. Die Textinspektion ohne Kommentare ergibt ungefähr [number withheld], [number withheld] und [number withheld] durch Leerraum getrennte Tokens, einschließlich LaTeX und Formeln.
   - Stichprobenzahlen [number withheld]/[number withheld]/[number withheld]/[number withheld], Erweiterungsabdeckung [number withheld]/[number withheld], sechs zusätzliche Kreuzungen, [number withheld] von [number withheld] fehlende Perpetual-Posten sowie die genannten MDEs stimmen mit den jeweiligen CSVs überein.
   - Die Summary-Tabelle unter `proposal/tables/` ist bytegleich mit dem eingefrorenen Output. Sämtliche [number withheld] numerischen Tabellenzellen stimmen mit der CSV auf vier Dezimalstellen überein. Die im Fließtext ausgewählten Werte sind korrekt gerundet.
   - Verwendet werden vorhandene Zitierschlüssel. Der sichtbare Quellenplatzhalter zur regulatorischen Perpetual-Behandlung ist vorhanden.
   - Die Validierungsdarstellung stimmt mit der CSV überein, widerspricht aber der falschen Kartenvorgabe; siehe Befund [number withheld].

[number withheld]. **Methoden exakt wie implementiert: nicht erfüllt.** Excess-Mass-Formel, Hauptfenster, Polynomgrad, Placebo-Ausschlussregion, [number withheld] Robustheitsspezifikationen, Zerlegungsformel, eingefrorenes MI-Kontrafaktum, D-Statistik, Placebo-Anker und sieben Vertragsmerkmale stimmen grundsätzlich mit Karten und Code überein. Inferenz, Zeitfenster und Kontrafaktumsstichprobe sind jedoch unzutreffend verallgemeinert; siehe Befunde [number withheld] und [number withheld].

[number withheld]. **Aussagen gemäß STATE, keine kausale oder ökonomische Überinterpretation: für die neu geschriebenen Kernaussagen belegt erfüllt.** Insbesondere `03_framework.tex:29`, `:[number withheld]` und `04_empirical_model.tex:32` unterscheiden mechanische Abhängigkeit, echte Eigenkapitalzufuhr und unbekannte ökonomische Substanz ausdrücklich. Die Theorieeinschränkung und der offene Tabellenkonflikt bleiben gemäß Befunden [number withheld] und [number withheld] zu bearbeiten.

[number withheld]. **`main.tex` kompiliert: laut bereitgestelltem Prüfartefakt belegt erfüllt.** `review/T035_latex.txt:1` meldet eine fehlerfreie Übersetzung. Keine eigene Übersetzung ausgeführt.

Weitere Vorgaben: Finaler Titel und Abschnittsreihenfolge sind vorhanden (`proposal/main.tex:24`, `:[number withheld]`). Abschnitt [number withheld] enthält genau vier nummerierte Gleichungen. Die Querverweise der neuen Abschnitte besitzen passende Ziele; `tab:summary` wird durch das Tabellenmakro gesetzt. Die alten Hypothesen wurden ersetzt.

## Nicht geprüft

- Keine Analysen, Projektbefehle oder LaTeX-Übersetzung ausgeführt; keine Dateien verändert.
- Datenrichtigkeit, Schätzkorrektheit und theoretische Beweise: nicht meine Rolle. Code wurde ausschließlich zum Abgleich mit der Beschreibung gelesen.
- Primärquellenprüfung der Politikregeln und Originalberichte sowie PI-Verifikation der vier veröffentlichten RL1-Werte nicht durchgeführt.
- Vollständige Zahlen- und Abbildungsprüfung der unveränderten beziehungsweise separat bearbeiteten Abschnitte außerhalb T035 nicht durchgeführt. Der Abstract enthält weiterhin das alte DiD-zentrierte Framing (`proposal/main.tex:43`); seine Überarbeitung ist laut `state/STATE.md:84` T037 zugeordnet.
- Urheberschaft der gemeldeten Änderungen außerhalb des Schreibbereichs nicht feststellbar. Die genannten Announcement-Dateien und vier Handcollection-Dateien entsprechen dem Schreibbereich von T033 (`tasks/T033.md:24`). Änderungszeiten allein belegen keinen Verstoß des T035-Workers.
- Der Overleaf-Diff enthält auch andere Kartenänderungen und erlaubt keine vollständige Zuordnung aller Änderungen zu T035.