## Rolle: consistency (codex, high) – VERDICT: REWORK


## Befunde

[number withheld]. **Der Haupttext überschreitet auch die gelockerte Sieben-Seiten-Grenze.** Die Testtabelle steht auf Seite [number withheld], die Diskussion beginnt auf Seite [number withheld]; die Beweise beginnen auf Seite [number withheld] (`review/T0[number withheld]_build/theory_note.aux:[number withheld]–[number withheld]`). Damit enthält Seite [number withheld] noch Haupttext, unabhängig davon, ob die Bibliografie mitgezählt wird. Die Grenze aus `tasks/T034.md:69` ist nicht erfüllt. Der Build gehört zum aktuellen Quelltext: Dessen MD5 stimmt mit `review/T0[number withheld]_build/theory_note.fdb_latexmk:[number withheld]` überein. Der Haupttext muss einschließlich Tabelle auf höchstens sieben Seiten gekürzt werden.

[number withheld]. **Tabellennote d übernimmt die κ-Einschränkung des Anhangs nicht vollständig.** `proposal/theory_note.tex:262` nennt \(e^*\) als relevante Anpassung für den Vergleich in endlichen Intervallen. Der Anhang präzisiert dagegen ausdrücklich, dass die relevante Distanz \(\kappa e^*\) beträgt und die Größenannahme bei \(\kappa<[number withheld]\) stärker ist (`:[number withheld]`); ebenso der κ-Remark (`:[number withheld]–[number withheld]`). Die Tabellenzusammenfassung muss diese Bedingung übernehmen oder ausdrücklich auf den Fall \(\kappa=[number withheld]\) beschränkt werden. Sonst erscheint der Test weniger voraussetzungsvoll als im Anhang.

## Abnahmekriterien

[number withheld]. **Konsistente Umbenennung: belegt erfüllt.** Der aktive Modelltext verwendet durchgehend \(d/e\) und \(\alpha_d/\alpha_e\), einschließlich der Beweise. Alte Bezeichnungen stehen nur im historischen Revisionskommentar. Interne Verweisziele und verwendete BibTeX-Schlüssel sind vorhanden. Ob jede Proposition mathematisch folgt: **nicht meine Rolle**.

[number withheld]. **κ- und Pufferbemerkung: hinsichtlich der Darstellung überwiegend belegt erfüllt.** Baseline und κ-Erweiterung sind ausdrücklich getrennt (`proposal/theory_note.tex:79–84`, `:[number withheld]–[number withheld]`). Der Puffertext, Note b und der entsprechende Anhangspunkt nennen übereinstimmend die Bedingungen für das Messfenster und behaupten keine automatisch geringere Umkehrwahrscheinlichkeit gegenüber der Vorperiode (`:[number withheld]`, `:[number withheld]`, `:[number withheld]`). Verbleibende Inkonsistenz: Befund [number withheld]. Mathematische Gültigkeit und Minimalität: **nicht meine Rolle**.

[number withheld]. **Testtabelle und Zahlenbeschränkung: teilweise erfüllt.** Die Zuordnung zu T023/T027/T029/T031 passt zu den gelesenen Karten und Outputs. T033 ist sichtbar als geplant gekennzeichnet (`proposal/theory_note.tex:248`; `tasks/T033.md:4`). Der gestrichene Renditelückentest fehlt. Das MI-Kontrafaktum wird zutreffend als mechanisch und unabhängig vom schuldenähnlichen Charakter des Eigenkapitals beschrieben (`:[number withheld]`). Die Fenstergrenzen `[[number withheld])` stimmen mit `replication/outputs/tables/t029_counterfactual_bunching.csv:2–5` überein. Keine neuen empirischen Schätzwerte gefunden; Zahlenbeispiele sind als illustrativ gekennzeichnet. Nicht vollständig erfüllt wegen Befund [number withheld].

[number withheld]. **Kompilation: durch vorhandene Artefakte belegt erfüllt.** Das passende Build-Protokoll dokumentiert ein PDF mit [number withheld] Seiten (`review/T034_build/theory_note.log:1247–1248`), ohne „Float too large“ oder „Overfull hbox“. **Die zusätzliche Längenvorgabe bleibt nicht erfüllt**, siehe Befund [number withheld].

## Nicht geprüft

- Keine Shell-, Analyse- oder Übersetzungsbefehle ausgeführt; keine Dateien geändert.
- Keine erneute Prüfung von Datenbereinigung, Schätzverfahren oder mathematischen Herleitungen.
- Keine vollständige Zahlenprüfung der parallel unter T036 bearbeiteten Proposal-Abschnitte und Tabellenkopien.
- Keine visuelle PDF-Prüfung; Seitenumfang und Übersetzungsstatus anhand der Build-Dateien geprüft.
- Die gemeldete Änderung an `state/STATE.md` und Änderungen außerhalb des Schreibbereichs wurden keiner Urheberschaft zugeordnet. Daraus allein folgt kein belegter Verstoß durch T034.
- Literaturinhalte nicht gegen Originalquellen geprüft.