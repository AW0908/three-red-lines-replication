# Three Red Lines replication archive

Replication archive for the research proposal “Meeting the Red Lines: Threshold Targeting and Minority Equity among Chinese Property Developers” (Modern Tools for Policy Analysis, Peking University, Autumn 2026). When citing, give the commit hash and access date. No DOI is assigned.

## What can be reproduced

This is a restricted-data release: aggregated estimates and figures are included, but the full original results cannot be regenerated without licensed Wind extracts. No raw Wind extract, original full panel, or extended full panel is included. The reduced public panel is for inspection only; it removes Wind firms and Wind ownership / industry / membership fields. Do not rename it to the full panel or interpret reruns on it as reproducing the original sample.

The complete script → output → Wind yes/no table is [REPRODUCIBILITY.csv](REPRODUCIBILITY.csv). Safe offline components are setup, the A-share EastMoney raw audit and the simulation environment check. Fetch scripts require network/provider access and retain their historical paths; they are not part of an offline build. The PDF extractor requires separately obtained annual reports. All substantive main-pipeline estimates rely on the full panel, frozen industry membership or upstream Wind-dependent results. Published hand coding and control raw files are independently inspectable. No change to the research estimand, filters or sample was made to create substitute estimates.

## Layout

- `code/`: original analysis code, provenance helpers and `fetch/` downloads.
- `data/raw/`: EastMoney, Sina control data and own manual coding; third-party annual reports and announcements are excluded. `data/raw/manual/DOCUMENTS.md` lists recorded sources and pages.
- `data/processed/`: reduced public panel, removed IDs/columns and detailed provenance. `data/prices_2019.csv` is a convenience copy of the manual raw price file.
- `outputs/tables/`, `outputs/figures/`: permitted aggregate results and independently public files.
- `audit/`: sanitized historical cards, worker reports, reviews, approvals, runs and AI usage. Historical decisions may have been superseded. These are project-internal audit records, not other students' referee reports.
- `OUTPUT_INVENTORY.csv` and `WITHHELD.md`: pre-copy conflict classification, provenance and withheld files.
- `software/`: actual R session/package versions, Python environment versions; `environment.lock` records original build requirements.
- `validation/`: scan, isolated dry-run and unchanged-input evidence. `release_tools/` contains the offline release build/check code.
- `MANIFEST.csv`: size and SHA-256 of every payload file plus explicit withheld records. MANIFEST excludes itself to avoid a recursive hash; `.git/` is repository transport metadata and excluded.

## Running

From this directory, install the versions in `software/` / `environment.lock` separately, then run `bash run_all.sh` or `Rscript run_all.R`. Original entry points are preserved: they stop at `01_clean.R` when Wind inputs are absent, rather than silently producing different estimates. `00_setup.R` may install missing packages; install prerequisites separately before running offline.

For available offline checks: `Rscript --vanilla code/00_setup.R`; `python3 code/provenance/t001_audit_a_shares.py`; `Rscript --vanilla code/provenance/t007_r_setup_check.R`. Use a working copy; outputs and protection hashes are historical and some helpers expect pre-existing output directories. Isolated results and exact blockers are documented in `validation/DRY_RUN.md`.

Wind access: obtain an institutional/commercial Wind licence, export the exact workbooks/register specified in `code/01_clean.R` and `data/processed/PUBLIC_PANEL.md`, and place them locally under `data/raw/wind/` (never commit). Additional 2023–2024 EastMoney exports, external project data/PDF directories and literature-screening files may be required by later scripts; inspect their input gates. These out-of-archive dependencies are not supplied or fabricated. Fetchers and full project path compatibility are documented in the source. The full-build runtime has not been measured in this restricted archive; allow hours for bootstrap-heavy stages, depending on hardware. The measured offline check times are in `validation/DRY_RUN.md`; no full-reproduction claim is made.

## Hand collection and verification

The manual folder freezes coding tables, report/page excerpts, statement IDs, transaction grouping, extraction logs and verification CSVs. Annual-report balances and NCI flows were transcribed/extracted with original currency and page references; contract features use statement-level evidence and explicit unresolved categories. Verification fields record the author's checks; missing or pending evidence is retained as such. `registry_todo.csv` records outstanding registry work. See the coding/extraction logs and historical T032–T047 audit records for rules and limitations. Inclusion is not a claim that every pending item has been verified by the author. PDFs must be obtained from the original issuer/exchange; the document register marks missing URLs/pages.

Ownership manual coding is withheld in this rework because the authorized inputs do not provide complete primary-source evidence; see WITHHELD.md and data/raw/manual/DOCUMENTS.md. The other four flagged raw datasets have field provenance documented there, including the exclusion of panel_mi_check from the canonical cash-flow file.

## Privacy, licences and audit fidelity

Code: MIT (`LICENSE`). Own coding and outputs: CC BY 4.0, subject to the third-party caveats in `LICENSE-data.md`. EastMoney/AKShare and Sina data remain subject to provider terms; no additional provider permission is asserted. Wind material is excluded; only aggregate results derived from it (estimates, intervals, counts, figures) are published. The public audit replaces user directories with `<local>`, removes email/credential literals, and withholds fenced excerpts and firm-specific lines to avoid redistributing Wind observations. `validation/SANITIZATION.csv` records modified files. Original source hashes remain available for local review; public copies are intentionally not byte-identical where sanitized. No Git push was performed.
