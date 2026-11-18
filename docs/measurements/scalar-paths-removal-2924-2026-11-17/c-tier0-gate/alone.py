# #2924 C8's gate, each area alone (alone.sh): compile's ticks with its bit alone (0x1) and validation's with its bit
# alone (0x2), each against no bit (0), by Tier 0 entries; the k-th call of an area pairs across runs, each call the
# median of the five rounds; then each small bin round by round. Run in this directory.
import statistics
d = 'ticks-alone'
rounds = 5
def calls(mask, area):
    per = [[tuple(map(int, l.split())) for l in open(f'{d}/{mask}-{r}.txt') if l.strip() and l.split()[0] == str(area)] for r in range(1, rounds + 1)]
    n = len(per[0])
    assert all(len(p) == n for p in per)
    return per
bins = [(0, 2), (2, 4), (4, 8), (8, 16), (16, 64), (64, 256), (256, 1024), (1024, 1 << 30)]
for area, name, mask in ((0, 'compile', '0x1'), (1, 'validation', '0x2')):
    v = calls('0', area); s = calls(mask, area)
    assert len(v[0]) == len(s[0])
    n = len(v[0])
    vm = [statistics.median(v[r][i][2] for r in range(rounds)) for i in range(n)]
    sm = [statistics.median(s[r][i][2] for r in range(rounds)) for i in range(n)]
    size = [v[0][i][1] for i in range(n)]
    print(f'{name} ({mask} against 0): {n} calls, scalar/vector {sum(sm) / sum(vm):.3f}')
    for lo, hi in bins:
        sel = [i for i in range(n) if lo <= size[i] < hi]
        if not sel:
            continue
        bv = sum(vm[i] for i in sel); bs = sum(sm[i] for i in sel)
        per_round = [sum(s[r][i][2] for i in sel) / sum(v[r][i][2] for i in sel) for r in range(rounds)]
        print(f'  {lo:5d}-{hi if hi < (1 << 30) else "max":>5}: {len(sel):5d} calls  vector {bv / len(sel):7.0f}/call  scalar {bs / len(sel):7.0f}/call  s/v {bs / bv:.3f}  rounds ' + ' '.join(f'{x:.3f}' for x in per_round))
