#!/usr/bin/env python3
# callers.py BINARY FUNCTION IPS...: for samples whose inline chain holds FUNCTION, the chain above it (callers), with
# each caller frame's source line.
import sys, subprocess, collections
binary, target = sys.argv[1], sys.argv[2]
counts = collections.Counter()
for path in sys.argv[3:]:
    for line in open(path):
        ip, kind = line.split()
        if kind == 'C':
            counts[int(ip, 16)] += 1
addrs = sorted(counts)
out = subprocess.run(['llvm-symbolizer', '--inlining', '--functions=linkage', '--no-demangle', '--obj=' + binary],
                     input=''.join('0x%x\n' % a for a in addrs), capture_output=True, text=True).stdout
chains = collections.Counter()
for a, b in zip(addrs, out.strip('\n').split('\n\n')):
    rows = b.split('\n')
    frames = [(rows[i], rows[i + 1].rsplit('/', 1)[-1].rsplit(':', 1)[0]) for i in range(0, len(rows) - 1, 2)]
    names = [f[0].replace('.buster_split', '') for f in frames]
    if target in names:
        i = names.index(target)
        # The frame's own line and its two callers' lines.
        chain = ' <- '.join('%s@%s' % (names[j], frames[j][1]) for j in range(i, min(i + 3, len(frames))))
        chains[chain] += counts[a]
for k, v in chains.most_common(25):
    print('%d\t%s' % (v, k))
