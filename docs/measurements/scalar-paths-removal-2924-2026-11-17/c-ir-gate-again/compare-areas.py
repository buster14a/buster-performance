# #2924 C9's gate, the twins against the vector paths: compare.py CONFIG BASE OTHER ROUNDS reads ticks/CONFIG-MASK-R.txt
# for both masks and rounds 1..ROUNDS (a line per compiled function: its stage, its Tier 0 entries, then the TSC ticks
# in each area's region), takes each function's median per area over the rounds, and prints OTHER/BASE for every area
# by the function's size, then each round's own total ratio (the spread). Run in this directory.
import sys, os, statistics
areas = ['lower', 'inline', 'sroa', 'gvn', 'promote', 'splits', 'thread', 'licm', 'vectorize', 'unroll', 'sink', 'optimize']
bins = [(0, 16), (16, 64), (64, 256), (256, 1024), (1024, 1 << 30)]
config, base, other, rounds = sys.argv[1], sys.argv[2], sys.argv[3], int(sys.argv[4])
def rows(mask, r):
    return [list(map(int, l.split())) for l in open(os.path.join(sys.argv[5], f"{config}-{mask}-{r}.txt")) if l.strip()]
b = [rows(base, r) for r in range(1, rounds + 1)]
o = [rows(other, r) for r in range(1, rounds + 1)]
n = len(b[0])
assert all(len(x) == n for x in b + o), [len(x) for x in b + o]
assert all(x[i][1] == b[0][i][1] for x in b + o for i in range(n))
for k, name in enumerate(areas):
    col = 2 + k
    mb = [statistics.median(x[i][col] for x in b) for i in range(n)]
    mo = [statistics.median(x[i][col] for x in o) for i in range(n)]
    tb = sum(mb); to = sum(mo)
    if tb == 0:
        print(f'{name}: not run')
        continue
    calls = sum(1 for i in range(n) if mb[i] > 0)
    print(f'{name}: {other}/{base} total {to / tb:.4f} ({calls} functions, base {tb / 1e6:.2f} M ticks)')
    for lo, hi in bins:
        sel = [i for i in range(n) if lo <= b[0][i][1] < hi and mb[i] > 0]
        if not sel:
            continue
        sb = sum(mb[i] for i in sel); so = sum(mo[i] for i in sel)
        print(f'  {lo:5d}-{hi if hi < (1 << 30) else "max":>5}: {len(sel):6d} fns  {base} {sb / 1e6:9.3f} M  {other} {so / 1e6:9.3f} M  ratio {so / sb:.4f}')
    per = []
    for r in range(rounds):
        rb = sum(b[r][i][col] for i in range(n)); ro = sum(o[r][i][col] for i in range(n))
        per.append(f'{ro / rb:.4f}' if rb else '-')
    print('  each round: ' + ' '.join(per))
