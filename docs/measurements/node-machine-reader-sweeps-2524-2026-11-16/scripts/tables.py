#!/usr/bin/env python3
# tables.py [RESULTS [LABEL SUFFIX]]: the README's tables from the result files (default: ../results/9700x beside this
# script, the pull request's build w2 and its job's suffix t). Ticks at 3,792.9 MHz.
import sys, os, re, glob, statistics
root = sys.argv[1] if len(sys.argv) > 1 else os.path.join(os.path.dirname(os.path.abspath(__file__)), '..', 'results', '9700x')
head = sys.argv[2] if len(sys.argv) > 2 else 'w2'
suffix = sys.argv[3] if len(sys.argv) > 3 else 't'
base = 'u3'
MHZ = 3792.9
READER = r'reader-time T expressions=(\d+) records=(\d+) typed=(\d+) taken=(\d+) roots-not-run=(\d+) late-types=(\d+) ticks=(\d+) setup-ticks=(\d+)'
SWEPT = r'reader-time C and X expressions=(\d+) taken=(\d+) entries=(\d+) tapes-not-kept=(\d+)'
REFUSED = r'reader-time C and X refused=(\S+) expressions=(\d+)'
COMPARED = r"reader-time C and X compared=(\d+) \(entries (\d+)\) differences=(\d+) \(root (\d+), refusal (\d+), tape (\d+), labels-and-calls (\d+)\) patched: globals'-entries=(\d+) direct-calls=(\d+)"
TYPED = r"reader-time T lowered=(\d+) \([0-9.]+%\) never-lowered=(\d+) \(taken (\d+), context (\d+)\) compared=(\d+) \(records (\d+)\) differences=(\d+)"
TAKEN = r'machine-taken expressions=(\d+) \([0-9.]+%\) evaluated-nodes=(\d+) \([0-9.]+%\) records=(\d+)'
def sweep(name):
    return r'time sweeps=%s passes=\d+ repeat=\d+ cycles=(\d+) instructions=(\d+) ticks=(\d+) ' % re.escape(name)
def files_of(label, tag, corpus):
    return sorted(glob.glob(os.path.join(root, label, 'types-%s-%s-%s-*.txt' % (tag, corpus, suffix))))
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
    text = open(path, errors='replace').read()
    return text.rstrip().endswith('status 0')
corpora = ['sqlite3', 'lua', 'musl']

print('== 1. What C and X ran on at reader time and how they compare (%s, the first run of each): the lean front, then the whole one' % head)
for tag in ['leansweeps1', 'sweeps1']:
    for corpus in corpora:
        paths = files_of(head, tag, corpus)
        if not paths:
            continue
        p = paths[0]
        r = fields(p, READER); s = fields(p, SWEPT); c = fields(p, COMPARED); t = fields(p, TYPED)
        refused = ', '.join('%s %s' % (name, count) for name, count in every(p, REFUSED))
        statuses = sum(1 for q in paths if ok(q))
        same = sum(1 for q in paths if fields(q, COMPARED)[2] == 0 and fields(q, TYPED)[6] == 0)
        print('  %-11s %-7s T ran on %d expressions (%d records typed) and took %d; C and X ran on %d, took %d (refused: %s), %d entries, %d tapes not kept; compared %d expressions (%d entries): %d differ (root %d, refusal %d, tape %d, labels and calls %d); patched %d globals\' entries and %d direct calls; %d of %d runs status 0, %d without a difference' % (
            tag, corpus, r[0], r[2], r[3], s[0], s[1], refused, s[2], s[3], c[0], c[1], c[2], c[3], c[4], c[5], c[6], c[7], c[8], statuses, len(paths), same))

print('== 2. Reader time against the tight loop (medians; TSC ticks a record T typed at reader time, a record of the taken expressions in the tight loop\'s first pass)')
rows = {}
for corpus in corpora:
    for front, alone, three in [('whole', 'types1', 'sweeps1'), ('lean', 'leantypes1', 'leansweeps1')]:
        def reader(label, tag):
            paths = files_of(label, tag, corpus)
            return median([fields(p, READER)[6] / fields(p, READER)[2] for p in paths]), median([fields(p, READER)[6] / MHZ / 1000 for p in paths]), len(paths)
        def tight(label, tag, name, column):
            paths = files_of(label, tag, corpus)
            return median([fields(p, sweep(name))[column] / fields(p, TAKEN)[2 if column == 2 else 1] for p in paths])
        if not files_of(head, three, corpus):
            continue
        t_base, t_base_ms, n_base = reader(base, alone)
        t_head, t_head_ms, n_head = reader(head, alone)
        all_head, all_head_ms, n_three = reader(head, three)
        tt = {name: tight(head, three, name, 2) for name in ['T', 'T+C', 'T+C+X']}
        cyc = tight(head, three, 'T+C+X', 0)
        rows[(corpus, front)] = (t_head, all_head, tt, cyc)
        print('  %-7s %-5s front: T alone %.1f by %s (%.3f ms, %d runs), %.1f by %s (%.3f ms, %d); T, C and X %.1f (%.3f ms, %d): C and X in place %.1f; tight loop: T %.1f, T+C %.1f, T+C+X %.1f (C and X %.1f; %.1f cycles a node); in place over tight: T %.2f, C and X %.2f, the three %.2f; the three in place as cycles a node %.1f' % (
            corpus, front, t_base, base, t_base_ms, n_base, t_head, head, t_head_ms, n_head, all_head, all_head_ms, n_three, all_head - t_head, tt['T'], tt['T+C'], tt['T+C+X'],
            tt['T+C+X'] - tt['T'], cyc, t_head / tt['T'], (all_head - t_head) / (tt['T+C+X'] - tt['T']), all_head / tt['T+C+X'], all_head / tt['T+C+X'] * cyc))

print('== 3. The shadow\'s own sweeps before and after this change, no front (medians a taken node; seven passes on sqlite3.c and Lua, one on musl)')
for corpus in corpora:
    for label in [base, head]:
        tag = 'plain1' if corpus == 'musl' else 'plain7'
        paths = files_of(label, tag, corpus)
        if not paths:
            continue
        row = []
        for name in ['T', 'T+C', 'T+C+X']:
            cycles = [fields(p, sweep(name))[0] / fields(p, TAKEN)[1] for p in paths]
            instructions = [fields(p, sweep(name))[1] / fields(p, TAKEN)[1] for p in paths]
            ticks = [fields(p, sweep(name))[2] / fields(p, TAKEN)[1] for p in paths]
            row.append('%s %.1f cycles (%.1f to %.1f), %.2f instructions, %.1f ticks' % (name, median(cycles), min(cycles), max(cycles), median(instructions), median(ticks)))
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
