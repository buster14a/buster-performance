#!/usr/bin/env python3
# mutants.py: the faults of the loop's quiet rule (buster#2850, the tests on the window, second half), one at a time, in a
# COPY of the tree (/home/user/mut7/tree, or tree<i> for a shard): each is a text of the new code replaced by a faulty
# one, the Debug compiler built, and the node machine's tests run (test-checker part 5 of 8). A fault the tests don't
# fail is a survivor. Every text is checked to be unique before any build, and the file is restored after each fault.
#   mutants.py check        : every fault's texts are unique, applies and reverts
#   mutants.py run [NAME..] : the campaign (all the faults, or those named); results in /home/user/mut7/results*.txt
#   MUT_SHARD=i/n           : the faults whose place in the list is i modulo n, in the tree's copy tree<i>
import subprocess, sys, os, shutil, time

ROOT = '/home/user/mut7'
SHARD, SHARDS = [int(x) for x in os.environ.get('MUT_SHARD', '0/1').split('/')]
TREE = ROOT + ('/tree' if SHARDS == 1 else '/tree%d' % SHARD)
SRC = TREE + '/src/buster/compiler/'
C = 'c_check_node_census.c'
F = 'c_check_node_machine_facts.c'
R = 'c_check_node_machine_reads.c'

K = 'BUSTER_NODE_TESTS_KIND_'
Q = 'BUSTER_NODE_TESTS_QUIET_'
MUTANTS = [
    # the classes' table
    ('t-divide-a-sum', C, "                          op == CHECK_OP_BIT_OR_ASSIGN || op == CHECK_OP_BIT_XOR_ASSIGN;", "                          op == CHECK_OP_BIT_OR_ASSIGN || op == CHECK_OP_BIT_XOR_ASSIGN || op == CHECK_OP_DIVIDE;"),
    ('t-no-add', C, "        const bool sums = op == CHECK_OP_ADD || op == CHECK_OP_SUBTRACT ||", "        const bool sums = op == CHECK_OP_SUBTRACT ||"),
    ('t-no-compound', C, "                          op == CHECK_OP_ADD_ASSIGN || op == CHECK_OP_SUBTRACT_ASSIGN ||", "                          op == CHECK_OP_SUBTRACT_ASSIGN ||"),
    ('t-unary-none', C, "op == CHECK_OP_POSITIVE || op == CHECK_OP_NEGATIVE || op == CHECK_OP_BIT_NOT ? " + Q + "UNARY :", "op == CHECK_OP_POSITIVE || op == CHECK_OP_NEGATIVE || op == CHECK_OP_BIT_NOT ? " + Q + "NONE :"),
    ('t-equality-as-relational', C, "equality ? " + Q + "EQUALITY : comparison ? " + Q + "RELATIONAL :", "equality ? " + Q + "RELATIONAL : comparison ? " + Q + "RELATIONAL :"),
    ('t-relational-as-equality', C, "equality ? " + Q + "EQUALITY : comparison ? " + Q + "RELATIONAL :", "equality ? " + Q + "EQUALITY : comparison ? " + Q + "EQUALITY :"),
    ('t-shift-under-policy', C, "shift && !policy->shift_sign_overflow ? " + Q + "SHIFT :", "shift ? " + Q + "SHIFT :"),
    ('t-division-none', C, "op == CHECK_OP_DIVIDE || op == CHECK_OP_REMAINDER ? " + Q + "DIVISION :", "op == CHECK_OP_DIVIDE || op == CHECK_OP_REMAINDER ? " + Q + "NONE :"),
    ('t-assign-as-binary', C, "op == CHECK_OP_ASSIGN ? " + Q + "ASSIGN :", "op == CHECK_OP_ASSIGN ? " + Q + "BINARY :"),
    ('t-convert-as-unary', C, "op == CHECK_OP_CONVERT ? " + Q + "CONVERT : " + Q + "NONE);", "op == CHECK_OP_CONVERT ? " + Q + "UNARY : " + Q + "NONE);"),
    ('t-convert-none', C, "op == CHECK_OP_CONVERT ? " + Q + "CONVERT : " + Q + "NONE);", "op == CHECK_OP_CONVERT ? " + Q + "NONE : " + Q + "NONE);"),
    ('t-pairs-not-made', C, "    node_tests_quiet_pairs(s->own_quiet_pairs);\n", "    memset(s->own_quiet_pairs, 0, sizeof(s->own_quiet_pairs));\n"),
    # the pairs' table
    ('p-index-swapped', C, "        const uint32_t left = pair % BUSTER_NODE_TESTS_KINDS;\n        const uint32_t right = pair / BUSTER_NODE_TESTS_KINDS;", "        const uint32_t left = pair / BUSTER_NODE_TESTS_KINDS;\n        const uint32_t right = pair % BUSTER_NODE_TESTS_KINDS;"),
    ('p-integer-left-pointer', C, "const bool integer_left = left >= " + K + "SIGNED;", "const bool integer_left = left >= " + K + "POINTER;"),
    ('p-integer-right-pointer', C, "const bool integer_right = right >= " + K + "SIGNED;", "const bool integer_right = right >= " + K + "POINTER;"),
    ('p-constant-left-unsigned', C, "const bool constant_left = left >= " + K + "ZERO;", "const bool constant_left = left >= " + K + "UNSIGNED;"),
    ('p-constant-right-unsigned', C, "const bool constant_right = right >= " + K + "ZERO;", "const bool constant_right = right >= " + K + "UNSIGNED;"),
    ('p-constant-left-never', C, "const bool constant_left = left >= " + K + "ZERO;", "const bool constant_left = left > " + K + "CONSTANT;"),
    ('p-constant-right-never', C, "const bool constant_right = right >= " + K + "ZERO;", "const bool constant_right = right > " + K + "CONSTANT;"),
    ('p-zero-left-tiny', C, "const bool zero_left = left == " + K + "ZERO;", "const bool zero_left = left == " + K + "ZERO || left == " + K + "TINY;"),
    ('p-zero-right-tiny', C, "const bool zero_right = right == " + K + "ZERO;", "const bool zero_right = right == " + K + "ZERO || right == " + K + "TINY;"),
    ('p-small-left-no-tiny', C, "const bool small_left = left == " + K + "TINY || left == " + K + "SMALL;", "const bool small_left = left == " + K + "SMALL;"),
    ('p-small-left-any-constant', C, "const bool small_left = left == " + K + "TINY || left == " + K + "SMALL;", "const bool small_left = left == " + K + "TINY || left == " + K + "SMALL || left == " + K + "CONSTANT;"),
    ('p-small-right-no-tiny', C, "const bool small_right = right == " + K + "TINY || right == " + K + "SMALL;", "const bool small_right = right == " + K + "SMALL;"),
    ('p-small-right-any-constant', C, "const bool small_right = right == " + K + "TINY || right == " + K + "SMALL;", "const bool small_right = right == " + K + "TINY || right == " + K + "SMALL || right == " + K + "CONSTANT;"),
    ('p-tiny-right-small', C, "const bool tiny_right = right == " + K + "ZERO || right == " + K + "TINY;", "const bool tiny_right = right == " + K + "ZERO || right == " + K + "TINY || right == " + K + "SMALL;"),
    ('p-tiny-right-no-zero', C, "const bool tiny_right = right == " + K + "ZERO || right == " + K + "TINY;", "const bool tiny_right = right == " + K + "TINY;"),
    ('p-signed-left-unsigned', C, "const bool signed_left = left == " + K + "SIGNED;", "const bool signed_left = left == " + K + "SIGNED || left == " + K + "UNSIGNED;"),
    ('p-signed-right-unsigned', C, "const bool signed_right = right == " + K + "SIGNED;", "const bool signed_right = right == " + K + "SIGNED || right == " + K + "UNSIGNED;"),
    ('p-both-left-only', C, "const bool both = integer_left && integer_right;", "const bool both = integer_left;"),
    ('p-both-right-only', C, "const bool both = integer_left && integer_right;", "const bool both = integer_right;"),
    ('p-lone-any-right', C, "const bool lone = integer_left && right == " + K + "NONE;", "const bool lone = integer_left;"),
    ('p-lone-no-type', C, "const bool lone = integer_left && right == " + K + "NONE;", "const bool lone = right == " + K + "NONE;"),
    ('p-equal-any-left', C, "const bool equal = (!constant_left || constant_right || zero_left || small_left) &&", "const bool equal = (!constant_left || constant_left) &&"),
    ('p-equal-any-right', C, "&& (!constant_right || constant_left || zero_right || small_right);\n        const bool ordered", "&& (!constant_right || constant_right);\n        const bool ordered"),
    ('p-equal-no-zero', C, "const bool equal = (!constant_left || constant_right || zero_left || small_left) &&", "const bool equal = (!constant_left || constant_right || small_left) &&"),
    ('p-ordered-left-unsigned', C, "const bool ordered = (!constant_left || constant_right || small_left || (zero_left && signed_right)) &&", "const bool ordered = (!constant_left || constant_right || small_left || zero_left) &&"),
    ('p-ordered-right-unsigned', C, "(!constant_right || constant_left || small_right || (zero_right && signed_left));", "(!constant_right || constant_left || small_right || zero_right);"),
    ('p-ordered-left-no-zero', C, "const bool ordered = (!constant_left || constant_right || small_left || (zero_left && signed_right)) &&", "const bool ordered = (!constant_left || constant_right || small_left) &&"),
    ('p-ordered-right-no-zero', C, "(!constant_right || constant_left || small_right || (zero_right && signed_left));", "(!constant_right || constant_left || small_right);"),
    ('p-shift-small-count', C, "const bool shifted = (!constant_right || tiny_right) && (!constant_left || zero_left || small_left);", "const bool shifted = (!constant_right || tiny_right || small_right) && (!constant_left || zero_left || small_left);"),
    ('p-shift-any-shifted', C, "const bool shifted = (!constant_right || tiny_right) && (!constant_left || zero_left || small_left);", "const bool shifted = (!constant_right || tiny_right) && (!constant_left || constant_left);"),
    ('p-divided-by-zero', C, "const bool divided = !constant_right || small_right;", "const bool divided = !constant_right || small_right || zero_right;"),
    ('p-divided-any', C, "const bool divided = !constant_right || small_right;", "const bool divided = !constant_right || constant_right;"),
    ('p-stored-any-constant', C, "const bool stored = zero_right || small_right;", "const bool stored = constant_right;"),
    ('p-stored-no-zero', C, "const bool stored = zero_right || small_right;", "const bool stored = small_right;"),
    ('p-converted-any-constant', C, "const bool converted = zero_left || small_left;", "const bool converted = constant_left;"),
    ('p-converted-no-zero', C, "const bool converted = zero_left || small_left;", "const bool converted = small_left;"),
    ('p-null-left-only', C, "const bool null = (left == " + K + "POINTER && zero_right) || (right == " + K + "POINTER && zero_left);", "const bool null = left == " + K + "POINTER && zero_right;"),
    ('p-null-right-only', C, "const bool null = (left == " + K + "POINTER && zero_right) || (right == " + K + "POINTER && zero_left);", "const bool null = right == " + K + "POINTER && zero_left;"),
    ('p-null-any-constant', C, "const bool null = (left == " + K + "POINTER && zero_right) || (right == " + K + "POINTER && zero_left);", "const bool null = (left == " + K + "POINTER && constant_right) || (right == " + K + "POINTER && constant_left);"),
    ('p-class-binary-any', C, "pairs[pair] = (uint8_t)((both ? " + Q + "BINARY : 0) |", "pairs[pair] = (uint8_t)((both || lone ? " + Q + "BINARY : 0) |"),
    ('p-class-unary-both', C, "(lone ? " + Q + "UNARY : 0) |", "(both ? " + Q + "UNARY : 0) |"),
    ('p-class-equality-any', C, "((both && equal) || null ? " + Q + "EQUALITY : 0) |", "(both || null ? " + Q + "EQUALITY : 0) |"),
    ('p-class-equality-no-null', C, "((both && equal) || null ? " + Q + "EQUALITY : 0) |", "(both && equal ? " + Q + "EQUALITY : 0) |"),
    ('p-class-relational-any', C, "(both && ordered ? " + Q + "RELATIONAL : 0) |", "(both ? " + Q + "RELATIONAL : 0) |"),
    ('p-class-shift-any', C, "(both && shifted ? " + Q + "SHIFT : 0) |", "(both ? " + Q + "SHIFT : 0) |"),
    ('p-class-division-any', C, "(both && divided ? " + Q + "DIVISION : 0) |", "(both ? " + Q + "DIVISION : 0) |"),
    ('p-class-assign-any', C, "(both && stored ? " + Q + "ASSIGN : 0) |", "(both ? " + Q + "ASSIGN : 0) |"),
    ('p-class-convert-any', C, "(lone && converted ? " + Q + "CONVERT : 0));", "(lone ? " + Q + "CONVERT : 0));"),
    # the records' kinds
    ('b-any-kind', C, "const __m512i plain_words = _mm512_sub_epi32(_mm512_and_si512(words, _mm512_set1_epi32(0x00ffffff)),\n                                                         _mm512_set1_epi32((int32_t)((uint32_t)BUSTER_TYPE_KIND_INTEGER << 16 | BUSTER_TYPED_CLASS_I8)));", "const __m512i plain_words = _mm512_sub_epi32(_mm512_and_si512(words, _mm512_set1_epi32(0x0000ffff)),\n                                                         _mm512_set1_epi32((int32_t)(BUSTER_TYPED_CLASS_I8)));"),
    ('b-no-facts', C, "const __m512i plain_words = _mm512_sub_epi32(_mm512_and_si512(words, _mm512_set1_epi32(0x00ffffff)),", "const __m512i plain_words = _mm512_sub_epi32(_mm512_and_si512(words, _mm512_set1_epi32(0x00ff00ff)),"),
    ('b-any-class', C, "_mm512_cmple_epu32_mask(plain_words, _mm512_set1_epi32(BUSTER_TYPED_CLASS_U64 - BUSTER_TYPED_CLASS_I8));", "_mm512_cmple_epu32_mask(plain_words, _mm512_set1_epi32(0xff));"),
    ('b-class-short-of-64', C, "_mm512_cmple_epu32_mask(plain_words, _mm512_set1_epi32(BUSTER_TYPED_CLASS_U64 - BUSTER_TYPED_CLASS_I8));", "_mm512_cmple_epu32_mask(plain_words, _mm512_set1_epi32(BUSTER_TYPED_CLASS_U32 - BUSTER_TYPED_CLASS_I8));"),
    ('b-bit-field-integer', C, "const __mmask16 integer = (__mmask16)(placed & ~bit_field) &", "const __mmask16 integer = (__mmask16)(placed) &"),
    ('b-valued-any-constant', C, "const __mmask16 valued = _mm512_mask_cmpeq_epi32_mask(integer, constant_kinds, _mm512_set1_epi32(CHECK_CONSTANT_INTEGER));", "const __mmask16 valued = _mm512_mask_test_epi32_mask(integer, constant_kinds, constant_kinds);"),
    ('b-valued-never', C, "const __mmask16 valued = _mm512_mask_cmpeq_epi32_mask(integer, constant_kinds, _mm512_set1_epi32(CHECK_CONSTANT_INTEGER));", "const __mmask16 valued = _mm512_mask_cmpeq_epi32_mask(integer, constant_kinds, _mm512_set1_epi32(CHECK_CONSTANT_FLOATING));"),
    ('b-unsigned-signed', C, "const __mmask16 unsigned_type = _mm512_mask_test_epi32_mask((__mmask16)(integer & ~valued), plain_words, _mm512_set1_epi32(1));", "const __mmask16 unsigned_type = _mm512_mask_testn_epi32_mask((__mmask16)(integer & ~valued), plain_words, _mm512_set1_epi32(1));"),
    ('b-every-type-signed', C, "const __mmask16 unsigned_type = _mm512_mask_test_epi32_mask((__mmask16)(integer & ~valued), plain_words, _mm512_set1_epi32(1));", "const __mmask16 unsigned_type = _mm512_mask_test_epi32_mask((__mmask16)(integer & ~valued), plain_words, _mm512_set1_epi32(0));"),
    ('b-value-is-said', C, "const __m512i value = _mm512_sub_epi32(said, _mm512_set1_epi32(1));", "const __m512i value = _mm512_sub_epi32(said, _mm512_set1_epi32(0));"),
    ('b-said-low-byte', C, "const __m512i said = _mm512_srli_epi32(standings, 16);", "const __m512i said = _mm512_and_si512(_mm512_srli_epi32(standings, 16), _mm512_set1_epi32(0xff));"),
    ('b-past-zero-2', C, "const __mmask16 past_zero = _mm512_mask_cmpge_epu32_mask(valued, value, _mm512_set1_epi32(1));", "const __mmask16 past_zero = _mm512_mask_cmpge_epu32_mask(valued, value, _mm512_set1_epi32(2));"),
    ('b-past-tiny-33', C, "const __mmask16 past_tiny = _mm512_mask_cmpge_epu32_mask(valued, value, _mm512_set1_epi32(32));", "const __mmask16 past_tiny = _mm512_mask_cmpge_epu32_mask(valued, value, _mm512_set1_epi32(33));"),
    ('b-past-tiny-31', C, "const __mmask16 past_tiny = _mm512_mask_cmpge_epu32_mask(valued, value, _mm512_set1_epi32(32));", "const __mmask16 past_tiny = _mm512_mask_cmpge_epu32_mask(valued, value, _mm512_set1_epi32(31));"),
    ('b-past-small-128', C, "const __mmask16 past_small = _mm512_mask_cmpge_epu32_mask(valued, value, _mm512_set1_epi32(127));", "const __mmask16 past_small = _mm512_mask_cmpge_epu32_mask(valued, value, _mm512_set1_epi32(128));"),
    ('b-past-small-126', C, "const __mmask16 past_small = _mm512_mask_cmpge_epu32_mask(valued, value, _mm512_set1_epi32(127));", "const __mmask16 past_small = _mm512_mask_cmpge_epu32_mask(valued, value, _mm512_set1_epi32(126));"),
    ('b-pointer-to-void', C, "_mm512_cmpeq_epi32_mask(six, _mm512_set1_epi32(0x08));\n            // Each kind's byte", "_mm512_test_epi32_mask(six, _mm512_set1_epi32(0x08));\n            // Each kind's byte"),
    ('b-pointer-constant', C, "const __mmask16 pointer = (__mmask16)(placed & (~some | address)) &", "const __mmask16 pointer = (__mmask16)(placed) &"),
    ('b-pointer-as-signed', C, "plain_bytes = _mm_maskz_set1_epi8(pointer, (char)BUSTER_NODE_TESTS_PLAIN(" + K + "POINTER));", "plain_bytes = _mm_maskz_set1_epi8(pointer, (char)BUSTER_NODE_TESTS_PLAIN(" + K + "SIGNED));"),
    ('b-unsigned-as-signed', C, "plain_bytes = _mm_mask_set1_epi8(plain_bytes, unsigned_type, (char)BUSTER_NODE_TESTS_PLAIN(" + K + "UNSIGNED));", "plain_bytes = _mm_mask_set1_epi8(plain_bytes, unsigned_type, (char)BUSTER_NODE_TESTS_PLAIN(" + K + "SIGNED));"),
    ('b-zero-as-tiny', C, "plain_bytes = _mm_mask_set1_epi8(plain_bytes, valued, (char)BUSTER_NODE_TESTS_PLAIN(" + K + "ZERO));", "plain_bytes = _mm_mask_set1_epi8(plain_bytes, valued, (char)BUSTER_NODE_TESTS_PLAIN(" + K + "TINY));"),
    ('b-tiny-as-small', C, "plain_bytes = _mm_mask_set1_epi8(plain_bytes, past_zero, (char)BUSTER_NODE_TESTS_PLAIN(" + K + "TINY));", "plain_bytes = _mm_mask_set1_epi8(plain_bytes, past_zero, (char)BUSTER_NODE_TESTS_PLAIN(" + K + "SMALL));"),
    ('b-small-as-tiny', C, "plain_bytes = _mm_mask_set1_epi8(plain_bytes, past_tiny, (char)BUSTER_NODE_TESTS_PLAIN(" + K + "SMALL));", "plain_bytes = _mm_mask_set1_epi8(plain_bytes, past_tiny, (char)BUSTER_NODE_TESTS_PLAIN(" + K + "TINY));"),
    ('b-constant-as-small', C, "plain_bytes = _mm_mask_set1_epi8(plain_bytes, past_small, (char)BUSTER_NODE_TESTS_PLAIN(" + K + "CONSTANT));", "plain_bytes = _mm_mask_set1_epi8(plain_bytes, past_small, (char)BUSTER_NODE_TESTS_PLAIN(" + K + "SMALL));"),
    ('b-plain-no-own-bit', C, "#define BUSTER_NODE_TESTS_PLAIN(kind) ((uint8_t)((kind) | (kind) << 3 | ((kind) >= " + K + "SIGNED ? BUSTER_NODE_TESTS_PLAIN_OWN : 0u)))", "#define BUSTER_NODE_TESTS_PLAIN(kind) ((uint8_t)((kind) | (kind) << 3 | ((kind) > " + K + "CONSTANT ? BUSTER_NODE_TESTS_PLAIN_OWN : 0u)))"),
    ('b-plain-own-bit-pointer', C, "#define BUSTER_NODE_TESTS_PLAIN(kind) ((uint8_t)((kind) | (kind) << 3 | ((kind) >= " + K + "SIGNED ? BUSTER_NODE_TESTS_PLAIN_OWN : 0u)))", "#define BUSTER_NODE_TESTS_PLAIN(kind) ((uint8_t)((kind) | (kind) << 3 | BUSTER_NODE_TESTS_PLAIN_OWN))"),
    ('b-plain-second-lost', C, "#define BUSTER_NODE_TESTS_PLAIN(kind) ((uint8_t)((kind) | (kind) << 3 | ((kind) >= " + K + "SIGNED ? BUSTER_NODE_TESTS_PLAIN_OWN : 0u)))", "#define BUSTER_NODE_TESTS_PLAIN(kind) ((uint8_t)((kind) | ((kind) >= " + K + "SIGNED ? BUSTER_NODE_TESTS_PLAIN_OWN : 0u)))"),
    # the loop's rule
    ('l-pair-left-twice', C, "_mm512_ternarylogic_epi64(_mm512_set1_epi8(BUSTER_NODE_TESTS_KINDS - 1), plain_left, plain_right, 0xca);", "_mm512_ternarylogic_epi64(_mm512_set1_epi8(BUSTER_NODE_TESTS_KINDS - 1), plain_left, plain_left, 0xca);"),
    ('l-pair-right-twice', C, "_mm512_ternarylogic_epi64(_mm512_set1_epi8(BUSTER_NODE_TESTS_KINDS - 1), plain_left, plain_right, 0xca);", "_mm512_ternarylogic_epi64(_mm512_set1_epi8(BUSTER_NODE_TESTS_KINDS - 1), plain_right, plain_right, 0xca);"),
    ('l-pair-swapped', C, "_mm512_ternarylogic_epi64(_mm512_set1_epi8(BUSTER_NODE_TESTS_KINDS - 1), plain_left, plain_right, 0xca);", "_mm512_ternarylogic_epi64(_mm512_set1_epi8(BUSTER_NODE_TESTS_KINDS - 1), plain_right, plain_left, 0xca);"),
    ('l-pair-or', C, "_mm512_ternarylogic_epi64(_mm512_set1_epi8(BUSTER_NODE_TESTS_KINDS - 1), plain_left, plain_right, 0xca);", "_mm512_ternarylogic_epi64(_mm512_set1_epi8(BUSTER_NODE_TESTS_KINDS - 1), plain_left, plain_right, 0xfe);"),
    ('l-own-bit-any', C, "const __m512i own_bit = _mm512_or_si512(plains, _mm512_set1_epi8((char)~BUSTER_NODE_TESTS_PLAIN_OWN));", "const __m512i own_bit = _mm512_or_si512(plains, _mm512_set1_epi8((char)0xff));"),
    ('l-own-bit-of-left', C, "const __m512i own_bit = _mm512_or_si512(plains, _mm512_set1_epi8((char)~BUSTER_NODE_TESTS_PLAIN_OWN));", "const __m512i own_bit = _mm512_or_si512(plain_left, _mm512_set1_epi8((char)~BUSTER_NODE_TESTS_PLAIN_OWN));"),
    ('l-class-any', C, "const __mmask64 quiet_class = _mm512_test_epi8_mask(_mm512_and_si512(paired, own_bit), quiets);", "const __mmask64 quiet_class = _mm512_test_epi8_mask(_mm512_and_si512(paired, own_bit), _mm512_set1_epi8((char)0xff));"),
    ('l-class-no-pair', C, "const __mmask64 quiet_class = _mm512_test_epi8_mask(_mm512_and_si512(paired, own_bit), quiets);", "const __mmask64 quiet_class = _mm512_test_epi8_mask(own_bit, quiets);"),
    ('l-alone-always', C, "const __mmask64 alone = _mm512_testn_epi8_mask(always, always) &", "const __mmask64 alone = (_mm512_testn_epi8_mask(always, always) | ~UINT64_C(0)) &"),
    ('l-alone-any-sent', C, "_mm512_cmpeq_epi8_mask(_mm512_and_si512(sends, operands), _mm512_set1_epi8(BUSTER_NODE_TESTS_OPERAND_CONSTANT));\n        const __mmask64 quiet", "_mm512_test_epi8_mask(_mm512_and_si512(sends, operands), _mm512_set1_epi8(BUSTER_NODE_TESTS_OPERAND_CONSTANT));\n        const __mmask64 quiet"),
    ('l-operators-keep-quiet', C, "masks[BUSTER_NODE_TESTS_MASK_OPERATORS] = _mm512_test_epi8_mask(sent, sent) & ~quiet;", "masks[BUSTER_NODE_TESTS_MASK_OPERATORS] = _mm512_test_epi8_mask(sent, sent) & ~(quiet & 0);"),
    ('l-quiet-not-counted', C, "quiet_total += (uint64_t)_mm_popcnt_u64(quiet);", "quiet_total += (uint64_t)_mm_popcnt_u64(quiet & 0);"),
    ('l-previous-plains-lost', C, "        previous_plains = plains;\n", "        previous_plains = _mm512_setzero_si512();\n"),
    ('l-left-near-right', C, "const __m512i plain_left = node_tests_window_operands(at_left, near_left, previous_plains, plains);", "const __m512i plain_left = node_tests_window_operands(at_left, near_right, previous_plains, plains);"),
    ('l-right-near-left', C, "const __m512i plain_right = node_tests_window_operands(at_right, near_right, previous_plains, plains);", "const __m512i plain_right = node_tests_window_operands(at_right, near_left, previous_plains, plains);"),
    ('l-pairs-not-loaded', C, "    const __m512i quiet_pairs = _mm512_loadu_si512(s->own_quiet_pairs);\n", "    const __m512i quiet_pairs = _mm512_setzero_si512();\n"),
    # an expression's part of the verify's check
    ('e-quiet-first-word-only', C, "quiet_bits[word] = node_tests_window_word(tests->window_masks, BUSTER_NODE_TESTS_MASK_QUIET, first, size, word);", "quiet_bits[word] = node_tests_window_word(tests->window_masks, BUSTER_NODE_TESTS_MASK_QUIET, first, size, 0);"),
    ('e-quiet-no-root', C, "quiet_bits[size / 64] |= (masks[BUSTER_NODE_TESTS_MASK_QUIET] >> (record & 63) & 1) << (size & 63);", "quiet_bits[size / 64] |= (masks[BUSTER_NODE_TESTS_MASK_QUIET] >> (record & 63) & 0) << (size & 63);"),
    ('e-quiet-mask-operators', C, "quiet_bits[word] = node_tests_window_word(tests->window_masks, BUSTER_NODE_TESTS_MASK_QUIET, first, size, word);", "quiet_bits[word] = node_tests_window_word(tests->window_masks, BUSTER_NODE_TESTS_MASK_OPERATORS, first, size, word);"),
    # what a record's exponent says, where it is made
    ('f-small-wraps', F, "    return (uint32_t)(payload < 0xffffu ? payload : 0xfffeu) + 1u;", "    return (uint32_t)(payload & 0xfffeu) + 1u;"),
    ('f-small-no-one', F, "    return (uint32_t)(payload < 0xffffu ? payload : 0xfffeu) + 1u;", "    return (uint32_t)(payload < 0xffffu ? payload : 0xfffeu);"),
    ('f-small-saturates-early', F, "    return (uint32_t)(payload < 0xffffu ? payload : 0xfffeu) + 1u;", "    return (uint32_t)(payload < 0x40u ? payload : 0xfffeu) + 1u;"),
    ('f-exponent-floating-small', F, "    return (standing & BUSTER_NODE_MACHINE_FIELD) == BUSTER_NODE_MACHINE_FLOATING ? exponent : node_facts_small(payload);", "    return (standing & BUSTER_NODE_MACHINE_FIELD) == BUSTER_NODE_MACHINE_OFFSET ? exponent : node_facts_small(payload);"),
    ('f-exponent-operand-s', F, "    return (standing & BUSTER_NODE_MACHINE_FIELD) == BUSTER_NODE_MACHINE_FLOATING ? exponent : node_facts_small(payload);", "    return (standing & BUSTER_NODE_MACHINE_FIELD) == BUSTER_NODE_MACHINE_FLOATING ? exponent : exponent;"),
    ('f-enumerator-none', F, "        .exponent = (uint16_t)(enumerator ? node_facts_small((uint64_t)value) : 0),", "        .exponent = (uint16_t)(enumerator ? 0 : 0),"),
    ('f-literal-columns', F, "        .exponent = (uint16_t)node_facts_exponent(standing, columns->payloads[r], columns->exponents[r]),", "        .exponent = columns->exponents[r],"),
    ('f-record-integer-none', F, "    node_facts_store(record, 24, (uint64_t)standing | 0x100u | (uint64_t)node_facts_small(payload) << 16);", "    node_facts_store(record, 24, (uint64_t)standing | 0x100u | (uint64_t)0 << 16);"),
    ('f-from-operand-s', F, "(uint64_t)node_facts_exponent(standing, records[a].payload, records[a].exponent) << 16);", "(uint64_t)records[a].exponent << 16);"),
    ('f-from-with-operand-s', F, "(uint64_t)node_facts_exponent(standing, payload, records[a].exponent) << 16);", "(uint64_t)records[a].exponent << 16);"),
    ('f-store-operand-s', F, "        const uint32_t exponent = node_facts_exponent(standing, payload, records[s].exponent);", "        const uint32_t exponent = records[s].exponent;"),
    ('f-value-line-none', F, "    line->exponent = (uint16_t)node_facts_exponent(line->standing, line->payload, line->exponent);\n", ""),
    ('f-front-integer-none', F, "        .exponent = (uint16_t)node_facts_small(integer),\n", ""),
    ('f-window-leaf-none', F, " | UINT64_C(1) << 8 | (uint64_t)node_facts_small(integer) << 16;", " | UINT64_C(1) << 8;"),
    ('f-window-leaf-wrong', F, " | UINT64_C(1) << 8 | (uint64_t)node_facts_small(integer) << 16;", " | UINT64_C(1) << 8 | (uint64_t)node_facts_small(integer + 1) << 16;"),
    ('f-expected-columns', F, "        .exponent = (standing & BUSTER_NODE_MACHINE_FIELD) == BUSTER_NODE_MACHINE_FLOATING ? facts->expected_exponents[at] : 0,", "        .exponent = (standing & BUSTER_NODE_MACHINE_FIELD) == BUSTER_NODE_MACHINE_FLOATING ? facts->expected_exponents[at] : 7,"),
    # the reads' census
    ('r-exponent-any', R, "    return (record->standing & BUSTER_NODE_MACHINE_FIELD) == BUSTER_NODE_MACHINE_FLOATING ? record->exponent : 0;", "    return record->exponent;"),
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
