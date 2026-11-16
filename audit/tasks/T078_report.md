## Ergebnis

T078 installiert HonestDiD [number withheld] samt notwendigen Abhängigkeiten in einer isolierten Projektbibliothek und berechnet die festgelegte Rambachan–Roth-Sensitivität für A-Shares und Hongkong. A-Shares schließen null bereits bei Mbar=[number withheld] ein; HK bleibt dort positiv, schließt null aber beim nächsten geprüften Wert Mbar=[number withheld] ein. Die Ergebnisse erlauben keine robuste kausale Verschärfung des bisherigen Befundes. Ein unabhängiger estimation-Review steht aus.

**Referenz und Zielgröße:** Die Sensitivität verwendet elf zeitlich korrekt geordnete Koeffizienten: fünf Vorperioden, Referenz [number withheld]H2 ausgelassen, sechs Nach-/Übergangsperioden ab [number withheld]H1. Die Gewichte für die sechs Nachperioden sind ([number withheld]): [number withheld]H1 wird als mögliche Übergangs-/Antizipationsperiode berücksichtigt, erhält aber kein Zielgewicht. Ziel ist der durchschnittliche Z-Kontrast [number withheld]H2–[number withheld]H2 relativ zu Ende [number withheld]. Dies ist ausdrücklich NICHT T0[number withheld]s Kontrast relativ zum gesamten Vorperiodendurchschnitt.

| Markt | Referenzbasierter Kontrast, pp | Gewöhnliches [number withheld]%-Normalintervall | T077: gepoolte Vorperiode, pp |
|---|---:|---|---:|
| A | [number withheld] | [[number withheld]; [number withheld]] | [number withheld] |
| HK | [number withheld] | [[number withheld]; [number withheld]] | [number withheld] |

Quelle: `t078_original_targets.csv`. Die Veränderung des Zahlenwerts gegenüber T077 folgt rechnerisch allein der anderen Referenz; keine neue Stichprobenwahl. Die zehn gemeinsamen dynamischen Koeffizienten und ihre Kovarianz stimmen mit T077 innerhalb [number withheld] überein. Die Hauptpopulationen bleiben A: [number withheld]/[number withheld], HK: [number withheld]/[number withheld] Entwickler/Kontrollen.

**Robuste [number withheld]%-Intervalle in Prozentpunkten (feinere, vorab geplante [number withheld]-Punkte-Prüfung):**

| Markt | Mbar | Robustes Intervall, pp | Null enthalten? |
|---|---:|---|---|
| A | [number withheld] | [[number withheld]; [number withheld]] | ja |
| A | [number withheld] | [[number withheld]; [number withheld]] | ja |
| A | [number withheld] | [[number withheld]; [number withheld]] | ja |
| A | [number withheld] | [[number withheld]; [number withheld]] | ja |
| A | [number withheld] | [[number withheld]; [number withheld]] | ja |
| HK | [number withheld] | [[number withheld]; [number withheld]] | nein |
| HK | [number withheld] | [[number withheld]; [number withheld]] | ja |
| HK | [number withheld] | [[number withheld]; [number withheld]] | ja |
| HK | [number withheld] | [[number withheld]; [number withheld]] | ja |
| HK | [number withheld] | [[number withheld]; [number withheld]] | ja |

Quelle: `t078_sensitivity.csv`; die vollständigen [number withheld]- und [number withheld]-Punkte-Ergebnisse sind beide gespeichert. Mbar begrenzt Änderungen des unbeobachteten unbehandelten Gruppenunterschieds in den Nachperioden relativ zur größten entsprechenden Änderung zwischen aufeinanderfolgenden Vorperioden. Mbar=[number withheld] ist daher eine Annahme über zulässige Gegenentwicklung, kein geschätzter tatsächlicher Störfaktor. Die Unsicherheit der Vorperioden wird mit berücksichtigt.

A schließt null schon bei Mbar=[number withheld] ein. Für HK liegt die erste Null-Einschließung im vorab festgelegten Raster bei [number withheld], also lediglich eine Rastereingrenzung zwischen [number withheld] und [number withheld], keine genau geschätzte Belastbarkeitsgrenze. Beide numerischen Auflösungen ergeben dieselbe Null-Einschluss-Aussage. Die Intervalle sind je Markt und Annahmewert, nicht simultan über alle Märkte/Mbar-Werte.

## Dateien

- `replication/code/t078_setup.R` – Setup bzw. offline Analyseskript.
- `replication/code/27_honest_sensitivity.R` – Setup bzw. offline Analyseskript.
- `replication/outputs/tables/t078_all_grid_results.csv` – Skriptgenerierte Ergebnisse und Prüfbelege.
- `replication/outputs/tables/t078_author_example.csv` – Skriptgenerierte Ergebnisse und Prüfbelege.
- `replication/outputs/tables/t078_author_example_warnings.csv` – Skriptgenerierte Ergebnisse und Prüfbelege.
- `replication/outputs/tables/t078_grid_convergence.csv` – Skriptgenerierte Ergebnisse und Prüfbelege.
- `replication/outputs/tables/t078_input_coefficients.csv` – Skriptgenerierte Ergebnisse und Prüfbelege.
- `replication/outputs/tables/t078_input_covariance.csv` – Skriptgenerierte Ergebnisse und Prüfbelege.
- `replication/outputs/tables/t078_original_targets.csv` – Skriptgenerierte Ergebnisse und Prüfbelege.
- `replication/outputs/tables/t078_protected_files.csv` – Skriptgenerierte Ergebnisse und Prüfbelege.
- `replication/outputs/tables/t078_reproducibility.csv` – Skriptgenerierte Ergebnisse und Prüfbelege.
- `replication/outputs/tables/t078_sensitivity.csv` – Skriptgenerierte Ergebnisse und Prüfbelege.
- `replication/outputs/tables/t078_solver_messages.csv` – Skriptgenerierte Ergebnisse und Prüfbelege.
- `replication/outputs/tables/t078_specification.csv` – Skriptgenerierte Ergebnisse und Prüfbelege.
- `replication/outputs/tables/t078_validation.csv` – Skriptgenerierte Ergebnisse und Prüfbelege.
- `replication/outputs/tables/t078_zero_inclusion.csv` – Skriptgenerierte Ergebnisse und Prüfbelege.
- `replication/outputs/tables/t078_reproducibility.csv` – SHA-[number withheld]-Vergleich, [number withheld]/[number withheld] Artefakte identisch.
- `replication/outputs/figures/t078_sensitivity.pdf` – Sensitivitätsgrafik, beide Märkte mit gemeinsamer Skala.
- `replication/software/t0[number withheld]/library/` – isolierte Paketbibliothek; keine Änderung der globalen R-Bibliothek.
- `replication/software/t0[number withheld]/downloads/`, `downloads_manifest.csv` – offizielle CRAN-Binärpakete mit URL, SHA-[number withheld] und Größe.
- `replication/software/t078/dependencies.csv`, `cran_binary_index.rds`, `sessionInfo.txt`, `STATUS.txt`, `setup.log`, `global_library_guard.csv` – Auflösung, Versionen und Installationsbelege.
- `replication/software/t078/*arguments*.R.txt`, `*_function.txt`, `*_formals.txt`, `*.Rd.txt`, `installed_solvers.txt` – exakte Aufrufe, Originalfunktionen, Dokumentation und verfügbare Solver.
- `replication/software/t078/run1_artifacts.csv`, `analysis_run2.log` – Laufnachweise.
- `tasks/T078_report.md` – dieser Bericht; keine Statusänderung.

## Ausführung

Aus dem Projektordner:

[fenced excerpt withheld in public process copy]
[fenced excerpt withheld in public process copy]

Setup mit freigegebenem Netzwerkzugriff für öffentliche CRAN-Pakete; die anschließende Analyse läuft offline. Keine Projektdaten hochgeladen, keine Systempakete installiert. Letzte erfolgreiche Ausgabe:

[fenced excerpt withheld in public process copy]
[fenced excerpt withheld in public process copy]

Die statistische Analyse lief zweimal mit identischen Ergebnissen; SHA-[number withheld]-Vergleich in `t078_reproducibility.csv`. Die abschließende reine Darstellungsänderung (Punkte zeigen den unveränderten Originalschätzwert, zusätzlicher Achsenabstand) wurde separat zweimal aus den gespeicherten identischen Ergebnissen erzeugt und verglichen; keine Neuschätzung und keine Änderung der Intervalle.

## Abnahmekriterien

[number withheld]. **Erfüllt:** HonestDiD [number withheld] aus kompatiblen offiziellen CRAN-Binärpaketen, Abhängigkeiten und Prüfsummen dokumentiert. Projektbibliothek vorangestellt; globale Bibliotheksdateien unverändert. Keine mathematischen Paketänderungen oder Solverwechsel.
[number withheld]. **Erfüllt:** Elf aufeinanderfolgende Halbjahres-Koeffizienten mit ausgelassener Referenz und Zielgewicht null für die Übergangsperiode. Koeffizienten/Kovarianzen aus individuellen balancierten Firmenverläufen; Rang [number withheld] und positive Eigenwerte bei den festgelegten Toleranzen. Rekonstruktion der gemeinsamen T077-Inputs und der Beziehung zwischen beiden Zielgrößen bestanden.
[number withheld]. **Erfüllt mit offengelegten Warnungen:** Das mitgelieferte Autorenbeispiel BCdata_EventStudy mit dokumentierten Periodenindizes ausgeführt; Original-Normalintervalle unabhängig algebraisch und in beiden Einheiten validiert, ebenso die Projektinputs. Für den robusten BCdata-Aufruf gibt die Dokumentation keinen gedruckten numerischen Sollwert vor: kein erfundener Referenzvergleich. Zwei Endpunktwarnungen aus diesem Beispiel sind gespeichert. Dies ist keine unabhängige Implementierung des robusten C-LF-Verfahrens und kein externer Review.
[number withheld]. **Erfüllt:** Alle fünf Mbar-Werte, beide Märkte, C-LF, [number withheld]%, keine Zusatzrestriktionen, Seed [number withheld], parallel=FALSE. Das anfängliche Raster +/[number withheld] SE war in beiden Märkten bei großen Mbar abgeschnitten; wie festgelegt auf +/[number withheld] SE für alle Mbar erweitert. Im endgültigen Raster keine Randberührung und keine Solverwarnungen. Alle anfänglichen Warnungen und Zwischenraster gespeichert. Endpunktunterschiede [number withheld]/[number withheld] Punkte höchstens [number withheld] pp, unter der festgelegten [number withheld]-pp-Toleranz. Dies ist numerische Auflösung, nicht statistische Unsicherheit. Der öffentliche Paketaufruf liefert keine zusätzlichen Solver-Statusfelder; Inventar und unveränderte Defaults dokumentiert.
[number withheld]. **Erfüllt:** Statistische Ergebnisdateien zweimal identisch; Schutzdateien unverändert; finale Grafik separat zweimal identisch und gerendert/sichtgeprüft. Kein Übertrag ins Proposal, in Folien oder ins öffentliche Archiv; run_all bleibt unverändert. Der Kartenstatus bleibt vom Worker unberührt.

## Offene Fragen

- **Unabhängiger Review steht aus.** Technische Selbstprüfungen und Autorenbeispiel ersetzen die Rolle estimation durch ein anderes Tool nicht. Keine Übernahme als freigegebener Hauptbefund vor diesem Review.
- **Identifikation bleibt begrenzt.** HK hat nur [number withheld] berichtsvollständige Entwickler und dünne Zielfensterstützung vor [number withheld]; A-Vortrend war bereits auffällig. Gruppenunterschiede in Krise, Bankenregulierung und Messung bleiben mögliche Ursachen. Diese Sensitivität beweist weder Null-Effekt noch Politik-Effekt.
- Große Mbar führen zu sehr breiten, teils über natürliche Outcomegrenzen hinausgehenden Gaussian-Intervallen. Die vorab gewählte Methode nutzt keine zusätzlichen beschränkten-Outcome-Annahmen; es wurden keine nachträglichen günstigen Restriktionen hinzugefügt.
- Die kausale Behauptung sollte daher nicht verschärft werden. Beobachtete Schwellenkonzentration, rechnerische MI-Abhängigkeit und tatsächlich schuldenähnliche Verträge sind weiterhin unterschiedliche Evidenzarten. Letztere erfordern verknüpfte Vertragsbelege.
- Installation ist lokal dokumentiert; eine dauerhafte Integration in environment.lock, run_all, Proposal oder öffentliches Paket gehört nicht zum Schreibbereich und wurde nicht vorgenommen.
- KI-Log-Vorschlag nach Abnahme: „T078: isolierte Installation von HonestDiD [number withheld] aus CRAN; korrekte Halbjahresfolge einschließlich Übergangsperiode; Originalbeispiel, Kovarianz-/Normalintervall-/Einheitenvalidierung; relative-magnitude Sensitivität über festes Mbar-Raster, numerische Gitterprüfung, Byteidentität und Sichtprüfung. A bereits bei Mbar=[number withheld] unpräzise, HK schließt null bei geprüftem Mbar=[number withheld] ein; keine kausale Verschärfung; unabhängiger Review separat.“
