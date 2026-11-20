# The round's survivors (s5, s6) and its mutant that didn't build (s7, written again to drop the wide group's last lane),
# on an archived copy of the branch with the next-entry scans' definitions (check_test_sparse_next, in test-checker's
# seventh part); first the unmutated tree. Each: applied, built, run against test-checker's seventh part, reverted.
import subprocess, os, sys
T = os.path.join(os.path.dirname(os.path.abspath(__file__)), 'tree')
C = os.path.join(T, 'src/buster/compiler')
MUTANTS = [('none', 'c_check_generic.c', 'const uint32_t empty = _mm512_cmpeq_epi32_mask(block, _mm512_setzero_si512());', 'const uint32_t empty = _mm512_cmpeq_epi32_mask(block, _mm512_setzero_si512());'), ('s5', 'c_check_sparse.c', 'const uint32_t set = _mm512_mask_test_epi32_mask(lanes, blocks, _mm512_set1_epi32((int)~BUSTER_CHECK_SPARSE_CLAIMED));', 'const uint32_t set = _mm512_mask_test_epi32_mask(lanes & 0x7fff, blocks, _mm512_set1_epi32((int)~BUSTER_CHECK_SPARSE_CLAIMED));'), ('s6', 'c_check_sparse.c', 'const uint32_t taken = _mm512_mask_test_epi32_mask(lanes, blocks, _mm512_set1_epi32((int)~BUSTER_CHECK_SPARSE_CLAIMED));', 'const uint32_t taken = _mm512_mask_test_epi32_mask(lanes & 0x7fff, blocks, _mm512_set1_epi32((int)~BUSTER_CHECK_SPARSE_CLAIMED));'), ('s7', 'c_check_sparse.c', '(uint32_t)_mm512_mask_cmpneq_epu64_mask((__mmask8)lanes, low, none) | (uint32_t)_mm512_mask_cmpneq_epu64_mask((__mmask8)(lanes >> 8), high, none) << 8;', '(uint32_t)_mm512_mask_cmpneq_epu64_mask((__mmask8)lanes, low, none) | (uint32_t)(_mm512_mask_cmpneq_epu64_mask((__mmask8)(lanes >> 8), high, none) & 0x7f) << 8;')]
log = open(os.path.join(os.path.dirname(T), 'results.txt'), 'a')
def run(cmd, cwd, out):
    with open(out, 'w') as f:
        return subprocess.call(cmd, cwd=cwd, stdout=f, stderr=subprocess.STDOUT, shell=True)
for name, f, old, new in MUTANTS:
    p = os.path.join(C, f)
    s = open(p).read()
    assert s.count(old) == 1, (name, s.count(old))
    open(p, 'w').write(s.replace(old, new))
    try:
        d = os.path.join(os.path.dirname(T), name)
        os.makedirs(d, exist_ok=True)
        if run('timeout -k 5 1800 ./build.sh', T, os.path.join(d, 'build.log')) != 0:
            print(name, 'build failed', file=log, flush=True)
            continue
        code = run('timeout -k 5 600 ./build/compiler test-checker --seed 133 --part 7/8', T, os.path.join(d, 'checker-7.log'))
        tail = open(os.path.join(d, 'checker-7.log')).read().strip().split('\n')[-1]
        print(name, ('killed by checker 7' if code != 0 else 'SURVIVED') + ' (' + tail + ')', file=log, flush=True)
    finally:
        open(p, 'w').write(s)
print('done', file=log, flush=True)
