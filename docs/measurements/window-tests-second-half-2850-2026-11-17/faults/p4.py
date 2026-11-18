#!/usr/bin/env python3
# mutants.py: the faults of the loop's quiet rule (buster#2850, the tests on the window, second half), one at a time, in a COPY of the
# tree (/home/user/mut6/tree, or tree<i> for a shard): each is a text of the new code replaced by a faulty one, the Debug
# compiler built, and the node machine's tests run (test-checker part 5 of 8). A fault the tests don't fail is a
# survivor. Every text is checked to be unique before any build, and the file is restored after each fault.
#   mutants.py check        : every fault's texts are unique, applies and reverts
#   mutants.py run [NAME..] : the campaign (all the faults, or those named); results in /home/user/mut6/results*.txt
#   MUT_SHARD=i/n           : the faults whose place in the list is i modulo n, in the tree's copy tree<i>
import subprocess, sys, os, shutil, time

ROOT = '/home/user/mut6'
SHARD, SHARDS = [int(x) for x in os.environ.get('MUT_SHARD', '0/1').split('/')]
TREE = ROOT + ('/tree' if SHARDS == 1 else '/tree%d' % SHARD)
SRC = TREE + '/src/buster/compiler/'
C = 'c_check_node_census.c'
M = 'c_check_node_machine.c'
F = 'c_check_node_machine_facts.c'

MUTANTS = [
    # the classes' table
    ('t-divide-a-sum', C, "                          op == CHECK_OP_BIT_OR_ASSIGN || op == CHECK_OP_BIT_XOR_ASSIGN;", "                          op == CHECK_OP_BIT_OR_ASSIGN || op == CHECK_OP_BIT_XOR_ASSIGN || op == CHECK_OP_DIVIDE;"),
    ('t-no-add', C, "        const bool sums = op == CHECK_OP_ADD || op == CHECK_OP_SUBTRACT ||", "        const bool sums = op == CHECK_OP_SUBTRACT ||"),
    ('t-no-compound', C, "                          op == CHECK_OP_ADD_ASSIGN || op == CHECK_OP_SUBTRACT_ASSIGN ||", "                          op == CHECK_OP_SUBTRACT_ASSIGN ||"),
    ('t-unary-none', C, "op == CHECK_OP_POSITIVE || op == CHECK_OP_NEGATIVE || op == CHECK_OP_BIT_NOT ? BUSTER_NODE_TESTS_QUIET_UNARY :", "op == CHECK_OP_POSITIVE || op == CHECK_OP_NEGATIVE || op == CHECK_OP_BIT_NOT ? BUSTER_NODE_TESTS_QUIET_NONE :"),
    ('t-equality-as-relational', C, "equality ? BUSTER_NODE_TESTS_QUIET_EQUALITY : comparison ? BUSTER_NODE_TESTS_QUIET_RELATIONAL :", "equality ? BUSTER_NODE_TESTS_QUIET_RELATIONAL : comparison ? BUSTER_NODE_TESTS_QUIET_RELATIONAL :"),
    ('t-relational-as-equality', C, "equality ? BUSTER_NODE_TESTS_QUIET_EQUALITY : comparison ? BUSTER_NODE_TESTS_QUIET_RELATIONAL :", "equality ? BUSTER_NODE_TESTS_QUIET_EQUALITY : comparison ? BUSTER_NODE_TESTS_QUIET_EQUALITY :"),
    ('t-shift-under-policy', C, "shift && !policy->shift_sign_overflow ? BUSTER_NODE_TESTS_QUIET_SHIFT :", "shift ? BUSTER_NODE_TESTS_QUIET_SHIFT :"),
    ('t-division-none', C, "op == CHECK_OP_DIVIDE || op == CHECK_OP_REMAINDER ? BUSTER_NODE_TESTS_QUIET_DIVISION :", "op == CHECK_OP_DIVIDE || op == CHECK_OP_REMAINDER ? BUSTER_NODE_TESTS_QUIET_NONE :"),
    ('t-assign-as-binary', C, "op == CHECK_OP_ASSIGN ? BUSTER_NODE_TESTS_QUIET_ASSIGN :", "op == CHECK_OP_ASSIGN ? BUSTER_NODE_TESTS_QUIET_BINARY :"),
    ('t-convert-as-unary', C, "op == CHECK_OP_INITIALIZE || op == CHECK_OP_CONVERT ? BUSTER_NODE_TESTS_QUIET_CONVERT : BUSTER_NODE_TESTS_QUIET_NONE);", "op == CHECK_OP_INITIALIZE || op == CHECK_OP_CONVERT ? BUSTER_NODE_TESTS_QUIET_UNARY : BUSTER_NODE_TESTS_QUIET_NONE);"),
    ('t-initialize-none', C, "op == CHECK_OP_INITIALIZE || op == CHECK_OP_CONVERT ? BUSTER_NODE_TESTS_QUIET_CONVERT :", "op != CHECK_OP_INITIALIZE && op == CHECK_OP_CONVERT ? BUSTER_NODE_TESTS_QUIET_CONVERT :"),
    ('t-convert-none', C, "op == CHECK_OP_INITIALIZE || op == CHECK_OP_CONVERT ? BUSTER_NODE_TESTS_QUIET_CONVERT :", "op == CHECK_OP_INITIALIZE ? BUSTER_NODE_TESTS_QUIET_CONVERT :"),
    # the plain byte
    ('b-any-kind', C, "const __mmask16 integer = (__mmask16)(placed & integer_kind & integer_class & bare &", "const __mmask16 integer = (__mmask16)(placed & (integer_kind | 0xffffu) & integer_class & bare &"),
    ('b-any-class', C, "const __mmask16 integer = (__mmask16)(placed & integer_kind & integer_class & bare &", "const __mmask16 integer = (__mmask16)(placed & integer_kind & (integer_class | 0xffffu) & bare &"),
    ('b-no-facts', C, "_mm512_set1_epi32((int32_t)(0xff00u | 0x3fu << BUSTER_NODE_MACHINE_WORD_TESTS_SHIFT)));\n            const uint32_t integer_constant", "_mm512_set1_epi32((int32_t)(0x3fu << BUSTER_NODE_MACHINE_WORD_TESTS_SHIFT)));\n            const uint32_t integer_constant"),
    ('b-no-six', C, "_mm512_set1_epi32((int32_t)(0xff00u | 0x3fu << BUSTER_NODE_MACHINE_WORD_TESTS_SHIFT)));\n            const uint32_t integer_constant", "_mm512_set1_epi32((int32_t)(0xff00u)));\n            const uint32_t integer_constant"),
    ('b-bit-field-integer', C, "integer_class & bare & ~bit_field & (~some | integer_constant | address));", "integer_class & bare & (~some | integer_constant | address));"),
    ('b-any-constant-kind', C, "integer_class & bare & ~bit_field & (~some | integer_constant | address));", "integer_class & bare & ~bit_field);"),
    ('b-unsigned-signed', C, "const __mmask16 signed_type = _mm512_mask_testn_epi32_mask(integer, type_classes, _mm512_set1_epi32(1));", "const __mmask16 signed_type = _mm512_mask_test_epi32_mask(integer, type_classes, _mm512_set1_epi32(1));"),
    ('b-every-type-signed', C, "const __mmask16 signed_type = _mm512_mask_testn_epi32_mask(integer, type_classes, _mm512_set1_epi32(1));", "const __mmask16 signed_type = _mm512_mask_testn_epi32_mask(integer, type_classes, _mm512_set1_epi32(0));"),
    ('b-wide-types-valued', C, "                                     _mm512_cmple_epu32_mask(type_classes, _mm512_set1_epi32(BUSTER_TYPED_CLASS_U32 - BUSTER_TYPED_CLASS_I8)) &\n", "                                     _mm512_cmple_epu32_mask(type_classes, _mm512_set1_epi32(BUSTER_TYPED_CLASS_U64 - BUSTER_TYPED_CLASS_I8)) &\n"),
    ('b-wide-standing-valued', C, "_mm512_testn_epi32_mask(standings, _mm512_set1_epi32(BUSTER_NODE_MACHINE_WIDE | BUSTER_NODE_MACHINE_FIELD));\n            const __m512i low", "_mm512_testn_epi32_mask(standings, _mm512_set1_epi32(0));\n            const __m512i low"),
    ('b-small-127', C, "_mm512_mask_cmple_epu32_mask(valued, low, _mm512_set1_epi32(126)) & ~zero_value);", "_mm512_mask_cmple_epu32_mask(valued, low, _mm512_set1_epi32(127)) & ~zero_value);"),
    ('b-small-with-zero', C, "_mm512_mask_cmple_epu32_mask(valued, low, _mm512_set1_epi32(126)) & ~zero_value);", "_mm512_mask_cmple_epu32_mask(valued, low, _mm512_set1_epi32(126)) & ~(zero_value & 0));"),
    ('b-tiny-32', C, "const __mmask16 tiny_value = _mm512_mask_cmple_epu32_mask(valued, low, _mm512_set1_epi32(31));", "const __mmask16 tiny_value = _mm512_mask_cmple_epu32_mask(valued, low, _mm512_set1_epi32(32));"),
    ('b-zero-never', C, "const __mmask16 zero_value = _mm512_mask_testn_epi32_mask(valued, low, low);", "const __mmask16 zero_value = (__mmask16)(_mm512_mask_testn_epi32_mask(valued, low, low) & 0);"),
    ('b-pointer-to-void', C, "_mm512_cmpeq_epi32_mask(six, _mm512_set1_epi32(0x08));", "_mm512_test_epi32_mask(six, _mm512_set1_epi32(0x18));"),
    ('b-no-constant-bit', C, "_mm_maskz_set1_epi8((__mmask16)(integer & integer_constant), BUSTER_NODE_TESTS_PLAIN_CONSTANT)),", "_mm_maskz_set1_epi8((__mmask16)(integer & integer_constant & 0), BUSTER_NODE_TESTS_PLAIN_CONSTANT)),"),
    ('b-payload-high-half', C, "const __m512i low = _mm512_mask_i32gather_epi32(_mm512_set1_epi32(-1), valued, lines, base + offsetof(NodeFactsRecord, payload), 1);", "const __m512i low = _mm512_mask_i32gather_epi32(_mm512_set1_epi32(-1), valued, lines, base + offsetof(NodeFactsRecord, payload) + 4, 1);"),
    # the loop's rule
    ('l-pair-no-right', C, "const __mmask64 pair = some_left & integer_left & integer_right & binary;", "const __mmask64 pair = some_left & integer_left & binary;"),
    ('l-pair-no-left', C, "const __mmask64 pair = some_left & integer_left & integer_right & binary;", "const __mmask64 pair = some_left & integer_right & binary;"),
    ('l-lone-no-type', C, "const __mmask64 lone = some_left & integer_left & ~binary;", "const __mmask64 lone = some_left & ~binary;"),
    ('l-equal-any-left', C, "const __mmask64 equal = (~constant_left | constant_right | zero_left | small_left) &", "const __mmask64 equal = (~constant_left | constant_left) &"),
    ('l-equal-any-right', C, "(~constant_right | constant_left | zero_right | small_right);\n        const __mmask64 ordered", "(~constant_right | constant_right);\n        const __mmask64 ordered"),
    ('l-ordered-left-unsigned', C, "const __mmask64 ordered = (~constant_left | constant_right | small_left | (zero_left & signed_right)) &", "const __mmask64 ordered = (~constant_left | constant_right | small_left | zero_left) &"),
    ('l-ordered-right-unsigned', C, "(~constant_right | constant_left | small_right | (zero_right & signed_left));", "(~constant_right | constant_left | small_right | zero_right);"),
    ('l-shift-small-count', C, "const __mmask64 shifted = (~constant_right | tiny_right) & (~constant_left | zero_left | small_left);", "const __mmask64 shifted = (~constant_right | small_right) & (~constant_left | zero_left | small_left);"),
    ('l-shift-any-shifted', C, "const __mmask64 shifted = (~constant_right | tiny_right) & (~constant_left | zero_left | small_left);", "const __mmask64 shifted = (~constant_right | tiny_right);"),
    ('l-divided-by-zero', C, "const __mmask64 divided = ~constant_right | small_right;", "const __mmask64 divided = ~constant_right | small_right | zero_right;"),
    ('l-stored-any-value', C, "const __mmask64 stored = constant_right & (zero_right | small_right);", "const __mmask64 stored = constant_right;"),
    ('l-converted-any-type', C, "const __mmask64 converted = integer_own & constant_left & (zero_left | small_left);", "const __mmask64 converted = constant_left & (zero_left | small_left);"),
    ('l-converted-any-value', C, "const __mmask64 converted = integer_own & constant_left & (zero_left | small_left);", "const __mmask64 converted = integer_own & constant_left;"),
    ('l-null-left-only', C, "const __mmask64 null = binary & ((pointer_left & integer_right & zero_right) | (pointer_right & integer_left & zero_left));", "const __mmask64 null = binary & (pointer_left & integer_right & zero_right);"),
    ('l-null-right-only', C, "const __mmask64 null = binary & ((pointer_left & integer_right & zero_right) | (pointer_right & integer_left & zero_left));", "const __mmask64 null = binary & (pointer_right & integer_left & zero_left);"),
    ('l-class-equality-any', C, "BUSTER_NODE_TESTS_QUIET_EQUALITY)) & ((pair & equal) | null)) |", "BUSTER_NODE_TESTS_QUIET_EQUALITY)) & (pair | null)) |"),
    ('l-class-relational-any', C, "BUSTER_NODE_TESTS_QUIET_RELATIONAL)) & pair & ordered) |", "BUSTER_NODE_TESTS_QUIET_RELATIONAL)) & pair) |"),
    ('l-class-shift-any', C, "BUSTER_NODE_TESTS_QUIET_SHIFT)) & pair & shifted) |", "BUSTER_NODE_TESTS_QUIET_SHIFT)) & pair) |"),
    ('l-class-division-any', C, "BUSTER_NODE_TESTS_QUIET_DIVISION)) & pair & divided) |", "BUSTER_NODE_TESTS_QUIET_DIVISION)) & pair) |"),
    ('l-class-assign-any', C, "BUSTER_NODE_TESTS_QUIET_ASSIGN)) & pair & stored) |", "BUSTER_NODE_TESTS_QUIET_ASSIGN)) & pair) |"),
    ('l-class-convert-any', C, "BUSTER_NODE_TESTS_QUIET_CONVERT)) & lone & converted);", "BUSTER_NODE_TESTS_QUIET_CONVERT)) & lone);"),
    ('l-class-unary-pair', C, "BUSTER_NODE_TESTS_QUIET_UNARY)) & lone) |", "BUSTER_NODE_TESTS_QUIET_UNARY)) & pair) |"),
    ('l-alone-always', C, "const __mmask64 alone = _mm512_testn_epi8_mask(always, always) &", "const __mmask64 alone = (_mm512_testn_epi8_mask(always, always) | ~UINT64_C(0)) &"),
    ('l-alone-any-sent', C, "_mm512_cmpeq_epi8_mask(_mm512_and_si512(sends, operands), _mm512_set1_epi8(BUSTER_NODE_TESTS_OPERAND_CONSTANT));\n        const __mmask64 quiet", "_mm512_test_epi8_mask(_mm512_and_si512(sends, operands), _mm512_set1_epi8(BUSTER_NODE_TESTS_OPERAND_CONSTANT));\n        const __mmask64 quiet"),
    ('l-operators-keep-quiet', C, "masks[BUSTER_NODE_TESTS_MASK_OPERATORS] = _mm512_test_epi8_mask(sent, sent) & ~quiet;", "masks[BUSTER_NODE_TESTS_MASK_OPERATORS] = _mm512_test_epi8_mask(sent, sent) & ~(quiet & 0);"),
    ('l-quiet-not-counted', C, "quiet_total += (uint64_t)_mm_popcnt_u64(quiet);", "quiet_total += (uint64_t)_mm_popcnt_u64(quiet & 0);"),
    ('l-previous-plains-lost', C, "        previous_plains = plains;\n", "        previous_plains = _mm512_setzero_si512();\n"),
    ('l-right-plain-of-left', C, "const __m512i plain_right = node_tests_window_operands(at_right, near_right, previous_plains, plains);", "const __m512i plain_right = node_tests_window_operands(at_left, near_left, previous_plains, plains);"),
    ('l-left-plain-of-right', C, "const __m512i plain_left = node_tests_window_operands(at_left, near_left, previous_plains, plains);", "const __m512i plain_left = node_tests_window_operands(at_right, near_right, previous_plains, plains);"),
    # an expression's part of the verify's check
    ('e-quiet-first-word-only', C, "quiet_bits[word] = node_tests_window_word(tests->window_masks, BUSTER_NODE_TESTS_MASK_QUIET, first, size, word);", "quiet_bits[word] = node_tests_window_word(tests->window_masks, BUSTER_NODE_TESTS_MASK_QUIET, first, size, 0);"),
    ('e-quiet-no-root', C, "quiet_bits[size / 64] |= (masks[BUSTER_NODE_TESTS_MASK_QUIET] >> lane & 1) << (size & 63);", "quiet_bits[size / 64] |= (masks[BUSTER_NODE_TESTS_MASK_QUIET] >> lane & 0) << (size & 63);"),
    ('e-quiet-mask-operators', C, "quiet_bits[word] = node_tests_window_word(tests->window_masks, BUSTER_NODE_TESTS_MASK_QUIET, first, size, word);", "quiet_bits[word] = node_tests_window_word(tests->window_masks, BUSTER_NODE_TESTS_MASK_OPERATORS, first, size, word);"),
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
        if s.count(new) != 0:
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
