import sys
MUTANTS = {
 "m1-outside-dominance": ("dominators_dominates(loops, work->destination[operand], preheader));",
                          "dominators_dominates(loops, work->destination[operand], work->destination[operand]));"),
 "m2-inside-epoch": ("(inside ? work->available[operand] == epoch && work->candidate[operand] != 0 :",
                     "(inside ? work->candidate[operand] != 0 :"),
 "m3-walk-reverse": ("""        end = member ? r + 1 : end;
        for (uint32_t i = f->block_offsets[block]; member && i < f->block_offsets[(uint64_t)block + 1]; i += 1)""",
                     """        end = member ? r + 1 : end;
        for (uint32_t k = f->block_offsets[block], i = f->block_offsets[(uint64_t)block + 1] - 1; member && k < f->block_offsets[(uint64_t)block + 1]; k += 1, i -= 1)"""),
 "m5-taint-ignored": ("& _mm_cmpeq_epi8_mask(tainted, _mm_setzero_si128());",
                      "& _mm_cmpge_epu8_mask(tainted, _mm_setzero_si128());"),
 "m6-larger-loops-first": ("work->loops.loop_size[order[at - 1]] > work->loops.loop_size[loop]",
                           "work->loops.loop_size[order[at - 1]] < work->loops.loop_size[loop]"),
 "m7-vector-operands-stay": ("                        work->candidate[operands[k]] = 2;",
                             "                        work->candidate[operands[k]] = 1;"),
 "m9-c-load-unmasked": ("_mm512_maskz_loadu_epi32(valid, f->c + first);",
                        "_mm512_maskz_loadu_epi32(0xffff, f->c + first);"),
 "m10-free-store-unmasked": ("_mm_mask_storeu_epi8(work->free_kinds + first, valid, free_kinds);",
                             "_mm_mask_storeu_epi8(work->free_kinds + first, 0xffff, free_kinds);"),
}
name, path = sys.argv[1], sys.argv[2]
if name == "list":
    print("\n".join(MUTANTS))
    sys.exit(0)
old, new = MUTANTS[name]
s = open(path).read()
if s.count(old) != 1:
    print("not-applied", s.count(old)); sys.exit(3)
open(path, "w").write(s.replace(old, new))
