#!/usr/bin/env python3
# faults6.py WORKER OF [check]: the sixth round, on the pull request's sources as pushed: everything the rounds before left open whose text is still there, and the faults of the conversions' rule as it is now; of the faults of C on the window's first piece, one at a time, in the
# copy /home/user/mut15/treeWORKER: a text of the piece's code replaced by a faulty one, the Debug compiler built, the
# node machine's tests run (test-checker part 5 of 8), and then the shadow with C on the window on Lua, sqlite3.c and
# musl, whatever the tests said: a fault the tests don't fail is a survivor, and the corpora say whether any program
# they hold tells it from the code. Worker WORKER of OF takes every OF-th fault. Results in
# /home/user/mut15/results6-WORKER.txt. With `check`, only that every text is there once.
import re, subprocess, sys, time
worker, of = int(sys.argv[1]), int(sys.argv[2])
TREE = '/home/user/mut15/tree%d' % worker
SRC = TREE + '/src/buster/compiler/'
W = 'c_check_node_machine_window.c'
C = 'c_check_node_census.c'
F = 'c_check_node_machine_front.c'
FA = 'c_check_node_machine_facts.c'
R = 'c_check_node_machine_reader.c'
window = open(SRC + W).read()

def mask(name):
    # The one definition of the loop's mask `name`, whole.
    m = re.findall(r'\n( +const __mmask64 %s = ([^;]*);\n)' % re.escape(name), window)
    assert len(m) == 1, (name, len(m))
    return m[0]

def force(name, value):
    whole, rhs = mask(name)
    indent = whole[:len(whole) - len(whole.lstrip())]
    return ('%s-%s' % (name.replace('_', '-'), 'all' if value else 'none'), W, whole,
            '%sconst __mmask64 %s = %s;\n' % (indent, name, ('(%s) | ~(__mmask64)0' if value else '(%s) & 0') % rhs))

MASKS = [name for name in dict.fromkeys(re.findall(r'\n +const __mmask64 ([a-z_0-9]+) = ', window)) if len(re.findall(r'\n +const __mmask64 %s = ' % name, window)) == 1]
FAULTS = [force(name, value) for name in MASKS for value in (True, False)]
FAULTS += [
    # the operators' classes
    ('class-positive-no-wrap', W, 'case CHECK_OP_CAST: case CHECK_OP_CONVERT: case CHECK_OP_POSITIVE: class = BUSTER_NODE_CONTEXTS_CLASS_WRAP; break;',
     'case CHECK_OP_CAST: case CHECK_OP_CONVERT: class = BUSTER_NODE_CONTEXTS_CLASS_WRAP; break;'),
    ('class-convert-no-wrap', W, 'case CHECK_OP_CAST: case CHECK_OP_CONVERT: case CHECK_OP_POSITIVE: class = BUSTER_NODE_CONTEXTS_CLASS_WRAP; break;',
     'case CHECK_OP_CAST: case CHECK_OP_POSITIVE: class = BUSTER_NODE_CONTEXTS_CLASS_WRAP; break;'),
    ('class-cast-no-wrap', W, 'case CHECK_OP_CAST: case CHECK_OP_CONVERT: case CHECK_OP_POSITIVE: class = BUSTER_NODE_CONTEXTS_CLASS_WRAP; break;',
     'case CHECK_OP_CONVERT: case CHECK_OP_POSITIVE: class = BUSTER_NODE_CONTEXTS_CLASS_WRAP; break;'),
    ('class-member-no-place', W, 'case CHECK_OP_MEMBER: class = BUSTER_NODE_CONTEXTS_CLASS_MEMBER | BUSTER_NODE_CONTEXTS_CLASS_PLACE; break;',
     'case CHECK_OP_MEMBER: class = BUSTER_NODE_CONTEXTS_CLASS_MEMBER; break;'),
    ('class-arrow-place', W, 'case CHECK_OP_ARROW: class = BUSTER_NODE_CONTEXTS_CLASS_MEMBER; break;',
     'case CHECK_OP_ARROW: class = BUSTER_NODE_CONTEXTS_CLASS_MEMBER | BUSTER_NODE_CONTEXTS_CLASS_PLACE; break;'),
    ('class-subtract-binary', W, 'case CHECK_OP_ADD: case CHECK_OP_SUBTRACT: class = BUSTER_NODE_CONTEXTS_CLASS_SUM; break;',
     'case CHECK_OP_ADD: class = BUSTER_NODE_CONTEXTS_CLASS_SUM; break;'),
    ('class-add-binary', W, 'case CHECK_OP_ADD: case CHECK_OP_SUBTRACT: class = BUSTER_NODE_CONTEXTS_CLASS_SUM; break;',
     'case CHECK_OP_SUBTRACT: class = BUSTER_NODE_CONTEXTS_CLASS_SUM; break;'),
    ('class-subscript-sum', W, 'case CHECK_OP_SUBSCRIPT: class = BUSTER_NODE_CONTEXTS_CLASS_SUBSCRIPT; break;', 'case CHECK_OP_SUBSCRIPT: class = BUSTER_NODE_CONTEXTS_CLASS_SUM; break;'),
    ('class-bit-not-other', W, 'case CHECK_OP_NEGATIVE: case CHECK_OP_BIT_NOT: class = BUSTER_NODE_CONTEXTS_CLASS_UNARY; break;',
     'case CHECK_OP_NEGATIVE: class = BUSTER_NODE_CONTEXTS_CLASS_UNARY; break;'),
    ('class-negative-other', W, 'case CHECK_OP_NEGATIVE: case CHECK_OP_BIT_NOT: class = BUSTER_NODE_CONTEXTS_CLASS_UNARY; break;',
     'case CHECK_OP_BIT_NOT: class = BUSTER_NODE_CONTEXTS_CLASS_UNARY; break;'),
    ('class-condition-other', W, 'case CHECK_OP_NOT: case CHECK_OP_CONDITION: class = BUSTER_NODE_CONTEXTS_CLASS_TRUTH; break;',
     'case CHECK_OP_NOT: class = BUSTER_NODE_CONTEXTS_CLASS_TRUTH; break;'),
    ('class-not-other', W, 'case CHECK_OP_NOT: case CHECK_OP_CONDITION: class = BUSTER_NODE_CONTEXTS_CLASS_TRUTH; break;',
     'case CHECK_OP_CONDITION: class = BUSTER_NODE_CONTEXTS_CLASS_TRUTH; break;'),
    ('class-assign-no-place', W, 'case CHECK_OP_ASSIGN: class = BUSTER_NODE_CONTEXTS_CLASS_ASSIGN | BUSTER_NODE_CONTEXTS_CLASS_PLACE; break;',
     'case CHECK_OP_ASSIGN: class = BUSTER_NODE_CONTEXTS_CLASS_ASSIGN; break;'),
    ('class-address-no-place', W, 'case CHECK_OP_ADDRESS: class = BUSTER_NODE_CONTEXTS_CLASS_ADDRESS | BUSTER_NODE_CONTEXTS_CLASS_PLACE; break;',
     'case CHECK_OP_ADDRESS: class = BUSTER_NODE_CONTEXTS_CLASS_ADDRESS; break;'),
    ('class-dereference-place', W, 'case CHECK_OP_DEREFERENCE: class = BUSTER_NODE_CONTEXTS_CLASS_DEREFERENCE; break;',
     'case CHECK_OP_DEREFERENCE: class = BUSTER_NODE_CONTEXTS_CLASS_DEREFERENCE | BUSTER_NODE_CONTEXTS_CLASS_PLACE; break;'),
    ('class-remainder-binary', W, 'case CHECK_OP_DIVIDE: case CHECK_OP_REMAINDER: class = BUSTER_NODE_CONTEXTS_CLASS_DIVIDE; break;',
     'case CHECK_OP_DIVIDE: class = BUSTER_NODE_CONTEXTS_CLASS_DIVIDE; break;'),
    ('class-divide-binary', W, 'case CHECK_OP_DIVIDE: case CHECK_OP_REMAINDER: class = BUSTER_NODE_CONTEXTS_CLASS_DIVIDE; break;',
     'case CHECK_OP_REMAINDER: class = BUSTER_NODE_CONTEXTS_CLASS_DIVIDE; break;'),
    ('class-initialize-other', W, 'case CHECK_OP_INITIALIZE: class = BUSTER_NODE_CONTEXTS_CLASS_INITIALIZE; break;', 'case CHECK_OP_INITIALIZE: class = BUSTER_NODE_CONTEXTS_CLASS_OTHER; break;'),
    ('class-call-other', W, 'case CHECK_OP_CALL: class = BUSTER_NODE_CONTEXTS_CLASS_CALL; break;', 'case CHECK_OP_CALL: class = BUSTER_NODE_CONTEXTS_CLASS_OTHER; break;'),
    ('class-conditional-binary', W, 'case CHECK_OP_LOGICAL_AND: case CHECK_OP_LOGICAL_OR: case CHECK_OP_CONDITIONAL: class = BUSTER_NODE_CONTEXTS_CLASS_LOGICAL; break;',
     'case CHECK_OP_LOGICAL_AND: case CHECK_OP_LOGICAL_OR: class = BUSTER_NODE_CONTEXTS_CLASS_LOGICAL; break;'),
    ('class-logical-binary', W, 'case CHECK_OP_LOGICAL_AND: case CHECK_OP_LOGICAL_OR: case CHECK_OP_CONDITIONAL: class = BUSTER_NODE_CONTEXTS_CLASS_LOGICAL; break;',
     'case CHECK_OP_LOGICAL_AND: class = BUSTER_NODE_CONTEXTS_CLASS_BINARY; break; case CHECK_OP_LOGICAL_OR: case CHECK_OP_CONDITIONAL: class = BUSTER_NODE_CONTEXTS_CLASS_LOGICAL; break;'),
    ('class-comma-binary', W, 'case CHECK_OP_COMMA: case CHECK_OP_SELECT: class = BUSTER_NODE_CONTEXTS_CLASS_COMMA; break;',
     'case CHECK_OP_COMMA: case CHECK_OP_SELECT: class = BUSTER_NODE_CONTEXTS_CLASS_BINARY; break;'),
    ('class-update-binary', W, 'class = update ? BUSTER_NODE_CONTEXTS_CLASS_UPDATE : binary != BUSTER_TYPED_NONE',
     'class = update && op > CHECK_OP_POST_DECREMENT ? BUSTER_NODE_CONTEXTS_CLASS_BINARY : update ? BUSTER_NODE_CONTEXTS_CLASS_UPDATE : binary != BUSTER_TYPED_NONE'),
    ('class-increment-unary', W, 'class = update ? BUSTER_NODE_CONTEXTS_CLASS_UPDATE : binary != BUSTER_TYPED_NONE',
     'class = update && op <= CHECK_OP_POST_DECREMENT ? BUSTER_NODE_CONTEXTS_CLASS_UNARY : update ? BUSTER_NODE_CONTEXTS_CLASS_UPDATE : binary != BUSTER_TYPED_NONE'),
    ('class-binary-other', W, 'binary != BUSTER_TYPED_NONE && op < CHECK_OP_PRE_INCREMENT ? BUSTER_NODE_CONTEXTS_CLASS_BINARY :',
     'binary != BUSTER_TYPED_NONE && op < CHECK_OP_PRE_INCREMENT && op != CHECK_OP_LESS ? BUSTER_NODE_CONTEXTS_CLASS_BINARY :'),
    # the rows
    ('row-pass-no-target', W, 'tables->rows[CHECK_LOWER_TEMPLATE_PASS << 2] = given;', 'tables->rows[CHECK_LOWER_TEMPLATE_PASS << 2] = BUSTER_NODE_CONTEXTS_EVALUATES;'),
    ('row-pass-dead', W, 'tables->rows[CHECK_LOWER_TEMPLATE_PASS << 2] = given;', 'tables->rows[CHECK_LOWER_TEMPLATE_PASS << 2] = BUSTER_NODE_CONTEXTS_SOURCE_GIVEN;'),
    ('row-dereference-no-target', W, 'tables->rows[CHECK_LOWER_TEMPLATE_DEREFERENCE << 2] = given;', 'tables->rows[CHECK_LOWER_TEMPLATE_DEREFERENCE << 2] = BUSTER_NODE_CONTEXTS_EVALUATES;'),
    ('row-member-no-target', W, 'tables->rows[CHECK_LOWER_TEMPLATE_MEMBER << 2] = given;', 'tables->rows[CHECK_LOWER_TEMPLATE_MEMBER << 2] = BUSTER_NODE_CONTEXTS_EVALUATES;'),
    ('row-unary-no-target', W, 'tables->rows[CHECK_LOWER_TEMPLATE_UNARY << 2] = given;', 'tables->rows[CHECK_LOWER_TEMPLATE_UNARY << 2] = BUSTER_NODE_CONTEXTS_EVALUATES;'),
    ('row-truth-no-target', W, 'tables->rows[CHECK_LOWER_TEMPLATE_TRUTH << 2] = given;', 'tables->rows[CHECK_LOWER_TEMPLATE_TRUTH << 2] = BUSTER_NODE_CONTEXTS_EVALUATES;'),
    ('row-binary-first-no-target', W, 'tables->rows[CHECK_LOWER_TEMPLATE_BINARY << 2] = given;', 'tables->rows[CHECK_LOWER_TEMPLATE_BINARY << 2] = BUSTER_NODE_CONTEXTS_EVALUATES;'),
    ('row-binary-second-no-target', W, 'tables->rows[(CHECK_LOWER_TEMPLATE_BINARY << 2) + 1] = given;', 'tables->rows[(CHECK_LOWER_TEMPLATE_BINARY << 2) + 1] = BUSTER_NODE_CONTEXTS_EVALUATES;'),
    ('row-binary-second-dead', W, 'tables->rows[(CHECK_LOWER_TEMPLATE_BINARY << 2) + 1] = given;', 'tables->rows[(CHECK_LOWER_TEMPLATE_BINARY << 2) + 1] = BUSTER_NODE_CONTEXTS_SOURCE_GIVEN;'),
    ('row-pointer-first-no-target', W, 'tables->rows[CHECK_LOWER_TEMPLATE_POINTER << 2] = given;', 'tables->rows[CHECK_LOWER_TEMPLATE_POINTER << 2] = BUSTER_NODE_CONTEXTS_EVALUATES;'),
    ('row-pointer-index-given', W, 'tables->rows[(CHECK_LOWER_TEMPLATE_POINTER << 2) + 1] = BUSTER_NODE_CONTEXTS_EVALUATES | BUSTER_NODE_CONTEXTS_SOURCE_LONG;',
     'tables->rows[(CHECK_LOWER_TEMPLATE_POINTER << 2) + 1] = given;'),
    ('row-store-local-destination', W, 'tables->rows[(CHECK_LOWER_TEMPLATE_STORE_LOCAL << 2) + 1] = given;',
     'tables->rows[(CHECK_LOWER_TEMPLATE_STORE_LOCAL << 2) + 1] = given;\n    tables->rows[CHECK_LOWER_TEMPLATE_STORE_LOCAL << 2] = BUSTER_NODE_CONTEXTS_EVALUATES;'),
    ('row-store-local-no-target', W, 'tables->rows[(CHECK_LOWER_TEMPLATE_STORE_LOCAL << 2) + 1] = given;', 'tables->rows[(CHECK_LOWER_TEMPLATE_STORE_LOCAL << 2) + 1] = BUSTER_NODE_CONTEXTS_EVALUATES;'),
    ('row-store-global-destination', W, 'tables->rows[(CHECK_LOWER_TEMPLATE_STORE_GLOBAL << 2) + 1] = given;',
     'tables->rows[(CHECK_LOWER_TEMPLATE_STORE_GLOBAL << 2) + 1] = given;\n    tables->rows[CHECK_LOWER_TEMPLATE_STORE_GLOBAL << 2] = BUSTER_NODE_CONTEXTS_EVALUATES;'),
    ('row-store-global-no-target', W, 'tables->rows[(CHECK_LOWER_TEMPLATE_STORE_GLOBAL << 2) + 1] = given;', 'tables->rows[(CHECK_LOWER_TEMPLATE_STORE_GLOBAL << 2) + 1] = BUSTER_NODE_CONTEXTS_EVALUATES;'),
    ('row-store-destination-dead', W, 'tables->rows[CHECK_LOWER_TEMPLATE_STORE << 2] = BUSTER_NODE_CONTEXTS_EVALUATES | BUSTER_NODE_CONTEXTS_SOURCE_NONE;',
     'tables->rows[CHECK_LOWER_TEMPLATE_STORE << 2] = BUSTER_NODE_CONTEXTS_SOURCE_NONE;'),
    ('row-store-destination-target', W, 'tables->rows[CHECK_LOWER_TEMPLATE_STORE << 2] = BUSTER_NODE_CONTEXTS_EVALUATES | BUSTER_NODE_CONTEXTS_SOURCE_NONE;',
     'tables->rows[CHECK_LOWER_TEMPLATE_STORE << 2] = given;'),
    ('row-store-no-target', W, 'tables->rows[(CHECK_LOWER_TEMPLATE_STORE << 2) + 1] = given;', 'tables->rows[(CHECK_LOWER_TEMPLATE_STORE << 2) + 1] = BUSTER_NODE_CONTEXTS_EVALUATES;'),
    ('row-none-dead', W, 'tables->rows[(CHECK_LOWER_TEMPLATE_NONE << 2) + place] = BUSTER_NODE_CONTEXTS_EVALUATES | BUSTER_NODE_CONTEXTS_SOURCE_NONE;',
     'tables->rows[(CHECK_LOWER_TEMPLATE_NONE << 2) + place] = BUSTER_NODE_CONTEXTS_SOURCE_NONE;'),
    # the reach
    ('consumers-room', W, 'const __m512i room = _mm512_sub_epi8(_mm512_set1_epi8(127), lanes);', 'const __m512i room = _mm512_sub_epi8(_mm512_set1_epi8(126), lanes);'),
    ('consumers-room-past', W, 'const __m512i room = _mm512_sub_epi8(_mm512_set1_epi8(127), lanes);', 'const __m512i room = _mm512_sub_epi8(_mm512_set1_epi8((char)191), lanes);'),
    ('consumers-by-distance', W, 'const __mmask64 some = _mm512_test_epi8_mask(takers, takers);', 'const __mmask64 some = _mm512_test_epi8_mask(ups, ups) | (_mm512_test_epi8_mask(takers, takers) & 0);'),
    ('operands-reach-past', W, 'const __m512i reach = _mm512_add_epi8(lanes, _mm512_set1_epi8(64));\n    const __mmask64 some = _mm512_test_epi8_mask(distance, distance);\n    const __mmask64 beyond = _mm512_cmpgt_epu8_mask(distance, reach);',
     'const __m512i reach = _mm512_add_epi8(lanes, _mm512_set1_epi8(64));\n    const __mmask64 some = _mm512_test_epi8_mask(distance, distance);\n    const __mmask64 beyond = _mm512_cmpgt_epu8_mask(distance, _mm512_set1_epi8((char)200));'),
    # the stride
    ('stride-row-always', W, 'bool stride = row->stride != 0;', 'bool stride = row->stride != 0 || row->stride == 0;'),
    ('stride-row-never', W, 'bool stride = row->stride != 0;', 'bool stride = row->stride != 0 && row->stride == 0;'),
    ('stride-asked-never', W, 'return pointer != 0 && check_action_pointer_stride(facts->machine->types, pointer) != 0;', 'return pointer != 0 && check_action_pointer_stride(facts->machine->types, pointer) == 0 && pointer == 0;'),
    ('stride-asked-always', W, 'return pointer != 0 && check_action_pointer_stride(facts->machine->types, pointer) != 0;', 'return pointer != 0 || check_action_pointer_stride(facts->machine->types, pointer) != 0;'),
    ('stride-not-asked', W, 'if (__builtin_expect((row->flags & BUSTER_NODE_FACTS_STRIDE) == 0, 0))', 'if (__builtin_expect((row->flags & BUSTER_NODE_FACTS_STRIDE) == 0 && pointer == 0, 0))'),
    # the far lanes
    ('far-consumer-template', W, 'far_bytes[BUSTER_NODE_CONTEXTS_FAR_TEMPLATE][lane] = state->window_c_templates[consumer];', 'far_bytes[BUSTER_NODE_CONTEXTS_FAR_TEMPLATE][lane] = (uint8_t)(state->window_c_templates[consumer] & 0);'),
    ('far-consumer-class', W, 'far_bytes[BUSTER_NODE_CONTEXTS_FAR_CONSUMER_CLASS][lane] = tables->classes[code];', 'far_bytes[BUSTER_NODE_CONTEXTS_FAR_CONSUMER_CLASS][lane] = (uint8_t)(tables->classes[code] & 0);'),
    ('far-left-code', W, 'far_bytes[BUSTER_NODE_CONTEXTS_FAR_LEFT_CODE][lane] = front->ops[operand] & 0x7f;', 'far_bytes[BUSTER_NODE_CONTEXTS_FAR_LEFT_CODE][lane] = (front->ops[operand] & 0x7f) | 0x7f;'),
    ('far-left-class', W, 'far_bytes[BUSTER_NODE_CONTEXTS_FAR_LEFT_CLASS][lane] = state->window_c_classes[operand];', 'far_bytes[BUSTER_NODE_CONTEXTS_FAR_LEFT_CLASS][lane] = (uint8_t)(state->window_c_classes[operand] & 0);'),
    ('far-left-facts', W, 'far_bytes[BUSTER_NODE_CONTEXTS_FAR_LEFT_FACTS][lane] = state->window_c_facts[operand];', 'far_bytes[BUSTER_NODE_CONTEXTS_FAR_LEFT_FACTS][lane] = (uint8_t)(state->window_c_facts[operand] & 0);'),
    ('far-left-kind', W, 'far_bytes[BUSTER_NODE_CONTEXTS_FAR_LEFT_KIND][lane] = state->window_c_kinds[operand];', 'far_bytes[BUSTER_NODE_CONTEXTS_FAR_LEFT_KIND][lane] = (uint8_t)(state->window_c_kinds[operand] & 0);'),
    ('far-left-flags', W, 'far_bytes[BUSTER_NODE_CONTEXTS_FAR_LEFT_FLAGS][lane] = state->window_c_flags[operand];', 'far_bytes[BUSTER_NODE_CONTEXTS_FAR_LEFT_FLAGS][lane] = (uint8_t)(state->window_c_flags[operand] & 0);'),
    ('far-left-not-near', W, '            near_left |= far_left;\n', '            near_left |= far_left & 0;\n'),
    ('far-left-unplaced-too', W, '        far_left &= placed;\n', '        far_left &= placed | ~(__mmask64)0;\n'),
    ('far-up-unplaced-too', W, '        far_up &= placed;\n', '        far_up &= placed | ~(__mmask64)0;\n'),
    ('far-count-not', W, 'far_count += (uint64_t)_mm_popcnt_u64(far_up) + (uint64_t)_mm_popcnt_u64(far_left);', 'far_count += (uint64_t)_mm_popcnt_u64(far_up);'),
    ('far-template-not-blended', W, '_mm512_mask_loadu_epi8(near_templates, far_up, far_bytes[BUSTER_NODE_CONTEXTS_FAR_TEMPLATE]);', '_mm512_mask_loadu_epi8(near_templates, far_up & 0, far_bytes[BUSTER_NODE_CONTEXTS_FAR_TEMPLATE]);'),
    # the operands' bytes
    ('decay-arrays-only', W, 'const __m512i decayed = _mm512_set1_epi8(BUSTER_TYPE_KIND_FUNCTION - BUSTER_TYPE_KIND_ARRAY);', 'const __m512i decayed = _mm512_set1_epi8(BUSTER_TYPE_KIND_VARIABLE_ARRAY - BUSTER_TYPE_KIND_ARRAY);'),
    ('decay-sized-arrays-only', W, 'const __m512i decayed = _mm512_set1_epi8(BUSTER_TYPE_KIND_FUNCTION - BUSTER_TYPE_KIND_ARRAY);', 'const __m512i decayed = _mm512_set1_epi8(BUSTER_TYPE_KIND_INCOMPLETE_ARRAY - BUSTER_TYPE_KIND_ARRAY);'),
    ('decay-fixed-arrays-only', W, 'const __m512i decayed = _mm512_set1_epi8(BUSTER_TYPE_KIND_FUNCTION - BUSTER_TYPE_KIND_ARRAY);', 'const __m512i decayed = _mm512_set1_epi8(BUSTER_TYPE_KIND_ARRAY - BUSTER_TYPE_KIND_ARRAY);'),
    ('scalars-to-f80', W, 'const __m512i scalars = _mm512_set1_epi8(BUSTER_TYPED_CLASS_F64 - BUSTER_TYPED_CLASS_I8);', 'const __m512i scalars = _mm512_set1_epi8(BUSTER_TYPED_CLASS_F80 - BUSTER_TYPED_CLASS_I8);'),
    ('scalars-to-f32', W, 'const __m512i scalars = _mm512_set1_epi8(BUSTER_TYPED_CLASS_F64 - BUSTER_TYPED_CLASS_I8);', 'const __m512i scalars = _mm512_set1_epi8(BUSTER_TYPED_CLASS_F32 - BUSTER_TYPED_CLASS_I8);'),
    ('testable-to-f80', W, 'const __mmask64 testable = _mm512_cmplt_epu8_mask(left_classes, _mm512_set1_epi8(BUSTER_TYPED_CLASS_VECTOR));', 'const __mmask64 testable = _mm512_cmplt_epu8_mask(left_classes, _mm512_set1_epi8(BUSTER_TYPED_CLASS_F80));'),
    ('named-unknown-too', W, 'const __m512i named_bits = _mm512_set1_epi8(BUSTER_NODE_CONTEXTS_OBJECT | BUSTER_NODE_CONTEXTS_KNOWN);', 'const __m512i named_bits = _mm512_set1_epi8(BUSTER_NODE_CONTEXTS_OBJECT);'),
    ('named-objectless-too', W, 'const __m512i named_bits = _mm512_set1_epi8(BUSTER_NODE_CONTEXTS_OBJECT | BUSTER_NODE_CONTEXTS_KNOWN);', 'const __m512i named_bits = _mm512_set1_epi8(BUSTER_NODE_CONTEXTS_KNOWN);'),
    ('integer-to-u128', W, 'const __mmask64 integer = _mm512_cmple_epu8_mask(from_i8, _mm512_set1_epi8(BUSTER_TYPED_CLASS_U64 - BUSTER_TYPED_CLASS_I8));',
     'const __mmask64 integer = _mm512_cmple_epu8_mask(from_i8, _mm512_set1_epi8(BUSTER_TYPED_CLASS_U128 - BUSTER_TYPED_CLASS_I8));'),
    ('small-to-f64', W, 'const __mmask64 small = aggregate | _mm512_cmplt_epu8_mask(type_classes, _mm512_set1_epi8(BUSTER_TYPED_CLASS_VECTOR));',
     'const __mmask64 small = aggregate | _mm512_cmplt_epu8_mask(type_classes, _mm512_set1_epi8(BUSTER_TYPED_CLASS_F80));'),
    ('small-not-aggregate', W, 'const __mmask64 small = aggregate | _mm512_cmplt_epu8_mask(type_classes, _mm512_set1_epi8(BUSTER_TYPED_CLASS_VECTOR));',
     'const __mmask64 small = (aggregate & 0) | _mm512_cmplt_epu8_mask(type_classes, _mm512_set1_epi8(BUSTER_TYPED_CLASS_VECTOR));'),
    ('unfit-complex-only', W, '_mm512_set1_epi8((char)(BUSTER_CHECK_LOWER_TYPE_BIT_INT | BUSTER_CHECK_LOWER_TYPE_COMPLEX)));', '_mm512_set1_epi8((char)(BUSTER_CHECK_LOWER_TYPE_COMPLEX)));'),
    ('unfit-bit-int-only', W, '_mm512_set1_epi8((char)(BUSTER_CHECK_LOWER_TYPE_BIT_INT | BUSTER_CHECK_LOWER_TYPE_COMPLEX)));', '_mm512_set1_epi8((char)(BUSTER_CHECK_LOWER_TYPE_BIT_INT)));'),
    ('floating-f32-only', W, '''        const __mmask64 floating = _mm512_cmpeq_epi8_mask(type_classes, _mm512_set1_epi8(BUSTER_TYPED_CLASS_F32)) |
                                   _mm512_cmpeq_epi8_mask(type_classes, _mm512_set1_epi8(BUSTER_TYPED_CLASS_F64));''',
     '        const __mmask64 floating = _mm512_cmpeq_epi8_mask(type_classes, _mm512_set1_epi8(BUSTER_TYPED_CLASS_F32));'),
    ('floating-f64-only', W, '''        const __mmask64 floating = _mm512_cmpeq_epi8_mask(type_classes, _mm512_set1_epi8(BUSTER_TYPED_CLASS_F32)) |
                                   _mm512_cmpeq_epi8_mask(type_classes, _mm512_set1_epi8(BUSTER_TYPED_CLASS_F64));''',
     '        const __mmask64 floating = _mm512_cmpeq_epi8_mask(type_classes, _mm512_set1_epi8(BUSTER_TYPED_CLASS_F64));'),
    ('leaf-literal-line-not', W, '''        const __mmask64 leaf = _mm512_cmpeq_epi8_mask(leaf_kinds, _mm512_set1_epi8(BUSTER_NODE_FACTS_IDENTIFIER)) |
                               _mm512_cmpeq_epi8_mask(leaf_kinds, _mm512_set1_epi8(BUSTER_NODE_FACTS_LITERAL_LINE));''',
     '        const __mmask64 leaf = _mm512_cmpeq_epi8_mask(leaf_kinds, _mm512_set1_epi8(BUSTER_NODE_FACTS_IDENTIFIER));'),
    ('places-capped-at-one', W, 'const __m512i places = _mm512_min_epu8(_mm512_loadu_si512(front->places + x), _mm512_set1_epi8(3));',
     'const __m512i places = _mm512_min_epu8(_mm512_loadu_si512(front->places + x), _mm512_set1_epi8(1));'),
    # the rules' terms
    ('folds-with-effects', W, 'const __mmask64 folds = constant & ~effects & (rvalue |', 'const __mmask64 folds = constant & ~(effects & 0) & (rvalue |'),
    ('folds-rvalue-only', W, '(rvalue | ((address | address_value) & address_constant));', '(rvalue | ((address | address_value) & address_constant & 0));'),
    ('folds-address-context-only', W, '(rvalue | ((address | address_value) & address_constant));', '(rvalue | ((address | (address_value & 0)) & address_constant));'),
    ('folds-address-value-only', W, '(rvalue | ((address | address_value) & address_constant));', '(rvalue | (((address & 0) | address_value) & address_constant));'),
    ('folds-any-placed', W, '(rvalue | ((address | address_value) & address_constant));', '(rvalue | ((address | address_value) & (address_constant | ~(__mmask64)0)));'),
    ('takes-unknown-object', W, 'const __mmask64 takes = (address_constant & (~has_object | known)) |', 'const __mmask64 takes = (address_constant & (~has_object | known | ~(__mmask64)0)) |'),
    ('takes-objectless-not', W, 'const __mmask64 takes = (address_constant & (~has_object | known)) |', 'const __mmask64 takes = (address_constant & ((~has_object & 0) | known)) |'),
    ('takes-integer-not', W, '(~address_constant & (integer | (floating_constant & floating)));', '(~address_constant & ((integer & 0) | (floating_constant & floating)));'),
    ('takes-floating-not', W, '(~address_constant & (integer | (floating_constant & floating)));', '(~address_constant & (integer | (floating_constant & floating & 0)));'),
    ('takes-any-floating-class', W, '(~address_constant & (integer | (floating_constant & floating)));', '(~address_constant & (integer | (floating_constant & (floating | ~(__mmask64)0))));'),
    ('takes-floating-typed', W, '(~address_constant & (integer | (floating_constant & floating)));', '(~address_constant & (integer | ((floating_constant | ~(__mmask64)0) & floating)));'),
    ('shared-atomic-addressed', W, 'const __mmask64 shared = unfit | (~address & lvalue & atomic);', 'const __mmask64 shared = unfit | (~(address & 0) & lvalue & atomic);'),
    ('shared-atomic-rvalue', W, 'const __mmask64 shared = unfit | (~address & lvalue & atomic);', 'const __mmask64 shared = unfit | (~address & (lvalue | ~(__mmask64)0) & atomic);'),
    ('placed-value-context-only', W, 'const __mmask64 placed_value = address | address_value;', 'const __mmask64 placed_value = address | (address_value & 0);'),
    ('placed-value-fact-only', W, 'const __mmask64 placed_value = address | address_value;', 'const __mmask64 placed_value = (address & 0) | address_value;'),
    ('named-value-placed', W, 'const __mmask64 named_value = is_value & ~placed_value & lvalue & known & numeric;', 'const __mmask64 named_value = is_value & ~(placed_value & 0) & lvalue & known & numeric;'),
    ('named-value-rvalue', W, 'const __mmask64 named_value = is_value & ~placed_value & lvalue & known & numeric;', 'const __mmask64 named_value = is_value & ~placed_value & (lvalue | ~(__mmask64)0) & known & numeric;'),
    ('named-value-unknown', W, 'const __mmask64 named_value = is_value & ~placed_value & lvalue & known & numeric;', 'const __mmask64 named_value = is_value & ~placed_value & lvalue & (known | ~(__mmask64)0) & numeric;'),
    ('named-value-any-class', W, 'const __mmask64 named_value = is_value & ~placed_value & lvalue & known & numeric;', 'const __mmask64 named_value = is_value & ~placed_value & lvalue & known & (numeric | ~(__mmask64)0);'),
    ('storable-any-class', W, 'const __mmask64 storable = is_assign & numeric & ~left_atomic;', 'const __mmask64 storable = is_assign & (numeric | ~(__mmask64)0) & ~left_atomic;'),
    ('storable-atomic', W, 'const __mmask64 storable = is_assign & numeric & ~left_atomic;', 'const __mmask64 storable = is_assign & numeric & ~(left_atomic & 0);'),
    ('constant-shared', W, 'const __mmask64 made_constant = ~shared & folds & takes;', 'const __mmask64 made_constant = ~(shared & 0) & folds & takes;'),
    ('constant-untaken', W, 'const __mmask64 made_constant = ~shared & folds & takes;', 'const __mmask64 made_constant = ~shared & folds & (takes | ~(__mmask64)0);'),
    ('address-of-void', W, 'const __mmask64 made_address = free & is_value & ~void_type & placed_value & (~has_object | known);', 'const __mmask64 made_address = free & is_value & ~(void_type & 0) & placed_value & (~has_object | known);'),
    ('address-unknown-object', W, 'const __mmask64 made_address = free & is_value & ~void_type & placed_value & (~has_object | known);', 'const __mmask64 made_address = free & is_value & ~void_type & placed_value & (~has_object | known | ~(__mmask64)0);'),
    ('address-objectless-not', W, 'const __mmask64 made_address = free & is_value & ~void_type & placed_value & (~has_object | known);', 'const __mmask64 made_address = free & is_value & ~void_type & placed_value & ((~has_object & 0) | known);'),
    ('local-with-symbol', W, 'const __mmask64 made_local = free & named_value & ~symbol;', 'const __mmask64 made_local = free & named_value & ~(symbol & 0);'),
    ('pass-wide-wrap', W, 'const __mmask64 made_pass = free & ((is_wrap & small) | is_address);', 'const __mmask64 made_pass = free & ((is_wrap & (small | ~(__mmask64)0)) | is_address);'),
    ('pass-no-address', W, 'const __mmask64 made_pass = free & ((is_wrap & small) | is_address);', 'const __mmask64 made_pass = free & ((is_wrap & small) | (is_address & 0));'),
    ('pass-no-wrap', W, 'const __mmask64 made_pass = free & ((is_wrap & small) | is_address);', 'const __mmask64 made_pass = free & ((is_wrap & small & 0) | is_address);'),
    ('dereference-any', W, 'const __mmask64 made_dereference = free & is_dereference & (placed_value | numeric);', 'const __mmask64 made_dereference = free & is_dereference & (placed_value | numeric | ~(__mmask64)0);'),
    ('dereference-numeric-only', W, 'const __mmask64 made_dereference = free & is_dereference & (placed_value | numeric);', 'const __mmask64 made_dereference = free & is_dereference & ((placed_value & 0) | numeric);'),
    ('dereference-placed-only', W, 'const __mmask64 made_dereference = free & is_dereference & (placed_value | numeric);', 'const __mmask64 made_dereference = free & is_dereference & (placed_value | (numeric & 0));'),
    ('member-any', W, 'const __mmask64 made_member = free & is_member & (placed_value | numeric);', 'const __mmask64 made_member = free & is_member & (placed_value | numeric | ~(__mmask64)0);'),
    ('member-numeric-only', W, 'const __mmask64 made_member = free & is_member & (placed_value | numeric);', 'const __mmask64 made_member = free & is_member & ((placed_value & 0) | numeric);'),
    ('member-placed-only', W, 'const __mmask64 made_member = free & is_member & (placed_value | numeric);', 'const __mmask64 made_member = free & is_member & (placed_value | (numeric & 0));'),
    ('unary-any-class', W, 'const __mmask64 made_unary = free & is_unary & numeric;', 'const __mmask64 made_unary = free & is_unary & (numeric | ~(__mmask64)0);'),
    ('truth-untestable', W, 'const __mmask64 made_truth = free & is_truth & numeric & testable;', 'const __mmask64 made_truth = free & is_truth & numeric & (testable | ~(__mmask64)0);'),
    ('truth-any-class', W, 'const __mmask64 made_truth = free & is_truth & numeric & testable;', 'const __mmask64 made_truth = free & is_truth & (numeric | ~(__mmask64)0) & testable;'),
    ('binary-any-class', W, 'const __mmask64 made_binary = free & numeric & both_scalar &', 'const __mmask64 made_binary = free & (numeric | ~(__mmask64)0) & both_scalar &'),
    ('binary-unscalar', W, 'const __mmask64 made_binary = free & numeric & both_scalar &', 'const __mmask64 made_binary = free & numeric & (both_scalar | ~(__mmask64)0) &'),
    ('binary-sum-of-left-pointer', W, '((is_sum & ~left_pointer & ~right_pointer) | is_binary);', '((is_sum & ~(left_pointer & 0) & ~right_pointer) | is_binary);'),
    ('binary-sum-of-right-pointer', W, '((is_sum & ~left_pointer & ~right_pointer) | is_binary);', '((is_sum & ~left_pointer & ~(right_pointer & 0)) | is_binary);'),
    ('binary-no-sum', W, '((is_sum & ~left_pointer & ~right_pointer) | is_binary);', '((is_sum & ~left_pointer & ~right_pointer & 0) | is_binary);'),
    ('binary-no-operator', W, '((is_sum & ~left_pointer & ~right_pointer) | is_binary);', '((is_sum & ~left_pointer & ~right_pointer) | (is_binary & 0));'),
    ('store-local-of-global', W, 'const __mmask64 made_store_local = free & storable & named & ~named_global;', 'const __mmask64 made_store_local = free & storable & named & ~(named_global & 0);'),
    ('store-unnamed-of-named', W, 'const __mmask64 made_store = free & storable & ~named;', 'const __mmask64 made_store = free & storable & ~(named & 0);'),
    ('pointed-right-pointer', W, '& placed & left_pointer & ~right_pointer & (~is_subscript | placed_value | numeric);', '& placed & left_pointer & ~(right_pointer & 0) & (~is_subscript | placed_value | numeric);'),
    ('pointed-left-any', W, '& placed & left_pointer & ~right_pointer & (~is_subscript | placed_value | numeric);', '& placed & (left_pointer | ~(__mmask64)0) & ~right_pointer & (~is_subscript | placed_value | numeric);'),
    ('pointed-any-subscript', W, '& placed & left_pointer & ~right_pointer & (~is_subscript | placed_value | numeric);', '& placed & left_pointer & ~right_pointer & (~is_subscript | placed_value | numeric | ~(__mmask64)0);'),
    ('pointed-unplaced', W, '& placed & left_pointer & ~right_pointer & (~is_subscript | placed_value | numeric);', '& (placed | ~(__mmask64)0) & left_pointer & ~right_pointer & (~is_subscript | placed_value | numeric);'),
    ('pointed-sum-not', W, 'uint64_t pointed = (is_sum | is_subscript) & free', 'uint64_t pointed = ((is_sum & 0) | is_subscript) & free'),
    ('pointed-subscript-not', W, 'uint64_t pointed = (is_sum | is_subscript) & free', 'uint64_t pointed = (is_sum | (is_subscript & 0)) & free'),
    ('pointed-shared', W, 'uint64_t pointed = (is_sum | is_subscript) & free', 'uint64_t pointed = (is_sum | is_subscript) & (free | ~(__mmask64)0)'),
    ('listed-union-cast-not', W, 'const __mmask64 listed = placed & (is_uncased | (is_wrap & union_type) | divisor | wide | stray);', 'const __mmask64 listed = placed & (is_uncased | (is_wrap & union_type & 0) | divisor | wide | stray);'),
    ('listed-any-union', W, 'const __mmask64 listed = placed & (is_uncased | (is_wrap & union_type) | divisor | wide | stray);', 'const __mmask64 listed = placed & (is_uncased | ((is_wrap | ~(__mmask64)0) & union_type) | divisor | wide | stray);'),
    ('bit0-no-store', W, 'made_dereference | made_unary | made_binary | made_store_local | made_store;\n        const __mmask64 bit1', 'made_dereference | made_unary | made_binary | made_store_local | (made_store & 0);\n        const __mmask64 bit1'),
    ('bit1-no-truth', W, 'const __mmask64 bit1 = made_void | made_address | made_pass | made_dereference | made_truth |', 'const __mmask64 bit1 = made_void | made_address | made_pass | made_dereference | (made_truth & 0) |'),
    ('bit2-no-local', W, 'const __mmask64 bit2 = made_local | made_global |', 'const __mmask64 bit2 = (made_local & 0) | made_global |'),
    ('bit3-no-pointer', W, 'const __mmask64 bit3 = made_member | made_unary | made_truth | made_binary | made_pointer |', 'const __mmask64 bit3 = made_member | made_unary | made_truth | made_binary | (made_pointer & 0) |'),
    # the evaluated records
    ('sources-of-roots', W, 'const __m512i sources = _mm512_maskz_mov_epi8(has_up & ~rooted & ~addressed,', 'const __m512i sources = _mm512_maskz_mov_epi8(has_up & ~(rooted & 0) & ~addressed,'),
    ('dead-ranges-not', W, 'for (uint64_t pending = placed & ~evaluates & ~is_value; pending != 0; pending &= pending - 1)\n        {\n            const uint32_t lane = (uint32_t)_tzcnt_u64(pending);\n            const uint32_t size = front->sizes[x + lane];',
     'for (uint64_t pending = placed & ~evaluates & ~is_value & 0; pending != 0; pending &= pending - 1)\n        {\n            const uint32_t lane = (uint32_t)_tzcnt_u64(pending);\n            const uint32_t size = front->sizes[x + lane];'),
    ('dead-ranges-of-leaves', W, 'for (uint64_t pending = placed & ~evaluates & ~is_value; pending != 0; pending &= pending - 1)\n        {\n            const uint32_t lane = (uint32_t)_tzcnt_u64(pending);\n            const uint32_t size = front->sizes[x + lane];',
     'for (uint64_t pending = placed & ~evaluates & ~(is_value & 0); pending != 0; pending &= pending - 1)\n        {\n            const uint32_t lane = (uint32_t)_tzcnt_u64(pending);\n            const uint32_t size = front->sizes[x + lane];'),
    ('dead-range-one-short', W, 'const uint32_t low = x + lane + 1 - (size < x + lane + 1 ? size : x + lane + 1);', 'const uint32_t low = x + lane + 2 - (size < x + lane + 1 ? size : x + lane + 1);'),
    ('dead-low-lost', W, 'dead_low = low < x && low < dead_low ? low : dead_low;', 'dead_low = low < x && low < dead_low && low > x ? low : dead_low;'),
    ('dead-carried-not', W, 'uint64_t dead = dead_low <= x ? ~UINT64_C(0) : dead_low < x + 64 ? ~UINT64_C(0) << (dead_low - x) : 0;', 'uint64_t dead = dead_low <= x && dead_low > x ? ~UINT64_C(0) : 0;'),
    ('dead-low-kept', W, 'dead_low = dead_low < x ? dead_low : UINT32_MAX;', 'dead_low = dead_low < x ? dead_low : dead_low;'),
    ('alive-dead-too', W, 'const __mmask64 alive = placed & evaluates & ~dead;', 'const __mmask64 alive = placed & evaluates & ~(dead & 0);'),
    ('mask-none-of-dead', W, 'masks[BUSTER_NODE_CONTEXTS_MASK_NONE] = alive & _mm512_testn_epi8_mask(templates, templates);', 'masks[BUSTER_NODE_CONTEXTS_MASK_NONE] = placed & _mm512_testn_epi8_mask(templates, templates);'),
    ('next-templates-stale', W, '        next_templates = templates;\n', '        next_templates = _mm512_or_si512(next_templates, _mm512_and_si512(templates, zero));\n'),
    ('next-classes-stale', W, '        next_classes = classes;\n', '        next_classes = _mm512_or_si512(next_classes, _mm512_and_si512(classes, zero));\n'),
    ('next-codes-stale', W, '        next_codes = codes;\n', '        next_codes = _mm512_or_si512(next_codes, _mm512_and_si512(codes, zero));\n'),
    # the targets
    ('target-first-conversion-only', W, '_mm512_slli_epi32(_mm512_min_epu32(places, _mm512_set1_epi32(1)), 2));', '_mm512_slli_epi32(_mm512_min_epu32(places, _mm512_set1_epi32(0)), 2));'),
    ('target-long-int', W, '_mm512_mask_mov_epi32(gathered, index, _mm512_set1_epi32((int32_t)BUSTER_TYPE_LONG));', '_mm512_mask_mov_epi32(gathered, index, _mm512_set1_epi32((int32_t)BUSTER_TYPE_INT));'),
    ('target-index-not', W, '_mm512_mask_mov_epi32(gathered, index, _mm512_set1_epi32((int32_t)BUSTER_TYPE_LONG));', '_mm512_mask_mov_epi32(gathered, index & 0, _mm512_set1_epi32((int32_t)BUSTER_TYPE_LONG));'),
    ('target-own-line', W, 'const __m512i consumers = _mm512_add_epi32(_mm512_add_epi32(_mm512_set1_epi32((int32_t)x), lanes), ups);', 'const __m512i consumers = _mm512_add_epi32(_mm512_add_epi32(_mm512_set1_epi32((int32_t)x), lanes), _mm512_and_si512(ups, _mm512_setzero_si512()));'),
    # an expression's part
    ('part-root-listed-not', W, '((root_masks[BUSTER_NODE_CONTEXTS_MASK_LISTED] & root_bit) != 0);', '((root_masks[BUSTER_NODE_CONTEXTS_MASK_LISTED] & root_bit & 0) != 0);'),
    ('part-root-refused-not', W, '((root_masks[BUSTER_NODE_CONTEXTS_MASK_NONE] & root_bit) != 0);', '((root_masks[BUSTER_NODE_CONTEXTS_MASK_NONE] & root_bit & 0) != 0);'),
    ('part-range-one-short', W, 'const uint64_t taken = short_size == 64 ? ~UINT64_C(0) : (UINT64_C(1) << short_size) - 1;', 'const uint64_t taken = short_size == 64 ? ~UINT64_C(0) : ((UINT64_C(1) << short_size) - 1) >> 1;'),
    ('part-range-next-word-not', W, 'uint64_t any = (low | high) & taken;', 'uint64_t any = (low | (high & 0)) & taken;'),
    ('part-range-long-not', W, 'any |= masks[BUSTER_NODE_CONTEXTS_MASKS * (uint64_t)(at / 64) + mask] & bits;', 'any |= masks[BUSTER_NODE_CONTEXTS_MASKS * (uint64_t)(at / 64) + mask] & bits & 0;'),
    ('part-root-target-of-operand', W, 'state->window_c_targets[rooted ? record : operand] = state->c_targets[e];', 'state->window_c_targets[rooted && record == operand ? record : operand] = state->c_targets[e];'),
    ('part-root-target-not', W, 'state->window_c_targets[rooted ? record : operand] = state->c_targets[e];', 'state->window_c_targets[rooted ? record : operand] = state->c_targets[e] & 0;'),
    ('part-refused-as-taken', W, 'verdict = (uint8_t)(listed ? BUSTER_NODE_CONTEXTS_LISTED : refused ? BUSTER_NODE_CONTEXTS_REFUSED : BUSTER_NODE_CONTEXTS_TAKEN);',
     'verdict = (uint8_t)(listed ? BUSTER_NODE_CONTEXTS_LISTED : refused && listed ? BUSTER_NODE_CONTEXTS_REFUSED : BUSTER_NODE_CONTEXTS_TAKEN);'),
    ('part-listed-as-decided', W, 'verdict = (uint8_t)(listed ? BUSTER_NODE_CONTEXTS_LISTED : refused ? BUSTER_NODE_CONTEXTS_REFUSED : BUSTER_NODE_CONTEXTS_TAKEN);',
     'verdict = (uint8_t)(listed && refused ? BUSTER_NODE_CONTEXTS_LISTED : refused ? BUSTER_NODE_CONTEXTS_REFUSED : BUSTER_NODE_CONTEXTS_TAKEN);'),
    # the comparison and the counts
    ('compare-no-target', W, 'state->window_c_targets[x] == state->place_c_targets[x]));', '(state->window_c_targets[x] == state->place_c_targets[x] || x == x)));'),
    ('compare-no-context', W, 'state->window_c_contexts[x] == state->place_c_contexts[x] &&', '(state->window_c_contexts[x] == state->place_c_contexts[x] || x == x) &&'),
    ('compare-no-template', W, '(!alive || (state->window_c_templates[x] == state->place_c_templates[x] &&', '(!alive || ((state->window_c_templates[x] == state->place_c_templates[x] || x == x) &&'),
    ('compare-no-evaluated', W, 'const bool same = alive == evaluated && (!alive ||', 'const bool same = (alive == evaluated || x == x) && (!alive ||'),
    ('compare-verdict-not', W, 'return refused != reference_refused || wrong != 0;', 'return (refused != reference_refused && wrong != 0) || wrong != 0;'),
    ('count-strides-not', W, 'counts[NODE_FACTS_COUNT_CONTEXTS_STRIDES] += loop_counts.strides;', 'counts[NODE_FACTS_COUNT_CONTEXTS_STRIDES] += loop_counts.strides & 0;'),
    ('count-asked-not', W, 'counts[NODE_FACTS_COUNT_CONTEXTS_STRIDES_ASKED] += loop_counts.asked;', 'counts[NODE_FACTS_COUNT_CONTEXTS_STRIDES_ASKED] += loop_counts.asked & 0;'),
    ('count-far-not', W, 'counts[NODE_FACTS_COUNT_CONTEXTS_FAR] += loop_counts.far;', 'counts[NODE_FACTS_COUNT_CONTEXTS_FAR] += loop_counts.far & 0;'),
    ('count-refused-not', W, 'counts[NODE_FACTS_COUNT_CONTEXTS_REFUSED] += verdict == BUSTER_NODE_CONTEXTS_REFUSED;', 'counts[NODE_FACTS_COUNT_CONTEXTS_REFUSED] += verdict == BUSTER_NODE_CONTEXTS_REFUSED && verdict == 0;'),
    # the records' bytes
    ('bytes-symbol-never', C, 'const __mmask16 symbolled = _mm512_mask_test_epi32_mask(named, line, _mm512_set1_epi32(BUSTER_NODE_TESTS_LINE_SYMBOL));', 'const __mmask16 symbolled = _mm512_mask_test_epi32_mask(named, line, _mm512_set1_epi32(BUSTER_NODE_TESTS_LINE_SYMBOL)) & 0;'),
    ('bytes-line-symbol-never', C, '(symbol ? BUSTER_NODE_TESTS_LINE_SYMBOL : 0) |', '(symbol && !symbol ? BUSTER_NODE_TESTS_LINE_SYMBOL : 0) |'),
    ('bytes-known-all', C, 'const __mmask16 known = _mm512_mask_cmplt_epu32_mask(objected, objects, _mm512_set1_epi32((int32_t)machine->object_count));', 'const __mmask16 known = _mm512_mask_cmplt_epu32_mask(objected, objects, _mm512_set1_epi32((int32_t)machine->object_count)) | objected;'),
    ('bytes-effects-side-only', C, '_mm512_set1_epi32((int32_t)(BUSTER_CHECK_SIDE_EFFECT | BUSTER_CHECK_FP_ENVIRONMENT)));', '_mm512_set1_epi32((int32_t)(BUSTER_CHECK_SIDE_EFFECT)));'),
    ('bytes-effects-environment-only', C, '_mm512_set1_epi32((int32_t)(BUSTER_CHECK_SIDE_EFFECT | BUSTER_CHECK_FP_ENVIRONMENT)));', '_mm512_set1_epi32((int32_t)(BUSTER_CHECK_FP_ENVIRONMENT)));'),
    ('bytes-standing-not', C, 'standing_bytes = _mm512_cvtepi32_epi8(standings);', 'standing_bytes = _mm512_cvtepi32_epi8(_mm512_and_si512(standings, _mm512_set1_epi32(0x7f)));'),
    # the front's distance
    ('ups-first-operand-not', F, '                if (window)\n                {\n                    front->window_ups[operand] = (uint16_t)(record - operand);', '                if (window && k != 0)\n                {\n                    front->window_ups[operand] = (uint16_t)(record - operand);'),
    ('ups-second-operand-not', F, '                if (window)\n                {\n                    front->window_ups[operand] = (uint16_t)(record - operand);', '                if (window && k != 1)\n                {\n                    front->window_ups[operand] = (uint16_t)(record - operand);'),
    ('ups-kept-not', F, '    front->window_ups[to] = front->window_ups[from];\n', '    front->window_ups[to] = (uint16_t)(front->window_ups[from] & 0);\n'),
    # the reference kept for the comparison
    ('reference-refused-as-taken', R, 'swept == NODE_MACHINE_TAKEN ? BUSTER_NODE_CONTEXTS_RAN_TAKEN : BUSTER_NODE_CONTEXTS_RAN_REFUSED;', 'swept == NODE_MACHINE_TAKEN ? BUSTER_NODE_CONTEXTS_RAN_TAKEN : BUSTER_NODE_CONTEXTS_RAN_TAKEN;'),
]

DROPPED = [name for name, f, a, b in FAULTS if open(SRC + f).read().count(a) != 1]
FAULTS = [fault for fault in FAULTS if fault[0] not in DROPPED]
FAULTS += [
    # the rows whose target is the consumer's own type
    ('row-pass-given', W, '    tables->rows[CHECK_LOWER_TEMPLATE_PASS << 2] = node;\n', '    tables->rows[CHECK_LOWER_TEMPLATE_PASS << 2] = given;\n'),
    ('row-store-local-given', W, '    tables->rows[(CHECK_LOWER_TEMPLATE_STORE_LOCAL << 2) + 1] = node;\n', '    tables->rows[(CHECK_LOWER_TEMPLATE_STORE_LOCAL << 2) + 1] = given;\n'),
    ('row-store-global-given', W, '    tables->rows[(CHECK_LOWER_TEMPLATE_STORE_GLOBAL << 2) + 1] = node;\n', '    tables->rows[(CHECK_LOWER_TEMPLATE_STORE_GLOBAL << 2) + 1] = given;\n'),
    ('row-store-given', W, '    tables->rows[(CHECK_LOWER_TEMPLATE_STORE << 2) + 1] = node;\n', '    tables->rows[(CHECK_LOWER_TEMPLATE_STORE << 2) + 1] = given;\n'),
    ('targets-node-as-conversion', W, 'const __m512i fields = _mm512_mask_mov_epi32(converted, node, _mm512_set1_epi32((int32_t)offsetof(NodeFactsRecord, type)));',
     'const __m512i fields = _mm512_mask_mov_epi32(converted, (__mmask16)(node & 0), _mm512_set1_epi32((int32_t)offsetof(NodeFactsRecord, type)));'),
    ('targets-node-not-gathered', W, '_mm512_mask_i32gather_epi32(_mm512_setzero_si512(), given | node, offsets, records, 1);', '_mm512_mask_i32gather_epi32(_mm512_setzero_si512(), given | (__mmask16)(node & 0), offsets, records, 1);'),
    # the terms the corrections brought
    ('small-aggregates-not', W, ' |\n                                _mm512_test_epi8_mask(facts, _mm512_set1_epi8(BUSTER_CHECK_LOWER_TYPE_AGGREGATE));', ' |\n                                (_mm512_test_epi8_mask(facts, _mm512_set1_epi8(BUSTER_CHECK_LOWER_TYPE_AGGREGATE)) & 0);'),
    ('testable-aggregates-too', W, '_mm512_testn_epi8_mask(left_facts, _mm512_set1_epi8(BUSTER_CHECK_LOWER_TYPE_AGGREGATE));', '(_mm512_testn_epi8_mask(left_facts, _mm512_set1_epi8(BUSTER_CHECK_LOWER_TYPE_AGGREGATE)) | ~(__mmask64)0);'),
    ('testable-void-too', W, '& _mm512_test_epi8_mask(left_classes, left_classes) &', '& (_mm512_test_epi8_mask(left_classes, left_classes) | ~(__mmask64)0) &'),
    ('takes-no-integral', W, 'const __mmask64 takes = address_constant | integral | (floating_constant & numeric);', 'const __mmask64 takes = address_constant | (integral & 0) | (floating_constant & numeric);'),
    ('takes-no-floating', W, 'const __mmask64 takes = address_constant | integral | (floating_constant & numeric);', 'const __mmask64 takes = address_constant | integral | (floating_constant & numeric & 0);'),
    ('takes-any-number', W, 'const __mmask64 takes = address_constant | integral | (floating_constant & numeric);', 'const __mmask64 takes = address_constant | integral | ((floating_constant | ~(__mmask64)0) & numeric);'),
    ('takes-no-address', W, 'const __mmask64 takes = address_constant | integral | (floating_constant & numeric);', 'const __mmask64 takes = (address_constant & 0) | integral | (floating_constant & numeric);'),
    ('folds-rvalue-in-a-place', W, '((rvalue & ~address) | ((address | address_value) & address_constant));', '((rvalue & (~address | ~(__mmask64)0)) | ((address | address_value) & address_constant));'),
    ('shared-atomic-rvalue-too', W, 'const __mmask64 shared = unfit | (~address & lvalue & atomic);', 'const __mmask64 shared = unfit | (~address & (lvalue | ~(__mmask64)0) & atomic);'),
    ('shared-atomic-place-too', W, 'const __mmask64 shared = unfit | (~address & lvalue & atomic);', 'const __mmask64 shared = unfit | ((~address | ~(__mmask64)0) & lvalue & atomic);'),
    ('named-value-rvalue-too', W, 'is_value & ~placed_value & lvalue & has_object & numeric;', 'is_value & ~placed_value & (lvalue | ~(__mmask64)0) & has_object & numeric;'),
    ('odd-leaf-effects-not', W, 'const __mmask64 odd_leaf = is_value & (effects | (free & (void_type | placed_value)));', 'const __mmask64 odd_leaf = is_value & ((effects & 0) | (free & (void_type | placed_value)));'),
    ('odd-leaf-void-not', W, 'const __mmask64 odd_leaf = is_value & (effects | (free & (void_type | placed_value)));', 'const __mmask64 odd_leaf = is_value & (effects | (free & ((void_type & 0) | placed_value)));'),
    ('odd-leaf-place-not', W, 'const __mmask64 odd_leaf = is_value & (effects | (free & (void_type | placed_value)));', 'const __mmask64 odd_leaf = is_value & (effects | (free & (void_type | (placed_value & 0))));'),
    ('pass-wrapper-any-class', W, 'const __mmask64 made_pass = free & ((is_wrap & small) | is_address);', 'const __mmask64 made_pass = free & ((is_wrap & (small | ~(__mmask64)0)) | is_address);'),
    ('member-vector-too', W, 'const __mmask64 made_member = free & is_member & ~vector & (placed_value | numeric);', 'const __mmask64 made_member = free & is_member & (~vector | ~(__mmask64)0) & (placed_value | numeric);'),
    ('own-binary-vector-too', W, '((is_sum & ~vector & ~either_pointer) | is_binary);\n        const __mmask64 made_store_local', '((is_sum & (~vector | ~(__mmask64)0) & ~either_pointer) | is_binary);\n        const __mmask64 made_store_local'),
    ('own-binary-pointers-too', W, '((is_sum & ~vector & ~either_pointer) | is_binary);\n        const __mmask64 made_store_local', '((is_sum & ~vector & (~either_pointer | ~(__mmask64)0)) | is_binary);\n        const __mmask64 made_store_local'),
    ('sums-vector-too', W, 'const __mmask64 sums = (is_sum | is_subscript) & free & placed & ~vector &', 'const __mmask64 sums = (is_sum | is_subscript) & free & placed & (~vector | ~(__mmask64)0) &'),
    ('sums-subscript-any-value', W, '& (~is_subscript | placed_value | numeric);\n        uint64_t pointed', '& (~is_subscript | placed_value | numeric | ~(__mmask64)0);\n        uint64_t pointed'),
    ('pointed-right-pointer-too', W, 'uint64_t pointed = sums & left_pointer & ~right_pointer;', 'uint64_t pointed = sums & left_pointer & (~right_pointer | ~(__mmask64)0);'),
    ('pointed-any-left', W, 'uint64_t pointed = sums & left_pointer & ~right_pointer;', 'uint64_t pointed = sums & (left_pointer | ~(__mmask64)0) & ~right_pointer;'),
    # the records whose rule reads T's conversions
    ('unsure-vector-too', W, '~both_scalar & ((is_sum & ~vector & ~either_pointer) | is_binary);', '~both_scalar & ((is_sum & (~vector | ~(__mmask64)0) & ~either_pointer) | is_binary);'),
    ('unsure-pointers-too', W, '~both_scalar & ((is_sum & ~vector & ~either_pointer) | is_binary);', '~both_scalar & ((is_sum & ~vector & (~either_pointer | ~(__mmask64)0)) | is_binary);'),
    ('unsure-sums-not', W, '~both_scalar & ((is_sum & ~vector & ~either_pointer) | is_binary);', '~both_scalar & (((is_sum & 0) & ~vector & ~either_pointer) | is_binary);'),
    ('unsure-binaries-not', W, '~both_scalar & ((is_sum & ~vector & ~either_pointer) | is_binary);', '~both_scalar & ((is_sum & ~vector & ~either_pointer) | (is_binary & 0));'),
    ('unsure-subscript-pointers-too', W, 'sums & is_subscript & ~(left_pointer & ~right_pointer);', 'sums & is_subscript;'),
    ('asked-truth-as-binary', W, '(is_truth & bit) != 0 ? BUSTER_NODE_CONTEXTS_CLASS_TRUTH :', '(is_truth & bit) != 0 ? BUSTER_NODE_CONTEXTS_CLASS_BINARY :'),
    ('asked-subscript-as-sum', W, '(is_subscript & bit) != 0 ? BUSTER_NODE_CONTEXTS_CLASS_SUBSCRIPT :', '(is_subscript & bit) != 0 ? BUSTER_NODE_CONTEXTS_CLASS_SUM :'),
    ('asked-sum-as-binary', W, '(is_sum & bit) != 0 ? BUSTER_NODE_CONTEXTS_CLASS_SUM : BUSTER_NODE_CONTEXTS_CLASS_BINARY;', '(is_sum & bit) != 0 ? BUSTER_NODE_CONTEXTS_CLASS_BINARY : BUSTER_NODE_CONTEXTS_CLASS_BINARY;'),
    ('asked-binary-as-sum', W, '(is_sum & bit) != 0 ? BUSTER_NODE_CONTEXTS_CLASS_SUM : BUSTER_NODE_CONTEXTS_CLASS_BINARY;', '(is_sum & bit) != 0 ? BUSTER_NODE_CONTEXTS_CLASS_SUM : BUSTER_NODE_CONTEXTS_CLASS_SUM;'),
    ('asked-loads-always', W, 'class_kind, ((placed_value | numeric) & bit) != 0, (numeric & bit) != 0);', 'class_kind, ((placed_value | numeric) & bit) != 0 || bit != 0, (numeric & bit) != 0);'),
    ('asked-plain-always', W, 'class_kind, ((placed_value | numeric) & bit) != 0, (numeric & bit) != 0);', 'class_kind, ((placed_value | numeric) & bit) != 0, (numeric & bit) != 0 || bit != 0);'),
    ('asked-pointer-dropped', W, '_cvtu64_mask64(pointed | asked_pointer);', '_cvtu64_mask64(pointed | (asked_pointer & 0));'),
    ('asked-binary-dropped', W, 'own_binary | _cvtu64_mask64(asked_binary);', 'own_binary | _cvtu64_mask64(asked_binary & 0);'),
    ('asked-truth-dropped', W, 'own_truth | _cvtu64_mask64(asked_truth);', 'own_truth | _cvtu64_mask64(asked_truth & 0);'),
    ('asked-not-counted', W, '            converted += 1;\n', '            converted += 0;\n'),
    ('converted-pointer-any-left', W, 'if (left_pointer && !right_pointer && check_action_pointer_stride(machine->types, type_a) != 0 && (!subscript || loads))',
     'if ((left_pointer || x != UINT32_MAX) && !right_pointer && check_action_pointer_stride(machine->types, type_a) != 0 && (!subscript || loads))'),
    ('converted-pointer-right-too', W, 'if (left_pointer && !right_pointer && check_action_pointer_stride(machine->types, type_a) != 0 && (!subscript || loads))',
     'if (left_pointer && (!right_pointer || x != UINT32_MAX) && check_action_pointer_stride(machine->types, type_a) != 0 && (!subscript || loads))'),
    ('converted-pointer-any-stride', W, 'if (left_pointer && !right_pointer && check_action_pointer_stride(machine->types, type_a) != 0 && (!subscript || loads))',
     'if (left_pointer && !right_pointer && (check_action_pointer_stride(machine->types, type_a) != 0 || x != UINT32_MAX) && (!subscript || loads))'),
    ('converted-pointer-any-load', W, 'if (left_pointer && !right_pointer && check_action_pointer_stride(machine->types, type_a) != 0 && (!subscript || loads))',
     'if (left_pointer && !right_pointer && check_action_pointer_stride(machine->types, type_a) != 0 && (!subscript || loads || x != UINT32_MAX))'),
    ('converted-sum-subscript-too', W, 'else if (!subscript && plain && !left_pointer && !right_pointer && scalars)', 'else if ((!subscript || x != UINT32_MAX) && plain && !left_pointer && !right_pointer && scalars)'),
    ('converted-sum-any-class', W, 'else if (!subscript && plain && !left_pointer && !right_pointer && scalars)', 'else if (!subscript && (plain || x != UINT32_MAX) && !left_pointer && !right_pointer && scalars)'),
    ('converted-sum-left-pointer-too', W, 'else if (!subscript && plain && !left_pointer && !right_pointer && scalars)', 'else if (!subscript && plain && (!left_pointer || x != UINT32_MAX) && !right_pointer && scalars)'),
    ('converted-sum-right-pointer-too', W, 'else if (!subscript && plain && !left_pointer && !right_pointer && scalars)', 'else if (!subscript && plain && !left_pointer && (!right_pointer || x != UINT32_MAX) && scalars)'),
    ('converted-sum-any-operands', W, 'else if (!subscript && plain && !left_pointer && !right_pointer && scalars)', 'else if (!subscript && plain && !left_pointer && !right_pointer && (scalars || x != UINT32_MAX))'),
    ('converted-truth-any-class', W, 'template = plain && !left_aggregate && class_a < BUSTER_TYPED_CLASS_VECTOR && class_a != BUSTER_TYPED_CLASS_VOID ?',
     'template = (plain || x != UINT32_MAX) && !left_aggregate && class_a < BUSTER_TYPED_CLASS_VECTOR && class_a != BUSTER_TYPED_CLASS_VOID ?'),
    ('converted-truth-aggregates-too', W, 'template = plain && !left_aggregate && class_a < BUSTER_TYPED_CLASS_VECTOR && class_a != BUSTER_TYPED_CLASS_VOID ?',
     'template = plain && (!left_aggregate || x != UINT32_MAX) && class_a < BUSTER_TYPED_CLASS_VECTOR && class_a != BUSTER_TYPED_CLASS_VOID ?'),
    ('converted-truth-vectors-too', W, 'template = plain && !left_aggregate && class_a < BUSTER_TYPED_CLASS_VECTOR && class_a != BUSTER_TYPED_CLASS_VOID ?',
     'template = plain && !left_aggregate && (class_a < BUSTER_TYPED_CLASS_VECTOR || x != UINT32_MAX) && class_a != BUSTER_TYPED_CLASS_VOID ?'),
    ('converted-truth-void-too', W, 'template = plain && !left_aggregate && class_a < BUSTER_TYPED_CLASS_VECTOR && class_a != BUSTER_TYPED_CLASS_VOID ?',
     'template = plain && !left_aggregate && class_a < BUSTER_TYPED_CLASS_VECTOR && (class_a != BUSTER_TYPED_CLASS_VOID || x != UINT32_MAX) ?'),
    ('converted-binary-any-class', W, 'template = plain && scalars && !left_aggregate ? CHECK_LOWER_TEMPLATE_BINARY', 'template = (plain || x != UINT32_MAX) && scalars && !left_aggregate ? CHECK_LOWER_TEMPLATE_BINARY'),
    ('converted-binary-any-operands', W, 'template = plain && scalars && !left_aggregate ? CHECK_LOWER_TEMPLATE_BINARY', 'template = plain && (scalars || x != UINT32_MAX) && !left_aggregate ? CHECK_LOWER_TEMPLATE_BINARY'),
    ('converted-binary-aggregates-too', W, 'template = plain && scalars && !left_aggregate ? CHECK_LOWER_TEMPLATE_BINARY', 'template = plain && scalars && (!left_aggregate || x != UINT32_MAX) ? CHECK_LOWER_TEMPLATE_BINARY'),
    ('converted-scalars-left-alone', W, 'const bool scalars = node_machine_scalar_class(class_a) && node_machine_scalar_class((uint8_t)word_b);', 'const bool scalars = node_machine_scalar_class(class_a) && (node_machine_scalar_class((uint8_t)word_b) || x != UINT32_MAX);'),
    ('converted-scalars-right-alone', W, 'const bool scalars = node_machine_scalar_class(class_a) && node_machine_scalar_class((uint8_t)word_b);', 'const bool scalars = (node_machine_scalar_class(class_a) || x != UINT32_MAX) && node_machine_scalar_class((uint8_t)word_b);'),
    ('converted-second-as-first', W, 'const TypeId type_b = facts->records[x].converted[1];', 'const TypeId type_b = facts->records[x].converted[0];'),
    ('converted-first-as-second', W, 'const TypeId type_a = facts->records[x].converted[0];\n    const TypeId type_b', 'const TypeId type_a = facts->records[x].converted[1];\n    const TypeId type_b'),
    # the bytes' sweep's vector element's flag
    ('flag-vector-none', C, '_mm_maskz_set1_epi8(element, BUSTER_NODE_CONTEXTS_VECTOR)', '_mm_maskz_set1_epi8((__mmask16)(element & 0), BUSTER_NODE_CONTEXTS_VECTOR)'),
]

FAULTS += [
    ('row-pass-no-target', W, '    tables->rows[CHECK_LOWER_TEMPLATE_PASS << 2] = node;\n', '    tables->rows[CHECK_LOWER_TEMPLATE_PASS << 2] = BUSTER_NODE_CONTEXTS_EVALUATES;\n'),
    ('row-pass-dead', W, '    tables->rows[CHECK_LOWER_TEMPLATE_PASS << 2] = node;\n', '    tables->rows[CHECK_LOWER_TEMPLATE_PASS << 2] = 0;\n'),
    ('row-store-local-destination', W, '    tables->rows[(CHECK_LOWER_TEMPLATE_STORE_LOCAL << 2) + 1] = node;\n',
     '    tables->rows[(CHECK_LOWER_TEMPLATE_STORE_LOCAL << 2) + 1] = node;\n    tables->rows[CHECK_LOWER_TEMPLATE_STORE_LOCAL << 2] = BUSTER_NODE_CONTEXTS_EVALUATES;\n'),
    ('row-store-local-no-target', W, '    tables->rows[(CHECK_LOWER_TEMPLATE_STORE_LOCAL << 2) + 1] = node;\n', '    tables->rows[(CHECK_LOWER_TEMPLATE_STORE_LOCAL << 2) + 1] = BUSTER_NODE_CONTEXTS_EVALUATES;\n'),
    ('row-store-global-destination', W, '    tables->rows[(CHECK_LOWER_TEMPLATE_STORE_GLOBAL << 2) + 1] = node;\n',
     '    tables->rows[(CHECK_LOWER_TEMPLATE_STORE_GLOBAL << 2) + 1] = node;\n    tables->rows[CHECK_LOWER_TEMPLATE_STORE_GLOBAL << 2] = BUSTER_NODE_CONTEXTS_EVALUATES;\n'),
    ('row-store-global-no-target', W, '    tables->rows[(CHECK_LOWER_TEMPLATE_STORE_GLOBAL << 2) + 1] = node;\n', '    tables->rows[(CHECK_LOWER_TEMPLATE_STORE_GLOBAL << 2) + 1] = BUSTER_NODE_CONTEXTS_EVALUATES;\n'),
    ('row-store-no-target', W, '    tables->rows[(CHECK_LOWER_TEMPLATE_STORE << 2) + 1] = node;\n', '    tables->rows[(CHECK_LOWER_TEMPLATE_STORE << 2) + 1] = BUSTER_NODE_CONTEXTS_EVALUATES;\n'),
    ('folds-with-effects', W, 'const __mmask64 folds = constant & ~effects & (', 'const __mmask64 folds = constant & (~effects | ~(__mmask64)0) & ('),
    ('folds-rvalue-only', W, '((rvalue & ~address) | ((address | address_value) & address_constant));', '((rvalue & ~address) | ((address | address_value) & address_constant & 0));'),
    ('folds-address-context-only', W, '((rvalue & ~address) | ((address | address_value) & address_constant));', '((rvalue & ~address) | ((address | (address_value & 0)) & address_constant));'),
    ('folds-address-value-only', W, '((rvalue & ~address) | ((address | address_value) & address_constant));', '((rvalue & ~address) | (((address & 0) | address_value) & address_constant));'),
    ('folds-any-placed', W, '((rvalue & ~address) | ((address | address_value) & address_constant));', '((rvalue & ~address) | ((address | address_value) & (address_constant | ~(__mmask64)0)));'),
    ('folds-lvalue-too', W, '((rvalue & ~address) | ((address | address_value) & address_constant));', '(((rvalue | ~(__mmask64)0) & ~address) | ((address | address_value) & address_constant));'),
    ('named-value-placed', W, 'is_value & ~placed_value & lvalue & has_object & numeric;', 'is_value & (~placed_value | ~(__mmask64)0) & lvalue & has_object & numeric;'),
    ('named-value-objectless', W, 'is_value & ~placed_value & lvalue & has_object & numeric;', 'is_value & ~placed_value & lvalue & (has_object | ~(__mmask64)0) & numeric;'),
    ('named-value-any-class', W, 'is_value & ~placed_value & lvalue & has_object & numeric;', 'is_value & ~placed_value & lvalue & has_object & (numeric | ~(__mmask64)0);'),
    ('member-any', W, 'free & is_member & ~vector & (placed_value | numeric);', 'free & is_member & ~vector & (placed_value | numeric | ~(__mmask64)0);'),
    ('member-numeric-only', W, 'free & is_member & ~vector & (placed_value | numeric);', 'free & is_member & ~vector & ((placed_value & 0) | numeric);'),
    ('member-placed-only', W, 'free & is_member & ~vector & (placed_value | numeric);', 'free & is_member & ~vector & (placed_value | (numeric & 0));'),
    ('truth-untestable', W, 'const __mmask64 own_truth = free & is_truth & numeric & testable;', 'const __mmask64 own_truth = free & is_truth & numeric & (testable | ~(__mmask64)0);'),
    ('truth-any-class', W, 'const __mmask64 own_truth = free & is_truth & numeric & testable;', 'const __mmask64 own_truth = free & is_truth & (numeric | ~(__mmask64)0) & testable;'),
    ('binary-any-class', W, 'const __mmask64 own_binary = free & numeric & both_scalar &', 'const __mmask64 own_binary = free & (numeric | ~(__mmask64)0) & both_scalar &'),
    ('binary-unscalar', W, 'const __mmask64 own_binary = free & numeric & both_scalar &', 'const __mmask64 own_binary = free & numeric & (both_scalar | ~(__mmask64)0) &'),
    ('binary-no-sum', W, '((is_sum & ~vector & ~either_pointer) | is_binary);\n        const __mmask64 made_store_local', '((is_sum & 0 & ~vector & ~either_pointer) | is_binary);\n        const __mmask64 made_store_local'),
    ('binary-no-operator', W, '((is_sum & ~vector & ~either_pointer) | is_binary);\n        const __mmask64 made_store_local', '((is_sum & ~vector & ~either_pointer) | (is_binary & 0));\n        const __mmask64 made_store_local'),
    ('listed-union-cast-not', W, 'placed & (is_uncased | (is_wrap & union_type) | divisor | wide | odd_leaf);', 'placed & (is_uncased | (is_wrap & union_type & 0) | divisor | wide | odd_leaf);'),
    ('listed-any-union', W, 'placed & (is_uncased | (is_wrap & union_type) | divisor | wide | odd_leaf);', 'placed & (is_uncased | ((is_wrap | ~(__mmask64)0) & union_type) | divisor | wide | odd_leaf);'),
    ('listed-odd-leaf-not', W, 'placed & (is_uncased | (is_wrap & union_type) | divisor | wide | odd_leaf);', 'placed & (is_uncased | (is_wrap & union_type) | divisor | wide | (odd_leaf & 0));'),
    ('bit1-no-truth', W, 'const __mmask64 bit1 = made_pass | made_dereference | made_truth | made_binary |', 'const __mmask64 bit1 = made_pass | made_dereference | (made_truth & 0) | made_binary |'),
    ('testable-to-f80', W, '_mm512_cmplt_epu8_mask(left_classes, _mm512_set1_epi8(BUSTER_TYPED_CLASS_VECTOR)) & _mm512_test_epi8_mask(left_classes, left_classes)',
     '_mm512_cmplt_epu8_mask(left_classes, _mm512_set1_epi8(BUSTER_TYPED_CLASS_F80)) & _mm512_test_epi8_mask(left_classes, left_classes)'),
    ('small-to-f80', W, 'const __mmask64 small = _mm512_cmplt_epu8_mask(type_classes, _mm512_set1_epi8(BUSTER_TYPED_CLASS_VECTOR)) |',
     'const __mmask64 small = _mm512_cmplt_epu8_mask(type_classes, _mm512_set1_epi8(BUSTER_TYPED_CLASS_F80)) |'),
    ('integral-to-u128', W, 'const __m512i integers = _mm512_set1_epi8(BUSTER_TYPED_CLASS_U64 - BUSTER_TYPED_CLASS_I8);', 'const __m512i integers = _mm512_set1_epi8(BUSTER_TYPED_CLASS_U128 - BUSTER_TYPED_CLASS_I8);'),
    ('integral-to-i64', W, 'const __m512i integers = _mm512_set1_epi8(BUSTER_TYPED_CLASS_U64 - BUSTER_TYPED_CLASS_I8);', 'const __m512i integers = _mm512_set1_epi8(BUSTER_TYPED_CLASS_I64 - BUSTER_TYPED_CLASS_I8);'),
]
FAULTS = [fault for fault in FAULTS if open(SRC + fault[1]).read().count(fault[2]) == 1]
FAULTS = list({fault[0]: fault for fault in FAULTS}.values())
names = [n for n, _, _, _ in FAULTS]
if len(sys.argv) > 3 and sys.argv[3] == 'check-the-third':
    bad = 0
    for name, f, a, b in FAULTS:
        n = open(SRC + f).read().count(a)
        if n != 1:
            print('NOT ONCE', name, n); bad += 1
    print(len(FAULTS), 'faults,', bad, 'not there once; dropped from the second round:', ' '.join(DROPPED))
    sys.exit(1 if bad else 0)

FAULTS_ALL = list(FAULTS)

OPEN = set(open('/home/user/mut15/round3-open.txt').read().split())
GONE = [name for name, f, a, b in FAULTS_ALL if name in OPEN and open(SRC + f).read().count(a) != 1]
FAULTS = [fault for fault in FAULTS_ALL if fault[0] in OPEN and fault[0] not in GONE]
# the masks whose text changed, and the new ones
for name in ('made_name', 'made_global', 'own_binary', 'made_truth', 'sums', 'small', 'testable', 'takes', 'integral',
             'floating_constant', 'folds', 'listed', 'made_member', 'made_pass', 'either_pointer', 'both_scalar'):
    for value in (True, False):
        fault = force(name, value)
        if fault[0] not in [n for n, _, _, _ in FAULTS]:
            FAULTS.append(fault)
ROW = '    tables->rows[%s] = %s;\n'
def row(name, key, old, new):
    return (name, W, ROW % (key, old), ROW % (key, new))
EVALUATES = 'BUSTER_NODE_CONTEXTS_EVALUATES | BUSTER_NODE_CONTEXTS_SOURCE_NONE'
FAULTS += [
    # the rows, as the table has them now
    row('row-none-first-dead', 'CHECK_LOWER_TEMPLATE_NONE << 1', EVALUATES, '0'),
    row('row-none-second-dead', '(CHECK_LOWER_TEMPLATE_NONE << 1) + 1', EVALUATES, '0'),
    row('row-pass-given', 'CHECK_LOWER_TEMPLATE_PASS << 1', 'node', 'given'),
    row('row-pass-no-target', 'CHECK_LOWER_TEMPLATE_PASS << 1', 'node', 'BUSTER_NODE_CONTEXTS_EVALUATES'),
    row('row-pass-dead', 'CHECK_LOWER_TEMPLATE_PASS << 1', 'node', '0'),
    row('row-dereference-node', 'CHECK_LOWER_TEMPLATE_DEREFERENCE << 1', 'given', 'node'),
    row('row-dereference-dead', 'CHECK_LOWER_TEMPLATE_DEREFERENCE << 1', 'given', '0'),
    row('row-member-node', 'CHECK_LOWER_TEMPLATE_MEMBER << 1', 'given', 'node'),
    row('row-member-dead', 'CHECK_LOWER_TEMPLATE_MEMBER << 1', 'given', '0'),
    row('row-unary-node', 'CHECK_LOWER_TEMPLATE_UNARY << 1', 'given', 'node'),
    row('row-unary-dead', 'CHECK_LOWER_TEMPLATE_UNARY << 1', 'given', '0'),
    row('row-truth-node', 'CHECK_LOWER_TEMPLATE_TRUTH << 1', 'given', 'node'),
    row('row-truth-dead', 'CHECK_LOWER_TEMPLATE_TRUTH << 1', 'given', '0'),
    row('row-binary-first-node', 'CHECK_LOWER_TEMPLATE_BINARY << 1', 'given', 'node'),
    row('row-binary-first-dead', 'CHECK_LOWER_TEMPLATE_BINARY << 1', 'given', '0'),
    row('row-binary-second-node', '(CHECK_LOWER_TEMPLATE_BINARY << 1) + 1', 'given', 'node'),
    row('row-binary-second-dead', '(CHECK_LOWER_TEMPLATE_BINARY << 1) + 1', 'given', '0'),
    row('row-pointer-first-node', 'CHECK_LOWER_TEMPLATE_POINTER << 1', 'given', 'node'),
    row('row-pointer-first-dead', 'CHECK_LOWER_TEMPLATE_POINTER << 1', 'given', '0'),
    row('row-pointer-index-given', '(CHECK_LOWER_TEMPLATE_POINTER << 1) + 1', 'BUSTER_NODE_CONTEXTS_EVALUATES | BUSTER_NODE_CONTEXTS_SOURCE_LONG', 'given'),
    row('row-pointer-index-dead', '(CHECK_LOWER_TEMPLATE_POINTER << 1) + 1', 'BUSTER_NODE_CONTEXTS_EVALUATES | BUSTER_NODE_CONTEXTS_SOURCE_LONG', '0'),
    row('row-store-local-given', '(CHECK_LOWER_TEMPLATE_STORE_LOCAL << 1) + 1', 'node', 'given'),
    row('row-store-local-no-target', '(CHECK_LOWER_TEMPLATE_STORE_LOCAL << 1) + 1', 'node', 'BUSTER_NODE_CONTEXTS_EVALUATES'),
    row('row-store-local-dead', '(CHECK_LOWER_TEMPLATE_STORE_LOCAL << 1) + 1', 'node', '0'),
    row('row-store-global-given', '(CHECK_LOWER_TEMPLATE_STORE_GLOBAL << 1) + 1', 'node', 'given'),
    row('row-store-global-no-target', '(CHECK_LOWER_TEMPLATE_STORE_GLOBAL << 1) + 1', 'node', 'BUSTER_NODE_CONTEXTS_EVALUATES'),
    row('row-store-global-dead', '(CHECK_LOWER_TEMPLATE_STORE_GLOBAL << 1) + 1', 'node', '0'),
    row('row-store-destination-dead', 'CHECK_LOWER_TEMPLATE_STORE << 1', EVALUATES, '0'),
    row('row-store-destination-given', 'CHECK_LOWER_TEMPLATE_STORE << 1', EVALUATES, 'given'),
    row('row-store-given', '(CHECK_LOWER_TEMPLATE_STORE << 1) + 1', 'node', 'given'),
    row('row-store-no-target', '(CHECK_LOWER_TEMPLATE_STORE << 1) + 1', 'node', 'BUSTER_NODE_CONTEXTS_EVALUATES'),
    row('row-store-dead', '(CHECK_LOWER_TEMPLATE_STORE << 1) + 1', 'node', '0'),
    ('row-store-local-destination', W, ROW % ('(CHECK_LOWER_TEMPLATE_STORE_LOCAL << 1) + 1', 'node'),
     ROW % ('(CHECK_LOWER_TEMPLATE_STORE_LOCAL << 1) + 1', 'node') + ROW % ('CHECK_LOWER_TEMPLATE_STORE_LOCAL << 1', 'BUSTER_NODE_CONTEXTS_EVALUATES')),
    ('row-store-global-destination', W, ROW % ('(CHECK_LOWER_TEMPLATE_STORE_GLOBAL << 1) + 1', 'node'),
     ROW % ('(CHECK_LOWER_TEMPLATE_STORE_GLOBAL << 1) + 1', 'node') + ROW % ('CHECK_LOWER_TEMPLATE_STORE_GLOBAL << 1', 'BUSTER_NODE_CONTEXTS_EVALUATES')),
    ('rows-place-not', W, '_mm512_or_si512(_mm512_slli_epi16(consumer_templates, 1), places), _mm512_load_si512(tables->rows));', '_mm512_or_si512(_mm512_slli_epi16(consumer_templates, 1), _mm512_and_si512(places, zero)), _mm512_load_si512(tables->rows));'),
    ('places-second-as-first', W, 'const __m512i places = _mm512_min_epu8(_mm512_loadu_si512(front->places + x), _mm512_set1_epi8(1));', 'const __m512i places = _mm512_min_epu8(_mm512_loadu_si512(front->places + x), _mm512_set1_epi8(0));'),
    # a name's two templates
    ('global-without-symbol', W, 'const __mmask64 made_global = made_name & symbol;', 'const __mmask64 made_global = made_name & (symbol | ALL);'),
    ('global-never', W, 'const __mmask64 made_global = made_name & symbol;', 'const __mmask64 made_global = made_name & symbol & 0;'),
    # the rule on T's conversions, as it is now
    ('converted-pointer-any-left', W, 'if (left_pointer && !right_pointer && check_action_pointer_stride(machine->types, type_a) != 0)',
     'if ((left_pointer || x != UINT32_MAX) && !right_pointer && check_action_pointer_stride(machine->types, type_a) != 0)'),
    ('converted-pointer-right-too', W, 'if (left_pointer && !right_pointer && check_action_pointer_stride(machine->types, type_a) != 0)',
     'if (left_pointer && (!right_pointer || x != UINT32_MAX) && check_action_pointer_stride(machine->types, type_a) != 0)'),
    ('converted-pointer-any-stride', W, 'if (left_pointer && !right_pointer && check_action_pointer_stride(machine->types, type_a) != 0)',
     'if (left_pointer && !right_pointer && (check_action_pointer_stride(machine->types, type_a) != 0 || x != UINT32_MAX))'),
    ('converted-sum-subscript-too', W, 'else if (!subscript && !left_pointer && !right_pointer && scalars)', 'else if ((!subscript || x != UINT32_MAX) && !left_pointer && !right_pointer && scalars)'),
    ('converted-sum-left-pointer-too', W, 'else if (!subscript && !left_pointer && !right_pointer && scalars)', 'else if (!subscript && (!left_pointer || x != UINT32_MAX) && !right_pointer && scalars)'),
    ('converted-sum-right-pointer-too', W, 'else if (!subscript && !left_pointer && !right_pointer && scalars)', 'else if (!subscript && !left_pointer && (!right_pointer || x != UINT32_MAX) && scalars)'),
    ('converted-sum-any-operands', W, 'else if (!subscript && !left_pointer && !right_pointer && scalars)', 'else if (!subscript && !left_pointer && !right_pointer && (scalars || x != UINT32_MAX))'),
    ('converted-sum-never', W, 'else if (!subscript && !left_pointer && !right_pointer && scalars)', 'else if (!subscript && !left_pointer && !right_pointer && scalars && x == UINT32_MAX)'),
    ('converted-truth-aggregates-too', W, 'template = !left_aggregate && class_a < BUSTER_TYPED_CLASS_VECTOR && class_a != BUSTER_TYPED_CLASS_VOID ?',
     'template = (!left_aggregate || x != UINT32_MAX) && class_a < BUSTER_TYPED_CLASS_VECTOR && class_a != BUSTER_TYPED_CLASS_VOID ?'),
    ('converted-truth-vectors-too', W, 'template = !left_aggregate && class_a < BUSTER_TYPED_CLASS_VECTOR && class_a != BUSTER_TYPED_CLASS_VOID ?',
     'template = !left_aggregate && (class_a < BUSTER_TYPED_CLASS_VECTOR || x != UINT32_MAX) && class_a != BUSTER_TYPED_CLASS_VOID ?'),
    ('converted-truth-void-too', W, 'template = !left_aggregate && class_a < BUSTER_TYPED_CLASS_VECTOR && class_a != BUSTER_TYPED_CLASS_VOID ?',
     'template = !left_aggregate && class_a < BUSTER_TYPED_CLASS_VECTOR && (class_a != BUSTER_TYPED_CLASS_VOID || x != UINT32_MAX) ?'),
    ('converted-binary-any-operands', W, 'template = scalars && !left_aggregate ? CHECK_LOWER_TEMPLATE_BINARY', 'template = (scalars || x != UINT32_MAX) && !left_aggregate ? CHECK_LOWER_TEMPLATE_BINARY'),
    ('converted-binary-aggregates-too', W, 'template = scalars && !left_aggregate ? CHECK_LOWER_TEMPLATE_BINARY', 'template = scalars && (!left_aggregate || x != UINT32_MAX) ? CHECK_LOWER_TEMPLATE_BINARY'),
    ('converted-binary-never', W, 'template = scalars && !left_aggregate ? CHECK_LOWER_TEMPLATE_BINARY', 'template = scalars && !left_aggregate && x == UINT32_MAX ? CHECK_LOWER_TEMPLATE_BINARY'),
    ('asked-as-binary-always', W, 'const uint8_t template = node_contexts_converted(state, x + lane, class_kind);', 'const uint8_t template = node_contexts_converted(state, x + lane, class_kind | BUSTER_NODE_CONTEXTS_CLASS_BINARY);'),
    ('own-binary-pointers-too', W, 'both_scalar & ((is_sum & ~either_pointer) | is_binary);\n        const __mmask64 made_store_local', 'both_scalar & ((is_sum & (~either_pointer | ALL)) | is_binary);\n        const __mmask64 made_store_local'),
    ('unsure-pointers-too', W, '~both_scalar & ((is_sum & ~either_pointer) | is_binary);', '~both_scalar & ((is_sum & (~either_pointer | ALL)) | is_binary);'),
    ('unsure-sums-not', W, '~both_scalar & ((is_sum & ~either_pointer) | is_binary);', '~both_scalar & ((is_sum & 0 & ~either_pointer) | is_binary);'),
    ('unsure-binaries-not', W, '~both_scalar & ((is_sum & ~either_pointer) | is_binary);', '~both_scalar & ((is_sum & ~either_pointer) | (is_binary & 0));'),
    # the stride's row, in forms that build
    ('stride-row-always', W, 'bool stride = row->stride != 0;', 'bool stride = row->stride != 0 || x != UINT32_MAX;'),
    ('stride-row-never', W, 'bool stride = row->stride != 0;', 'bool stride = row->stride != 0 && x == UINT32_MAX;'),
    # the comparison, in forms that build, and its control
    ('compare-no-evaluated', W, 'const bool same = alive == evaluated && (!alive ||', 'const bool same = (alive == evaluated || e != UINT32_MAX) && (!alive ||'),
    ('compare-no-template', W, '(!alive || (state->window_c_templates[x] == state->place_c_templates[x] &&', '(!alive || ((state->window_c_templates[x] == state->place_c_templates[x] || e != UINT32_MAX) &&'),
    ('compare-no-context', W, 'state->window_c_contexts[x] == state->place_c_contexts[x] &&', '(state->window_c_contexts[x] == state->place_c_contexts[x] || e != UINT32_MAX) &&'),
    ('compare-no-target', W, 'state->window_c_targets[x] == state->place_c_targets[x]));', '(state->window_c_targets[x] == state->place_c_targets[x] || e != UINT32_MAX)));'),
    ('compare-verdict-not', W, 'return refused != reference_refused || wrong != 0;', 'return (refused != reference_refused && wrong != 0) || wrong != 0;'),
    ('compare-records-not', W, 'return refused != reference_refused || wrong != 0;', 'return refused != reference_refused || (wrong != 0 && e == UINT32_MAX);'),
    ('control-template-not', FA, 'state->place_c_templates[root] ^= turn == 0 ? 1 : 0;', 'state->place_c_templates[root] ^= turn == 0 && e == UINT32_MAX ? 1 : 0;'),
    ('control-context-not', FA, 'state->place_c_contexts[root] ^= turn == 1 ? BUSTER_CHECK_LOWER_TEMPLATE_ADDRESS : 0;', 'state->place_c_contexts[root] ^= turn == 1 && e == UINT32_MAX ? BUSTER_CHECK_LOWER_TEMPLATE_ADDRESS : 0;'),
    ('control-target-not', FA, 'state->place_c_targets[root] ^= turn == 2 ? 1u : 0u;', 'state->place_c_targets[root] ^= turn == 2 && e == UINT32_MAX ? 1u : 0u;'),
    ('control-evaluated-not', FA, 'state->place_c_states[root] ^= turn == 3 ? BUSTER_NODE_MACHINE_EVALUATED : 0;', 'state->place_c_states[root] ^= turn == 3 && e == UINT32_MAX ? BUSTER_NODE_MACHINE_EVALUATED : 0;'),
    ('control-verdict-not', FA, 'state->c_ran[e] = turn == 4 ? BUSTER_NODE_CONTEXTS_RAN_REFUSED : state->c_ran[e];', 'state->c_ran[e] = turn == 4 && e == UINT32_MAX ? BUSTER_NODE_CONTEXTS_RAN_REFUSED : state->c_ran[e];'),
    ('bytes-line-symbol-never', C, '(symbol ? BUSTER_NODE_TESTS_LINE_SYMBOL : 0) |', '(symbol && number == UINT32_MAX ? BUSTER_NODE_TESTS_LINE_SYMBOL : 0) |'),
]
FAULTS += [
    ('converted-left-alone', W, 'return node_machine_scalar_class((uint8_t)word_a) && node_machine_scalar_class((uint8_t)word_b);', 'return node_machine_scalar_class((uint8_t)word_a) && (node_machine_scalar_class((uint8_t)word_b) || x != UINT32_MAX);'),
    ('converted-right-alone', W, 'return node_machine_scalar_class((uint8_t)word_a) && node_machine_scalar_class((uint8_t)word_b);', 'return (node_machine_scalar_class((uint8_t)word_a) || x != UINT32_MAX) && node_machine_scalar_class((uint8_t)word_b);'),
    ('converted-never', W, 'return node_machine_scalar_class((uint8_t)word_a) && node_machine_scalar_class((uint8_t)word_b);', 'return node_machine_scalar_class((uint8_t)word_a) && node_machine_scalar_class((uint8_t)word_b) && x == UINT32_MAX;'),
    ('converted-first-twice', W, 'const uint32_t word_b = node_machine_word(machine, facts->records[x].converted[1]);', 'const uint32_t word_b = node_machine_word(machine, facts->records[x].converted[0]);'),
    ('converted-second-twice', W, 'const uint32_t word_a = node_machine_word(machine, facts->records[x].converted[0]);', 'const uint32_t word_a = node_machine_word(machine, facts->records[x].converted[1]);'),
    ('asked-any-class', W, 'pending = free & placed & numeric & ~both_scalar & ((is_sum & ~either_pointer) | is_binary);', 'pending = free & placed & (numeric | ALL) & ~both_scalar & ((is_sum & ~either_pointer) | is_binary);'),
    ('asked-numbers-too', W, 'pending = free & placed & numeric & ~both_scalar & ((is_sum & ~either_pointer) | is_binary);', 'pending = free & placed & numeric & (~both_scalar | ALL) & ((is_sum & ~either_pointer) | is_binary);'),
    ('asked-pointers-too', W, 'pending = free & placed & numeric & ~both_scalar & ((is_sum & ~either_pointer) | is_binary);', 'pending = free & placed & numeric & ~both_scalar & ((is_sum & (~either_pointer | ALL)) | is_binary);'),
    ('asked-sums-not', W, 'pending = free & placed & numeric & ~both_scalar & ((is_sum & ~either_pointer) | is_binary);', 'pending = free & placed & numeric & ~both_scalar & ((is_sum & 0 & ~either_pointer) | is_binary);'),
    ('asked-binaries-not', W, 'pending = free & placed & numeric & ~both_scalar & ((is_sum & ~either_pointer) | is_binary);', 'pending = free & placed & numeric & ~both_scalar & ((is_sum & ~either_pointer) | (is_binary & 0));'),
    ('asked-unplaced-too', W, 'pending = free & placed & numeric & ~both_scalar & ((is_sum & ~either_pointer) | is_binary);', 'pending = free & (placed | ALL) & numeric & ~both_scalar & ((is_sum & ~either_pointer) | is_binary);'),
    ('asked-folded-too', W, 'pending = free & placed & numeric & ~both_scalar & ((is_sum & ~either_pointer) | is_binary);', 'pending = (free | ALL) & placed & numeric & ~both_scalar & ((is_sum & ~either_pointer) | is_binary);'),
    ('asked-binary-dropped', W, 'own_binary | _cvtu64_mask64(asked_binary);', 'own_binary | _cvtu64_mask64(asked_binary & 0);'),
    ('asked-not-counted', W, '            converted += 1;\n', '            converted += 0;\n'),
    ('truth-untestable', W, 'const __mmask64 made_truth = free & is_truth & numeric & testable;', 'const __mmask64 made_truth = free & is_truth & numeric & (testable | ALL);'),
    ('truth-any-class', W, 'const __mmask64 made_truth = free & is_truth & numeric & testable;', 'const __mmask64 made_truth = free & is_truth & (numeric | ALL) & testable;'),
    ('subscript-any-left', W, 'uint64_t pointed = sums & left_pointer & ~right_pointer;', 'uint64_t pointed = sums & (left_pointer | ALL) & ~right_pointer;'),
]
FAULTS = [(n, f, a, b.replace('ALL', '~(__mmask64)0')) for n, f, a, b in FAULTS]
seen = set()
unique = []
for fault in reversed(FAULTS):
    if fault[0] not in seen:
        seen.add(fault[0]); unique.append(fault)
FAULTS = list(reversed(unique))
KEEP = set(open('/home/user/mut15/round6-names.txt').read().split())
NEW = ('converted-', 'asked-', 'truth-', 'subscript-any-left')
FAULTS = [fault for fault in FAULTS if (fault[0] in KEEP or fault[0].startswith(NEW)) and open(SRC + fault[1]).read().count(fault[2]) == 1]
names = [n for n, _, _, _ in FAULTS]
if len(sys.argv) > 3 and sys.argv[3] == 'check':
    bad = 0
    for name, f, a, b in FAULTS:
        n = open(SRC + f).read().count(a)
        if n != 1:
            print('NOT ONCE', name, n); bad += 1
    print(len(FAULTS), 'faults,', bad, 'not there once; of the third round\'s open ones, with a text that is gone:', ' '.join(GONE))
    sys.exit(1 if bad else 0)
CORPORA = open('/home/user/mut15/corpora.txt').read().strip().split('\n')
out = open('/home/user/mut15/results6-%d.txt' % worker, 'w')
for index, (name, f, a, b) in enumerate(FAULTS):
    if index % of != worker:
        continue
    text = open(SRC + f).read()
    assert text.count(a) == 1, (name, text.count(a))
    open(SRC + f, 'w').write(text.replace(a, b))
    t0 = time.time()
    build = subprocess.run(['./build.sh', '--config', 'Debug', '--jobs', '1'], cwd=TREE, capture_output=True, text=True)
    if build.returncode != 0:
        verdict = 'NOT BUILT ' + (build.stdout + build.stderr)[-300:].replace('\n', ' ')
    else:
        try:
            test = subprocess.run(['./build/compiler', 'test-checker', '--seed', '133', '--part', '5/8'], cwd=TREE, capture_output=True, text=True, timeout=600)
            first = (test.stderr.strip().split('\n') or [''])[0][:160]
            verdict = ('caught' if test.returncode != 0 else 'SURVIVED') + ' [status %d] %s' % (test.returncode, first)
        except subprocess.TimeoutExpired:
            verdict = 'TIMED OUT'
        told = []
        for line in (CORPORA if verdict.startswith('SURVIVED') else []):
            corpus, arguments = line.split(' ', 1)
            try:
                run = subprocess.run('./build/compiler measure-node-machine --shadow --passes 0 --window-contexts --list 3 ' + arguments, shell=True, cwd=TREE, capture_output=True, text=True, timeout=300)
                m = re.search(r'window contexts expressions=\d+ records=\d+ decided=(\d+) .*?of-them-refused=(\d+) differences=(\d+)', run.stdout)
                d = re.search(r'window contexts difference file=(\S+) line=(\d+)', run.stdout)
                told.append('%s: status %d%s%s' % (corpus, run.returncode, ' decided %s refused %s differences %s' % m.groups() if m else ' no line', ' first %s:%s' % (d.group(1).split('/')[-1], d.group(2)) if d else ''))
            except subprocess.TimeoutExpired:
                told.append('%s: timed out' % corpus)
        verdict += ' || ' + '; '.join(told)
    out.write('%s: %s (%d s)\n' % (name, verdict, time.time() - t0)); out.flush()
    open(SRC + f, 'w').write(text)
out.write('done\n'); out.close()
