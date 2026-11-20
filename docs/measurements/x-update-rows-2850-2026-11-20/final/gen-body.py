#!/usr/bin/env python3
# gen-body.py PARTS CHECKS SAN_FINAL TREE OUT: the pull request's body (OUT/body.md) and the result note for #2850
# (OUT/result-note.md, PRLINK left to fill) from their templates beside this file, gen-notes.py's parts (PARTS), the
# cloud container's checks' statuses (CHECKS, checks-rows.sh's) and the sanitizers' last pass (SAN_FINAL/progress.txt).
import os, re, subprocess, sys
parts, checks, san, tree, out = sys.argv[1:6]
here = os.path.dirname(os.path.abspath(__file__))
values = {}
for name in ('short-table', 'builds-table', 'builds-notes', 'gates', 'short-gates', 'stays', 'lists', 'means'):
    values[name.replace('-', '_')] = open('%s/%s.md' % (parts, name)).read().rstrip('\n')
progress = open(checks + '/progress.txt').read()
expected = ['build status 0', 'checker done: 8 of 8 parts with status 0', 'self-check status 0', 'self-parse status 0', 'test-call-graph status 0', 'check-call-graph status 0', 'ownership status 0',
            'complete-heavy: exit 0', 'complete-parse: exit 0', 'all done']
for line in expected:
    assert line in progress, line
shadow = re.search(r'shadow done: (\d+) of (\d+) runs with status 0', progress); modes = re.search(r'modes done: (\d+) of (\d+) runs with status 0', progress)
assert shadow and shadow.group(1) == shadow.group(2) and modes and modes.group(1) == modes.group(2), (shadow, modes)
# The light list: its one failure is the preprocessor's comparison with clang.
light = [l for l in open(checks + '/complete-light.log', errors='replace').read().splitlines() if l.startswith('== ')]
failed = [l for l in light if ': failed' in l]
assert len(failed) == 1 and 'Test the preprocessor on the repository' in failed[0] and 'against clang' in failed[0], failed
# No tape differs in any of the rows' shadow runs.
for name in os.listdir(checks + '/shadow'):
    if name.endswith('.out') and 'window-rows' in name:
        text = open('%s/shadow/%s' % (checks, name), errors='replace').read()
        assert re.search(r'window rows expressions=\d+ records=\d+ taken=\d+ \([\d.]+%\) their-records=\d+ \([\d.]+%\) their-entries=\d+ differences=0 not-kept-by-the-reference=0 second-runs-that-differ=0', text), name
        assert re.search(r'window contexts expressions=\d+ records=\d+ decided=\d+ \([\d.]+%\) their-records=\d+ \([\d.]+%\) of-them-refused=\d+ differences=0 records-that-differ=0', text), name
sanitized = open(san + '/progress.txt').read().splitlines()
runs = [l for l in sanitized if 'part5' in l]
assert len(runs) == 3 and all('status 0' in l and 'reports 0' in l and ', 0 failures' in l for l in runs) and sanitized[-1].startswith('all done'), sanitized
shadows = [l for l in sanitized if ' shadow ' in l]
assert len(shadows) == 6 and all('status 0' in l and 'reports 0' in l and '--window-rows' in l for l in shadows), shadows
assert all('build status 0' in l for l in sanitized if ' build ' in l) and len([l for l in sanitized if ' build ' in l]) == 3
revision = open(checks + '/revision.txt').read().split()[0]
head = subprocess.run(['git', '-C', tree, 'rev-parse', 'HEAD'], capture_output=True, text=True).stdout.strip()
base = subprocess.run(['git', '-C', tree, 'merge-base', 'HEAD', 'origin/main'], capture_output=True, text=True).stdout.strip()
same = subprocess.run(['git', '-C', tree, 'diff', '--stat', revision, head, '--', 'src', 'tools', 'tests'], capture_output=True, text=True).stdout.strip()
assert same == '', same
values['checks_revision'] = "the commit's sources, on main `%s`" % base[:9]
values['shadow_runs'] = shadow.group(1); values['mode_runs'] = modes.group(1)
for name in ('body', 'result-note'):
    text = open('%s/%s-template.md' % (here, name)).read()
    for key, value in values.items():
        text = text.replace('@@%s@@' % key, value)
    open('%s/%s.md' % (out, name), 'w').write(text)
    print(name, 'left:', sorted(set(re.findall(r'@@(\w+)@@', text))), 'bytes', len(text))
