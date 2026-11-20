# The checker core's mutants (#2924 C12c-3), each built in the archived tree of the deletion (82d4a4e4a) and run against
# test-checker's eight parts and test-checker-driver's eight. One mutant at a time: applied, built, tested, reverted.
import subprocess, os, sys
T = os.path.join(os.path.dirname(os.path.abspath(__file__)), 'tree')
C = os.path.join(T, 'src/buster/compiler')
W = 'c_checker.c'
MUTANTS = [
    # The marked run's scan never reads a block's last mark.
    ('m1', W, 'const __mmask64 lanes = (__mmask64)_bzhi_u64(~(uint64_t)0, live);\n        const __m512i block = _mm512_maskz_loadu_epi8(lanes, marks + end);',
              'const __mmask64 lanes = (__mmask64)_bzhi_u64(~(uint64_t)0, live) & (UINT64_MAX >> 1);\n        const __m512i block = _mm512_maskz_loadu_epi8(lanes, marks + end);'),
    # The warning contexts' scan drops each block's last warning.
    ('m2', W, '__mmask16 candidates = _mm512_test_epi32_mask(_mm512_loadu_si512(stream->warnings + node), _mm512_set1_epi32(-1));',
              '__mmask16 candidates = _mm512_test_epi32_mask(_mm512_loadu_si512(stream->warnings + node), _mm512_set1_epi32(-1)) & 0x7fff;'),
    # The reports' scan drops each block's last diagnostic.
    ('m3', W, '__mmask16 reported = _mm512_cmpneq_epi32_mask(_mm512_loadu_si512(stream->diagnostics + node), _mm512_set1_epi32(CHECK_DIAG_NONE));',
              '__mmask16 reported = _mm512_cmpneq_epi32_mask(_mm512_loadu_si512(stream->diagnostics + node), _mm512_set1_epi32(CHECK_DIAG_NONE)) & 0x7fff;'),
    # The resource scan drops each block's last lane.
    ('m4', W, 'const __mmask16 exhausted = _mm512_cmpeq_epi32_mask(_mm512_loadu_si512(stream->diagnostics + node), _mm512_set1_epi32(CHECK_DIAG_RESOURCE));',
              'const __mmask16 exhausted = _mm512_cmpeq_epi32_mask(_mm512_loadu_si512(stream->diagnostics + node), _mm512_set1_epi32(CHECK_DIAG_RESOURCE)) & 0x7fff;'),
    # The constant contexts skip a block whose only marks are later nodes'.
    ('m5', W, 'skipped = _mm512_test_epi8_mask(_mm512_or_si512(contexts, _mm512_loadu_si512(marks + first)), _mm512_set1_epi8(-1)) == 0;',
              'skipped = _mm512_test_epi8_mask(_mm512_or_si512(contexts, _mm512_loadu_si512(marks + first)), _mm512_set1_epi8((char)0xfe)) == 0;'),
    # A discard's shortcut takes an lvalue too.
    ('m6', W, 'taken = type_is_valid(types, value->type) && value->overload_head == 0 && value->category == CHECK_RVALUE;',
              'taken = type_is_valid(types, value->type) && value->overload_head == 0;'),
    # A leaf with an overload set completes as a plain leaf.
    ('m7', W, 'return graph->ops[node] == CHECK_OP_VALUE && (graph->overload_candidate_count == 0 || check_graph_leaf_overload_head(graph, node) == 0);',
              'return graph->ops[node] == CHECK_OP_VALUE;'),
    # The transitions' statics drop each block's last eligible node.
    ('m8', 'c_check_transitions.c', '        eligible &= (__mmask16)~(_mm512_test_epi32_mask(member, _mm512_set1_epi32((int)BUSTER_CHECK_LIBRARY_CALL)) |',
              '        eligible &= 0x7fff & (__mmask16)~(_mm512_test_epi32_mask(member, _mm512_set1_epi32((int)BUSTER_CHECK_LIBRARY_CALL)) |'),
    # The validator's blocks let an operand equal its node.
    ('m9', W, 'valid &= (used & _mm512_cmplt_epu32_mask(operands[i], nodes)) | ((__mmask16)~used & _mm512_cmpeq_epi32_mask(operands[i], none));',
              'valid &= (used & _mm512_cmple_epu32_mask(operands[i], nodes)) | ((__mmask16)~used & _mm512_cmpeq_epi32_mask(operands[i], none));'),
]
if __name__ == '__main__' and sys.argv[1:2] == ['--check']:
    for name, f, old, new in MUTANTS:
        n = open(os.path.join(sys.argv[2], f)).read().count(old)
        print(name, f, n)
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
        b = run('timeout -k 5 1800 ./build.sh', T, os.path.join(d, 'build.log'))
        if b != 0:
            print(name, 'build failed', file=log, flush=True)
            continue
        fails = []
        for half in ((1, 2, 3, 4), (5, 6, 7, 8)):
            procs = [subprocess.Popen(f'timeout -k 5 1200 ./build/compiler test-checker --seed 133 --part {k}/8 > {d}/checker-{k}.log 2>&1', cwd=T, shell=True) for k in half]
            codes = [q.wait() for q in procs]
            fails += [f'checker {k}' for k, c in zip(half, codes) if c != 0]
        for half in ((1, 2, 3, 4), (5, 6, 7, 8)):
            procs = [subprocess.Popen(f'timeout -k 5 1800 ./build/compiler test-checker-driver --executable ./build/compiler --part {k}/8 --in-process > {d}/driver-{k}.log 2>&1', cwd=T, shell=True) for k in half]
            codes = [q.wait() for q in procs]
            fails += [f'driver {k}' for k, c in zip(half, codes) if c != 0]
        print(name, 'killed by ' + ', '.join(fails) if fails else 'SURVIVED', file=log, flush=True)
    finally:
        open(p, 'w').write(s)
print('done', file=log, flush=True)
