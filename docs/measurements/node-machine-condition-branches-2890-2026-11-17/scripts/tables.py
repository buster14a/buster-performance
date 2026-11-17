#!/usr/bin/env python3
# tables.py RESULTS: #2890's 9700X job's tables, from job.sh's files (RESULTS/base, RESULTS/cond): what the machine takes
# and the shadow's sweeps after the pipeline, base against cond; T, C and X at reader time; the fused sweep; the census's
# own reports; and the whole compile.
import re, sys, glob, statistics, os
root = sys.argv[1]
def readings(label, tag, corpus):
    return sorted(glob.glob(f'{root}/{label}/{tag}-{corpus}-[0-9]*.txt'), key=lambda f: int(re.search(r'-(\d+)\.txt$', f).group(1)))
def text(f):
    return open(f, errors='replace').read()
bad = []
def status(f, t):
    if not re.search(r'^status 0$', t, re.M): bad.append((f, 'status'))
corpora = ('sqlite3', 'lua', 'musl')
print('## What the machine takes, and the shadow\'s sweeps after the pipeline (medians of the readings)')
for corpus in corpora:
    for label in ('base', 'cond'):
        d = {}; taken = None; n = 0
        for f in readings(label, 'shadow', corpus):
            t = text(f); status(f, t); n += 1
            for m in re.finditer(r'node-shadow: time sweeps=(\S+) passes=\d+ repeat=\d+ cycles=(\d+) instructions=(\d+) ticks=\d+ per-evaluated-node: cycles=([\d.]+) instructions=([\d.]+) ticks=([\d.]+)', t):
                d.setdefault(m.group(1), []).append((float(m.group(4)), float(m.group(5)), int(m.group(2)), int(m.group(3))))
            if not re.search(r'node-shadow: differences values=0 entries=0 twin=0', t): bad.append((f, 'shadow differences'))
            m = re.search(r'node-shadow: census-taken expressions=(\d+) evaluated-nodes=(\d+)', t)
            c = m.groups()
            m = re.search(r'node-shadow: machine-taken expressions=(\d+) \(([\d.]+)%\) evaluated-nodes=(\d+) \(([\d.]+)%\) records=(\d+) entries=(\d+)', t)
            taken = (c, m.groups())
            r = re.findall(r'node-shadow: refused=(\S+) expressions=(\d+) evaluated-nodes=(\d+)', t)
        print(f'{corpus} {label} n={n}: census {taken[0][0]} expressions {taken[0][1]} nodes; machine {taken[1][0]} ({taken[1][1]}%) expressions, {taken[1][2]} ({taken[1][3]}%) nodes, {taken[1][4]} records, {taken[1][5]} entries')
        print('   refused: ' + ', '.join(f'{k} {e} expr {nodes} nodes' for k, e, nodes in r if int(e) != 0))
        print('   ' + ' | '.join(f'{k}: cycles {statistics.median(x[0] for x in v):.1f} instructions {statistics.median(x[1] for x in v):.1f} a node; a unit {statistics.median(x[2] for x in v) / 1e6:.2f} M cycles' for k, v in d.items()))
print('\n## T, C and X at reader time (--front-sweeps --front-lean): ticks (medians), and what they compare')
for corpus in corpora:
    for label in ('base', 'cond'):
        ticks = []; line = None; swept = None; n = 0; refused = None
        for f in readings(label, 'sweeps-lean', corpus):
            t = text(f); status(f, t); n += 1
            m = re.search(r'node-shadow: reader-time T expressions=(\d+) records=(\d+) typed=(\d+) taken=(\d+) .* ticks=(\d+) setup-ticks=(\d+)', t)
            ticks.append(int(m.group(5))); line = m.groups()
            for l in t.splitlines():
                if l.startswith('node-shadow: reader-time C and X') or l.startswith('node-shadow: reader-time sweeps'):
                    swept = (swept or []) + [l] if n == 1 else swept
            if not re.search(r'node-shadow: reader-time T .*differences=0 \(range 0, refusal 0\)', t): bad.append((f, 'reader-time T differs'))
        if n:
            print(f'{corpus} {label} n={n}: T, C and X ticks {statistics.median(ticks)} ({statistics.median(ticks) / int(line[1]):.1f} a record of {line[1]}; expressions {line[0]}, taken by T {line[3]})')
            for l in swept or []: print('   ' + l[:400])
print('\n## The fused sweep (cond)')
for corpus in corpora:
    for f in readings('cond', 'fused', corpus):
        t = text(f); status(f, t)
        for l in t.splitlines():
            if 'fused' in l and ('time' in l or 'differ' in l): print(corpus, l[:330])
print('\n## The census\'s own reports, base against cond')
for corpus in corpora:
    for tag in ('census', 'census-wall'):
        a = readings('base', tag, corpus); b = readings('cond', tag, corpus)
        if a and b:
            ta = [l for l in text(a[0]).splitlines() if l.startswith('node-census')]; tb = [l for l in text(b[0]).splitlines() if l.startswith('node-census')]
            print(corpus, tag, 'lines', len(ta), len(tb), 'SAME' if ta == tb else 'DIFFERENT')
            if ta != tb: bad.append((b[0], 'census report differs'))
        else: print(corpus, tag, 'missing', len(a), len(b))
print('\n## -c sqlite3.c, base against cond (head)')
for f in sorted(glob.glob(f'{root}/cond/compile-*.txt')):
    t = text(f)
    d = {}
    for m in re.finditer(r'run \d+ list 1 (\S+) copy \d+: ([\d.]+) ms wall, .* (\d+) user cycles, (\d+) instructions, status (\d+)', t):
        d.setdefault(m.group(1), []).append((float(m.group(2)), int(m.group(3)), int(m.group(4)), int(m.group(5))))
    for k, v in d.items():
        print(os.path.basename(f), k, len(v), 'wall', statistics.median(x[0] for x in v), 'cycles', statistics.median(x[1] for x in v), 'instructions', statistics.median(x[2] for x in v), 'failed', sum(1 for x in v if x[3] != 0))
    for k in ('head', 'base-again'):
        if k in d and 'base' in d:
            w = statistics.median(x[0] for x in d[k]) / statistics.median(x[0] for x in d['base']) - 1
            c = statistics.median(x[1] for x in d[k]) / statistics.median(x[1] for x in d['base']) - 1
            print(f'    {k} against base: wall {100 * w:+.2f}% user cycles {100 * c:+.2f}%')
print('\nBAD:', bad if bad else 'none')
