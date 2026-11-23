#!/usr/bin/env python3
# chain.py BINARY TARGET IPS...: per run, the samples whose inline chain holds TARGET, by the out-of-line function they
# are in, and by TARGET's own frame's line (where its code or an inlined callee's call site is); and by innermost frame.
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
outer = collections.Counter(); own = collections.Counter(); inner = collections.Counter()
runs = float(len(paths)); P = 200003 / 1e6
for a, b in zip(addrs, out.strip('\n').split('\n\n')):
    rows = b.split('\n')
    frames = [(rows[i].replace('.buster_split', ''), rows[i + 1].rsplit('/', 1)[-1].rsplit(':', 1)[0]) for i in range(0, len(rows) - 1, 2)]
    names = [f[0] for f in frames]
    if target in names:
        i = names.index(target)
        n = counts[a]
        outer[names[-1]] += n
        own[frames[i][1]] += n
        inner['%s@%s' % frames[0]] += n
tot = sum(outer.values())
print('== %s: %.2f M a run' % (target, tot / runs * P))
print('== by out-of-line function')
for k, v in outer.most_common(8): print('%7.2f\t%s' % (v / runs * P, k))
print('== by %s line' % target)
for k, v in own.most_common(int(sys.argv[0] and 40)): print('%7.2f\t%s' % (v / runs * P, k))
print('== by innermost frame')
for k, v in inner.most_common(30): print('%7.2f\t%s' % (v / runs * P, k))
