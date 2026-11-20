import sys, re
def load(p):
    maps = {}
    cur = None
    for line in open(p):
        m = re.match(r'^([0-9a-f]+)-([0-9a-f]+) (\S+) \S+ \S+ \S+\s*(.*)$', line)
        if m:
            cur = (m.group(1), m.group(2), m.group(3), m.group(4))
            maps[cur] = {}
            continue
        m = re.match(r'^(\w+):\s+(\d+) kB', line)
        if m and cur:
            maps[cur][m.group(1)] = int(m.group(2))
    return maps
a = load(sys.argv[1]); b = load(sys.argv[2])
keys = sorted(set(a) | set(b))
for k in keys:
    ra = a.get(k, {}).get('Rss', 0); rb = b.get(k, {}).get('Rss', 0)
    if ra != rb:
        print('%s-%s %s %-50s Rss %6d -> %6d kB (%+d)  size %d kB' % (k[0], k[1], k[2], k[3][-50:], ra, rb, rb - ra, b.get(k, a.get(k, {})).get('Size', 0)))
