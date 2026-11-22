import subprocess, sys, collections
# attribute.py STAGES COMPILER: the memory experiment's lines reduced: each arena's most resident and filled MB (at a mark
# or at a release), and the large pushes' fill by call site.
cc = sys.argv[2]
marks, rss, arenas, released, pushes = [], [], {}, {}, []
for line in open(sys.argv[1]):
    f = line.rstrip('\n').split('\t')
    if f[0] == 'experiment-marks': marks = f[1:]
    elif f[0] == 'experiment-rss-kb': rss = [int(x) for x in f[1:]]
    elif f[0] == 'experiment-arena':
        arenas[int(f[1])] = dict(stage=f[2], caller=f[3], requested=int(f[4]), takes=int(f[6]), cells=[tuple(int(x) for x in c.split('/')) for c in f[7:]])
    elif f[0] == 'experiment-released':
        released[int(f[1])] = (f[2], int(f[3]), int(f[4]), int(f[5]))
    elif f[0] == 'experiment-push':
        a, b = [tuple(int(x) for x in c.split('/')) for c in f[6:8]]
        pushes.append(dict(stage=f[1], arena=int(f[2]), begin=int(f[3]), bytes=int(f[4]), caller=f[5], m0=a, m1=b))
cache = {}
def name(addr, depth=2):
    if addr not in cache:
        o = subprocess.run(['addr2line', '-f', '-i', '-e', cc, addr], capture_output=True, text=True).stdout.strip().split('\n')
        fn = [o[i] for i in range(0, len(o), 2)]
        loc = [o[i].split('/')[-1] for i in range(1, len(o), 2)]
        chain = [f'{f}@{l}' for f, l in zip(fn, loc) if not f.startswith('arena_push') and not f.startswith('arena_reserve')]
        cache[addr] = chain
    return ' < '.join(cache[addr][:depth])[:100]
peak = max(range(len(rss)), key=lambda i: rss[i])
print(f"marks {len(marks)}; RSS peak at a mark: {rss[peak]/1024:.1f} MB after {marks[peak]}")
print(f"\n{'#':>3} {'reserved after':<14} {'most res MB':>11} {'filled':>7} {'where':<22} {'rel':>3}  reserved by")
total_res = total_fill = 0
for a, row in sorted(arenas.items(), key=lambda kv: -max(max(c[0] for c in kv[1]['cells']), released.get(kv[0], ('', 0, 0, 0))[2])):
    best = max(range(len(row['cells'])), key=lambda i: row['cells'][i][0])
    res, fill, where = row['cells'][best][0], row['cells'][best][1], 'mark ' + marks[best]
    rel = released.get(a, ('-', 0, 0, 0))
    if rel[2] > res:
        res, fill, where = rel[2], rel[3], 'release ' + rel[0]
    total_res += res; total_fill += fill
    if res >= 1024:
        print(f"{a:>3} {row['stage']:<14} {res/1024:>11.1f} {fill/1024:>7.1f} {where:<22} {rel[1]:>3}  {name(row['caller'])}")
print(f"sum of the arenas' most resident: {total_res/1024:.1f} MB, filled {total_fill/1024:.1f} MB")
for slot, label in ((0, 'check-declarations'), (1, 'object-write')):
    by = collections.OrderedDict()
    for p in pushes:
        m = p['m0'] if slot == 0 else p['m1']
        k = (p['arena'], name(p['caller'], 1))
        c = by.setdefault(k, [0, 0, 0, 0])
        c[0] += 1; c[1] += p['bytes']; c[2] += m[0]; c[3] += m[1]
    print(f"\npushes of 512 KB or more, their ranges at the {label} mark (a scratch arena's ranges overlap):")
    print(f"{'arena':>5} {'n':>3} {'pushed MB':>9} {'resident':>8} {'filled':>7}  site")
    for (arena, site), (n, size, res, fill) in sorted(by.items(), key=lambda kv: -kv[1][2])[:34]:
        if res >= 1024:
            print(f"{arena:>5} {n:>3} {size/1e6:>9.1f} {res/1024:>8.1f} {fill/1024:>7.1f}  {site}")
