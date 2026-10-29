import sys, re, statistics
# Summarizes ab's rounds of benchmark-lowering-source: per tree, the median across rounds of referenced_ns.
rows = []
tree = None
for line in open(sys.argv[1]):
    m = re.match(r'== round (\d+) tree \./(\w+)', line)
    if m:
        tree = m.group(2)
        continue
    m = re.match(r'lowering-source: totals .* referenced_ns=(\d+) all_ns=(\d+)', line)
    if m:
        rows.append((tree, int(m.group(1)), int(m.group(2))))
base = None
for t in ['main', 'head', 'pr2', 'pr3']:
    r = [x for x in rows if x[0] == t]
    if not r:
        continue
    ref = statistics.median([x[1] for x in r]) / 1e6
    line = f'{t:5} n={len(r)} referenced {ref:.3f} ms (rounds {", ".join("%.3f" % (x[1]/1e6) for x in r)})'
    if base is not None:
        line += f' | {100*(ref/base-1):+.2f}%'
    else:
        base = ref
    print(line)
