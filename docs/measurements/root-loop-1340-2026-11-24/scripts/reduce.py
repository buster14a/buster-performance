#!/usr/bin/env python3
# Reduces roots-ab.sh's results: each variant's task-clock (ms), user cycles and instructions (M) and L1 misses (k), a
# round at a time and their mean, and each variant less the first. Usage: reduce.py DIRECTORY
import csv, glob, os, re, sys
d = sys.argv[1]
rows = {}
for path in sorted(glob.glob(os.path.join(d, "stat-*.csv"))):
    m = re.match(r"stat-(.*)-(\d)\.csv", os.path.basename(path))
    name, rnd = m.group(1), int(m.group(2))
    vals = {}
    for line in open(path):
        parts = line.strip().split(",")
        if len(parts) > 3 and parts[0] not in ("", "#") and not line.startswith("#"):
            try:
                vals[parts[2]] = float(parts[0])
            except ValueError:
                pass
    rows.setdefault(name, {})[rnd] = vals
names = sorted(rows, key=lambda n: (n.endswith("-w"), n))
order = [n for n in open(os.path.join(d, "compilers.txt")).read().split() if False]
keys = [("task-clock", 1.0, "ms"), ("cycles:u", 1e-6, "M cycles"), ("instructions:u", 1e-6, "M instr"), ("L1-dcache-load-misses:u", 1e-3, "k L1 miss")]
def mean(name, key):
    v = [rows[name][r][key] for r in sorted(rows[name]) if key in rows[name][r]]
    return sum(v) / len(v)
first = [n for n in names if n.startswith("base") and not n.endswith("-w")]
ref = first[0] if first else names[0]
print("variant | " + " | ".join(u for _, _, u in keys) + " | rounds' ms")
for n in names:
    print(n + " | " + " | ".join("%.2f" % (mean(n, k) * s) for k, s, _ in keys) + " | " + " ".join("%.2f" % rows[n][r]["task-clock"] for r in sorted(rows[n])))
print()
print("less %s | " % ref + " | ".join(u for _, _, u in keys) + " | rounds' ms")
for n in names:
    if n != ref:
        print(n + " | " + " | ".join("%+.2f" % ((mean(n, k) - mean(ref, k)) * s) for k, s, _ in keys) + " | " + " ".join("%+.2f" % (rows[n][r]["task-clock"] - rows[ref][r]["task-clock"]) for r in sorted(rows[n])))
for f in ("differs.txt",):
    p = os.path.join(d, f)
    print(f, "present:" if os.path.exists(p) else "absent", open(p).read() if os.path.exists(p) else "")
bad = [p for p in glob.glob(os.path.join(d, "err-*.txt")) if "status=0" not in open(p).read()]
print("runs with a status other than 0:", bad)
