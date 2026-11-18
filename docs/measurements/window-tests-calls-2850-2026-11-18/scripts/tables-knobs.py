#!/usr/bin/env python3
# tables-knobs.py RESULTS LABEL KNOB...: a knobs' job's table as Markdown: for each of BUSTER_CALLS_KNOB's values, the
# medians of the tests on the window and of its sweeps on the three corpora (files RESULTS/LABEL/knob<K>-<corpus>-<n>.txt).
import re, glob, statistics, sys
root, label, knobs = sys.argv[1], sys.argv[2], sys.argv[3:]
LINE = re.compile(r"window tests ticks=(\d+) \(([\d.]+) a record\): the records' bytes=(\d+) \(([\d.]+)\) the loop=(\d+) \(([\d.]+)\) an expression's part=(\d+) \(([\d.]+)\) the tests on T's records=(\d+) \(([\d.]+)\); T again for them, not counted=(\d+)")
def rows(k, c):
    out = {}
    for f in sorted(glob.glob(f'{root}/{label}/knob{k}-{c}-[0-9]*.txt')):
        t = open(f).read()
        if not re.search(r'^status 0$', t, re.M): print('PROBLEM: status', f)
        m0 = re.search(r"window tests expressions=(\d+) records=(\d+) differences=(\d+)", t); m = LINE.search(t)
        if not (m0 and m): print('PROBLEM: no line', f); continue
        if int(m0.group(3)) != 0: print('PROBLEM: differences', f)
        recs = int(m0.group(2))
        for name, i in (('all', 1), ('bytes', 3), ('loop', 5), ('part', 7), ('rest', 9)):
            out.setdefault(name, []).append(int(m.group(i)) / recs)
    return out
cs = ('sqlite3', 'lua', 'musl')
print('| knob | readings | `sqlite3.c` | bytes | loop | part | rest | Lua | bytes | loop | part | rest | musl | bytes | loop | part | rest |')
print('| --- | ---: |' + ' ---: |' * 15)
for k in knobs:
    d = {c: rows(k, c) for c in cs}
    n = len(d['sqlite3'].get('all', []))
    print(f'| {k} | {n} | ' + ' | '.join(' | '.join(f"{statistics.median(d[c][name]):.2f}" for name in ('all', 'bytes', 'loop', 'part', 'rest')) for c in cs) + ' |')
