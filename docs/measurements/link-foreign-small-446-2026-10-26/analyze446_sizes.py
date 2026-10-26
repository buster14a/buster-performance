#!/usr/bin/env python3
# analyze446_sizes.py results446s.tsv: #446's sizes (procbench over sizes446.list): for each program, the median wall
# time of main's (base) and the head's threaded dynamic PIE links over every run, the change, the range of the rounds'
# changes, the effective clock (cycles over task-clock, all threads), CPU time and instructions.
import collections
import statistics as st
import sys

rows = [line.rstrip('\n').split('\t') for line in open(sys.argv[1])][1:]
data = collections.defaultdict(list)
per_round = collections.defaultdict(lambda: collections.defaultdict(list))
for row in rows:
    if row[0] == 'round' or row[4] == '1':
        continue
    c = {kv.split('=')[0]: int(kv.split('=')[1].rstrip('*')) for kv in row[17:]}
    run = (int(row[6]) / 1e3, c['cycles'] / c['task-clock'], c['task-clock'] / 1e3, c['instructions'] / 1e6)
    data[row[2]].append(run)
    per_round[row[2]][int(row[0])].append(run[0])
sizes = sorted({int(label.split('-')[1][3:]) for label in data})
print(f'{"workers":>8s} {"base us":>9s} {"head us":>9s} {"change":>7s} {"rounds":>22s} {"GHz b/h":>10s} {"cpu b us":>9s} {"instr b/h M":>14s}')
for n in sizes:
    b, h = data[f'base-dyn{n}-threads'], data[f'head-dyn{n}-threads']
    bw, hw = st.median(x[0] for x in b), st.median(x[0] for x in h)
    rounds = per_round[f'base-dyn{n}-threads']
    changes = [st.median(per_round[f'head-dyn{n}-threads'][r]) / st.median(rounds[r]) - 1 for r in rounds]
    print(f'{n:8d} {bw:9.1f} {hw:9.1f} {100 * (hw / bw - 1):+6.2f}% {100 * min(changes):+6.2f}% to {100 * max(changes):+6.2f}% '
          f'{st.median(x[1] for x in b):4.2f}/{st.median(x[1] for x in h):4.2f} {st.median(x[2] for x in b):9.0f} '
          f'{st.median(x[3] for x in b):6.2f}/{st.median(x[3] for x in h):6.2f}')
