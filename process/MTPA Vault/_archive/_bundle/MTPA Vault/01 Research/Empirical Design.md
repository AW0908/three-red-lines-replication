---
tags: [mtpa, research, methods]
status: in-progress
updated: 2026-10-14
---
# Empirical Design

Back to [[[number withheld] Home]] · [[Research Question]] · [[Three Red Lines Policy]] · [[Identification Threats]] · [[Variables and Metrics]]

> [!info] Status
> Planned design as of 2026-10-14 (`PROJEKT_STAND.md` §[number withheld]). Nothing estimated yet. Data panel: [[T004 Firm Panel and Red-Line Metrics]]; first descriptives and bunching plots: [[T005 Descriptives and Bunching Plots]]. Design choices are the PI's; equations below translate the plan into notation.

[fenced excerpt withheld in public process copy]
[fenced excerpt withheld in public process copy]

## [number withheld]. Bunching at the thresholds

- Compare the distribution of each of the three ratios in **[number withheld]–[number withheld]** with **[number withheld]H2–[number withheld]**.
- Question: do firms cluster just below [number withheld] % (line [number withheld]), just below [number withheld] % (line [number withheld]) and just above [number withheld] (line [number withheld]) after the policy?
- Excess mass following Kleven ([number withheld]) → [[Kleven [number withheld] Bunching]].

Notation (generic Kleven-type estimator; check against the paper before writing it into the proposal): bin the ratio into bins $j$ with counts $c_j$; fit a polynomial counterfactual $\hat c_j$ to the bins outside an excluded window around the threshold $z^*$; excess mass on the compliant side of $z^*$ (below [number withheld] % / [number withheld] %, above [number withheld]):

$$\hat B = \sum_{j \in \text{compliant side of window}} \left(c_j - \hat c_j\right), \qquad \hat b = \frac{\hat B}{\bar{\hat c}}$$

where $\bar{\hat c}$ is the average counterfactual count per bin in the excluded window.

> [!idea] Suggestion (not decided)
> - With ≈[number withheld]–[number withheld] firms, per-period histograms will be thin. Consider pooling half-years within each period and using the pre-policy distribution ([number withheld]–[number withheld]) as an empirical counterfactual (difference-in-bunching) rather than only a polynomial fit.
> - Bin width, polynomial order and excluded window should be fixed in advance and varied as robustness.
> - Show the three ratios also jointly (e.g. share of firms within ±[number withheld] pp of any threshold) to gain power.

## [number withheld]. Dose-response difference-in-differences

- **Treatment intensity:** number of lines breached **before** the policy, $\text{Lines}_i \in \{[number withheld]\}$, measured at **[number withheld]** or **[number withheld]** (choice open).
- **Fixed effects:** firm and half-year. **Clustering:** firm level.

$$Y_{it} = \alpha_i + \lambda_t + \beta \,\big(\text{Lines}_i \times \text{Post}_t\big) + \varepsilon_{it}$$

with $\alpha_i$ firm FE, $\lambda_t$ half-year FE, $\text{Post}_t = [number withheld]$ for half-years after the policy (August [number withheld]), SEs clustered by firm.

### Outcomes

| Outcome | Chinese term | Intuition |
|---|---|---|
| Minority equity share = minority equity / total equity | 少数股东权益 / 总权益 | Off-balance JVs and disguised equity show up as minority equity |
| Gap: minority share of equity − minority share of profit | 明股实债 indicator | Equity holders who receive little profit are likely debt-like (明股实债 = debt disguised as equity) |
| JV/associate investments / total assets | 长期股权投资 (long-term equity investments) | Shifting projects into non-consolidated JVs |
| Perpetual bonds classified as equity | 永续债 (A-share) / 永久资本证券 (HK, perpetual capital securities) | Debt-like instruments counted as equity |
| Reported leverage | the three red-line ratios | Did reported metrics improve? |
| Supplementary: inventory, land purchases, revenue | 存货, 拿地, 营业收入 | Real adjustment margins |

Field mapping and coverage: [[Variables and Metrics]], [[Field Coverage]].

> [!idea] Suggestion (not decided)
> - Categorical alternative: replace $\text{Lines}_i$ by category dummies (yellow/orange/red vs. green) to avoid imposing linearity in the dose.
> - Report the main specification with and without the delisted firms ([[Delisted Developers]]) to show survivorship sensitivity.
> - Any control variables must be pre-determined (measured before [number withheld]) to avoid bad-control problems.

## [number withheld]. Adjusted leverage

Add back joint-venture debt proportionally (or proxy via minority equity / perpetual bonds) and compare with **reported** leverage. The gap between the two over time is the core "real vs. cosmetic" measure.

> [!idea] Suggestion (not decided) – one possible formalisation
> $$\text{Lev}^{adj}_{it} = \frac{L_{it} - AR_{it} + \hat D^{JV}_{it} + PB_{it}}{TA_{it} + \hat D^{JV}_{it}}$$
> where $L$ = total liabilities, $AR$ = advance receipts (预收款项 + 合同负债), $\hat D^{JV}$ = estimated proportional JV debt (or a proxy), $PB$ = perpetual bonds reclassified from equity to debt, $TA$ = total assets. Then estimate the DiD on $\text{Lev}^{adj} - \text{Lev}^{reported}$. JV debt is not directly observed in the AKShare fields, so the proxy route is likely needed.

## [number withheld]. Modern DiD methods (course week [number withheld])

The course covers "DID: Basics and recent advances" in **week [number withheld] ([number withheld] Nov [number withheld])** – see [[Course Overview]]. Planned: DiD with continuous / multi-valued treatment and **event-study plots**.

Event-study version:

$$Y_{it} = \alpha_i + \lambda_t + \sum_{k \neq k_0} \beta_k \,\big(\text{Lines}_i \times \mathbb{[number withheld]}[t = k]\big) + \varepsilon_{it}$$

with $k_0$ the reference half-year (e.g. [number withheld]H1 – not decided). Pre-period $\beta_k$ test for parallel trends / anticipation; post-period $\beta_k$ trace dynamics.

> [!idea] Suggestion (not decided)
> - Treatment timing is common (all firms exposed from [number withheld]H2), so staggered-adoption corrections are less central; the relevant recent literature is DiD with **continuous/multi-valued doses** (heterogeneous effects across dose levels, "parallel trends in each dose"). Check which estimators week [number withheld] covers before choosing.
> - Plot event studies separately by category and by SOE/private.

Source: `PROJEKT_STAND.md` §[number withheld], §[number withheld], §[number withheld]; syllabus `MTPA_Syllabus_Autumn26-27.pdf` (course schedule, week [number withheld] = [number withheld]/[number withheld]/[number withheld] "DID: Basics and recent advances"); Kleven ([number withheld]) – see [[Kleven [number withheld] Bunching]].
