import sys, glob, os, statistics, re
# reduce2.py DIRECTORY: the medians of the rounds and of the rounds' paired differences (a round's value is the mean of its two runs of an arm).
out = sys.argv[1]
tokens = int(open(os.path.join(out, 'tokens')).read()) if os.path.exists(os.path.join(out, 'tokens')) else 0
rounds = {}
shas, diags, statuses, objects = set(), set(), set(), set()
notes = []
for wall in sorted(glob.glob(os.path.join(out, 'r*.wall'))):
    key = wall[:-5]
    m = re.match(r'r(\d+)\.p(\d+)\.(\w+)', os.path.basename(key))
    r, arm = int(m.group(1)), m.group(3)
    w = int(open(wall).read())
    c = {}
    for line in open(key + '.perf'):
        f = line.strip().split(',')
        if len(f) > 2 and f[0].isdigit():
            c[f[2]] = int(f[0])
    faults = int(open(key + '.faults').read().split()[0]) if os.path.exists(key + '.faults') else -1
    c['wall-faults'] = faults
    for s in open(key + '.sha').read().split():
        shas.add(s)
    diags.add(open(key + '.diag').read().strip())
    statuses.add(open(key + '.status').read().strip())
    objects.add(open(key + '.objects').read().strip())
    rounds.setdefault(r, {}).setdefault(arm, []).append((w, c))
def mean(xs): return sum(xs) / len(xs)
metrics = [('wall ms', lambda w, c: w / 1e6), ('user cycles M', lambda w, c: c['cycles:u'] / 1e6), ('kernel cycles M', lambda w, c: c['cycles:k'] / 1e6),
           ('total cycles M', lambda w, c: (c['cycles:u'] + c['cycles:k']) / 1e6), ('user instructions M', lambda w, c: c['instructions:u'] / 1e6),
           ('page faults', lambda w, c: c['page-faults']), ('wall run faults', lambda w, c: c['wall-faults'])]
if tokens:
    metrics.insert(4, ('total cycles/token', lambda w, c: (c['cycles:u'] + c['cycles:k']) / tokens))
print(f'{len(rounds)} rounds; distinct object sets: {len(shas)}; objects a run: {sorted(objects)}; distinct diagnostics: {len(diags)}; exit statuses: {sorted(statuses)}')
print(f'{"metric":22} {"parent":>10} {"candidate":>10} {"paired":>9} {"min":>9} {"max":>9}  lower')
for name, fn in metrics:
    p, q, d = [], [], []
    for r in sorted(rounds):
        a = mean([fn(w, c) for w, c in rounds[r]['parent']])
        b = mean([fn(w, c) for w, c in rounds[r]['candidate']])
        p.append(a); q.append(b); d.append(b - a)
    print(f'{name:22} {statistics.median(p):10.3f} {statistics.median(q):10.3f} {statistics.median(d):+9.3f} {min(d):+9.3f} {max(d):+9.3f}  {sum(x < 0 for x in d)}/{len(d)}')
