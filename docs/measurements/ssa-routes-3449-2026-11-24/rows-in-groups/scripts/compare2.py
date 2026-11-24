# compare.py DIR KIND CONFIG BASE OTHER ROUNDS: per-function median ticks over rounds from DIR/CONFIG-SETTING-R.txt
# (promote lines: blocks slots instructions ticks; optimize lines: blocks instructions ticks), OTHER/BASE by size bin.
import sys, os, statistics
d, kind, config, base, other, rounds = sys.argv[1], sys.argv[2], sys.argv[3], sys.argv[4], sys.argv[5], int(sys.argv[6]); col = int(sys.argv[7])
def rows(s, r):
    return [list(map(int, l.split())) for l in open(os.path.join(d, f"{config}-{s}-{r}.txt")) if l.strip()]
b = [rows(base, r) for r in range(1, rounds + 1)]
o = [rows(other, r) for r in range(1, rounds + 1)]
n = len(b[0])
assert all(len(x) == n for x in b + o), [len(x) for x in b + o]
key = (lambda row: row[:3]) if kind == 'promote' else (lambda row: row[:2])
assert all(key(x[i]) == key(b[0][i]) for x in b + o for i in range(n))
if kind == 'promote':
    size = lambda row: row[0] * row[1]; label = 'cells'
    bins = [(0, 64), (64, 256), (256, 1024), (1024, 4096), (4096, 16384), (16384, 65536), (65536, 1 << 40)]
else:
    size = lambda row: row[1]; label = 'instructions'
    bins = [(0, 32), (32, 128), (128, 512), (512, 2048), (2048, 8192), (8192, 1 << 40)]
mb = [statistics.median(x[i][col] for x in b) for i in range(n)]
mo = [statistics.median(x[i][col] for x in o) for i in range(n)]
print(f'{config} {kind}: {other}/{base} total {sum(mo) / sum(mb):.4f} ({n} functions, {base} {sum(mb) / 1e6:.2f} M ticks)')
for lo, hi in bins:
    sel = [i for i in range(n) if lo <= size(b[0][i]) < hi]
    if not sel:
        continue
    sb = sum(mb[i] for i in sel); so = sum(mo[i] for i in sel)
    slower = sum(1 for i in sel if mo[i] > mb[i])
    print(f'  {label} {lo:6d}-{hi if hi < (1 << 40) else "max":>6}: {len(sel):6d} fns  {base} {sb / 1e6:9.3f} M  {other} {so / 1e6:9.3f} M  ratio {so / sb:.4f}  {other} slower in {slower}')
per = []
for r in range(rounds):
    rb = sum(b[r][i][-1] for i in range(n)); ro = sum(o[r][i][-1] for i in range(n))
    per.append(f'{ro / rb:.4f}')
print('  each round: ' + ' '.join(per))
