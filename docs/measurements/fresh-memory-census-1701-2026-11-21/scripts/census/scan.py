#!/usr/bin/env python3
# scan.py STAGES EXE: the occupancy scans (pages present, pages of one repeated byte) by push site, at check-input's end
# and at the report; a page is the latest push's that covers it.
import sys, collections, subprocess, functools
path, exe = sys.argv[1:3]
FR = {}
def symbolize(addrs):
    addrs = sorted(set(addrs))
    out = subprocess.run(['addr2line', '-f', '-i', '-a', '-e', exe] + [hex(a) for a in addrs], capture_output=True, text=True).stdout.split('\n')
    cur = None
    i = 0
    while i < len(out):
        l = out[i]
        if l.startswith('0x') and len(l) > 2 and all(ch in '0123456789abcdefx' for ch in l):
            cur = int(l, 16); FR[cur] = []; i += 1; continue
        if cur is not None and i + 1 < len(out):
            FR[cur].append((l, out[i + 1].split('/')[-1].split(' ')[0])); i += 2; continue
        i += 1
def site(ip, ret):
    pick = [x for x in FR.get(ip, []) if not x[0].startswith('arena_')] or [x for x in FR.get(ret - 1, []) if not x[0].startswith('arena_')]
    return f'{pick[0][0]} {pick[0][1]}' if pick else '?'
scans = [[]]
for line in open(path):
    f = line.rstrip('\n').split('\t')
    if f[0] == 'census-scan-at' and f[1] == 'end': scans.append([])
    elif f[0] == 'census-scan':
        scans[-1].append((int(f[1], 16), int(f[2], 16), int(f[3]), int(f[4]), int(f[5]), int(f[6]), int(f[7], 16), int(f[8], 16)))
symbolize([x[6] for sc in scans for x in sc] + [x[7] - 1 for sc in scans for x in sc])
MB = 1 << 20
for name, sc in zip(('at check-input\'s end', 'at the report'), scans):
    # the scan counts each push's pages; later pushes over the same pages count them again: keep the latest push a page
    agg = collections.defaultdict(collections.Counter)
    seen = {}
    for i, (base, begin, size, present, uniform, zero, ip, ret) in enumerate(sc):
        seen[(base + begin) & ~4095] = i
    for i, (base, begin, size, present, uniform, zero, ip, ret) in enumerate(sc):
        s = site(ip, ret)
        agg[s]['pushed'] += size; agg[s]['present'] += present; agg[s]['uniform'] += uniform; agg[s]['zero'] += zero; agg[s]['n'] += 1
    tp = sum(c['present'] for c in agg.values()); tu = sum(c['uniform'] for c in agg.values()); tz = sum(c['zero'] for c in agg.values())
    print(f'== {name}: pushes of 64 KB or more: present {tp * 4096 / MB:.1f} MB, of one repeated byte {tu * 4096 / MB:.1f} MB (zero {tz * 4096 / MB:.1f})')
    print(f'   {"site":58s} {"pushed":>8s} {"present":>8s} {"uniform":>8s} {"zero":>6s}  n')
    for s, c in sorted(agg.items(), key=lambda kv: -kv[1]['present'])[:45]:
        print(f'   {s[:58]:58s} {c["pushed"] / MB:8.1f} {c["present"] * 4096 / MB:8.1f} {c["uniform"] * 4096 / MB:8.1f} {c["zero"] * 4096 / MB:6.1f}  {c["n"]}')
