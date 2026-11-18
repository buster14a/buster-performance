# compare-lower.py DIR CONFIG ROUNDS: lines "entries ticks" per lowering in DIR/CONFIG-{vector,scalar}-R.txt; each
# lowering's median over the rounds, scalar/vector by Tier 0 entries, then each round's own total ratio.
import sys, os, statistics
d, config, rounds = sys.argv[1], sys.argv[2], int(sys.argv[3])
def rows(s, r):
    return [list(map(int, l.split())) for l in open(os.path.join(d, f"{config}-{s}-{r}.txt")) if l.strip()]
v = [rows('vector', r) for r in range(1, rounds + 1)]
s = [rows('scalar', r) for r in range(1, rounds + 1)]
n = len(v[0])
assert all(len(x) == n for x in v + s), [len(x) for x in v + s]
assert all(x[i][0] == v[0][i][0] for x in v + s for i in range(n))
mv = [statistics.median(x[i][1] for x in v) for i in range(n)]
ms = [statistics.median(x[i][1] for x in s) for i in range(n)]
print(f'{config} lowering: scalar/vector total {sum(ms) / sum(mv):.4f} ({n} lowerings, vector {sum(mv) / 1e6:.2f} M ticks)')
for lo, hi in [(0, 16), (16, 64), (64, 256), (256, 1024), (1024, 1 << 40)]:
    sel = [i for i in range(n) if lo <= v[0][i][0] < hi]
    if sel:
        sv = sum(mv[i] for i in sel); ss = sum(ms[i] for i in sel)
        print(f'  entries {lo:5d}-{hi if hi < (1 << 40) else "max":>5}: {len(sel):6d}  vector {sv / 1e6:9.3f} M  scalar {ss / 1e6:9.3f} M  ratio {ss / sv:.4f}  vector slower in {sum(1 for i in sel if mv[i] > ms[i])}')
print('  each round: ' + ' '.join(f'{sum(s[r][i][1] for i in range(n)) / sum(v[r][i][1] for i in range(n)):.4f}' for r in range(rounds)))
