import os, subprocess, sys, hashlib, time
sys.path.insert(0, '/tmp/claude-0/mut')
from mutants import MUTANTS
tree, label, jobs = sys.argv[1], sys.argv[2], sys.argv[3]
only = sys.argv[4:] 
log = open(f'/tmp/claude-0/mut/{label}.results', 'a')
def digest():
    h = hashlib.sha256()
    for _, f, _, _ in MUTANTS:
        h.update(open(os.path.join(tree, f), 'rb').read())
    return h.hexdigest()
def swap(f, old, new):
    p = os.path.join(tree, f)
    s = open(p).read()
    assert s.count(old) == 1 and s.count(new) == 0, (f, old)
    open(p, 'w').write(s.replace(old, new))
base = digest()
# Apply and revert every mutant before the first build.
for name, f, old, new in MUTANTS:
    if not only or name in only:
        swap(f, old, new); swap(f, new, old)
assert digest() == base
def build(tag):
    r = subprocess.run(['nice', '-n', '5', './build.sh', '--jobs', jobs], cwd=tree, capture_output=True, text=True)
    open(f'/tmp/claude-0/mut/{label}-{tag}.build', 'w').write(r.stdout + r.stderr)
    return r.returncode == 0
def test(tag):
    t = time.time()
    r = subprocess.run(['timeout', '300', './build/compiler', 'test-x86-disassembler'], cwd=tree, capture_output=True, text=True)
    open(f'/tmp/claude-0/mut/{label}-{tag}.test', 'w').write(r.stdout + r.stderr)
    return r.returncode, time.time() - t
ok = build('base')
code, sec = test('base') if ok else (-1, 0)
print(f'{label} base build={ok} test={code} {sec:.1f}s', file=log, flush=True)
for name, f, old, new in MUTANTS:
    if only and name not in only:
        continue
    swap(f, old, new)
    try:
        ok = build(name)
        code, sec = test(name) if ok else (-1, 0)
    finally:
        swap(f, new, old)
    assert digest() == base
    verdict = 'BUILD-FAILED' if not ok else ('killed' if code != 0 else 'SURVIVED')
    print(f'{label} {name} {verdict} exit={code} {sec:.1f}s', file=log, flush=True)
print(f'{label} done', file=log, flush=True)
