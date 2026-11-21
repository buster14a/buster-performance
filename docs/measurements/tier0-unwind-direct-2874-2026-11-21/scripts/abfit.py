import sys, statistics, glob, os
# Usage: abfit.py TSC_MHZ CORE_GHZ DIR: rowlog-d-*.tsv (descriptor from the frame) against rowlog-e-*.tsv (from events),
# per body medians over runs; cycles = ticks * CORE_GHZ * 1000 / TSC_MHZ; and the stage clock's medians.
tsc = float(sys.argv[1]); core = float(sys.argv[2]); d = sys.argv[3]
scale = core * 1000.0 / tsc
def load(mode):
    runs = []
    for path in sorted(glob.glob(os.path.join(d, f"rowlog-{mode}-*.tsv"))):
        rows = {}
        for line in open(path):
            p = line.rstrip('\n').split('\t')
            if len(p) < 29: continue
            rows[int(p[0])] = [int(x) for x in p]
        runs.append(rows)
    return runs
D = load('d'); E = load('e')
bodies = sorted(set.intersection(*[set(r) for r in D + E]))
def med(runs, b, col): return statistics.median(r[b][col] for r in runs) * scale
COLS = {'tier0': 6, 'sizing': 7, 'encode': 8, 'debug': 9, 'unwind': 10, 'rest': 11, 'emitted_from_tier0': 12 + 15}
direct = [b for b in bodies if D[0][b][28] == 1]
assert all(E[0][b][28] == 0 for b in bodies)
entries = {b: D[0][b][1] for b in bodies}
print(f"runs d {len(D)} e {len(E)}; bodies {len(bodies)}, of them direct {len(direct)} ({100*len(direct)/len(bodies):.1f}%), "
      f"entries {sum(entries.values())}, of them in direct bodies {sum(entries[b] for b in direct)}")
def fit(xs, ys):
    mx = sum(xs) / len(xs); my = sum(ys) / len(ys)
    sxx = sum((x - mx) ** 2 for x in xs); sxy = sum((x - mx) * (y - my) for x, y in zip(xs, ys))
    b = sxy / sxx if sxx else 0.0
    return my - b * mx, b
n_e = sum(entries.values())
print(f"{'part':20s} {'d Mcyc':>8s} {'e Mcyc':>8s} {'e-d Mcyc':>9s} {'e-d cyc/body':>12s} {'e-d cyc/entry':>13s} | direct bodies: {'d cyc/body':>10s} {'e cyc/body':>10s} {'fit a d':>8s} {'fit b d':>8s} {'fit a e':>8s} {'fit b e':>8s}")
for name, col in COLS.items():
    sd = sum(med(D, b, col) for b in bodies); se = sum(med(E, b, col) for b in bodies)
    dd = [med(D, b, col) for b in direct[1:]]; de = [med(E, b, col) for b in direct[1:]]
    xs = [entries[b] for b in direct[1:]]
    ad, bd = fit(xs, dd); ae, be = fit(xs, de)
    print(f"{name:20s} {sd/1e6:8.3f} {se/1e6:8.3f} {(se-sd)/1e6:9.3f} {(se-sd)/len(bodies):12.1f} {(se-sd)/n_e:13.2f} | {statistics.mean(dd):10.1f} {statistics.mean(de):10.1f} {ad:8.0f} {bd:8.2f} {ae:8.0f} {be:8.2f}")
# The stage clock, ms, medians over runs.
def stages(mode):
    vals = {}
    for path in sorted(glob.glob(os.path.join(d, f"stages-{mode}-*.txt"))):
        for line in open(path):
            p = line.split('\t')
            if len(p) >= 3 and p[0] == 'time-stage' and p[1] != 'stage':
                vals.setdefault(p[1], []).append(float(p[2]))
    return {k: statistics.median(v) for k, v in vals.items()}
sd = stages('d'); se = stages('e')
print("stage clock, ms (medians): stage d e e-d")
for k in ['tier0', 'branch-sizing', 'encode', 'unwind', 'code-atoms', 'publish-data', 'object-build', 'object-write', 'total']:
    if k in sd and k in se:
        print(f"  {k:14s} {sd[k]:8.3f} {se[k]:8.3f} {se[k]-sd[k]:+8.3f}")
