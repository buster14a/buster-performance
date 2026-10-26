#!/usr/bin/env python3
# analyze501b.py [DIR]: #501's comparisons pass by pass and their uncertainty. For each list, case and comparison
# (m2/m1, the control; hd/m1; kp/rl, the switch build's settings, one binary; fn/m1 and fn/m2, the confirmation's
# final head), the paired median change of the wall
# time in each pass (each procbench call, its first round left out), and over all passes with a 95% bootstrap
# interval (2,000 resamplings of the rounds, seed 501).
import collections
import os
import random
import statistics as st
import sys

D = sys.argv[1] if len(sys.argv) > 1 else os.path.expanduser('~/buster-fast-bench/perf-501-claude')
ROUNDS = {'small-threads': 41, 'big-threads': 10, 'small-one': 41, 'big-one': 10, 'small-time': 41, 'big-time': 10}
PAIRS = [('m2', 'm1'), ('hd', 'm1'), ('kp', 'rl'), ('kp', 'm1'), ('fn', 'm1'), ('fn', 'm2')]


def read(name):
    runs = collections.defaultdict(dict)
    for line in open(f'{D}/results501-{name}.tsv'):
        row = line.rstrip('\n').split('\t')
        if row[0] == 'round':
            continue
        round_ = int(row[0])
        if (round_ - 1) % ROUNDS[name] == 0:
            continue
        runs[row[2]][round_] = int(row[6]) / 1e3
    return runs


random.seed(501)
for name in ROUNDS:
    runs = read(name)
    cases = sorted({label.split('-', 1)[1] for label in runs if not label.startswith('w')})
    print(f'== {name}')
    for case in cases:
        for a, b in PAIRS:
            x = runs.get(f'{a}-{case}')
            y = runs.get(f'{b}-{case}')
            if not x or not y:
                continue
            common = sorted(set(x) & set(y))
            changes = {r: x[r] / y[r] - 1 for r in common}
            passes = collections.defaultdict(list)
            for r in common:
                passes[(r - 1) // ROUNDS[name]].append(changes[r])
            values = list(changes.values())
            boots = sorted(st.median(random.choices(values, k=len(values))) for _ in range(2000))
            per_pass = ' '.join(f'{100 * st.median(v):+5.1f}' for _, v in sorted(passes.items()))
            print(f'  {case:9s} {a}/{b}: {100 * st.median(values):+6.2f}% [{100 * boots[50]:+6.2f}%, {100 * boots[1949]:+6.2f}%]  passes: {per_pass}')
