import sys, glob, os, statistics, re, collections
out = sys.argv[1]
data = collections.defaultdict(lambda: collections.defaultdict(list))
for f in glob.glob(os.path.join(out, 'perf-*.csv')):
    m = re.match(r'perf-(\w+)-(.+)\.(\d+)\.csv', os.path.basename(f))
    label, build, rnd = m.group(1), m.group(2), m.group(3)
    vals = {}
    for line in open(f):
        p = line.strip().split(',')
        if len(p) > 3 and p[2] in ('cycles:u','cycles:k','instructions:u','page-faults','task-clock'):
            try: vals[p[2]] = float(p[0])
            except ValueError: pass
    for k, v in vals.items():
        data[(label, build)][k].append(v)
print('%-8s %-10s %4s %10s %10s %10s %12s %10s %9s' % ('work', 'build', 'n', 'user Mc', 'kern Mc', 'all Mc', 'user Minstr', 'faults', 'task ms'))
for (label, build) in sorted(data):
    d = data[(label, build)]
    med = lambda k: statistics.median(d[k]) if d[k] else float('nan')
    allc = [u + k for u, k in zip(d['cycles:u'], d['cycles:k'])]
    print('%-8s %-10s %4d %10.1f %10.1f %10.1f %12.1f %10.0f %9.1f' % (label, build, len(d['cycles:u']), med('cycles:u') / 1e6, med('cycles:k') / 1e6, statistics.median(allc) / 1e6,
          med('instructions:u') / 1e6, med('page-faults'), med('task-clock')))
