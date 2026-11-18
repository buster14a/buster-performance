#!/usr/bin/env python3
# faults2.py WORKER OF (the three texts of faults.py that didn't compile, corrected): the fourth piece's faults (the casts, a pointer's subscripts and its sums), one at a time, in the
# copy /home/user/mut14/treeWORKER: a text of the piece's code replaced by a faulty one, the Debug compiler built, and
# the node machine's tests run (test-checker part 5 of 8). A fault the tests don't fail is a survivor. Worker WORKER of
# OF takes every OF-th fault. Results in /home/user/mut14/results-WORKER.txt.
import subprocess, sys, time
worker, of = int(sys.argv[1]), int(sys.argv[2])
TREE = '/home/user/mut14/tree%d' % worker
SRC = TREE + '/src/buster/compiler/'
C = 'c_check_node_census.c'
FAULTS = [
    ('read-every-operator', C, 'const __mmask64 quiet = quiet_class & alone & ~(subscripts & pointer_read);', 'const __mmask64 quiet = quiet_class & alone & ~((subscripts | ~subscripts) & pointer_read);'),
    ('read-no-operator', C, 'const __mmask64 quiet = quiet_class & alone & ~(subscripts & pointer_read);', 'const __mmask64 quiet = quiet_class & alone & ~(subscripts & pointer_read & 0);'),
    ('count-not-given', C, '    *cast_count += cast_total;\n', '    *cast_count += cast_total * 0;\n'),
]
out = open('/home/user/mut14/results2-%d.txt' % worker, 'w')
for index, (name, f, a, b) in enumerate(FAULTS):
    if index % of != worker:
        continue
    text = open(SRC + f).read()
    assert text.count(a) == 1, (name, text.count(a))
    open(SRC + f, 'w').write(text.replace(a, b))
    t0 = time.time()
    build = subprocess.run(['./build.sh', '--config', 'Debug', '--jobs', '2'], cwd=TREE, capture_output=True, text=True)
    if build.returncode != 0:
        verdict = 'NOT BUILT ' + (build.stdout + build.stderr)[-300:].replace('\n', ' ')
    else:
        try:
            test = subprocess.run(['./build/compiler', 'test-checker', '--seed', '133', '--part', '5/8'], cwd=TREE, capture_output=True, text=True, timeout=1200)
            first = (test.stderr.strip().split('\n') or [''])[0][:300]
            verdict = ('caught' if test.returncode != 0 else 'SURVIVED') + ' [status %d] %s' % (test.returncode, first)
        except subprocess.TimeoutExpired:
            verdict = 'TIMED OUT'
    out.write('%s: %s (%d s)\n' % (name, verdict, time.time() - t0)); out.flush()
    open(SRC + f, 'w').write(text)
out.write('done\n'); out.close()
