import sys
for path in sys.argv[1:]:
    rows = {}
    for line in open(path):
        if line.startswith('#'):
            continue
        p = line.rstrip('\n').split('\t')
        rows[(p[0], p[1], p[4])] = (int(p[0]), int(p[1]), p[3])
    rows = list(rows.values())
    end = max(e for s, e, o in rows)
    work = sum(e - s for s, e, o in rows)
    idle = sum(max(0, 4 - sum(1 for s, e, o in rows if s <= t < e)) for t in range(0, end, 1000))
    top = sorted(rows, key=lambda r: r[0] - r[1])[:3]
    print('%-40s wall %6.1f s  step work %7.1f s  idle CPU-s %4d  longest: %s' % (path.split('/')[-1], end / 1e3, work / 1e3, idle,
          ', '.join('%s %.1f' % (o.split('/')[-1], (e - s) / 1e3) for s, e, o in top)))
