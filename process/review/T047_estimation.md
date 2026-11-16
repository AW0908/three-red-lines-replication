## Rolle: estimation (claude, opus) – VERDICT: PASS


## Befunde

Für die Rolle Estimation gibt es keine inhaltlichen Fehler. T047 enthält keine Regression. Ich habe deshalb die Rechenlogik von Zerlegung, Zuordnung, Pooling und Verifikationslabels in `replication/code/18_crossers_coding.R` gegen die Outputs geprüft. Hinweise ohne Rework-Bedarf:

[number withheld]. **Die Zerlegungsidentität ist eine Tautologie.** `residual` wird in Z. [number withheld] als `delta-profit+div-cash` definiert, und die Prüfung in Z. [number withheld]–[number withheld] rechnet genau das zurück. „accounting identities PASS“ belegt also nur, dass die Rechnung intern stimmig ist. Es ist keine unabhängige Bestätigung. Der Bericht (Krit. [number withheld]) und die TeX-Fußnote sagen das ausdrücklich. Es ist korrekt offengelegt.
[firm-specific excerpt withheld in public process copy]
[firm-specific excerpt withheld in public process copy]

## Nachgerechnete Logik (Rolle Estimation)

[firm-specific excerpt withheld in public process copy]
- **Rechenbeispiele:**
[firm-specific excerpt withheld in public process copy]
[firm-specific excerpt withheld in public process copy]
[firm-specific excerpt withheld in public process copy]
- **Vorzeichen:** Dividenden stehen im Ledger positiv und werden im Residuum addiert. Der Dividendenanteil wird mit [number withheld] multipliziert (Z. [number withheld]). Das ist konsistent.
- **Headline:**
  - Alle Ereignisse: Summe der [number withheld] beobachteten Firmenjahre = [number withheld] ✓
  - Neue Ereignisse: nach Abzug der T044-Firmenjahre ([number withheld] [number withheld], [number withheld] [number withheld], [number withheld], [number withheld], [number withheld]) = [number withheld] ✓
  - Quoten: [number withheld]/[number withheld] = [number withheld] % ✓ und [number withheld]/[number withheld] = [number withheld] % ✓
  - Benötigte Firmenjahre [number withheld] bzw. [number withheld] ✓
- **NA-Regel (Rework [number withheld]):** Fehlt das NCI-Kapital, setzt der Code alle `cash_*`-Werte, `cash_attributed` und `cash_not_attributed` auf NA (Z. [number withheld], [number withheld], [number withheld]). Die Pools nutzen `strict_sum` (Z. [number withheld], [number withheld]), und in TeX erscheint „--“ (Z. [number withheld]).
- **Verifikation (Rework [number withheld]):**
  - `cash_not_attributed_verification` verlangt verifiziertes Kapital und eine verifizierte, nicht leere Zuordnung. Außerdem müssen alle Gruppen des Firmenfensters verifiziert sein, einschließlich der Grenzfälle; ist die Liste leer, gilt `unverified` (Z. [number withheld]–[number withheld]).
  - Die vier neuen Gewinnoperanden (L4[number withheld]/L4[number withheld]/L4[number withheld]/L4[number withheld]) stehen auf `unverified` (Ledger Z. [number withheld], [number withheld], [number withheld], [number withheld]).
  - Damit sind auch die Gewinn-, Residual- und Gesamtlabels dieser Firmen unverifiziert.
[firm-specific excerpt withheld in public process copy]
[firm-specific excerpt withheld in public process copy]
- **Kontrollen:** `two_run_checks`, `allocation_checks` und `verification_checks` haben keine FAIL- oder FALSE-Einträge. Die [number withheld] FALSE in `accounting_checks.csv` sind `complete=FALSE`, also erwartbar unvollständige Zeilen ([number withheld] Zeilen, [number withheld] vollständig).

## Abnahmekriterien

[number withheld]. Belege und Stichprobe: nicht meine Rolle (data). Der Code erzwingt Datei, Seite und Auszug je Merkmal und Betrag, und der Auszug muss im PDF stehen (Z. [number withheld]–[number withheld], [number withheld]–[number withheld], [number withheld], [number withheld]).
[number withheld]. Rubrik: belegt erfüllt, soweit Code. Z. [number withheld]–[number withheld] bilden Kategorie und Subtyp nur aus den Merkmalsspalten; bei Abweichung bricht der Lauf ab.
[number withheld]. Byte-Identität geschützter Dateien: nicht meine Rolle.
[number withheld]. Zwei Läufe und Zerlegung: belegt erfüllt. Die Rechenlogik ist korrekt, die Zerlegung geht für die vollständigen Firmen auf, und `two_run_checks` zeigt keinen Fehler. Siehe Befund [number withheld] zur Aussagekraft der Identitätsprüfung.
[number withheld]. Keine unverifizierte Zahl als verifiziert: belegt erfüllt für die Rechenlogik. Die Labels folgen dem PI-Status jeder Zeile (`state()` verlangt alle Operanden verifiziert), und die Headline steht fest auf `unverified`.

## Nicht geprüft

[firm-specific excerpt withheld in public process copy]
- Ob „吸收投资收到的现金“ (Gesamtposten) als NCI-Kapital für die T044-Fenster angemessen ist (Befund [number withheld]). Das betrifft eingefrorene T044-Eingaben.
- PDF-Seiten, TeX-Kompilierung, Rechtschreibung und Konsistenz zwischen Text und Output: andere Rollen. Ausführen konnte ich nichts, da ich nur Lesezugriff habe.
