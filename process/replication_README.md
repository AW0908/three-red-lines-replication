# Replication Package

**Meeting the Red Lines: Threshold Targeting and Minority Equity among Chinese Property Developers**

Anton Wilhelmi · Modern Tools for Policy Analysis (Course [number withheld]), School of Economics, Peking University · Autumn [number withheld]

> **Status (2026-11-14): build integration through accepted T076.** T082 updates the build and documentation; acceptance of T082 requires separate reviews and PI approval. The build reads local `Daten/` and `state/` sources and writes only under `replication/` by default. This is the internal project package; a standalone public archive is a separate follow-up. Scripts [number withheld]–[number withheld] and `t078_setup.R` are excluded. T077 is accepted but awaits a separate integration decision. Sections marked **[pending]** need documentation updates; **[unverified]** marks source information not checked against a primary source.

---

## Contents

[number withheld]. [Overview](#number-withheld-overview)
[number withheld]. [Quick start](#number-withheld-quick-start)
[number withheld]. [Folder structure](#number-withheld-folder-structure)
[number withheld]. [Computational requirements](#number-withheld-computational-requirements)
[number withheld]. [Data availability and provenance](#number-withheld-data-availability-and-provenance)
[number withheld]. [Description of the scripts](#number-withheld-description-of-the-scripts)
[number withheld]. [Variable definitions](#number-withheld-variable-definitions)
[number withheld]. [Empirical design](#number-withheld-empirical-design)
[number withheld]. [List of outputs](#number-withheld-list-of-outputs-pending)
[number withheld]. [Reproducibility conventions](#number-withheld-reproducibility-conventions)
[number withheld]. [Known data issues](#number-withheld-known-data-issues)
[number withheld]. [Open decisions](#number-withheld-open-decisions)
[number withheld]. [Use of AI tools](#number-withheld-use-of-ai-tools)
[number withheld]. [Changelog](#number-withheld-changelog)
[number withheld]. [Contact](#number-withheld-contact)

---

## [number withheld]. Overview

### Research question

> Did China's Three Red Lines lead property developers to manage their reported leverage toward the regulatory thresholds, and did developers that moved below a threshold get there by reducing debt or by expanding equity, in particular equity from minority partners that need not lower economic leverage?

PI question fixed on [number withheld] October [number withheld] (`../state/STATE.md`); title fixed on [number withheld] October. The question concerns the form of reported adjustment. Minority-interest counterfactuals are mechanical accounting exercises, not estimates of hidden debt or causal policy effects.

In August [number withheld] the People's Bank of China (PBoC) and the Ministry of Housing and Urban-Rural Development
(MOHURD) introduced three balance-sheet thresholds for property developers (三道红线). Firms breaching
more thresholds face tighter caps on the annual growth of their interest-bearing debt. The thresholds apply to
the **consolidated** balance sheet, which creates an incentive to reduce *reported* leverage without reducing
*economic* leverage – for example through off-balance-sheet joint ventures, minority-interest financing that is
economically debt (明股实债), or perpetual bonds classified as equity.

This package contains the panel-building code and the accepted tables and figures. The current full-build limitations and the restricted scope of the latest verification are documented below.

### The three thresholds

| # | Ratio | Threshold breached if |
|---|---|---|
| [number withheld] | (Total liabilities − advance receipts) / (total assets − advance receipts) | > [number withheld] % |
| [number withheld] | Net gearing: (interest-bearing debt − cash) / equity | > [number withheld] % |
| [number withheld] | Cash (excluding restricted cash) / short-term debt | < [number withheld] |

Firms are classified by the number of thresholds breached: green ([number withheld]), yellow ([number withheld]), orange ([number withheld]), red ([number withheld]).
The [number withheld] % debt-growth cap for green firms is documented in secondary sources.
**[unverified]** The caps of [number withheld] % / [number withheld] % / [number withheld] % for yellow / orange / red, the exact start date, and the list of pilot firms
have not yet been checked against a primary source.

### Main sample

- **Unit of observation:** firm × half-year
- **Period:** [number withheld]H2–[number withheld]H2 – [number withheld] reporting dates ([number withheld] June and [number withheld] December)
- **Firms:** Chinese property developers listed in Shanghai/Shenzhen (A-shares) or Hong Kong, **including
  firms delisted after [number withheld] January [number withheld]**, to avoid survivorship bias (many distressed developers were delisted
  after [number withheld])
- **Pre-policy reference date:** [number withheld] Dec [number withheld] (robustness: [number withheld] Jun [number withheld])

---

## [number withheld]. Quick start

### Reproduction status ([number withheld] Nov [number withheld])

**A complete rebuild from the current project does not succeed.** T082 closes the safe build-interface changes and documents the remaining gaps; it does not certify a fully reproducible archive. The full-copy run in `outputs/tables/t082_r4_full_build.log` stopped in step [number withheld] (exit [number withheld]), after [number withheld] successful steps. `t082_r4_findings.md`, `t082_r4_difference_causes.csv` and `t082_r4_T047_integrity_probe.csv` retain the evidence. Thirteen processed-data files were byte-identical; [number withheld] existing output files differed. These differences were not accepted as exceptions and no regenerated results were copied into the project.

| Step / source | Cause and affected files (paths relative to `replication/`) | Financial numbers affected? |
|---|---|---|
| [number withheld] / [number withheld]: historical integrity gates | Historical checks refer to `../AGENTS.md`, `../PROJEKT_STAND.md` and `../tasks/T047.md`. The run-[number withheld] copy lacked the indirect `AGENTS.md` input; a separate reconstruction against current project inputs still fails three of [number withheld] step-[number withheld] checks, including the stored task override. Supplying the missing copy alone cannot fix the gate. | No financial input changed; the full build is blocked. Guards and baselines remain unchanged. |
| [number withheld]: font replay | The previous entry points omitted `--embed-proposal-fonts`, and run [number withheld] stopped before reaching relocated [number withheld]. The nine differing PDFs were `outputs/figures/t023_excess_mass_rl1.pdf`, `t027_decomposition_rl1.pdf`, `t029_bunching_frozen.pdf`, `t029_distance_es.pdf`, `t031_grid.pdf`, `t040_constructed_vs_published.pdf`, `t041_bunching_by_date.pdf`, `t041_frozen_horizons.pdf`, `t043_meas_error.pdf` (all in that folder). Both entry points now pass the flag. The native Quartz branch of the unchanged script rewrites five of these; the other four are retained in the targeted test, so their equality does not prove a full regeneration. | Run-[number withheld] differences concern rendering/style. The flag's actual byte comparisons are recorded separately in the final test evidence. |
| [number withheld]: verification inventory | `outputs/tables/t040_verification.txt`: protected-output count changes from [number withheld] to [number withheld]. | No statistical result; inventory changes exceed the earlier narrow exception. |
| [number withheld]: integrity inventory | `outputs/tables/t043_input_output_guards.csv`: expanded output inventory and current STATE/input hashes. | Guard metadata; no result cells changed. |
| [number withheld]: input integrity | `outputs/tables/t044_input_integrity_checks.csv`: current case-note and verification-file hashes differ from historical records; preserved append-only prefixes and permitted PI row metadata pass. | Guard metadata. |
| [number withheld]: later PI verification | `outputs/tables/t044_number_sources.csv`, `t044_pending_statements.csv`, `t044_pilot_coding.csv`, `t044_pilot_coding.tex`, `t044_verification_row_checks.csv` (all in `outputs/tables/`): current verification labels, row checks and removal of now-verified pending entries differ from accepted historical outputs. | No differing numeric cells in equal-length, non-inventory tables; the TEX difference is a verification label. Pending-ledger row counts change. These are still byte differences. |
| [number withheld]: integrity inventory | `outputs/tables/t046_input_output_guards.csv`: expanded inventory, updated verification outputs and current input hashes. | Guard metadata; no financial input changed. |
| [number withheld]: later PI verification | `outputs/audit/T047/component_ledger.csv`, `number_file_filter.csv`, `transaction_groups.csv`, `verification_checks.csv`, `verification_row_checks.csv` (all in that audit folder), plus `outputs/tables/t047_coding.csv`, `t047_magnitude.csv`, `t047_pending_numeric.csv`, `t047_pending_qualitative.csv`, `t047_pending_statements.csv` (all in `outputs/tables/`): verification fields and pending ledgers reflect later PI decisions. | No differing numeric cells in equal-length, non-inventory tables; pending-ledger row counts change. No financial input changed by T082. |

The final T082 verification is limited to four sequential standalone tests in a fresh project copy retaining accepted outputs: `Rscript code/23_drdid.R`, `Rscript code/03_figures.R --embed-proposal-fonts`, `Rscript code/24_figures.R`, `Rscript code/25_hk_control.R`. Integration switches remain unset. The interrupted worker session left complete, internally consistent `outputs/tables/t082_final_check.csv`, `t082_final_summary.json` and four logs. These already record exit codes **[number withheld] / [number withheld] / [number withheld] / [number withheld]**, not four successful tests. Its temporary copy was no longer available when work resumed, preventing direct inspection of the differing PDF bytes. The four tests were therefore repeated once in a fresh copy to complete that diagnosis; the earlier evidence remains unchanged. No new full run was performed, either in the copy or in the project.

**Run [number withheld] failed the then-applicable strict acceptance criteria.** `outputs/tables/t082_r6_check.csv` and `t082_r6_summary.json` record the same exit codes and the same nine differing or new files. Of [number withheld] detected output writes, [number withheld] reproduce existing bytes, seven change existing bytes and two create build-only audit files. All [number withheld] processed-data files remain identical. All [number withheld] proposal and [number withheld] presentation files in the copy, and [number withheld] inventoried protected project files, remain unchanged. The copied sibling inputs were made read-only; the project inventory excludes managed metadata, environments and the PI's concurrent `presentation/slides/` work, as detailed in `t082_r6_findings.md`. The subsequently approved run-[number withheld] correction and its remaining finding are reported below.

| Targeted step | Outcome and limit |
|---|---|
| [number withheld] | Exit [number withheld]; [number withheld] of [number withheld] written files byte-identical. Both differences are audit context, detailed below. Statistical results, bootstrap draws, TEX tables and PDFs are unchanged. |
| [number withheld] with flag | Exit [number withheld]; the native Quartz/Times New Roman branch rewrites five PDFs. They have identical content but different bytes. Four other legacy PDFs are retained without rewriting, so their equality is preservation evidence, not evidence of regeneration. |
| [number withheld], standard mode | Exit [number withheld] at `stopifnot(..., nrow(ar)>[number withheld])` in `code/24_figures.R:451`. Its unrestricted `outputs/figures/f_*.pdf` font-check loop includes the existing T076 `f_hk_control_density.pdf`, for which the step-[number withheld] audit has no row. All [number withheld] files written before this failure match existing bytes; the concluding T072 audit/guard files are not refreshed. `t082_r6_step24_probe.csv` records the offending file. No figure was removed or script changed to avoid the failure. |
| [number withheld], standard mode | Exit [number withheld]; all [number withheld] statistical/TEX/figure outputs byte-identical and all [number withheld] HK raw MANIFEST entries verified. Two additional build-only audit files are new relative to the project. No historical proposal integration was run. |

Run [number withheld] recorded each of the following differences; at that point no byte-identity exception applied:

| File (relative to `replication/`) | Verified cause |
|---|---|
| `outputs/figures/t023_excess_mass_rl1.pdf` | Quartz changes `/CreationDate`, `/ModDate` and trailer `/ID` only; content and embedded fonts identical. |
| `outputs/figures/t027_decomposition_rl1.pdf` | Same three metadata fields only; content and embedded fonts identical. |
| `outputs/figures/t029_bunching_frozen.pdf` | Same three metadata fields only; content and embedded fonts identical. |
| `outputs/figures/t040_constructed_vs_published.pdf` | Same three metadata fields only; content and embedded fonts identical. |
| `outputs/figures/t043_meas_error.pdf` | Same three metadata fields only; content and embedded fonts identical. |
| `outputs/tables/t066_validation.txt` | Only the guard inventory sentence changes: [number withheld] to [number withheld] existing outputs and [number withheld] to [number withheld] raw files. The earlier interrupted-session test counted [number withheld] outputs; the repeated test also inventories additional T082 evidence. No estimate or numerical validation result changes. |
| `outputs/tables/t066_verification.csv` | Inventory expands from [number withheld] to [number withheld] rows: [number withheld] additions, no deletions; four existing input SHA-[number withheld] cells change (`code/23_drdid.R`, `run_all.R`, `run_all.sh`, `README.md`). Every recorded `unchanged` flag is true. This is broader than a script-checksum-only difference. |
| `outputs/tables/t082_hk_build_inputs.csv` | New build-mode inventory: [number withheld] input rows, all recorded hashes verified; no `../proposal/` path. Local HK source/destination entries are intentionally both inventoried by the existing implementation. |
| `outputs/tables/t082_hk_build_reproducibility.csv` | New build-mode record of [number withheld] accepted output hashes; every hash matches both the project reference and rebuilt copy. |

For each of the five differing PDFs, the diagnostic comparison becomes byte-identical after removing only the two date values and trailer ID **in memory**; no PDF was altered or normalized on disk. Decoded drawing/font streams, extracted text, word coordinates and font inventories agree exactly. Paired Poppler renders at [number withheld] dpi have zero differing pixels and the contact sheet was inspected. `outputs/tables/t082_r6_pdf_comparison.csv`, `t082_r6_pdf_metadata.txt`, `t082_r6_pdf_contact.png`, the two `t0[number withheld]_r6_t0[number withheld]_*` diffs and `t082_r6_difference_causes.csv` preserve the checks. Ghostscript is not used by the native branch exercised here. These findings establish unchanged visual/numerical content for the tested files; the PDF bytes themselves remain different. The later PI-approved supplement permits differences confined to those date/ID fields with identical streams, plus the two new HK build logs and the specified T066 script-checksum changes.

**Run [number withheld] (approved supplement [number withheld]): both step [number withheld] and step [number withheld] now exit [number withheld], but an additional guard-file difference prevents an unqualified acceptance claim.** Only step [number withheld]'s font-check path selection was changed: it now checks the figures in its own audit list, in the existing alphabetical order, rather than every `f_*.pdf` in the directory. The HK figure remains present and is checked by step [number withheld]. The private combined script was regenerated from the canonical sources. No estimation, drawing code or other audit logic changed.

The two authorized commands, `Rscript code/24_figures.R` and `Rscript code/25_hk_control.R`, were executed sequentially in a fresh real project copy (`outputs/tables/t082_r7_summary.json`). Step [number withheld] passes all [number withheld] reconstruction gates and writes [number withheld] files: [number withheld] byte-identical files, including all [number withheld] paper PDFs and the font/reconstruction/figure audits, and one differing verification inventory. Step [number withheld] writes [number withheld] byte-identical statistical/TEX/figure outputs and the two expressly permitted new HK build logs. All [number withheld] HK MANIFEST entries match. `t082_r7_check.csv` compares all [number withheld] copied replication files and all [number withheld] sibling files; the [number withheld] proposal and [number withheld] presentation files are byte-unchanged, and no write outside `outputs/` is observed. The standard-mode slide PDFs were rendered in temporary storage. No full build, integration mode or in-project analysis was run.

The additional finding is `outputs/tables/t072_verification.csv`: [number withheld] historical rows become [number withheld] rows ([number withheld] additions, no removals). Six SHA-[number withheld] cells change across three existing rows: `../proposal/references.bib`, `code/23_drdid.R` and `code/24_figures.R`. Each copied input matches the current project input, and all [number withheld] before/after `unchanged` flags are true. This is inventory/input-hash context, with no estimate, financial value or figure change. It is broader than the explicitly permitted exceptions in supplement [number withheld] and is **not** classified as PASS or repaired. The cell-level evidence is `t082_r7_t072_verification_diff.csv`; `t082_r7_t072_inventory_summary.json` and `t082_r7_difference_causes.csv` explain every differing/new file. The three other concluding T072 audits are byte-identical.

The successful run-[number withheld] tests of unchanged steps [number withheld] and [number withheld] are retained rather than repeated; `t082_r7_retained_tests_check.csv` verifies their [number withheld] recorded output hashes and unchanged tested source files. The earlier nine-PDF stream/metadata comparison remains intact; four historical PDFs were preserved rather than regenerated. The broader T066 inventory changes described above remain disclosed. `t082_r7_static_checks.csv` verifies all [number withheld] ordered build steps and their canonical embedded sources; parsed package references and all [number withheld] lockfile versions are checked. `t082_r7_scope_check.csv` and `t082_r7_prior_evidence_check.csv` record the protected project scope and preservation of prior T082 evidence. The README was updated after the test copy was made; tested source hashes are retained separately.

A separate archive card after [number withheld] November must resolve historical guard/input dependencies, reconcile later PI-verification metadata with accepted audit outputs, address reproducible PDF metadata and inventory baselines, and verify the entire pipeline including all figure renders. The step-[number withheld] HK font-check incompatibility is fixed and tested by run [number withheld]; acceptance of the newly exposed T072 guard difference remains a Co-PI/PI decision. `public_release/` remains unchanged. Until the archive work is accepted, the package requires retained reference outputs and must not be described as a verified standalone full rebuild.

Install R and all packages separately using `environment.lock` (recorded R: [number withheld]). This internal build requires the project layout: `replication/` alongside the read-only local `Daten/`, `state/`, `tasks/` inputs and the existing `proposal/figures/toc_nef.tex` and `proposal/references.bib`. External read dependencies are inventoried in `outputs/tables/t082_resume_external_references.csv`. No downloads or package installation are authorized for T082; missing dependencies require stopping. The historical setup script can install missing packages, so verify prerequisites before invoking it.

**RStudio (including Windows):** open `replication.Rproj`, then run in the console:

[fenced excerpt withheld in public process copy]
[fenced excerpt withheld in public process copy]

**Command line (Windows, macOS or Linux):** from the `replication/` folder:

[fenced excerpt withheld in public process copy]
[fenced excerpt withheld in public process copy]

On macOS/Linux, `./run_all.sh` is an alternative. Both entry points stop at the first error
and run each script in a fresh R process, in this order:

| Step | Script | Reads | Writes |
|---|---|---|---|
| [number withheld] | `code/00_setup.R` | `environment.lock` | checks R/packages; installs missing packages |
| [number withheld] | `code/01_clean.R` | `data/raw/` | panel and T004 diagnostic tables |
| [number withheld]b | `code/01b_extend.R` | `data/raw/`, unchanged main panel | separate panel through [number withheld]H2 and T030 coverage/crossing counts |
| [number withheld] | `code/t008_power.R` | processed panel | T008 precision tables |
| [number withheld] | `code/02_estimate.R` | processed panel | T009 estimates and event studies |
| [number withheld] | `code/04_robustness.R` | processed panel, T009 estimates | T011 robustness tables and four event-study figures |
| [number withheld] | `code/05_heterogeneity.R` | processed panel, manual ownership coding | T015 ownership counts, interaction and split-sample tables |
| [number withheld] | `code/06_bunching_tests.R` | processed panel, T005 counts | T023 threshold diagnostics |
| [number withheld] | `code/07_rd.R` | processed panel | T024 supplementary RL1 RD, validity checks, audit tables and four figures |
| [number withheld] | `code/08_decomposition.R` | processed panel | T027 crossing decompositions, bootstrap contrasts and figure |
| [number withheld] | `code/09_selection.R` | processed panel, T009 baseline | T025 attrition, selection comparisons and Lee bounds ([number withheld] firm draws) |
| [number withheld] | `code/10_controls.R` | processed panel, T009 baseline | T028 pre-period control balance, C0--C5 DiD, stability and controlled event studies |
| [number withheld] | `code/11_mechanism.R` | main panel and separate T030 extension | T029 frozen-MI compliance, counterfactual bunching, debt benchmarks, distance event studies and incentive groups |
| [number withheld] | `code/12_q1_robustness.R` | main panel and unchanged T023 reference outputs | T031 support, leave-one-firm-out, sample composition, full [number withheld]-cell density grid, exact-distance reversal and timing |
| [number withheld] | `code/14_core_robustness.R` | unchanged main panel | T041 date-specific bunching, one-per-firm selections, low-flexibility densities and matched-horizon frozen-MI placebos |
| [number withheld] | `code/13_rl1_validation.R` | unchanged main panel and coded firm-published ratios | T040 ratio validation, classification disagreements, perpetual and matched-firm robustness |
| T043 | `code/15_referee2.R` | unchanged main panel, T023/T029 references, T040 matched pairs, pilot windows and NCI cash-flow coding | `t0[number withheld]_*`: all [number withheld] joint post-minus-pre bunching cells; integration constraint with convergence/draw audit; two empirical error distributions, each with raw and zero-centered measurement-error simulations ([number withheld] per variant); descriptive heterogeneity; annual pilot cash backing; own-firm and bin-median MI trend counterfactuals, with [number withheld] firm draws re-estimating bin trends and densities. Six CSV/TeX tables, audit CSVs and one PDF. Standalone: `cd replication && Rscript code/15_referee2.R` from the project root. Integration (PI decision, reworks [number withheld]–[number withheld]): the main result is the textbook Chetty et al. ([number withheld]) fixed point with B_net = observed minus fitted counts over the whole excluded window [[number withheld]) (counts at or above [number withheld] scaled by [number withheld] + B_net/their sum, refit until B_net changes by less than [number withheld], at most [number withheld] iterations; full-grid mass residual zero by an OLS identity, asserted); b_net = B_net / mean fitted count per bin in [[number withheld]) (T023 normalization), with the decomposition of B_net below [number withheld] and in [[number withheld]) and Δb_net from the joint firm bootstrap. The rework-[number withheld] fixed point with B on [[number withheld]) only is a labeled secondary row; the free-scale literal-s and globally normalized searches are retained as labeled boundary cases with their full-grid mass residuals shown in the TeX table. Starting fits, iteration traces, local/full-grid residuals and convergence are audited; no result is forced. Raw and centered error variants share sampled indices; the CSV decomposes mean attenuation into centered attenuation and the mean-shift contrast. Pilot windows use the earliest/latest FY in `reports_needed` and intervening annual flows; printed dash = [number withheld], blanks remain missing, every component keeps its PDF page. HK and pooled cash/MI ratios involving HK are explicitly conditional on unverified panel stocks being RMB; no FX conversion is imputed. Trends require four positive pre-period MI observations; failed own trends use the anchor-RL1-bin median; the common-bin variant uses that median for all firms. Bin medians are recomputed with sampled firm multiplicities. Outcome windows are anchor+[number withheld] through [number withheld] half-years. Placebo anchors 2016-12-31/2017-06-30 lack sufficient history, so their estimates and post-minus-placebo differences remain unavailable. |

`03_figures.R --embed-proposal-fonts` runs after `23_drdid.R` and immediately before `24_figures.R` in both entry points and the generated private script (T082, [number withheld] November). This explicitly selects the historical font replay; the ordinary T005 table-generation branch is not run in this mode. `06_bunching_tests.R` reads the retained T005 counts earlier, so accepted reference outputs must remain present. Scripts [number withheld] and [number withheld] do not consume the legacy PDF targets of [number withheld].

T046: `code/17_cash_backing_all.R` runs before steps [number withheld] and [number withheld] in both build entry points (standalone: `cd replication && Rscript code/17_cash_backing_all.R`). It reads `data/raw/manual/handcollect/nci_cashflow_all.csv`, the main panel and the [number withheld] distinct firm IDs in `state/handcollect/crossers_post.csv`, and writes `t0[number withheld]_*` tables/audits plus `outputs/figures/t046_cash_share.pdf`. It uses complete positive-growth firm-years, annual NCI profit, absolute dividend outflows, verified RMB stocks/flows and December fiscal endpoints; residual = change MI minus profit plus dividends minus capital. Ratios are ratios of sums; [number withheld] whole-firm bootstrap draws (seed [number withheld]) give percentile CIs. Missing components remain missing; printed dashes are zero. The offline extraction helper (`cd replication && python3 code/provenance/extract_nci_cashflow.py`; requires Python [number withheld] and Poppler `pdftotext`) reproduces the canonical input and the required `t046_extraction_sources.csv` / `t046_currency_audit.csv` from the manifest PDFs. FY2[number withheld] supplies [number withheld]/[number withheld]; FY2[number withheld] supplies [number withheld] and supplies [number withheld] only when FY2[number withheld] is missing. Both [number withheld] vintages, every pilot comparison, exclusions, manual values and [number withheld] fixed-seed PI checks are retained separately. Each analysis run rechecks source strings on cited PDF pages. HK panel currency `reported` is resolved only where the signed year-specific MI matches a labelled consolidated balance-sheet line with a printed RMB unit; unresolved years are excluded, including HK [number withheld] growth when the [number withheld] opening stock cannot be verified. These are descriptive results conditional on reporting coverage, currency verification and accounting comparability, without a causal interpretation.

**Runtime and reproducibility:** see `outputs/tables/t024_verification.txt` for measured
run times, exit codes, artifact counts and SHA-[number withheld] comparisons from the prescribed
`cd replication && Rscript run_all.R` runs. The verification record is test evidence and
is not rebuilt by the pipeline. Run times exclude dependency installation and depend on
hardware and software versions. Earlier fresh-copy verification records for T015/T023
remain unchanged.

Rebuild in a working copy retaining the existing reference outputs and historical verification records. Several scripts validate regenerated results against these accepted references; do not delete them. The build regenerates statistical results, while historical development, manuscript-integration and visual-review attestations remain preserved test evidence.
Historical development files are stored separately under `docs/provenance/` (see below).

### Operating systems

Tested on macOS [number withheld] (Apple Silicon) with R [number withheld]. Windows has not been tested by the authors.
On Windows, open `replication.Rproj` in RStudio and run `source("run_all.R")`, or run
`Rscript run_all.R` from `replication/`. R >= [number withheld] with the functions checked by setup is sufficient;
exact R [number withheld] is not required. `environment.lock` records the tested versions.
`run_all.sh` requires Git Bash or WSL on Windows. All build paths are relative to `replication/`;
paths containing spaces are supported by the R entry point.

Generated CSV/TEX files use LF (`\n`) line endings on every operating system. Content guards
ignore carriage returns in CSV/TEX before computing SHA-[number withheld]. The delivered T004 panel hash remains
the reference. Real text content differences stop the build by default.
Protected PDFs must exist after rebuilding and have a non-empty PDF header. Byte differences produce
an informational message and the build continues, retaining existing protected PDFs: R/package versions
can change PDF metadata or rendering, while the numbers remain guarded via CSV/TEX.
For byte comparisons in our macOS checks, set `Sys.setenv(MTPA_GUARDS = "strict_pdf")`
before `source("run_all.R")` (or set `MTPA_GUARDS=strict_pdf` in the shell).
This mode also keeps text guards strict and aborts on protected PDF byte differences.
As an explicit fallback, set `Sys.setenv(MTPA_GUARDS = "warn")` before `source("run_all.R")`
(or set `MTPA_GUARDS=warn` in the shell environment). Guard mismatches then warn and the build
continues, retaining existing protected files; outputs from such a run are not verified as identical.
Restore the default mode with `Sys.unsetenv("MTPA_GUARDS")` before the next run.
PDF existence/header checks apply in every mode, including `warn`.

---

## [number withheld]. Folder structure

[fenced excerpt withheld in public process copy]
[fenced excerpt withheld in public process copy]

`data/raw/` is read-only: the build never modifies it. Tables and figures are generated by scripts;
LaTeX fragments are included with `\input{}` and PDF figures with `\includegraphics{}`.
The T003 item catalogue and fiscal-year flags are embedded in `01_clean.R` with their source hashes;
no audit-table copies are required as raw inputs.


### Provenance files (not rebuilt by run_all)

`code/provenance/` contains `t001_audit_a_shares.py`, `t003_audit_hk.py` and
`t007_r_setup_check.R`. Run these manually from `replication/` only when needed; the Python
audits require pandas. Their inputs and output paths stay inside this package; their outputs go
to `docs/provenance/`. They are excluded from the paper build.

The following twelve historical files were moved unchanged to `docs/provenance/`:

- `t001_a_firms.csv`, `t001_a_field_coverage.csv`
- `t003_hk_firms.csv`, `t003_hk_field_coverage.csv`, `t003_hk_fiscal_year_ends.csv`, `t003_hk_items.csv`
- `t007_r_packages.csv`, `t007_twfe_check.csv`, `t007_twfe_check.tex`, `t007_event_study_check.pdf`
- `t013_ownership_codex.csv`, `wind_nachholliste.csv`

These files document development history and are not read or rebuilt by `run_all.R`/`run_all.sh`.

---

## [number withheld]. Computational requirements

### Software and installation

R >= [number withheld] with the functions checked by setup is sufficient; exact R [number withheld] is not required.
R [number withheld] was used for verification on macOS (Apple Silicon); `environment.lock` records the tested versions.
RStudio is optional. No Python or shell is required for the R build. The build uses
`tools::sha2[number withheld]sum` and PDF `timestamp = FALSE`. Text guards remain strict by default; protected PDF
byte differences are informational. `MTPA_GUARDS=strict_pdf` enables strict PDF byte comparisons
for checks with the tested environment (see "Operating systems").

`code/00_setup.R` reads `environment.lock`, checks R and only the packages in its `used` list, installs missing
required packages from `https://cloud.r-project.org`, and prints installed versus recorded versions.
The mainland China alternative `https://mirrors.ustc.edu.cn/CRAN/` is documented in the setup script.
Installation needs internet access and a writable R package library; rebuilding with all dependencies
already installed is offline. Version differences produce warnings and do not install/downgrade
already available packages. Missing functionality or packages stop the build.

| Package | Recorded version | Purpose |
|---|---|---|
| data.table | [number withheld] | panel cleaning |
| readxl | [number withheld] | Wind workbook import |
| fixest | [number withheld] | fixed-effects estimates and precision checks |
| ggplot2 | [number withheld] | plots |
| scales | [number withheld] | descriptive plot scales |
| modelsummary | [number withheld] | regression tables |
| kableExtra | [number withheld] | LaTeX table styling |
| stats, grDevices, tools | [number withheld] | R-distributed statistics, PDF output and checksums |
| did | [number withheld] | retained in lock; not needed for the build |
| rdrobust | [number withheld] | local polynomial sharp/fuzzy RD and robust bias-corrected inference |
| rddensity | [number withheld] | density discontinuity test and plot |
| lpdensity | [number withheld] | transitive dependency of rddensity for density plots |
| DRDID | [number withheld] | improved doubly robust panel DiD |
| trust | [number withheld] | DR-DiD propensity-score optimizer |
| digest | [number withheld] | source/audit checksums |
| jsonlite | [number withheld] | local coding evidence |
| systemfonts | [number withheld] | installed font lookup |

`HonestDiD` and `CVXR` are pending T078 dependencies in an isolated library; they are not part of this build.

`environment.lock` records versions; it is not a repository snapshot or an automatic version pin.
`did` remains in the lock for provenance; setup does not check or install it.
Setup checks `rdrobust` and `rddensity`; if either is missing, the offline RD build stops
without attempting installation or substituting another package. Install them separately before rebuilding.
The installed `lpdensity` version is also recorded as a transitive dependency.
Exact reproduction was tested with the required installed versions. Windows execution is supported by
`run_all.R`; Windows itself has not been tested here.

### Hardware and acquisition

No special hardware is required for this small firm-half-year panel. Runtime is reported in Section [number withheld].
Raw acquisition is separate from this build: the included exports are read locally, and no EastMoney
or Wind connection is made. Wind data are licensed to the PKU Guanghua terminal and supplied to
the instructor for course replication only; do not redistribute them.

---

## [number withheld]. Data availability and provenance

| Source | Content | Access | Redistribution |
|---|---|---|---|
| EastMoney via AKShare | balance sheets and income statements of currently listed developers (A-share and HK) | free, public API | raw downloads may be shared for replication |
| Wind Financial Terminal | lists of delisted A-share and HK firms; financial statements of delisted developers not covered by EastMoney; ownership type (SOE vs. private) | licensed, PKU Guanghua School of Management terminal | included solely for the course instructor to replicate results; no redistribution beyond the course |
| Company annual reports (cninfo.com.cn, HKEXnews) | restricted cash where not available in the databases **[pending]** | free, public | yes |

### Wind data

Wind exports are licensed (PKU Guanghua terminal) and included solely so that the course instructor
can replicate the results. No redistribution beyond the course is allowed. The included files are listed
under "Raw files" below; the original terminal menu paths for the delisting registers are:

- Delisted A-shares: 内地股票 → 市场类 → 上市状态 → 已摘牌股票
- Delisted HK shares: 香港股票 → 港股市场类 → 已摘牌港股

Wind `.xlsx` exports cannot be read with `openpyxl` (stylesheet error). In Python use
`pd.read_excel(file, engine = "calamine")`; in R `readxl` works. The first row is the header; the last row
(„数据来源：Wind") must be dropped.

### Sample construction from the sources

[number withheld]. **Currently listed developers:** members of the EastMoney industry board 房地产开发 (A-shares) and a
   manually compiled list of HK-listed developers.
[number withheld]. **Delisted developers:** all firms in the Wind delisting lists with Wind industry 房地产管理和开发 and
   delisting date on or after [number withheld] Jan [number withheld], excluding B-shares.
[number withheld]. Main sample: Wind 房地产开发; robustness adds 多元化房地产业务 and 房地产经营公司. Property management (房地产服务) and non-developers are excluded.

### Raw files

All [number withheld] build inputs are included below. `data/raw/MANIFEST.csv` is the machine-readable inventory.
Dates refer to the local download/export or register-creation date: EastMoney and the derived
Wind delisted-firm register, 2026-10-13; Wind financial/ownership workbooks, 2026-10-16.
Original project paths in the manifest document provenance and are never accessed by the build.
Every copy was verified against its original by SHA-[number withheld].
The manual ownership file was finalised on 2026-10-17 and is an unchanged copy of the
author-approved coding. Its `source` field records coding provenance; the build does not
retrieve or reverify the underlying company disclosures.

The Wind workbooks and Wind-derived register are licensed (PKU Guanghua terminal) and included
for the instructor's course replication only, with no further redistribution. This inclusion follows
the author's approval of 2026-10-16.

| File | Original source | Download/export date | Bytes | SHA-[number withheld] |
|---|---|---|---:|---|
| `data/raw/manual/ownership_manual_coding.csv` | `state/ownership_final.csv` | 2026-10-17 | [number withheld] | `c0ed1a3052a46757c163ae402db0e14e60d19d475f652883252e38db418170fe` |
| `data/raw/eastmoney/delisted_hk_balance.csv` | `Daten/akshare_output/delisted_hk_balance.csv` | 2026-10-13 | [number withheld] | `3e589d9ba5c9f572409affac1395445b434eeeeaaa7e9fb52f409158ca648fc0` |
| `data/raw/eastmoney/delisted_hk_income.csv` | `Daten/akshare_output/delisted_hk_income.csv` | 2026-10-13 | [number withheld] | `8ab43841a4336225e935b645d382c6b3a0c72812963609f5aba334917ecfe524` |
| `data/raw/eastmoney/firm_list.csv` | `Daten/akshare_output/firm_list.csv` | 2026-10-13 | [number withheld] | `26a0beb3aac57a30c3bb18619de46f854110aae6a54281886e4ea9e51f99c00c` |
| `data/raw/eastmoney/raw_a_balance.csv` | `Daten/akshare_output/raw_a_balance.csv` | 2026-10-13 | [number withheld] | `b14ecb525391389ed6e60bb99ec984c9feef99b7acba111dfa7b1a3b5b424feb` |
| `data/raw/eastmoney/raw_a_income.csv` | `Daten/akshare_output/raw_a_income.csv` | 2026-10-13 | [number withheld] | `82dab1bc9386f0d2da2c07a2d55d70630ed928c03b2eb74bd92a437633db12b1` |
| `data/raw/eastmoney/raw_hk_balance.csv` | `Daten/akshare_output/raw_hk_balance.csv` | 2026-10-13 | [number withheld] | `864eded01132fbd5b29103c428d14ca96a8fb359399304b002aa479a370fa1da` |
| `data/raw/eastmoney/raw_hk_income.csv` | `Daten/akshare_output/raw_hk_income.csv` | 2026-10-13 | [number withheld] | `ccb7941e284ba277d81b5888de8c1578ab9585d4e557afd3b96f26564146aae0` |
| `data/raw/wind/Sicherung_A_1.xlsx` | `Daten/wind_2[number withheld][number withheld][number withheld]/Sicherung_A_1.xlsx` | 2026-10-16 | [number withheld] | `61bac5ff4bbc8a3576d6a6356deecd6e2ac3d126da5200f10008de9634161489` |
| `data/raw/wind/delistete_immobilienfirmen.csv` | `Daten/delistete_immobilienfirmen.csv` | 2026-10-13 | [number withheld] | `769de6bd6bbcf7cecee79f6d409847b9d6c170ed28d4cbe60b58a1e4f068dbfd` |
| `data/raw/wind/sicherung_HK_1.xlsx` | `Daten/wind_2[number withheld][number withheld][number withheld]/sicherung_HK_1.xlsx` | 2026-10-16 | [number withheld] | `3de46b363d4edfe4a533ff1e963cb27a8273e8b21ea7f509eea8fe2649cab3a8` |
| `data/raw/wind/sicherung_HK_2.xlsx` | `Daten/wind_2[number withheld][number withheld][number withheld]/sicherung_HK_2.xlsx` | 2026-10-16 | [number withheld] | `c76e3bbf1ef6de8b26d2db1a9dd83354a9f6e287fc7abfc61b8a36da0149c2a9` |
| `data/raw/wind/sicherung_HK_3.xlsx` | `Daten/wind_2[number withheld][number withheld][number withheld]/sicherung_HK_3.xlsx` | 2026-10-16 | [number withheld] | `da07cd9119ba0ab0a0f45a09938ecf96f604917d2819a5ac5237294c672d22df` |
| `data/raw/wind/wind_A_delistet_v2.xlsx` | `Daten/wind_2[number withheld][number withheld][number withheld]/wind_A_delistet_v2.xlsx` | 2026-10-16 | [number withheld] | `a488a4bc9991ea5044322a17825c4e1ca712bfd0f82b002b380f62770788a5a0` |
| `data/raw/wind/wind_A_gelistet_eigentum.xlsx` | `Daten/wind_2[number withheld][number withheld][number withheld]/wind_A_gelistet_eigentum.xlsx` | 2026-10-16 | [number withheld] | `eb308d7cfd4ffe4726e8a510bd6fb3ffad58ab26de0587b2f473a39501887fec` |
| `data/raw/wind/wind_HK_delistet_v2.xlsx` | `Daten/wind_2[number withheld][number withheld][number withheld]/wind_HK_delistet_v2.xlsx` | 2026-10-16 | [number withheld] | `6383c9e158b82ca550048a818123416580f993af47bc79b630e6ceef8d0874dc` |

---

## [number withheld]. Description of the scripts

### `01_clean.R` – build the panel **[pending]**

[number withheld]. Read the raw exports (EastMoney wide format for A-shares, long format for HK; Wind exports).
[number withheld]. Keep the [number withheld] reporting dates ([number withheld] Jun / [number withheld] Dec, [number withheld]–[number withheld]).
[number withheld]. Harmonise item names across sources and reporting standards (IFRS [number withheld] renaming of advance receipts).
[number withheld]. Remove B-share duplicates and non-developers.
[number withheld]. Convert HKD to RMB where needed.
[number withheld]. Compute the three red-line ratios, the number of thresholds breached, and the pre-policy treatment intensity.
[number withheld]. Compute the outcome variables (Section [number withheld]).
[number withheld]. Append `owner_class_final`, `soe_final` and `soe_source` by `firm_id`, keeping Wind ownership
   where known and otherwise using `data/raw/manual/ownership_manual_coding.csv`.
   Preserve all [number withheld] previous columns and the historical T004 dictionary/diagnostic outputs.
[number withheld]. Write `data/processed/panel_firm_halfyear.csv` ([number withheld] rows, [number withheld] columns).

### `02_estimate.R` – estimates **[pending]**

Bunching estimates and difference-in-differences regressions (Section [number withheld]); writes regression tables to `outputs/`.

### `03_figures.R` – figures **[pending]**

Distributions of the three ratios before and after the policy (bunching histograms), event-study plots;
writes PDF figures to `outputs/`.

### `05_heterogeneity.R` – ownership heterogeneity (T015)

Runs after `04_robustness.R` in both build entry points. Uses `sample_main` with non-missing
`dose_pre` and `soe_final`; outcome NAs and FE singletons are removed per model. For each of
`rl1`, `rl2`, `rl2_gap`, `mi_share` and `jv_ta`, estimates
`y ~ dose_pre:post + dose_pre:post:soe_final | firm_id + date^soe_final` and the pooled specification
separately for private and SOE firms. Uses one thread, seed [number withheld] and firm-clustered SEs.
The implied SOE effect uses the sum of both interaction coefficients and their full covariance.
The main interaction allows ownership-specific half-year FE; its private and implied SOE
point estimates must equal the respective split estimates within [number withheld], with identical estimation
rows (asserted in code). The SOE-minus-private coefficient and its firm-clustered SE provide the
main heterogeneity test. Joint and split SEs may differ because of their cluster counts and
small-sample corrections. The previous interaction with common half-year FE is retained only
as `robustness_common_time_fe`; panel (c) shows its difference coefficient. No multiple-testing
claims are made.

Writes `outputs/tables/t015_soe_heterogeneity.csv/.tex` ([number withheld] CSV effect rows: [number withheld] unrestricted, [number withheld] split,
[number withheld] restricted robustness; model-specific N,
private/SOE firm counts, SEs and [number withheld]% CIs) and `t015_ownership_counts.csv` (main-sample category
counts, Wind-to-final cross-tab, firm-level source audit and ignored IDs). The only permitted
[firm-specific excerpt withheld in public process copy]
these are reported as "not in panel, ignored". Duplicated or other absent IDs stop the build.
The build also stops if an estimated ownership group has fewer than [number withheld] firms.
`t015_specification_checks.csv` records the ten interaction-versus-split assertions. The TEX
table keeps estimates, SEs and CIs together, inserts spacing only between complete blocks,
and shows only the relevant group count in each split block.

### `06_bunching_tests.R` – descriptive threshold diagnostics (T023)

Runs after `05_heterogeneity.R` in both entry points. Uses the main sample, pre-period
[number withheld]H1–[number withheld]H2 and post-period [number withheld]H2–[number withheld]H2, with no treatment-availability restriction,
winsorisation or tail trimming. Uses seed [number withheld] and [number withheld] common whole-firm resamples;
definitions and periods remain paired within every draw. Available-observation shares retain
out-of-range values in their denominators. It stops before publishing outputs if the placebo
definition is missing for more than [number withheld]% of available regulated-ratio observations in either
period, if the RL1 below-threshold counts differ from T005 ([number withheld]/[number withheld] and [number withheld]/[number withheld]), or if an input
or existing non-T023 output changes during the step.

- **Alternative definitions (descriptive):** full regulated reference cells retain the T005
  sample and counts. RL1 comparisons use only paired observations with observed positive
  advances. Alternative RL1 uses the type-[number withheld] pre-period quantile at the empirical percentile
  of [number withheld] in regulated RL1 in that same paired sample. Width remains [number withheld]. The estimated
  cutoff is fixed across periods and bootstrap draws, so its intervals condition on that cutoff;
  this is a distribution-position comparison, not a test of economic leverage. RL2 versus
  adjusted RL2 uses paired observations with `perp_missing == FALSE`, cutoff [number withheld] and width
  [number withheld]. Missing perpetual items imputed to zero are excluded. N, firms, sample rules and
  missing/imputed item counts are explicit in the CSVs. For the observed-perpetual comparison,
  inference is suppressed unless each period includes at least [number withheld] firms (a conservative
  descriptive-only rule, not a universal validity threshold). Other available contrasts use
  firm bootstrap SEs and percentile [number withheld]% CIs.
- **Reporting dates:** full regulated references and the restricted definition comparisons
  are reported separately for aligned June/December panel dates, both with all firms and
  excluding every row of fiscal-year-flag firms. CSV fields count flagged firms and rows
  and exclusions. Exclusions use the observed panel flags, rather than a hardcoded catalogue
  count; some flagged firms are outside the main sample.
  These are aligned reporting snapshots, not publication dates; date mapping may shift
  actual dates. Both are snapshots, so June/December comparisons cannot establish
  within-year window dressing by themselves.
- **Reversal:** next scheduled half-year strictly above the threshold for origins in the near
  bin, versus controls [[number withheld]) for RL1 and [[number withheld]) for RL2. The latter mirrors the two
  control-bin widths specified for RL1. Period labels refer to the origin: [number withheld]H2 follow-up
  can be [number withheld]H1; [number withheld]H2 is right-censored. Gaps are never bridged. The CSV separates absent
  dates, missing next ratios and follow-up outside the origin period. Shares, near-minus-control
  differences and post-minus-pre near-bin differences have firm-bootstrap CIs.
- **Composition:** destinations in the post-period entering [[number withheld]) from strictly above
  [number withheld] versus staying strictly above [number withheld], at two adjacent dates. The first lag can be [number withheld]H1.
  For each of log debt, cash/assets, minority equity share, perpetuals/equity, JV/assets and
  log assets, compare available changes. Perpetuals/equity requires an observed perpetual item
  at both adjacent dates, removing zero-imputed items; restriction exclusions and remaining
  missing changes are reported separately. Its inference requires at least [number withheld] firms overall
  and at least [number withheld] in each transition group; otherwise means and differences are descriptive
  only, with inference fields missing. Other outcomes retain available changes. Logs require positive levels.
  An intercept-and-entrant OLS gives the difference in means; the firm-cluster sandwich uses
  G/(G−[number withheld]) times (N−[number withheld])/(N−[number withheld]), t inference with G−[number withheld] degrees of freedom. These are selected,
  descriptive transitions. Log changes include HK firms as specified; currency comparability
  within firms remains an assumption and HK currency metadata are unresolved.
- **Excess mass:** polynomial count fits following Kleven ([number withheld], Section [number withheld], equation [number withheld]),
  using all [number withheld] bins (including zeros) over [[number withheld]], final right edge included. The main
  fit is degree [number withheld] excluding [[number withheld]). Four one-at-a-time robustness fits use degree [number withheld],
  degree [number withheld], [[number withheld]), and [[number withheld]). Excess mass always counts only the
  below-cutoff part; the wide variant excludes above-cutoff bins from fitting and reports
  their excess separately. Estimate RL1 both on the full main sample (pre/post N = [number withheld]/[number withheld])
  and on the same observed-positive-advance firm-dates used for alternative RL1
  (N = [number withheld]/[number withheld]); the CSV and TEX explicitly label the samples. Repeat for each of these
  three ratio/sample combinations at the main cutoff and placebo cutoffs [number withheld] and [number withheld]:
  [number withheld] specifications. Every placebo fit excludes both its own window and the regulated
  region [[number withheld]) for RL1, or the analogous [[number withheld]) region for alternative RL1.
  The additional exclusion affects fitting only; placebo mass is counted only in the
  placebo's own below-cutoff window. For excess mass only, round the pre-estimated
  alternative cutoff [number withheld] to the nearest [number withheld] (R rounding, ties to even): [number withheld].
  Its main mass window is therefore exactly [[number withheld]), aligned with the fixed bin grid.
  The definition-share and reporting-date checks retain their unrounded cutoff.
  Alternative-definition fits remain descriptive and condition on the fixed cutoff.
  `b` is total observed minus counterfactual counts in the below-cutoff mass window
  divided by the **mean counterfactual count per mass-window bin**;
  its units are bins. `excess_fraction` instead divides by the total counterfactual in the
  window. Whole-firm resampling replaces the reference's residual bootstrap; each draw
  refits the polynomial. Nonpositive fitted window counts invalidate a draw, without clipping;
  valid/failed draw counts and negative fitted-bin counts are reported. Invalid point
  estimates and their SEs/intervals are missing (printed as `--` in the excess-mass CSV
  and TEX). `bootstrap_valid_share`, `bootstrap_meets_9[number withheld]pct` and `inference_status`
  identify unstable fits. A TEX dagger marks fits with fewer than [number withheld]% valid draws;
  their conditional SEs are unreliable for inference. There are no significance stars.
  There is no integration
  correction or structural elasticity interpretation. Smoothness and polynomial extrapolation
  are assumptions; the prescribed exclusion window need not encompass the entire response.

All tables are descriptive diagnostics. Definition-specific, threshold-local excess mass is
consistent with targeting reported ratios, but genuine adjustment can also target regulatory
thresholds. Alternative RL1 changes the denominator and is not a complete measure of economic
leverage; adjusted RL2 adds back perpetuals but not all off-balance-sheet obligations. Neither
the alternative-definition comparisons nor reversal/composition tests identify cosmetic adjustment
causally. Reversal, reporting snapshots, composition and placebo thresholds of regulated RL1
are the principal diagnostics of targeting; none alone separates real from cosmetic adjustment.
All intervals and p values are pointwise and unadjusted for multiple testing across these
diagnostics and robustness fits. Pre/post excess-mass differences are not formally tested.

Outputs are staged and published only after integrity gates pass. The script writes only
`outputs/tables/t0[number withheld]_*` and `outputs/figures/t0[number withheld]_*`. See the verification record for independent
fresh-copy, repeated-build and byte-comparison evidence.

---

### `07_rd.R` – supplementary regression discontinuity (T024)

Runs after step [number withheld] and before step [number withheld]. One observation per `sample_main` firm, without a
`dose_pre` restriction. Running variable is end-[number withheld] RL1 minus [number withheld]; strictly positive means
breaching side. Outcomes are available-date means over [number withheld]H2–[number withheld]H2 minus end-[number withheld]
RL1, RL2, RL2 gap, minority equity share, JV/assets and log interest-bearing debt. A missing
baseline or an entirely missing post mean drops the firm for that outcome. No imputations,
outlier trimming or extra sample filters. Absolute levels (log debt outcome, log assets balance
check) use A-shares only because HK reporting currencies remain unresolved (D7).
The firm audit records every baseline, post mean, number of post observations and exclusion.

The approved 2026-10-21 amendment makes **fixed h = b = [number withheld]** the primary specification:
local linear, triangular kernel, local quadratic bias correction and nearest-neighbor robust
variance (`nnmatch = [number withheld]`). The CSV/TEX distinguish conventional point estimates from
bias-corrected estimates and robust bias-corrected [number withheld]% CIs. Fuzzy RD instruments the
June-[number withheld] RL1 breach with end-[number withheld] threshold position. It additionally requires June-[number withheld]
RL1 and reports the first-stage jump, robust CI, p-value and squared robust z statistic.
That squared z is a Wald strength diagnostic, not a conventional first-stage F statistic.
Normal-approximation fuzzy CIs are **not weak-instrument robust**. The main TEX table
contains sharp ITT rows only. The separate `t024_rd_fuzzy.tex` contains first-stage
diagnostics and fuzzy estimates, each fuzzy estimate labeled "weak first stage -- CI not
interpretable". CSVs retain every column and flag estimated fuzzy rows in their notes.

Robustness includes MSE-optimal h and b, fixed h = b = [number withheld] and [number withheld], a quadratic fit
with cubic bias correction at h = b = [number withheld], and mean [number withheld]H1–[number withheld]H2 RL1 minus [number withheld]
(at least three dates) at h = b = [number withheld]. Outcomes retain the end-[number withheld] baseline in that last
variant. For each outcome/design/running variable, an MSE-bandwidth gate requires ten firms
on each side. Below ten, report only MSE counts/bandwidths and suppress estimates/inference
for that combination. Four alternative-running variants fail this gate: RL2 gap sharp/fuzzy
([number withheld]/[number withheld] and [number withheld]/[number withheld]), log debt sharp/fuzzy ([number withheld]/[number withheld] and [number withheld]/[number withheld]). The main RL1 MSE fit has few firms
left of the cutoff, n = [number withheld] ([number withheld] right); it is retained only as flagged robustness.
`t024_rd_robustness_note.tex` generates that warning from the MSE model object;
the density-note count is likewise generated and both counts are assertion-guarded.

Baseline RL1 counts within ±[number withheld] are **[number withheld] below / [number withheld] above**, matching the Co-PI.
[firm-specific excerpt withheld in public process copy]
has [number withheld]/[number withheld] after additionally dropping missing June-[number withheld] RL1. Complete and effective
counts, missing outcomes and missing treatment are reported per model. RL2/RL3 graphs
show changes against their own end-[number withheld] ratio minus [number withheld], with no estimates or fitted
RD jump; near ±[number withheld] only [number withheld]/[number withheld] and [number withheld]/[number withheld] firms, respectively, have available changes.
Graph ranges and bin widths are documented on each figure and in the underlying CSVs.

Validity outputs include the robust jackknife `rddensity` test on all [number withheld] end-[number withheld] RL1
observations, all ten complementary exact binomial windows, the [number withheld]H2-to-[number withheld]H2 RL1
change, HK listing, the later-delisted panel register flag, end-[number withheld] log assets (A-shares)
and minority share, and four placebo cutoffs ([number withheld], [number withheld], [number withheld], [number withheld]) for the main
RL1 change at nominal fixed h = b = [number withheld]. Negative placebo cutoffs use only x < [number withheld],
positive cutoffs only x > [number withheld]. Estimation and bias windows are truncated at zero;
effective counts on both sides of each placebo cutoff are reported. The panel does not date delisting: the register flag is a post-treatment diagnostic,
not a predetermined covariate. All tests are reported, with unadjusted p-values and no
significance stars; non-rejection cannot establish validity. In this build the primary density, pre-outcome and covariate CIs include zero.
The corrected [number withheld] placebo cutoff CI narrowly excludes zero (unadjusted p = [number withheld]);
the other three placebo cutoff CIs include zero. This rejection limits the validity
evidence. Four overlapping binomial windows also have p below [number withheld].

These low-powered estimates supplement the bunching and decomposition evidence. Sharp
RD is a local ITT contrast of end-[number withheld] threshold position. Fuzzy RD targets the effect of
mid-[number withheld] breach status for local compliers only with relevance, exclusion and monotonicity;
weak first stages impede that interpretation. Both require continuous potential outcomes,
no precise sorting and no other discontinuity at [number withheld]. Outcomes and missing reporting can
also reflect selection. RL1 is not a complete measure of economic leverage (D2[number withheld]), and the
RL2 gap is often mechanically zero when perpetual items are missing (D1[number withheld]). Wong, Steiner
and Cook ([number withheld]), key `wong2[number withheld]analyzing`, concerns multiple assignment variables; this
analysis is deliberately the approved single-RL1 design, with no joint RL1/RL2/RL3 RD.

Only `outputs/tables/t0[number withheld]_*` and `outputs/figures/t0[number withheld]_*` are written; all artifacts are staged
before publication. The input panel and every non-T024 existing output are hash-guarded.
Verification evidence (two pipeline runs, SHA-[number withheld] manifests, direct estimator comparisons,
TeX compilation and visual inspection) is recorded in `outputs/tables/t024_verification.txt`;
that record is test evidence and is not rebuilt by the pipeline.

### `08_decomposition.R` – accounting decomposition of crossings (T027)

Runs after step [number withheld], using base R and the unchanged
main-sample panel. Destination dates define pre ([number withheld]H1–[number withheld]H2) and post
([number withheld]H2–[number withheld]H2). Adjacent half-years are matched within firms without bridging gaps.
RL1 crossings start at or above [number withheld] and end below it; the post stayer benchmark
starts and remains at or above [number withheld]. Secondary RL2 crossings use [number withheld].

The script checks total equity including minorities against the balance-sheet
identity, by sample and source, including a rival parent-equity hypothesis.
It stops for more than [number withheld] percent identity failures, unsupported inclusion of minorities,
or fewer than [number withheld] post RL1 crossings. RL1 log-odds use the exact identity-implied
ratio N/(N+te), N = tl − adv; rounding differences from stored RL1 are audited.
RL2 is decomposed in levels; its numerator log change and zero-change flag use
net debt (ibd minus cash), and are unavailable unless net debt is positive at both
dates. Available item sums are asserted within [number withheld].
Undefined logs, missing minorities and zero-change item-share denominators stay
missing, with event counts retained and statistic-specific coverage reported.

Full-sample equity is split into minorities and parent equity including unresolved
perpetuals. The separate parent/minority/perpetual split requires perpetual items
observed at both endpoints (D1[number withheld]). A guard stops if any observed-perpetual event
endpoint comes from HK-Wind, where total perpetuals may overlap minority equity.
The figure uses all events, with available-case medians for debt, other liabilities,
parent equity including perpetuals, and minority equity. Each bar reports total N
and firms; the note reports component coverage. It separately marks the median total:
component medians generally do not add to it. All RL1 captions and notes state
change in logit(RL1) = Δln N − Δln te; all components in log-odds units.
Code translates the post-crossing median near [number withheld] using
ΔRL1 ≈ RL1([number withheld] − RL1)·Δlogit; shares remain dimensionless.
Existing stocks are not new cosmetic
adjustment. Minority interests and perpetuals are cosmetic-leaning only under the
theory note's measurement assumptions: debt-like partner equity, and perpetuals
booked as equity.

All summaries are descriptive selected transitions. The seven contrasts use
[number withheld] shared whole-firm bootstrap resamples, seed [number withheld], percentile intervals,
and no significance stars or multiple-testing adjustment. The minority plus perpetual
share is the signed event-level contribution divided by the equity term, summarized
primarily by its median; it can lie outside [[number withheld]]. Invalid draws are counted; intervals
with fewer than [number withheld] percent valid draws are labeled conditional and unreliable.
The pre-period perpetual subsample has only two RL1 crossings from one firm and is
not interpretable as a pre/post comparison; its contrast remains conditional and
unreliable. The added all-events minority equity-change share contrast reports both
median and mean, with [number withheld] post and [number withheld] pre available events, without a perpetual restriction.
Binary-share medians display as -- in TeX; rounded negative zero displays as zero.

RMB debt levels are A-share-only. HK and A within-firm log changes are pooled under
unchanged reporting currency within firms (D7 unresolved). One-at-a-time robustness:
[[number withheld]) RL1 crossing destinations (stayer benchmark unchanged), exclude
fiscal-year-flag firms, [number withheld]/[number withheld]-percent winsorized means within each cell/metric/coverage
sample (type-[number withheld] quantiles, original medians), and two-period endpoints requiring an
available intervening ratio. No additional robustness hypothesis tests.

Outputs in `outputs/tables/`: `t027_identity_checks.txt`, `t027_events.csv`,
`t027_event_audit.csv`, `t027_decomposition_rl1.csv/.tex`,
`t027_decomposition_rl2.csv/.tex`, `t027_tests.csv/.tex`,
`t027_debt_growth.csv` and `t027_robustness.csv`.
Figure: `outputs/figures/t027_decomposition_rl1.pdf`.
The static `t027_verification.txt` records the repeated full-build SHA-[number withheld] checks;
it is verification evidence, not an analysis output. The script guards input and
all non-T027 output hashes.

---

### `10_controls.R` – predetermined controls (T028)

Runs after [number withheld], using the unchanged T009 main sample and all five outcomes.
C0 must reproduce every numeric field in `t009_did_main.csv` within [number withheld] before
controlled estimation proceeds. C1 adds size times post; C2 adds all continuous
controls times post; C3 adds SOE and market categories times post; C4 replaces
these post interactions with date interactions; C5 applies C3 after excluding
firms with any post date having nonpositive equity, minority equity above total
equity, or RL2 above [number withheld], exactly as in T024 (D2[number withheld]). All six specifications are
reported. C5 is selection on post outcomes and is only a sensitivity check.

Financial characteristics are means from [number withheld]H1-[number withheld]H2 requiring at least three
dates: log assets, ROA, cash/assets, inventory/assets and revenue/assets. Both
mapped and actual report dates must be no later than December [number withheld], [number withheld]. This
excludes mapped December-[number withheld] observations whose actual reports are March [number withheld].
EastMoney and Wind income variables remain YTD in the panel, so the approved
December-only fallback uses three actual December annual reports for ROA and
revenue intensity, without mixing six- and twelve-month numerators. A flow
control is dropped if fewer than [number withheld] firms qualify. Observed firm means are
z-scored across baseline firms, then missing values are zero-filled with their
own indicator. Constant or redundant indicator interactions are omitted as
collinear, with retained control df and every requested slope term absent from
the estimated coefficient vector in the CSV, including all-zero missing
indicators. Balance groups use `floor(dose_pre + [number withheld])`, rounding half values
upward as in T005/T012 ([number withheld] / [number withheld] / [number withheld] / [number withheld] firms). Ownership
NA is a separate category; the inherited June-[number withheld] ownership snapshot and
later disclosure coding cannot establish pre-[number withheld] ownership (D9/D1[number withheld]).
Log assets retain the existing currency limitation (D7).

The RL1 and minority-share event studies overlay C0 and the C3 control set
interacted with each date, with June [number withheld] as reference and joint tests of the
seven earlier coefficients. In the event-study outputs and figures, `C3-date`
denotes this flexible date-interaction version; pooled C3 uses controls times
post. Both exposure and the pre-period control means overlap the pre-test
window, so the joint test is not a clean placebo test. Pooled C3 and C4 coefficient changes are reported in
baseline SE units, alongside within R-squared; no stability threshold or Oster
delta is imposed. All models use firm/date FE, firm-clustered SE and the T009
singleton convention. C0--C4 retain identical outcome-specific estimation rows.

For RL1, the larger coefficient magnitude under C2--C4 coincides with a
conditional pre-trend (controls times date: joint pre-test p = [number withheld], below
[number withheld]). It must not be interpreted as a stronger policy effect. C4 uses [number withheld]
slope parameters against [number withheld] clusters ([number withheld] for minority share), and the
controlled event studies use [number withheld] slopes against [number withheld] or [number withheld] clusters. These
counts approach the number of clusters, making CR1 standard errors and joint
tests unreliable. JV/assets C4 has [number withheld] slopes against [number withheld] clusters; its SE is
displayed as `--` in the TEX table. The CSV retains the unmodified model SEs,
intervals, and p-values for audit only in these specifications. No estimates
or estimation samples are changed by the REWORK.

The script checks input and non-T028 output hashes. Repeated full-build evidence
is recorded separately in `../tasks/T028_verification.txt`, outside the rebuilt
outputs directory.

### `11_mechanism.R` – mechanical minority-interest counterfactuals (T029)

Runs last, with seed [number withheld] and [number withheld] shared whole-firm bootstrap draws. The script
first reproduces the T023 main official excess-mass estimate (rounded [number withheld]), and stops
on failure. It requires positive non-advance liabilities and total equity, records
all exclusions, and asserts the frozen-MI identity within [number withheld]. Frozen MI uses the
end-[number withheld] stock; the pre-policy placebo uses end-[number withheld] and [number withheld]H2–[number withheld]H2 destinations.
Main-window and [number withheld]H1–[number withheld]H2 extension results are reported separately. Both inclusion
and `exclude_jump_dates` for known half-year MI jumps above [number withheld]% of current equity
are reported. Only jump dates are excluded; later dates retain the jump in the MI
stock. Unknown jump flags are retained and counted.

The compliance table distinguishes the net share difference `C - C_frozen` from the
conditional failure share among officially compliant observations. It also reports
reverse compliance. The bunching table reports all five T023 polynomial/window fits,
paired official/frozen comparisons, and full-eligible official comparisons with
separate availability counts and shared draws. Nonpositive fitted counts invalidate
a bootstrap draw; failed-draw counts remain visible. Debt benchmarks show cumulative
log debt and debt changes scaled by end-[number withheld] assets for both compliance groups.

Distance bins are fixed at end-[number withheld] (sensitivity: June [number withheld]). Four outcomes use own
end-[number withheld] assets, firm/date effects and firm-clustered SEs, with end-[number withheld] and the far-below
bin as references. Pre-period coefficients and normalization rows are included.
Intervals are pointwise CIs, with no multiple-testing correction. The Part B TeX
note explicitly reports the negative MI coefficients in [number withheld]H2–[number withheld]H1 for the
initially near-above bin: these firms already built MI faster before [number withheld], so
the regression describes differential adjustment rather than a policy effect.
Consecutive-transition component records, pooled summaries, within-firm medians and
leave-one-firm-out minority-contribution medians cover all initially near-above firms,
without selection on crossing. Log-odds components use exact logarithmic-mean factors,
including continuous limits at zero net changes. Scaled item changes retain their
raw accounting signs; equity growth thus has a positive scaled change and a negative
log-odds contribution. No perpetual-specific split or zero imputation is used.

End-[number withheld] RL1-only versus multiple-breach groups require observed RL2/RL3. Their
within-[[number withheld]] unique-firm counts appear first. The [number withheld]-firm gate is then applied
to the firms with finite outcomes actually entering each statistic, separately by
scope, variant and period, in both groups. Contrasts require all contributing cells
to pass. Smaller cells have `inference = "descriptive_small_cell"`, no CI, and `--`
in the TeX. Group D and conditional failure compare post with a [number withheld] anchor against
the [number withheld]-anchor placebo, including group-specific changes and their difference
between groups. The [[number withheld]) share retains its original pre/post comparison.
Missing classifications stay missing.
The value of a relaxed cap need not be greater for RL1-only firms: such a ranking
would be an assumption about financing constraints. The tier-description citation
is `jin2[number withheld]deleveraging` only. All results are mechanical accounting counterfactuals
or descriptive adjustment, not attainable balance sheets, causal policy effects,
or economic leverage. Minority interests may be genuine equity. HK within-firm
changes assume unchanged reporting currency (D7 unresolved).

The script guards both input panels and every non-T029 output by exact SHA-[number withheld].
Full-build summaries, independent acceptance checks and repeated-run hashes are stored
in `outputs/tables/t029_verification.txt`; that verification record is not rebuilt.

## [number withheld]. Variable definitions

Exact item mappings depend on the open decisions in Section [number withheld] and will be fixed in `01_clean.R`.

### Red-line ratios

| Variable | Definition |
|---|---|
| `rl1` | (total liabilities − advance receipts) / (total assets − advance receipts) **[unverified against primary source]** |
| `rl2` | (interest-bearing debt − cash) / total equity |
| `rl3` | (cash − restricted cash) / short-term interest-bearing debt |
| `n_breached` | number of thresholds breached ([number withheld]–[number withheld]) |
| `dose` | `n_breached` at the pre-policy reference date |

Advance receipts = 预收款项 (A-share item `ADVANCE_RECEIVABLES`) plus 合同负债 (`CONTRACT_LIAB`), because
firms switched between the two items after IFRS [number withheld] / CAS [number withheld].

### Final ownership (T015; appended columns [number withheld]–[number withheld])

| Variable | Definition |
|---|---|
| `owner_class_final` | Where Wind `soe` is known: `SOE` for [number withheld], `private` for [number withheld]. Otherwise the approved manual `owner_class`; missing if no coding is available. |
| `soe_final` | Wind `soe` where known, otherwise manual `soe_final` (SOE [number withheld]; private/foreign [number withheld]). `state_no_controller`, `other`, `unknown`, `conflict` remain NA and are excluded from heterogeneity estimation. |
| `soe_source` | `wind` where Wind `soe` is known; otherwise `manual` if a manual record exists (also for NA classifications), else NA. |

The original `soe` and all [number withheld] pre-existing columns are unchanged. Counts use unique firms:
`sample_main` contains [number withheld] SOEs, [number withheld] private/non-SOEs and [number withheld] NA classifications ([number withheld] total).
See `t015_ownership_counts.csv` for exact classes and firm-level provenance. The historical
`t004_variable_dictionary.csv` remains byte-identical; these three definitions extend it here.

### Outcomes (planned)

| Variable | Definition | Interpretation |
|---|---|---|
| `minority_eq_share` | minority equity (少数股东权益) / total equity | financing moved to minority partners |
| `minority_gap` | minority share of equity − minority share of net profit | indicator for disguised debt (明股实债): partners provide equity but receive little profit |
| `jv_invest` | long-term equity investments (长期股权投资) / total assets | activity moved to off-balance-sheet JVs and associates |
| `perp_bonds` | perpetual bonds in equity (永续债 / 永久资本证券) / total equity | debt-like instruments booked as equity |
| `rl1`, `rl2`, `rl3` | reported ratios | reported leverage |
| `adj_leverage` | leverage with JV debt added back pro rata (or proxied by minority equity and perpetual bonds) | economic leverage |
| supplementary | inventory, land purchases, revenue | real activity |

---

## [number withheld]. Empirical design

[number withheld]. **Bunching at the thresholds.** Compare the distribution of each ratio before ([number withheld]–[number withheld]) and after
   ([number withheld]H2–[number withheld]) the policy. Excess mass just below [number withheld] % for RL1, just below [number withheld] % for RL2, and just
   above [number withheld] for RL3 after the policy indicates targeting of the reported ratio (RL3 compliance: ≥ [number withheld]).
   Excess mass estimated following Kleven ([number withheld]).
[number withheld]. **Dose-response difference-in-differences.** Treatment intensity = number of thresholds breached at the
   pre-policy reference date. Firm and half-year fixed effects; standard errors clustered by firm. Event-study
   specification to inspect pre-trends (joint test of the pre-period coefficients).
[number withheld]. **Real vs. reported leverage.** Compare the response of reported ratios with the response of adjusted
   leverage and of the off-balance-sheet indicators.

**Identifying assumption:** absent the policy, outcomes of firms with different pre-policy treatment intensity
would have evolved in parallel. Threats addressed explicitly in the proposal: COVID-[number withheld] in the same period;
the concentration limits for bank property lending introduced in December [number withheld]; anticipation (the policy was
reported before its formal introduction); selection of firms near the thresholds; survivorship (handled by
including delisted firms); small sample; heterogeneity between state-owned and private developers.

---

## [number withheld]. List of outputs **[pending]**

Every table and figure in the proposal, with the script and output file that produce it.

| Exhibit in proposal | Script | Output file |
|---|---|---|
| Table [number withheld]: Summary statistics | `02_estimate.R` | `outputs/…` |
| Table [number withheld]: Descriptive table by pre-policy category | `02_estimate.R` | `outputs/…` |
| Figure [number withheld]: Bunching histograms | `03_figures.R` | `outputs/…` |
| Main pooled DiD (caption/label included) | `02_estimate.R` | `outputs/tables/t009_did_main.tex` |
| Robustness S0–S1[number withheld] | `04_robustness.R` | `outputs/tables/t011_robustness.csv/.tex` |
| Pre-policy MDE: legacy dose and main_dose_pre | `t008_power.R` | `outputs/tables/t008_mde.csv/.tex` |
| Ownership estimates (caption/label included) | `05_heterogeneity.R` | `outputs/tables/t015_soe_heterogeneity.tex` |
| Ownership split-sample coefficients and [number withheld]% CIs | `05_heterogeneity.R` | `outputs/figures/t019_soe_coefficients.pdf` |
| Restricted alternative-definition shares and differences | `06_bunching_tests.R` | `outputs/tables/t023_placebo_definitions.csv/.tex` |
| June/December shares, with/without fiscal-year-flag firms | `06_bunching_tests.R` | `outputs/tables/t023_reporting_dates.csv` |
| Next-date reversal shares and contrasts | `06_bunching_tests.R` | `outputs/tables/t023_reversal.csv/.tex` |
| Descriptive entrant versus stayer changes (perpetuals observed at both dates) | `06_bunching_tests.R` | `outputs/tables/t023_composition.csv` |
| Excess-mass estimates, SEs and specification diagnostics | `06_bunching_tests.R` | `outputs/tables/t023_excess_mass.csv/.tex` |
| Observed and fitted counts for every excess-mass fit | `06_bunching_tests.R` | `outputs/tables/t023_excess_mass_bins.csv` |
| Overlaid RL1 and alternative-RL1 distributions and underlying bins | `06_bunching_tests.R` | `outputs/figures/t023_bunching_rl1_vs_alt.pdf`, `outputs/tables/t023_histogram_bins.csv` |
| Post-period RL1 counts versus main polynomial counterfactual | `06_bunching_tests.R` | `outputs/figures/t023_excess_mass_rl1.pdf` |
| Coverage and imputation exclusions | `06_bunching_tests.R` | `outputs/tables/t023_coverage.csv` |
| Build logs, SHA-[number withheld] manifests and acceptance checks (not rebuilt) | T023 verification | `outputs/tables/t023_verification.txt` |
| Supplementary primary sharp ITT RD (all designs retained in CSV) | `07_rd.R` | `outputs/tables/t024_rd_main.csv/.tex` |
| Separate weak-first-stage diagnostics and labeled fuzzy estimates | `07_rd.R` | `outputs/tables/t024_rd_fuzzy.tex` |
| RD bandwidth, polynomial and alternative-running robustness, generated MSE warning | `07_rd.R` | `outputs/tables/t024_rd_robustness.csv`, `t024_rd_robustness_note.tex` |
| Density, pre-outcome, balance, cutoff and binomial checks | `07_rd.R` | `outputs/tables/t024_rd_validity.csv/.tex` |
| Baseline/window counts and one-row-per-firm input audit | `07_rd.R` | `outputs/tables/t024_sample_counts.csv`, `t024_firm_audit.csv` |
| Graph bins, primary fit coordinates and density grid | `07_rd.R` | `outputs/tables/t024_plot_bins.csv`, `t024_plot_fits.csv`, `t024_density_grid.csv` |
| RL1 binned scatter and local linear fits; RL2/RL3 graphical only | `07_rd.R` | `outputs/figures/t024_rdplot_rl1.pdf`, `t024_rdplot_rl2.pdf`, `t024_rdplot_rl3.pdf` |
| End-[number withheld] RL1 density with pointwise confidence regions | `07_rd.R` | `outputs/figures/t024_density_rl1.pdf` |
| T024 build logs, manifests and acceptance checks (not rebuilt) | T024 verification | `outputs/tables/t024_verification.txt` |
| Baseline, Heckman, IPW and S6 comparison with SEs, CIs and draw counts | `09_selection.R` | `outputs/tables/t025_selection.csv/.tex` |
| Lee binary-dose sensitivity bounds, endpoint intervals and uncertainty envelope | `09_selection.R` | `outputs/tables/t025_lee_bounds.csv/.tex` |
| Attrition by date and rounded dose; baseline and exclusion diagnostics | `09_selection.R` | `outputs/tables/t025_attrition.csv`, `t025_baseline_validation.csv`, `t025_first_stage_diagnostics.csv` |
| Selection risk rows, missing predictors, Lee firm changes and every bootstrap result | `09_selection.R` | `outputs/tables/t025_selection_audit.csv`, `t025_missing_predictors.csv`, `t025_lee_audit.csv`, `t025_bootstrap_draws.csv` |
| T025 repeated fresh-copy build logs, hashes and acceptance checks (not rebuilt) | T025 verification | `outputs/tables/t025_verification.txt` |
| Pre-period balance by rounded exposure, correlations and missing counts | `10_controls.R` | `outputs/tables/t028_balance.csv/.tex` |
| All five outcomes under C0--C5, cluster SEs, counts, within R-squared and df | `10_controls.R` | `outputs/tables/t028_controls_did.csv/.tex` |
| Firm control values, standardization, source flow conventions and baseline checks | `10_controls.R` | `outputs/tables/t028_firm_controls.csv`, `t028_control_summary.csv`, `t028_flow_conventions.csv`, `t028_baseline_validation.csv` |
| C3/C4 coefficient shifts in baseline SE units | `10_controls.R` | `outputs/tables/t028_coefficient_stability.csv` |
| C0 and controlled event-study coefficients and joint pre-trend tests | `10_controls.R` | `outputs/tables/t028_event_study_controls.csv`, `t028_pretrend_controls.csv` |
| Baseline and controlled event-study overlays | `10_controls.R` | `outputs/figures/t028_es_rl1_controls.pdf`, `t028_es_mi_share_controls.pdf` |
| T028 repeated full-build logs, SHA-[number withheld] manifests and acceptance checks (not rebuilt) | T028 verification | `../tasks/T028_verification.txt` |
| Date shares, post/placebo compliance contrasts and counterfactual excess mass | `11_mechanism.R` | `outputs/tables/t029_compliance.csv/.tex`, `t029_counterfactual_bunching.csv/.tex` |
| Debt benchmarks, distance event studies, exact components and incentive groups | `11_mechanism.R` | `outputs/tables/t029_debt_benchmark.csv`, `t029_distance_es.csv`, `t029_distance_components.csv`, `t029_incentive.csv` |
| Pre-policy MI coefficients and per-statistic-gated incentive results with contributing cell counts | `11_mechanism.R` | `outputs/tables/t029_distance_es.tex`, `t029_incentive.tex` |
| Exclusions, accounting checks, definitions, limitations and result summary | `11_mechanism.R` | `outputs/tables/t029_coverage.txt` |
| Compliance shares, official/frozen histogram and four-outcome distance plots | `11_mechanism.R` | `outputs/figures/t029_compliance_shares.pdf`, `t029_bunching_frozen.pdf`, `t029_distance_es.pdf` |
| Full-build summaries, SHA-[number withheld] comparisons and acceptance checks (not rebuilt) | T029 verification | `outputs/tables/t029_verification.txt` |
| Separate panel, frozen firm membership/exposure/ownership, original [number withheld] columns retained | `01b_extend.R` | `data/processed/panel_firm_halfyear_ext.csv` |
| Coverage by date, market and source, plus main-sample RL1 totals | `01b_extend.R` | `outputs/tables/t030_coverage.csv`, `t030_rl1_by_date.csv` |
| Missing [number withheld]H2 reporters by rounded dose and firm-level reasons; all Wind-only firms | `01b_extend.R` | `outputs/tables/t030_attrition_2023_2024.csv`, `t030_missing_firms.csv`, `t030_wind_only_firms.csv` |
| Adjacent-date downward RL1 crossing counts, [number withheld]H1–[number withheld]H2 (no estimates) | `01b_extend.R` | `outputs/tables/t030_crossings_preview.csv` |
| New/changed semantics, HK item-name check and column-level overlap assertions | `01b_extend.R` | `outputs/tables/t030_dictionary_addendum.csv`, `t030_item_mapping_audit.csv`, `t030_overlap_assert.csv` |
| T030 build logs, SHA-[number withheld] manifests and independent checks (not rebuilt) | T030 verification | `outputs/tables/t030_verification.txt` |
| T023 reproduction assertion and unique-firm window support | `12_q1_robustness.R` | `outputs/tables/t031_baseline.csv`, `t031_support.csv` |
| Every eligible firm omission, delta from baseline and five-firm influence ranking | `12_q1_robustness.R` | `outputs/tables/t031_leave_one_out.csv` |
| All three samples, both periods, [number withheld]-draw firm bootstrap CIs and validity | `12_q1_robustness.R` | `outputs/tables/t031_samples.csv/.tex` |
| All [number withheld] indexed grid cells, nominal/realized bin edges, validity and zero-exclusion share | `12_q1_robustness.R` | `outputs/tables/t031_grid.csv`, `outputs/figures/t031_grid.pdf` |
| Fully interacted binned/linear LPM predictions, contrasts, CR1 CIs and coverage | `12_q1_robustness.R` | `outputs/tables/t031_reversal_distance.csv/.tex`, `outputs/figures/t031_reversal_distance.pdf` |
| All three timing windows, bunching and raw/distance-adjusted reversal differences | `12_q1_robustness.R` | `outputs/tables/t031_timing.csv/.tex` |
| Full-build logs, SHA-[number withheld] manifests and acceptance evidence (not rebuilt) | T031 verification | `outputs/tables/t031_verification.txt`, `t031_build_run1.log`, `t031_build_run2.log`, `t031_hashes.csv` |

---

T030 builds a separate [number withheld]-date panel ([number withheld]H2–[number withheld]H2) directly after step [number withheld].
The cleaning block is copied verbatim from `01_clean.R` and asserted equal at runtime;
the original script is never sourced or modified. All [number withheld] historical rows and their
[number withheld] original columns must match the main panel (absolute numeric tolerance [number withheld]).
The firm universe, sample flags, exposure and final ownership remain frozen to the
[number withheld] main-panel firms ([number withheld] main, [number withheld] broad). Four new dates contain all [number withheld] firms,
including explicit `has_row=FALSE` rows; historical missing rows are not added.
On absent rows, financial values and imputation flags are NA and component counts
are zero. The [number withheld] Wind-only firms ([number withheld] in the main sample) lack exports after [number withheld]H2;
their missing extension rows reflect source availability and must not be interpreted
as observed firm attrition. Firm IDs and [number withheld]H2 reporting status are listed in
`t030_wind_only_firms.csv`; other missing reports are identified separately.

Coverage uses the full frozen main-sample denominator at every date. Its `source`
is the actual source when observed, otherwise the firm's historical source class;
the panel's own `source` remains NA on absent rows. A balance-sheet count denotes
an actual source row; total-assets coverage is also reported separately. Attrition
counts condition on an actual balance-sheet row in [number withheld]H2, retain missing `dose_pre`
as a separate group, and use `floor(dose_pre + [number withheld])` as in T005/T012. Crossing counts
use the main sample, require two observed RL1 values at consecutive target dates,
and count transitions from RL1 >= [number withheld] to RL1 < [number withheld] without additional eligibility
filters. `post2` identifies [number withheld]H1–[number withheld]H2 as a separate window; the inherited `post`
is only its original mechanical date indicator. The policy's relaxation after [number withheld]
remains for the PI to verify, so the extension is not labelled "post-policy".

Robustness list: S0 main `dose_pre`; S1 `dose2[number withheld]`; S2 `dose` ([number withheld]H2);
S3 threshold distance; S4 firm-specific trends; S5 within-date [number withheld]/[number withheld]% winsorisation;
S6 balanced panel; S7 broad sample; S8 [number withheld]H1 dose; S9 no missing-advance flag;
S1[number withheld] calendar fiscal years; S1[number withheld] alternative RL1; S1[number withheld] A-shares; S1[number withheld] HK firms;
[firm-specific excerpt withheld in public process copy]
outside `sample_main`, so S1[number withheld] equals S0 for all five outcomes, including N and firms.
The S0–S1[number withheld] results and existing embedded validation assertions are retained.

## [number withheld]. Reproducibility conventions

- **Fixed seed** in every script that uses random numbers: `set.seed([number withheld])`.
- **Relative paths only**; scripts are run from `replication/` via the primary entry point `run_all.R`
  (`run_all.sh` is an alternative).
- **One direction of data flow:** `data/raw/` → `data/processed/` → `outputs/`. No script reads its own outputs
  from a later step.
- **No manual steps** between raw data and outputs. Numbers in the text of the proposal are taken from files
  in `outputs/`; in the LaTeX source each such number carries a comment `% source: outputs/…`.
- **Versions** recorded in `environment.lock`.

---

## [number withheld]. Known data issues

- **Advance receipts** are reported as 预收款项 or as 合同负债 depending on firm and year (IFRS [number withheld] / CAS [number withheld]);
  both are summed for red line [number withheld].
- **Restricted cash** is missing for A-shares in EastMoney; source for red line [number withheld] **[pending]** (Wind or annual reports).
- **Survivorship:** the EastMoney industry board contains only firms listed today; delisted firms come from Wind.
[firm-specific excerpt withheld in public process copy]
  EastMoney returns the *new* firm under the old code (e.g. code [number withheld] returns 国恩科技 instead of 佳源国际);
  these firms are taken from Wind only.
- **B-share duplicates** (e.g. 深物业A / 深物业B) and some non-developers are in the EastMoney board and are removed.
- **Currency:** HK-listed firms report partly in HKD, partly in RMB.
- **Cumulative income statements:** half-year figures are year-to-date (H1 = Jan–Jun; annual = Jan–Dec);
  H2 flows are computed as annual minus H1.
- **Short interim histories** for some HK firms listed after [number withheld].

---

## [number withheld]. Open decisions

Decided by the author on 2026-10-16 (authoritative record: `state/STATE.md`).

| # | Question | Decision |
|---|---|---|
| [number withheld] | Which firms count as developers? Exclude property management (房地产服务)? | Kern 房地产开发; Robustheit + 多元化/经营公司; 房地产服务 und Nicht-Entwickler raus (2026-10-16) |
| [number withheld] | B-shares: drop duplicates, keep the A-share line? | Duplikate raus, A-Zeile behalten (2026-10-16) |
| [number withheld] | HK reporting dates; firms with non-December fiscal year ends | Nächster [number withheld]./[number withheld]., Flag, Robustheit ohne (2026-10-16) |
| [number withheld] | Red line [number withheld]: denominator with or without advance receipts | (L − AR) / (A − AR), AR = 预收+合同负债 [unverified]; Robustheit nur Zähler (2026-10-16) |
| [number withheld] | Definition of interest-bearing debt (loans, bonds, notes, lease liabilities?) | Kern: Kredite + Anleihen + kurzfr. Anteil; Robustheit + Leasing, 应付票据 (2026-10-16) |
| [number withheld] | Restricted cash for A-shares: Wind/annual reports, or total cash as an upper bound | Vorerst gesamte Cash (Obergrenze); Nachtrag aus Geschäftsberichten (2026-10-16) |
| [number withheld] | Pre-policy reference date: [number withheld] Dec [number withheld] or [number withheld] Jun [number withheld] | [number withheld]; Robustheit [number withheld] (2026-10-16) |
| [number withheld] | HKD/RMB conversion: exchange rate and date | PBoC-Mittelkurs zum Stichtag (2026-10-16) |
| [number withheld] | Perpetual bonds in red line [number withheld]: equity or debt | Ausgewiesen: Eigenkapital; bereinigt: Schuld (2026-10-16) |

---

## [number withheld]. Use of AI tools

AI-assisted tools were used for coding, data checks and drafting, in line with the course AI policy. Every use
of substance is recorded with tool, date, purpose, representative task, verification and modifications in
`AI_USAGE_LOG.md` (project root) and summarised in the AI-use appendix of the proposal. All code, numbers
and citations were verified by the author, who is responsible for every claim.

---

## [number withheld]. Changelog

| Date | Change |
|---|---|
| 2026-11-14 | T082 (implementation; not PI acceptance): integrate HK build, explicit publication switches, authenticated price fallback, complete dependency versions and generated private build copy. |
| 2026-11-13 | T076 (PI accepted): Hong Kong control group, part [number withheld] – pre-registered HK difference-in-bunching, integration into proposal text and appendix. |
| 2026-11-13 | T074 (PI accepted): Hong Kong control group, part [number withheld] – roster and download script for HK-listed non-developers (balance sheets [number withheld]H2–[number withheld]H2), pre-registered estimation plan. |
| 2026-11-12 | T073 (PI accepted): Public replication archive (public_release/) – code, non-Wind data, outputs and audit trail, with Wind exclusion and privacy checks. |
| 2026-11-12 | T072 (PI accepted): All proposal figures re-rendered in one consistent style from existing outputs (no re-estimation), redesigned spec curve and crossing decomposition, developer-vs-control by date in the main text, slide versions. |
| 2026-11-09 | T071 (PI accepted): Online Appendix – page layout and table spacing with visual page-by-page check (no content changes). |
| 2026-11-02 | T070 (PI accepted): Online Appendix – all tables at full text width in one consistent format (layout only, no new numbers). |
| 2026-11-09 | T069 (PI accepted): Text integration of T066 (DR-DiD, private vs. state-owned, revised Heckman) and interpretation/credibility points of the ChatGPT report of [number withheld] Nov. |
| 2026-11-12 | T068 (PI accepted): Presentation slides ([number withheld] min, Nov [number withheld]) rebuilt from the current proposal results. |
| 2026-11-02 | T067 (PI accepted): Professor's points ([number withheld] Nov) – Online Appendix: cover page, second table of contents, page numbers A1, A2, …. |
| 2026-11-09 | T066 (PI accepted): Professor's points ([number withheld] Nov) – code: doubly robust DiD with covariate balancing (developers vs. matched unregulated firms), private vs. state-owned developers as comparison. |
| 2026-11-02 | T064 (PI accepted): Referee round [number withheld] ([number withheld] Nov) – text: notch with imprecise control (theory), A-share vs. Hong Kong prominence, supplier-industry control, public filings instead of supervisors, final-paper κ plan, readable introduction, institutional background, table and number fixes, AI appendix. |
| 2026-11-02 | T063 (PI accepted): Referee round [number withheld] ([number withheld] Nov) – code: notch-with-noise simulation calibrated to validation errors, [[number withheld], [number withheld]) co-main window, control without developer-supplier industries, one observation per firm, distributions by half-year, number reconciliation. |
| 2026-11-01 | T062 (PI accepted): Text – difference-in-bunching against an unregulated control group (Sections [number withheld]–[number withheld], Tables [number withheld], [number withheld], [number withheld], abstract, introduction, conclusion, Appendix B); updated κ figure. |
| 2026-11-01 | T061 (PI accepted): Difference-in-bunching, part [number withheld] – build control RL1 panel and estimate developer minus control change in excess mass at [number withheld]; κ figure re-rendered with larger fonts. |
| 2026-10-31 | T060 (PI accepted): Difference-in-bunching, part [number withheld] – fetch script for an unregulated control population (non-property listed firms, same RL1 definition). |
| 2026-10-31 | T059 (PI accepted): Referee round [number withheld] ([number withheld] Oct) – text: exposure-based treatment definition, framing of Finding [number withheld] as a disclosure audit, endogenous κ prediction, symmetric benchmarks, attrition and specification evidence, Liu ([number withheld]) comparison, coincident policies. |
| 2026-10-31 | T058 (PI accepted): Referee round [number withheld] ([number withheld] Oct) – code: policy exposure (pilot developers vs. rollout), notch-intensity test, symmetric freezing benchmarks, balanced-panel and attrition checks for Δb, missing mass above [number withheld], compact specification grid for Δb, accounting-standard transition. |
| 2026-10-31 | T057 (PI accepted): Appendix overhaul – A1/B1 numbering, float layout, readable labels, no internal workflow codes, Table [number withheld] overflow, T055 tables and figure, AI-use appendix per use (A4). |
| 2026-10-30 | T056 (PI accepted): Strict-referee round ([number withheld] Oct) – text: integrate T055, split H2, first person, regulated entity, policy feasibility and side effects, placebo thresholds in the main robustness table, traceability fixes, focal-paper author note, Chetty et al. ([number withheld]). |
| 2026-10-30 | T055 (PI accepted): Strict-referee round ([number withheld] Oct) – code: density-free MI shift, κ-reclassification counterfactual with break-even κ, falsification on the unadjusted liability-to-assets ratio, linear MI trend, pre-trend test table. |
| 2026-10-30 | T054 (PI accepted): Main-text polish towards a top grade – Co-PI's full critical reading of [number withheld] Oct: no duplicate policy description, Section [number withheld] opens with content, theory reconciled with excess above the threshold, Finding [number withheld] trend result in words, consistent terms, intro previews the policy implications. |
| 2026-10-30 | T053 (PI accepted): Conclusion rewritten as a policy conclusion (question, three results, two policy recommendations derived from the findings, transferability, limits, short plan) and two fixes in the introduction from the T052 review. |
| 2026-10-30 | T052 (PI accepted): Economic stakes in the introduction (Rogoff and Yang [number withheld]; Liu and Xiong [number withheld]) and the remaining wording points of the T051 review. |
| 2026-10-30 | T051 (PI accepted): Readability pass after the PI's full reading – introduction with the policy and its incentives, robustness numbers out of the prose into one compact table, warmer Sections [number withheld]–[number withheld], larger Table [number withheld] and Figure [number withheld], fuller conclusion, title page and contents line. |
| 2026-10-30 | T050 (PI accepted): [number withheld]/[number withheld] pass" – put the existing robustness evidence where reviewers look for it: bunching-by-date figure, balanced panel and one-observation-per-firm results, one counterfactual table (frozen vs. trend), identification overview table, result hierarchy; literature tightened to pay for it. |
| 2026-10-30 | T049 (PI accepted): Final polish of the first proposal – probe review [number withheld] (ChatGPT [number withheld]/[number withheld], 2026-10-30), plan for the final paper, compact threats table, sample composition, announcement vs. effective date, slimmer AI appendix, figure and language leftovers. |
| 2026-10-30 | T048 (PI accepted): Theory-of-change figure (NEF framework, Lecture [number withheld]) in Section [number withheld] and the remaining language points of the T045 review. |
| 2026-10-30 | T047 (PI accepted): Pilot extension to all post-policy MI crossers – code the transactions behind minority-interest growth of the remaining firms in crossers_post.csv with the T044 rubric. |
| 2026-10-29 | T046 (PI accepted): Cash backing of minority-interest growth for the full sample – capital contributions from minority shareholders from the FY2[number withheld]/FY2[number withheld] annual reports, [number withheld]–[number withheld]. |
| 2026-10-30 | T045 (PI accepted): Referee round [number withheld] (text) – one revision pass that implements all points of the two probe reviews of 2026-10-28, integrates T043/T044, switches to Times New Roman, and keeps the main text at [number withheld] pages. |
| 2026-10-29 | T044 (PI accepted): Pilot coding of all ten firms – classify the transactions behind minority-interest growth by a fixed rubric and measure which share of the growth carries debt-like terms. |
| 2026-10-29 | T043 (PI accepted): Referee round [number withheld] (code) – direct test of the change in bunching, integration constraint, measurement-error simulation, pre-specified heterogeneity, cash backing of minority-interest growth in the pilot. |
| 2026-10-28 | T042 (PI accepted): Fill the AI-use appendix (proposal/appendix/ai_use.tex) from the documented AI log, cards and approvals. |
| 2026-10-27 | T041 (PI accepted): Robustness of the two core findings – bunching by half-year, one observation per firm, low-flexibility densities, and frozen-MI placebos with matched horizons. |
| 2026-10-28 | T040 (PI accepted): RL1 validation at scale – code firms' own published Three-Red-Lines ratios, compare with our RL1, and re-estimate the key results under the firms' definition. |
| 2026-10-28 | T039 (PI accepted): Final revision of the first proposal – Section [number withheld] around three findings, RL1 validation and robustness, systematic literature search with PRISMA, external feedback, main text ≤ [number withheld] pages, slim appendix. |
| 2026-10-27 | T038 (PI accepted): Language, layout and length pass over the whole proposal and the theory note (first-draft polish). |
| 2026-10-26 | T037 (PI accepted): Write Introduction, Related Literature and Conclusion; final abstract, keywords and JEL codes. |
| 2026-10-26 | T036 (PI accepted): Rewrite Section [number withheld] (preliminary results) around the three levels of evidence; rebuild the results appendix. |
| 2026-10-26 | T035 (PI accepted): Rewrite Sections [number withheld] (framework), [number withheld] (context and data) and [number withheld] (empirical strategy) to the final framing; new section order and title in main.tex. |
| 2026-10-26 | T034 (PI accepted): Revise the theory note to the final framing – title, margins d/e, safety buffer, prediction-to-test table updated to T029/T031. |
| 2026-10-26 | T033 (PI accepted): Hand-collection pilot, part [number withheld] – code the [number withheld] ad-hoc announcements: who supplied the new minority equity, on what terms (with page citations). |
| 2026-10-26 | T032 (PI accepted): Hand-collection pilot – extract minority-interest evidence from [number withheld] annual/interim reports (tables, cash flows, contract terms, published RL1) with page citations. |
| 2026-10-26 | T031 (PI accepted): Robustness of the Q1 targeting evidence – unique-firm support, leave-one-firm-out, balanced sample, sensitivity grid, reversal by exact distance, [number withheld]H2 timing. |
| 2026-10-23 | T030 (PI accepted): Extension panel [number withheld]H1–[number withheld]H2 from the existing EastMoney raw files (main panel unchanged). |
| 2026-10-26 | T029 (PI accepted): Mechanism – counterfactual compliance with minority interests frozen at end-[number withheld], and adjustment by predetermined distance to the threshold (all firms, no selection on crossing). |
| 2026-10-23 | T028 (PI accepted): Pre-determined control variables for the dose DiD and event study (plus equity-problem robustness, D2[number withheld]). |
| 2026-10-21 | T027 (PI accepted): Decomposition of threshold crossings – real (less debt) vs. cosmetic (more partner/perpetual equity) adjustment. |
| 2026-10-20 | T026 (PI accepted): Theory note – a notch model of real vs cosmetic compliance with a leverage threshold (separate LaTeX document, [number withheld]–[number withheld] pages). |
| 2026-10-23 | T025 (PI accepted): Attrition and selection – Heckman correction (Wooldridge panel variant), inverse-probability weighting and Lee bounds for the main dose × post estimates. |
| 2026-10-21 | T024 (PI accepted): Regression discontinuity at the RL1 threshold – sharp (end-[number withheld] position) and fuzzy (mid-[number withheld] breach instrumented by end-[number withheld] position), density test, bandwidths, placebo cutoffs, balance; RL2/RL3 graphical only. |
| 2026-10-20 | T023 (PI accepted): Bunching tests that separate threshold targeting of reported ratios from genuine deleveraging (placebo definitions, reporting dates, reversal, composition, excess-mass estimator). |
| 2026-10-26 | T031: registered step [number withheld] last. Asserts T023 pre/post estimates and CIs before publishing; adds distinct-firm support and explicit entry definitions, leave-one-firm-out, all three samples, the full [number withheld]-cell density grid, exact-distance reversal LPMs and all three timing windows. Bootstrap mass fits use the T023 seed and [number withheld] whole-firm draws, refitting each draw; restricted universes are resampled at fixed size. Grid exclusions use T023 midpoint membership and disclose realized edges when nominal bounds split [number withheld] bins; b has bin-width-specific units, with common [number withheld]-bin units also in CSV. Reversal uses CR1 firm-clustered t intervals, observed next scheduled dates, and explicit nonestimable cells. Static reproducibility evidence is in `outputs/tables/t031_verification.txt`. |
| 2026-10-23 | T029: registered step [number withheld] last; added mechanical frozen-MI and ex-MI compliance, end-[number withheld] placebo, all five T023 bunching fits, debt benchmarks, all-firm distance regressions, exact components and incentive heterogeneity. Main/extension windows, known-jump variants, counts and limitations are explicit; byte comparisons are in `outputs/tables/t029_verification.txt`. |
| 2026-10-25 | T029 REWORK: corrected incentive comparisons to post minus the [number withheld]-anchor placebo, added differences between groups, and applied the [number withheld]-firm gate to actual statistic cells. Added explicit MI pre-trend and pointwise-CI notes, placebo counts in compliance TeX contrasts, half-year plot labels and an unconnected extension segment starting at [number withheld]H1; renamed the exclusion variant `exclude_jump_dates`. Part A estimates are unchanged. |
| 2026-10-23 | T030: added [number withheld]b directly after [number withheld] in both entry points, a separate extension through [number withheld]H2, unchanged-cleaning and historical-overlap assertions, coverage, source-availability/attrition audits, crossing counts and dictionary addendum. Main panel and existing outputs remain protected; full-build verification is in `outputs/tables/t030_verification.txt`. |
| 2026-10-23 | T028: added step [number withheld] after [number withheld] in both entry points. Pre-period financial means with missing indicators and December-only annual flow controls; all six C0--C5 specifications, D2[number withheld] exclusion, coefficient stability, and controlled RL1/minority-share event studies. Actual report-date gates prevent mapped-[number withheld] observations from entering controls. Ownership timing and reported-currency limitations remain explicit. Repeated full-build verification is in `../tasks/T028_verification.txt`. |
| 2026-10-23 | T028 REWORK: aligned balance groups with T005/T012; logged all dropped slopes, including zero missing indicators; renamed the controlled event study C3-date; clarified the RL1 conditional pre-trend, overlapping control/pre-test windows, and unreliable CR1 inference with many slopes. Suppressed the JV/assets C4 SE in the TEX table; numerical model outputs remain unchanged. Moved static verification evidence to `../tasks/T028_verification.txt`. |
| 2026-10-21 | T025: added step [number withheld] after [number withheld] in both entry points. Pooled post-period probit with missing-indicator predictors, single Mills ratio, IPW using pre-announcement reporting, and binary-dose Lee bounds. Both-stage Heckman/IPW and Lee bootstrap use [number withheld] shared seeded firm draws. Failed Heckman draws are counted without replacement; above [number withheld] percent failures its SE and CI are suppressed. Notes explain weak exclusion, near collinearity, within-firm IPW weighting and unequal Lee horizons. Superseded partial/stop files removed; fresh-copy byte checks in `outputs/tables/t025_verification.txt`. |
| 2026-10-21 | T024 REWORK round [number withheld]: the firm audit adds post-date counts for nonpositive equity and minority equity above total equity, plus a firm flag also covering post RL2 above [number withheld]. The robustness CSV adds sharp h = b = [number withheld] exclusions for RL2 and minority share; primary estimates stay unchanged. Main/fuzzy notes document equity-denominator problems (D2[number withheld]) and undefined log debt at zero debt. Round-specific checks and counts are in `outputs/tables/t024_verification.txt`. |
| 2026-10-21 | T024 REWORK: restrict placebo cutoffs to their own side of zero with truncated windows and effective counts; separate fuzzy estimates and first-stage diagnostics from the sharp ITT TEX table, flag all estimated fuzzy rows as uninterpretable due to the weak first stage, and generate assertion-guarded density/MSE counts in notes. |
| 2026-10-21 | T024: inserted step [number withheld] between [number withheld] and [number withheld]; added local rdrobust/rddensity dependencies and recorded lpdensity. Fixed-bandwidth primary sharp/fuzzy RL1 RD, first-stage strength, MSE/fixed/quadratic/mean-running robustness with the approved ten-firm gate, full validity checks, audits and four figures. RD is low-powered and supplementary; weak first-stage and counts-only variants are explicit. |
| 2026-10-21 | T027: added step [number withheld] after [number withheld] in both entry points, identity gates, crossing decompositions, event audit, five firm-bootstrap contrasts, debt growth, four robustness variants and figure. Missing log domains and minority/perpetual coverage are explicit. Existing outputs protected. |
| 2026-10-21 | T027 REWORK: clarified log-odds units and code-computed percentage-point approximation, corrected RL2 numerator diagnostics, added all-events minority-share median/mean contrasts, changed the figure to the all-events split, marked the thin perpetual pre panel as not interpretable, corrected TeX share/zero display, and added the HK-Wind perpetual overlap guard. |
| 2026-10-19 | T023 estimation REWORK: additionally exclude the regulated region from placebo polynomial fits; suppress SEs for invalid point estimates and flag fewer than [number withheld]% valid draws without significance stars; add paired-sample RL1 excess mass and explicit sample labels; round the excess-mass alternative cutoff to [number withheld] on the [number withheld] grid. Old/new placebo estimates and rebuild hashes are recorded in the verification file. |
| 2026-10-19 | T023 review corrections: exclude imputed perpetuals from adjusted-RL2 comparisons and perpetual composition changes; use positive observed advances and a quantile-matched alternative-RL1 cutoff; add reporting-date robustness excluding fiscal-year-flag firms and coverage counts; keep wide-fit excess mass below the cutoff, flag conditional SEs, and state multiplicity and descriptive limits. |
| 2026-10-19 | T023: added step [number withheld] after [number withheld] in both builds, definition placebos, reporting-date shares, adjacent-date reversal, descriptive composition differences, polynomial excess mass with clustered bootstrap and robustness/placebo fits, and two figures. Existing outputs remain protected; verification evidence is in `outputs/tables/t023_verification.txt`. |
| 2026-10-19 | T022: replaced the unescaped sample identifier in the S1[number withheld] LaTeX note with "the main sample"; scanned all six generated TEX tables for unescaped special characters in text/notes and verified a fresh-copy build with only that note line changed. |
| 2026-10-18 | T019: added S1[number withheld] excluding two likely non-developers (already outside sample_main); added captions/labels to main DiD and ownership tables; added the five-outcome ownership coefficient figure from existing split estimates; appended ten main_dose_pre placebo MDE rows while retaining all fourteen legacy rows. Fresh-copy byte comparisons and SHA-[number withheld] evidence are recorded in the T019 worker report. |
| 2026-10-18 | T015 REWORK: ownership-specific half-year FE in the main interaction; asserted split-equivalent point estimates ([number withheld]); kept common-time FE only as labelled robustness; corrected TEX block spacing and split-group counts. Rebuild and checksum evidence: `outputs/tables/t015_rework_verification.txt` (verification record, not an analysis output). |
| 2026-10-18 | T015: appended final ownership and source columns from unchanged manual coding with Wind priority; added five-outcome SOE interaction and split-sample estimates and ownership audits; extended both build entry points after [number withheld]. All first [number withheld] panel columns and previous outputs are preserved; fresh-copy checks accompany the worker report. |
| 2026-10-17 | T014: made CSV/TEX output line endings platform-independent; normalised text checksum guards with an optional warning mode; validate protected PDFs and report byte differences by default, with optional `strict_pdf` checks; limited setup to used packages; clarified Windows setup, tested versions, build status and Wind course-only inclusion. |
| 2026-10-17 | T010: included and hash-verified raw inputs; added RStudio project, dependency setup and cross-platform six-step build; staged all T005 outputs before protection checks. Moved twelve development outputs and three scripts into provenance folders; rebuilt four T011 event-study PDFs. Fresh-copy verification is documented in Section [number withheld]. |
| 2026-10-16 | Package skeleton created (structure, README, environment, build script). |
| 2026-10-16 | Existing scripts and outputs moved in from the project root; `replication/` is now the only location for code, data and outputs. Scripts run from `replication/`; raw exports are still read from `../Daten/` until they are copied to `data/raw/`. |

---

## [number withheld]. Contact

Anton Wilhelmi · <email-redacted>


### T041: robustness of the two core findings

`Rscript --vanilla code/14_core_robustness.R` (from `replication/`) runs after T037 and before T040 in
both build entry points. It reads only the existing main panel and first asserts
that T023 post-policy b rounds to [number withheld] and T029 pooled D rounds to [number withheld].
Outputs are the four `t0[number withheld]_bunching_by_date`, `t0[number withheld]_one_per_firm`, `t0[number withheld]_low_flex`
and `t0[number withheld]_frozen_horizons` CSV/TeX pairs in `outputs/tables/`, plus
`t041_bunching_by_date.pdf` and `t041_frozen_horizons.pdf` in `outputs/figures/`.
The script guards all other outputs and its inputs with SHA-[number withheld] and stages its
own outputs until the assertions pass. Static `t041_verification.txt`, build logs
and `t041_hashes.csv` record the separate repeated-run check.

The date-specific observed/counterfactual ratios use the pooled [number withheld]H1–[number withheld]H2
fifth-degree polynomial, with [number withheld] bins on [[number withheld]] and exclusion [[number withheld]).
Predicted mass is divided by the pre-period number of finite RL1 observations,
and compared to each date's observed share with the same denominator rule.
Whole-firm draws jointly re-estimate the pre density and date shares. Cross-section
b is fitted separately at the five requested dates; cells below [number withheld] observed firms
are descriptive only. All [number withheld] uniform random selections of one available post
observation per firm are retained in CSV. Their date-selection distribution and
positive share are not a sampling confidence interval; TeX reports its mean and
[number withheld]/[number withheld] percentiles beside the five cross sections.

Low-flexibility fits use degrees one and two over [[number withheld]], plus local linear
regressions of bin counts outside [[number withheld]), with a fixed tricube kernel and
bandwidth [number withheld] RL1 units on that same narrow range. Kernel, bandwidth and range
are implementation choices fixed before estimation. All use the same [number withheld] bins,
mass normalization and invalid-counterfactual rule as T023. No density is clipped.

Frozen-MI D uses the T029 accounting formula, positive N and E, positive frozen
total denominators, and available official/frozen pairs. Exact horizons are [number withheld],
[number withheld], [number withheld], [number withheld] and [number withheld] years after each anchor. The end-[number withheld] placebo has all five
horizons; June [number withheld] has only four within the approved [number withheld]H2–[number withheld]H2 window, so
its three-year cell and contrast are explicitly unavailable. Paired intervals
use shared draws of all main-sample firms, retaining the cell-specific available
samples rather than imposing a new balanced-sample restriction. Contrast CSVs
include both cell counts and their firm overlap. Each bootstrap refits the
statistic, using [number withheld] draws and seed [number withheld]. Intervals are pointwise; invalid
draws are counted, never replaced, and fewer than [number withheld]% valid draws is unreliable.
Smooth counterfactual density, reporting selection and stable within-firm currency
remain assumptions. Minority interests may be genuine equity; these comparisons
do not establish a causal policy effect or a change in economic leverage.


### T040: firm-published RL1 validation and accounting robustness

From the project root run `(cd replication && Rscript --vanilla code/13_rl1_validation.R)`;
from `replication/` run `Rscript --vanilla code/13_rl1_validation.R`. Step [number withheld] runs last
in both build entry points, after step [number withheld]. It needs only local inputs; no downloads.
The PI's report-fetching and candidate-extraction commands in `tasks/T040.md` are
preparation commands, not part of the offline replication build.

`data/raw/manual/rl1_validation/published_coded.csv` is the hand-coded input:
[number withheld] ratios for [number withheld] firms, including [number withheld] current-date RL1 values for [number withheld] firms.
Every row records the original PDF path, physical page, date, normalized value,
page text and verbatim definition evidence. Definition pages can differ from the
value page. `coding_log.md` records candidate decisions and definition conflicts.
Coverage is conditional on the supplied search, including its keyword and text
extraction limitations. Current dates are FY2[number withheld], H1[number withheld] and FY2[number withheld]; later
comparatives are not pooled with contemporaneous disclosures. No values are
inferred from green status. Unknown perpetual treatment remains unknown.

The script first asserts T023 b rounds to [number withheld] and T029 D to [number withheld], then writes
`t040_validation.csv/.tex`, `t040_disagreements.csv`, `t040_robustness.csv/.tex`,
`t040_matched_observations.csv`, `t040_verification.txt` and the scatter
`t040_constructed_vs_published.pdf`. The matched-observation audit retains all
coded ratios, availability, exact-date panel matches and document evidence.
RL1 and gearing errors are in proportions; cash-ratio tolerances are absolute
ratio units. The validation classification uses compliance at RL1 <= [number withheld].

The perpetual sensitivity uses `(tl - adv + perp)/(ta - adv)` only for observed
perpetual items (including observed zeros); otherwise it retains original RL1.
Its frozen-MI counterpart subtracts current MI and adds end-[number withheld] MI in that same
asset denominator, retaining current perpetuals. T029's positive original N/E
and positive total-counterfactual-denominator rules remain in force. The matched
firm sample requires all coded current-date RL1 values for a firm to be available
in the panel and within one percentage point; all its original main-panel dates
are then retained. This conservative firm-level rule is an implementation choice,
not an extra balance-sheet filter. Missing publications do not count as matches.

All robustness statistics use [number withheld] whole-firm resamples with shared draws, complete
histories, seed [number withheld] and refitted fifth-degree counterfactuals over the T023
grid. The restricted sample resamples its own firm universe. Invalid draws are
counted, not replaced; below [number withheld]% valid is unreliable. Classification and validation
error summaries are descriptive. Smooth counterfactual density and stable
within-firm reporting currency remain assumptions. Minority interests can be
genuine equity; these comparisons do not identify evasion, causal policy effects
or economic leverage. The all-perpetual adjustment does not reproduce every
firm's actual treatment of VAT, issuance dates or perpetual denominators.
The required independent reviewer check of [number withheld] published values remains pending.


### T044: fixed-rubric pilot coding and annual magnitude (step [number withheld])

Run `cd replication && Rscript code/16_pilot_magnitude.R` from the project root.
Both build entry points run step [number withheld] last, after `15_referee2.R`. The offline
script reads `data/raw/manual/handcollect/pilot_coding.csv`, the unchanged panel
and hand-collected cash flows, and fixed annual source-statement links to
`case_notes.md`; it rebuilds `t044_component_statements.csv` and requires R packages `jsonlite`
and `digest`, and local `pdftotext`. It writes `t044_pilot_coding.csv/.tex`,
`t044_magnitude.csv/.tex`, and `t0[number withheld]_*` source/coverage/verification audits.
The hand coding includes individual transaction candidates and ten explicitly
separate U coverage markers: complete enumeration of all minority subscriptions
is unresolved. Groups whose dates are all uncertain relative to the window boundary
are retained but excluded from the in-window counts (N, rows), amounts and cash
allocation; `t044_pilot_coding.csv/.tex` shows them in a separate column
(`boundary_uncertain_candidates`, "Bound.-unc."; ids in `boundary_uncertain_group_ids`).
Transaction/participant rows and distinct deal counts
are distinguished. The rubric is applied D, G, H, E, U in that order; an investor
put or mandatory issuer-side retransfer qualifies as D even with project-based
pricing. Shanghai Zhonghan therefore codes D under this rubric; G1-G8 remain
verbatim PI-verified factual statements, not approval of the category.

Magnitude windows use the two fiscal years in `reports_needed`, annual `ni_mi`
only, and flows after the earlier year-end through the later year-end. Printed
dashes are nil; empty input cells remain missing and make residual NA. Only
explicitly evidenced paid contributions in a matching year enter category cash;
proposals, issuer money, in-kind contributions, transfer prices and creditor
guarantees are separate. Documented allocation zeros do not establish zero
debt-like financing. Shares use signed delta MI; pools for A and B are ratios of
sums with missing components propagated. A residual includes all unmodelled
changes (for example consolidation, transfers and other comprehensive income),
not an estimate of hidden debt. Numeric components are `verified` only when every
linked statement has current-text-matching PI status `yes` and level `strings` or
`meaning`; categories, relations and clauses require `meaning`. Shares also require
verified delta MI. Unattributed cash inherits total-cash verification and every
actual allocated category amount. PI verification is separate from worker checks.
The seed-[number withheld] sample, affirmative/negative feature evidence, note-prefix and
verification-row integrity checks, pending statement line numbers, and number-to-file-to-filter
links are delivered as `t0[number withheld]_*` audits. The original [number withheld] verification ID/text pairs
are recovered from the hash-validated original notes; historical mutable CSV bytes
were not retained. Embedded metadata captures the approved-rework checkpoint;
subsequent metadata changes require `verified_by=PI`. Old/current file SHA-[number withheld]
values are reported without asserting historical byte equality. D remains the
original category; added subtypes are derived only from the feature columns: D1
(fixed return/price/shortfall), D2 (market-value exit), and D-unspecified where the
exit-pricing feature is not stated. A feature that is mentioned but cannot be decided
(column `undecided_feature`, with page) makes a row U by the rubric order; there are
no ID- or text-based exceptions. Rows of the same subsidiary and agreement chain share
a `transaction_group_id`; counts and the compact table are by group, which takes its
most severe row category (`t044_transaction_groups.csv`, `t044_group_merges.csv`).
The check sample (`t044_check_sample.csv`) is every D, G and H row plus five random U
rows (seed [number withheld]). Files in `outputs/audit/T044/` are worker screening/visual-review
records and the Rework-[number withheld] coding-edit record, not script outputs; exclude these, logs and
the comparison manifest itself from the two-run reproducibility claim. Re-run step [number withheld]
after PI verification.
Rework [number withheld] (PI decisions 2026-10-28): the coding has a column `issuer_call_preset_price`
(H feature; an issuer call at a preset price is not an investor exit). Annual-report rows
join the announcement group of the same subsidiary and fiscal year, but their transfer
consideration is reported separately (`ar_consideration_rmb`, "AR cons."), not added to
the announcement amount. `t044_attribution_totals.csv` sums capital from NCI attributed to
a coded category vs. not attributed over the ten firms (firms with missing capital from NCI
are named and excluded, not set to zero).
This purposive pilot supplies mechanism evidence, not prevalence or causal effects.

### T047: transaction coding of the crossing-event sample

`cd replication && Rscript code/18_crossers_coding.R` applies the unchanged T044
Rework-[number withheld] feature rubric to the Revision-[number withheld] sample: all [number withheld] events in
`state/handcollect/crossers_post.csv` ([number withheld] firms). Six exact pilot windows reuse
`pilot_coding.csv`; the other [number withheld] windows ([number withheld] firms, including [number withheld] nonpilot firms)
use the hand-collected `crossers_coding.csv`, with identical columns. The sample
includes debt-driven crossings: the file defines the pool, not a claim that every
crossing was MI-driven. `t047_coding.csv/.tex` count distinct agreement-chain groups
per event, firm union and pool. Coverage gaps and boundary-only candidates are
separate; proposed transactions and historical contract terms are identified in
the coding notes. In particular, Shimao's D1 concerns original redemption terms:
the buyback undertaking was transferred from the Group to Mr. Hui and lapses
on the Shimao Services listing; the Group obligation was removed before conversion
from a derivative liability to ordinary equity (FY2[number withheld] physical p.[number withheld]). This is not outstanding D1 equity at
year end. The medical-device G candidate is a plan without a signed agreement.

`t047_magnitude.csv/.tex` report annual components and D1/D2/D-unspecified/G/H/E/U
paid-cash allocations. If NCI capital is unavailable, every allocation is NA
rather than zero. Pools use the union of fiscal years within each firm, then
strict sums; event monetary rows must never be summed. A missing closing annual
report, blank cash-flow cell or unmatched panel amount remains missing. The
separate `t047_attribution_totals.csv` headline covers only observed firm-years;
it is explicitly a partial-coverage total, not the complete-sample pool. Transactions
are counted through date1 while cash flows run to fiscal year-end; the attributed
share is a lower bound for the fiscal-year window. No payment
is inferred from commitments, share prices or year-end subsidiary balances.
`outputs/audit/T047/component_sources_input.csv` stores checked source locators;
step [number withheld] reads values afresh from the panel/T044 cash-flow/T046 cash-flow inputs,
validates the PDF excerpts and links the actual `case_notes.md` line text to the
PI verification file, which step [number withheld] never modifies. Numeric statements require PI yes at strings
or meaning level; qualitative statements require meaning. Pending statements are
split into `t047_pending_numeric.csv` and `t047_pending_qualitative.csv`.

Audits include the sample mapping, all event-to-transaction memberships, annual
source ledger, number-to-file-to-filter links, [number withheld] pilot-window reuse checks,
[number withheld] file/prefix SHA-[number withheld] checks and verification row-identity checks allowing only
PI metadata updates and added rows, the all-D/G/H-plus-five-U check sample (seed [number withheld])
and the two-run byte comparison. Preparation helpers, rendered sample pages and
worker review records are not build outputs and are excluded from the two-run
claim. Hand-collected inputs and PI decisions are never rewritten by step [number withheld].
Rework profit-source replacements are appended; earlier claims are marked
superseded only in the audit, retaining all original note bytes. Empty allocations
never verify an unallocated remainder; the remainder also requires every
firm-window category to be verified. Local-source coverage remains U for every firm; counts are observed disclosure
evidence, not an exhaustive financing census or a causal estimate.


### T055: density-free MI dependence and definition falsification

`cd replication && Rscript code/19_referee3.R` runs the approved T055 checks
offline and is the last step in both build entry points. Before computing any
variants it asserts post RL1 b = [number withheld] (rounded), frozen-MI D = [number withheld] (rounded),
and [number withheld] paired observations / [number withheld] firms. It only reads the original main panel
and previously published reference tables; no hand-collected inputs are read.
All uncertainty uses the common T023/T029 [number withheld] whole-firm resamples of the full
[number withheld]-firm main-sample universe (seed [number withheld]), re-estimating statistics, density
fits, reweighting distributions and fallback medians in every draw. Intervals
are pointwise percentile CIs; valid/failed draw counts are retained.

- `t055_mi_shift.csv/.tex`: means and medians of \[number withheld](frozen minus reported RL1),
  post, placebo and their paired-bootstrap difference, both all eligible pairs
  and reported RL1 in [[number withheld]]. D is separately reported in share units.
  Placebo D is standardized to the paired post reported-RL1 distribution using
  [number withheld] bins within this range (left-closed, final bin includes [number withheld]).
  Bin weights are post share / placebo share, recomputed in every draw;
  an unsupported target bin invalidates that draw, with no extrapolation.
  The contrast compares restricted post D to restricted reweighted placebo D.
- `t055_kappa.csv/.tex`, `t055_kappa_break_even.csv`, `t055_kappa.pdf`:
  reclassify kappa of positive MI growth into debt while preserving N+E,
  for every kappa from [number withheld] to [number withheld] in increments of [number withheld], separately post/placebo,
  holding the official/frozen eligible pairs fixed. Compliance uses <= [number withheld].
  First b <= [number withheld] and first CI inclusion of zero are linearly interpolated between
  neighboring grid points. They are sensitivity thresholds, not exact roots
  of the discontinuous histogram statistic or estimates of actual hidden debt.
  Already nonpositive at zero, never crossing, and invalid fits have distinct
  statuses; nonmonotone b paths are retained.
- `t055_falsification.csv/.tex`: raw **tl/ta** and regulated RL1 b at [number withheld],
  pre/post levels and changes, and RL1-minus-raw contrasts in the joint
  bootstrap. Both definitions use identical available firm-dates ([number withheld] pre,
  [number withheld] post); `rl1_alt` is not used. Smooth density, reporting selection and
  polynomial specification remain assumptions behind a targeting interpretation.
- `t055_linear_trend.csv/.tex`: T043 step [number withheld] with an OLS slope of MI levels
  over the inclusive three-year pre-anchor history, anchored at actual anchor
  MI. The unchanged eligibility rule requires four finite MI observations and
  no observed nonpositive MI. Failed own slopes use the median donor slope
  within the anchor RL1 bin; the second variant uses this median for all firms.
  Bins are [[number withheld]), [[number withheld]), [[number withheld]], other; no global fallback.
  Linear MI is not clipped; invalid total denominators are excluded and counted.
  Fallback of monetary level slopes across firms assumes comparable units,
  including unresolved HK reporting currency. Pre-[number withheld] history is unavailable,
  so the T043 placebo anchors (end-[number withheld] / mid-[number withheld]) and associated contrasts
  remain explicitly unavailable. Own/bin variants and those unavailable rows
  preserve the T043 step-[number withheld] reporting structure.
- `t055_pretrend_tests.csv/.tex`: all nine published T009/T028 tests, copied
  without re-estimation; controlled RL1 p = [number withheld]. T009 did not
  record N/firms, so these remain unavailable. T028 C0 repeats the corresponding
  T009 tests and is labeled by source. Non-rejection does not establish parallel
  trends; controlled RL1 rejects the tested restriction.

Bunching uses degree [number withheld] over [[number withheld]], [number withheld] bins, with [[number withheld]) excluded
from the fit and used for excess mass, exactly as T023/T029. Negative estimates
and all failed fits remain visible. `t055_bootstrap_draws.csv` contains all
[number withheld] draws for [number withheld] estimate/contrast rows; `t055_sample_audit.csv` identifies
firm-dates and definitions, `t055_mi_reweight_bins.csv` records bin support and
weights, and `t055_linear_trend_firms.csv` / `t055_linear_trend_coverage.csv`
record slope eligibility, fallback and draw coverage. `t055_number_map.csv`
links each estimated number to its file and exact row filter.
`t055_verification.csv` contains SHA-[number withheld] hashes for read-only inputs and every
pre-existing non-T055 output; all are checked before publishing staged files.
A repeated execution with the same context additionally asserts byte equality
of every staged T055 CSV/TEX/PDF against the previous run. PDF metadata have
no timestamps. All checks are descriptive accounting sensitivities and cannot
identify a causal policy effect or the share of MI that is disguised debt.

### `20_referee4.R` - policy exposure and descriptive referee checks (T058)

Runs **last** in both build entry points. Standalone from the project root:
`cd replication && Rscript code/20_referee4.R`. No downloads or raw-data changes.
The initial gate reproduces official post/pre b ([number withheld]/[number withheld]), their change
([number withheld]), frozen-MI D ([number withheld]), and the [number withheld]-observation/[number withheld]-firm paired sample.
All inference uses [number withheld] common whole-firm draws from the [number withheld] main-sample firms,
seed [number withheld], preserving histories, periods and overlapping subgroups. Density
polynomials and nonlinear statistics are re-estimated in every draw. Invalid
draws remain counted; intervals with fewer than [number withheld]% valid draws are unreliable.
No clipping, winsorisation, replacement of failed draws or integration correction.

- `t058_pilot.csv/.tex`: exactly the eleven panel IDs in the read-only
  `state/pilot_developers.csv`, nonpilots, changes and joint contrasts; end-[number withheld]
  and [number withheld]H1-onward timing cells; Seazen A-share substitution; pilots with finite
  RL1 at all [number withheld] dates. In the latter sensitivity incomplete pilots would be
  excluded rather than relabeled as controls. The other Seazen entity is excluded
[firm-specific excerpt withheld in public process copy]
  `t058_pilot_mapping.csv` and
  `t058_sample_audit.csv` preserve memberships. Every cell reports observations,
  firms, firm-dates and firms in [[number withheld]); fewer than [number withheld] window firms is flagged
  descriptive/small. Zero-window b cells or bootstrap draws have explicit CSV
  inference flags and zero-draw counts, plus B in TEX: their percentile intervals
  are bounded by construction at b = [number withheld] (minus the number of mass bins) and are
  not informative. Control counts reflect the exclusion.
  The pilot and rollout dates are supplied by T058, not
  independently source-verified in this offline task.
- `t058_notch.csv/.tex`: pre/post b, changes and the joint change contrast for
  **contemporaneous** RL2 <= [number withheld] and RL3 >= [number withheld] versus at least one breach, requiring
  both ratios observed. T058 explicitly requests the same-date class; T043's
  existing `other_lines_2[number withheld]h1` instead freezes classification at June [number withheld].
  `t058_notch_classification.csv` records every classification and missing cell.
  Switching classes and selection prevent a causal notch-intensity reading.
- `t058_symmetric.csv/.tex`: on the existing MI-eligible pairs, freeze MI,
  parent equity (`te-mi`), debt (`std+ltd+notes+lease`, the panel's `ibd_ext`),
  or total equity (`te`, MI and parent jointly). Partial debt sums follow the
  panel: missing components zero only when at least one is observed; all missing
  remains missing. HK notes already included in std/ltd are not added twice;
  the standalone `notes` column is the A-share bills-payable item, absent for HK.
  Equity freeze is N/(N+E-item+item_anchor); debt freeze is
  (N-debt+debt_anchor)/(N+E-debt+debt_anchor), with N=tl-adv and E=te.
  Reported N,E and frozen total denominator must be positive; negative growth,
  nonpositive frozen equity and nonpositive debt-frozen numerator are retained.
  Anchors are end-[number withheld] for post, end-[number withheld] for the matched five-date placebo
  [number withheld]H2-[number withheld]H2. Additional item/anchor/denominator losses from the MI pairs are
  counted rather than changing the comparison silently. Normalization is
  `[number withheld]*D / median([number withheld]*(item_t-item_anchor)/ta_anchor)`: compliance percentage
  points per growth percentage point of **own-firm anchor total assets**.
  Zero median growth is undefined; its bootstrap draws remain failed. Window
  counts refer to the ratio relevant to the metric (reported for D and growth,
  frozen for frozen compliance/b). `t058_symmetric_audit.csv` preserves formulas,
  eligible pairs, item stocks, denominator and signed growth. Constant within-firm
  reporting currency is assumed; parent equity includes unresolved perpetuals.
  Joint-bootstrap MI-minus-parent and MI-minus-joint-freeze normalized-D
  differences are reported for post and placebo, plus their post-minus-placebo
  differences. All use the same draws W; undefined normalizations remain failed.
  All four contributing populations for the latter contrasts are recorded in CSV.
- `t058_attrition.csv/.tex` and `t058_attrition.pdf`: pre/post b and changes on
  all firms, finite-RL1 balanced [number withheld] dates ([number withheld]H2-[number withheld]H2), and balanced [number withheld] main
  pre/post dates. Terminal exits have their last financial row at or after
  June [number withheld] and before December [number withheld]; continuing firms have a December [number withheld] row.
  Compare each firm's last finite RL1, with all finite values in the denominator,
  including values outside the [number withheld]-[number withheld] histogram. The last [number withheld] bin includes
  [number withheld]; the near-window test is separately [[number withheld]). Both a shared-bootstrap
  share difference and the two-sided Fisher exact p-value are reported.
  For `bin_share` rows, window observations/firms count the respective [number withheld] bin,
  rather than the separate near-threshold window.
  LOCF carries the last finite ratio only to scheduled dates after terminal exit,
  never into internal gaps, through December [number withheld]. Earlier exits are excluded
  from this comparison/fill. It is a sensitivity scenario, not a mathematical
  bound on nonlinear b. Firm histories and additions are in
  `t058_attrition_firms.csv` and `t058_attrition_LOCF.csv`.
- `t058_window.csv`: the original code rule is pre from 2017-06-30 through
  2019-12-31 and post from 2020-12-31 through 2022-12-31, otherwise NA. The T023
  README wording is "Uses the main sample, pre-period [number withheld]H1–[number withheld]H2 and
  post-period [number withheld]H2–[number withheld]H2". June [number withheld] is between these explicit windows;
  neither source gives a separate substantive rationale. June-only b and the
  change after adding June [number withheld] to pre are reported without inventing one.
- `t058_above.csv/.tex`: for each upper bound [number withheld]/[number withheld], exclude the entire
  [[number withheld],upper) region from fitting. Report below [[number withheld]), above [[number withheld],upper)
  and total [[number withheld],upper) excess mass from that same polynomial, pre and post,
  with CIs. Each b divides observed minus fitted counts by its own region's
  mean fitted bin count, so b values need not add. Window counts refer to the
  evaluated region. Negative means missing mass; no integration constraint.
  The old rows whose evaluated bins participated in fitting are dropped.
- `t058_grid.csv`, one-page `t058_grid.tex`, `t058_grid_summary.csv` and
  `t058_grid.pdf`: all [number withheld] specifications of the read-only T031 grid, now for
  joint post-minus-pre b. Every post point is asserted equal to T031. Realized
  mass/exclusion edges follow T031 midpoint assignment, including nominal edges
  not aligned with width [number withheld]. Summary shares use all specifications as denominator;
  CI-above-zero additionally requires a valid point and >=[number withheld]% valid draws.
  `window_obs/firms_pre/post` count the actual realized exclusion window;
  `mass_obs/firms_pre/post` count the below-threshold mass region. Native b
  units vary with bin width; the TEX summary uses only rescaled [number withheld]-bin
  min/median/max, while the CSV retains both native and converted values. Converted
  [number withheld]-bin changes and the second figure panel permit comparison. These correlated
  intervals have no multiple-testing adjustment.
- `t058_standard.csv/.tex` and `t058_standard_mapping.csv`: the existing
  `01_clean.R` maps and T004 dictionary sum both advance receipts and contract
  liabilities at every date, for both EastMoney and Wind A-share records. There
  is no [number withheld]-specific splice. Partial sums and the existing all-missing zero with
  `adv_missing` flag are preserved. Report median adv/ta by market/date, finite
  positive assets required, and pre/post b, changes and the joint HK-minus-A
  contrast. Additional `no_imputed_zero` variants exclude `adv_missing` firm-dates
  for medians and both markets' changes, retaining every other rule. TEX notes
  count imputed-zero observations by market and period; CSV retains date counts.
  HK source labels are `预收款项 + 合同负债` for both EastMoney and Wind
  (the legacy columns `A_eastmoney/A_wind` describe the row market's sources).
  Adoption timing is supplied by the card and not newly verified here.
  The card's phrase "no standard change inside the window" for HK needs care:
  [number withheld] is inside the full [number withheld]-[number withheld] pre period, although before policy exposure.
  Market composition, fiscal calendars and raw component vintage comparability
  remain limitations; no accounting-standard effect is identified.

`t058_bootstrap_draws.csv` retains all [number withheld] draws for each estimated row;
`t058_number_map.csv` maps numbers to files and unique row filters.
`t058_interpretation.csv` generates one interpretation paragraph per step directly
from those estimates. `t058_reproduction.csv` records all six initial assertions.
`t058_verification.csv` records SHA-[number withheld] hashes for read-only inputs and every
existing non-T058 output. Outputs are staged until coverage and integrity gates
pass; when context hashes match a prior run, each staged CSV/TEX/PDF must be
byte-identical before publication. PDF metadata omit timestamps. These are
descriptive density/accounting checks; smooth counterfactual density, reporting
selection and accounting comparability remain assumptions, without causal or
disguised-debt identification.

### T061 — difference-in-bunching with the approved Sina control population

Run from `replication/`: `Rscript code/21_diff_bunching.R`. Both build entry points
append this script after `20_referee4.R`. It performs no downloads. The frozen control
inputs are in `data/raw/control/`, with their own `MANIFEST.csv` (the original
`data/raw/MANIFEST.csv` is outside T061's write scope). Source copies have matching
SHA-[number withheld] checksums. Embedded selection/download dates are used where present;
otherwise the manifest explicitly labels the source filesystem modification date as
an **unverified fetch-date proxy**. The combined balance file was assembled on
2026-11-01; the worker cannot recover exact request timestamps from the saved CSV.
The two fetch scripts and all [number withheld] Sina list CSVs are preserved as provenance, never run
by the offline build.

The PI-approved route replaced EastMoney industry boards with Sina Finance lists
for 建筑建材, 水泥行业, 机械行业, 化工行业, 钢铁行业, 有色金属, 电力行业,
供水供气, 交通运输 and 煤炭行业. The original roster plus coal add-on has [number withheld] distinct
A-share codes. Of these, [number withheld] have all [number withheld] requested balance dates ([number withheld]H1–[number withheld]H2),
[number withheld] firm-half-years; [number withheld] roster firms have no saved balance data. This is a
balanced, survivor-selected control population. `t061_download_failures.csv` lists
all [number withheld] missing firms by exact sector membership and `t061_failure_by_sector.csv`
aggregates them. The saved failure ledger contains only the two coal errors;
[number withheld] earlier error messages are unavailable, and their causes are not imputed.
No control overlaps any firm in the full developer panel.

Cleaning exactly follows the applicable developer RL1 rules: sum observed
`ADVANCE_RECEIVABLES` and `CONTRACT_LIAB`; both absent gives zero with
`adv_missing=TRUE`; calculate `(TOTAL_LIABILITIES-adv)/(TOTAL_ASSETS-adv)` only
when the denominator is positive. Missing core fields remain missing. No trimming,
winsorization, interpolation or numerator restriction is added. The same [number withheld]-date
set as developers is used in analysis ([number withheld]H2–[number withheld]H2); [number withheld]H1 is retained in the
control audit only. Pre is [number withheld]H1–[number withheld]H2; post is [number withheld]H2–[number withheld]H2. The script asserts
reproduction of developer b_pre [number withheld], b_post [number withheld] and change [number withheld] before estimating
controls. Full cleaning rules, row-level ratios and by-date finite-N / fit-range
coverage are in `t061_cleaning_rules.csv`, `t061_control_panel.csv` and
`t061_coverage.csv`. The control panel is an audit table because T061 does not
permit a new file under `data/processed/`.

Bunching uses [number withheld] bins on [[number withheld]], degree [number withheld], excluding [[number withheld]).
Counterfactual density is refitted in all [number withheld] whole-firm bootstrap draws, seed
[number withheld]. Pre/post histories are paired within firm; developer and control draws
are independent strata. Each developer variant resamples its own firm population;
control draws are shared across thresholds and comparisons. Percentile CIs condition
on valid draws; invalid draws, negative fitted bins and zero-window draws are
reported. No multiplicity adjustment is applied. Control placebos move the four-bin
mass window to [[number withheld]) and [[number withheld]). Following T023, both placebo fits
additionally exclude [[number withheld]). This additional exclusion affects fitting only;
observed mass, fitted mass and the four-bin normalization use only the placebo
window. `t061_density_bins.csv` separates `excluded` from `mass_window`.
Main and balanced-developer comparisons are
co-primary; the latter uses exactly T058's [number withheld] firms with finite RL1 on all [number withheld] dates.
A-share developers versus the A-share control provides the same-market comparison.
All rows include finite observations, firms, fit-range observations and actual
threshold-window support by period; fewer than [number withheld] window observations in either
period flags low support. These counts are a support diagnostic, not a power curve.

`T061` explicitly drops broad and Hong Kong control variants under its approved data
route. The existing developer panel, manual ownership coding and Wind ownership
export match zero control firms, so SOE/non-SOE control changes are unavailable.
The supplied warning-line caveat since [number withheld] is not independently verified offline.
Sina classification, survivor selection, SOE warning lines, market composition and
concurrent sector shocks limit interpretation. A positive developer-minus-control
change with CI above zero supports developer-specific concentration only under
comparable counterfactual changes and smooth-density assumptions. A CI including
zero leaves a general reporting/focal-point shift possible; it does not establish
equivalence or prove absence of a policy response.

Core outputs: `t061_estimates.csv`, `t061_diff_bunching.csv`, `t061_support.csv`,
`t061_bootstrap_draws.csv`, `t061_results.tex`, `t061_density_bins.csv` and
`outputs/figures/t061_control_density.pdf`. Availability, ownership checks,
one paragraph per step and number → file → exact row/column filters are in
`t061_variants.csv`, `t061_ownership_availability.csv`, `t061_interpretation.csv`
and `t061_number_map.csv`. All generated tabular numerical cells are mapped.

The only permitted existing-output change is `t055_kappa.pdf`. The figure block in
`19_referee3.R` changes rendering dimensions/fonts only; T061 calls that block using
the existing T055 points and stored draws, checks the old CIs and writes no T055
table. Native width [number withheld] inches, [number withheld]-point base text and minimum [number withheld] scaling yield
a calculated lower bound of [number withheld] pt natively and [number withheld] pt at the A4
paper's full linewidth ([number withheld]-inch margins): [number withheld] * [number withheld] * ([number withheld]/[number withheld] - [number withheld]) / [number withheld].
These are conservative rendering bounds, not measured PDF font sizes.
Axes and titles are larger. This guarantee assumes full-linewidth placement.

`t061_baseline.csv` records all [number withheld] pre-existing output hashes before T061, marking
only the kappa PDF as mutable. `t061_verification.csv` checks read-only inputs and
other output bytes; a second run with unchanged inputs asserts every staged file
is byte-identical. The baseline is an audit of this approved execution, rather than
a requirement that historical verification manifests remain identical after a full
pipeline rebuild: upstream verification files legitimately incorporate source hashes.
The targeted T061 command records historical comparisons in
`t061_historical_output_check.csv`; changed upstream context is visible there
without preventing a fresh full build. Every invocation still protects all
pre-existing non-T061 outputs against changes made by T061 itself.

T061 Rework [number withheld]: the prescribed command also regenerates `t061_validation.txt`,
including independent histogram/polynomial checks of the six control levels,
all [number withheld] bootstrap contrast identities and the same calculated kappa text bound
as `t061_kappa_render.csv` and interpretation step [number withheld]. It participates in the
staged repeat-run byte comparison.

### T063 - notch calibration and referee round [number withheld]

Run `cd replication && Rscript code/22_referee5.R` from the project root.
Both build entry points append this step last. It extracts only the pure functions
`nf`, `period_masks`, `weights`, `mass`, `change` and `ci` from the parsed T061
script; the upstream script is never executed. The saved T061 control panel is
reused without modification. The first numerical gate reproduces developer
change [number withheld] and all/balanced developer-minus-control changes [number withheld]/[number withheld].

The noise calibration uses all finite RL1 pairs in the mandated, pre-existing
`t040_matched_observations.csv`. It neither reads original manually coded reports
nor adds hand-collected observations. Raw constructed-minus-published differences
are used without recentering or trimming; `t063_noise_calibration.csv` gives N,
firms, mean, sample SD and quantiles, plus the normal location/scale fit.
Treating these validation discrepancies as behavioral period-end errors is an
assumption, not a finding. They may reflect accounting definitions and measurement
error and need not represent firms close to the policy threshold.

Because the card does not specify a pi grid, use pi = [number withheld], [number withheld], ..., [number withheld], beta =
[number withheld]/[number withheld]/[number withheld], Delta = [number withheld]/[number withheld], with empirical, fitted-normal and frictionless
errors: [number withheld] cells, [number withheld] replications each, seed [number withheld]. The fixed no-policy
distribution contains every finite pre-policy developer observation, including
out-of-fit-range values. In each replication a Bernoulli(pi) indicator is drawn
once per firm; its observations inside the inclusive band [[number withheld]+Delta] move
to [number withheld]-beta plus an independent date-specific error. Only movers receive noise.
For beta=[number withheld], the intended target is the left limit [number withheld][number withheld], avoiding an artificial
above-threshold atom in the left-closed histogram. Common uniforms pair grid cells
and empirical/normal errors. Firm composition and baseline observations are fixed;
these are simulation ranges, not population sampling intervals.

Each simulated distribution is refitted with the main estimator and, separately,
the above-threshold estimator excluding [[number withheld]). `t063_noise.csv/.tex` reports
every cell. A descriptive match means both observed statistics fall inside their
respective marginal [number withheld]% simulation ranges, not a simultaneous test or a parameter
confidence set. Mean errors remain visible in the CSV even for matching cells.
`t063_noise_draws.csv` stores all replication statistics and support;
`t063_noise_histograms.csv` stores all mean histograms. Four figure panels show
the empirical, normal and frictionless cells minimizing squared discrepancies of
the two mean statistics, plus the frictionless version of the empirical-best policy
parameters. Selection is documented in `t063_noise_representatives.csv` and is not
an estimate of policy parameters. Bar and line heights divide by all finite N.

`t063_window.csv/.tex` reports all/balanced/A-share/Hong Kong developer levels and
changes, control changes, and all/balanced/A-share contrasts with [[number withheld])
excluded. Both [[number withheld]) and total [[number withheld]) mass are evaluated using their own
mean fitted bin count normalization. `t063_control_sens.csv/.tex` reports removal
and reverse-only inclusion of construction, cement and steel for main and co-main
fits; the reverse sample is descriptive. Membership is recorded by firm and exact
Sina labels in `t063_control_membership.csv`. Every estimate includes finite N,
distinct firms, fit-range N, missing N and actual mass/exclusion window support
in both periods, including the control side of contrasts. Fewer than [number withheld] mass-window
observations flags low support. All fits have [number withheld] bins, degree [number withheld] over [[number withheld]].
[number withheld] within-population whole-firm draws preserve pre/post histories; populations
are independent strata. Invalid-draw counts and pointwise percentile CIs are
reported, with no multiplicity correction. All bootstrap values and fitted
histograms are saved in `t063_bootstrap_draws.csv` and `t063_density_bins.csv`.

`t063_distinct_firms.csv` counts firms with any below-threshold observation by
period/population. `t063_one_obs.csv/.tex` gives median and [number withheld]/[number withheld] percentiles
across [number withheld] independent observation selections (seed [number withheld]), one finite ratio
per firm and period, including out-of-fit-range ratios. Developer and control
selections are independent and paired by draw for their contrast. These are
observation-selection distributions, not bootstrap confidence intervals.
`t063_one_obs_draws.csv` and `t063_one_obs_support.csv` retain every result and N.

`t063_by_date.csv` gives both near-threshold shares and actual support on all [number withheld]
dates [number withheld]H2[number withheld]H2. The two-page `t063_by_date.pdf` uses [number withheld] bins [[number withheld]],
common vertical scales within population and all finite ratios as denominators.
The histogram bins are also saved in `t063_by_date_histograms.csv`.

`t063_reconcile.csv` identifies the missing RL1 row, distinguishes CNKI raw search
records from unique journal-source articles, checks both historical subgroup CIs
against saved draws, and distinguishes the [number withheld]/[number withheld] control estimates. It does not
re-estimate these reconciliation results. CNKI unique counts and the cross-query
duplicate are checked read-only against `state/litsearch/screening.xlsx`; being a
journal-source record is not proof of peer review or core-journal status.

`t063_interpretation.csv` contains one paragraph per step and states the identifying
and calibration assumptions. `t063_number_map.csv` maps every summary numeric cell
to file, exact row filter and column; draw/histogram files use explicit keys.
All existing outputs, all raw files and read-only analysis inputs are SHA-[number withheld]
guarded. New results are staged until gates pass; rerunning in the same input
context must produce identical bytes, including PDF metadata. Independent
hist/lm/predict checks and coverage gates are recorded in `t063_validation.txt`.

### T066 - improved doubly robust panel DiD and revised selection sensitivity

Run `cd replication && Rscript code/23_drdid.R` from the project root. Both build
entry points run this script before [number withheld] (`--embed-proposal-fonts`), [number withheld] and [number withheld]. It uses installed `DRDID` ([number withheld] in the
approved execution), with no network access, and first asserts reproduction of
[number withheld]-firm main-sample developer change [number withheld] and developer-minus-control change [number withheld]. Only pure functions
are extracted from T061/T025; neither upstream script is executed. The read-only
T061 control audit panel supplies identical RL1 cleaning and the T063 exact sector
labels exclude construction/building materials, cement and steel, including joint
membership. The finance fallback is outside this card's analysis.

Main outcomes compare 2019-12-31 to 2021-12-31. The period-mean sensitivity averages
each firm-date outcome over observed dates in [number withheld]H1-[number withheld]H2 versus [number withheld]H2-[number withheld]H2,
requiring at least one finite outcome per period. The binary outcome is constructed
before averaging, so the mean is a frequency. No missing outcomes become zero.
End-[number withheld] covariates, with the exact [number withheld]H2-to-[number withheld]H2 RL1 change, are unchanged
across main and period-average windows. Each pre-policy placebo instead measures
covariates at its own earlier base date. Its two-year RL1 change ends at that
base and is omitted when the lag date is unavailable ([number withheld]H2-[number withheld]H1 bases).
Baseline RL1 remains a permitted pre-change covariate; no covariate uses the
subsequent [number withheld] endpoint or the dependent change. The retained-sample algebraic
identity check and interval-count eligibility are saved in `t066_placebo_audit.csv`. Main A-share and all-market developers are each compared to all
controls and controls without the three supplier sectors. Private versus SOE uses
the literal `soe` field requested by T066; `soe_final` is not substituted, and
unclassified firms are counted and excluded. Rework [number withheld] removes cash / short-term
debt (near-duplicate of RL3) and the HK dummy. Market counts are [number withheld] private / [number withheld]
SOE A shares and [number withheld] / [number withheld] HK. The HK stratum cannot meet ten firms per group, so
the approved fallback reports A shares only, with pooling weight one.
`t066_ownership_markets.csv` and `t066_ownership_strata.csv` document counts,
complete-case counts per outcome/window and this decision. The all-market
ownership bunching contrast remains unchanged. Nominal assets use existing
reported currency units; no unavailable conversion is invented. Cross-market
asset comparability remains an additional limitation of those sensitivities.

The improved Sant'Anna-Zhao estimator uses an IPT-estimated logistic propensity
score and odds-weighted linear outcome regression for comparison changes, not
ordinary maximum-likelihood logit/OLS. `DRDID::drdid_imp_panel` supplies every point
outcome; multi-outcome bootstrap calculations use the algebraically identical
IPT/WLS score, checked against the package on all point outcomes and an exact-ATT
simulation (ATT=[number withheld]). Bootstrap IPT refits solve the same convex moment equations
by damped Newton ([number withheld] iterations, [number withheld] line-search steps), passing the installed
package's own `ipt.valid` gate. Ownership draws first try the package's secondary
`nlm` algorithm (same `loss.ps.IPT`, MLE initializer, bounded [number withheld]-iteration limit and
[number withheld] gradient tolerance; deterministic `stepmax=[number withheld]` bounds optimizer steps in
non-overlap draws), then damped Newton when that attempt fails the package gate.
This optimizer setting changes neither the IPT equation nor the acceptance
criterion. For ownership point fits, the primary package trust calibration is tried first,
then bounded secondary and Newton; if all fail, that point is unavailable. Any
verified fallback calibration is passed into an unchanged local copy of the
package outcome routine to avoid repeating an unbounded failed calibration;
the installed namespace is never modified. Every draw logs its solver/failure; no failed draw is
replaced and fewer than [number withheld] valid draws remains explicitly reported. On every observed sample, Newton and package propensity scores
are asserted within [number withheld]; unsolved bootstrap equations remain failed draws. A preliminary maximum-likelihood logit on the complete-case risk set supplies
the one-time [[number withheld]] support deletion; IPT is then refitted on retained firms.
Trimming scores and refitted IPT balancing scores are saved separately; the latter
can differ and are not recursively trimmed. Consequently the target is the ATT
of the retained overlap firms. All [number withheld] stratified whole-firm draws repeat
preliminary-logit support selection and IPT/WLS nuisance fitting from the complete-case risk set, with paired
pre/post histories, seed [number withheld]. Exact redundant covariate columns are removed
algebraically and recorded, without choosing variables by fit or outcomes.
The retained model space is orthonormalized by QR for numerical stability,
preserving every estimable requested covariate and the original logistic/linear
model spaces. Point
failures and every invalid bootstrap draw are retained in audit tables. Percentile
CIs condition on valid draws; fewer than [number withheld] percent valid flags unreliable inference.

`t066_drdid.csv/.tex`, `t066_balance.csv/.tex`, `t066_drdid_draws.csv`,
`t066_sample_audit.csv`, `t066_overlap.csv` and `t066_dr_fit_log.csv` provide every
estimate, complete-case N, trimming count, balance and firm-level outcome-date
coverage. Standardized mean differences use the unweighted pooled within-group SD;
trimming-only and final weighted balance are separate columns. The overlap PDF has
one page per comparison/window; the pretrends PDF shows every pre-policy date
[number withheld]H2-[number withheld]H1 versus end-[number withheld], with pointwise bootstrap CIs, for each comparison.
These pre-policy diagnostics use only their earlier-base covariates; flagged
algebraically mechanical rows are omitted from the figure and interval counts,
and unavailable intervals are also excluded from the count. Pointwise intervals
are correlated and unadjusted and are not proof of parallel trends.
A causal interpretation additionally requires conditional parallel trends, no
anticipation, no relevant spillovers, common support and a correct propensity or
comparison-change model. Survivor-selected controls and concurrent sector/market
shocks remain limitations. Private/SOE contrasts two regulated groups and measures
relative exposure, not regulated versus untreated firms.

`t066_ownership_counts.csv`, `t066_ownership_bunching.csv` and its draw table
report the private/SOE exclusion count, pre/post bunching and joint private-minus-
SOE change. The original degree-[number withheld] histogram estimator and six/five-date windows
are unchanged; [number withheld] whole-firm draws preserve each firm's histories, with independent
private and SOE strata. Invalid counterfactuals and threshold-window support are
reported. Smooth counterfactual densities and comparable counterfactual changes
remain assumptions.

For selection, the [number withheld]-firm T025 risk population, [number withheld] dates, five outcomes, pre-mean
missingness indicators, firm/date fixed effects and dose_pre by post outcome model
are retained. Excluded candidates are within-market centered log end-[number withheld] closing
price (Z1), observed FY2[number withheld] net loss (Z2), and original reporting frequency (Z3).
Each enters alone and all three enter jointly, in pooled-post probits with original
T025 covariates. Centering is an intercept reparameterization; prices retain RMB
and HKD within market. Three saved prices are from December [number withheld], not December [number withheld];
they are retained as the PI's end-[number withheld] closing prices and their dates are disclosed.
The raw price file is copied byte-for-byte to `data/raw/manual/prices_2019.csv`;
its authorized entry is appended to `data/raw/MANIFEST.csv`, preserving existing
manifest bytes. The download/export date is unverified rather than inferred.
Missing prices or losses are never imputed; specification-specific exclusions and
same-sample baseline coefficients disclose resulting sample changes.

`t066_first_stage.csv/.tex` reports candidate coefficients, firm-clustered z,
candidate-only joint Wald chi-square, McFadden pseudo-R2 and the share of firms
whose mean fitted post probability is strictly in ([number withheld]), averaging the five
post-date predictions within each firm and then using equal firm weights. Statistical admissibility
requires convergence, estimable candidates/cluster variances, finite Wald and no
structurally separated pre-mean-missingness group. The greatest joint Wald selects
separately by outcome, retaining the original disclosed interpretation of
strongest. Raw Wald comparisons across single/joint specifications have different
df and are not comparable significance rankings. The card's Wald >= [number withheld] usability
flag is reported separately, including explicit columns in the Heckman table;
its caption states that no specification reaches [number withheld], with the observed maximum.
Dose is the firm-constant mean number of breached red lines over [number withheld]H1-[number withheld]H2
(at least three nonmissing dates), exactly as in T025.
Selection is fixed at that specification in the bootstrap, with both stages refit
in each of [number withheld] whole-firm draws. As the card requests re-estimation whatever the
results, a strongest admissible specification below [number withheld] still supplies the requested
sensitivity, clearly flagged weak rather than called usable. Only a lack of any
statistically admissible specification makes that outcome unavailable.
`t066_heckman.csv/.tex`, `t066_heckman_draws.csv`, `t066_selection_audit.csv` and
`t066_selected_first_stage.csv` document this two-stage sensitivity. Reporting-
weighted pre/post b and change use the selected RL1 reporting equation, inverse
post reporting probabilities floored at [number withheld] (maximum weight [number withheld]), unweighted pre,
and the unchanged polynomial estimator, with both stages re-estimated in the same
[number withheld] draws. This floor winsorizes weights rather than dropping reporting rows.
The distributional weights and effective N are in `t066_reporting_weighted_bunching.csv`.

Strength does not validate exclusion. Price can predict reporting through
suspension/delisting but also reflect distress and leverage; losses can predict
failure and reporting but directly affect equity/leverage; reporting history can
proxy disclosure capacity but also persistent distress. All estimates therefore
remain sensitivities conditional on unverified exclusion assumptions.

`t066_interpretation.csv` has one generated paragraph per analysis step, and
`t066_number_map.csv` links every summary numerical cell to file, exact row filter
and column. Large draw/firm tables retain explicit comparison/period/outcome/firm/
draw keys. `t066_dr_validation.csv` and `t066_validation.txt` document package and
simulation checks. `t066_verification.csv` guards every existing non-T066 output,
read-only input and existing raw file by SHA-[number withheld]. Results are staged; unchanged
input context requires byte-identical reruns of all CSV/TEX/PDF outputs, with PDF
timestamps suppressed. The AI-use log entry is proposed in the worker report;
editing the shared log is outside T066's write scope.

T066 Rework [number withheld] preserves the original [number withheld] output files as compressed bytes in
`t0[number withheld]_rework1_baseline.rds` (SHA-[number withheld] asserted in code). It is an immutable audit
input, not another analysis. `t066_preserved_rows.csv` checks byte identity of
all [number withheld] non-ownership main/average DR rows against that snapshot. The all-market
ownership bunching table and draws also retain their full original bytes.
`t066_rework1_old_new.csv` gives old/new values for every changed numeric or
logical cell in original CSV tables, including every changed bootstrap draw and
firm audit, joined on explicit keys. Added/removed rows are marked; the derived
number map duplicates those cells and is not diffed a second time. Integrity
hashes in verification are guard metadata and excluded from this result-cell diff.
`t066_rework1_change_summary.csv` lists row counts and changed-cell counts by
file. Generated interpretation step [number withheld] explicitly reports reporting-IPW b_post
and delta b with CIs and the weak first-stage caveat; step [number withheld] also discloses the
supplier-exclusion placebo-outcome intervals that exclude zero.

T066 Rework [number withheld] adds `t066_reporting_same_sample_bunching.csv`: weighted, unweighted
and weighted-minus-unweighted b_pre, b_post and delta b on exactly the same
[number withheld]-firm risk set (`sample_main` and nonmissing `dose_pre`), retaining the same
observed RL1 rows and T061 periods. The same histogram function is called with
reporting weights and with weights identically one. `t066_reporting_same_sample_draws.csv`
contains both estimates and their paired differences for the same [number withheld] draws,
including failure/warning fields. Percentile CIs for differences use draw-level
differences, never differences between CI endpoints. No resampling or first-stage
selection is added. The pre difference is exactly zero. The [number withheld]-firm main-sample
change of [number withheld] is a separate reproduction reference; its comparison with the
[number withheld]-firm weighted change does not isolate a weighting effect. Interpretation
step [number withheld] uses only the same-sample differences to assess weighting.
`t066_rework2_baseline.csv` freezes the prior output hashes;
`t066_rework2_preserved_outputs.csv` asserts byte identity of every other existing
T066 result, including the original reporting-weighted table, Heckman draws,
DR tables/figures, number map and Rework-[number withheld] old/new evidence. New same-sample
rows carry explicit method/metric filters; the frozen original number map stays
unchanged. Validation and input-hash metadata are regenerated.

### T072: consistent proposal and slide figures

Run `Rscript code/24_figures.R` from `replication/` (project-root equivalent:
`cd replication && Rscript code/24_figures.R`). It precedes step [number withheld] in both
`run_all.R` and `run_all.sh`. This offline rendering step preserves every existing
non-T072 output and every data file. By default it writes `f_*.pdf` and `t0[number withheld]_*` audit/bin CSVs under `outputs/`; slide PDFs are rendered in temporary storage for the unchanged font checks. `MTPA_INTEGRATE_PROPOSAL=[number withheld]` explicitly enables proposal figure copies and the `f_toc_nef.tex` wrapper; `MTPA_INTEGRATE_SLIDES=[number withheld]` independently enables slide copies. Both switches are off by default. Reading the existing conceptual-diagram source and bibliography under `proposal/` remains required. It does not rerun
the estimation scripts or change any model, sample, period, or estimator setting.

`code/theme_proposal.R` supplies Times/serif type, the course green palette,
subordinate grey and blue, bottom legends, and dashed dark RL1 threshold lines.
Paper graphics are [number withheld] x [number withheld] inches, two-panel graphics [number withheld] x [number withheld] inches; the
four/five-panel pre-trend pages are [number withheld] x [number withheld] inches. Slides are [number withheld] x [number withheld] inches
with [number withheld]-point text. Text in paper plots is [number withheld] points in the source PDF. The audit
computes the actual reduction from the A4 one-inch-margin text area, the inclusion
width and its height cap; the smallest empirical label is [number withheld] points in print.
`pdftohtml` font metadata is also checked, including the small-multiple pages,
so automatic base-R layout scaling cannot silently reduce the type size.

| New PDF stem | Proposal use | Numeric sources under `outputs/tables/` |
|---|---|---|
| `f_by_date` | Figure [number withheld] | `t041_bunching_by_date.csv`, `t063_by_date.csv` |
| `f_frozen_mi` | Figure [number withheld] | `t072_frozen_bins.csv`, validated against `t029_counterfactual_bunching.csv` and `t029_compliance.csv` |
| `f_excess_mass` | B1 | `t023_excess_mass_bins.csv` |
| `f_validation` | B2 | `t040_matched_observations.csv` |
| `f_measurement_error` | B3 | `t043_meas_error_draws.csv`, `t043_meas_error.csv`, `t072_simulation_bins.csv` |
| `f_control_density` | B4 | `t061_density_bins.csv`, `t061_estimates.csv` |
| `f_distributions_by_date` | B5/B6, pages [number withheld]/[number withheld] | `t063_by_date_histograms.csv` |
| `f_specification_curve` | B7 | `t058_grid.csv` |
| `f_crossing_decomposition` | B8 | `t027_decomposition_rl1.csv` |
| `f_kappa` | B9 | `t055_kappa.csv` |
| `f_overlap` | B1[number withheld]-B1[number withheld], pages [number withheld][number withheld] | `t066_overlap.csv`, `t072_overlap_bins.csv` |
| `f_pretrends` | B2[number withheld]-B2[number withheld], pages [number withheld][number withheld] | `t066_drdid.csv`, `t066_placebo_audit.csv` |
| `f_frozen_horizons` | available, not added to manuscript | `t041_frozen_horizons.csv` |
| `f_toc_nef` | Figure [number withheld], conceptual diagram | existing `proposal/figures/toc_nef.tex`; numeric-analysis exemption |
| `f_prisma` | B2[number withheld], unchanged diagram | byte copy of existing `outputs/figures/prisma.pdf` |

Figure [number withheld] uses the approved fallback: developers' observed-to-counterfactual
ratios and CIs are on the left axis; controls' saved observed window shares are
on the right. No control ratio series or CI series was saved; none is invented.
The caption explicitly distinguishes the units. The slide omits developer CIs.
B5/B6 retain all [number withheld] reporting dates, with [number withheld]H2 in a separate short top panel
and the remaining [number withheld] dates in a filled [number withheld] x [number withheld] grid. B7 sorts by the estimate in
[number withheld]-bin units and scales both CI endpoints by `bin_width / [number withheld]`; its indicator
matrix retains every specification. B8 uses component-median dots and an open
diamond for the median total, since medians need not add.

The PI's rendering-only reconstruction authorization in T072 is applied to
Figure [number withheld]. `24_figures.R` extracts the existing `read_panel` and `mass_fit`
assignment expressions verbatim from `11_mechanism.R`; it never sources that
script's writing code. The original panel, eligibility rules, paired sample,
end-[number withheld] anchor, [number withheld] grid, polynomial, [number withheld] firm draws and seed [number withheld] are
retained. Before saving `t072_frozen_bins.csv`, it asserts b, N, firm counts,
in-range counts, CIs and the compliance difference D against T029 at absolute
tolerance [number withheld]. All later drawing reads the saved bins. Missing simulation and
overlap histograms are reconstructed from their saved draws/observations using
the original `hist()` calls; the former are checked against saved simulation
means, percentiles and counts, and the latter against retained-firm counts.
These are rendering operations, not new estimates. `t072_slide_distribution_bins.csv`
aggregates the existing [number withheld] date bins for exactly [number withheld]H1[number withheld]H2 and
[number withheld]H1[number withheld]H2, dividing by all finite observations in the named dates.

`outputs/tables/t072_figure_audit.csv` records each PDF/page's source CSVs,
source-file SHA-[number withheld] hashes, a hash of the serialized plotting data, exact source
type size, computed minimum printed type size, and effective paper dimensions.
Diagram exceptions are explicit. The byte-preserved PRISMA diagram has an approximately [number withheld]-point minimum at its existing printed width; the card explicitly exempts that diagram from redesign. `t072_reconstruction_checks.csv` records the
numerical gates, `t072_pdf_font_check.csv` records the PDF font checks, and
`t072_verification.csv` records before/after SHA-[number withheld] for all protected outputs
and data/code inputs. The worker's two final runs are compared in
`t072_reproducibility.csv`; `t072_visual_check.csv` inventories the inspected PNG
pages and hashes. These last two CSVs are execution/visual-review evidence,
not model inputs or estimates.

When `MTPA_INTEGRATE_SLIDES=[number withheld]`, the five slide stems in `../presentation/slides/figures/` are `f_by_date`,
`f_frozen_mi`, `f_developer_control_density`, `f_kappa`, and
`f_distributions_pre_post`. Standard builds do not write to that directory.

Additional offline tools for this rendering step: XeLaTeX, BibTeX, the existing
Times New Roman font, and Poppler (`pdfinfo`, `pdftohtml`; `pdftoppm` for visual
review). They are already installed locally. The theory-of-change diagram is
compiled in a temporary directory from the existing TikZ source, with locally
resolved bibliography, fixed `SOURCE_DATE_EPOCH` and a fixed trailer ID. R PDF
timestamps are disabled. Build/PNG review artifacts belong in a temporary
directory, not among the immutable historical outputs.

Worker verification repeated on 2026-11-12: [number withheld] numerical gates passed at
absolute tolerance [number withheld]; [number withheld] historical outputs and [number withheld] data/code inputs were
unchanged. Two consecutive renderer runs produced [number withheld] byte-identical files
(including proposal copies and numeric audit CSVs). All [number withheld] PDF pages were
rendered to PNG and visually inspected. The proposal compiled successfully
with its main text ending on page [number withheld]; the only font warnings, concerning
Chinese italic substitution, were also present in the before-build. The
minimum printed empirical-figure type size is [number withheld] points. Temporary
builds and PNGs for this verification are in `/tmp/t0[number withheld]_current_build/` and
`/tmp/t0[number withheld]_current_png/`; the durable checks are the T072 CSVs and worker report.


### `25_hk_control.R` – accepted Hong Kong comparison (T076; build split T082)

Step [number withheld] follows step [number withheld] in both entry points. Run from `replication/`:

[fenced excerpt withheld in public process copy]
[fenced excerpt withheld in public process copy]

Standard mode authenticates every file against `data/raw/control_hk/MANIFEST.csv` (SHA-[number withheld] and byte size) and reads the internal copy first. Only a missing local raw file may fall back to the corresponding `../Daten/control/hk/` file, authenticated against the same manifest; it never creates or overwrites raw files. Inputs also include the unchanged main panel and accepted A-share/control references. The fixed T074 plan, seed, bootstrap order, samples and numerical code are retained. Statistical CSVs, the two table TEX files and `f_hk_control_density.pdf` are rebuilt byte-identically. `t082_hk_build_inputs.csv` and `t082_hk_build_reproducibility.csv` record this build; historical T076 manuscript-number, visual/build and integration attestations are preserved, not reissued as current manuscript claims.

Step [number withheld] in standard mode neither reads nor writes `../proposal`. The historical T076 text/table patching is available only with `MTPA_INTEGRATE_PROPOSAL=[number withheld]`; this is a one-off historical integration mode, not part of a normal build and not executed in T082. It can replace marked T076 manuscript blocks, so invoke it only under a separately authorized integration task. Its `--check-build` historical evidence mode also requires that explicit switch. No new inference is authorized by these switches. Step [number withheld] shares `MTPA_INTEGRATE_PROPOSAL` for figure/wrapper copies and has the independent `MTPA_INTEGRATE_SLIDES=[number withheld]` switch for slide copies. Leave both unset for normal replication.

Earlier T082 full-copy attempts are retained in `outputs/tables/t082_rebuild_check.csv` and the run-[number withheld] evidence. The final authorized scope is the four standalone tests described in “Reproduction status ([number withheld] Nov [number withheld])”, with original comparisons in `outputs/tables/t082_final_check.csv`, run-[number withheld] diagnostics in `t082_r6_check.csv`, and the approved correction/retest of [number withheld]/[number withheld] in `t082_r7_check.csv`; it does not establish a successful full rebuild. No build is run in the project itself. The sibling proposal and presentation trees in the copy are hashed before and after. The public archive (`../public_release/`) is unchanged and requires its own integration card.
