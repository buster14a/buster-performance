#!/usr/bin/env python3
# preagg.py LOW HIGH < `perf script -F brstack` > a profile in BOLT's pre-aggregated form: each sample's branch stack
# (newest first) gives its branches (B from to count mispredicted) and, between an older branch's target and the next
# branch's source, a fall-through (F start end count). Only addresses in [LOW, HIGH), the executable's text, are kept.
import sys, collections
low = int(sys.argv[1], 16); high = int(sys.argv[2], 16)
branches = collections.Counter(); mispredicted = collections.Counter(); falls = collections.Counter()
samples = 0
for line in sys.stdin:
    entries = line.split()
    if not entries:
        continue
    samples += 1
    stack = []
    for entry in entries:
        parts = entry.split('/')
        if len(parts) < 3:
            continue
        try:
            source = int(parts[0], 16); target = int(parts[1], 16)
        except ValueError:
            continue
        stack.append((source, target, parts[2] == 'M'))
    for i, (source, target, missed) in enumerate(stack):
        inside_source = low <= source < high; inside_target = low <= target < high
        if inside_source and inside_target:
            branches[(source, target)] += 1
            mispredicted[(source, target)] += missed
        if i > 0 and inside_target:
            # The branch taken after this one (the entry before it in the stack) left from `later`: straight-line code between.
            later = stack[i - 1][0]
            if low <= later < high and target <= later and later - target < 1 << 20:
                falls[(target, later)] += 1
for (source, target), count in sorted(branches.items()):
    print(f'B {source:x} {target:x} {count} {mispredicted[(source, target)]}')
for (start, end), count in sorted(falls.items()):
    print(f'F {start:x} {end:x} {count}')
print(f'samples {samples} branches {len(branches)} falls {len(falls)}', file=sys.stderr)
