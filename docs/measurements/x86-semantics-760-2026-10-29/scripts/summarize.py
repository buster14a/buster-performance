#!/usr/bin/env python3
# Medians over the rounds of #760's 9700X logs: benchmark-x86-semantics' tables, choice and effects lines,
# benchmark-x86-target's table, and perf stat's -c runs. Usage: summarize.py M_DIRECTORY MAIN HEAD.
import glob, os, re, statistics, sys
m, main, head = sys.argv[1:4]
def median(values):
    return statistics.median(values) if values else float("nan")
def sem_values(path):
    out = {}
    shape = None
    for line in open(path):
        g = re.match(r"tables: x86_semantics_initialize ([\d.]+) us, (\d+) cycles", line)
        if g:
            out["init_us"] = float(g.group(1)); out["init_cycles"] = float(g.group(2))
        g = re.match(r"tables: (\d+) covered forms", line)
        if g:
            out["covered"] = int(g.group(1))
        g = re.match(r"effects, -(O\d)'s shape", line)
        if g:
            shape = g.group(1)
        g = re.match(r"\s+(choose-scalar|choose-avx512|effects-scalar|effects-avx512|effects-opmasks|encode)\s+([\d.]+) ns\s+([\d.]+) cycles\s+([\d.]+) instructions", line)
        if g:
            name = g.group(1) + ("" if g.group(1).startswith("choose") else "-" + (shape or "?"))
            out[name + " ns"] = float(g.group(2)); out[name + " cycles"] = float(g.group(3)); out[name + " instructions"] = float(g.group(4))
    return out
def collect(pattern):
    rounds = []
    for path in sorted(glob.glob(os.path.join(m, pattern))):
        rounds.append(sem_values(path))
    keys = sorted({k for r in rounds for k in r})
    return {k: median([r[k] for r in rounds if k in r]) for k in keys}, len(rounds)
for kind in ("full", "effects-avx512", "effects-avx512-after", "choose-avx512", "choose-avx512-after"):
    for tree in (main, head):
        values, n = collect("sem/%s-%s-*.log" % (kind, tree))
        print("sem %-22s %-14s (%d rounds): %s" % (kind, tree, n, ", ".join("%s %.3f" % (k, v) for k, v in values.items())))
for kind in ("effects-opmasks", "effects-opmasks-after"):
    values, n = collect("sem/%s-%s-*.log" % (kind, head))
    print("sem %-22s %-14s (%d rounds): %s" % (kind, head, n, ", ".join("%s %.3f" % (k, v) for k, v in values.items())))
for kind in ("avx512", "after"):
    for tree in (main, head):
        ns, cycles = [], []
        for path in glob.glob(os.path.join(m, "target/%s-%s-*.log" % (kind, tree))):
            for line in open(path):
                g = re.search(r"AVX-512: ([\d.]+) ns/table, ([\d.]+) cycles/table", line)
                if g:
                    ns.append(float(g.group(1))); cycles.append(float(g.group(2)))
        print("target %-7s %-14s (%d): %.1f ns/table, %.0f cycles/table" % (kind, tree, len(ns), median(ns), median(cycles)))
for prefix in ("", "tiny-"):
    for tree in (main, head):
        values = {}
        for path in glob.glob(os.path.join(m, "compile/%s%s-*.csv" % (prefix, tree))):
            for line in open(path):
                fields = line.strip().split(",")
                if len(fields) > 3 and fields[2] in ("task-clock", "cycles:u", "instructions:u"):
                    values.setdefault(fields[2], []).append(float(fields[0]))
        print("compile %-5s %-14s: %s" % (prefix or "sqlite", tree, ", ".join("%s %.6g (median of %d)" % (k, median(v), len(v)) for k, v in sorted(values.items()))))
