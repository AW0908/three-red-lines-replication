# Original-language hand-collected fields

The fields listed below contain original-language material, including German working notes by the principal investigator (PI), Chinese source quotations, names, units or original file references. They are retained verbatim for reproducibility; their presence is not fresh verification. Some matches are names or identifiers rather than free text.

- `announcements_triage.csv`: `evidence_excerpt`, `file`, `reason`, `title`.
- `case_notes_verification.csv`: `auto_found`, `auto_missing`, `comment`, `statement`.
- `contract_hits.csv`: `excerpt`, `printed_page`, `term`.
- `crossers_coding.csv`: `amount_excerpt`, `amount_original`, `amount_unit`, `consolidation`, `equity_transfer_price_original`, `file`, `notes`, `own_group_excerpt`, `own_group_file`, `ownership_file`, `partner`, `reason`, `subsidiary`, `transaction_kind`, `unrelated_prorata_excerpt`, `unrelated_prorata_file`.
- `nci_cashflow.csv`: `printed_page`, `statement_label`.
- `nci_cashflow_all.csv`: `excerpt`, `note`, `unit_printed`.
- `nci_subsidiaries.csv`: `balance_summary_printed_page`, `consolidated_nci_printed_page`, `income_summary_printed_page`, `printed_page`, `subsidiary_name`.
- `pilot_coding.csv`: `amount_excerpt`, `amount_file`, `amount_original`, `amount_unit`, `consolidation`, `equity_transfer_price_file`, `equity_transfer_price_original`, `file`, `investor_put_excerpt`, `investor_put_file`, `issuer_call_excerpt`, `issuer_call_file`, `issuer_call_preset_price_excerpt`, `issuer_call_preset_price_file`, `mandatory_buyback_redemption_excerpt`, `mandatory_buyback_redemption_file`, `market_value_exit_excerpt`, `market_value_exit_file`, `notes`, `own_group_excerpt`, `own_group_file`, `ownership_file`, `paid_excerpt`, `partner`, `partner_relation`, `preferred_dividends_excerpt`, `preferred_dividends_file`, `preset_exit_not_project_value_excerpt`, `preset_exit_not_project_value_file`, `profit_target_excerpt`, `profit_target_file`, `subsidiary`, `total_funding_original`, `transaction_group_id`, `undecided_feature_excerpt`, `undecided_feature_file`, `unrelated_prorata_excerpt`, `unrelated_prorata_file`.
- `registry_todo.csv`: `previous_subsidiary_name`, `printed_page`, `subsidiary_name`.
- `rl1_published.csv`: `verbatim_wording`.
- `transactions.csv`: `actual_guarantor_source`, `amount`, `amount_basis`, `bill_issuer_alias`, `cash_from_nci_same_period_json`, `counterparty_name`, `counterparty_ownership_after_pct`, `currency`, `current_shareholding_source`, `equity_transfer_amount`, `existing_minority_holder`, `exit_deadline_excerpt`, `field_evidence_json`, `file`, `fixed_guaranteed_return_excerpt`, `keeps_control_consolidation`, `listed_firm_guarantee_excerpt`, `loan_interest_rule`, `nci_balance_changes_json`, `notes`, `preferred_dividend_performance_target`, `put_redemption_excerpt`, `relation_to_listed_firm`, `repurchase_buyback_excerpt`, `section_source_excerpt`, `shareholder_loans_surplus_draw_excerpt`, `shortfall_makeup_excerpt`, `subsidiary`, `t032_nci_links_json`, `t032_registry_links_json`, `transaction_kind`.

`code/16_pilot_magnitude.R` embeds verification records, including their `comment`, `auto_found`, `auto_missing` and `statement` fields, verbatim. Its informal PI comments are candidates for a separate PI decision; removing them requires a separate card.

The fetch scripts also retain original German runtime messages and output labels as string literals. `akshare_coverage_test.py` uses Chinese names, regular expressions and sheet labels to query and interpret the provider data. These executable strings are preserved to avoid changing behavior; they are not hand-coded observations.
