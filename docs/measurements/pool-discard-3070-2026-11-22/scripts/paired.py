import sys, glob, os, re, collections, statistics
out, a, b = sys.argv[1], sys.argv[2], sys.argv[3]
vals = collections.defaultdict(dict)
for f in glob.glob(os.path.join(out, 'perf-*.csv')):
    m = re.match(r'perf-(\w+)-(.+)\.(\d+)\.csv', os.path.basename(f))
    label, build, rnd = m.group(1), m.group(2), int(m.group(3))
    d = {}
    for line in open(f):
        p = line.strip().split(',')
        if len(p) > 3:
            try: d[p[2]] = float(p[0])
            except ValueError: pass
    vals[(label, rnd)][build] = d
for label in sorted({k[0] for k in vals}):
    for ev in ('cycles:k', 'cycles:u', 'all'):
        diffs = []
        for (l, r), bs in sorted(vals.items()):
            if l != label or a not in bs or b not in bs: continue
            g = lambda d: d['cycles:u'] + d['cycles:k'] if ev == 'all' else d[ev]
            diffs.append(100.0 * (g(bs[b]) - g(bs[a])) / g(bs[a]))
        print('%-6s %-9s rounds %d: median %+.2f%%, min %+.2f%%, max %+.2f%%, lower in %d' % (label, ev, len(diffs), statistics.median(diffs), min(diffs), max(diffs), sum(1 for x in diffs if x < 0)))
