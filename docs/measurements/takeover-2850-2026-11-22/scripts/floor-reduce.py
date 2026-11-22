import glob, os, statistics, sys
out = sys.argv[1]
tokens = 716136
print(f'{"variant":22} {"wall ms":>9} {"user Mc":>9} {"kernel Mc":>10} {"total c/token":>14} {"faults":>8}')
for perf in sorted(glob.glob(os.path.join(out, '*.perf')), key=os.path.getmtime):
    name = os.path.basename(perf)[:-5]
    c = {}
    for line in open(perf):
        f = line.strip().split(',')
        if len(f) > 2 and f[0].replace('.', '').isdigit():
            c[f[2]] = float(f[0])
    walls = sorted(int(open(w).read()) for w in glob.glob(os.path.join(out, name + '.w*.wall')))
    wall = statistics.median(walls) / 1e6 if walls else float('nan')
    u, k = c.get('cycles:u', 0), c.get('cycles:k', 0)
    print(f'{name:22} {wall:9.3f} {u / 1e6:9.3f} {k / 1e6:10.3f} {(u + k) / tokens:14.2f} {c.get("page-faults", 0):8.0f}')
