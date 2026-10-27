#!/usr/bin/env python3
# Prints the counters of whole benchmark-backend processes: each *.perf file's perf stat -x, blocks (cycles,
# instructions, branch misses, L1i misses, ic_tag misses; a file of several runs holds a block per run), one line per run,
# and benchmark-backend's own ns per entry from the matching *.out file when it holds one run.
# Usage: counters.py DIRECTORY
import glob, os, sys

EVENTS = ["cycles:u", "instructions:u", "branch-misses:u", "L1-icache-load-misses:u", "ic_tag_hit_miss.instruction_cache_miss:u"]

def runs(path):
    blocks = []
    current = {}
    for line in open(path):
        fields = line.strip().split(",")
        if len(fields) >= 3 and fields[2] in EVENTS:
            if fields[2] in current:
                blocks.append(current)
                current = {}
            current[fields[2]] = float(fields[0]) if fields[0] not in ("<not counted>", "<not supported>") else float("nan")
    if current:
        blocks.append(current)
    return blocks

def ns_per_entry(path):
    if not os.path.exists(path):
        return None
    for line in open(path):
        parts = line.split()
        if parts and parts[0] in ("vector", "scalar") and len(parts) > 1:
            return float(parts[1])
    return None

directory = sys.argv[1]
print("file | run | ns/entry | cycles | instructions | branch misses | L1i misses | ic_tag misses")
for path in sorted(glob.glob(os.path.join(directory, "*.perf"))):
    name = os.path.basename(path)[:-5]
    blocks = runs(path)
    ns = ns_per_entry(os.path.join(directory, name + ".out")) if len(blocks) == 1 else None
    for i, b in enumerate(blocks):
        values = " | ".join(f"{b.get(e, float('nan')) / 1e6:,.2f}M" for e in EVENTS)
        print(f"{name} | {i + 1} | {ns if ns is not None else '-'} | {values}")
