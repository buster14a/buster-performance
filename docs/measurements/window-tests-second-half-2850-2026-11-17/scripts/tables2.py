#!/usr/bin/env python3
# tables2.py RESULTS HEAD BASE: the quiet rule's job (job-p4): the window's tests, the head's build against the base's
# in the same turns (the base's files are tagged vs-HEAD...), by sweep; the counts; the window without the tests; the
# whole compile.
import re, glob, statistics, sys
root, head, base = sys.argv[1], sys.argv[2], sys.argv[3]
def med(x): return statistics.median(x) if x else float('nan')
LINE = re.compile(r"window tests ticks=(\d+) \(([\d.]+) a record\): the records' bytes=(\d+) \(([\d.]+)\) the loop=(\d+) \(([\d.]+)\) an expression's part=(\d+) \(([\d.]+)\) the tests on T's records=(\d+) \(([\d.]+)\); T again for them, not counted=(\d+)")
def rows(label, tag, c):
    out = {}
    for f in sorted(glob.glob(f'{root}/{label}/{tag}-{c}-*.txt')):
        t = open(f).read()
        if 'status 0' not in t.splitlines()[-1] and 'status 0' not in t[-200:]: print('PROBLEM: status', f)
        m0 = re.search(r"window tests expressions=(\d+) records=(\d+) differences=(\d+)", t)
        m = LINE.search(t)
        if not (m0 and m): print('PROBLEM: no line', f); continue
        recs = int(m0.group(2))
        out.setdefault('differences', []).append(int(m0.group(3)))
        for k, i in (('all', 1), ('bytes', 3), ('loop', 5), ('part', 7), ('rest', 9), ('again', 11)):
            out.setdefault(k, []).append(int(m.group(i)) / recs)
        q = re.search(r"operators-left-out-for-quiet-constants=(\d+) checked=(\d+) of-them-with-a-test=(\d+)", t)
        if q: out.setdefault('quiet', []).append((int(q.group(1)), int(q.group(2)), int(q.group(3))))
        o = re.search(r"own tests listed tree=(\d+) \([\d.]+%\) operators=(\d+)", t)
        if o: out.setdefault('operators', []).append(int(o.group(2)))
    return out
for tags in (('window-tests', f'vs-{head}'), ('window-tests-wall', f'vs-{head}-wall'), ('window-tests-verify', f'vs-{head}-verify')):
    print('##', tags[0])
    for c in ('sqlite3', 'lua', 'musl'):
        for label, tag in ((base, tags[1]), (head, tags[0])):
            r = rows(label, tag, c)
            if not r: continue
            print(f"  {c} {label}: " + ', '.join(f"{k} {med(v):.2f}" for k, v in r.items() if k in ('all', 'bytes', 'loop', 'part', 'rest', 'again')) +
                  f"; differences {sorted(set(r['differences']))}; operators {sorted(set(r.get('operators', [])))}; quiet {sorted(set(r.get('quiet', [])))}; all: {[round(x, 1) for x in r['all']]}")
print('## the window without the tests')
for c in ('sqlite3', 'lua', 'musl'):
    for label, tag in ((base, f'vs-{head}-window'), (head, 'window')):
        k, fr, nm = [], [], []
        for f in sorted(glob.glob(f'{root}/{label}/{tag}-{c}-*.txt')):
            t = open(f).read()
            m = re.search(r'the kernel in place: .* ticks=(\d+) \(([\d.]+) a record\)', t)
            if m: k.append(float(m.group(2)))
            m = re.search(r'the front with the window: ticks=(\d+) records=(\d+);', t)
            if m: fr.append(int(m.group(1)) / int(m.group(2)))
            m = re.search(r"the names' pass: names=(\d+) ticks=(\d+)", t)
            if m: nm.append(int(m.group(2)) / int(m.group(1)))
        print(f"  {c} {label}: the kernel in place {med(k):.2f} {k}; the front {med(fr):.2f} {[round(x, 2) for x in fr]}; the names' pass {med(nm):.2f} {[round(x, 2) for x in nm]}")
print('## -c sqlite3.c')
for f in sorted(glob.glob(f'{root}/{head}/compile-*.txt')):
    for l in open(f).read().splitlines():
        if 'median' in l: print('  ', f.split('/')[-1], l.strip()[:160])
