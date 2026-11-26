import re, sys, collections
# linediff2.py S WORKTAG FILE LO HI [N]: per-line (text-matched) op and cycle deltas of the head's lines LO..HI of FILE
# against main's (pu/{op,cyc}-lines-base.txt vs pu/pu-{op,cyc}-lines-WORKTAG.txt).
S, tag, fname, lo, hi = sys.argv[1], sys.argv[2], sys.argv[3], int(sys.argv[4]), int(sys.argv[5])
N = int(sys.argv[6]) if len(sys.argv) > 6 else 40
def load(path):
    d = collections.Counter()
    for line in open(path):
        m = re.match(r'\s*[\d.]+%\s+(\d+)\s+(\S+):(\d+)', line)
        if m and m.group(2) == fname: d[int(m.group(3))] += int(m.group(1))
    return d
tb = open(S + '/src-main/' + fname).read().split('\n')
import os; tw = open(os.environ.get('HEADSRC', '/home/user/buster/src/buster/compiler') + '/' + fname).read().split('\n')
norm = lambda s: re.sub(r'\s+', ' ', s.strip())
# The head's lines in range, by text; main's lines with the same text anywhere in main's matching function range are
# unknown, so match main's lines by text globally but only for texts the head's range has.
wanted = {norm(tw[n - 1]) for n in range(lo, hi + 1)}
res = {}
for kind, P in (('op', 262144), ('cyc', 100000)):
    b = load(S + '/pu/%s-lines-base.txt' % kind); w = load(S + '/pu/pu-%s-lines-%s.txt' % (kind, tag))
    agg = collections.defaultdict(lambda: [0.0, 0.0, set()])
    for n, c in w.items():
        if lo <= n <= hi: agg[norm(tw[n - 1])][1] += c * P / 300 / 1e6; agg[norm(tw[n - 1])][2].add(n)
    for n, c in b.items():
        if 0 < n <= len(tb) and norm(tb[n - 1]) in wanted: agg[norm(tb[n - 1])][0] += c * P / 300 / 1e6
    res[kind] = agg
keys = set(res['op']) | set(res['cyc'])
rows = []
for k in keys:
    o = res['op'].get(k, [0, 0, set()]); c = res['cyc'].get(k, [0, 0, set()])
    rows.append((c[1] - c[0], o[1] - o[0], c[0], c[1], o[0], o[1], sorted(o[2] | c[2]), k))
rows.sort(reverse=True)
print('dcyc   dops   (cyc main->head)  lines  text')
for dc, do, cb, cw, ob, ow, lines, k in rows[:N]:
    print('%+.3f %+.3f (%.3f->%.3f)  %s  %s' % (dc, do, cb, cw, ','.join(map(str, lines[:3])), k[:110]))
tot = [sum(r[i] for r in rows) for i in (0, 1)]
print('range total: dcyc %+.3f dops %+.3f (text-matched; main lines whose text left are not subtracted)' % tuple(tot))
