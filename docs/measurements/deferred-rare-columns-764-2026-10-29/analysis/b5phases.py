#!/usr/bin/env python3
# Campaign B5's readings by each tree's rule (the "lanes=8" lines of logs/B5.txt), head against main, by phase: the
# medians over the rounds of each tree's whole reading, top level, lanes' span, merge (and the merge's pass) and the
# phases after it, in ns/token, the head's and main's lanes, and the medians of the differences over the units that the
# head reads on more than one lane and more than 1% slower than main.
#   b5phases.py logs/B5.txt HEAD MAIN
import re, statistics, sys
head, main = sys.argv[2], sys.argv[3]
current = None
rows = {}
for line in open(sys.argv[1]):
    m = re.match(r'== round (\d+) (\S+) (\S+) lanes 8', line)
    if m:
        current = (m.group(2), m.group(3))
        continue
    m = re.search(r'lanes=8 active=(\d+) copies=\d+ whole=([\d.]+) top=([\d.]+) environment=[\d.]+ walks=[\d.]+ '
                  r'positions=[\d.]+ lanes_span=([\d.]+) merge=([\d.]+) rest=([\d.]+)', line)
    if m and current:
        active, whole, top, span, merge, rest = m.groups()
        rows.setdefault(current, []).append(dict(active=int(active), whole=float(whole), top=float(top),
                                                 span=float(span), merge=float(merge), rest=float(rest)))
        continue
    m = re.search(r'lanes=8 merge.s parts: .* pass=([\d.]+)', line)
    if m and current:
        rows[current][-1]['pass'] = float(m.group(1))
fields = ['whole', 'top', 'span', 'merge', 'pass', 'rest']
def median(readings, field):
    return statistics.median(r[field] for r in readings)
units = sorted({unit for (_, unit) in rows})
table = []
for unit in units:
    h, m = rows[(head, unit)], rows[(main, unit)]
    change = 100 * (median(h, 'whole') / median(m, 'whole') - 1)
    table.append((change, unit, h[0]['active'], m[0]['active'], {f: median(h, f) - median(m, f) for f in fields}))
table.sort()
print('unit lanes(head) lanes(main) change whole top span merge pass rest (head minus main, ns/token)')
for change, unit, lh, lm, d in table:
    print('%-18s %d %d %+6.1f%% %s' % (unit, lh, lm, change, ' '.join('%+6.2f' % d[f] for f in fields)))
slower = [t for t in table if t[0] > 1 and t[2] > 1]
print('units on more than one lane and more than 1%% slower: %d' % len(slower))
for f in fields:
    print('  %-5s median %+.2f' % (f, statistics.median(t[4][f] for t in slower)))
