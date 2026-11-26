import re, sys, collections
# symdiff2.py FUNCS A B [N]: within functions (comma list), cycles and ops by (file, line text) between two profiles:
# A and B each one of main (pu7 base, src-main), head (pu7 work, src-q7), all (pu7 all, ablall sources).
fns = set(sys.argv[1].split(',')); A, B = sys.argv[2], sys.argv[3]; N = int(sys.argv[4]) if len(sys.argv) > 4 else 40
cfg = {'main': ('base', 'src-main/'), 'head': ('work', 'src-q7/'), 'all': ('all', 'ablall/src/buster/compiler/')}
norm = lambda s: re.sub(r'\s+', ' ', s.strip())
files = ['c_direct_cc.c', 'c_direct_types.c', 'c_direct_lex.c', 'c_direct_x86.c', 'c_direct.c']
def load(path, P):
    d = collections.Counter()
    for line in open(path):
        m = re.match(r'\s*[\d.]+%\s+(\d+)\s+\[\.\]\s+(\S+)\s+(\S+):(\d+)', line)
        if m and m.group(2) in fns: d[(m.group(3), int(m.group(4)))] += int(m.group(1)) * P / 300 / 1e6
    return d
agg = collections.defaultdict(lambda: [0.0, 0.0, 0.0, 0.0, set(), set()])
for side, tag in [(0, A), (1, B)]:
    prof, srcdir = cfg[tag]
    src = {f: open(srcdir + f).read().split('\n') for f in files}
    for kind, P, slot in [('cyc', 100000, 0), ('op', 262144, 1)]:
        for k, v in load('pu7/pu-%s-symlines-%s.txt' % (kind, prof), P).items():
            f, n = k
            t = (f.replace('c_direct_', ''), norm(src[f][n - 1]) if f in src and 0 < n <= len(src[f]) else '<line %d>' % n)
            agg[t][side * 2 + slot] += v
            agg[t][4 + side].add(n)
tot = [sum(v[i] for v in agg.values()) for i in range(4)]
print('%s: %s cyc %.3f ops %.3f | %s cyc %.3f ops %.3f' % (sys.argv[1], A, tot[0], tot[1], B, tot[2], tot[3]))
rows = sorted(agg.items(), key=lambda kv: -(kv[1][2] - kv[1][0]))
fmt = lambda t, v: '%+.3f cyc %+.3f ops (cyc %.3f->%.3f ops %.3f->%.3f) %s %s/%s  %s' % (v[2] - v[0], v[3] - v[1], v[0], v[2], v[1], v[3], t[0], ','.join(map(str, sorted(v[4])[:2])), ','.join(map(str, sorted(v[5])[:2])), t[1][:84])
for t, v in rows[:N]: print(fmt(t, v))
print('... most negative:')
for t, v in rows[-10:]: print(fmt(t, v))
