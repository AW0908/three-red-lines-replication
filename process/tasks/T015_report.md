## Ergebnis

Die Rework-Punkte wurden umgesetzt: Hauptinteraktion mit eigentümerspezifischen Halbjahres-Fixed-Effects, bisherige Spezifikation als gekennzeichnete Robustheitsprüfung und korrigiertes TEX-Layout. Alle zehn Gruppeneffekte stimmen innerhalb von \([number withheld]{,}[number withheld] \times [number withheld]^{[number withheld]}\) mit den Split-Schätzungen überein. Vollständiger Lauf und zwei frische Neuaufbauten waren erfolgreich.

## Dateien

- `replication/code/05_heterogeneity.R` – neue Hauptspezifikation, Gleichheitsprüfungen, Robustheit und Tabellenkorrekturen.
- `replication/outputs/tables/t015_soe_heterogeneity.csv` – [number withheld] Effektzeilen mit SE, Konfidenzintervallen und Stichprobenzahlen.
- `replication/outputs/tables/t015_soe_heterogeneity.tex` – korrigierte Tabelle mit aktualisierten Methodenhinweisen.
- `replication/outputs/tables/t015_specification_checks.csv` – zehn Interaktion/Split-Abgleiche.
- `replication/outputs/tables/t015_rework_verification.txt` – Laufprotokolle, Prüfsummen und Prüfcode.
- `replication/README.md` – Spezifikation, Ausgaben und Reproduktionsnachweise aktualisiert.
- `replication/outputs/tables/t015_ownership_counts.csv` – erneut erzeugt, byte-identisch.
- `replication/data/processed/panel_firm_halfyear.csv` – erneut erzeugt, byte-identisch.

## Ausführung

Exakter Befehl:

[fenced excerpt withheld in public process copy]
[fenced excerpt withheld in public process copy]

Letzte Standardausgabe:

[fenced excerpt withheld in public process copy]
[fenced excerpt withheld in public process copy]

## Abnahmekriterien

[number withheld]. **Erfüllt:** [number withheld] Zeilen, [number withheld] Spalten; die drei Eigentümerspalten stehen am Ende. SHA-[number withheld] der ersten [number withheld] Spalten vor und nach Rework sowie gegenüber dem ursprünglichen T015-Ausgangsstand identisch:

[fenced excerpt withheld in public process copy]
[fenced excerpt withheld in public process copy]

[number withheld]. **Erfüllt:** Wind-Vorrang unverändert. Hauptstichprobe: [number withheld] SOE, [number withheld] privat, [number withheld] NA.

   | Wind `soe` | Final [number withheld] | Final [number withheld] | Final NA |
   |---|---:|---:|---:|
   | [number withheld] | [number withheld] | [number withheld] | [number withheld] |
   | [number withheld] | [number withheld] | [number withheld] | [number withheld] |
   | NA | [number withheld] | [number withheld] | [number withheld] |

   Manuelle Datei byte-identisch zur freigegebenen Eingabe; alle [number withheld] Manifest-Einträge stimmen.

[number withheld]. **Erfüllt:** Alle fünf Outcomes enthalten Hauptinteraktion, Split-Schätzungen und gekennzeichnete Robustheit. Private Koeffizienten stimmen zwischen Hauptinteraktion und privatem Split überein:

   | Outcome | Privater Effekt | N Interaktion | Firmen privat/SOE | N privater Split |
   |---|---:|---:|---:|---:|
   | rl1 | [number withheld] | [number withheld] | [number withheld]/[number withheld] | [number withheld] |
   | rl2 | [number withheld] | [number withheld] | [number withheld]/[number withheld] | [number withheld] |
   | rl2_gap | [number withheld] | [number withheld] | [number withheld]/[number withheld] | [number withheld] |
   | mi_share | [number withheld] | [number withheld] | [number withheld]/[number withheld] | [number withheld] |
   | jv_ta | [number withheld] | [number withheld] | [number withheld]/[number withheld] | [number withheld] |

   Zehn Gleichheitsassertionen bestanden; [number withheld] Kontraste einschließlich SE zusätzlich über direkte Gruppeneffekte geprüft. Mindestens [number withheld] Firmen je geschätzter Gruppe. TEX: Abstände ausschließlich zwischen vollständigen Blöcken, keine Null-Gruppenzählungen; kompiliert ohne Warnungen auf einer Seite und visuell geprüft.

[number withheld]. **Erfüllt:** Beide frischen Neuaufbauten außerhalb des Projekts mit geleerten Ausgabeverzeichnissen: Exit [number withheld]. Jeweils [number withheld]/[number withheld] Analyseartefakte byte-identisch zum Projektlauf; alle [number withheld] bisherigen Tabellen und Abbildungen unverändert. Dauerhafte Belege: `replication/outputs/tables/t015_rework_verification.txt`.

[number withheld]. **Erfüllt:** Keine externen Pfadverweise in Code und Build-Einstiegspunkten. Alle Inhaltsänderungen liegen im Schreibbereich; Kartenstatus unverändert.

## Offene Fragen

[firm-specific excerpt withheld in public process copy]
- Eigentümerquellen wurden ohne Netzwerkzugriff nicht erneut verifiziert. Identifikationsannahmen stehen in den TEX-Notizen; keine zusätzliche kausale Mechanismusaussage.
- Vorschlag für den KI-Nutzungseintrag durch den Co-PI: „Codex überarbeitete T015 gemäß Review; geprüft durch Interaktion/Split-Assertions, alternative Kontrastberechnung, TEX-Prüfung und zwei vollständige Neuaufbauten.“