# gate2.py DIR ROUNDS: per bin, the twin's ticks over the vector path's from per-call medians (sum ratio), the median of the
# per-call ratios; the calls past 50,000 ticks an entry in either (a process's first compile, which pays one-time costs: the
# tables' and arenas' first use) are set aside and listed.
import statistics, sys
d = sys.argv[1]; rounds = int(sys.argv[2]); tiny_calls = 2000
def calls(mask):
    return [[tuple(map(int, l.split())) for l in open(f'{d}/{mask}-{r}.txt') if l.strip() and l.split()[0] == '0'] for r in range(1, rounds + 1)]
v = calls('0'); s = calls('0x1')
n = len(v[0])
vm = [statistics.median(v[r][i][2] for r in range(rounds)) for i in range(n)]
sm = [statistics.median(s[r][i][2] for r in range(rounds)) for i in range(n)]
size = [v[0][i][1] for i in range(n)]
bins = [(0, 2), (2, 4), (4, 8), (8, 16), (16, 64), (64, 256), (256, 1024), (1024, 1 << 30)]
for label, lo_i, hi_i in (('corpora', 0, n - tiny_calls), ('tiny.c', n - tiny_calls, n)):
    idx = range(lo_i, hi_i)
    allk = [i for i in idx if max(vm[i], sm[i]) <= 50000 * max(size[i], 1)]
    print(f'{label}: {hi_i - lo_i} calls, twin/vector {sum(sm[i] for i in idx) / sum(vm[i] for i in idx):.3f}, without the set-aside calls {sum(sm[i] for i in allk) / sum(vm[i] for i in allk):.3f}')
    for lo, hi in bins:
        sel = [i for i in idx if lo <= size[i] < hi]
        if not sel:
            continue
        big = [i for i in sel if max(vm[i], sm[i]) > 50000 * max(size[i], 1)]
        kept = [i for i in sel if i not in big]
        bv = sum(vm[i] for i in kept); bs = sum(sm[i] for i in kept)
        med = statistics.median(sm[i] / vm[i] for i in sel)
        print(f'  {lo:5d}-{hi if hi < (1 << 30) else "max":>5}: {len(sel):5d} calls  vector {bv / len(kept):7.0f}  twin {bs / len(kept):7.0f}  sums {bs / bv:.3f}  median per call {med:.3f}  set aside: {len(big)}' + ''.join(f' [call {i}: {size[i]} entries, vector {vm[i]:.0f}, twin {sm[i]:.0f}]' for i in big[:3]))
