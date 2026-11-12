## Rolle: consistency (claude, sonnet) – VERDICT: PASS


## Befunde
Keine inhaltlichen Inkonsistenzen zwischen Outputs, `.tex`-Fassungen und den Interpretationsabsätzen gefunden. Zwei Hinweise, kein Mangel:

1. Private/SOE-Zeilen in `t066_drdid.csv` tragen den Status "unreliable: fewer than 90 percent valid bootstrap draws" (766, 702 und 748 von 999 gültig). `t066_drdid.tex` und `t066_interpretation.csv` benennen das offen ("Valid"-Spalte, "unreliable"-Satz). Das ist konsistent berichtet. Die Aussagekraft ist begrenzt, aber das ist keine Textabweichung.
2. `t066_heckman.tex` weist für `mi_share` (389/499) und `jv_ta` (413/499) weniger als 90 % gültige Ziehungen aus. Die CSV markiert beide als "unreliable", und die Tabelle zeigt die Zahlen offen.

## Abnahmekriterien
Nur soweit sie meine Rolle betreffen:
- **Kriterium 2 (alle Varianten mit N, Trimming, Balance berichtet):** hinsichtlich Übereinstimmung belegt erfüllt.
  - `t066_drdid.tex` stimmt mit `t066_drdid.csv` überein: ATT, CI, T/C, Trim T/C und Valid. Geprüft wurden alle Private/SOE-Zeilen und die A_control-Zeilen. Beispiel: Private/SOE Y1 ‑0.0464 [‑0.2450, 0.2687], 28/38, 766/999.
  - `t066_heckman.tex` stimmt mit `t066_heckman.csv` und `t066_first_stage.csv` überein: Schätzer, CI, Wald (1.8796, 2.2859, 1.0568, 2.1629, 3.9954), N/Firmen, gültige Ziehungen. Die Caption nennt das Maximum 3.9954 und die Schwelle 10 korrekt. Die Spalte "Usable" ist durchgehend "No", passend zu `usable_strength = FALSE`.
  - `t066_first_stage.tex` stimmt mit `t066_first_stage.csv` überein: Koeffizient, z, Wald, Pseudo‑R², Overlap, N Firmen.
- **Interpretationstext Schritt 1:**
  - Die Zahlen Y1–Y4 für A‑Share‑Main und die Supplier‑Y4‑CIs stimmen mit der CSV überein.
  - "1 von 24 Placebo‑Intervallen schließt null aus" stimmt: Die CSV hat 24 A_control‑Placebozeilen, nur Y2/2016H2 ([‑0.2905, ‑0.0074]) schließt null aus.
  - Placebo‑Y3 2017H2 = 0.00344 [‑0.0340, 0.0428] stimmt.
- **Interpretationstext Schritt 2:**
  - Die Private/SOE‑ATTs, die gültigen Ziehungen (766/702) und das ΔΔb 3.2735 [‑1.8532, 9.0532] stimmen mit `t066_ownership_bunching.csv` überein.
  - Die Aussage, dass HK nur vier SOEs hat und nur der A‑Share‑Stratum berichtet wird, passt zur Tabellennote.
- **Interpretationstext Schritt 3:**
  - b_post 3.2157 [1.1728, 6.6245] und Δb 3.8369 [1.3611, 6.8625] stimmen mit `t066_reporting_weighted_bunching.csv` überein.
  - Der ungewichtete Δb von 4.0200 stimmt. Die Aussage "beide Intervalle schließen null aus" stimmt.
  - Die Auswahl der Spezifikationen (rl1:Z3, rl2:Z2, mi_share:Z3, rl2_gap:Z2, jv_ta:joint) passt zur `selected`‑Spalte in `t066_first_stage.csv`.
- **Rework‑1‑Punkt 3 und 4 (Heckman‑Tabelle, Interpretation Schritt 3):** belegt erfüllt. Wald‑ und Usable‑Spalte sind vorhanden, die Caption nennt das Maximum, die Dosis ist in der Note definiert, die IPW‑Werte stehen mit CIs im Text.
- Kriterien 1 und 3 (Reproduktion, Byte‑Identität, Schätzervalidierung) sowie Daten‑ und Schätzcode: nicht meine Rolle.

## Nicht geprüft
- `t066_number_map.csv` (11.241 Zeilen): nur Struktur und Kopfzeilen gesehen, keine zellenweise Abstimmung.
- `t066_balance.tex`/`.csv`, `t066_rework1_old_new.csv`, `t066_sample_audit.csv` und die PDF‑Abbildungen (`t066_overlap.pdf`, `t066_pretrends.pdf`): nicht geöffnet. Beschriftungen und Seitenzahlen der Abbildungen sind damit nicht gegen die CSVs abgeglichen.
- Die Alt→Neu‑Werte im Worker‑Bericht habe ich nicht geprüft, weil `t066_rework1_old_new.csv` und die Baseline‑RDS nicht geöffnet wurden. Die Neu‑Werte der Private/SOE‑Haupt‑ATTs stimmen mit der CSV überein.
- `replication/README.md` und `AI_USAGE_LOG.md`: nicht gegen die Outputs abgeglichen.
- Die Proposal‑Texte in `proposal/` wurden nicht geprüft. Die Textintegration ist laut Karte Aufgabe von T067.
- Ich konnte keine Befehle ausführen (Bash‑Zugriff verweigert) und habe daher nur mit Lesewerkzeugen geprüft. Die Zählung der 24 Placebo‑Intervalle habe ich von Hand an den ausgegebenen CSV‑Zeilen vorgenommen.
