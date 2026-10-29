#!/usr/bin/env python3
# Campaign SOI's processes (logs/SOI.txt: perf stat's user instructions and cycles, and the source order reading's
# ns/token): each unit's medians over the rounds, head against main.
#   soisum.py logs/SOI.txt HEAD MAIN
import re, statistics, sys
head, main = sys.argv[2], sys.argv[3]
current = None
data = {}
for line in open(sys.argv[1]):
    m = re.match(r'== round \d+ (\S+) (\S+) lanes 1', line)
    if m:
        current = (m.group(1), m.group(2))
        continue
    m = re.match(r'(\d+),,(instructions|cycles):u', line)
    if m and current:
        data.setdefault((current[0], current[1], m.group(2)), []).append(int(m.group(1)))
    m = re.search(r'source_order=([\d.]+) ns/token', line)
    if m and current:
        data.setdefault((current[0], current[1], 'source order'), []).append(float(m.group(1)))
units = []
for (tree, unit, _) in data:
    if unit not in units:
        units.append(unit)
for unit in units:
    out = [unit]
    for field in ('instructions', 'cycles', 'source order'):
        h = statistics.median(data[(head, unit, field)])
        m = statistics.median(data[(main, unit, field)])
        out.append('%s %s against %s (%+.3f%%)' % (field, h, m, 100 * (h / m - 1)))
    print(' | '.join(out))
