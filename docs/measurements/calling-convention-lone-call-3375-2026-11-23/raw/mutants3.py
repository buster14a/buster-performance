#!/usr/bin/env python3
# #3375's mutation round: mutants.py ORIGINAL OUTPUT N writes mutant N of the per-call kernel (or lists them with
# --list). Each mutant replaces one text, which must occur once.
import sys

M = [
    ("union's alignment below 8", "_mm512_max_epu32(own_alignment, slot_log2)", "own_alignment"),
    ("FIRST in its own slot (own_slot never)", "const __mmask16 own_slot = decision.memory & (__mmask16)~decision.integer;", "const __mmask16 own_slot = decision.memory & (__mmask16)~decision.integer & 0;"),
    ("integer LOW at 8 bytes", "decision.integer & (__mmask16)~decision.in_register & _mm512_cmpgt_epu32_mask(own_bytes, slot_bytes);", "decision.integer & (__mmask16)~decision.in_register & _mm512_cmpge_epu32_mask(own_bytes, slot_bytes);"),
    ("grown union", "arguments.integer = (BUSTER_ABI_LANES_TEST(pass, BUSTER_ABI_PASS_GROWN) & (__mmask16)~transparent) | word;", "arguments.integer = BUSTER_ABI_LANES_TEST(pass, BUSTER_ABI_PASS_GROWN) | word;"),
    ("late general any class", "(__mmask16)~(aggregate | pair) & no_vectors & _mm512_cmpeq_epi32_mask(need_integers, one);", "(__mmask16)~(aggregate | pair) & (__mmask16)(no_vectors | ~no_vectors) & _mm512_cmpeq_epi32_mask(need_integers, one);"),
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
