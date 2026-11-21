#!/usr/bin/env python3
# census3.py LOG STAGES FAULTS EXE [OWNER_SUBSTRING]: as census2, plus each arena's bytes by the push that took them.
import sys, re, collections, subprocess, bisect, functools
log, stages_path, faults_path, exe = sys.argv[1:5]
HUGE = 2 << 20; PAGE = 4096; MB = 1 << 20
events = []
for line in open(log):
    f = line.split()
    events.append((int(f[1]), f[0], [int(x, 16) for x in f[2:7]]))
events.sort()
laps = [(int(f[2]), f[1]) for f in (l.rstrip('\n').split('\t') for l in open(stages_path)) if f[0] == 'census-lap']
lap_t = [t for t, _ in laps]
def stage_at(t):
    i = bisect.bisect_left(lap_t, t)
    return laps[i][1] if i < len(laps) else 'after'
pat = re.compile(r'^\s*(\d+)\.(\d+):\s+([0-9a-f]+)\s+(\S+)\s+([0-9a-f]+)\s+(.*)$')
faults = []
for line in open(faults_path):
    m = pat.match(line)
    if m: faults.append((int(m.group(1)) * 10**9 + int(m.group(2).ljust(9, '0')[:9]), int(m.group(3), 16), m.group(6).strip()))
faults.sort()
@functools.lru_cache(None)
def frames(addr):
    o = subprocess.run(['addr2line', '-f', '-i', '-e', exe, hex(addr)], capture_output=True, text=True).stdout.split('\n')
    return [(o[i], o[i + 1].split('/')[-1].split(' ')[0]) for i in range(0, len(o) - 1, 2)]
def site(ip, ret):
    fr = frames(ip)
    pick = [x for x in fr if not x[0].startswith('arena_')]
    if not pick:
        fr = frames(ret - 1); pick = [x for x in fr if not x[0].startswith('arena_')] or fr
    return f'{pick[0][0]} {pick[0][1]}' if pick else '?'
arenas = {}; pushes = collections.defaultdict(list)
ei = 0; rows = []
def find(addr):
    best = None
    for b in arenas:
        if b <= addr and addr - b < (64 << 30) and (best is None or b > best): best = b
    return best
for t, addr, sym in faults:
    while ei < len(events) and events[ei][0] <= t:
        _, k, a = events[ei]; ei += 1
        if k in ('reserve', 'tables') and a[0]:
            arenas[a[0]] = [a[2] if k == 'reserve' else 0, 0, site(a[4] - 1, a[4])]
            pushes[a[0]] = []
        elif k == 'push' and a[0] in arenas:
            pushes[a[0]].append((a[1], a[2], a[3], a[4]))
        elif k == 'release':
            arenas.pop(a[0], None)
    b = find(addr)
    if b is not None:
        small, huge, owner = arenas[b]
        in_huge = bool(huge) and addr >= ((b + small + HUGE - 1) & ~(HUGE - 1))
        off = addr - b
        who = 'small pushes'
        for begin, size, ip, ret in reversed(pushes[b]):
            # a huge fault covers the 2 MB block: credit the push that covers the faulting address
            if begin <= off < begin + size: who = site(ip, ret); break
    else:
        owner, in_huge, who = 'non-arena', False, re.sub(r'\+0x.*', '', sym)[:40]
    rows.append((owner, addr >> 21, in_huge, stage_at(t), who))
per_block = collections.Counter((o, blk) for o, blk, h, s, w in rows)
by = collections.defaultdict(collections.Counter); own = collections.Counter()
for o, blk, h, s, w in rows:
    size = HUGE if (h and per_block[(o, blk)] == 1) else PAGE
    by[o][(w, s)] += size; own[o] += size
for o, tot in own.most_common():
    if tot < MB: continue
    print(f'{o}: {tot / MB:.1f} MB')
    for (w, s), b in by[o].most_common(40):
        if b >= 300 * 1024: print(f'    {b / MB:6.1f}  {s:18s} {w}')
