## Ergebnis

Die S14-Notiz verwendet jetzt „the main sample“ statt des unmaskierten `sample_main`. Der vollständige Build in einer frischen Kopie endete mit Exit 0; sämtliche Zahlen blieben unverändert. Alle sechs generierten TEX-Tabellen wurden auf unmaskierte Sonderzeichen geprüft.

## Dateien

- `replication/code/04_robustness.R` – ausschließlich S14-Notiz korrigiert.
- `replication/outputs/tables/t011_robustness.tex` – aus dem geprüften Build übernommen.
- `replication/README.md` – eine Changelog-Zeile ergänzt.

## Ausführung

Exakter Befehl:
[fenced excerpt withheld in public audit]
[fenced excerpt withheld in public audit]

Ausgeführt in der temporären frischen Kopie unter `/var/folders/zm/380qc22n60l8fdpk4zdbt7x00000gn/T/T022_1c09dbnj/fresh/`, nachdem 37 generierte Analyseartefakte entfernt worden waren.

Letzte Ausgabezeilen:
[fenced excerpt withheld in public audit]
[fenced excerpt withheld in public audit]

## Abnahmekriterien

1. **Erfüllt:** `t011_robustness.tex` enthält keinen unmaskierten Unterstrich. Der einzige Unterschied liegt in Zeile 77:
[fenced excerpt withheld in public audit]
[fenced excerpt withheld in public audit]
2. **Erfüllt:** Build Exit 0. Von 37 neu erzeugten Analyseartefakten sind 36 bytegleich; nur die obige Notizzeile unterscheidet sich. Auch alle übrigen Dateien der Output-Verzeichnisse blieben bytegleich; keine Dateien kamen hinzu oder entfielen.
3. **Erfüllt:** Scan auf unmaskierte `_`, `%`, `&`, `#` in Text/Notizen:
   
   | TEX-Datei | Verbleibende Befunde |
   |---|---:|
   | `t005_by_dose.tex` | 0 |
   | `t005_summary_stats.tex` | 0 |
   | `t008_mde.tex` | 0 |
   | `t009_did_main.tex` | 0 |
   | `t011_robustness.tex` | 0 |
   | `t015_soe_heterogeneity.tex` | 0 |

   Gültige Tabellenspalten-Trenner, LaTeX-Kommentare und Unterstriche in `\label{...}` wurden ausgenommen. Keine weiteren Korrekturen erforderlich.

Temporäre Prüfbelege liegen unter `/var/folders/zm/380qc22n60l8fdpk4zdbt7x00000gn/T/T022_1c09dbnj/`, insbesondere `fresh_comparison.json`, `note.diff` und `scan_after.txt`.

## Offene Fragen

Keine. Eine Übersetzung des gesamten Proposals wurde nicht durchgeführt; das Kopieren nach `proposal/tables/` bleibt gemäß Karte beim PI nach DELIVERED. Der Kartenstatus wurde nicht verändert.

Vorschlag für den KI-Nutzungseintrag durch den Co-PI nach Abnahme: „T022: Codex korrigierte die S14-LaTeX-Notiz; vollständiger Fresh-copy-Build und Bytevergleich bestätigten unveränderte Zahlen, Sonderzeichenscan aller sechs TEX-Tabellen ohne weitere Befunde.“