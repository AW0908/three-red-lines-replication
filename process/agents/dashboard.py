#!/usr/bin/env python3
"""Live-Dashboard des Agenten-Teams.

    python3 agents/dashboard.py          # öffnet http://localhost:8765
    python3 agents/dashboard.py --port 9000 --no-browser

Liest nur: tasks/, review/, state/. Schreibt nichts ins Projekt und nichts nach state/terminal.log.
Die Seite fragt alle 3 Sekunden /api/state ab. Beenden mit Ctrl+C.
"""
import argparse
import json
import os
import re
import subprocess
import sys
import threading
import time
import webbrowser
from datetime import datetime
from http.server import BaseHTTPRequestHandler, ThreadingHTTPServer
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
TASKS, REVIEW, STATE = ROOT / "tasks", ROOT / "review", ROOT / "state"

RUN_RE = re.compile(r"^(\d{4}-\d{2}-\d{2} \d{2}:\d{2}) (T\d{3}) (worker|reviewer)(?:\[(\w+)\])? (\S+) (\S+)(?: \(priority (\w+)\))?\s*(PASS|REWORK|ESCALATE)?\s*$")
APPROVAL_RE = re.compile(r"^(\d{4}-\d{2}-\d{2} \d{2}:\d{2}) (T\d{3}) (\w+) \(PI[^)]*\)(?: OVERRIDE: (.*))?$")
TERM_HEAD_RE = re.compile(r"^===== (\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2}) \$ agents/(\S+)\s*(.*)$")
TOOL_NAMES = {"codex": "Codex", "claude": "Claude (Text)", "agy": "Antigravity"}


def read(p):
    try:
        return p.read_text(encoding="utf-8", errors="replace")
    except OSError:
        return ""


def front_matter(text):
    out = {}
    m = re.match(r"^---\n(.*?)\n---", text, re.S)
    if m:
        for line in m.group(1).splitlines():
            if ":" in line:
                k, v = line.split(":", 1)
                out[k.strip()] = v.strip()
    return out


def codex_log_info(p):
    """Tokens und Modell aus einem Codex-Protokoll (enthält nur den letzten Lauf)."""
    t = read(p)
    if not t:
        return None
    toks = re.findall(r"^tokens used\n([\d,.  ]+)$", t, re.M)
    model = re.search(r"^model: (.+)$", t, re.M)
    effort = re.search(r"^reasoning effort: (.+)$", t, re.M)
    if not toks and not model:
        return None
    return {
        "tokens": int(re.sub(r"\D", "", toks[-1])) if toks else None,
        "model": model.group(1).strip() if model else None,
        "effort": effort.group(1).strip() if effort else None,
        "mtime": p.stat().st_mtime,
    }


def file_info(p):
    try:
        st = p.stat()
        return {"path": str(p.relative_to(ROOT)), "size": st.st_size, "mtime": st.st_mtime}
    except OSError:
        return None


def running_processes():
    try:
        out = subprocess.run(["ps", "-axo", "pid=,etime=,command="], capture_output=True, text=True, timeout=3).stdout
    except Exception:
        return []
    procs = []
    for line in out.splitlines():
        parts = line.strip().split(None, 2)
        if len(parts) < 3:
            continue
        pid, etime, cmd = parts
        tool = None
        if re.search(r"(^|/)codex(\s|$)", cmd) and " exec" in cmd:
            tool = "codex"
        elif re.search(r"(^|/)claude(\s|$)", cmd) and " -p" in cmd:
            tool = "claude"
        elif re.search(r"(^|/)agy(\s|$)", cmd):
            tool = "agy"
        if tool:
            procs.append({"pid": pid, "etime": etime, "tool": tool})
    return procs


def terminal_blocks():
    lines = read(STATE / "terminal.log").splitlines()
    blocks, cur = [], None
    for ln in lines:
        m = TERM_HEAD_RE.match(ln)
        if m:
            cur = {"ts": m.group(1), "script": m.group(2), "args": m.group(3).strip(), "out": []}
            blocks.append(cur)
        elif cur is not None and ln.strip():
            cur["out"].append(ln)
    return blocks, lines


def provider_policy():
    roles = ("worker", "co-pi", "data", "estimation", "consistency", "language", "general")
    result = subprocess.run(["bash", "-c", 'source agents/providers.sh; for role in worker co-pi data estimation consistency language general; do select_provider "$role" || exit; done'], cwd=ROOT, capture_output=True, text=True, timeout=3)
    values = result.stdout.splitlines()
    if result.returncode or len(values) != len(roles):
        return {role: "CONFIG ERROR" for role in roles}
    return dict(zip(roles, values))


def collect():
    now = time.time()
    policy = provider_policy()
    tasks = {}
    for card in sorted(TASKS.glob("T[0-9][0-9][0-9].md")):
        fm = front_matter(read(card))
        tid = fm.get("id", card.stem)
        rev_text = read(REVIEW / (tid + ".md"))
        verdict = re.search(r"VERDICT: *(PASS|REWORK|ESCALATE)", rev_text)
        tasks[tid] = {
            "id": tid, "title": fm.get("title", ""), "status": fm.get("status", "?"),
            "priority": fm.get("priority", "normal") or "normal",
            "worker": fm.get("worker", ""), "reviewer": fm.get("reviewer", ""),
            "effective_worker": policy["worker"], "effective_reviewer": policy["general"],
            "created": fm.get("created", ""),
            "report": file_info(TASKS / (tid + "_report.md")),
            "worker_log": file_info(TASKS / (tid + "_worker.log")),
            "review_log": file_info(REVIEW / (tid + "_reviewer.log")),
            "verdict": verdict.group(1) if verdict else None,
            "runs": [], "tokens": 0,
        }

    runs = []
    for ln in read(STATE / "runs.log").splitlines():
        m = RUN_RE.match(ln.strip())
        if not m:
            continue  # z. B. Rechte-Vermerke
        ts, tid, role, sub, tool, tier, prio, verdict = m.groups()
        if sub:
            role = f"reviewer:{sub}"
        r = {"ts": ts, "task": tid, "role": role, "tool": tool, "tier": tier,
             "priority": prio or "normal", "verdict": verdict, "tokens": None}
        runs.append(r)
        if tid in tasks:
            tasks[tid]["runs"].append(r)

    # Tokens: Codex schreibt sie ins Protokoll. Protokolle werden je Lauf überschrieben,
    # also gehören sie zum letzten Codex-Lauf dieser Rolle und Aufgabe.
    codex_logs = []
    for tid, t in tasks.items():
        cands = [("worker", TASKS / (tid + "_worker.log")), ("reviewer", REVIEW / (tid + "_reviewer.log"))]
        cands += [("reviewer:" + q.stem.split("_", 1)[1], q) for q in sorted(REVIEW.glob(tid + "_*.log"))
                  if q.stem.split("_", 1)[1] in ("data", "estimation", "consistency", "language", "general")]
        for role, p in cands:
            info = codex_log_info(p)
            if not info:
                continue
            info.update({"task": tid, "role": role})
            codex_logs.append(info)
            last = [r for r in t["runs"] if r["role"] == role and r["tool"] == "codex"]
            if last and info["tokens"] is not None:
                last[-1]["tokens"] = info["tokens"]
            if info["tokens"]:
                t["tokens"] += info["tokens"]

    tools = {}
    for key, name in TOOL_NAMES.items():
        rs = [r for r in runs if r["tool"] == key]
        tok = [r["tokens"] for r in rs if r["tokens"] is not None]
        tiers = {}
        for r in rs:
            tiers[r["tier"]] = tiers.get(r["tier"], 0) + 1
        tools[key] = {
            "name": name, "runs": len(rs),
            "worker_runs": sum(1 for r in rs if r["role"] == "worker"),
            "reviewer_runs": sum(1 for r in rs if r["role"].startswith("reviewer")),
            "tokens_known": sum(tok), "runs_with_tokens": len(tok), "tiers": tiers,
            "last": rs[-1]["ts"] if rs else None,
        }

    approvals = []
    for ln in read(STATE / "approvals.log").splitlines():
        m = APPROVAL_RE.match(ln.strip())
        if m:
            approvals.append({"ts": m.group(1), "task": m.group(2), "status": m.group(3), "override": m.group(4)})

    blocks, tlines = terminal_blocks()
    procs = running_processes()
    active = None
    if blocks:
        b = blocks[-1]
        if b["script"] in ("worker.sh", "review.sh"):
            finished = any(re.search(r"Status (EXECUTED|PASS|REWORK|ESCALATE)|Fehler:|Bericht:", o) for o in b["out"])
            started = datetime.strptime(b["ts"], "%Y-%m-%d %H:%M:%S").timestamp()
            tid = (b["args"].split() or [""])[0]
            t = tasks.get(tid, {})
            tool = policy["worker"] if b["script"] == "worker.sh" else policy["general"]
            proc_alive = any(p["tool"] == tool for p in procs)
            if not finished and (proc_alive or now - started < 30 * 60):
                log = t.get("worker_log") if b["script"] == "worker.sh" else t.get("review_log")
                active = {
                    "task": tid, "role": "worker" if b["script"] == "worker.sh" else "reviewer",
                    "tool": tool, "started": started, "proc_alive": proc_alive,
                    "log": log, "title": t.get("title", ""),
                    "tier_hint": t.get("priority", "normal"),
                    "log_tail": [],
                }
                if log:
                    tail = read(ROOT / log["path"]).splitlines()
                    active["log_tail"] = [x for x in tail if x.strip()][-14:]

    status_counts = {}
    for t in tasks.values():
        status_counts[t["status"]] = status_counts.get(t["status"], 0) + 1

    return {
        "now": now, "project": ROOT.name, "provider_policy": policy,
        "tasks": list(tasks.values()), "runs": runs, "tools": tools,
        "approvals": approvals, "status_counts": status_counts,
        "active": active, "processes": procs,
        "terminal_tail": tlines[-60:],
        "codex_logs": codex_logs,
    }


class Handler(BaseHTTPRequestHandler):
    def log_message(self, *a):
        pass

    def _send(self, code, body, ctype):
        data = body.encode("utf-8")
        self.send_response(code)
        self.send_header("Content-Type", ctype)
        self.send_header("Cache-Control", "no-store")
        self.send_header("Content-Length", str(len(data)))
        self.end_headers()
        self.wfile.write(data)

    def do_GET(self):
        if self.path.startswith("/api/state"):
            try:
                self._send(200, json.dumps(collect(), ensure_ascii=False), "application/json; charset=utf-8")
            except Exception as e:  # Dashboard soll bei halb geschriebenen Dateien nicht abstürzen
                self._send(500, json.dumps({"error": str(e)}), "application/json")
        elif self.path in ("/", "/index.html"):
            self._send(200, PAGE, "text/html; charset=utf-8")
        else:
            self._send(404, "nicht gefunden", "text/plain; charset=utf-8")


PAGE = (Path(__file__).resolve().parent / "dashboard.html").read_text(encoding="utf-8") if (Path(__file__).resolve().parent / "dashboard.html").exists() else "<p>agents/dashboard.html fehlt.</p>"


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--port", type=int, default=8765)
    ap.add_argument("--no-browser", action="store_true")
    ap.add_argument("--dump", action="store_true", help="Zustand einmal als JSON ausgeben und beenden")
    a = ap.parse_args()
    if a.dump:
        print(json.dumps(collect(), ensure_ascii=False, indent=1))
        return
    srv = ThreadingHTTPServer(("127.0.0.1", a.port), Handler)
    url = "http://localhost:%d" % a.port
    print("Agenten-Dashboard läuft: %s  (Ctrl+C beendet)" % url)
    if not a.no_browser:
        threading.Timer(0.6, lambda: webbrowser.open(url)).start()
    try:
        srv.serve_forever()
    except KeyboardInterrupt:
        print("\nbeendet")


if __name__ == "__main__":
    main()
