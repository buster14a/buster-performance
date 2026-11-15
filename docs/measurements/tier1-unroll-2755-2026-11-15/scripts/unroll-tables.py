#!/usr/bin/env python3
"""unroll-tables.py RESULTS...: Markdown tables of buster#2755's kernel runs (run-one.sh's lines).

  MARCH NAME padP KERNEL ELEMENTS REPS SECONDS NS DIGEST | LOOP | status S
  perf MARCH NAME KERNEL 1 C1 I1 REPS CN IN status S1 SN padP
Builds: tier1-base, tier1-unroll, clang-O2-novec-nounroll, clang-O2-novec, clang-O2.
"""
import math
import sys

VECTOR = ["sum_i32", "sum_u8", "dot_i16", "max_i32", "count_eq_u8", "cond_sum_i32", "popcount_u64", "aos_sum", "add_i32", "saxpy_f32", "scale_u8", "blend_u8", "clamp_i32", "i32_to_f32", "fill_u32", "copy_u8", "stencil3_u8", "rgb_to_gray", "matmul_f32"]
CONTROL = ["dot_f32", "prefix_sum_i32", "histogram_u8", "find_u8", "crc32_table", "fnv1a"]
KERNELS = VECTOR + CONTROL
BUILDS = ["tier1-base", "tier1-unroll", "clang-O2-novec-nounroll", "clang-O2-novec", "clang-O2"]
PADS = ["pad0", "pad16", "pad32", "pad48"]

def geomean(values):
    values = [v for v in values if v is not None and v > 0]
    return math.exp(sum(math.log(v) for v in values) / len(values)) if values else None

def fmt(value, digits=3):
    return "" if value is None else f"{value:.{digits}f}"

times = {}
perf = {}
digests = {}
elements = {}
bad = []
lines = 0
for path in sys.argv[1:]:
    for raw in open(path):
        line = raw.strip()
        if not line:
            continue
        parts = [p.strip() for p in line.split("|")]
        f = parts[0].split()
        if f[0] == "perf":
            try:
                march, name, kernel = f[1], f[2], f[3]
                c1, i1, reps, cn, i_n = int(f[5]), int(f[6]), int(f[7]), int(f[8]), int(f[9])
                if f[11] != "0" or f[12] != "0" or reps < 2:
                    bad.append(line)
                    continue
                pad = f[13] if len(f) > 13 else "pad0"
                per = (reps - 1) * elements[(march, kernel)]
                perf.setdefault((march, name, pad), {})[kernel] = ((cn - c1) / per, (i_n - i1) / per)
            except (ValueError, IndexError, KeyError):
                bad.append(line)
            continue
        if len(f) != 9 or not parts[-1].startswith("status") or parts[-1].split()[-1] != "0":
            bad.append(line)
            continue
        march, name, pad, kernel, count, reps, seconds, ns, digest = f
        lines += 1
        elements[(march, kernel)] = int(count)
        times.setdefault((march, name, pad), {})[kernel] = float(ns)
        digests.setdefault((march, kernel), {}).setdefault(digest, []).append(name)

marches = sorted({key[0] for key in times})
print(f"Timing lines: {lines}. Unparsed or failed lines: {len(bad)}.")
for line in bad:
    print(f"    {line}")
for march in marches:
    mismatched = [k for k in KERNELS if len(digests.get((march, k), {})) > 1]
    print(f"\n## -march={march}\n")
    print(f"Kernels whose digest differs between builds: {len(mismatched)} {' '.join(mismatched)}")
    pads = [p for p in PADS if (march, "tier1-base", p) in times]
    for pad in pads:
        print(f"\n### ns per element, {pad}\n")
        header = [b for b in BUILDS if (march, b, pad) in times]
        print("| Kernel | " + " | ".join(header) + " | base / unroll | unroll / clang-O2-novec |")
        print("| --- |" + " ---: |" * (len(header) + 2))
        for k in KERNELS:
            row = [times[(march, b, pad)].get(k) for b in header]
            base = times[(march, "tier1-base", pad)].get(k)
            unroll = times.get((march, "tier1-unroll", pad), {}).get(k)
            novec = times.get((march, "clang-O2-novec", pad), {}).get(k)
            print(f"| {k} | " + " | ".join(fmt(v) for v in row) + f" | {fmt(base / unroll if base and unroll else None, 2)} | {fmt(unroll / novec if unroll and novec else None, 2)} |")
    print(f"\n### Geometric means of time ratios (larger is slower)\n")
    def ratio(a, b, kernels, pad):
        ta = times.get((march, a, pad), {})
        tb = times.get((march, b, pad), {})
        return geomean([ta[k] / tb[k] for k in kernels if k in ta and k in tb])
    def best(name, k):
        values = [times[(march, name, p)][k] for p in pads if (march, name, p) in times and k in times[(march, name, p)]]
        return min(values) if values else None
    def ratio_best(a, b, kernels):
        return geomean([best(a, k) / best(b, k) for k in kernels if best(a, k) and best(b, k)])
    pairs = [("tier1-base", "tier1-unroll"), ("tier1-unroll", "clang-O2-novec"), ("tier1-base", "clang-O2-novec-nounroll"), ("clang-O2-novec-nounroll", "clang-O2-novec"), ("tier1-unroll", "clang-O2")]
    print("| Ratio | 19 vectorized, pad0 | 19 vectorized, best placement of each | 6 controls, pad0 | 6 controls, best placement of each |")
    print("| --- | ---: | ---: | ---: | ---: |")
    for a, b in pairs:
        print(f"| {a} / {b} | {fmt(ratio(a, b, VECTOR, 'pad0'), 2)} | {fmt(ratio_best(a, b, VECTOR), 2)} | {fmt(ratio(a, b, CONTROL, 'pad0'), 2)} | {fmt(ratio_best(a, b, CONTROL), 2)} |")
    if len(pads) > 1:
        print("\n### tier1-base / tier1-unroll at each placement (geometric means)\n")
        print("| Placement | 19 vectorized | 6 controls |")
        print("| --- | ---: | ---: |")
        for pad in pads:
            print(f"| {pad} | {fmt(ratio('tier1-base', 'tier1-unroll', VECTOR, pad), 2)} | {fmt(ratio('tier1-base', 'tier1-unroll', CONTROL, pad), 2)} |")
    for pad in pads:
        print(f"\n### Cycles and instructions per element, {pad} (perf stat, user)\n")
        header = [b for b in BUILDS if (march, b, pad) in perf]
        print("| Kernel | " + " | ".join(f"{b} cycles | {b} instructions" for b in header) + " |")
        print("| --- |" + " ---: |" * (2 * len(header)))
        for k in KERNELS:
            cells = []
            for b in header:
                value = perf[(march, b, pad)].get(k)
                cells.append(f"{fmt(value[0])} | {fmt(value[1])}" if value else " | ")
            print(f"| {k} | " + " | ".join(cells) + " |")
    print("\n### Cycles per element: geometric means of ratios over placements\n")
    def cycles(name, pad, k):
        value = perf.get((march, name, pad), {}).get(k)
        return value[0] if value else None
    print("| Ratio | " + " | ".join(f"19 vectorized, {p}" for p in pads) + " | " + " | ".join(f"6 controls, {p}" for p in pads) + " |")
    print("| --- |" + " ---: |" * (2 * len(pads)))
    for a, b in pairs:
        cells = []
        for group in (VECTOR, CONTROL):
            for pad in pads:
                cells.append(fmt(geomean([cycles(a, pad, k) / cycles(b, pad, k) for k in group if cycles(a, pad, k) and cycles(b, pad, k)]), 2))
        print(f"| {a} / {b} cycles | " + " | ".join(cells) + " |")
