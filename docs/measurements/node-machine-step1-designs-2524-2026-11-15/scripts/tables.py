#!/usr/bin/env python3
# tables.py [RESULTS]: the README's tables from the time files under RESULTS (results/9700x in the record, results on
# the 9700X). A row is a build's runs of some tags and rounds with --repeat 1: each set's median cycles and instructions
# a taken node. An interleaved set less the walk is the difference of the two medians; the sweeps' own time there is
# their TSC ticks inside the set at the tight set's cycles a tick.
import sys, re, glob, os, fnmatch, statistics, collections
base = sys.argv[1] if len(sys.argv) > 1 else ('results/9700x' if os.path.isdir('results/9700x') else 'results')
time_line = re.compile(r'time sweeps=(\S+) passes=\d+ repeat=(\d+) .*per-evaluated-node: cycles=([0-9.]+) instructions=([0-9.]+) ticks=([0-9.]+)')
inner_line = re.compile(r"interleaved sweeps=(\S+) chunk=\d+ .*per-evaluated-node: ticks=([0-9.]+)")
corpora = ('sqlite3', 'lua', 'musl')

def runs(label, corpus, tags='*', rounds=None, repeat=1):
    sets, inner = collections.OrderedDict(), collections.OrderedDict()
    for path in sorted(glob.glob(f'{base}/{label}/time-*-{corpus}-r*.txt')):
        m = re.search(r'/time-([a-z0-9]+)-' + corpus + r'-r(\d+)\.txt$', path)
        if m is None or not any(fnmatch.fnmatch(m.group(1), t) for t in tags.split(',')) or (rounds is not None and int(m.group(2)) not in rounds):
            continue
        for line in open(path):
            t = time_line.search(line)
            if t and int(t.group(2)) == repeat:
                sets.setdefault(t.group(1), []).append((float(t.group(3)), float(t.group(4)), float(t.group(5))))
            i = inner_line.search(line)
            if i:
                inner.setdefault(i.group(1), []).append(float(i.group(2)))
    return sets, inner

def median(sets, name, field=0):
    return statistics.median(v[field] for v in sets[name]) if name in sets else float('nan')

def percent(new, old):
    return '%+.1f%%' % (100.0 * (new / old - 1.0))

def tight(title, rows):
    print('==', title)
    for name, label, tags, rounds in rows:
        for corpus in corpora:
            sets, _ = runs(label, corpus, tags, rounds)
            names = [n for n in sets if not n.startswith('walk')]
            if names:
                line = '  '.join('%s %.1f, %.1f' % (n, median(sets, n), median(sets, n, 1)) for n in names)
                if 'T+CX' in sets:
                    line += '  | one sweep ' + percent(median(sets, 'T+CX'), median(sets, 'T+C+X'))
                print(f'{name:22} {corpus:8} ({len(sets[names[0]])} runs) {line}')

def interleaved(title, rows, chunks):
    print('==', title)
    for name, label, pattern, rounds in rows:
        for corpus in corpora:
            for chunk in chunks:
                sets, inner = runs(label, corpus, pattern.replace('N', chunk), rounds)
                if 'walk' not in sets:
                    continue
                walk = median(sets, 'walk')
                out, values = [f'{name:10} {corpus:8} chunk {chunk:>3}: walk {walk:.1f} ({median(sets, "walk", 1):.1f} instr) |'], {}
                for s in ('T+C+X', 'T+CX', 'Tv+CX'):
                    pair = 'walk;' + s
                    if pair in sets:
                        less = median(sets, pair) - walk
                        own = statistics.median(inner[pair]) / median(sets, s, 2) * median(sets, s) if pair in inner else float('nan')
                        values[s] = (less, own)
                        out.append(f' {s}: tight {median(sets, s):.1f}, pair {median(sets, pair):.1f} ({median(sets, pair, 1):.1f} instr), less walk {less:.1f}, own {own:.1f};')
                if 'T+C+X' in values and 'T+CX' in values:
                    out.append(' one sweep: less walk %s, own %s' % (percent(values['T+CX'][0], values['T+C+X'][0]), percent(values['T+CX'][1], values['T+C+X'][1])))
                print(''.join(out))

tight('the exploration\'s builds (jobs 1 to 6; the sets in turn inside a pass)', [(l, l, '*', None) for l in ('s1', 's2', 's3', 's4', 's5', 's6')])
tight('main by job (the sets in turn inside a pass)', [(f'm5 job {j}', 'm5', 'base*', r) for j, r in ((7, (1, 2, 3)), (8, (4, 5, 6)), (9, (7, 8, 9)), (10, (10, 11, 12)), (11, (13, 14, 15)))])
tight('jobs 7 to 9 (the sets in turn inside a pass)', [('p1 job 7', 'p1', 'i*', None), ('p2 job 8', 'p2', 'i*', (4, 5, 6)), ('m6 job 9', 'm6', '*', None), ('p3 job 9', 'p3', '*', None)])
tight('job 10: p2 (the sets in turn) and p4 (a set\'s passes in a row), by option', [('p2 no option', 'p2', 'jn', None), ('p2 --fused --interleave 1', 'p2', 'ji1', None), ('p4 no option', 'p4', 'n', (10, 11, 12)), ('p4 --fused', 'p4', 'f', (10, 11, 12)), ('p4 --interleave 1', 'p4', 'i1', None), ('p4 --interleave 16', 'p4', 'i16', None), ('p4 --interleave 0', 'p4', 'i0', None), ('p4 --interleave 256', 'p4', 'i256', None), ('p4 every run', 'p4', '*', (10, 11, 12))])
tight('job 11: main as it times (m5), main with a set\'s passes in a row (m7), p4 --fused', [('m5', 'm5', 'base', (13, 14, 15)), ('m7', 'm7', 'n', None), ('p4 --fused', 'p4', 'f', (13, 14, 15))])
print('== --repeat 2: both runs\' cycles, then the second run alone (less the --repeat 1 median)')
for label in ('s1', 's2', 's3'):
    for corpus in corpora:
        twice, _ = runs(label, corpus, repeat=2)
        once, _ = runs(label, corpus)
        if twice:
            print(f'{label} {corpus:8}', '  '.join('%s %.1f, second %.1f' % (n, median(twice, n), median(twice, n) - median(once, n)) for n in twice))
interleaved('interleaved, the sets in turn inside a pass (jobs 5 to 9)', [('s5', 's5', 'fli', None)], ('1',))
interleaved('', [('s6', 's6', 'iN', None), ('p1', 'p1', 'iN', None), ('p2 job 8', 'p2', 'iN', (4, 5, 6)), ('p3', 'p3', 'iN', None)], ('1', '4', '16', '64', '0', '256'))
interleaved('interleaved, a set\'s passes in a row (job 10)', [('p2 turns', 'p2', 'jiN', None), ('p4', 'p4', 'iN', None)], ('1', '16', '0', '256'))
