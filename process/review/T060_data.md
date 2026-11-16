## Rolle: data (claude, sonnet) – VERDICT: PASS

Ich prüfe gerade den Code von `fetch_control.py`, die Prüfprotokolle und die Feldzuordnung. Der Prüfbericht folgt jetzt.

VERDICT: PASS

## Befunde

Keine inhaltlichen Fehler gefunden. Es gibt vier Hinweise ohne Rework-Bedarf, geordnet nach Gewicht:

[number withheld]. **Keine echten Daten (Beleg `test_run.txt`, Bericht).** Der echte [number withheld]-Firmen-Test scheiterte an einem DNS-Fehler (`[number withheld].push2.eastmoney.com`). Die Datenlogik ist deshalb nur an synthetischen Fixtures geprüft (`offline_checks.txt`, PASS [number withheld]–[number withheld]), nicht an echten EastMoney-Antworten. Die Boardnamen in `MAIN_BOARDS` (`fetch_control.py:40-50`) sind online ungeprüft. Fehlt ein Board, bricht das Skript ab (`:[number withheld][number withheld]`). Eine stille Änderung der Population ist damit ausgeschlossen. Das akzeptiere ich, weil die Karte diesen Fall ausdrücklich zulässt.
[number withheld]. **Feldzuordnung identisch zum Entwicklerpanel.**
   - `FIELDS` (`fetch_control.py:35`) umfasst `TOTAL_ASSETS`, `TOTAL_LIABILITIES`, `ADVANCE_RECEIVABLES` und `CONTRACT_LIAB`. Das entspricht `maps$a_em` in `01_clean.R:402-403` (`ta`, `tl`, `adv`).
   - Beide Vorauszahlungsfelder bleiben getrennt und behalten ihre Fehlwerte (`:[number withheld][number withheld]`). Es gibt keine Nullimputation und keine RL1-Berechnung.
   - Endpunkt, `reportDateType=[number withheld]`, `reportType=[number withheld]` und die Stapel zu je [number withheld] Stichtagen stimmen mit `akshare_coverage_test.py:169-170` überein.
   - Die [number withheld] Stichtage ([number withheld]. und [number withheld]., [number withheld]–[number withheld]) decken den Kartenzeitraum ab.
[number withheld]. **Entwickler-Ausschluss.**
   - Das Skript schließt Codes aus vier Quellregistern aus (`:[number withheld][number withheld]`): `firm_list.csv`, `delistete_immobilienfirmen.csv`, `wind_A_gelistet_eigentum.xlsx` und `Sicherung_A_1.xlsx`. Es verlangt, dass alle vier im MANIFEST stehen. Offline-Check [number withheld] meldet [number withheld] Codes.
   - `wind_A_delistet_v2.xlsx` fehlt in dieser Liste. Das ist unschädlich: Es enthält delistete Firmen, und die aktuellen Board-Mitglieder (`stock_board_industry_cons_em`) enthalten keine. Außerdem steht der Entwickler-Delisted-Satz bereits in der CSV.
   - Zusätzlich sind alle Boards mit `房地产` im Namen gesperrt (`:[number withheld]`, `:[number withheld]`).
[number withheld]. **Survivorship und Eigentümer.** Die Mitgliedschaft folgt dem aktuellen Board-Stand, das Skript benennt das im Docstring (`:[number withheld]`). Die Spalte `ownership` ist durchgehend NA (`:[number withheld]`). Beides ist dokumentiert. T061 muss es als Einschränkung in `state/LIMITATIONS.md` aufnehmen.

Weitere Prüfpunkte, jeweils am Code nachvollzogen:
- **Schlüssel und Duplikate:** Doppelte Stichtage je Firma stoppen den Lauf (`:[number withheld][number withheld]`, Check [number withheld]). Boards mit mehrfacher Zugehörigkeit werden pro Code zusammengeführt, ohne Zeilenverdopplung (`:[number withheld][number withheld]`).
- **Börsenfilter:** Der Filter `[[number withheld]]\d{[number withheld]}|[number withheld]\d{[number withheld]}` lässt B-Aktien aus ([number withheld]/[number withheld]). Die Präfixe [number withheld], [number withheld] und [number withheld] sind Beijing und werden nach `BJ` gemappt (`:[number withheld][number withheld]`).
- **Lauf- und Resume-Logik:** Ein Lauf ohne `--resume` verwirft alte Bilanzzeilen des Universums und ersetzt sie erst nach erfolgreichem Abruf. Fehlerzeilen zählen nicht als Erfolg (`:[number withheld][number withheld]`, Check [number withheld]). Das Resume-Ledger wird gegen die gespeicherten Bilanzen geprüft (`:[number withheld][number withheld]`).
- **Abdeckungsbericht:** Die Nenner stimmen (`n_firms` = ausgewählte Firmen, Anteil erwartet gegen beobachtet getrennt, `:[number withheld][number withheld]`).
- **Anfragepausen:** Das Mindestintervall von [number withheld] s gilt für alle `requests`-Aufrufe, auch die internen von AKShare. Es gibt [number withheld] Versuche mit Back-off und [number withheld] s Timeout (`:[number withheld][number withheld]`, Check [number withheld]).
- **Seed:** Der Seed ist gesetzt (`:[number withheld]`), und es gibt keine Zufallsstichprobe. `--limit` nimmt die ersten N Codes in aufsteigender Reihenfolge, also deterministisch. Die Test-Stichprobe ist dadurch nach Code geordnet und nicht repräsentativ. Die Laufzeit-Hochrechnung bleibt trotzdem verwertbar.
- **Board-Freigabe:** `board_list.csv` wird vor dem ersten Bilanzabruf geschrieben (`:[number withheld][number withheld]`). Ein Vollabruf verlangt die interaktive PI-Bestätigung per Hash (`:[number withheld][number withheld]`). Das erfüllt die Kartenvorgabe.
- **Offene Karten-Anforderungen:** HK ist als „not available" protokolliert (Check [number withheld]). Das ist laut Karte zulässig. Die Laufzeit pro Firma lässt sich ohne Netz nicht messen.

## Abnahmekriterien

[number withheld]. **Test `--limit [number withheld]` oder exakter Netzwerkfehler:** belegt erfüllt über die Ersatzklausel. Der Befehl wurde ausgeführt, der Fehlerkern ist zitiert (DNS-Fehler, `test_run.txt`). Die Echtprüfung muss der PI wiederholen.
[number withheld]. **Feldzuordnung identisch, mit Zitat:** belegt erfüllt (Befund [number withheld]).
[number withheld]. **Keine Änderung außerhalb des Schreibbereichs:** belegt erfüllt. `scope_check.json` zeigt `input_sha2[number withheld]_changes: []`. Die [number withheld] aufgeführten Änderungen betreffen `tasks/`, `review/`, `state/` und `proposal/.git`, also Bereiche paralleler Sitzungen. Der Hinweis des Auftrags nennt dazu keine Änderungen außerhalb des Schreibbereichs. Das Kartenfeld ist nur für `Daten/fetch_control.py`, `Daten/control/` und den Bericht beschrieben.

## Nicht geprüft

- Ich habe keine Befehle ausgeführt und keine echten EastMoney-Antworten gesehen. Daher sind unbelegt: Boardnamen im Live-Katalog, Datentyp und Form von `REPORT_DATE`, Feldverfügbarkeit nach Firmentyp, Laufzeit pro Firma und Größe der Gesamtpopulation.
- Ich habe die Inhalte der vier Registerdateien nicht geöffnet. Die Zahl [number withheld] stützt sich auf `offline_checks.txt`.
- `AI_USAGE_LOG.md` ist eingefroren, aber nicht meine Rolle (Datenprüfung). Den Eintrag habe ich nicht bewertet.
- Das Verhalten von `ak.stock_board_industry_cons_em` mit Board-Code (`BK…`) habe ich nur im AKShare-Quelltext bestätigt (Regex `^BK\d+`, Zeile [number withheld]), nicht live.
