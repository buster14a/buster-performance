#!/usr/bin/env python3
# analyze.py RECORD: #3344's 9700X record. Per order, the median over rounds of each tree's cycles (summed over the five
# scripts, and per script); the paired log ratio head/base per order; its mean over the 33 orders with a t interval.
import math, statistics, sys, collections
R = sys.argv[1]
runs = collections.defaultdict(list)  # (tree, order, script) -> [cycles]
for line in open(R + "/runs.tsv"):
    f = line.rstrip("\t\n").split("\t")
    if len(f) < 5 or line.startswith("#"):
        continue
    kv = dict(x.split("=", 1) for x in f[4:] if "=" in x)
    runs[(f[2], int(f[1]), f[3])].append(float(kv["cycles:u"]))
orders = sorted({k[1] for k in runs})
scripts = sorted({k[2] for k in runs})
T975 = {32: 2.0369}
def summary(name, ratios):
    n = len(ratios)
    m = statistics.mean(ratios)
    s = statistics.stdev(ratios)
    h = T975.get(n - 1, 2.0) * s / math.sqrt(n)
    pct = lambda x: (math.exp(x) - 1) * 100
    print(f"{name:12s} n={n} mean {pct(m):+.2f}%  95% CI {pct(m-h):+.2f}% .. {pct(m+h):+.2f}%  range {pct(min(ratios)):+.2f}% .. {pct(max(ratios)):+.2f}%  head faster in {sum(r < 0 for r in ratios)}/{n}")
total = {t: {k: sum(statistics.median(runs[(t, k, s)]) for s in scripts) for k in orders} for t in ("base", "head")}
for s in scripts:
    summary(s, [math.log(statistics.median(runs[("head", k, s)]) / statistics.median(runs[("base", k, s)])) for k in orders])
summary("all five", [math.log(total["head"][k] / total["base"][k]) for k in orders])
print(f"order 0 total cycles: base {total['base'][0]:.0f} head {total['head'][0]:.0f}")
print(f"median over orders of total cycles: base {statistics.median(total['base'].values()):.0f} head {statistics.median(total['head'].values()):.0f}")
try:
    prof = {}
    for line in open(R + "/profile.tsv"):
        f = line.split("\t")
        if f[0] not in ("base", "head"):
            continue
        kv = dict(x.split("=", 1) for x in f[2:] if "=" in x)
        prof[(f[0], int(f[1]))] = (int(kv["luaV_execute"]) * int(kv["period"].strip()), int(kv["total"]) * int(kv["period"].strip()))
    lv = [math.log(prof[("head", k)][0] / prof[("base", k)][0]) for k in orders]
    summary("luaV_execute", lv)
    print(f"luaV_execute cycles, median over orders: base {statistics.median(prof[('base', k)][0] for k in orders):.4g} head {statistics.median(prof[('head', k)][0] for k in orders):.4g}")
    print(f"luaV_execute share, median: base {statistics.median(prof[('base', k)][0] / prof[('base', k)][1] for k in orders):.3f} head {statistics.median(prof[('head', k)][0] / prof[('head', k)][1] for k in orders):.3f}")
except FileNotFoundError:
    pass
try:
    cost = collections.defaultdict(list)
    for line in open(R + "/cost.tsv"):
        f = line.rstrip("\t\n").split("\t")
        if f[0] not in ("base", "head"):
            continue
        kv = dict(x.split("=", 1) for x in f[3:] if "=" in x)
        cost[(f[0], f[2])].append((float(kv["cycles:u"]), float(kv["instructions:u"])))
    for unit in ("lvm", "sqlite"):
        b = cost[("base", unit)]; h = cost[("head", unit)]
        bc = statistics.median(x[0] for x in b); hc = statistics.median(x[0] for x in h)
        bi = statistics.median(x[1] for x in b); hi = statistics.median(x[1] for x in h)
        print(f"compile {unit}: cycles base {bc:.4g} head {hc:.4g} ({(hc/bc-1)*100:+.2f}%), instructions base {bi:.4g} head {hi:.4g} ({(hi/bi-1)*100:+.3f}%), n={len(b)}")
except FileNotFoundError:
    pass
