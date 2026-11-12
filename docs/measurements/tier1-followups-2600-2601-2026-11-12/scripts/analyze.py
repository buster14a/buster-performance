# analyze.py RUNS: run2600.sh's (or rerun2600.sh's) runs.txt into the comparison's tables. Lua: each layout's (link order's) median of every
# script over the rounds, by build; their sum, the five scripts' total, by layout; and the head's ratio to the base's by
# layout, with the mean of the layouts' log ratios and its 95% interval over the layouts (t with layouts - 1 degrees of
# freedom). speedtest1, one layout: the medians and their ratio, and the per-round paired ratios' median and range.
# Every metric: task-clock (ms), user cycles and user instructions.
import math
import statistics
import sys

T975 = {1: 12.706, 2: 4.303, 3: 3.182, 4: 2.776, 5: 2.571, 6: 2.447, 7: 2.365, 8: 2.306, 9: 2.262, 10: 2.228}
METRICS = [("task-clock", "time, ms", 1.0), ("cycles", "user cycles, M", 1e-6), ("instructions", "user instructions, M", 1e-6)]

runs = []
for line in open(sys.argv[1]):
    words = line.split()
    if len(words) < 5:
        continue
    kind, round_, order, build, script = words[:5]
    values = dict(w.split("=", 1) for w in words[5:] if "=" in w)
    runs.append((kind, int(round_), int(order), build, script, {k: float(v) for k, v in values.items() if v not in ("<not counted>", "<not supported>")}))

def median(xs):
    return statistics.median(xs) if xs else float("nan")

lua = [r for r in runs if r[0] == "lua"]
orders = sorted({r[2] for r in lua})
scripts = ["calls", "tables", "strings", "arithmetic", "closures"]
print(f"Lua: {len(lua)} runs, {len(orders)} layouts, {len({r[1] for r in lua})} rounds")
for metric, name, scale in METRICS if lua else []:
    print(f"\n### Lua's five scripts, {name}\n")
    print("| Layout | base | head | head / base |")
    print("| ---: | ---: | ---: | ---: |")
    logs = []
    for o in orders:
        total = {}
        for b in ("base", "head"):
            total[b] = sum(median([r[5][metric] for r in lua if r[2] == o and r[3] == b and r[4] == s and metric in r[5]]) for s in scripts) * scale
        ratio = total["head"] / total["base"]
        logs.append(math.log(ratio))
        print(f"| {o} | {total['base']:.2f} | {total['head']:.2f} | {ratio:.4f} |")
    mean = statistics.mean(logs)
    half = T975.get(len(logs) - 1, 2.0) * statistics.stdev(logs) / math.sqrt(len(logs)) if len(logs) > 1 else float("nan")
    print(f"\nMean ratio over the layouts {math.exp(mean):.4f} (95% interval {math.exp(mean - half):.4f} to {math.exp(mean + half):.4f})")
    print("\n| Script | base, median of layouts' medians | head | head / base |")
    print("| --- | ---: | ---: | ---: |")
    for s in scripts:
        per = {b: median([median([r[5][metric] for r in lua if r[2] == o and r[3] == b and r[4] == s and metric in r[5]]) for o in orders]) * scale for b in ("base", "head")}
        print(f"| {s} | {per['base']:.2f} | {per['head']:.2f} | {per['head'] / per['base']:.4f} |")

st = [r for r in runs if r[0] == "st"]
print(f"\nspeedtest1: {len(st)} runs, one layout")
print("\n| Metric | base | head | head / base | paired rounds' ratio, median (range) |")
print("| --- | ---: | ---: | ---: | ---: |")
for metric, name, scale in METRICS:
    med = {b: median([r[5][metric] for r in st if r[3] == b and metric in r[5]]) * scale for b in ("base", "head")}
    rounds = sorted({r[1] for r in st})
    pairs = []
    for rd in rounds:
        v = {r[3]: r[5].get(metric) for r in st if r[1] == rd}
        if v.get("base") and v.get("head"):
            pairs.append(v["head"] / v["base"])
    print(f"| {name} | {med['base']:.2f} | {med['head']:.2f} | {med['head'] / med['base']:.4f} | {median(pairs):.4f} ({min(pairs):.4f} to {max(pairs):.4f}) |")
