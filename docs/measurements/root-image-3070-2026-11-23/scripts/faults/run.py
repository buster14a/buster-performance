#!/usr/bin/env python3
# The fault round: each mutant applied to the tree, built (Develop) and run against the tests; restored after each, and
# the tree rebuilt at the end. usage: run.py [NAME...]  (results appended to results.tsv)
import subprocess, sys, os, shutil, time
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from mutants import MUTANTS
ROOT = '/home/user/buster'
HERE = os.path.dirname(os.path.abspath(__file__))
TESTS = [
 ('corpus', ['./build/compiler', 'test-check-units', '--corpus', 'tests/units/root-image', '--option', '--lanes', '--option', '1']),
 ('errors', ['./build/compiler', 'test-check-units', '--corpus', 'tests/units/root-image/errors', '--option', '--lanes', '--option', '1', '--option', '--attested=off']),
 ('units', ['./build/compiler', 'test-check-units']),
 ('lanes', ['./build/compiler', 'test-lanes']),
]
def sh(args, timeout):
    try:
        p = subprocess.run(args, cwd=ROOT, stdout=subprocess.PIPE, stderr=subprocess.STDOUT, timeout=timeout)
        return p.returncode, p.stdout.decode(errors='replace')
    except subprocess.TimeoutExpired:
        return 124, 'timeout'
def build():
    return sh(['./build.sh'], 3000)
names = sys.argv[1:]
files = sorted({m[1] for m in MUTANTS})
backup = os.path.join(HERE, 'backup')
os.makedirs(backup, exist_ok=True)
for f in files:
    shutil.copyfile(os.path.join(ROOT, f), os.path.join(backup, f.replace('/', '__')))
def restore():
    # Written anew, so that the build sees the file as changed: a copy that kept the backup's time left the mutant's
    # object in place.
    for f in files:
        open(os.path.join(ROOT, f), 'wb').write(open(os.path.join(backup, f.replace('/', '__')), 'rb').read())
try:
    for name, f, old, new in MUTANTS:
        if names and name not in names: continue
        text = open(os.path.join(ROOT, f)).read()
        if text.count(old) != 1:
            open(os.path.join(HERE, 'results.tsv'), 'a').write('%s\tNOT-APPLIED (%d matches)\n' % (name, text.count(old)))
            continue
        open(os.path.join(ROOT, f), 'w').write(text.replace(old, new))
        start = time.time()
        code, out = build()
        if code != 0:
            row = 'NOT-BUILT'
            open(os.path.join(HERE, 'build-%s.log' % name), 'w').write(out[-6000:])
        else:
            failed = []
            for label, args in TESTS:
                c, o = sh(args, 900)
                if c != 0:
                    failed.append(label)
                    open(os.path.join(HERE, 'test-%s-%s.log' % (name, label)), 'w').write(o[-4000:])
            row = 'KILLED by ' + ','.join(failed) if failed else 'SURVIVED'
        open(os.path.join(HERE, 'results.tsv'), 'a').write('%s\t%s\t%d s\n' % (name, row, time.time() - start))
        restore()
finally:
    restore()
    code, out = build()
    open(os.path.join(HERE, 'results.tsv'), 'a').write('RESTORED\tbuild exit %d\n' % code)
