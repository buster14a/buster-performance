#!/usr/bin/env python3
# faults.py WORKER OF [check]: the null constant's piece's faults (#3012, #3014, #3017), one at a time in the copy
# /home/user/mut16/treeWORKER: a text of the piece's code replaced by a faulty one, the Debug compiler built, the node
# machine's tests run (test-checker part 5 of 8), and for a fault the tests don't fail the piece's statements one at a
# time (probe4.py on null2.txt and null3.txt): whether any line differs from the base's. Worker WORKER of OF takes
# every OF-th fault. Results in /home/user/mut17/results-WORKER.txt. With `check`, only that every text is there once.
import os, re, subprocess, sys, time
worker, of = int(sys.argv[1]), int(sys.argv[2])
ROUND = os.environ.get('ROUND', '1')
TREE = '/home/user/mut16/tree%d' % worker
SRC = TREE + '/src/buster/compiler/'
FA = 'c_check_node_machine_facts.c'
C = 'c_check_node_census.c'
texts = {}
def text(f):
    if f not in texts:
        texts[f] = open(SRC + f).read()
    return texts[f]
def body(f, header):
    t = text(f)
    assert t.count(header) == 1, (header, t.count(header))
    i = t.index(header)
    j = t.index('\n}\n', i) + 3
    return t[i:j]
FAULTS = []
def F(name, f, header, a, b):
    whole = body(f, header)
    n = whole.count(a)
    FAULTS.append((name, f, whole, whole.replace(a, b), n))
def P(name, f, a, b):
    FAULTS.append((name, f, a, b, text(f).count(a)))



# Round 3: the initializer's root's ask, counted.
OWNROOT = 'static inline uint64_t node_tests_root('
F('own-root-no-null', C, OWNROOT, 'tests |= asked && node_census_null_warned(s, root, declared) ? UINT64_C(1) << NODE_CENSUS_CONSTANT : 0;', 'tests |= asked && count == 0 && node_census_null_warned(s, root, declared) ? UINT64_C(1) << NODE_CENSUS_CONSTANT : 0;')
F('own-root-not-asked', C, OWNROOT, 'const bool asked = policy->non_literal_null && kind == CHECK_CONSTANT_INTEGER && node_tests_null_asked(s, count - 1, node_census_type_bits(s, declared));', 'const bool asked = policy->non_literal_null && kind == CHECK_CONSTANT_INTEGER;')
F('own-root-asked-is-warned', C, OWNROOT, 'tests |= asked && node_census_null_warned(s, root, declared) ? UINT64_C(1) << NODE_CENSUS_CONSTANT : 0;', 'tests |= asked ? UINT64_C(1) << NODE_CENSUS_CONSTANT : 0;')
F('own-root-any-constant', C, OWNROOT, 'const bool asked = policy->non_literal_null && kind == CHECK_CONSTANT_INTEGER && node_tests_null_asked', 'const bool asked = policy->non_literal_null && kind != CHECK_CONSTANT_NONE && node_tests_null_asked')
F('own-root-whatever-the-policy', C, OWNROOT, 'const bool asked = policy->non_literal_null && kind == CHECK_CONSTANT_INTEGER && node_tests_null_asked', 'const bool asked = kind == CHECK_CONSTANT_INTEGER && node_tests_null_asked')
F('own-root-not-counted', C, OWNROOT, 'counts->own_root_nulls += asked;', 'counts->own_root_nulls += asked && count == 0;')

names = [f[0] for f in FAULTS]
assert len(set(names)) == len(names), [n for n in names if names.count(n) > 1]
if len(sys.argv) > 3 and sys.argv[3] == 'check':
    bad = 0
    for name, f, a, b, n in FAULTS:
        if n != 1 or text(f).count(a) != 1 or a == b:
            print('NOT ONCE', name, n, text(f).count(a), a == b); bad += 1
    print(len(FAULTS), 'faults,', bad, 'bad')
    sys.exit(1 if bad else 0)
KEEP = None
if os.path.exists('/home/user/mut17/round3-names.txt'):
    KEEP = set(open('/home/user/mut17/round3-names.txt').read().split())
PROBES = '/home/user/keep/null/probes'
def probes(compiler):
    lines = []
    for name in ['null2.txt', 'null3.txt']:
        run = subprocess.run(['python3', PROBES + '/probe4.py', compiler, name], cwd='/home/user/mut17/probe%d' % worker, capture_output=True, text=True, timeout=3000)
        lines += run.stdout.split('\n')
    return lines
out = open('/home/user/mut17/results3-%d.txt' % worker, 'w')
todo = [f for f in FAULTS if KEEP is None or f[0] in KEEP]
base_lines = None
for index, (name, f, a, b, n) in enumerate(todo):
    if index % of != worker:
        continue
    source = open(SRC + f).read()
    assert source.count(a) == 1, (name, source.count(a))
    open(SRC + f, 'w').write(source.replace(a, b))
    t0 = time.time()
    build = subprocess.run(['./build.sh', '--config', 'Debug', '--jobs', '1'], cwd=TREE, capture_output=True, text=True)
    if build.returncode != 0:
        verdict = 'NOT BUILT ' + (build.stdout + build.stderr)[-300:].replace('\n', ' ')
    else:
        try:
            test = subprocess.run(['./build/compiler', 'test-checker', '--seed', '133', '--part', '5/8'], cwd=TREE, capture_output=True, text=True, timeout=1200)
            first = (test.stderr.strip().split('\n') or [''])[0][:160]
            verdict = ('caught' if test.returncode != 0 else 'SURVIVED') + ' [status %d] %s' % (test.returncode, first)
        except subprocess.TimeoutExpired:
            verdict = 'TIMED OUT'
        if verdict.startswith('SURVIVED'):
            if base_lines is None:
                base_lines = open('/home/user/mut17/base-probes.txt').read().split('\n')
            try:
                got = probes(TREE + '/build/compiler')
                told = [l for l in got if l and l not in base_lines]
                verdict += ' || probes: %d lines not the base\'s%s' % (len(told), (': ' + told[0][:150]) if told else '')
            except subprocess.TimeoutExpired:
                verdict += ' || probes: timed out'
    out.write('%s: %s (%d s)\n' % (name, verdict, time.time() - t0)); out.flush()
    open(SRC + f, 'w').write(source)
out.write('done\n'); out.close()
