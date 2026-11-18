#!/usr/bin/env python3
# faults.py WORKER OF: the fourth piece's faults (the casts, a pointer's subscripts and its sums), one at a time, in the
# copy /home/user/mut14/treeWORKER: a text of the piece's code replaced by a faulty one, the Debug compiler built, and
# the node machine's tests run (test-checker part 5 of 8). A fault the tests don't fail is a survivor. Worker WORKER of
# OF takes every OF-th fault. Results in /home/user/mut14/results-WORKER.txt.
import subprocess, sys, time
worker, of = int(sys.argv[1]), int(sys.argv[2])
TREE = '/home/user/mut14/tree%d' % worker
SRC = TREE + '/src/buster/compiler/'
C = 'c_check_node_census.c'
FAULTS = [
    # the pairs
    ('pairs-first-side', C, 'const bool pointed = (left == BUSTER_NODE_TESTS_KIND_POINTER && integer_right) || (integer_left && right == BUSTER_NODE_TESTS_KIND_POINTER);',
     'const bool pointed = (integer_left && right == BUSTER_NODE_TESTS_KIND_POINTER);'),
    ('pairs-second-side', C, 'const bool pointed = (left == BUSTER_NODE_TESTS_KIND_POINTER && integer_right) || (integer_left && right == BUSTER_NODE_TESTS_KIND_POINTER);',
     'const bool pointed = (left == BUSTER_NODE_TESTS_KIND_POINTER && integer_right);'),
    ('pairs-any-second', C, 'const bool pointed = (left == BUSTER_NODE_TESTS_KIND_POINTER && integer_right) ||',
     'const bool pointed = (left == BUSTER_NODE_TESTS_KIND_POINTER && right != BUSTER_NODE_TESTS_KIND_POINTER) ||'),
    ('pairs-any-first', C, '|| (integer_left && right == BUSTER_NODE_TESTS_KIND_POINTER);\n',
     '|| (left != BUSTER_NODE_TESTS_KIND_POINTER && right == BUSTER_NODE_TESTS_KIND_POINTER);\n'),
    ('pairs-two-pointers', C, 'const bool pointed = (left == BUSTER_NODE_TESTS_KIND_POINTER && integer_right) ||',
     'const bool pointed = (left == BUSTER_NODE_TESTS_KIND_POINTER && right == BUSTER_NODE_TESTS_KIND_POINTER) || (left == BUSTER_NODE_TESTS_KIND_POINTER && integer_right) ||'),
    ('pairs-equality-too', C, '((both && equal) || null ? BUSTER_NODE_TESTS_QUIET_EQUALITY : 0)', '((both && equal) || null || pointed ? BUSTER_NODE_TESTS_QUIET_EQUALITY : 0)'),
    # the tables
    ('sends-enum-back', C, '(op != CHECK_OP_CAST && policy->enums ? BUSTER_NODE_TESTS_OPERAND_ENUM : 0) |', '(policy->enums ? BUSTER_NODE_TESTS_OPERAND_ENUM : 0) |'),
    ('sends-enum-never', C, '(op != CHECK_OP_CAST && policy->enums ? BUSTER_NODE_TESTS_OPERAND_ENUM : 0) |', '(op != CHECK_OP_CAST && op != CHECK_OP_ASSIGN && policy->enums ? BUSTER_NODE_TESTS_OPERAND_ENUM : 0) |'),
    ('subscript-no-class', C, 's->own_quiets[code] = (uint8_t)(sums || op == CHECK_OP_SUBSCRIPT ? BUSTER_NODE_TESTS_QUIET_BINARY :', 's->own_quiets[code] = (uint8_t)(sums ? BUSTER_NODE_TESTS_QUIET_BINARY :'),
    # the subscript's constant pointer
    ('read-left-only', C, '''        const __mmask64 pointer_read = _mm512_cmpeq_epi8_mask(_mm512_and_si512(kind_left, pointer_bits), constant_pointer) |
                                       _mm512_cmpeq_epi8_mask(_mm512_and_si512(kind_right, pointer_bits), constant_pointer);''',
     '        const __mmask64 pointer_read = _mm512_cmpeq_epi8_mask(_mm512_and_si512(kind_left, pointer_bits), constant_pointer);'),
    ('read-right-only', C, '''        const __mmask64 pointer_read = _mm512_cmpeq_epi8_mask(_mm512_and_si512(kind_left, pointer_bits), constant_pointer) |
                                       _mm512_cmpeq_epi8_mask(_mm512_and_si512(kind_right, pointer_bits), constant_pointer);''',
     '        const __mmask64 pointer_read = _mm512_cmpeq_epi8_mask(_mm512_and_si512(kind_right, pointer_bits), constant_pointer);'),
    ('read-any-pointer', C, 'const __m512i constant_pointer = _mm512_set1_epi8((char)(BUSTER_NODE_TESTS_KIND_POINTER << BUSTER_NODE_TESTS_KIND_SHIFT | BUSTER_NODE_TESTS_VALUE_CONSTANT));',
     'const __m512i constant_pointer = _mm512_set1_epi8((char)(BUSTER_NODE_TESTS_KIND_POINTER << BUSTER_NODE_TESTS_KIND_SHIFT));'),
    ('read-mask-kind-alone', C, 'const __m512i pointer_bits = _mm512_set1_epi8((char)((BUSTER_NODE_TESTS_KINDS - 1) << BUSTER_NODE_TESTS_KIND_SHIFT | BUSTER_NODE_TESTS_VALUE_CONSTANT));',
     'const __m512i pointer_bits = _mm512_set1_epi8((char)((BUSTER_NODE_TESTS_KINDS - 1) << BUSTER_NODE_TESTS_KIND_SHIFT));'),
    ('read-mask-constant-alone', C, 'const __m512i pointer_bits = _mm512_set1_epi8((char)((BUSTER_NODE_TESTS_KINDS - 1) << BUSTER_NODE_TESTS_KIND_SHIFT | BUSTER_NODE_TESTS_VALUE_CONSTANT));',
     'const __m512i pointer_bits = _mm512_set1_epi8((char)(BUSTER_NODE_TESTS_KIND_POINTER << BUSTER_NODE_TESTS_KIND_SHIFT | BUSTER_NODE_TESTS_VALUE_CONSTANT));'),
    ('read-every-operator', C, 'const __mmask64 quiet = quiet_class & alone & ~(subscripts & pointer_read);', 'const __mmask64 quiet = quiet_class & alone & ~pointer_read;'),
    ('read-no-operator', C, 'const __mmask64 quiet = quiet_class & alone & ~(subscripts & pointer_read);', 'const __mmask64 quiet = quiet_class & alone;'),
    # the casts
    ('casts-unsent-too', C, '''        const __mmask64 quiet_casts = casts & _mm512_test_epi8_mask(sends, operands) &
                                      _mm512_test_epi8_mask(own,''', '''        const __mmask64 quiet_casts = casts &
                                      _mm512_test_epi8_mask(own,'''),
    ('casts-void-alone', C, '_mm512_test_epi8_mask(own, _mm512_set1_epi8((char)(BUSTER_NODE_TESTS_TYPE_VOID | BUSTER_NODE_CENSUS_TYPE_POINTER)));',
     '_mm512_test_epi8_mask(own, _mm512_set1_epi8((char)(BUSTER_NODE_TESTS_TYPE_VOID)));'),
    ('casts-pointer-alone', C, '_mm512_test_epi8_mask(own, _mm512_set1_epi8((char)(BUSTER_NODE_TESTS_TYPE_VOID | BUSTER_NODE_CENSUS_TYPE_POINTER)));',
     '_mm512_test_epi8_mask(own, _mm512_set1_epi8((char)(BUSTER_NODE_CENSUS_TYPE_POINTER)));'),
    ('casts-enumeration-too', C, '_mm512_test_epi8_mask(own, _mm512_set1_epi8((char)(BUSTER_NODE_TESTS_TYPE_VOID | BUSTER_NODE_CENSUS_TYPE_POINTER)));',
     '_mm512_test_epi8_mask(own, _mm512_set1_epi8((char)(BUSTER_NODE_TESTS_TYPE_VOID | BUSTER_NODE_CENSUS_TYPE_POINTER | BUSTER_NODE_CENSUS_TYPE_ENUM)));'),
    ('casts-any-type', C, '''        const __mmask64 quiet_casts = casts & _mm512_test_epi8_mask(sends, operands) &
                                      _mm512_test_epi8_mask(own, _mm512_set1_epi8((char)(BUSTER_NODE_TESTS_TYPE_VOID | BUSTER_NODE_CENSUS_TYPE_POINTER)));''',
     '        const __mmask64 quiet_casts = casts & _mm512_test_epi8_mask(sends, operands);'),
    ('casts-every-operator', C, '''        const __mmask64 quiet_casts = casts & _mm512_test_epi8_mask(sends, operands) &''', '''        const __mmask64 quiet_casts = _mm512_test_epi8_mask(sends, operands) &'''),
    ('casts-void-pointee', C, '_mm512_test_epi8_mask(own, _mm512_set1_epi8((char)(BUSTER_NODE_TESTS_TYPE_VOID | BUSTER_NODE_CENSUS_TYPE_POINTER)));',
     '_mm512_test_epi8_mask(own, _mm512_set1_epi8((char)(BUSTER_NODE_TESTS_TYPE_VOID | BUSTER_NODE_CENSUS_TYPE_VOID_POINTEE)));'),
    # the masks and the counts
    ('mask-quiet-without', C, 'masks[BUSTER_NODE_TESTS_MASK_QUIET] = quiet | quiet_calls | quiet_casts;', 'masks[BUSTER_NODE_TESTS_MASK_QUIET] = quiet | quiet_calls;'),
    ('mask-operators-with', C, 'masks[BUSTER_NODE_TESTS_MASK_OPERATORS] = _mm512_test_epi8_mask(sent, sent) & ~quiet & ~quiet_calls & ~quiet_casts;',
     'masks[BUSTER_NODE_TESTS_MASK_OPERATORS] = _mm512_test_epi8_mask(sent, sent) & ~quiet & ~quiet_calls;'),
    ('count-none', C, 'cast_total += (uint64_t)_mm_popcnt_u64(quiet_casts);', 'cast_total += 0;'),
    ('count-calls', C, 'cast_total += (uint64_t)_mm_popcnt_u64(quiet_casts);', 'cast_total += (uint64_t)_mm_popcnt_u64(quiet_calls);'),
    ('count-not-given', C, '    *cast_count += cast_total;\n', '    *cast_count += 0;\n'),
    ('checked-not-counted', C, 'counts->own_quiet_casts_checked += cast;', 'counts->own_quiet_casts_checked += call;'),
    ('checked-with-constants', C, 'counts->own_quiet_checked += !call && !cast;', 'counts->own_quiet_checked += !call;'),
    ('sum-not-taken', C, 'shadow->own_quiet_casts += typed->own_quiet_casts;', 'shadow->own_quiet_casts += 0;'),
    ('sum-checked-not-taken', C, 'shadow->own_quiet_casts_checked += typed->own_quiet_casts_checked;', 'shadow->own_quiet_casts_checked += 0;'),
]
out = open('/home/user/mut14/results-%d.txt' % worker, 'w')
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
