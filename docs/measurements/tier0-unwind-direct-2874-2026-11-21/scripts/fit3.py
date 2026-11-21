import sys, statistics, glob, os
# Usage: fit3.py TSC_MHZ CORE_GHZ DIR: per body medians over runs of each mode (d: the descriptor from the frame, e: frame
# events, m: main), cycles = ticks * CORE_GHZ * 1000 / TSC_MHZ; the parts' totals, a body's mean and the fit a + b x entries.
tsc = float(sys.argv[1]); core = float(sys.argv[2]); d = sys.argv[3]
scale = core * 1000.0 / tsc
def load(mode):
    runs = []
    for path in sorted(glob.glob(os.path.join(d, f"rowlog-{mode}-*.tsv"))):
        rows = {}
        for line in open(path):
            p = line.rstrip('\n').split('\t')
            if len(p) < 28: continue
            v = [int(x) for x in p]
            rows[v[0]] = v + ([0] if len(v) == 28 else [])
        runs.append(rows)
    return runs
modes = {m: load(m) for m in 'dem'}
modes = {m: r for m, r in modes.items() if r}
bodies = sorted(set.intersection(*[set(r) for rs in modes.values() for r in rs]))
entries = {b: modes['d'][0][b][1] for b in bodies}
E = sum(entries.values())
direct = [b for b in bodies if modes['d'][0][b][28] == 1]
print(f"runs {', '.join(f'{m} {len(r)}' for m, r in modes.items())}; bodies {len(bodies)}, direct {len(direct)}; entries {E}; cycles = ticks x {scale:.4f}")
def med(runs, b, col): return statistics.median(r[b][col] for r in runs) * scale
def fit(xs, ys):
    mx = sum(xs) / len(xs); my = sum(ys) / len(ys)
    sxx = sum((x - mx) ** 2 for x in xs); sxy = sum((x - mx) * (y - my) for x, y in zip(xs, ys))
    b = sxy / sxx if sxx else 0.0
    return my - b * mx, b
COLS = [('tier0', 6), ('sizing', 7), ('encode', 8), ('unwind', 10), ('rest', 11), ('emitted_from_tier0', 27)]
print(f"{'part':20s} " + ' '.join(f"{m+' Mcyc':>9s} {m+' /body':>8s} {m+' a':>7s} {m+' b':>6s}" for m in modes))
for name, col in COLS:
    line = f"{name:20s} "
    for m, runs in modes.items():
        ys = [med(runs, b, col) for b in bodies]
        a, bb = fit([entries[b] for b in bodies[1:]], ys[1:])
        line += f"{sum(ys)/1e6:9.3f} {sum(ys)/len(bodies):8.1f} {a:7.0f} {bb:6.2f} "
    print(line)
both = lambda m: [med(modes[m], b, 10) + med(modes[m], b, 27) for b in bodies]
for m in modes:
    v = sorted(both(m)); n = len(v)
    print(f"{m}: unwind + emitted_from_tier0, cycles a body: mean {sum(v)/n:.1f} median {v[n//2]:.1f} p10 {v[n//10]:.1f} p90 {v[9*n//10]:.1f}")
def stages(mode):
    vals = {}
    for path in sorted(glob.glob(os.path.join(d, f"stages-{mode}-*.txt"))):
        for line in open(path):
            p = line.split('\t')
            if len(p) >= 3 and p[0] == 'time-stage' and p[1] != 'stage':
                vals.setdefault(p[1], []).append(float(p[2]))
    return {k: statistics.median(v) for k, v in vals.items()}
st = {m: stages(m) for m in modes}
print("stage clock, ms (medians): " + ' '.join(modes))
for k in ['tier0', 'branch-sizing', 'encode', 'unwind', 'code-atoms', 'publish-data', 'object-build', 'object-write', 'total']:
    print(f"  {k:14s} " + ' '.join(f"{st[m].get(k, float('nan')):8.3f}" for m in modes))
