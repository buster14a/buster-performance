# attribute.py DUMP EXECUTABLE: the instrumented build's dump of the pushes that hold resident pages at a stage's mark
# (peak_dump), grouped by mapping and by the first two callers outside the arena's own functions, which addr2line names
# from the executable's debug information. Each page counts once, for the latest push over it.
import sys, subprocess, collections
path, exe = sys.argv[1], sys.argv[2]
pushes = []
maps = []
for line in open(path):
    f = line.split()
    if f and f[0] == 'push':
        pushes.append((int(f[2], 16), int(f[4]), int(f[8]), f[10:]))
    elif f and f[0] == 'map' and f[2] == 'rss':
        a, b = f[1].split('-')
        maps.append((int(a, 16), int(b, 16), int(f[3])))
addresses = sorted({a for p in pushes for a in p[3]})
out = subprocess.run(['addr2line', '-f', '-e', exe] + addresses, capture_output=True, text=True).stdout.split('\n')
names = {a: (out[2 * i], out[2 * i + 1].split('/')[-1]) for i, a in enumerate(addresses)}
skip = ('arena_push', 'peak_log', 'arena_push_logged', 'arena_push_array', 'arena_push_bytes')
def mapping(x):
    for i, (a, b, kb) in enumerate(maps):
        if a <= x < b:
            return f'mapping {a:x}-{b:x}'
    return 'mapping of less than 512 KiB resident'
total = collections.Counter()
groups = collections.defaultdict(collections.Counter)
for begin, size, kb, frames in pushes:
    rest = [names[a] for a in frames if not names[a][0].startswith(skip)]
    key = ' < '.join(f'{n}@{l}' for n, l in rest[:2])
    total[rest[0][0] if rest else '?'] += kb
    groups[mapping(begin)][key] += kb
print(f'pushes with resident pages: {len(pushes)}, {sum(total.values())} KiB')
print('by first caller (KiB):')
for k, v in total.most_common(25):
    print(f'  {v:8d}  {k}')
for m in sorted(groups, key=lambda m: -sum(groups[m].values())):
    print(f'{m}: {sum(groups[m].values())} KiB')
    for k, v in groups[m].most_common(12):
        print(f'  {v:8d}  {k}')
