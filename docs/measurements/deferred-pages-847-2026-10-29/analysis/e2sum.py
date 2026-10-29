#!/usr/bin/env python3
# #847's E2: for each unit and run (the claim tree forced huge, main, the claim tree as it is), the perf stat lines
# (task-clock, page faults, user and kernel cycles) and, from every page fault recorded with its time (`perf script -F
# pid,tid,time,ip,sym,addr`: pid/tid, time, address, its symbol, IP, its symbol), the 2 MB regions that more than one
# thread faulted within WINDOW µs of the region's first fault, none of them more than twice (a huge page's first
# write, or a load and then a store: not a region of base pages, which each thread faults a 4 KB page at a time):
# the regions the threads met at, and the threads' faults there past the first's.
#   e2sum.py LOG DIR UNIT...
import collections, gzip, os, re, sys
WINDOW = 100e-6
log, directory, units = sys.argv[1], sys.argv[2], sys.argv[3:]
stats = collections.defaultdict(dict)
current = None
for line in open(log, errors='replace'):
    m = re.match(r'== stat (\S+) (\S+) lanes', line)
    if m:
        current = (m.group(1), m.group(2))
        continue
    m = re.match(r'([\d.]+),[^,]*,([\w.:-]+),', line)
    if m and current:
        stats[current][m.group(2)] = float(m.group(1))
    if line.startswith('== faults'):
        current = None
def faults(name, unit):
    rows = []
    for line in gzip.open(os.path.join(directory, f'faults-{name}-{unit}.txt.gz'), 'rt', errors='replace'):
        parts = line.split()
        if len(parts) < 4 or '/' not in parts[0] or not parts[1].endswith(':'):
            continue
        pid, tid = parts[0].split('/')
        rows.append((float(parts[1][:-1]), int(tid), pid == tid, int(parts[2], 16), parts[-1]))
    rows.sort()
    return rows
def meetings(rows):
    by_region = collections.defaultdict(list)
    for time, tid, main, address, symbol in rows:
        if address < 0x7f0000000000 and address > 0x10000000:
            by_region[address >> 21].append((time, tid, main, symbol))
    met = extra = 0
    symbols = collections.Counter()
    for region, list_ in by_region.items():
        i = 0
        while i < len(list_):
            start = list_[i][0]
            j = i
            while j < len(list_) and list_[j][0] - start <= WINDOW:
                j += 1
            burst = list_[i:j]
            per = collections.Counter(t for _, t, _, _ in burst)
            if len(per) > 1 and max(per.values()) <= 2:
                met += 1
                extra += len(per) - 1
                for _, _, _, symbol in burst:
                    symbols[symbol] += 1
            i = j
    return met, extra, symbols
print('| Unit | Run | task-clock, ms | Page faults | Kernel Mcycles | User Mcycles | Lanes\' faults | Regions met at | Threads past the first | Their symbols |')
print('| --- | --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | --- |')
for unit in units:
    for name in sorted({n for (n, u) in stats if u == unit}, key=lambda n: (('huge' not in n), n)):
        s = stats[(name, unit)]
        path = os.path.join(directory, f'faults-{name}-{unit}.txt.gz')
        if not os.path.exists(path):
            continue
        rows = faults(name, unit)
        lanes = sum(1 for r in rows if not r[2])
        met, extra, symbols = meetings(rows)
        top = ', '.join(f'{k} {v}' for k, v in symbols.most_common(3))
        print(f'| `{unit}.c` | {name} | {s.get("task-clock", 0):.1f} | {s.get("page-faults", 0):.0f} | {s.get("cycles:k", 0) / 1e6:.1f} | '
              f'{s.get("cycles:u", 0) / 1e6:.1f} | {lanes} | {met} | {extra} | {top} |')
