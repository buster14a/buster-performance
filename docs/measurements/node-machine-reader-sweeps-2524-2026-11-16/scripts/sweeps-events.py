#!/usr/bin/env python3
# sweeps-events.py RESULTS TAG BASE HEAD: sweeps-events.sh's counts by symbol for the two labels (means of their rounds,
# millions a process): the machine's functions (node_machine_*, with a Release part's .buster_split suffix dropped) side
# by side for each event, and their sums.
import glob, os, re, sys
results, tag, base, head = sys.argv[1:5]
events = ["cycles", "ex_ret_brn_misp", "ic_tag_hit_miss.instruction_cache_miss", "op_cache_hit_miss.op_cache_miss", "ls_bad_status2.stli_other"]
def symbols(label, event):
    paths = sorted(glob.glob(os.path.join(results, label, "se-%s-%s-symbols-*.txt" % (tag, event))))
    sums = {}
    for path in paths:
        for line in open(path):
            value, name = line.split(None, 1)
            name = name.strip().replace(".buster_split", "")
            sums[name] = sums.get(name, 0.0) + float(value)
    return {name: value / max(len(paths), 1) for name, value in sums.items()}, len(paths)
for event in events:
    (a, na), (b, nb) = symbols(base, event), symbols(head, event)
    names = sorted((n for n in set(a) | set(b) if n.startswith("node_machine_")), key=lambda n: -max(a.get(n, 0.0), b.get(n, 0.0)))
    print("== %s, millions a process (%s: %d rounds, %s: %d)" % (event, base, na, head, nb))
    for name in names[:14]:
        x, y = a.get(name, 0.0), b.get(name, 0.0)
        print("  %-40s %10.3f %10.3f %+9.3f %+6.1f%%" % (name[:40], x, y, y - x, (y / x - 1) * 100 if x else 0.0))
    ta = sum(v for n, v in a.items() if n.startswith("node_machine_")); tb = sum(v for n, v in b.items() if n.startswith("node_machine_"))
    print("  %-40s %10.3f %10.3f %+9.3f %+6.1f%%; the process %.3f %.3f" % ("node_machine_* together", ta, tb, tb - ta, (tb / ta - 1) * 100 if ta else 0.0, sum(a.values()), sum(b.values())))
