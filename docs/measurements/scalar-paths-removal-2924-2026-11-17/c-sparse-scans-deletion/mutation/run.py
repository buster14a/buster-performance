# The sparse scans', the generic masks' and the selection positions' mutants (#2924 C12c-3 core-2), each built in the
# archived tree of the deletion (19e6a2172) and run against test-checker's eight parts, test-checker-driver's eight,
# test-checker-deferred and test-check-lanes. One mutant at a time: applied, built, tested, reverted.
import subprocess, os, sys
T = os.path.join(os.path.dirname(os.path.abspath(__file__)), 'tree')
C = os.path.join(T, 'src/buster/compiler')
S = 'c_check_sparse.c'
MUTANTS = [
    # The control: the tree as it is.
    ('none', 'c_check_generic.c', 'const uint32_t empty = _mm512_cmpeq_epi32_mask(block, _mm512_setzero_si512());',
              'const uint32_t empty = _mm512_cmpeq_epi32_mask(block, _mm512_setzero_si512());'),
    # The entries' scan drops each block's last lane.
    ('s1', S, 'for (uint32_t set = _mm512_mask_cmpneq_epu32_mask((__mmask16)lanes, values, _mm512_set1_epi32((int)BUSTER_CHECK_NONE)); set != 0',
              'for (uint32_t set = _mm512_mask_cmpneq_epu32_mask((__mmask16)lanes & 0x7fff, values, _mm512_set1_epi32((int)BUSTER_CHECK_NONE)); set != 0'),
    # The entries' scan takes a block's tokens before `begin` too.
    ('s2', S, 'const uint32_t lanes = ((stop == BUSTER_CHECK_SPARSE_TOKENS ? 0x10000u : 1u << stop) - 1) & ~((1u << (first - start)) - 1);',
              'const uint32_t lanes = ((stop == BUSTER_CHECK_SPARSE_TOKENS ? 0x10000u : 1u << stop) - 1);'),
    # The next entry's block test drops each block's last lane.
    ('s3', S, 'const uint32_t set = _mm512_mask_cmpneq_epu32_mask((__mmask16)lanes, values, _mm512_set1_epi32((int)BUSTER_CHECK_NONE));',
              'const uint32_t set = _mm512_mask_cmpneq_epu32_mask((__mmask16)lanes & 0x7fff, values, _mm512_set1_epi32((int)BUSTER_CHECK_NONE));'),
    # The next entry's block test takes tokens before `token` too.
    ('s4', S, 'const uint32_t lanes = ((stop == BUSTER_CHECK_SPARSE_TOKENS ? 0x10000u : 1u << stop) - 1) & ~((1u << (result - start)) - 1);',
              'const uint32_t lanes = ((stop == BUSTER_CHECK_SPARSE_TOKENS ? 0x10000u : 1u << stop) - 1);'),
    # The next entry's directory scan skips each 16 entries' last.
    ('s5', S, 'const uint32_t set = _mm512_mask_test_epi32_mask(lanes, blocks, _mm512_set1_epi32((int)~BUSTER_CHECK_SPARSE_CLAIMED));',
              'const uint32_t set = _mm512_mask_test_epi32_mask(lanes & 0x7fff, blocks, _mm512_set1_epi32((int)~BUSTER_CHECK_SPARSE_CLAIMED));'),
    # The wide columns' directory scan skips each 16 entries' last.
    ('s6', S, 'const uint32_t taken = _mm512_mask_test_epi32_mask(lanes, blocks, _mm512_set1_epi32((int)~BUSTER_CHECK_SPARSE_CLAIMED));',
              'const uint32_t taken = _mm512_mask_test_epi32_mask(lanes & 0x7fff, blocks, _mm512_set1_epi32((int)~BUSTER_CHECK_SPARSE_CLAIMED));'),
    # The wide group drops its high 8 tokens.
    ('s7', S, '(uint32_t)_mm512_mask_cmpneq_epu64_mask((__mmask8)lanes, low, none) | (uint32_t)_mm512_mask_cmpneq_epu64_mask((__mmask8)(lanes >> 8), high, none) << 8;',
              '(uint32_t)_mm512_mask_cmpneq_epu64_mask((__mmask8)lanes, low, none);'),
    # The generic masks' empty lanes are the key's.
    ('s8', 'c_check_generic.c', 'const uint32_t empty = _mm512_cmpeq_epi32_mask(block, _mm512_setzero_si512());',
              'const uint32_t empty = _mm512_cmpeq_epi32_mask(block, _mm512_setzero_si512()) & 0x7fff;'),
    # A selection keyword that is another child than its close's first counts too.
    ('s9', 'c_check_select.c', 'if (close < count && first_child[close] == keyword)', 'if (close < count)'),
]
if __name__ == '__main__' and sys.argv[1:2] == ['--check']:
    for name, f, old, new in MUTANTS:
        print(name, f, open(os.path.join(C, f)).read().count(old))
    sys.exit(0)
log = open(os.path.join(os.path.dirname(T), 'results.txt'), 'a')
def run(cmd, cwd, out):
    with open(out, 'w') as f:
        return subprocess.call(cmd, cwd=cwd, stdout=f, stderr=subprocess.STDOUT, shell=True)
only = sys.argv[1:]
for name, f, old, new in MUTANTS:
    if only and name not in only:
        continue
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
        fails = []
        for half in ((1, 2, 3, 4), (5, 6, 7, 8)):
            procs = [subprocess.Popen(f'timeout -k 5 1200 ./build/compiler test-checker --seed 133 --part {k}/8 > {d}/checker-{k}.log 2>&1', cwd=T, shell=True) for k in half]
            fails += [f'checker {k}' for k, q in zip(half, procs) if q.wait() != 0]
        for half in ((1, 2, 3, 4), (5, 6, 7, 8)):
            procs = [subprocess.Popen(f'timeout -k 5 1800 ./build/compiler test-checker-driver --executable ./build/compiler --part {k}/8 --in-process > {d}/driver-{k}.log 2>&1', cwd=T, shell=True) for k in half]
            fails += [f'driver {k}' for k, q in zip(half, procs) if q.wait() != 0]
        extra = [('deferred', 'test-checker-deferred'), ('lanes', 'test-check-lanes')]
        procs = [subprocess.Popen(f'timeout -k 5 1800 ./build/compiler {cmd} > {d}/{tag}.log 2>&1', cwd=T, shell=True) for tag, cmd in extra]
        fails += [tag for (tag, cmd), q in zip(extra, procs) if q.wait() != 0]
        print(name, 'killed by ' + ', '.join(fails) if fails else 'SURVIVED', file=log, flush=True)
    finally:
        open(p, 'w').write(s)
print('done', file=log, flush=True)
