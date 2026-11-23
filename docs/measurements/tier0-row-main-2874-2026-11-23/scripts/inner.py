#!/usr/bin/env python3
# inner.py CHAINS SYMBOL IPS...: the samples whose outermost function is SYMBOL, by the innermost function of their
# chain that matches a tier0_/x86_/... family (the pass), then by innermost function. buster#2874.
import collections, re, sys
chains_path, symbol = sys.argv[1], sys.argv[2]
counts = collections.Counter()
for path in sys.argv[3:]:
    for line in open(path):
        counts[int(line.split()[0], 16)] += 1
chains = {}
cur = None
for line in open(chains_path):
    line = line.rstrip('\n')
    if line.startswith('0x'):
        a, rest = line.split(': ', 1); cur = int(a, 16); chains[cur] = [rest.split(' at ')[0].replace('.buster_split', '')]
    elif line.startswith(' (inlined by) '):
        chains[cur].append(line[14:].split(' at ')[0].replace('.buster_split', ''))
depth = int(sys.argv[3]) if False else None
by_second = collections.Counter()
by_inner = collections.Counter()
total = 0
for a, n in counts.items():
    c = chains.get(a, ['??'])
    if c[-1] != symbol:
        continue
    total += n
    # the outermost-but-one function: the pass inlined into the symbol
    second = c[-2] if len(c) >= 2 else '(self)'
    third = c[-3] if len(c) >= 3 else '(self)'
    by_second[second + ' / ' + third] += n
    by_inner[c[0]] += n
print(symbol, total)
print('== by inlined pass (outermost-but-one / next)')
for k, n in by_second.most_common(60):
    print('%6d %5.1f%% %s' % (n, 100 * n / total, k))
print('== by innermost')
for k, n in by_inner.most_common(40):
    print('%6d %5.1f%% %s' % (n, 100 * n / total, k))
