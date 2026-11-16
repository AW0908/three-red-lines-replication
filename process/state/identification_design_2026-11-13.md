# Identification design memo — [number withheld] November [number withheld]

Status: proposed analysis plan, not an approved protocol. Prepared at Anton's request after discussion of identification weaknesses. Implementation card: tasks/T077.md (PLAN). No new estimates have been computed for this memo.

## [number withheld]. Problem and intended contribution

The question is whether the introduction of the Three Red Lines changed developers' concentration around the RL1 threshold, relative to unregulated firms in the same listing market. The target is a change in reported-ratio concentration, not economic leverage, hidden debt, regulatory effectiveness, or a causal minority-equity financing response.

T076 supplies an HK comparison but does not remove developer-specific shocks. The current draft reports HK difference-in-bunching [number withheld] [[number withheld]] with only [number withheld] pre-policy developer observations in the target window. T066's A-share firm-level window ATT is [number withheld] [[number withheld]], whereas its density-based counterpart is positive and imprecise. Different estimands, samples and weighting prevent interpreting these as replication of one effect. The new analysis will make the comparison explicit in common units.

Sources: proposal/sections/[number withheld]_empirical_model.tex and [number withheld]_preliminary_analysis.tex; outputs t0[number withheld]_drdid.csv and t0[number withheld]_hk_support.csv. All cited estimates were already known when designing this analysis. This is an outcome-informed extension, not a preregistration of the original study. Existing [number withheld]/[number withheld] placebo choices are also known. Locking this plan before its execution limits further discretion but does not undo that history.

## [number withheld]. Sample and timing

Use the existing main developer panel and existing A/HK control panels without remapping accounting items or downloading data. Markets are analysed separately; no pooled primary claim. Main population: developers and controls with finite RL1 at every one of the original [number withheld] endpoints ([number withheld]H2–[number withheld]H2), with one observation per firm/date. This makes time composition constant, but identifies only a survivor/reporting-complete population. Controls' current-listing selection remains unresolved.

Main pre-period: [number withheld]H1–[number withheld]H2; main post-period: [number withheld]H2–[number withheld]H2. Exclude [number withheld]H1 from estimation as the ambiguous announcement/anticipation period; show it as a descriptive point. Use [number withheld]H2 as the dynamic reference. Show [number withheld]H2 descriptively, outside the main pre-period. Market-specific firm/date counts must be established before estimation. Do not assume previous pooled counts carry over to these balanced samples.

Sensitivity samples: (a) original unbalanced developer sample with the same balanced controls, described as a repeated observed-sample contrast, (b) HK developer/control firms reporting at least one advance-receipt component at every endpoint, using the existing missingness flags. The latter changes both groups, unlike T076's control-only restriction; report the resulting counts and selection. No new imputation. Sensitivities never replace the primary analysis after inspecting results.

## [number withheld]. Outcomes and estimands

For each firm i and date t let R be RL1. Use half-open intervals throughout:

- L = [number withheld]{[number withheld] <= R < [number withheld]}: below-threshold concentration.
- U = [number withheld]{[number withheld] <= R < [number withheld]}: above-threshold concentration.
- S = L + U: concentration around the threshold.
- P6[number withheld] = [number withheld]{[number withheld] <= R < [number withheld]}; P8[number withheld] = [number withheld]{[number withheld] <= R < [number withheld]}.
- Z = L - (P6[number withheld] + P8[number withheld])/[number withheld]: target-window probability relative to two equally wide placebo windows.

PRIMARY: within each market, theta = [mean_post(Z_dev)-mean_pre(Z_dev)] - [mean_post(Z_ctl)-mean_pre(Z_ctl)]. Equal weight per firm and equal weight per date within each period. Express theta and intervals in percentage points. Estimate exactly as a difference of sample means (equivalently a saturated linear contrast); no polynomial density model or fitted bin-count denominator. This is a triple contrast across firm group, time, and ratio region. It is not the old b or an ATT on L.

SECONDARY: corresponding group/time differences for L, U, S and RL1 level; dynamic theta_t relative to [number withheld]H2; separate Z6[number withheld]=L-P6[number withheld] and Z8[number withheld]=L-P8[number withheld] contrasts. The latter expose asymmetry; report both, without selecting the stronger result. Plot full distributions in fixed [number withheld] bins across [[number withheld]] descriptively, using all finite-RL1 firms as the probability denominator and reporting tails. Do not condition the primary sample on being near [number withheld]: the ratio may itself respond to the policy.

## [number withheld]. Identifying assumption and remaining threats

For theta to identify a policy-induced change in Z among the primary developer population, the untreated mean change in Z must have been equal for developers and controls within each market. This is a parallel-trends assumption on a particular transformed outcome. It is weaker than requiring equal changes in every individual window, but is not guaranteed by a smooth density or covariate balance.

Also required: no relevant anticipation in the main pre-period; no policy spillovers changing control Z; consistent ratio measurement and reporting; no confounding developer-specific intervention or shock changing target-relative-to-placebo concentration. The banking concentration policy, developer distress, differential advance-receipt accounting, and survivor selection remain plausible threats. Macro/sector shocks do not automatically cancel: a broad location or scale shift can change local-window probabilities differently near [number withheld] and the placebos. The triple contrast is a diagnostic improvement, not proof of exogenous treatment.

Placebo regions could themselves receive firms displaced by the policy. In that case theta measures redistribution relative to those regions, not an isolated threshold effect. Report L, P6[number withheld] and P8[number withheld] separately. Mass above the line is a model diagnostic; a policy-induced concentration need not validate the previously rejected frictionless notch model.

## [number withheld]. Inference, diagnostics and sensitivity to trends

Seed [number withheld]. Resample whole firms with complete histories independently within each market/group; [number withheld] bootstrap draws. Reuse each draw jointly for all outcomes/dates/contrasts. Report pointwise percentile intervals; report a [number withheld]% simultaneous band across the ten non-reference dates for Z (five pre: [number withheld]H1–[number withheld]H1; five post: [number withheld]H2–[number withheld]H2; [number withheld]H2 is the zero reference). Use max absolute studentized deviations with fixed original bootstrap SEs, and record the valid-draw count. Correct the family definition in machine-readable specifications if a count assertion fails; do not silently change dates.

Primary two-market p-values: Holm adjustment across A/HK, alongside unadjusted inference; bootstrap two-sided p-values from centred draws. Treat secondary outcomes as diagnostic and label pointwise intervals. A joint pre-period test is diagnostic; failure to reject is not evidence establishing parallel trends. Display point estimates, intervals, cell counts and unique firms for each window/date, including zeros. Flag any group/date window cell with fewer than [number withheld] observations as sparse (descriptive warning, not a validated power threshold); no window expansion to remove a warning.

If a verified implementation of Rambachan–Roth is locally available, apply relative-magnitude trend sensitivity to the LINEAR dynamic Z contrasts and their joint firm-level covariance matrix. Target: equal-weight mean of the five post coefficients; five pre coefficients relative to [number withheld]H2. Fixed Mbar grid: [number withheld], [number withheld], [number withheld], [number withheld], [number withheld]. Report robust [number withheld]% intervals and the first grid value including zero; if the zero-deviation interval includes zero, say so. A finite grid gives a bracket, not an exact breakdown value. Mbar bounds post-period deviations from parallel trends relative to the largest pre-period deviation in the counterfactual trend; it does not establish the bound as true.

Do not apply HonestDiD to b or to percentile endpoints. Check coefficient ordering, covariance rank/positive semidefiniteness and sensitivity to numerical tolerances; report package/version and exact arguments. If the dependency is unavailable or the method cannot be validated, mark this component NOT RUN and request a separate dependency/method decision; do not invent a substitute or label it HonestDiD. See Rambachan & Roth ([number withheld]), https://www.jonathandroth.com/assets/files/HonestParallelTrends_Main.pdf. This memo is a plan, not a claim that these conditions currently pass.

## [number withheld]. Interpretation rules fixed before execution

- Report every specified contrast, including null, negative or fragile results. Do not choose market, sample, period, window or estimator by significance.
- A positive theta means a relative concentration change under the stated definition. A causal reading remains conditional on Section [number withheld], even if all checks pass.
- Opposite signs across markets or placebo references must be discussed rather than hidden in a pooled average.
- Wide intervals/weak pre-period support mean the data may not distinguish policy targeting from alternatives. More models cannot manufacture variation.
- None of these estimates identifies debt-like MI, economic leverage, or policy-induced MI growth. Those need linked contractual evidence or a different source of exogenous variation.

## [number withheld]. Decision after execution

Independent estimation review first. Then decide whether the design materially strengthens policy attribution or should remain a falsification/diagnostic exercise. Proposal integration is a separate writing decision; retain old results and explain the new estimand. No retrospective claim that this design was fixed before data collection or before any results were observed.
