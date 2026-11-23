#!/usr/bin/env python3
# lines.py CHAINS FUNCTION IPS...: the samples whose chain has FUNCTION, by the source line of FUNCTION's frame in the
# chain (where inside it the sample was, through what it inlined). buster#2874.
import collections, sys
chains_path, function = sys.argv[1], sys.argv[2]
counts = collections.Counter()
for path in sys.argv[3:]:
    for line in open(path):
        counts[int(line.split()[0], 16)] += 1
frames = {}
cur = None
for line in open(chains_path):
    line = line.rstrip('\n')
    if line.startswith('0x'):
        a, rest = line.split(': ', 1); cur = int(a, 16); frames[cur] = [rest]
    elif line.startswith(' (inlined by) '):
        frames[cur].append(line[14:])
by_line = collections.Counter()
total = 0
for a, n in counts.items():
    for f in frames.get(a, []):
        name, _, where = f.partition(' at ')
        if name.replace('.buster_split', '') == function:
            by_line[where] += n
            total += n
            break
print(function, total)
for k, n in sorted(by_line.items(), key=lambda kv: -kv[1])[:50]:
    print('%6d %5.1f%% %s' % (n, 100 * n / total, k))
