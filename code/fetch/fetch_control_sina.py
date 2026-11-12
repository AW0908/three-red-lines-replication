import sys
sys.dont_write_bytecode = True

import argparse
import os
import runpy
import time
from pathlib import Path

import pandas as pd

BASE = Path("Daten/control")
RAW = BASE / "raw_balance_sina"
ROSTER = BASE / "control_sina_roster.csv"

FIELDS = [
    "TOTAL_ASSETS",
    "TOTAL_LIABILITIES",
    "ADVANCE_RECEIVABLES",
    "CONTRACT_LIAB",
]

def save_atomic(df, path):
    tmp = path.with_suffix(".tmp")
    df.to_csv(tmp, index=False, encoding="utf-8-sig")
    os.replace(tmp, path)


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--limit", type=int, default=0)
    parser.add_argument("--roster", default=str(ROSTER))  # Co-PI 2026-11-01: coal add-on
    parser.add_argument("--tag", default="")  # Co-PI 2026-11-02: separate output set, e.g. finance
    args = parser.parse_args()

    if args.limit < 0:
        parser.error("--limit cannot be negative")

    global RAW
    sfx = f"_{args.tag}" if args.tag else ""
    RAW = BASE / f"raw_balance_sina{sfx}"
    RAW.mkdir(parents=True, exist_ok=True)

    module = runpy.run_path("Daten/fetch_control.py")
    fetch_balance = module["fetch_balance"]

    firms = pd.read_csv(args.roster, dtype={"code": str})
    firms["code"] = firms["code"].str.zfill(6)

    if firms["code"].duplicated().any():
        raise ValueError("Duplicate company codes in roster")

    if not set(["code", "name", "board"]).issubset(firms.columns):
        raise ValueError("Invalid roster")

    selected = firms.head(args.limit) if args.limit else firms

    print(f"Companies selected: {len(selected)}", flush=True)

    failures = []
    completed = 0
    skipped = 0

    for i, firm in enumerate(selected.itertuples(index=False), 1):
        code = firm.code
        path = RAW / f"{code}.csv"

        if path.exists():
            skipped += 1
            print(f"[{i}/{len(selected)}] {code}: saved")
            continue

        try:
            d = fetch_balance(code)

            if d.empty:
                raise ValueError("Empty balance sheet")

            if d["REPORT_DATE"].duplicated().any():
                raise ValueError("Duplicate report dates")

            if not set(FIELDS).issubset(d.columns):
                raise ValueError("Missing required columns")

            d.insert(0, "code", code)
            d.insert(1, "name", firm.name)
            d.insert(2, "board", firm.board)

            save_atomic(d, path)

            completed += 1

            print(
                f"[{i}/{len(selected)}] {code}: "
                f"{len(d)} periods saved",
                flush=True
            )

        except Exception as e:
            failures.append({
                "code": code,
                "error": str(e)
            })
            print(
                f"[{i}/{len(selected)}] {code}: ERROR {e}",
                flush=True
            )

        time.sleep(2)

    print("\nDOWNLOAD SUMMARY")
    print("Selected:", len(selected))
    print("Newly downloaded:", completed)
    print("Previously saved:", skipped)
    print("Failures:", len(failures))

    if failures:
        pd.DataFrame(failures).to_csv(
            BASE / f"balance_download_errors{sfx}.csv",
            index=False,
            encoding="utf-8-sig"
        )

    files = sorted(RAW.glob("*.csv"))

    if files:
        all_data = pd.concat(
            [
                pd.read_csv(p, dtype={"code": str})
                for p in files
            ],
            ignore_index=True
        )

        if all_data.duplicated(["code", "REPORT_DATE"]).any():
            raise ValueError("Duplicate firm-period observations")

        save_atomic(
            all_data,
            BASE / f"control_a_balance_sina{sfx}.csv"
        )

        print("Total saved companies:", all_data["code"].nunique())
        print("Total firm-periods:", len(all_data))
        print(
            "Combined dataset:",
            (BASE / f"control_a_balance_sina{sfx}.csv").resolve()
        )

    return 1 if failures else 0


if __name__ == "__main__":
    sys.exit(main())


