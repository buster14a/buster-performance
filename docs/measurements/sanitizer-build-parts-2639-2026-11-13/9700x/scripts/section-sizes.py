#!/usr/bin/env python3
# section-sizes.py DIRECTORY: sections.sh's section headers of each sanitizer's whole (SANITIZER-src.txt) and split
# (SANITIZER-split.txt) executables: the allocated sections whose size differs, split minus whole, in bytes.
import os, re, sys
def sizes(path):
    out = {}
    for line in open(path):
        m = re.match(r'\s*\[\s*\d+\]\s+(\S+)\s+(\S+)\s+([0-9a-f]+)\s+([0-9a-f]+)\s+([0-9a-f]+)\s+([0-9a-f]+)\s+(\S*)', line)
        if m and 'A' in m.group(7):
            out[m.group(1)] = int(m.group(5), 16)
    return out
for s in ('memory', 'address', 'thread'):
    a = sizes(os.path.join(sys.argv[1], f'{s}-src.txt'))
    b = sizes(os.path.join(sys.argv[1], f'{s}-split.txt'))
    diffs = {k: b.get(k, 0) - a.get(k, 0) for k in set(a) | set(b) if a.get(k) != b.get(k)}
    shown = ', '.join(f'{k} {v:+d}' for k, v in sorted(diffs.items(), key=lambda kv: -abs(kv[1]))) or 'none'
    print(f'{s}: {shown}')
