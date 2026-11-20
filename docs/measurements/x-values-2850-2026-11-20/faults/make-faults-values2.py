# make-faults-values.py TREE OUT: build OUT (a round's faults-values-roundN.py), the entries' values' faults in the frozen
# code: each entry of the values' tables, each term of the sweep's masks and of the seconds' arithmetic, each loop's
# load, shift and store, the two lists made before the sweep, the columns' makers (the tests' sweep's record's value,
# the reads' member's offset, C's stride, the reader's end's bit), each term of the numbering, and the shadow's
# comparison and its control, changed alone.
import sys
tree = sys.argv[1]
ROWS = 'src/buster/compiler/c_check_node_machine_rows.c'
FACTS = 'src/buster/compiler/c_check_node_machine_facts.c'
WINDOW = 'src/buster/compiler/c_check_node_machine_window.c'
CENSUS = 'src/buster/compiler/c_check_node_census.c'
texts = {f: open(tree + '/' + f).read() for f in (ROWS, FACTS, WINDOW, CENSUS)}
out = []
def N(name, old, new, nth=None, file=ROWS):
    n = texts[file].count(old)
    assert (n == 1 if nth is None else n > nth), (name, n)
    assert name not in [f[0] for f in out], name
    assert old != new, name
    out.append((name, file, old, new, nth))
def R(name, line, a, b, nth=None, file=ROWS):
    # A fault within one unique line (or block) of text: `a` replaced by `b` in it.
    assert a in line, name
    N(name, line, line.replace(a, b, 1), nth, file)

# ---- The values' tables.
OBJECT = "        const bool object = first == BUSTER_TYPED_LOCAL || first == BUSTER_TYPED_GLOBAL || first == BUSTER_TYPED_LOCAL_ADDRESS || first == BUSTER_TYPED_GLOBAL_ADDRESS;"
R('table-object-no-local', OBJECT, "first == BUSTER_TYPED_LOCAL || ", "")
R('table-object-no-global', OBJECT, "first == BUSTER_TYPED_GLOBAL || ", "")
R('table-object-no-local-address', OBJECT, "first == BUSTER_TYPED_LOCAL_ADDRESS || ", "")
R('table-object-no-global-address', OBJECT, " || first == BUSTER_TYPED_GLOBAL_ADDRESS", "")
ALONE = "        const bool alone = shape == BUSTER_NODE_ROWS_ADDRESS || shape == BUSTER_NODE_ROWS_ADDRESS + 1;"
R('table-alone-not-the-plain', ALONE, "shape == BUSTER_NODE_ROWS_ADDRESS || ", "")
R('table-alone-not-the-converted', ALONE, " || shape == BUSTER_NODE_ROWS_ADDRESS + 1", "")
FIRST = "        lists |= object || alone || member || base == BUSTER_NODE_ROWS_MEMBER ? BUSTER_NODE_ROWS_VALUE_FIRST : 0;"
R('table-first-no-object', FIRST, "object || ", "(object && shape == 0) || ")
R('table-first-no-offset-alone', FIRST, "alone || ", "(alone && shape == 0) || ")
R('table-first-no-member', FIRST, "member || ", "(member && shape == 0) || ")
R('table-first-no-kept-member', FIRST, " || base == BUSTER_NODE_ROWS_MEMBER", "")
STORED = "        lists |= shape == BUSTER_TYPED_STORE_LOCAL || shape == BUSTER_TYPED_STORE_GLOBAL ? BUSTER_NODE_ROWS_VALUE_STORED : 0;"
R('table-stored-no-local', STORED, "shape == BUSTER_TYPED_STORE_LOCAL || ", "")
R('table-stored-no-global', STORED, " || shape == BUSTER_TYPED_STORE_GLOBAL", "")
R('table-stored-a-store', STORED, "shape == BUSTER_TYPED_STORE_LOCAL || ", "shape == BUSTER_TYPED_STORE_LOCAL || shape == BUSTER_TYPED_STORE || ")
CONSTANT = "        lists |= shape == BUSTER_TYPED_CONST || shape == BUSTER_NODE_ROWS_FOLDED ? BUSTER_NODE_ROWS_VALUE_CONSTANT : 0;"
R('table-constant-no-plain', CONSTANT, "shape == BUSTER_TYPED_CONST || ", "")
R('table-constant-no-folded', CONSTANT, " || shape == BUSTER_NODE_ROWS_FOLDED", "")
STRIDE = "        lists |= pointer || pointer_update || (kept && base == BUSTER_NODE_ROWS_POINTER) ? BUSTER_NODE_ROWS_VALUE_STRIDE : 0;"
R('table-stride-no-pointer', STRIDE, "pointer || ", "(pointer && shape == 0) || ")
R('table-stride-no-update', STRIDE, "pointer_update || ", "")
R('table-stride-no-kept', STRIDE, " || (kept && base == BUSTER_NODE_ROWS_POINTER)", "")
R('table-stride-any-kept', STRIDE, "(kept && base == BUSTER_NODE_ROWS_POINTER)", "(kept && base != 0)")
REST = "        lists |= variant == 2 || variant == 4 ? BUSTER_NODE_ROWS_VALUE_REST : 0;"
R('table-rest-no-local-s', REST, "variant == 2 || variant == 4", "variant == 4")
R('table-rest-no-global-s', REST, "variant == 2 || variant == 4", "variant == 2")
R('table-rest-without-offset-too', REST, "variant == 2 || variant == 4", "(variant >= 1 && variant <= 4)")
NUMBERED = "        lists |= shape == BUSTER_TYPED_CALL || shape == BUSTER_NODE_ROWS_BRANCHED + 1 || kept ? BUSTER_NODE_ROWS_VALUE_NUMBERED : 0;"
R('table-numbered-no-call', NUMBERED, "shape == BUSTER_TYPED_CALL || ", "")
R('table-numbered-no-label', NUMBERED, "shape == BUSTER_NODE_ROWS_BRANCHED + 1 || ", "")
R('table-numbered-every-operator', NUMBERED, "shape == BUSTER_NODE_ROWS_BRANCHED + 1", "shape >= BUSTER_NODE_ROWS_BRANCHED")
R('table-numbered-no-kept', NUMBERED, " || kept ?", " ?")
SLOT = "            if (tables->kinds[slot][shape] == BUSTER_TYPED_PTR_ADD && (lists & BUSTER_NODE_ROWS_VALUE_STRIDE) != 0)\n            {\n                slots |= (uint8_t)entries;\n            }"
R('table-slot-none', SLOT, "slots |= (uint8_t)entries;", "slots |= (uint8_t)(entries & 0);")
R('table-slot-by-slot', SLOT, "slots |= (uint8_t)entries;", "slots |= (uint8_t)(slot + (entries & 0));")
R('table-slot-of-any-sum', SLOT, " && (lists & BUSTER_NODE_ROWS_VALUE_STRIDE) != 0", "")
STEP = "        slots |= pointer_update && first == BUSTER_TYPED_CONST ? BUSTER_NODE_ROWS_SLOT_STEP : 0;"
R('table-step-none', STEP, "pointer_update && first == BUSTER_TYPED_CONST", "pointer_update && first == BUSTER_TYPED_NEG")
R('table-step-every-update', STEP, "pointer_update && first == BUSTER_TYPED_CONST", "pointer_update")
BEFORE = "        const uint32_t before = kept ? tables->lengths[base] : 0;"
R('table-kept-before-none', BEFORE, "kept ? tables->lengths[base] : 0", "kept ? tables->lengths[base] * 0 : 0")
R('table-kept-before-one', BEFORE, "kept ? tables->lengths[base] : 0", "kept ? 1 : 0")
BASES = "{ 0, BUSTER_NODE_ROWS_POINTER, BUSTER_NODE_ROWS_ADDRESS + 2, BUSTER_NODE_ROWS_ADDRESS + 6,\n                                                                                               BUSTER_NODE_ROWS_MEMBER };"
R('table-kept-bases-pointer', BASES, "{ 0, BUSTER_NODE_ROWS_POINTER,", "{ 0, BUSTER_NODE_ROWS_MEMBER,")
R('table-kept-bases-member', BASES, "BUSTER_NODE_ROWS_MEMBER };", "BUSTER_NODE_ROWS_POINTER };")
R('table-kept-bases-address', BASES, "BUSTER_NODE_ROWS_ADDRESS + 2, BUSTER_NODE_ROWS_ADDRESS + 6,", "BUSTER_NODE_ROWS_ADDRESS + 2, 0,")
PUPDATE = "        const bool pointer_update = shape >= BUSTER_NODE_ROWS_UPDATE_POINTER && shape < BUSTER_NODE_ROWS_FIRST;"
R('table-pointer-update-from-update', PUPDATE, "shape >= BUSTER_NODE_ROWS_UPDATE_POINTER", "shape >= BUSTER_NODE_ROWS_UPDATE")
R('table-pointer-update-through-first', PUPDATE, "shape < BUSTER_NODE_ROWS_FIRST;", "shape < BUSTER_NODE_ROWS_FIRST_CONVERT;")

# ---- The reads' loop: a member's offset in bytes.
MEMBER = "        const uint32_t other = state->window_c_templates[x] != CHECK_LOWER_TEMPLATE_MEMBER ? 1u : 0u;\n        state->window_x_values[x + ((BUSTER_NODE_ROWS_VALUE_NOWHERE - x) & (0u - other))] = record->member_offset / 8;"
R('reads-member-every-record', MEMBER, "!= CHECK_LOWER_TEMPLATE_MEMBER ? 1u : 0u", "!= CHECK_LOWER_TEMPLATE_MEMBER ? 0u : 0u")
R('reads-member-none', MEMBER, "!= CHECK_LOWER_TEMPLATE_MEMBER ? 1u : 0u", "!= CHECK_LOWER_TEMPLATE_MEMBER ? 1u : 1u")
R('reads-member-others', MEMBER, "!= CHECK_LOWER_TEMPLATE_MEMBER", "== CHECK_LOWER_TEMPLATE_MEMBER")
R('reads-member-in-bits', MEMBER, "record->member_offset / 8;", "record->member_offset;")
R('reads-member-halved', MEMBER, "record->member_offset / 8;", "record->member_offset / 16;")
R('reads-member-next-record', MEMBER, "state->window_x_values[x + ((", "state->window_x_values[x + 1 + ((")

# ---- The branches' loop: the list of the control's label, and an operator's shape.
LISTED_CONTROL = "    state->x_lists[BUSTER_NODE_ROWS_LIST_CONTROLLED][*controlled] = (uint16_t)o;\n    *controlled += takes & (~given >> 1) & 1u;"
R('tested-list-every-call', LISTED_CONTROL, "takes & (~given >> 1) & 1u", "(~given >> 1) & 1u")
R('tested-list-owned-too', LISTED_CONTROL, "takes & (~given >> 1) & 1u", "takes & 1u")
R('tested-list-owned-alone', LISTED_CONTROL, "(~given >> 1)", "(given >> 1)")
R('tested-list-by-sense', LISTED_CONTROL, "(~given >> 1)", "(~given)")
R('tested-list-none', LISTED_CONTROL, "*controlled += takes & (~given >> 1) & 1u;", "*controlled += takes & (~given >> 1) & 0u;")
R('tested-list-next-record', LISTED_CONTROL, "= (uint16_t)o;", "= (uint16_t)(o + 1);")
R('tested-list-other-list', LISTED_CONTROL, "BUSTER_NODE_ROWS_LIST_CONTROLLED", "BUSTER_NODE_ROWS_LIST_REST")
SHAPE = "    state->window_x_owns[c] = (uint8_t)(BUSTER_NODE_ROWS_BRANCHED + past);"
R('branch-shape-never-labeled', SHAPE, "BUSTER_NODE_ROWS_BRANCHED + past", "BUSTER_NODE_ROWS_BRANCHED + past * 0")
R('branch-shape-always-labeled', SHAPE, "BUSTER_NODE_ROWS_BRANCHED + past", "BUSTER_NODE_ROWS_BRANCHED + 1 + past * 0")
R('branch-shape-other-way', SHAPE, "BUSTER_NODE_ROWS_BRANCHED + past", "BUSTER_NODE_ROWS_BRANCHED + 1 - past")
R('branch-shape-none', SHAPE, "(uint8_t)(BUSTER_NODE_ROWS_BRANCHED + past)", "(uint8_t)(past * 0)")
R('branch-shape-next-record', SHAPE, "state->window_x_owns[c] =", "state->window_x_owns[c + 1] =")
GIVEN = "    node_rows_window_tested(state, c - front->window_left[c], (last & (0u - negated)) | (either & (negated - 1u)) | owned | (past * BUSTER_NODE_ROWS_SENSE_OWNED), controlled);\n    node_rows_window_tested(state, c - 1, last | owned, controlled);"
R('branch-first-not-owned-by-it', GIVEN, " | (past * BUSTER_NODE_ROWS_SENSE_OWNED), controlled);", " | (past * 0), controlled);")
R('branch-first-always-owned', GIVEN, " | (past * BUSTER_NODE_ROWS_SENSE_OWNED), controlled);", " | (past * 0 + BUSTER_NODE_ROWS_SENSE_OWNED), controlled);")
R('branch-first-no-owner-above', GIVEN, " | owned | (past * BUSTER_NODE_ROWS_SENSE_OWNED)", " | (owned & 0) | (past * BUSTER_NODE_ROWS_SENSE_OWNED)")
R('branch-second-no-owner-above', GIVEN, "c - 1, last | owned, controlled);", "c - 1, last | (owned & 0), controlled);")
R('branch-second-owned-by-it', GIVEN, "c - 1, last | owned, controlled);", "c - 1, last | owned | (past * BUSTER_NODE_ROWS_SENSE_OWNED), controlled);")

# ---- The reader: an expression's end's bit and its number; the batch's end.
TOP = "                    state->window_x_senses[operand] = (uint8_t)(state->c_sense_now | BUSTER_NODE_ROWS_SENSE_TOP);\n                    state->window_x_expressions[operand] = (uint16_t)e;"
R('reader-no-end', TOP, "(state->c_sense_now | BUSTER_NODE_ROWS_SENSE_TOP)", "(state->c_sense_now)", file=FACTS)
R('reader-end-at-next', TOP, "state->window_x_senses[operand] = (uint8_t)(state->c_sense_now | BUSTER_NODE_ROWS_SENSE_TOP);", "state->window_x_senses[operand] = state->c_sense_now;\n                    state->window_x_senses[operand + 1] |= BUSTER_NODE_ROWS_SENSE_TOP;", file=FACTS)
R('reader-expression-next', TOP, "= (uint16_t)e;", "= (uint16_t)(e + 1);", file=FACTS)
R('reader-expression-none', TOP, "= (uint16_t)e;", "= (uint16_t)(e * 0);", file=FACTS)
R('reader-expression-at-next', TOP, "state->window_x_expressions[operand] =", "state->window_x_expressions[operand + 1] =", file=FACTS)
CLEAR = "        for (uint32_t x = 0; x < front->count; x += 64)\n        {\n            _mm512_storeu_si512(state->window_x_senses + x, _mm512_setzero_si512());\n        }"
R('batch-end-not-cleared', CLEAR, "x < front->count;", "x < front->count * 0;", file=FACTS)
R('batch-end-first-block', CLEAR, "x < front->count;", "x < 64 && x < front->count;", file=FACTS)
R('batch-end-skips-first', CLEAR, "for (uint32_t x = 0;", "for (uint32_t x = 64;", file=FACTS)

# ---- The tests' sweep: a record's value.
DESIGNATES = "                const uint32_t designates = ~null;"
R('value-object-in-every-lane', DESIGNATES, "= ~null;", "= ~null | 0xffffu;", file=CENSUS)
R('value-object-of-none', DESIGNATES, "= ~null;", "= null;", file=CENSUS)
R('value-payload-always', DESIGNATES, "= ~null;", "= ~null & 0u;", file=CENSUS)
PAYLOADS = "    const __m512i payload_columns = _mm512_set_epi64(0, 0, 0, 0, 8 + 6, 8 + 2, 6, 2);"
R('value-payload-first-record-twice', PAYLOADS, "8 + 6, 8 + 2, 6, 2", "8 + 6, 8 + 2, 2, 2", file=CENSUS)
R('value-payload-third-record-twice', PAYLOADS, "8 + 6, 8 + 2, 6, 2", "8 + 2, 8 + 2, 6, 2", file=CENSUS)
R('value-payload-swapped', PAYLOADS, "8 + 6, 8 + 2, 6, 2", "8 + 6, 6, 8 + 2, 2", file=CENSUS)
R('value-payload-other-quadword', PAYLOADS, "8 + 6, 8 + 2, 6, 2", "8 + 7, 8 + 3, 7, 3", file=CENSUS)
R('value-payload-first-quadword', PAYLOADS, "8 + 6, 8 + 2, 6, 2", "8 + 5, 8 + 1, 5, 1", file=CENSUS)
LOW = "                value_low = _mm512_mask_mov_epi64(_mm512_inserti64x4(_mm512_castsi256_si512(payloads[0]), payloads[1], 1), (__mmask8)designates,\n                                                  _mm512_cvtepu32_epi64(_mm512_castsi512_si256(objects)));"
R('value-low-fours-swapped', LOW, "_mm512_castsi256_si512(payloads[0]), payloads[1], 1)", "_mm512_castsi256_si512(payloads[1]), payloads[0], 1)", file=CENSUS)
R('value-low-objects-high', LOW, "_mm512_cvtepu32_epi64(_mm512_castsi512_si256(objects))", "_mm512_cvtepu32_epi64(_mm512_extracti64x4_epi64(objects, 1))", file=CENSUS)
R('value-low-mask-high', LOW, "(__mmask8)designates,", "(__mmask8)(designates >> 8),", file=CENSUS)
R('value-low-signed', LOW, "_mm512_cvtepu32_epi64(_mm512_castsi512_si256(objects))", "_mm512_cvtepi32_epi64(_mm512_castsi512_si256(objects))", file=CENSUS)
HIGH = "                value_high = _mm512_mask_mov_epi64(_mm512_inserti64x4(_mm512_castsi256_si512(payloads[2]), payloads[3], 1), (__mmask8)(designates >> 8),\n                                                   _mm512_cvtepu32_epi64(_mm512_extracti64x4_epi64(objects, 1)));"
R('value-high-fours-swapped', HIGH, "_mm512_castsi256_si512(payloads[2]), payloads[3], 1)", "_mm512_castsi256_si512(payloads[3]), payloads[2], 1)", file=CENSUS)
R('value-high-objects-low', HIGH, "_mm512_cvtepu32_epi64(_mm512_extracti64x4_epi64(objects, 1))", "_mm512_cvtepu32_epi64(_mm512_castsi512_si256(objects))", file=CENSUS)
R('value-high-mask-low', HIGH, "(__mmask8)(designates >> 8),", "(__mmask8)designates,", file=CENSUS)
STORES = "            _mm512_storeu_si512(state->window_x_values + x, value_low);\n            _mm512_storeu_si512(state->window_x_values + x + 8, value_high);"
R('value-stores-swapped', STORES, "x, value_low);\n            _mm512_storeu_si512(state->window_x_values + x + 8, value_high);", "x, value_high);\n            _mm512_storeu_si512(state->window_x_values + x + 8, value_low);", file=CENSUS)
R('value-high-not-stored', STORES, "state->window_x_values + x + 8, value_high);", "state->window_x_values + x + 8, _mm512_andnot_si512(value_high, value_high));", file=CENSUS)

# ---- C's loop: a pointer's stride kept.
KEPT_STRIDE = "    state->window_c_strides[x] = stride;\n    return stride != 0;"
R('stride-not-kept', KEPT_STRIDE, "state->window_c_strides[x] = stride;", "state->window_c_strides[x] = stride * 0;", file=WINDOW)
R('stride-kept-at-next', KEPT_STRIDE, "state->window_c_strides[x] = stride;", "state->window_c_strides[x + 1] = stride;", file=WINDOW)
R('stride-kept-narrow', KEPT_STRIDE, "state->window_c_strides[x] = stride;", "state->window_c_strides[x] = (uint32_t)stride;", file=WINDOW)
ASKED = "    return pointer != 0 ? check_action_pointer_stride(facts->machine->types, pointer) : 0;"
R('stride-asked-a-truth', ASKED, "check_action_pointer_stride(facts->machine->types, pointer) : 0;", "(check_action_pointer_stride(facts->machine->types, pointer) != 0 ? 1u : 0u) : 0;", file=WINDOW)

# ---- The values: the fill.
FILL = "        const uint64_t sums = _mm512_cmpeq_epi8_mask(_mm512_loadu_si512(state->x_kinds + at), _mm512_set1_epi8(BUSTER_TYPED_PTR_ADD));\n        for (uint32_t eight = 0; eight < 8; eight += 1)\n        {\n            _mm512_storeu_si512(values + at + 8 * eight, _mm512_maskz_mov_epi64((__mmask8)(sums >> (8 * eight)), ones));\n        }"
R('fill-no-ones', FILL, "_mm512_set1_epi8(BUSTER_TYPED_PTR_ADD));", "_mm512_set1_epi8(BUSTER_TYPED_KINDS));")
R('fill-ones-of-adds', FILL, "_mm512_set1_epi8(BUSTER_TYPED_PTR_ADD));", "_mm512_set1_epi8(BUSTER_TYPED_ADD));")
R('fill-ones-of-consts', FILL, "_mm512_set1_epi8(BUSTER_TYPED_PTR_ADD));", "_mm512_set1_epi8(BUSTER_TYPED_CONST));")
R('fill-first-eight-s-mask', FILL, "(__mmask8)(sums >> (8 * eight))", "(__mmask8)(sums)")
R('fill-next-eight-s-mask', FILL, "(__mmask8)(sums >> (8 * eight))", "(__mmask8)(sums >> (8 * ((eight + 1) & 7)))")
R('fill-kinds-of-the-first-step', FILL, "state->x_kinds + at)", "state->x_kinds + at * 0)")
R('fill-seven-eights', FILL, "eight < 8;", "eight < 7;")
R('fill-twos', "    const __m512i ones = _mm512_set1_epi64(1);", "_mm512_set1_epi64(1)", "_mm512_set1_epi64(2)")
FILL_LOOP = "    for (uint32_t at = 0; at < written; at += 64)\n    {\n        const uint64_t sums"
R('fill-short', FILL_LOOP, "at < written;", "at + 64 < written;")
R('fill-first-step-alone', FILL_LOOP, "at < written;", "at < written && at < 64;")

# ---- The values: the sweep's masks and lists.
CONST_MASK = "        const __mmask64 floating = constant & _mm512_cmpge_epu8_mask(classes, _mm512_set1_epi8(BUSTER_TYPED_CLASS_F32));"
R('sweep-floating-from-double', CONST_MASK, "BUSTER_TYPED_CLASS_F32", "BUSTER_TYPED_CLASS_F64")
R('sweep-floating-from-u64', CONST_MASK, "BUSTER_TYPED_CLASS_F32", "BUSTER_TYPED_CLASS_U64")
R('sweep-floating-none', CONST_MASK, "_mm512_cmpge_epu8_mask(classes,", "_mm512_cmplt_epu8_mask(classes,")
BOOL_MASK = "        const __mmask64 to_bool = folded & _mm512_test_epi8_mask(to_facts, _mm512_set1_epi8(BUSTER_CHECK_LOWER_TYPE_BOOL));"
R('sweep-to-bool-plain-too', BOOL_MASK, "folded & _mm512_test_epi8_mask", "_mm512_test_epi8_mask")
R('sweep-to-bool-none', BOOL_MASK, "_mm512_test_epi8_mask(to_facts,", "_mm512_testn_epi8_mask(to_facts,")
R('sweep-to-bool-every-folded', BOOL_MASK, "folded & _mm512_test_epi8_mask(to_facts, _mm512_set1_epi8(BUSTER_CHECK_LOWER_TYPE_BOOL))", "folded | (_mm512_test_epi8_mask(to_facts, _mm512_set1_epi8(BUSTER_CHECK_LOWER_TYPE_BOOL)) & 0)")
R('sweep-to-bool-by-pointer', BOOL_MASK, "BUSTER_CHECK_LOWER_TYPE_BOOL", "BUSTER_CHECK_LOWER_TYPE_POINTER")
FACTS_LOAD = "        const __m512i to_facts = _mm512_loadu_si512(state->window_x_facts + x);"
R('sweep-facts-own', FACTS_LOAD, "state->window_x_facts + x)", "state->window_c_facts + x)")
R('sweep-facts-first-block', FACTS_LOAD, "state->window_x_facts + x)", "state->window_x_facts)")
FOLDED = "        const __mmask64 folded = _mm512_cmpeq_epi8_mask(owns, _mm512_set1_epi8(BUSTER_NODE_ROWS_FOLDED));"
R('sweep-folded-none', FOLDED, "BUSTER_NODE_ROWS_FOLDED", "BUSTER_NODE_ROWS_CONVERT")
R('sweep-folded-plain', FOLDED, "BUSTER_NODE_ROWS_FOLDED", "BUSTER_TYPED_CONST")
L_FIRST = "        first_count = node_rows_listed(firsts, first_count, _mm512_test_epi8_mask(lists, _mm512_set1_epi8(BUSTER_NODE_ROWS_VALUE_FIRST)), places, base);"
R('sweep-first-list-stored', L_FIRST, "BUSTER_NODE_ROWS_VALUE_FIRST", "BUSTER_NODE_ROWS_VALUE_STORED")
L_STORED = "        stored_count = node_rows_listed(stored, stored_count, _mm512_test_epi8_mask(lists, _mm512_set1_epi8(BUSTER_NODE_ROWS_VALUE_STORED)), places, base);"
R('sweep-stored-list-first', L_STORED, "BUSTER_NODE_ROWS_VALUE_STORED", "BUSTER_NODE_ROWS_VALUE_FIRST")
L_CONSTANT = "        constant_count = node_rows_listed(constants, constant_count, constant & ~floating & ~to_bool, places, base);"
R('sweep-constants-with-floats', L_CONSTANT, "constant & ~floating & ~to_bool", "constant & ~to_bool")
R('sweep-constants-with-bools', L_CONSTANT, "constant & ~floating & ~to_bool", "constant & ~floating")
R('sweep-constants-none', L_CONSTANT, "constant & ~floating & ~to_bool", "constant & floating & to_bool")
L_STRIDE = "        stride_count = node_rows_listed(strides, stride_count, _mm512_test_epi8_mask(lists, _mm512_set1_epi8(BUSTER_NODE_ROWS_VALUE_STRIDE)), places, base);"
R('sweep-stride-list-rest', L_STRIDE, "BUSTER_NODE_ROWS_VALUE_STRIDE", "BUSTER_NODE_ROWS_VALUE_REST")
L_REST = "        rest_count = node_rows_listed(rest, rest_count, _mm512_test_epi8_mask(lists, _mm512_set1_epi8(BUSTER_NODE_ROWS_VALUE_REST)) | floating | to_bool, places, base);"
R('sweep-rest-no-floats', L_REST, " | floating | to_bool", " | to_bool")
R('sweep-rest-no-bools', L_REST, " | floating | to_bool", " | floating")
R('sweep-rest-no-offsets', L_REST, "_mm512_test_epi8_mask(lists, _mm512_set1_epi8(BUSTER_NODE_ROWS_VALUE_REST)) | floating | to_bool", "floating | to_bool")
R('sweep-rest-constants', L_REST, "BUSTER_NODE_ROWS_VALUE_REST", "BUSTER_NODE_ROWS_VALUE_CONSTANT")
LOOKUP = "        const __m512i lists = node_window_table(tables->value_owns, owns);"
R('sweep-table-slots', LOOKUP, "tables->value_owns", "tables->value_slots")
OWNS = "        const __m512i owns = _mm512_loadu_si512(state->window_x_owns + x);\n        const __m512i classes = _mm512_loadu_si512(state->window_c_classes + x);\n        const __m512i senses = _mm512_loadu_si512(state->window_x_senses + x);"
R('sweep-owns-first-block', OWNS, "state->window_x_owns + x);", "state->window_x_owns);")
R('sweep-owns-conversions', OWNS, "state->window_x_owns + x);", "state->window_x_conversions + x);")
R('sweep-classes-first-block', OWNS, "state->window_c_classes + x);", "state->window_c_classes);")
R('sweep-classes-targets', OWNS, "state->window_c_classes + x);", "state->window_x_targets + x);")
R('sweep-senses-first-block', OWNS, "state->window_x_senses + x);", "state->window_x_senses);")
BASE = "        const __m512i base = _mm512_set1_epi16((int16_t)x);"
R('sweep-base-none', BASE, "(int16_t)x", "(int16_t)(x * 0)")
R('sweep-base-next-block', BASE, "(int16_t)x", "(int16_t)(x + 64)")
LISTED = "    const __m512i packed = _mm512_maskz_compress_epi8(mask, places);\n    const uint32_t more = (uint32_t)_mm_popcnt_u64(mask);\n    _mm512_storeu_si512(list + count, _mm512_add_epi16(base, _mm512_cvtepu8_epi16(_mm512_castsi512_si256(packed))));\n    if (__builtin_expect(more > 32, 0))\n    {\n        _mm512_storeu_si512(list + count + 32, _mm512_add_epi16(base, _mm512_cvtepu8_epi16(_mm512_extracti64x4_epi64(packed, 1))));\n    }\n    return count + more;"
R('listed-no-second-store', LISTED, "more > 32", "more > 64")
R('listed-second-store-late', LISTED, "more > 32", "more > 33")
R('listed-second-half-first', LISTED, "_mm512_cvtepu8_epi16(_mm512_extracti64x4_epi64(packed, 1))", "_mm512_cvtepu8_epi16(_mm512_castsi512_si256(packed))")
R('listed-second-no-base', LISTED, "list + count + 32, _mm512_add_epi16(base, ", "list + count + 32, _mm512_add_epi16(_mm512_setzero_si512(), ")
R('listed-second-store-place', LISTED, "list + count + 32,", "list + count + 31,")
R('listed-first-no-base', LISTED, "list + count, _mm512_add_epi16(base, ", "list + count, _mm512_add_epi16(_mm512_setzero_si512(), ")
R('listed-not-compressed', LISTED, "_mm512_maskz_compress_epi8(mask, places)", "_mm512_maskz_mov_epi8(mask, places)")
R('listed-count-one-short', LISTED, "return count + more;", "return count + more - (more != 0 ? 1u : 0u);")
R('listed-count-stays', LISTED, "return count + more;", "return count + more * 0;")

# ---- The values: the seconds.
MARKS = "        const uint64_t marks = _mm512_test_epi8_mask(lists, _mm512_set1_epi8((char)BUSTER_NODE_ROWS_VALUE_NUMBERED));\n        const uint64_t ends = _mm512_test_epi8_mask(senses, _mm512_set1_epi8((char)BUSTER_NODE_ROWS_SENSE_TOP));"
R('seconds-marks-of-firsts', MARKS, "BUSTER_NODE_ROWS_VALUE_NUMBERED", "BUSTER_NODE_ROWS_VALUE_FIRST")
R('seconds-no-ends', MARKS, "_mm512_test_epi8_mask(senses, _mm512_set1_epi8((char)BUSTER_NODE_ROWS_SENSE_TOP))", "_mm512_test_epi8_mask(senses, _mm512_set1_epi8((char)BUSTER_NODE_ROWS_SENSE_TOP)) & 0")
R('seconds-ends-by-sense', MARKS, "BUSTER_NODE_ROWS_SENSE_TOP", "BUSTER_NODE_ROWS_SENSE_TRUE")
R('seconds-ends-by-owner', MARKS, "BUSTER_NODE_ROWS_SENSE_TOP", "BUSTER_NODE_ROWS_SENSE_OWNED")
ARITH = "        const uint64_t first_marks = marks & ~(marks - ((ends << 1) | 1));\n        const uint64_t lowest = first_marks & (0 - first_marks);\n        const uint64_t lowest_end = ends & (0 - ends);\n        const uint64_t going_on = lowest & (0 - open) & (0 - (uint64_t)(lowest - 1 <= lowest_end - 1 ? 1 : 0));\n        uint64_t later = (marks & ~first_marks) | going_on;\n        const uint64_t after = ends == 0 ? marks : marks >> (63 - (uint32_t)_lzcnt_u64(ends)) >> 1;\n        open = (after != 0 ? 1u : 0u) | (ends == 0 ? open : 0u);"
R('seconds-starts-at-ends', ARITH, "((ends << 1) | 1)", "(ends | 1)")
R('seconds-no-first-start', ARITH, "((ends << 1) | 1)", "(ends << 1)")
R('seconds-starts-two-on', ARITH, "((ends << 1) | 1)", "((ends << 2) | 1)")
R('seconds-first-none', ARITH, "marks & ~(marks - ((ends << 1) | 1));", "marks & (marks - ((ends << 1) | 1));")
R('seconds-first-of-block', ARITH, "marks & ~(marks - ((ends << 1) | 1));", "marks & (0 - marks) & (ends | ~ends);")
R('seconds-lowest-all', ARITH, "const uint64_t lowest = first_marks & (0 - first_marks);", "const uint64_t lowest = first_marks;")
R('seconds-lowest-end-all', ARITH, "const uint64_t lowest_end = ends & (0 - ends);", "const uint64_t lowest_end = ends;")
R('seconds-going-on-always', ARITH, "lowest & (0 - open) & ", "lowest & ")
R('seconds-going-on-never', ARITH, "lowest & (0 - open) & ", "lowest & (0 - open) & 0 & ")
R('seconds-going-on-past-end', ARITH, " & (0 - (uint64_t)(lowest - 1 <= lowest_end - 1 ? 1 : 0));", " & (0 - (uint64_t)(lowest - 1 <= lowest_end - 1 ? 1 : 1));")
R('seconds-going-on-before-end-alone', ARITH, "lowest - 1 <= lowest_end - 1", "lowest - 1 < lowest_end - 1")
R('seconds-later-no-going-on', ARITH, "(marks & ~first_marks) | going_on;", "(marks & ~first_marks) | (going_on & 0);")
R('seconds-later-the-firsts', ARITH, "(marks & ~first_marks) | going_on;", "(marks & first_marks) | going_on;")
R('seconds-later-every-mark', ARITH, "(marks & ~first_marks) | going_on;", "marks | (first_marks & 0) | going_on;")
R('seconds-after-whole-block', ARITH, "ends == 0 ? marks : marks >> (63 - (uint32_t)_lzcnt_u64(ends)) >> 1;", "ends == 0 ? marks : marks;")
R('seconds-after-from-the-end', ARITH, "marks >> (63 - (uint32_t)_lzcnt_u64(ends)) >> 1;", "marks >> (63 - (uint32_t)_lzcnt_u64(ends));")
R('seconds-after-from-first-end', ARITH, "marks >> (63 - (uint32_t)_lzcnt_u64(ends)) >> 1;", "marks >> (uint32_t)_tzcnt_u64(ends) >> 1;")
R('seconds-after-none-without-end', ARITH, "ends == 0 ? marks : marks >>", "ends == 0 ? marks * 0 : marks >>")
R('seconds-open-never', ARITH, "open = (after != 0 ? 1u : 0u) | (ends == 0 ? open : 0u);", "open = (after != 0 ? 0u : 0u) | (ends == 0 ? open : 0u);")
R('seconds-open-forgotten', ARITH, "| (ends == 0 ? open : 0u);", "| (ends == 0 ? open * 0 : 0u);")
R('seconds-open-kept-past-end', ARITH, "| (ends == 0 ? open : 0u);", "| (ends == 0 ? open : open);")
R('seconds-open-always', ARITH, "open = (after != 0 ? 1u : 0u)", "open = (after != 0 ? 1u : 1u)")
PUSH = "            seconds[second_count] = (uint16_t)(x + (uint32_t)_tzcnt_u64(later));\n            second_count += 1;\n            later &= later - 1;"
R('seconds-pushed-without-block', PUSH, "(uint16_t)(x + (uint32_t)_tzcnt_u64(later))", "(uint16_t)((uint32_t)_tzcnt_u64(later))")
R('seconds-pushed-block-start', PUSH, "(uint16_t)(x + (uint32_t)_tzcnt_u64(later))", "(uint16_t)(x + 0 * (uint32_t)_tzcnt_u64(later))")
KEEP_MASKS = "        state->window_x_marks[block] = marks;\n        state->window_x_ends[block] = ends;"
R('seconds-marks-kept-first', KEEP_MASKS, "state->window_x_marks[block] = marks;", "state->window_x_marks[0] = marks;")
R('seconds-ends-kept-first', KEEP_MASKS, "state->window_x_ends[block] = ends;", "state->window_x_ends[0] = ends;")
R('seconds-marks-kept-ends', KEEP_MASKS, "state->window_x_marks[block] = marks;", "state->window_x_marks[block] = ends | (marks & 0);")
OPEN0 = "    uint64_t open = 0;\n    for (uint32_t block = 0; block < blocks; block += 1)\n    {\n        const uint32_t x = block * 64;\n        const __m512i owns = _mm512_loadu_si512(state->window_x_owns + x);\n        const __m512i classes = _mm512_loadu_si512(state->window_c_classes + x);\n        const __m512i senses"
R('seconds-open-at-first', OPEN0, "uint64_t open = 0;", "uint64_t open = 1;")

# ---- The values: the loops.
L1 = "        const uint32_t x = firsts[i];\n        values[cursors[x / 8] + offsets[x]] = record_values[x];"
R('first-no-eight', L1, "cursors[x / 8] + offsets[x]", "cursors[0] + offsets[x]")
R('first-no-offset', L1, "cursors[x / 8] + offsets[x]", "cursors[x / 8] + offsets[x & ~7u]")
R('first-next-entry', L1, "cursors[x / 8] + offsets[x]]", "cursors[x / 8] + offsets[x] + 1]")
R('first-next-record-s', L1, "= record_values[x];", "= record_values[x + 1];")
R('first-low-half', L1, "= record_values[x];", "= (uint32_t)record_values[x];")
L2 = "        const uint32_t x = stored[i];\n        values[cursors[x / 8] + offsets[x]] = record_values[x - lefts[x]];"
R('stored-own-record-s', L2, "record_values[x - lefts[x]]", "record_values[x]")
R('stored-the-record-before-s', L2, "record_values[x - lefts[x]]", "record_values[x - 1]")
R('stored-no-eight', L2, "cursors[x / 8] + offsets[x]", "cursors[0] + offsets[x]")
R('stored-next-entry', L2, "cursors[x / 8] + offsets[x]]", "cursors[x / 8] + offsets[x] + 1]")
L3 = "        const uint32_t x = constants[i];\n        const uint32_t place = cursors[x / 8] + offsets[x];\n        values[place] = node_rows_extend(node_rows_extend(record_values[x], own_classes[x]), entry_classes[place]);"
R('constant-not-its-own-class-first', L3, "node_rows_extend(node_rows_extend(record_values[x], own_classes[x]), entry_classes[place])", "node_rows_extend(record_values[x], entry_classes[place] | (own_classes[x] & 0))")
R('constant-not-its-entry-s-class', L3, "node_rows_extend(node_rows_extend(record_values[x], own_classes[x]), entry_classes[place])", "node_rows_extend(record_values[x], own_classes[x] | (entry_classes[place] & 0))")
R('constant-own-class-twice', L3, "entry_classes[place]);", "own_classes[x] | (entry_classes[place] & 0));")
R('constant-entry-class-twice', L3, "record_values[x], own_classes[x])", "record_values[x], entry_classes[place] | (own_classes[x] & 0))")
R('constant-next-entry-s-class', L3, "entry_classes[place]);", "entry_classes[place + 1]);")
R('constant-no-eight', L3, "cursors[x / 8] + offsets[x];", "cursors[0] + offsets[x];")
R('constant-next-record-s', L3, "record_values[x], own_classes[x]", "record_values[x + 1], own_classes[x]")
EXTEND = "    static const uint8_t shifts[16] = { 0, 56, 56, 48, 48, 32, 32, 0, 0, 0, 0, 0, 0, 0, 0, 0 };\n    const uint32_t shift = shifts[class & 15u];\n    const uint64_t high = bits << shift;\n    return (class & 1u) != 0 ? (uint64_t)((int64_t)high >> shift) : high >> shift;"
R('extend-i8-wide', EXTEND, "{ 0, 56, 56, 48,", "{ 0, 48, 56, 48,")
R('extend-u8-wide', EXTEND, "{ 0, 56, 56, 48,", "{ 0, 56, 48, 48,")
R('extend-i16-wide', EXTEND, "56, 56, 48, 48, 32,", "56, 56, 32, 48, 32,")
R('extend-u16-wide', EXTEND, "56, 56, 48, 48, 32,", "56, 56, 48, 32, 32,")
R('extend-i32-whole', EXTEND, "48, 48, 32, 32, 0,", "48, 48, 0, 32, 0,")
R('extend-u32-whole', EXTEND, "48, 48, 32, 32, 0,", "48, 48, 32, 0, 0,")
R('extend-i64-cut', EXTEND, "32, 32, 0, 0, 0, 0, 0, 0, 0, 0, 0 };", "32, 32, 32, 0, 0, 0, 0, 0, 0, 0, 0 };")
R('extend-u64-cut', EXTEND, "32, 32, 0, 0, 0, 0, 0, 0, 0, 0, 0 };", "32, 32, 0, 32, 0, 0, 0, 0, 0, 0, 0 };")
R('extend-always-signed', EXTEND, "(class & 1u) != 0 ? (uint64_t)((int64_t)high >> shift) : high >> shift;", "(class & 1u) != 0 ? (uint64_t)((int64_t)high >> shift) : (uint64_t)((int64_t)high >> shift);")
R('extend-never-signed', EXTEND, "(class & 1u) != 0 ? (uint64_t)((int64_t)high >> shift) : high >> shift;", "(class & 1u) != 0 ? high >> shift : high >> shift;")
R('extend-sign-swapped', EXTEND, "(class & 1u) != 0 ?", "(class & 1u) == 0 ?")
L4 = "        const uint32_t x = strides[i];\n        const uint32_t place = cursors[x / 8] + offsets[x];\n        const uint32_t slots = tables->value_slots[owns[x]];\n        values[place] = (slots & BUSTER_NODE_ROWS_SLOT_STEP) != 0 ? 1u : 0u;\n        values[place + (slots & BUSTER_NODE_ROWS_SLOT_STRIDE)] = record_strides[x];"
R('stride-no-step', L4, "(slots & BUSTER_NODE_ROWS_SLOT_STEP) != 0 ? 1u : 0u;", "(slots & BUSTER_NODE_ROWS_SLOT_STEP) != 0 ? 0u : 0u;")
R('stride-step-always', L4, "(slots & BUSTER_NODE_ROWS_SLOT_STEP) != 0 ? 1u : 0u;", "(slots & BUSTER_NODE_ROWS_SLOT_STEP) != 0 ? 1u : 1u;")
R('stride-step-of-two', L4, "(slots & BUSTER_NODE_ROWS_SLOT_STEP) != 0 ? 1u : 0u;", "(slots & BUSTER_NODE_ROWS_SLOT_STEP) != 0 ? 2u : 0u;")
R('stride-in-first-entry', L4, "values[place + (slots & BUSTER_NODE_ROWS_SLOT_STRIDE)]", "values[place + (slots & 0)]")
R('stride-in-next-entry', L4, "values[place + (slots & BUSTER_NODE_ROWS_SLOT_STRIDE)]", "values[place + (slots & BUSTER_NODE_ROWS_SLOT_STRIDE) + 1]")
R('stride-slot-low-bit', L4, "(slots & BUSTER_NODE_ROWS_SLOT_STRIDE)]", "(slots & 1u)]")
R('stride-next-record-s', L4, "= record_strides[x];", "= record_strides[x + 1];")
R('stride-low-half', L4, "= record_strides[x];", "= (uint32_t)record_strides[x];")
R('stride-a-record-s-value', L4, "= record_strides[x];", "= record_values[x] | (record_strides[x] & 0);")
R('stride-no-eight', L4, "cursors[x / 8] + offsets[x];\n        const uint32_t slots", "cursors[0] + offsets[x];\n        const uint32_t slots")
R('stride-shape-of-first-record', L4, "tables->value_slots[owns[x]]", "tables->value_slots[owns[0] | (owns[x] & 0)]")
L5 = "        const uint32_t x = controlled[i];\n        values[cursors[x / 8] + offsets[x] + lengths[x] - 1u] = BUSTER_NODE_MACHINE_CONTROL_LABEL;"
R('control-past-the-row', L5, "lengths[x] - 1u]", "lengths[x]]")
R('control-first-entry', L5, "+ lengths[x] - 1u]", "+ (lengths[x] & 0)]")
R('control-before-last', L5, "lengths[x] - 1u]", "lengths[x] - 2u]")
R('control-no-label', L5, "= BUSTER_NODE_MACHINE_CONTROL_LABEL;", "= BUSTER_NODE_MACHINE_CONTROL_LABEL & 0;")
R('control-a-temporary', L5, "= BUSTER_NODE_MACHINE_CONTROL_LABEL;", "= BUSTER_NODE_MACHINE_TEMPORARY;")
R('control-none', "    const uint32_t controlled_count = made->controlled;", "made->controlled;", "made->controlled * 0;")
R('control-one-short', "    const uint32_t controlled_count = made->controlled;", "made->controlled;", "made->controlled - (made->controlled != 0 ? 1u : 0u);")
L6 = "        const uint64_t one = class == BUSTER_TYPED_CLASS_F32 ? UINT32_C(0x3f800000) : class == BUSTER_TYPED_CLASS_F64 ? UINT64_C(0x3ff0000000000000) : 1u;\n        // (Each of the two is written nowhere where the update has none: its kinds are no pattern a predictor learns.)\n        const uint32_t unstepped = own - (BUSTER_NODE_ROWS_UPDATE + 2) > 1u ? 1u : 0u;\n        const uint32_t through = stores[x] < BUSTER_TYPED_STORE_LOCAL ? 1u : 0u;\n        const uint32_t last = place + tables->lengths[own] - 1u;\n        values[place + ((BUSTER_NODE_ROWS_ENTRY_NOWHERE - place) & (0u - unstepped))] = one;\n        values[last + ((BUSTER_NODE_ROWS_ENTRY_NOWHERE - last) & (0u - through))] = record_values[destination];"
R('update-float-s-one-an-integer-s', L6, "class == BUSTER_TYPED_CLASS_F32 ? UINT32_C(0x3f800000) : ", "class == BUSTER_TYPED_CLASS_F32 ? 1u : ")
R('update-double-s-one-an-integer-s', L6, "class == BUSTER_TYPED_CLASS_F64 ? UINT64_C(0x3ff0000000000000) : 1u;", "class == BUSTER_TYPED_CLASS_F64 ? 1u : 1u;")
R('update-float-s-one-a-double-s', L6, "UINT32_C(0x3f800000)", "UINT64_C(0x3ff0000000000000)")
R('update-double-s-one-a-float-s', L6, "class == BUSTER_TYPED_CLASS_F64 ? UINT64_C(0x3ff0000000000000)", "class == BUSTER_TYPED_CLASS_F64 ? UINT32_C(0x3f800000)")
R('update-one-a-two', L6, "UINT64_C(0x3ff0000000000000) : 1u;", "UINT64_C(0x3ff0000000000000) : 2u;")
R('update-step-never', L6, "own - (BUSTER_NODE_ROWS_UPDATE + 2) > 1u ? 1u : 0u;", "own - (BUSTER_NODE_ROWS_UPDATE + 2) > 1u ? 1u : 1u;")
R('update-step-always', L6, "own - (BUSTER_NODE_ROWS_UPDATE + 2) > 1u ? 1u : 0u;", "own - (BUSTER_NODE_ROWS_UPDATE + 2) > 1u ? 0u : 0u;")
R('update-step-of-the-first-alone', L6, "own - (BUSTER_NODE_ROWS_UPDATE + 2) > 1u", "own - (BUSTER_NODE_ROWS_UPDATE + 2) > 0u")
R('update-step-of-pointers-too', L6, "own - (BUSTER_NODE_ROWS_UPDATE + 2) > 1u", "own - (BUSTER_NODE_ROWS_UPDATE + 2) > 5u")
R('update-step-of-the-unstepped', L6, "own - (BUSTER_NODE_ROWS_UPDATE + 2) > 1u", "own - BUSTER_NODE_ROWS_UPDATE > 1u")
R('update-store-never-by-name', L6, "stores[x] < BUSTER_TYPED_STORE_LOCAL ? 1u : 0u;", "stores[x] < BUSTER_TYPED_STORE_LOCAL ? 1u : 1u;")
R('update-store-always-by-name', L6, "stores[x] < BUSTER_TYPED_STORE_LOCAL ? 1u : 0u;", "stores[x] < BUSTER_TYPED_STORE_LOCAL ? 0u : 0u;")
R('update-store-globals-alone', L6, "stores[x] < BUSTER_TYPED_STORE_LOCAL", "stores[x] < BUSTER_TYPED_STORE_GLOBAL")
R('update-store-postfix-through', L6, "stores[x] < BUSTER_TYPED_STORE_LOCAL", "stores[x] < BUSTER_TYPED_SET")
R('update-store-before-last', L6, "tables->lengths[own] - 1u;", "tables->lengths[own] - 2u;")
R('update-store-past-last', L6, "tables->lengths[own] - 1u;", "tables->lengths[own];")
R('update-store-own-record-s', L6, "= record_values[destination];", "= record_values[x] | (record_values[destination] & 0);")
R('update-step-at-store', L6, "values[place + ((BUSTER_NODE_ROWS_ENTRY_NOWHERE - place) & (0u - unstepped))] = one;", "values[last + ((BUSTER_NODE_ROWS_ENTRY_NOWHERE - last) & (0u - unstepped))] = one;")
R('update-step-class-of-next', "        const uint8_t class = entry_classes[place];\n        const uint64_t one", "entry_classes[place];", "entry_classes[place + 1];")
DEST = "        const uint32_t destination = x - lefts[x];\n        const uint32_t own = owns[x];\n        const uint32_t kept = owns[destination];"
R('update-destination-before', DEST, "x - lefts[x];", "x - 1 - (lefts[x] & 0);")
R('update-kept-by-own', DEST, "const uint32_t kept = owns[destination];", "const uint32_t kept = owns[x] | (owns[destination] & 0);")
KEPT6 = "        if (__builtin_expect(kept >= BUSTER_NODE_ROWS_KEPT && kept < BUSTER_NODE_ROWS_KEPT_REST, 0))\n        {\n            uint64_t* six = values + cursors[destination / 8] + offsets[destination] + (tables->value_slots[kept] >> BUSTER_NODE_ROWS_SLOT_KEPT_SHIFT);\n            six[0] = BUSTER_NODE_MACHINE_TEMPORARY;\n            six[1] = BUSTER_NODE_MACHINE_TEMPORARY;\n            six[3] = BUSTER_NODE_MACHINE_TEMPORARY | 1;\n            six[4] = BUSTER_NODE_MACHINE_TEMPORARY;\n            six[5] = BUSTER_NODE_MACHINE_TEMPORARY | 1;\n        }"
R('kept-none', KEPT6, "kept >= BUSTER_NODE_ROWS_KEPT && kept < BUSTER_NODE_ROWS_KEPT_REST, 0", "kept >= BUSTER_NODE_ROWS_KEPT && kept < BUSTER_NODE_ROWS_KEPT, 0")
R('kept-not-the-first', KEPT6, "kept >= BUSTER_NODE_ROWS_KEPT &&", "kept > BUSTER_NODE_ROWS_KEPT &&")
R('kept-not-the-last', KEPT6, "kept < BUSTER_NODE_ROWS_KEPT_REST, 0", "kept < BUSTER_NODE_ROWS_KEPT_REST - 1, 0")
R('kept-with-the-rest', KEPT6, "kept < BUSTER_NODE_ROWS_KEPT_REST, 0", "kept < BUSTER_NODE_ROWS_TESTED, 0")
R('kept-from-first-rows', KEPT6, "kept >= BUSTER_NODE_ROWS_KEPT &&", "kept >= BUSTER_NODE_ROWS_FIRST &&")
R('kept-no-own-entries', KEPT6, " + (tables->value_slots[kept] >> BUSTER_NODE_ROWS_SLOT_KEPT_SHIFT);", " + ((tables->value_slots[kept] >> BUSTER_NODE_ROWS_SLOT_KEPT_SHIFT) & 0);")
R('kept-own-record-s-place', KEPT6, "cursors[destination / 8] + offsets[destination]", "cursors[x / 8] + offsets[x] + 0 * (cursors[destination / 8] + offsets[destination])")
R('kept-address-store-zero', KEPT6, "six[0] = BUSTER_NODE_MACHINE_TEMPORARY;", "six[0] = BUSTER_NODE_MACHINE_TEMPORARY & 0;")
R('kept-address-read-zero', KEPT6, "six[1] = BUSTER_NODE_MACHINE_TEMPORARY;", "six[1] = BUSTER_NODE_MACHINE_TEMPORARY & 0;")
R('kept-old-store-the-address-s', KEPT6, "six[3] = BUSTER_NODE_MACHINE_TEMPORARY | 1;", "six[3] = BUSTER_NODE_MACHINE_TEMPORARY | 0;")
R('kept-address-again-the-old-s', KEPT6, "six[4] = BUSTER_NODE_MACHINE_TEMPORARY;", "six[4] = BUSTER_NODE_MACHINE_TEMPORARY | 1;")
R('kept-old-read-the-address-s', KEPT6, "six[5] = BUSTER_NODE_MACHINE_TEMPORARY | 1;", "six[5] = BUSTER_NODE_MACHINE_TEMPORARY | 0;")
R('kept-load-a-temporary', KEPT6, "six[1] = BUSTER_NODE_MACHINE_TEMPORARY;\n", "six[1] = BUSTER_NODE_MACHINE_TEMPORARY;\n            six[2] = BUSTER_NODE_MACHINE_TEMPORARY;\n")
R('updates-none', "    const uint32_t update_count = (uint32_t)made->updates;", "(uint32_t)made->updates;", "(uint32_t)made->updates * 0;")
R('updates-one-short', "    const uint32_t update_count = (uint32_t)made->updates;", "(uint32_t)made->updates;", "(uint32_t)made->updates - (made->updates != 0 ? 1u : 0u);")

# ---- The rest's list.
RESTF = "    if (own == BUSTER_TYPED_CONST)\n    {\n        values[0] = node_rows_float_bits(record, state->x_classes[place]);\n    }\n    else if (own == BUSTER_NODE_ROWS_FOLDED)\n    {\n        // (A constant's payload is its value's bits of its class's width, or those extended: none is zero in them and\n        // not zero past them.)\n        values[0] = record->payload != 0 ? 1u : 0u;\n    }\n    else\n    {\n        values[1] = record->payload;\n    }"
R('rest-float-a-double-s', RESTF, "node_rows_float_bits(record, state->x_classes[place]);", "node_rows_float_bits(record, BUSTER_TYPED_CLASS_F64 | (state->x_classes[place] & 0));")
R('rest-float-a-float-s', RESTF, "node_rows_float_bits(record, state->x_classes[place]);", "node_rows_float_bits(record, BUSTER_TYPED_CLASS_F32 | (state->x_classes[place] & 0));")
R('rest-float-a-payload', RESTF, "values[0] = node_rows_float_bits(record, state->x_classes[place]);", "values[0] = record->payload + 0 * node_rows_float_bits(record, state->x_classes[place]);")
R('rest-bool-its-bits', RESTF, "values[0] = record->payload != 0 ? 1u : 0u;", "values[0] = record->payload;")
R('rest-bool-inverted', RESTF, "record->payload != 0 ? 1u : 0u;", "record->payload != 0 ? 0u : 1u;")
R('rest-bool-true', RESTF, "record->payload != 0 ? 1u : 0u;", "record->payload != 0 ? 1u : 1u;")
R('rest-offset-first-entry', RESTF, "values[1] = record->payload;", "values[0] = record->payload;")
R('rest-offset-third-entry', RESTF, "values[1] = record->payload;", "values[2] = record->payload;")
R('rest-offset-none', RESTF, "values[1] = record->payload;", "values[1] = record->payload * 0;")
R('rest-folded-as-plain', RESTF, "else if (own == BUSTER_NODE_ROWS_FOLDED)", "else if (own == BUSTER_NODE_ROWS_FOLDED + 1)")
FLOATF = "    if ((record->standing & BUSTER_NODE_MACHINE_FIELD) == BUSTER_NODE_MACHINE_FLOATING)\n    {\n        value.floating_storage[0] = record->payload;\n        value.floating_storage[1] = record->exponent;\n    }"
R('float-any-standing', FLOATF, "(record->standing & BUSTER_NODE_MACHINE_FIELD) == BUSTER_NODE_MACHINE_FLOATING", "(record->standing & BUSTER_NODE_MACHINE_FIELD) != BUSTER_NODE_MACHINE_OFFSET")
R('float-no-standing', FLOATF, "(record->standing & BUSTER_NODE_MACHINE_FIELD) == BUSTER_NODE_MACHINE_FLOATING", "(record->standing & BUSTER_NODE_MACHINE_FIELD) == BUSTER_NODE_MACHINE_OFFSET")
R('float-no-significand', FLOATF, "value.floating_storage[0] = record->payload;", "value.floating_storage[0] = record->payload & 0;")
R('float-no-exponent', FLOATF, "value.floating_storage[1] = record->exponent;", "value.floating_storage[1] = record->exponent & 0;")
R('float-no-sign', FLOATF, "value.floating_storage[1] = record->exponent;", "value.floating_storage[1] = record->exponent & 0x7fffu;")
R('rest-none', "    for (uint32_t i = 0; i < rest_count; i += 1)\n    {\n        node_rows_window_rest(state, rest[i]);\n    }", "i < rest_count;", "i < rest_count * 0;")

# ---- The numbering: which expression, and each number.
TOPS = "        const uint32_t x = seconds[i];\n        uint32_t word = x / 64;\n        uint64_t ends = state->window_x_ends[word] >> (x & 63) << (x & 63);\n        while (ends == 0)\n        {\n            word += 1;\n            ends = state->window_x_ends[word];\n        }\n        const uint32_t top = 64 * word + (uint32_t)_tzcnt_u64(ends);\n        if (top != top_before)\n        {\n            numbered_now += node_rows_window_number(state, front, top, steps) ? 1u : 0u;\n            top_before = top;\n        }"
R('number-end-of-the-block-s-first', TOPS, ">> (x & 63) << (x & 63);", ";")
R('number-end-after-it-alone', TOPS, ">> (x & 63) << (x & 63);", ">> (x & 63) >> 1 << (x & 63) << 1;")
R('number-end-word-stays', TOPS, "            word += 1;\n            ends = state->window_x_ends[word];", "            ends = state->window_x_ends[word + 1];\n            word += 1 - (ends != 0 ? 1u : 0u);")
R('number-end-without-word', TOPS, "64 * word + (uint32_t)_tzcnt_u64(ends);", "64 * (x / 64) + 0 * word + (uint32_t)_tzcnt_u64(ends);")
R('number-every-second', TOPS, "if (top != top_before)", "if (top != top_before || top == top_before)")
R('number-once-a-chunk', TOPS, "if (top != top_before)", "if (top != top_before && top_before == UINT32_MAX)")
R('number-not-counted', TOPS, "numbered_now += node_rows_window_number(state, front, top, steps) ? 1u : 0u;", "numbered_now += node_rows_window_number(state, front, top, steps) ? 0u : 0u;")
R('number-counted-whatever', TOPS, "numbered_now += node_rows_window_number(state, front, top, steps) ? 1u : 0u;", "numbered_now += node_rows_window_number(state, front, top, steps) ? 1u : 1u;")
R('number-none', "    for (uint32_t i = 0; i < second_count; i += 1)\n    {\n        const uint32_t x = seconds[i];", "i < second_count;", "i < second_count * 0;")
MARKED = "        const uint64_t from = word == first / 64 ? ~UINT64_C(0) << (first & 63) : ~UINT64_C(0);\n        const uint64_t through = word == top / 64 ? ~UINT64_C(0) >> (63 - (top & 63)) : ~UINT64_C(0);\n        for (uint64_t bits = state->window_x_marks[word] & from & through; bits != 0; bits &= bits - 1)\n        {\n            marked[marks] = (uint16_t)(64 * word + (uint32_t)_tzcnt_u64(bits));\n            marks += 1;\n        }"
R('number-marks-from-the-word-s-first', MARKED, "word == first / 64 ? ~UINT64_C(0) << (first & 63) : ~UINT64_C(0);", "word == first / 64 ? ~UINT64_C(0) : ~UINT64_C(0);")
R('number-marks-after-first', MARKED, "~UINT64_C(0) << (first & 63) : ~UINT64_C(0);", "~UINT64_C(0) << (first & 63) << 1 : ~UINT64_C(0);")
R('number-marks-through-the-word-s-last', MARKED, "word == top / 64 ? ~UINT64_C(0) >> (63 - (top & 63)) : ~UINT64_C(0);", "word == top / 64 ? ~UINT64_C(0) : ~UINT64_C(0);")
R('number-marks-before-top', MARKED, "~UINT64_C(0) >> (63 - (top & 63)) : ~UINT64_C(0);", "~UINT64_C(0) >> (63 - (top & 63)) >> 1 : ~UINT64_C(0);")
R('number-marks-without-word', MARKED, "(uint16_t)(64 * word + (uint32_t)_tzcnt_u64(bits));", "(uint16_t)(64 * (first / 64) + 0 * word + (uint32_t)_tzcnt_u64(bits));")
R('number-marks-first-word-alone', "    for (uint32_t word = first / 64; word <= top / 64; word += 1)", "word <= top / 64;", "word <= first / 64 && word <= top / 64;")
NUMBERS = "    const bool numbers = state->c_verdicts[e] == BUSTER_NODE_CONTEXTS_TAKEN && !node_contexts_window_any(state->window_c_masks, BUSTER_NODE_ROWS_MASK_LISTED, first, size);"
R('number-with-three', NUMBERS, "const bool numbers = ", "const bool numbers = marks >= 3 && ")
R('number-whatever-c-made', NUMBERS, "state->c_verdicts[e] == BUSTER_NODE_CONTEXTS_TAKEN && ", "(state->c_verdicts[e] == BUSTER_NODE_CONTEXTS_TAKEN || state->c_verdicts[e] != BUSTER_NODE_CONTEXTS_TAKEN) && ")
R('number-the-listed-too', NUMBERS, " && !node_contexts_window_any(state->window_c_masks, BUSTER_NODE_ROWS_MASK_LISTED, first, size);", " && (!node_contexts_window_any(state->window_c_masks, BUSTER_NODE_ROWS_MASK_LISTED, first, size) || size != 0);")
R('number-never', NUMBERS, "const bool numbers = ", "const bool numbers = e > UINT32_MAX - 1 && ")
EXPR = "    const uint32_t e = state->window_x_expressions[top];"
R('number-expression-of-the-first', EXPR, "state->window_x_expressions[top];", "state->window_x_expressions[top] * 0;")
CALLS = "                const uint32_t lowest = x + 1 - front->sizes[x];\n                uint32_t row = 0;\n                for (uint32_t j = 0; j < marks; j += 1)\n                {\n                    const uint32_t other = marked[j];\n                    const bool counted = other < lowest || (other > x && other + 1 - front->sizes[other] <= lowest);\n                    row += state->window_x_owns[other] == BUSTER_TYPED_CALL && counted ? 1u : 0u;\n                }\n                values[node_rows_window_place(state, x)] = row;"
R('call-row-no-calls-before', CALLS, "other < lowest || (other > x", "(other < lowest && other > x) || (other > x")
R('call-row-no-calls-around', CALLS, "other < lowest || (other > x && other + 1 - front->sizes[other] <= lowest);", "other < lowest || (other > x && other + 1 - front->sizes[other] <= lowest && other < lowest);")
R('call-row-every-call-before-it', CALLS, "other < lowest || (other > x", "(other < x || other < lowest) || (other > x")
R('call-row-every-call-after', CALLS, "(other > x && other + 1 - front->sizes[other] <= lowest)", "(other > x)")
R('call-row-counts-every-mark', CALLS, "state->window_x_owns[other] == BUSTER_TYPED_CALL && counted", "counted")
R('call-row-zero', CALLS, "values[node_rows_window_place(state, x)] = row;", "values[node_rows_window_place(state, x)] = row & 0;")
R('call-row-one-more', CALLS, "values[node_rows_window_place(state, x)] = row;", "values[node_rows_window_place(state, x)] = row + 1;")
R('call-row-its-subtree-s-size-one', CALLS, "const uint32_t lowest = x + 1 - front->sizes[x];\n                uint32_t row = 0;", "const uint32_t lowest = x + 0 * front->sizes[x];\n                uint32_t row = 0;")
R('call-row-holder-s-first-after', CALLS, "other + 1 - front->sizes[other] <= lowest)", "other + 1 - front->sizes[other] < lowest)")
TEMPS = "                kept[0] = BUSTER_NODE_MACHINE_TEMPORARY | temporaries;\n                kept[1] = BUSTER_NODE_MACHINE_TEMPORARY | temporaries;\n                kept[3] = BUSTER_NODE_MACHINE_TEMPORARY | (temporaries + 1);\n                kept[4] = BUSTER_NODE_MACHINE_TEMPORARY | temporaries;\n                kept[5] = BUSTER_NODE_MACHINE_TEMPORARY | (temporaries + 1);\n                temporaries += 2;"
R('temporaries-first-pair-again', TEMPS, "temporaries += 2;", "temporaries += 0;")
R('temporaries-one-apart', TEMPS, "temporaries += 2;", "temporaries += 1;")
R('temporaries-store-first-pair', TEMPS, "kept[0] = BUSTER_NODE_MACHINE_TEMPORARY | temporaries;", "kept[0] = BUSTER_NODE_MACHINE_TEMPORARY | (temporaries & 0);")
R('temporaries-read-first-pair', TEMPS, "kept[1] = BUSTER_NODE_MACHINE_TEMPORARY | temporaries;", "kept[1] = BUSTER_NODE_MACHINE_TEMPORARY | (temporaries & 0);")
R('temporaries-old-store-first-pair', TEMPS, "kept[3] = BUSTER_NODE_MACHINE_TEMPORARY | (temporaries + 1);", "kept[3] = BUSTER_NODE_MACHINE_TEMPORARY | 1 | (temporaries & 0);")
R('temporaries-again-first-pair', TEMPS, "kept[4] = BUSTER_NODE_MACHINE_TEMPORARY | temporaries;", "kept[4] = BUSTER_NODE_MACHINE_TEMPORARY | (temporaries & 0);")
R('temporaries-old-read-first-pair', TEMPS, "kept[5] = BUSTER_NODE_MACHINE_TEMPORARY | (temporaries + 1);", "kept[5] = BUSTER_NODE_MACHINE_TEMPORARY | 1 | (temporaries & 0);")
R('temporaries-no-own-entries', "                const uint32_t before = tables->value_slots[own] >> BUSTER_NODE_ROWS_SLOT_KEPT_SHIFT;\n                uint64_t* kept", ">> BUSTER_NODE_ROWS_SLOT_KEPT_SHIFT;", ">> BUSTER_NODE_ROWS_SLOT_KEPT_SHIFT >> 4;")
WALK_BOUNDS = "                const uint32_t lowest = x + 1 - front->sizes[x];\n                walk_first = lowest < walk_first ? lowest : walk_first;\n                walk_last = x;"
R('walk-from-the-last-s-first', WALK_BOUNDS, "walk_first = lowest < walk_first ? lowest : walk_first;", "walk_first = lowest;")
R('walk-from-the-first-s-record', WALK_BOUNDS, "const uint32_t lowest = x + 1 - front->sizes[x];", "const uint32_t lowest = x + 0 * front->sizes[x];")
R('walk-through-the-first', WALK_BOUNDS, "walk_last = x;", "walk_last = walk_last == 0 ? x : walk_last;")
R('walk-none', WALK_BOUNDS, "walk_last = x;", "walk_last = x * 0;")
WALK = "            const uint32_t own = state->window_x_owns[x];\n            if (own >= BUSTER_NODE_ROWS_BRANCHED)\n            {\n                owners[x - 1] = owners[x];\n                owners[x - front->window_left[x]] = own == BUSTER_NODE_ROWS_BRANCHED ? owners[x] : (uint16_t)x;\n            }"
R('walk-owner-second-none', WALK, "owners[x - 1] = owners[x];", "owners[x - 1] = owners[x - 1];")
R('walk-owner-second-the-operator', WALK, "owners[x - 1] = owners[x];", "owners[x - 1] = own == BUSTER_NODE_ROWS_BRANCHED ? owners[x] : (uint16_t)x;")
R('walk-owner-first-inherits', WALK, "own == BUSTER_NODE_ROWS_BRANCHED ? owners[x] : (uint16_t)x;\n            }", "own == BUSTER_NODE_ROWS_BRANCHED ? owners[x] : owners[x];\n            }")
R('walk-owner-first-always-it', WALK, "own == BUSTER_NODE_ROWS_BRANCHED ? owners[x] : (uint16_t)x;\n            }", "own == BUSTER_NODE_ROWS_BRANCHED ? (uint16_t)x : (uint16_t)x;\n            }")
R('walk-owner-first-swapped', WALK, "own == BUSTER_NODE_ROWS_BRANCHED ? owners[x] : (uint16_t)x;\n            }", "own != BUSTER_NODE_ROWS_BRANCHED ? owners[x] : (uint16_t)x;\n            }")
R('walk-labeled-alone', WALK, "if (own >= BUSTER_NODE_ROWS_BRANCHED)", "if (own > BUSTER_NODE_ROWS_BRANCHED)")
R('walk-first-operand-before', WALK, "owners[x - front->window_left[x]] =", "owners[x - 1 - (front->window_left[x] & 0)] =")
LABELS = "            if (state->window_x_conversions[x] >= BUSTER_NODE_ROWS_TESTED && (state->window_x_senses[x] & BUSTER_NODE_ROWS_SENSE_OWNED) != 0)\n            {\n                const uint32_t owner = owners[x];\n                const uint32_t lowest = owner + 1 - front->sizes[owner];\n                uint32_t label = 0;\n                for (uint32_t j = 0; j < marks; j += 1)\n                {\n                    const uint32_t other = marked[j];\n                    const bool counted = other < lowest || (other > owner && other + 1 - front->sizes[other] <= lowest);\n                    label += state->window_x_owns[other] == BUSTER_NODE_ROWS_BRANCHED + 1 && counted ? 1u : 0u;\n                }\n                values[node_rows_window_place(state, x) + state->window_x_lengths[x] - 1u] = label;\n            }"
R('label-of-the-control-s-too', LABELS, " && (state->window_x_senses[x] & BUSTER_NODE_ROWS_SENSE_OWNED) != 0)", " && (state->window_x_senses[x] & BUSTER_NODE_ROWS_SENSE_OWNED) == 0)")
R('label-by-sense', LABELS, "BUSTER_NODE_ROWS_SENSE_OWNED) != 0)", "BUSTER_NODE_ROWS_SENSE_TRUE) != 0)")
R('label-of-every-conversion', LABELS, "state->window_x_conversions[x] >= BUSTER_NODE_ROWS_TESTED && ", "state->window_x_conversions[x] >= BUSTER_TYPED_CONVERT && ")
R('label-no-labels-before', LABELS, "other < lowest || (other > owner", "(other < lowest && other > owner) || (other > owner")
R('label-no-labels-around', LABELS, "(other > owner && other + 1 - front->sizes[other] <= lowest);", "(other > owner && other + 1 - front->sizes[other] <= lowest && other < lowest);")
R('label-every-label-before-it', LABELS, "other < lowest || (other > owner", "(other < owner || other < lowest) || (other > owner")
R('label-holder-s-first-after', LABELS, "other + 1 - front->sizes[other] <= lowest)", "other + 1 - front->sizes[other] < lowest)")
R('label-every-label-after', LABELS, "(other > owner && other + 1 - front->sizes[other] <= lowest)", "(other > owner)")
R('label-counts-every-mark', LABELS, "state->window_x_owns[other] == BUSTER_NODE_ROWS_BRANCHED + 1 && counted", "counted")
R('label-zero', LABELS, "- 1u] = label;", "- 1u] = label & 0;")
R('label-one-more', LABELS, "- 1u] = label;", "- 1u] = label + 1;")
R('label-first-entry', LABELS, "+ state->window_x_lengths[x] - 1u] = label;", "+ (state->window_x_lengths[x] & 0)] = label;")
R('label-of-its-own-number', LABELS, "const uint32_t owner = owners[x];", "const uint32_t owner = x + 0 * owners[x];")
STEPS = "            *steps += 1;"
R('steps-not-counted', STEPS, "*steps += 1;", "*steps += 0;")
WALKLOOP = "        for (uint32_t x = walk_last + 1; x-- > walk_first;)"
R('walk-loop-misses-the-last', WALKLOOP, "x = walk_last + 1;", "x = walk_last;")
R('walk-loop-misses-the-first', WALKLOOP, "x-- > walk_first;", "x-- > walk_first + 1;")

# ---- The shadow's comparison, its control and its second run.
COMPARE = "            const uint64_t value = values[i] ^ (valued_turn && i == valued_entry ? bit : 0u);\n            differs = state->x_kinds[at] != kind || state->x_classes[at] != class;\n            value_differs = value_differs || state->x_values[at] != value;"
R('compare-no-value', COMPARE, "value_differs = value_differs || state->x_values[at] != value;", "value_differs = value_differs || (state->x_values[at] != value && at > UINT32_MAX - 1);")
R('compare-first-value-alone', COMPARE, "value_differs = value_differs || state->x_values[at] != value;", "value_differs = value_differs || (state->x_values[at] != value && i == 0);")
R('compare-last-value-alone', COMPARE, "value_differs = value_differs || state->x_values[at] != value;", "value_differs = state->x_values[at] != value;")
R('compare-value-low-half', COMPARE, "state->x_values[at] != value;", "(uint32_t)state->x_values[at] != (uint32_t)value;")
R('compare-value-high-half', COMPARE, "state->x_values[at] != value;", "(state->x_values[at] >> 32) != (value >> 32);")
R('compare-control-no-value-turn', COMPARE, "(valued_turn && i == valued_entry ? bit : 0u)", "(valued_turn && i == valued_entry ? bit & 0u : 0u)")
VALUED = "    *valued = !differs && value_differs;"
R('compare-valued-never', VALUED, "!differs && value_differs;", "!differs && value_differs && differs;")
R('compare-valued-with-kinds', VALUED, "!differs && value_differs;", "value_differs;")
COUNTED = "                const bool differs = node_rows_window_compare(state, front, e, &entries, &unkept, &valued) || valued;"
R('compare-value-not-a-difference', COUNTED, "&valued) || valued;", "&valued) || (valued && unkept);")
AGAIN = "    counts[NODE_FACTS_COUNT_ROWS_AGAIN_DIFFERENCES] += first_written != written_again || memcmp(state->x_first_kinds, state->x_kinds, written) != 0 ||\n                                                       memcmp(state->x_first_classes, state->x_classes, written) != 0 ||\n                                                       memcmp(state->x_first_values, state->x_values, (uint64_t)written * sizeof(uint64_t)) != 0 ||\n                                                       first_numbered != numbered_again || first_steps != steps_again ||\n                                                       memcmp(first_lists, lists_again, sizeof(first_lists)) != 0;"
R('again-written-not-compared', AGAIN, "first_written != written_again || ", "(first_written != written_again && written_again > UINT32_MAX - 1) || ")
R('again-kinds-not-compared', AGAIN, "memcmp(state->x_first_kinds, state->x_kinds, written) != 0", "memcmp(state->x_first_kinds, state->x_kinds, 0 * written) != 0")
R('again-classes-not-compared', AGAIN, "memcmp(state->x_first_classes, state->x_classes, written) != 0", "memcmp(state->x_first_classes, state->x_classes, 0 * written) != 0")
R('again-values-not-compared', AGAIN, "memcmp(state->x_first_values, state->x_values, (uint64_t)written * sizeof(uint64_t)) != 0 ||", "memcmp(state->x_first_values, state->x_values, 0 * (uint64_t)written * sizeof(uint64_t)) != 0 ||")
R('again-values-low-half-of-the-stream', AGAIN, "memcmp(state->x_first_values, state->x_values, (uint64_t)written * sizeof(uint64_t)) != 0 ||", "memcmp(state->x_first_values + written / 2, state->x_values + written / 2, (uint64_t)(written - written / 2) * sizeof(uint64_t)) != 0 ||")
R('again-numbered-not-compared', AGAIN, "first_numbered != numbered_again || ", "(first_numbered != numbered_again && written_again > UINT32_MAX - 1) || ")
R('again-steps-not-compared', AGAIN, "first_steps != steps_again ||", "(first_steps != steps_again && written_again > UINT32_MAX - 1) ||")
R('again-lists-not-compared', AGAIN, "sizeof(first_lists)) != 0;", "0 * sizeof(first_lists)) != 0;")
R('again-lists-not-the-last', AGAIN, "sizeof(first_lists)) != 0;", "sizeof(first_lists) - sizeof(uint32_t)) != 0;")
R('again-lists-not-the-first', AGAIN, "memcmp(first_lists, lists_again, sizeof(first_lists)) != 0;", "memcmp(first_lists + 1, lists_again + 1, sizeof(first_lists) - sizeof(uint32_t)) != 0;")
FIRSTCOPY = "    memcpy(state->x_first_kinds, state->x_kinds, written);\n    memcpy(state->x_first_classes, state->x_classes, written);\n    memcpy(state->x_first_values, state->x_values, (uint64_t)written * sizeof(uint64_t));"
R('again-first-kinds-not-kept', FIRSTCOPY, "memcpy(state->x_first_kinds, state->x_kinds, written);", "memcpy(state->x_first_kinds, state->x_kinds, 0 * written);")
R('again-first-classes-not-kept', FIRSTCOPY, "memcpy(state->x_first_classes, state->x_classes, written);", "memcpy(state->x_first_classes, state->x_classes, 0 * written);")
R('again-first-values-not-kept', FIRSTCOPY, "(uint64_t)written * sizeof(uint64_t));", "0 * (uint64_t)written * sizeof(uint64_t));")
SECONDS = "    listed[BUSTER_NODE_ROWS_LIST_SECOND] += second_count;"
R('seconds-not-counted', SECONDS, "+= second_count;", "+= 0 * second_count;")
out = [f for f in out if f is not None]
# The first round's survivors that change nothing a program reaches, and are no faults: each with why. They are left
# out of the list from the second round on.
NO_FAULTS = {
    'value-low-signed': "an object's number sign-extended into its record's value: its number is its declaring token's index and one (the reader's `objects[token] = token + 1`), so its bit 31 is a unit of more than two thousand million tokens'",
    'update-step-class-of-next': "an update's step's class read from the entry after it: that entry is the step's operation, of the class the step is computed in",
    'kept-with-the-rest': "a destination taken for a postfix update's through the kept rows' rest's shapes too: those are a conversion's part's, and no record's own part has one",
    'number-marks-after-first': "an expression's marked records taken from its operand's second record on: its first record is a leaf, and a marked record (a call, an operator with a label, an update's destination through an address) comes after an operand of its own",
    'label-of-every-conversion': "an owned record with any conversion's part taken for a tested value: the owner's bit is given to a tested value and to an operator evaluated as branches alone; such an operator has no conversion's part, and a tested value with a conversion of its own lists its expression, which is not numbered",
}
for name in NO_FAULTS:
    assert name in [f[0] for f in out], name
open(sys.argv[2] + '.no-faults.txt', 'w').write(''.join('%s: %s\n' % (name, why) for name, why in NO_FAULTS.items()))
out = [f for f in out if f[0] not in NO_FAULTS]
open(sys.argv[2], 'w').write('''#!/usr/bin/env python3
# faults-values.py TREE [N]: the entries' values' faults (make-faults-values.py). With no N, check every fault applies once and
# print how many; with N, apply fault N in TREE in place and print its name.
import sys
faults = %r
def apply(t, old, new, nth, name):
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
''' % (out,))
print(len(out))
