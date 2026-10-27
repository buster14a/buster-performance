#!/usr/bin/env python3
# analyze594c.py [DIR]: #594's confirmation (results594c-LIST.tsv, outc594/'s --time reports). Each procbench call's
# first round is left out as its warm-up, and so are the warm-up commands (w...). Per case (kind and program), per
# variant: the median wall time in us with its p10 and p90 and the runs kept, and medians of faults, context switches,
# CPU time, instructions and peak RSS; then the paired changes by round (median of the runs' changes, its interquartile
# range, and the change of the medians): hd/h1 (the default as benchmark-link places it against one lane on CPU 2),
# hp/h1 (the same placement), hd/mu and hp/m1 (the head's default against main's, one lane, at each placement), h1/m1
# and h8/m8 (the head's forced lanes against main's), hd/m8 (against benchmark-link's threads before #594), mu/m1 and
# m8/m1.
import collections
import glob
import os
import re
import statistics as st
import sys

D = sys.argv[1] if len(sys.argv) > 1 else os.path.expanduser('~/buster-fast-bench/perf-594-claude')
ROUNDS = {'confirm-small': 41, 'confirm-big': 6, 'confirm-mid': 8, 'confirm-time': 10}
ORDER = ['m1', 'mu', 'm8', 'h1', 'h8', 'hd', 'hp']
PAIRS = [('hd', 'h1'), ('hp', 'h1'), ('hd', 'mu'), ('hp', 'm1'), ('h1', 'm1'), ('h8', 'm8'), ('hd', 'm8'), ('mu', 'm1'), ('m8', 'm1')]


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


def read(name):
    runs = collections.defaultdict(dict)
    bad = 0
    path = f'{D}/results594c-{name}.tsv'
    if os.path.exists(path):
        for line in open(path):
            row = line.rstrip('\n').split('\t')
            if row[0] == 'round':
                continue
            round_, label, status = int(row[0]), row[2], int(row[5])
            bad += status != 0
            if (round_ - 1) % ROUNDS[name] == 0 or label.startswith('w'):
                continue
            c = counters(row[17:])
            runs[label][round_] = {
                'wall': int(row[6]) / 1e3,
                'cpu': int(row[7]) + int(row[8]),
                'faults': c.get('page-faults', 0),
                'cs': c.get('context-switches', 0),
                'maxrss': int(row[13]),
                'instructions': c.get('instructions', 0),
            }
    return runs, bad


def report(name):
    runs, bad = read(name)
    if not runs:
        return
    print(f'== {name}: {sum(len(v) for v in runs.values())} runs kept, {bad} with a status other than 0')
    cases = sorted({label.split('-', 1)[1] for label in runs}, key=lambda c: ('dsp l'.index(c[0]), int(c[1:].split('-')[0]), c))
    for case in cases:
        print(f'-- {case}')
        for v in ORDER:
            r = runs.get(f'{v}-{case}')
            if not r:
                continue
            x = list(r.values())
            wall = [y['wall'] for y in x]
            print(f'   {v:3s} {len(x):4d} {st.median(wall):9.1f} ({quantile(wall, 0.1):9.1f} - {quantile(wall, 0.9):9.1f})  faults {st.median(y["faults"] for y in x):6.0f}  '
                  f'cs {st.median(y["cs"] for y in x):5.1f}  cpu {st.median(y["cpu"] for y in x):7.0f}  instr {st.median(y["instructions"] for y in x) / 1e6:8.2f}M  rss {st.median(y["maxrss"] for y in x):7.0f}')
        for v, against in PAIRS:
            r = runs.get(f'{v}-{case}')
            b = runs.get(f'{against}-{case}')
            if not r or not b:
                continue
            common = sorted(set(r) & set(b))
            changes = [r[k]['wall'] / b[k]['wall'] - 1 for k in common]
            overall = st.median(r[k]['wall'] for k in common) / st.median(b[k]['wall'] for k in common) - 1
            print(f'   {v}/{against}: paired {100 * st.median(changes):+6.2f}% (IQR {100 * quantile(changes, 0.25):+6.2f} to {100 * quantile(changes, 0.75):+6.2f}), '
                  f'medians {100 * overall:+6.2f}%, {len(common)} rounds')


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


for name in ['confirm-small', 'confirm-big', 'confirm-mid']:
    report(name)
runs, bad = read('confirm-time')
reports = collections.defaultdict(list)
for path in glob.glob(f'{D}/outc594/*.err'):
    m = re.match(r'(\d+)-(.+)-(\d+)\.err$', os.path.basename(path))
    if m and m.group(2) in runs and int(m.group(1)) in runs[m.group(2)]:
        reports[m.group(2)].append(stages(open(path).read()))
KEYS = ['whole', 'lanes#', 'arguments', 'interpreter', 'open', 'open.objects', 'lanes', 'resolve', 'resolve.open', 'convert', 'write', 'release']
cases = sorted({label.split('-', 1)[1] for label in reports}, key=lambda c: ('dsp l'.index(c[0]), int(c[1:].split('-')[0]), c))
print(f'\n== confirm-time --time reports (ms medians; open.objects in bytes): {bad} with a status other than 0')
for case in cases:
    print(f'-- {case}: ' + ', '.join(f'{v} {len(reports.get(f"{v}-{case}", []))}' for v in ['hd', 'h1']))
    for k in KEYS:
        cells = []
        for v in ['hd', 'h1']:
            values = [r[k] for r in reports.get(f'{v}-{case}', []) if k in r]
            cells.append(f'{st.median(values):12.3f}' if values else f'{"-":>12s}')
        print(f'   {k:16s}' + ''.join(cells))
