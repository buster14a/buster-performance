#!/usr/bin/env python3
# analyze446.py results446.tsv: #446's campaign (procbench over links446.list). For each label, over every run (not the
# warm-ups): the median, p10, p90, p95 and max wall time, the median CPU time (user + system), effective clock (cycles
# over task-clock, all threads), instructions, context switches, migrations and page faults. Then, per round, each
# case's median for main (base), head and main again (base2), and the paired changes head/base and base2/base over the
# rounds: their median and range. Then, for the affected case, how a run's wall time goes with its effective clock and
# its instructions.
import collections
import statistics as st
import sys


def counters(fields):
    result = {}
    for field in fields:
        key, value = field.split('=')
        result[key] = int(value.rstrip('*'))
        result[key + '*'] = value.endswith('*')
    return result


def percentile(values, p):
    ordered = sorted(values)
    return ordered[min(len(ordered) - 1, int(p * len(ordered)))]


rows = [line.rstrip('\n').split('\t') for line in open(sys.argv[1])]
runs = collections.defaultdict(list)
per_round = collections.defaultdict(lambda: collections.defaultdict(list))
multiplexed = 0
bad = 0
for row in rows[1:]:
    if row[0] == 'round':
        continue
    round_, label, warmup, status = int(row[0]), row[2], row[4] == '1', int(row[5])
    c = counters(row[17:])
    multiplexed += sum(1 for k in c if k.endswith('*') and c[k])
    bad += status != 0
    if warmup:
        continue
    run = {
        'wall': int(row[6]) / 1e3,
        'cpu': (int(row[7]) + int(row[8])),
        'minflt': int(row[9]),
        'clock': c['cycles'] / c['task-clock'],
        'instructions': c['instructions'],
        'cycles': c['cycles'],
        'cs': c['context-switches'],
        'migrations': c['cpu-migrations'],
        'faults': c['page-faults'],
    }
    runs[label].append(run)
    per_round[label][round_].append(run)

print(f'{sum(len(v) for v in runs.values())} runs, {bad} with a status other than 0, {multiplexed} multiplexed counters')
print()
print(f'{"label":28s} {"n":>4s} {"median":>9s} {"p10":>9s} {"p90":>9s} {"p95":>9s} {"max":>9s} {"cpu us":>8s} {"GHz":>5s} {"instr M":>8s} {"cs":>4s} {"mig":>4s} {"faults":>6s}')
for label, v in runs.items():
    wall = [r['wall'] for r in v]
    print(f'{label:28s} {len(v):4d} {st.median(wall):9.1f} {percentile(wall, 0.1):9.1f} {percentile(wall, 0.9):9.1f} {percentile(wall, 0.95):9.1f} {max(wall):9.1f} '
          f'{st.median(r["cpu"] for r in v):8.0f} {st.median(r["clock"] for r in v):5.2f} {st.median(r["instructions"] for r in v) / 1e6:8.2f} '
          f'{st.median(r["cs"] for r in v):4.0f} {st.median(r["migrations"] for r in v):4.0f} {st.median(r["faults"] for r in v):6.0f}')

print()
print('Paired by round: each round\'s median, then head / base and base2 / base')
cases = sorted({label.split('-', 1)[1] for label in runs})
for case in cases:
    base = per_round.get('base-' + case, {})
    head = per_round.get('head-' + case, {})
    again = per_round.get('base2-' + case, {})
    rounds = sorted(set(base) & set(head))
    changes = []
    controls = []
    lines = []
    for r in rounds:
        b = st.median(x['wall'] for x in base[r])
        h = st.median(x['wall'] for x in head[r])
        changes.append(h / b - 1)
        text = f'  round {r:2d}: base {b:9.1f} head {h:9.1f} ({100 * (h / b - 1):+6.2f}%)'
        if r in again:
            a = st.median(x['wall'] for x in again[r])
            controls.append(a / b - 1)
            text += f' base2 {a:9.1f} ({100 * (a / b - 1):+6.2f}%)'
        lines.append(text)
    if not rounds:
        continue
    print(f'{case}: {len(rounds)} rounds, head/base median {100 * st.median(changes):+.2f}% (range {100 * min(changes):+.2f}% to {100 * max(changes):+.2f}%)'
          + (f', base2/base median {100 * st.median(controls):+.2f}% (range {100 * min(controls):+.2f}% to {100 * max(controls):+.2f}%)' if controls else ''))
    all_b = [x['wall'] for r in rounds for x in base[r]]
    all_h = [x['wall'] for r in rounds for x in head[r]]
    print(f'  all runs: base median {st.median(all_b):.1f}, head {st.median(all_h):.1f} ({100 * (st.median(all_h) / st.median(all_b) - 1):+.2f}%)')
    if '2000-threads' in case:
        for line in lines:
            print(line)

print()
print('The affected case (dyn2000-threads): wall time against effective clock and instructions, every run of base, base2 and head')
v = [r for label in ('base-dyn2000-threads', 'base2-dyn2000-threads', 'head-dyn2000-threads') for r in runs.get(label, [])]
if v:
    by_clock = sorted(v, key=lambda r: r['clock'])
    quarter = len(by_clock) // 4
    for name, part in (('slowest-clock quarter', by_clock[:quarter]), ('fastest-clock quarter', by_clock[-quarter:])):
        print(f'  {name}: clock {st.median(r["clock"] for r in part):.2f} GHz, wall {st.median(r["wall"] for r in part):.1f} us, cycles {st.median(r["cycles"] for r in part) / 1e6:.2f} M, '
              f'instructions {st.median(r["instructions"] for r in part) / 1e6:.2f} M')
    for label in ('base-dyn2000-threads', 'base2-dyn2000-threads', 'head-dyn2000-threads'):
        w = runs.get(label, [])
        if w:
            print(f'  {label}: instructions {st.median(r["instructions"] for r in w) / 1e6:.3f} M, cycles {st.median(r["cycles"] for r in w) / 1e6:.2f} M, clock {st.median(r["clock"] for r in w):.2f} GHz')
