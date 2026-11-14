#!/usr/bin/env python3
# faultmap.py: perf script --show-mmap-events -F ip,sym,addr of page-faults (-d) on stdin: each fault's mapping (the latest
# anonymous or file mmap covering its address); per mapping its fault count and its top symbols.
import sys, re, collections, bisect
maps = []  # (start, end, name)
faults = collections.Counter()
syms = collections.defaultdict(collections.Counter)
mm = re.compile(r'PERF_RECORD_MMAP2? \d+/\d+: \[0x([0-9a-f]+)\((0x[0-9a-f]+)\) @ [^\]]*\]: [rwxp-]+ ?(.*)$')
for line in sys.stdin:
    if 'PERF_RECORD_MMAP' in line:
        m = mm.search(line)
        if m:
            start = int(m.group(1), 16); length = int(m.group(2), 16)
            maps.append((start, start + length, m.group(3).strip()[-40:]))
        continue
    parts = line.split()
    if len(parts) < 2:
        continue
    try:
        addr = int(parts[0], 16)
    except ValueError:
        continue
    sym = parts[2] if len(parts) > 2 else '?'
    region = None
    for start, end, name in reversed(maps):
        if start <= addr < end:
            region = (start, end, name)
            break
    key = region if region else (addr >> 30 << 30, 0, 'unmapped')
    faults[key] += 1
    syms[key][sym.split('+')[0]] += 1
for key, n in sorted(faults.items(), key=lambda kv: -kv[1])[:40]:
    start, end, name = key
    print('%8d  %x-%x (%d MB) %s  %s' % (n, start, end, (end - start) >> 20, name, ' '.join('%s:%d' % kv for kv in syms[key].most_common(3))))
