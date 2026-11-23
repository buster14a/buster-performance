#!/usr/bin/env python3
# lines.py SRC [FUNCTION...]: perf script -F ip,sym,srcline reduced: per source file its share of the samples, and for
# each FUNCTION named its hottest source lines.
import sys, collections
lines = [l.rstrip('\n') for l in open(sys.argv[1])]
samples = []
i = 0
while i < len(lines):
    head = lines[i].split()
    src = lines[i + 1].strip() if i + 1 < len(lines) and lines[i + 1].startswith('  ') and len(lines[i + 1].split()) == 1 else '?'
    if len(head) >= 2:
        samples.append((head[1].split('+')[0], src)); i += 2 if src != '?' else 1
    else:
        i += 1
n = len(samples)
files = collections.Counter(s[1].split(':')[0] for s in samples)
print('samples', n)
print('--- by source file, top 45')
for f, c in files.most_common(45): print(f'{100*c/n:6.2f}%  {f}')
for w in sys.argv[2:]:
    hot = collections.Counter(s[1] for s in samples if s[0].startswith(w))
    total = sum(hot.values())
    print(f'--- {w}: {100*total/n:.2f}% own; hottest lines')
    for l, c in hot.most_common(22): print(f'{100*c/n:6.2f}%  {l}')
