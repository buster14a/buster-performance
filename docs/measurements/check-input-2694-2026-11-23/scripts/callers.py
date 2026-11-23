#!/usr/bin/env python3
# callers.py BINARY FUNCTION IPS...: per run, the samples whose innermost frame is FUNCTION, by the frame that inlined
# it, or for an out-of-line one, by nothing (no call graph): the out-of-line function itself. M events (200003).
import sys, subprocess, collections
binary, target = sys.argv[1], sys.argv[2]
paths = sys.argv[3:]
counts = collections.Counter()
for path in paths:
    for line in open(path):
        p = line.split()
        if len(p) == 2 and p[1] == 'C':
            counts[int(p[0], 16)] += 1
addrs = sorted(counts)
out = subprocess.run(['llvm-symbolizer', '--inlining', '--functions=linkage', '--no-demangle', '--obj=' + binary],
                     input=''.join('0x%x\n' % a for a in addrs), capture_output=True, text=True).stdout
by = collections.Counter(); lines = collections.Counter()
for a, b in zip(addrs, out.strip('\n').split('\n\n')):
    rows = b.split('\n')
    frames = [(rows[i].replace('.buster_split', ''), rows[i + 1].rsplit('/', 1)[-1].rsplit(':', 1)[0]) for i in range(0, len(rows) - 1, 2)]
    if frames[0][0] == target:
        caller = frames[1] if len(frames) > 1 else ('(out of line)', '')
        by['%s@%s' % caller] += counts[a]
        lines[frames[0][1]] += counts[a]
r = len(paths); P = 200003 / 1e6
for k, v in by.most_common(15): print('%6.2f\t%s' % (v / r * P, k))
print('-- lines')
for k, v in lines.most_common(10): print('%6.2f\t%s' % (v / r * P, k))
