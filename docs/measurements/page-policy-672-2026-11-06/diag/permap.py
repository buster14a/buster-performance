#!/usr/bin/env python3
# Throwaway: per-mapping Rss at one stage's snapshot, for two runs (huge, base), mappings matched by creation order.
import re, os, sys
def load(log, smaps_dir, stage):
    maps = [l.split() for l in open(log) if l.startswith('map')]
    maps = [(int(p[1]), int(p[2], 16), int(p[2], 16) + int(p[3]), p[5:9]) for p in maps]
    snap = sorted([f for f in os.listdir(smaps_dir) if f.split('-', 1)[1][:-4] == stage], key=lambda f: int(f.split('-')[0]))[-1]
    tsc = int(snap.split('-')[0])
    vmas = []; cur = None
    for line in open(os.path.join(smaps_dir, snap)):
        m = re.match(r'^([0-9a-f]+)-([0-9a-f]+) ', line)
        if m:
            cur = {'s': int(m.group(1), 16), 'Rss': 0}; vmas.append(cur); continue
        k, _, v = line.partition(':')
        if cur is not None and k == 'Rss': cur['Rss'] = int(v.split()[0])
    out = []
    for i, (t, s, e, fr) in enumerate(maps):
        if t > tsc: break
        later = [m for m in maps[i + 1:] if m[0] <= tsc and m[1] < e and s < m[2]]
        rss = 0 if later else sum(v['Rss'] for v in vmas if s <= v['s'] < e)
        out.append((i, rss, fr))
    return out
stage = sys.argv[1]
h = load('/tmp/claude-0/arena-hp1.log', '/tmp/claude-0/smaps-hp1', stage)
b = load('/tmp/claude-0/arena-hp0.log', '/tmp/claude-0/smaps-hp0', stage)
for (i, rh, fr), (j, rb, _) in zip(h, b):
    if rh or rb:
        print('%3d %8d %8d %8d  %s' % (i, rh, rb, rh - rb, ' '.join(fr)))
