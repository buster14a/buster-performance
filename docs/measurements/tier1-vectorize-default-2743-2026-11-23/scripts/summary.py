#!/usr/bin/env python3
"""summary.py OUT_DIR: #2743's kernels by clang -O2, main's --tier1 (base-tier1) and the branch's (head-tier1), from
OUT_DIR/results.txt (run-one.sh's lines) and OUT_DIR/short.txt (run-short.sh's): every digest against clang -O2's,
each kernel's ns per element as linked (placement 0) and at its best of four placements, the geometric means over the 19
loops clang vectorizes and the 6 controls, and the short trip counts' ns per call by trip count."""
import math
import sys
from collections import defaultdict

LOOPS = ["sum_i32", "sum_u8", "dot_i16", "max_i32", "count_eq_u8", "cond_sum_i32", "popcount_u64", "aos_sum", "add_i32",
         "saxpy_f32", "scale_u8", "blend_u8", "clamp_i32", "i32_to_f32", "fill_u32", "copy_u8", "stencil3_u8",
         "rgb_to_gray", "matmul_f32"]
CONTROLS = ["dot_f32", "prefix_sum_i32", "histogram_u8", "find_u8", "crc32_table", "fnv1a"]
BUILDS = ["clang-O2", "base-tier1", "head-tier1"]


def geomean(values):
    return math.exp(sum(math.log(v) for v in values) / len(values))


def main():
    out = sys.argv[1]
    ns = defaultdict(dict)
    digests = defaultdict(dict)
    perf = {}
    problems = []
    for line in open(f"{out}/results.txt"):
        f = line.split()
        if not f:
            continue
        if f[0] == "perf":
            # perf MARCH NAME k 1 c1 i1 reps cN iN status s1 sN
            perf[(f[2], f[3])] = (int(f[5]), int(f[6]), int(f[7]), int(f[8]), int(f[9]))
            if f[11] != "0" or f[12] != "0":
                problems.append(line.strip())
            continue
        name, pad = f[1], f[2]
        kernel, value, digest = f[3], float(f[7]), f[8]
        status = f[-1]
        if status != "0":
            problems.append(line.strip())
        ns[(name, kernel)][pad] = value
        digests[(name, kernel)][pad] = digest
    for (name, kernel), pads in digests.items():
        reference = digests.get(("clang-O2", kernel), {}).get("pad0")
        for pad, digest in pads.items():
            if digest != reference:
                problems.append(f"digest {name} {kernel} {pad} {digest} != clang-O2's {reference}")
    print(f"# {out}: {len(problems)} problems")
    for p in problems:
        print("PROBLEM", p)

    def linked(name, kernel):
        return ns[(name, kernel)]["pad0"]

    def best(name, kernel):
        return min(ns[(name, kernel)].values())

    print("\n| Kernel | clang -O2 | main --tier1 | branch --tier1 | main / clang | branch / clang | main / branch |")
    print("| --- | ---: | ---: | ---: | ---: | ---: | ---: |")
    for kernel in LOOPS + CONTROLS:
        c, b, h = (linked(n, kernel) for n in BUILDS)
        cb, bb, hb = (best(n, kernel) for n in BUILDS)
        print(f"| {kernel} | {c:.4f} / {cb:.4f} | {b:.4f} / {bb:.4f} | {h:.4f} / {hb:.4f} | {b / c:.2f} / {bb / cb:.2f} | "
              f"{h / c:.2f} / {hb / cb:.2f} | {b / h:.2f} / {bb / hb:.2f} |")
    print("\nGeometric means, as linked / best placement:\n")
    print("| | 19 loops clang vectorizes | 6 controls |")
    print("| --- | ---: | ---: |")
    for label, num, den in (("main --tier1 / clang -O2", "base-tier1", "clang-O2"),
                            ("branch --tier1 / clang -O2", "head-tier1", "clang-O2"),
                            ("main --tier1 / branch --tier1", "base-tier1", "head-tier1")):
        cells = []
        for group in (LOOPS, CONTROLS):
            a = geomean([linked(num, k) / linked(den, k) for k in group])
            b = geomean([best(num, k) / best(den, k) for k in group])
            cells.append(f"{a:.2f} / {b:.2f}")
        print(f"| {label} | {cells[0]} | {cells[1]} |")
    if perf:
        print("\nCycles and instructions per element of the calibrated run at placement 0 (perf, user):\n")
        print("| Kernel | main cycles | branch cycles | main instructions | branch instructions |")
        print("| --- | ---: | ---: | ---: | ---: |")
        elements = {}
        for line in open(f"{out}/results.txt"):
            f = line.split()
            if f and f[0] != "perf" and f[2] == "pad0":
                elements[f[3]] = int(f[4])
        for kernel in LOOPS + CONTROLS:
            row = []
            for name in ("base-tier1", "head-tier1"):
                c1, i1, reps, cn, i_n = perf[(name, kernel)]
                count = (reps - 1) * elements[kernel]
                row.append(((cn - c1) / count, (i_n - i1) / count))
            print(f"| {kernel} | {row[0][0]:.3f} | {row[1][0]:.3f} | {row[0][1]:.3f} | {row[1][1]:.3f} |")
    try:
        short = open(f"{out}/short.txt").read().splitlines()
    except FileNotFoundError:
        short = []
    if short:
        calls = defaultdict(dict)
        sdig = defaultdict(dict)
        bad = 0
        for line in short:
            f = line.split()
            # short MARCH NAME kernel n reps seconds ns digest status S
            name, kernel, n, value, digest, status = f[2], f[3], int(f[4]), float(f[7]), f[8], f[10]
            calls[(name, kernel)][n] = value
            sdig[(name, kernel)][n] = digest
            bad += status != "0"
        for (name, kernel), d in sdig.items():
            for n, digest in d.items():
                if digest != sdig[("clang-O2", kernel)][n]:
                    bad += 1
                    print(f"PROBLEM short digest {name} {kernel} n={n}")
        print(f"\nShort trip counts ({bad} problems): ns per call, branch / main, by trip count\n")
        trips = sorted(calls[("head-tier1", LOOPS[0])].keys())
        print("| Kernel | " + " | ".join(str(t) for t in trips) + " |")
        print("| --- |" + " ---: |" * len(trips))
        for kernel in LOOPS + CONTROLS:
            cells = [f"{calls[('head-tier1', kernel)][t] / calls[('base-tier1', kernel)][t]:.2f}" for t in trips]
            print(f"| {kernel} | " + " | ".join(cells) + " |")
        for group_name, group in (("19 loops", LOOPS), ("6 controls", CONTROLS)):
            cells = [f"{geomean([calls[('head-tier1', k)][t] / calls[('base-tier1', k)][t] for k in group]):.2f}" for t in trips]
            print(f"| geomean, {group_name} | " + " | ".join(cells) + " |")
        print("\nns per call by trip count, main / branch / clang -O2, for each kernel:\n")
        for kernel in LOOPS + CONTROLS:
            cells = [f"{t}: {calls[('base-tier1', kernel)][t]:.1f}/{calls[('head-tier1', kernel)][t]:.1f}/{calls[('clang-O2', kernel)][t]:.1f}" for t in trips]
            print(f"- {kernel}: " + ", ".join(cells))


main()
