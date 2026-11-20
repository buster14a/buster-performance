#!/usr/bin/env python3
# make-faults-logical.py TREE OUT: build OUT (a round's faults list), an operator's value's and a comma's faults in the
# frozen code (#2850: `&&` and `||` as values, `?:` and a comma on the window): each row of C's tables for them, each
# term of the loop's masks (the branch operators, the runs of `!`, the entered and the chained records and the doubling
# steps, the value's and the comma's templates and what lists), the record-at-a-time steps (a comma's consumer's type,
# the conversion put into the arms, a root's), the keys, and X's side: the reads' mask, the shapes' rows and the arms'
# table, the turn of an operator's value, the write's class, the values' marks by kind, the last entry's list, the
# rest's and the numbering by labels; each changed alone.
import sys
tree = sys.argv[1]
ROWS = 'src/buster/compiler/c_check_node_machine_rows.c'
WINDOW = 'src/buster/compiler/c_check_node_machine_window.c'
FACTS = 'src/buster/compiler/c_check_node_machine_facts.c'
texts = {f: open(tree + '/' + f).read() for f in (ROWS, WINDOW, FACTS)}
out = []
def N(name, old, new, file):
    assert texts[file].count(old) == 1, (name, texts[file].count(old))
    assert name not in [f[0] for f in out], name
    assert old != new, name
    out.append((name, file, old, new, None))
def L(name, anchor, a, b, file=WINDOW, k=1):
    # A fault within the one line that has `anchor`: the k-th `a` in it replaced by `b`.
    lines = [l for l in texts[file].split('\n') if anchor in l]
    assert len(lines) == 1, (name, anchor, len(lines))
    line = lines[0]
    parts = line.split(a)
    assert len(parts) > k, (name, a)
    N(name, line, a.join(parts[:k]) + b + a.join(parts[k:]), file)

# ---- C's tables.
L('table-select-a-comma', 'case CHECK_OP_COMMA: class = BUSTER_NODE_CONTEXTS_CLASS_COMMA; break;', 'case CHECK_OP_COMMA:', 'case CHECK_OP_COMMA: case CHECK_OP_SELECT:')
L('table-value-condition-node', 'tables->rows[NODE_MACHINE_TEMPLATE_BRANCH << 1] = given;', '= given', '= node')
L('table-value-second-node', 'tables->rows[(NODE_MACHINE_TEMPLATE_BRANCH << 1) + 1] = given;', '= given', '= node')
L('table-conditional-condition-node', 'tables->rows[BUSTER_NODE_CONTEXTS_KEY_CONDITIONAL << 1] = given;', '= given', '= node')
L('table-conditional-arm-given', 'tables->rows[(BUSTER_NODE_CONTEXTS_KEY_CONDITIONAL << 1) + 1] = node;', '= node', '= given')
L('table-comma-first-node', 'tables->rows[BUSTER_NODE_CONTEXTS_KEY_COMMA << 1] = voided;', '= voided', '= node')
L('table-comma-second-voided', 'tables->rows[(BUSTER_NODE_CONTEXTS_KEY_COMMA << 1) + 1] = node;', '= node', '= voided')
L('table-discard-first-node', 'tables->rows[BUSTER_NODE_CONTEXTS_KEY_COMMA_DISCARD << 1] = voided;', '= voided', '= node')
L('table-discard-second-node', 'tables->rows[(BUSTER_NODE_CONTEXTS_KEY_COMMA_DISCARD << 1) + 1] = voided;', '= voided', '= node')
L('table-voided-not-evaluated', 'const uint8_t voided = BUSTER_NODE_CONTEXTS_EVALUATES | BUSTER_NODE_CONTEXTS_SOURCE_VOID;', 'BUSTER_NODE_CONTEXTS_EVALUATES | ', '')

# ---- The loop: a far consumer's key.
L('far-key-the-template', 'far_bytes[BUSTER_NODE_CONTEXTS_FAR_TEMPLATE][lane] = state->window_c_keys[consumer];', 'window_c_keys', 'window_c_templates')

# ---- The loop: the consumer's classes.
CONDITION = 'const __mmask64 consumer_condition = consumer_truth & '
L('consumer-condition-every-truth', CONDITION, 'consumer_truth & _mm512_test_epi8_mask(consumer_classes, _mm512_set1_epi8(BUSTER_NODE_CONTEXTS_CLASS_CONDITION))', 'consumer_truth')
L('consumer-not-every-truth', 'const __mmask64 consumer_not = consumer_truth & ~consumer_condition;', ' & ~consumer_condition', '')
L('consumer-conditional-a-logical', 'const __mmask64 consumer_conditional = ', 'BUSTER_NODE_CONTEXTS_CLASS_CONDITIONAL', 'BUSTER_NODE_CONTEXTS_CLASS_LOGICAL')
L('consumer-comma-a-wrap', 'const __mmask64 consumer_comma = ', 'BUSTER_NODE_CONTEXTS_CLASS_COMMA', 'BUSTER_NODE_CONTEXTS_CLASS_WRAP')
L('consumer-wrap-a-comma', 'const __mmask64 consumer_wrap = ', 'BUSTER_NODE_CONTEXTS_CLASS_WRAP', 'BUSTER_NODE_CONTEXTS_CLASS_COMMA')

# ---- The loop: the branch operators and the runs of `!`.
LOGICAL = 'const uint64_t operator_logical = _cvtmask64_u64(is_logical & free & left_unknown);'
L('operator-logical-folded-too', LOGICAL, ' & free', '')
L('operator-logical-known-too', LOGICAL, ' & left_unknown', '')
L('operator-not-folded-too', 'const uint64_t operator_not = _cvtmask64_u64(is_not & free);', ' & free', '')
DEEP = 'const uint64_t deep_not = operator_not & ~(operator_not + (operator_logical << 1));'
L('deep-not-unshifted', DEEP, '(operator_logical << 1)', 'operator_logical')
L('deep-not-shifted-two', DEEP, '(operator_logical << 1)', '(operator_logical << 2)')
L('deep-not-the-first-alone', DEEP, 'operator_not & ~(operator_not + (operator_logical << 1))', 'operator_not & (operator_logical << 1)')
L('deep-not-every-not', DEEP, 'operator_not & ~(operator_not + (operator_logical << 1))', 'operator_not')
L('deep-not-none', DEEP, 'operator_not & ~(operator_not + (operator_logical << 1))', '0')
L('deep-without-the-nots', 'const uint64_t deep = operator_logical | deep_not;', ' | deep_not', '')
L('deep-without-the-operators', 'const uint64_t deep = operator_logical | deep_not;', 'operator_logical | ', '')
L('operators-no-logical', 'const uint64_t operators = operator_logical | operator_not;', 'operator_logical | ', '')
L('operators-no-not', 'const uint64_t operators = operator_logical | operator_not;', ' | operator_not', '')
EDGE = 'const uint64_t edge = operators & _cvtmask64_u64(consumer_not) & (UINT64_C(1) << 63);'
L('edge-none', EDGE, 'operators & _cvtmask64_u64(consumer_not) & (UINT64_C(1) << 63)', '0')
L('edge-any-operator-last', EDGE, ' & _cvtmask64_u64(consumer_not)', '')
L('edge-any-record-under-a-not', EDGE, 'operators & ', '')
L('edge-the-first-record', EDGE, '(UINT64_C(1) << 63)', 'UINT64_C(1)')
ENTERED = 'const uint64_t entered = (operators & _cvtmask64_u64(consumer_logical & first_place)) | (deep & _cvtmask64_u64(consumer_condition | (consumer_conditional & first_place)));'
L('entered-no-logical-first', ENTERED, '(operators & _cvtmask64_u64(consumer_logical & first_place)) | ', '')
L('entered-logical-either-place', ENTERED, 'consumer_logical & first_place', 'consumer_logical')
L('entered-the-deep-alone-first', ENTERED, '(operators & _cvtmask64_u64(consumer_logical & first_place))', '(deep & _cvtmask64_u64(consumer_logical & first_place))')
L('entered-no-condition', ENTERED, 'consumer_condition | ', '')
L('entered-no-conditional', ENTERED, ' | (consumer_conditional & first_place)', '')
L('entered-conditional-any-place', ENTERED, '(consumer_conditional & first_place)', 'consumer_conditional')
L('entered-every-operator-a-condition', ENTERED, '(deep & _cvtmask64_u64(consumer_condition', '((operators | (deep & 0)) & _cvtmask64_u64(consumer_condition')
CHAINED = 'const uint64_t chained = operators & _cvtmask64_u64((consumer_logical & ~first_place) | consumer_not);'
L('chained-no-second', CHAINED, '(consumer_logical & ~first_place) | ', '')
L('chained-no-not', CHAINED, ' | consumer_not', '')
L('chained-the-deep-alone', CHAINED, 'operators & _cvtmask64_u64', 'deep & _cvtmask64_u64')
L('chained-any-record', CHAINED, 'operators & _cvtmask64_u64', '_cvtmask64_u64')
GENERATE = 'uint64_t generate = entered | (chained & (carry_branched << 63));'
L('generate-no-carry', GENERATE, '(chained & (carry_branched << 63))', '(chained & (carry_branched << 63) & 0)')
L('generate-carry-unchained', GENERATE, '(chained & (carry_branched << 63))', '(carry_branched << 63)')
L('generate-carry-at-the-first', GENERATE, '(carry_branched << 63)', 'carry_branched')
L('step-one-none', 'generate |= propagate & (generate >> 1);', 'generate |= propagate & (generate >> 1);', 'generate |= 0;')
L('step-one-unpropagated', 'generate |= propagate & (generate >> 1);', 'propagate & ', '')
L('step-one-up', 'generate |= propagate & (generate >> 1);', '(generate >> 1)', '(generate << 1)')
L('step-one-span', 'propagate &= propagate >> 1;', 'propagate &= propagate >> 1;', 'propagate &= ~UINT64_C(0);')
L('step-two-none', 'generate |= propagate & (generate >> 2);', 'generate |= propagate & (generate >> 2);', 'generate |= 0;')
L('step-two-by-one', 'generate |= propagate & (generate >> 2);', '(generate >> 2)', '(generate >> 1)')
L('step-two-span', 'propagate &= propagate >> 2;', 'propagate &= propagate >> 2;', 'propagate &= propagate >> 1;')
L('step-two-no-span', 'propagate &= propagate >> 2;', 'propagate &= propagate >> 2;', 'propagate &= 0;')
L('unreached-none', 'const uint64_t unreached = propagate;', 'unreached = propagate;', 'unreached = propagate & 0;')
L('branched-no-generated', 'const __mmask64 branched = _cvtu64_mask64(generate) | branched_root;', '_cvtu64_mask64(generate) | ', '')
L('branched-no-root', 'const __mmask64 branched = _cvtu64_mask64(generate) | branched_root;', ' | branched_root', ' | (branched_root & 0)')
VALUEDL = 'const __mmask64 valued_logical = _cvtu64_mask64(operator_logical & ~generate & ~unreached);'
L('valued-the-branched-too', VALUEDL, ' & ~generate', '')
L('valued-the-unreached-too', VALUEDL, ' & ~unreached', '')
L('valued-a-not-too', VALUEDL, 'operator_logical & ', 'operators & ')
L('branched-root-over-a-not', 'const __mmask64 branched_root = is_condition & left_logical;', 'left_logical', '(left_logical | left_not)')
UNBRANCHED = 'const __mmask64 unbranched = (is_logical & ~_cvtu64_mask64(operator_logical)) | (_cvtu64_mask64(deep_not) & consumer_condition) | (valued_logical & left_not) |'
L('unbranched-no-operator', UNBRANCHED, '(is_logical & ~_cvtu64_mask64(operator_logical)) | ', '')
L('unbranched-no-condition-over-not', UNBRANCHED, '(_cvtu64_mask64(deep_not) & consumer_condition) | ', '')
L('unbranched-no-value-over-not', UNBRANCHED, '(valued_logical & left_not) |', '(valued_logical & left_not & ~left_not) |')
L('unbranched-no-unreached', '_cvtu64_mask64(unreached | edge);', 'unreached | edge', 'edge')
L('unbranched-no-edge', '_cvtu64_mask64(unreached | edge);', 'unreached | edge', 'unreached | (edge & 0)')
L('carry-none', 'carry_branched = generate & 1;', 'generate & 1', '0')
L('carry-the-last', 'carry_branched = generate & 1;', 'generate & 1', 'generate >> 63')

# ---- The loop: an operator's value's template and a comma's.
OPEN = 'const __mmask64 open_conditional = is_conditional & free & left_unknown;'
L('conditional-folded-too', OPEN, ' & free', '')
L('conditional-known-too', OPEN, ' & left_unknown', '')
MADE = 'const __mmask64 made_conditional = open_conditional & (numeric | void_type) & left_tested;'
L('conditional-any-class', MADE, ' & (numeric | void_type)', '')
L('conditional-no-void', MADE, '(numeric | void_type)', 'numeric')
L('conditional-void-alone', MADE, '(numeric | void_type)', 'void_type')
L('conditional-any-condition', MADE, ' & left_tested', '')
VALUED = 'const __mmask64 made_valued = made_conditional | (valued_logical & ~left_not & left_tested & right_tested);'
L('valued-no-conditional', VALUED, 'made_conditional | ', '')
L('valued-no-logical', VALUED, ' | (valued_logical & ~left_not & left_tested & right_tested)', '')
L('valued-over-a-not-too', VALUED, ' & ~left_not', '')
L('valued-any-condition', VALUED, ' & left_tested & right_tested', ' & right_tested')
L('valued-any-second', VALUED, ' & left_tested & right_tested', ' & left_tested')
COMMA = 'const __mmask64 made_comma = free & is_comma & numeric;'
L('comma-any-class', COMMA, ' & numeric', '')
UNCOMMAED = 'const __mmask64 uncommaed = is_comma & (~free | address | (consumer_comma & ~first_place));'
L('uncommaed-no-folded', UNCOMMAED, '~free | ', '')
L('uncommaed-no-address', UNCOMMAED, 'address | ', '')
L('uncommaed-no-second', UNCOMMAED, ' | (consumer_comma & ~first_place)', '')
L('uncommaed-the-first-too', UNCOMMAED, '(consumer_comma & ~first_place)', 'consumer_comma')
PENDING = 'for (uint64_t pending = made_comma & (near_up | far_up) & (consumer_wrap | (consumer_conditional & ~first_place)); pending != 0; pending &= pending - 1)'
L('voided-no-wrap', PENDING, '(consumer_wrap | (consumer_conditional & ~first_place))', '((consumer_wrap & 0) | (consumer_conditional & ~first_place))')
L('voided-no-arm', PENDING, '(consumer_wrap | (consumer_conditional & ~first_place))', 'consumer_wrap')
L('voided-a-condition-too', PENDING, '(consumer_conditional & ~first_place)', 'consumer_conditional')
L('voided-far-ones-left', PENDING, '(near_up | far_up)', 'near_up')
EXACT = 'voided |= (uint64_t)(state->window_c_classes[consumer] == BUSTER_TYPED_CLASS_VOID ? 1 : 0) << lane;'
L('voided-any-type', EXACT, 'state->window_c_classes[consumer] == BUSTER_TYPED_CLASS_VOID ? 1 : 0', 'state->window_c_classes[consumer] == BUSTER_TYPED_CLASS_VOID ? 1 : 1')
L('voided-its-own-type', EXACT, 'window_c_classes[consumer]', 'window_c_classes[consumer - consumer + x + lane]')
DISCARDED = 'const __mmask64 discarded = (is_comma & consumer_comma & first_place) | _cvtu64_mask64(voided);'
L('discarded-no-first', DISCARDED, '(is_comma & consumer_comma & first_place) | ', '')
L('discarded-a-second-too', DISCARDED, '(is_comma & consumer_comma & first_place)', '(is_comma & consumer_comma)')
L('discarded-any-first', DISCARDED, '(is_comma & consumer_comma & first_place)', '(consumer_comma & first_place)')
L('discarded-no-voided', DISCARDED, ' | _cvtu64_mask64(voided)', ' | _cvtu64_mask64(voided & 0)')
L('contexts-no-discard', 'for (uint64_t pending = discarded; pending != 0; pending &= pending - 1)', 'pending = discarded', 'pending = 0')
L('contexts-discard-an-address', 'state->window_c_contexts[x + (uint32_t)_tzcnt_u64(pending)] = BUSTER_CHECK_LOWER_TEMPLATE_DISCARD;', 'BUSTER_CHECK_LOWER_TEMPLATE_DISCARD', 'BUSTER_CHECK_LOWER_TEMPLATE_ADDRESS')
L('contexts-discard-the-block-s-first', 'state->window_c_contexts[x + (uint32_t)_tzcnt_u64(pending)] = BUSTER_CHECK_LOWER_TEMPLATE_DISCARD;', 'x + (uint32_t)_tzcnt_u64(pending)', 'x')
L('count-valued-unplaced', 'valued_count += (uint64_t)_mm_popcnt_u64(placed & made_valued);', 'placed & made_valued', 'made_valued')
LISTED = '(update_asked & ~made_update) | unbranched | (is_conditional & ~open_conditional) | uncommaed);'
L('listed-no-unbranched', LISTED, ' | unbranched', ' | (unbranched & 0)')
L('listed-no-closed-conditional', LISTED, ' | (is_conditional & ~open_conditional)', '')
L('listed-no-uncommaed', LISTED, ' | uncommaed', ' | (uncommaed & 0)')
L('passed-no-comma', 'const __mmask64 passed = made_pass | made_comma;', ' | made_comma', '')
L('uncased-a-class-past-the-comma', 'const __mmask64 is_uncased = _mm512_testn_epi8_mask(class_kinds, class_kinds);', '_mm512_testn_epi8_mask(class_kinds, class_kinds)',
  '_mm512_testn_epi8_mask(class_kinds, class_kinds) | _mm512_cmpge_epu8_mask(class_kinds, _mm512_set1_epi8(BUSTER_NODE_CONTEXTS_CLASS_COMMA))')
TEMPLATES = 'const __m512i templates = _mm512_mask_mov_epi8(branched_templates, made_valued, _mm512_set1_epi8(NODE_MACHINE_TEMPLATE_BRANCH));'
L('template-no-value', TEMPLATES, 'made_valued', '0')
L('template-a-decided', TEMPLATES, 'NODE_MACHINE_TEMPLATE_BRANCH)', 'NODE_MACHINE_TEMPLATE_DECIDED)')
COMMAK = 'const __m512i comma_keys = _mm512_mask_mov_epi8(_mm512_set1_epi8(BUSTER_NODE_CONTEXTS_KEY_COMMA), discarded, _mm512_set1_epi8(BUSTER_NODE_CONTEXTS_KEY_COMMA_DISCARD));'
L('key-no-discard', COMMAK, 'discarded', '0')
L('key-every-comma-discarded', COMMAK, 'discarded', 'made_comma')
OWNK = 'const __m512i own_keys = _mm512_mask_mov_epi8(comma_keys, made_conditional, _mm512_set1_epi8(BUSTER_NODE_CONTEXTS_KEY_CONDITIONAL));'
L('key-no-conditional', OWNK, 'made_conditional', '0')
L('key-conditional-every-value', OWNK, 'made_conditional', 'made_valued')
KEYS = 'const __m512i keys = _mm512_mask_mov_epi8(update_keys, made_comma | made_conditional, own_keys);'
L('key-no-comma', KEYS, 'made_comma | made_conditional', 'made_conditional')
L('key-conditional-its-template', KEYS, 'made_comma | made_conditional', 'made_comma')
L('keys-column-the-templates', '_mm512_storeu_si512(state->window_c_keys + x, keys);', 'keys);', 'templates);')

# ---- The loop: the record-at-a-time step of an operator's value.
L('sink-loop-none', 'for (uint64_t pending = placed & made_valued; pending != 0; pending &= pending - 1)', 'placed & made_valued', '0')
L('sink-consumer-none', 'const uint32_t consumer = front->ups[r] != 0 ? r + front->window_ups[r] : r;', 'front->ups[r] != 0 ? r + front->window_ups[r] : r', 'r')
L('sink-given-the-first', 'source == BUSTER_NODE_CONTEXTS_SOURCE_GIVEN ? line->converted[front->places[r] != 0 ? 1 : 0] :', 'front->places[r] != 0 ? 1 : 0', '0')
L('sink-given-the-second', 'source == BUSTER_NODE_CONTEXTS_SOURCE_GIVEN ? line->converted[front->places[r] != 0 ? 1 : 0] :', 'front->places[r] != 0 ? 1 : 0', '1')
L('sink-given-the-type', 'source == BUSTER_NODE_CONTEXTS_SOURCE_GIVEN ? line->converted[front->places[r] != 0 ? 1 : 0] :', 'line->converted[front->places[r] != 0 ? 1 : 0]', 'line->type')
L('sink-node-none', 'source == BUSTER_NODE_CONTEXTS_SOURCE_NODE  ? line->type :', 'line->type', '0')
L('sink-node-the-conversion', 'source == BUSTER_NODE_CONTEXTS_SOURCE_NODE  ? line->type :', 'line->type', 'line->converted[0]')
L('sink-long-none', 'source == BUSTER_NODE_CONTEXTS_SOURCE_LONG  ? BUSTER_TYPE_LONG :', 'BUSTER_TYPE_LONG', '0')
L('sink-own-none', 'source == BUSTER_NODE_CONTEXTS_SOURCE_OWN   ? (TypeId)state->facts.records[r].spare :', '(TypeId)state->facts.records[r].spare', '0')
L('twice-none', 'const bool twice = front->window_left[r] == front->window_right[r];', 'front->window_left[r] == front->window_right[r]', 'false')
SUNK = 'sunk |= (uint64_t)(twice || node_contexts_sinks(state, front, r, target) ? 1 : 0) << lane;'
L('sunk-twice-alone', SUNK, 'twice || node_contexts_sinks(state, front, r, target)', 'twice || (node_contexts_sinks(state, front, r, target) && false)')
L('sunk-no-twice', SUNK, 'twice || ', '(twice && false) || ')
L('sunk-not-listed', 'masks[BUSTER_NODE_CONTEXTS_MASK_LISTED] = listed | sunk;', ' | sunk', '')
L('sunk-count-none', 'sunk_count += (uint64_t)_mm_popcnt_u64(sunk);', '_mm_popcnt_u64(sunk)', '0')

# ---- The conversion the tasks may put into the arms.
RULE = 'if (to != 0 && facts->records[x].type != to)'
L('sinks-no-target-too', RULE, 'to != 0 && ', '')
L('sinks-its-own-type-too', RULE, ' && facts->records[x].type != to', '')
L('sinks-first-arm-the-condition', 'const uint8_t first = state->window_c_standings[x - front->window_right[x]] & 0x1c;', 'window_right', 'window_left')
L('sinks-first-arm-any-bit', 'const uint8_t first = state->window_c_standings[x - front->window_right[x]] & 0x1c;', '& 0x1c', '& 0x1f')
L('sinks-second-arm-the-first', 'const uint8_t second = state->window_c_standings[x - 1] & 0x1c;', 'x - 1', 'x - front->window_right[x]')
L('sinks-every-value-a-conditional', 'const bool conditional = (front->ops[x] & 0x7f) == CHECK_OP_CONDITIONAL;', '(front->ops[x] & 0x7f) == CHECK_OP_CONDITIONAL', 'true')
L('sinks-no-value-a-conditional', 'const bool conditional = (front->ops[x] & 0x7f) == CHECK_OP_CONDITIONAL;', '(front->ops[x] & 0x7f) == CHECK_OP_CONDITIONAL', 'false')
CONSTANT = 'const bool constant = !conditional || first == (CHECK_CONSTANT_INTEGER << 2) || second == (CHECK_CONSTANT_INTEGER << 2);'
L('sinks-a-logical-no-constant', CONSTANT, '!conditional || ', '(!conditional && false) || ')
L('sinks-first-arm-alone', CONSTANT, ' || second == (CHECK_CONSTANT_INTEGER << 2)', ' || (second == (CHECK_CONSTANT_INTEGER << 2) && false)')
L('sinks-second-arm-alone', CONSTANT, 'first == (CHECK_CONSTANT_INTEGER << 2) || ', '(first == (CHECK_CONSTANT_INTEGER << 2) && false) || ')
L('sinks-first-arm-any-constant', CONSTANT, 'first == (CHECK_CONSTANT_INTEGER << 2)', 'first != 0')
L('sinks-second-arm-any-constant', CONSTANT, 'second == (CHECK_CONSTANT_INTEGER << 2)', 'second != 0')
TARGET = 'sinks = constant && target >= BUSTER_TYPED_CLASS_I8 && target <= BUSTER_TYPED_CLASS_U64;'
L('sinks-no-constant-too', TARGET, 'constant && ', '(constant || true) && ')
L('sinks-void-too', TARGET, ' && target >= BUSTER_TYPED_CLASS_I8', '')
L('sinks-a-floating-target-too', TARGET, ' && target <= BUSTER_TYPED_CLASS_U64', '')
L('sinks-no-64-bit-target', TARGET, 'target <= BUSTER_TYPED_CLASS_U64', 'target <= BUSTER_TYPED_CLASS_U32')
L('sinks-no-narrow-target', TARGET, 'target >= BUSTER_TYPED_CLASS_I8', 'target >= BUSTER_TYPED_CLASS_I32')

# ---- The targets' sweep and the expression's part.
L('targets-no-void', 'const __m512i targets = _mm512_mask_mov_epi32(indexed, voided, _mm512_set1_epi32((int32_t)BUSTER_TYPE_VOID));', 'indexed, voided', 'indexed, voided & 0')
L('targets-void-a-long', 'const __m512i targets = _mm512_mask_mov_epi32(indexed, voided, _mm512_set1_epi32((int32_t)BUSTER_TYPE_VOID));', 'BUSTER_TYPE_VOID', 'BUSTER_TYPE_LONG')
ROOT = 'const bool sunk = !rooted && state->window_c_templates[operand] == NODE_MACHINE_TEMPLATE_BRANCH && node_contexts_sinks(state, front, operand, state->c_targets[e]);'
L('root-none', ROOT, '!rooted && state->window_c_templates[operand] == NODE_MACHINE_TEMPLATE_BRANCH && node_contexts_sinks(state, front, operand, state->c_targets[e])', 'false')
L('root-any-template', ROOT, 'state->window_c_templates[operand] == NODE_MACHINE_TEMPLATE_BRANCH && ', '')
L('root-no-target', ROOT, 'state->c_targets[e])', '0)')
N('root-no-bit', "            if (__builtin_expect(sunk, 0))\n            {", "            if (__builtin_expect(sunk && false, 0))\n            {", WINDOW)
L('root-not-listed', 'verdict = (uint8_t)(listed || sunk ? BUSTER_NODE_CONTEXTS_LISTED', 'listed || sunk', 'listed')
L('turns-no-values', 'state->c_branches_now = loop_counts.branched - loop_counts.branched_roots + loop_counts.valued;', ' + loop_counts.valued', '')

# ---- X: the reads, the tables.
L('reads-a-discarded-converts', 'converts &= alive & _mm512_testn_epi8_mask(contexts, contexts);', '_mm512_testn_epi8_mask(contexts, contexts)', '(_mm512_testn_epi8_mask(contexts, contexts) | ~UINT64_C(0))', file=ROWS)
LOGIC_ROWS = "            { BUSTER_TYPED_CONST, BUSTER_NODE_ROWS_CLASS_OPERAND },\n            { BUSTER_TYPED_NE, BUSTER_TYPED_CLASS_I32 },\n            { BUSTER_TYPED_JUMP_VALUE, BUSTER_NODE_ROWS_CLASS_OWN },\n            { BUSTER_TYPED_CONST, BUSTER_TYPED_CLASS_I32 },\n        };\n        node_rows_row(tables, BUSTER_NODE_ROWS_LOGIC + either, 4, entries);"
def B(name, a, b):
    assert LOGIC_ROWS.count(a) == 1, (name, a)
    N(name, LOGIC_ROWS, LOGIC_ROWS.replace(a, b), ROWS)
B('table-logic-test-own', 'BUSTER_NODE_ROWS_CLASS_OPERAND', 'BUSTER_NODE_ROWS_CLASS_OWN')
B('table-logic-eq', 'BUSTER_TYPED_NE', 'BUSTER_TYPED_EQ')
B('table-logic-jump', 'BUSTER_TYPED_JUMP_VALUE', 'BUSTER_TYPED_JUMP')
B('table-logic-jump-class', '{ BUSTER_TYPED_JUMP_VALUE, BUSTER_NODE_ROWS_CLASS_OWN }', '{ BUSTER_TYPED_JUMP_VALUE, BUSTER_TYPED_CLASS_I64 }')
B('table-logic-value-class', '{ BUSTER_TYPED_CONST, BUSTER_TYPED_CLASS_I32 }', '{ BUSTER_TYPED_CONST, BUSTER_TYPED_CLASS_U8 }')
B('table-logic-three', ', 4, entries', ', 3, entries')
L('table-arm-value-a-jump', 'const uint8_t value[1][2] = { { BUSTER_TYPED_JUMP_VALUE, BUSTER_NODE_ROWS_CLASS_OWN } };', 'BUSTER_TYPED_JUMP_VALUE', 'BUSTER_TYPED_JUMP', file=ROWS)
L('table-arm-value-class', 'const uint8_t value[1][2] = { { BUSTER_TYPED_JUMP_VALUE, BUSTER_NODE_ROWS_CLASS_OWN } };', 'BUSTER_NODE_ROWS_CLASS_OWN', 'BUSTER_TYPED_CLASS_I32', file=ROWS)
L('table-arm-none-a-value', 'const uint8_t none[1][2] = { { BUSTER_TYPED_JUMP, BUSTER_TYPED_CLASS_VOID } };', 'BUSTER_TYPED_JUMP,', 'BUSTER_TYPED_JUMP_VALUE,', file=ROWS)
L('table-arm-none-class', 'const uint8_t none[1][2] = { { BUSTER_TYPED_JUMP, BUSTER_TYPED_CLASS_VOID } };', 'BUSTER_TYPED_CLASS_VOID', 'BUSTER_NODE_ROWS_CLASS_OWN', file=ROWS)
L('table-arm-target-own', 'const uint8_t target[1][2] = { { BUSTER_TYPED_JUMP_VALUE, BUSTER_NODE_ROWS_CLASS_TARGET } };', 'BUSTER_NODE_ROWS_CLASS_TARGET', 'BUSTER_NODE_ROWS_CLASS_OWN', file=ROWS)
CONVERTED = 'const uint8_t converted[2][2] = { { BUSTER_TYPED_CONVERT, BUSTER_NODE_ROWS_CLASS_TARGET }, { BUSTER_TYPED_JUMP_VALUE, BUSTER_NODE_ROWS_CLASS_TARGET } };'
L('table-arm-converted-jump-own', CONVERTED, '{ BUSTER_TYPED_JUMP_VALUE, BUSTER_NODE_ROWS_CLASS_TARGET }', '{ BUSTER_TYPED_JUMP_VALUE, BUSTER_NODE_ROWS_CLASS_OWN }', file=ROWS)
L('table-arm-converted-convert-own', CONVERTED, '{ BUSTER_TYPED_CONVERT, BUSTER_NODE_ROWS_CLASS_TARGET }', '{ BUSTER_TYPED_CONVERT, BUSTER_NODE_ROWS_CLASS_OWN }', file=ROWS)
DISCARD = 'const uint8_t discarded[2][2] = { { BUSTER_TYPED_DISCARD, BUSTER_NODE_ROWS_CLASS_OWN }, { BUSTER_TYPED_JUMP, BUSTER_TYPED_CLASS_VOID } };'
L('table-arm-discarded-a-value', DISCARD, '{ BUSTER_TYPED_JUMP, BUSTER_TYPED_CLASS_VOID }', '{ BUSTER_TYPED_JUMP_VALUE, BUSTER_TYPED_CLASS_VOID }', file=ROWS)
L('table-arm-discarded-class', DISCARD, '{ BUSTER_TYPED_DISCARD, BUSTER_NODE_ROWS_CLASS_OWN }', '{ BUSTER_TYPED_DISCARD, BUSTER_TYPED_CLASS_VOID }', file=ROWS)
for index, name in ((0, 'own'), (1, 'own-converted'), (4, 'target'), (5, 'converted'), (8, 'void'), (10, 'discarded')):
    anchor = 'tables->arms[%d] = ' % index
    line = [l for l in texts[ROWS].split('\n') if anchor in l][0]
    N('arms-%s-none' % name, line, line.split(' = ')[0] + ' = 0;', ROWS)
L('arms-own-the-target', 'tables->arms[0] = BUSTER_NODE_ROWS_ARM;', 'BUSTER_NODE_ROWS_ARM;', 'BUSTER_NODE_ROWS_ARM + 2;', file=ROWS)
L('arms-target-the-own', 'tables->arms[4] = BUSTER_NODE_ROWS_ARM + 2;', 'BUSTER_NODE_ROWS_ARM + 2;', 'BUSTER_NODE_ROWS_ARM;', file=ROWS)
L('arms-void-a-value', 'tables->arms[8] = BUSTER_NODE_ROWS_ARM + 1;', 'BUSTER_NODE_ROWS_ARM + 1;', 'BUSTER_NODE_ROWS_ARM;', file=ROWS)
L('arms-discarded-no-discard', 'tables->arms[10] = BUSTER_NODE_ROWS_ARM + 4;', 'BUSTER_NODE_ROWS_ARM + 4;', 'BUSTER_NODE_ROWS_ARM + 1;', file=ROWS)
N('template-value-later', "    tables->templates[NODE_MACHINE_TEMPLATE_DECIDED] = BUSTER_NODE_ROWS_LATER;", "    tables->templates[NODE_MACHINE_TEMPLATE_DECIDED] = BUSTER_NODE_ROWS_LATER;\n    tables->templates[NODE_MACHINE_TEMPLATE_BRANCH] = BUSTER_NODE_ROWS_LATER;", ROWS)
LOGIC = 'const bool logic = shape == BUSTER_NODE_ROWS_LOGIC || shape == BUSTER_NODE_ROWS_LOGIC + 1;'
L('values-logic-no-and', LOGIC, 'shape == BUSTER_NODE_ROWS_LOGIC || ', '', file=ROWS)
L('values-logic-no-or', LOGIC, ' || shape == BUSTER_NODE_ROWS_LOGIC + 1', '', file=ROWS)
L('values-rest-no-logic', 'lists |= variant == 2 || variant == 4 || logic ? BUSTER_NODE_ROWS_VALUE_REST : 0;', ' || logic', '', file=ROWS)
LABELED = 'lists |= shape == BUSTER_NODE_ROWS_BRANCHED + 1 || shape == BUSTER_NODE_ROWS_HELD || logic ? BUSTER_NODE_ROWS_VALUE_LABELED : 0;'
L('values-labeled-no-branched', LABELED, 'shape == BUSTER_NODE_ROWS_BRANCHED + 1 || ', '', file=ROWS)
L('values-labeled-no-held', LABELED, 'shape == BUSTER_NODE_ROWS_HELD || ', '', file=ROWS)
L('values-labeled-no-logic', LABELED, ' || logic ?', ' ?', file=ROWS)
L('values-labeled-with-the-numbered', LABELED, 'BUSTER_NODE_ROWS_VALUE_LABELED', 'BUSTER_NODE_ROWS_VALUE_NUMBERED', file=ROWS)
L('values-labeled-every-branched', LABELED, 'shape == BUSTER_NODE_ROWS_BRANCHED + 1', 'shape == BUSTER_NODE_ROWS_BRANCHED || shape == BUSTER_NODE_ROWS_BRANCHED + 1', file=ROWS)

# ---- X: the turn of an operator's value.
N('held-either-none', "    const uint32_t either = op == CHECK_OP_LOGICAL_OR ? 1u : 0u;\n    bool listed = false;", "    const uint32_t either = 0u;\n    bool listed = false;", ROWS)
N('held-either-an-and', "    const uint32_t either = op == CHECK_OP_LOGICAL_OR ? 1u : 0u;\n    bool listed = false;", "    const uint32_t either = op == CHECK_OP_LOGICAL_AND ? 1u : 0u;\n    bool listed = false;", ROWS)
TESTED = 'node_rows_window_tested(state, c - front->window_left[c], either | BUSTER_NODE_ROWS_SENSE_OWNED, controlled);'
L('held-condition-unowned', TESTED, ' | BUSTER_NODE_ROWS_SENSE_OWNED', '', file=ROWS)
L('held-condition-the-other-sense', TESTED, 'either | ', '(either ^ 1u) | ', file=ROWS)
L('held-condition-the-second', TESTED, 'c - front->window_left[c]', 'c - front->window_right[c]', file=ROWS)
N('held-no-condition', "    " + TESTED + "\n    if (op == CHECK_OP_CONDITIONAL)", "    if (op == CHECK_OP_CONDITIONAL)", ROWS)
L('held-arm-the-condition', 'const uint32_t arm = c - front->window_right[c];', 'window_right', 'window_left', file=ROWS)
L('held-arm-the-last', 'const uint32_t arm = c - front->window_right[c];', 'c - front->window_right[c]', 'c - 1', file=ROWS)
WORDED = 'const uint32_t worded = (uint32_t)(state->window_x_reads[2 * (uint64_t)(arm / 64) + 1] >> (arm & 63)) & 1u;'
L('held-worded-none', WORDED, '(uint32_t)(state->window_x_reads[2 * (uint64_t)(arm / 64) + 1] >> (arm & 63)) & 1u', '0u', file=ROWS)
L('held-worded-every', WORDED, '(uint32_t)(state->window_x_reads[2 * (uint64_t)(arm / 64) + 1] >> (arm & 63)) & 1u', '1u', file=ROWS)
L('held-worded-the-converts', WORDED, '(arm / 64) + 1]', '(arm / 64)]', file=ROWS)
L('held-worded-its-own-bit', WORDED, '>> (arm & 63)', '>> (c & 63)', file=ROWS)
VOIDED = 'const uint32_t voided = state->window_c_classes[c] == BUSTER_TYPED_CLASS_VOID ? 1u : 0u;'
L('held-voided-none', VOIDED, 'state->window_c_classes[c] == BUSTER_TYPED_CLASS_VOID ? 1u : 0u', '0u', file=ROWS)
L('held-voided-the-arm', VOIDED, 'window_c_classes[c]', 'window_c_classes[arm]', file=ROWS)
CONVERSION = 'const uint32_t conversion = before == 0 ? 0u : before == BUSTER_NODE_ROWS_CONVERT ? 1u : before == BUSTER_TYPED_DISCARD ? 2u : 3u;'
L('held-conversion-none', CONVERSION, 'before == 0 ? 0u : before == BUSTER_NODE_ROWS_CONVERT ? 1u : before == BUSTER_TYPED_DISCARD ? 2u : 3u', '(before & 0u)', file=ROWS)
L('held-conversion-other-a-convert', CONVERSION, '? 2u : 3u', '? 2u : 1u', file=ROWS)
L('held-conversion-other-none', CONVERSION, '? 2u : 3u', '? 2u : 0u', file=ROWS)
L('held-conversion-discard-a-convert', CONVERSION, 'before == BUSTER_TYPED_DISCARD ? 2u', 'before == BUSTER_TYPED_DISCARD ? 1u', file=ROWS)
L('held-arms-unvoided', 'const uint32_t shape = tables->arms[8u * voided + 4u * worded + conversion];', '8u * voided + ', '0u * voided + ', file=ROWS)
L('held-arms-unworded', 'const uint32_t shape = tables->arms[8u * voided + 4u * worded + conversion];', '4u * worded + ', '0u * worded + ', file=ROWS)
L('held-arm-never-listed', 'listed = shape == 0;', 'shape == 0', 'false', file=ROWS)
L('held-own-none', 'state->window_x_owns[c] = BUSTER_NODE_ROWS_HELD;', 'BUSTER_NODE_ROWS_HELD', '0', file=ROWS)
L('held-own-a-branched', 'state->window_x_owns[c] = BUSTER_NODE_ROWS_HELD;', 'BUSTER_NODE_ROWS_HELD', 'BUSTER_NODE_ROWS_BRANCHED + 1', file=ROWS)
L('held-arm-shape-kept', 'state->window_x_conversions[arm] = (uint8_t)shape;', '(uint8_t)shape', '(uint8_t)before', file=ROWS)
L('held-arm-length-kept', 'state->window_x_lengths[arm] = (uint8_t)(state->window_x_lengths[arm] + 1u);', ' + 1u', ' + 0u', file=ROWS)
L('held-arm-no-bit', 'state->window_x_senses[arm] = BUSTER_NODE_ROWS_SENSE_JUMPED;', '= BUSTER_NODE_ROWS_SENSE_JUMPED', '= 0', file=ROWS)
L('held-arm-the-conditional-listed', 'state->x_lists[BUSTER_NODE_ROWS_LIST_CONTROLLED][*controlled] = (uint16_t)arm;', '(uint16_t)arm', '(uint16_t)c', file=ROWS)
N('held-arm-not-listed', "            state->x_lists[BUSTER_NODE_ROWS_LIST_CONTROLLED][*controlled] = (uint16_t)arm;\n            *controlled += 1;", "            state->x_lists[BUSTER_NODE_ROWS_LIST_CONTROLLED][*controlled] = (uint16_t)arm;\n            *controlled += 0;", ROWS)
CLASS = 'const uint8_t tested = node_machine_class(state->facts.machine, state->facts.records[c].converted[1]);'
L('held-test-the-first-operand', CLASS, 'converted[1]', 'converted[0]', file=ROWS)
L('held-test-its-own-class', CLASS, 'node_machine_class(state->facts.machine, state->facts.records[c].converted[1])', 'state->window_c_classes[c]', file=ROWS)
L('held-narrow-taken', 'listed = tested <= BUSTER_TYPED_CLASS_U16;', 'tested <= BUSTER_TYPED_CLASS_U16', 'false', file=ROWS)
L('held-narrow-the-bytes-alone', 'listed = tested <= BUSTER_TYPED_CLASS_U16;', 'BUSTER_TYPED_CLASS_U16', 'BUSTER_TYPED_CLASS_U8', file=ROWS)
L('held-narrow-an-int-too', 'listed = tested <= BUSTER_TYPED_CLASS_U16;', 'BUSTER_TYPED_CLASS_U16', 'BUSTER_TYPED_CLASS_I32', file=ROWS)
L('held-test-class-unwritten', 'state->window_x_operands[c] = tested;', 'state->window_x_operands[c] = tested;', '(void)tested;', file=ROWS)
L('held-logic-an-and', 'state->window_x_owns[c] = (uint8_t)(BUSTER_NODE_ROWS_LOGIC + either);', ' + either', '', file=ROWS)
L('held-logic-length', 'state->window_x_lengths[c] = (uint8_t)(state->window_x_lengths[c] + 4u);', ' + 4u', ' + 3u', file=ROWS)
N('held-never-listed', "    if (listed)\n    {\n        state->window_c_masks[BUSTER_NODE_CONTEXTS_MASKS * (uint64_t)(c / 64) + BUSTER_NODE_ROWS_MASK_LISTED] |= UINT64_C(1) << (c & 63);",
  "    if (listed && false)\n    {\n        state->window_c_masks[BUSTER_NODE_CONTEXTS_MASKS * (uint64_t)(c / 64) + BUSTER_NODE_ROWS_MASK_LISTED] |= UINT64_C(1) << (c & 63);", ROWS)
N('turns-no-value', "                                        _mm512_cmpneq_epi8_mask(_mm512_loadu_si512(front->ops + x), _mm512_set1_epi8(CHECK_OP_CONDITION))) |\n                                       _mm512_mask_cmpeq_epi8_mask(alive, templates, _mm512_set1_epi8((char)NODE_MACHINE_TEMPLATE_BRANCH));",
  "                                        _mm512_cmpneq_epi8_mask(_mm512_loadu_si512(front->ops + x), _mm512_set1_epi8(CHECK_OP_CONDITION))) |\n                                       _mm512_mask_cmpeq_epi8_mask(0, templates, _mm512_set1_epi8((char)NODE_MACHINE_TEMPLATE_BRANCH));", ROWS)
N('turns-a-dead-value-too', "                                       _mm512_mask_cmpeq_epi8_mask(alive, templates, _mm512_set1_epi8((char)NODE_MACHINE_TEMPLATE_BRANCH));",
  "                                       _mm512_cmpeq_epi8_mask(templates, _mm512_set1_epi8((char)NODE_MACHINE_TEMPLATE_BRANCH));", ROWS)
L('turn-every-one-branched', 'if (__builtin_expect(state->window_c_templates[c] == NODE_MACHINE_TEMPLATE_BRANCH, 0))', 'state->window_c_templates[c] == NODE_MACHINE_TEMPLATE_BRANCH', 'false', file=ROWS)

# ---- X: the write, the values.
L('write-second-slot-unresolved', 'classes[BUSTER_NODE_ROWS_SLOTS + 1] = _mm512_mask_mov_epi8(conversion_seconds, _mm512_cmpeq_epi8_mask(conversion_seconds, target_source), target_classes);',
  '_mm512_cmpeq_epi8_mask(conversion_seconds, target_source)', '0', file=ROWS)
L('write-second-slot-own', 'classes[BUSTER_NODE_ROWS_SLOTS + 1] = _mm512_mask_mov_epi8(conversion_seconds, _mm512_cmpeq_epi8_mask(conversion_seconds, target_source), target_classes);',
  'target_classes);', 'own_classes);', file=ROWS)
L('marks-labels-none', 'const uint64_t labels = _mm512_test_epi8_mask(lists, _mm512_set1_epi8((char)BUSTER_NODE_ROWS_VALUE_LABELED));', '_mm512_test_epi8_mask(lists, _mm512_set1_epi8((char)BUSTER_NODE_ROWS_VALUE_LABELED))', '0', file=ROWS)
FIRST = 'const uint64_t first_labels = labels & ~(labels - starts);'
L('marks-labels-every-one-first', FIRST, 'labels & ~(labels - starts)', 'labels', file=ROWS)
L('marks-labels-none-first', FIRST, 'labels & ~(labels - starts)', '0', file=ROWS)
L('marks-labels-the-other-starts', FIRST, '(labels - starts)', '(labels - 1)', file=ROWS)
L('marks-labels-lowest-the-marks', 'const uint64_t lowest_label = first_labels & (0 - first_labels);', 'first_labels & (0 - first_labels)', 'first_marks & (0 - first_marks)', file=ROWS)
GOING = 'const uint64_t labels_going_on = lowest_label & (0 - open_labels) & (0 - (uint64_t)(lowest_label - 1 <= lowest_end - 1 ? 1 : 0));'
L('marks-labels-going-on-none', GOING, 'lowest_label & (0 - open_labels) & (0 - (uint64_t)(lowest_label - 1 <= lowest_end - 1 ? 1 : 0))', '(lowest_label & 0)', file=ROWS)
L('marks-labels-going-on-the-marks-open', GOING, '(0 - open_labels)', '(0 - open)', file=ROWS)
L('marks-labels-going-on-past-the-end', GOING, ' & (0 - (uint64_t)(lowest_label - 1 <= lowest_end - 1 ? 1 : 0))', '', file=ROWS)
LATER = 'uint64_t later = (marks & ~first_marks) | going_on | (labels & ~first_labels) | labels_going_on;'
L('later-no-labels', LATER, ' | (labels & ~first_labels)', '', file=ROWS)
L('later-no-labels-going-on', LATER, ' | labels_going_on', ' | (labels_going_on & 0)', file=ROWS)
L('later-every-label', LATER, '(labels & ~first_labels)', 'labels', file=ROWS)
L('labels-after-none', 'const uint64_t labels_after = ends == 0 ? labels : labels >> past >> 1;', 'ends == 0 ? labels : labels >> past >> 1', '0', file=ROWS)
L('labels-after-the-marks', 'const uint64_t labels_after = ends == 0 ? labels : labels >> past >> 1;', 'ends == 0 ? labels : labels >> past >> 1', 'after', file=ROWS)
OPEN_LABELS = 'open_labels = (labels_after != 0 ? 1u : 0u) | (ends == 0 ? open_labels : 0u);'
L('open-labels-never', OPEN_LABELS, '(labels_after != 0 ? 1u : 0u) | (ends == 0 ? open_labels : 0u)', '(labels_after & 0)', file=ROWS)
L('open-labels-not-kept', OPEN_LABELS, ' | (ends == 0 ? open_labels : 0u)', '', file=ROWS)
L('open-labels-always-kept', OPEN_LABELS, '(ends == 0 ? open_labels : 0u)', 'open_labels', file=ROWS)
L('marks-word-no-labels', 'state->window_x_marks[block] = marks | labels;', ' | labels', '', file=ROWS)
JUMP = 'const uint64_t jump = 0 - (uint64_t)((jumped[x] / BUSTER_NODE_ROWS_SENSE_JUMPED) & 1u);'
L('jump-none', JUMP, '0 - (uint64_t)((jumped[x] / BUSTER_NODE_ROWS_SENSE_JUMPED) & 1u)', '0 & (uint64_t)jumped[x]', file=ROWS)
L('jump-every-one', JUMP, '0 - (uint64_t)((jumped[x] / BUSTER_NODE_ROWS_SENSE_JUMPED) & 1u)', '~UINT64_C(0) | (uint64_t)jumped[x]', file=ROWS)
L('jump-the-owned-bit', JUMP, 'jumped[x] / BUSTER_NODE_ROWS_SENSE_JUMPED', 'jumped[x] / BUSTER_NODE_ROWS_SENSE_OWNED', file=ROWS)
L('jump-value-zero', 'values[cursors[x / 8] + offsets[x] + lengths[x] - 1u] = BUSTER_NODE_MACHINE_CONTROL_LABEL ^ (jump & (BUSTER_NODE_MACHINE_CONTROL_LABEL ^ 1u));',
  '(BUSTER_NODE_MACHINE_CONTROL_LABEL ^ 1u)', 'BUSTER_NODE_MACHINE_CONTROL_LABEL', file=ROWS)
L('rest-logic-as-an-address', 'else if (own >= BUSTER_NODE_ROWS_LOGIC)', 'own >= BUSTER_NODE_ROWS_LOGIC', 'false', file=ROWS)
L('rest-logic-jump-zero', '        values[2] = 1;', 'values[2] = 1;', 'values[2] = 0;', file=ROWS)
L('rest-logic-jump-place', '        values[2] = 1;', 'values[2]', 'values[1]', file=ROWS)
L('rest-logic-value-zero', 'values[3] = own - BUSTER_NODE_ROWS_LOGIC;', 'own - BUSTER_NODE_ROWS_LOGIC', '0', file=ROWS)
L('rest-logic-value-one', 'values[3] = own - BUSTER_NODE_ROWS_LOGIC;', 'own - BUSTER_NODE_ROWS_LOGIC', '1', file=ROWS)
L('rest-logic-value-place', 'values[3] = own - BUSTER_NODE_ROWS_LOGIC;', 'values[3]', 'values[2]', file=ROWS)

# ---- X: the numbering.
LABELS = 'const uint32_t labels = own >= BUSTER_NODE_ROWS_HELD ? 2u : own == BUSTER_NODE_ROWS_BRANCHED + 1 ? 1u : 0u;'
L('label-a-value-one', LABELS, '? 2u :', '? 1u :', file=ROWS)
L('label-a-value-none', LABELS, 'own >= BUSTER_NODE_ROWS_HELD ? 2u : ', '', file=ROWS)
L('label-a-branched-none', LABELS, 'own == BUSTER_NODE_ROWS_BRANCHED + 1 ? 1u : 0u', '0u', file=ROWS)
L('label-a-branched-two', LABELS, 'own == BUSTER_NODE_ROWS_BRANCHED + 1 ? 1u : 0u', 'own == BUSTER_NODE_ROWS_BRANCHED + 1 ? 2u : 0u', file=ROWS)
L('label-every-mark-one', LABELS, ': 0u;', ': 1u;', file=ROWS)
COUNTED = 'const bool counted = other < lowest || (other > owner && other + 1 - front->sizes[other] <= lowest);'
L('label-none-before', COUNTED, 'other < lowest || ', '', file=ROWS)
L('label-none-holding', COUNTED, ' || (other > owner && other + 1 - front->sizes[other] <= lowest)', '', file=ROWS)
L('label-every-later', COUNTED, ' && other + 1 - front->sizes[other] <= lowest', '', file=ROWS)
L('label-itself-too', COUNTED, 'other > owner', 'other >= owner', file=ROWS)
L('label-before-the-owner', COUNTED, 'other < lowest', 'other < owner', file=ROWS)
L('label-none-counted', 'label += counted ? labels : 0u;', 'counted ? labels : 0u', 'counted ? labels & 0u : 0u', file=ROWS)
L('label-every-one-counted', 'label += counted ? labels : 0u;', 'counted ? labels : 0u', 'counted ? labels : labels', file=ROWS)
WALK = "            else if (own >= BUSTER_NODE_ROWS_BRANCHED)\n            {\n                // An operator with labels: one evaluated as branches, or an operator's value."
N('number-walk-the-branched-alone', WALK, WALK.replace('own >= BUSTER_NODE_ROWS_BRANCHED', 'own == BUSTER_NODE_ROWS_BRANCHED + 1'), ROWS)
HELD = 'if (own >= BUSTER_NODE_ROWS_HELD)'
L('number-no-value', HELD, 'own >= BUSTER_NODE_ROWS_HELD', 'false', file=ROWS)
L('number-a-conditional-alone', HELD, 'own >= BUSTER_NODE_ROWS_HELD', 'own == BUSTER_NODE_ROWS_HELD', file=ROWS)
L('number-a-logical-alone', HELD, 'own >= BUSTER_NODE_ROWS_HELD', 'own > BUSTER_NODE_ROWS_HELD', file=ROWS)
PLACE = 'const uint32_t place = own == BUSTER_NODE_ROWS_HELD ? node_rows_window_place(state, arm) + state->window_x_lengths[arm] - 1u : node_rows_window_place(state, x) + 2u;'
L('number-jump-the-arm-first', PLACE, ' + state->window_x_lengths[arm] - 1u', '', file=ROWS)
L('number-jump-own-third', PLACE, 'node_rows_window_place(state, x) + 2u', 'node_rows_window_place(state, x) + 3u', file=ROWS)
L('number-jump-own-second', PLACE, 'node_rows_window_place(state, x) + 2u', 'node_rows_window_place(state, x) + 1u', file=ROWS)
L('number-jump-every-one-an-arm', PLACE, 'own == BUSTER_NODE_ROWS_HELD ?', 'true ?', file=ROWS)
L('number-arm-the-condition', 'const uint32_t arm = x - front->window_right[x];', 'window_right', 'window_left', file=ROWS)
L('number-jump-the-first-label', 'values[place] = node_rows_window_label(state, front, marked, marks, x) + 1u;', ' + 1u', '', file=ROWS)
L('number-jump-the-owner-s', 'values[place] = node_rows_window_label(state, front, marked, marks, x) + 1u;', 'marks, x)', 'marks, owners[x])', file=ROWS)
TESTEDV = 'if (state->window_x_conversions[x] >= BUSTER_NODE_ROWS_TESTED && (state->window_x_senses[x] & BUSTER_NODE_ROWS_SENSE_OWNED) != 0)'
L('number-tested-unowned-too', TESTEDV, ' && (state->window_x_senses[x] & BUSTER_NODE_ROWS_SENSE_OWNED) != 0', '', file=ROWS)
L('number-tested-its-own-label', 'values[node_rows_window_place(state, x) + state->window_x_lengths[x] - 1u] = node_rows_window_label(state, front, marked, marks, owners[x]);', 'owners[x])', 'x)', file=ROWS)
OWNERS = 'owners[x - front->window_left[x]] = own == BUSTER_NODE_ROWS_BRANCHED ? owners[x] : (uint16_t)x;'
L('number-owner-every-one-its-own', OWNERS, 'own == BUSTER_NODE_ROWS_BRANCHED ? owners[x] : (uint16_t)x', '(uint16_t)x', file=ROWS)
L('number-owner-a-value-passes-on', OWNERS, 'own == BUSTER_NODE_ROWS_BRANCHED ?', 'own != BUSTER_NODE_ROWS_BRANCHED + 1 ?', file=ROWS)

out = [f for f in out if f is not None]
open(sys.argv[2], 'w').write('''#!/usr/bin/env python3
# faults-logical.py TREE [N]: an operator's value's and a comma's faults (make-faults-logical.py). With no N, check every
# fault applies once and print how many; with N, apply fault N in TREE in place and print its name.
import sys
faults = %r
def apply(t, old, new, nth, name):
    assert t.count(old) == 1, (name, t.count(old))
    return t.replace(old, new)
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
print(len(out), 'faults')
