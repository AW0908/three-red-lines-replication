## Ergebnis

Die fünf REWORK-Punkte sind umgesetzt: eindeutige Log-Odds-Einheiten, korrigierte RL2-Zählerdiagnostik, überarbeitete Darstellung, zusätzliche Minderheiten-Kontraste und HK-Wind-Guard. Die bisherigen RL1-Zahlen und fünf ursprünglichen Kontraste bleiben unverändert. Zwei vollständige Builds bestätigen die Reproduzierbarkeit; alle Ergebnisse bleiben deskriptiv.

## Dateien

- `replication/code/08_decomposition.R` – Korrekturen, zusätzliche Kontraste und Guard.
- `replication/README.md` – Methodik, Darstellung und Changelog aktualisiert.
- `replication/outputs/tables/t027_identity_checks.txt` – präzisierte Zählerdiagnostik und Identitätsprüfungen.
- `replication/outputs/tables/t027_events.csv` – unveränderte Ereigniszahlen, erneut erzeugt.
- `replication/outputs/tables/t027_event_audit.csv` – korrigierte RL2-Diagnostik je Ereignis.
- `replication/outputs/tables/t027_decomposition_rl1.csv` – Interpretation von `reported_total` korrigiert.
- `replication/outputs/tables/t027_decomposition_rl1.tex` – Einheiten, berechnete Prozentpunktübersetzung und Darstellung.
- `replication/outputs/tables/t027_decomposition_rl2.csv` – `dln_n` auf Nettoschuld bezogen.
- `replication/outputs/tables/t027_decomposition_rl2.tex` – Null- und Anteilsdarstellung korrigiert.
- `replication/outputs/tables/t027_tests.csv` – sieben Bootstrap-Kontraste.
- `replication/outputs/tables/t027_tests.tex` – ergänzte Kontraste und Einschränkungen.
- `replication/outputs/tables/t027_debt_growth.csv` – unverändert, erneut erzeugt.
- `replication/outputs/tables/t027_robustness.csv` – RL2-Diagnostik entsprechend korrigiert.
- `replication/outputs/figures/t027_decomposition_rl1.pdf` – All-Events-Zerlegung mit Fallzahlen und Komponentenabdeckung.
- `replication/outputs/tables/t027_verification.txt` – Ausführungs-, Prüfungs- und SHA-[number withheld]-Belege.

Die Pipeline-Einstiegspunkte waren bereits korrekt und blieben unverändert.

## Ausführung

Exakter Befehl, zweimal mit endgültigem Code erfolgreich ausgeführt:

[fenced excerpt withheld in public process copy]
[fenced excerpt withheld in public process copy]

Letzte Zeilen der Standardausgabe des zweiten Laufs:

[fenced excerpt withheld in public process copy]
[fenced excerpt withheld in public process copy]

Keine Netzwerkzugriffe oder Paketinstallationen. Unabhängige Nachrechnung bestätigt beide neuen Bootstrap-Intervalle; temporäre Testfälle bestätigen den HK-Wind-Guard an beiden Endpunkten sowie die RL2-Guards bei nichtpositiver Nettoschuld.

## Abnahmekriterien

[number withheld]. **Nicht vollständig erfüllt, datenbedingt und unverändert:** Bilanzidentitätsverletzungen über [number withheld] %: [number withheld]/[number withheld] auswertbare Panelzeilen und [number withheld]/[number withheld] Hauptstichprobenzeilen. Alle verfügbaren Komponentensummen bestehen `stopifnot` bis [number withheld]; maximaler Fehler [number withheld] × [number withheld]⁻¹⁶. Eine vollständige Zerlegung jedes Ereignisses bleibt wegen [number withheld] undefinierter RL1-Stayer-Logits und eines fehlenden Minderheitenwerts je Kreuzungsart unmöglich. Belege: Identitätsbericht und Ereignisaudit.

[number withheld]. **Erfüllt:** Alle zwölf Analyseartefakte sind zwischen zwei vollständigen Builds byte-identisch. Alle [number withheld] gesicherten Nicht-T027-Output-/Datendateien bleiben nach jedem Lauf byte-identisch. Bestehende Zahlen ändern sich ausschließlich bei der ausdrücklich beanstandeten RL2-Zählerdiagnostik. Alle sechs Tabellenseiten und die Abbildung wurden visuell geprüft; LaTeX kompiliert ohne Layoutwarnungen. Beleg: `t027_verification.txt`.

[number withheld]. **Erfüllt hinsichtlich Interpretation und Darstellung:** Sämtliche Statistiken enthalten Interpretations- und Abdeckungsangaben in den CSVs. Negative Schuldenänderungen sprechen für realen Schuldenabbau; negative Eigenkapitalbeiträge zeigen einen Rückgang durch mehr Eigenkapital. Minderheiten und Perpetuals sind ausschließlich unter den Theorieannahmen kosmetiknah: schuldenähnliches Partnereigenkapital und als Eigenkapital verbuchte Perpetuals.

   | RL1-Statistik | Post-Kreuzungen | Pre-Kreuzungen | Post-Stayer |
   |---|---:|---:|---:|
   | Median Δlogit(RL1) | [number withheld] | [number withheld] | [number withheld] |
   | Median Δln N | [number withheld] | [number withheld] | [number withheld] |
   | Median Δln te | [number withheld] | [number withheld] | [number withheld] |
   | Median Δln ibd | [number withheld] | [number withheld] | [number withheld] |
   | Anteil mit fallender Schuld | [number withheld] % | [number withheld] % | [number withheld] % |
   | Eigenkapital erklärt über Hälfte des Rückgangs | [number withheld] % | [number withheld] % | [number withheld] % |

   Negative Δln N und Δln ibd zeigen sinkende Verbindlichkeiten beziehungsweise Schuld. Positive Δln te und hohe Eigenkapitaldominanz zeigen eine stärkere Nenneranpassung, beweisen aber keine kosmetische Anpassung. Die Stayer-Eigenkapitaldominanz bezieht sich nur auf [number withheld] Ereignisse mit sinkendem Logit.

   Der Post-Median [number withheld] entspricht nahe RL1 = [number withheld] nach der im Code berechneten Näherung ungefähr **[number withheld] Prozentpunkten**. Bei [number withheld]/[number withheld] Post-Kreuzungen steigt die Schuld trotz sinkendem RL1.

   | Kontrast | Differenz | [number withheld]-%-Intervall |
   |---|---:|---:|
   | Median Δln N: Post minus Pre | [number withheld] | [[number withheld]; [number withheld]] |
   | Median Δln te: Post minus Pre | [number withheld] | [[number withheld]; [number withheld]] |
   | Anteil mit fallender Schuld: Post minus Pre | [number withheld] | [[number withheld]; [number withheld]] |
   | Median Minderheiten-/Perpetual-Anteil: Post minus Pre | [number withheld] | [[number withheld]; [number withheld]] |
   | Median Δln ibd: Post minus Stayer | [number withheld] | [[number withheld]; [number withheld]] |
   | **Median Minderheitenanteil: Post minus Pre** | **[number withheld]** | **[[number withheld]; [number withheld]]** |
   | **Mittlerer Minderheitenanteil: Post minus Pre** | **[number withheld]** | **[[number withheld]; [number withheld]]** |

   Höhere Minderheitenanteile sprechen nur unter der Partnerannahme für stärkere kosmetiknahe Anpassung. Die neuen Kontraste verwenden [number withheld] Post- und [number withheld] Pre-Ereignisse, jeweils [number withheld] gültige Ziehungen. Alle Intervalle schließen null ein. Der Perpetual-Kontrast bleibt mit nur einer Pre-Firma und [number withheld] gültigen Ziehungen ausdrücklich bedingt und unzuverlässig.

   Bei RL2 beträgt der korrigierte Median Δln Nettoschuld [number withheld] post und [number withheld] pre; negative Werte zeigen Nettoschuldenabbau. Die bereits geprüften Komponenten bleiben unverändert.

[number withheld]. **Erfüllt:** Fallzahlen sind vollständig berichtet; [number withheld] RL1-Post-Kreuzungen überschreiten die Stoppschwelle von [number withheld].

   | Zelle | Ereignisse | Firmen |
   |---|---:|---:|
   | RL1 Post-Kreuzungen | [number withheld] | [number withheld] |
   | RL1 Pre-Kreuzungen | [number withheld] | [number withheld] |
   | RL1 Post-Stayer | [number withheld] | [number withheld] |
   | RL2 Post-Kreuzungen | [number withheld] | [number withheld] |
   | RL2 Pre-Kreuzungen | [number withheld] | [number withheld] |

## Offene Fragen

[firm-specific excerpt withheld in public process copy]
- Die Perpetual-Pre-Teilstichprobe mit zwei Ereignissen einer Firma erlaubt keinen belastbaren Pre-/Post-Vergleich.
- Die Abbildung verwendet verfügbare Komponentenmediane aller Ereignisse; unterschiedliche Abdeckung steht in der Bildnote.
- HK-Logänderungen setzen unveränderte Berichtswährung innerhalb der Firma voraus; D7 bleibt offen.
- Vorgeschlagener KI-Protokolleintrag: „2026-10-21, Codex, T027 REWORK: Einheiten, RL2-Diagnostik und Darstellung korrigiert; Minderheiten-Kontraste und HK-Wind-Guard ergänzt; durch zwei vollständige Builds, unabhängige Nachrechnung, Guard-Tests, SHA-[number withheld]-Vergleiche und visuelle Prüfung verifiziert.“
- `AI_USAGE_LOG.md` liegt außerhalb des Schreibbereichs und wurde nicht geändert. Der Kartenstatus blieb unverändert.