#!/usr/bin/env python3
"""tables.py RESULTS VECTORIZED: Markdown tables of one target's run (run-one.sh's lines).

RESULTS holds lines `MARCH NAME padP KERNEL ELEMENTS REPS SECONDS NS DIGEST | LOOP | status S` and
`perf MARCH NAME KERNEL 1 C1 I1 REPS CN IN status S1 SN`; VECTORIZED names the kernels whose object code the
vectorizer changed at that target (vectorized.py's output), one per line.
"""
import math
import sys

VECTOR = ["sum_i32", "sum_u8", "dot_i16", "max_i32", "count_eq_u8", "cond_sum_i32", "popcount_u64", "aos_sum", "add_i32", "saxpy_f32", "scale_u8", "blend_u8", "clamp_i32", "i32_to_f32", "fill_u32", "copy_u8", "stencil3_u8", "rgb_to_gray", "matmul_f32"]
CONTROL = ["dot_f32", "prefix_sum_i32", "histogram_u8", "find_u8", "crc32_table", "fnv1a"]
HAND = ["sum_i32", "sum_u8", "dot_i16", "max_i32", "count_eq_u8", "cond_sum_i32", "add_i32", "saxpy_f32", "scale_u8", "clamp_i32", "i32_to_f32", "fill_u32"]
KERNELS = VECTOR + CONTROL
PADS = ["pad0", "pad16", "pad32", "pad48"]
VEC = "buster-tier1-vec"
T1 = "buster-tier1"

def geomean(values):
    values = [v for v in values if v is not None and v > 0]
    return math.exp(sum(math.log(v) for v in values) / len(values)) if values else None

def fmt(value, digits=3):
    return "" if value is None else f"{value:.{digits}f}"

def ratio(a, b):
    return None if a is None or b is None or b == 0 else a / b

def table(header, rows):
    print("| " + " | ".join(header) + " |")
    print("| --- |" + " ---: |" * (len(header) - 1))
    for row in rows:
        print("| " + " | ".join(row) + " |")
    print()

def main():
    times, digests, perf, elements, bad = {}, {}, {}, {}, []
    march = "?"
    lines = [l.strip() for l in open(sys.argv[1]) if l.strip()]
    for line in lines:
        f = line.split("|")[0].split()
        if f[0] != "perf":
            parts = [p.strip() for p in line.split("|")]
            if len(f) != 9 or (len(parts) > 2 and parts[2] != "status 0"):
                bad.append(line)
                continue
            march, name, pad, kernel = f[0], f[1], f[2], f[3]
            elements[kernel] = int(f[4])
            times.setdefault((name, pad), {})[kernel] = float(f[7])
            digests.setdefault(kernel, {}).setdefault(f[8], set()).add(name)
    for line in lines:
        f = line.split()
        if f[0] == "perf":
            try:
                name, kernel = f[2], f[3]
                c1, i1, reps, cn, i_n = int(f[5]), int(f[6]), int(f[7]), int(f[8]), int(f[9])
                if f[11] != "0" or f[12] != "0" or reps < 2:
                    bad.append(line)
                    continue
                per = (reps - 1) * elements[kernel]
                perf.setdefault(name, {})[kernel] = ((cn - c1) / per, (i_n - i1) / per)
            except (ValueError, IndexError, KeyError):
                bad.append(line)
    vectorized = [l.strip() for l in open(sys.argv[2]) if l.strip()]
    at = lambda name, pad, k: times.get((name, pad), {}).get(k)
    best = lambda name, k: min([v for v in (at(name, p, k) for p in PADS) if v is not None], default=None)
    names = sorted({n for n, _ in times})
    mismatched = [k for k in KERNELS if len(digests.get(k, {})) != 1]
    print(f"## -march={march}\n")
    print(f"Builds: {', '.join(names)}. Timing lines: {sum(len(v) for v in times.values())}, perf lines: {sum(len(v) for v in perf.values())}, unused: {len(bad)}. "
          f"Kernels whose digest differs between builds: {len(mismatched)} {mismatched if mismatched else ''}\n")
    print(f"Loops the vectorizer changed here ({len(vectorized)}): {', '.join(vectorized)}.\n")
    print("### ns per element, as linked (placement 0)\n")
    columns = [c for c in (T1, VEC, "clang-O2-novec-nounroll", "clang-O2-novec", "clang-O2") if (c, "pad0") in times]
    rows = []
    for k in KERNELS:
        t1, v, c2 = at(T1, "pad0", k), at(VEC, "pad0", k), at("clang-O2", "pad0", k)
        rows.append([k + (" (v)" if k in vectorized else "")] + [fmt(at(c, "pad0", k)) for c in columns] + [fmt(ratio(t1, v), 2), fmt(ratio(v, c2), 2)])
    table(["Kernel"] + columns + ["tier1 / vec", "vec / clang-O2"], rows)
    print("### Geometric means of time ratios (larger is slower)\n")
    groups = [("19 loops clang vectorizes", VECTOR), ("the vectorized ones", [k for k in VECTOR if k in vectorized]), ("the 19 others", [k for k in VECTOR if k not in vectorized]), ("6 controls", CONTROL)]
    pairs = [(T1, "clang-O2"), (VEC, "clang-O2"), (T1, VEC), (VEC, "clang-O2-novec-nounroll"), (VEC, "clang-O2-novec")]
    rows = []
    for a, b in pairs:
        row = [f"{a} / {b}"]
        for _, group in groups:
            row.append(fmt(geomean([ratio(at(a, "pad0", k), at(b, "pad0", k)) for k in group]), 2) + " / " + fmt(geomean([ratio(best(a, k), best(b, k)) for k in group]), 2))
        rows.append(row)
    table(["Ratio (as linked / best placement)"] + [f"{n} ({len(g)})" for n, g in groups], rows)
    for name in (VEC, T1, "clang-O2"):
        if not all((name, p) in times for p in PADS):
            continue
        print(f"### Placement: {name}, ns per element behind 0, 16, 32 and 48 bytes\n")
        rows = []
        for k in KERNELS:
            values = [at(name, p, k) for p in PADS]
            if None in values:
                continue
            rows.append([k] + [fmt(v) for v in values] + [fmt(max(values) / min(values), 2)])
        table(["Kernel"] + PADS + ["worst / best"], rows)
    if perf:
        print("### Cycles and instructions per element (perf stat, user; N repetitions less 1)\n")
        columns = [c for c in (T1, VEC, "clang-O2-novec-nounroll", "clang-O2", "buster-tier1-hand", "clang-O2-hand") if c in perf]
        rows = []
        for k in KERNELS:
            row = [k]
            for c in columns:
                value = perf[c].get(k)
                row += ["", ""] if value is None else [f"{value[0]:.3f}", f"{value[1]:.3f}"]
            rows.append(row)
        header = ["Kernel"]
        for c in columns:
            header += [f"{c} cycles", f"{c} instructions"]
        table(header, rows)
    if ("buster-tier1-hand", "pad0") in times:
        print("### The explicit-vector probe (ns per element, placement 0)\n")
        rows = []
        for k in HAND:
            v, th, c2, ch = (at(n, "pad0", k) for n in (VEC, "buster-tier1-hand", "clang-O2", "clang-O2-hand"))
            rows.append([k + (" (v)" if k in vectorized else ""), fmt(v, 4), fmt(th, 4), fmt(c2, 4), fmt(ch, 4), fmt(ratio(v, th), 2), fmt(ratio(th, ch), 2)])
        sub = [k for k in HAND if k in vectorized]
        rows.append([f"geometric mean, the {len(sub)} vectorized", "", "", "", "", fmt(geomean([ratio(at(VEC, "pad0", k), at("buster-tier1-hand", "pad0", k)) for k in sub]), 2),
                     fmt(geomean([ratio(at("buster-tier1-hand", "pad0", k), at("clang-O2-hand", "pad0", k)) for k in sub]), 2)])
        table(["Kernel", "vec, C loop", "tier1, vector source", "clang-O2, C loop", "clang-O2, vector source", "vec C / tier1 vector source", "tier1 vector / clang-O2 vector"], rows)
    if bad:
        print(f"### Lines not used: {len(bad)}\n")
        for line in bad[:20]:
            print(f"    {line}")

main()
