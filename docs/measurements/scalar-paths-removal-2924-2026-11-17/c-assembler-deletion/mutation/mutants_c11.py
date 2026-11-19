# #2924 C11a: mutants of the assembler's vector paths that lose their scalar twins, each (name, file, old, new).
A = 'src/buster/compiler/assembler.c'
W = 'src/buster/compiler/assembler_words.c'
M = 'src/buster/compiler/x86_match.c'
MUTANTS = [
    ('l1-lex-letters', A, "\n        uint64_t word = _mm512_cmple_epu8_mask(_mm512_sub_epi8(lower, _mm512_set1_epi8('a')), _mm512_set1_epi8(25));",
                          "\n        uint64_t word = _mm512_cmple_epu8_mask(_mm512_sub_epi8(lower, _mm512_set1_epi8('a')), _mm512_set1_epi8(24));"),
    ('l2-lex-semicolon', A, "| _mm512_cmpeq_epi8_mask(bytes, _mm512_set1_epi8(';'));", "| 0;"),
    ('l3-lex-boundary', A, "at + n < length && asm_word_byte(source[at + n]))", "at + n < length)"),
    ('l4-lex-space', A, "_mm512_set1_epi8('\\t')), _mm512_set1_epi8(4));", "_mm512_set1_epi8('\\t')), _mm512_set1_epi8(3));"),
    ('l5-lex-capacity', A, "valid & 0x4444", "valid & 0x2222"),
    ('b1-batch-octal', A, "decimal &= ~(_mm512_cmpgt_epi64_mask(sizes, _mm512_set1_epi64(1))", "decimal &= ~(_mm512_cmpgt_epi64_mask(sizes, _mm512_set1_epi64(8))"),
    ('b2-batch-negative', A, "negative[word] ? -(__int128)values[word] : values[word]", "negative[word] ? (__int128)values[word] : values[word]"),
    ('b3-batch-rip', A, "descriptions = _mm512_maskz_mov_epi64(_mm512_cmpneq_epi64_mask(classes, class_mask), descriptions);", "descriptions = _mm512_maskz_mov_epi64(_mm512_cmpneq_epi64_mask(classes, _mm512_set1_epi64(254u << 16)), descriptions);"),
    ('b4-batch-xchg', A, '{ "sal", "xchg", "shl"', '{ "sal", "shl"'),
    ('r1-words-vector-limit', W, "vector_name, _mm512_set1_epi64(32)), opmask", "vector_name, _mm512_set1_epi64(16)), opmask"),
    ('r2-words-mmx', W, "_mm512_cmple_epu64_mask(mmx_number, _mm512_set1_epi64(7));", "_mm512_cmple_epu64_mask(mmx_number, _mm512_set1_epi64(6));"),
    ('m1-match-broadcast', M, "    mask &= _mm512_mask_cmpeq_epi32_mask(valid, _mm512_maskz_loadu_epi32(valid, index->broadcast + first), _mm512_set1_epi32(request->broadcast));\n", "\n"),
    ('m2-match-accumulator', M, "value->class <= BUSTER_X86_CLASS_GPR64 ? 65535u : 0", "65535u"),
    ('m3-match-displacement', M, "(value->value < INT32_MIN || value->value > INT32_MAX))", "(value->value < INT32_MIN || value->value > UINT32_MAX))"),
    ('m4-match-symbolic-immediate', M, "_mm512_cmpge_epu64_mask(high, _mm512_set1_epi64(INT32_MAX))", "_mm512_cmpge_epu64_mask(high, _mm512_set1_epi64(INT16_MAX))"),
    ('m5-match-one', M, "value->value == 1 ? one", "value->value == 2 ? one"),
    ('m6-match-segment', M, "(uint16_t)(instruction->form + operand->segment * X86_FORM_COUNT) : 0;", "(uint16_t)(instruction->form) : 0;"),
    ('m7-match-vvvv', M, "            instruction->vvvv = operand->reg;", "            instruction->vvvv = operand->reg ^ 1;"),
]
