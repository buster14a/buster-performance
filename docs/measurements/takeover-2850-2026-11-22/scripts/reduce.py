import sys, glob, os, statistics, re
out = sys.argv[1]
tokens = 716136
rounds = {}
shas, diags = set(), set()
for wall in sorted(glob.glob(os.path.join(out, 'r*.wall'))):
    key = wall[:-5]
    m = re.match(r'r(\d+)\.p(\d+)\.(\w+)', os.path.basename(key))
    r, arm = int(m.group(1)), m.group(3)
    w = int(open(wall).read())
    if os.path.exists(key + '.faults'):
        faults = int(open(key + '.faults').read().split()[0])
        if faults > 20000:
            print(f'note: {os.path.basename(key)} wall run took {faults} minor faults (base pages), {w / 1e6:.3f} ms')
    c = {}
    for line in open(key + '.perf'):
        f = line.strip().split(',')
        if len(f) > 2 and f[0].isdigit():
            c[f[2]] = int(f[0])
    for s in open(key + '.sha').read().split():
        shas.add(s)
    diags.add(open(key + '.diag').read().strip())
    rounds.setdefault(r, {}).setdefault(arm, []).append((w, c))
def mean(xs): return sum(xs) / len(xs)
metrics = [('wall ms', lambda w, c: w / 1e6), ('user cycles/token', lambda w, c: c['cycles:u'] / tokens), ('kernel cycles/token', lambda w, c: c['cycles:k'] / tokens),
           ('total cycles/token', lambda w, c: (c['cycles:u'] + c['cycles:k']) / tokens), ('user instructions M', lambda w, c: c['instructions:u'] / 1e6), ('page faults', lambda w, c: c['page-faults'])]
print(f'{len(rounds)} rounds; distinct objects: {len(shas)}; distinct diagnostics: {len(diags)}')
print(f'{"metric":22} {"parent":>10} {"candidate":>10} {"paired":>9} {"min":>9} {"max":>9}  better')
for name, fn in metrics:
    p, q, d = [], [], []
    for r in sorted(rounds):
        a = mean([fn(w, c) for w, c in rounds[r]['parent']])
        b = mean([fn(w, c) for w, c in rounds[r]['candidate']])
        p.append(a); q.append(b); d.append(b - a)
    print(f'{name:22} {statistics.median(p):10.3f} {statistics.median(q):10.3f} {statistics.median(d):+9.3f} {min(d):+9.3f} {max(d):+9.3f}  {sum(x < 0 for x in d)}/{len(d)}')
