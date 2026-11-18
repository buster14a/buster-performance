#!/usr/bin/env python3
# pads.py RESULTS TAG CORPUS LABEL...: the readings of pads.sh by environment size, and each label's median over the sizes.
import sys, re, statistics, glob, os
results, tag, corpus = sys.argv[1:4]
labels = sys.argv[4:]
pads = sorted({int(re.search(r'pad(\d+)\.txt$', f).group(1)) for f in glob.glob(f'{results}/{labels[0]}/{tag}-{corpus}-pad*.txt')})
rows = {}
for label in labels:
    rows[label] = {}
    for pad in pads:
        text = open(f'{results}/{label}/{tag}-{corpus}-pad{pad}.txt').read()
        m = re.search(r"window tests ticks=\d+ \(([\d.]+) a record\): the records' bytes=\d+ \(([\d.]+)\) the loop=\d+ \(([\d.]+)\) an expression's part=\d+ \(([\d.]+)\) the tests on T's records=\d+ \(([\d.]+)\); T again for them, not counted=\d+ \(([\d.]+)\)", text)
        status = re.search(r'^status (\d+)', text, re.M)
        rows[label][pad] = [float(x) for x in m.groups()] if m and status and status.group(1) == '0' else None
names = ['all', 'bytes', 'loop', 'part', 'rest', 'again']
print(f'## {tag} {corpus}: ticks a record by the environment variable\'s bytes')
print('pad   ' + '   '.join(f'{label:>8}' for label in labels))
for pad in pads:
    print(f'{pad:4d}  ' + '   '.join(f'{rows[label][pad][0]:8.2f}' if rows[label][pad] else '    FAIL' for label in labels))
for label in labels:
    values = [rows[label][pad] for pad in pads if rows[label][pad]]
    line = ', '.join(f'{name} {statistics.median(v[i] for v in values):.2f}' for i, name in enumerate(names))
    spread = (max(v[0] for v in values) / min(v[0] for v in values) - 1) * 100
    print(f'{label}: medians over {len(values)} sizes: {line}; all from {min(v[0] for v in values):.2f} to {max(v[0] for v in values):.2f} (+{spread:.1f}%)')
