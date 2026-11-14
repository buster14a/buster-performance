#!/usr/bin/env python3
# within2.py BINARY FUNCTION RUNS IPS...: per-run samples whose inline chain holds FUNCTION, by the innermost frame's
# function name (lines dropped, so two builds compare).
import sys, subprocess, collections
binary, target, runs = sys.argv[1], sys.argv[2], float(sys.argv[3])
counts = collections.Counter()
for path in sys.argv[4:]:
    for line in open(path):
        ip, kind = line.split()
        if kind == 'C':
            counts[int(ip, 16)] += 1
addrs = sorted(counts)
out = subprocess.run(['llvm-symbolizer', '--inlining', '--functions=linkage', '--no-demangle', '--obj=' + binary],
                     input=''.join('0x%x\n' % a for a in addrs), capture_output=True, text=True).stdout
res = collections.Counter()
for a, b in zip(addrs, out.strip('\n').split('\n\n')):
    rows = b.split('\n')
    names = [rows[i].replace('.buster_split', '') for i in range(0, len(rows) - 1, 2)]
    if target in names:
        i = names.index(target)
        # the frame just below the target (the inlined callee it is in), or the target itself
        res[names[i - 1] if i > 0 else target] += counts[a]
for k, v in res.most_common():
    print('%.1f\t%s' % (v / runs, k))
