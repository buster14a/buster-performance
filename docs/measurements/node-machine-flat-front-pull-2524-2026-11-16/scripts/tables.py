#!/usr/bin/env python3
# tables4.py RESULTS OWN_RESULTS: the front by passes on today's main, from job4.sh's files: the fronts' ticks before the
# walk (medians, ms at the TSC's 3792.9 MHz) with each one's compaction, the comparison of the two fronts in every run,
# the shadow's own sweeps and the census's reports base against flat, and the whole compile.
import re, sys, glob, statistics, os
root, own_root = sys.argv[1], sys.argv[2]
mhz = 3792.9
def readings(base, label, tag, corpus):
    return sorted(glob.glob(f'{base}/{label}/{tag}-{corpus}-[0-9]*.txt'), key=lambda f: int(re.search(r'-(\d+)\.txt$', f).group(1)))
def text(f):
    return open(f, errors='replace').read()
bad = []
def status(f, t):
    if not re.search(r'^status 0$', t, re.M): bad.append((f, 'status'))
def ms(v): return statistics.median(v) / mhz / 1000
print('## The fronts before the walk, ms (medians), each with its compaction')
for corpus in ('sqlite3', 'lua', 'musl'):
    lean, lean_compact, flat, flat_compact, stages = [], [], [], [], {}
    for f in readings(root, 'flat', 'leanfirst', corpus):
        t = text(f); status(f, t)
        lean.append(int(re.search(r'node-shadow: front ticks=(\d+)', t).group(1)))
        lean_compact.append(int(re.search(r'node-shadow: walk prepare ticks compact=(\d+)', t).group(1)))
        if not re.search(r'node-shadow: front before-the-walk lean .* differences=0 ', t): bad.append((f, 'lean front differs from the walk'))
    for f in readings(root, 'flat', 'flatfirst', corpus):
        t = text(f); status(f, t)
        m = re.search(r'node-shadow: flat front ticks=(\d+) compact-ticks=(\d+)', t)
        flat.append(int(m.group(1))); flat_compact.append(int(m.group(2)))
        m = re.search(r'node-shadow: flat front stage ticks classify=(\d+) leaves=(\d+) places=(\d+) records=(\d+) empties=(\d+)', t)
        for name, value in zip(['classify', 'leaves', 'places', 'records', 'empties'], m.groups()): stages.setdefault(name, []).append(int(value))
        m = re.search(r'node-shadow: flat front against the lean front: compared=(\d+) differences=(\d+) only-the-flat-front\'s=(\d+) only-the-lean-front\'s=(\d+)', t)
        if int(m.group(2)) != 0 or int(m.group(3)) != 0: bad.append((f, 'fronts differ'))
        counts = m.group(0)
    a = ms(lean) + ms(lean_compact); b = ms(flat) + ms(flat_compact)
    print(f'{corpus}: lean {ms(lean):.3f} + {ms(lean_compact):.3f} = {a:.3f} (n={len(lean)}) | flat {ms(flat):.3f} + {ms(flat_compact):.3f} = {b:.3f} (n={len(flat)}) | lean/flat {a / b:.2f}')
    print('   stages: ' + ', '.join(f'{k} {ms(v):.3f}' for k, v in stages.items()))
    print('   ' + counts)
    after = []
    for f in readings(root, 'flat', 'flat', corpus):
        t = text(f); status(f, t)
        m = re.search(r'node-shadow: flat front ticks=(\d+) compact-ticks=(\d+)', t)
        after.append(int(m.group(1)))
        m = re.search(r'node-shadow: flat front against the lean front: compared=(\d+) differences=(\d+) only-the-flat-front\'s=(\d+)', t)
        if int(m.group(2)) != 0 or int(m.group(3)) != 0: bad.append((f, 'fronts differ'))
    print(f'   the flat front after the walk: {ms(after):.3f} (n={len(after)})')
print('\n## The shadow\'s own sweeps after the pipeline, base against flat: cycles and instructions an evaluated node (medians)')
for corpus in ('sqlite3', 'lua', 'musl'):
    for base, label, tag in ((own_root, 'base', 'shadow'), (root, 'flat', 'shadow')):
        d = {}
        for f in readings(base, label, tag, corpus):
            t = text(f); status(f, t)
            for m in re.finditer(r'node-shadow: time sweeps=(\S+) passes=\d+ repeat=\d+ cycles=\d+ instructions=\d+ ticks=\d+ per-evaluated-node: cycles=([\d.]+) instructions=([\d.]+) ticks=([\d.]+)', t):
                d.setdefault(m.group(1), []).append((float(m.group(2)), float(m.group(3))))
            if not re.search(r'node-shadow: differences values=0 entries=0 twin=0', t): bad.append((f, 'shadow differences'))
        print(corpus, label, ' | '.join(f'{k}: cycles {statistics.median(x[0] for x in v):.1f} instructions {statistics.median(x[1] for x in v):.1f}' for k, v in d.items()))
print('\n## The census\'s own reports, base against flat')
for corpus in ('sqlite3', 'lua', 'musl'):
    for tag in ('census', 'census-wall'):
        a = readings(own_root, 'base', tag, corpus); b = readings(root, 'flat', tag, corpus)
        if a and b:
            ta = [l for l in text(a[0]).splitlines() if l.startswith('node-census')]; tb = [l for l in text(b[0]).splitlines() if l.startswith('node-census')]
            print(corpus, tag, 'lines', len(ta), len(tb), 'SAME' if ta == tb else 'DIFFERENT')
            if ta != tb: bad.append((b[0], 'census report differs'))
        else: print(corpus, tag, 'missing', len(a), len(b))
print('\n## -c sqlite3.c, base against flat')
for f in sorted(glob.glob(f'{root}/flat/compile-*.txt')):
    t = text(f)
    d = {}
    for m in re.finditer(r'run \d+ list 1 (\S+) copy \d+: ([\d.]+) ms wall, .* (\d+) user cycles, (\d+) instructions, status (\d+)', t):
        d.setdefault(m.group(1), []).append((float(m.group(2)), int(m.group(3)), int(m.group(4)), int(m.group(5))))
    for k, v in d.items():
        print(os.path.basename(f), k, len(v), 'wall', statistics.median(x[0] for x in v), 'cycles', statistics.median(x[1] for x in v), 'instructions', statistics.median(x[2] for x in v), 'failed', sum(1 for x in v if x[3] != 0))
    for l in t.splitlines():
        if 'against base' in l: print('   ', l.strip()[:160])
print('\nBAD:', bad if bad else 'none')
