# #2924 C9f: mutants of value numbering with memory's vector phases, whose scalar twins C9f deletes, each (name, file,
# old, new): a unique text replaced by another unique one, every identifier kept.
M = 'src/buster/compiler/ir_optimize_memory.c'
MUTANTS = [
    # Classification: SCCP's constants, observable accesses as writes, the last lane's info; the follow operand of an
    # addition whose constant comes first, and inttoptr's source type.
    ('c1-classify-constant', M, 'const __mmask16 constant = i64 & _mm512_cmpeq_epi32_mask(state, _mm512_set1_epi32(IROPT_CONSTANT));', 'const __mmask16 constant = i64 & _mm512_cmpeq_epi32_mask(state, _mm512_set1_epi32(IROPT_CONSTANT)) & 0;'),
    ('c2-classify-observable', M, 'kind = _mm512_mask_mov_epi32(kind, observable, _mm512_set1_epi32(BUSTER_IR_MEMORY_WRITE));\n        kind = _mm512_mask_mov_epi32(kind, (through', 'kind = _mm512_mask_mov_epi32(kind, observable & 0, _mm512_set1_epi32(BUSTER_IR_MEMORY_WRITE));\n        kind = _mm512_mask_mov_epi32(kind, (through'),
    ('c3-classify-tail', M, '_mm512_mask_storeu_epi32(m->info + first, valid, info);', '_mm512_mask_storeu_epi32(m->info + first, valid & 0x7fff, info);'),
    ('c4-follow-constant-first', M, 'follow = _mm512_mask_mov_epi32(follow, add & ~b_constant & a_constant, b);', 'follow = _mm512_mask_mov_epi32(follow, add & ~b_constant & a_constant & 0, b);'),
    ('c5-follow-inttoptr', M, 'const __mmask16 source = ~inttoptr | _mm512_cmpeq_epi32_mask(a_type, _mm512_set1_epi32(IR_I64));', 'const __mmask16 source = ~inttoptr | _mm512_cmpeq_epi32_mask(a_type, _mm512_set1_epi32(IR_I32));'),
    # Derivation: one round of pointer jumping, the last lane's slot.
    ('d1-derive-one-round', M, 'changed = changed || moved != 0;', 'changed = changed && moved != 0;'),
    ('d2-derive-tail', M, '_mm512_mask_i32gather_epi32(_mm512_set1_epi32((int)BUSTER_IR_NONE), slot, start, f->a, 4)', '_mm512_mask_i32gather_epi32(_mm512_set1_epi32((int)BUSTER_IR_NONE), slot & 0x7fff, start, f->a, 4)'),
    # Escapes: the last lane's derived value.
    ('e1-escapes-tail', M, 'uint32_t derived = valid & _mm512_cmpneq_epi32_mask(', 'uint32_t derived = (valid & 0x7fff) & _mm512_cmpneq_epi32_mask('),
    # Events: a volatile slot's accesses, lifetime markers, the undo bound, the last lane's slot address.
    ('v1-events-volatile', M, 'const __mmask16 observable = slotted & _mm512_test_epi32_mask(flagged, flagged);', 'const __mmask16 observable = slotted & _mm512_test_epi32_mask(flagged, flagged) & 0;'),
    ('v2-events-lifetime', M, '_mm512_cmple_epu32_mask(kind, _mm512_set1_epi32(BUSTER_IR_MEMORY_LIFETIME));', '_mm512_cmple_epu32_mask(kind, _mm512_set1_epi32(BUSTER_IR_MEMORY_WRITE));'),
    ('v3-events-undo', M, 'm->undo_bound += (uint64_t)__builtin_popcount(event) + 2u * (uint64_t)__builtin_popcount(store);', 'm->undo_bound += (uint64_t)__builtin_popcount(event) + 1u * (uint64_t)__builtin_popcount(store);'),
    ('v4-events-slot-tail', M, 'uint32_t slots = valid & _mm512_cmpeq_epi32_mask(kind, _mm512_set1_epi32(BUSTER_IR_MEMORY_SLOT));', 'uint32_t slots = (valid & 0x7fff) & _mm512_cmpeq_epi32_mask(kind, _mm512_set1_epi32(BUSTER_IR_MEMORY_SLOT));'),
    # Hashes: a store's key type from its stored value, the last lane's hash.
    ('h1-hash-store-type', M, 'const __m256i typed = _mm256_mask_blend_epi32(store, access, stored);', 'const __m256i typed = _mm256_mask_blend_epi32(store & 0, access, stored);'),
    ('h2-hash-tail', M, '_mm512_mask_storeu_epi64(m->hashes + first, lanes, hash);', '_mm512_mask_storeu_epi64(m->hashes + first, lanes & 0x7f, hash);'),
]
