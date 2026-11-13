#!/usr/bin/env python3
# functions-delta.py A.functions B.functions: identity.sh's function lists (address, size, name), sorted by address:
# whether the two executables hold the same functions in the same order, how far each moved, and those whose size
# differs.
import collections, sys
def load(path):
    rows = []
    for line in open(path):
        address, size, name = line.split()
        rows.append((int(address, 16), int(size, 16), name))
    rows.sort()
    return rows
a = load(sys.argv[1])
b = load(sys.argv[2])
print(f"functions: {len(a)} and {len(b)}; the same names in the same order: {len(a) == len(b) and all(x[2] == y[2] for x, y in zip(a, b))}")
print("moved by (bytes: functions):", ", ".join(f"{d}: {n}" for d, n in collections.Counter(y[0] - x[0] for x, y in zip(a, b)).most_common(6)))
resized = [(x, y) for x, y in zip(a, b) if x[1] != y[1]]
print(f"another size: {len(resized)}")
for x, y in resized[:20]:
    print(f"  {x[2]}: {x[1]} and {y[1]} bytes")
