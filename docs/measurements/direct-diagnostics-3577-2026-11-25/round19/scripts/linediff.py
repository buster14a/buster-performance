import re, sys, collections
S = sys.argv[1]; kind = sys.argv[2]  # op or cyc
P = 262144 if kind == 'op' else 100000
def load(path):
    d = collections.Counter()
    for line in open(path):
        m = re.match(r'\s*[\d.]+%\s+(\d+)\s+(\S+):(\d+)', line)
        if m: d[(m.group(2), int(m.group(3)))] += int(m.group(1))
    return d
def texts(root):
    t = {}
    for f in ['c_direct_cc.c', 'c_direct_types.c', 'c_direct_lex.c', 'c_direct_x86.c', 'c_direct.c']:
        try: t[f] = open(root + '/' + f).read().split('\n')
        except FileNotFoundError: pass
    return t
tb = texts(S + '/src-main'); tw = texts('/home/user/buster/src/buster/compiler')
b = load(S + '/pu/%s-lines-base.txt' % kind); w = load(S + '/pu/%s-lines-work.txt' % kind)
def key(t, f, n):
    if f in t and 0 < n <= len(t[f]): return (f, re.sub(r'\s+', ' ', t[f][n-1].strip()))
    return (f, '#%d' % n)
agg = collections.defaultdict(lambda: [0, 0, set()])
for (f, n), c in b.items(): k = key(tb, f, n); agg[k][0] += c
for (f, n), c in w.items(): k = key(tw, f, n); agg[k][1] += c; agg[k][2].add(n)
rows = sorted(agg.items(), key=lambda kv: -(kv[1][1] - kv[1][0]))
scale = P / 300 / 1e6
print('delta(M)  base  work  file:lines  text')
for (f, txt), (cb, cw, lines) in rows[:int(sys.argv[3])]:
    print('%+.3f %7.3f %7.3f  %s:%s  %s' % ((cw - cb) * scale, cb * scale, cw * scale, f.replace('c_direct_', ''), ','.join(str(x) for x in sorted(lines)[:3]), txt[:120]))
