#!/usr/bin/env python3
# analyze490.py DIR: #490's A/B logs (DIR/logs-{pre,main,head}/): per tree and round, benchmark-link's direct path by
# program and kind (the link, runtime_open and bind_begin, a timed run's faults in each where the build counts them,
# the warm-ups' faults and resident growth), main's again with its mapping populated, benchmark-snapshot's sizes and
# runtime_open, and the C driver's hello world (time-runs: medians of wall time, peak resident set and minor faults).
# Prints each round's figure and, per tree, the median of the rounds' and their range.
import collections
import glob
import os
import re
import statistics as st
import sys

base = sys.argv[1]
trees = ['pre', 'main', 'populated', 'head']
link = collections.defaultdict(lambda: collections.defaultdict(dict))
snapshot = collections.defaultdict(lambda: collections.defaultdict(dict))
proc = collections.defaultdict(dict)


def logs(tree, kind):
    directory = 'logs-main' if tree == 'populated' else f'logs-{tree}'
    name = 'link-populated' if tree == 'populated' else kind
    for path in glob.glob(os.path.join(base, directory, f'{name}-*.log')):
        match = re.search(rf'/{re.escape(name)}-(\d+)\.log$', path)
        if match:
            yield int(match.group(1)), open(path).read()


for tree in trees:
    for r, text in logs(tree, 'link'):
        program = None
        for line in text.splitlines():
            m = re.match(r'(\d+) workers? in \d+ units.*linked as an? (.*):$', line)
            if m:
                program = (int(m.group(1)), m.group(2))
                continue
            m = re.match(r'\s+direct path\s+([\d.]+) us: open ([\d.]+) begin ([\d.]+) end ([\d.]+) write ([\d.]+)', line)
            if m and program:
                link[program][tree][r] = {'link': float(m.group(1)), 'open': float(m.group(2)), 'begin': float(m.group(3))}
            m = re.match(r'\s+work\s+.* (\d+) page faults(?: \(a run\'s open (\d+), begin (\d+)\))?, ([\d.]+) MB more resident', line)
            if m and program and r in link[program][tree]:
                entry = link[program][tree][r]
                entry['faults'] = int(m.group(1))
                entry['open_faults'] = int(m.group(2)) if m.group(2) else None
                entry['begin_faults'] = int(m.group(3)) if m.group(3) else None
                entry['resident'] = float(m.group(4))
    if tree == 'populated':
        continue
    for kind in ('dynamic', 'shared'):
        for r, text in logs(tree, f'snapshot-{kind}'):
            size = re.search(r'a (\d+)-byte snapshot', text)
            opened = re.search(r'runtime_open from the snapshot\s+([\d.]+) us: identity ([\d.]+) map ([\d.]+) hash ([\d.]+)', text)
            fresh = re.search(r'binding one worker, freshly loaded\s+([\d.]+) us', text)
            if size and opened:
                snapshot[kind][tree][r] = {'bytes': int(size.group(1)), 'open': float(opened.group(1)), 'hash': float(opened.group(4)),
                                           'fresh': float(fresh.group(1)) if fresh else None}
    for r, text in logs(tree, 'proc'):
        runs = [m for m in re.finditer(r'run \d+ list 1: ([\d.]+) ms wall, .* (\d+) KB peak, (\d+) minor faults, \d+ major, status (\d+)', text)]
        if runs:
            proc[tree][r] = {
                'wall': st.median(float(m.group(1)) for m in runs),
                'peak': st.median(int(m.group(2)) for m in runs),
                'faults': st.median(int(m.group(3)) for m in runs),
                'statuses': sorted({int(m.group(4)) for m in runs}),
                'runs': len(runs),
            }


def summary(values, digits=1):
    if not values:
        return '-'
    return f'{st.median(values):.{digits}f} ({min(values):.{digits}f}-{max(values):.{digits}f})'


print('benchmark-link --only direct: median of the rounds (range), each round a median of its runs')
for program in sorted(link, key=lambda p: (p[1], p[0])):
    print(f'{program[0]} workers, {program[1]}:')
    for tree in trees:
        rounds = link[program].get(tree, {})
        if not rounds:
            continue
        v = list(rounds.values())
        text = f'  {tree:10s} n={len(v)} link {summary([x["link"] for x in v])} open {summary([x["open"] for x in v])} begin {summary([x["begin"] for x in v])}'
        if all(x.get('begin_faults') is not None for x in v):
            text += f' faults: open {summary([x["open_faults"] for x in v], 0)} begin {summary([x["begin_faults"] for x in v], 0)}'
        text += f' warm-ups {summary([x.get("faults", 0) for x in v], 0)} faults, {summary([x.get("resident", 0) for x in v], 2)} MB'
        print(text)
print()
for kind in ('dynamic', 'shared'):
    print(f'benchmark-snapshot --only {kind}:')
    for tree in ('pre', 'main', 'head'):
        v = list(snapshot[kind].get(tree, {}).values())
        if v:
            print(f'  {tree:10s} n={len(v)} {v[0]["bytes"]} bytes, runtime_open {summary([x["open"] for x in v], 2)} us, hash {summary([x["hash"] for x in v], 2)}, '
                  f'binding one worker freshly loaded {summary([x["fresh"] for x in v if x["fresh"] is not None], 2)} us')
print()
print('the C driver\'s hello world (time-runs, 41 processes a round):')
for tree in ('pre', 'main', 'head'):
    v = list(proc.get(tree, {}).values())
    if v:
        print(f'  {tree:10s} n={len(v)} wall {summary([x["wall"] for x in v], 3)} ms, peak {summary([x["peak"] for x in v], 0)} KB, minor faults {summary([x["faults"] for x in v], 0)}, '
              f'statuses {sorted({s for x in v for s in x["statuses"]})}')
