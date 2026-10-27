#!/usr/bin/env python3
# summarize.py ROUNDS_DIR [TREES...]: per tree, the median over rounds of each round's figure (the driver's median wall
# time and peak, benchmark-lowering-source's referenced_ns for sqlite3.c and c-testsuite, and benchmark-builtin-lowering's
# vector and scalar medians per case), with each tree's change from the first tree's.
import glob, os, re, statistics, sys

directory = sys.argv[1]
trees = sys.argv[2:] or ['main', 'head', 'main2']
figures = {}

def add(tree, name, value):
    figures.setdefault(name, {}).setdefault(tree, []).append(value)

for path in sorted(glob.glob(os.path.join(directory, '*-*-*.log'))):
    base = os.path.basename(path)
    round_text, tree, kind = base.split('-', 2)
    if tree not in trees:
        continue
    text = open(path).read()
    if kind == 'driver.log':
        m = re.search(r'median ([0-9.]+) ms wall \(([0-9.]+) to ([0-9.]+)\), ([0-9.]+) ms user, ([0-9.]+) ms system, ([0-9]+) KB peak', text)
        add(tree, 'driver wall ms', float(m.group(1)))
        add(tree, 'driver user ms', float(m.group(4)))
        add(tree, 'driver peak KB', float(m.group(6)))
    elif kind in ('lowering-sqlite.log', 'lowering-suite.log'):
        m = re.search(r'totals .*referenced_ns=([0-9]+) all_ns=([0-9]+)', text)
        label = 'sqlite3.c' if 'sqlite' in kind else 'c-testsuite'
        add(tree, 'lowering ' + label + ' referenced ms', int(m.group(1)) / 1e6)
        add(tree, 'lowering ' + label + ' all ms', int(m.group(2)) / 1e6)
    elif kind == 'builtin-lowering.log':
        case = None
        for line in text.splitlines():
            m = re.match(r'^(\S+)\s+entries=', line)
            if m:
                case = m.group(1)
            m = re.match(r'^\s+(scalar|vector) median=([0-9.]+) ns/function', line)
            if m and case:
                add(tree, 'builtin ' + case + ' ' + m.group(1) + ' ns', float(m.group(2)))

first = trees[0]
print('%-44s' % 'figure (median of rounds)' + ''.join('%14s' % t for t in trees) + ''.join('%10s' % (t + '/' + first) for t in trees[1:]))
for name in figures:
    row = figures[name]
    medians = [statistics.median(row[t]) if t in row else float('nan') for t in trees]
    rounds = min(len(row.get(t, [])) for t in trees)
    line = '%-44s' % (name + ' (%d)' % rounds) + ''.join('%14.3f' % v for v in medians)
    line += ''.join('%+9.2f%%' % ((v / medians[0] - 1) * 100) for v in medians[1:])
    print(line)
