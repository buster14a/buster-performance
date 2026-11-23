#!/usr/bin/env python3
# compact.py RESULTS: the kernels' runs as one row a kernel and build: for a build linked at the four paddings, the
# least and the most of the four placements' median user cycles (a placement's median is over its rounds), as cycles
# an iteration; a clang build has one placement. Then the pass's ratios: without it over with it, at the placements'
# least and most, and at each placement.
import statistics
import sys

ITERATIONS = 200_000_000
NAMES = {"t0": "Tier 0", "t1": "`--tier1` without the pass", "sm": "`--tier1` (the pass on)", "all": "`--tier1 --tier1-passes=+all`", "c0": "clang -O0", "c2": "clang -O2",
         "c2n": "clang -O2, no unrolling or vectors"}
cycles = {}
instructions = {}
for line in open(sys.argv[1]):
    fields = line.split()
    if len(fields) == 7 and fields[0] == "run":
        cycles.setdefault((fields[1], fields[2]), []).append(int(fields[5]))
        instructions.setdefault((fields[1], fields[2]), []).append(int(fields[6]))
median = {key: statistics.median(values) for key, values in cycles.items()}
kernels = sorted({key[0] for key in cycles})
print("| Kernel | Build | Cycles an iteration, least to most of the placements | Median cycles, least | Most | Instructions an iteration |")
print("| --- | --- | ---: | ---: | ---: | ---: |")
for kernel in kernels:
    for build in ("t0", "t1", "sm", "all", "c0", "c2", "c2n"):
        keys = [(kernel, f"{build}-p{n}") for n in (0, 16, 32, 48)] if build in ("t0", "t1", "sm", "all") else [(kernel, build)]
        values = [median[key] for key in keys]
        per = statistics.median(instructions[keys[0]]) / ITERATIONS
        low, high = min(values), max(values)
        span = f"{low / ITERATIONS:.3f}" if len(values) == 1 or f"{low / ITERATIONS:.3f}" == f"{high / ITERATIONS:.3f}" else f"{low / ITERATIONS:.3f} to {high / ITERATIONS:.3f}"
        print(f"| {kernel} | {NAMES[build]} | {span} | {low:,.0f} | {high:,.0f} | {per:.2f} |")
print()
print("| Kernel | Without the pass over with it: least placements | Most placements | At +0 | +16 | +32 | +48 | Compiler's own link |")
print("| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: |")
for kernel in kernels:
    t1 = [median[(kernel, f"t1-p{n}")] for n in (0, 16, 32, 48)]
    sm = [median[(kernel, f"sm-p{n}")] for n in (0, 16, 32, 48)]
    each = " | ".join(f"{a / b:.3f}" for a, b in zip(t1, sm))
    print(f"| {kernel} | {min(t1) / min(sm):.3f} | {max(t1) / max(sm):.3f} | {each} | {median[(kernel, 't1-bl')] / median[(kernel, 'sm-bl')]:.3f} |")
