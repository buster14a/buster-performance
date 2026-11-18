# Runs each mutant of mutants.py in an archived copy of the tree (never a worktree): apply, build, test, revert, and
# check the tree is back to its base digest. One runner per tree, under flock.
import os, subprocess, sys, hashlib, time
here = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, here)
from mutants import MUTANTS
tree, label = sys.argv[1], sys.argv[2]
only = sys.argv[3:]
log = open(f'{here}/{label}.results', 'a')
def digest():
    h = hashlib.sha256()
    for f in sorted(set(m[1] for m in MUTANTS)):
        h.update(open(os.path.join(tree, f), 'rb').read())
    return h.hexdigest()
def swap(f, old, new):
    p = os.path.join(tree, f)
    s = open(p).read()
    assert s.count(old) == 1 and s.count(new) == 0, (f, old)
    open(p, 'w').write(s.replace(old, new))
base = digest()
for name, f, old, new in MUTANTS:
    if not only or name in only:
        swap(f, old, new); swap(f, new, old)
assert digest() == base
TESTS = [
    ('ir-inline', ['./build/compiler', 'test-ir-inline']),
    ('unit-inline', [os.path.join(here, 'unit_check.sh'), tree]),
    ('tier0-inline', ['./build/compiler', 'test-tier0-inline']),
]
def build(tag):
    r = subprocess.run(['nice', '-n', '5', './build.sh'], cwd=tree, capture_output=True, text=True)
    open(f'{here}/{label}-{tag}.build', 'w').write(r.stdout[-20000:] + r.stderr[-20000:])
    return r.returncode == 0
def test(tag):
    t = time.time()
    failed = []
    with open(f'{here}/{label}-{tag}.test', 'w') as o:
        for name, command in TESTS:
            r = subprocess.run(['timeout', '1200'] + command, cwd=tree, capture_output=True, text=True)
            o.write(f'== {name}: exit {r.returncode}\n' + r.stdout[-6000:] + r.stderr[-6000:])
            if r.returncode != 0:
                failed.append(name)
    return failed, time.time() - t
ok = build('base')
failed, sec = test('base') if ok else (['build'], 0)
print(f'{label} base build={ok} failed={failed} {sec:.1f}s', file=log, flush=True)
for name, f, old, new in MUTANTS:
    if only and name not in only:
        continue
    swap(f, old, new)
    try:
        ok = build(name)
        failed, sec = test(name) if ok else (['build'], 0)
    finally:
        swap(f, new, old)
    assert digest() == base
    verdict = 'BUILD-FAILED' if not ok else ('killed' if failed else 'SURVIVED')
    print(f'{label} {name} {verdict} by={failed} {sec:.1f}s', file=log, flush=True)
print(f'{label} done', file=log, flush=True)
