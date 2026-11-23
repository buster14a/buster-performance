#!/usr/bin/env python3
# summarize.py RESULTS: the kernels' runs (sm3309-kernels.sh's results.txt) as tables. For each kernel and build, the
# median, least and most user cycles of its rounds, the cycles an iteration at the median, and the instructions; then,
# for the builds linked at four paddings, the least and the most of the four medians.
import statistics
import sys

ITERATIONS = 200_000_000
runs = {}
layouts = {}
order = []
for line in open(sys.argv[1]):
    fields = line.split()
    if len(fields) == 7 and fields[0] == "run":
        key = (fields[1], fields[2])
        if key not in runs:
            runs[key] = []
            order.append(key)
        runs[key].append((float(fields[4]), int(fields[5]), int(fields[6])))
    elif len(fields) >= 4 and fields[0] == "layout":
        layouts[(fields[1], fields[2])] = fields[3].split("=")[1][-4:]

print("| Kernel | Build | f at | Rounds | Median cycles | Least | Most | Cycles an iteration | Instructions |")
print("| --- | --- | --- | ---: | ---: | ---: | ---: | ---: | ---: |")
medians = {}
for key in order:
    cycles = sorted(r[1] for r in runs[key])
    instructions = statistics.median(r[2] for r in runs[key])
    median = statistics.median(cycles)
    medians[key] = median
    print(f"| {key[0]} | {key[1]} | 0x{layouts.get(key, '????')} | {len(cycles)} | {median:,.0f} | {cycles[0]:,} | {cycles[-1]:,} | {median / ITERATIONS:.3f} | {instructions:,.0f} |")

print()
print("| Kernel | Build | Least median of the four paddings | Most | Most over least |")
print("| --- | --- | ---: | ---: | ---: |")
kernels = []
for key in order:
    if key[0] not in kernels:
        kernels.append(key[0])
for kernel in kernels:
    for build in ("t0", "t1", "sm", "all"):
        four = [medians[(kernel, f"{build}-p{n}")] for n in (0, 16, 32, 48) if (kernel, f"{build}-p{n}") in medians]
        if len(four) == 4:
            print(f"| {kernel} | {build} | {min(four):,.0f} | {max(four):,.0f} | {max(four) / min(four):.3f} |")
