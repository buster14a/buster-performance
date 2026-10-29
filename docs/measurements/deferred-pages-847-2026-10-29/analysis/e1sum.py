#!/usr/bin/env python3
# #847's E1: for each unit, the two trees' perf stat lines (task-clock, page faults, L1 and L2 data TLB misses, user and
# kernel cycles), and their page faults by thread (the main thread, the other threads: the lanes) and by symbol, from
# `perf script -F pid,tid,ip,sym,addr` (pid/tid, address, its symbol, IP, its symbol) of `perf record -e page-faults -c 1 -d`, head's less headhuge's.
#   e1sum.py LOG DIR UNIT...
import collections, gzip, os, re, sys
log, directory, units = sys.argv[1], sys.argv[2], sys.argv[3:]
stats = collections.defaultdict(dict)
current = None
for line in open(log, errors='replace'):
    m = re.match(r'== stat (\S+) (\S+) lanes', line)
    if m:
        current = (m.group(1), m.group(2))
        continue
    m = re.match(r'([\d.]+),[^,]*,([\w.:]+),', line)
    if m and current:
        stats[current][m.group(2)] = float(m.group(1))
    if line.startswith('== faults'):
        current = None
def faults(tree, unit):
    by = collections.Counter()
    threads = collections.Counter()
    for line in gzip.open(os.path.join(directory, f'faults-{tree}-{unit}.txt.gz'), 'rt', errors='replace'):
        parts = line.split()
        if len(parts) < 3 or '/' not in parts[0]:
            continue
        pid, tid = parts[0].split('/')
        who = 'main' if pid == tid else 'lanes'
        sym = parts[4] if len(parts) > 4 else '?'
        by[(who, sym)] += 1
        threads[who] += 1
    return by, threads
for unit in units:
    print(f'== {unit}')
    for tree in ('head-95fc3668', 'headhuge-95fc3668'):
        s = stats.get((tree, unit), {})
        print(f'  {tree:18s} ' + ' '.join(f'{k}={v:.0f}' for k, v in s.items()))
    h, ht = faults('head-95fc3668', unit)
    g, gt = faults('headhuge-95fc3668', unit)
    print(f'  faults: head main={ht["main"]} lanes={ht["lanes"]}; headhuge main={gt["main"]} lanes={gt["lanes"]}')
    diff = collections.Counter()
    for k in set(h) | set(g):
        diff[k] = h[k] - g[k]
    for (who, sym), d in sorted(diff.items(), key=lambda kv: -abs(kv[1]))[:14]:
        print(f'    {who:5s} {d:+7d}  head {h[(who, sym)]:7d}  huge {g[(who, sym)]:7d}  {sym}')
