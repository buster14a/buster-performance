#!/usr/bin/env python3
# facts-events.py RESULTS TAG BASE HEAD: the rounds' medians of facts-events.sh's counts (millions) for the two labels,
# side by side, and the symbols whose cycles differ most.
import glob, os, re, statistics, sys
results, tag, base, head = sys.argv[1:5]

def stats(label):
    counts = {}
    for path in sorted(glob.glob(os.path.join(results, label, "fe-%s-stat-*-*.txt" % tag))):
        group = re.search(r"stat-([abc])-", path).group(1)
        for line in open(path):
            cells = line.strip().split(",")
            if len(cells) > 3 and cells[0].replace(".", "").isdigit():
                name = cells[2]
                if name.startswith("cycles") and group != "a":
                    name = "cycles (group %s)" % group
                counts.setdefault(name, []).append(float(cells[0]) / 1e6)
    return counts

def symbols(label):
    sums = {}
    paths = sorted(glob.glob(os.path.join(results, label, "fe-%s-symbols-*.txt" % tag)))
    for path in paths:
        for line in open(path):
            value, name = line.split(None, 1)
            sums.setdefault(name.strip(), []).append(float(value))
    return {name: sum(values) / len(paths) for name, values in sums.items()}, len(paths)

a, b = stats(base), stats(head)
print("counts, millions a process (medians of the rounds): %s, %s" % (base, head))
for name in a:
    x, y = statistics.median(a[name]), statistics.median(b.get(name, [0.0]))
    print("  %-52s %12.3f %12.3f  %+10.3f  %+6.2f%%  (runs %d, %d; %s spread %.3f, %s spread %.3f)" % (name, x, y, y - x, (y / x - 1) * 100 if x else 0.0, len(a[name]), len(b.get(name, [])), base, max(a[name]) - min(a[name]), head, max(b.get(name, [0.0])) - min(b.get(name, [0.0]))))
(sa, na), (sb, nb) = symbols(base), symbols(head)
print("cycles by symbol, millions a process (means of %d and %d rounds): the 30 largest differences" % (na, nb))
names = sorted(set(sa) | set(sb), key=lambda n: -abs(sb.get(n, 0.0) - sa.get(n, 0.0)))
for name in names[:30]:
    print("  %-52s %10.3f %10.3f  %+9.3f" % (name[:52], sa.get(name, 0.0), sb.get(name, 0.0), sb.get(name, 0.0) - sa.get(name, 0.0)))
facts_a = sum(v for n, v in sa.items() if n.startswith("node_facts_")); facts_b = sum(v for n, v in sb.items() if n.startswith("node_facts_"))
print("  node_facts_* together %.3f %.3f %+.3f; everything %.3f %.3f %+.3f" % (facts_a, facts_b, facts_b - facts_a, sum(sa.values()), sum(sb.values()), sum(sb.values()) - sum(sa.values())))
