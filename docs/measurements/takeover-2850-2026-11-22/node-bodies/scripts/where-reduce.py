#!/usr/bin/env python3
# where-reduce.py DIR: medians of the stage tables, the counters and the profiles of two arms (plain, bodies), and their differences.
import sys, os, re, statistics, collections
d = sys.argv[1]
arms = ("plain", "bodies")
def med(v): return statistics.median(v) if v else float("nan")
stages = {a: collections.OrderedDict() for a in arms}
extra = {a: collections.defaultdict(list) for a in arms}
proc = {a: collections.defaultdict(list) for a in arms}
for a in arms:
    for i in range(1, 8):
        p = os.path.join(d, f"{a}-{i}.stages")
        if not os.path.exists(p): continue
        for line in open(p):
            f = line.rstrip("\n").split("\t")
            if f[0] in ("time-stage", "time-check") and len(f) >= 3 and f[1] != "stage":
                try: v = float(f[2])
                except ValueError: continue
                key = (f[0], f[1])
                stages[a].setdefault(key, []).append(v)
                if f[0] == "time-stage" and len(f) >= 7:
                    extra[a][(f[1], "sys")].append(float(f[4])); extra[a][(f[1], "faults")].append(float(f[5])); extra[a][(f[1], "peak")].append(float(f[6]))
            elif f[0] == "time-process" and len(f) >= 3:
                try: proc[a][f[1]].append(float(f[2]))
                except ValueError: pass
            elif f[0].startswith("node-bodies") or "node-bodies" in line[:40]:
                if i == 1: print("  ", line.rstrip())
print(f"{'stage':38s} {'plain':>9s} {'bodies':>9s} {'delta':>9s}   {'sys d':>7s} {'faults d':>8s} {'peak-kb d':>9s}")
keys = list(stages["plain"].keys())
for k in stages["bodies"].keys():
    if k not in keys: keys.append(k)
for k in keys:
    p = med(stages["plain"].get(k, [])); b = med(stages["bodies"].get(k, []))
    line = f"{k[0][5:]+' '+k[1]:38s} {p:9.3f} {b:9.3f} {b-p:+9.3f}"
    if k[0] == "time-stage" and (k[1], "sys") in extra["plain"]:
        line += f"   {med(extra['bodies'][(k[1],'sys')])-med(extra['plain'][(k[1],'sys')]):+7.3f} {med(extra['bodies'][(k[1],'faults')])-med(extra['plain'][(k[1],'faults')]):+8.0f} {med(extra['bodies'][(k[1],'peak')])-med(extra['plain'][(k[1],'peak')]):+9.0f}"
    if abs(b - p) >= 0.05 or k[1] == "total": print(line)
print()
for name in ("peak-rss-kb", "user-ms", "system-ms", "minor-faults"):
    p = med(proc["plain"][name]); b = med(proc["bodies"][name]); print(f"{name:20s} {p:12.3f} {b:12.3f} {b-p:+12.3f}")
print()
stat = {a: collections.defaultdict(list) for a in arms}
for a in arms:
    for i in range(1, 8):
        p = os.path.join(d, f"{a}-{i}.stat")
        if not os.path.exists(p): continue
        for line in open(p):
            f = line.strip().split(",")
            if len(f) > 3 and f[0].replace(".", "").isdigit(): stat[a][f[2]].append(float(f[0]))
for name in stat["plain"]:
    p = med(stat["plain"][name]); b = med(stat["bodies"][name]); print(f"{name:28s} {p/1e6:12.3f} M {b/1e6:12.3f} M {(b-p)/1e6:+12.3f} M")
print()
prof = {a: collections.defaultdict(float) for a in arms}
runs = {a: 0 for a in arms}
for a in arms:
    for i in range(1, 8):
        p = os.path.join(d, f"{a}-{i}.report")
        if not os.path.exists(p): continue
        runs[a] += 1
        for line in open(p):
            m = re.match(r"\s*([\d.]+)%\s+(\d+)\s+\[(.)\]\s+(.*)$", line)
            if m: prof[a][("k " if m.group(3) == "k" else "") + re.split(r"\s{2,}", m.group(4).strip())[0]] += float(m.group(2))
names = set(prof["plain"]) | set(prof["bodies"])
rows = []
for n in names:
    p = prof["plain"].get(n, 0) / max(runs["plain"], 1); b = prof["bodies"].get(n, 0) / max(runs["bodies"], 1)
    rows.append((b - p, p, b, n))
tp = sum(r[1] for r in rows); tb = sum(r[2] for r in rows)
print(f"profile: cycles a run plain {tp/1e6:.1f} M, bodies {tb/1e6:.1f} M, delta {(tb-tp)/1e6:+.1f} M ({(tb-tp)/5.49e6:+.2f} ms at 5.49 GHz)")
rows.sort()
top = int(sys.argv[2]) if len(sys.argv) > 2 else 45
print("-- grows most (M cycles a run; ms at 5.49 GHz)")
for dlt, p, b, n in rows[::-1][:top]: print(f"{dlt/1e6:+8.2f} {dlt/5.49e6:+7.2f} ms  {p/1e6:7.2f} -> {b/1e6:7.2f}  {n[:90]}")
print("-- shrinks most")
for dlt, p, b, n in rows[:top]: print(f"{dlt/1e6:+8.2f} {dlt/5.49e6:+7.2f} ms  {p/1e6:7.2f} -> {b/1e6:7.2f}  {n[:90]}")
fam = collections.defaultdict(float)
def family(n):
    if n.startswith("k "): return "kernel"
    for pre in ("node_producer", "node_twin", "node_bodies", "node_alone", "node_front", "node_flat", "node_census", "node_tests", "node_machine_type", "node_machine", "node_facts", "node_", "check_lower", "check_program", "check_control", "check_input_expression", "check_input", "check_graph", "check_action", "check_warn", "check_init", "check_", "tier0", "c_parse", "parse", "preprocess", "c_tok", "mem", "__mem"):
        if n.startswith(pre): return pre
    return "other"
for dlt, p, b, n in rows: fam[family(n)] += dlt
print("-- by family (M cycles; ms)")
for k, v in sorted(fam.items(), key=lambda kv: -kv[1]): print(f"{v/1e6:+8.2f} {v/5.49e6:+7.2f} ms  {k}")
