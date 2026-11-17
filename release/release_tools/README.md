# Release presentation tools

Run the maintained build/check from the original project root, with the delivered public archive and read-only proposal/project inputs present:

```bash
python3 public_release/release/release_tools/build_release.py
python3 public_release/release/release_tools/check_release.py
```

The build preserves the delivered T084 scientific payload, migrates metadata using PATH_MAP.csv, walks the proposal input graph, and regenerates documentation and the static start page. It never runs an analysis or a fetcher. The checker repeats source/accepted-freeze, privacy, licensed-field, output, path, scope and documentation checks, then regenerates the manifest. The retained T084 process source inventory is verified either directly or by reversing the documented Markdown-format changes. Baselines are not reset.

For the exact legacy command in T091 only, run the maintained builder with `--legacy-entrypoints` first. It stages temporary entry shims under the old path; the legacy checker relocates them before scanning. No old top-level tool directory remains. Ordinary rebuilds use the maintained paths above.

Reader checks work independently from the release directory: `python3 release/release_tools/inspect_release.py`. This is read-only and uses only the Python standard library. After the maintained check, run `python3 release/release_tools/path_check.py` from the release directory twice, at least two minutes apart; it verifies the manifest before sealing its evidence into the refreshed manifest and verifying again.

`t084_build.py`, `t073_check.py`, `t084_verify.py` and `dry_run.py` retain historical implementation context and earlier path conventions; they are not entry points for this layout. T091 reuses the fail-closed T073/T084 safety gates with current paths and the frozen T091 baseline. Full scientific reproduction and the prior isolated scientific component checks are not rerun by a presentation build. No network, Git command or publication is performed.
