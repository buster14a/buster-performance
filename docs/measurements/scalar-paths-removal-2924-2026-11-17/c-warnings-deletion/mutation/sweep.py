# sweep.py: m11 and m14 again, with the interrupt driver test's lane sweep (e329788bf), against test-checker's eight parts and all eight of test-checker-driver's (the
# first round ran the driver's first part alone, and the common warnings' driver tests are in another). One mutant at a time:
# applied, built, tested, reverted; a mutant whose pattern isn't found once stops the run. Every test has a timeout.
import subprocess, os, sys
T = os.path.join(os.path.dirname(os.path.abspath(__file__)), 'tree')
C = os.path.join(T, 'src/buster/compiler')
W = 'c_check_common_warnings.c'
MUTANTS = [
    # The token scan drops its last role.
    ('m1', W, 'for (uint32_t r = 0; r < role_count; r += 1)\n            {\n                selected |= _mm512_mask_cmpeq_epi8_mask((__mmask64)lanes, role_bytes',
              'for (uint32_t r = 0; r + 1 < role_count; r += 1)\n            {\n                selected |= _mm512_mask_cmpeq_epi8_mask((__mmask64)lanes, role_bytes'),
    # The operator scan drops each block's last lane.
    ('m2', W, 'const uint32_t selected = check_common_op_lanes(set, _mm512_maskz_loadu_epi32((__mmask16)lanes, graph->ops + first), (__mmask16)lanes);',
              'const uint32_t selected = check_common_op_lanes(set, _mm512_maskz_loadu_epi32((__mmask16)lanes, graph->ops + first), (__mmask16)(lanes & 0x7fff));'),
    # The cached roots' scan drops each block's last lane.
    ('m3', W, 'const uint32_t selected = roots != NULL ? (uint32_t)(roots[first >> 6] >> (first & 63)) & lanes :',
              'const uint32_t selected = roots != NULL ? (uint32_t)(roots[first >> 6] >> (first & 63)) & lanes & 0x7fff :'),
    # The parents' tree test lets a child equal to its node pass.
    ('m4', W, 'ordered &= _mm512_mask_cmplt_epu32_mask(edge, children, nodes) == edge;',
              'ordered &= _mm512_mask_cmple_epu32_mask(edge, children, nodes) == edge;'),
    # The candidate classifier's tail block drops its last lane.
    ('m5', 'c_check_common_candidates.c', 'const __mmask16 present = _mm512_mask_cmplt_epu32_mask(lanes, ops, limit);',
              'const __mmask16 present = _mm512_mask_cmplt_epu32_mask(lanes & 0x7fff, ops, limit);'),
    # The self candidates forget a member operator at a block's end.
    ('m6', W, 'carry = member >> 63;', 'carry = 0;'),
    # The return facts' sources leave out the x86 builtins.
    ('m7', 'c_check_return_flow.c', '_mm512_mask_cmpeq_epi32_mask(live, ops, misc) | _mm512_mask_cmpeq_epi32_mask(live, ops, x86);',
              '_mm512_mask_cmpeq_epi32_mask(live, ops, misc) | (_mm512_mask_cmpeq_epi32_mask(live, ops, x86) & 0);'),
    # The typo filter takes a length a third away no more.
    ('m8', 'c_check_typo.c', 'const __mmask16 near = _mm512_mask_cmple_epu32_mask(ordinary, _mm512_mullo_epi32(difference, three), limit);',
              'const __mmask16 near = _mm512_mask_cmplt_epu32_mask(ordinary, _mm512_mullo_epi32(difference, three), limit);'),
    # The typo builtins' scan takes no statement's semicolon.
    ('m9', 'c_check_typo.c', 'uint64_t candidates = (uint64_t)_mm512_mask_cmpeq_epi8_mask(identifiers, token_roles, operand) |\n                              (uint64_t)_mm512_mask_cmpeq_epi8_mask(live, token_kinds, semicolon);',
              'uint64_t candidates = (uint64_t)_mm512_mask_cmpeq_epi8_mask(identifiers, token_roles, operand) |\n                              ((uint64_t)_mm512_mask_cmpeq_epi8_mask(live, token_kinds, semicolon) & 0);'),
    # The interrupt checks' node pass leaves out varargs.
    ('m10', 'c_check_warning_graph.c', '_mm512_mask_cmpeq_epi32_mask(lanes, ops, _mm512_set1_epi32(CHECK_OP_VARARGS)) |\n', ''),
    # The redeclaration marks' scan drops each block's last lane.
    ('m11', 'c_check_warning_graph.c', 'uint64_t selected = _mm512_mask_cmpeq_epi8_mask(lanes, kinds, _mm512_set1_epi8((char)C_BINDING_FUNCTION));',
              'uint64_t selected = _mm512_mask_cmpeq_epi8_mask(lanes, kinds, _mm512_set1_epi8((char)C_BINDING_FUNCTION)) & (lanes >> 1);'),
    # The side effects' scan leaves out calls.
    ('m12', 'c_check_warning_graph.c', '_mm512_mask_cmpeq_epi8_mask((__mmask64)lanes, roles, _mm512_set1_epi8((char)PARSE_ROLE_CLOSE_CALL)) |',
              '0 |'),
    # The reach scan drops a reach's lowest bit.
    ('m13', W, 'const uint64_t selected = _mm512_mask_test_epi8_mask((__mmask64)lanes, _mm512_maskz_loadu_epi8((__mmask64)lanes, reach + first),\n                                                             _mm512_set1_epi8((char)bits));',
               'const uint64_t selected = _mm512_mask_test_epi8_mask((__mmask64)lanes, _mm512_maskz_loadu_epi8((__mmask64)lanes, reach + first),\n                                                             _mm512_set1_epi8((char)(bits & 0xfe)));'),
    # The interrupt evaluated calls' scan drops each block's last lane.
    ('m14', 'c_check_warning_graph.c', 'uint64_t selected = _mm512_mask_cmpeq_epi8_mask(lanes, roles, _mm512_set1_epi8((char)PARSE_ROLE_CLOSE_CALL));',
               'uint64_t selected = _mm512_mask_cmpeq_epi8_mask(lanes, roles, _mm512_set1_epi8((char)PARSE_ROLE_CLOSE_CALL)) & (lanes >> 1);'),
]
if __name__ == '__main__' and sys.argv[1:2] == ['--check']:
    for name, f, old, new in MUTANTS:
        n = open(os.path.join(sys.argv[2], f)).read().count(old)
        print(name, f, n)
    sys.exit(0)
log = open(os.path.join(os.path.dirname(T), 'sweep.txt'), 'a')
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
        d = os.path.join(os.path.dirname(T), 'sweep-' + name)
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
