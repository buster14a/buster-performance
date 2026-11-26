import re, sys, collections
# mainstall.py: main's own stalls from the unthrottled profiles: per line, cycles - ops x main's mean cycles per op.
S = sys.argv[1]
def load(path, period):
    d = collections.Counter()
    for line in open(path):
        m = re.match(r'\s*[\d.]+%\s+(\d+)\s+(\S+):(\d+)', line)
        if m: d[(m.group(2), int(m.group(3)))] += int(m.group(1)) * period / 300 / 1e6
    return d
cyc = load(S + '/pu/cyc-lines-base.txt', 100000)
ops = load(S + '/pu/op-lines-base.txt', 262144)
tc, to = sum(cyc.values()), sum(ops.values())
mean = tc / to
print('main: %.2f M cycles, %.2f M ops, %.3f cycles/op' % (tc, to, mean))
files = collections.defaultdict(lambda: [0.0, 0.0])
for k, v in cyc.items(): files[k[0]][0] += v
for k, v in ops.items(): files[k[0]][1] += v
print('\nby file (cycles M, ops M, cycles/op, excess M):')
for f, (c, o) in sorted(files.items(), key=lambda x: -x[1][0])[:25]:
    print('  %-48s %7.2f %7.2f %6.3f %+7.2f' % (f, c, o, c / o if o else 0, c - o * mean))
keys = set(cyc) | set(ops)
rows = [(cyc[k] - ops[k] * mean, cyc[k], ops[k], k) for k in keys]
rows.sort(reverse=True)
print('\ntop lines by excess cycles (excess, cycles, ops):')
for e, c, o, k in rows[:70]:
    print('  %+6.3f %6.3f %6.3f  %s:%d' % (e, c, o, k[0], k[1]))
