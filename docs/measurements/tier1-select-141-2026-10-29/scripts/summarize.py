#!/usr/bin/env python3
# Medians of #141's 9700X benchmark-tier1-select logs, in ns per IR node. The main run (bench/): each shape, phase and
# path's median over the five rounds by main and the head, with the rounds' range. The placements (shifts/): each
# build's median over its placements' medians (each over the rounds), the placements' spread, and the head's and main
# again's change against main, with its range over the placements as docs/profiling.md's method takes it: each of the
# build's placements' medians against each of main's, which pairs nothing, since a shift of one tree isn't the same
# placement as that shift of another; and whether the change is outside the floor (beyond main again's change, and its
# range excluding 0). The rows' structure (records, bytes, costs, spills, peaks) must be the same for every run of a
# row. Usage: summarize.py M_DIRECTORY MAIN HEAD.
import collections, glob, os, re, statistics, sys

m, main, head = sys.argv[1:4]

def rows(path):
    out = {}
    for line in open(path):
        f = line.strip().split(",")
        if len(f) == 15 and f[0] in ("chain", "wide", "pressure"):
            out[(f[0], f[1], f[2])] = (float(f[13]), tuple(f[3:13]))
    return out

structure = collections.defaultdict(set)
for kind in ("full", "after"):
    print("== %s rounds (bench/%s-*): ns per IR node, median (min to max)" % (kind, kind))
    values = collections.defaultdict(lambda: collections.defaultdict(list))
    for tree in (main, head):
        for path in sorted(glob.glob(os.path.join(m, "bench", "%s-%s-*.log" % (kind, tree)))):
            for key, (ns, shape) in rows(path).items():
                values[key][tree].append(ns)
                structure[key].add(shape)
    for key in sorted(values):
        a, b = values[key][main], values[key][head]
        print("%-9s %-10s %-7s main %8.3f (%.3f to %.3f), head %8.3f (%.3f to %.3f): %+.2f%%" % (
            key + (statistics.median(a), min(a), max(a), statistics.median(b), min(b), max(b),
                   (statistics.median(b) - statistics.median(a)) / statistics.median(a) * 100)))

placements = collections.defaultdict(lambda: collections.defaultdict(lambda: collections.defaultdict(list)))
for path in glob.glob(os.path.join(m, "shifts", "*-*-*.log")):
    g = re.match(r"(main|head|again)-(\d+)-(\d)\.log$", os.path.basename(path))
    if g:
        for key, (ns, shape) in rows(path).items():
            placements[key][g.group(1)][int(g.group(2))].append(ns)
            structure[key].add(shape)
if placements:
    print("== placements (shifts/): ns per IR node; each placement the median of its rounds")
    for key in sorted(placements):
        builds = placements[key]
        per = {b: {s: statistics.median(v) for s, v in builds[b].items()} for b in builds}
        reference = per["main"]
        line = "%-9s %-10s %-7s" % key
        for b in ("main", "head", "again"):
            if b not in per:
                continue
            p = per[b]
            median = statistics.median(p.values())
            spread = (max(p.values()) / min(p.values()) - 1) * 100
            line += "  %s %.3f (spread %.2f%%)" % (b, median, spread)
            if b != "main":
                changes = [(p[s] - reference[t]) / reference[t] * 100 for s in p for t in reference]
                change = (median - statistics.median(reference.values())) / statistics.median(reference.values()) * 100
                line += " %+.2f%% (%+.2f to %+.2f)" % (change, min(changes), max(changes))
                if b == "head":
                    head_change, head_range = change, (min(changes), max(changes))
                else:
                    floor = abs(change)
        outside = abs(head_change) > floor and (head_range[0] > 0 or head_range[1] < 0)
        print(line + ("  outside the floor" if outside else "  within the floor"))
different = [key for key, shapes in structure.items() if len(shapes) != 1]
print("== structure: %s" % ("the same for every run of each row" if not different else "differs: %s" % different))
