"""
MTPA – Three Red Lines: Coverage-Test der kostenlosen Datenquelle AKShare
-------------------------------------------------------------------------
Prüft, welche Bilanz-/GuV-Felder für chinesische Immobilienentwickler
(A-Shares + HK-gelistet) über AKShare (EastMoney) verfügbar sind,
Halbjahre 2016H2–2022H2.

Ausführen im normalen Mac-Terminal (nicht in einer Sandbox), im Ordner
dieser Datei:
    pip install --upgrade akshare pandas openpyxl
    python3 akshare_coverage_test.py

Output (im Unterordner ./akshare_output):
    raw_a_balance.csv, raw_a_income.csv, raw_hk_balance.csv, raw_hk_income.csv
    coverage_report.xlsx   -> Abdeckung je Feld (Anteil Firmen-Halbjahre mit Wert)
    firm_list.csv          -> Firmenliste mit Codes
Laufzeit: ca. 10–20 Minuten (Pausen gegen Rate-Limits).
"""

import os
import re
import sys
import time

import pandas as pd

import requests

# Globales Timeout für alle HTTP-Requests (AKShare setzt keins -> Hänger)
_orig_request = requests.sessions.Session.request


def _request_with_timeout(self, method, url, **kwargs):
    kwargs.setdefault("timeout", 20)
    return _orig_request(self, method, url, **kwargs)


requests.sessions.Session.request = _request_with_timeout

try:
    import akshare as ak
    from akshare.stock_feature.stock_three_report_em import (
        _stock_balance_sheet_by_report_ctype_em as em_ctype,
    )
except ImportError:
    sys.exit("AKShare fehlt: bitte zuerst  pip install --upgrade akshare  ausführen.")

HEADERS = {"User-Agent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7)"}
EM_BASE = "https://emweb.securities.eastmoney.com/PC_HSF10/NewFinanceAnalysis/"

OUT = os.path.join(os.path.dirname(os.path.abspath(__file__)), "akshare_output")
os.makedirs(OUT, exist_ok=True)

PERIODS = [f"{y}-{md}" for y in range(2016, 2023) for md in ("06-30", "12-31")]
PERIODS = [p for p in PERIODS if p >= "2016-12-31"]  # 2016H2 .. 2022H2 (13 Stichtage)
SLEEP = 0.8

# ---------------------------------------------------------------------------
# Vorläufige Liste HK-gelisteter Festlands-Entwickler (Codes ohne Gewähr –
# Fehlschläge werden im Report ausgewiesen und dann korrigiert)
# ---------------------------------------------------------------------------
HK_FIRMS = {
    "03333": "China Evergrande", "02007": "Country Garden", "01918": "Sunac",
    "00960": "Longfor", "00688": "China Overseas Land", "01109": "China Resources Land",
    "00813": "Shimao", "02777": "Guangzhou R&F", "03383": "Agile",
    "01813": "KWG", "03380": "Logan", "00123": "Yuexiu Property",
    "01638": "Kaisa", "00884": "CIFI", "01233": "Times China",
    "01777": "Fantasia", "03900": "Greentown", "01628": "Yuzhou",
    "01238": "Powerlong", "06158": "Zhenro", "03377": "Sino-Ocean",
    "00754": "Hopson", "00817": "China Jinmao", "00119": "Poly Property",
    "03301": "Ronshine", "00832": "Central China RE", "01107": "Modern Land",
    "01622": "Redco", "01966": "China SCE", "03990": "Midea Real Estate",
    "01030": "Seazen Group", "03883": "China Aoyuan", "02019": "Dexin China",
    "01862": "Jingrui", "09993": "Radiance",
    # 02768 Jiayuan: delistet, Code bei EastMoney neu vergeben -> über Wind holen
}

# ---------------------------------------------------------------------------
# Gesuchte Felder: Name -> Regex auf Spaltennamen (A-Share, EastMoney-Codes)
# bzw. auf STD_ITEM_NAME (HK, chinesische Bezeichnungen)
# ---------------------------------------------------------------------------
A_BAL_FIELDS = {
    "total_assets":        r"^TOTAL_ASSETS$",
    "total_liabilities":   r"^TOTAL_LIABILITIES$",
    "advance_receipts":    r"^ADVANCE_RECEIVABLES$|^ADVANCE_RECEIVE",
    "contract_liab":       r"^CONTRACT_LIAB$",
    "cash":                r"^MONETARYFUNDS$",
    "short_loan":          r"^SHORT_LOAN$",
    "noncurrent_liab_1y":  r"^NONCURRENT_LIAB_1YEAR$",
    "long_loan":           r"^LONG_LOAN$",
    "bonds_payable":       r"^BOND_PAYABLE$",
    "perpetual_bond":      r"PERPETUAL|^OTHER_EQUITY_TOOL$",
    "total_equity":        r"^TOTAL_EQUITY$",
    "parent_equity":       r"^TOTAL_PARENT_EQUITY$",
    "minority_equity":     r"^MINORITY_EQUITY$",
    "long_equity_invest":  r"^LONG_EQUITY_INVEST$",
    "inventory":           r"^INVENTORY$",
}
A_INC_FIELDS = {
    "net_profit":          r"^NETPROFIT$",
    "parent_net_profit":   r"^PARENT_NETPROFIT$",
    "minority_profit":     r"^MINORITY_INTEREST$",
    "revenue":             r"^TOTAL_OPERATE_INCOME$|^OPERATE_INCOME$",
    "invest_income_jv":    r"INVEST_JOINT_INCOME|^INVEST_INCOME$",
}
HK_BAL_FIELDS = {
    "total_assets":        r"^总资产$",
    "total_liabilities":   r"^总负债$",
    "advance_receipts":    r"预收",
    "contract_liab":       r"合同负债",
    "cash":                r"^现金及等价物$",
    "restricted_cash":     r"受限|受限制",
    "short_loan":          r"^短期贷款$",
    "long_loan":           r"^长期贷款$",
    "bonds_payable":       r"债券",
    "perpetual_bond":      r"永续|永久资本证券",
    "total_equity":        r"^总权益$|^股东权益$",
    "minority_equity":     r"少数股东权益|非控制性权益",
    "jv_associates":       r"合营|联营",
    "inventory":           r"存货|发展中物业|待售物业",
}
HK_INC_FIELDS = {
    "net_profit":          r"^除税后溢利$|^净利润$",
    "parent_net_profit":   r"股东应占溢利",
    "minority_profit":     r"少数股东损益|非控制性权益",
    "revenue":             r"^营业额$|^营运收入$",
    "invest_income_jv":    r"合营|联营",
}


def norm_date(s):
    return pd.to_datetime(s, errors="coerce").strftime("%Y-%m-%d")


def a_share_list():
    """A-Share Immobilienentwickler über EastMoney-Branchenboard."""
    for board in ("房地产开发", "房地产"):
        try:
            df = ak.stock_board_industry_cons_em(symbol=board)
            df = df.rename(columns={"代码": "code", "名称": "name"})[["code", "name"]]
            df["board"] = board
            print(f"[A] Board '{board}': {len(df)} Firmen")
            return df
        except Exception as e:
            print(f"[A] Board '{board}' nicht abrufbar: {e}")
    return pd.DataFrame(columns=["code", "name", "board"])


def em_symbol(code):
    return ("SH" if code.startswith(("6", "9")) else "SZ") + code


def em_get(endpoint, params, tries=3):
    """EastMoney-Request mit Timeout + Retries."""
    for t in range(tries):
        try:
            r = requests.get(EM_BASE + endpoint, params=params, headers=HEADERS, timeout=20)
            return r.json()
        except Exception as e:
            if t == tries - 1:
                raise
            time.sleep(2 * (t + 1))


def em_sheet(sym, ctype, endpoint):
    """Nur die 13 benötigten Halbjahres-Stichtage (3 Requests statt ~23)."""
    frames = []
    for i in range(0, len(PERIODS), 5):
        params = {"companyType": ctype, "reportDateType": "0", "reportType": "1",
                  "dates": ",".join(PERIODS[i:i + 5]), "code": sym}
        js = em_get(endpoint, params)
        if js and js.get("data"):
            frames.append(pd.DataFrame(js["data"]))
        time.sleep(0.3)
    return pd.concat(frames, ignore_index=True) if frames else pd.DataFrame()


def fetch_a(codes):
    bal, inc = [], []
    for i, c in enumerate(codes, 1):
        sym = em_symbol(c)
        try:
            ctype = em_ctype(symbol=sym)
        except Exception as e:
            print(f"  [A] {c}: Firmentyp nicht abrufbar ({e})")
            continue
        for kind, endpoint, store in (("balance", "zcfzbAjaxNew", bal),
                                      ("income", "lrbAjaxNew", inc)):
            try:
                d = em_sheet(sym, ctype, endpoint)
                if not d.empty:
                    d["code"] = c
                    store.append(d)
            except Exception as e:
                print(f"  [A] {c} {kind}: Fehler {e}")
        print(f"  [A] {i}/{len(codes)} {c} ok", flush=True)
        time.sleep(SLEEP)
    return (pd.concat(bal, ignore_index=True) if bal else pd.DataFrame(),
            pd.concat(inc, ignore_index=True) if inc else pd.DataFrame())


def fetch_hk(codes):
    bal, inc = [], []
    for i, c in enumerate(codes, 1):
        for kind, sheet, store in (("balance", "资产负债表", bal), ("income", "利润表", inc)):
            try:
                d = ak.stock_financial_hk_report_em(stock=c, symbol=sheet, indicator="报告期")
                d["code"] = c
                store.append(d)
            except Exception as e:
                print(f"  [HK] {c} {kind}: Fehler {e}")
            time.sleep(SLEEP)
        print(f"  [HK] {i}/{len(codes)} {c} ok", flush=True)
    return (pd.concat(bal, ignore_index=True) if bal else pd.DataFrame(),
            pd.concat(inc, ignore_index=True) if inc else pd.DataFrame())


def coverage_wide(df, fields, n_firms, label):
    """A-Share: breite Tabelle, eine Spalte je Posten."""
    rows = []
    if df.empty:
        return pd.DataFrame([{"market": label, "field": f, "matched_column": None,
                              "coverage": 0.0} for f in fields])
    df = df.copy()
    df["period"] = df["REPORT_DATE"].map(norm_date)
    df = df[df["period"].isin(PERIODS)]
    denom = n_firms * len(PERIODS)
    for f, pat in fields.items():
        cols = [c for c in df.columns if re.search(pat, str(c))]
        if not cols:
            rows.append({"market": label, "field": f, "matched_column": None, "coverage": 0.0})
            continue
        best = max(cols, key=lambda c: df[c].notna().sum())
        cov = df.loc[df[best].notna() & (df[best] != 0), ["code", "period"]].drop_duplicates()
        rows.append({"market": label, "field": f, "matched_column": best,
                     "coverage": round(len(cov) / denom, 3)})
    return pd.DataFrame(rows)


def coverage_long(df, fields, n_firms, label):
    """HK: lange Tabelle (STD_ITEM_NAME, AMOUNT)."""
    rows = []
    if df.empty:
        return pd.DataFrame([{"market": label, "field": f, "matched_column": None,
                              "coverage": 0.0} for f in fields])
    df = df.copy()
    df["period"] = df["REPORT_DATE"].map(norm_date)
    df = df[df["period"].isin(PERIODS)]
    items = df["STD_ITEM_NAME"].dropna().unique()
    denom = n_firms * len(PERIODS)
    for f, pat in fields.items():
        hits = [it for it in items if re.search(pat, str(it))]
        if not hits:
            rows.append({"market": label, "field": f, "matched_column": None, "coverage": 0.0})
            continue
        sub = df[df["STD_ITEM_NAME"].isin(hits) & df["AMOUNT"].notna()]
        cov = sub[["code", "period"]].drop_duplicates()
        rows.append({"market": label, "field": f, "matched_column": " | ".join(hits[:4]),
                     "coverage": round(len(cov) / denom, 3)})
    return pd.DataFrame(rows)


def main():
    print("== A-Shares ==")
    a_list = a_share_list()
    a_bal, a_inc = fetch_a(a_list["code"].tolist())
    print("== Hongkong ==")
    hk_bal, hk_inc = fetch_hk(list(HK_FIRMS))

    for name, d in (("raw_a_balance", a_bal), ("raw_a_income", a_inc),
                    ("raw_hk_balance", hk_bal), ("raw_hk_income", hk_inc)):
        d.to_csv(os.path.join(OUT, f"{name}.csv"), index=False, encoding="utf-8-sig")

    hk_ok = set(hk_bal["code"]) if not hk_bal.empty else set()
    a_ok = set(a_bal["code"]) if not a_bal.empty else set()
    firms = pd.concat([
        a_list.assign(market="A-Share", fetched=a_list["code"].isin(a_ok)),
        pd.DataFrame({"code": list(HK_FIRMS), "name": list(HK_FIRMS.values()),
                      "board": "manuell", "market": "HK",
                      "fetched": [c in hk_ok for c in HK_FIRMS]}),
    ], ignore_index=True)
    firms.to_csv(os.path.join(OUT, "firm_list.csv"), index=False, encoding="utf-8-sig")

    cov = pd.concat([
        coverage_wide(a_bal, A_BAL_FIELDS, max(len(a_ok), 1), "A-Share Bilanz"),
        coverage_wide(a_inc, A_INC_FIELDS, max(len(a_ok), 1), "A-Share GuV"),
        coverage_long(hk_bal, HK_BAL_FIELDS, max(len(hk_ok), 1), "HK Bilanz"),
        coverage_long(hk_inc, HK_INC_FIELDS, max(len(hk_ok), 1), "HK GuV"),
    ], ignore_index=True)

    hk_items = (hk_bal[["STD_ITEM_NAME"]].drop_duplicates().sort_values("STD_ITEM_NAME")
                if not hk_bal.empty else pd.DataFrame())
    with pd.ExcelWriter(os.path.join(OUT, "coverage_report.xlsx")) as xw:
        cov.to_excel(xw, sheet_name="Coverage", index=False)
        firms.to_excel(xw, sheet_name="Firmen", index=False)
        hk_items.to_excel(xw, sheet_name="HK_Bilanzposten", index=False)

    print("\n== Ergebnis ==")
    print(f"A-Shares geladen: {len(a_ok)}/{len(a_list)} | HK geladen: {len(hk_ok)}/{len(HK_FIRMS)}")
    print(cov.to_string(index=False))
    print(f"\nDateien in: {OUT}")


if __name__ == "__main__":
    main()
