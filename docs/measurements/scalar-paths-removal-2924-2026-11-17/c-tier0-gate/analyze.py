# #2924 C8's gate: each area's TSC ticks, vector (mask 0) against scalar (0xf). Each call is one line, "area entries
# ticks", in call order, so the k-th line of an area pairs across runs; a call's ticks are the median of the rounds,
# summed by its Tier 0 entries. Usage: analyze.py TICKS_DIR ROUNDS
import sys, os, statistics
areas = ['compile', 'validate', 'inline', 'unwind analyzer']
bins = [(0, 16), (16, 64), (64, 256), (256, 1024), (1024, 1 << 30)]
d, rounds = sys.argv[1], int(sys.argv[2])
def load(mask):
    per = []
    for r in range(1, rounds + 1):
        rows = [tuple(map(int, l.split())) for l in open(os.path.join(d, f'{mask}-{r}.txt')) if l.strip()]
        by = {a: [] for a in range(len(areas))}
        for a, n, t in rows:
            by[a].append((n, t))
        per.append(by)
    out = {}
    for a in range(len(areas)):
        lens = [len(p[a]) for p in per]
        assert len(set(lens)) == 1, (a, lens)
        out[a] = []
        for i in range(lens[0]):
            sizes = {p[a][i][0] for p in per}
            assert len(sizes) == 1, (a, i, sizes)
            out[a].append((per[0][a][i][0], statistics.median(p[a][i][1] for p in per), [p[a][i][1] for p in per]))
    return out
v = load('0'); s = load('0xf')
for a, name in enumerate(areas):
    assert len(v[a]) == len(s[a]), (name, len(v[a]), len(s[a]))
    assert all(v[a][i][0] == s[a][i][0] for i in range(len(v[a])))
    tv = sum(x[1] for x in v[a]); ts = sum(x[1] for x in s[a])
    print(f'{name}: {len(v[a])} calls, vector {tv / 1e6:.2f} M ticks, scalar {ts / 1e6:.2f} M, scalar/vector {ts / tv if tv else 0:.3f}')
    for lo, hi in bins:
        sel = [i for i in range(len(v[a])) if lo <= v[a][i][0] < hi]
        bv = sum(v[a][i][1] for i in sel); bs = sum(s[a][i][1] for i in sel)
        print(f'  {lo:5d}-{hi if hi < (1 << 30) else "max":>5}: {len(sel):6d} calls  vector {bv / 1e6:9.3f} M  scalar {bs / 1e6:9.3f} M  scalar/vector {bs / bv if bv else 0:6.3f}')
    # Round by round: each round's totals.
    rv = [sum(x[2][r] for x in v[a]) for r in range(rounds)]; rs = [sum(x[2][r] for x in s[a]) for r in range(rounds)]
    print('  rounds scalar/vector: ' + ' '.join(f'{rs[r] / rv[r]:.3f}' if rv[r] else '-' for r in range(rounds)))
