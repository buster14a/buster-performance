# Runs each mutant of mutants_c12a.py in an archived copy of the tree (never a worktree): apply, build Develop
# incrementally (./build.sh), run test-preprocessor (from the tree's root, for its digests) and test-files, revert,
# and check the tree is back to its base digest.
import os, subprocess, sys, hashlib, time
here = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, here)
from mutants_c12a import MUTANTS
tree, label = sys.argv[1], sys.argv[2]
only = sys.argv[3:]
log = open(f'{here}/{label}.results', 'a')
def digest():
    h = hashlib.sha256()
    for f in sorted(set(m[1] for m in MUTANTS)):
        h.update(open(os.path.join(tree, f), 'rb').read())
    return h.hexdigest()
base = digest()
for name, f, old, new in MUTANTS:
    if not only or name in only:
        assert open(os.path.join(tree, f)).read().count(old) == 1, (name, old)
def build(tag):
    r = subprocess.run(['nice', '-n', '10', './build.sh'], cwd=tree, capture_output=True, text=True)
    open(f'{here}/{label}-{tag}.build', 'w').write(r.stdout[-20000:] + r.stderr[-20000:])
    return r.returncode == 0
def test(tag):
    t = time.time()
    env = dict(os.environ, TMPDIR=f'{here}/tmp')
    os.makedirs(env['TMPDIR'], exist_ok=True)
    failed = []
    out = ''
    for tname, args in (('preprocessor', ['test-preprocessor', '--jobs', '4']), ('files', ['test-files'])):
        r = subprocess.run(['timeout', '900', f'{tree}/build/compiler'] + args, cwd=tree, capture_output=True, text=True, env=env)
        out += f'== {tname} exit {r.returncode}\n' + r.stdout[-30000:] + r.stderr[-6000:]
        if r.returncode != 0:
            failed.append(tname)
    open(f'{here}/{label}-{tag}.test', 'w').write(out)
    return failed, time.time() - t
ok = build('base')
failed, sec = test('base') if ok else (['build'], 0)
print(f'{label} base build={ok} failed={failed} {sec:.1f}s', file=log, flush=True)
for name, f, old, new in MUTANTS:
    if only and name not in only:
        continue
    p = os.path.join(tree, f)
    s = open(p).read()
    open(p, 'w').write(s.replace(old, new))
    try:
        ok = build(name)
        failed, sec = test(name) if ok else (['build'], 0)
    finally:
        open(p, 'w').write(s)
    assert digest() == base
    verdict = 'BUILD-FAILED' if not ok else ('killed' if failed else 'SURVIVED')
    print(f'{label} {name} {verdict} by={failed} {sec:.1f}s', file=log, flush=True)
print(f'{label} done', file=log, flush=True)
