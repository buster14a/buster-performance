# #2972: Tier 0 compile's gate with the fixed setup cut (gate.sh): compile's ticks with its twin (0x1) against the
# vector path (0), by Tier 0 entries; the k-th call pairs across runs, each call the median of the five rounds; then each
# bin round by round. tiny.c's 2,000 calls are the last of each run's (objects.sh compiles it last), shown apart.
# Run in this directory.
import statistics
d = 'ticks'
rounds = 5
tiny_calls = 2000
def calls(mask):
    per = [[tuple(map(int, l.split())) for l in open(f'{d}/{mask}-{r}.txt') if l.strip() and l.split()[0] == '0'] for r in range(1, rounds + 1)]
    n = len(per[0])
    assert all(len(p) == n for p in per), [len(p) for p in per]
    return per
v = calls('0'); s = calls('0x1')
assert len(v[0]) == len(s[0])
n = len(v[0])
vm = [statistics.median(v[r][i][2] for r in range(rounds)) for i in range(n)]
sm = [statistics.median(s[r][i][2] for r in range(rounds)) for i in range(n)]
size = [v[0][i][1] for i in range(n)]
assert all(s[0][i][1] == size[i] for i in range(n))
bins = [(0, 2), (2, 4), (4, 8), (8, 16), (16, 64), (64, 256), (256, 1024), (1024, 1 << 30)]
for label, lo_i, hi_i in (('corpora', 0, n - tiny_calls), ('tiny.c', n - tiny_calls, n)):
    idx = range(lo_i, hi_i)
    tv = sum(vm[i] for i in idx); ts = sum(sm[i] for i in idx)
    print(f'{label}: {hi_i - lo_i} calls, scalar/vector {ts / tv:.3f}')
    for lo, hi in bins:
        sel = [i for i in idx if lo <= size[i] < hi]
        if not sel:
            continue
        bv = sum(vm[i] for i in sel); bs = sum(sm[i] for i in sel)
        per_round = [sum(s[r][i][2] for i in sel) / sum(v[r][i][2] for i in sel) for r in range(rounds)]
        print(f'  {lo:5d}-{hi if hi < (1 << 30) else "max":>5}: {len(sel):5d} calls  vector {bv / len(sel):7.0f}/call  scalar {bs / len(sel):7.0f}/call  s/v {bs / bv:.3f}  rounds ' + ' '.join(f'{x:.3f}' for x in per_round))
