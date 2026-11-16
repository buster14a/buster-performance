#!/usr/bin/env python3
# kernel-baseline.py [RESULTS] LABEL...: what buster#2850's fact words' figure is made of, by label, corpus and setting
# (results/9700x/facts-19-24/LABEL/facts-CORPUS[-SETTING]-N.txt, and LABEL/padmusl-SETTING-PAD.txt for the stack's
# places). The harness reports "the kernel a taken leaf or lookup" as a pass less a second pass that only puts each
# window's given records in place, and prints that second pass's cycles and instructions a record. This prints both
# and their sum a record: kernel * (leaves + lookups taken) / records + baseline.
import glob, os, re, statistics, sys
arguments = sys.argv[1:]
root = os.path.join(os.path.dirname(os.path.abspath(__file__)), '..', 'results', '9700x')
if arguments and os.path.isdir(arguments[0]):
    root = arguments.pop(0)
labels = arguments or ['w2', 'z3']
KERNEL = r"the kernel a taken leaf or lookup: cycles=([\d.]+) instructions=([\d.]+) mispredicted-branches=([\d.]+) \(a pass less its windows' given records put in place: ([\d.]+) cycles and ([\d.]+) instructions a record of the window\)"
RECORDS = r"node-facts: (?:variant=\S+ )?records=(\d+) "
TAKEN = r"node-facts: taken identifiers=(\d+) \([\d.]+%\) lookups=(\d+) "
def read(path):
    text = open(path, errors='replace').read()
    k = re.search(KERNEL, text); r = re.search(RECORDS, text); t = re.search(TAKEN, text)
    if not (k and r and t):
        return None
    kernel, instructions, mispredicted, baseline, baseline_instructions = map(float, k.groups())
    records = int(r.group(1)); taken = int(t.group(1)) + int(t.group(2))
    return dict(kernel=kernel, instructions=instructions, baseline=baseline, baseline_instructions=baseline_instructions, records=records, taken=taken,
                whole=kernel * taken / records + baseline, whole_instructions=instructions * taken / records + baseline_instructions)
def spread(rows, key, digits=2):
    values = [row[key] for row in rows]
    return '%.*f (%.*f to %.*f)' % (digits, statistics.median(values), digits, min(values), digits, max(values))
print('== The fact words\' figure and the pass it is taken from (cycles; medians and ranges over the rounds)')
for label in labels:
    groups = {}
    for path in sorted(glob.glob(os.path.join(root, 'facts-19-24', label, 'facts-*.txt'))):
        m = re.match(r'facts-([a-z0-9]+?)(?:-([a-z0-9]+))?-(\d+)\.txt$', os.path.basename(path))
        row = read(path)
        if m and row:
            groups.setdefault((m.group(1), m.group(2) or 'a body'), []).append(row)
    for (corpus, setting), rows in sorted(groups.items()):
        print('  %-3s %-7s %-11s the kernel a taken leaf or lookup %s, %s instructions; the given records put in place, a record %s, %s instructions; the two a record %s, %s instructions; %d of %d records taken; %d runs' % (
            label, corpus, setting, spread(rows, 'kernel'), spread(rows, 'instructions'), spread(rows, 'baseline'), spread(rows, 'baseline_instructions'), spread(rows, 'whole'), spread(rows, 'whole_instructions'),
            rows[0]['taken'], rows[0]['records'], len(rows)))
print('== musl by the stack\'s place (a pad of the environment, bytes; one run each)')
for label in labels:
    for setting in ['whole', 'loads']:
        rows = []
        for path in glob.glob(os.path.join(root, label, 'padmusl-%s-*.txt' % setting)):
            row = read(path)
            if row:
                rows.append((int(re.search(r'-(\d+)\.txt$', path).group(1)), row))
        rows.sort()
        if rows:
            print('  %-3s %-5s %s' % (label, setting, '; '.join('%d: kernel %.2f, in place %.2f, the two %.2f' % (pad, row['kernel'], row['baseline'], row['whole']) for pad, row in rows)))
print('== musl\'s two passes by their TSC ticks (facts-gdb-musl.sh: the harness\'s own sums read with gdb at its report; medians of the runs; a tick is 1.46 cycles on a long unit)')
GDB = r'gdb: records=(\d+) taken-leaves=(\d+) taken-lookups=(\d+) pass-cycles=(\d+) pass-instructions=(\d+) pass-ticks=(\d+) given-cycles=(\d+) given-instructions=(\d+) given-ticks=(\d+)'
UNITS = 1336
TICK = 1.46
for label in labels:
    for setting in ['whole', 'packed4096']:
        rows = []
        for path in sorted(glob.glob(os.path.join(root, label, 'gdbmusl-%s-*.txt' % setting))):
            text = open(path, errors='replace').read()
            m = re.search(GDB, text)
            if m and text.rstrip().endswith('status 0'):
                rows.append(list(map(int, m.groups())))
        if rows:
            def med(f):
                return statistics.median([f(*row) for row in rows])
            print('  %-3s %-10s first pass %.2f cycles and %.2f ticks a record; second pass (the given records alone) %.2f cycles and %.2f ticks a record; cycles outside the ticks, a unit\'s pass: first %.0f, second %.0f; the first less the second a taken leaf or lookup: %.2f cycles, %.2f ticks; %d runs' % (
                label, setting, med(lambda n, a, b, pc, pi, pt, gc, gi, gt: pc / n), med(lambda n, a, b, pc, pi, pt, gc, gi, gt: pt / n),
                med(lambda n, a, b, pc, pi, pt, gc, gi, gt: gc / n), med(lambda n, a, b, pc, pi, pt, gc, gi, gt: gt / n),
                med(lambda n, a, b, pc, pi, pt, gc, gi, gt: (pc - TICK * pt) / UNITS), med(lambda n, a, b, pc, pi, pt, gc, gi, gt: (gc - TICK * gt) / UNITS),
                med(lambda n, a, b, pc, pi, pt, gc, gi, gt: (pc - gc) / (a + b)), med(lambda n, a, b, pc, pi, pt, gc, gi, gt: (pt - gt) / (a + b)), len(rows)))
