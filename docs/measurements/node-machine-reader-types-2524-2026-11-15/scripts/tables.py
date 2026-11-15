#!/usr/bin/env python3
# tables.py [RESULTS]: every table of the README from the result files (default: ../results/9700x beside this script).
import sys, os, re, glob, statistics
root = sys.argv[1] if len(sys.argv) > 1 else os.path.join(os.path.dirname(os.path.abspath(__file__)), '..', 'results', '9700x')
MHZ = 3792.9
def ms(ticks):
    return ticks / MHZ / 1000
def files_of(label, tag, corpus, suffix):
    return sorted(glob.glob(os.path.join(root, label, 'types-%s-%s-%s-*.txt' % (tag, corpus, suffix))))
def fields(path, rx):
    for line in open(path):
        m = re.search(rx, line)
        if m:
            return [float(g) for g in m.groups()]
    return None
READER = r'reader-time T expressions=(\d+) records=(\d+) typed=(\d+) taken=(\d+) roots-not-run=(\d+) late-types=(\d+) ticks=(\d+) setup-ticks=(\d+)'
LOWERED = r"reader-time T lowered=(\d+) \([0-9.]+%\) never-lowered=(\d+) \(taken (\d+), context (\d+)\) compared=(\d+) \(records (\d+)\) differences=(\d+) \(range (\d+), refusal (\d+)\) taken-expressions-the-front-left=(\d+) the-front's-not-run=(\d+)"
OBJECTS = r'reader-time T objects=(\d+) differences=(\d+) library-calls=(\d+) differences=(\d+)'
TAKEN = r'machine-taken expressions=(\d+) \([0-9.]+%\) evaluated-nodes=(\d+) \([0-9.]+%\) records=(\d+)'
def sweep(name):
    return r'time sweeps=%s passes=\d+ repeat=\d+ cycles=(\d+) instructions=(\d+) ticks=(\d+) ' % re.escape(name)
FRONT = r'node-shadow: front ticks=(\d+)'
WALK = r'node-shadow: walk ticks classes=(\d+) prepare=(\d+) actions=(\d+) visits=(\d+)'
def median(values):
    return statistics.median(values) if values else float('nan')

print('== 1. T at reader time against the shadow\'s T after the pipeline (medians; ticks at %.1f MHz): t4, the pull request\'s sources (job13), then t3 (job12), t2 (job11) and t1 (job10)' % MHZ)
for label, suffix in [('t4', 'n'), ('t3', 'm'), ('t2', 'l'), ('t1', 'k')]:
  for corpus in ['sqlite3', 'lua', 'musl']:
    for tag in ['types1', 'types7', 'leantypes1', 'firsttypes1']:
        paths = files_of(label, tag, corpus, suffix)
        if not paths:
            continue
        reader_per, shadow_per, shadow_cycles_per, shadow_instr_per, reader_ms, setup_ms, shadow_ms, front_ms, walk_ms = [], [], [], [], [], [], [], [], []
        for path in paths:
            r = fields(path, READER); t = fields(path, TAKEN); s = fields(path, sweep('T')); f = fields(path, FRONT); w = fields(path, WALK)
            reader_per.append(r[6] / r[2]); reader_ms.append(ms(r[6])); setup_ms.append(ms(r[7]))
            shadow_per.append(s[2] / t[2]); shadow_cycles_per.append(s[0] / t[2]); shadow_instr_per.append(s[1] / t[2]); shadow_ms.append(ms(s[2]))
            front_ms.append(ms(f[0])); walk_ms.append(ms(sum(w)))
        print('  %-3s %-7s %-12s (%d runs): reader-time T %.3f ms, %.1f ticks a typed record; its state %.3f ms; the shadow\'s T %.3f ms, %.1f ticks a record (%.1f cycles, %.1f instructions); the front %.3f ms; the walk %.3f ms' % (
            label, corpus, tag, len(paths), median(reader_ms), median(reader_per), median(setup_ms), median(shadow_ms), median(shadow_per), median(shadow_cycles_per),
            median(shadow_instr_per), median(front_ms), median(walk_ms)))
print('== 2. The shadow\'s own sweeps before and after this change, no front (medians): job13 (m11, t4), then job12 (m11, t3), job11 (m11, t2) and job10 (m11, t1)')
for suffix, labels in [('n', ['m11', 't4']), ('m', ['m11', 't3']), ('l', ['m11', 't2']), ('k', ['m11', 't1'])]:
  for corpus in ['sqlite3', 'lua', 'musl']:
    for label in labels:
        for tag in ['plain7', 'plain1']:
            paths = files_of(label, tag, corpus, suffix)
            if not paths:
                continue
            row = []
            for name in ['T', 'T+C', 'T+C+X']:
                cycles, ticks, instructions = [], [], []
                for path in paths:
                    s = fields(path, sweep(name)); t = fields(path, TAKEN)
                    cycles.append(s[0] / t[1]); instructions.append(s[1] / t[1]); ticks.append(s[2] / t[1])
                row.append('%s %.1f cycles, %.1f instructions, %.1f ticks a node' % (name, median(cycles), median(instructions), median(ticks)))
            print('  %-7s %-3s %-6s (%d runs): %s' % (corpus, label, tag, len(paths), '; '.join(row)))
print('== 3. What reader time ran on and how it compares (t4, the first --front-types run of each corpus)')
for corpus in ['sqlite3', 'lua', 'musl']:
    paths = files_of('t4', 'types1', corpus, 'n')
    print('  ' + corpus)
    for line in open(paths[0]):
        if 'reader-time' in line or 'machine-taken' in line or re.search(r'node-shadow: front (after|before)', line):
            print('    ' + line.strip())
print('== 4. Every --front-types run\'s comparison (t1 to t4)')
seen = {}
for path in sorted(glob.glob(os.path.join(root, 't1', 'types-*types*-k-*.txt')) + glob.glob(os.path.join(root, 't2', 'types-*types*-l-*.txt')) +
                   glob.glob(os.path.join(root, 't3', 'types-*types*-m-*.txt')) + glob.glob(os.path.join(root, 't4', 'types-*types*-n-*.txt'))):
    l = fields(path, LOWERED); o = fields(path, OBJECTS)
    key = ('differences=%d objects=%d library=%d' % (l[6], o[1], o[3]))
    seen[key] = seen.get(key, 0) + 1
for key in sorted(seen):
    print('  %s: %d runs' % (key, seen[key]))
print('== 5. -c sqlite3.c as whole processes from fresh copies of each executable (21 runs a build)')
for name in sorted(glob.glob(os.path.join(root, 'ab-copies-m11-t*'))):
    path = os.path.join(name, 'time-runs.txt')
    print('  ' + os.path.basename(name))
    instructions = {}
    keep = False
    for line in open(path):
        m = re.match(r'run \d+ list 1 (\S+) copy \d+: .* (\d+) instructions, status 0', line)
        if m:
            instructions.setdefault(m.group(1), []).append(int(m.group(2)))
        if line.startswith('list 1, '):
            keep = True
        if keep and (line.startswith('list 1, ') or line.startswith('  ')):
            print('    ' + line.rstrip()[:200])
    for build in instructions:
        print('    %s: mean instructions %.0f over %d runs' % (build, statistics.mean(instructions[build]), len(instructions[build])))
