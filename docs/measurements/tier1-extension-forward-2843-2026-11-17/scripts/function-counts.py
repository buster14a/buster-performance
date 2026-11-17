import sys, re, collections
def counts(path):
    c = collections.OrderedDict(); cur = None
    for line in open(path):
        m = re.match(r'^[0-9a-f]+ <(.+)>:$', line)
        if m: cur = m.group(1); c[cur] = 0; continue
        if cur and re.match(r'^\s+[0-9a-f]+:\t', line) and 'int3' not in line and not re.search(r'\tnop', line): c[cur] += 1
    return c
a = counts(sys.argv[1]); b = counts(sys.argv[2])
grew = [(f, a[f], b.get(f, 0)) for f in a if b.get(f, 0) > a[f]]
shrank = [(f, a[f], b.get(f, 0)) for f in a if b.get(f, 0) < a[f]]
print("functions", len(a), len(b), "grew", len(grew), "shrank", len(shrank), "total", sum(a.values()), sum(b.values()))
for f, x, y in sorted(grew, key=lambda t: t[1]-t[2])[:20]: print("  grew", f, x, y, y - x)
for f, x, y in sorted(shrank, key=lambda t: t[2]-t[1])[:10]: print("  shrank", f, x, y, y - x)
