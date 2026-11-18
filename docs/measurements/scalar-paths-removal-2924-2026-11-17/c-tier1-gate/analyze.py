# #2924 C7's gate: each region's TSC ticks, vector (mask 0) against scalar (0x3ff, and 0x40 for the CFG allocation
# alone), per function as the median of the rounds, summed by the function's IR instructions. Usage: analyze.py TICKS_DIR
import sys, os, statistics
regions = ['select', 'chain-liveness', 'chain-allocate', 'chain-prepare', 'chain-records', 'cfg-problem', 'cfg-allocation', 'preference', 'cfg-records', 'schedule']
bins = [(1, 16), (16, 64), (64, 256), (256, 1024), (1024, 1 << 30)]
d = sys.argv[1]
def load(mask):
    rounds = []
    for r in (1, 2, 3):
        p = os.path.join(d, f'{mask}-{r}.txt')
        rows = [list(map(int, l.split())) for l in open(p) if l.strip()]
        rounds.append(rows)
    n = len(rounds[0])
    assert all(len(x) == n for x in rounds), [len(x) for x in rounds]
    out = []
    for i in range(n):
        stage, size = rounds[0][i][0], rounds[0][i][1]
        assert all(x[i][1] == size for x in rounds)
        ticks = [statistics.median(x[i][2 + k] for x in rounds) for k in range(len(regions))]
        out.append((stage, size, ticks))
    return out
v = load('0'); s = load('0x3ff'); a = load('0x40')
assert len(v) == len(s) == len(a)
print(f'functions: {len(v)}, with IR: {sum(1 for x in v if x[1] > 0)}')
for k, name in enumerate(regions):
    if k == 7:
        continue
    total_v = total_s = 0
    rows = []
    for lo, hi in bins:
        sel = [i for i in range(len(v)) if lo <= v[i][1] < hi and v[i][2][k] > 0]
        tv = sum(v[i][2][k] for i in sel); ts = sum(s[i][2][k] for i in sel); ta = sum(a[i][2][k] for i in sel)
        total_v += tv; total_s += ts
        extra = f' alloc-only {ta / tv:5.2f}' if k == 6 and tv else ''
        rows.append(f'  {lo:5d}-{hi if hi < (1 << 30) else "max":>5}: {len(sel):6d} fns  vector {tv / 1e6:9.2f} M  scalar {ts / 1e6:9.2f} M  scalar/vector {ts / tv if tv else 0:5.2f}{extra}')
    print(f'{name}: total scalar/vector {total_s / total_v if total_v else 0:5.2f} (vector {total_v / 1e6:.1f} M ticks)')
    print('\n'.join(rows))
