#!/usr/bin/env python3
# within.py BINARY FUNCTION RUNS IPS...: per-run samples of the samples whose inline chain holds FUNCTION, by the line
# of FUNCTION's own frame (where its code or an inlined callee's call site is), and by the innermost frame.
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
own = collections.Counter(); innermost = collections.Counter()
for a, b in zip(addrs, out.strip('\n').split('\n\n')):
    rows = b.split('\n')
    frames = [(rows[i].replace('.buster_split', ''), rows[i + 1].rsplit('/', 1)[-1].rsplit(':', 1)[0]) for i in range(0, len(rows) - 1, 2)]
    names = [f[0] for f in frames]
    if target in names:
        i = names.index(target)
        own[frames[i][1]] += counts[a]
        innermost['%s@%s' % frames[0]] += counts[a]
print('== by %s line' % target)
for k, v in own.most_common(30): print('%6.1f\t%s' % (v / runs, k))
print('== by innermost frame')
for k, v in innermost.most_common(20): print('%6.1f\t%s' % (v / runs, k))
