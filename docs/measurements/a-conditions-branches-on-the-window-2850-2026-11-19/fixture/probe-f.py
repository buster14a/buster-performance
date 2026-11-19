#!/usr/bin/env python3
# probe-f.py COMPILER TEST_FILE LINES: each statement of LINES alone in the contexts fixture's function (its declarations and
# locals, read from the test file's string), through the shadow with C on the window: a line a statement with what
# C on the window made of its expressions, and the sums. SUM in a statement is the fixture's sum of seventy operands.
import subprocess, sys, re, os
compiler, test_file, lines_file = sys.argv[1:4]
source = open(test_file).read().split('\n')
start = next(i for i, l in enumerate(source) if l.startswith('static const char node_contexts_test_source[] ='))
head = []
for l in source[start + 1:]:
    m = re.match(r'\s*"(.*)\\n"$', l)
    assert m, l
    text = m.group(1).replace('\\"', '"')
    head.append(text)
    if text.strip() == 'const struct outer* co = o;':
        break
ten = 'a + a + a + a + a + a + a + a + a + a'
total = '(' + ' + '.join([ten] * 7) + ')'
os.makedirs('work', exist_ok=True)
keys = (('expressions', r'window contexts expressions=(\d+)'), ('decided', r'window contexts expressions=\d+ records=\d+ decided=(\d+)'), ('refused', r'of-them-refused=(\d+)'),
        ('differences', r'of-them-refused=\d+ differences=(\d+)'), ('record-differences', r'records-that-differ=(\d+)'),
        ('strides', r'strides-read=(\d+)'), ('asked', r'of-them-asked-of-the-type-table=(\d+)'), ('converted', r'rules-that-read-the-conversions=(\d+)'),
        ('far', r"out-of-a-block's-reach=(\d+)"), ('updates', r'window contexts updates=(\d+)'), ('updates_taken', r'window contexts updates=\d+ \([^)]*\) taken=(\d+)'),
        ('branched', r'window contexts branched=(\d+)'), ('roots', r'of-them-a-condition=(\d+)'))
def measure(line):
    open('work/one.c', 'w').write('\n'.join(head) + '\n    ' + line.replace('SUM', total) + '\n    return a + c;\n}\n')
    run = subprocess.run([compiler, 'measure-node-machine', '--shadow', '--passes', '0', '--window-contexts', '--list', '5', 'work/one.c'], capture_output=True, text=True)
    out = run.stdout + run.stderr
    counts = {}
    for key, pat in keys:
        m = re.search(pat, out)
        counts[key] = int(m.group(1)) if m else 0
    m = re.search(r"listed, by an expression's first record's reason:(.*)", out)
    for item in (m.group(1) if m else '').split():
        name, value = item.split('=')
        counts['listed ' + name] = int(value)
    return counts, 'failures=0' in out, run.returncode
base, accepted, status = measure(';')
assert accepted and status == 0, 'the base unit'
print('base: ' + ' '.join('%s=%d' % (k, v) for k, v in sorted(base.items()) if v != 0))
sums = {}
for line in open(lines_file):
    line = line.rstrip('\n')
    if not line.strip() or line.startswith('#'):
        continue
    counts, accepted, status = measure(line)
    delta = {k: counts.get(k, 0) - base.get(k, 0) for k in counts}
    for k, v in delta.items():
        sums[k] = sums.get(k, 0) + v
    print('%-58s %s%s%s' % (line[:58], ' '.join('%s=%d' % (k, v) for k, v in delta.items() if v != 0), '' if accepted else ' REJECTED', '' if status == 0 else ' STATUS %d' % status))
print('sums: ' + ' '.join('%s=%d' % (k, v) for k, v in sorted(sums.items()) if v != 0))
