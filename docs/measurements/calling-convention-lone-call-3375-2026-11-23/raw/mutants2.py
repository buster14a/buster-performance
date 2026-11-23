#!/usr/bin/env python3
# #3375's mutation round: mutants.py ORIGINAL OUTPUT N writes mutant N of the per-call kernel (or lists them with
# --list). Each mutant replaces one text, which must occur once.
import sys

M = [
    ("two_vectors_free threshold", "_mm512_set1_epi32(BUSTER_ABI_VECTOR_ARGUMENTS - 1));", "_mm512_set1_epi32(BUSTER_ABI_VECTOR_ARGUMENTS));"),
    ("in_register with EMPTY", "result.in_register = result.integer & arguments->integer_register & integers_free;", "result.in_register = result.integer & integers_free;"),
    ("unnamed from the next", "_mm512_cmpge_epu32_mask(_mm512_add_epi32(lanes,", "_mm512_cmpgt_epu32_mask(_mm512_add_epi32(lanes,"),
    ("union's alignment below 8", "_mm512_max_epu32(own_alignment, slot_log2)", "own_alignment"),
    ("high vector after a low vector (second_vector)", "const __m512i second_vector = _mm512_or_si512(_mm512_add_epi32(vectors, one), vector_register);", "const __m512i second_vector = _mm512_or_si512(vectors, vector_register);"),
    ("FIRST in its own slot (own_slot never)", "const __mmask16 own_slot = decision.memory & (__mmask16)~decision.integer;", "const __mmask16 own_slot = decision.memory & (__mmask16)~decision.integer & 0;"),
    ("integer LOW at 8 bytes", "decision.integer & (__mmask16)~decision.in_register & _mm512_cmpgt_epu32_mask(own_bytes, slot_bytes);", "decision.integer & (__mmask16)~decision.in_register & _mm512_cmpge_epu32_mask(own_bytes, slot_bytes);"),
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
