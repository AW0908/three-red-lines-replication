## Rolle: consistency (declared=codex, effective=codex, high, Modell=Provider-Standard) – VERDICT: ESCALATE


## Befunde

[number withheld]. **Die ursprüngliche Eingabeintegrität ist weiterhin verletzt; der unveränderte letzte Worker-Lauf löst diesen Befund nicht.** Der unabhängige SHA-[number withheld]-Vergleich bestätigt außerhalb des Schreibbereichs:
   - `state/LIMITATIONS.md`: Baseline `b5e2[number withheld]f…`, aktuell `e5cec0[number withheld]…`.
   - `state/STATE.md`: Baseline `[number withheld]c4a8a5f…`, aktuell `f3[number withheld]ebfe9…`.

   Belege: `review/T082_baseline.sha256:16–17`; `replication/outputs/tables/t082_r9_scope_check.csv:21310–21311`. Die R9-Prüfung vergleicht beide Dateien bereits mit ihren geänderten Ausgangswerten. Sie belegt damit deren Erhaltung während dieses Laufs, nicht die Übereinstimmung mit der ursprünglichen Karten-Baseline.

   Die Governance-Ausnahme betrifft den Zeitbezug der Änderungszeitprüfung; die SHA-Prüfung bleibt ausdrücklich unverändert (`state/governance_proposal_runstart_20261116.md:21–27`). Nach `agents/TEAM.md:43` erzwingen Eingabeänderungen ESCALATE. Das ist kein nachgewiesener Schätzfehler und keine belegte Verursachung durch diesen Worker. Herkunft, Auswirkungen und Behandlung der historischen Änderungen muss der PI entscheiden.

## Abnahmekriterien

Maßgeblich sind die fünf Kriterien der Neufassung [number withheld] einschließlich Ergänzungen [number withheld] und [number withheld].

[number withheld]. **Belegt erfüllt hinsichtlich der geprüften Output-Konsistenz.** Die erhaltenen Tests von [number withheld]/[number withheld] aus Lauf [number withheld] und [number withheld]/[number withheld] aus Lauf [number withheld] protokollieren jeweils Exit [number withheld]; ihre Quellen stimmen mit den aktuellen Skripten überein. Alle [number withheld] zugehörigen Ausgabevergleiche wurden anhand der tatsächlichen Projekt- und Kopiedateien bestätigt. Die Abweichungen entsprechen den ergänzten Ausnahmen. Bei fünf PDFs verschwinden sämtliche Byteunterschiede nach ausschließlich im Speicher entfernten Datums-/ID-Feldern; die dekodierten Streams sind identisch. Vier weitere PDFs wurden erhalten, nicht regeneriert. Belege: `t082_r6_check.csv`, `t082_r7_check.csv`, `t082_r6_pdf_comparison.csv`.

[number withheld]. **Belegt erfüllt für die Publikationsdateien der Testkopien.** Je Kopie stimmen sämtliche [number withheld] Proposal- und [number withheld] Präsentationsdateien mit ihren Ausgangshashes überein. Die aktuellen [number withheld] Proposal-Dateien sind ebenfalls unverändert. Alle [number withheld] geprüften Paper-Abbildungen sowie beide HK-TEX-Tabellen stimmen bytegenau mit den entsprechenden Outputs überein. Belege: `t082_r6_copy_before.csv`, `t082_r7_copy_before.csv`; direkter Dateivergleich. Vollständige technische Schreibpfadkontrolle: **nicht meine Rolle**.

[number withheld]. **Belegt erfüllt.** Beide Einstiegsskripte und die private Komplettfassung enthalten dieselben [number withheld] Schritte in derselben Reihenfolge. Alle [number withheld] eingebetteten Quelltexte entsprechen den kanonischen Dateien. Schritt [number withheld] steht an Position [number withheld] und erhält überall `--embed-proposal-fonts`. Belege: `replication/run_all.R:18–28`, `replication/run_all.sh:6–11`, `privat_R/MTPA_komplett.R`.

[number withheld]. **Belegt erfüllt hinsichtlich Dokumentationskonsistenz.** Titel und Forschungsfrage entsprechen `state/STATE.md:[number withheld]`. Der Reproduktionsabschnitt benennt alle [number withheld] Dateien der Lauf-[number withheld]-Abweichungsliste und unterscheidet fehlgeschlagenen Gesamtbuild, spätere Einzeltests und erhaltene PDFs (`replication/README.md:74–124`). Die [number withheld] dokumentierten direkten Paketreferenzen passen zum Lockfile. Technische Paketvollständigkeit und installierte Versionen: **nicht meine Rolle**.

[number withheld]. **Nicht erfüllt hinsichtlich der historischen Eingabeintegrität.** Siehe Befund [number withheld]. Alle [number withheld] Freeze-Hashes stimmen vor und nach dieser Prüfung. Ob außerhalb der protokollierten Prüfungen Analyseskripte im Projekt ausgeführt wurden, ist nicht unabhängig belegt.

Zusätzliche Kriterien:

- **E4[number withheld]: Belegt erfüllt.** Unabhängig bestätigt: T066-Inventar [number withheld] → [number withheld] Zeilen, keine Löschung, vier geänderte Hashzellen; T072-Inventar [number withheld] → [number withheld] Zeilen, keine Löschung, sechs geänderte Hashzellen. Sämtliche `unchanged`-Flags sind wahr. Im T066-Validierungstext ändert sich ausschließlich der genehmigte Inventarsatz. Alle [number withheld] dokumentierten statistischen Dateivergleiche sind bytegleich. Beleg: `t082_r8_inventory_proof.csv:2–4` und direkte Vergleiche mit den erhaltenen Testkopien.
- **E4[number withheld]: Belegt erfüllt.** Die README enthält exakt die drei genehmigten Ersetzungen und keine weitere Änderung gegenüber der gesicherten Vorfassung. RL1-Definition, RL3-Richtung und Build-Reihenfolge stimmen überein. Belege: `t0[number withheld]_r8_README.diff`; `replication/README.md:[number withheld]–[number withheld]–[number withheld]`.
- **E4[number withheld]: Belegt erfüllt im geprüften Umfang.** Die [number withheld] statistischen Vergleiche, [number withheld] Proposal-Dateien und [number withheld] inventarisierten Dateien unter `public_release/` wurden unabhängig bestätigt. Vollständige technische Integritätsprüfung aller übrigen statistischen Dateien und von `Daten/`: **nicht meine Rolle**.

## Nicht geprüft

- Keine Analyse, Teststeuerung, Installation oder Netzwerkabfrage ausgeführt; keine Datei verändert.
- Keine erneute Prüfung von Schätzern, Stichprobenselektion, Kovarianzen oder sämtlichen Zahlen und Querverweisen im unveränderten Proposal.
- Kein vollständiger Neubau; vier historische PDFs wurden durch die erhaltenen Tests nicht regeneriert.
- Reviewer und Worker gehören zur Codex-Modellfamilie. Es besteht Prozessunabhängigkeit, keine vollständige Modellunabhängigkeit; korrelierte Fehler bleiben möglich. Ein externes menschliches oder anderes Modell-Audit bleibt eine Option des PI für weitergehende Schätzungsprüfungen.