## Rolle: data (claude, opus) – VERDICT: PASS


## Befunde

Keine Mängel in der Datenaufbereitung, die eine Nacharbeit innerhalb dieser Karte verlangen. Die folgenden Hinweise sind nicht blockierend, schwerster zuerst:

1. **Mittelwerte im Kompositionstest reagieren wahrscheinlich stark auf Ausreißer.** `06_bunching_tests.R:324-325` verwendet `mi_share`, `perp_te`, `jv_ta` und `cash_ta` ungetrimmt. `mi_share = mi/te` stammt aus `01_clean.R:588`, und `safe_ratio` setzt den Wert nur bei `te ≤ 0` auf NA (`01_clean.R:575`). Wenn `te` klein, aber positiv ist, wird der Quotient sehr groß. In `t023_composition.csv`, Zeile 4, liegt die mittlere Änderung von `mi_share` bei den Firmen, die über 0,70 bleiben, bei **+0,100 je Halbjahr** (n = 266). Für eine typische Halbjahresänderung ist das unplausibel und spricht für einzelne Extremwerte. Ich habe das nicht am Panel nachgeprüft. Folge: Die deskriptiven Mittelwertvergleiche für `mi_share` (p = 0,196) und möglicherweise `jv_ta` könnten von wenigen Beobachtungen bestimmt sein. Empfehlung an den Co-PI: Mediane oder getrimmte Mittelwerte ergänzen, oder im Text einen Hinweis aufnehmen. Die Karte verlangt das nicht.
2. **Zahl der Firmen mit `fye_flag` widerspricht der Dokumentation.** Karte (Co-PI-Punkt 3) und `state/LIMITATIONS.md` D11 nennen 11 Firmen. Im Panel tragen 10 Firmen das Flag, davon 4 in der Hauptstichprobe. Belege: Report, offene Fragen; `t023_reporting_dates.csv`, Spalte `flagged_firms_in_main_sample` = 4. Die Ursache liegt vor T023 im Abgleich `01_clean.R:398` (`firm_id %in% hk_id(fye$code)`); vermutlich kommt ein Code nicht im Universum vor. Folge: Die Ausschlussvariante entfernt alle im Panel geflaggten Zeilen korrekt (391 − 11 = 380, 406 − 10 = 396, 254 − 4 = 250, 376 − 6 = 370). Nur D11 sollte der Co-PI präzisieren.
3. **Die Umkehranalyse in der Post-Periode hat deutlich mehr fehlende Folgebeobachtungen.** Laut `t023_reversal.csv`, Zeilen 4–5, fehlt der nächste Stichtag bei 17 von 78 Ursprüngen in [0,68; 0,70) und bei 12 von 62 in der Kontrollgruppe. In der Pre-Periode sind es 0 von 36. Ursache sind die Rechtszensierung Ende 2022 und Delistings (D4). Der Code überbrückt keine Lücken (`:254-256`) und weist die Ausfälle in eigenen Spalten aus (`next_date_absent`). Die TEX-Fußnote nennt Attrition und Zensierung. Das ist korrekt umgesetzt, schränkt aber die Interpretation ein.
4. **`t023_excess_mass.csv` schreibt fehlende Werte in allen Spalten als `--`** (`:482`, `na = "--"`), also auch bei `matched_cutoff_*` für rl1. Das entspricht der Vorgabe des Co-PI (Punkt 2), aber wer die Datei maschinell weiterliest, muss `na.strings = "--"` setzen.

Am Code geprüft und ohne Befund:
- **Variablen:** Die Formeln stimmen am Beispiel Vanke 2016 (Panelzeile 2): rl1 = (tl − adv)/(ta − adv) = 0,7092 und rl1_alt = (tl − adv)/ta = 0,4747.
- **Paarstichprobe:** Sie verlangt beobachtete Vorauszahlungen größer als null (`adv_missing == FALSE` & `adv > 0`), schließt also die mit 0 imputierten Fälle aus. Die Fallzahlen gehen auf: 797 − 86 = 711 und 630 − 31 = 599 (Coverage-Datei, `placebo_definitions.csv`).
- **rl2-Vergleich:** Er nutzt nur Zeilen mit `perp_missing == FALSE`, bei `perp_te` an beiden Stichtagen (`:330-331`).
- **Periodenabgrenzung:** Der Halbjahresindex (`:29-30`) ist korrekt; Folgestichtage werden nur exakt benachbart verknüpft (`:255-256`). Die Abfolge Dez. 2019 → Jun. 2020 ist dokumentiert.
- **Eindeutigkeit:** Die Schlüssel `firm_id`/`date` sind eindeutig, und es kommen nur die Stichtage 30.6. und 31.12. vor (`:24-25`).
- **Excess-Mass-Bins:** Die Fenster werden über die Bin-Mittelpunkte gewählt und stimmen.
  - Post, rl1: Bins [0,68; 0,69) = 38 und [0,69; 0,70) = 40, zusammen 78. Das Fenster [0,66; 0,70) enthält 118 Beobachtungen.
  - Placebo-Fits schließen 4 + 6 = 10 Bins aus, die regulierte Region [0,66; 0,72) ist also tatsächlich entfernt.
  - Beobachtungen außerhalb von [0,40; 1,00] werden ausgewiesen (`n_outside` 84/73).
- **Stichtagsvergleich:** Die Zellen addieren sich zur Gesamtzahl: Juni + Dezember = 391 + 406 = 797 (pre) und 254 + 376 = 630 (post).
- **Bootstrap:** `aggregate_firm` stellt fehlende Firmen explizit wieder her (`:113-119`). Alle Tests ziehen dieselben Firmen-Resamples (`:36`), der Seed ist fest (`:6`).

## Abnahmekriterien

1. **Alle Ausgaben vorhanden, zweimal byte-identisch:** nicht prüfbar (keine Befehle ausgeführt). Alle in der Karte genannten Dateien sind in der eingefrorenen Liste. Der Code setzt einen festen Seed, nutzt relative Pfade und erzeugt Tabellen und Abbildungen nur über Staging. Byte-Identität behauptet nur der Worker (`t023_verification.txt:81-83`); ich habe die Hashes nicht nachgerechnet.
2. **Bestehende Ausgaben byte-identisch:** nicht prüfbar. Das Skript bricht ab, wenn sich die Hashes geschützter Ausgaben oder der Eingaben ändern (`:569-570`). Die Ausgaben von t008–t019 erscheinen in der Liste nach Änderungszeit. Das passt zu einem erneuten Lauf mit identischen Bytes, aber ich habe es nicht verifiziert.
3. **Interpretation im Bericht:** nicht meine Rolle.
4. **T005-Zählungen 36/797 und 78/630:** belegt erfüllt. `t023_placebo_definitions.csv`, Zeilen 2–3, enthält count_below 36 bei n 797 und 78 bei 630. Das Skript prüft das mit einer harten `stopifnot`-Bedingung gegen `t005_bunching_counts.csv` (`:201-208`). Die Bin-Datei bestätigt post 38 + 40 = 78.
5. **Abbruchbedingung bei über 10 % fehlendem rl1_alt/rl2_adj:** belegt erfüllt. `t023_coverage.csv` zeigt 0 fehlende Werte in allen vier Zellen. Bei rl2_adj ist das allerdings nur formal so, weil `perp` mit 0 imputiert wird; darauf reagiert die Beschränkung auf beobachtete Perpetuals.

## Nicht geprüft

- **Reproduzierbarkeit und Hashes:** Laut Rolle führe ich keine Befehle aus; Bash war außerdem gesperrt.
- **Verteilung der Extremwerte von `mi_share`/`jv_ta` im Panel:** Ich habe sie nicht ausgezählt, Befund 1 bleibt deshalb ein Verdacht.
- **`state/LIMITATIONS.md`:** Laut SHA-Prüfung des Skripts hat sich die Datei seit Beginn der Ausführung geändert. Der Worker gibt sie dagegen als byte-identisch an (`t023_verification.txt:110`). Vermutlich wurden D19/D20 vor dem REWORK-Lauf vom Co-PI ergänzt, die Ausgangsstände unterscheiden sich also. Ich kann das nicht zuordnen; der Co-PI sollte es klären.
- **Weitere Änderungen außerhalb des Schreibbereichs:** `replication/.RData`, `replication/.Rhistory` und `privat_R/MTPA_komplett.R` stammen vermutlich aus einer interaktiven R-Sitzung, nicht aus `Rscript run_all.R`. Die Änderungen unter `proposal/` kommen laut Karte aus T026. Beides habe ich nicht weiter geprüft.
- **Regressionen und Inferenz, Textaussagen, LaTeX:** nicht meine Rolle.
