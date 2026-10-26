#!/usr/bin/env python3
# analyze446p.py RESULTS.tsv OUTDIR|-: #446's phases (with OUTDIR -, runs without reports: tmpfs446.list's). Each measured run of phases446.list (procbench's row: wall time,
# rusage, counters) joined with its link-foreign --time report (OUTDIR/ROUND-LABEL-RUN.err), then per label the medians
# of the whole, each stage and each phase, the process around the link (`outside`: the wall time less --time's whole),
# the voluntary context switches, and the same for the runs with the fewest and the most context switches, to find
# which part of the link the head's extra sleeps come with. Then each round's medians, the paired changes against main
# (head/base, and base2/base: main against itself), and each label's medians by its place in the round's rotated order.
import collections
import os
import re
import statistics as st
import sys

results, outdir = sys.argv[1], sys.argv[2]
rows = []
with open(results) as f:
    header = f.readline().rstrip('\n').split('\t')
    for line in f:
        fields = line.rstrip('\n').split('\t')
        row = dict(zip(header, fields[:len(header) - 1]))
        if row.get('warmup') != '0':
            continue
        counters = {}
        for item in fields[len(header) - 1:]:
            if '=' in item:
                name, value = item.split('=', 1)
                counters[name] = int(value)
        row['counters'] = counters
        rows.append(row)


def report(path):
    parts = collections.OrderedDict()
    if outdir == '-':
        return parts
    if not os.path.exists(path):
        return None
    for line in open(path):
        m = re.match(r'link-foreign: ([\d.]+) ms on (\d+) lanes?', line)
        if m:
            parts['total'] = float(m.group(1))
            parts['lanes'] = int(m.group(2))
            continue
        tokens = line.split()
        if len(tokens) >= 3 and tokens[2] == 'ms':
            stage = tokens[0]
            parts[stage] = float(tokens[1])
            rest = tokens[3:]
            for i in range(0, len(rest) - 1, 2):
                parts[f'{stage}.{rest[i]}'] = float(rest[i + 1])
    return parts if 'total' in parts else None


runs = collections.defaultdict(list)
missing = 0
for row in rows:
    parts = report(os.path.join(outdir, f'{row["round"]}-{row["label"]}-{row["run"]}.err'))
    if parts is None:
        missing += 1
        continue
    parts['wall'] = int(row['wall_ns']) / 1e6
    parts['nvcsw'] = int(row['nvcsw'])
    parts['nivcsw'] = int(row['nivcsw'])
    c = row['counters']
    parts['cs'] = c.get('context-switches', -1)
    parts['cpu'] = c.get('task-clock', 0) / 1e6
    parts['GHz'] = c.get('cycles', 0) / c['task-clock'] if c.get('task-clock') else 0
    if 'total' in parts:
        parts['outside'] = parts['wall'] - parts['total']
    parts['round'] = int(row['round'])
    parts['place'] = (int(row['command']) - (int(row['round']) - 1)) % 3
    parts['status'] = int(row['status'])
    runs[row['label']].append(parts)

print(f'{sum(len(v) for v in runs.values())} measured runs{" with reports" if outdir != "-" else ""}, {missing} without; statuses {sorted({r["status"] for v in runs.values() for r in v})}')
labels = sorted(runs, key=lambda l: (l.split('-', 1)[1], l))
keys = []
for label in labels:
    for r in runs[label]:
        for k in r:
            if k not in keys and k not in ('round', 'status', 'lanes', 'place'):
                keys.append(k)


def med(values):
    return st.median(values) if values else float('nan')


def row_of(name, groups):
    cells = []
    for group in groups:
        values = [r[name] for r in group if name in r]
        cells.append(f'{med(values):10.3f}' if values else f'{"-":>10}')
    return f'  {name:28s}' + ''.join(cells)


print()
print('medians per label (ms; cs and nvcsw counts; GHz cycles over task-clock):')
print(f'  {"":28s}' + ''.join(f'{l.split("-")[0]:>10}' for l in labels))
print(f'  {"runs":28s}' + ''.join(f'{len(runs[l]):10d}' for l in labels))
for k in keys:
    print(row_of(k, [runs[l] for l in labels]))

print()
print('each label\'s runs split at its median voluntary context switches: fewer | more (medians)')
for label in labels:
    v = runs[label]
    cut = med([r['nvcsw'] for r in v])
    low = [r for r in v if r['nvcsw'] <= cut]
    high = [r for r in v if r['nvcsw'] > cut]
    print(f'{label}: cut at {cut}, {len(low)} | {len(high)} runs')
    for k in keys:
        a = med([r[k] for r in low if k in r])
        b = med([r[k] for r in high if k in r])
        if a == a and b == b and (k in ('wall', 'total', 'nvcsw', 'cs', 'GHz', 'cpu') or abs(b - a) >= 0.02):
            print(f'  {k:28s} {a:10.3f} | {b:10.3f}  ({b - a:+.3f})')

print()
print('per round: medians of wall, total and nvcsw by label' if outdir != '-' else 'per round: medians of wall and nvcsw by label')
rounds = sorted({r['round'] for v in runs.values() for r in v})
for rnd in rounds:
    cells = []
    for label in labels:
        v = [r for r in runs[label] if r['round'] == rnd]
        total = f'/{med([r["total"] for r in v]):.3f}' if outdir != '-' else ''
        cells.append(f'{label.split("-")[0]} {med([r["wall"] for r in v]):.3f}{total}/{med([r["nvcsw"] for r in v]):.0f}')
    print(f'  round {rnd}: ' + '   '.join(cells))

print()
print('paired by round: head/base and base2/base of the rounds\' medians (wall' + (', and --time\'s whole)' if outdir != '-' else ')'))
base = next(l for l in labels if l.startswith('base-'))
for other in [l for l in labels if l != base]:
    for key in [k for k in ('wall', 'total') if k in keys]:
        changes = []
        for rnd in rounds:
            a = med([r[key] for r in runs[base] if r['round'] == rnd])
            b = med([r[key] for r in runs[other] if r['round'] == rnd])
            if a == a and b == b:
                changes.append(100 * (b / a - 1))
        if changes:
            print(f'  {other.split("-")[0]}/base {key:6s}: median {med(changes):+.2f}% over {len(changes)} rounds (range {min(changes):+.2f}% to {max(changes):+.2f}%); '
                  f'all runs {100 * (med([r[key] for r in runs[other]]) / med([r[key] for r in runs[base]]) - 1):+.2f}%')

print()
print('by place in the round\'s order (0 first): medians of wall, ' + ('total, outside, ' if outdir != '-' else '') + 'nvcsw, GHz')
for label in labels:
    for place in range(3):
        v = [r for r in runs[label] if r['place'] == place]
        if v:
            parts = f'total {med([r["total"] for r in v]):.3f}, outside {med([r["outside"] for r in v]):.3f}, ' if outdir != '-' else ''
            print(f'  {label.split("-")[0]:5s} place {place}: {len(v):4d} runs, wall {med([r["wall"] for r in v]):.3f}, {parts}'
                  f'nvcsw {med([r["nvcsw"] for r in v]):.0f}, GHz {med([r["GHz"] for r in v]):.2f}')
