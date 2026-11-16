## Rolle: estimation (declared=claude, effective=claude, medium, Modell=opus) – VERDICT: PASS


## Befunde

Ich habe keinen Rechen- oder Spezifikationsfehler gefunden. Die folgenden Punkte betreffen Interpretation und Offenlegung. Sie sollten beim Einsatz im Paper beachtet werden. Schwerster Punkt zuerst.

[number withheld]. **Indikator [number withheld] misst nur den ausgewiesenen Zinsaufwand. Die Richtung des Vergleichs ist deshalb nicht belastbar.** `FE_INTEREST_EXPENSE` enthält keine kapitalisierten Zinsen (`32_red_flags.R:69–93`, `t090_interest_source_check.csv`). Beispiel Vanke [number withheld]H2: [number withheld] Mrd. Zinsaufwand bei durchschnittlich [number withheld] Mrd. verzinslicher Schuld ergeben [number withheld] % p. a.
   - Die Gruppe MI_dependent besteht überwiegend aus großen Entwicklern. Sie liegt systematisch niedriger: Post-Median [number withheld] % gegenüber [number withheld] %, Differenz [number withheld] [[number withheld]; [number withheld]]. Ihr Flag-Anteil ist pre und post [number withheld].
   - Das ist eher ein Artefakt der Kapitalisierungspraxis als ein Befund. Die Karte erlaubt die Variante („where reported“), und der Worker legt die Einschränkung offen (`t090_methods.md`, `t090_feasibility.md`).
   - Der Kontrast sollte im Paper nicht als „niedrigere Finanzierungskosten“ gelesen werden. Ob die Variante verwendet wird, entscheidet der PI.

[firm-specific excerpt withheld in public process copy]
   - Folge: Für A pre ist `payout_profit` nur für [number withheld]/[number withheld] (MI_dependent, [number withheld] Firmen), [number withheld]/[number withheld] (other_compliant) und [number withheld]/[number withheld] (noncompliant) Beobachtungen messbar (`t090_cutoffs.csv`, Zeilen [number withheld]–[number withheld]).
   - Beobachtet werden also nur Firmen, die die Unterzeile separat ausweisen. `t090_methods.md` nennt die geerbte Regel, aber nicht diesen Abdeckungseinbruch. Die Ns sind in den Tabellen sichtbar. Empfehlung: einen Satz in die Grenzen aufnehmen.

[number withheld]. **Die Inferenz ist bei wenigen Clustern schwach, und einige Intervalle sind entartet.**
   - In den MI_dependent-Zellen gibt es nur [number withheld]–[number withheld] Firmen. Perzentil-Intervalle aus einem Firmen-Bootstrap haben bei so wenigen Clustern unsichere Überdeckung.
   - Wo der Punktanteil [number withheld] ist (`flag_interest`, MI_dependent, pre/post), liefert das Perzentilverfahren mechanisch [[number withheld], [number withheld]]. Das zeigt keine Präzision an.
   - In der Zelle HK pre MI_dependent fehlen [number withheld] von [number withheld] Ziehungen. Das Intervall ist dort bedingt auf nicht-leere Ziehungen, und das ist offengelegt.
   - Es gibt [number withheld] punktweise Kontraste ohne Mehrfachtestkorrektur. Das ist offengelegt, aber einzelne Intervalle ohne die Null (HK-Gap, A-post-Zins, A-post `unexplained_mi_bn`) sind vor diesem Hintergrund zu lesen.

[number withheld]. **Für [number withheld]H1/H2 gibt es nur [number withheld] Peers beim Zins-Grenzwert** (`t090_peer_thresholds.csv`, Zeilen [number withheld]–[number withheld]). Das [number withheld]. Perzentil nach Typ [number withheld] aus [number withheld] Werten markiert mechanisch genau den Höchstwert. Betroffen ist das Pre-Fenster mit 2017-12-31. Es gilt keine Mindest-N-Regel; die Peer-Ns sind offengelegt. Die Wirkung ist gering, höchstens [number withheld] Flag je Datum.

[number withheld]. **Indikator [number withheld] zieht die Minderheitsausschüttungen nicht ab.** Das entspricht dem Kartenwortlaut. Der Residualwert ist dadurch um die Ausschüttungen nach unten verzerrt, und das [number withheld]-%-Flag wird seltener ausgelöst.
   - Die negativen MI_dependent-Mediane (post [number withheld] Mrd.) spiegeln teils Ausschüttungen, nicht nur Konsolidierung. Bei Vanke [number withheld]H2 machen die Ausschüttungen [number withheld] Mrd. von [number withheld] Mrd. aus.
   - Das ist in `t090_methods.md` offengelegt („does not subtract payouts by design“). Für die Interpretation ist es zu beachten.

**Unabhängige Nachrechnung** (von Hand aus `t090_indicator_panel.csv`, Vanke 2022-12-31): Alle Werte stimmen auf alle angezeigten Stellen.
- Gruppe: official [number withheld] ≤ [number withheld]; frozen = [number withheld] / ([number withheld] + [number withheld] − [number withheld] + [number withheld]) = [number withheld] > [number withheld], also MI_dependent.
- gap_pp = [number withheld] × ([number withheld] − [number withheld]) = [number withheld].
- payout_profit = [number withheld] / [number withheld] = [number withheld].
- payout_lag_mi = [number withheld] × [number withheld] / [number withheld] = [number withheld].
- unexplained = [number withheld] − [number withheld] − [number withheld] = [number withheld] Mrd.; fraction = [number withheld].
- rate = [number withheld] × [number withheld] / [number withheld] = [number withheld].

[firm-specific excerpt withheld in public process copy]

**Offenlegung:** Ich bin Claude (Opus), der Worker war Codex. Das ist Prozessunabhängigkeit, keine volle Modellunabhängigkeit; korrelierte Fehler sind nicht ausgeschlossen. T090 ist deskriptiv und nicht High-Stakes-kausal. Vor der Verwendung im finalen Paper bleibt ein externes Audit eine Option für den PI.

## Abnahmekriterien

[number withheld]. **Definition, Quelle, Einheit, Fehlwertregel, reproduzierbar:** belegt erfüllt (Estimation-Teil).
   - Die Formeln in `t090_definitions.csv` stimmen mit `32_red_flags.R:94–100` überein.
   - Die Annualisierung ist konsistent: Halbjahr × [number withheld] = `[number withheld]*` bei Raten, keine Annualisierung beim Ausschüttungs/Gewinn-Verhältnis und bei der Bestands-Fluss-Identität. Die Vorzeichen sind korrekt.
   - Seed [number withheld] wird vor der einzigen Zufallsquelle gesetzt (Zeile [number withheld]). Relative Pfade.

[number withheld]. **Grenzwerte und Gruppen gemäß Karte:**
   - Grenzwerte belegt erfüllt (`setflags`, Zeilen [number withheld]–[number withheld]: > [number withheld] pp, > [number withheld], > [number withheld], > Peer-p9[number withheld]).
   - Gruppen belegt erfüllt. Die frozen-MI-Definition mit Anker Ende [number withheld] bzw. Ende [number withheld] stimmt (Zeilen [number withheld]–[number withheld]). Die T029-Reproduktion trifft D exakt: pre [number withheld] / post [number withheld] Paare (`t090_t029_reproduction.csv`).
   - Die Zerlegung ist konsistent: [number withheld] − [number withheld] = [number withheld] = [number withheld] × [number withheld].
   - Fehlende Anker werden „unclassified“, nicht „other compliant“.

[number withheld]. **Primärtabelle und Grenzwerttabelle, alle Gruppen, pre/post, Ns, Intervalle, Nullbefunde:** belegt erfüllt, mit den Einschränkungen aus Befund [number withheld]–[number withheld].
   - Es gibt [number withheld] Firmen-Bootstrap-Ziehungen mit ganzen Historien innerhalb des Markts.
   - Die Peer-Grenze wird je Ziehung neu geschätzt. Gemeinsame Ziehungen gelten für die Kontraste.
   - Kontraste und Punktwerte kommen direkt aus `point`/`boot` (Zeilen [number withheld]–[number withheld]), ohne Handübertragung.

[number withheld]. **Validierung gegen t0[number withheld], keine Firma benannt:** belegt erfüllt, soweit meine Rolle betroffen ist. Die rein deskriptive Darstellung ohne Trefferquote ist methodisch angemessen. Ob die Endpunkte richtig verknüpft sind, gehört nicht zu meiner Rolle (Datenprüfung).

[number withheld]. **Bestehende Outputs bytegleich:** nicht meine Rolle.

## Nicht geprüft

- **Bootstrap nicht selbst reproduziert:** In dieser Sitzung stand keine Shell zur Verfügung. Die Bootstrap-Ziehungen (`t0[number withheld]_bootstrap_draws.rds`) habe ich nicht erneut ausgeführt oder eingelesen. Intervalle beurteile ich anhand der Code-Logik und der Worker-Prüfung `t090_bootstrap_verification.csv`; das ist keine unabhängige Verifikation.
- **Nur eine Zeile vollständig nachgerechnet:** Vollständig von Hand nachgerechnet habe ich nur eine Panelzeile (Vanke [number withheld]H2) und eine Gruppenzuordnung. Die übrigen [number withheld] Indikatorzellen stützen sich auf die Code-Lektüre und die Worker-Prüfung.
- **Nicht meine Rolle:** die Semantik der Cash-Flow-Felder und der T088-Nullsetzungsregel (Datenreview), die Integrität und Prüfsummen sowie die Sprache.
