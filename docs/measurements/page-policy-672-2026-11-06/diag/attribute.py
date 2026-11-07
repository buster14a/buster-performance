#!/usr/bin/env python3
# Throwaway diagnostic: attribute each smaps snapshot's resident memory to the arena mapping (and its call stack) that
# contains it. usage: attribute.py ARENA_LOG SMAPS_DIR EXECUTABLE [STAGE_FILTER]
import os, re, subprocess, sys, collections

log_path, smaps_dir, exe = sys.argv[1:4]
only = sys.argv[4] if len(sys.argv) > 4 else None

maps = []  # (tsc, start, end, frames)
base = None
for line in open(log_path):
    parts = line.split()
    if parts[0] != 'map':
        continue
    tsc = int(parts[1]); start = int(parts[2], 16); size = int(parts[3]); base = int(parts[4], 16)
    frames = [int(f, 16) for f in parts[5:]]
    maps.append((tsc, start, start + size, frames))

# Symbolize every distinct frame offset once.
offsets = sorted({f for m in maps for f in m[3] if 0 < f < 1 << 40})
sym = {}
if offsets:
    out = subprocess.run(['llvm-symbolizer', '--obj=' + exe, '--functions=linkage', '--inlining'] , input='\n'.join('0x%x' % (o - 1) for o in offsets), capture_output=True, text=True).stdout
    blocks = out.strip('\n').split('\n\n')
    for o, b in zip(offsets, blocks):
        lines = b.split('\n')
        names = [lines[i] for i in range(0, len(lines), 2)]
        locs = [os.path.basename(lines[i]) for i in range(1, len(lines), 2)]
        sym[o] = list(zip(names, locs))

SKIP = re.compile(r'^(arena_|parse_column$|parse_columns$|check_.*_arena$|backtrace|__libc)')
def site(frames):
    chain = []
    for f in frames:
        for name, loc in sym.get(f, [('?', '?')]):
            chain.append((name, loc))
    # The first frame that isn't the arena layer itself, plus its caller.
    keep = [c for c in chain if not c[0].startswith('arena_')]
    return ' < '.join('%s(%s)' % c for c in keep[:3])

def snapshot(path):
    vmas = []
    cur = None
    for line in open(path):
        m = re.match(r'^([0-9a-f]+)-([0-9a-f]+) ', line)
        if m:
            cur = {'start': int(m.group(1), 16), 'end': int(m.group(2), 16), 'line': line.strip()}
            vmas.append(cur)
            continue
        k, _, v = line.partition(':')
        if cur is not None and v.strip().endswith('kB'):
            cur[k] = int(v.split()[0])
    return vmas

files = sorted(os.listdir(smaps_dir), key=lambda n: int(n.split('-')[0]))
for name in files:
    tsc = int(name.split('-')[0]); stage = name.split('-', 1)[1][:-4]
    if only and stage != only:
        continue
    vmas = snapshot(os.path.join(smaps_dir, name))
    by_site = collections.Counter(); huge_site = collections.Counter(); total = 0; unattributed = 0; other = collections.Counter()
    for v in vmas:
        rss = v.get('Rss', 0)
        if rss == 0:
            continue
        total += rss
        cands = [m for m in maps if m[0] <= tsc and m[1] <= v['start'] < m[2]]
        if cands:
            m = max(cands, key=lambda m: m[0])
            s = site(m[3])
            by_site[s] += rss; huge_site[s] += v.get('AnonHugePages', 0)
        else:
            unattributed += rss
            other[v['line'].split()[-1] if len(v['line'].split()) > 5 else '[anon]'] += rss
    print('=== %s  total Rss %d KB, unattributed %d KB' % (stage, total, unattributed))
    for s, kb in by_site.most_common(25):
        print('%9d KB  huge %9d KB  %s' % (kb, huge_site[s], s))
    for s, kb in other.most_common(6):
        print('%9d KB  (non-arena) %s' % (kb, s))
