#!/usr/bin/env python3
# tables.py RESULTS LABEL [BASE]: the tests on the window from job-tests.sh's files (results/LABEL and results/BASE,
# default base).
#   1. The window's tests' ticks a record (medians over the readings in turn; every reading listed), by sweep.
#   2. The own form at the base, by its sets: T, C and X; with the own form; the difference.
#   3. The counts (every reading must give the same), with every warning and beside T checking itself.
#   4. The window without the tests, base against LABEL: the kernel's, the front's and the names' pass's ticks.
#   5. -c sqlite3.c as whole processes.
import re, sys, glob, statistics
root, label = sys.argv[1], sys.argv[2]
base = sys.argv[3] if len(sys.argv) > 3 else 'base'
def readings(lab, tag, corpus):
    return sorted(glob.glob(f'{root}/{lab}/{tag}-{corpus}-[0-9]*.txt'), key=lambda f: int(re.search(r'-(\d+)\.txt$', f).group(1)))
def text(f):
    return open(f, errors='replace').read()
bad = []
def check(f, t):
    if not re.search(r'^status 0$', t, re.M): bad.append((f, 'status'))
    for value in re.findall(r'(?:differences|walks-of-another-count|taken-there-and-refused-by-the-census)=(\d+)', t):
        if int(value) != 0: bad.append((f, 'difference'))
def med(v):
    return statistics.median(v) if v else float('nan')
corpora = ('sqlite3', 'lua', 'musl')
print('## 1. The tests on the window: TSC ticks a record of the expressions they ran on (medians; then every reading)')
parts = ('all', "the records' bytes", 'the loop', "an expression's part", "the tests on T's records", 'T again, not counted')
for tag in ('window-tests', 'window-tests-wall', 'window-tests-verify'):
    for corpus in corpora:
        rows = []
        for f in readings(label, tag, corpus):
            t = text(f); check(f, t)
            m = re.search(r"window tests ticks=(\d+) \(([\d.]+) a record\): the records' bytes=(\d+) \(([\d.]+)\) the loop=(\d+) \(([\d.]+)\) an expression's part=(\d+) \(([\d.]+)\) the tests on T's records=(\d+) \(([\d.]+)\); T again for them, not counted=(\d+) \(([\d.]+)\)", t)
            e = re.search(r'window tests expressions=(\d+) records=(\d+) differences=(\d+)', t)
            typed = re.search(r'reader-time T expressions=(\d+) records=(\d+) typed=(\d+)', t)
            rows.append(([float(m.group(i)) for i in (2, 4, 6, 8, 10, 12)], int(m.group(1)), int(e.group(2)), int(typed.group(3))))
        if not rows: continue
        print(f'{tag} {corpus} (n={len(rows)}; records {rows[0][2]}, T typed {rows[0][3]}):')
        for k, name in enumerate(parts):
            v = [r[0][k] for r in rows]
            print(f'   {name}: {med(v):.2f}  {[round(x, 2) for x in v]}')
        print(f'   all, a record T typed: {med([r[1] / r[3] for r in rows]):.2f}')
print('\n## 2. The own form at the base: ticks a record T typed (medians), by its sets')
for corpus in corpora:
    row = {}
    for tag in ('sweeps', 'own'):
        v = []
        for f in readings(base, tag, corpus):
            t = text(f); check(f, t)
            m = re.search(r'reader-time T expressions=(\d+) records=(\d+) typed=(\d+) taken=(\d+) .*ticks=(\d+) setup-ticks=(\d+)', t)
            v.append(int(m.group(5)) / int(m.group(3)))
        row[tag] = v
    if row['sweeps'] and row['own']:
        print(f"{corpus}: T, C and X {med(row['sweeps']):.1f} {[round(x, 1) for x in row['sweeps']]}; with the own form {med(row['own']):.1f} {[round(x, 1) for x in row['own']]}; the own form alone {med(row['own']) - med(row['sweeps']):.1f}")
print('\n## 3. Counts')
for tag in ('window-tests', 'window-tests-wall', 'window-tests-verify'):
    for corpus in corpora:
        lines = None
        for f in readings(label, tag, corpus):
            t = text(f)
            keep = [re.sub(r'ticks=.*', '', l) for l in t.splitlines() if l.startswith('node-shadow: window tests expr') or l.startswith('node-shadow: own tests') or l.startswith('node-shadow: reader-time verify')]
            if lines is None: lines = keep
            elif keep != lines: bad.append((f, 'counts differ between readings'))
        if lines:
            print('---', tag, corpus)
            for l in lines: print('  ', l[:300])
print('\n## 4. The window without the tests, the base against the piece: ticks a record of the windows (medians)')
for corpus in corpora:
    for lab in (base, label):
        k, fr, nm = [], [], []
        for f in readings(lab, 'window', corpus):
            t = text(f); check(f, t)
            m = re.search(r'the kernel in place: .* ticks=(\d+) \(([\d.]+) a record\)', t)
            if m: k.append(float(m.group(2)))
            m = re.search(r'the front with the window: ticks=(\d+) records=(\d+);', t)
            if m: fr.append(int(m.group(1)) / int(m.group(2)))
            m = re.search(r"the names' pass: names=(\d+) ticks=(\d+)", t)
            if m: nm.append(int(m.group(2)) / int(m.group(1)))
        print(f'{corpus} {lab}: the kernel in place {med(k):.2f} {k}; the front, a record {med(fr):.2f} {[round(x, 2) for x in fr]}; the names\' pass, a name {med(nm):.2f} {[round(x, 2) for x in nm]}')
print('\n## 5. -c sqlite3.c as whole processes')
for f in sorted(glob.glob(f'{root}/{label}/compile-*.txt')):
    t = text(f)
    if not re.search(r'^status 0$', t, re.M): bad.append((f, 'status'))
    for l in t.splitlines():
        if re.match(r'\s*(base|head|base-again)\b', l) or 'median' in l or 'against' in l: print('  ', f.split('/')[-1], l[:200])
print('\nPROBLEMS:' if bad else '\nno problems:', bad if bad else 'every run exited 0 and no difference was counted')
