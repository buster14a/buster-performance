#!/usr/bin/env python3
# tables.py [RESULTS]: every table of the README from the result files (default: ../results/9700x beside this script).
import sys, os, re, glob, statistics
root = sys.argv[1] if len(sys.argv) > 1 else os.path.join(os.path.dirname(os.path.abspath(__file__)), '..', 'results', '9700x')
MHZ = 3792.9
def ms(ticks):
    return ticks / MHZ / 1000
def median_of(paths, rx, group=1):
    values = []
    for path in paths:
        for line in open(path):
            m = re.search(rx, line)
            if m:
                values.append(float(m.group(group)))
    return (statistics.median(values) if values else None), len(values)

print('== 1. The coded walk by its parts in -c sqlite3.c --lanes 1 (job1; ms, medians)')
for label in ['m8', 'e1']:
    files = sorted(glob.glob(os.path.join(root, label, 'walk-a-*.txt')))
    row = []
    for key in ['expressions', 'expressions.classes', 'expressions.prepare', 'expressions.actions', 'expressions.visits']:
        value, count = median_of(files, r'time-check\t%s\t([0-9.]+)\t' % re.escape(key))
        row.append('%s %.3f' % (key.replace('expressions.', ''), value))
    print('  %s (%d runs): %s' % (label, len(files), '; '.join(row)))
files = sorted(glob.glob(os.path.join(root, 'e1', 'walk-a-*.txt')))
ticks, count = median_of(files, r'experiment-flush ticks=(\d+)')
print('  e1 flushes: %d ticks = %.3f ms' % (ticks, ms(ticks)))
for line in open(files[0]):
    if line.startswith('experiment-flush'):
        print('  ' + line.strip())

def front_table(label, suffix, corpora, modes):
    names = ['classes', 'prepare', 'actions', 'visits']
    for corpus in corpora:
        for mode in modes:
            files = sorted(glob.glob(os.path.join(root, label, 'front-%s-%s-%s-*.txt' % (mode, corpus, suffix))))
            if not files:
                continue
            parts = {}
            for i, name in enumerate(names):
                parts[name], count = median_of(files, r'node-shadow: walk ticks classes=(\d+) prepare=(\d+) actions=(\d+) visits=(\d+)', i + 1)
            totals = []
            for path in files:
                for line in open(path):
                    m = re.search(r'node-shadow: walk ticks classes=(\d+) prepare=(\d+) actions=(\d+) visits=(\d+)', line)
                    if m:
                        totals.append(sum(int(v) for v in m.groups()))
            front, count = median_of(files, r'node-shadow: front ticks=(\d+)')
            text = '  %-3s %-5s %-7s (%d runs): classes %.3f prepare %.3f actions %.3f visits %.3f walk %.3f' % (
                label, mode, corpus, len(files), ms(parts['classes']), ms(parts['prepare']), ms(parts['actions']), ms(parts['visits']), ms(statistics.median(totals)))
            if front is not None:
                text += ' front %.3f' % ms(front)
            print(text)

print('== 2. The shadow\'s one reading by f4, the pull request\'s sources (job5; ms, medians)')
front_table('f4', 'r', ['sqlite3', 'lua', 'musl'], ['walk', 'after', 'first'])
print('== 3. The first front, f1 (job2b; ms, medians)')
front_table('f1', 'a', ['sqlite3', 'lua', 'musl'], ['walk', 'after', 'first'])
print('== 4. Counters in registers, f2 against f1, in turn (job3)')
for label in ['f1', 'f2']:
    front_table(label, 'f2', ['sqlite3', 'lua'], ['first', 'after'])
print('== 5. The stagger: f3 (f2 staggered) and f4 (f1 staggered) against f1, in turn (job4)')
for label in ['f1', 'f3', 'f4']:
    front_table(label, 'f34', ['sqlite3', 'lua'], ['first', 'after'])
print('== 6. node_front_chunk\'s events in the --front-first reading of sqlite3.c (perf-events.sh; millions)')
for label in ['f1', 'f2', 'f3', 'f4']:
    row = []
    for event in ['cycles', 'instructions', 'ex_ret_brn_misp']:
        path = os.path.join(root, label, 'events-first-%s.txt' % event)
        value = None
        if os.path.exists(path):
            for line in open(path):
                if 'node_front_chunk' in line:
                    value = float(line.split()[0])
        row.append('%s %s' % (event, '%.3f' % value if value is not None else '-'))
    print('  %s: %s' % (label, '; '.join(row)))
print('== 7. The front\'s counts (f4, the --front-first readings)')
for corpus in ['sqlite3', 'lua', 'musl']:
    path = os.path.join(root, 'f4', 'front-first-%s-r-1.txt' % corpus)
    print('  ' + corpus)
    for line in open(path):
        if re.search(r'node-shadow: (front (before|left|taken|operands)|machine-taken)', line):
            print('    ' + line.strip())
print('== 8. -c sqlite3.c as whole processes')
for name in ['ab-m9-f1', 'ab-copies-m9-f4']:
    path = os.path.join(root, name, 'time-runs.txt')
    print('  ' + name)
    keep = False
    for line in open(path):
        if line.startswith('list 1, '):
            keep = True
        if keep and (line.startswith('list 1, ') or line.startswith('  ')):
            print('    ' + line.rstrip()[:200])
