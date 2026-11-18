# #2924 C7's gate, one area against vector: compare.py TICKS_DIR BASE OTHER ROUNDS REGION... reads TICKS_DIR/MASK-R.txt
# for both masks and rounds 1..ROUNDS, takes each function's median per region over the rounds, and prints OTHER/BASE
# by the function's IR size, then each round's own total ratio (the spread). Region numbers as in analyze.py.
import sys, os, statistics
regions = ['select', 'chain-liveness', 'chain-allocate', 'chain-prepare', 'chain-records', 'cfg-problem', 'cfg-allocation', 'preference', 'cfg-records', 'schedule', 'debug']
bins = [(1, 16), (16, 64), (64, 256), (256, 1024), (1024, 1 << 30)]
d, base, other, rounds = sys.argv[1], sys.argv[2], sys.argv[3], int(sys.argv[4])
wanted = [int(x) for x in sys.argv[5:]]
def rows(mask, r):
    return [list(map(int, l.split())) for l in open(os.path.join(d, f'{mask}-{r}.txt')) if l.strip()]
b = [rows(base, r) for r in range(1, rounds + 1)]
o = [rows(other, r) for r in range(1, rounds + 1)]
n = len(b[0])
assert all(len(x) == n for x in b + o)
assert all(x[i][1] == b[0][i][1] for x in b + o for i in range(n))
for k in wanted:
    col = 2 + k
    mb = [statistics.median(x[i][col] for x in b) for i in range(n)]
    mo = [statistics.median(x[i][col] for x in o) for i in range(n)]
    tb = sum(mb); to = sum(mo)
    print(f'{regions[k]}: {other}/{base} total {to / tb if tb else 0:.4f} (base {tb / 1e6:.1f} M ticks)')
    for lo, hi in bins:
        sel = [i for i in range(n) if lo <= b[0][i][1] < hi and mb[i] > 0]
        sb = sum(mb[i] for i in sel); so = sum(mo[i] for i in sel)
        print(f'  {lo:5d}-{hi if hi < (1 << 30) else "max":>5}: {len(sel):6d} fns  {base} {sb / 1e6:9.2f} M  {other} {so / 1e6:9.2f} M  ratio {so / sb if sb else 0:.4f}')
    per = []
    for r in range(rounds):
        rb = sum(b[r][i][col] for i in range(n)); ro = sum(o[r][i][col] for i in range(n))
        per.append(f'{ro / rb:.4f}' if rb else '-')
    print('  each round: ' + ' '.join(per))
