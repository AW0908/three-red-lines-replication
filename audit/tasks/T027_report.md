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
- `replication/outputs/tables/t027_verification.txt` – Ausführungs-, Prüfungs- und SHA-256-Belege.

Die Pipeline-Einstiegspunkte waren bereits korrekt und blieben unverändert.

## Ausführung

Exakter Befehl, zweimal mit endgültigem Code erfolgreich ausgeführt:

[fenced excerpt withheld in public audit]
[fenced excerpt withheld in public audit]

Letzte Zeilen der Standardausgabe des zweiten Laufs:

[fenced excerpt withheld in public audit]
[fenced excerpt withheld in public audit]

Keine Netzwerkzugriffe oder Paketinstallationen. Unabhängige Nachrechnung bestätigt beide neuen Bootstrap-Intervalle; temporäre Testfälle bestätigen den HK-Wind-Guard an beiden Endpunkten sowie die RL2-Guards bei nichtpositiver Nettoschuld.

## Abnahmekriterien

1. **Nicht vollständig erfüllt, datenbedingt und unverändert:** Bilanzidentitätsverletzungen über 1 %: 0/2.277 auswertbare Panelzeilen und 0/1.691 Hauptstichprobenzeilen. Alle verfügbaren Komponentensummen bestehen `stopifnot` bis 1e-10; maximaler Fehler 4,44 × 10⁻¹⁶. Eine vollständige Zerlegung jedes Ereignisses bleibt wegen 15 undefinierter RL1-Stayer-Logits und eines fehlenden Minderheitenwerts je Kreuzungsart unmöglich. Belege: Identitätsbericht und Ereignisaudit.

2. **Erfüllt:** Alle zwölf Analyseartefakte sind zwischen zwei vollständigen Builds byte-identisch. Alle 73 gesicherten Nicht-T027-Output-/Datendateien bleiben nach jedem Lauf byte-identisch. Bestehende Zahlen ändern sich ausschließlich bei der ausdrücklich beanstandeten RL2-Zählerdiagnostik. Alle sechs Tabellenseiten und die Abbildung wurden visuell geprüft; LaTeX kompiliert ohne Layoutwarnungen. Beleg: `t027_verification.txt`.

3. **Erfüllt hinsichtlich Interpretation und Darstellung:** Sämtliche Statistiken enthalten Interpretations- und Abdeckungsangaben in den CSVs. Negative Schuldenänderungen sprechen für realen Schuldenabbau; negative Eigenkapitalbeiträge zeigen einen Rückgang durch mehr Eigenkapital. Minderheiten und Perpetuals sind ausschließlich unter den Theorieannahmen kosmetiknah: schuldenähnliches Partnereigenkapital und als Eigenkapital verbuchte Perpetuals.

   | RL1-Statistik | Post-Kreuzungen | Pre-Kreuzungen | Post-Stayer |
   |---|---:|---:|---:|
   | Median Δlogit(RL1) | −0,1620 | −0,2180 | 0,0109 |
   | Median Δln N | −0,0448 | −0,0354 | 0,0003 |
   | Median Δln te | 0,1067 | 0,1540 | −0,0019 |
   | Median Δln ibd | −0,0333 | −0,0147 | −0,0280 |
   | Anteil mit fallender Schuld | 66,7 % | 57,1 % | 64,8 % |
   | Eigenkapital erklärt über Hälfte des Rückgangs | 69,7 % | 57,1 % | 57,6 % |

   Negative Δln N und Δln ibd zeigen sinkende Verbindlichkeiten beziehungsweise Schuld. Positive Δln te und hohe Eigenkapitaldominanz zeigen eine stärkere Nenneranpassung, beweisen aber keine kosmetische Anpassung. Die Stayer-Eigenkapitaldominanz bezieht sich nur auf 125 Ereignisse mit sinkendem Logit.

   Der Post-Median −0,1620 entspricht nahe RL1 = 0,70 nach der im Code berechneten Näherung ungefähr **−3,40 Prozentpunkten**. Bei 11/33 Post-Kreuzungen steigt die Schuld trotz sinkendem RL1.

   | Kontrast | Differenz | 95-%-Intervall |
   |---|---:|---:|
   | Median Δln N: Post minus Pre | −0,0094 | [−0,0882; 0,1058] |
   | Median Δln te: Post minus Pre | −0,0473 | [−0,1547; 0,0966] |
   | Anteil mit fallender Schuld: Post minus Pre | 0,0952 | [−0,1751; 0,3607] |
   | Median Minderheiten-/Perpetual-Anteil: Post minus Pre | 0,2227 | [−0,1172; 0,5529] |
   | Median Δln ibd: Post minus Stayer | −0,0053 | [−0,0605; 0,0306] |
   | **Median Minderheitenanteil: Post minus Pre** | **0,3687** | **[−0,1097; 0,7470]** |
   | **Mittlerer Minderheitenanteil: Post minus Pre** | **0,1460** | **[−0,4220; 0,7658]** |

   Höhere Minderheitenanteile sprechen nur unter der Partnerannahme für stärkere kosmetiknahe Anpassung. Die neuen Kontraste verwenden 32 Post- und 21 Pre-Ereignisse, jeweils 999 gültige Ziehungen. Alle Intervalle schließen null ein. Der Perpetual-Kontrast bleibt mit nur einer Pre-Firma und 634 gültigen Ziehungen ausdrücklich bedingt und unzuverlässig.

   Bei RL2 beträgt der korrigierte Median Δln Nettoschuld −0,1478 post und −0,2197 pre; negative Werte zeigen Nettoschuldenabbau. Die bereits geprüften Komponenten bleiben unverändert.

4. **Erfüllt:** Fallzahlen sind vollständig berichtet; 33 RL1-Post-Kreuzungen überschreiten die Stoppschwelle von 20.

   | Zelle | Ereignisse | Firmen |
   |---|---:|---:|
   | RL1 Post-Kreuzungen | 33 | 31 |
   | RL1 Pre-Kreuzungen | 21 | 19 |
   | RL1 Post-Stayer | 281 | 74 |
   | RL2 Post-Kreuzungen | 28 | 27 |
   | RL2 Pre-Kreuzungen | 36 | 30 |

## Offene Fragen

[firm-specific excerpt withheld in public audit]
- Die Perpetual-Pre-Teilstichprobe mit zwei Ereignissen einer Firma erlaubt keinen belastbaren Pre-/Post-Vergleich.
- Die Abbildung verwendet verfügbare Komponentenmediane aller Ereignisse; unterschiedliche Abdeckung steht in der Bildnote.
- HK-Logänderungen setzen unveränderte Berichtswährung innerhalb der Firma voraus; D7 bleibt offen.
- Vorgeschlagener KI-Protokolleintrag: „2026-10-21, Codex, T027 REWORK: Einheiten, RL2-Diagnostik und Darstellung korrigiert; Minderheiten-Kontraste und HK-Wind-Guard ergänzt; durch zwei vollständige Builds, unabhängige Nachrechnung, Guard-Tests, SHA-256-Vergleiche und visuelle Prüfung verifiziert.“
- `AI_USAGE_LOG.md` liegt außerhalb des Schreibbereichs und wurde nicht geändert. Der Kartenstatus blieb unverändert.