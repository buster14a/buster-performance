#!/usr/bin/env python3
# far-counts.py: what four surviving faults change in the counts the tests don't pin: the loads out of a block's reach
# and the records swept, on the fixture's source and the three corpora, in /home/user/mut15/tree4.
import re, subprocess, sys
sys.argv = ['faults3.py', '0', '1', 'none']
TREE = '/home/user/mut15/tree4'
SRC = TREE + '/src/buster/compiler/'
src = open('/home/user/mut15/faults3.py').read()
src = src.replace("TREE = '/home/user/mut15/tree%d' % worker", "TREE = '/home/user/mut15/tree4'")
src = src[:src.index("CORPORA = open('/home/user/mut15/corpora.txt')")]
exec(src)
wanted = sys.argv[4:] if len(sys.argv) > 4 else ['consumers-room', 'far-up-unplaced-too', 'far-left-unplaced-too', 'placed-all']
CORPORA = open('/home/user/mut15/corpora.txt').read().strip().split('\n') + ['fixture /home/user/keep/c-kernel/fixture/contexts4.c']
out = open('/home/user/mut15/far-counts.txt', 'w')
def counts(label):
    for line in CORPORA:
        corpus, arguments = line.split(' ', 1)
        run = subprocess.run('./build/compiler measure-node-machine --shadow --passes 0 --window-contexts --list 3 ' + arguments, shell=True, cwd=TREE, capture_output=True, text=True)
        m = re.search(r"window contexts expressions=(\d+) records=\d+ decided=(\d+) .*?of-them-refused=(\d+) differences=(\d+) .*?out-of-a-block's-reach=(\d+) records-swept=(\d+)", run.stdout)
        out.write('%s %s: status %d %s\n' % (label, corpus, run.returncode, 'expressions %s decided %s refused %s differences %s far %s swept %s' % m.groups() if m else 'no line'))
        out.flush()
subprocess.run(['./build.sh', '--config', 'Debug', '--jobs', '1'], cwd=TREE, capture_output=True, text=True)
counts('base')
for name, f, a, b in FAULTS_ALL:
    if name not in wanted:
        continue
    text = open(SRC + f).read()
    open(SRC + f, 'w').write(text.replace(a, b))
    build = subprocess.run(['./build.sh', '--config', 'Debug', '--jobs', '1'], cwd=TREE, capture_output=True, text=True)
    if build.returncode != 0:
        out.write('%s: NOT BUILT\n' % name)
    else:
        counts(name)
    open(SRC + f, 'w').write(text)
out.write('done\n')
