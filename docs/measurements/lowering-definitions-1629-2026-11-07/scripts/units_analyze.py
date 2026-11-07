#!/usr/bin/env python3
# #442: the units' path's runs (units.sh's or phaseB's runs.txt): each tree's wall times over its runs (median, least,
# quartiles), and the paired deltas against the first tree named, run by run within each round and pass.
# Usage: units_analyze.py RUNS_TXT TREE...
import sys, re, statistics, collections
path, trees = sys.argv[1], sys.argv[2:]
runs = collections.defaultdict(dict)
for line in open(path):
    m = re.match(r'round (\d+) pass (\d+) tree (\w+) exit=(\d+) ns=(\d+)', line)
    if m and m.group(4) == '0':
        runs[(int(m.group(1)), int(m.group(2)))][m.group(3)] = int(m.group(5))
    elif line.startswith('objects'):
        print(line.rstrip())
def q(v, p):
    v = sorted(v)
    return v[min(len(v) - 1, int(p * (len(v) - 1) + 0.5))]
base = trees[0]
for t in trees:
    v = [r[t] for r in runs.values() if t in r]
    print(f'{t:6s} runs={len(v):2d} median={statistics.median(v)/1e6:8.3f} ms least={min(v)/1e6:8.3f} p25={q(v,.25)/1e6:8.3f} p75={q(v,.75)/1e6:8.3f}')
for t in trees[1:]:
    d = [100 * (r[t] / r[base] - 1) for r in runs.values() if t in r and base in r]
    print(f'{t} against {base}: paired runs median {statistics.median(d):+.2f}% [{min(d):+.2f}% .. {max(d):+.2f}%], {sum(x < 0 for x in d)} of {len(d)} faster')
