"""
Downloads balance-sheet and income-statement data for DELISTED developers via AKShare
(list: delistete_immobilienfirmen.csv, filtered from Wind exports).
Codes marked "!" (reassigned after delisting) are skipped; use Wind.

Run in the Daten directory with the virtual environment active:
    source .venv/bin/activate
    python fetch_delisted.py
"""
import os
import pandas as pd
import akshare_coverage_test as t   # uses the same functions (timeout, only 13 reporting dates)

HERE = os.path.dirname(os.path.abspath(__file__))
OUT = os.path.join(HERE, "akshare_output")
lst = pd.read_csv(os.path.join(HERE, "delistete_immobilienfirmen.csv"), dtype=str)
lst = lst[lst["reused_code"] == "False"]

a_codes = [c.split(".")[0] for c in lst.loc[lst.market == "A", "code"]]
hk_codes = [c.split(".")[0].zfill(5) for c in lst.loc[lst.market == "HK", "code"]]
print(f"A: {len(a_codes)} Firmen, HK: {len(hk_codes)} Firmen")

a_bal, a_inc = t.fetch_a(a_codes)
hk_bal, hk_inc = t.fetch_hk(hk_codes)
for name, d in (("delisted_a_balance", a_bal), ("delisted_a_income", a_inc),
                ("delisted_hk_balance", hk_bal), ("delisted_hk_income", hk_inc)):
    d.to_csv(os.path.join(OUT, f"{name}.csv"), index=False, encoding="utf-8-sig")

def n(d):
    return 0 if d.empty else d["code"].nunique()
print(f"\nGeladen: A-Bilanz {n(a_bal)}/{len(a_codes)}, HK-Bilanz {n(hk_bal)}/{len(hk_codes)}")
print("Fertig. Dateien in", OUT)
