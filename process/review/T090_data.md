## Rolle: data (declared=codex, effective=codex, medium, Modell=Provider-Standard) – VERDICT: ESCALATE


## Befunde

[number withheld]. **Indikator [number withheld] misst eine andere Größe als den vorgesehenen Finanzierungskostensatz; die Entscheidung darüber liegt beim PI.** Die Karte verlangt Zinsaufwand einschließlich kapitalisierter Zinsen, soweit berichtet (`tasks/T090.md:29`). Der Code verwendet ausschließlich `FE_INTEREST_EXPENSE` (`replication/code/32_red_flags.R:73–100`). Fehlende Spalten im Einkommensextrakt belegen jedoch keine fehlende Veröffentlichung: Der bereits zur Feldprüfung verwendete Vanke-Geschäftsbericht nennt für [number withheld] **[number withheld] RMB kapitalisierte Zinsen** (PDF-Seite [number withheld], gedruckte Seite [number withheld], Anhang [number withheld]). Die Einschränkung wird offengelegt, aber der eingeschränkte Ersatzindikator trotzdem ausgeführt. Damit ist die Messentscheidung angesichts der Stopp-Regel (`tasks/T090.md:93–96`) nicht abschließend gedeckt. Der PI muss über die eingeschränkte Aufwandsquote oder eine ergänzende Datenerhebung entscheiden.

[number withheld]. **Zähler und Nenner des Zinsindikators haben zudem unterschiedliche Schuldabgrenzungen.** Derselbe Geschäftsbericht zerlegt den übernommenen Wert exakt:
   **[number withheld] + [number withheld] − [number withheld] = [number withheld] RMB.**
   Der Zähler enthält somit Leasingzinsen. Der verwendete Nenner `ibd` schließt separat ausgewiesene Leasingverbindlichkeiten aus; diese werden erst `ibd_ext` zugerechnet (`replication/code/01_clean.R:577–579`; Verwendung in `[number withheld]_red_flags.R:[number withheld]`). Die Quote kann deshalb auch durch Leasingumfang und Kapitalisierungspraxis variieren. Eine hohe Quote ist nicht eindeutig als hoher Finanzierungspreis der im Nenner enthaltenen Schulden interpretierbar. Die Auswirkung auf Peergrenzen und Flags wurde nicht quantifiziert.

[number withheld]. **Die übrige Datenkonstruktion ließ sich unabhängig bestätigen.** Die lesende Gegenrechnung ergab bei **[number withheld] Formelzellen**, **[number withheld] Gruppenzuordnungen** und den Punktwerten/Fallzahlen aller **[number withheld] Verteilungs- und Grenzwertzeilen** keine Abweichung. Ausgangs- und Ergebnisstichprobe umfassen jeweils [number withheld] eindeutige Firma-Stichtage aus [number withheld] Firmen; die T088-Verknüpfung ist vollständig und eindeutig. Alle **[number withheld] Freeze-Prüfsummen** stimmen. Von [number withheld] Integritätseinträgen stimmen aktuell [number withheld] mit der Ausgangssumme überein; die verbleibende Datei ist die inzwischen auf `CANDIDATE` gesetzte Aufgabenkarte. Das ist kein nachgewiesener Eingriff in Forschungsartefakte.

## Abnahmekriterien

[number withheld]. **Nicht vollständig erfüllt.** Definitionen, Quellenfelder, Einheiten und Fehlwertregeln sind dokumentiert und rechnerisch reproduzierbar (`t090_definitions.csv`; `32_red_flags.R:249–267`). Für Indikator [number withheld] bestehen die in Befunden [number withheld]–[number withheld] beschriebenen Abgrenzungsprobleme.

[number withheld]. **Belegt erfüllt hinsichtlich Gruppen und numerischer Grenzwerte.** Unabhängige Gruppenrekonstruktion ohne Abweichung; Schwellen [number withheld] pp, [number withheld] und [number withheld] stehen unverändert im Code (`32_red_flags.R:111–115`). Der Zinsgrenzwert wird als datumsbezogenes A-Entwickler-Perzentil operationalisiert. Seine zugrunde liegende Messgröße bedarf der PI-Entscheidung.

[number withheld]. **Nicht vollständig erfüllt.** [number withheld] Verteilungszeilen, [number withheld] Grenzwertzeilen und [number withheld] Kontraste einschließlich fehlender bzw. nicht anwendbarer Zellen liegen vor. Punktwerte und Fallzahlen der ersten beiden Tabellen stimmen unabhängig überein. Für den vorgesehenen Indikator [number withheld] fehlt eine inhaltlich passende Messung. Bootstrap-Inferenz: **nicht meine Rolle**, siehe „Nicht geprüft“.

[number withheld]. **Belegt erfüllt hinsichtlich Datenverknüpfung.** Positive Transaktionszahlen bestimmen die D/G/E/U-Zuordnung; überlappende Kategorien bleiben erhalten (`32_red_flags.R:199–247`). Die Tabellen weisen fehlende Indikatorwerte ausdrücklich aus. Die sprachliche Bewertung fällt in die Konsistenzrolle.

[number withheld]. **Belegt erfüllt für die geschützten bestehenden Ergebnisdateien.** Aktuelle Hashes stimmen mit den Ausgangssummen in `t090_integrity.csv` überein. Ersetzte Vorlaufartefakte sind in `t090_artifacts.csv` ausgewiesen und in `t090_prior_run_backup.json` gesichert. Kein Schreibbefehl wurde ausgeführt.

## Nicht geprüft

- Keine vollständige erneute Prüfung der vorgelagerten T004-/T088-Rohdatenerhebung oder sämtlicher Geschäftsberichte. Die Halbjahresflüsse wurden aus den gespeicherten T088-YTD-Werten unabhängig rekonstruiert.
- Keine erneute Ausführung des Analyseskripts wegen seiner Schreibnebenwirkungen. Vollständige Bootstrap-Neuberechnung, Intervallgüte und Kovarianzstruktur gehören zum Estimation-Review.
- Keine externe Prüfung der Analystenquelle für den [number withheld]-pp-Grenzwert; Netzwerkzugriffe waren untersagt.
- Worker und Reviewer gehören derselben Modellfamilie Codex an. Dies ist Prozessunabhängigkeit; korrelierte Fehler bleiben möglich. Ein externes menschliches oder anderes Modell-Audit bleibt eine Option des PI.