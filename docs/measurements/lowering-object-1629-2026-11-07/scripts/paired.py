import sys, re, glob, statistics, collections
d = sys.argv[1]; trees = sys.argv[2].split(','); limit = int(sys.argv[3]) if len(sys.argv) > 3 else 300
data = collections.defaultdict(dict)
for p in glob.glob(f'{d}/round-*-*.txt'):
    m = re.search(r'round-(\d+)-([\w-]+)\.txt$', p); r, t = int(m.group(1)), m.group(2)
    if t not in trees: continue
    for line in open(p):
        if 'file=' in line and 'ns=' in line:
            f = dict(kv.split('=', 1) for kv in line.split()[1:])
            data[(r, t)][f['file'].rsplit('/', 1)[-1]] = f
full = max(len(v) for v in data.values())
rounds = sorted(r for r in {r for r, t in data} if all(len(data.get((r, t), {})) == full for t in trees))
print(f'complete rounds: {rounds}')
files = set.intersection(*[set(data[(r, t)]) for r in rounds for t in trees])
for label, sel in (('tiny', {f for f in files if int(data[(rounds[0], trees[0])][f]['tokens']) < limit}), ('all', files)):
    print(f'== {label} ({len(sel)} files)')
    for s in ('min_ns', 'min_select', 'min_emit', 'min_publish', 'min_object'):
        floors = {t: sum(min(int(data[(r, t)][f][s]) for r in rounds) for f in sel) for t in trees}
        row = '  '.join(f'{t}={floors[t]/len(sel):8.1f}' for t in trees)
        paired = []
        for t in trees[1:]:
            ds = [sum(int(data[(r, t)][f][s]) for f in sel) / sum(int(data[(r, trees[0])][f][s]) for f in sel) - 1 for r in rounds]
            paired.append(f'{t}: floor {(floors[t]-floors[trees[0]])/len(sel):+7.1f} ns/file, paired median {100*statistics.median(ds):+.2f}% [{", ".join(f"{100*x:+.1f}" for x in ds)}]')
        print(f'  {s:12s} {row}   ' + '; '.join(paired))
