import sys, re
# regions.py ANNOTATE [start:end:name ...]: sums of perf annotate's percentages by address range
rngs = []
for a in sys.argv[2:]:
    s, e, n = a.split(':'); rngs.append((int(s, 16), int(e, 16), n))
tot = {}
for line in open(sys.argv[1]):
    m = re.match(r'\s+([0-9.]+)\s+:\s+([0-9a-f]+):', line)
    if not m: continue
    pct = float(m.group(1)); addr = int(m.group(2), 16)
    name = 'other'
    for s, e, n in rngs:
        if s <= addr < e: name = n; break
    tot[name] = tot.get(name, 0) + pct
print(' '.join(f'{k} {v:.1f}' for k, v in sorted(tot.items())))
