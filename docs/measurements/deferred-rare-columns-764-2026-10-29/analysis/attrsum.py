#!/usr/bin/env python3
# Summarizes a fixed-period cycles profile (perf record -e cycles -c PERIOD; perf script -F pid,tid,ip,sym, gzipped):
# the main thread's and the lanes' (every other thread's) samples, user and kernel, and their kernel samples by symbol,
# in millions of cycles (samples times PERIOD).
#   attrsum.py PERIOD FILE.txt.gz...
import gzip, sys, collections, re
period = int(sys.argv[1])
for path in sys.argv[2:]:
    threads = collections.Counter()
    kernel = collections.defaultdict(collections.Counter)
    user = collections.defaultdict(collections.Counter)
    pid = None
    for line in gzip.open(path, 'rt', errors='replace'):
        parts = line.split()
        if len(parts) < 3:
            continue
        m = re.match(r'(\d+)/(\d+)', parts[0])
        if not m:
            continue
        p, t = int(m.group(1)), int(m.group(2))
        ip = int(parts[1], 16)
        sym = parts[2] if len(parts) > 2 else '[unknown]'
        who = 'main' if p == t else 'lanes'
        if ip >= 0xffff800000000000:
            kernel[who][sym] += 1
        else:
            user[who][sym] += 1
        threads[(who, t)] += 1
    print(path)
    for who in ('main', 'lanes'):
        k = sum(kernel[who].values())
        u = sum(user[who].values())
        n = len([1 for (w, t) in threads if w == who])
        print('  %-5s threads=%d user=%.1f Mcycles kernel=%.1f Mcycles' % (who, n, u * period / 1e6, k * period / 1e6))
        for sym, c in kernel[who].most_common(12):
            print('      kernel %8.1f %s' % (c * period / 1e6, sym))
        for sym, c in user[who].most_common(6):
            print('      user   %8.1f %s' % (c * period / 1e6, sym))
