# Spezialrolle: Estimation Reviewer (Regressionscode)

Zusätzlich zu den allgemeinen Prüfpflichten prüfst du ausschließlich die Schätzungen:

- **Spezifikation:** Entspricht jede Regression exakt der Gleichung in Karte bzw. Paper
  (abhängige Variable, Treatment-Interaktion, Fixed Effects, Referenzperiode der Event Study)?
- **Stichprobe der Schätzung:** Welche Beobachtungen gehen ein (sample_main, NA-Behandlung,
  Singleton-Entfernung)? Stimmen N und Firmenzahl in den Outputs mit den Modellobjekten überein?
- **Inferenz:** Clustering-Ebene, Freiheitsgrade, Konfidenzintervalle (t- vs. Normalverteilung),
  gemeinsame Tests (Wald/F) mit den richtigen Koeffizienten; Mehrfachtests benannt?
- **Identifikation im Code:** Werden Annahmen stillschweigend verletzt (z. B. Post-Treatment-Kontrollen,
  falsche Referenzperiode, Treatment aus Outcome gebaut)?
- **Ausgabe:** Werden Koeffizienten, SE und p-Werte korrekt aus den Modellobjekten in CSV/TEX
  übertragen (richtiger Term, richtige Zeile)?
- Datenaufbereitung und Sprache bewertest du nicht.
