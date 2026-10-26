#!/usr/bin/env python3
# sweep445.py results445s.tsv out445s results445d.tsv: #445's sweeps by the initial stack's offset in its page. First the
# benchmark's (sweep445-*.list: benchmark-checker-source --only scalar --passes 7, two sweeps): each offset's ns per
# node of main (base) and the head, marked * past 2% over the median of all, with the processes' store-to-load
# conflicts (ls_bad_status2.stli_other, r0224) in millions. Then the driver's (driver445-*.list: -fsyntax-only of the
# same source, three processes each): each offset's median wall time, marked * past 1.5% over the median of all.
import collections
import os
import re
import statistics as st
import sys


def counters(fields):
    return {kv.split('=')[0]: int(kv.split('=')[1].rstrip('*')) for kv in fields}


rows = [line.rstrip('\n').split('\t') for line in open(sys.argv[1])][1:]
points = collections.defaultdict(lambda: collections.defaultdict(list))
conflicts = collections.defaultdict(lambda: collections.defaultdict(list))
for row in rows:
    if row[0] == 'round':
        continue
    tree = row[2].split('-')[0]
    offset = int(row[16]) % 4096
    text = open(os.path.join(sys.argv[2], f'{row[0]}-{row[2]}-0.out')).read()
    match = re.search(r'path=scalar ns_per_node=([\d.]+)', text)
    points[offset][tree].append(float(match.group(1)))
    conflicts[offset][tree].append(counters(row[17:])['r0224'] / 1e6)
median = st.median(v for o in points for t in points[o] for v in points[o][t])
slow = {t: 0 for t in ('base', 'head')}
print(f'benchmark-checker-source --only scalar --passes 7: median of all {median:.3f} ns/node')
print(f'{"offset":>6s} {"base ns/node":>16s}  {"head ns/node":>16s}   conflicts M base/head')
for offset in sorted(points):
    cells = []
    for tree in ('base', 'head'):
        v = points[offset][tree]
        marked = st.median(v) > median * 1.02
        slow[tree] += marked
        cells.append(f'{" ".join(f"{x:7.3f}" for x in v):>16s}{"*" if marked else " "}')
    print(f'{offset:6d} {cells[0]} {cells[1]}   {st.median(conflicts[offset]["base"]):5.1f}/{st.median(conflicts[offset]["head"]):5.1f}')
print(f'slow offsets: base {slow["base"]} of {len(points)}, head {slow["head"]} of {len(points)}')
print()
rows = [line.rstrip('\n').split('\t') for line in open(sys.argv[3])][1:]
walls = collections.defaultdict(lambda: collections.defaultdict(list))
offsets = {}
statuses = collections.Counter()
for row in rows:
    if row[0] == 'round':
        continue
    tree, k = row[2].split('-')
    statuses[row[5]] += 1
    if int(row[16]) >= 0:
        offsets[int(k[1:])] = int(row[16]) % 4096
    walls[int(k[1:])][tree].append(int(row[6]) / 1e6)
median = st.median(v for k in walls for t in walls[k] for v in walls[k][t])
print(f'the driver, -fsyntax-only: exit statuses {dict(statuses)}, median of all {median:.2f} ms')
print(f'{"offset":>6s} {"base ms":>8s} {"head ms":>8s}')
for k in sorted(walls, key=lambda k: offsets.get(k, -1)):
    b = st.median(walls[k]['base'])
    h = st.median(walls[k]['head'])
    print(f'{offsets.get(k, -1):6d} {b:8.2f}{"*" if b > median * 1.015 else " "} {h:8.2f}{"*" if h > median * 1.015 else " "}')
allb = [v for k in walls for v in walls[k]['base']]
allh = [v for k in walls for v in walls[k]['head']]
print(f'all offsets: base {min(allb):.2f} to {max(allb):.2f} ms, head {min(allh):.2f} to {max(allh):.2f} ms')
