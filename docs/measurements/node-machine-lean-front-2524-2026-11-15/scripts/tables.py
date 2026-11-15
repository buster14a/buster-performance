#!/usr/bin/env python3
# tables.py [RESULTS]: every table of the README from the result files (default: ../results/9700x beside this script).
import sys, os, re, glob, statistics
root = sys.argv[1] if len(sys.argv) > 1 else os.path.join(os.path.dirname(os.path.abspath(__file__)), '..', 'results', '9700x')
MHZ = 3792.9
WALK = r'node-shadow: walk ticks classes=(\d+) prepare=(\d+) actions=(\d+) visits=(\d+)'
PREPARE = r'node-shadow: walk prepare ticks compact=(\d+) identifiers=(\d+) literals=(\d+)'
def ms(ticks):
    return ticks / MHZ / 1000
def files_of(label, mode, corpus, suffix):
    return sorted(glob.glob(os.path.join(root, label, 'front-%s-%s-%s-*.txt' % (mode, corpus, suffix))))
def values_of(paths, rx, group=1):
    values = []
    for path in paths:
        for line in open(path):
            m = re.search(rx, line)
            if m:
                values.append(float(m.group(group)))
    return values
def median_ms(paths, rx, group=1):
    values = values_of(paths, rx, group)
    return ms(statistics.median(values)) if values else None
def row(label, mode, corpus, suffix):
    paths = files_of(label, mode, corpus, suffix)
    if not paths:
        return None
    parts = [median_ms(paths, WALK, k) for k in (1, 2, 3, 4)]
    totals = []
    for path in paths:
        for line in open(path):
            m = re.search(WALK, line)
            if m:
                totals.append(sum(int(v) for v in m.groups()))
    result = {'runs': len(paths), 'classes': parts[0], 'prepare': parts[1], 'actions': parts[2], 'visits': parts[3], 'walk': ms(statistics.median(totals)),
              'front': median_ms(paths, r'node-shadow: front ticks=(\d+)')}
    for k, name in enumerate(['compact', 'identifiers', 'literals']):
        result[name] = median_ms(paths, PREPARE, k + 1)
    return result
def show(label, mode, corpus, suffix):
    r = row(label, mode, corpus, suffix)
    if r is None:
        return
    text = '  %-3s %-15s %-7s (%d runs): classes %.3f prepare %.3f actions %.3f visits %.3f walk %.3f' % (
        label, mode, corpus, r['runs'], r['classes'], r['prepare'], r['actions'], r['visits'], r['walk'])
    if r['front'] is not None:
        text += ' front %.3f' % r['front']
    if r['compact'] is not None:
        text += ' | compact %.3f identifiers %.3f literals %.3f' % (r['compact'], r['identifiers'], r['literals'])
    print(text)

print('== 1. The pull request\'s sources, g3, and main, m10: the shadow\'s one reading (job9; ms, medians)')
for corpus in ['sqlite3', 'lua', 'musl']:
    for label, mode in [('g3', 'walk'), ('m10', 'first'), ('g3', 'first'), ('g3', 'leanfirst'), ('g3', 'warmfirst'), ('g3', 'leanwarmfirst'), ('m10', 'after'), ('g3', 'after'), ('g3', 'leanafter')]:
        show(label, mode, corpus, 'j')
print('== 2. What the machine reads before the walk, of the walk as it is (job9)')
for corpus in ['sqlite3', 'lua', 'musl']:
    walk = row('g3', 'walk', corpus, 'j')
    merged = row('m10', 'first', corpus, 'j')
    whole = row('g3', 'first', corpus, 'j')
    lean = row('g3', 'leanfirst', corpus, 'j')
    a = merged['classes'] + merged['prepare'] + merged['front']
    b = whole['classes'] + whole['prepare'] + whole['front']
    c = lean['classes'] + lean['compact'] + lean['literals'] + lean['front']
    print('  %-7s walk %.3f; #2857\'s front with classes and entries %.3f (%.1f%%); the whole front\'s %.3f (%.1f%%); the lean front with classes, compaction and literals %.3f (%.1f%%)' % (
        corpus, walk['walk'], a, 100 * a / walk['walk'], b, 100 * b / walk['walk'], c, 100 * c / walk['walk']))
    print('  %-7s the front of the walk\'s actions and visits: #2857\'s %.1f%%, whole %.1f%%, lean %.1f%%' % (
        corpus, 100 * merged['front'] / (walk['actions'] + walk['visits']), 100 * whole['front'] / (walk['actions'] + walk['visits']), 100 * lean['front'] / (walk['actions'] + walk['visits'])))
print('== 3. The structural bytes and the lean front as first built, g1 (job6; ms, medians)')
for corpus in ['sqlite3', 'lua', 'musl']:
    for label, mode in [('g1', 'walk'), ('m10', 'first'), ('g1', 'first'), ('g1', 'leanfirst'), ('g1', 'after'), ('g1', 'leanafter')]:
        show(label, mode, corpus, 'g')
print('== 4. Passing tokens first, g2 against g1 and m10, in turn (job7; ms, medians)')
for corpus in ['sqlite3', 'lua', 'musl']:
    for label, mode in [('g2', 'walk'), ('m10', 'first'), ('g1', 'leanfirst'), ('g2', 'first'), ('g2', 'leanfirst'), ('g2', 'warmfirst'), ('g2', 'leanwarmfirst')]:
        show(label, mode, corpus, 'h')
print('== 5. g2 after the walk (job8; ms, medians)')
for corpus in ['sqlite3', 'lua']:
    for label, mode in [('m10', 'after'), ('g2', 'after'), ('g2', 'leanafter')]:
        show(label, mode, corpus, 'i')
print('== 6. The front\'s function\'s events in the --front-first reading of sqlite3.c (millions; events5: five processes an event)')
def events(label, prefix, tag):
    out = []
    for event in ['cycles', 'instructions', 'ex_ret_brn_misp']:
        path = os.path.join(root, label, '%s-%s-%s.txt' % (prefix, tag, event))
        value = None
        if os.path.exists(path):
            for line in open(path):
                f = line.split()
                if len(f) >= 3 and re.match(r'node_front_chunk(_lean)?(\.buster_split)?$', f[2]):
                    value = float(f[0])
        out.append('%s %s' % (event, '%.3f' % value if value is not None else '-'))
    print('  %-3s %-7s %-9s: %s' % (label, prefix, tag, '; '.join(out)))
for label, prefix, tag in [('g1', 'events', 'first'), ('g1', 'events', 'leanfirst'), ('g2', 'events', 'first'), ('g2', 'events', 'leanfirst'), ('m10', 'events5', 'first'),
                           ('g2', 'events5', 'first'), ('g2', 'events5', 'leanfirst'), ('g3', 'events5', 'first'), ('g3', 'events5', 'leanfirst')]:
    events(label, prefix, tag)
print('== 7. The front\'s counts (g3, the --front-lean --front-first readings; the same in every g3 run of a corpus)')
for corpus in ['sqlite3', 'lua', 'musl']:
    path = files_of('g3', 'leanfirst', corpus, 'j')[0]
    print('  ' + corpus)
    for line in open(path):
        if re.search(r'node-shadow: (front (before|class|left|taken|operands|structure)|machine-taken)', line):
            print('    ' + line.strip())
print('== 8. Every g3 run\'s comparison')
seen = {}
for path in sorted(glob.glob(os.path.join(root, 'g3', 'front-*-j-*.txt'))):
    for line in open(path):
        m = re.search(r'node-shadow: front ((?:before|after)-the-walk[a-z ]*?) tokens=\d+ left=\d+ records=\d+ compared=\d+ (differences=\d+)', line)
        if m:
            key = (m.group(1), m.group(2))
            seen[key] = seen.get(key, 0) + 1
for key in sorted(seen):
    print('  %-28s %s: %d runs' % (key[0], key[1], seen[key]))
print('== 9. -c sqlite3.c as whole processes from fresh copies of each executable (21 runs a build)')
for name in ['ab-copies-m10-g1', 'ab-copies-m10-g2', 'ab-copies-m10-g3-second', 'ab-copies-m10-g3-third', 'ab-copies-m10-g3-fourth']:
    path = os.path.join(root, name, 'time-runs.txt')
    if not os.path.exists(path):
        continue
    print('  ' + name)
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
