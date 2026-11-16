# medians.py FILE...: time-runs' lines ("run N list L BUILD copy C: W ms wall, ... U user cycles, I instructions") pooled
# over FILEs, the median wall, user cycles and instructions of each build, and each file's medians alone.
import re, sys, statistics
pat = re.compile(r'^run \d+ list \d+ (\S+) copy \d+: ([0-9.]+) ms wall,.* (\d+) user cycles, (\d+) instructions, status 0')
def read(paths):
    d = {}
    for p in paths:
        for line in open(p):
            m = pat.match(line)
            if m:
                d.setdefault(m.group(1), []).append((float(m.group(2)), int(m.group(3)), int(m.group(4))))
    return d
def show(d, title):
    base = d.get('base')
    print(title)
    for b in ('base', 'head', 'base-again'):
        if b not in d: continue
        w = statistics.median(x[0] for x in d[b]); c = statistics.median(x[1] for x in d[b]); i = statistics.median(x[2] for x in d[b])
        if base and b != 'base':
            bw = statistics.median(x[0] for x in base); bc = statistics.median(x[1] for x in base); bi = statistics.median(x[2] for x in base)
            print(f"  {b:10s} n={len(d[b])} wall {w:.3f} ms ({100*(w/bw-1):+.2f}%) cycles {c:,.0f} ({100*(c/bc-1):+.2f}%) instructions {i:,.0f} ({100*(i/bi-1):+.3f}%)")
        else:
            print(f"  {b:10s} n={len(d[b])} wall {w:.3f} ms cycles {c:,.0f} instructions {i:,.0f}")
paths = sys.argv[1:]
show(read(paths), 'pooled')
for p in paths:
    show(read([p]), p)
