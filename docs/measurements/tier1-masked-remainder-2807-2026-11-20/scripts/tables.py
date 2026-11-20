#!/usr/bin/env python3
# tables.py RECORD: buster#2807's tables from record/short-*.tsv and record/long-*.tsv. For each kernel and length, the
# least of the three rounds' ticks a call for base and head; then per kernel the geometric mean of head/base over the
# lengths below one vector, over those with a remainder past one vector, and over the exact multiples (the lanes at 64
# bytes as each kernel's widest element gives them). The 8 KB harness: ns per element, the least of three rounds.
import sys, glob, math, os
record = sys.argv[1]
lanes = {"sum_i32": 8, "sum_u8": 16, "dot_i16": 16, "cond_sum_i32": 8, "popcount_u64": 8, "add_i32": 16, "scale_u8": 16,
         "blend_u8": 16, "clamp_i32": 16, "fill_u32": 16, "copy_u8": 64, "stencil3_u8": 16}
def read_short(tree):
    best = {}
    digests = set()
    for path in sorted(glob.glob(os.path.join(record, f"short-{tree}-*.tsv"))):
        for line in open(path):
            f = line.split()
            if f[0] == "digest":
                digests.add(f[1]); continue
            key = (f[0], int(f[1])); v = float(f[2])
            best[key] = min(best.get(key, v), v)
    return best, digests
b, bd = read_short("base"); h, hd = read_short("head")
print("digests base", sorted(bd), "head", sorted(hd))
print("| kernel | lanes | below one vector | remainder past one | exact multiples | all lengths |")
print("| --- | ---: | ---: | ---: | ---: | ---: |")
groups_all = {"below": [], "rem": [], "exact": [], "all": []}
for k, L in lanes.items():
    g = {"below": [], "rem": [], "exact": [], "all": []}
    for (name, n), bv in b.items():
        if name != k or (name, n) not in h or n == 0:
            continue
        trip = n - 2 if k == "stencil3_u8" else n
        if trip <= 0:
            continue
        r = h[(name, n)] / bv
        cls = "below" if trip < L else ("exact" if trip % L == 0 else "rem")
        g[cls].append(r); g["all"].append(r)
        groups_all[cls].append(r); groups_all["all"].append(r)
    gm = lambda xs: (math.exp(sum(map(math.log, xs)) / len(xs)) if xs else float("nan"))
    print(f"| `{k}` | {L} | {gm(g['below']):.3f} ({len(g['below'])}) | {gm(g['rem']):.3f} ({len(g['rem'])}) | {gm(g['exact']):.3f} ({len(g['exact'])}) | {gm(g['all']):.3f} |")
gm = lambda xs: math.exp(sum(map(math.log, xs)) / len(xs))
print(f"| all 12 | | {gm(groups_all['below']):.3f} | {gm(groups_all['rem']):.3f} | {gm(groups_all['exact']):.3f} | {gm(groups_all['all']):.3f} |")
print()
def read_long(tree):
    best = {}; digest = {}
    for path in sorted(glob.glob(os.path.join(record, f"long-{tree}-*.tsv"))):
        for line in open(path):
            f = line.split()
            if len(f) < 6: continue
            best[f[0]] = min(best.get(f[0], float(f[4])), float(f[4])); digest.setdefault(f[0], set()).add(f[5])
    return best, digest
lb, ld = read_long("base"); lh, lhd = read_long("head")
print("| kernel (8 KB) | base ns/elem | head ns/elem | head/base | digests agree |")
print("| --- | ---: | ---: | ---: | --- |")
rs = []
for k in lb:
    r = lh[k] / lb[k]; rs.append(r)
    print(f"| `{k}` | {lb[k]:.4f} | {lh[k]:.4f} | {r:.3f} | {ld[k] == lhd[k] and len(ld[k]) == 1} |")
print(f"| geometric mean of {len(rs)} | | | {gm(rs):.3f} | |")
