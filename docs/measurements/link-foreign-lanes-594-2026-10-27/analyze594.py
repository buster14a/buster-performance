#!/usr/bin/env python3
# analyze594.py TREE [DIR]: #594's sweep by TREE (results594-sweep-{small,big}-TREE.tsv and out594/'s --time reports in
# DIR). Each procbench call's first round is left out as its warm-up (sweep594.sh's calls: 10 rounds small, 3 big). For
# each kind and program, per way (1p: one lane pinned to CPU 2; 1: one lane unpinned; N: N lanes unpinned): the median
# wall time in us with its p10 and p90, and the medians of page faults, context switches, CPU time and peak RSS; then the
# --time stages' medians.
import collections
import glob
import os
import re
import statistics as st
import sys

TREE = sys.argv[1] if len(sys.argv) > 1 else 'v0'
D = sys.argv[2] if len(sys.argv) > 2 else os.path.expanduser('~/buster-fast-bench/perf-594-claude')
ROUNDS = {f'sweep-small-{TREE}': 10, f'sweep-big-{TREE}': 3}
WAYS = ['1p', '1', '2', '3', '4', '6', '8', 'd']
KINDS = {'d': 'dynamic PIE', 's': 'static', 'p': 'static PIE', 'l': 'shared library'}
PROGRAMS = ['1-8', '2000-8', '2000-64', '5000-64', '10000-64', '20000-64', '40000-64', '102400-64']


def counters(fields):
    result = {}
    for field in fields:
        if '=' in field:
            key, value = field.split('=')
            result[key] = int(value.rstrip('*'))
    return result


def quantile(values, p):
    ordered = sorted(values)
    position = p * (len(ordered) - 1)
    low = int(position)
    high = min(low + 1, len(ordered) - 1)
    return ordered[low] + (ordered[high] - ordered[low]) * (position - low)


def read():
    runs = collections.defaultdict(dict)
    bad = 0
    for name, rounds in ROUNDS.items():
        path = f'{D}/results594-{name}.tsv'
        if not os.path.exists(path):
            continue
        for line in open(path):
            row = line.rstrip('\n').split('\t')
            if row[0] == 'round':
                continue
            round_, label, status = int(row[0]), row[2], int(row[5])
            bad += status != 0
            if (round_ - 1) % rounds == 0:
                continue
            c = counters(row[17:])
            runs[label][round_] = {
                'wall': int(row[6]) / 1e3,
                'cpu': int(row[7]) + int(row[8]),
                'faults': c.get('page-faults', 0),
                'cs': c.get('context-switches', 0),
                'maxrss': int(row[13]),
            }
    return runs, bad


def stages(text):
    result = {}
    for line in text.splitlines():
        m = re.match(r'link-foreign: ([0-9.]+) ms on (\d+) lane', line)
        if m:
            result['whole'] = float(m.group(1))
            result['lanes#'] = float(m.group(2))
            continue
        m = re.match(r'  (\S+)\s+([0-9.]+) ms(.*)', line)
        if m:
            stage = m.group(1)
            result[stage] = float(m.group(2))
            words = m.group(3).split()
            for i in range(0, len(words) - 1, 2):
                try:
                    result[f'{stage}.{words[i]}'] = float(words[i + 1])
                except ValueError:
                    pass
    return result


runs, bad = read()
print(f'{sum(len(v) for v in runs.values())} runs kept, {bad} with a status other than 0')
for kind, kind_name in KINDS.items():
    print(f'\n== {kind_name}: median wall us (p10-p90) by way')
    print(f'{"program":>10s}' + ''.join(f'{w:>16s}' for w in WAYS) + '   best')
    for program in PROGRAMS:
        cells = []
        best = None
        for way in WAYS:
            r = runs.get(f'{TREE}-{kind}{program}-{way}')
            if not r:
                cells.append(f'{"-":>16s}')
                continue
            wall = [x['wall'] for x in r.values()]
            m = st.median(wall)
            cells.append(f'{m:9.1f} ({len(wall):2d}) ')
            if way != '1p' and (best is None or m < best[1]):
                best = (way, m)
        print(f'{program:>10s}' + ''.join(cells) + (f'   {best[0]} {best[1]:.1f}' if best else ''))
    print(f'-- faults / cs / cpu us / maxrss KB medians')
    for program in PROGRAMS:
        cells = []
        for way in WAYS:
            r = runs.get(f'{TREE}-{kind}{program}-{way}')
            if not r:
                cells.append(f'{"-":>24s}')
                continue
            x = list(r.values())
            cells.append(f'{st.median(y["faults"] for y in x):5.0f}/{st.median(y["cs"] for y in x):4.0f}/{st.median(y["cpu"] for y in x):6.0f}/{st.median(y["maxrss"] for y in x):6.0f} ')
        print(f'{program:>10s} ' + ''.join(cells))

reports = collections.defaultdict(list)
for path in glob.glob(f'{D}/out594/*.err'):
    m = re.match(r'(\d+)-(.+)-(\d+)\.err$', os.path.basename(path))
    if not m:
        continue
    round_, label = int(m.group(1)), m.group(2)
    if label in runs and round_ in runs[label]:
        reports[label].append(stages(open(path).read()))
KEYS = ['whole', 'arguments', 'interpreter', 'open', 'lanes', 'resolve', 'resolve.open', 'resolve.indices', 'resolve.symbols', 'resolve.exchange', 'resolve.resolve',
        'resolve.winners', 'convert', 'convert.sections', 'convert.names', 'convert.relocations', 'convert.check', 'write', 'write.lanes+symbols', 'write.count',
        'write.chunks', 'release']
for kind, kind_name in KINDS.items():
    for program in PROGRAMS:
        labels = [f'{TREE}-{kind}{program}-{way}' for way in WAYS]
        if not any(reports.get(l) for l in labels):
            continue
        print(f'\n-- --time {kind_name} {program} (ms medians): ' + ', '.join(f'{w} {len(reports.get(l, []))}' for w, l in zip(WAYS, labels)))
        print(f'   {"":22s}' + ''.join(f'{w:>9s}' for w in WAYS))
        for k in KEYS:
            cells = []
            seen = False
            for l in labels:
                values = [r[k] for r in reports.get(l, []) if k in r]
                seen = seen or bool(values)
                cells.append(f'{st.median(values):9.3f}' if values else f'{"-":>9s}')
            if seen:
                print(f'   {k:22s}' + ''.join(cells))
