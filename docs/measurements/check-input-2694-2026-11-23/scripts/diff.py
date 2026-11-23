#!/usr/bin/env python3
# diff.py A.tsv B.tsv PATTERN N: per-run sample differences (A - B) of attr.py's tables (values already per run), for
# keys matching PATTERN; one sample is PERIOD (200003) events. Prints the N largest growths and the 12 largest cuts.
import sys, re, collections
def load(f):
    d = collections.Counter()
    for line in open(f):
        v, k = line.rstrip('\n').split('\t', 1)
        d[k] += float(v)
    return d
a = load(sys.argv[1]); b = load(sys.argv[2])
pat = re.compile(sys.argv[3]); n = int(sys.argv[4])
period = 200003
keys = [k for k in set(a) | set(b) if pat.search(k)]
keys.sort(key=lambda k: -(a[k] - b[k]))
print('%9s %9s %9s  (M events a run)' % ('change', 'A', 'B'))
for k in keys[:n]: print('%+9.2f %9.2f %9.2f  %s' % ((a[k] - b[k]) * period / 1e6, a[k] * period / 1e6, b[k] * period / 1e6, k))
print('...')
for k in keys[-12:]: print('%+9.2f %9.2f %9.2f  %s' % ((a[k] - b[k]) * period / 1e6, a[k] * period / 1e6, b[k] * period / 1e6, k))
print('total matching: A %.2f M, B %.2f M' % (sum(a[k] for k in keys) * period / 1e6, sum(b[k] for k in keys) * period / 1e6))
