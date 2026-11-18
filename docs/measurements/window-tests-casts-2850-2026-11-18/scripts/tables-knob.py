#!/usr/bin/env python3
# tables-knob.py RESULTS LABEL TAG-A TAG-B: one executable's two settings, medians by sweep, ticks a record.
import re, glob, statistics, sys
root, label, ta, tb = sys.argv[1:5]
LINE = re.compile(r"window tests ticks=(\d+) \(([\d.]+) a record\): the records' bytes=(\d+) \(([\d.]+)\) the loop=(\d+) \(([\d.]+)\) an expression's part=(\d+) \(([\d.]+)\) the tests on T's records=(\d+)")
def rows(tag, c):
    out = {}; diffs = set(); listed = set()
    for f in sorted(glob.glob(f'{root}/{label}/{tag}-{c}-[0-9]*.txt')):
        t = open(f).read()
        m0 = re.search(r"window tests expressions=(\d+) records=(\d+) differences=(\d+)", t); m = LINE.search(t)
        if not (m0 and m): continue
        recs = int(m0.group(2)); diffs.add(int(m0.group(3)))
        m1 = re.search(r"expressions-with-nothing-listed=(\d+)", t)
        if m1: listed.add(int(m0.group(1)) - int(m1.group(1)))
        for k, i in (('all', 1), ('bytes', 3), ('loop', 5), ('part', 7), ('rest', 9)):
            out.setdefault(k, []).append(int(m.group(i)) / recs)
    return out, diffs, listed
print('| ticks a record | `sqlite3.c` | | Lua | | musl | |')
print('| --- | ---: | ---: | ---: | ---: | ---: | ---: |')
print(f'| | `{ta}` | `{tb}` | `{ta}` | `{tb}` | `{ta}` | `{tb}` |')
cs = ('sqlite3', 'lua', 'musl')
d = {c: (rows(ta, c), rows(tb, c)) for c in cs}
for k, name in (('all', 'the tests on the window'), ('bytes', 'bytes'), ('loop', 'loop'), ('part', 'part'), ('rest', 'rest')):
    print(f'| {name} | ' + ' | '.join(f"{statistics.median(d[c][0][0][k]):.2f} | {statistics.median(d[c][1][0][k]):.2f}" for c in cs) + ' |')
print('| expressions listed | ' + ' | '.join(f"{sorted(d[c][0][2])} | {sorted(d[c][1][2])}" for c in cs) + ' |')
print('| expressions that differ | ' + ' | '.join(f"{sorted(d[c][0][1])} | {sorted(d[c][1][1])}" for c in cs) + ' |')
print('readings: ' + '; '.join(f"{c} {min(d[c][0][0]['all']):.1f} to {max(d[c][0][0]['all']):.1f}, {min(d[c][1][0]['all']):.1f} to {max(d[c][1][0]['all']):.1f}" for c in cs))
