#!/usr/bin/env python3
# gen-body.py VALUES CHECKS SAN TREE OUT: the pull request's body (OUT/body.md) and the result note for #2850
# (OUT/result-note.md, PRLINK left to fill) from their templates beside this file, gen-docs.py's values (VALUES, its
# values.json), the cloud container's checks' statuses (CHECKS, checks-rows.sh's), the sanitizers' pass
# (SAN/progress.txt) and the tests' paragraph (tests.md beside this file, its counts checked against TREE's pins).
import json, os, re, subprocess, sys
values_path, checks, san, tree, out = sys.argv[1:6]
here = os.path.dirname(os.path.abspath(__file__))
values = json.load(open(values_path))
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
san_done = os.path.exists(san + '/progress.txt') and any(l.startswith('all done') for l in open(san + '/progress.txt'))
if san_done:
    sanitized = open(san + '/progress.txt').read().splitlines()
    runs = [l for l in sanitized if 'part5' in l]
    assert len(runs) == 3 and all('status 0' in l and 'reports 0' in l and ', 0 failures' in l for l in runs) and any(l.startswith('all done') for l in sanitized), sanitized
    shadows = [l for l in sanitized if ' shadow ' in l]
    assert len(shadows) == 6 and all('status 0' in l and 'reports 0' in l and '--window-rows' in l for l in shadows), shadows
    assert all('build status 0' in l for l in sanitized if ' build ' in l) and len([l for l in sanitized if ' build ' in l]) == 3
values['sanitizers_done'] = 'yes' if san_done else 'no'
values['sanitizers'] = ("the rows a PR's checks skip, on the code's commit: native memory, address and thread builds, `test-checker` part 5 under each, and under memory and address the shadow with `--window-rows` on `sqlite3.c`, Lua and the compiler's own source: no report."
                        if san_done else
                        "the rows a PR's checks skip (native memory, address and thread builds, `test-checker` part 5 under each, and under memory and address the shadow with `--window-rows` on `sqlite3.c`, Lua and the compiler's own source) are running on the code's commit as this is opened; this description gets their result. The session before ran them on `9eb233772`, this code but for three comments: no report.")
revision = open(checks + '/revision.txt').read().split()[0]
head = subprocess.run(['git', '-C', tree, 'rev-parse', 'HEAD'], capture_output=True, text=True).stdout.strip()
base = subprocess.run(['git', '-C', tree, 'merge-base', 'HEAD', 'origin/main'], capture_output=True, text=True).stdout.strip()
same = subprocess.run(['git', '-C', tree, 'diff', '--stat', revision, head, '--', 'src', 'tools', 'tests'], capture_output=True, text=True).stdout.strip()
assert same == '', same
san_revision = open(san + '/revision.txt').read().split()[0] if os.path.exists(san + '/revision.txt') else None
values['checks_revision'] = "the commit's sources, on main `%s`" % base[:9]
values['shadow_runs'] = shadow.group(1); values['mode_runs'] = modes.group(1)
# The tests' paragraph: its numbers are the fixture's pins.
tests = open(here + '/tests.md').read().strip()
test_source = open(tree + '/src/buster/compiler/c_check_node_census_test.c').read()
for number in re.findall(r'\b\d[\d,]*\b', tests):
    plain = number.replace(',', '')
    assert len(plain) < 3 or re.search(r'= %s,' % plain, test_source) or plain in ('64',), number
values['tests'] = tests
for name in ('body', 'result-note'):
    text = open('%s/%s-template.md' % (here, name)).read()
    for key, value in values.items():
        text = text.replace('@@%s@@' % key, value)
    open('%s/%s.md' % (out, name), 'w').write(text)
    print(name, 'left:', sorted(set(re.findall(r'@@(\w+)@@', text))), 'bytes', len(text))
print('checks at', revision[:9], 'head', head[:9], 'base', base[:9], 'sanitizers at', san_revision[:9] if san_revision else '?')
