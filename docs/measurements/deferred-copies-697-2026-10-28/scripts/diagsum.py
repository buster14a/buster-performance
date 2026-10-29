# Summary of a diagnostic log (3-runs.sh's format): per unit and tree, each round's lanes=1 and lanes=8 rows' whole,
# top, walks, positions, lanes_span, merge, rest and copy, and the trees' medians over the rounds.
import sys, re, collections, statistics
rows = collections.defaultdict(list)
head = None
for line in open(sys.argv[1]):
    m = re.match(r'== round (\d+) (\S+) (\S+) lanes (\d+)', line)
    if m:
        head = (m.group(3), m.group(2), int(m.group(1)))
        continue
    m = re.search(r'lanes=(\d+) active=(\d+) copies=\d+ whole=([\d.]+) top=([\d.]+) environment=[\d.]+ walks=([\d.]+) positions=([\d.]+) lanes_span=([\d.]+) merge=([\d.]+) rest=([\d.]+) ns/token, positions=[\d.]+ ns/body, copy=(\d+)', line)
    if m and head:
        lanes = int(m.group(1))
        vals = [float(m.group(i)) for i in range(3, 10)] + [float(m.group(10)) / 1000]
        rows[(head[0], head[1], lanes)].append(vals)
names = ['whole', 'top', 'walks', 'pos', 'span', 'merge', 'rest', 'copy_us']
units = sorted(set(k[0] for k in rows))
for unit in units:
    print('== %s' % unit)
    for lanes in (1, 8):
        print('  lanes=%d   %s' % (lanes, ' '.join('%8s' % n for n in names)))
        for key in sorted(k for k in rows if k[0] == unit and k[2] == lanes):
            v = rows[key]
            med = [statistics.median(x[i] for x in v) for i in range(len(names))]
            print('  %-22s %s  (n=%d)' % (key[1], ' '.join('%8.2f' % x for x in med), len(v)))
