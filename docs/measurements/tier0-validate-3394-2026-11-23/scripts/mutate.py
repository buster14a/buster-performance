# The fault round (buster#3394): each mutant of MUTANTS built in /home/user/exp3394 (main + v10.patch + the mutant) and
# test-tier0 run on it; a mutant is killed when test-tier0 reports a failed check.
import subprocess, sys, re, time
sys.path.insert(0, '/home/user/work3394')
from mutants import MUTANTS
tree = '/home/user/exp3394'
log = open('/home/user/work3394/mutants.log', 'a')
for name, a, b in MUTANTS:
    subprocess.run(['git', 'checkout', '-q', '.'], cwd=tree, check=True)
    subprocess.run(['git', 'apply', '/home/user/work3394/v10.patch'], cwd=tree, check=True)
    p = tree + '/src/buster/compiler/tier0.c'
    s = open(p).read()
    assert s.count(a) == 1, name
    open(p, 'w').write(s.replace(a, b))
    start = time.time()
    built = subprocess.run(['./build.sh', '--config', 'Release'], cwd=tree, capture_output=True, text=True)
    if built.returncode != 0:
        log.write('%s: not built\n' % name); log.flush(); continue
    test = subprocess.run(['timeout', '900', './build/compiler', 'test-tier0'], cwd=tree, capture_output=True, text=True)
    m = re.search(r'test-tier0: (\d+) checks, (\d+) failed', test.stdout + test.stderr)
    failed = int(m.group(2)) if m else -1
    first = [l for l in (test.stdout + test.stderr).splitlines() if l.startswith('test-tier0: ') and 'checks,' not in l][:1]
    log.write('%s: %s (%s failed, exit %d, %.0f s) %s\n' % (name, 'killed' if failed != 0 else 'SURVIVED', failed, test.returncode, time.time() - start, first[0][:160] if first else ''))
    log.flush()
subprocess.run(['git', 'checkout', '-q', '.'], cwd=tree, check=True)
log.write('done\n')
