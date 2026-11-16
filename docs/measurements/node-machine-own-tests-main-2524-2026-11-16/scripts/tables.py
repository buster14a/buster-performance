#!/usr/bin/env python3
# tables3.py RESULTS: the tests in the machine's own form on today's main, from job3.sh's files: the ticks a record T
# typed at reader time (medians over the readings in turn) for T, C and X, with the census's code and with the own form;
# the own form beside the census's code; the shadow's own sweeps, #2850's kernels, the census's reports and the whole
# compile, head2 (buster#2887's head) against own.
import re, sys, glob, statistics, os
root = sys.argv[1]
def readings(label, tag, corpus):
    return sorted(glob.glob(f'{root}/{label}/{tag}-{corpus}-[0-9]*.txt'), key=lambda f: int(re.search(r'-(\d+)\.txt$', f).group(1)))
def text(f):
    return open(f, errors='replace').read()
bad = []
def status(f, t):
    if not re.search(r'^status 0$', t, re.M):
        bad.append((f, 'status'))
def zero(f, t):
    for value in re.findall(r'(?:differences|taken-there-and-refused-by-the-census|walks-of-another-count)=(\d+)', t):
        if int(value) != 0: bad.append((f, 'difference'))
print('## At reader time: ticks a record T typed (medians), and the readings')
for corpus in ('sqlite3', 'lua', 'musl'):
    row = {}
    for label, tag in (('head2', 'sweeps3'), ('own', 'sweeps'), ('own', 'tests'), ('own', 'own')):
        v = []
        for f in readings(label, tag, corpus):
            t = text(f); status(f, t); zero(f, t)
            m = re.search(r'reader-time T expressions=(\d+) records=(\d+) typed=(\d+) taken=(\d+) .*ticks=(\d+) setup-ticks=(\d+)', t)
            v.append(int(m.group(5)) / int(m.group(3)))
        row[(label, tag)] = (statistics.median(v), len(v), min(v), max(v))
    print(corpus, ' | '.join(f'{k[0]} {k[1]}: {v[0]:.1f} (n={v[1]}, {v[2]:.1f} to {v[3]:.1f})' for k, v in row.items()))
    sweeps = row[('own', 'sweeps')][0]
    print(f'   the census\'s code alone (tests less sweeps): {row[("own","tests")][0] - sweeps:.1f}; the own form alone (own less sweeps): {row[("own","own")][0] - sweeps:.1f}')
    for f in readings('own', 'own-last', corpus):
        t = text(f); status(f, t); zero(f, t)
        m = re.search(r'reader-time T expressions=(\d+) records=(\d+) typed=(\d+) taken=(\d+) .*ticks=(\d+) setup-ticks=(\d+)', t)
        print(f'   the own form after C and X, one reading: {int(m.group(5)) / int(m.group(3)):.1f}')
print('\n## Counts (every reading of own own must give the same)')
for corpus in ('sqlite3', 'lua', 'musl'):
    lines = None
    for f in readings('own', 'own', corpus):
        t = text(f)
        keep = [re.sub(r'ticks=\d+ setup-ticks=\d+', '', l) for l in t.splitlines() if l.startswith('node-shadow: reader-time') or l.startswith('node-shadow: own tests') or l.startswith('node-shadow: differences')]
        if lines is None: lines = keep
        elif keep != lines: bad.append((f, 'counts differ between readings'))
    print('---', corpus)
    for l in lines: print('  ', l[:330])
for tag in ('own-verify', 'own-verify-wall'):
    print(f'\n## {tag} (one reading): the own form beside the census\'s code')
    for corpus in ('sqlite3', 'lua', 'musl'):
        for f in readings('own', tag, corpus):
            t = text(f); status(f, t); zero(f, t)
            for l in t.splitlines():
                if re.match(r'node-shadow: (own tests|reader-time (tests (expressions|compared)|verify))', l):
                    print('  ', corpus, l[:330])
print('\n## The shadow\'s own sweeps after the pipeline, head2 against own: cycles and instructions an evaluated node (medians)')
for corpus in ('sqlite3', 'lua', 'musl'):
    for label, tag in (('head2', 'shadow3'), ('own', 'shadow')):
        d = {}
        for f in readings(label, tag, corpus):
            t = text(f); status(f, t)
            for m in re.finditer(r'node-shadow: time sweeps=(\S+) passes=\d+ repeat=\d+ cycles=\d+ instructions=\d+ ticks=\d+ per-evaluated-node: cycles=([\d.]+) instructions=([\d.]+) ticks=([\d.]+)', t):
                d.setdefault(m.group(1), []).append((float(m.group(2)), float(m.group(3))))
            if not re.search(r'node-shadow: differences values=0 entries=0 twin=0', t): bad.append((f, 'shadow differences'))
        print(corpus, label, ' | '.join(f'{k}: cycles {statistics.median(x[0] for x in v):.1f} {[x[0] for x in v]} instructions {statistics.median(x[1] for x in v):.1f}' for k, v in d.items()))
print('\n## #2850\'s kernels with the operators, the first pass\'s cycles a record of the windows (medians)')
for corpus in ('sqlite3', 'musl'):
    out = []
    for label, tag in (('head2', 'facts-operators3'), ('own', 'facts-operators')):
        v, ins = [], []
        for f in readings(label, tag, corpus):
            t = text(f); status(f, t)
            m = re.search(r'the two passes, a record of the windows: the given records put in place and the kernel: cycles=([\d.]+) instructions=([\d.]+) ticks=([\d.]+); the given records alone: cycles=([\d.]+)', t)
            if m: v.append(float(m.group(1))); ins.append(float(m.group(2)))
            if not re.search(r'node-facts: taken .* differences=0 list-differences=0 failures=0', t): bad.append((f, 'facts differences'))
        if v: out.append(f'{label} {statistics.median(v):.2f} {v} instructions {statistics.median(ins):.2f}')
    print(corpus, ' | '.join(out))
print('\n## The census\'s own reports, head2 against own')
for corpus in ('sqlite3', 'lua', 'musl'):
    for tag in ('census', 'census-wall'):
        a = readings('head2', tag, corpus); b = readings('own', tag, corpus)
        if a and b:
            ta = [l for l in text(a[0]).splitlines() if l.startswith('node-census')]; tb = [l for l in text(b[0]).splitlines() if l.startswith('node-census')]
            status(a[0], text(a[0])); status(b[0], text(b[0]))
            print(corpus, tag, 'lines', len(ta), len(tb), 'SAME' if ta == tb else 'DIFFERENT')
            if ta != tb: bad.append((b[0], 'census report differs'))
        else:
            print(corpus, tag, 'missing', len(a), len(b))
print('\n## -c sqlite3.c, head2 against own')
for f in sorted(glob.glob(f'{root}/own/compile-*.txt')):
    t = text(f)
    d = {}
    for m in re.finditer(r'run \d+ list 1 (\S+) copy \d+: ([\d.]+) ms wall, .* (\d+) user cycles, (\d+) instructions, status (\d+)', t):
        d.setdefault(m.group(1), []).append((float(m.group(2)), int(m.group(3)), int(m.group(4)), int(m.group(5))))
    for k, v in d.items():
        print(os.path.basename(f), k, len(v), 'wall', statistics.median(x[0] for x in v), 'cycles', statistics.median(x[1] for x in v), 'instructions', statistics.median(x[2] for x in v), 'failed', sum(1 for x in v if x[3] != 0))
    for l in t.splitlines():
        if 'against base' in l: print('   ', l.strip()[:160])
print('\nBAD:', bad if bad else 'none')
