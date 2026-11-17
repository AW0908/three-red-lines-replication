# Data and sources

[Public panel provenance](processed/PUBLIC_PANEL.md) · [Removed columns](processed/REMOVED_COLUMNS.csv) · [Removed firm IDs](processed/REMOVED_FIRMS.csv) · [Raw input manifest](raw/MANIFEST.csv)

`raw/eastmoney/` contains public statements; `raw/control/` contains Sina rosters and EastMoney controls; `raw/control_hk/` contains HKEX listings and public EastMoney statements with a checked manifest. These controls come from public sources. `raw/manual/` contains hand-coded records and the canonical [prices](raw/manual/prices_2019.csv); the unused duplicate was removed.

The manual tables retain report/page excerpts, statement IDs, transaction grouping, extraction logs, original currency and verification flags. Contract terms use statement-level evidence and unresolved categories. Missing/pending principal investigator (PI) checks remain pending: inclusion is not a new verification. `registry_todo.csv` records outstanding registry work. Consult the [document register](raw/manual/DOCUMENTS.md), coding logs and [historical task records](../process/tasks/); absent page/URL information is explicit. Obtain third-party annual reports and announcements from issuers/exchanges; PDFs are not distributed.

`processed/` is for inspection: every Wind-sourced firm and the recorded ownership/industry/sample columns were removed. It is not the full analysis panel or an alternative estimation sample. Wind exports, full and extended panels, ownership coding without complete primary provenance, firm-specific Wind-derived outputs and the two validation scatterplots remain withheld. The exclusion of `panel_mi_check` from canonical cash-flow coding and other flagged raw-file provenance is documented in the manual register.

[Withheld files](../docs/WITHHELD.md) · [Licenses](../LICENSE-data.md). Own coding/outputs are CC BY 4.0, subject to third-party rights; EastMoney/AKShare, Sina and HKEX provider terms still apply. No Wind license or new permission to redistribute third-party excerpts is granted.
