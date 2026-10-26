#!/usr/bin/env python3
# analyze501.py [DIR]: #501's campaigns (results501-LIST.tsv and out501/'s --time reports in DIR: the first campaign's,
# or confirm/'s, whose final head is fn and whose warm-up commands, w..., are left out). Each list
# runs every command once per round, so a round pairs every variant's run with main's (m1). The first round of each
# hold of the lock (each procbench call) is left out as its warm-up. For each list and case:
#   - per variant, over its runs: the median, p10 and p90 wall time, the median CPU time (user + system), voluntary and
#     involuntary context switches (rusage), context switches and migrations counted by perf (all threads), page
#     faults, instructions and the effective clock (cycles over task-clock);
#   - per variant against m1, paired by round: the median of the runs' changes and its interquartile range, and the
#     change of the medians over all runs; m2 is main again, the control, and kp against rl compares the switch
#     build's two settings, one binary;
#   - with --time, each stage's and phase's median per variant.
import collections
import glob
import os
import re
import statistics as st
import sys

D = sys.argv[1] if len(sys.argv) > 1 else os.path.expanduser('~/buster-fast-bench/perf-501-claude')
ROUNDS = {'small-threads': 41, 'big-threads': 10, 'small-one': 41, 'big-one': 10, 'small-time': 41, 'big-time': 10}
ORDER = ['m1', 'm2', 'hd', 'rl', 'kp', 'fn']


def counters(fields):
    result = {}
    for field in fields:
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
    path = f'{D}/results501-{name}.tsv'
    runs = collections.defaultdict(dict)
    warm = 0
    bad = 0
    if not os.path.exists(path):
        return runs, warm, bad
    for line in open(path):
        row = line.rstrip('\n').split('\t')
        if row[0] == 'round':
            continue
        round_, label, status = int(row[0]), row[2], int(row[5])
        bad += status != 0
        if (round_ - 1) % ROUNDS[name] == 0:
            warm += 1
            continue
        c = counters(row[17:])
        runs[label][round_] = {
            'wall': int(row[6]) / 1e3,
            'cpu': int(row[7]) + int(row[8]),
            'nvcsw': int(row[11]),
            'nivcsw': int(row[12]),
            'cs': c['context-switches'],
            'migrations': c['cpu-migrations'],
            'faults': c['page-faults'],
            'instructions': c['instructions'],
            'clock': c['cycles'] / c['task-clock'] if c['task-clock'] else 0.0,
            'maxrss': int(row[13]),
        }
    return runs, warm, bad


def report(name):
    runs, warm, bad = read(name)
    if not runs:
        return
    print(f'== {name}: {sum(len(v) for v in runs.values())} runs kept, {warm} warm-up runs left out, {bad} with a status other than 0')
    cases = sorted({label.split('-', 1)[1] for label in runs if not label.startswith('w')}, key=lambda c: (int(re.sub(r'\D', '', c.split('-')[0])), c))
    for case in cases:
        print(f'-- {case}')
        print(f'   {"":3s} {"n":>4s} {"median":>9s} {"p10":>9s} {"p90":>9s} {"cpu us":>7s} {"nvcsw":>6s} {"nivcsw":>6s} {"cs":>5s} {"mig":>4s} {"faults":>7s} {"instr M":>8s} {"GHz":>5s} {"rss KB":>7s}')
        for v in ORDER:
            r = runs.get(f'{v}-{case}')
            if not r:
                continue
            x = list(r.values())
            wall = [y['wall'] for y in x]
            print(f'   {v:3s} {len(x):4d} {st.median(wall):9.1f} {quantile(wall, 0.1):9.1f} {quantile(wall, 0.9):9.1f} {st.median(y["cpu"] for y in x):7.0f} '
                  f'{st.median(y["nvcsw"] for y in x):6.1f} {st.median(y["nivcsw"] for y in x):6.1f} {st.median(y["cs"] for y in x):5.1f} {st.median(y["migrations"] for y in x):4.1f} '
                  f'{st.median(y["faults"] for y in x):7.0f} {st.median(y["instructions"] for y in x) / 1e6:8.2f} {st.median(y["clock"] for y in x):5.2f} {st.median(y["maxrss"] for y in x):7.0f}')
        base = runs.get(f'm1-{case}', {})
        pairs = [(v, 'm1') for v in ORDER[1:]] + [('kp', 'rl'), ('fn', 'm2')]
        for v, against in pairs:
            r = runs.get(f'{v}-{case}')
            b = runs.get(f'{against}-{case}')
            if not r or not b:
                continue
            common = sorted(set(r) & set(b))
            changes = [r[k]['wall'] / b[k]['wall'] - 1 for k in common]
            overall = st.median(r[k]['wall'] for k in common) / st.median(b[k]['wall'] for k in common) - 1
            print(f'   {v}/{against}: paired median {100 * st.median(changes):+6.2f}% (IQR {100 * quantile(changes, 0.25):+6.2f}% to {100 * quantile(changes, 0.75):+6.2f}%), '
                  f'medians {100 * overall:+6.2f}%, {len(common)} rounds')


def stages(text):
    result = {}
    for line in text.splitlines():
        m = re.match(r'link-foreign: ([0-9.]+) ms on', line)
        if m:
            result['whole'] = float(m.group(1))
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


def report_time(name):
    runs, warm, bad = read(name)
    if not runs:
        return
    print(f'== {name} --time reports (ms, medians over the kept runs)')
    files = glob.glob(f'{D}/out501/*.err')
    reports = collections.defaultdict(list)
    for path in files:
        m = re.match(r'(\d+)-(.+)-(\d+)\.err$', os.path.basename(path))
        if not m:
            continue
        round_, label = int(m.group(1)), m.group(2)
        if label in runs and round_ in runs[label]:
            reports[label].append(stages(open(path).read()))
    cases = sorted({label.split('-', 1)[1] for label in reports if not label.startswith('w')})
    for case in cases:
        keys = []
        for v in ORDER:
            for r in reports.get(f'{v}-{case}', []):
                for k in r:
                    if k not in keys:
                        keys.append(k)
        print(f'-- {case}: ' + ', '.join(f'{v} {len(reports.get(f"{v}-{case}", []))}' for v in ORDER))
        print(f'   {"":34s}' + ''.join(f'{v:>9s}' for v in ORDER))
        for k in keys:
            cells = []
            for v in ORDER:
                values = [r[k] for r in reports.get(f'{v}-{case}', []) if k in r]
                cells.append(f'{st.median(values):9.3f}' if values else f'{"-":>9s}')
            print(f'   {k:34s}' + ''.join(cells))


for name in ('small-threads', 'big-threads', 'small-one', 'big-one', 'small-time', 'big-time'):
    report(name)
    print()
for name in ('small-time', 'big-time'):
    report_time(name)
    print()
