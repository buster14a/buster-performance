import sys, re, statistics
# Summarizes ab's rounds of time-runs for any trees: per tree and list, the medians across rounds of each round's
# median wall, user cycles and instructions, each against main's.
rows = []
tree = None
for line in open(sys.argv[1]):
    m = re.match(r'== round (\d+) tree \./(\w+)', line)
    if m:
        tree = m.group(2)
        continue
    m = re.match(r'list (\d) \[(-c|-fsyntax-only).*median ([\d.]+) ms wall.* ([\d]+) user cycles, ([\d]+) instructions', line)
    if m:
        rows.append((tree, m.group(2), float(m.group(3)), int(m.group(4)), int(m.group(5))))
trees = []
for r in rows:
    if r[0] not in trees:
        trees.append(r[0])
for cmd in ('-c', '-fsyntax-only'):
    base = None
    for t in ['main'] + [x for x in trees if x != 'main']:
        r = [x for x in rows if x[0] == t and x[1] == cmd]
        if not r:
            continue
        wall = statistics.median([x[2] for x in r])
        cycles = statistics.median([x[3] for x in r])
        instr = statistics.median([x[4] for x in r])
        line = f'{cmd:14} {t:5} n={len(r)} wall {wall:8.3f} ms (rounds {", ".join("%.3f" % x[2] for x in r)}) cycles {cycles/1e6:8.2f}M instructions {instr:,.0f}'
        if base is not None:
            line += f' | wall {100*(wall/base[0]-1):+.2f}% cycles {100*(cycles/base[1]-1):+.2f}% instructions {100*(instr/base[2]-1):+.3f}% ({instr-base[2]:+,.0f})'
        else:
            base = (wall, cycles, instr)
        print(line)
