# The three survivors of run.py's round (m1 the regions' scan, m4 the resource scan, m5 the constant contexts), on an
# archived copy of the branch with the tests that answer them (check_test_graph_marked_end, _resource_node and
# _constant_contexts, test-checker's first part); first the unmutated tree, then each mutant: applied, built, run against
# test-checker's first part, reverted.
import subprocess, os, sys
T = os.path.join(os.path.dirname(os.path.abspath(__file__)), 'tree')
C = os.path.join(T, 'src/buster/compiler')
MUTANTS = [('m1', 'c_checker.c', 'const __mmask64 lanes = (__mmask64)_bzhi_u64(~(uint64_t)0, live);\n        const __m512i block = _mm512_maskz_loadu_epi8(lanes, marks + end);', 'const __mmask64 lanes = (__mmask64)_bzhi_u64(~(uint64_t)0, live) & (UINT64_MAX >> 1);\n        const __m512i block = _mm512_maskz_loadu_epi8(lanes, marks + end);'), ('m4', 'c_checker.c', 'const __mmask16 exhausted = _mm512_cmpeq_epi32_mask(_mm512_loadu_si512(stream->diagnostics + node), _mm512_set1_epi32(CHECK_DIAG_RESOURCE));', 'const __mmask16 exhausted = _mm512_cmpeq_epi32_mask(_mm512_loadu_si512(stream->diagnostics + node), _mm512_set1_epi32(CHECK_DIAG_RESOURCE)) & 0x7fff;'), ('m5', 'c_checker.c', 'skipped = _mm512_test_epi8_mask(_mm512_or_si512(contexts, _mm512_loadu_si512(marks + first)), _mm512_set1_epi8(-1)) == 0;', 'skipped = _mm512_test_epi8_mask(_mm512_or_si512(contexts, _mm512_loadu_si512(marks + first)), _mm512_set1_epi8((char)0xfe)) == 0;')]
log = open(os.path.join(os.path.dirname(T), 'results.txt'), 'a')
def run(cmd, cwd, out):
    with open(out, 'w') as f:
        return subprocess.call(cmd, cwd=cwd, stdout=f, stderr=subprocess.STDOUT, shell=True)
def part1(name):
    d = os.path.join(os.path.dirname(T), name)
    os.makedirs(d, exist_ok=True)
    if run('timeout -k 5 1800 ./build.sh', T, os.path.join(d, 'build.log')) != 0:
        return 'build failed'
    code = run('timeout -k 5 1200 ./build/compiler test-checker --seed 133 --part 1/8', T, os.path.join(d, 'checker-1.log'))
    tail = open(os.path.join(d, 'checker-1.log')).read().strip().split('\n')[-1]
    return ('killed by checker 1' if code != 0 else 'SURVIVED') + ' (' + tail + ')'
print('none', part1('none'), file=log, flush=True)
for name, f, old, new in MUTANTS:
    p = os.path.join(C, f)
    s = open(p).read()
    assert s.count(old) == 1, (name, s.count(old))
    open(p, 'w').write(s.replace(old, new))
    try:
        print(name, part1(name), file=log, flush=True)
    finally:
        open(p, 'w').write(s)
print('done', file=log, flush=True)
