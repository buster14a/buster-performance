import re, sys, collections
# rangediff.py MAINLO MAINHI HEADRANGES(lo-hi,lo-hi) [N]: ops/cycles by line text, main's range vs the head's ranges (p4)
mlo, mhi = int(sys.argv[1]), int(sys.argv[2])
hr = [tuple(map(int, r.split('-'))) for r in sys.argv[3].split(',')]
N = int(sys.argv[4]) if len(sys.argv) > 4 else 40
import os; f = os.environ.get('RF', 'c_direct_cc.c')
norm = lambda s: re.sub(r'\s+', ' ', s.strip())
tb = open('src-main/' + f).read().split('\n'); tw = open('src-p4/' + f).read().split('\n')
def load(path, P):
    d = collections.Counter()
    for line in open(path):
        m = re.match(r'\s*[\d.]+%\s+(\d+)\s+(\S+):(\d+)', line)
        if m and m.group(2) == f: d[int(m.group(3))] += int(m.group(1)) * P / 300 / 1e6
    return d
ob, cb = load('pu/op-lines-base.txt', 262144), load('pu/cyc-lines-base.txt', 100000)
ow, cw = load('pu/pu-op-lines-p4.txt', 262144), load('pu/pu-cyc-lines-p4.txt', 100000)
agg = collections.defaultdict(lambda: [0.0, 0.0, 0.0, 0.0, []])
for n in range(mlo, mhi + 1):
    t = norm(tb[n - 1]); agg[t][0] += ob[n]; agg[t][2] += cb[n]
for lo, hi in hr:
    for n in range(lo, hi + 1):
        t = norm(tw[n - 1]); agg[t][1] += ow[n]; agg[t][3] += cw[n]; agg[t][4].append(n)
rows = sorted(agg.items(), key=lambda kv: -(kv[1][1] - kv[1][0]))
tot = [sum(v[i] for v in agg.values()) for i in range(4)]
print('main ops %.3f cyc %.3f | head ops %.3f cyc %.3f | dops %+.3f dcyc %+.3f' % (tot[0], tot[2], tot[1], tot[3], tot[1] - tot[0], tot[3] - tot[2]))
for t, v in rows[:N]:
    print('%+.3f ops %+.3f cyc  (ops %.3f->%.3f)  %s  %s' % (v[1] - v[0], v[3] - v[2], v[0], v[1], ','.join(map(str, v[4][:3])), t[:100]))
print('... most negative:')
for t, v in rows[-8:]:
    print('%+.3f ops %+.3f cyc  (ops %.3f->%.3f)  %s  %s' % (v[1] - v[0], v[3] - v[2], v[0], v[1], ','.join(map(str, v[4][:3])), t[:100]))
