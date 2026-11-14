#!/usr/bin/env python3
"""tables.py [--march M] FILE...: Markdown tables from the harness's result lines.

Three line formats are read:
  NAME KERNEL ELEMENTS REPS SECONDS NS DIGEST                                  (run-all.sh; --march names its target)
  NAME padP KERNEL ELEMENTS REPS SECONDS NS DIGEST | LOOP                      (pad.sh; --march names its target)
  MARCH NAME padP KERNEL ELEMENTS REPS SECONDS NS DIGEST | LOOP | status S     (9700x/run-one.sh)
  perf MARCH NAME KERNEL 1 C1 I1 REPS CN IN status S1 SN                       (9700x/run-one.sh, pad 0)
LOOP is loops.py's line: k_NAME START END BYTES INSTRUCTIONS crosses|inside OFFSET.
"""
import math
import sys

VECTOR = ["sum_i32", "sum_u8", "dot_i16", "max_i32", "count_eq_u8", "cond_sum_i32", "popcount_u64", "aos_sum", "add_i32", "saxpy_f32", "scale_u8", "blend_u8", "clamp_i32", "i32_to_f32", "fill_u32", "copy_u8", "stencil3_u8", "rgb_to_gray", "matmul_f32"]
CONTROL = ["dot_f32", "prefix_sum_i32", "histogram_u8", "find_u8", "crc32_table", "fnv1a"]
HAND = ["sum_i32", "sum_u8", "dot_i16", "max_i32", "count_eq_u8", "cond_sum_i32", "add_i32", "saxpy_f32", "scale_u8", "clamp_i32", "i32_to_f32", "fill_u32"]
KERNELS = VECTOR + CONTROL
PADS = ["pad0", "pad16", "pad32", "pad48"]

def geomean(values):
    values = [v for v in values if v is not None and v > 0]
    return math.exp(sum(math.log(v) for v in values) / len(values)) if values else None

def fmt(value, digits=3):
    return "" if value is None else f"{value:.{digits}f}"

def parse(paths, default_march):
    times = {}   # (march, name, pad) -> kernel -> ns
    loops = {}   # (march, name, pad) -> kernel -> (bytes, instructions, crosses)
    digests = {} # (march, kernel) -> digest -> [names]
    perf = {}    # (march, name) -> kernel -> (cycles per element, instructions per element)
    elements = {}
    bad = []
    for path in paths:
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
                    per = (reps - 1) * elements[kernel]
                    perf.setdefault((march, name), {})[kernel] = ((cn - c1) / per, (i_n - i1) / per)
                except (ValueError, IndexError, KeyError):
                    bad.append(line)
                continue
            if len(f) == 7:
                march, name, pad, rest = default_march, f[0], "linked", f[1:]
            elif len(f) == 8:
                march, name, pad, rest = default_march, f[0], f[1], f[2:]
            elif len(f) == 9:
                march, name, pad, rest = f[0], f[1], f[2], f[3:]
            else:
                bad.append(line)
                continue
            if len(parts) > 2 and parts[2] != "status 0":
                bad.append(line)
                continue
            try:
                kernel, count, ns, digest = rest[0], int(rest[1]), float(rest[4]), rest[5]
            except (ValueError, IndexError):
                bad.append(line)
                continue
            elements[kernel] = count
            times.setdefault((march, name, pad), {})[kernel] = ns
            digests.setdefault((march, kernel), {}).setdefault(digest, set()).add(name)
            if len(parts) > 1 and parts[1]:
                l = parts[1].split()
                if len(l) >= 6:
                    loops.setdefault((march, name, pad), {})[kernel] = (int(l[3]), int(l[4]), l[5] == "crosses")
    return times, loops, digests, perf, bad

def best(times, march, name, kernel):
    values = [times[(march, name, pad)][kernel] for pad in PADS + ["linked"] if (march, name, pad) in times and kernel in times[(march, name, pad)]]
    return min(values) if values else None

def at(times, march, name, pad, kernel):
    return times.get((march, name, pad), {}).get(kernel)

def ratio(a, b):
    return None if a is None or b is None or b == 0 else a / b

def table(header, rows):
    print("| " + " | ".join(header) + " |")
    print("| --- |" + " ---: |" * (len(header) - 1))
    for row in rows:
        print("| " + " | ".join(row) + " |")
    print()

def main():
    arguments = sys.argv[1:]
    default_march = "?"
    if arguments and arguments[0] == "--march":
        default_march = arguments[1]
        arguments = arguments[2:]
    times, loops, digests, perf, bad = parse(arguments, default_march)
    marches = sorted({key[0] for key in times})
    for march in marches:
        names = sorted({key[1] for key in times if key[0] == march})
        first = "pad0" if (march, "clang-O2", "pad0") in times else "linked"
        print(f"## -march={march}\n")
        mismatched = [k for k in KERNELS if len(digests.get((march, k), {})) != 1]
        print(f"Builds: {len(names)} ({', '.join(names)}). Kernels whose digest differs between builds: {len(mismatched)} {mismatched if mismatched else ''}\n")

        print(f"### ns per element, as linked ({first})\n")
        columns = ["buster-tier0", "buster-tier1", "clang-O1", "clang-O2-novec-nounroll", "clang-O2-novec", "clang-O2", "clang-O3", "gcc-O2", "gcc-O3"]
        columns = [c for c in columns if (march, c, first) in times]
        rows = []
        for k in KERNELS:
            t1, c2 = at(times, march, "buster-tier1", first, k), at(times, march, "clang-O2", first, k)
            rows.append([k] + [fmt(at(times, march, c, first, k)) for c in columns] + [fmt(ratio(t1, c2), 2)])
        table(["Kernel"] + columns + ["tier1 / clang-O2"], rows)

        print("### Geometric means of ratios\n")
        pairs = [("buster-tier1", "clang-O2"), ("buster-tier1", "clang-O3"), ("buster-tier1", "gcc-O2"), ("buster-tier1", "clang-O2-novec-nounroll"), ("clang-O2-novec-nounroll", "clang-O2-novec"), ("clang-O2-novec", "clang-O2"), ("buster-tier0", "buster-tier1"), ("buster-tier1-licm", "buster-tier1"), ("buster-tier1-all", "buster-tier1")]
        rows = []
        for a, b in pairs:
            if (march, a, first) not in times or (march, b, first) not in times:
                continue
            row = [f"{a} / {b}"]
            for group in (VECTOR, CONTROL):
                row.append(fmt(geomean([ratio(at(times, march, a, first, k), at(times, march, b, first, k)) for k in group]), 2))
                row.append(fmt(geomean([ratio(best(times, march, a, k), best(times, march, b, k)) for k in group]), 2))
            rows.append(row)
        table(["Ratio", "19 vectorized, as linked", "19 vectorized, best placement of each", "6 controls, as linked", "6 controls, best placement of each"], rows)

        for name in ("buster-tier1", "clang-O2-novec-nounroll", "clang-O2-novec", "clang-O2", "clang-O1", "gcc-O2", "buster-tier0", "buster-tier1-hand", "clang-O2-hand"):
            if not all((march, name, pad) in times for pad in PADS):
                continue
            print(f"### Placement: {name}, ns per element behind 0, 16, 32 and 48 bytes (x = the innermost loop lies across a 64-byte line)\n")
            rows = []
            for k in KERNELS:
                values = [at(times, march, name, pad, k) for pad in PADS]
                if any(v is None for v in values):
                    continue
                cells = []
                for pad, v in zip(PADS, values):
                    loop = loops.get((march, name, pad), {}).get(k)
                    cells.append(fmt(v) + (" x" if loop and loop[2] else ""))
                loop = loops.get((march, name, "pad0"), {}).get(k)
                rows.append([k, f"{loop[0]}" if loop else "", f"{loop[1]}" if loop else ""] + cells + [fmt(max(values) / min(values), 2)])
            table(["Kernel", "Loop bytes", "Loop instructions"] + PADS + ["worst / best"], rows)

        if (march, "buster-tier1") in perf:
            print("### Cycles and instructions per element (perf stat, user; N repetitions less 1 repetition)\n")
            columns = [c for c in ("buster-tier1", "clang-O2-novec-nounroll", "clang-O2-novec", "clang-O2", "buster-tier1-hand", "clang-O2-hand") if (march, c) in perf]
            rows = []
            for k in KERNELS:
                row = [k]
                for c in columns:
                    value = perf[(march, c)].get(k)
                    row.append("" if value is None else f"{value[0]:.3f}")
                    row.append("" if value is None else f"{value[1]:.3f}")
                rows.append(row)
            header = ["Kernel"]
            for c in columns:
                header += [f"{c} cycles", f"{c} instructions"]
            table(header, rows)

        if (march, "buster-tier1-hand", first) in times:
            print("### The kernels written with vector operations (ns per element, best placement of each)\n")
            rows = []
            for k in HAND:
                t1, th, c2, ch = (best(times, march, n, k) for n in ("buster-tier1", "buster-tier1-hand", "clang-O2", "clang-O2-hand"))
                rows.append([k, fmt(t1, 4), fmt(th, 4), fmt(c2, 4), fmt(ch, 4), fmt(ratio(t1, th), 1), fmt(ratio(th, c2), 2), fmt(ratio(th, ch), 2)])
            rows.append(["geometric mean", "", "", "", ""] + [fmt(geomean([ratio(best(times, march, a, k), best(times, march, b, k)) for k in HAND]), 2) for a, b in (("buster-tier1", "buster-tier1-hand"), ("buster-tier1-hand", "clang-O2"), ("buster-tier1-hand", "clang-O2-hand"))])
            table(["Kernel", "tier1, C loop", "tier1, vector source", "clang-O2, C loop", "clang-O2, vector source", "tier1 C / tier1 vector", "tier1 vector / clang-O2 C", "tier1 vector / clang-O2 vector"], rows)
    if bad:
        print(f"## Lines not used: {len(bad)}\n")
        for line in bad[:40]:
            print(f"    {line}")

main()
