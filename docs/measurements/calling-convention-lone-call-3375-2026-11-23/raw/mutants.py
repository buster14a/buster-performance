#!/usr/bin/env python3
# #3375's mutation round: mutants.py ORIGINAL OUTPUT N writes mutant N of the per-call kernel (or lists them with
# --list). Each mutant replaces one text, which must occur once.
import sys

M = [
    ("pair_free threshold", "const __mmask16 pair_free = _mm512_cmplt_epu32_mask(integers, _mm512_set1_epi32(BUSTER_ABI_INTEGER_ARGUMENTS - 1));", "const __mmask16 pair_free = _mm512_cmplt_epu32_mask(integers, _mm512_set1_epi32(BUSTER_ABI_INTEGER_ARGUMENTS));"),
    ("two_vectors_free threshold", "_mm512_set1_epi32(BUSTER_ABI_VECTOR_ARGUMENTS - 1));", "_mm512_set1_epi32(BUSTER_ABI_VECTOR_ARGUMENTS));"),
    ("clang short integers >=", "_mm512_cmpgt_epu32_mask(_mm512_add_epi32(clang_integers, arguments->need_integers)", "_mm512_cmpge_epu32_mask(_mm512_add_epi32(clang_integers, arguments->need_integers)"),
    ("clang short vectors >=", "_mm512_cmpgt_epu32_mask(_mm512_add_epi32(clang_vectors, arguments->need_vectors)", "_mm512_cmpge_epu32_mask(_mm512_add_epi32(clang_vectors, arguments->need_vectors)"),
    ("clang none >", "const __mmask16 clang_none = _mm512_cmpge_epu32_mask(clang_integers,", "const __mmask16 clang_none = _mm512_cmpgt_epu32_mask(clang_integers,"),
    ("late vector without LLVM's register", "result.late_vector = arguments->late_vector & clang_short_vectors & vectors_free;", "result.late_vector = arguments->late_vector & clang_short_vectors;"),
    ("late general without clang none", "result.late_general = arguments->late_general & clang_none & integers_free;", "result.late_general = arguments->late_general & integers_free;"),
    ("memory without short vectors", "(arguments->in_memory | clang_short_integers | clang_short_vectors)", "(arguments->in_memory | clang_short_integers)"),
    ("in_register with EMPTY", "result.in_register = result.integer & arguments->integer_register & integers_free;", "result.in_register = result.integer & integers_free;"),
    ("in_pair without pair_free", "result.in_pair = result.whole & (__mmask16)~result.in_vector & arguments->pair & pair_free;", "result.in_pair = result.whole & (__mmask16)~result.in_vector & arguments->pair & integers_free;"),
    ("high general after low general", "((arguments->low_general & pair_free) | ((__mmask16)~arguments->low_general & integers_free))", "((arguments->low_general & integers_free) | ((__mmask16)~arguments->low_general & integers_free))"),
    ("second integer without high", "result.value_pair | result.value_high | result.in_pair | result.high_in_general;", "result.value_pair | result.value_high | result.in_pair;"),
    ("first vector without low", "result.value_vector | result.late_vector | result.in_vector | result.low_in_vector;", "result.value_vector | result.late_vector | result.in_vector;"),
    ("no high vector count", "result.delta = _mm512_mask_add_epi32(delta, result.high_in_vector, delta,", "result.delta = _mm512_mask_add_epi32(delta, 0, delta,"),
    ("clang counts memory", "__m512i delta = _mm512_maskz_mov_epi32(taken, arguments->need);", "__m512i delta = _mm512_maskz_mov_epi32(rest, arguments->need);"),
    ("sum without its 8-lane step", "    result = _mm512_add_epi32(result, _mm512_alignr_epi32(result, zero, 8));\n    return _mm512_add_epi32(result, carry);", "    return _mm512_add_epi32(result, carry);"),
    ("sum64 without its 4-lane step", "    result = _mm512_add_epi64(result, _mm512_alignr_epi64(result, zero, 4));\n    return _mm512_add_epi64(result, carry);", "    return _mm512_add_epi64(result, carry);"),
    ("low padding wrong", "const __m512i low_padding = _mm512_and_si512(_mm512_sub_epi64(_mm512_setzero_si512(), low_offsets), low_below);", "const __m512i low_padding = _mm512_and_si512(low_offsets, low_below);"),
    ("high padding wrong", "const __m512i high_padding = _mm512_and_si512(_mm512_sub_epi64(_mm512_setzero_si512(), high_offsets), high_below);", "const __m512i high_padding = _mm512_and_si512(high_offsets, high_below);"),
    ("area not raised", "*area = largest > *area ? largest : *area;", "*area = largest > *area ? *area : *area;"),
    ("counts carry without the last lane", "_mm512_permutexvar_epi32(_mm512_set1_epi32(BUSTER_ABI_LANES - 1), _mm512_add_epi32(before, delta))", "_mm512_permutexvar_epi32(_mm512_set1_epi32(BUSTER_ABI_LANES - 1), before)"),
    ("stack carry without the last slot", "_mm512_add_epi64(high_offsets, high_bytes)", "high_offsets"),
    ("high general after a low vector", "decision.high_in_general & low & (__mmask16)~decision.low_in_general, first_general);", "decision.high_in_general & low & (__mmask16)~decision.low_in_general, second_general);"),
    ("high vector after a low vector", "decision.high_in_vector & low & decision.low_in_vector, second_vector);", "decision.high_in_vector & low & decision.low_in_vector, first_vector);"),
    ("halves value slot 8", "_mm512_mask_mov_epi32(slot_bytes, (__mmask16)~decision.value_low, _mm512_set1_epi32(2 * BUSTER_ABI_SLOT_BYTES))", "_mm512_mask_mov_epi32(slot_bytes, (__mmask16)~decision.value_low, slot_bytes)"),
    ("pair slot aligned to 8", "_mm512_max_epu32(alignment_log2, _mm512_set1_epi32(4))", "_mm512_max_epu32(alignment_log2, _mm512_set1_epi32(3))"),
    ("vector slot 32 for 16", "within_16, _mm512_set1_epi32(4));", "within_16, _mm512_set1_epi32(5));"),
    ("payload held below 16", "_mm512_cmpge_epu32_mask(part_bytes, _mm512_set1_epi32(BUSTER_ABI_REGISTER_BYTES));", "(__mmask16)0xffff;"),
    ("integer's slot its bytes", "transparent, own_bytes), decision.integer, slot_bytes);", "transparent, own_bytes), decision.integer, bytes);"),
    ("FIRST in its own slot", "transparent & (in_registers | placed) & (__mmask16)~own_slot &", "transparent & (in_registers | placed) &"),
    ("halves LOW in registers", "halves & (__mmask16)~high & stacked &", "halves & (__mmask16)~high &"),
    ("integer LOW not a union", "decision.integer & (__mmask16)~decision.in_register & transparent &", "decision.integer & (__mmask16)~decision.in_register &"),
    ("unnamed from the next", "_mm512_cmpge_epu32_mask(_mm512_add_epi32(lanes,", "_mm512_cmpgt_epu32_mask(_mm512_add_epi32(lanes,"),
    ("uncounted vector small swapped", "(variadic ? small : (__mmask16)0xffff)", "(!variadic ? small : (__mmask16)0xffff)"),
    ("wide vector in a variadic call's register", "arguments.whole_vector = vector & (__mmask16)~wide_variadic;", "arguments.whole_vector = vector;"),
    ("union's alignment below 8", "_mm512_max_epu32(own_alignment, slot_log2)", "own_alignment"),
    ("demoted counted", "(hidden && !demoted ? BUSTER_ABI_LANES_CLANG_INTEGER : 0)", "(hidden && demoted ? BUSTER_ABI_LANES_CLANG_INTEGER : 0)"),
    ("member's pass not gathered", "pass = _mm512_mask_i32gather_epi32(pass, transparent, member, abi->pass, 4);", "pass = _mm512_mask_i32gather_epi32(pass, transparent, own, abi->pass, 4);"),
    ("member's bytes not gathered", "bytes = _mm512_mask_i32gather_epi32(bytes, transparent, member, abi->stack_bytes, 4);", "bytes = _mm512_mask_i32gather_epi32(bytes, transparent, own, abi->stack_bytes, 4);"),
    ("halves value never split", "const __mmask16 split = (decision.value_low & (__mmask16)~decision.value_high) | ", "const __mmask16 split = "),
    ("eightbytes all stacked", "const __mmask16 all_stacked = (low_out | (__mmask16)~low) & (high_out | (__mmask16)~high);", "const __mmask16 all_stacked = low_out & high_out & (low | high);"),
    ("HIGH by the high", "flags = _mm512_mask_or_epi32(flags, halves & (__mmask16)~low, flags,", "flags = _mm512_mask_or_epi32(flags, halves & (__mmask16)~high, flags,"),
    ("PAYLOAD at the payload's size", "vector_stack & _mm512_cmplt_epu32_mask(payload, bytes)", "vector_stack & _mm512_cmple_epu32_mask(payload, bytes)"),
    ("value high in the last register", "result.value_high = arguments->value_halves & pair_free;", "result.value_high = arguments->value_halves & integers_free;"),
    ("in_vector any vector", "result.in_vector = result.whole & arguments->whole_vector & vectors_free;", "result.in_vector = result.whole & arguments->wholes & vectors_free;"),
    ("low vector without a free one", "result.low_in_vector = result.halves & arguments->low_vector & vectors_free;", "result.low_in_vector = result.halves & arguments->low_vector;"),
    ("halves slot without the high", "_mm512_add_epi32(_mm512_maskz_mov_epi32(low_out, slot_bytes), _mm512_maskz_mov_epi32(high_out, slot_bytes))", "_mm512_maskz_mov_epi32(low_out | high_out, slot_bytes)"),
    ("value slot's alignment its own", "__m512i log2 = _mm512_mask_mov_epi32(alignment_log2, value_out | halves, slot_log2);", "__m512i log2 = _mm512_mask_mov_epi32(alignment_log2, halves, slot_log2);"),
    ("pair stack not placed", "const __mmask16 placed = value_stack | value_out | memory_stacked | pair_stack | vector_stack | (halves & stacked);", "const __mmask16 placed = value_stack | value_out | memory_stacked | vector_stack | (halves & stacked);"),
    ("hidden pointer not LLVM's", "uint32_t counts = (hidden ? BUSTER_ABI_LANES_ONE : 0) |", "uint32_t counts = (hidden ? 0 : 0) |"),
    ("late general any class", "arguments.late_general = counted & (__mmask16)~in_memory & (__mmask16)~(aggregate | pair) & no_vectors &", "arguments.late_general = counted & (__mmask16)~in_memory & (__mmask16)~(aggregate | pair) &"),
    ("late vector of an aggregate", "arguments.late_vector = counted & (__mmask16)~in_memory & (__mmask16)~aggregate & no_integers &", "arguments.late_vector = counted & (__mmask16)~in_memory & no_integers &"),
    ("word of any alignment", "_mm512_cmpeq_epi32_mask(indirect_bytes, slot_bytes) & _mm512_cmpeq_epi32_mask(place_log2, slot_log2);", "_mm512_cmpeq_epi32_mask(indirect_bytes, slot_bytes) & _mm512_cmple_epu32_mask(place_log2, slot_log2);"),
    ("grown union", "arguments.integer = (BUSTER_ABI_LANES_TEST(pass, BUSTER_ABI_PASS_GROWN) & (__mmask16)~transparent) | word;", "arguments.integer = BUSTER_ABI_LANES_TEST(pass, BUSTER_ABI_PASS_GROWN) | word;"),
]

if sys.argv[1] == "--list":
    for i, m in enumerate(M):
        print(i, m[0])
else:
    original, output, n = sys.argv[1], sys.argv[2], int(sys.argv[3])
    s = open(original).read()
    name, old, new = M[n]
    assert s.count(old) == 1, (n, name, s.count(old))
    open(output, "w").write(s.replace(old, new))
