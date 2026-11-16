---
tags: [mtpa, research, methods]
status: open
updated: 2026-10-14
---
# Identification Threats

Back to [[[number withheld] Home]] · [[Empirical Design]] · [[Research Question]] · [[Three Red Lines Policy]]

The project state lists the following threats that must be addressed openly in the proposal (`PROJEKT_STAND.md` §[number withheld]). Mitigations below are agent suggestions, not decisions.

## COVID-[number withheld] in the same period
**Why it matters:** the policy (Aug [number withheld]) coincides with the pandemic shock and its policy responses. Any change in leverage, sales or financing after [number withheld] could reflect COVID rather than the red lines.
> [!idea] Suggestion (not decided)
> The dose-response design differences out common shocks via half-year FE; the threat is that COVID hit high- and low-dose firms differently. Show pre-trends through [number withheld]H1 (COVID already present, policy not yet), and control for pre-determined exposure (e.g. pre-[number withheld] regional sales mix, if obtainable).

## "Two red lines" for banks (Dec [number withheld])
**Why it matters:** concentration limits on banks' property lending from December [number withheld] restricted credit supply to all developers shortly after the three red lines – a confounding policy in the post period.
> [!idea] Suggestion (not decided)
> Argue it is a supply-side shock common to all developers (absorbed by time FE) unless banks rationed high-leverage developers more; discuss explicitly and, if possible, separate [number withheld]H2 (before bank rule) from later periods in the event study.

## Anticipation
**Why it matters:** the policy was reported before it was formalised, so firms may have adjusted before the "Post" date, biasing the DiD toward zero and contaminating the pre-period of the bunching comparison.
> [!idea] Suggestion (not decided)
> Measure treatment at [number withheld] rather than [number withheld]; inspect event-study coefficients for [number withheld]H1; run bunching with [number withheld]H1 excluded.

## Selection near the thresholds
**Why it matters:** firms close to the thresholds are not there randomly; high-dose firms differ systematically (growth strategy, ownership, size). Mean reversion of extreme ratios can also mimic a treatment effect.
> [!idea] Suggestion (not decided)
> Firm FE absorb level differences; add pre-determined characteristics × Post interactions; check whether ratios already converged pre-policy (placebo "policy" dates in [number withheld]).

## Survivorship
**Why it matters:** developers that failed were delisted; the EastMoney board contains only currently listed firms. Dropping them would remove the most distressed (and plausibly most window-dressing) firms.
**Current handling:** delisted developers identified via Wind ([number withheld] firms, [number withheld] listed on [number withheld]) – see [[Delisted Developers]], [[Wind Terminal]].
> [!idea] Suggestion (not decided)
> Report results with and without delisted firms; treat exit itself as an outcome.

## Small sample (≈[number withheld]–[number withheld] firms)
**Why it matters:** low power for DiD and thin histograms for bunching; clustered SEs with few clusters may be unreliable.
> [!idea] Suggestion (not decided)
> Wild cluster bootstrap for inference; pool periods for bunching; pre-specify a small set of primary outcomes to limit multiple testing.

## SOE vs. private heterogeneity
**Why it matters:** central heterogeneity dimension – [[Shi Hao Xie Kim [number withheld]]] find spread/default effects only for private developers. Pooling may mask opposite effects. Ownership type is not yet in the data (Wind indicator still to be found, see [[Wind Visit [number withheld] Checklist]]).
> [!idea] Suggestion (not decided)
> Pre-register the SOE × dose interaction as a main heterogeneity test.

## Other rule changes in the window (suggested addition)
> [!idea] Suggestion (not decided)
> Not listed in `PROJEKT_STAND.md` §[number withheld] as a threat, but relevant: M&A loans excluded from the ratios since Dec [number withheld] and easing from early [number withheld] ([[Three Red Lines Policy]]). The Dec [number withheld] change alters measured ratios mechanically within the sample (to [number withheld]H2); consider ending the main window at [number withheld]H2 as a robustness check.

Source: `PROJEKT_STAND.md` §[number withheld], §[number withheld], §[number withheld], §[number withheld].
