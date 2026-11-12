"""T001: audit the approved A-Share sample without modifying source files.

Run from the project directory with:
    cd replication && python3 code/provenance/t001_audit_a_shares.py

CSV identifiers remain six-character strings. Import code as text when opening
the CSV in spreadsheet software (CSV itself has no column-type metadata).
First/last dates refer to observations with nonmissing, positive TOTAL_ASSETS.
Coverage counts nonmissing values, including zero; no missing values are imputed.
"""

import csv
import random
import sys
from pathlib import Path

# Do not create bytecode while auditing the local raw copies.
sys.dont_write_bytecode = True

import pandas as pd


SEED = 20261013
FIRM_INPUT = Path("data/raw/eastmoney/firm_list.csv")
BALANCE_INPUT = Path("data/raw/eastmoney/raw_a_balance.csv")
FIRM_OUTPUT = Path("docs/provenance/t001_a_firms.csv")
COVERAGE_OUTPUT = Path("docs/provenance/t001_a_field_coverage.csv")
FIELDS = [
    "TOTAL_ASSETS", "TOTAL_LIABILITIES", "ADVANCE_RECEIVABLES",
    "CONTRACT_LIAB", "MONETARYFUNDS", "SHORT_LOAN",
    "NONCURRENT_LIAB_1YEAR", "LONG_LOAN", "BOND_PAYABLE",
    "PERPETUAL_BOND", "OTHER_EQUITY_TOOL", "TOTAL_EQUITY",
    "MINORITY_EQUITY", "LONG_EQUITY_INVEST", "INVENTORY",
]
TARGET_DATES = pd.DatetimeIndex(
    ["2016-12-31"]
    + [f"{year}-{day}" for year in range(2017, 2023)
       for day in ("06-30", "12-31")]
)


def require(condition, message):
    if not condition:
        raise ValueError(message)


def write_csv(table, path):
    path.parent.mkdir(parents=True, exist_ok=True)
    table.to_csv(path, index=False, encoding="utf-8-sig",
                 quoting=csv.QUOTE_NONNUMERIC, lineterminator="\n")


def main():
    random.seed(SEED)  # Audit is deterministic; no random sampling is performed.
    firms = pd.read_csv(FIRM_INPUT, dtype={"code": "string"},
                        encoding="utf-8-sig", low_memory=False)
    balance = pd.read_csv(BALANCE_INPUT, dtype={"code": "string"},
                          encoding="utf-8-sig", low_memory=False)
    for table, columns, label in (
        (firms, ["code", "name", "board", "market", "fetched"], "firm_list"),
        (balance, ["code", "REPORT_DATE", *FIELDS], "raw_a_balance"),
    ):
        missing = sorted(set(columns) - set(table.columns))
        require(not missing, f"STOP: {label} missing columns: {missing}")

    a_firms = firms.loc[firms["market"].eq("A-Share"), ["code", "name"]].copy()
    require(len(a_firms) == 89, f"STOP: expected 89 A-Share firms, got {len(a_firms)}")
    require(not a_firms["code"].duplicated().any(), "STOP: duplicate firm-list codes")
    for table in (a_firms, balance):
        require(table["code"].str.fullmatch(r"[0-9]{6}").fillna(False).all(),
                "STOP: missing or non-six-digit A-Share code")

    missing_firms = sorted(set(a_firms["code"]) - set(balance["code"]))
    balance["REPORT_DATE"] = pd.to_datetime(balance["REPORT_DATE"], errors="raise")
    panel = balance.loc[balance["REPORT_DATE"].isin(TARGET_DATES)].copy()
    require(panel["code"].isin(a_firms["code"]).all(),
            "STOP: filtered balance contains codes outside the approved firm list")
    require(not panel.duplicated(["code", "REPORT_DATE"]).any(),
            "STOP: duplicate firm-date keys; no deduplication rule authorized")
    assets = pd.to_numeric(panel["TOTAL_ASSETS"], errors="raise")
    valid = panel.loc[assets.notna() & assets.gt(0)]
    dates = valid.groupby("code")["REPORT_DATE"].agg(
        n_stichtage="nunique", erster_stichtag="min", letzter_stichtag="max")
    result = a_firms.merge(dates, on="code", how="left", validate="one_to_one")
    result["n_stichtage"] = result["n_stichtage"].fillna(0).astype(int)
    for column in ("erster_stichtag", "letzter_stichtag"):
        result[column] = result[column].dt.strftime("%Y-%m-%d")
    result["b_share"] = result["code"].str.startswith(("200", "900"))
    require(result["n_stichtage"].between(0, 13).all(), "STOP: invalid date count")
    require(int(result["b_share"].sum()) == 9, "STOP: expected 9 B-Share firms")

    # The card explicitly requires missing firms to appear with zero dates,
    # but stops further work in that case (no coverage output is generated).
    if missing_firms:
        write_csv(result, FIRM_OUTPUT)
        raise ValueError(f"STOP: codes absent from balance data: {missing_firms}; "
                         f"zero-date firms included in {FIRM_OUTPUT}")

    n_total = len(panel)
    require(n_total > 0, "STOP: no observations on approved dates")
    present = panel[FIELDS].notna().sum().astype(int).to_dict()
    present["ADVANCE_OR_CONTRACT"] = int(
        panel[["ADVANCE_RECEIVABLES", "CONTRACT_LIAB"]].notna().any(axis=1).sum())
    coverage = pd.DataFrame([
        {"feld": field, "n_vorhanden": count, "n_gesamt": n_total,
         "anteil": count / n_total}
        for field, count in present.items()
    ])
    require(len(coverage) == 16 and coverage["anteil"].between(0, 1).all(),
            "STOP: invalid coverage table")
    write_csv(result, FIRM_OUTPUT)
    write_csv(coverage, COVERAGE_OUTPUT)
    print(f"Input: {len(balance)} balance rows; 89 A-Share firms; no absent codes")
    print(f"Filter: {len(TARGET_DATES)} dates, 2016-12-31 to 2022-12-31; {n_total} rows")
    print(f"Firm table: {len(result)} rows; 9 B-Shares; n_stichtage "
          f"{result.n_stichtage.min()} to {result.n_stichtage.max()}")
    print(f"Coverage table: {len(coverage)} rows; n_gesamt={n_total} throughout")
    print(f"Created: {FIRM_OUTPUT}")
    print(f"Created: {COVERAGE_OUTPUT}")


if __name__ == "__main__":
    try:
        main()
    except (ValueError, OSError) as error:
        print(error, file=sys.stderr)
        sys.exit(1)
