#!/usr/bin/env python3
# mutants.py: the faults of the calls' rule and of a statement that discards nothing (buster#2850, the tests on the
# window, second half, third piece), one at a time, in a COPY of the tree (/home/user/mut13/tree<i>): each is a text of
# the new code replaced by a faulty one, the Debug compiler built, and the node machine's tests run (test-checker part 5
# of 8). A fault the tests don't fail is a survivor. Every text is checked to be unique before any build, and the file
# is restored after each fault.
#   mutants.py check        : every fault's texts are unique, applies and reverts
#   mutants.py run [NAME..] : the campaign (all the faults, or those named); results in /home/user/mut13/<ROUND>-results-<i>.txt
#   MUT_SHARD=i/n           : the faults whose place in the list is i modulo n, in the tree's copy tree<i>
#   MUT_ROUND=name          : the results' file's name (default round1)
import subprocess, sys, os, shutil, time

ROOT = '/home/user/mut13'
SHARD, SHARDS = [int(x) for x in os.environ.get('MUT_SHARD', '0/1').split('/')]
ROUND = os.environ.get('MUT_ROUND', 'round2')
TREE = ROOT + '/tree%d' % SHARD
SRC = TREE + '/src/buster/compiler/'
C = 'c_check_node_census.c'
R = 'c_check_node_machine_facts.c'

def read(path):
    return open(path).read()

TEXT = {C: read(SRC + C), R: read(SRC + R)}

def line(f, needle, nth=None):
    """The whole line of file f that has `needle`: the only one, or the nth of several (from 0)."""
    found = [l for l in TEXT[f].split('\n') if needle in l]
    if nth is None:
        assert len(found) == 1, (needle, len(found))
        return found[0]
    assert len(found) > nth, (needle, len(found))
    return found[nth]

MUTANTS = []

def fault(name, f, old, a, b):
    """In the text `old` of file f, `a` replaced by `b`."""
    assert a in old, (name, a)
    MUTANTS.append((name, f, old, old.replace(a, b)))

# The kernel: a type's row, what each parameter takes.
TAKES1 = line(R, 'takes = takes && parameter_kind != BUSTER_TYPE_KIND_FLOATING && (word >> BUSTER_NODE_MACHINE_WORD_TESTS_SHIFT & BUSTER_NODE_FACTS_TESTS_ENUM) == 0 &&')
TAKES2 = line(R, '                    (parameter_kind != BUSTER_TYPE_KIND_INTEGER || plain_integer);')
PLAIN = line(R, 'const bool plain_integer = (word & 0x00ffffffu)')
ROWTAKES = line(R, '(takes ? BUSTER_NODE_FACTS_TAKES : 0) |')
fault('k-takes-floating', R, TAKES1, 'parameter_kind != BUSTER_TYPE_KIND_FLOATING &&', 'parameter_kind != BUSTER_TYPE_KIND_VOID &&')
fault('k-takes-enum', R, TAKES1, '(word >> BUSTER_NODE_MACHINE_WORD_TESTS_SHIFT & BUSTER_NODE_FACTS_TESTS_ENUM) == 0 &&', 'true &&')
fault('k-takes-integer', R, TAKES2, '(parameter_kind != BUSTER_TYPE_KIND_INTEGER || plain_integer)', '(parameter_kind != BUSTER_TYPE_KIND_INTEGER || plain_integer || true)')
fault('k-takes-integer-any', R, TAKES2, '(parameter_kind != BUSTER_TYPE_KIND_INTEGER || plain_integer)', '(parameter_kind == BUSTER_TYPE_KIND_INTEGER && plain_integer)')
fault('k-takes-plain-first', R, PLAIN, '<= BUSTER_TYPED_CLASS_U64 - BUSTER_TYPED_CLASS_I8', '< BUSTER_TYPED_CLASS_U64 - BUSTER_TYPED_CLASS_I8')
fault('k-takes-plain-kind', R, PLAIN, '(word & 0x00ffffffu)', '(word & 0x0000ffffu)')
fault('k-takes-never', R, ROWTAKES, '(takes ? BUSTER_NODE_FACTS_TAKES : 0)', '(takes ? 0u : 0u)')
fault('k-takes-always', R, ROWTAKES, '(takes ? BUSTER_NODE_FACTS_TAKES : 0)', '(takes ? BUSTER_NODE_FACTS_TAKES : BUSTER_NODE_FACTS_TAKES)')
fault('k-takes-inverted', R, ROWTAKES, '(takes ? BUSTER_NODE_FACTS_TAKES : 0)', '(takes ? 0 : BUSTER_NODE_FACTS_TAKES)')
fault('k-takes-last-alone', R, TAKES1, 'takes = takes && ', 'takes = ')

# The kernel: what the arguments say.
KIND = line(R, 'const uint32_t kind = ((uint32_t)argument->standing >> 2) & 0x07u;')
KINDS = line(R, 'asked->kinds |= 1u << kind;')
LARGE = line(R, 'asked->large |= (kind == CHECK_CONSTANT_INTEGER) & ((uint32_t)argument->exponent - 1u > 126u);')
WORDS = line(R, 'asked->words |= argument->word;')
fault('k-arg-kind-shift', R, KIND, '>> 2) & 0x07u', '>> 3) & 0x07u')
fault('k-arg-kinds-none', R, KINDS, '1u << kind', '1u << CHECK_CONSTANT_NONE')
fault('k-arg-kinds-last', R, KINDS, 'asked->kinds |= ', 'asked->kinds = ')
fault('k-arg-large-127', R, LARGE, '- 1u > 126u', '- 1u > 127u')
fault('k-arg-large-125', R, LARGE, '- 1u > 126u', '- 1u > 125u')
fault('k-arg-large-zero', R, LARGE, '(uint32_t)argument->exponent - 1u > 126u', '(uint32_t)argument->exponent > 127u')
fault('k-arg-large-kind', R, LARGE, '(kind == CHECK_CONSTANT_INTEGER) & ', '')
fault('k-arg-large-never', R, LARGE, '(kind == CHECK_CONSTANT_INTEGER) & ', '(kind == CHECK_CONSTANT_FLOATING) & ')
fault('k-arg-large-last', R, LARGE, 'asked->large |= ', 'asked->large = ')
fault('k-arg-words-none', R, WORDS, 'asked->words |= argument->word;', 'asked->words |= 0;')
fault('k-arg-words-last', R, WORDS, 'asked->words |= ', 'asked->words = ')

# The kernel: the arguments' verdict.
QKINDS = line(R, 'const uint32_t quiet_kinds = 1u << CHECK_CONSTANT_NONE | 1u << CHECK_CONSTANT_INTEGER | 1u << CHECK_CONSTANT_ADDRESS;')
LOUD = line(R, 'const uint32_t loud = (asked->words >> BUSTER_NODE_MACHINE_WORD_TESTS_SHIFT & BUSTER_NODE_FACTS_TESTS_AGGREGATE) | (asked->kinds & ~quiet_kinds) | asked->large;')
QTAKES = line(R, 'const bool takes = (asked->kinds & 1u << CHECK_CONSTANT_INTEGER) == 0 || (function & BUSTER_NODE_FACTS_TAKES) != 0;')
QRET = line(R, 'return loud == 0 && takes ? BUSTER_NODE_FACTS_QUIET_CALL : 0;')
fault('k-quiet-kinds-none', R, QKINDS, '1u << CHECK_CONSTANT_NONE | ', '')
fault('k-quiet-kinds-integer', R, QKINDS, '1u << CHECK_CONSTANT_INTEGER | ', '')
fault('k-quiet-kinds-address', R, QKINDS, ' | 1u << CHECK_CONSTANT_ADDRESS', '')
fault('k-quiet-kinds-floating', R, QKINDS, ' | 1u << CHECK_CONSTANT_ADDRESS', ' | 1u << CHECK_CONSTANT_ADDRESS | 1u << CHECK_CONSTANT_FLOATING')
fault('k-quiet-aggregate', R, LOUD, '(asked->words >> BUSTER_NODE_MACHINE_WORD_TESTS_SHIFT & BUSTER_NODE_FACTS_TESTS_AGGREGATE) | ', '')
fault('k-quiet-aggregate-bit', R, LOUD, 'BUSTER_NODE_FACTS_TESTS_AGGREGATE', 'BUSTER_NODE_FACTS_TESTS_ENUM')
fault('k-quiet-loud-kinds', R, LOUD, ' | (asked->kinds & ~quiet_kinds)', ' | (asked->kinds & ~quiet_kinds & 0u)')
fault('k-quiet-large', R, LOUD, ' | asked->large', '')
fault('k-quiet-takes-any', R, QTAKES, '(asked->kinds & 1u << CHECK_CONSTANT_INTEGER) == 0 || ', '')
fault('k-quiet-takes-ignored', R, QTAKES, ' || (function & BUSTER_NODE_FACTS_TAKES) != 0', ' || true')
fault('k-quiet-takes-kind', R, QTAKES, '1u << CHECK_CONSTANT_INTEGER) == 0', '1u << CHECK_CONSTANT_ADDRESS) == 0')
fault('k-quiet-always', R, QRET, 'loud == 0 && takes ?', '(loud == 0 && takes) || true ?')
fault('k-quiet-never', R, QRET, 'loud == 0 && takes ?', '(loud == 0 && takes) && false ?')
fault('k-quiet-no-loud', R, QRET, 'loud == 0 && takes', '(loud == 0 || true) && takes')
fault('k-quiet-no-takes', R, QRET, 'loud == 0 && takes', 'loud == 0 && (takes || true)')

# The kernel: the two rules' gathering and stores.
STORE_FAST = line(R, 'node_facts_store(records + w, 24, (uint64_t)made | 0x100u | (uint64_t)node_facts_arguments_quiet(&asked, function) << 16);')
ARG_FAST = line(R, '        node_facts_argument(&asked, records + place);')
ARG_MORE = line(R, '        node_facts_argument(&asked, argument);')
fault('k-store-fast-none', R, STORE_FAST, ' | (uint64_t)node_facts_arguments_quiet(&asked, function) << 16', '')
fault('k-store-fast-always', R, STORE_FAST, '(uint64_t)node_facts_arguments_quiet(&asked, function) << 16', '(uint64_t)BUSTER_NODE_FACTS_QUIET_CALL << 16')
fault('k-gather-fast', R, ARG_FAST, 'node_facts_argument(&asked, records + place);', '(void)asked;')
fault('k-gather-fast-callee', R, ARG_FAST, 'records + place', 'records + a')
fault('k-gather-more', R, ARG_MORE, 'node_facts_argument(&asked, argument);', '(void)asked;')

# The tests: the unit's switch, the records' bytes.
SWITCH = line(C, 's->own_calls_quiet = !policy->type_safety;')
NOVALUE = line(C, 'own_bytes = _mm_or_si128(_mm512_cvtepi32_epi8(own), _mm_maskz_set1_epi8(no_value, BUSTER_NODE_TESTS_TYPE_VOID));')
NOVALUE_KIND = line(C, '_mm512_set1_epi32((int32_t)((uint32_t)BUSTER_TYPE_KIND_VOID << 16)));')
QCALL = line(C, 'const __mmask16 quiet_call = _mm512_test_epi32_mask(standings, _mm512_set1_epi32((int32_t)((uint32_t)BUSTER_NODE_FACTS_QUIET_CALL << 16)));')
QCALL_BYTE = line(C, 'own_bytes = _mm_or_si128(own_bytes, _mm_maskz_set1_epi8(quiet_call, BUSTER_NODE_TESTS_TYPE_QUIET));')
CALLS_LINE = line(C, 'const bool calls = (node_tests_window_row(&state->facts, type)->function & BUSTER_NODE_FACTS_FUNCTION) != 0;', 0)
LINE_MADE = line(C, 'tests->line_bytes[number] = (uint8_t)(BUSTER_NODE_TESTS_LINE_KNOWN | node_tests_window_line(s, front->tokens[r], calls));')
LOUD_MASK = line(C, 'const uint32_t loud = _mm512_test_epi32_mask(line, _mm512_set1_epi32(BUSTER_NODE_TESTS_LINE_LOUD)) | stray;')
LOUD_BYTE = line(C, 'const __m128i loud_byte = _mm_maskz_set1_epi8((__mmask16)loud, BUSTER_NODE_TESTS_VALUE_LOUD);')
VALUE_BYTES = line(C, 'value_bytes = _mm_or_si128(_mm_or_si128(constant_byte, bit_field_byte), _mm_or_si128(declaration_byte, loud_byte));')
LINE_CALLEE = line(C, 'const uint8_t callee = calls ? node_census_declaration_facts(s, declaration, name, BUSTER_NODE_CENSUS_DECLARATION_CALLEE_KNOWN) : 0;')
LINE_LOUD = line(C, 'bits |= (callee & BUSTER_NODE_CENSUS_DECLARATION_CALLEE) != 0 ? BUSTER_NODE_TESTS_LINE_LOUD : 0;')
fault('b-switch-always', C, SWITCH, '!policy->type_safety', 'true')
fault('b-switch-never', C, SWITCH, '!policy->type_safety', 'false')
fault('b-switch-inverted', C, SWITCH, '!policy->type_safety', 'policy->type_safety')
fault('b-void-never', C, NOVALUE, '_mm_maskz_set1_epi8(no_value, BUSTER_NODE_TESTS_TYPE_VOID)', '_mm_maskz_set1_epi8((__mmask16)(no_value & 0), BUSTER_NODE_TESTS_TYPE_VOID)')
fault('b-void-kind', C, NOVALUE_KIND, 'BUSTER_TYPE_KIND_VOID', 'BUSTER_TYPE_KIND_INTEGER')
fault('b-void-bit', C, NOVALUE, 'BUSTER_NODE_TESTS_TYPE_VOID', 'BUSTER_NODE_TESTS_TYPE_QUIET')
fault('b-quiet-value', C, QCALL, '(uint32_t)BUSTER_NODE_FACTS_QUIET_CALL << 16', '(uint32_t)BUSTER_NODE_FACTS_QUIET_CALL << 17')
fault('b-quiet-never', C, QCALL_BYTE, '_mm_maskz_set1_epi8(quiet_call, BUSTER_NODE_TESTS_TYPE_QUIET)', '_mm_maskz_set1_epi8((__mmask16)(quiet_call & 0), BUSTER_NODE_TESTS_TYPE_QUIET)')
fault('b-quiet-bit', C, QCALL_BYTE, 'BUSTER_NODE_TESTS_TYPE_QUIET', 'BUSTER_NODE_TESTS_TYPE_VOID')
fault('b-quiet-always', C, QCALL_BYTE, '_mm_maskz_set1_epi8(quiet_call, BUSTER_NODE_TESTS_TYPE_QUIET)', '_mm_maskz_set1_epi8((__mmask16)(quiet_call | 0xffff), BUSTER_NODE_TESTS_TYPE_QUIET)')
fault('b-line-calls-never', C, LINE_MADE, 'front->tokens[r], calls)', 'front->tokens[r], calls && false)')
fault('b-line-calls-row', C, CALLS_LINE, 'BUSTER_NODE_FACTS_FUNCTION) != 0', 'BUSTER_NODE_FACTS_DESIGNATOR) != 0')
fault('b-line-callee-never', C, LINE_CALLEE, 'calls ? node_census_declaration_facts(s, declaration, name, BUSTER_NODE_CENSUS_DECLARATION_CALLEE_KNOWN) : 0', '0')
fault('b-line-loud-never', C, LINE_LOUD, '? BUSTER_NODE_TESTS_LINE_LOUD : 0', '? 0 : 0')
fault('b-line-loud-always', C, LINE_LOUD, '(callee & BUSTER_NODE_CENSUS_DECLARATION_CALLEE) != 0 ?', '(callee & BUSTER_NODE_CENSUS_DECLARATION_CALLEE) != 0 || true ?')
fault('b-loud-mask', C, LOUD_MASK, 'BUSTER_NODE_TESTS_LINE_LOUD', 'BUSTER_NODE_TESTS_LINE_RESULT')
fault('b-loud-byte-never', C, VALUE_BYTES, '_mm_or_si128(declaration_byte, loud_byte)', '_mm_or_si128(declaration_byte, _mm_and_si128(loud_byte, _mm_setzero_si128()))')
fault('b-loud-byte-bit', C, LOUD_BYTE, 'BUSTER_NODE_TESTS_VALUE_LOUD', 'BUSTER_NODE_TESTS_VALUE_DECLARATION')
fault('b-loud-no-line', C, LOUD_MASK, ' | stray;', ';')

# The tests: the loop's rule.
RULE = line(C, 'const __mmask64 calls_rule = _cvtu64_mask64(s->own_calls_quiet ? UINT64_MAX : 0);')
CALLS = line(C, 'const __mmask64 calls = _mm512_cmpeq_epi8_mask(codes, _mm512_set1_epi8((char)CHECK_OP_CALL));')
QARGS = line(C, 'const __mmask64 quiet_arguments = _mm512_test_epi8_mask(own, _mm512_set1_epi8(BUSTER_NODE_TESTS_TYPE_QUIET));')
LCALLEE = line(C, 'const __mmask64 loud_callee = _mm512_test_epi8_mask(kind_left, _mm512_set1_epi8(BUSTER_NODE_TESTS_VALUE_LOUD));')
AGGS = line(C, 'const __mmask64 aggregates = _mm512_test_epi8_mask(own, _mm512_set1_epi8(BUSTER_NODE_CENSUS_TYPE_AGGREGATE));')
QCALLS = line(C, 'const __mmask64 quiet_calls = calls_rule & calls & near_left & quiet_arguments & ~loud_callee & ~aggregates & ~_mm512_test_epi8_mask(sends, operands);')
CASTS = line(C, 'const __mmask64 casts = _mm512_cmpeq_epi8_mask(codes, _mm512_set1_epi8((char)CHECK_OP_CAST));')
VOIDS = line(C, 'const __mmask64 voids = _mm512_test_epi8_mask(own, _mm512_set1_epi8(BUSTER_NODE_TESTS_TYPE_VOID));')
LEFTOUT = line(C, 'const __m512i left_out = _mm512_movm_epi8(quiet_calls);')
TOPLEFT = line(C, 'const __m512i top_left_out = node_tests_window_operands(at_left, near_left, previous_left_out, left_out);')
ASKS = line(C, 'const uint64_t asks = _cvtmask64_u64(casts & voids & _mm512_test_epi8_mask(top_left_out, top_left_out));')
FARCALL = line(C, 'const uint64_t far_call = r < count && (front->ops[operand] & 0x7f) == CHECK_OP_CALL ? 1 : 0;')
FARCLEAR = line(C, 'tests->window_masks[BUSTER_NODE_TESTS_MASKS * (uint64_t)(operand / 64) + BUSTER_NODE_TESTS_MASK_DISCARDS] &= ~(far_call << (operand & 63));')
NUMBERS = line(C, 'const __m512i numbers = _mm512_add_epi16(places, _mm512_set1_epi16((short)x));')
STORE_LOW = line(C, '_mm512_storeu_si512(tests->window_asks + ask_total, _mm512_maskz_compress_epi16((__mmask32)asks, numbers));')
COUNT_LOW = line(C, 'ask_total += (uint32_t)_mm_popcnt_u32((uint32_t)asks);')
STORE_HIGH = line(C, '_mm512_storeu_si512(tests->window_asks + ask_total, _mm512_maskz_compress_epi16((__mmask32)(asks >> 32), _mm512_add_epi16(numbers, _mm512_set1_epi16(32))));')
COUNT_HIGH = line(C, 'ask_total += (uint32_t)_mm_popcnt_u32((uint32_t)(asks >> 32));')
MQUIET = line(C, 'masks[BUSTER_NODE_TESTS_MASK_QUIET] = quiet | quiet_calls;')
MOPS = line(C, 'masks[BUSTER_NODE_TESTS_MASK_OPERATORS] = _mm512_test_epi8_mask(sent, sent) & ~quiet & ~quiet_calls;')
MDISC = line(C, 'masks[BUSTER_NODE_TESTS_MASK_DISCARDS] = writes | voids | quiet_calls;')
PREV = line(C, '        previous_left_out = left_out;')
TOTAL = line(C, 'call_total += (uint64_t)_mm_popcnt_u64(quiet_calls);')
ASKOUT = line(C, '    *ask_count = ask_total;')
fault('l-rule-always', C, RULE, 's->own_calls_quiet ? UINT64_MAX : 0', 'UINT64_MAX')
fault('l-calls-op', C, CALLS, 'CHECK_OP_CALL', 'CHECK_OP_CAST')
fault('l-args-bit', C, QARGS, 'BUSTER_NODE_TESTS_TYPE_QUIET', 'BUSTER_NODE_TESTS_TYPE_VOID')
fault('l-callee-bit', C, LCALLEE, 'BUSTER_NODE_TESTS_VALUE_LOUD', 'BUSTER_NODE_TESTS_VALUE_BIT_FIELD')
fault('l-callee-right', C, LCALLEE, 'kind_left', 'kind_right')
fault('l-aggregate-bit', C, AGGS, 'BUSTER_NODE_CENSUS_TYPE_AGGREGATE', 'BUSTER_NODE_CENSUS_TYPE_ARRAY')
fault('l-no-rule', C, QCALLS, 'calls_rule & calls', '(calls_rule | ~calls_rule) & calls')
fault('l-no-calls', C, QCALLS, 'calls_rule & calls & ', 'calls_rule & (calls | ~calls) & ')
fault('l-no-near', C, QCALLS, ' & near_left', '')
fault('l-no-args', C, QCALLS, ' & quiet_arguments', ' & (quiet_arguments | ~quiet_arguments)')
fault('l-no-callee', C, QCALLS, ' & ~loud_callee', ' & ~(loud_callee & ~loud_callee)')
fault('l-no-aggregates', C, QCALLS, ' & ~aggregates', ' & ~(aggregates & ~aggregates)')
fault('l-no-sends', C, QCALLS, ' & ~_mm512_test_epi8_mask(sends, operands)', '')
fault('l-casts-op', C, CASTS, 'CHECK_OP_CAST', 'CHECK_OP_CONVERT')
fault('l-voids-bit', C, VOIDS, 'BUSTER_NODE_TESTS_TYPE_VOID', 'BUSTER_NODE_TESTS_TYPE_QUIET')
fault('l-voids-never', C, VOIDS, '_mm512_set1_epi8(BUSTER_NODE_TESTS_TYPE_VOID)', '_mm512_setzero_si512()')
fault('l-top-right', C, TOPLEFT, 'at_left, near_left', 'at_right, near_right')
fault('l-top-previous-none', C, TOPLEFT, 'previous_left_out, left_out', '_mm512_and_si512(previous_left_out, _mm512_setzero_si512()), left_out')
fault('l-top-current-none', C, TOPLEFT, 'previous_left_out, left_out', 'previous_left_out, _mm512_setzero_si512()')
fault('l-previous-stale', C, PREV, 'previous_left_out = left_out;', '(void)left_out;')
fault('l-asks-no-voids', C, ASKS, 'casts & voids & ', 'casts & (voids | ~voids) & ')
fault('l-asks-no-near', C, ASKS, '_mm512_test_epi8_mask(top_left_out, top_left_out)', '(_mm512_test_epi8_mask(top_left_out, top_left_out) | ~_mm512_test_epi8_mask(top_left_out, top_left_out))')
fault('l-asks-none', C, ASKS, 'casts & voids & ', 'casts & voids & ~voids & ')
fault('l-asks-no-casts', C, ASKS, 'casts & voids & ', '(casts | ~casts) & voids & ')
fault('f-far-count', C, FARCALL, 'r < count && ', '')
fault('f-far-call', C, FARCALL, '(front->ops[operand] & 0x7f) == CHECK_OP_CALL', '(front->ops[operand] & 0x7f) != CHECK_OP_COUNT')
fault('f-far-never', C, FARCALL, '(front->ops[operand] & 0x7f) == CHECK_OP_CALL', '(front->ops[operand] & 0x7f) == CHECK_OP_COUNT')
fault('f-far-clear-lane', C, FARCLEAR, '(far_call << (operand & 63))', '(far_call << ((operand + 1) & 63))')
fault('f-far-clear-block', C, FARCLEAR, '(uint64_t)(operand / 64)', '(uint64_t)(r / 64)')
fault('f-far-clear-mask', C, FARCLEAR, 'BUSTER_NODE_TESTS_MASK_DISCARDS', 'BUSTER_NODE_TESTS_MASK_WRITES')
fault('l-numbers-base', C, NUMBERS, '_mm512_set1_epi16((short)x)', '_mm512_set1_epi16((short)(x & 63))')
fault('l-low-none', C, STORE_LOW, '(__mmask32)asks, numbers', '(__mmask32)0, numbers')
fault('l-low-count', C, COUNT_LOW, '_mm_popcnt_u32((uint32_t)asks)', '_mm_popcnt_u32((uint32_t)asks & 0)')
fault('l-high-none', C, STORE_HIGH, '(__mmask32)(asks >> 32), _mm512_add_epi16', '(__mmask32)0, _mm512_add_epi16')
fault('l-high-base', C, STORE_HIGH, '_mm512_set1_epi16(32)', '_mm512_set1_epi16(31)')
fault('l-high-count', C, COUNT_HIGH, '_mm_popcnt_u32((uint32_t)(asks >> 32))', '_mm_popcnt_u32((uint32_t)(asks >> 33))')
fault('l-mask-quiet', C, MQUIET, 'quiet | quiet_calls', 'quiet')
fault('l-mask-operators', C, MOPS, ' & ~quiet_calls', '')
fault('l-mask-discards-writes', C, MDISC, 'writes | voids | quiet_calls', 'voids | quiet_calls')
fault('l-mask-discards-voids', C, MDISC, 'writes | voids | quiet_calls', 'writes | (voids & ~voids) | quiet_calls')
fault('l-mask-discards-calls', C, MDISC, 'writes | voids | quiet_calls', 'writes | voids')
fault('l-total', C, TOTAL, '_mm_popcnt_u64(quiet_calls)', '_mm_popcnt_u64(calls)')
fault('l-ask-count', C, ASKOUT, '*ask_count = ask_total;', '*ask_count = 0;')

# The tests: the asks.
A_CALL = line(C, 'const uint32_t call = cast - front->window_left[cast];')
A_CALLEE = line(C, 'const uint32_t callee = call - front->window_left[call];')
A_NAMED = line(C, 'const uint32_t named = front->window_kinds[callee] == BUSTER_NODE_FACTS_IDENTIFIER;')
A_LINE = line(C, 'const uint8_t line = tests->line_bytes[front->window_entries[callee] & (0u - named)];')
A_RESULT = line(C, 'uint32_t result = named != 0 ? line : BUSTER_NODE_TESTS_LINE_RESULT_KNOWN;')
A_ASK = line(C, 'if (__builtin_expect((result & BUSTER_NODE_TESTS_LINE_RESULT_KNOWN) == 0, 0))')
A_WANTS = line(C, '            result = node_tests_window_wants(tests, front, callee);')
A_MADE = line(C, '            made += 1;')
A_KEEP = line(C, 'if (__builtin_expect((result & BUSTER_NODE_TESTS_LINE_RESULT) != 0, 0))')
A_CLEAR = line(C, 'tests->window_masks[BUSTER_NODE_TESTS_MASKS * (uint64_t)(call / 64) + BUSTER_NODE_TESTS_MASK_DISCARDS] &= ~(UINT64_C(1) << (call & 63));')
A_LOOP = line(C, 'for (uint32_t i = 0; i < ask_count; i += 1)')
fault('a-call-self', C, A_CALL, 'cast - front->window_left[cast]', 'cast - 1')
fault('a-callee-self', C, A_CALLEE, 'call - front->window_left[call]', 'call - 1')
fault('a-named-never', C, A_NAMED, 'front->window_kinds[callee] == BUSTER_NODE_FACTS_IDENTIFIER', 'front->window_kinds[callee] == 0xffu')
fault('a-line-first', C, A_LINE, 'front->window_entries[callee] & (0u - named)', '0')
fault('a-result-other-wants', C, A_RESULT, 'named != 0 ? line : BUSTER_NODE_TESTS_LINE_RESULT_KNOWN', 'named != 0 ? line : BUSTER_NODE_TESTS_LINE_RESULT_KNOWN | BUSTER_NODE_TESTS_LINE_RESULT')
fault('a-ask-always', C, A_ASK, '(result & BUSTER_NODE_TESTS_LINE_RESULT_KNOWN) == 0, 0', '(named != 0) | ((result & BUSTER_NODE_TESTS_LINE_RESULT_KNOWN) == 0), 0')
fault('a-ask-never', C, A_ASK, '(result & BUSTER_NODE_TESTS_LINE_RESULT_KNOWN) == 0, 0', '(result & BUSTER_NODE_TESTS_LINE_RESULT_KNOWN) == 0xff, 0')
fault('a-wants-callee', C, A_WANTS, 'node_tests_window_wants(tests, front, callee)', 'node_tests_window_wants(tests, front, call)')
fault('a-made', C, A_MADE, 'made += 1;', 'made += 2;')
fault('a-keep-never', C, A_KEEP, '(result & BUSTER_NODE_TESTS_LINE_RESULT) != 0, 0', '(result & BUSTER_NODE_TESTS_LINE_RESULT) == 0xff, 0')
fault('a-keep-bit', C, A_KEEP, '(result & BUSTER_NODE_TESTS_LINE_RESULT) != 0, 0', '(result & BUSTER_NODE_TESTS_LINE_RESULT_KNOWN) != 0, 0')
fault('a-clear-lane', C, A_CLEAR, '(UINT64_C(1) << (call & 63))', '(UINT64_C(1) << ((call + 1) & 63))')
fault('a-clear-none', C, A_CLEAR, '&= ~(UINT64_C(1) << (call & 63));', '&= UINT64_MAX | (call & 63);')
fault('a-clear-block', C, A_CLEAR, '(uint64_t)(call / 64)', '(uint64_t)(cast / 64)')
fault('a-loop-first', C, A_LOOP, 'i < ask_count', 'i < ask_count && i < 1')
fault('a-loop-skip', C, A_LOOP, 'uint32_t i = 0;', 'uint32_t i = 1;')

# The tests: the declaration's fact.
W_RESULT = line(C, 'const uint8_t bits = (uint8_t)(BUSTER_NODE_TESTS_LINE_RESULT_KNOWN | (result ? BUSTER_NODE_TESTS_LINE_RESULT : 0));')
W_KEEP = line(C, '    tests->line_bytes[front->window_entries[callee]] |= bits;')
W_NONE = line(C, 'const bool result = declaration != BUSTER_CHECK_NONE &&', 0)
fault('w-result-never', C, W_RESULT, '(result ? BUSTER_NODE_TESTS_LINE_RESULT : 0)', '(result ? 0 : 0)')
fault('w-result-always', C, W_RESULT, '(result ? BUSTER_NODE_TESTS_LINE_RESULT : 0)', '(result || true ? BUSTER_NODE_TESTS_LINE_RESULT : 0)')
fault('w-known-never', C, W_RESULT, 'BUSTER_NODE_TESTS_LINE_RESULT_KNOWN | ', '')
fault('w-keep-none', C, W_KEEP, '|= bits;', '|= 0;')
fault('w-keep-known', C, W_KEEP, '|= bits;', '|= BUSTER_NODE_TESTS_LINE_RESULT_KNOWN;')
fault('w-keep-over', C, W_KEEP, '|= bits;', '= bits;')

# The tests: an expression's listing; the chunk's call of the asks.
DISCARDS = line(C, 'const uint32_t discards = (uint32_t)(tests->window_masks[BUSTER_NODE_TESTS_MASKS * (uint64_t)(operand / 64) + BUSTER_NODE_TESTS_MASK_DISCARDS] >> (operand & 63) & 1) ^ 1;')
LISTED = line(C, 'const uint32_t listed = (lists != 0) | !rooted | (unsequenced & (sequenced ^ 1)) | ((context == NODE_CENSUS_ROOT_STATEMENT) & discards) | addresses |')
CHUNK_ASKS = line(C, 'types->own_result_asks += node_tests_window_asks(tests, front, ask_count);')
CHUNK_CASTS = line(C, 'types->own_result_casts += ask_count;')
fault('e-discards-mask', C, DISCARDS, 'BUSTER_NODE_TESTS_MASK_DISCARDS', 'BUSTER_NODE_TESTS_MASK_WRITES')
fault('e-discards-quiet', C, DISCARDS, 'BUSTER_NODE_TESTS_MASK_DISCARDS', 'BUSTER_NODE_TESTS_MASK_QUIET')
fault('e-discards-block', C, DISCARDS, '(uint64_t)(operand / 64)', '(uint64_t)(record / 64)')
fault('e-discards-lane', C, DISCARDS, '>> (operand & 63) & 1', '>> (record & 63) & 1')
fault('e-discards-always', C, DISCARDS, ' & 1) ^ 1;', ' & 0) ^ 1;')
fault('e-discards-never', C, DISCARDS, ' & 1) ^ 1;', ' & 0);')
fault('e-listed-statement', C, LISTED, '((context == NODE_CENSUS_ROOT_STATEMENT) & discards)', '((context == NODE_CENSUS_ROOT_STATEMENT) & (discards | 1))')
fault('e-asks-none', C, CHUNK_ASKS, 'node_tests_window_asks(tests, front, ask_count)', 'node_tests_window_asks(tests, front, 0)')
fault('e-casts-count', C, CHUNK_CASTS, '+= ask_count;', '+= 0;')

# The verify: a call left out, by its own list.
V_SMALL = line(C, 'const bool small = kind == CHECK_CONSTANT_INTEGER && columns->payloads[argument] <= 126;')
V_LOUD2 = line(C, 'loud = loud || (kind != CHECK_CONSTANT_NONE && kind != CHECK_CONSTANT_ADDRESS && !small);')
V_CHECKED = line(C, 'counts->own_quiet_calls_checked += call;')
fault('v-small-126', C, V_SMALL, '<= 126', '<= 125')
fault('v-constant-none', C, V_LOUD2, 'kind != CHECK_CONSTANT_NONE && ', '')
fault('v-constant-address', C, V_LOUD2, ' && kind != CHECK_CONSTANT_ADDRESS', '')
fault('v-constant-small', C, V_LOUD2, ' && !small', ' && !(small && false)')
fault('v-checked', C, V_CHECKED, '+= call;', '+= 0;')

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
    results = open(ROOT + '/%s-results-%d.txt' % (ROUND, SHARD), 'a')
    for place, (name, f, old, new) in enumerate(MUTANTS):
        if (only and name not in only) or place % SHARDS != SHARD:
            continue
        path = SRC + f
        saved = ROOT + '/saved%d.c' % SHARD
        shutil.copyfile(path, saved)
        s = read(path)
        open(path, 'w').write(s.replace(old, new))
        start = time.time()
        build = subprocess.run(['./build.sh', '--config', 'Debug', '--jobs', '1'], cwd=TREE, capture_output=True, text=True)
        built = build.returncode == 0
        verdict = 'NOT BUILT'
        detail = ''
        if built:
            try:
                test = subprocess.run(['./build/compiler', 'test-checker', '--seed', '133', '--part', '5/8'], cwd=TREE, capture_output=True, text=True, timeout=900)
                failed = test.returncode != 0
                lines = [l for l in (test.stderr + test.stdout).splitlines() if 'test-checker' in l and 'retained' not in l]
                detail = ' | '.join(l[:150] for l in lines[:2]) + ' [status %d]' % test.returncode
                verdict = 'caught' if failed else 'SURVIVED'
            except subprocess.TimeoutExpired:
                verdict = 'caught (timeout)'
        else:
            detail = (build.stderr + build.stdout)[-300:].replace('\n', ' ')
        shutil.copyfile(saved, path)
        line_ = f'{name}: {verdict} ({time.time() - start:.0f} s) {detail}'
        print(line_, flush=True)
        results.write(line_ + '\n'); results.flush()
    subprocess.run(['./build.sh', '--config', 'Debug', '--jobs', '2'], cwd=TREE, capture_output=True, text=True)
    print('campaign done', flush=True)

if __name__ == '__main__':
    if len(sys.argv) > 1 and sys.argv[1] == 'check':
        sys.exit(0 if check() else 1)
    run(sys.argv[2:])
