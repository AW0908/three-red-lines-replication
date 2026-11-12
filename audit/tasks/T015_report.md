## Ergebnis

Die Rework-Punkte wurden umgesetzt: Hauptinteraktion mit eigentümerspezifischen Halbjahres-Fixed-Effects, bisherige Spezifikation als gekennzeichnete Robustheitsprüfung und korrigiertes TEX-Layout. Alle zehn Gruppeneffekte stimmen innerhalb von \(1{,}6 \times 10^{-15}\) mit den Split-Schätzungen überein. Vollständiger Lauf und zwei frische Neuaufbauten waren erfolgreich.

## Dateien

- `replication/code/05_heterogeneity.R` – neue Hauptspezifikation, Gleichheitsprüfungen, Robustheit und Tabellenkorrekturen.
- `replication/outputs/tables/t015_soe_heterogeneity.csv` – 40 Effektzeilen mit SE, Konfidenzintervallen und Stichprobenzahlen.
- `replication/outputs/tables/t015_soe_heterogeneity.tex` – korrigierte Tabelle mit aktualisierten Methodenhinweisen.
- `replication/outputs/tables/t015_specification_checks.csv` – zehn Interaktion/Split-Abgleiche.
- `replication/outputs/tables/t015_rework_verification.txt` – Laufprotokolle, Prüfsummen und Prüfcode.
- `replication/README.md` – Spezifikation, Ausgaben und Reproduktionsnachweise aktualisiert.
- `replication/outputs/tables/t015_ownership_counts.csv` – erneut erzeugt, byte-identisch.
- `replication/data/processed/panel_firm_halfyear.csv` – erneut erzeugt, byte-identisch.

## Ausführung

Exakter Befehl:

[fenced excerpt withheld in public audit]
[fenced excerpt withheld in public audit]

Letzte Standardausgabe:

[fenced excerpt withheld in public audit]
[fenced excerpt withheld in public audit]

## Abnahmekriterien

1. **Erfüllt:** 2.279 Zeilen, 89 Spalten; die drei Eigentümerspalten stehen am Ende. SHA-256 der ersten 86 Spalten vor und nach Rework sowie gegenüber dem ursprünglichen T015-Ausgangsstand identisch:

[fenced excerpt withheld in public audit]
[fenced excerpt withheld in public audit]

2. **Erfüllt:** Wind-Vorrang unverändert. Hauptstichprobe: 46 SOE, 82 privat, 8 NA.

   | Wind `soe` | Final 0 | Final 1 | Final NA |
   |---|---:|---:|---:|
   | 0 | 52 | 0 | 0 |
   | 1 | 0 | 43 | 0 |
   | NA | 30 | 3 | 8 |

   Manuelle Datei byte-identisch zur freigegebenen Eingabe; alle 16 Manifest-Einträge stimmen.

3. **Erfüllt:** Alle fünf Outcomes enthalten Hauptinteraktion, Split-Schätzungen und gekennzeichnete Robustheit. Private Koeffizienten stimmen zwischen Hauptinteraktion und privatem Split überein:

   | Outcome | Privater Effekt | N Interaktion | Firmen privat/SOE | N privater Split |
   |---|---:|---:|---:|---:|
   | rl1 | −0,005668 | 1.479 | 75/44 | 910 |
   | rl2 | −0,438165 | 1.458 | 75/44 | 889 |
   | rl2_gap | −0,008729 | 1.458 | 75/44 | 889 |
   | mi_share | 0,003577 | 1.419 | 73/44 | 857 |
   | jv_ta | 0,004191 | 1.160 | 57/39 | 669 |

   Zehn Gleichheitsassertionen bestanden; 15 Kontraste einschließlich SE zusätzlich über direkte Gruppeneffekte geprüft. Mindestens 39 Firmen je geschätzter Gruppe. TEX: Abstände ausschließlich zwischen vollständigen Blöcken, keine Null-Gruppenzählungen; kompiliert ohne Warnungen auf einer Seite und visuell geprüft.

4. **Erfüllt:** Beide frischen Neuaufbauten außerhalb des Projekts mit geleerten Ausgabeverzeichnissen: Exit 0. Jeweils 36/36 Analyseartefakte byte-identisch zum Projektlauf; alle 31 bisherigen Tabellen und Abbildungen unverändert. Dauerhafte Belege: `replication/outputs/tables/t015_rework_verification.txt`.

5. **Erfüllt:** Keine externen Pfadverweise in Code und Build-Einstiegspunkten. Alle Inhaltsänderungen liegen im Schreibbereich; Kartenstatus unverändert.

## Offene Fragen

[firm-specific excerpt withheld in public audit]
- Eigentümerquellen wurden ohne Netzwerkzugriff nicht erneut verifiziert. Identifikationsannahmen stehen in den TEX-Notizen; keine zusätzliche kausale Mechanismusaussage.
- Vorschlag für den KI-Nutzungseintrag durch den Co-PI: „Codex überarbeitete T015 gemäß Review; geprüft durch Interaktion/Split-Assertions, alternative Kontrastberechnung, TEX-Prüfung und zwei vollständige Neuaufbauten.“