## Ergebnis
Das HK-Downloadskript mit Roster-Ausschlüssen, Rohdatenablage, Bilanzexport, Resume und Fehlerprotokoll wurde erstellt und offline geprüft. Die README enthält den PI-Aufruf und den unveränderten T076-Plan; echte Daten wurden nicht heruntergeladen, der Kartenstatus bleibt APPROVED.

## Dateien

- `Daten/fetch_control_hk.py` – Downloadskript mit Offline-Prüfungen.
- `Daten/README_control_hk.md` – Quellen, Ausschlüsse, PI-Befehle, Resume, Laufzeitschätzung und T076-Plan.
- `Daten/control/hk/offline/mock_roster.csv` – zwölf synthetische Roster-Testfälle.
- `Daten/control/hk/offline/mock_balance.csv` – vier synthetische Bilanzzeilen.
- `Daten/control/hk/offline/validation.txt` – Offline-Prüfergebnisse.
- `Daten/control/hk/offline/akshare_api.txt` – installierte AKShare-Version und Funktionssignaturen.
- `Daten/control/hk/offline/http_validation.txt` – Test der HTTP-Begrenzung mit simuliertem Transport.
- `tasks/T074_report.md` – ausführlicher Bericht.

## Ausführung

Aus dem Projektordner:

[fenced excerpt withheld in public process copy]
[fenced excerpt withheld in public process copy]

Beide Befehle: Exit-Code [number withheld]. Letzte Ausgabezeilen:

[fenced excerpt withheld in public process copy]
[fenced excerpt withheld in public process copy]

## Abnahmekriterien

[number withheld]. **Erfüllt:** Syntaxprüfung und Offline-Dry-Run erfolgreich; Resume, Retries, atomisches Speichern und Extraktion geprüft.
[number withheld]. **Erfüllt:** Ausschlüsse dokumentiert und an zwölf Mock-Fällen getestet, darunter Entwickler, Bank und Industrieunternehmen. Ergebnis: neun ausgeschlossen, zwei geeignet, einer ungeklärt.
[number withheld]. **Erfüllt:** README enthält Vollaufruf, Fünf-Kandidaten-Test und Resume-Anleitung.

## Offene Fragen

Live-Erreichbarkeit, tatsächliche Metadatenlabels und Datenabdeckung bleiben ungeprüft. Kein Netzwerkdownload wurde gestartet. Fehlende Währungsangaben bleiben leer; die Laufzeit ist geschätzt.

KI-Protokollvorschlag nach Abnahme: „T074: HK-Kontrolldownload durch Codex implementiert und offline geprüft; keine echten Daten heruntergeladen oder Schätzungen vorgenommen.“