#!/usr/bin/env python3
# Leaf symbols of perf script's samples whose stack holds FUNCTION, and the share of callers for a few leaves.
import sys, collections
function = sys.argv[1]
leaves = collections.Counter(); pairs = collections.Counter(); total = 0; stack = []
def flush():
    global total
    if stack and any(function in f for f in stack):
        total += 1
        leaves[stack[0]] += 1
        if len(stack) > 1:
            pairs[stack[0] + ' <- ' + stack[1]] += 1
for line in sys.stdin:
    line = line.rstrip('\n')
    if not line.strip():
        flush(); stack = []
    elif line.startswith('\t') or line.startswith(' '):
        parts = line.split()
        if len(parts) >= 2:
            stack.append(parts[1].split('+')[0])
    else:
        flush(); stack = []
flush()
print(f'{total} samples under {function}')
for name, k in leaves.most_common(40): print(f'{100*k/total:6.2f}% {k:7d} {name}')
print('-- leaf <- caller')
for name, k in pairs.most_common(30): print(f'{100*k/total:6.2f}% {k:7d} {name}')
