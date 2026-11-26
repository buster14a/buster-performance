import re, sys, collections
# region.py S kind file base_lo base_hi work_lo work_hi: samples (M per compile) in a line range of main's and the head's file
S, kind, f = sys.argv[1], sys.argv[2], sys.argv[3]
bl, bh, wl, wh = map(int, sys.argv[4:8])
P = 262144 if kind == 'op' else 100000
def load(path):
    d = collections.Counter()
    for line in open(path):
        m = re.match(r'\s*[\d.]+%\s+(\d+)\s+(\S+):(\d+)', line)
        if m and m.group(2) == f: d[int(m.group(3))] += int(m.group(1))
    return d
b = load(S + '/pu/%s-lines-base.txt' % kind); w = load(S + '/pu/%s-lines-work.txt' % kind)
sb = sum(c for n, c in b.items() if bl <= n <= bh) * P / 300 / 1e6
sw = sum(c for n, c in w.items() if wl <= n <= wh) * P / 300 / 1e6
print('%s %s: main %.3f head %.3f delta %+.3f' % (kind, ' '.join(sys.argv[3:8]), sb, sw, sw - sb))
