#!/usr/bin/env python3
# faults.py WORKER OF [check]: the faults of C on the window's first piece, one at a time, in the copy
# /home/user/mut15/treeWORKER: a text of the piece's code replaced by a faulty one, the Debug compiler built, and the
# node machine's tests run (test-checker part 5 of 8). A fault the tests don't fail is a survivor. Worker WORKER of OF
# takes every OF-th fault. Results in /home/user/mut15/results-WORKER.txt. With `check`, only that every text is there
# once.
import subprocess, sys, time
worker, of = int(sys.argv[1]), int(sys.argv[2])
TREE = '/home/user/mut15/tree%d' % worker
SRC = TREE + '/src/buster/compiler/'
W = 'c_check_node_machine_window.c'
C = 'c_check_node_census.c'
F = 'c_check_node_machine_front.c'
K = 'c_check_node_machine_facts.c'
R = 'c_check_node_machine_reader.c'
FAULTS = [
    # the operators' classes
    ('class-positive-no-wrap', W, 'case CHECK_OP_CAST: case CHECK_OP_CONVERT: case CHECK_OP_POSITIVE: class = BUSTER_NODE_CONTEXTS_CLASS_WRAP; break;',
     'case CHECK_OP_CAST: case CHECK_OP_CONVERT: class = BUSTER_NODE_CONTEXTS_CLASS_WRAP; break;'),
    ('class-convert-no-wrap', W, 'case CHECK_OP_CAST: case CHECK_OP_CONVERT: case CHECK_OP_POSITIVE: class = BUSTER_NODE_CONTEXTS_CLASS_WRAP; break;',
     'case CHECK_OP_CAST: case CHECK_OP_POSITIVE: class = BUSTER_NODE_CONTEXTS_CLASS_WRAP; break;'),
    ('class-member-no-place', W, 'case CHECK_OP_MEMBER: class = BUSTER_NODE_CONTEXTS_CLASS_MEMBER | BUSTER_NODE_CONTEXTS_CLASS_PLACE; break;',
     'case CHECK_OP_MEMBER: class = BUSTER_NODE_CONTEXTS_CLASS_MEMBER; break;'),
    ('class-arrow-place', W, 'case CHECK_OP_ARROW: class = BUSTER_NODE_CONTEXTS_CLASS_MEMBER; break;',
     'case CHECK_OP_ARROW: class = BUSTER_NODE_CONTEXTS_CLASS_MEMBER | BUSTER_NODE_CONTEXTS_CLASS_PLACE; break;'),
    ('class-subtract-binary', W, 'case CHECK_OP_ADD: case CHECK_OP_SUBTRACT: class = BUSTER_NODE_CONTEXTS_CLASS_SUM; break;',
     'case CHECK_OP_ADD: class = BUSTER_NODE_CONTEXTS_CLASS_SUM; break;'),
    ('class-bit-not-other', W, 'case CHECK_OP_NEGATIVE: case CHECK_OP_BIT_NOT: class = BUSTER_NODE_CONTEXTS_CLASS_UNARY; break;',
     'case CHECK_OP_NEGATIVE: class = BUSTER_NODE_CONTEXTS_CLASS_UNARY; break;'),
    ('class-condition-other', W, 'case CHECK_OP_NOT: case CHECK_OP_CONDITION: class = BUSTER_NODE_CONTEXTS_CLASS_TRUTH; break;',
     'case CHECK_OP_NOT: class = BUSTER_NODE_CONTEXTS_CLASS_TRUTH; break;'),
    ('class-assign-no-place', W, 'case CHECK_OP_ASSIGN: class = BUSTER_NODE_CONTEXTS_CLASS_ASSIGN | BUSTER_NODE_CONTEXTS_CLASS_PLACE; break;',
     'case CHECK_OP_ASSIGN: class = BUSTER_NODE_CONTEXTS_CLASS_ASSIGN; break;'),
    ('class-address-no-place', W, 'case CHECK_OP_ADDRESS: class = BUSTER_NODE_CONTEXTS_CLASS_ADDRESS | BUSTER_NODE_CONTEXTS_CLASS_PLACE; break;',
     'case CHECK_OP_ADDRESS: class = BUSTER_NODE_CONTEXTS_CLASS_ADDRESS; break;'),
    ('class-dereference-place', W, 'case CHECK_OP_DEREFERENCE: class = BUSTER_NODE_CONTEXTS_CLASS_DEREFERENCE; break;',
     'case CHECK_OP_DEREFERENCE: class = BUSTER_NODE_CONTEXTS_CLASS_DEREFERENCE | BUSTER_NODE_CONTEXTS_CLASS_PLACE; break;'),
    ('class-shift-binary', W, 'case CHECK_OP_SHIFT_LEFT: case CHECK_OP_SHIFT_RIGHT: class = BUSTER_NODE_CONTEXTS_CLASS_SHIFT; break;',
     'case CHECK_OP_SHIFT_LEFT: case CHECK_OP_SHIFT_RIGHT: class = BUSTER_NODE_CONTEXTS_CLASS_BINARY; break;'),
    ('class-divide-binary', W, 'case CHECK_OP_DIVIDE: case CHECK_OP_REMAINDER: class = BUSTER_NODE_CONTEXTS_CLASS_DIVIDE; break;',
     'case CHECK_OP_DIVIDE: class = BUSTER_NODE_CONTEXTS_CLASS_DIVIDE; break;'),
    ('class-comma-other', W, 'case CHECK_OP_COMMA: case CHECK_OP_SELECT: class = BUSTER_NODE_CONTEXTS_CLASS_COMMA; break;',
     'case CHECK_OP_COMMA: case CHECK_OP_SELECT: class = BUSTER_NODE_CONTEXTS_CLASS_BINARY; break;'),
    ('class-update-binary', W, 'class = update ? BUSTER_NODE_CONTEXTS_CLASS_UPDATE : binary != BUSTER_TYPED_NONE',
     'class = update && op > CHECK_OP_POST_DECREMENT ? BUSTER_NODE_CONTEXTS_CLASS_BINARY : update ? BUSTER_NODE_CONTEXTS_CLASS_UPDATE : binary != BUSTER_TYPED_NONE'),
    # the rows
    ('row-pass-given', W, 'tables->rows[CHECK_LOWER_TEMPLATE_PASS << 2] = node;', 'tables->rows[CHECK_LOWER_TEMPLATE_PASS << 2] = given;'),
    ('row-dereference-node', W, 'tables->rows[CHECK_LOWER_TEMPLATE_DEREFERENCE << 2] = given;', 'tables->rows[CHECK_LOWER_TEMPLATE_DEREFERENCE << 2] = node;'),
    ('row-member-node', W, 'tables->rows[CHECK_LOWER_TEMPLATE_MEMBER << 2] = given;', 'tables->rows[CHECK_LOWER_TEMPLATE_MEMBER << 2] = node;'),
    ('row-unary-node', W, 'tables->rows[CHECK_LOWER_TEMPLATE_UNARY << 2] = given;', 'tables->rows[CHECK_LOWER_TEMPLATE_UNARY << 2] = node;'),
    ('row-truth-node', W, 'tables->rows[CHECK_LOWER_TEMPLATE_TRUTH << 2] = given;', 'tables->rows[CHECK_LOWER_TEMPLATE_TRUTH << 2] = node;'),
    ('row-binary-second-none', W, 'tables->rows[(CHECK_LOWER_TEMPLATE_BINARY << 2) + 1] = given;', 'tables->rows[(CHECK_LOWER_TEMPLATE_BINARY << 2) + 1] = BUSTER_NODE_CONTEXTS_EVALUATES;'),
    ('row-binary-first-node', W, 'tables->rows[CHECK_LOWER_TEMPLATE_BINARY << 2] = given;', 'tables->rows[CHECK_LOWER_TEMPLATE_BINARY << 2] = node;'),
    ('row-pointer-index-given', W, 'tables->rows[(CHECK_LOWER_TEMPLATE_POINTER << 2) + 1] = BUSTER_NODE_CONTEXTS_EVALUATES | BUSTER_NODE_CONTEXTS_SOURCE_LONG;',
     'tables->rows[(CHECK_LOWER_TEMPLATE_POINTER << 2) + 1] = given;'),
    ('row-pointer-first-node', W, 'tables->rows[CHECK_LOWER_TEMPLATE_POINTER << 2] = given;', 'tables->rows[CHECK_LOWER_TEMPLATE_POINTER << 2] = node;'),
    ('row-store-local-first', W, 'tables->rows[(CHECK_LOWER_TEMPLATE_STORE_LOCAL << 2) + 1] = node;',
     'tables->rows[(CHECK_LOWER_TEMPLATE_STORE_LOCAL << 2) + 1] = node;\n    tables->rows[CHECK_LOWER_TEMPLATE_STORE_LOCAL << 2] = BUSTER_NODE_CONTEXTS_EVALUATES;'),
    ('row-store-global-given', W, 'tables->rows[(CHECK_LOWER_TEMPLATE_STORE_GLOBAL << 2) + 1] = node;', 'tables->rows[(CHECK_LOWER_TEMPLATE_STORE_GLOBAL << 2) + 1] = given;'),
    ('row-store-no-destination', W, 'tables->rows[CHECK_LOWER_TEMPLATE_STORE << 2] = BUSTER_NODE_CONTEXTS_EVALUATES | BUSTER_NODE_CONTEXTS_SOURCE_NONE;',
     'tables->rows[CHECK_LOWER_TEMPLATE_STORE << 2] = BUSTER_NODE_CONTEXTS_SOURCE_NONE;'),
    ('row-store-value-given', W, 'tables->rows[(CHECK_LOWER_TEMPLATE_STORE << 2) + 1] = node;', 'tables->rows[(CHECK_LOWER_TEMPLATE_STORE << 2) + 1] = given;'),
    ('row-none-dead', W, 'tables->rows[(CHECK_LOWER_TEMPLATE_NONE << 2) + place] = BUSTER_NODE_CONTEXTS_EVALUATES | BUSTER_NODE_CONTEXTS_SOURCE_NONE;',
     'tables->rows[(CHECK_LOWER_TEMPLATE_NONE << 2) + place] = BUSTER_NODE_CONTEXTS_SOURCE_NONE;'),
    # the reach
    ('consumers-room', W, 'const __m512i room = _mm512_sub_epi8(_mm512_set1_epi8(127), lanes);', 'const __m512i room = _mm512_sub_epi8(_mm512_set1_epi8(126), lanes);'),
    ('consumers-untaken', W, 'const __mmask64 some = _mm512_test_epi8_mask(takers, takers);\n    const __mmask64 beyond = _mm512_cmpgt_epu8_mask(ups, room);',
     'const __mmask64 some = _mm512_test_epi8_mask(ups, ups) | _mm512_test_epi8_mask(takers, takers);\n    const __mmask64 beyond = _mm512_cmpgt_epu8_mask(ups, room);'),
    # the stride
    ('stride-always', W, 'bool stride = row->stride != 0;', 'bool stride = true;'),
    ('stride-never', W, 'bool stride = row->stride != 0;', 'bool stride = false;'),
    ('stride-asked-never', W, 'return pointer != 0 && check_action_pointer_stride(facts->machine->types, pointer) != 0;', 'return false;'),
    # the far lanes
    ('far-consumer-none', W, 'far_bytes[BUSTER_NODE_CONTEXTS_FAR_TEMPLATE][lane] = state->window_c_templates[consumer];', 'far_bytes[BUSTER_NODE_CONTEXTS_FAR_TEMPLATE][lane] = 0;'),
    ('far-consumer-class', W, 'far_bytes[BUSTER_NODE_CONTEXTS_FAR_CONSUMER_CLASS][lane] = tables->classes[code];', 'far_bytes[BUSTER_NODE_CONTEXTS_FAR_CONSUMER_CLASS][lane] = 0;'),
    ('far-consumer-not-loaded', W, 'loaded |= UINT64_C(1) << lane;', 'loaded |= 0;'),
    ('far-left-class', W, 'far_bytes[BUSTER_NODE_CONTEXTS_FAR_LEFT_CLASS][lane] = state->window_c_classes[operand];', 'far_bytes[BUSTER_NODE_CONTEXTS_FAR_LEFT_CLASS][lane] = 0;'),
    ('far-left-code', W, 'far_bytes[BUSTER_NODE_CONTEXTS_FAR_LEFT_CODE][lane] = front->ops[operand] & 0x7f;', 'far_bytes[BUSTER_NODE_CONTEXTS_FAR_LEFT_CODE][lane] = 0x7f;'),
    ('far-left-flags', W, 'far_bytes[BUSTER_NODE_CONTEXTS_FAR_LEFT_FLAGS][lane] = state->window_c_flags[operand];', 'far_bytes[BUSTER_NODE_CONTEXTS_FAR_LEFT_FLAGS][lane] = 0;'),
    ('far-right-class', W, 'far_bytes[BUSTER_NODE_CONTEXTS_FAR_RIGHT_CLASS][lane] = state->window_c_classes[operand];', 'far_bytes[BUSTER_NODE_CONTEXTS_FAR_RIGHT_CLASS][lane] = 0;'),
    ('far-right-standing', W, 'far_bytes[BUSTER_NODE_CONTEXTS_FAR_RIGHT_STANDING][lane] = state->window_c_standings[operand];', 'far_bytes[BUSTER_NODE_CONTEXTS_FAR_RIGHT_STANDING][lane] = 0;'),
    ('far-not-near', W, '            near_left |= far_left;\n            near_right |= far_right;', '            near_left |= far_left;'),
    ('far-unplaced-too', W, '        far_left &= placed;\n        far_right &= placed;', '        far_right &= placed;'),
    # the consumer
    ('root-initialized-not', W, 'const __mmask64 rooted = ~(has_up | far_up) | initialized;', 'const __mmask64 rooted = ~(has_up | far_up);'),
    ('address-any-place', W, 'const __mmask64 address = has_up & first_place & _mm512_test_epi8_mask', 'const __mmask64 address = has_up & _mm512_test_epi8_mask'),
    ('addressed-never', W, 'const __m512i sources = _mm512_maskz_mov_epi8(has_up & ~rooted & ~addressed,', 'const __m512i sources = _mm512_maskz_mov_epi8(has_up & ~rooted,'),
    ('places-capped-two', W, 'const __m512i places = _mm512_min_epu8(_mm512_loadu_si512(front->places + x), _mm512_set1_epi8(3));',
     'const __m512i places = _mm512_min_epu8(_mm512_loadu_si512(front->places + x), _mm512_set1_epi8(1));'),
    # the operands
    ('decay-left-not', W, 'const __m512i left_value = _mm512_mask_mov_epi8(left_classes, left_decays, pointer_class);', 'const __m512i left_value = left_classes;'),
    ('decay-right-not', W, 'const __m512i right_value = _mm512_mask_mov_epi8(right_classes, right_decays, pointer_class);', 'const __m512i right_value = right_classes;'),
    ('decay-function-not', W, 'const __m512i decayed = _mm512_set1_epi8(BUSTER_TYPE_KIND_FUNCTION - BUSTER_TYPE_KIND_ARRAY);',
     'const __m512i decayed = _mm512_set1_epi8(BUSTER_TYPE_KIND_VARIABLE_ARRAY - BUSTER_TYPE_KIND_ARRAY);'),
    ('pointer-left-fact-only', W, 'const __mmask64 left_pointer = left_decays | _mm512_test_epi8_mask(left_facts, _mm512_set1_epi8(BUSTER_CHECK_LOWER_TYPE_POINTER));',
     'const __mmask64 left_pointer = _mm512_test_epi8_mask(left_facts, _mm512_set1_epi8(BUSTER_CHECK_LOWER_TYPE_POINTER));'),
    ('pointer-right-fact-only', W, 'const __mmask64 right_pointer = right_decays | _mm512_test_epi8_mask(right_facts, _mm512_set1_epi8(BUSTER_CHECK_LOWER_TYPE_POINTER));',
     'const __mmask64 right_pointer = _mm512_test_epi8_mask(right_facts, _mm512_set1_epi8(BUSTER_CHECK_LOWER_TYPE_POINTER));'),
    ('aggregate-left-decayed', W, 'const __mmask64 left_aggregate = ~left_decays & _mm512_test_epi8_mask(left_facts,', 'const __mmask64 left_aggregate = _mm512_test_epi8_mask(left_facts,'),
    ('aggregate-right-decayed', W, 'const __mmask64 right_aggregate = ~right_decays & _mm512_test_epi8_mask(right_facts,', 'const __mmask64 right_aggregate = _mm512_test_epi8_mask(right_facts,'),
    ('testable-aggregate', W, 'const __mmask64 testable = ~left_aggregate & _mm512_cmplt_epu8_mask(left_value,', 'const __mmask64 testable = _mm512_cmplt_epu8_mask(left_value,'),
    ('testable-wide', W, 'const __mmask64 testable = ~left_aggregate & _mm512_cmplt_epu8_mask(left_value, _mm512_set1_epi8(BUSTER_TYPED_CLASS_VECTOR)) &',
     'const __mmask64 testable = ~left_aggregate &'),
    ('named-any-leaf', W, '''        const __mmask64 named = near_left & _mm512_cmpeq_epi8_mask(left_codes, _mm512_set1_epi8(CHECK_OP_VALUE)) &
                                _mm512_cmpeq_epi8_mask(_mm512_and_si512(left_flags, named_bits), named_bits);''',
     '        const __mmask64 named = near_left & _mm512_cmpeq_epi8_mask(left_codes, _mm512_set1_epi8(CHECK_OP_VALUE));'),
    ('named-any-operator', W, '''        const __mmask64 named = near_left & _mm512_cmpeq_epi8_mask(left_codes, _mm512_set1_epi8(CHECK_OP_VALUE)) &
                                _mm512_cmpeq_epi8_mask(_mm512_and_si512(left_flags, named_bits), named_bits);''',
     '        const __mmask64 named = near_left & _mm512_cmpeq_epi8_mask(_mm512_and_si512(left_flags, named_bits), named_bits);'),
    ('named-unknown-too', W, 'const __m512i named_bits = _mm512_set1_epi8(BUSTER_NODE_CONTEXTS_OBJECT | BUSTER_NODE_CONTEXTS_KNOWN);', 'const __m512i named_bits = _mm512_set1_epi8(BUSTER_NODE_CONTEXTS_OBJECT);'),
    ('divisor-any-constant', W, '''        const __mmask64 right_constant = near_right & _mm512_cmpeq_epi8_mask(_mm512_and_si512(right_standings, _mm512_set1_epi8(0x1c)),
                                                                             _mm512_set1_epi8(CHECK_CONSTANT_INTEGER << 2));''',
     '        const __mmask64 right_constant = near_right & _mm512_test_epi8_mask(right_standings, _mm512_set1_epi8(0x1c));'),
    ('divisor-never', W, 'const __mmask64 divisor = is_divide & right_constant;', 'const __mmask64 divisor = is_divide & right_constant & 0;'),
    # the record's own
    ('numeric-to-f80', W, 'const __m512i scalars = _mm512_set1_epi8(BUSTER_TYPED_CLASS_F64 - BUSTER_TYPED_CLASS_I8);', 'const __m512i scalars = _mm512_set1_epi8(BUSTER_TYPED_CLASS_F80 - BUSTER_TYPED_CLASS_I8);'),
    ('integer-to-f32', W, 'const __mmask64 integer = _mm512_cmple_epu8_mask(from_i8, _mm512_set1_epi8(BUSTER_TYPED_CLASS_U64 - BUSTER_TYPED_CLASS_I8));',
     'const __mmask64 integer = _mm512_cmple_epu8_mask(from_i8, _mm512_set1_epi8(BUSTER_TYPED_CLASS_F32 - BUSTER_TYPED_CLASS_I8));'),
    ('floating-f32-only', W, '''        const __mmask64 floating = _mm512_cmpeq_epi8_mask(type_classes, _mm512_set1_epi8(BUSTER_TYPED_CLASS_F32)) |
                                   _mm512_cmpeq_epi8_mask(type_classes, _mm512_set1_epi8(BUSTER_TYPED_CLASS_F64));''',
     '        const __mmask64 floating = _mm512_cmpeq_epi8_mask(type_classes, _mm512_set1_epi8(BUSTER_TYPED_CLASS_F32));'),
    ('scalar-class-plain', W, 'const __mmask64 scalar_class = aggregate | numeric;', 'const __mmask64 scalar_class = numeric;'),
    ('plain-aggregate-too', W, 'const __mmask64 plain = numeric & ~aggregate;', 'const __mmask64 plain = numeric;'),
    ('small-not-aggregate', W, 'const __mmask64 small = aggregate | _mm512_cmplt_epu8_mask(type_classes, _mm512_set1_epi8(BUSTER_TYPED_CLASS_VECTOR));',
     'const __mmask64 small = _mm512_cmplt_epu8_mask(type_classes, _mm512_set1_epi8(BUSTER_TYPED_CLASS_VECTOR));'),
    ('small-to-f64', W, 'const __mmask64 small = aggregate | _mm512_cmplt_epu8_mask(type_classes, _mm512_set1_epi8(BUSTER_TYPED_CLASS_VECTOR));',
     'const __mmask64 small = aggregate | _mm512_cmplt_epu8_mask(type_classes, _mm512_set1_epi8(BUSTER_TYPED_CLASS_F80));'),
    ('void-any-classless', W, 'const __mmask64 void_type = _mm512_testn_epi8_mask(type_classes, type_classes) & _mm512_cmpeq_epi8_mask(kinds, _mm512_set1_epi8(BUSTER_TYPE_KIND_VOID));',
     'const __mmask64 void_type = _mm512_testn_epi8_mask(type_classes, type_classes);'),
    ('union-cast-taken', W, 'const __mmask64 listed = placed & (is_uncased | (is_wrap & union_type) | divisor | wide | far_up | stray);',
     'const __mmask64 listed = placed & (is_uncased | divisor | wide | far_up | stray);'),
    ('wide-taken', W, 'const __mmask64 listed = placed & (is_uncased | (is_wrap & union_type) | divisor | wide | far_up | stray);',
     'const __mmask64 listed = placed & (is_uncased | (is_wrap & union_type) | divisor | far_up | stray);'),
    ('stray-taken', W, 'const __mmask64 listed = placed & (is_uncased | (is_wrap & union_type) | divisor | wide | far_up | stray);',
     'const __mmask64 listed = placed & (is_uncased | (is_wrap & union_type) | divisor | wide | far_up);'),
    ('uncased-taken', W, 'const __mmask64 listed = placed & (is_uncased | (is_wrap & union_type) | divisor | wide | far_up | stray);',
     'const __mmask64 listed = placed & ((is_wrap & union_type) | divisor | wide | far_up | stray);'),
    ('leaf-literal-line-not', W, '''        const __mmask64 leaf = _mm512_cmpeq_epi8_mask(leaf_kinds, _mm512_set1_epi8(BUSTER_NODE_FACTS_IDENTIFIER)) |
                               _mm512_cmpeq_epi8_mask(leaf_kinds, _mm512_set1_epi8(BUSTER_NODE_FACTS_LITERAL_LINE));''',
     '        const __mmask64 leaf = _mm512_cmpeq_epi8_mask(leaf_kinds, _mm512_set1_epi8(BUSTER_NODE_FACTS_IDENTIFIER));'),
    # the binary operators' types
    ('arithmetic-shift-too', W, 'const __mmask64 arithmetic = near_left & near_right & ~is_shift & ~left_pointer & ~right_pointer;',
     'const __mmask64 arithmetic = near_left & near_right & ~left_pointer & ~right_pointer;'),
    ('arithmetic-pointers-too', W, 'const __mmask64 arithmetic = near_left & near_right & ~is_shift & ~left_pointer & ~right_pointer;',
     'const __mmask64 arithmetic = near_left & near_right & ~is_shift;'),
    ('arithmetic-never', W, 'const __mmask64 arithmetic = near_left & near_right & ~is_shift & ~left_pointer & ~right_pointer;',
     'const __mmask64 arithmetic = 0;'),
    ('first-aggregate-left', W, 'const __mmask64 first_aggregate = (arithmetic & ((left_wider & left_aggregate) | (~left_wider & right_aggregate))) | (~arithmetic & left_aggregate);',
     'const __mmask64 first_aggregate = left_aggregate;'),
    ('first-aggregate-never', W, 'const __mmask64 first_aggregate = (arithmetic & ((left_wider & left_aggregate) | (~left_wider & right_aggregate))) | (~arithmetic & left_aggregate);',
     'const __mmask64 first_aggregate = 0;'),
    # the templates' rules
    ('folds-with-effects', W, 'const __mmask64 folds = constant & ~effects & ((rvalue & ~address) |', 'const __mmask64 folds = constant & ((rvalue & ~address) |'),
    ('folds-addressed-rvalue', W, 'const __mmask64 folds = constant & ~effects & ((rvalue & ~address) |', 'const __mmask64 folds = constant & ~effects & (rvalue |'),
    ('folds-no-address-constant', W, '((rvalue & ~address) | ((address | address_value) & address_constant));', '(rvalue & ~address);'),
    ('folds-address-value-alone', W, '((rvalue & ~address) | ((address | address_value) & address_constant));', '((rvalue & ~address) | (address_value & address_constant));'),
    ('takes-unknown-object', W, 'const __mmask64 takes = (address_constant & (~has_object | known)) |', 'const __mmask64 takes = address_constant |'),
    ('takes-complex', W, '(~address_constant & simple & (integer | (floating_constant & floating)));', '(~address_constant & (integer | (floating_constant & floating)));'),
    ('takes-any-floating', W, '(~address_constant & simple & (integer | (floating_constant & floating)));', '(~address_constant & simple & (integer | floating));'),
    ('takes-floating-not', W, '(~address_constant & simple & (integer | (floating_constant & floating)));', '(~address_constant & simple & integer);'),
    ('shared-atomic-addressed', W, 'const __mmask64 shared = unfit | (~address & lvalue & atomic);', 'const __mmask64 shared = unfit | (lvalue & atomic);'),
    ('shared-atomic-not', W, 'const __mmask64 shared = unfit | (~address & lvalue & atomic);', 'const __mmask64 shared = unfit;'),
    ('shared-unfit-not', W, 'const __mmask64 shared = unfit | (~address & lvalue & atomic);', 'const __mmask64 shared = (~address & lvalue & atomic);'),
    ('named-value-rvalue', W, 'const __mmask64 named_value = is_value & ~void_type & ~placed_value & lvalue & known & plain;', 'const __mmask64 named_value = is_value & ~void_type & ~placed_value & known & plain;'),
    ('named-value-unknown', W, 'const __mmask64 named_value = is_value & ~void_type & ~placed_value & lvalue & known & plain;', 'const __mmask64 named_value = is_value & ~void_type & ~placed_value & lvalue & plain;'),
    ('named-value-aggregate', W, 'const __mmask64 named_value = is_value & ~void_type & ~placed_value & lvalue & known & plain;', 'const __mmask64 named_value = is_value & ~void_type & ~placed_value & lvalue & known;'),
    ('storable-atomic', W, 'const __mmask64 storable = is_assign & plain & ~left_atomic & ~left_bit_field;', 'const __mmask64 storable = is_assign & plain & ~left_bit_field;'),
    ('storable-bit-field', W, 'const __mmask64 storable = is_assign & plain & ~left_atomic & ~left_bit_field;', 'const __mmask64 storable = is_assign & plain & ~left_atomic;'),
    ('storable-aggregate', W, 'const __mmask64 storable = is_assign & plain & ~left_atomic & ~left_bit_field;', 'const __mmask64 storable = is_assign & ~left_atomic & ~left_bit_field;'),
    ('constant-shared', W, 'const __mmask64 made_constant = ~shared & folds & takes;', 'const __mmask64 made_constant = folds & takes;'),
    ('constant-untaken', W, 'const __mmask64 made_constant = ~shared & folds & takes;', 'const __mmask64 made_constant = ~shared & folds;'),
    ('address-unknown-object', W, 'const __mmask64 made_address = free & is_value & ~void_type & placed_value & (~has_object | known);', 'const __mmask64 made_address = free & is_value & ~void_type & placed_value;'),
    ('local-with-symbol', W, 'const __mmask64 made_local = free & named_value & ~symbol;', 'const __mmask64 made_local = free & named_value;'),
    ('global-never', W, 'const __mmask64 made_global = free & named_value & symbol;', 'const __mmask64 made_global = 0;'),
    ('pass-wide-wrap', W, 'const __mmask64 made_pass = free & ((is_wrap & small) | is_address);', 'const __mmask64 made_pass = free & (is_wrap | is_address);'),
    ('pass-no-address', W, 'const __mmask64 made_pass = free & ((is_wrap & small) | is_address);', 'const __mmask64 made_pass = free & (is_wrap & small);'),
    ('dereference-any', W, 'const __mmask64 made_dereference = free & is_dereference & (aggregate | placed_value | scalar_class);', 'const __mmask64 made_dereference = free & is_dereference;'),
    ('member-bit-field', W, 'const __mmask64 made_member = free & is_member & ~bit_field & (placed_value | scalar_class);', 'const __mmask64 made_member = free & is_member & (placed_value | scalar_class);'),
    ('member-any', W, 'const __mmask64 made_member = free & is_member & ~bit_field & (placed_value | scalar_class);', 'const __mmask64 made_member = free & is_member & ~bit_field;'),
    ('unary-any', W, 'const __mmask64 made_unary = free & is_unary & plain;', 'const __mmask64 made_unary = free & is_unary;'),
    ('truth-untestable', W, 'const __mmask64 made_truth = free & is_truth & plain & testable;', 'const __mmask64 made_truth = free & is_truth & plain;'),
    ('binary-vector-sum', W, '((is_sum & ~vector & ~left_pointer & ~right_pointer) | (is_binary & ~first_aggregate));', '((is_sum & ~left_pointer & ~right_pointer) | (is_binary & ~first_aggregate));'),
    ('binary-pointer-sum', W, '((is_sum & ~vector & ~left_pointer & ~right_pointer) | (is_binary & ~first_aggregate));', '((is_sum & ~vector & ~right_pointer) | (is_binary & ~first_aggregate));'),
    ('binary-unscalar', W, 'const __mmask64 made_binary = free & plain & both_scalar &', 'const __mmask64 made_binary = free & plain &'),
    ('store-local-global', W, 'const __mmask64 made_store_local = free & storable & named & ~named_global;', 'const __mmask64 made_store_local = free & storable & named;'),
    ('store-unnamed-named', W, 'const __mmask64 made_store = free & storable & ~named;', 'const __mmask64 made_store = free & storable;'),
    ('pointed-right-pointer', W, '& placed & ~vector & left_pointer & ~right_pointer & (~is_subscript | placed_value | scalar_class);', '& placed & ~vector & left_pointer & (~is_subscript | placed_value | scalar_class);'),
    ('pointed-any-subscript', W, '& placed & ~vector & left_pointer & ~right_pointer & (~is_subscript | placed_value | scalar_class);', '& placed & ~vector & left_pointer & ~right_pointer;'),
    ('pointed-vector', W, '& placed & ~vector & left_pointer & ~right_pointer & (~is_subscript | placed_value | scalar_class);', '& placed & left_pointer & ~right_pointer & (~is_subscript | placed_value | scalar_class);'),
    ('pointed-sum-not', W, 'uint64_t pointed = (is_sum | is_subscript) & free', 'uint64_t pointed = is_subscript & free'),
    ('bit0-no-store', W, 'made_dereference | made_unary | made_binary | made_store_local | made_store;\n        const __mmask64 bit1', 'made_dereference | made_unary | made_binary | made_store_local;\n        const __mmask64 bit1'),
    ('bit3-no-pointer', W, 'const __mmask64 bit3 = made_member | made_unary | made_truth | made_binary | made_pointer |', 'const __mmask64 bit3 = made_member | made_unary | made_truth | made_binary |'),
    # the evaluated records and the discards
    ('evaluates-unrooted', W, 'const __mmask64 evaluates = rooted | (has_up &', 'const __mmask64 evaluates = (has_up &'),
    ('dead-leaves-walked', W, 'for (uint64_t pending = placed & ~evaluates & ~is_value; pending != 0; pending &= pending - 1)\n        {\n            const uint32_t lane = (uint32_t)_tzcnt_u64(pending);\n            const uint32_t size = front->sizes[x + lane];',
     'for (uint64_t pending = 0; pending != 0; pending &= pending - 1)\n        {\n            const uint32_t lane = (uint32_t)_tzcnt_u64(pending);\n            const uint32_t size = front->sizes[x + lane];'),
    ('dead-low-lost', W, 'dead_low = low < x && low < dead_low ? low : dead_low;', 'dead_low = dead_low;'),
    ('dead-carried-not', W, 'uint64_t dead = dead_low <= x ? ~UINT64_C(0) : dead_low < x + 64 ? ~UINT64_C(0) << (dead_low - x) : 0;', 'uint64_t dead = 0;'),
    ('alive-unplaced', W, 'const __mmask64 alive = placed & evaluates & ~dead;', 'const __mmask64 alive = evaluates & ~dead;'),
    ('alive-dead-too', W, 'const __mmask64 alive = placed & evaluates & ~dead;', 'const __mmask64 alive = placed & evaluates;'),
    ('discards-addressed', W, 'const __mmask64 discards = is_assign & ~address & (aggregate | left_bit_field);', 'const __mmask64 discards = is_assign & (aggregate | left_bit_field);'),
    ('discards-aggregate-not', W, 'const __mmask64 discards = is_assign & ~address & (aggregate | left_bit_field);', 'const __mmask64 discards = is_assign & ~address & left_bit_field;'),
    ('discards-bit-field-not', W, 'const __mmask64 discards = is_assign & ~address & (aggregate | left_bit_field);', 'const __mmask64 discards = is_assign & ~address & aggregate;'),
    ('mask-none-dead-too', W, 'masks[BUSTER_NODE_CONTEXTS_MASK_NONE] = alive & _mm512_testn_epi8_mask(templates, templates);', 'masks[BUSTER_NODE_CONTEXTS_MASK_NONE] = placed & _mm512_testn_epi8_mask(templates, templates);'),
    ('next-templates-stale', W, '        next_templates = templates;\n', '        next_templates = next_templates;\n'),
    ('next-classes-stale', W, '        next_classes = classes;\n', '        next_classes = next_classes;\n'),
    # the targets
    ('target-given-first-only', W, '_mm512_slli_epi32(_mm512_min_epu32(places, _mm512_set1_epi32(1)), 2));', '_mm512_slli_epi32(_mm512_min_epu32(places, _mm512_set1_epi32(0)), 2));'),
    ('target-node-converted', W, 'const __m512i fields = _mm512_mask_mov_epi32(_mm512_set1_epi32((int32_t)offsetof(NodeFactsRecord, type)), given, converted);',
     'const __m512i fields = converted;'),
    ('target-long-int', W, 'targets = _mm512_mask_mov_epi32(targets, index, _mm512_set1_epi32((int32_t)BUSTER_TYPE_LONG));', 'targets = _mm512_mask_mov_epi32(targets, index, _mm512_set1_epi32((int32_t)BUSTER_TYPE_INT));'),
    ('target-dead-too', W, 'const __mmask16 given = _mm512_mask_cmpeq_epi32_mask(alive, sources, _mm512_set1_epi32(BUSTER_NODE_CONTEXTS_SOURCE_GIVEN));',
     'const __mmask16 given = _mm512_cmpeq_epi32_mask(sources, _mm512_set1_epi32(BUSTER_NODE_CONTEXTS_SOURCE_GIVEN));'),
    ('discard-never', W, 'if (__builtin_expect(discardable != 0, 0))', 'if (__builtin_expect(discardable != 0 && x > count, 0))'),
    ('discard-any-target', W, 'const __mmask16 discarded = discardable & _mm512_cmpeq_epi32_mask(targets, _mm512_set1_epi32((int32_t)BUSTER_TYPE_VOID));', 'const __mmask16 discarded = discardable;'),
    # an expression's part
    ('part-root-listed-not', W, '''            const bool listed = node_contexts_window_any(state->window_c_masks, BUSTER_NODE_CONTEXTS_MASK_LISTED, first, size) |
                                ((root_masks[BUSTER_NODE_CONTEXTS_MASK_LISTED] & root_bit) != 0);''',
     '            const bool listed = node_contexts_window_any(state->window_c_masks, BUSTER_NODE_CONTEXTS_MASK_LISTED, first, size);'),
    ('part-root-refused-not', W, '''            const bool refused = node_contexts_window_any(state->window_c_masks, BUSTER_NODE_CONTEXTS_MASK_NONE, first, size) |
                                 ((root_masks[BUSTER_NODE_CONTEXTS_MASK_NONE] & root_bit) != 0);''',
     '            const bool refused = node_contexts_window_any(state->window_c_masks, BUSTER_NODE_CONTEXTS_MASK_NONE, first, size);'),
    ('part-range-short', W, 'const uint64_t taken = short_size == 64 ? ~UINT64_C(0) : (UINT64_C(1) << short_size) - 1;', 'const uint64_t taken = short_size == 64 ? ~UINT64_C(0) : (UINT64_C(1) << short_size) - 1 - (short_size > 1 ? UINT64_C(1) << (short_size - 1) : 0);'),
    ('part-range-next-word-not', W, 'uint64_t any = (low | high) & taken;', 'uint64_t any = low & taken;'),
    ('part-range-long-not', W, 'any |= masks[BUSTER_NODE_CONTEXTS_MASKS * (uint64_t)(at / 64) + mask] & bits;', 'any |= 0;'),
    ('part-root-target-operand', W, 'state->window_c_targets[rooted ? record : operand] = state->c_targets[e];', 'state->window_c_targets[operand] = state->c_targets[e];'),
    ('part-refused-taken', W, 'verdict = (uint8_t)(listed ? BUSTER_NODE_CONTEXTS_LISTED : refused ? BUSTER_NODE_CONTEXTS_REFUSED : BUSTER_NODE_CONTEXTS_TAKEN);',
     'verdict = (uint8_t)(listed ? BUSTER_NODE_CONTEXTS_LISTED : BUSTER_NODE_CONTEXTS_TAKEN);'),
    # the comparison and the counts
    ('compare-no-target', W, '''                                                            state->window_c_contexts[x] == state->place_c_contexts[x] &&
                                                            state->window_c_targets[x] == state->place_c_targets[x]));''',
     '                                                            state->window_c_contexts[x] == state->place_c_contexts[x]));'),
    ('compare-no-context', W, '''state->window_c_templates[x] == state->place_c_templates[x] &&
                                                            state->window_c_contexts[x] == state->place_c_contexts[x] &&''',
     'state->window_c_templates[x] == state->place_c_templates[x] &&'),
    ('compare-no-template', W, 'const bool same = alive == evaluated && (!alive || (state->window_c_templates[x] == state->place_c_templates[x] &&', 'const bool same = alive == evaluated && (!alive || ('),
    ('compare-no-evaluated', W, 'const bool same = alive == evaluated && (!alive ||', 'const bool same = (!alive ||'),
    ('compare-verdict-not', W, 'return refused != reference_refused || wrong != 0;', 'return wrong != 0;'),
    ('count-strides-not', W, 'counts[NODE_FACTS_COUNT_CONTEXTS_STRIDES] += loop_counts.strides;', 'counts[NODE_FACTS_COUNT_CONTEXTS_STRIDES] += 0;'),
    ('count-refused-not', W, "counts[NODE_FACTS_COUNT_CONTEXTS_REFUSED] += verdict == BUSTER_NODE_CONTEXTS_REFUSED;", 'counts[NODE_FACTS_COUNT_CONTEXTS_REFUSED] += 0;'),
    # the records' bytes
    ('bytes-symbol-never', C, 'const __mmask16 symbolled = _mm512_mask_test_epi32_mask(named, line, _mm512_set1_epi32(BUSTER_NODE_TESTS_LINE_SYMBOL));', 'const __mmask16 symbolled = 0;'),
    ('bytes-line-symbol-never', C, '(symbol ? BUSTER_NODE_TESTS_LINE_SYMBOL : 0) |', '0 |'),
    ('bytes-known-all', C, 'const __mmask16 known = _mm512_mask_cmplt_epu32_mask(objected, objects, _mm512_set1_epi32((int32_t)machine->object_count));', 'const __mmask16 known = objected;'),
    ('bytes-effects-side-only', C, '_mm512_set1_epi32((int32_t)(BUSTER_CHECK_SIDE_EFFECT | BUSTER_CHECK_FP_ENVIRONMENT)));', '_mm512_set1_epi32((int32_t)(BUSTER_CHECK_SIDE_EFFECT)));'),
    ('bytes-element-never', C, 'const __mmask16 element = _mm512_test_epi32_mask(flags, _mm512_set1_epi32((int32_t)BUSTER_CHECK_VECTOR_ELEMENT));', 'const __mmask16 element = 0;'),
    ('bytes-bit-field-never', C, '_mm_maskz_set1_epi8(bit_field, BUSTER_NODE_CONTEXTS_BIT_FIELD)', '_mm_maskz_set1_epi8(bit_field, 0)'),
    # the front's distance
    ('ups-operator-not', F, '                if (window)\n                {\n                    front->window_ups[operand] = (uint16_t)(record - operand);', '                if (window && k != 1)\n                {\n                    front->window_ups[operand] = (uint16_t)(record - operand);'),
    ('ups-kept-not', F, '    front->window_ups[to] = front->window_ups[from];\n', ''),
    # the reference kept for the comparison
    ('reference-ran-refused-as-taken', R, 'swept == NODE_MACHINE_TAKEN ? BUSTER_NODE_CONTEXTS_RAN_TAKEN : BUSTER_NODE_CONTEXTS_RAN_REFUSED;', 'swept == NODE_MACHINE_TAKEN ? BUSTER_NODE_CONTEXTS_RAN_TAKEN : BUSTER_NODE_CONTEXTS_RAN_TAKEN;'),
]
if len(sys.argv) > 3 and sys.argv[3] == 'check':
    bad = 0
    for name, f, a, b in FAULTS:
        n = open(SRC + f).read().count(a)
        if n != 1:
            print('NOT ONCE', name, n); bad += 1
    names = [n for n, _, _, _ in FAULTS]
    assert len(set(names)) == len(names), 'a name twice'
    print(len(FAULTS), 'faults,', bad, 'not there once')
    sys.exit(1 if bad else 0)
out = open('/home/user/mut15/results-%d.txt' % worker, 'w')
for index, (name, f, a, b) in enumerate(FAULTS):
    if index % of != worker:
        continue
    text = open(SRC + f).read()
    assert text.count(a) == 1, (name, text.count(a))
    open(SRC + f, 'w').write(text.replace(a, b))
    t0 = time.time()
    build = subprocess.run(['./build.sh', '--config', 'Debug', '--jobs', '2'], cwd=TREE, capture_output=True, text=True)
    if build.returncode != 0:
        verdict = 'NOT BUILT ' + (build.stdout + build.stderr)[-300:].replace('\n', ' ')
    else:
        try:
            test = subprocess.run(['./build/compiler', 'test-checker', '--seed', '133', '--part', '5/8'], cwd=TREE, capture_output=True, text=True, timeout=1200)
            first = (test.stderr.strip().split('\n') or [''])[0][:300]
            verdict = ('caught' if test.returncode != 0 else 'SURVIVED') + ' [status %d] %s' % (test.returncode, first)
        except subprocess.TimeoutExpired:
            verdict = 'TIMED OUT'
    out.write('%s: %s (%d s)\n' % (name, verdict, time.time() - t0)); out.flush()
    open(SRC + f, 'w').write(text)
out.write('done\n'); out.close()
