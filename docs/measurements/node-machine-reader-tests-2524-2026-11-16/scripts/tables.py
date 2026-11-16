#!/usr/bin/env python3
# tables.py [RESULTS]: the README's tables from the result files (default: ../results/9700x beside this script). z3 is
# the pull request's sources but for two lines of a test's fixture, and w2 its parent's (C and X where they sit, at the
# same main); z0, z1 and z2 are the builds of section 4. Ticks at 3,792.9 MHz.
import sys, os, re, glob, statistics
root = sys.argv[1] if len(sys.argv) > 1 else os.path.join(os.path.dirname(os.path.abspath(__file__)), '..', 'results', '9700x')
head = 'z3'
base = 'w2'
MHZ = 3792.9
READER = r'reader-time T expressions=(\d+) records=(\d+) typed=(\d+) taken=(\d+) roots-not-run=(\d+) late-types=(\d+) ticks=(\d+) setup-ticks=(\d+)'
TYPED = r"reader-time T lowered=(\d+) \([0-9.]+%\) never-lowered=(\d+) \(taken (\d+), context (\d+); of them in a lowered body: taken (\d+), context (\d+)\) declarations'-discards-not-run=(\d+) compared=(\d+) \(records (\d+)\) differences=(\d+)"
TESTED = r'reader-time tests expressions=(\d+) refused=(\d+) nodes-outside-the-records=(\d+) units-whose-enabled-warnings-differ=(\d+)'
BY_TEST = r'reader-time tests refused test=(\S+) expressions=(\d+) first=(\d+)'
COMPARED = r"reader-time tests compared=(\d+) never-lowered=(\d+) taken-there=(\d+) \(nodes (\d+)\) taken-there-and-refused-by-the-census=(\d+) \(for the lowering's facts alone (\d+)\) differences=(\d+) root-kind-differences=(\d+) refused-by-the-census=(\d+) \(of them past C and X (\d+), nodes (\d+)\)"
ALONE = r'reader-time tests test=(\S+) reader-alone=(\d+) census-alone=(\d+)'
VERIFY = r"reader-time verify nodes-whose-value-is-not-the-action's=(\d+) nodes-whose-action-warns=(\d+)"
SWEPT = r"reader-time C and X compared=(\d+) \(entries (\d+)\) differences=(\d+)"
TAKEN = r'machine-taken expressions=(\d+) \([0-9.]+%\) evaluated-nodes=(\d+) \([0-9.]+%\) records=(\d+)'
def sweep(name):
    return r'time sweeps=%s passes=\d+ repeat=\d+ cycles=(\d+) instructions=(\d+) ticks=(\d+) ' % re.escape(name)
def files_of(label, tag, corpus, suffix):
    return sorted(glob.glob(os.path.join(root, label, 'types-%s-%s%s-*.txt' % (tag, corpus, suffix))))
def fields(path, rx):
    for line in open(path, errors='replace'):
        m = re.search(rx, line)
        if m:
            return [float(g) if re.fullmatch(r'[0-9.]+', g) else g for g in m.groups()]
    return None
def every(path, rx):
    return [m.groups() for m in (re.search(rx, line) for line in open(path, errors='replace')) if m]
def median(values):
    return statistics.median(values) if values else float('nan')
def ok(path):
    return open(path, errors='replace').read().rstrip().endswith('status 0')
corpora = ['sqlite3', 'lua', 'musl']

print('== 1. The tests at reader time and the census after the pipeline (%s, the first run of each): the default warnings, every warning with --verify, and the lean front' % head)
for tag, suffix in [('tests', '-f'), ('walltests', '-wall'), ('verifytests', '-wall'), ('leantests', '-f')]:
    for corpus in corpora:
        paths = files_of(head, tag, corpus, suffix)
        if not paths:
            continue
        p = paths[0]
        r = fields(p, READER); t = fields(p, TYPED); e = fields(p, TESTED); c = fields(p, COMPARED); v = fields(p, VERIFY); x = fields(p, SWEPT)
        by = ', '.join('%s %s' % (name, count) for name, count, first in every(p, BY_TEST))
        alone = ', '.join('%s reader %s census %s' % (name, a, b) for name, a, b in every(p, ALONE))
        clean = sum(1 for q in paths if ok(q) and fields(q, COMPARED)[4] == 0 and fields(q, COMPARED)[6] == 0 and fields(q, COMPARED)[7] == 0 and fields(q, TESTED)[2] == 0 and fields(q, TESTED)[3] == 0)
        print('  %-11s %-7s T ran on %d expressions (%d of them lowered; never lowered %d: taken %d, in a lowered body %d), %d declarations\' discards left alone; the tests ran on %d and refused %d (%s); compared %d lowered and %d never lowered: taken there %d (nodes %d), of them refused by the census %d (the lowering\'s facts alone %d), tests that differ %d, root kinds %d; refused by the census %d, of them past C and X %d (nodes %d); by test alone: %s; nodes outside the records %d, units whose warnings differ %d%s; C and X compared %d, %d differ; %d of %d runs clean' % (
            tag, corpus, r[0], t[0], t[1], t[2], t[4], t[6], e[0], e[1], by or 'none', c[0], c[1], c[2], c[3], c[4], c[5], c[6], c[7], c[8], c[9], c[10], alone or 'none', e[2], e[3],
            '; verify: %d values not the action\'s, %d nodes whose action warns' % (v[0], v[1]) if v else '', x[0] if x else 0, x[2] if x else 0, clean, len(paths)))

print('== 2. What the tests cost in place (medians; TSC ticks a record T typed at reader time, and the unit\'s state)')
for label, suffix, runs, what in [('z0', '-b', 'sqlite3.c and Lua 7, musl 3', 'the tests as the census had them'), ('z1', '-b', '7, 3', 'a byte a type and a declaration, three gates'),
                                  ('z2', '', '7, 3', 'the walk\'s columns by record too'), (head, '-f', '7, 3', 'the pull request\'s sources but for two fixture lines')]:
    for corpus in corpora:
        suffixes = [suffix] if corpus != 'musl' else ([''] if label != head else ['-f'])
        def reader(tag):
            paths = [p for s in suffixes for p in files_of(label, tag, corpus, s)]
            return (median([fields(p, READER)[6] / fields(p, READER)[2] for p in paths]), median([fields(p, READER)[6] / MHZ / 1000 for p in paths]),
                    median([fields(p, READER)[7] / MHZ / 1000 for p in paths]), len(paths), median([fields(p, READER)[2] for p in paths]))
        if not [p for s in suffixes for p in files_of(label, 'tests', corpus, s)]:
            continue
        sweeps = reader('sweeps'); tests = reader('tests')
        print('  %-3s %-7s (%s): T, C and X %.1f (%.3f ms, %d runs; state %.3f ms); with the tests %.1f (%.3f ms, %d runs; state %.3f ms); the tests %.1f a record, %.2f times the three sweeps; %d records typed' % (
            label, corpus, what, sweeps[0], sweeps[1], sweeps[3], sweeps[2], tests[0], tests[1], tests[3], tests[2], tests[0] - sweeps[0], (tests[0] - sweeps[0]) / sweeps[0], sweeps[4]))
for corpus in corpora:
    for tag in ['leansweeps', 'leantests']:
        paths = files_of(head, tag, corpus, '-f')
        if paths:
            print('  %s %-7s %-10s lean front: %.1f ticks a record (%d runs)' % (head, corpus, tag, median([fields(p, READER)[6] / fields(p, READER)[2] for p in paths]), len(paths)))

print('== 3. The shadow\'s own sweeps before and after this change, no front (medians a taken node; seven passes on sqlite3.c and Lua, one on musl)')
for corpus in corpora:
    for label in [base, head]:
        tag = 'plain1' if corpus == 'musl' else 'plain7'
        paths = files_of(label, tag, corpus, '-f')
        if not paths:
            continue
        row = []
        for name in ['T', 'T+C', 'T+C+X']:
            cycles = [fields(p, sweep(name))[0] / fields(p, TAKEN)[1] for p in paths]
            instructions = [fields(p, sweep(name))[1] / fields(p, TAKEN)[1] for p in paths]
            row.append('%s %.1f cycles (%.1f to %.1f), %.2f instructions' % (name, median(cycles), min(cycles), max(cycles), median(instructions)))
        print('  %-7s %-3s %-6s (%d runs): %s' % (corpus, label, tag, len(paths), '; '.join(row)))

print('== 4. -c sqlite3.c as whole processes, %s against %s' % (base, head))
for k in [1, 2]:
    path = os.path.join(root, 'ab-copies-%s-%s-%d' % (base, head, k), 'time-runs.txt')
    if os.path.exists(path):
        text = open(path, errors='replace').read()
        wall = re.search(r'list 1, wall time \(ms\):\n(.*)\n(.*)\n', text)
        instructions = {}
        for m in re.finditer(r'run \d+ list 1 (\S+) copy \d+: .*?(\d+) instructions, status 0', text):
            instructions.setdefault(m.group(1), []).append(int(m.group(2)))
        print('  %d: %s | %s | instructions %s' % (k, wall.group(1).strip(), wall.group(2).strip(), ', '.join('%s %.3f M' % (label, median(v) / 1e6) for label, v in instructions.items())))
