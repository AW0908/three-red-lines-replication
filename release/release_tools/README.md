# Release presentation tools

## Current website build (T093)

From the original project root:

```bash
python3 public_release/release/release_tools/build_release.py
python3 public_release/release/release_tools/check_release.py
```

The current builder uses `t093_site.py` and `site_template.html`. It regenerates
only `docs/index.html`, the root README's Pages link, and the website's numeric
and link evidence. Chart counts and all seven results-map fields come exclusively
from archived CSVs. The supplied template is retained byte-for-byte; generation
also splits the one multi-source map cell into separate links without changing
layout, captions or scientific wording. The approved preview has identical markup
after removing its embedded preview data.

The approved review revision retains the D-category split (D1: 1, D2: 2,
unspecified: 1), the compliance denominator (602 firm-half-years, 129 developers)
and the estimator's exact pre/post calendar labels. These values are checked
against the permitted proposal excerpts, archived compliance table and archived
estimator. The JavaScript check also verifies the rendered contract rows and
period titles.

The approved Files section links to six archive folders, the repository and its
main-branch ZIP. Folder existence and contents are checked offline. The displayed
size is about 0.5 decimal GB unpacked, computed from the MANIFEST's included
payload bytes, excluding the manifest itself and withheld entries. No compressed
ZIP size or HTTP availability is asserted. The earlier ZIP-size stop receipt and
numeric audit are retained under validation and its history folder.

`T093_NUMBERS.csv` records scientific values, visible numeric occurrences, chart
ticks, metadata and explicitly cited literature context. The allowed proposal
excerpts retain their exact source lines and SHA-256 in `T093_PROPOSAL_RECEIPT.json`.
The checker reuses the existing safety gates and scientific freezes, then checks
the approved language revision snapshot `T093_R6_BEFORE.json` rather than T091's historical
worker handoff. Earlier snapshots and the historical review baseline remain
intact. The scope evidence reports current-run integrity separately from the
documented historical input drift, which still requires a PI decision in the
regular review. `T093_FILE_CHANGES.csv` retains the cumulative file ledger;
`T093_R1_FILE_CHANGES.csv` records changes since the first review revision;
`T093_R5_FILE_CHANGES.csv` records changes since the corrected Files revision;
`T093_R6_FILE_CHANGES.csv` records this language revision alone.
`T093_SCIENTIFIC_HASHES.csv` verifies all code/data/output
files against the existing commit `6ab039d` without running a Git command.

Maintained full checks require the original project's read-only inputs, Poppler
and Node.js. The JavaScript check runs the delivered script in a minimal DOM and
checks charts, filters, search and clipboard fallback; it is not a browser render.
Reader inspection remains read-only, offline, and Python-standard-library only:

```bash
python3 release/release_tools/inspect_release.py
python3 release/release_tools/path_check.py --task T093
```

Run the last command twice from the release directory, at least two minutes apart.
It checks the full manifest before and after recording the path-check evidence.
All GitHub links are checked against local archive targets; no HTTP request is
made. The website needs no external assets. A byte-identical rebuild requires no
licensed financial observations; full release safety checks still use the original
read-only project inputs described above.

## Historical T091 implementation

The following description documents the retained T091 migration and presentation
code. It is superseded by the T093 builder for the start page.

Run the maintained build/check from the original project root, with the delivered public archive and read-only proposal/project inputs present:

```bash
python3 public_release/release/release_tools/build_release.py
python3 public_release/release/release_tools/check_release.py
```

The build preserves the delivered T084 scientific payload, migrates metadata using PATH_MAP.csv, walks the proposal input graph, and regenerates documentation and the static start page. It never runs an analysis or a fetcher. The checker repeats source/accepted-freeze, privacy, licensed-field, output, path, scope and documentation checks, then regenerates the manifest. The retained T084 process source inventory is verified either directly or by reversing the documented Markdown-format changes. Baselines are not reset.

For the exact legacy command in T091 only, run the maintained builder with `--legacy-entrypoints` first. It stages temporary entry shims under the old path; the legacy checker relocates them before scanning. No old top-level tool directory remains. Ordinary rebuilds use the maintained paths above.

Reader checks work independently from the release directory: `python3 release/release_tools/inspect_release.py`. This is read-only and uses only the Python standard library. After the maintained check, run `python3 release/release_tools/path_check.py` from the release directory twice, at least two minutes apart; it verifies the manifest before sealing its evidence into the refreshed manifest and verifying again.

`t084_build.py`, `t073_check.py`, `t084_verify.py` and `dry_run.py` retain historical implementation context and earlier path conventions; they are not entry points for this layout. T091 reuses the fail-closed T073/T084 safety gates with current paths and the frozen T091 baseline. Full scientific reproduction and the prior isolated scientific component checks are not rerun by a presentation build. No network, Git command or publication is performed.
