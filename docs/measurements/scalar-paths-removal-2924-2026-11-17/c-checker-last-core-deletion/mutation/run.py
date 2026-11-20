# core-3's mutants (#2924 C12c-3): the vector code whose twins the deletion removes, each built in the archived tree of
# the deletion and run against test-checker's eight parts, test-checker-driver's eight, test-checker-deferred and
# test-check-lanes. One mutant at a time: applied, built, tested, reverted.
import subprocess, os, sys
T = os.path.join(os.path.dirname(os.path.abspath(__file__)), 'tree')
C = os.path.join(T, 'src/buster/compiler')
U = 'c_check_unsequenced.c'
MUTANTS = [
    # The control: the tree as it is.
    ('none', 'c_check_environment.c', 'const __mmask64 mask = live == 64 ? ~(__mmask64)0 : (((__mmask64)1 << live) - 1);',
              'const __mmask64 mask = live == 64 ? ~(__mmask64)0 : (((__mmask64)1 << live) - 1);'),
    # The marks miss a plain assignment.
    ('u1', U, '        selected |= _mm512_mask_cmpeq_epi32_mask(lanes, ops, _mm512_set1_epi32(CHECK_OP_ASSIGN));\n', ''),
    # The marks drop each 16 nodes' last.
    ('u2', U, '''        selected = _mm512_mask_cmpge_epu32_mask(lanes, ops, _mm512_set1_epi32(CHECK_OP_PRE_INCREMENT)) &
                   _mm512_mask_cmple_epu32_mask''', '''        selected = _mm512_mask_cmpge_epu32_mask(lanes & 0x7fff, ops, _mm512_set1_epi32(CHECK_OP_PRE_INCREMENT)) &
                   _mm512_mask_cmple_epu32_mask'''),
    # The repeats' first pass misses a compound assignment's last operator.
    ('u3', U, '''                                    _mm512_mask_cmple_epu32_mask(lanes, ops, _mm512_set1_epi32(CHECK_OP_BIT_XOR_ASSIGN))) |''',
              '''                                    _mm512_mask_cmplt_epu32_mask(lanes, ops, _mm512_set1_epi32(CHECK_OP_BIT_XOR_ASSIGN))) |'''),
    # The repeats' second pass drops each 16 nodes' last value.
    ('u4', U, '''                                   _mm512_mask_cmpeq_epi32_mask(lanes, ops, _mm512_set1_epi32(CHECK_OP_VALUE));''',
              '''                                   _mm512_mask_cmpeq_epi32_mask(lanes & 0x7fff, ops, _mm512_set1_epi32(CHECK_OP_VALUE));'''),
    # The repeats' first pass misses a plain assignment.
    ('u5', U, '''                                       _mm512_mask_cmpeq_epi32_mask(lanes, ops, _mm512_set1_epi32(CHECK_OP_ASSIGN)) :''',
              '''                                       0 :'''),
    # The entries drop each 64 tokens' last 16.
    ('d1', 'c_check_deferred.c', '            set |= (uint64_t)_mm512_mask_cmpneq_epu32_mask(active, values, empty) << (part * 16);',
              '            set |= part == 3 ? 0 : (uint64_t)_mm512_mask_cmpneq_epu32_mask(active, values, empty) << (part * 16);'),
    # The 64-bit entries drop each 64 tokens' last 8.
    ('d2', 'c_check_deferred.c', '            set |= (uint64_t)_mm512_mask_test_epi64_mask(active, values, values) << (part * 8);',
              '            set |= part == 7 ? 0 : (uint64_t)_mm512_mask_test_epi64_mask(active, values, values) << (part * 8);'),
    # The byte count drops each 64 tokens' last.
    ('d3', 'c_check_deferred.c', 'const __mmask64 active = length == 64 ? ~(__mmask64)0 : (((__mmask64)1 << length) - 1);',
              'const __mmask64 active = (length == 64 ? ~(__mmask64)0 : (((__mmask64)1 << length) - 1)) & (UINT64_MAX >> 1);'),
    # The append relocates a leaf slot's none too.
    ('d4', 'c_check_deferred_expressions.c', '_mm512_mask_storeu_epi32(to->field + base + n, lanes, _mm512_mask_add_epi32(old, present, old, delta)); \\',
              '_mm512_mask_storeu_epi32(to->field + base + n, lanes, _mm512_mask_add_epi32(old, present | lanes, old, delta)); \\'),
    # The append's arguments miss a varargs call's.
    ('d5', 'c_check_deferred_expressions.c', 'const __mmask16 arguments = _mm512_mask_test_epi32_mask(lanes, _mm512_or_si512(low, high), _mm512_set1_epi32(1)) | varargs;',
              'const __mmask16 arguments = _mm512_mask_test_epi32_mask(lanes, _mm512_or_si512(low, high), _mm512_set1_epi32(1));'),
    # The token nodes' relocation drops each 16 tokens' last.
    ('d6', 'c_check_deferred_expressions.c', 'const __mmask16 present = _mm512_mask_cmpneq_epu32_mask(lanes, old, _mm512_set1_epi32((int32_t)BUSTER_CHECK_NONE));',
              'const __mmask16 present = _mm512_mask_cmpneq_epu32_mask(lanes & 0x7fff, old, _mm512_set1_epi32((int32_t)BUSTER_CHECK_NONE));'),
    # The overload index's probe drops each group's last key.
    ('o1', 'c_check_overload_index.c', 'uint32_t matches = _mm512_cmpeq_epi64_mask(keys, _mm512_set1_epi64((long long)key));',
              'uint32_t matches = _mm512_cmpeq_epi64_mask(keys, _mm512_set1_epi64((long long)key)) & 0x7f;'),
    # The overload index's probe misses each group's last empty slot.
    ('o2', 'c_check_overload_index.c', 'const uint32_t empty = _mm512_cmpeq_epi64_mask(keys, _mm512_setzero_si512());',
              'const uint32_t empty = _mm512_cmpeq_epi64_mask(keys, _mm512_setzero_si512()) & 0x7f;'),
    # The mangling's substitutions drop each 16's last.
    ('m1', 'c_check_mangle.c', 'const uint32_t matches = _mm512_mask_cmpeq_epi32_mask(active, values, _mm512_set1_epi32((int32_t)type));',
              'const uint32_t matches = _mm512_mask_cmpeq_epi32_mask(active & 0x7fff, values, _mm512_set1_epi32((int32_t)type));'),
    # The mangling's global tags miss the bodies' openings.
    ('m2', 'c_check_mangle.c', '''check_input_scan_equal(input->declaration_kinds, first, input->token_count, C_BINDING_TAG_KIND) |
                                       check_input_scan_equal(parser->tree.roles, first, input->token_count, PARSE_ROLE_OPEN_BODY);''',
              '''check_input_scan_equal(input->declaration_kinds, first, input->token_count, C_BINDING_TAG_KIND);'''),
    # The environment's body count drops each 64 roles' last.
    ('e1', 'c_check_environment.c', 'const __mmask64 mask = live == 64 ? ~(__mmask64)0 : (((__mmask64)1 << live) - 1);',
              'const __mmask64 mask = (live == 64 ? ~(__mmask64)0 : (((__mmask64)1 << live) - 1)) & (UINT64_MAX >> 1);'),
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
        # Batches in an order that puts each area's likeliest killer first; a mutant stops at its first failing batch.
        checker = [('checker', (1, 2, 3, 4)), ('checker', (5, 6, 7, 8))]
        driver = [('driver', (1, 2, 3, 4)), ('driver', (5, 6, 7, 8))]
        extra = [('extra', ())]
        order = (extra + checker + driver) if name.startswith('d') else (driver + checker + extra) if name.startswith('u') else (checker + driver + extra)
        for kind, half in order:
            if fails:
                break
            if kind == 'checker':
                procs = [subprocess.Popen(f'timeout -k 5 1200 ./build/compiler test-checker --seed 133 --part {k}/8 > {d}/checker-{k}.log 2>&1', cwd=T, shell=True) for k in half]
                fails += [f'checker {k}' for k, q in zip(half, procs) if q.wait() != 0]
            elif kind == 'driver':
                procs = [subprocess.Popen(f'timeout -k 5 1800 ./build/compiler test-checker-driver --executable ./build/compiler --part {k}/8 --in-process > {d}/driver-{k}.log 2>&1', cwd=T, shell=True) for k in half]
                fails += [f'driver {k}' for k, q in zip(half, procs) if q.wait() != 0]
            else:
                tests = [('deferred', 'test-checker-deferred'), ('lanes', 'test-check-lanes')]
                procs = [subprocess.Popen(f'timeout -k 5 1800 ./build/compiler {cmd} > {d}/{tag}.log 2>&1', cwd=T, shell=True) for tag, cmd in tests]
                fails += [tag for (tag, cmd), q in zip(tests, procs) if q.wait() != 0]
        print(name, 'killed by ' + ', '.join(fails) if fails else 'SURVIVED', file=log, flush=True)
    finally:
        open(p, 'w').write(s)
print('done', file=log, flush=True)
