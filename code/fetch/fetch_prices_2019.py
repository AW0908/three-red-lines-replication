"""Closing share prices of A-share and Hong Kong developers in December 2019.
Co-PI 2026-11-02, for the Heckman exclusion restriction. Run by the PI (no VPN).
Tries several AKShare sources per firm because single providers are often unreachable."""
import socket, time, pandas as pd, requests
_orig = requests.sessions.Session.request
def _req(self, method, url, **kw):          # AKShare sets no timeout -> hangs
    kw["timeout"] = 15
    return _orig(self, method, url, **kw)
requests.sessions.Session.request = _req
socket.setdefaulttimeout(20)
import akshare as ak
from pathlib import Path

out = Path("Daten/control/prices_2019.csv")
for host in ("finance.sina.com.cn", "web.ifzq.gtimg.cn", "push2his.eastmoney.com"):
    try:
        print("DNS", host, socket.getaddrinfo(host, 443)[0][4][0])
    except Exception as e:
        print("DNS", host, "FAILED", e)

def last_close(p, dcol, ccol):
    p = p.copy(); p[dcol] = p[dcol].astype(str).str[:10]
    p = p[(p[dcol] >= "2019-12-01") & (p[dcol] <= "2019-12-31")].sort_values(dcol)
    if p.empty:
        raise ValueError("no December 2019 rows")
    return p.iloc[-1][dcol], float(p.iloc[-1][ccol])

def a_sources(code, ex):
    sym = ("sh" if ex == "SH" else "sz") + code
    yield "tencent", lambda: last_close(ak.stock_zh_a_hist_tx(symbol=sym, start_date="20191201", end_date="20191231", adjust=""), "date", "close")
    yield "sina", lambda: last_close(ak.stock_zh_a_daily(symbol=sym, start_date="20191201", end_date="20191231", adjust=""), "date", "close")
    yield "eastmoney", lambda: last_close(ak.stock_zh_a_hist(symbol=code, period="daily", start_date="20191201", end_date="20191231", adjust=""), "日期", "收盘")

def hk_sources(code):
    c = code.zfill(5)
    yield "sina", lambda: last_close(ak.stock_hk_daily(symbol=c, adjust=""), "date", "close")
    yield "eastmoney", lambda: last_close(ak.stock_hk_hist(symbol=c, period="daily", start_date="20191201", end_date="20191231", adjust=""), "日期", "收盘")

d = pd.read_csv("replication/data/processed/panel_firm_halfyear.csv", usecols=["firm_id", "sample_main"], dtype=str)
ids = sorted(d.loc[d.sample_main.str.upper() == "TRUE", "firm_id"].unique())
rows = []
done = {}
if out.exists():
    prev = pd.read_csv(out, dtype={"firm_id": str})
    prev = prev[prev["close"].notna()]
    rows = prev.to_dict("records"); done = set(prev["firm_id"])
    print("resume:", len(done), "firms already saved")
for i, fid in enumerate(ids, 1):
    if fid in done:
        continue
    code, ex = fid.split(".")
    srcs = a_sources(code, ex) if ex in ("SH", "SZ") else hk_sources(code)
    errs = []
    for name, fn in srcs:
        try:
            dt, close = fn()
            rows.append({"firm_id": fid, "source": name, "price_date": dt, "close": close, "currency": "RMB" if ex in ("SH", "SZ") else "HKD", "error": ""})
            print(f"[{i}/{len(ids)}] {fid}: {close} ({name})")
            break
        except Exception as e:
            errs.append(f"{name}: {str(e)[:80]}")
    else:
        rows.append({"firm_id": fid, "source": "", "price_date": "", "close": None, "currency": "", "error": " | ".join(errs)})
        print(f"[{i}/{len(ids)}] {fid}: ERROR {' | '.join(errs)}")
    pd.DataFrame(rows).to_csv(out, index=False, encoding="utf-8-sig")
    time.sleep(0.8)
pd.DataFrame(rows).to_csv(out, index=False, encoding="utf-8-sig")
print("saved", out, "errors:", sum(str(r.get("error", "")) not in ("", "nan") for r in rows))
