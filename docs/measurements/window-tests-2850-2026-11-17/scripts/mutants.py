#!/usr/bin/env python3
# mutants.py: the faults of "the tests on the window" (buster#2850, --window-tests), one at a time, in a COPY of the
# tree (/home/user/mut5/tree, or tree<i> for a shard): each is a text of the new code replaced by a faulty one, the Debug
# compiler built, and the node machine's tests run (test-checker part 5 of 8). A fault the tests don't fail is a
# survivor. Every text is checked to be unique before any build, and the file is restored after each fault.
#   mutants.py check        : every fault's texts are unique, applies and reverts
#   mutants.py run [NAME..] : the campaign (all the faults, or those named); results in /home/user/mut5/results*.txt
#   MUT_SHARD=i/n           : the faults whose place in the list is i modulo n, in the tree's copy tree<i>
import subprocess, sys, os, shutil, time

ROOT = '/home/user/mut5'
SHARD, SHARDS = [int(x) for x in os.environ.get('MUT_SHARD', '0/1').split('/')]
TREE = ROOT + ('/tree' if SHARDS == 1 else '/tree%d' % SHARD)
SRC = TREE + '/src/buster/compiler/'
C = 'c_check_node_census.c'
M = 'c_check_node_machine.c'
F = 'c_check_node_machine_facts.c'

MUTANTS = [
    # the type's bits in the machine's word
    ('w-no-special', M, 'const uint32_t tests = ((byte >> 1) & 0x07u) | ((byte >> 2) & 0x38u);', 'const uint32_t tests = ((byte >> 1) & 0x06u) | ((byte >> 2) & 0x38u);'),
    ('w-no-aggregate', M, 'const uint32_t tests = ((byte >> 1) & 0x07u) | ((byte >> 2) & 0x38u);', 'const uint32_t tests = ((byte >> 1) & 0x05u) | ((byte >> 2) & 0x38u);'),
    ('w-no-enumeration', M, 'const uint32_t tests = ((byte >> 1) & 0x07u) | ((byte >> 2) & 0x38u);', 'const uint32_t tests = ((byte >> 1) & 0x03u) | ((byte >> 2) & 0x38u);'),
    ('w-no-pointer', M, 'const uint32_t tests = ((byte >> 1) & 0x07u) | ((byte >> 2) & 0x38u);', 'const uint32_t tests = ((byte >> 1) & 0x07u) | ((byte >> 2) & 0x30u);'),
    ('w-no-void-pointee', M, 'const uint32_t tests = ((byte >> 1) & 0x07u) | ((byte >> 2) & 0x38u);', 'const uint32_t tests = ((byte >> 1) & 0x07u) | ((byte >> 2) & 0x28u);'),
    ('w-no-array', M, 'const uint32_t tests = ((byte >> 1) & 0x07u) | ((byte >> 2) & 0x38u);', 'const uint32_t tests = ((byte >> 1) & 0x07u) | ((byte >> 2) & 0x18u);'),
    # the records' bytes
    ('b-every-record-placed', C, '            const __mmask16 placed = _mm_test_epi8_mask(taken, taken);', '            const __mmask16 placed = (__mmask16)(_mm_test_epi8_mask(taken, taken) | lanes);'),
    ('b-type-low-shift', C, '_mm512_slli_epi32(_mm512_and_si512(six, _mm512_set1_epi32(0x07)), 1),', '_mm512_slli_epi32(_mm512_and_si512(six, _mm512_set1_epi32(0x07)), 2),'),
    ('b-type-high-shift', C, '_mm512_slli_epi32(_mm512_and_si512(six, _mm512_set1_epi32(0x38)), 2));', '_mm512_slli_epi32(_mm512_and_si512(six, _mm512_set1_epi32(0x38)), 1));'),
    ('b-named-none', C, "            const __mmask16 named = _mm_mask_cmpeq_epi8_mask(placed, kinds, _mm_set1_epi8((char)BUSTER_NODE_FACTS_IDENTIFIER));", "            const __mmask16 named = _mm_mask_cmpeq_epi8_mask(placed, kinds, _mm_set1_epi8((char)BUSTER_NODE_FACTS_LITERAL_LINE));"),
    ('b-stray-none', C, "            const __mmask16 stray = _mm_mask_cmpeq_epi8_mask(placed, kinds, _mm_set1_epi8((char)BUSTER_NODE_FACTS_LITERAL));", "            const __mmask16 stray = _mm_mask_cmpeq_epi8_mask(placed, kinds, _mm_set1_epi8((char)BUSTER_NODE_FACTS_LITERAL_LINE));"),
    ('b-line-never-flagged', C, "(uint8_t)(BUSTER_NODE_TESTS_LINE_KNOWN | (node_tests_window_flagged(s, front->tokens[r]) ? BUSTER_NODE_TESTS_LINE_FLAGGED : 0));", "(uint8_t)(BUSTER_NODE_TESTS_LINE_KNOWN | (node_tests_window_flagged(s, front->tokens[r]) ? 0 : 0));"),
    ('b-line-always-flagged', C, "(uint8_t)(BUSTER_NODE_TESTS_LINE_KNOWN | (node_tests_window_flagged(s, front->tokens[r]) ? BUSTER_NODE_TESTS_LINE_FLAGGED : 0));", "(uint8_t)(BUSTER_NODE_TESTS_LINE_KNOWN | (node_tests_window_flagged(s, front->tokens[r]) ? BUSTER_NODE_TESTS_LINE_FLAGGED : BUSTER_NODE_TESTS_LINE_FLAGGED));"),
    ('b-line-of-another', C, "                    const uint32_t number = front->window_entries[r];\n                    lines_made += tests->line_bytes[number] == 0;", "                    const uint32_t number = front->window_entries[r] ^ 1u;\n                    lines_made += tests->line_bytes[number] == 0;"),
    ('b-line-not-read-again', C, "                line = _mm512_mask_i32gather_epi32(zero, named, numbers, tests->line_bytes, 1);\n            }", "                line = _mm512_mask_i32gather_epi32(zero, (__mmask16)(named & ~unknown), numbers, tests->line_bytes, 1);\n            }"),
    ('b-stray-not-asked', C, "                flagged |= node_tests_window_flagged(s, front->tokens[x + lane]) ? 1u << lane : 0;", "                flagged |= node_tests_window_flagged(s, front->tokens[x + lane]) ? 0u << lane : 0;"),
    ('b-constant-any-address', C, "            const __mmask16 constant = (__mmask16)(some & (~address | wide | null));", "            const __mmask16 constant = (__mmask16)(some & (~address | wide | null | address));"),
    ('b-constant-no-address', C, "            const __mmask16 constant = (__mmask16)(some & (~address | wide | null));", "            const __mmask16 constant = (__mmask16)(some & (~address | (wide & null)));"),
    ('b-constant-no-wide', C, "            const __mmask16 constant = (__mmask16)(some & (~address | wide | null));", "            const __mmask16 constant = (__mmask16)(some & (~address | (wide & ~wide) | null));"),
    ('b-constant-no-null', C, "            const __mmask16 constant = (__mmask16)(some & (~address | wide | null));", "            const __mmask16 constant = (__mmask16)(some & (~address | wide | (null & ~null)));"),
    ('b-constant-none', C, "            const __mmask16 constant = (__mmask16)(some & (~address | wide | null));", "            const __mmask16 constant = (__mmask16)(some & ~some & (~address | wide | null));"),
    ('b-constant-kind-bits', C, "            const __m512i constant_kinds = _mm512_and_si512(_mm512_srli_epi32(standings, 2), _mm512_set1_epi32(0x07));", "            const __m512i constant_kinds = _mm512_and_si512(_mm512_srli_epi32(standings, 3), _mm512_set1_epi32(0x07));"),
    ('b-no-bit-field', C, "            const __mmask16 bit_field = _mm512_test_epi32_mask(flags, _mm512_set1_epi32((int32_t)BUSTER_CHECK_BIT_FIELD));", "            const __mmask16 bit_field = _mm512_test_epi32_mask(flags, _mm512_set1_epi32((int32_t)BUSTER_CHECK_REGISTER));"),
    ('b-no-register', C, "            const __mmask16 declaration = (__mmask16)(registered | flagged);", "            const __mmask16 declaration = (__mmask16)((registered & ~registered) | flagged);"),
    ('b-no-flagged', C, "            const __mmask16 declaration = (__mmask16)(registered | flagged);", "            const __mmask16 declaration = (__mmask16)(registered | (flagged & ~flagged));"),
    ('b-no-role', C, "            role_bytes = _mm512_cvtepi32_epi8(_mm512_mask_i32gather_epi32(zero, inside, tokens, roles, 1));", "            role_bytes = _mm512_cvtepi32_epi8(_mm512_mask_i32gather_epi32(zero, (__mmask16)(inside & ~inside), tokens, roles, 1));"),
    ('b-role-of-next-token', C, "            role_bytes = _mm512_cvtepi32_epi8(_mm512_mask_i32gather_epi32(zero, inside, tokens, roles, 1));", "            role_bytes = _mm512_cvtepi32_epi8(_mm512_mask_i32gather_epi32(zero, inside, tokens, roles + 1, 1));"),
    # the loop
    ('l-no-constant-property', C, '        const __m512i property = _mm512_or_si512(_mm512_or_si512(constant, enumeration), _mm512_or_si512(pointed, operand_bits));', '        const __m512i property = _mm512_or_si512(_mm512_or_si512(_mm512_andnot_si512(constant, constant), enumeration), _mm512_or_si512(pointed, operand_bits));'),
    ('l-no-enumeration-property', C, '        const __m512i property = _mm512_or_si512(_mm512_or_si512(constant, enumeration), _mm512_or_si512(pointed, operand_bits));', '        const __m512i property = _mm512_or_si512(_mm512_or_si512(constant, _mm512_andnot_si512(enumeration, enumeration)), _mm512_or_si512(pointed, operand_bits));'),
    ('l-no-pointer-property', C, '        const __m512i property = _mm512_or_si512(_mm512_or_si512(constant, enumeration), _mm512_or_si512(pointed, operand_bits));', '        const __m512i property = _mm512_or_si512(_mm512_or_si512(constant, enumeration), _mm512_or_si512(_mm512_andnot_si512(pointed, pointed), operand_bits));'),
    ('l-no-operator-property', C, '        const __m512i property = _mm512_or_si512(_mm512_or_si512(constant, enumeration), _mm512_or_si512(pointed, operand_bits));', '        const __m512i property = _mm512_or_si512(_mm512_or_si512(constant, enumeration), _mm512_or_si512(pointed, _mm512_andnot_si512(operand_bits, operand_bits)));'),
    ('l-no-left-operand', C, '        __m512i operands = _mm512_or_si512(left, right);', '        __m512i operands = _mm512_or_si512(_mm512_andnot_si512(left, left), right);'),
    ('l-no-right-operand', C, '        __m512i operands = _mm512_or_si512(left, right);', '        __m512i operands = _mm512_or_si512(left, _mm512_andnot_si512(right, right));'),
    ('l-no-far-left', C, "                tests->window_operands[r] |= tests->window_properties[r - front->window_left[r]];", "                tests->window_operands[r] |= tests->window_properties[r] & 0;"),
    ('l-no-far-right', C, "                tests->window_operands[r] |= tests->window_properties[r - front->window_right[r]];", "                tests->window_operands[r] |= tests->window_properties[r] & 0;"),
    ('l-far-not-read-back', C, "            operands = _mm512_loadu_si512(tests->window_operands + x);\n        }", "            operands = _mm512_or_si512(left, right);\n        }"),
    ('l-operand-of-the-block-before-lost', C, "        previous = property;\n    }\n    *far_count += far_total;", "        previous = _mm512_setzero_si512();\n    }\n    *far_count += far_total;"),
    ('l-operand-reach', C, "    const __m512i reach = _mm512_add_epi8(lanes, _mm512_set1_epi8(64));", "    const __m512i reach = _mm512_add_epi8(lanes, _mm512_set1_epi8(63));"),
    ('l-far-never', C, "    *far = some & beyond;", "    *far = some & beyond & ~some;"),
    ('l-set-no-uncoded', C, '        const __m512i set = _mm512_or_si512(_mm512_or_si512(_mm512_or_si512(uncoded, address), _mm512_or_si512(special, aggregate)),', '        const __m512i set = _mm512_or_si512(_mm512_or_si512(_mm512_or_si512(_mm512_andnot_si512(uncoded, uncoded), address), _mm512_or_si512(special, aggregate)),'),
    ('l-set-no-address', C, '        const __m512i set = _mm512_or_si512(_mm512_or_si512(_mm512_or_si512(uncoded, address), _mm512_or_si512(special, aggregate)),', '        const __m512i set = _mm512_or_si512(_mm512_or_si512(_mm512_or_si512(uncoded, _mm512_andnot_si512(address, address)), _mm512_or_si512(special, aggregate)),'),
    ('l-set-no-special', C, '        const __m512i set = _mm512_or_si512(_mm512_or_si512(_mm512_or_si512(uncoded, address), _mm512_or_si512(special, aggregate)),', '        const __m512i set = _mm512_or_si512(_mm512_or_si512(_mm512_or_si512(uncoded, address), _mm512_or_si512(_mm512_andnot_si512(special, special), aggregate)),'),
    ('l-set-no-aggregate', C, '        const __m512i set = _mm512_or_si512(_mm512_or_si512(_mm512_or_si512(uncoded, address), _mm512_or_si512(special, aggregate)),', '        const __m512i set = _mm512_or_si512(_mm512_or_si512(_mm512_or_si512(uncoded, address), _mm512_or_si512(special, _mm512_andnot_si512(aggregate, aggregate))),'),
    ('l-set-no-bit-field', C, '                                            _mm512_or_si512(_mm512_or_si512(bit_field, array), declaration));', '                                            _mm512_or_si512(_mm512_or_si512(_mm512_andnot_si512(bit_field, bit_field), array), declaration));'),
    ('l-set-no-array', C, '                                            _mm512_or_si512(_mm512_or_si512(bit_field, array), declaration));', '                                            _mm512_or_si512(_mm512_or_si512(bit_field, _mm512_andnot_si512(array, array)), declaration));'),
    ('l-set-no-declaration', C, '                                            _mm512_or_si512(_mm512_or_si512(bit_field, array), declaration));', '                                            _mm512_or_si512(_mm512_or_si512(bit_field, array), _mm512_andnot_si512(declaration, declaration)));'),
    ('l-aggregate-of-any-operator', C, '        const __m512i aggregate = _mm512_and_si512(_mm512_slli_epi16(_mm512_and_si512(own, copies), 1), _mm512_set1_epi8(BUSTER_NODE_TESTS_SET_AGGREGATE));', '        const __m512i aggregate = _mm512_and_si512(_mm512_slli_epi16(_mm512_and_si512(own, _mm512_or_si512(copies, _mm512_set1_epi8(-1))), 1), _mm512_set1_epi8(BUSTER_NODE_TESTS_SET_AGGREGATE));'),
    ('l-tree-no-equality', C, '        const __mmask64 equality = _mm512_cmpeq_epi8_mask(roles, _mm512_set1_epi8(PARSE_ROLE_EQUALITY));', '        const __mmask64 equality = _mm512_cmpeq_epi8_mask(roles, _mm512_set1_epi8(PARSE_ROLE_RELATIONAL));'),
    ('l-tree-no-relational', C, '        const __mmask64 relational = _mm512_cmpeq_epi8_mask(roles, _mm512_set1_epi8(PARSE_ROLE_RELATIONAL));', '        const __mmask64 relational = _mm512_cmpeq_epi8_mask(roles, _mm512_set1_epi8(PARSE_ROLE_EQUALITY));'),
    ('l-tree-no-class', C, '        masks[BUSTER_NODE_TESTS_MASK_TREE] = equality | relational | _mm512_test_epi8_mask(classes, _mm512_set1_epi8(BUSTER_NODE_TESTS_CLASS_TREE));', '        masks[BUSTER_NODE_TESTS_MASK_TREE] = equality | relational | _mm512_test_epi8_mask(classes, _mm512_set1_epi8(BUSTER_NODE_TESTS_CLASS_UNCODED));'),
    ('l-operators-always-alone', C, '        const __m512i sent = _mm512_or_si512(always, _mm512_and_si512(sends, operands));', '        const __m512i sent = _mm512_or_si512(always, _mm512_and_si512(_mm512_andnot_si512(sends, sends), operands));'),
    ('l-operators-sent-alone', C, '        const __m512i sent = _mm512_or_si512(always, _mm512_and_si512(sends, operands));', '        const __m512i sent = _mm512_or_si512(_mm512_andnot_si512(always, always), _mm512_and_si512(sends, operands));'),
    ('l-no-writes', C, "        masks[BUSTER_NODE_TESTS_MASK_WRITES] = _mm512_test_epi8_mask(classes, _mm512_set1_epi8(BUSTER_NODE_TESTS_CLASS_WRITE));", "        masks[BUSTER_NODE_TESTS_MASK_WRITES] = _mm512_test_epi8_mask(classes, _mm512_set1_epi8(BUSTER_NODE_TESTS_CLASS_UNCODED));"),
    # an expression's part
    ('e-set-first-block-only', C, "        all = _mm512_or_si512(all, _mm512_maskz_loadu_epi8(lanes, sets + first + done));", "        all = _mm512_or_si512(all, _mm512_maskz_loadu_epi8(done == 0 ? lanes : 0, sets + first + done));"),
    ('e-set-fold-halves', C, "    const uint64_t halves = folded | folded >> 32;", "    const uint64_t halves = folded | folded >> 31 >> 2;"),
    ('e-set-fold-quarters', C, "    const uint64_t quarters = halves | halves >> 16;", "    const uint64_t quarters = halves | halves >> 15 >> 2;"),
    ('e-set-fold-bytes', C, "    return (uint8_t)(quarters | quarters >> 8);", "    return (uint8_t)(quarters | quarters >> 9);"),
    ('e-word-no-next-block', C, "    return (block[0] >> lane | (block[4] << 1) << (63 - lane)) & range;", "    return (block[0] >> lane) & range;"),
    ('e-word-past-the-last', C, "    return (block[0] >> lane | (block[4] << 1) << (63 - lane)) & range;", "    return (block[0] >> lane | (block[4] << 1) << (63 - lane)) | (range & 0);"),
    ('e-word-later-words', C, "    const uint64_t* block = masks + 4 * ((uint64_t)(first / 64) + word) + kind;", "    const uint64_t* block = masks + 4 * ((uint64_t)(first / 64) + word * 0) + kind;"),
    ('e-span-any-token', C, '        const __mmask16 placed = _mm512_mask_cmplt_epu32_mask(lanes, block, limit);\n        low = _mm512_mask_min_epu32(low, placed, low, block);', '        const __mmask16 placed = (__mmask16)(lanes | _mm512_mask_cmplt_epu32_mask(lanes, block, limit));\n        low = _mm512_mask_min_epu32(low, placed, low, block);'),
    ('e-span-first-sixteen', C, "        const __m512i block = _mm512_maskz_loadu_epi32(lanes, tokens + first + done);", "        const __m512i block = _mm512_maskz_loadu_epi32(lanes, tokens + first);"),
    ('e-span-no-lowest', C, "    *lowest = _mm512_reduce_min_epu32(low);", "    *lowest = _mm512_reduce_max_epu32(low);"),
    ('e-span-no-highest', C, "    *highest = _mm512_reduce_max_epu32(high);", "    *highest = _mm512_reduce_min_epu32(high);"),
    ('e-set-without-root', C, "            const uint8_t set = (uint8_t)(node_tests_window_set(tests->window_sets, first, size) | (rooted ? tests->window_sets[record] : 0));", "            const uint8_t set = (uint8_t)(node_tests_window_set(tests->window_sets, first, size) | (rooted ? 0 : 0));"),
    ('e-no-operator-test', C, "            uint64_t bits = (set & BUSTER_NODE_TESTS_SET_UNCODED) != 0 ? UINT64_C(1) << NODE_CENSUS_OPERATOR : 0;", "            uint64_t bits = (set & BUSTER_NODE_TESTS_SET_UNCODED) != 0 ? UINT64_C(0) << NODE_CENSUS_OPERATOR : 0;"),
    ('e-no-type-test', C, "            bits |= (set & BUSTER_NODE_TESTS_SET_SPECIAL) != 0 ? UINT64_C(1) << NODE_CENSUS_TYPE : 0;", "            bits |= (set & BUSTER_NODE_TESTS_SET_SPECIAL) != 0 ? UINT64_C(0) << NODE_CENSUS_TYPE : 0;"),
    ('e-no-bit-field-test', C, "            bits |= (set & BUSTER_NODE_TESTS_SET_BIT_FIELD) != 0 ? UINT64_C(1) << NODE_CENSUS_BIT_FIELD : 0;", "            bits |= (set & BUSTER_NODE_TESTS_SET_BIT_FIELD) != 0 ? UINT64_C(0) << NODE_CENSUS_BIT_FIELD : 0;"),
    ('e-no-aggregate-test', C, "            bits |= (set & BUSTER_NODE_TESTS_SET_AGGREGATE) != 0 ? UINT64_C(1) << NODE_CENSUS_AGGREGATE : 0;", "            bits |= (set & BUSTER_NODE_TESTS_SET_AGGREGATE) != 0 ? UINT64_C(0) << NODE_CENSUS_AGGREGATE : 0;"),
    ('e-no-packed-test', C, "            bits |= (set & BUSTER_NODE_TESTS_SET_ADDRESS) != 0 && policy->packed_member && s->packed_unit ? UINT64_C(1) << NODE_CENSUS_PACKED_MEMBER : 0;", "            bits |= (set & BUSTER_NODE_TESTS_SET_ADDRESS) != 0 && policy->packed_member && s->packed_unit ? UINT64_C(0) << NODE_CENSUS_PACKED_MEMBER : 0;"),
    ('e-no-declaration-test', C, "            bits |= (set & BUSTER_NODE_TESTS_SET_DECLARATION) != 0 ? UINT64_C(1) << NODE_CENSUS_DECLARATION : 0;", "            bits |= (set & BUSTER_NODE_TESTS_SET_DECLARATION) != 0 ? UINT64_C(0) << NODE_CENSUS_DECLARATION : 0;"),
    ('e-no-address-class', C, "            loop->class_bits = (set & BUSTER_NODE_TESTS_SET_ADDRESS) != 0 ? BUSTER_NODE_TESTS_CLASS_ADDRESS : 0;", "            loop->class_bits = (set & BUSTER_NODE_TESTS_SET_ADDRESS) != 0 ? 0 : 0;"),
    ('e-no-array-type', C, "            loop->type_bits = (set & BUSTER_NODE_TESTS_SET_ARRAY) != 0 ? BUSTER_NODE_CENSUS_TYPE_ARRAY : 0;", "            loop->type_bits = (set & BUSTER_NODE_TESTS_SET_ARRAY) != 0 ? 0 : 0;"),
    ('e-one-word', C, "            const uint32_t words = size / 64 + 1;", "            const uint32_t words = size / 64 + 1 - size / 64;"),
    ('e-no-writes', C, "                writes += (uint32_t)_mm_popcnt_u64(written);", "                writes += (uint32_t)_mm_popcnt_u64(written & 0);"),
    ('e-last-write-one-before', C, '                last_write = written != 0 ? word * 64 + 63 - (uint32_t)_lzcnt_u64(written) : last_write;', '                last_write = written != 0 ? word * 64 + 62 - (uint32_t)_lzcnt_u64(written) : last_write;'),
    ('e-root-no-operator', C, "                operator_bits[size / 64] |= (masks[BUSTER_NODE_TESTS_MASK_OPERATORS] >> lane & 1) << (size & 63);", "                operator_bits[size / 64] |= (masks[BUSTER_NODE_TESTS_MASK_OPERATORS] >> lane & 0) << (size & 63);"),
    ('e-root-token-not-lowest', C, "                lowest = token < token_count && token < lowest ? token : lowest;", "                lowest = token < token_count && token < lowest ? lowest : lowest;"),
    ('e-root-token-not-highest', C, "                highest = token < token_count && token > highest ? token : highest;", "                highest = token < token_count && token > highest ? highest : highest;"),
    ('e-initialization-rooted', C, "            const bool rooted = state->counts[e] > size;\n            // The set, from the bits of all its records.", "            const bool rooted = state->counts[e] >= size;\n            // The set, from the bits of all its records."),
    # the tests on T's records, and the comparison
    ('t-root-apart-not-stood-in', C, '                columns[c][operand + 1] = lone ? columns[c][record] : columns[c][operand + 1];', '                columns[c][operand + 1] = lone ? columns[c][operand + 1] : columns[c][operand + 1];'),
    ('t-tree-record', C, "            const uint32_t r = word * 64 + (uint32_t)__builtin_ctzll(pending);\n            const uint32_t node = r + 1 == count ? root : first + r;\n            const uint32_t token = tokens[node];", "            const uint32_t r = (uint32_t)__builtin_ctzll(pending);\n            const uint32_t node = r + 1 == count ? root : first + r;\n            const uint32_t token = tokens[node];"),
    ('t-operator-record', C, "            const uint32_t r = word * 64 + (uint32_t)__builtin_ctzll(pending);\n            tests |= node_tests_operator(", "            const uint32_t r = (uint32_t)__builtin_ctzll(pending);\n            tests |= node_tests_operator("),
    ('t-operands-of-first', C, "tests |= node_tests_operator(s, r, r + 1 == count ? root : first + r, loop->operands[r], visit, &visits, counts);", "tests |= node_tests_operator(s, r, r + 1 == count ? root : first + r, loop->operands[0], visit, &visits, counts);"),
    ('t-third-operand-byte', C, "    const uint8_t all = (uint8_t)(operands | (o[2] != UINT32_MAX ? properties[o[2]] : 0));", "    const uint8_t all = (uint8_t)(operands | (o[2] != UINT32_MAX ? 0 : 0));"),
    ('c-span-not-kept', C, "        tests->span_lows[root] = s->span_low;\n        tests->span_highs[root] = s->span_high;", "        tests->span_lows[root] = s->span_low;\n        tests->span_highs[root] = s->span_low;"),
    ('c-not-placed-run', F, '        state->placed[e] = placed;', '        state->placed[e] = placed | 1;'),
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
