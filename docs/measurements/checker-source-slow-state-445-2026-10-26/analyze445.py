#!/usr/bin/env python3
# analyze445.py RESULTS.tsv OUT_DIR: #445's processes (procbench over checker445.list or sweep445-*.list), each joined
# with benchmark-checker-source's own lines from OUT_DIR (ROUND-LABEL-0.out): its body checking's ns and cycles per node
# by path, with the process's counters (cycles, instructions, dTLB walks rf045, and the list's fourth counter: L2 data
# misses r0864 or store-to-load conflicts r0224), its huge pages and its initial stack's address. Prints every process,
# then each label's median and range, then the processes ordered by their initial stack's offset in its page.
import collections
import os
import re
import statistics as st
import sys

results, out = sys.argv[1], sys.argv[2]
rows = [line.rstrip('\n').split('\t') for line in open(results)]
processes = []
for row in rows[1:]:
    if row[0] == 'round':
        continue
    round_, label = int(row[0]), row[2]
    counters = {}
    for field in row[17:]:
        key, value = field.split('=')
        counters[key] = int(value.rstrip('*'))
        counters[key + '*'] = value.endswith('*')
    text = open(os.path.join(out, f'{round_}-{label}-0.out')).read() if os.path.exists(os.path.join(out, f'{round_}-{label}-0.out')) else ''
    paths = {}
    for match in re.finditer(r'body_graph: path=(\w+) ns_per_node=([\d.]+) cycles_per_node=([\d.]+)', text):
        paths[match.group(1)] = (float(match.group(2)), float(match.group(3)))
    stack = int(row[16])
    processes.append({
        'round': round_,
        'label': label,
        'status': int(row[5]),
        'wall': int(row[6]) / 1e9,
        'huge': int(row[14]),
        'stack': stack,
        'offset': stack % 4096 if stack >= 0 else -1,
        'scalar': paths.get('scalar', (0.0, 0.0)),
        'vector': paths.get('vector', (0.0, 0.0)),
        'counters': counters,
        'multiplexed': any(counters[k] for k in counters if k.endswith('*')),
    })

extra = [k for k in (processes[0]['counters'] if processes else {}) if k.startswith('r') and not k.endswith('*')]
print(f'{len(processes)} processes, {sum(p["status"] != 0 for p in processes)} with a status other than 0, {sum(p["multiplexed"] for p in processes)} with a multiplexed counter')
print()
print(f'{"round":>5s} {"label":24s} {"scalar ns":>9s} {"cyc":>7s} {"vector ns":>9s} {"GHz":>5s} {"instr G":>8s} ' + ' '.join(f'{k:>10s}' for k in extra) + f' {"huge MB":>8s} {"offset":>6s}')
for p in processes:
    c = p['counters']
    print(f'{p["round"]:5d} {p["label"]:24s} {p["scalar"][0]:9.3f} {p["scalar"][1]:7.2f} {p["vector"][0]:9.3f} {c["cycles"] / c["task-clock"]:5.2f} {c["instructions"] / 1e9:8.3f} '
          + ' '.join(f'{c[k]:10d}' for k in extra) + f' {p["huge"] / 1024:8.0f} {p["offset"]:6d}')
print()
by_label = collections.defaultdict(list)
for p in processes:
    by_label[p['label']].append(p)
for label, v in by_label.items():
    s = [p['scalar'][0] for p in v if p['scalar'][0] > 0]
    w = [p['vector'][0] for p in v if p['vector'][0] > 0]
    if s:
        print(f'{label:24s} n={len(v):3d} scalar median {st.median(s):.3f} range {min(s):.3f}-{max(s):.3f}'
              + (f', vector median {st.median(w):.3f} range {min(w):.3f}-{max(w):.3f}' if w else ''))
print()
print('By the initial stack\'s offset in its page (scalar ns/node, each process):')
for p in sorted(processes, key=lambda p: (p['offset'], p['label'])):
    if p['scalar'][0] > 0:
        print(f'  {p["offset"]:5d} {p["label"]:24s} {p["scalar"][0]:8.3f}')
