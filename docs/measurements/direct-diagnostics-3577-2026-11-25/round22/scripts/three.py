import re, sys
# three.py [N]: per function, main (pu7 base), head (pu7 work) and the ALL arm (pu7/pu-*-all.txt): ops and cycles a
# compile (M), the conditions' share (head - ALL) and the floor (ALL - main), ranked by |head - main| cycles.
N = int(sys.argv[1]) if len(sys.argv) > 1 else 50
def load(f):
    d = {}
    for line in open('pu7/' + f):
        m = re.match(r'\s*([\d.]+)%\s+(\d+)\s+\[\.\]\s+(\S+)', line)
        if m: d[m.group(3)] = d.get(m.group(3), 0) + int(m.group(2))
    return d
fc = 1e5 / 300 / 1e6; fo = 262144 / 300 / 1e6
C = {t: load('pu-cyc-%s.txt' % t) for t in ['base', 'work', 'all']}
O = {t: load('pu-op-%s.txt' % t) for t in ['base', 'work', 'all']}
tot = lambda d, f: sum(d.values()) * f
print('totals: cycles main %.2f head %.2f all %.2f | ops main %.2f head %.2f all %.2f' % tuple(
    [tot(C[t], fc) for t in ['base', 'work', 'all']] + [tot(O[t], fo) for t in ['base', 'work', 'all']]))
names = set().union(*[set(C[t]) for t in C], *[set(O[t]) for t in O])
rows = []
for k in names:
    c = [C[t].get(k, 0) * fc for t in ['base', 'work', 'all']]
    o = [O[t].get(k, 0) * fo for t in ['base', 'work', 'all']]
    rows.append((c, o, k))
rows.sort(key=lambda r: -abs(r[0][1] - r[0][0]))
print('%-40s %26s %26s %22s %22s' % ('function', 'cycles main/head/all', 'ops main/head/all', 'cond (h-a) cyc/ops', 'floor (a-m) cyc/ops'))
for c, o, k in rows[:N]:
    print('%-40s %8.3f %8.3f %8.3f %8.3f %8.3f %8.3f   %+7.3f %+7.3f   %+7.3f %+7.3f' % (k[:40], c[0], c[1], c[2], o[0], o[1], o[2], c[1] - c[2], o[1] - o[2], c[2] - c[0], o[2] - o[0]))
