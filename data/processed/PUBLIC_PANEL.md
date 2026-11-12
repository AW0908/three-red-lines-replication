# Public panel provenance

Source: replication/data/processed/panel_firm_halfyear.csv (SHA-256 9b868659fbc52d2a5d67efb6a1889ca1bbd695731ca30bf17a0a5c3c54c1cb26).
01_clean.R lines 530–535 assign source eastmoney/wind and select whole rows with EastMoney priority. 01b_extend.R lines 687–690 derives Wind-only IDs from source history, matching the 34 removed IDs here. All firms with any Wind source row are removed, including their treatment history. No mixed-source firm occurs in this snapshot.
2279 rows → 1880 public rows, 150 firms; 12 columns removed → 77 retained.
The raw MANIFEST independently identifies excluded Wind extracts. Ownership fields are assigned from the export in 01_clean.R lines 342–396, final ownership coalesces Wind and manual coding in lines 787–790. Industry-based sample flags and exclusion/listing metadata are removed too. Firm IDs and names are public per the PI decision. Ratios and treatments retained on EastMoney-only firms use their EastMoney financial history.
This reduced panel is NOT an analysis substitute: scripts expecting sample_main or the full sample must use licensed inputs and rebuild the original panel. No original/ext panel is shipped.
