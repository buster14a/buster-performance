#!/usr/bin/env python3
# summarize.py LOGS: the -fsyntax-only table (perf stat's means over 15 runs, two rounds) and benchmark-checker-source's
# body-graph medians, from stat-TREE-PLACE-ROUND.txt and source-TREE-PLACE-1.txt.
import glob, os, re, statistics, sys
logs = sys.argv[1]
rows = {}
for path in glob.glob(os.path.join(logs, 'stat-*.txt')):
    tree, place, rnd = re.match(r'stat-(main|head)-(s\d+(?:-copy)?)-(\d)\.txt', os.path.basename(path)).groups()
    values = {}
    for line in open(path):
        fields = line.strip().split(',')
        if len(fields) > 3 and fields[0].replace('.', '').isdigit():
            values[fields[2].split(':')[0]] = float(fields[0])
    rows[(tree, place, rnd)] = values
places = ['s0', 's0-copy', 's16', 's32', 's48', 's64', 's1024']
def mean(tree, place, event):
    return (rows[(tree, place, '1')][event] + rows[(tree, place, '2')][event]) / 2
print('| Placement | main cycles (rounds 1, 2) | head cycles (rounds 1, 2) | head - main | main stli_other | head stli_other |')
print('| --- | ---: | ---: | ---: | ---: | ---: |')
deltas = []
for place in places:
    m = [rows[('main', place, r)]['cycles'] / 1e6 for r in '12']
    h = [rows[('head', place, r)]['cycles'] / 1e6 for r in '12']
    d = 100 * (sum(h) / sum(m) - 1)
    deltas.append(d)
    print(f'| {place} | {m[0]:.1f}, {m[1]:.1f} M | {h[0]:.1f}, {h[1]:.1f} M | {d:+.2f}% | '
          f'{mean("main", place, "ls_bad_status2.stli_other") / 1e6:.3f} M | {mean("head", place, "ls_bad_status2.stli_other") / 1e6:.3f} M |')
for event in ['cycles', 'instructions', 'ls_bad_status2.stli_other', 'ex_ret_brn_misp']:
    m = statistics.mean(mean('main', p, event) for p in places)
    h = statistics.mean(mean('head', p, event) for p in places)
    print(f'{event}: main {m / 1e6:.3f} M, head {h / 1e6:.3f} M, {h - m:+,.0f} ({100 * (h / m - 1):+.2f}%)')
print(f'per-placement cycle deltas: mean {statistics.mean(deltas):+.2f}%, sd {statistics.stdev(deltas):.2f}%, '
      f'lower at {sum(d < 0 for d in deltas)} of {len(deltas)}')
print()
print('| Placement | main scalar | head scalar | main vector | head vector |')
print('| --- | ---: | ---: | ---: | ---: |')
for place in ['s0', 's16', 's32', 's48', 's64', 's1024']:
    cells = []
    for path_name in ['scalar', 'vector']:
        for tree in ['main', 'head']:
            text = open(os.path.join(logs, f'source-{tree}-{place}-1.txt')).read()
            cells.append(float(re.search(rf'path={path_name} ns_per_node=[0-9.]+ cycles_per_node=([0-9.]+)', text).group(1)))
    print(f'| {place} | {cells[0]:.1f} | {cells[1]:.1f} | {cells[2]:.1f} | {cells[3]:.1f} |')
