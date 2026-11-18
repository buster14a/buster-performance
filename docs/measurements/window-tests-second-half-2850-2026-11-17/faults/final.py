#!/usr/bin/env python3
# mutants.py: the faults of the loop's quiet rule (buster#2850, the tests on the window, second half), one at a time, in a
# COPY of the tree (/home/user/mut10/tree, or tree<i> for a shard): each is a text of the new code replaced by a faulty
# one, the Debug compiler built, and the node machine's tests run (test-checker part 5 of 8). A fault the tests don't
# fail is a survivor. Every text is checked to be unique before any build, and the file is restored after each fault.
#   mutants.py check        : every fault's texts are unique, applies and reverts
#   mutants.py run [NAME..] : the campaign (all the faults, or those named); results in /home/user/mut10/results*.txt
#   MUT_SHARD=i/n           : the faults whose place in the list is i modulo n, in the tree's copy tree<i>
import subprocess, sys, os, shutil, time

ROOT = '/home/user/mut10'
SHARD, SHARDS = [int(x) for x in os.environ.get('MUT_SHARD', '0/1').split('/')]
TREE = ROOT + ('/tree' if SHARDS == 1 else '/tree%d' % SHARD)
SRC = TREE + '/src/buster/compiler/'
C = 'c_check_node_census.c'
F = 'c_check_node_machine_facts.c'
R = 'c_check_node_machine_reads.c'

K = 'BUSTER_NODE_TESTS_KIND_'
Q = 'BUSTER_NODE_TESTS_QUIET_'
MUTANTS = [
    ('t-divide-a-sum', C, '                          op == CHECK_OP_BIT_OR_ASSIGN || op == CHECK_OP_BIT_XOR_ASSIGN;', '                          op == CHECK_OP_BIT_OR_ASSIGN || op == CHECK_OP_BIT_XOR_ASSIGN || op == CHECK_OP_DIVIDE;'),
    ('t-no-add', C, '        const bool sums = op == CHECK_OP_ADD || op == CHECK_OP_SUBTRACT ||', '        const bool sums = op == CHECK_OP_SUBTRACT ||'),
    ('t-no-compound', C, '                          op == CHECK_OP_ADD_ASSIGN || op == CHECK_OP_SUBTRACT_ASSIGN ||', '                          op == CHECK_OP_SUBTRACT_ASSIGN ||'),
    ('t-unary-none', C, 'op == CHECK_OP_POSITIVE || op == CHECK_OP_NEGATIVE || op == CHECK_OP_BIT_NOT ? BUSTER_NODE_TESTS_QUIET_UNARY :', 'op == CHECK_OP_POSITIVE || op == CHECK_OP_NEGATIVE || op == CHECK_OP_BIT_NOT ? BUSTER_NODE_TESTS_QUIET_NONE :'),
    ('t-equality-as-relational', C, 'equality ? BUSTER_NODE_TESTS_QUIET_EQUALITY : comparison ? BUSTER_NODE_TESTS_QUIET_RELATIONAL :', 'equality ? BUSTER_NODE_TESTS_QUIET_RELATIONAL : comparison ? BUSTER_NODE_TESTS_QUIET_RELATIONAL :'),
    ('t-relational-as-equality', C, 'equality ? BUSTER_NODE_TESTS_QUIET_EQUALITY : comparison ? BUSTER_NODE_TESTS_QUIET_RELATIONAL :', 'equality ? BUSTER_NODE_TESTS_QUIET_EQUALITY : comparison ? BUSTER_NODE_TESTS_QUIET_EQUALITY :'),
    ('t-shift-under-policy', C, 'shift && !policy->shift_sign_overflow ? BUSTER_NODE_TESTS_QUIET_SHIFT :', 'shift ? BUSTER_NODE_TESTS_QUIET_SHIFT :'),
    ('t-division-none', C, 'op == CHECK_OP_DIVIDE || op == CHECK_OP_REMAINDER ? BUSTER_NODE_TESTS_QUIET_DIVISION :', 'op == CHECK_OP_DIVIDE || op == CHECK_OP_REMAINDER ? BUSTER_NODE_TESTS_QUIET_NONE :'),
    ('t-assign-as-binary', C, 'op == CHECK_OP_ASSIGN ? BUSTER_NODE_TESTS_QUIET_ASSIGN :', 'op == CHECK_OP_ASSIGN ? BUSTER_NODE_TESTS_QUIET_BINARY :'),
    ('t-convert-as-unary', C, 'op == CHECK_OP_CONVERT ? BUSTER_NODE_TESTS_QUIET_CONVERT : BUSTER_NODE_TESTS_QUIET_NONE);', 'op == CHECK_OP_CONVERT ? BUSTER_NODE_TESTS_QUIET_UNARY : BUSTER_NODE_TESTS_QUIET_NONE);'),
    ('t-convert-none', C, 'op == CHECK_OP_CONVERT ? BUSTER_NODE_TESTS_QUIET_CONVERT : BUSTER_NODE_TESTS_QUIET_NONE);', 'op == CHECK_OP_CONVERT ? BUSTER_NODE_TESTS_QUIET_NONE : BUSTER_NODE_TESTS_QUIET_NONE);'),
    ('t-pairs-not-made', C, '    node_tests_quiet_pairs(s->own_quiet_pairs);\n', '    node_tests_quiet_pairs(s->own_quiet_pairs);\n    memset(s->own_quiet_pairs, 0, sizeof(s->own_quiet_pairs));\n'),
    ('p-index-swapped', C, '        const uint32_t left = pair % BUSTER_NODE_TESTS_KINDS;\n        const uint32_t right = pair / BUSTER_NODE_TESTS_KINDS;', '        const uint32_t left = pair / BUSTER_NODE_TESTS_KINDS;\n        const uint32_t right = pair % BUSTER_NODE_TESTS_KINDS;'),
    ('p-integer-left-pointer', C, 'const bool integer_left = left >= BUSTER_NODE_TESTS_KIND_SIGNED;', 'const bool integer_left = left >= BUSTER_NODE_TESTS_KIND_POINTER;'),
    ('p-integer-right-pointer', C, 'const bool integer_right = right >= BUSTER_NODE_TESTS_KIND_SIGNED;', 'const bool integer_right = right >= BUSTER_NODE_TESTS_KIND_POINTER;'),
    ('p-constant-left-unsigned', C, 'const bool constant_left = left >= BUSTER_NODE_TESTS_KIND_ZERO;', 'const bool constant_left = left >= BUSTER_NODE_TESTS_KIND_UNSIGNED;'),
    ('p-constant-right-unsigned', C, 'const bool constant_right = right >= BUSTER_NODE_TESTS_KIND_ZERO;', 'const bool constant_right = right >= BUSTER_NODE_TESTS_KIND_UNSIGNED;'),
    ('p-constant-left-never', C, 'const bool constant_left = left >= BUSTER_NODE_TESTS_KIND_ZERO;', 'const bool constant_left = left > BUSTER_NODE_TESTS_KIND_CONSTANT;'),
    ('p-constant-right-never', C, 'const bool constant_right = right >= BUSTER_NODE_TESTS_KIND_ZERO;', 'const bool constant_right = right > BUSTER_NODE_TESTS_KIND_CONSTANT;'),
    ('p-zero-left-tiny', C, 'const bool zero_left = left == BUSTER_NODE_TESTS_KIND_ZERO;', 'const bool zero_left = left == BUSTER_NODE_TESTS_KIND_ZERO || left == BUSTER_NODE_TESTS_KIND_TINY;'),
    ('p-zero-right-tiny', C, 'const bool zero_right = right == BUSTER_NODE_TESTS_KIND_ZERO;', 'const bool zero_right = right == BUSTER_NODE_TESTS_KIND_ZERO || right == BUSTER_NODE_TESTS_KIND_TINY;'),
    ('p-small-left-no-tiny', C, 'const bool small_left = left == BUSTER_NODE_TESTS_KIND_TINY || left == BUSTER_NODE_TESTS_KIND_SMALL;', 'const bool small_left = left == BUSTER_NODE_TESTS_KIND_SMALL;'),
    ('p-small-left-any-constant', C, 'const bool small_left = left == BUSTER_NODE_TESTS_KIND_TINY || left == BUSTER_NODE_TESTS_KIND_SMALL;', 'const bool small_left = left == BUSTER_NODE_TESTS_KIND_TINY || left == BUSTER_NODE_TESTS_KIND_SMALL || left == BUSTER_NODE_TESTS_KIND_CONSTANT;'),
    ('p-small-right-no-tiny', C, 'const bool small_right = right == BUSTER_NODE_TESTS_KIND_TINY || right == BUSTER_NODE_TESTS_KIND_SMALL;', 'const bool small_right = right == BUSTER_NODE_TESTS_KIND_SMALL;'),
    ('p-small-right-any-constant', C, 'const bool small_right = right == BUSTER_NODE_TESTS_KIND_TINY || right == BUSTER_NODE_TESTS_KIND_SMALL;', 'const bool small_right = right == BUSTER_NODE_TESTS_KIND_TINY || right == BUSTER_NODE_TESTS_KIND_SMALL || right == BUSTER_NODE_TESTS_KIND_CONSTANT;'),
    ('p-tiny-right-small', C, 'const bool tiny_right = right == BUSTER_NODE_TESTS_KIND_ZERO || right == BUSTER_NODE_TESTS_KIND_TINY;', 'const bool tiny_right = right == BUSTER_NODE_TESTS_KIND_ZERO || right == BUSTER_NODE_TESTS_KIND_TINY || right == BUSTER_NODE_TESTS_KIND_SMALL;'),
    ('p-tiny-right-no-zero', C, 'const bool tiny_right = right == BUSTER_NODE_TESTS_KIND_ZERO || right == BUSTER_NODE_TESTS_KIND_TINY;', 'const bool tiny_right = right == BUSTER_NODE_TESTS_KIND_TINY;'),
    ('p-signed-left-unsigned', C, 'const bool signed_left = left == BUSTER_NODE_TESTS_KIND_SIGNED;', 'const bool signed_left = left == BUSTER_NODE_TESTS_KIND_SIGNED || left == BUSTER_NODE_TESTS_KIND_UNSIGNED;'),
    ('p-signed-right-unsigned', C, 'const bool signed_right = right == BUSTER_NODE_TESTS_KIND_SIGNED;', 'const bool signed_right = right == BUSTER_NODE_TESTS_KIND_SIGNED || right == BUSTER_NODE_TESTS_KIND_UNSIGNED;'),
    ('p-both-left-only', C, 'const bool both = integer_left && integer_right;', 'const bool both = integer_left && (integer_right || true);'),
    ('p-both-right-only', C, 'const bool both = integer_left && integer_right;', 'const bool both = integer_right;'),
    ('p-equal-any-left', C, 'const bool equal = (!constant_left || constant_right || zero_left || small_left) &&', 'const bool equal = (!constant_left || constant_right || zero_left || small_left || true) &&'),
    ('p-equal-any-right', C, '&& (!constant_right || constant_left || zero_right || small_right);\n        const bool ordered', '&& (!constant_right || constant_left || zero_right || small_right || true);\n        const bool ordered'),
    ('p-equal-no-zero', C, 'const bool equal = (!constant_left || constant_right || zero_left || small_left) &&', 'const bool equal = (!constant_left || constant_right || small_left) &&'),
    ('p-ordered-left-unsigned', C, 'small_left || (zero_left && signed_right)) &&', 'small_left || (zero_left && (signed_right || true))) &&'),
    ('p-ordered-right-unsigned', C, 'small_right || (zero_right && signed_left));', 'small_right || (zero_right && (signed_left || true)));'),
    ('p-ordered-left-no-zero', C, 'small_left || (zero_left && signed_right)) &&', 'small_left || (zero_left && signed_right && false)) &&'),
    ('p-ordered-right-no-zero', C, 'small_right || (zero_right && signed_left));', 'small_right || (zero_right && signed_left && false));'),
    ('p-shift-small-count', C, 'const bool shifted = (!constant_right || tiny_right) && (!constant_left || zero_left || small_left);', 'const bool shifted = (!constant_right || tiny_right || small_right) && (!constant_left || zero_left || small_left);'),
    ('p-shift-any-shifted', C, 'const bool shifted = (!constant_right || tiny_right) && (!constant_left || zero_left || small_left);', 'const bool shifted = (!constant_right || tiny_right) && (!constant_left || zero_left || small_left || true);'),
    ('p-divided-by-zero', C, 'const bool divided = !constant_right || small_right;', 'const bool divided = !constant_right || small_right || zero_right;'),
    ('p-divided-any', C, 'const bool divided = !constant_right || small_right;', 'const bool divided = !constant_right || small_right || true;'),
    ('p-stored-any-constant', C, 'const bool stored = zero_right || small_right;', 'const bool stored = constant_right;'),
    ('p-stored-no-zero', C, 'const bool stored = zero_right || small_right;', 'const bool stored = small_right;'),
    ('p-converted-any-constant', C, 'const bool converted = zero_left || small_left;', 'const bool converted = constant_left;'),
    ('p-converted-no-zero', C, 'const bool converted = zero_left || small_left;', 'const bool converted = small_left;'),
    ('p-null-left-only', C, 'const bool null = (left == BUSTER_NODE_TESTS_KIND_POINTER && zero_right) || (right == BUSTER_NODE_TESTS_KIND_POINTER && zero_left);', 'const bool null = left == BUSTER_NODE_TESTS_KIND_POINTER && zero_right;'),
    ('p-null-right-only', C, 'const bool null = (left == BUSTER_NODE_TESTS_KIND_POINTER && zero_right) || (right == BUSTER_NODE_TESTS_KIND_POINTER && zero_left);', 'const bool null = right == BUSTER_NODE_TESTS_KIND_POINTER && zero_left;'),
    ('p-null-any-constant', C, 'const bool null = (left == BUSTER_NODE_TESTS_KIND_POINTER && zero_right) || (right == BUSTER_NODE_TESTS_KIND_POINTER && zero_left);', 'const bool null = (left == BUSTER_NODE_TESTS_KIND_POINTER && constant_right) || (right == BUSTER_NODE_TESTS_KIND_POINTER && constant_left);'),
    ('p-class-binary-any', C, 'pairs[pair] = (uint8_t)((both ? BUSTER_NODE_TESTS_QUIET_BINARY : 0) |', 'pairs[pair] = (uint8_t)((both || lone ? BUSTER_NODE_TESTS_QUIET_BINARY : 0) |'),
    ('p-class-equality-any', C, '((both && equal) || null ? BUSTER_NODE_TESTS_QUIET_EQUALITY : 0) |', '((both && (equal || true)) || null ? BUSTER_NODE_TESTS_QUIET_EQUALITY : 0) |'),
    ('p-class-equality-no-null', C, '((both && equal) || null ? BUSTER_NODE_TESTS_QUIET_EQUALITY : 0) |', '((both && equal) || (null && false) ? BUSTER_NODE_TESTS_QUIET_EQUALITY : 0) |'),
    ('p-class-relational-any', C, '(both && ordered ? BUSTER_NODE_TESTS_QUIET_RELATIONAL : 0) |', '(both && (ordered || true) ? BUSTER_NODE_TESTS_QUIET_RELATIONAL : 0) |'),
    ('p-class-shift-any', C, '(both && shifted ? BUSTER_NODE_TESTS_QUIET_SHIFT : 0) |', '(both && (shifted || true) ? BUSTER_NODE_TESTS_QUIET_SHIFT : 0) |'),
    ('p-class-division-any', C, '(both && divided ? BUSTER_NODE_TESTS_QUIET_DIVISION : 0) |', '(both && (divided || true) ? BUSTER_NODE_TESTS_QUIET_DIVISION : 0) |'),
    ('p-class-assign-any', C, '(both && stored ? BUSTER_NODE_TESTS_QUIET_ASSIGN : 0) |', '(both && (stored || true) ? BUSTER_NODE_TESTS_QUIET_ASSIGN : 0) |'),
    ('p-class-convert-any', C, '(converted ? BUSTER_NODE_TESTS_QUIET_CONVERT : 0));', '(converted || integer_left ? BUSTER_NODE_TESTS_QUIET_CONVERT : 0));'),
    ('b-any-kind', C, 'const __m512i plain_words = _mm512_sub_epi32(_mm512_and_si512(words, _mm512_set1_epi32(0x00ffffff)),\n                                                         _mm512_set1_epi32((int32_t)((uint32_t)BUSTER_TYPE_KIND_INTEGER << 16 | BUSTER_TYPED_CLASS_I8)));', 'const __m512i plain_words = _mm512_sub_epi32(_mm512_and_si512(words, _mm512_set1_epi32(0x0000ffff)),\n                                                         _mm512_set1_epi32((int32_t)(BUSTER_TYPED_CLASS_I8)));'),
    ('b-no-facts', C, 'const __m512i plain_words = _mm512_sub_epi32(_mm512_and_si512(words, _mm512_set1_epi32(0x00ffffff)),', 'const __m512i plain_words = _mm512_sub_epi32(_mm512_and_si512(words, _mm512_set1_epi32(0x00ff00ff)),'),
    ('b-any-class', C, '_mm512_cmple_epu32_mask(plain_words, _mm512_set1_epi32(BUSTER_TYPED_CLASS_U64 - BUSTER_TYPED_CLASS_I8));', '_mm512_cmple_epu32_mask(plain_words, _mm512_set1_epi32(0xff));'),
    ('b-class-short-of-64', C, '_mm512_cmple_epu32_mask(plain_words, _mm512_set1_epi32(BUSTER_TYPED_CLASS_U64 - BUSTER_TYPED_CLASS_I8));', '_mm512_cmple_epu32_mask(plain_words, _mm512_set1_epi32(BUSTER_TYPED_CLASS_U32 - BUSTER_TYPED_CLASS_I8));'),
    ('b-bit-field-integer', C, 'const __mmask16 integer = (__mmask16)(placed & ~bit_field) &', 'const __mmask16 integer = (__mmask16)(placed) &'),
    ('b-valued-any-constant', C, 'const __mmask16 valued = _mm512_mask_cmpeq_epi32_mask(integer, constant_kinds, _mm512_set1_epi32(CHECK_CONSTANT_INTEGER));', 'const __mmask16 valued = _mm512_mask_test_epi32_mask(integer, constant_kinds, constant_kinds);'),
    ('b-valued-never', C, 'const __mmask16 valued = _mm512_mask_cmpeq_epi32_mask(integer, constant_kinds, _mm512_set1_epi32(CHECK_CONSTANT_INTEGER));', 'const __mmask16 valued = _mm512_mask_cmpeq_epi32_mask(integer, constant_kinds, _mm512_set1_epi32(CHECK_CONSTANT_FLOATING));'),
    ('b-unsigned-signed', C, 'const __mmask16 unsigned_type = _mm512_mask_test_epi32_mask((__mmask16)(integer & ~valued), plain_words, _mm512_set1_epi32(1));', 'const __mmask16 unsigned_type = _mm512_mask_testn_epi32_mask((__mmask16)(integer & ~valued), plain_words, _mm512_set1_epi32(1));'),
    ('b-every-type-signed', C, 'const __mmask16 unsigned_type = _mm512_mask_test_epi32_mask((__mmask16)(integer & ~valued), plain_words, _mm512_set1_epi32(1));', 'const __mmask16 unsigned_type = _mm512_mask_test_epi32_mask((__mmask16)(integer & ~valued), plain_words, _mm512_set1_epi32(0));'),
    ('b-value-is-said', C, 'const __m512i value = _mm512_sub_epi32(said, _mm512_set1_epi32(1));', 'const __m512i value = _mm512_sub_epi32(said, _mm512_set1_epi32(0));'),
    ('b-said-low-byte', C, 'const __m512i said = _mm512_srli_epi32(standings, 16);', 'const __m512i said = _mm512_and_si512(_mm512_srli_epi32(standings, 16), _mm512_set1_epi32(0xff));'),
    ('b-past-zero-2', C, 'const __mmask16 past_zero = _mm512_mask_cmpge_epu32_mask(valued, value, _mm512_set1_epi32(1));', 'const __mmask16 past_zero = _mm512_mask_cmpge_epu32_mask(valued, value, _mm512_set1_epi32(2));'),
    ('b-past-tiny-33', C, 'const __mmask16 past_tiny = _mm512_mask_cmpge_epu32_mask(valued, value, _mm512_set1_epi32(32));', 'const __mmask16 past_tiny = _mm512_mask_cmpge_epu32_mask(valued, value, _mm512_set1_epi32(33));'),
    ('b-past-tiny-31', C, 'const __mmask16 past_tiny = _mm512_mask_cmpge_epu32_mask(valued, value, _mm512_set1_epi32(32));', 'const __mmask16 past_tiny = _mm512_mask_cmpge_epu32_mask(valued, value, _mm512_set1_epi32(31));'),
    ('b-past-small-128', C, 'const __mmask16 past_small = _mm512_mask_cmpge_epu32_mask(valued, value, _mm512_set1_epi32(127));', 'const __mmask16 past_small = _mm512_mask_cmpge_epu32_mask(valued, value, _mm512_set1_epi32(128));'),
    ('b-past-small-126', C, 'const __mmask16 past_small = _mm512_mask_cmpge_epu32_mask(valued, value, _mm512_set1_epi32(127));', 'const __mmask16 past_small = _mm512_mask_cmpge_epu32_mask(valued, value, _mm512_set1_epi32(126));'),
    ('b-pointer-as-signed', C, '__m128i kind_bytes = _mm_maskz_set1_epi8(pointer, (char)BUSTER_NODE_TESTS_KIND_BITS(BUSTER_NODE_TESTS_KIND_POINTER));', '__m128i kind_bytes = _mm_maskz_set1_epi8(pointer, (char)BUSTER_NODE_TESTS_KIND_BITS(BUSTER_NODE_TESTS_KIND_SIGNED));'),
    ('b-unsigned-as-signed', C, 'kind_bytes = _mm_mask_set1_epi8(kind_bytes, unsigned_type, (char)BUSTER_NODE_TESTS_KIND_BITS(BUSTER_NODE_TESTS_KIND_UNSIGNED));', 'kind_bytes = _mm_mask_set1_epi8(kind_bytes, unsigned_type, (char)BUSTER_NODE_TESTS_KIND_BITS(BUSTER_NODE_TESTS_KIND_SIGNED));'),
    ('b-zero-as-tiny', C, 'kind_bytes = _mm_mask_set1_epi8(kind_bytes, valued, (char)BUSTER_NODE_TESTS_KIND_BITS(BUSTER_NODE_TESTS_KIND_ZERO));', 'kind_bytes = _mm_mask_set1_epi8(kind_bytes, valued, (char)BUSTER_NODE_TESTS_KIND_BITS(BUSTER_NODE_TESTS_KIND_TINY));'),
    ('b-tiny-as-small', C, 'kind_bytes = _mm_mask_set1_epi8(kind_bytes, past_zero, (char)BUSTER_NODE_TESTS_KIND_BITS(BUSTER_NODE_TESTS_KIND_TINY));', 'kind_bytes = _mm_mask_set1_epi8(kind_bytes, past_zero, (char)BUSTER_NODE_TESTS_KIND_BITS(BUSTER_NODE_TESTS_KIND_SMALL));'),
    ('b-small-as-tiny', C, 'kind_bytes = _mm_mask_set1_epi8(kind_bytes, past_tiny, (char)BUSTER_NODE_TESTS_KIND_BITS(BUSTER_NODE_TESTS_KIND_SMALL));', 'kind_bytes = _mm_mask_set1_epi8(kind_bytes, past_tiny, (char)BUSTER_NODE_TESTS_KIND_BITS(BUSTER_NODE_TESTS_KIND_TINY));'),
    ('b-constant-as-small', C, 'kind_bytes = _mm_mask_set1_epi8(kind_bytes, past_small, (char)BUSTER_NODE_TESTS_KIND_BITS(BUSTER_NODE_TESTS_KIND_CONSTANT));', 'kind_bytes = _mm_mask_set1_epi8(kind_bytes, past_small, (char)BUSTER_NODE_TESTS_KIND_BITS(BUSTER_NODE_TESTS_KIND_SMALL));'),
    ('l-pair-swapped', C, '_mm512_ternarylogic_epi64(_mm512_set1_epi8(BUSTER_NODE_TESTS_KINDS - 1), _mm512_srli_epi16(kind_left, BUSTER_NODE_TESTS_KIND_SHIFT), kind_right, 0xca);', '_mm512_ternarylogic_epi64(_mm512_set1_epi8(BUSTER_NODE_TESTS_KINDS - 1), _mm512_srli_epi16(kind_right, BUSTER_NODE_TESTS_KIND_SHIFT), kind_left, 0xca);'),
    ('l-pair-or', C, '_mm512_ternarylogic_epi64(_mm512_set1_epi8(BUSTER_NODE_TESTS_KINDS - 1), _mm512_srli_epi16(kind_left, BUSTER_NODE_TESTS_KIND_SHIFT), kind_right, 0xca);', '_mm512_ternarylogic_epi64(_mm512_set1_epi8(BUSTER_NODE_TESTS_KINDS - 1), _mm512_srli_epi16(kind_left, BUSTER_NODE_TESTS_KIND_SHIFT), kind_right, 0xfe);'),
    ('l-own-bit-any', C, 'const __m512i own_bit = _mm512_or_si512(values, _mm512_set1_epi8((char)~BUSTER_NODE_TESTS_KIND_OWN));', 'const __m512i own_bit = _mm512_or_si512(values, _mm512_set1_epi8((char)0xff));'),
    ('l-own-bit-of-left', C, 'const __m512i own_bit = _mm512_or_si512(values, _mm512_set1_epi8((char)~BUSTER_NODE_TESTS_KIND_OWN));', 'const __m512i own_bit = _mm512_or_si512(kind_left, _mm512_set1_epi8((char)~BUSTER_NODE_TESTS_KIND_OWN));'),
    ('l-class-any', C, 'const __mmask64 quiet_class = _mm512_test_epi8_mask(_mm512_and_si512(paired, own_bit), quiets);', 'const __mmask64 quiet_class = _mm512_test_epi8_mask(_mm512_and_si512(paired, own_bit), _mm512_or_si512(quiets, _mm512_set1_epi8((char)0xff)));'),
    ('l-class-no-pair', C, 'const __mmask64 quiet_class = _mm512_test_epi8_mask(_mm512_and_si512(paired, own_bit), quiets);', 'const __mmask64 quiet_class = _mm512_test_epi8_mask(_mm512_or_si512(_mm512_and_si512(paired, own_bit), _mm512_set1_epi8((char)0xff)), quiets);'),
    ('l-alone-always', C, 'const __mmask64 alone = _mm512_testn_epi8_mask(always, always) &', 'const __mmask64 alone = (_mm512_testn_epi8_mask(always, always) | ~UINT64_C(0)) &'),
    ('l-alone-any-sent', C, '_mm512_cmpeq_epi8_mask(_mm512_and_si512(sends, operands), _mm512_set1_epi8(BUSTER_NODE_TESTS_OPERAND_CONSTANT));\n        const __mmask64 quiet', '_mm512_test_epi8_mask(_mm512_and_si512(sends, operands), _mm512_set1_epi8(BUSTER_NODE_TESTS_OPERAND_CONSTANT));\n        const __mmask64 quiet'),
    ('l-operators-keep-quiet', C, 'masks[BUSTER_NODE_TESTS_MASK_OPERATORS] = _mm512_test_epi8_mask(sent, sent) & ~quiet;', 'masks[BUSTER_NODE_TESTS_MASK_OPERATORS] = _mm512_test_epi8_mask(sent, sent) & ~(quiet & 0);'),
    ('l-quiet-not-counted', C, 'quiet_total += (uint64_t)_mm_popcnt_u64(quiet);', 'quiet_total += (uint64_t)_mm_popcnt_u64(quiet & 0);'),
    ('l-left-near-right', C, 'const __m512i kind_left = node_tests_window_operands(at_left, near_left, previous_values, values);', 'const __m512i kind_left = node_tests_window_operands(at_left, near_right, previous_values, values);'),
    ('l-right-near-left', C, 'const __m512i kind_right = node_tests_window_operands(at_right, near_right, previous_values, values);', 'const __m512i kind_right = node_tests_window_operands(at_right, near_left, previous_values, values);'),
    ('l-pairs-not-loaded', C, '    const __m512i quiet_pairs = _mm512_loadu_si512(s->own_quiet_pairs);\n', '    const __m512i quiet_pairs = _mm512_setzero_si512();\n'),
    ('e-quiet-first-word-only', C, 'quiet_bits[word] = node_tests_window_word(tests->window_masks, BUSTER_NODE_TESTS_MASK_QUIET, first, size, word);', 'quiet_bits[word] = node_tests_window_word(tests->window_masks, BUSTER_NODE_TESTS_MASK_QUIET, first, size, 0);'),
    ('e-quiet-no-root', C, 'quiet_bits[size / 64] |= (masks[BUSTER_NODE_TESTS_MASK_QUIET] >> (record & 63) & 1) << (size & 63);', 'quiet_bits[size / 64] |= (masks[BUSTER_NODE_TESTS_MASK_QUIET] >> (record & 63) & 0) << (size & 63);'),
    ('e-quiet-mask-operators', C, 'quiet_bits[word] = node_tests_window_word(tests->window_masks, BUSTER_NODE_TESTS_MASK_QUIET, first, size, word);', 'quiet_bits[word] = node_tests_window_word(tests->window_masks, BUSTER_NODE_TESTS_MASK_OPERATORS, first, size, word);'),
    ('f-small-wraps', F, '    return (uint32_t)(payload < 0xffffu ? payload : 0xfffeu) + 1u;', '    return (uint32_t)(payload & 0xfffeu) + 1u;'),
    ('f-small-no-one', F, '    return (uint32_t)(payload < 0xffffu ? payload : 0xfffeu) + 1u;', '    return (uint32_t)(payload < 0xffffu ? payload : 0xfffeu);'),
    ('f-small-saturates-early', F, '    return (uint32_t)(payload < 0xffffu ? payload : 0xfffeu) + 1u;', '    return (uint32_t)(payload < 0x40u ? payload : 0xfffeu) + 1u;'),
    ('f-exponent-floating-small', F, '    return (standing & BUSTER_NODE_MACHINE_FIELD) == BUSTER_NODE_MACHINE_FLOATING ? exponent : node_facts_small(payload);', '    return (standing & BUSTER_NODE_MACHINE_FIELD) == BUSTER_NODE_MACHINE_OFFSET ? exponent : node_facts_small(payload);'),
    ('f-exponent-operand-s', F, '    return (standing & BUSTER_NODE_MACHINE_FIELD) == BUSTER_NODE_MACHINE_FLOATING ? exponent : node_facts_small(payload);', '    return (standing & BUSTER_NODE_MACHINE_FIELD) == BUSTER_NODE_MACHINE_FLOATING ? exponent : exponent;'),
    ('f-enumerator-none', F, '        .exponent = (uint16_t)(enumerator ? node_facts_small((uint64_t)value) : 0),', '        .exponent = (uint16_t)(enumerator ? 0 : 0),'),
    ('f-literal-columns', F, '        .exponent = (uint16_t)node_facts_exponent(standing, columns->payloads[r], columns->exponents[r]),', '        .exponent = columns->exponents[r],'),
    ('f-record-integer-none', F, '    node_facts_store(record, 24, (uint64_t)standing | 0x100u | (uint64_t)node_facts_small(payload) << 16);', '    node_facts_store(record, 24, (uint64_t)standing | 0x100u | (uint64_t)0 << 16);'),
    ('f-from-with-operand-s', F, '(uint64_t)node_facts_exponent(standing, payload, records[a].exponent) << 16);', '(uint64_t)records[a].exponent << 16 | (uint64_t)0);'),
    ('f-store-operand-s', F, '        const uint32_t exponent = node_facts_exponent(standing, payload, records[s].exponent);', '        const uint32_t exponent = records[s].exponent;'),
    ('f-value-line-none', F, '    line->exponent = (uint16_t)node_facts_exponent(line->standing, line->payload, line->exponent);\n', ''),
    ('f-front-integer-none', F, '        .exponent = (uint16_t)node_facts_small(integer),\n', ''),
    ('f-window-leaf-none', F, ' | UINT64_C(1) << 8 | (uint64_t)node_facts_small(integer) << 16;', ' | UINT64_C(1) << 8;'),
    ('f-window-leaf-wrong', F, ' | UINT64_C(1) << 8 | (uint64_t)node_facts_small(integer) << 16;', ' | UINT64_C(1) << 8 | (uint64_t)node_facts_small(integer + 1) << 16;'),
    ('f-expected-columns', F, '        .exponent = (standing & BUSTER_NODE_MACHINE_FIELD) == BUSTER_NODE_MACHINE_FLOATING ? facts->expected_exponents[at] : 0,', '        .exponent = (standing & BUSTER_NODE_MACHINE_FIELD) == BUSTER_NODE_MACHINE_FLOATING ? facts->expected_exponents[at] : 7,'),
    ('r-exponent-any', R, '    return (record->standing & BUSTER_NODE_MACHINE_FIELD) == BUSTER_NODE_MACHINE_FLOATING ? record->exponent : 0;', '    return record->exponent;'),
    ('l-pair-no-right', C, '_mm512_ternarylogic_epi64(_mm512_set1_epi8(BUSTER_NODE_TESTS_KINDS - 1), _mm512_srli_epi16(kind_left, BUSTER_NODE_TESTS_KIND_SHIFT), kind_right, 0xca);', '_mm512_ternarylogic_epi64(_mm512_set1_epi8(BUSTER_NODE_TESTS_KINDS - 1), _mm512_srli_epi16(kind_left, BUSTER_NODE_TESTS_KIND_SHIFT), _mm512_andnot_si512(kind_right, kind_right), 0xca);'),
    ('l-pair-no-left', C, '_mm512_ternarylogic_epi64(_mm512_set1_epi8(BUSTER_NODE_TESTS_KINDS - 1), _mm512_srli_epi16(kind_left, BUSTER_NODE_TESTS_KIND_SHIFT), kind_right, 0xca);', '_mm512_ternarylogic_epi64(_mm512_set1_epi8(BUSTER_NODE_TESTS_KINDS - 1), _mm512_srli_epi16(_mm512_andnot_si512(kind_left, kind_left), BUSTER_NODE_TESTS_KIND_SHIFT), kind_right, 0xca);'),
    ('p-unary-any', C, '(integer_left ? BUSTER_NODE_TESTS_QUIET_UNARY : 0) |', '(integer_left || true ? BUSTER_NODE_TESTS_QUIET_UNARY : 0) |'),
    ('p-unary-both', C, '(integer_left ? BUSTER_NODE_TESTS_QUIET_UNARY : 0) |', '(both ? BUSTER_NODE_TESTS_QUIET_UNARY : 0) |'),
    ('p-binary-first-only', C, 'pairs[pair] = (uint8_t)((both ? BUSTER_NODE_TESTS_QUIET_BINARY : 0) |', 'pairs[pair] = (uint8_t)((integer_left ? BUSTER_NODE_TESTS_QUIET_BINARY : 0) |'),
    ('p-convert-never', C, '(converted ? BUSTER_NODE_TESTS_QUIET_CONVERT : 0));', '(converted && false ? BUSTER_NODE_TESTS_QUIET_CONVERT : 0));'),
    ('b-pointer-any-six', C, 'const __mmask16 pointer = _mm512_mask_cmpeq_epi32_mask(placed, six, _mm512_set1_epi32(0x08));', 'const __mmask16 pointer = _mm512_mask_test_epi32_mask(placed, six, _mm512_set1_epi32(0x08));'),
    ('b-pointer-never', C, 'const __mmask16 pointer = _mm512_mask_cmpeq_epi32_mask(placed, six, _mm512_set1_epi32(0x08));', 'const __mmask16 pointer = _mm512_mask_cmpeq_epi32_mask(placed, six, _mm512_set1_epi32(0x3f));'),
    ('f-from-none', F, '    node_facts_store(record, 24, (uint64_t)standing | 0x100u | (uint64_t)records[a].exponent << 16);', '    node_facts_store(record, 24, (uint64_t)standing | 0x100u | (uint64_t)0 << 16 | (uint64_t)0);'),
    ('f-small-0xfffe', F, '    return (uint32_t)(payload < 0xffffu ? payload : 0xfffeu) + 1u;', '    return (uint32_t)(payload < 0xffffu ? payload : 0xfffdu) + 1u;'),
    ('b-signed-as-unsigned', C, 'kind_bytes = _mm_mask_set1_epi8(kind_bytes, integer, (char)BUSTER_NODE_TESTS_KIND_BITS(BUSTER_NODE_TESTS_KIND_SIGNED));', 'kind_bytes = _mm_mask_set1_epi8(kind_bytes, integer, (char)BUSTER_NODE_TESTS_KIND_BITS(BUSTER_NODE_TESTS_KIND_UNSIGNED));'),
    ('b-kind-no-own-bit', C, '#define BUSTER_NODE_TESTS_KIND_BITS(kind) ((uint8_t)((kind) << BUSTER_NODE_TESTS_KIND_SHIFT | ((kind) >= BUSTER_NODE_TESTS_KIND_SIGNED ? BUSTER_NODE_TESTS_KIND_OWN : 0u)))', '#define BUSTER_NODE_TESTS_KIND_BITS(kind) ((uint8_t)((kind) << BUSTER_NODE_TESTS_KIND_SHIFT | ((kind) > BUSTER_NODE_TESTS_KIND_CONSTANT ? BUSTER_NODE_TESTS_KIND_OWN : 0u)))'),
    ('b-kind-own-bit-pointer', C, '#define BUSTER_NODE_TESTS_KIND_BITS(kind) ((uint8_t)((kind) << BUSTER_NODE_TESTS_KIND_SHIFT | ((kind) >= BUSTER_NODE_TESTS_KIND_SIGNED ? BUSTER_NODE_TESTS_KIND_OWN : 0u)))', '#define BUSTER_NODE_TESTS_KIND_BITS(kind) ((uint8_t)((kind) << BUSTER_NODE_TESTS_KIND_SHIFT | BUSTER_NODE_TESTS_KIND_OWN))'),
    ('b-kinds-not-in-values', C, '            value_bytes = _mm_or_si128(value_bytes, kind_bytes);\n', '            value_bytes = _mm_or_si128(value_bytes, _mm_andnot_si128(kind_bytes, kind_bytes));\n'),
    ('l-pair-no-shift', C, '_mm512_ternarylogic_epi64(_mm512_set1_epi8(BUSTER_NODE_TESTS_KINDS - 1), _mm512_srli_epi16(kind_left, BUSTER_NODE_TESTS_KIND_SHIFT), kind_right, 0xca);', '_mm512_ternarylogic_epi64(_mm512_set1_epi8(BUSTER_NODE_TESTS_KINDS - 1), _mm512_srli_epi16(kind_left, 0), kind_right, 0xca);'),
    ('l-pair-right-is-left', C, '_mm512_ternarylogic_epi64(_mm512_set1_epi8(BUSTER_NODE_TESTS_KINDS - 1), _mm512_srli_epi16(kind_left, BUSTER_NODE_TESTS_KIND_SHIFT), kind_right, 0xca);', '_mm512_ternarylogic_epi64(_mm512_set1_epi8(BUSTER_NODE_TESTS_KINDS - 1), _mm512_srli_epi16(kind_left, BUSTER_NODE_TESTS_KIND_SHIFT), _mm512_or_si512(_mm512_andnot_si512(kind_right, kind_right), kind_left), 0xca);'),
    ('l-previous-values-lost', C, '        previous_values = values;\n', '        previous_values = _mm512_setzero_si512();\n'),
    ('l-left-at-right', C, 'const __m512i kind_left = node_tests_window_operands(at_left, near_left, previous_values, values);', 'const __m512i kind_left = node_tests_window_operands(at_right, near_left, previous_values, values);'),
    ('l-kinds-of-previous', C, 'const __m512i kind_right = node_tests_window_operands(at_right, near_right, previous_values, values);', 'const __m512i kind_right = node_tests_window_operands(at_right, near_right, previous_values, previous_values);'),
]

def read(path):
    return open(path).read()

def check():
    ok = True
    names = set()
    for name, f, old, new in MUTANTS:
        s = read(SRC + f)
        if name in names:
            print('DUPLICATE NAME', name); ok = False
        names.add(name)
        if s.count(old) != 1:
            print(name, 'old text occurs', s.count(old)); ok = False
        if old == new or s.replace(old, new) == s:
            print(name, 'changes nothing'); ok = False
        if new != '' and s.count(new) != 0:
            print(name, 'new text is there already', s.count(new)); ok = False
    print(len(MUTANTS), 'faults;', 'all unique' if ok else 'PROBLEMS')
    return ok

def run(only):
    if not check():
        sys.exit(1)
    results = open(ROOT + '/results%s.txt' % ('' if SHARDS == 1 else '-%d' % SHARD), 'a')
    for place, (name, f, old, new) in enumerate(MUTANTS):
        if (only and name not in only) or place % SHARDS != SHARD:
            continue
        path = SRC + f
        saved = ROOT + '/saved%d.c' % SHARD
        shutil.copyfile(path, saved)
        s = read(path)
        open(path, 'w').write(s.replace(old, new))
        start = time.time()
        build = subprocess.run(['./build.sh', '--config', 'Debug'], cwd=TREE, capture_output=True, text=True)
        built = build.returncode == 0
        verdict = 'NOT BUILT'
        detail = ''
        if built:
            try:
                test = subprocess.run(['./build/compiler', 'test-checker', '--seed', '133', '--part', '5/8'], cwd=TREE, capture_output=True, text=True, timeout=900)
                failed = test.returncode != 0
                lines = [l for l in (test.stderr + test.stdout).splitlines() if 'test-checker' in l and 'retained' not in l]
                detail = ' | '.join(l[:150] for l in lines[:2])
                verdict = 'caught' if failed else 'SURVIVED'
            except subprocess.TimeoutExpired:
                verdict = 'caught (timeout)'
        else:
            detail = (build.stderr + build.stdout)[-300:].replace('\n', ' ')
        shutil.copyfile(saved, path)
        line = f'{name}: {verdict} ({time.time() - start:.0f} s) {detail}'
        print(line, flush=True)
        results.write(line + '\n'); results.flush()
    subprocess.run(['./build.sh', '--config', 'Debug'], cwd=TREE, capture_output=True, text=True)
    print('campaign done', flush=True)
    results.write('campaign done\n'); results.flush()

if __name__ == '__main__':
    if len(sys.argv) > 1 and sys.argv[1] == 'check':
        sys.exit(0 if check() else 1)
    run(sys.argv[2:] if len(sys.argv) > 2 else [])
