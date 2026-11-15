#!/usr/bin/env python3
# layout-tables.py RUNS: layout.sh's runs as tables: per program and placement (speedtest1's pads, Lua's link orders),
# each build's median user cycles and instructions over the measured rounds (round 0 is the warm-up), the ratio
# +unroll / default, and the mean and range of the ratios over the placements.
import statistics
import sys

rows = {}
for line in open(sys.argv[1]):
    f = line.split()
    if len(f) < 12 or f[0] != "round" or f[1] == "0":
        continue
    # round N PROGRAM pad|order P BUILD cycles C instructions I status S
    program, place, build = f[2], f[4], f[5]
    if f[11] != "0" or not f[7].isdigit() or not f[9].isdigit():
        print(f"skipped: {line.strip()}")
        continue
    rows.setdefault((program, place, build), []).append((int(f[7]), int(f[9])))

programs = []
for program, _, _ in rows:
    if program not in programs:
        programs.append(program)
for program in programs:
    places = sorted({p for (q, p, _) in rows if q == program}, key=int)
    kind = "pad, bytes" if program == "speedtest1" else "link order"
    print(f"## {program}\n")
    print(f"| {kind} | rounds | default cycles, M | +unroll cycles, M | +unroll / default | default instructions, M | +unroll instructions, M | +unroll / default |")
    print("| ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |")
    cycle_ratios = []
    for place in places:
        a = rows.get((program, place, "default"), [])
        b = rows.get((program, place, "unroll"), [])
        if not a or not b:
            continue
        ac = statistics.median(c for c, _ in a)
        bc = statistics.median(c for c, _ in b)
        ai = statistics.median(i for _, i in a)
        bi = statistics.median(i for _, i in b)
        cycle_ratios.append(bc / ac)
        print(f"| {place} | {min(len(a), len(b))} | {ac / 1e6:.2f} | {bc / 1e6:.2f} | {bc / ac:.4f} | {ai / 1e6:.2f} | {bi / 1e6:.2f} | {bi / ai:.4f} |")
    if cycle_ratios:
        print(f"\nCycles, +unroll / default: mean over the placements {statistics.mean(cycle_ratios):.4f} (from {min(cycle_ratios):.4f} to {max(cycle_ratios):.4f})\n")
