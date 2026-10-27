#!/usr/bin/env python3
# Summarizes one series of the A/B: benchmark-backend's vector and scalar rows per round and tree, the vector path alone,
# and perf stat's -c sqlite3.c means, with each tree's median and range over the rounds and the second tree's ratio to
# the first's. Usage: summarize.py RESULTS_DIRECTORY MAIN_TREE HEAD_TREE (results, main, head for queue.sh's series;
# results-fix, main, fix; results-final, main, final; results-merged, main2, merged).
import glob, os, re, statistics, sys

directory, first, second = sys.argv[1], sys.argv[2], sys.argv[3]
trees = (first, second)

def backend(path, variant):
    for line in open(path):
        parts = line.split()
        if parts and parts[0] == variant:
            return [float(x) for x in parts[1:]]
    return None

def perf(path):
    values = {}
    for line in open(path):
        fields = line.strip().split(",")
        if len(fields) >= 3 and fields[2] in ("instructions:u", "cycles:u", "task-clock"):
            values[fields[2]] = float(fields[0])
    return values

rows = {}
for tree in trees:
    for path in sorted(glob.glob(os.path.join(directory, f"backend-{tree}-*.txt"))):
        r = int(re.search(r"-(\d+)\.txt$", path).group(1))
        v = backend(path, "vector")
        s = backend(path, "scalar")
        alone = backend(os.path.join(directory, f"backend-vector-{tree}-{r}.txt"), "vector")
        p = perf(os.path.join(directory, f"sqlite-{tree}-{r}.txt"))
        rows.setdefault(tree, []).append((r, v, s, alone, p))
    rows.get(tree, []).sort()

print("round tree | vector ns cyc ins | scalar ns cyc ins | vector alone ns cyc ins | sqlite instr cycles ms")
for tree in trees:
    for r, v, s, a, p in rows.get(tree, []):
        print(f"{r} {tree} | {v[0]:.2f} {v[1]:.2f} {v[2]:.2f} | {s[0]:.2f} {s[1]:.2f} {s[2]:.2f} | {a[0]:.2f} {a[1]:.2f} {a[2]:.2f} | "
              f"{p.get('instructions:u', 0):,.0f} {p.get('cycles:u', 0):,.0f} {p.get('task-clock', 0):.2f}")

def stat(tree, pick):
    xs = [pick(row) for row in rows.get(tree, [])]
    return (statistics.median(xs), min(xs), max(xs)) if xs else (0, 0, 0)

items = [
    ("vector ns/entry", lambda r: r[1][0]), ("vector cyc/entry", lambda r: r[1][1]), ("vector ins/entry", lambda r: r[1][2]),
    ("scalar ns/entry", lambda r: r[2][0]), ("scalar cyc/entry", lambda r: r[2][1]), ("scalar ins/entry", lambda r: r[2][2]),
    ("vector alone ns/entry", lambda r: r[3][0]), ("vector alone cyc/entry", lambda r: r[3][1]), ("vector alone ins/entry", lambda r: r[3][2]),
    ("sqlite instructions", lambda r: r[4].get("instructions:u", 0)), ("sqlite cycles", lambda r: r[4].get("cycles:u", 0)),
    ("sqlite ms", lambda r: r[4].get("task-clock", 0)),
]
print()
print(f"measure | {first} median [min, max] | {second} median [min, max] | {second}/{first}")
for name, pick in items:
    m = stat(first, pick)
    h = stat(second, pick)
    ratio = h[0] / m[0] if m[0] else 0
    print(f"{name} | {m[0]:,.2f} [{m[1]:,.2f}, {m[2]:,.2f}] | {h[0]:,.2f} [{h[1]:,.2f}, {h[2]:,.2f}] | {ratio:.4f}")
