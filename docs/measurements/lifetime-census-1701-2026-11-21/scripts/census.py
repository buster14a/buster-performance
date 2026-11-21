# #1701 lifetime census reducer (granules): coverage, dead-but-resident bytes at each mark, by owner.
import sys, subprocess, collections
table, exe = sys.argv[1], sys.argv[2]
focus = [int(x) for x in sys.argv[3].split(',')] if len(sys.argv) > 3 else []
G = 64 << 10
marks, pushes, arenas, gran = [], [], [], collections.defaultdict(list)
for line in open(table):
    f = line.rstrip('\n').split('\t')
    if f[0] == 'mark':
        marks.append(dict(name=f[2], rss=int(f[3]) * 1024, hwm=int(f[4]) * 1024))
    elif f[0] == 'push':
        pushes.append(dict(begin=int(f[2], 16), size=int(f[3]), site=int(f[4], 16), arena=int(f[5], 16), pushed=int(f[7]), popped=int(f[8])))
    elif f[0] == 'arena':
        arenas.append(dict(base=int(f[2], 16), end=int(f[3]), site=int(f[4], 16), created=int(f[5]), released=int(f[6])))
    elif f[0] == 'granule':
        gran[int(f[1])].append((int(f[2]), int(f[3], 16), int(f[4], 16), [int(x) for x in f[5].split(',')]))
M = len(marks)
first = min(i for i, m in enumerate(marks) if m['name'] == 'parse')
last = min(i for i, m in enumerate(marks) if m['name'] == 'object-build')
sites = sorted({p['site'] for p in pushes} | {a['site'] for a in arenas})
out = subprocess.run(['llvm-symbolizer', '--inlining', '--obj=' + exe] + [hex(s - 1) for s in sites],
                     capture_output=True, text=True).stdout.split('\n\n')
name = {}
for s, block in zip(sites, out):
    lines = [l for l in block.strip().split('\n') if l]
    frames = [(lines[i], lines[i + 1].split('/compiler/')[-1].rsplit(':', 1)[0]) for i in range(0, len(lines) - 1, 2)]
    pick = [fr for fr in frames if not fr[0].startswith('arena_')] or frames
    name[s] = f'{pick[0][0].replace(".buster_split","")} ({pick[0][1]})'
def owner(ai, g, m):
    a = arenas[ai]; lo = a['base'] + g * G; mid = lo + G // 2
    best = None
    for p in pushes:
        if p['arena'] == a['base'] and p['begin'] < lo + G and lo < p['begin'] + p['size'] and p['pushed'] <= m:
            live = p['popped'] == -1 or p['popped'] > m
            key = (live, p['pushed'])
            if best is None or key > best[0]:
                best = (key, p)
    if best is None:
        return 'small pushes in arena of ' + name[a['site']]
    return ('' if best[0][0] else 'popped: ') + name[best[1]['site']]
def alive(a, m):
    return a['created'] <= m and (a['released'] == -1 or a['released'] > m)
print(f"marks {M}; accesses tracked in epochs {first+1}..{last} (after '{marks[first]['name']}' through '{marks[last]['name']}'); arenas {len(arenas)}")
print('mark  stage               RSS MB  arenas MB  cover  touched-later MB  dead MB')
rows = []
for m in range(M):
    res = dead = 0
    for ai, a in enumerate(arenas):
        if not alive(a, m):
            continue
        for g, r, w, rs in gran[ai]:
            b = rs[m] * 4096 if m < len(rs) else 0
            res += b
            if m >= first and not any(((r | w) >> k) & 1 for k in range(m + 1, last + 1)):
                dead += b
    rows.append((m, res, dead))
    d = f'{dead/1e6:7.1f}' if m >= first and m < last else '      -'
    print(f"{m:4d}  {marks[m]['name']:<18} {marks[m]['rss']/1e6:7.1f}  {res/1e6:9.1f}  {100*res/marks[m]['rss']:4.0f}%  {(res-dead)/1e6 if m>=first and m<last else 0:16.1f}  {d}")
live_peak = max((res - dead) for m, res, dead in rows if first <= m < last)
arena_peak = max(res for m, res, dead in rows)
first_touched = sum(max(rs) * 4096 for ai in gran for g, r, w, rs in gran[ai])
print(f"\narena bytes resident at their peak {arena_peak/1e6:.1f} MB; touched-later at most {live_peak/1e6:.1f} MB (marks {first}..{last-1});"
      f" granules' largest residency summed (first touched, without re-faults) {first_touched/1e6:.1f} MB; process VmHWM {max(m['hwm'] for m in marks)/1e6:.1f} MB")
for fm in focus:
    agg = collections.defaultdict(lambda: [0, 0, collections.Counter()])
    for ai, a in enumerate(arenas):
        if not alive(a, fm):
            continue
        for g, r, w, rs in gran[ai]:
            b = rs[fm] * 4096 if fm < len(rs) else 0
            if not b:
                continue
            o = owner(ai, g, fm)
            bits = r | w
            lastk = max([k for k in range(fm + 1, last + 1) if (bits >> k) & 1], default=None)
            agg[o][0] += b
            if lastk is None:
                agg[o][1] += b
            else:
                agg[o][2][marks[lastk]['name']] += b
    print(f"\nat mark {fm} ({marks[fm]['name']}): resident MB, of it dead MB, last later stage touching the rest (MB)")
    for o, (b, d, lasts) in sorted(agg.items(), key=lambda kv: -kv[1][0])[:28]:
        tops = ', '.join(f'{k} {v/1e6:.1f}' for k, v in lasts.most_common(3))
        print(f"{b/1e6:7.1f} {d/1e6:7.1f}  {o[:95]:<95} {tops}")
