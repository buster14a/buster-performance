#!/usr/bin/env python3
# blocks.py HUGE_BLOCKS_JSON BASE_FAULTS: each 2 MB fault of the huge-page run against the 4 KB pages the base-page run
# touched in the same block (the two runs map the same addresses: setarch -R, the same arena log), priced at #2873's
# 210 K kernel cycles a MB of huge pages and 642 K a MB of base pages (420 K a 2 MB page, 2.568 K a 4 KB page).
import json, re, sys, collections
hb = {int(k): v for k, v in json.load(open(sys.argv[1])).items()}
pat = re.compile(r'^\s*(\d+)\.(\d+):\s+([0-9a-f]+)\s+(\S+)\s+([0-9a-f]+)\s+(.*)$')
b = collections.Counter()
for l in open(sys.argv[2]):
    m = pat.match(l)
    if m: b[int(m.group(3), 16) >> 21] += 1
rows = sorted((b.get(blk, 0), o) for blk, o in hb.items())
hist = collections.Counter('0' if p == 0 else '1-15' if p < 16 else '16-127' if p < 128 else '128-255' if p < 256 else '256-511' if p < 512 else '512' for p, o in rows)
print('2 MB faults in the huge-page run:', len(hb))
print('their 4 KB pages touched in the base-page run:', dict(hist))
cheap = [(p, o) for p, o in rows if p * 2.568 < 420]
print('blocks cheaper in base pages:', len(cheap), 'saving K cycles: %.0f' % sum(420 - p * 2.568 for p, o in cheap))
by = collections.Counter(); n = collections.Counter()
for p, o in cheap: by[o] += 420 - p * 2.568; n[o] += 1
for o, v in by.most_common(): print(f'   {o[:60]:60s} {n[o]:3d} blocks {v:7.0f} K cycles')
