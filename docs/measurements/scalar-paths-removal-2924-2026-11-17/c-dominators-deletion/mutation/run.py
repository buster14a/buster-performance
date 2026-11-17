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
subset = [l.strip() for l in open(os.path.join(tree, 'tests/c-testsuite/subset.txt')) if l.strip().isdigit()][:80]
sources = ['tests/ir-source/dominators.c'] + [f'build/c-testsuite/tests/single-exec/{n}.c' for n in subset]
TESTS = [
    ('dominators', ['./build/compiler', 'test-dominators']),
    ('dominators-seed7', ['./build/compiler', 'test-dominators', '--seed', '7', '--count', '40']),
    ('ir-source', ['./build/compiler', 'test-ir-source', '--dominators'] + sources),
]
def build(tag):
    r = subprocess.run(['nice', '-n', '5', './build.sh'], cwd=tree, capture_output=True, text=True)
    open(f'{here}/{label}-{tag}.build', 'w').write(r.stdout + r.stderr)
    return r.returncode == 0
def test(tag):
    t = time.time()
    failed = []
    with open(f'{here}/{label}-{tag}.test', 'w') as o:
        for name, command in TESTS:
            r = subprocess.run(['timeout', '600'] + command, cwd=tree, capture_output=True, text=True)
            o.write(f'== {name}: exit {r.returncode}\n' + r.stdout[-4000:] + r.stderr[-4000:])
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
