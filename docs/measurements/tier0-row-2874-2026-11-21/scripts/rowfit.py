import sys, statistics
# Usage: rowfit.py TSC_MHZ CORE_GHZ log1 log2 ...: per body median over runs; fit ticks = a + b*entries per part.
tsc = float(sys.argv[1]); core = float(sys.argv[2])
runs = []
for path in sys.argv[3:]:
    rows = {}
    for line in open(path):
        p = line.split('\t')
        if len(p) < 12: continue
        rows[int(p[0])] = [int(x) for x in p]
    runs.append(rows)
bodies = sorted(set.intersection(*[set(r) for r in runs]))
parts = ['tier0', 'sizing', 'encode', 'debug', 'unwind', 'rest']
data = []
for b in bodies:
    base = runs[0][b]
    med = [statistics.median(r[b][6 + k] for r in runs) for k in range(6)]
    data.append((base[1], base[2], base[3], base[4], base[5], med))
n = len(data)
E = sum(d[0] for d in data); R = sum(d[1] for d in data); B = sum(d[2] for d in data); F = sum(d[3] for d in data); Y = sum(d[4] for d in data)
scale = core * 1000.0 / tsc  # core cycles per TSC tick
print(f"bodies {n} entries {E} records {R} branches {B} references {F} bytes {Y}; core/tsc {scale:.3f}")
def fit(xs, ys):
    mx = sum(xs) / len(xs); my = sum(ys) / len(ys)
    sxx = sum((x - mx) ** 2 for x in xs); sxy = sum((x - mx) * (y - my) for x, y in zip(xs, ys))
    b = sxy / sxx; a = my - b * mx
    return a, b
tot_all = 0
print(f"{'part':8s} {'total Mc':>9s} {'cyc/entry':>9s} {'fit a (cyc/fn)':>14s} {'fit b (cyc/entry)':>17s} {'fixed share':>11s}")
for k, name in enumerate(parts):
    ys = [d[5][k] * scale for d in data]
    xs = [d[0] for d in data]
    # skip the first body (cold) in the fit
    a, b = fit(xs[1:], ys[1:])
    tot = sum(ys); tot_all += tot
    print(f"{name:8s} {tot/1e6:9.2f} {tot/E:9.1f} {a:14.0f} {b:17.2f} {100*a*(n-1)/max(sum(ys[1:]),1):10.1f}%")
print(f"{'all':8s} {tot_all/1e6:9.2f} {tot_all/E:9.1f}")
# buckets by entries
import math
buckets = {}
for d in data[1:]:
    k = 0 if d[0] < 1 else int(math.log2(d[0]))
    buckets.setdefault(k, []).append(d)
print("bucket(entries)   n   median cyc/entry tier0  sizing  encode  unwind  rest   all")
for k in sorted(buckets):
    ds = buckets[k]
    def med(i): return statistics.median(d[5][i] * scale / max(d[0], 1) for d in ds)
    alls = statistics.median(sum(d[5]) * scale / max(d[0], 1) for d in ds)
    print(f"[{2**k:5d},{2**(k+1):5d})  {len(ds):5d}  {med(0):12.1f} {med(1):7.1f} {med(2):7.1f} {med(4):7.1f} {med(5):6.1f} {alls:6.1f}")
