## Ergebnis

Die S1[number withheld]-Notiz verwendet jetzt „the main sample“ statt des unmaskierten `sample_main`. Der vollständige Build in einer frischen Kopie endete mit Exit [number withheld]; sämtliche Zahlen blieben unverändert. Alle sechs generierten TEX-Tabellen wurden auf unmaskierte Sonderzeichen geprüft.

## Dateien

- `replication/code/04_robustness.R` – ausschließlich S1[number withheld]-Notiz korrigiert.
- `replication/outputs/tables/t011_robustness.tex` – aus dem geprüften Build übernommen.
- `replication/README.md` – eine Changelog-Zeile ergänzt.

## Ausführung

Exakter Befehl:
[fenced excerpt withheld in public process copy]
[fenced excerpt withheld in public process copy]

Ausgeführt in der temporären frischen Kopie unter `/var/folders/zm/[number withheld]qc2[number withheld]n6[number withheld]l8fdpk4zdbt7x0[number withheld]gn/T/T0[number withheld]_1c0[number withheld]dbnj/fresh/`, nachdem [number withheld] generierte Analyseartefakte entfernt worden waren.

Letzte Ausgabezeilen:
[fenced excerpt withheld in public process copy]
[fenced excerpt withheld in public process copy]

## Abnahmekriterien

[number withheld]. **Erfüllt:** `t011_robustness.tex` enthält keinen unmaskierten Unterstrich. Der einzige Unterschied liegt in Zeile [number withheld]:
[fenced excerpt withheld in public process copy]
[fenced excerpt withheld in public process copy]
[number withheld]. **Erfüllt:** Build Exit [number withheld]. Von [number withheld] neu erzeugten Analyseartefakten sind [number withheld] bytegleich; nur die obige Notizzeile unterscheidet sich. Auch alle übrigen Dateien der Output-Verzeichnisse blieben bytegleich; keine Dateien kamen hinzu oder entfielen.
[number withheld]. **Erfüllt:** Scan auf unmaskierte `_`, `%`, `&`, `#` in Text/Notizen:
   
   | TEX-Datei | Verbleibende Befunde |
   |---|---:|
   | `t005_by_dose.tex` | [number withheld] |
   | `t005_summary_stats.tex` | [number withheld] |
   | `t008_mde.tex` | [number withheld] |
   | `t009_did_main.tex` | [number withheld] |
   | `t011_robustness.tex` | [number withheld] |
   | `t015_soe_heterogeneity.tex` | [number withheld] |

   Gültige Tabellenspalten-Trenner, LaTeX-Kommentare und Unterstriche in `\label{...}` wurden ausgenommen. Keine weiteren Korrekturen erforderlich.

Temporäre Prüfbelege liegen unter `/var/folders/zm/[number withheld]qc2[number withheld]n6[number withheld]l8fdpk4zdbt7x0[number withheld]gn/T/T0[number withheld]_1c0[number withheld]dbnj/`, insbesondere `fresh_comparison.json`, `note.diff` und `scan_after.txt`.

## Offene Fragen

Keine. Eine Übersetzung des gesamten Proposals wurde nicht durchgeführt; das Kopieren nach `proposal/tables/` bleibt gemäß Karte beim PI nach DELIVERED. Der Kartenstatus wurde nicht verändert.

Vorschlag für den KI-Nutzungseintrag durch den Co-PI nach Abnahme: „T022: Codex korrigierte die S1[number withheld]-LaTeX-Notiz; vollständiger Fresh-copy-Build und Bytevergleich bestätigten unveränderte Zahlen, Sonderzeichenscan aller sechs TEX-Tabellen ohne weitere Befunde.“