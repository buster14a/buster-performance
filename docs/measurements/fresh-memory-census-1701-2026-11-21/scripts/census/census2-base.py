#!/usr/bin/env python3
# census2.py LOG STAGES FAULTS EXE: first-touched memory by owner and stage, fault sizes inferred per 2 MB block.
import sys, re, collections, subprocess, bisect
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
names = {}
for c in sorted({a[4] for _, k, a in events if k != 'table'}):
    o = subprocess.run(['addr2line', '-f', '-i', '-e', exe, hex(c - 1)], capture_output=True, text=True).stdout.split('\n')
    pairs = [(o[i], o[i + 1].split('/')[-1].split(' ')[0]) for i in range(0, len(o) - 1, 2)]
    pick = next(((fn, fl) for fn, fl in pairs if not fn.startswith('arena_')), pairs[-1] if pairs else ('?', '?'))
    names[c] = f'{pick[0]} {pick[1]}'
arenas = {}   # base -> [small, huge, owner]
ei = 0
rows = []     # (owner, block, in_huge, stage, retouch, sym)
discarded_blocks = set()
dis = collections.Counter(); disb = collections.Counter()
def find(addr):
    best = None
    for b in arenas:
        if b <= addr and addr - b < (64 << 30) and (best is None or b > best): best = b
    return best
for t, addr, sym in faults:
    while ei < len(events) and events[ei][0] <= t:
        _, k, a = events[ei]; ei += 1
        if k == 'reserve' and a[0]:
            arenas[a[0]] = [a[2], 0, names[a[4]]]
        elif k == 'tables' and a[0]:
            tables_owner = names[a[4]]
        elif k == 'table' and a[1]:
            # a table: its first `small` bytes base pages, the rest huge (arena_reserve_tables)
            arenas[a[1]] = [a[3], 0, tables_owner]
        elif k == 'discard':
            ow = arenas[a[0]][2] if a[0] in arenas else '?'
            dis[ow] += 1; disb[ow] += a[2] - a[1]
            for blk in range(a[1] >> 21, (a[2] + HUGE - 1) >> 21): discarded_blocks.add(blk)
        elif k == 'release':
            arenas.pop(a[0], None)
            for tb in [b for b, v in arenas.items() if v[2] == '__none__']: pass
    b = find(addr)
    if b is not None:
        small, huge, owner = arenas[b]
        in_huge = bool(huge) and addr >= ((b + small + HUGE - 1) & ~(HUGE - 1))
    else:
        owner, in_huge = 'non-arena ' + re.sub(r'\+0x.*', '', sym)[:40], False
    blk = addr >> 21
    rows.append((owner, blk, in_huge, stage_at(t), blk in discarded_blocks))
# faults per block (and per epoch: before/after its discard)
per_block = collections.Counter((o, blk, r) for o, blk, h, s, r in rows)
by_owner = collections.defaultdict(collections.Counter); stage_tot = collections.Counter(); owner_stage = collections.defaultdict(collections.Counter)
for o, blk, h, s, r in rows:
    size = HUGE if (h and per_block[(o, blk, r)] == 1) else PAGE
    by_owner[o]['bytes'] += size; by_owner[o]['faults'] += 1
    if r: by_owner[o]['again'] += size
    if size == HUGE: by_owner[o]['huge'] += 1
    stage_tot[s] += size; owner_stage[o][s] += size
tot = sum(c['bytes'] for c in by_owner.values())
print(f'first touches: {tot / MB:.1f} MB in {len(rows)} faults ({sum(c["huge"] for c in by_owner.values())} of them 2 MB); again after a discard: {sum(c["again"] for c in by_owner.values()) / MB:.1f} MB')
print('\nby stage, MB:')
for s in dict.fromkeys([s for _, s in laps] + ['after']):
    if stage_tot[s] >= 0.05 * MB: print(f'  {s:20s} {stage_tot[s] / MB:7.1f}')
print('\nby owner: MB, faults (2 MB ones), MB again after a discard, discards (MB); stages')
for o, c in sorted(by_owner.items(), key=lambda kv: -kv[1]['bytes']):
    if c['bytes'] < 200 * 1024: continue
    sts = ', '.join(f'{s} {b / MB:.1f}' for s, b in owner_stage[o].most_common() if b >= 200 * 1024)
    print(f'  {o[:62]:62s} {c["bytes"] / MB:6.1f} {c["faults"]:5d} ({c["huge"]:3d}) {c["again"] / MB:5.1f} {dis[o]:2d} ({disb[o] / MB:5.1f})  [{sts}]')
