import sys, statistics
tsc = float(sys.argv[1]); core = float(sys.argv[2])
names = {0:'setup(columns)',1:'labels',2:'values P0',3:'fuse P1-P3',4:'depths P4',5:'select+align',6:'homes+frame',7:'measure+push',8:'emit',9:'choices',10:'generate rest',11:'conclude+labels',15:'emitted_from_tier0'}
runs = []
for path in sys.argv[3:]:
    rows = {}
    for line in open(path):
        p = line.split('\t')
        if len(p) < 28: continue
        rows[int(p[0])] = [int(x) for x in p]
    runs.append(rows)
bodies = sorted(set.intersection(*[set(r) for r in runs]))
scale = core * 1000.0 / tsc
data = []
for b in bodies:
    base = runs[0][b]
    passes = [statistics.median(r[b][12 + k] for r in runs) * scale for k in range(16)]
    data.append((base[1], passes))
E = sum(d[0] for d in data); n = len(data)
def fit(xs, ys):
    mx = sum(xs) / len(xs); my = sum(ys) / len(ys)
    sxx = sum((x - mx) ** 2 for x in xs); sxy = sum((x - mx) * (y - my) for x, y in zip(xs, ys))
    b = sxy / sxx; return my - b * mx, b
print(f"bodies {n} entries {E}; cycles = ticks * {scale:.3f}")
print(f"{'pass':22s} {'cyc/entry':>9s} {'per fn':>8s} {'per entry':>9s} {'big fns cyc/entry':>17s}")
tot = 0; totb = 0
big = [d for d in data[1:] if d[0] >= 256]
EB = sum(d[0] for d in big)
for k, name in names.items():
    ys = [d[1][k] for d in data]; xs = [d[0] for d in data]
    a, b = fit(xs[1:], ys[1:])
    t = sum(ys); tot += t
    tb = sum(d[1][k] for d in big); totb += tb
    print(f"{name:22s} {t/E:9.1f} {a:8.0f} {b:9.2f} {tb/EB:17.1f}")
print(f"{'all':22s} {tot/E:9.1f} {'':8s} {'':9s} {totb/EB:17.1f}  (functions of 256+ entries: {len(big)}, {EB} entries)")
