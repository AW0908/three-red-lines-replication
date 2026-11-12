## Rolle: estimation (claude, opus) – VERDICT: PASS


## Befunde

Für die Rolle Estimation gibt es keine inhaltlichen Fehler. T047 enthält keine Regression. Ich habe deshalb die Rechenlogik von Zerlegung, Zuordnung, Pooling und Verifikationslabels in `replication/code/18_crossers_coding.R` gegen die Outputs geprüft. Hinweise ohne Rework-Bedarf:

1. **Die Zerlegungsidentität ist eine Tautologie.** `residual` wird in Z. 254 als `delta-profit+div-cash` definiert, und die Prüfung in Z. 328–329 rechnet genau das zurück. „accounting identities PASS“ belegt also nur, dass die Rechnung intern stimmig ist. Es ist keine unabhängige Bestätigung. Der Bericht (Krit. 4) und die TeX-Fußnote sagen das ausdrücklich. Es ist korrekt offengelegt.
[firm-specific excerpt withheld in public audit]
[firm-specific excerpt withheld in public audit]

## Nachgerechnete Logik (Rolle Estimation)

[firm-specific excerpt withheld in public audit]
- **Rechenbeispiele:**
[firm-specific excerpt withheld in public audit]
[firm-specific excerpt withheld in public audit]
[firm-specific excerpt withheld in public audit]
- **Vorzeichen:** Dividenden stehen im Ledger positiv und werden im Residuum addiert. Der Dividendenanteil wird mit −1 multipliziert (Z. 311). Das ist konsistent.
- **Headline:**
  - Alle Ereignisse: Summe der 20 beobachteten Firmenjahre = 190,538.4 ✓
  - Neue Ereignisse: nach Abzug der T044-Firmenjahre (600325 2021, 000517 2021, 1966, 1638, 600208) = 129,492.5 ✓
  - Quoten: 415.961/190,538.421 = 0.2183 % ✓ und 415.961/129,492.539 = 0.3212 % ✓
  - Benötigte Firmenjahre 33 bzw. 27 ✓
- **NA-Regel (Rework 1.2):** Fehlt das NCI-Kapital, setzt der Code alle `cash_*`-Werte, `cash_attributed` und `cash_not_attributed` auf NA (Z. 264, 274, 278). Die Pools nutzen `strict_sum` (Z. 12, 305), und in TeX erscheint „--“ (Z. 385).
- **Verifikation (Rework 1.1):**
  - `cash_not_attributed_verification` verlangt verifiziertes Kapital und eine verifizierte, nicht leere Zuordnung. Außerdem müssen alle Gruppen des Firmenfensters verifiziert sein, einschließlich der Grenzfälle; ist die Liste leer, gilt `unverified` (Z. 280–287).
  - Die vier neuen Gewinnoperanden (L402/L405/L408/L411) stehen auf `unverified` (Ledger Z. 108, 118, 134, 146).
  - Damit sind auch die Gewinn-, Residual- und Gesamtlabels dieser Firmen unverifiziert.
[firm-specific excerpt withheld in public audit]
[firm-specific excerpt withheld in public audit]
- **Kontrollen:** `two_run_checks`, `allocation_checks` und `verification_checks` haben keine FAIL- oder FALSE-Einträge. Die 52 FALSE in `accounting_checks.csv` sind `complete=FALSE`, also erwartbar unvollständige Zeilen (92 Zeilen, 40 vollständig).

## Abnahmekriterien

1. Belege und Stichprobe: nicht meine Rolle (data). Der Code erzwingt Datei, Seite und Auszug je Merkmal und Betrag, und der Auszug muss im PDF stehen (Z. 88–94, 112–140, 183, 187).
2. Rubrik: belegt erfüllt, soweit Code. Z. 76–87 bilden Kategorie und Subtyp nur aus den Merkmalsspalten; bei Abweichung bricht der Lauf ab.
3. Byte-Identität geschützter Dateien: nicht meine Rolle.
4. Zwei Läufe und Zerlegung: belegt erfüllt. Die Rechenlogik ist korrekt, die Zerlegung geht für die vollständigen Firmen auf, und `two_run_checks` zeigt keinen Fehler. Siehe Befund 1 zur Aussagekraft der Identitätsprüfung.
5. Keine unverifizierte Zahl als verifiziert: belegt erfüllt für die Rechenlogik. Die Labels folgen dem PI-Status jeder Zeile (`state()` verlangt alle Operanden verifiziert), und die Headline steht fest auf `unverified`.

## Nicht geprüft

[firm-specific excerpt withheld in public audit]
- Ob „吸收投资收到的现金“ (Gesamtposten) als NCI-Kapital für die T044-Fenster angemessen ist (Befund 3). Das betrifft eingefrorene T044-Eingaben.
- PDF-Seiten, TeX-Kompilierung, Rechtschreibung und Konsistenz zwischen Text und Output: andere Rollen. Ausführen konnte ich nichts, da ich nur Lesezugriff habe.
