import re, sys, collections
# stallscan.py S TAG: lines whose text is unique in both main's and the head's file, with more cycles in the head at
# about the same ops (a stall: forwarding, aliasing), from the unthrottled profiles.
S, tag = sys.argv[1], sys.argv[2]
files = ['c_direct_cc.c', 'c_direct_types.c', 'c_direct_lex.c', 'c_direct_x86.c', 'c_direct.c']
norm = lambda s: re.sub(r'\s+', ' ', s.strip())
def load(path):
    d = collections.Counter()
    for line in open(path):
        m = re.match(r'\s*[\d.]+%\s+(\d+)\s+(\S+):(\d+)', line)
        if m: d[(m.group(2), int(m.group(3)))] += int(m.group(1))
    return d
cb = load(S + '/pu/cyc-lines-base.txt'); ob = load(S + '/pu/op-lines-base.txt')
cw = load(S + '/pu/pu-cyc-lines-%s.txt' % tag); ow = load(S + '/pu/pu-op-lines-%s.txt' % tag)
rows = []
for f in files:
    tb = open(S + '/src-main/' + f).read().split('\n'); tw = open('/home/user/buster/src/buster/compiler/' + f).read().split('\n')
    cntb = collections.Counter(norm(x) for x in tb); cntw = collections.Counter(norm(x) for x in tw)
    posb = {norm(x): i + 1 for i, x in enumerate(tb) if cntb[norm(x)] == 1}
    for i, x in enumerate(tw):
        t = norm(x)
        if len(t) < 12 or cntw[t] != 1 or t not in posb: continue
        nb, nw = posb[t], i + 1
        c0 = cb.get((f, nb), 0) * 1e5 / 300 / 1e6; c1 = cw.get((f, nw), 0) * 1e5 / 300 / 1e6
        o0 = ob.get((f, nb), 0) * 262144 / 300 / 1e6; o1 = ow.get((f, nw), 0) * 262144 / 300 / 1e6
        if c1 - c0 > 0.03 and (o1 - o0) < 0.25 * (c1 - c0): rows.append((c1 - c0, o1 - o0, c0, c1, f, nw, t))
rows.sort(reverse=True)
for r in rows[:30]: print('%+.3f cyc %+.3f ops (%.3f->%.3f) %s:%d  %s' % (r[0], r[1], r[2], r[3], r[4].replace('c_direct_', ''), r[5], r[6][:100]))
print('sum', sum(r[0] for r in rows))
