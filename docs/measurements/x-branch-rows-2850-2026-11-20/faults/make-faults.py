# make-faults.py TREE OUT: build OUT (a round's faults-branch-roundN.py), the branches' rows' faults in the frozen code: each term of the
# operand's rule and of an operator's turn, each of their stores, the second list's sweep, the chunk's guard, the
# reader's sense, each new row of the tables and the shadow's stronger check of a chunk's second run, changed alone.
import sys
tree = sys.argv[1] if len(sys.argv) > 1 else '/home/user/buster-x1'
ROWS = 'src/buster/compiler/c_check_node_machine_rows.c'
FACTS = 'src/buster/compiler/c_check_node_machine_facts.c'
READER = 'src/buster/compiler/c_check_node_machine_reader.c'
WINDOW = 'src/buster/compiler/c_check_node_machine_window.c'
texts = {f: open(tree + '/' + f).read() for f in (ROWS, FACTS, READER, WINDOW)}
out = []
def N(name, old, new, nth=None, file=ROWS):
    n = texts[file].count(old)
    assert (n == 1 if nth is None else n > nth), (name, n)
    assert name not in [f[0] for f in out], name
    assert old != new, name
    out.append((name, file, old, new, nth))
# The tables: a tested value's rows.
N('table-convert-kind', "                entries[count][0] = BUSTER_TYPED_CONVERT;\n                entries[count][1] = BUSTER_TYPED_CLASS_I32;\n                count += 1;\n            }\n            entries[count][0] = BUSTER_TYPED_CONST;\n            entries[count][1] = narrow != 0 ? BUSTER_TYPED_CLASS_I32 : BUSTER_NODE_ROWS_CLASS_OWN;",
  "                entries[count][0] = BUSTER_TYPED_CONST;\n                entries[count][1] = BUSTER_TYPED_CLASS_I32;\n                count += 1;\n            }\n            entries[count][0] = BUSTER_TYPED_CONST;\n            entries[count][1] = narrow != 0 ? BUSTER_TYPED_CLASS_I32 : BUSTER_NODE_ROWS_CLASS_OWN;")
N('table-convert-class', "                entries[count][0] = BUSTER_TYPED_CONVERT;\n                entries[count][1] = BUSTER_TYPED_CLASS_I32;\n                count += 1;\n            }\n            entries[count][0] = BUSTER_TYPED_CONST;\n            entries[count][1] = narrow != 0 ? BUSTER_TYPED_CLASS_I32 : BUSTER_NODE_ROWS_CLASS_OWN;",
  "                entries[count][0] = BUSTER_TYPED_CONVERT;\n                entries[count][1] = BUSTER_TYPED_CLASS_I64;\n                count += 1;\n            }\n            entries[count][0] = BUSTER_TYPED_CONST;\n            entries[count][1] = narrow != 0 ? BUSTER_TYPED_CLASS_I32 : BUSTER_NODE_ROWS_CLASS_OWN;")
CONST = "            entries[count][0] = BUSTER_TYPED_CONST;\n            entries[count][1] = narrow != 0 ? BUSTER_TYPED_CLASS_I32 : BUSTER_NODE_ROWS_CLASS_OWN;\n            entries[count + 1][0] = BUSTER_TYPED_NE;"
N('table-const-kind', CONST, CONST.replace("entries[count][0] = BUSTER_TYPED_CONST;", "entries[count][0] = BUSTER_TYPED_LOCAL;"))
N('table-const-narrow-own', CONST, CONST.replace("narrow != 0 ? BUSTER_TYPED_CLASS_I32 : BUSTER_NODE_ROWS_CLASS_OWN", "narrow != 0 ? BUSTER_NODE_ROWS_CLASS_OWN : BUSTER_NODE_ROWS_CLASS_OWN"))
N('table-const-wide-i32', CONST, CONST.replace("narrow != 0 ? BUSTER_TYPED_CLASS_I32 : BUSTER_NODE_ROWS_CLASS_OWN", "narrow != 0 ? BUSTER_TYPED_CLASS_I32 : BUSTER_TYPED_CLASS_I32"))
N('table-const-wide-target', CONST, CONST.replace("narrow != 0 ? BUSTER_TYPED_CLASS_I32 : BUSTER_NODE_ROWS_CLASS_OWN", "narrow != 0 ? BUSTER_TYPED_CLASS_I32 : BUSTER_NODE_ROWS_CLASS_OPERAND"))
NE = "            entries[count + 1][0] = BUSTER_TYPED_NE;\n            entries[count + 1][1] = BUSTER_TYPED_CLASS_I32;\n            entries[count + 2][0] = (uint8_t)(BUSTER_TYPED_BRANCH_FALSE + sense);\n            entries[count + 2][1] = BUSTER_TYPED_CLASS_I32;\n            count += 3;"
N('table-test-eq', NE, NE.replace("BUSTER_TYPED_NE;", "BUSTER_TYPED_EQ;"))
N('table-test-class', NE, NE.replace("entries[count + 1][1] = BUSTER_TYPED_CLASS_I32;", "entries[count + 1][1] = BUSTER_TYPED_CLASS_U8;"))
N('table-branch-other-sense', NE, NE.replace("(uint8_t)(BUSTER_TYPED_BRANCH_FALSE + sense)", "(uint8_t)(BUSTER_TYPED_BRANCH_TRUE - sense)"))
N('table-branch-false-always', NE, NE.replace("(uint8_t)(BUSTER_TYPED_BRANCH_FALSE + sense)", "(uint8_t)(BUSTER_TYPED_BRANCH_FALSE)"))
N('table-branch-true-always', NE, NE.replace("(uint8_t)(BUSTER_TYPED_BRANCH_FALSE + sense)", "(uint8_t)(BUSTER_TYPED_BRANCH_TRUE)"))
N('table-branch-a-jump', NE, NE.replace("(uint8_t)(BUSTER_TYPED_BRANCH_FALSE + sense)", "(uint8_t)(BUSTER_TYPED_JUMP + sense * 0)"))
N('table-branch-class', NE, NE.replace("entries[count + 2][1] = BUSTER_TYPED_CLASS_I32;", "entries[count + 2][1] = BUSTER_TYPED_CLASS_I64;"))
N('table-no-branch', NE, NE.replace("count += 3;", "count += 2;"))
N('table-no-test', NE, NE.replace("count += 3;", "count += 1;"))
ROW = "            node_rows_row(tables, BUSTER_NODE_ROWS_TESTED + 2 * narrow + sense, count, entries);"
N('table-shape-swapped', ROW, ROW.replace("2 * narrow + sense", "narrow + 2 * sense"))
N('table-shape-no-sense', ROW, ROW.replace("2 * narrow + sense", "2 * narrow"))
N('table-shape-no-width', ROW, ROW.replace("2 * narrow + sense", "sense"))
N('table-branches-template-listed', "    tables->templates[NODE_MACHINE_TEMPLATE_SECOND] = BUSTER_NODE_ROWS_LATER;\n", "    tables->templates[NODE_MACHINE_TEMPLATE_SECOND] = BUSTER_NODE_ROWS_LATER;\n    tables->templates[NODE_MACHINE_TEMPLATE_BRANCHES] = BUSTER_NODE_ROWS_LATER;\n")
N('table-branches-template-a-shape', "    tables->templates[NODE_MACHINE_TEMPLATE_SECOND] = BUSTER_NODE_ROWS_LATER;\n", "    tables->templates[NODE_MACHINE_TEMPLATE_SECOND] = BUSTER_NODE_ROWS_LATER;\n    tables->templates[NODE_MACHINE_TEMPLATE_BRANCHES] = BUSTER_TYPED_CONST;\n")
# The second list's sweep.
BRANCHED = "            const __mmask64 branched = _mm512_mask_cmpeq_epi8_mask(alive, templates, _mm512_set1_epi8((char)NODE_MACHINE_TEMPLATE_BRANCHES)) &\n                                       _mm512_cmpneq_epi8_mask(_mm512_loadu_si512(front->ops + x), _mm512_set1_epi8(CHECK_OP_CONDITION));"
N('list-not-alive', BRANCHED, BRANCHED.replace("_mm512_mask_cmpeq_epi8_mask(alive, templates,", "_mm512_cmpeq_epi8_mask(templates,"))
N('list-of-updates', BRANCHED, BRANCHED.replace("NODE_MACHINE_TEMPLATE_BRANCHES", "NODE_MACHINE_TEMPLATE_UPDATE"))
N('list-of-values', BRANCHED, BRANCHED.replace("NODE_MACHINE_TEMPLATE_BRANCHES", "NODE_MACHINE_TEMPLATE_BRANCH"))
N('list-with-conditions', BRANCHED, BRANCHED.replace(" &\n                                       _mm512_cmpneq_epi8_mask(_mm512_loadu_si512(front->ops + x), _mm512_set1_epi8(CHECK_OP_CONDITION));", ";"))
N('list-conditions-alone', BRANCHED, BRANCHED.replace("_mm512_cmpneq_epi8_mask(_mm512_loadu_si512(front->ops + x)", "_mm512_cmpeq_epi8_mask(_mm512_loadu_si512(front->ops + x)"))
N('list-without-nots', BRANCHED, BRANCHED.replace("_mm512_set1_epi8(CHECK_OP_CONDITION));", "_mm512_set1_epi8(CHECK_OP_NOT));"))
N('list-without-ands', BRANCHED, BRANCHED.replace("_mm512_set1_epi8(CHECK_OP_CONDITION));", "_mm512_set1_epi8(CHECK_OP_LOGICAL_AND));"))
N('list-without-ors', BRANCHED, BRANCHED.replace("_mm512_set1_epi8(CHECK_OP_CONDITION));", "_mm512_set1_epi8(CHECK_OP_LOGICAL_OR));"))
N('list-other-block-ops', BRANCHED, BRANCHED.replace("front->ops + x)", "front->ops)"))
BRANCHING = "    const bool branching = state->c_branches_now != 0;"
N('list-not-branching', BRANCHING, BRANCHING.replace("state->c_branches_now != 0", "state->c_updates_now != 0"))
N('list-never-branching', BRANCHING, BRANCHING.replace("state->c_branches_now != 0", "state->c_branches_now != 0 && state->c_updates_now != 0"))
N('list-branching-with-two', BRANCHING, BRANCHING.replace("state->c_branches_now != 0", "state->c_branches_now > 1"))
N('list-branching-other-way', BRANCHING, BRANCHING.replace("state->c_branches_now != 0", "state->c_branches_now == 0"))
SECOND = "            __m512i branch_places = _mm512_maskz_compress_epi8(branched, places);\n            const uint32_t branch_end = branch_count + (uint32_t)_mm_popcnt_u64(branched);"
N('list-places-of-updates', SECOND, SECOND.replace("_mm512_maskz_compress_epi8(branched, places)", "_mm512_maskz_compress_epi8(updated, places)"))
N('list-places-not-compressed', SECOND, SECOND.replace("_mm512_maskz_compress_epi8(branched, places)", "_mm512_maskz_mov_epi8(branched, places)"))
N('list-count-of-updates', SECOND, SECOND.replace("_mm_popcnt_u64(branched)", "_mm_popcnt_u64(updated)"))
N('list-count-one-less', SECOND, SECOND.replace("(uint32_t)_mm_popcnt_u64(branched);", "(uint32_t)_mm_popcnt_u64(branched & (branched - 1));"))
N('list-count-low-half', SECOND, SECOND.replace("(uint32_t)_mm_popcnt_u64(branched);", "(uint32_t)_mm_popcnt_u32((uint32_t)branched);"))
STORE = "                _mm512_storeu_si512(branches + branch_count, _mm512_add_epi32(base, _mm512_cvtepu8_epi32(_mm512_castsi512_si128(branch_places))));\n                branch_places = _mm512_shuffle_i64x2(branch_places, branch_places, 0x39);\n                branch_count += 16;\n            } while (branch_count < branch_end);\n            branch_count = branch_end;"
N('list-no-base', STORE, STORE.replace("_mm512_add_epi32(base, _mm512_cvtepu8_epi32(_mm512_castsi512_si128(branch_places)))", "_mm512_cvtepu8_epi32(_mm512_castsi512_si128(branch_places))"))
N('list-into-updates', STORE, STORE.replace("_mm512_storeu_si512(branches + branch_count,", "_mm512_storeu_si512(updates + branch_count,"))
N('list-no-second-turn-shuffle', STORE, STORE.replace("branch_places = _mm512_shuffle_i64x2(branch_places, branch_places, 0x39);", "branch_places = _mm512_shuffle_i64x2(branch_places, branch_places, 0xe4);"))
N('list-shuffle-two-lanes', STORE, STORE.replace("0x39);", "0x4e);"))
N('list-one-turn', STORE, STORE.replace("} while (branch_count < branch_end);", "} while (branch_count + 16 < branch_end);"))
N('list-turn-of-eight', STORE, STORE.replace("branch_count += 16;", "branch_count += 8;"))
# (Round 1's list-count-not-ended set the count to the lesser of itself and the block's end: the turns' loop leaves it
# no less than the end, so it changed nothing a program reaches, and is not a fault.)
N('list-count-of-a-turn', STORE, STORE.replace("            branch_count = branch_end;", ""))
# An operand's rule.
VALUE = "    const uint32_t value = state->window_c_templates[o] != NODE_MACHINE_TEMPLATE_BRANCHES ? 1u : 0u;"
N('operand-value-never', VALUE, VALUE.replace("? 1u : 0u", "? 0u : 0u"))
N('operand-value-always', VALUE, VALUE.replace("? 1u : 0u", "? 1u : 1u"))
N('operand-value-other-way', VALUE, VALUE.replace("!= NODE_MACHINE_TEMPLATE_BRANCHES", "== NODE_MACHINE_TEMPLATE_BRANCHES"))
N('operand-value-by-update', VALUE, VALUE.replace("NODE_MACHINE_TEMPLATE_BRANCHES", "NODE_MACHINE_TEMPLATE_UPDATE"))
N('operand-value-by-truth', VALUE, VALUE.replace("NODE_MACHINE_TEMPLATE_BRANCHES", "NODE_MACHINE_TEMPLATE_BRANCH"))
N('operand-before-of-the-next', "    const uint32_t before = state->window_x_conversions[o];", "    const uint32_t before = state->window_x_conversions[o + 1];")
N('operand-before-its-own-part', "    const uint32_t before = state->window_x_conversions[o];", "    const uint32_t before = state->window_x_owns[o];")
# (Round 1's operand-narrow-with-void took void's class for a narrow one: no tested value has it, so it changed nothing,
# and the test is by its upper bound alone now.)
NARROW = "    const uint32_t narrow = state->window_c_classes[o] <= BUSTER_TYPED_CLASS_U16 ? 1u : 0u;"
N('operand-narrow-never', NARROW, NARROW.replace("? 1u : 0u", "? 0u : 0u"))
N('operand-narrow-always', NARROW, NARROW.replace("? 1u : 0u", "? 1u : 1u"))
N('operand-narrow-to-u8', NARROW, NARROW.replace("<= BUSTER_TYPED_CLASS_U16", "<= BUSTER_TYPED_CLASS_U8"))
N('operand-narrow-to-i16', NARROW, NARROW.replace("<= BUSTER_TYPED_CLASS_U16", "<= BUSTER_TYPED_CLASS_I16"))
N('operand-narrow-to-i32', NARROW, NARROW.replace("<= BUSTER_TYPED_CLASS_U16", "<= BUSTER_TYPED_CLASS_I32"))
N('operand-narrow-other-way', NARROW, NARROW.replace("<= BUSTER_TYPED_CLASS_U16", "> BUSTER_TYPED_CLASS_U16"))
N('operand-narrow-of-the-next', NARROW, NARROW.replace("state->window_c_classes[o]", "state->window_c_classes[o + 1]"))
N('operand-narrow-of-its-target', NARROW, NARROW.replace("state->window_c_classes[o]", "state->window_x_targets[o]"))
SHAPE = "    const uint32_t shape = BUSTER_NODE_ROWS_TESTED + 2u * narrow + sense;"
N('operand-shape-no-width', SHAPE, SHAPE.replace("2u * narrow + sense", "sense"))
N('operand-shape-no-sense', SHAPE, SHAPE.replace("2u * narrow + sense", "2u * narrow"))
N('operand-shape-other-sense', SHAPE, SHAPE.replace("2u * narrow + sense", "2u * narrow + (sense ^ 1u)"))
N('operand-shape-swapped', SHAPE, SHAPE.replace("2u * narrow + sense", "narrow + 2u * sense"))
N('operand-shape-a-bool-conversion', SHAPE, SHAPE.replace("BUSTER_NODE_ROWS_TESTED + 2u * narrow + sense", "BUSTER_NODE_ROWS_BOOL + narrow + 0u * sense"))
CONVERTED = "    const uint32_t converted = before - 1u < BUSTER_NODE_ROWS_TESTED - 1u ? 1u : 0u;"
N('operand-converted-never', CONVERTED, CONVERTED.replace("? 1u : 0u", "? 0u : 0u"))
N('operand-converted-always', CONVERTED, CONVERTED.replace("? 1u : 0u", "? 1u : 1u"))
N('operand-converted-with-free', CONVERTED, CONVERTED.replace("before - 1u < BUSTER_NODE_ROWS_TESTED - 1u", "before < BUSTER_NODE_ROWS_TESTED"))
N('operand-converted-with-tests', CONVERTED, CONVERTED.replace("BUSTER_NODE_ROWS_TESTED - 1u", "BUSTER_NODE_ROWS_SHAPES - 1u"))
N('operand-converted-with-one-test', CONVERTED, CONVERTED.replace("BUSTER_NODE_ROWS_TESTED - 1u", "BUSTER_NODE_ROWS_TESTED"))
N('operand-converted-below-a-narrow-bool', CONVERTED, CONVERTED.replace("BUSTER_NODE_ROWS_TESTED - 1u", "BUSTER_NODE_ROWS_BOOL"))
N('operand-converted-other-way', CONVERTED, CONVERTED.replace("before - 1u < BUSTER_NODE_ROWS_TESTED - 1u", "before - 1u >= BUSTER_NODE_ROWS_TESTED - 1u"))
TAKES = "    const uint32_t takes = 0u - (value & (before == 0 ? 1u : 0u));"
N('operand-takes-a-branched', TAKES, TAKES.replace("(value & (before == 0 ? 1u : 0u))", "((value | 1u) & (before == 0 ? 1u : 0u))"))
N('operand-takes-no-room', TAKES, TAKES.replace("(value & (before == 0 ? 1u : 0u))", "value"))
N('operand-takes-where-not-free', TAKES, TAKES.replace("before == 0 ? 1u : 0u", "before != 0 ? 1u : 0u"))
N('operand-takes-none', TAKES, TAKES.replace("0u - (value & (before == 0 ? 1u : 0u))", "0u * (value & (before == 0 ? 1u : 0u))"))
N('operand-takes-one-bit', TAKES, TAKES.replace("0u - (value", "(value"))
N('operand-sense-not-kept', "    state->window_x_senses[o] = (uint8_t)sense;\n", "")
N('operand-sense-kept-other', "    state->window_x_senses[o] = (uint8_t)sense;", "    state->window_x_senses[o] = (uint8_t)(sense ^ 1u);")
N('operand-sense-kept-of-values-alone', "    state->window_x_senses[o] = (uint8_t)sense;", "    state->window_x_senses[o] = (uint8_t)(sense & value);")
CONV = "    state->window_x_conversions[o] = (uint8_t)(before | (shape & takes));"
N('operand-shape-not-written', CONV, "    (void)shape;")
N('operand-shape-drops-before', CONV, CONV.replace("(before | (shape & takes))", "(shape & takes)"))
N('operand-shape-not-masked', CONV, CONV.replace("(before | (shape & takes))", "(before | shape)"))
N('operand-shape-and-before', CONV, CONV.replace("(before | (shape & takes))", "(before & (shape & takes))"))
N('operand-shape-of-the-next', CONV, CONV.replace("state->window_x_conversions[o] =", "state->window_x_conversions[o + 1] ="))
N('operand-shape-its-own-part', CONV, CONV.replace("state->window_x_conversions[o] =", "state->window_x_owns[o] ="))
LEN = "    state->window_x_lengths[o] = (uint8_t)(state->window_x_lengths[o] + ((3u + narrow) & takes));"
N('operand-length-not-written', LEN, "")
N('operand-length-three', LEN, LEN.replace("(3u + narrow)", "3u"))
N('operand-length-four', LEN, LEN.replace("(3u + narrow)", "4u"))
N('operand-length-two', LEN, LEN.replace("(3u + narrow)", "(2u + narrow)"))
N('operand-length-not-masked', LEN, LEN.replace("((3u + narrow) & takes)", "(3u + narrow)"))
N('operand-length-of-a-value', LEN, LEN.replace("((3u + narrow) & takes)", "((3u + narrow) & (0u - value))"))
N('operand-length-replaced', LEN, LEN.replace("state->window_x_lengths[o] + ((3u + narrow)", "((3u + narrow)"))
LIST = "    if (__builtin_expect(converted != 0, 0))"
N('operand-never-lists', LIST, LIST.replace("converted != 0", "converted > 1u"))
N('operand-lists-the-free', LIST, LIST.replace("converted != 0", "converted == 0"))
N('operand-lists-every-value', LIST, LIST.replace("converted != 0", "(converted | value) != 0"))
BIT = "        state->window_c_masks[BUSTER_NODE_CONTEXTS_MASKS * (uint64_t)(o / 64) + BUSTER_NODE_ROWS_MASK_LISTED] |= UINT64_C(1) << (o & 63);"
N('operand-lists-low-bits', BIT, BIT.replace("<< (o & 63)", "<< (o & 31)"))
N('operand-lists-first-block', BIT, BIT.replace("(uint64_t)(o / 64)", "(uint64_t)0"))
N('operand-lists-as-refused', BIT, BIT.replace("BUSTER_NODE_ROWS_MASK_LISTED]", "BUSTER_NODE_ROWS_MASK_REFUSED]"))
N('operand-lists-replaces', BIT, BIT.replace("|= UINT64_C(1)", "= UINT64_C(1)"))
N('operand-lists-the-next', BIT, BIT.replace("<< (o & 63)", "<< ((o + 1) & 63)"))
# An operator's turn.
N('turn-operator-of-the-next', "    const uint32_t op = front->ops[c];\n    const uint32_t sense = state->window_x_senses[c];", "    const uint32_t op = front->ops[c + 1];\n    const uint32_t sense = state->window_x_senses[c];")
NEG = "    const uint32_t negated = op == CHECK_OP_NOT ? 1u : 0u;"
N('turn-negated-never', NEG, NEG.replace("? 1u : 0u", "? 0u : 0u"))
N('turn-negated-always', NEG, NEG.replace("? 1u : 0u", "? 1u : 1u"))
N('turn-negated-by-and', NEG, NEG.replace("CHECK_OP_NOT", "CHECK_OP_LOGICAL_AND"))
N('turn-negated-by-or', NEG, NEG.replace("CHECK_OP_NOT", "CHECK_OP_LOGICAL_OR"))
EITHER = "    const uint32_t either = op == CHECK_OP_LOGICAL_OR ? 1u : 0u;"
N('turn-either-never', EITHER, EITHER.replace("? 1u : 0u", "? 0u : 0u"))
N('turn-either-always', EITHER, EITHER.replace("? 1u : 0u", "? 1u : 1u"))
N('turn-either-by-and', EITHER, EITHER.replace("CHECK_OP_LOGICAL_OR", "CHECK_OP_LOGICAL_AND"))
N('turn-either-by-not', EITHER, EITHER.replace("CHECK_OP_LOGICAL_OR", "CHECK_OP_NOT"))
N('turn-sense-of-no-one', "    const uint32_t sense = state->window_x_senses[c];", "    const uint32_t sense = 0;")
N('turn-sense-true', "    const uint32_t sense = state->window_x_senses[c];", "    const uint32_t sense = 1;")
N('turn-sense-of-the-next', "    const uint32_t sense = state->window_x_senses[c];", "    const uint32_t sense = state->window_x_senses[c + 1];")
N('turn-sense-of-the-one-before', "    const uint32_t sense = state->window_x_senses[c];", "    const uint32_t sense = state->window_x_senses[c - 1];")
N('turn-last-not-negated', "    const uint32_t last = sense ^ negated;", "    const uint32_t last = sense;")
N('turn-last-of-either', "    const uint32_t last = sense ^ either;" if False else "    const uint32_t last = sense ^ negated;", "    const uint32_t last = sense ^ either;")
N('turn-last-always-negated', "    const uint32_t last = sense ^ negated;", "    const uint32_t last = sense ^ 1u;")
FIRST = "    node_rows_window_tested(state, c - front->window_left[c], (last & (0u - negated)) | (either & (negated - 1u)));"
N('turn-first-not-given', FIRST, "    (void)either;")
N('turn-first-is-before', FIRST, FIRST.replace("c - front->window_left[c]", "c - 1"))
N('turn-first-by-right', FIRST, FIRST.replace("front->window_left[c]", "front->window_right[c]"))
N('turn-first-has-its-operators', FIRST, FIRST.replace("(last & (0u - negated)) | (either & (negated - 1u))", "last | (either & 0u)"))
N('turn-first-by-either-alone', FIRST, FIRST.replace("(last & (0u - negated)) | (either & (negated - 1u))", "either"))
N('turn-first-other', FIRST, FIRST.replace("(last & (0u - negated)) | (either & (negated - 1u))", "(last & (0u - negated)) | ((either ^ 1u) & (negated - 1u))"))
N('turn-first-of-a-not-swapped', FIRST, FIRST.replace("(last & (0u - negated)) | (either & (negated - 1u))", "(either & (0u - negated)) | (last & (negated - 1u))"))
N('turn-first-of-a-not-its-own', FIRST, FIRST.replace("(last & (0u - negated))", "(sense & (0u - negated))"))
SECONDCALL = "    node_rows_window_tested(state, c - 1, last);"
N('turn-second-not-given', SECONDCALL, "")
N('turn-second-two-before', SECONDCALL, SECONDCALL.replace("c - 1", "c - 2"))
N('turn-second-by-left', SECONDCALL, SECONDCALL.replace("c - 1", "c - front->window_left[c]"))
N('turn-second-own-sense', SECONDCALL, SECONDCALL.replace("c - 1, last", "c - 1, sense"))
N('turn-second-other-sense', SECONDCALL, SECONDCALL.replace("c - 1, last", "c - 1, last ^ 1u"))
# (Round 1's turn-second-before-first gave the second operand its sense before the first: two records, but a `!`'s one
# operand, whose two senses are the same, so it changed nothing.)
LOOP = "    for (uint32_t i = branch_count; i-- != 0;)\n    {\n        node_rows_window_branch(state, front, branches[i]);\n    }"
N('loop-forward', LOOP, "    for (uint32_t i = 0; i < branch_count; i += 1)\n    {\n        node_rows_window_branch(state, front, branches[i]);\n    }")
N('loop-not-the-last', LOOP, LOOP.replace("uint32_t i = branch_count; i-- != 0;", "uint32_t i = branch_count - (branch_count != 0 ? 1u : 0u); i-- != 0;"))
N('loop-not-the-first', LOOP, LOOP.replace("i-- != 0;", "i-- > 1;"))
N('loop-none', LOOP, LOOP.replace("uint32_t i = branch_count; i-- != 0;", "uint32_t i = 0; i-- != 0;"))
N('loop-of-updates', LOOP, LOOP.replace("branches[i]", "updates[i]"))
# (Round 1's loop-before-the-updates ran the branches' loop before the updates': an update that is a tested value takes
# its own part from the one and its conversion's from the other, and each adds to its row's length, so nothing changed.)
N('loop-counts-updates', "    counts->branched += branch_count;", "    counts->branched += update_count;")
N('loop-counts-none', "    counts->branched += branch_count;", "    counts->branched += 0u * branch_count;")
# The chunk: its guard, in both runs.
GUARD = "    if ((state->c_updates_now | state->c_branches_now) != 0)\n    {\n        node_rows_window_updates(state, front, count, &read);\n    }"
N('chunk-guard-updates-alone', GUARD, GUARD.replace("(state->c_updates_now | state->c_branches_now) != 0", "state->c_updates_now != 0"))
N('chunk-guard-branches-alone', GUARD, GUARD.replace("(state->c_updates_now | state->c_branches_now) != 0", "state->c_branches_now != 0"))
N('chunk-guard-both', GUARD, GUARD.replace("(state->c_updates_now | state->c_branches_now) != 0", "state->c_updates_now != 0 && state->c_branches_now != 0"))
GUARD2 = GUARD.replace("&read", "&again")
N('chunk-second-run-guard-updates-alone', GUARD2, GUARD2.replace("(state->c_updates_now | state->c_branches_now) != 0", "state->c_updates_now != 0"))
N('chunk-second-run-guard-branches-alone', GUARD2, GUARD2.replace("(state->c_updates_now | state->c_branches_now) != 0", "state->c_branches_now != 0"))
N('chunk-count-turns-of-updates', "    counts[NODE_FACTS_COUNT_ROWS_BRANCHED] += read.branched;", "    counts[NODE_FACTS_COUNT_ROWS_BRANCHED] += read.updates;")
# The listed expression's reason.
UPDATED = "    const bool updated = (state->window_c_templates[x] & 63u) == NODE_MACHINE_TEMPLATE_UPDATE || state->window_x_owns[x] == BUSTER_NODE_ROWS_LATER;"
N('reason-update-not-by-template', UPDATED, UPDATED.replace("(state->window_c_templates[x] & 63u) == NODE_MACHINE_TEMPLATE_UPDATE || ", ""))
N('reason-destination-not-by-mark', UPDATED, UPDATED.replace(" || state->window_x_owns[x] == BUSTER_NODE_ROWS_LATER", ""))
# (Round 2's reason-mark-of-its-conversion read the mark in the record's conversion's part: the tables give a destination
# with no room the mark in both parts (kept_owns and kept_conversions, set together), so it changed nothing.)
N('reason-update-by-the-branches-template', UPDATED, UPDATED.replace("== NODE_MACHINE_TEMPLATE_UPDATE", "== NODE_MACHINE_TEMPLATE_BRANCHES"))
N('reason-mark-other-way', UPDATED, UPDATED.replace("state->window_x_owns[x] == BUSTER_NODE_ROWS_LATER", "state->window_x_owns[x] != BUSTER_NODE_ROWS_LATER"))
REASONS = "           updated                                           ? BUSTER_NODE_ROWS_REASON_UPDATE :\n                                                               BUSTER_NODE_ROWS_REASON_BRANCHES;"
N('reason-swapped', REASONS, REASONS.replace("? BUSTER_NODE_ROWS_REASON_UPDATE :", "? BUSTER_NODE_ROWS_REASON_BRANCHES :").replace("                                                               BUSTER_NODE_ROWS_REASON_BRANCHES;", "                                                               BUSTER_NODE_ROWS_REASON_UPDATE;"))
N('reason-never-branches', REASONS, REASONS.replace("                                                               BUSTER_NODE_ROWS_REASON_BRANCHES;", "                                                               BUSTER_NODE_ROWS_REASON_UPDATE;"))
# The reader's sense, and C's count.
SENSE = "                    state->window_x_senses[operand] = state->c_sense_now;"
N('reader-sense-not-written', SENSE, "                    (void)operand;", file=FACTS)
N('reader-sense-at-the-root', SENSE, "                    state->window_x_senses[root_place] = state->c_sense_now;", file=FACTS)
N('reader-sense-false', SENSE, "                    state->window_x_senses[operand] = 0;", file=FACTS)
N('reader-sense-true', SENSE, "                    state->window_x_senses[operand] = 1;", file=FACTS)
N('reader-sense-other', "    state->c_sense_now = sense ? 1 : 0;", "    state->c_sense_now = sense ? 0 : 1;", file=FACTS)
N('reader-sense-of-none', "(context & BUSTER_NODE_MACHINE_ROOT_BRANCH_TRUE) != 0);", "(context & BUSTER_NODE_MACHINE_ROOT_BRANCH_TRUE) == 0x100);", file=READER)
N('window-no-branches-count', "    state->c_branches_now = loop_counts.branched - loop_counts.branched_roots;", "    state->c_branches_now = 0;", file=WINDOW)
# (Round 1's window-branches-count-of-roots took the CONDITIONs out of the count: a chunk with a turn has an operator that
# is no CONDITION, so it changed nothing; the count is the turns' now, and a chunk with one turn separates the two below.)
N('window-branches-count-one-less', "    state->c_branches_now = loop_counts.branched - loop_counts.branched_roots;", "    state->c_branches_now = loop_counts.branched - loop_counts.branched_roots - (loop_counts.branched != 0 ? 1u : 0u);", file=WINDOW)
N('window-branches-count-of-roots-less', "    state->c_branches_now = loop_counts.branched - loop_counts.branched_roots;", "    state->c_branches_now = loop_counts.branched - 2 * loop_counts.branched_roots;", file=WINDOW)
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
body = ("#!/usr/bin/env python3\n# faults-branch.py TREE [N]: the branches' rows' faults (make-faults.py). With no N, check every fault applies once and\n"
        "# print how many; with N, apply fault N in TREE in place and print its name.\nimport sys\nfaults = " + repr(out) + "\n" + tail)
import os
open(sys.argv[2], 'w').write(body)  # the round's own list: a running round keeps reading its own file
print(len(out), 'faults')
