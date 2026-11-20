# make-faults.py: build faults-update.py, the update's rows' faults in the frozen code: each term of the updates'
# loop's bits and shapes, each of its stores, the list's sweep, the rows' write's new resolutions and marks, and each
# new row of the tables, changed alone.
tree = '/home/user/buster-x1'
ROWS = 'src/buster/compiler/c_check_node_machine_rows.c'
text = open(tree + '/' + ROWS).read()
out = []
def N(name, old, new, nth=None):
    n = text.count(old)
    assert (n == 1 if nth is None else n > nth), (name, n)
    assert name not in [f[0] for f in out], name
    assert old != new, name
    out.append((name, ROWS, old, new, nth))
# The updates' loop: an update's bits.
POSTFIX = "const uint32_t postfix = op - CHECK_OP_POST_INCREMENT <= (uint32_t)(CHECK_OP_POST_DECREMENT - CHECK_OP_POST_INCREMENT) ? 1u : 0u;"
N('loop-postfix-always', POSTFIX, "const uint32_t postfix = op - CHECK_OP_POST_INCREMENT <= (uint32_t)(CHECK_OP_POST_DECREMENT - CHECK_OP_POST_INCREMENT) ? 1u : 1u;")
N('loop-postfix-never', POSTFIX, "const uint32_t postfix = op - CHECK_OP_POST_INCREMENT <= (uint32_t)(CHECK_OP_POST_DECREMENT - CHECK_OP_POST_INCREMENT) ? 0u : 0u;")
N('loop-postfix-no-decrement', POSTFIX, "const uint32_t postfix = op - CHECK_OP_POST_INCREMENT <= (uint32_t)(CHECK_OP_POST_INCREMENT - CHECK_OP_POST_INCREMENT) ? 1u : 0u;")
N('loop-postfix-of-prefix', POSTFIX, "const uint32_t postfix = op - CHECK_OP_PRE_INCREMENT <= (uint32_t)(CHECK_OP_POST_DECREMENT - CHECK_OP_POST_INCREMENT) ? 1u : 0u;")
N('loop-postfix-with-add-assign', POSTFIX, "const uint32_t postfix = op - CHECK_OP_POST_INCREMENT <= (uint32_t)(CHECK_OP_ADD_ASSIGN - CHECK_OP_POST_INCREMENT) ? 1u : 0u;")
NAMED = "const uint32_t named = (front->ops[destination] & 0x7fu) == CHECK_OP_VALUE ? 1u : 0u;"
N('loop-named-always', NAMED, "const uint32_t named = (front->ops[destination] & 0x7fu) == CHECK_OP_VALUE ? 1u : 1u;")
N('loop-named-never', NAMED, "const uint32_t named = (front->ops[destination] & 0x7fu) == CHECK_OP_VALUE ? 0u : 0u;")
N('loop-named-of-the-update', NAMED, "const uint32_t named = (front->ops[x] & 0x7fu) == CHECK_OP_VALUE ? 1u : 0u;")
GLOBAL = "const uint32_t global = (state->window_c_flags[destination] & BUSTER_NODE_CONTEXTS_SYMBOL) != 0 ? 1u : 0u;"
N('loop-global-always', GLOBAL, "const uint32_t global = (state->window_c_flags[destination] & BUSTER_NODE_CONTEXTS_SYMBOL) != 0 ? 1u : 1u;")
N('loop-global-never', GLOBAL, "const uint32_t global = (state->window_c_flags[destination] & BUSTER_NODE_CONTEXTS_SYMBOL) != 0 ? 0u : 0u;")
N('loop-global-by-object', GLOBAL, "const uint32_t global = (state->window_c_flags[destination] & BUSTER_NODE_CONTEXTS_OBJECT) != 0 ? 1u : 0u;")
N('loop-global-of-the-update', GLOBAL, "const uint32_t global = (state->window_c_flags[x] & BUSTER_NODE_CONTEXTS_SYMBOL) != 0 ? 1u : 0u;")
POINTER = "const uint32_t pointer = (facts & BUSTER_CHECK_LOWER_TYPE_POINTER) != 0 ? 1u : 0u;"
N('loop-pointer-always', POINTER, "const uint32_t pointer = (facts & BUSTER_CHECK_LOWER_TYPE_POINTER) != 0 ? 1u : 1u;")
N('loop-pointer-never', POINTER, "const uint32_t pointer = (facts & BUSTER_CHECK_LOWER_TYPE_POINTER) != 0 ? 0u : 0u;")
N('loop-pointer-by-address', POINTER, "const uint32_t pointer = (facts & BUSTER_CHECK_LOWER_TYPE_ADDRESS) != 0 ? 1u : 0u;")
N('loop-facts-of-the-destination', "const uint32_t facts = state->window_c_facts[x];", "const uint32_t facts = state->window_c_facts[x] & ~(uint32_t)BUSTER_CHECK_LOWER_TYPE_POINTER;")
CALC = "const uint32_t calculated = node_machine_class(state->facts.machine, state->facts.records[x].converted[0]);"
N('loop-computation-second-operand', CALC, "const uint32_t calculated = node_machine_class(state->facts.machine, state->facts.records[x].converted[1]);")
N('loop-computation-own-type', CALC, "const uint32_t calculated = node_machine_class(state->facts.machine, state->facts.records[x].type);")
N('loop-computation-facts', CALC, "const uint32_t calculated = node_machine_facts(state->facts.machine, state->facts.records[x].converted[0]);")
N('loop-computation-of-the-destination', CALC, "const uint32_t calculated = node_machine_class(state->facts.machine, state->facts.records[destination].converted[0]);")
COMPUTED = "const uint32_t computed = calculated != stored ? 1u : 0u;"
N('loop-computed-always', COMPUTED, "const uint32_t computed = calculated != stored ? 1u : 1u;")
N('loop-computed-never', COMPUTED, "const uint32_t computed = calculated != stored ? 0u : 0u;")
TESTED = "const uint32_t tested = (facts & BUSTER_CHECK_LOWER_TYPE_BOOL) != 0 ? 1u : 0u;"
N('loop-tested-always', TESTED, "const uint32_t tested = (facts & BUSTER_CHECK_LOWER_TYPE_BOOL) != 0 ? 1u : 1u;")
N('loop-tested-never', TESTED, "const uint32_t tested = (facts & BUSTER_CHECK_LOWER_TYPE_BOOL) != 0 ? 0u : 0u;")
N('loop-tested-by-pointer', TESTED, "const uint32_t tested = (facts & BUSTER_CHECK_LOWER_TYPE_POINTER) != 0 ? 1u : 0u;")
OWN = "const uint32_t own = ((tables->updates[op] + computed) & (pointer - 1u)) | (tables->pointer_updates[op] & (0u - pointer));"
N('loop-own-no-convert-back', OWN, "const uint32_t own = ((tables->updates[op] + 0u * computed) & (pointer - 1u)) | (tables->pointer_updates[op] & (0u - pointer));")
N('loop-own-pointer-as-another', OWN, "const uint32_t own = ((tables->updates[op] + computed) & (pointer - 1u)) | ((tables->updates[op] + computed) & (0u - pointer));")
N('loop-own-another-as-pointer', OWN, "const uint32_t own = (tables->pointer_updates[op] & (pointer - 1u)) | (tables->pointer_updates[op] & (0u - pointer));")
N('loop-own-not-written', "state->window_x_owns[x] = (uint8_t)own;", "state->window_x_owns[x] = (uint8_t)(own & 0u);")
LEN = "state->window_x_lengths[x] = (uint8_t)(state->window_x_lengths[x] + tables->lengths[own]);"
N('loop-length-no-conversion', LEN, "state->window_x_lengths[x] = (uint8_t)((state->window_x_lengths[x] & 0u) + tables->lengths[own]);")
N('loop-length-not-written', LEN, "state->window_x_lengths[x] = (uint8_t)(state->window_x_lengths[x] + 0u * tables->lengths[own]);")
N('loop-length-one-less', LEN, "state->window_x_lengths[x] = (uint8_t)(state->window_x_lengths[x] + tables->lengths[own] - 1u);")
STORE = "state->window_x_bits[x] = (uint8_t)(BUSTER_TYPED_STORE + postfix + named * (BUSTER_TYPED_STORE_LOCAL - BUSTER_TYPED_STORE + 2u * global));"
N('loop-store-no-set', STORE, "state->window_x_bits[x] = (uint8_t)(BUSTER_TYPED_STORE + 0u * postfix + named * (BUSTER_TYPED_STORE_LOCAL - BUSTER_TYPED_STORE + 2u * global));")
N('loop-store-by-address', STORE, "state->window_x_bits[x] = (uint8_t)(BUSTER_TYPED_STORE + postfix + 0u * named * (BUSTER_TYPED_STORE_LOCAL - BUSTER_TYPED_STORE + 2u * global));")
N('loop-store-global-as-local', STORE, "state->window_x_bits[x] = (uint8_t)(BUSTER_TYPED_STORE + postfix + named * (BUSTER_TYPED_STORE_LOCAL - BUSTER_TYPED_STORE + 0u * global));")
N('loop-store-of-the-destination', STORE, "state->window_x_bits[destination] = (uint8_t)(BUSTER_TYPED_STORE + postfix + named * (BUSTER_TYPED_STORE_LOCAL - BUSTER_TYPED_STORE + 2u * global));")
N('loop-class-not-written', "state->window_x_operands[x] = (uint8_t)calculated;", "state->window_x_operands[x] = (uint8_t)(calculated & 0u);")
N('loop-class-stored', "state->window_x_operands[x] = (uint8_t)calculated;", "state->window_x_operands[x] = (uint8_t)stored;")
LISTED = "masks[BUSTER_NODE_ROWS_MASK_LISTED] |= (uint64_t)tested << (x & 63);"
N('loop-tested-not-listed', LISTED, "masks[BUSTER_NODE_ROWS_MASK_LISTED] |= (uint64_t)(tested & 0u) << (x & 63);")
N('loop-tested-listed-low-lanes', LISTED, "masks[BUSTER_NODE_ROWS_MASK_LISTED] |= (uint64_t)tested << (x & 31);")
N('loop-tested-listed-another-mask', LISTED, "masks[BUSTER_NODE_ROWS_MASK_REFUSED] |= (uint64_t)tested << (x & 63);")
N('loop-tested-first-block', "\n    uint64_t* masks = state->window_c_masks + BUSTER_NODE_CONTEXTS_MASKS * (uint64_t)(x / 64);", "\n    uint64_t* masks = state->window_c_masks + BUSTER_NODE_CONTEXTS_MASKS * (uint64_t)(x / 64 & 0u);")
# Its first row.
N('loop-entries-of-the-update', "const uint32_t entries = state->window_x_owns[destination];", "const uint32_t entries = state->window_x_owns[x];")
N('loop-by-name-never', "const uint32_t by_name = 0u - named;", "const uint32_t by_name = 0u - (named & 0u);")
N('loop-kept-never', "const uint32_t kept = 0u - postfix;", "const uint32_t kept = 0u - (postfix & 0u);")
N('loop-kept-always', "const uint32_t kept = 0u - postfix;", "const uint32_t kept = 0u - (postfix | 1u);")
PO = "const uint32_t pointed_own = (tables->kept_owns[computed][entries] & kept) | (entries & ~kept);"
N('loop-pointed-own-without-the-convert', PO, "const uint32_t pointed_own = (tables->kept_owns[0][entries] & kept) | (entries & ~kept);")
N('loop-pointed-own-with-the-convert', PO, "const uint32_t pointed_own = (tables->kept_owns[1][entries] & kept) | (entries & ~kept);")
N('loop-pointed-own-prefix-none', PO, "const uint32_t pointed_own = (tables->kept_owns[computed][entries] & kept) | (0u & ~kept);")
PC = "const uint32_t pointed_conversion = (tables->kept_conversions[computed][entries] & kept) | ((BUSTER_NODE_ROWS_FIRST_ADDRESS + computed) & ~kept);"
N('loop-pointed-conversion-without-the-convert', PC, "const uint32_t pointed_conversion = (tables->kept_conversions[0][entries] & kept) | ((BUSTER_NODE_ROWS_FIRST_ADDRESS + computed) & ~kept);")
N('loop-pointed-conversion-with-the-convert', PC, "const uint32_t pointed_conversion = (tables->kept_conversions[1][entries] & kept) | ((BUSTER_NODE_ROWS_FIRST_ADDRESS + computed) & ~kept);")
N('loop-address-no-convert', PC, "const uint32_t pointed_conversion = (tables->kept_conversions[computed][entries] & kept) | ((BUSTER_NODE_ROWS_FIRST_ADDRESS + 0u * computed) & ~kept);")
N('loop-address-always-convert', PC, "const uint32_t pointed_conversion = (tables->kept_conversions[computed][entries] & kept) | ((BUSTER_NODE_ROWS_FIRST_ADDRESS + 1u) & ~kept);")
FO = "const uint32_t first_own = ((BUSTER_NODE_ROWS_FIRST + 2u * global + postfix) & by_name) | (pointed_own & ~by_name);"
N('loop-first-global-as-local', FO, "const uint32_t first_own = ((BUSTER_NODE_ROWS_FIRST + 0u * global + postfix) & by_name) | (pointed_own & ~by_name);")
N('loop-first-no-dup', FO, "const uint32_t first_own = ((BUSTER_NODE_ROWS_FIRST + 2u * global + 0u * postfix) & by_name) | (pointed_own & ~by_name);")
N('loop-first-address-none', FO, "const uint32_t first_own = ((BUSTER_NODE_ROWS_FIRST + 2u * global + postfix) & by_name) | ((pointed_own & 0u) & ~by_name);")
FC = "const uint32_t first_conversion = ((BUSTER_NODE_ROWS_FIRST_CONVERT * computed) & by_name) | (pointed_conversion & ~by_name);"
N('loop-first-no-convert', FC, "const uint32_t first_conversion = ((BUSTER_NODE_ROWS_FIRST_CONVERT * 0u * computed) & by_name) | (pointed_conversion & ~by_name);")
N('loop-first-always-convert', FC, "const uint32_t first_conversion = (BUSTER_NODE_ROWS_FIRST_CONVERT & by_name) | (pointed_conversion & ~by_name);")
N('loop-first-address-no-row', FC, "const uint32_t first_conversion = ((BUSTER_NODE_ROWS_FIRST_CONVERT * computed) & by_name) | ((pointed_conversion & 0u) & ~by_name);")
N('loop-first-own-not-written', "state->window_x_owns[destination] = (uint8_t)first_own;", "state->window_x_owns[destination] = (uint8_t)(first_own & 0u);")
N('loop-first-conversion-not-written', "state->window_x_conversions[destination] = (uint8_t)first_conversion;", "state->window_x_conversions[destination] = (uint8_t)(first_conversion & 0u);")
FL = "state->window_x_lengths[destination] = (uint8_t)(tables->lengths[first_own] + tables->lengths[first_conversion]);"
N('loop-first-length-no-own', FL, "state->window_x_lengths[destination] = (uint8_t)(0u * tables->lengths[first_own] + tables->lengths[first_conversion]);")
N('loop-first-length-no-conversion', FL, "state->window_x_lengths[destination] = (uint8_t)(tables->lengths[first_own] + 0u * tables->lengths[first_conversion]);")
N('loop-first-length-of-the-entries', FL, "state->window_x_lengths[destination] = (uint8_t)(tables->lengths[entries] + tables->lengths[first_conversion]);")
# A row's entries' number, which the shapes' sweep makes and the write and the comparison read.
SUM = "_mm512_storeu_si512(state->window_x_lengths + x, _mm512_add_epi8(own_lengths, conversion_lengths));"
N('shapes-length-no-conversion', SUM, "_mm512_storeu_si512(state->window_x_lengths + x, _mm512_add_epi8(own_lengths, _mm512_andnot_si512(conversion_lengths, conversion_lengths)));")
N('shapes-length-no-own', SUM, "_mm512_storeu_si512(state->window_x_lengths + x, _mm512_add_epi8(_mm512_andnot_si512(own_lengths, own_lengths), conversion_lengths));")
N('write-offsets-with-its-own', "_mm512_mullo_epi64(lengths, _mm512_set1_epi64(0x0101010101010100))", "_mm512_mullo_epi64(lengths, _mm512_set1_epi64(0x0101010101010101))")
N('write-offsets-short', "_mm512_mullo_epi64(lengths, _mm512_set1_epi64(0x0101010101010100))", "_mm512_mullo_epi64(lengths, _mm512_set1_epi64(0x0001010101010100))")
N('length-low-bits', "    return state->window_x_lengths[x];\n", "    return state->window_x_lengths[x] & 7u;\n")
N('loop-destination-class-not-written', "state->window_x_operands[destination] = (uint8_t)calculated;", "state->window_x_operands[destination] = (uint8_t)(calculated & 0u);")
N('loop-destination-class-stored', "state->window_x_operands[destination] = (uint8_t)calculated;", "state->window_x_operands[destination] = (uint8_t)stored;")
DL = "destination_masks[BUSTER_NODE_ROWS_MASK_LISTED] |= (uint64_t)(first_own == BUSTER_NODE_ROWS_LATER ? 1u : 0u) << (destination & 63);"
N('loop-no-room-not-listed', DL, "destination_masks[BUSTER_NODE_ROWS_MASK_LISTED] |= (uint64_t)(first_own == BUSTER_NODE_ROWS_LATER ? 0u : 0u) << (destination & 63);")
N('loop-no-room-low-lanes', DL, "destination_masks[BUSTER_NODE_ROWS_MASK_LISTED] |= (uint64_t)(first_own == BUSTER_NODE_ROWS_LATER ? 1u : 0u) << (destination & 31);")
N('loop-no-room-at-the-update', DL, "destination_masks[BUSTER_NODE_ROWS_MASK_LISTED] |= (uint64_t)(first_own == BUSTER_NODE_ROWS_LATER ? 1u : 0u) << (x & 63);")
N('loop-no-room-first-block', "uint64_t* destination_masks = state->window_c_masks + BUSTER_NODE_CONTEXTS_MASKS * (uint64_t)(destination / 64);", "uint64_t* destination_masks = state->window_c_masks + BUSTER_NODE_CONTEXTS_MASKS * (uint64_t)(destination / 64 & 0u);")
N('loop-no-room-the-updates-block', "uint64_t* destination_masks = state->window_c_masks + BUSTER_NODE_CONTEXTS_MASKS * (uint64_t)(destination / 64);", "uint64_t* destination_masks = state->window_c_masks + BUSTER_NODE_CONTEXTS_MASKS * (uint64_t)(x / 64);")
N('loop-destination-second-operand', "const uint32_t destination = x - front->window_left[x];", "const uint32_t destination = x - 1u + (front->window_left[x] & 0u);")
# The updates' list.
UPD = "const __mmask64 updated = _mm512_mask_cmpeq_epi8_mask(alive, _mm512_loadu_si512(state->window_c_templates + x), _mm512_set1_epi8((char)NODE_MACHINE_TEMPLATE_UPDATE));"
N('list-not-evaluated', UPD, "const __mmask64 updated = _mm512_mask_cmpeq_epi8_mask(alive | ~alive, _mm512_loadu_si512(state->window_c_templates + x), _mm512_set1_epi8((char)NODE_MACHINE_TEMPLATE_UPDATE));")
N('list-none', UPD, "const __mmask64 updated = _mm512_mask_cmpeq_epi8_mask(alive & 0, _mm512_loadu_si512(state->window_c_templates + x), _mm512_set1_epi8((char)NODE_MACHINE_TEMPLATE_UPDATE));")
N('list-calls', UPD, "const __mmask64 updated = _mm512_mask_cmpeq_epi8_mask(alive, _mm512_loadu_si512(state->window_c_templates + x), _mm512_set1_epi8((char)NODE_MACHINE_TEMPLATE_CALL));")
N('list-low-lanes', UPD, "const __mmask64 updated = _mm512_mask_cmpeq_epi8_mask(alive & 0xffffffff, _mm512_loadu_si512(state->window_c_templates + x), _mm512_set1_epi8((char)NODE_MACHINE_TEMPLATE_UPDATE));")
N('list-places-not-compressed', "__m512i update_places = _mm512_maskz_compress_epi8(updated, places);", "__m512i update_places = _mm512_maskz_mov_epi8(updated, places);")
N('list-count-one-short', "const uint32_t update_end = update_count + (uint32_t)_mm_popcnt_u64(updated);", "const uint32_t update_end = update_count + (uint32_t)_mm_popcnt_u64(updated & (updated - 1));")
N('list-no-block-number', "_mm512_add_epi32(_mm512_set1_epi32((int32_t)x), _mm512_cvtepu8_epi32(_mm512_castsi512_si128(update_places)))", "_mm512_add_epi32(_mm512_set1_epi32((int32_t)(x & 0u)), _mm512_cvtepu8_epi32(_mm512_castsi512_si128(update_places)))")
N('list-no-second-turn', "} while (update_count < update_end);", "} while (update_count < update_end && update_count == 0);")
N('list-second-turn-same-places', "update_places = _mm512_shuffle_i64x2(update_places, update_places, 0x39);", "update_places = _mm512_shuffle_i64x2(update_places, update_places, 0xe4);")
N('list-second-turn-other-lane', "update_places = _mm512_shuffle_i64x2(update_places, update_places, 0x39);", "update_places = _mm512_shuffle_i64x2(update_places, update_places, 0x4e);")
N('list-turn-of-eight', "            update_count += 16;\n", "            update_count += 8;\n")
N('list-loop-short', "for (uint32_t i = 0; i < update_count; i += 1)\n    {\n        node_rows_window_update(state, front, updates[i]);", "for (uint32_t i = 0; i + 1 < update_count; i += 1)\n    {\n        node_rows_window_update(state, front, updates[i]);")
N('list-loop-from-the-second', "for (uint32_t i = 0; i < update_count; i += 1)\n    {\n        node_rows_window_update(state, front, updates[i]);", "for (uint32_t i = 1; i < update_count; i += 1)\n    {\n        node_rows_window_update(state, front, updates[i]);")
# The chunk: the updates' sweep in both runs.
N('chunk-second-run-without-updates', "node_rows_window_updates(state, front, count, &again);", "(void)again;")
N('chunk-updates-never', "    if (state->c_updates_now != 0)\n    {\n        node_rows_window_updates(state, front, count, &read);", "    if (state->c_updates_now == UINT64_MAX)\n    {\n        node_rows_window_updates(state, front, count, &read);")
N('chunk-updates-of-two', "    if (state->c_updates_now != 0)\n    {\n        node_rows_window_updates(state, front, count, &read);", "    if (state->c_updates_now > 1)\n    {\n        node_rows_window_updates(state, front, count, &read);")
out.append(('chunk-updates-count-not-kept', 'src/buster/compiler/c_check_node_machine_window.c', "    state->c_updates_now = loop_counts.updates_taken;\n", "    state->c_updates_now = loop_counts.updates_taken & 0;\n", None))
out.append(('chunk-updates-count-of-the-asked', 'src/buster/compiler/c_check_node_machine_window.c', "    state->c_updates_now = loop_counts.updates_taken;\n", "    state->c_updates_now = loop_counts.updates_taken > 1 ? loop_counts.updates_taken : 0;\n", None))
# The write.
OPS = "const __m512i operations = node_window_table(tables->operations, _mm512_permutexvar_epi8(order, _mm512_loadu_si512(front->ops + x)));"
N('write-operations-not-ordered', OPS, "const __m512i operations = node_window_table(tables->operations, _mm512_loadu_si512(front->ops + x));")
N('write-operations-by-binaries', OPS, "const __m512i operations = node_window_table(tables->binaries, _mm512_permutexvar_epi8(order, _mm512_loadu_si512(front->ops + x)));")
N('write-stores-not-ordered', "const __m512i stores = _mm512_permutexvar_epi8(order, _mm512_loadu_si512(state->window_x_bits + x));", "const __m512i stores = _mm512_loadu_si512(state->window_x_bits + x);")
CONV = "classes[BUSTER_NODE_ROWS_SLOTS + slot] = _mm512_mask_mov_epi8(conversion_sources, _mm512_cmpeq_epi8_mask(conversion_sources, own_source), own_classes);"
for slot in (1, 2, 3):
    N('write-conversion-own-not-slot-%d' % slot, CONV, "classes[BUSTER_NODE_ROWS_SLOTS + slot] = _mm512_mask_mov_epi8(conversion_sources, slot == %d ? 0 : _mm512_cmpeq_epi8_mask(conversion_sources, own_source), own_classes);" % slot)
N('write-operand-second-slot', "classes[1] = _mm512_mask_mov_epi8(classes[1], _mm512_cmpeq_epi8_mask(classes[1], operand_source), operand_classes);", "classes[1] = _mm512_mask_mov_epi8(classes[1], _mm512_cmpeq_epi8_mask(classes[1], operand_source) & 0, operand_classes);")
N('write-operand-second-slot-target', "classes[1] = _mm512_mask_mov_epi8(classes[1], _mm512_cmpeq_epi8_mask(classes[1], operand_source), operand_classes);", "classes[1] = _mm512_mask_mov_epi8(classes[1], _mm512_cmpeq_epi8_mask(classes[1], operand_source), target_classes);")
LAST = "classes[BUSTER_NODE_ROWS_MOST - 1] = _mm512_mask_mov_epi8(conversion_lasts, _mm512_cmpeq_epi8_mask(conversion_lasts, operand_source), operand_classes);"
N('write-conversion-operand-not-made', LAST, "classes[BUSTER_NODE_ROWS_MOST - 1] = _mm512_mask_mov_epi8(conversion_lasts, _mm512_cmpeq_epi8_mask(conversion_lasts, operand_source) & 0, operand_classes);")
N('write-conversion-operand-own', LAST, "classes[BUSTER_NODE_ROWS_MOST - 1] = _mm512_mask_mov_epi8(conversion_lasts, _mm512_cmpeq_epi8_mask(conversion_lasts, operand_source), own_classes);")
N('write-operation-not-made', "kinds[1] = _mm512_mask_mov_epi8(kinds[1], _mm512_cmpeq_epi8_mask(kinds[1], _mm512_set1_epi8(BUSTER_NODE_ROWS_KIND_OPERATION)), operations);", "kinds[1] = _mm512_mask_mov_epi8(kinds[1], _mm512_cmpeq_epi8_mask(kinds[1], _mm512_set1_epi8(BUSTER_NODE_ROWS_KIND_OPERATION)) & 0, operations);")
N('write-store-not-made', "kinds[3] = _mm512_mask_mov_epi8(kinds[3], _mm512_cmpeq_epi8_mask(kinds[3], _mm512_set1_epi8(BUSTER_NODE_ROWS_KIND_STORE)), stores);", "kinds[3] = _mm512_mask_mov_epi8(kinds[3], _mm512_cmpeq_epi8_mask(kinds[3], _mm512_set1_epi8(BUSTER_NODE_ROWS_KIND_STORE)) & 0, stores);")
N('write-store-the-operation', "kinds[3] = _mm512_mask_mov_epi8(kinds[3], _mm512_cmpeq_epi8_mask(kinds[3], _mm512_set1_epi8(BUSTER_NODE_ROWS_KIND_STORE)), stores);", "kinds[3] = _mm512_mask_mov_epi8(kinds[3], _mm512_cmpeq_epi8_mask(kinds[3], _mm512_set1_epi8(BUSTER_NODE_ROWS_KIND_STORE)), _mm512_or_si512(operations, _mm512_andnot_si512(stores, stores)));")
# The tables.
N('table-update-template-listed', "    tables->templates[NODE_MACHINE_TEMPLATE_BRANCHES] = BUSTER_NODE_ROWS_LATER;\n", "    tables->templates[NODE_MACHINE_TEMPLATE_BRANCHES] = BUSTER_NODE_ROWS_LATER;\n    tables->templates[NODE_MACHINE_TEMPLATE_UPDATE] = BUSTER_NODE_ROWS_LATER;\n")
N('table-places-shifted', "tables->places[place] = (uint8_t)place;", "tables->places[place] = (uint8_t)(place ^ 1u);")
N('table-operations-increment', "op == CHECK_OP_PRE_INCREMENT || op == CHECK_OP_POST_INCREMENT ? BUSTER_TYPED_ADD :", "op == CHECK_OP_PRE_INCREMENT || op == CHECK_OP_POST_INCREMENT ? BUSTER_TYPED_SUB :")
N('table-operations-no-post-increment', "op == CHECK_OP_PRE_INCREMENT || op == CHECK_OP_POST_INCREMENT ? BUSTER_TYPED_ADD :", "op == CHECK_OP_PRE_INCREMENT ? BUSTER_TYPED_ADD :")
N('table-operations-no-pre-increment', "op == CHECK_OP_PRE_INCREMENT || op == CHECK_OP_POST_INCREMENT ? BUSTER_TYPED_ADD :", "op == CHECK_OP_POST_INCREMENT ? BUSTER_TYPED_ADD :")
N('table-operations-decrement', "op == CHECK_OP_PRE_DECREMENT || op == CHECK_OP_POST_DECREMENT ? BUSTER_TYPED_SUB :", "op == CHECK_OP_PRE_DECREMENT || op == CHECK_OP_POST_DECREMENT ? BUSTER_TYPED_ADD :")
N('table-operations-no-post-decrement', "op == CHECK_OP_PRE_DECREMENT || op == CHECK_OP_POST_DECREMENT ? BUSTER_TYPED_SUB :", "op == CHECK_OP_PRE_DECREMENT ? BUSTER_TYPED_SUB :")
N('table-operations-no-pre-decrement', "op == CHECK_OP_PRE_DECREMENT || op == CHECK_OP_POST_DECREMENT ? BUSTER_TYPED_SUB :", "op == CHECK_OP_POST_DECREMENT ? BUSTER_TYPED_SUB :")
STEP = "const uint32_t stepped = op >= CHECK_OP_PRE_INCREMENT && op <= CHECK_OP_POST_DECREMENT ? 2u : 0u;"
N('table-stepped-from-the-second', STEP, "const uint32_t stepped = op > CHECK_OP_PRE_INCREMENT && op <= CHECK_OP_POST_DECREMENT ? 2u : 0u;")
N('table-stepped-short-of-the-last', STEP, "const uint32_t stepped = op >= CHECK_OP_PRE_INCREMENT && op < CHECK_OP_POST_DECREMENT ? 2u : 0u;")
N('table-stepped-with-add-assign', STEP, "const uint32_t stepped = op >= CHECK_OP_PRE_INCREMENT && op <= CHECK_OP_ADD_ASSIGN ? 2u : 0u;")
NEG = "const uint32_t negated = op == CHECK_OP_PRE_DECREMENT || op == CHECK_OP_POST_DECREMENT || op == CHECK_OP_SUBTRACT_ASSIGN ? 1u : 0u;"
N('table-negated-no-pre', NEG, "const uint32_t negated = op == CHECK_OP_POST_DECREMENT || op == CHECK_OP_SUBTRACT_ASSIGN ? 1u : 0u;")
N('table-negated-no-post', NEG, "const uint32_t negated = op == CHECK_OP_PRE_DECREMENT || op == CHECK_OP_SUBTRACT_ASSIGN ? 1u : 0u;")
N('table-negated-no-assign', NEG, "const uint32_t negated = op == CHECK_OP_PRE_DECREMENT || op == CHECK_OP_POST_DECREMENT ? 1u : 0u;")
N('table-negated-add-assign', NEG, "const uint32_t negated = op == CHECK_OP_PRE_DECREMENT || op == CHECK_OP_POST_DECREMENT || op == CHECK_OP_SUBTRACT_ASSIGN || op == CHECK_OP_ADD_ASSIGN ? 1u : 0u;")
N('table-updates-no-step', "tables->updates[op] = (uint8_t)(BUSTER_NODE_ROWS_UPDATE + stepped);", "tables->updates[op] = (uint8_t)(BUSTER_NODE_ROWS_UPDATE + 0u * stepped);")
N('table-pointer-updates-no-step', "tables->pointer_updates[op] = (uint8_t)(BUSTER_NODE_ROWS_UPDATE_POINTER + stepped + negated);", "tables->pointer_updates[op] = (uint8_t)(BUSTER_NODE_ROWS_UPDATE_POINTER + 0u * stepped + negated);")
N('table-pointer-updates-no-negation', "tables->pointer_updates[op] = (uint8_t)(BUSTER_NODE_ROWS_UPDATE_POINTER + stepped + negated);", "tables->pointer_updates[op] = (uint8_t)(BUSTER_NODE_ROWS_UPDATE_POINTER + stepped + 0u * negated);")
N('table-update-const-class', "node_rows_place(tables, shape, 0, BUSTER_TYPED_CONST, BUSTER_NODE_ROWS_CLASS_OPERAND);", "node_rows_place(tables, shape, 0, BUSTER_TYPED_CONST, BUSTER_NODE_ROWS_CLASS_OWN);")
N('table-update-const-kind', "node_rows_place(tables, shape, 0, BUSTER_TYPED_CONST, BUSTER_NODE_ROWS_CLASS_OPERAND);", "node_rows_place(tables, shape, 0, BUSTER_TYPED_CONVERT, BUSTER_NODE_ROWS_CLASS_OPERAND);")
N('table-pointer-const-class', "node_rows_place(tables, pointer, 0, BUSTER_TYPED_CONST, BUSTER_TYPED_CLASS_I64);", "node_rows_place(tables, pointer, 0, BUSTER_TYPED_CONST, BUSTER_TYPED_CLASS_U64);")
N('table-pointer-const-kind', "node_rows_place(tables, pointer, 0, BUSTER_TYPED_CONST, BUSTER_TYPED_CLASS_I64);", "node_rows_place(tables, pointer, 0, BUSTER_TYPED_NEG, BUSTER_TYPED_CLASS_I64);")
N('table-update-operation-class', "node_rows_place(tables, shape, 1, BUSTER_NODE_ROWS_KIND_OPERATION, BUSTER_NODE_ROWS_CLASS_OPERAND);", "node_rows_place(tables, shape, 1, BUSTER_NODE_ROWS_KIND_OPERATION, BUSTER_NODE_ROWS_CLASS_OWN);")
N('table-update-back-class', "node_rows_place(tables, shape, 2, BUSTER_TYPED_CONVERT, BUSTER_NODE_ROWS_CLASS_OWN);", "node_rows_place(tables, shape, 2, BUSTER_TYPED_CONVERT, BUSTER_TYPED_CLASS_I32);")
N('table-update-back-kind', "node_rows_place(tables, shape, 2, BUSTER_TYPED_CONVERT, BUSTER_NODE_ROWS_CLASS_OWN);", "node_rows_place(tables, shape, 2, BUSTER_TYPED_DISCARD, BUSTER_NODE_ROWS_CLASS_OWN);")
N('table-pointer-negation-class', "node_rows_place(tables, pointer, 1, BUSTER_TYPED_NEG, BUSTER_TYPED_CLASS_I64);", "node_rows_place(tables, pointer, 1, BUSTER_TYPED_NEG, BUSTER_TYPED_CLASS_U64);")
N('table-pointer-negation-kind', "node_rows_place(tables, pointer, 1, BUSTER_TYPED_NEG, BUSTER_TYPED_CLASS_I64);", "node_rows_place(tables, pointer, 1, BUSTER_TYPED_NOT, BUSTER_TYPED_CLASS_I64);")
N('table-pointer-add-class', "node_rows_place(tables, pointer, 2, BUSTER_TYPED_PTR_ADD, BUSTER_TYPED_CLASS_U64);", "node_rows_place(tables, pointer, 2, BUSTER_TYPED_PTR_ADD, BUSTER_TYPED_CLASS_I64);")
N('table-pointer-add-kind', "node_rows_place(tables, pointer, 2, BUSTER_TYPED_PTR_ADD, BUSTER_TYPED_CLASS_U64);", "node_rows_place(tables, pointer, 2, BUSTER_TYPED_ADD, BUSTER_TYPED_CLASS_U64);")
N('table-update-store-class', "node_rows_place(tables, shape, 3, BUSTER_NODE_ROWS_KIND_STORE, BUSTER_NODE_ROWS_CLASS_OWN);", "node_rows_place(tables, shape, 3, BUSTER_NODE_ROWS_KIND_STORE, BUSTER_TYPED_CLASS_I32);")
N('table-pointer-store-class', "node_rows_place(tables, pointer, 3, BUSTER_NODE_ROWS_KIND_STORE, BUSTER_NODE_ROWS_CLASS_OWN);", "node_rows_place(tables, pointer, 3, BUSTER_NODE_ROWS_KIND_STORE, BUSTER_TYPED_CLASS_I64);")
N('table-first-read-kind', "node_rows_place(tables, shape, 0, global != 0 ? BUSTER_TYPED_GLOBAL : BUSTER_TYPED_LOCAL, BUSTER_NODE_ROWS_CLASS_OWN);", "node_rows_place(tables, shape, 0, global != 0 ? BUSTER_TYPED_LOCAL : BUSTER_TYPED_GLOBAL, BUSTER_NODE_ROWS_CLASS_OWN);")
N('table-first-read-class', "node_rows_place(tables, shape, 0, global != 0 ? BUSTER_TYPED_GLOBAL : BUSTER_TYPED_LOCAL, BUSTER_NODE_ROWS_CLASS_OWN);", "node_rows_place(tables, shape, 0, global != 0 ? BUSTER_TYPED_GLOBAL : BUSTER_TYPED_LOCAL, BUSTER_NODE_ROWS_CLASS_OPERAND);")
N('table-first-dup-class', "node_rows_place(tables, shape, 1, BUSTER_TYPED_DUP, BUSTER_NODE_ROWS_CLASS_OWN);", "node_rows_place(tables, shape, 1, BUSTER_TYPED_DUP, BUSTER_TYPED_CLASS_I32);")
N('table-first-dup-kind', "node_rows_place(tables, shape, 1, BUSTER_TYPED_DUP, BUSTER_NODE_ROWS_CLASS_OWN);", "node_rows_place(tables, shape, 1, BUSTER_TYPED_LOCAL, BUSTER_NODE_ROWS_CLASS_OWN);")
FCV = "node_rows_place(tables, BUSTER_NODE_ROWS_FIRST_CONVERT, BUSTER_NODE_ROWS_SLOTS - 1, BUSTER_TYPED_CONVERT, BUSTER_NODE_ROWS_CLASS_OPERAND);"
N('table-first-convert-class', FCV, "node_rows_place(tables, BUSTER_NODE_ROWS_FIRST_CONVERT, BUSTER_NODE_ROWS_SLOTS - 1, BUSTER_TYPED_CONVERT, BUSTER_NODE_ROWS_CLASS_OWN);")
N('table-first-convert-kind', FCV, "node_rows_place(tables, BUSTER_NODE_ROWS_FIRST_CONVERT, BUSTER_NODE_ROWS_SLOTS - 1, BUSTER_TYPED_DISCARD, BUSTER_NODE_ROWS_CLASS_OPERAND);")
N('table-address-dup-class', "node_rows_place(tables, shape, 0, BUSTER_TYPED_DUP, BUSTER_TYPED_CLASS_U64);", "node_rows_place(tables, shape, 0, BUSTER_TYPED_DUP, BUSTER_TYPED_CLASS_I64);")
N('table-address-dup-kind', "node_rows_place(tables, shape, 0, BUSTER_TYPED_DUP, BUSTER_TYPED_CLASS_U64);", "node_rows_place(tables, shape, 0, BUSTER_TYPED_LOCAL, BUSTER_TYPED_CLASS_U64);")
N('table-address-load-class', "node_rows_place(tables, shape, 1, BUSTER_TYPED_LOAD, BUSTER_NODE_ROWS_CLASS_OWN);", "node_rows_place(tables, shape, 1, BUSTER_TYPED_LOAD, BUSTER_TYPED_CLASS_I32);")
N('table-address-load-kind', "node_rows_place(tables, shape, 1, BUSTER_TYPED_LOAD, BUSTER_NODE_ROWS_CLASS_OWN);", "node_rows_place(tables, shape, 1, BUSTER_TYPED_DUP, BUSTER_NODE_ROWS_CLASS_OWN);")
ACV = "            node_rows_place(tables, shape, BUSTER_NODE_ROWS_SLOTS - 1, BUSTER_TYPED_CONVERT, BUSTER_NODE_ROWS_CLASS_OPERAND);\n        }\n    }\n    // A postfix update's first row through an address"
N('table-address-convert-class', ACV, ACV.replace("BUSTER_NODE_ROWS_CLASS_OPERAND", "BUSTER_NODE_ROWS_CLASS_OWN"))
N('table-address-convert-kind', ACV, ACV.replace("BUSTER_TYPED_CONVERT", "BUSTER_TYPED_DISCARD"))
for i, (a, b) in enumerate([("{ BUSTER_TYPED_SET_LOCAL, BUSTER_TYPED_CLASS_U64 },", "{ BUSTER_TYPED_STORE_LOCAL, BUSTER_TYPED_CLASS_U64 },"),
                            ("{ BUSTER_TYPED_SET_LOCAL, BUSTER_TYPED_CLASS_U64 },", "{ BUSTER_TYPED_SET_LOCAL, BUSTER_TYPED_CLASS_I64 },"),
                            ("{ BUSTER_TYPED_SET_LOCAL, BUSTER_TYPED_CLASS_U64 },   { BUSTER_TYPED_LOCAL, BUSTER_TYPED_CLASS_U64 },", "{ BUSTER_TYPED_SET_LOCAL, BUSTER_TYPED_CLASS_U64 },   { BUSTER_TYPED_LOCAL, BUSTER_TYPED_CLASS_I64 },"),
                            ("{ BUSTER_TYPED_SET_LOCAL, BUSTER_TYPED_CLASS_U64 },   { BUSTER_TYPED_LOCAL, BUSTER_TYPED_CLASS_U64 },", "{ BUSTER_TYPED_SET_LOCAL, BUSTER_TYPED_CLASS_U64 },   { BUSTER_TYPED_GLOBAL, BUSTER_TYPED_CLASS_U64 },"),
                            ("{ BUSTER_TYPED_LOAD, BUSTER_NODE_ROWS_CLASS_OWN },    { BUSTER_TYPED_STORE_LOCAL, BUSTER_NODE_ROWS_CLASS_OWN },", "{ BUSTER_TYPED_LOAD, BUSTER_TYPED_CLASS_U64 },    { BUSTER_TYPED_STORE_LOCAL, BUSTER_NODE_ROWS_CLASS_OWN },"),
                            ("{ BUSTER_TYPED_LOAD, BUSTER_NODE_ROWS_CLASS_OWN },    { BUSTER_TYPED_STORE_LOCAL, BUSTER_NODE_ROWS_CLASS_OWN },", "{ BUSTER_TYPED_DUP, BUSTER_NODE_ROWS_CLASS_OWN },    { BUSTER_TYPED_STORE_LOCAL, BUSTER_NODE_ROWS_CLASS_OWN },"),
                            ("{ BUSTER_TYPED_LOAD, BUSTER_NODE_ROWS_CLASS_OWN },    { BUSTER_TYPED_STORE_LOCAL, BUSTER_NODE_ROWS_CLASS_OWN },", "{ BUSTER_TYPED_LOAD, BUSTER_NODE_ROWS_CLASS_OWN },    { BUSTER_TYPED_STORE_LOCAL, BUSTER_TYPED_CLASS_U64 },"),
                            ("{ BUSTER_TYPED_LOAD, BUSTER_NODE_ROWS_CLASS_OWN },    { BUSTER_TYPED_STORE_LOCAL, BUSTER_NODE_ROWS_CLASS_OWN },", "{ BUSTER_TYPED_LOAD, BUSTER_NODE_ROWS_CLASS_OWN },    { BUSTER_TYPED_SET_LOCAL, BUSTER_NODE_ROWS_CLASS_OWN },"),
                            ("{ BUSTER_TYPED_LOCAL, BUSTER_TYPED_CLASS_U64 },       { BUSTER_TYPED_LOCAL, BUSTER_NODE_ROWS_CLASS_OWN },", "{ BUSTER_TYPED_LOCAL, BUSTER_NODE_ROWS_CLASS_OWN },       { BUSTER_TYPED_LOCAL, BUSTER_NODE_ROWS_CLASS_OWN },"),
                            ("{ BUSTER_TYPED_LOCAL, BUSTER_TYPED_CLASS_U64 },       { BUSTER_TYPED_LOCAL, BUSTER_NODE_ROWS_CLASS_OWN },", "{ BUSTER_TYPED_GLOBAL, BUSTER_TYPED_CLASS_U64 },       { BUSTER_TYPED_LOCAL, BUSTER_NODE_ROWS_CLASS_OWN },"),
                            ("{ BUSTER_TYPED_LOCAL, BUSTER_TYPED_CLASS_U64 },       { BUSTER_TYPED_LOCAL, BUSTER_NODE_ROWS_CLASS_OWN },", "{ BUSTER_TYPED_LOCAL, BUSTER_TYPED_CLASS_U64 },       { BUSTER_TYPED_LOCAL, BUSTER_TYPED_CLASS_U64 },"),
                            ("{ BUSTER_TYPED_LOCAL, BUSTER_TYPED_CLASS_U64 },       { BUSTER_TYPED_LOCAL, BUSTER_NODE_ROWS_CLASS_OWN },", "{ BUSTER_TYPED_LOCAL, BUSTER_TYPED_CLASS_U64 },       { BUSTER_TYPED_GLOBAL, BUSTER_NODE_ROWS_CLASS_OWN },")]):
    N('table-kept-six-%d' % i, a, b)
for i, base in enumerate(["{ BUSTER_NODE_ROWS_POINTER, 1 },", "{ BUSTER_NODE_ROWS_ADDRESS + 2, 1 },", "{ BUSTER_NODE_ROWS_ADDRESS + 6, 1 },", "{ BUSTER_NODE_ROWS_MEMBER, 2 },"]):
    N('table-kept-base-%d-out' % (i + 1), "            " + base + "\n", "            { 126, 0 },\n")
N('table-kept-base-0-out', "            { 0, 0 },\n            { BUSTER_NODE_ROWS_POINTER, 1 },", "            { 126, 0 },\n            { BUSTER_NODE_ROWS_POINTER, 1 },")
KCV = "                    node_rows_place(tables, shape, BUSTER_NODE_ROWS_SLOTS - 1, BUSTER_TYPED_CONVERT, BUSTER_NODE_ROWS_CLASS_OPERAND);\n                }\n            }\n        }\n        for (uint32_t b = 0;"
N('table-kept-convert-class', KCV, KCV.replace("BUSTER_NODE_ROWS_CLASS_OPERAND", "BUSTER_NODE_ROWS_CLASS_OWN"))
N('table-kept-convert-kind', KCV, KCV.replace("BUSTER_TYPED_CONVERT", "BUSTER_TYPED_DISCARD"))
N('table-kept-rest-from-one-more', "for (uint32_t i = 4 - own; i < 6; i += 1)", "for (uint32_t i = 5 - own; i < 6; i += 1)")
N('table-kept-rest-shifted', "node_rows_place(tables, shape, i - (4 - own), six[i][0], six[i][1]);", "node_rows_place(tables, shape, i - (4 - own), six[i - 1][0], six[i - 1][1]);")
N('table-kept-own-entries-not-copied', "node_rows_place(tables, shape, slot, tables->kinds[slot][base], tables->sources[slot][base]);", "node_rows_place(tables, shape, slot, BUSTER_TYPED_CONST, tables->sources[slot][base]);")
N('table-kept-own-sources-not-copied', "node_rows_place(tables, shape, slot, tables->kinds[slot][base], tables->sources[slot][base]);", "node_rows_place(tables, shape, slot, tables->kinds[slot][base], BUSTER_TYPED_CLASS_I32);")
N('table-kept-own-six-shifted', "node_rows_place(tables, shape, slot, six[slot - own][0], six[slot - own][1]);", "node_rows_place(tables, shape, slot, six[slot][0], six[slot][1]);")
N('table-kept-conversion-map', "tables->kept_conversions[converted][base] = (uint8_t)(BUSTER_NODE_ROWS_KEPT_REST + 2 * own + converted);", "tables->kept_conversions[converted][base] = (uint8_t)(BUSTER_NODE_ROWS_KEPT_REST + 2 * own);")
N('table-kept-conversion-map-of-none', "tables->kept_conversions[converted][base] = (uint8_t)(BUSTER_NODE_ROWS_KEPT_REST + 2 * own + converted);", "tables->kept_conversions[converted][base] = (uint8_t)(BUSTER_NODE_ROWS_KEPT_REST + converted);")
N('table-kept-own-map', "tables->kept_owns[converted][base] = (uint8_t)shape;", "tables->kept_owns[converted][base] = (uint8_t)(shape ^ converted);")
N('table-kept-member-with-convert', "for (uint32_t converted = 0; converted < 2 - own / 2; converted += 1)\n            {\n                tables->kept_owns[converted][base] = (uint8_t)shape;", "for (uint32_t converted = 0; converted < 2; converted += 1)\n            {\n                tables->kept_owns[converted][base] = (uint8_t)shape;")
N('table-kept-maps-not-marked', "memset(tables->kept_owns, BUSTER_NODE_ROWS_LATER, sizeof(tables->kept_owns));", "memset(tables->kept_owns, 0, sizeof(tables->kept_owns));")
N('reason-update-as-branches', "state->x_tables->templates[state->window_c_templates[x] & 63] == BUSTER_NODE_ROWS_LATER ? BUSTER_NODE_ROWS_REASON_BRANCHES :", "state->x_tables->templates[state->window_c_templates[x] & 63] != BUSTER_NODE_ROWS_LATER ? BUSTER_NODE_ROWS_REASON_BRANCHES :")
tail = '''def apply(t, old, new, nth, name):
    if nth is None:
        assert t.count(old) == 1, (name, t.count(old))
        return t.replace(old, new)
    parts = t.split(old)
    assert len(parts) > nth + 1, (name, len(parts))
    return old.join(parts[:nth + 1]) + new + old.join(parts[nth + 1:])
tree = sys.argv[1]
if len(sys.argv) < 3:
    names = set()
    for name, file, old, new, nth in faults:
        t = open(tree + '/' + file).read()
        assert apply(t, old, new, nth, name) != t, name
        assert name not in names, name
        names.add(name)
    print(len(faults))
else:
    name, file, old, new, nth = faults[int(sys.argv[2])]
    t = open(tree + '/' + file).read()
    open(tree + '/' + file, 'w').write(apply(t, old, new, nth, name))
    print(name)
'''
body = "#!/usr/bin/env python3\n# faults-update.py TREE [N]: the update's rows' faults (make-faults.py). With no N, check every fault applies once and\n# print how many; with N, apply fault N in TREE in place and print its name.\nimport sys\nfaults = " + repr(out) + "\n" + tail
open('faults-update.py', 'w').write(body)
print(len(out), 'faults')
