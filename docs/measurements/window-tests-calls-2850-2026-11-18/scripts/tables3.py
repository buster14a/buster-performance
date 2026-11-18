#!/usr/bin/env python3
# tables3.py RESULTS HEAD BASE: a job-pair's table as Markdown: medians by sweep, the head's build and the base's in the
# same turns (the base's files are tagged vs-HEAD...).
import re, glob, statistics, sys
root, head, base = sys.argv[1], sys.argv[2], sys.argv[3]
LINE = re.compile(r"window tests ticks=(\d+) \(([\d.]+) a record\): the records' bytes=(\d+) \(([\d.]+)\) the loop=(\d+) \(([\d.]+)\) an expression's part=(\d+) \(([\d.]+)\) the tests on T's records=(\d+) \(([\d.]+)\); T again for them, not counted=(\d+)")
def med(x): return statistics.median(x) if x else float('nan')
def rows(label, tag, c):
    out = {}
    for f in sorted(glob.glob(f'{root}/{label}/{tag}-{c}-[0-9]*.txt')):
        t = open(f).read()
        if not re.search(r'^status 0$', t, re.M): print('PROBLEM: status', f)
        m0 = re.search(r"window tests expressions=(\d+) records=(\d+) differences=(\d+)", t); m = LINE.search(t)
        if not (m0 and m): continue
        recs = int(m0.group(2))
        for k, i in (('all', 1), ('bytes', 3), ('loop', 5), ('part', 7), ('rest', 9)):
            out.setdefault(k, []).append(int(m.group(i)) / recs)
    return out
def window(label, tag, c):
    k, fr = [], []
    for f in sorted(glob.glob(f'{root}/{label}/{tag}-{c}-[0-9]*.txt')):
        t = open(f).read()
        m = re.search(r'the kernel in place: .* ticks=(\d+) \(([\d.]+) a record\)', t)
        if m: k.append(float(m.group(2)))
        m = re.search(r'the front with the window: ticks=(\d+) records=(\d+);', t)
        if m: fr.append(int(m.group(1)) / int(m.group(2)))
    return k, fr
cs = ('sqlite3', 'lua', 'musl')
d = {c: (rows(base, f'vs-{head}', c), rows(head, 'window-tests', c)) for c in cs}
w = {c: (rows(base, f'vs-{head}-wall', c), rows(head, 'window-tests-wall', c)) for c in cs}
v = {c: rows(head, 'window-tests-verify', c) for c in cs}
print(f'| ticks a record | `sqlite3.c` | | Lua | | musl | |')
print('| --- | ---: | ---: | ---: | ---: | ---: | ---: |')
print(f'| | before | `{head}` | before | `{head}` | before | `{head}` |')
names = (('all', 'the tests on the window'), ('bytes', 'bytes'), ('loop', 'loop'), ('part', 'part'), ('rest', 'rest'))
for k, name in names:
    print(f'| {name} | ' + ' | '.join(f"{med(d[c][0].get(k, [])):.2f} | {med(d[c][1].get(k, [])):.2f}" for c in cs) + ' |')
print('| with every warning | ' + ' | '.join(f"{med(w[c][0].get('all', [])):.2f} | {med(w[c][1].get('all', [])):.2f}" for c in cs) + ' |')
if any(v[c] for c in cs):
    print('| beside `--verify` (one reading) | ' + ' | '.join(f" | {med(v[c].get('all', [])):.2f}" for c in cs) + ' |')
kb = {c: (window(base, f'vs-{head}-window', c), window(head, 'window', c)) for c in cs}
if all(kb[c][0][0] and kb[c][1][0] for c in cs):
    print('| the kernel in place, without the tests | ' + ' | '.join(f"{med(kb[c][0][0]):.2f} | {med(kb[c][1][0]):.2f}" for c in cs) + ' |')
    print('| the front with the window | ' + ' | '.join(f"{med(kb[c][0][1]):.2f} | {med(kb[c][1][1]):.2f}" for c in cs) + ' |')
print()
print('Readings of the tests: ' + '; '.join(f"{c} `{head}` {min(d[c][1]['all']):.1f} to {max(d[c][1]['all']):.1f}, before {min(d[c][0]['all']):.1f} to {max(d[c][0]['all']):.1f}" for c in cs) + '.')
for f in sorted(glob.glob(f'{root}/{head}/compile-*.txt')):
    for l in open(f).read().splitlines():
        if 'median' in l and ('head:' in l or 'base-again:' in l): print('`-c sqlite3.c`,', f.split('/')[-1] + ':', l.strip()[:160])
