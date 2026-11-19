#!/usr/bin/env python3
# faults.py WORKER OF [check]: the call piece's faults, one at a time in the copy /home/user/mut16/treeWORKER: a text of
# the piece's code replaced by a faulty one, the Debug compiler built, the node machine's tests run (test-checker part 5
# of 8), and for a fault the tests don't fail the shadow with C on the window on Lua, sqlite3.c and musl: whether any
# program they hold tells it from the code (a status, a difference or a count that is not the base's). Worker WORKER of
# OF takes every OF-th fault. Results in /home/user/mut16/results-WORKER.txt. With `check`, only that every text is
# there once. ROUND (the environment's) names the list: 1 by default.
import os, re, subprocess, sys, time
worker, of = int(sys.argv[1]), int(sys.argv[2])
ROUND = os.environ.get('ROUND', '1')
TREE = '/home/user/mut16/tree%d' % worker
SRC = TREE + '/src/buster/compiler/'
FA = 'c_check_node_machine_facts.c'
W = 'c_check_node_machine_window.c'
C = 'c_check_node_census.c'
texts = {}
def text(f):
    if f not in texts:
        texts[f] = open(SRC + f).read()
    return texts[f]
def body(f, header):
    t = text(f)
    assert t.count(header) == 1, (header, t.count(header))
    i = t.index(header)
    j = t.index('\n}\n', i) + 3
    return t[i:j]
FAULTS = []
def F(name, f, header, a, b):
    whole = body(f, header)
    n = whole.count(a)
    FAULTS.append((name, f, whole, whole.replace(a, b), n))
def P(name, f, a, b):
    FAULTS.append((name, f, a, b, text(f).count(a)))

ARGUED = 'static uint32_t node_facts_argued('
F('argued-no-type-word', FA, ARGUED, 'type != 0 ? node_machine_word(machine, type) : 0', 'node_machine_word(machine, type)')
F('argued-real-no-float', FA, ARGUED, 'code == type_index(BUSTER_TYPE_FLOAT) || ', '')
F('argued-real-no-double', FA, ARGUED, ' || code == type_index(BUSTER_TYPE_DOUBLE)', '')
F('argued-real-no-long-double', FA, ARGUED, ' || code == type_index(BUSTER_TYPE_LONG_DOUBLE)', '')
F('argued-width-none', FA, ARGUED, 'code < BUSTER_NODE_MACHINE_KINDS ? node_machine_integer_widths[code] : 0', '0')
F('argued-vector-never', FA, ARGUED, 'const bool vector = valid && check_vector_type(types, stripped);', 'const bool vector = valid && check_vector_type(types, stripped) && code == UINT32_MAX;')
F('argued-arithmetic-never', FA, ARGUED, 'const bool arithmetic = valid && !vector && check_action_is_arithmetic(types, stripped);',
  'const bool arithmetic = valid && !vector && check_action_is_arithmetic(types, stripped) && code == UINT32_MAX;')
F('argued-arithmetic-vectors-too', FA, ARGUED, 'const bool arithmetic = valid && !vector && check_action_is_arithmetic(types, stripped);',
  'const bool arithmetic = valid && check_action_is_arithmetic(types, stripped);')
F('argued-scalar-never', FA, ARGUED, 'const bool scalar = valid && !vector && check_action_is_scalar(types, stripped);',
  'const bool scalar = valid && !vector && check_action_is_scalar(types, stripped) && code == UINT32_MAX;')
F('argued-scalar-vectors-too', FA, ARGUED, 'const bool scalar = valid && !vector && check_action_is_scalar(types, stripped);', 'const bool scalar = valid && check_action_is_scalar(types, stripped);')
F('argued-scalar-as-arithmetic', FA, ARGUED, 'check_action_is_scalar(types, stripped)', 'check_action_is_arithmetic(types, stripped)')
F('argued-vectors-no-plain', FA, ARGUED, 'kind == BUSTER_TYPE_KIND_VECTOR || ', '')
F('argued-vectors-no-ext', FA, ARGUED, ' || kind == BUSTER_TYPE_KIND_EXT_VECTOR', '')
F('argued-complex-never', FA, ARGUED, 'const bool complex = kind == BUSTER_TYPE_KIND_COMPLEX;', 'const bool complex = kind == BUSTER_TYPE_KIND_COMPLEX && code == UINT32_MAX;')
F('argued-valid-bit-none', FA, ARGUED, '(valid ? BUSTER_NODE_FACTS_ARGUED_VALID : 0)', '0u')
F('argued-bool-never', FA, ARGUED, '(valid && stripped == BUSTER_TYPE_BOOL ? BUSTER_NODE_FACTS_ARGUED_BOOL : 0)', '0u')
F('argued-bool-all', FA, ARGUED, '(valid && stripped == BUSTER_TYPE_BOOL ? BUSTER_NODE_FACTS_ARGUED_BOOL : 0)', '(valid ? BUSTER_NODE_FACTS_ARGUED_BOOL : 0)')
F('argued-real-bit-none', FA, ARGUED, '(real ? BUSTER_NODE_FACTS_ARGUED_REAL : 0)', '0u')
F('argued-integer-bit-none', FA, ARGUED, '(kind == BUSTER_TYPE_KIND_INTEGER ? BUSTER_NODE_FACTS_ARGUED_INTEGER : 0)', '0u')
F('argued-vector-bit-none', FA, ARGUED, '(vectors ? BUSTER_NODE_FACTS_ARGUED_VECTOR : 0)', '0u')
F('argued-complex-bit-none', FA, ARGUED, '(complex ? BUSTER_NODE_FACTS_ARGUED_COMPLEX : 0)', '0u')
F('argued-pointer-bit-none', FA, ARGUED, '(kind == BUSTER_TYPE_KIND_POINTER ? BUSTER_NODE_FACTS_ARGUED_POINTER : 0)', '0u')
F('argued-aggregate-no-struct', FA, ARGUED, 'kind == BUSTER_TYPE_KIND_STRUCT || ', '')
F('argued-aggregate-no-union', FA, ARGUED, ' || kind == BUSTER_TYPE_KIND_UNION', '')
F('argued-folds-no-integer', FA, ARGUED, '(kind == BUSTER_TYPE_KIND_INTEGER || kind == BUSTER_TYPE_KIND_ENUM || real ?', '(kind == BUSTER_TYPE_KIND_ENUM || real ?')
F('argued-folds-no-enum', FA, ARGUED, '(kind == BUSTER_TYPE_KIND_INTEGER || kind == BUSTER_TYPE_KIND_ENUM || real ?', '(kind == BUSTER_TYPE_KIND_INTEGER || real ?')
F('argued-folds-no-real', FA, ARGUED, '(kind == BUSTER_TYPE_KIND_INTEGER || kind == BUSTER_TYPE_KIND_ENUM || real ?', '(kind == BUSTER_TYPE_KIND_INTEGER || kind == BUSTER_TYPE_KIND_ENUM ?')
F('argued-made-complex-too', FA, ARGUED, '(valid && !complex && !vectors ?', '(valid && !vectors ?')
F('argued-made-vectors-too', FA, ARGUED, '(valid && !complex && !vectors ?', '(valid && !complex ?')
F('argued-made-invalid-too', FA, ARGUED, '(valid && !complex && !vectors ?', '(!complex && !vectors ?')
F('argued-plain-all', FA, ARGUED, '(check_lower_plain_scalar(word, false) ? BUSTER_NODE_FACTS_ARGUED_PLAIN : 0)', 'BUSTER_NODE_FACTS_ARGUED_PLAIN')
F('argued-plain-none', FA, ARGUED, '(check_lower_plain_scalar(word, false) ? BUSTER_NODE_FACTS_ARGUED_PLAIN : 0)', '0u')

VALUE = 'static uint64_t node_facts_argued_value('
F('value-enum-promoted', FA, VALUE, ' && kind != BUSTER_TYPE_KIND_ENUM', '')
F('value-no-default-promotion', FA, VALUE, 'const TypeId to = type_default_argument_promote(types, promoted);', 'const TypeId to = promoted;')
F('value-pointer-any-same', FA, VALUE, 'to == promoted && check_action_kind(types, to) == BUSTER_TYPE_KIND_POINTER', 'to == promoted')
F('value-pointer-never', FA, VALUE, 'to == promoted && check_action_kind(types, to) == BUSTER_TYPE_KIND_POINTER', 'to == promoted && check_action_kind(types, to) == BUSTER_TYPE_KIND_POINTER && index == UINT32_MAX')
F('value-pointer-other-type', FA, VALUE, 'to == promoted && check_action_kind(types, to) == BUSTER_TYPE_KIND_POINTER', 'check_action_kind(types, to) == BUSTER_TYPE_KIND_POINTER')
F('value-taken-all', FA, VALUE, 'const bool taken = pointer || node_machine_arithmetic_assignable(machine, to, promoted);', 'const bool taken = pointer || node_machine_arithmetic_assignable(machine, to, promoted) || index != UINT32_MAX;')
F('value-taken-pointers-only', FA, VALUE, 'const bool taken = pointer || node_machine_arithmetic_assignable(machine, to, promoted);', 'const bool taken = pointer;')
F('value-destination-untaken', FA, VALUE, 'destination = taken ? to : 0;', 'destination = to;')
F('value-promoted-pointer-none', FA, VALUE, '(pointer ? BUSTER_NODE_FACTS_ARGUED_PROMOTED_POINTER : 0)', '0u')
F('value-promoted-made-none', FA, VALUE, '((made & BUSTER_NODE_FACTS_ARGUED_MADE) != 0 ? BUSTER_NODE_FACTS_ARGUED_PROMOTED_MADE : 0)', '0u')
F('value-promoted-made-all', FA, VALUE, '((made & BUSTER_NODE_FACTS_ARGUED_MADE) != 0 ? BUSTER_NODE_FACTS_ARGUED_PROMOTED_MADE : 0)', 'BUSTER_NODE_FACTS_ARGUED_PROMOTED_MADE')
F('value-promoted-plain-none', FA, VALUE, '((made & BUSTER_NODE_FACTS_ARGUED_PLAIN) != 0 ? BUSTER_NODE_FACTS_ARGUED_PROMOTED_PLAIN : 0)', '0u')
F('value-promoted-plain-all', FA, VALUE, '((made & BUSTER_NODE_FACTS_ARGUED_PLAIN) != 0 ? BUSTER_NODE_FACTS_ARGUED_PROMOTED_PLAIN : 0)', 'BUSTER_NODE_FACTS_ARGUED_PROMOTED_PLAIN')
F('value-no-destination', FA, VALUE, 'return (uint64_t)destination << 32 | argued;', 'return argued;')
F('value-invalid-promoted', FA, VALUE, '(argued & BUSTER_NODE_FACTS_ARGUED_VALID) != 0 && ', '')

ROW = 'static void node_facts_row('
F('row-argued-none', FA, ROW, '*argued = node_facts_argued_value(machine, index);', '*argued = 0;')
F('row-target-atomic-too', FA, ROW, ' && check_action_kind(types, parameter_types[p]) != BUSTER_TYPE_KIND_ATOMIC', '')
F('row-target-facts-none', FA, ROW, '(uint64_t)node_facts_argued(machine, converted) << 32 | converted;', 'converted;')
F('row-target-none', FA, ROW, '(uint64_t)node_facts_argued(machine, converted) << 32 | converted;', '(uint64_t)node_facts_argued(machine, converted) << 32;')
F('row-plain-parameters-any', FA, ROW, 'scalars = scalars && check_lower_plain_scalar(word, false);', 'scalars = scalars && (check_lower_plain_scalar(word, false) || p != UINT32_MAX);')
F('row-plain-result-any', FA, ROW, 'bool scalars = check_lower_plain_scalar(returned_word, true);', 'bool scalars = true;')
F('row-plain-result-no-void', FA, ROW, 'bool scalars = check_lower_plain_scalar(returned_word, true);', 'bool scalars = check_lower_plain_scalar(returned_word, false);')
F('row-plain-all', FA, ROW, '(scalars ? BUSTER_NODE_FACTS_PLAIN : 0)', 'BUSTER_NODE_FACTS_PLAIN')
F('row-plain-none', FA, ROW, '(scalars ? BUSTER_NODE_FACTS_PLAIN : 0)', '0u')
F('row-parameters-place', FA, ROW, 'row->parameters = first;', 'row->parameters = first + 1;')

KEY = 'static inline __attribute__((always_inline)) uint64_t node_facts_argument_standing('
F('key-zero-field-too', FA, KEY, 'const uint32_t valued = BUSTER_NODE_MACHINE_FIELD | 0x1cu;', 'const uint32_t valued = 0x1cu;')
F('key-zero-any-payload', FA, KEY, ' && record->payload == 0', '')
F('key-zero-never', FA, KEY, ' && record->payload == 0 ? 1u : 0u', ' && record->payload == UINT64_MAX ? 1u : 0u')
F('key-no-flags', FA, KEY, '(uint64_t)(record->flags & BUSTER_NODE_FACTS_ARGUMENT_FLAGS) << 16 | ', '')
F('key-no-standing', FA, KEY, 'standing << 1 | zero;', 'zero;')
F('key-no-zero', FA, KEY, 'standing << 1 | zero;', 'standing << 1;')
FLAGS = '#define BUSTER_NODE_FACTS_ARGUMENT_FLAGS \\\n    (BUSTER_CHECK_REGISTER_NAME | BUSTER_CHECK_VOLATILE_PART | BUSTER_CHECK_ICE | BUSTER_CHECK_GNU_ICE_FORM | BUSTER_CHECK_NULL_POINTER | \\\n     (BUSTER_CHECK_INHERITED & ~(BUSTER_CHECK_SIDE_EFFECT | BUSTER_CHECK_GNU_CONSTANT | BUSTER_CHECK_FP_ENVIRONMENT)))'
for flag in ('BUSTER_CHECK_REGISTER_NAME', 'BUSTER_CHECK_VOLATILE_PART', 'BUSTER_CHECK_ICE', 'BUSTER_CHECK_GNU_ICE_FORM', 'BUSTER_CHECK_NULL_POINTER'):
    P('key-flags-no-' + flag[13:].lower().replace('_', '-'), FA, FLAGS, FLAGS.replace('(' + flag + ' | ', '(').replace(' | ' + flag + ' |', ' |'))
P('key-flags-no-inherited', FA, FLAGS, FLAGS.replace(' | \\\n     (BUSTER_CHECK_INHERITED & ~(BUSTER_CHECK_SIDE_EFFECT | BUSTER_CHECK_GNU_CONSTANT | BUSTER_CHECK_FP_ENVIRONMENT)))', ')'))

FILL = 'static __attribute__((noinline)) const NodeFactsArgumentSlot* node_facts_argument_fill('
F('fill-zero-none', FA, FILL, 'const uint32_t zero = (uint32_t)standing & 1u;', 'const uint32_t zero = (uint32_t)standing & 0u;')
F('fill-parameter-as-other', FA, FILL, 'node_facts_argument_made(facts, records, view, g, target, true, zero, &conversion)', 'node_facts_argument_made(facts, records, view, g, target, false, zero, &conversion)')
F('fill-other-as-parameter', FA, FILL, 'node_facts_argument_made(facts, records, view, g, 0, false, zero, &conversion)', 'node_facts_argument_made(facts, records, view, g, 0, true, zero, &conversion)')
F('fill-key-types-other', FA, FILL, '.types = types,', '.types = types + 1,')
F('fill-key-standing-other', FA, FILL, '.standing = standing,', '.standing = standing + 2,')
F('fill-no-conversion', FA, FILL, '.conversion = conversion,', '.conversion = 0,')
F('fill-no-outcome', FA, FILL, '.outcome = outcome,', '.outcome = 0,')
F('fill-one-slot-off', FA, FILL, 'if (__builtin_expect(facts->argument_one, 0))', 'if (__builtin_expect(facts->argument_one && g == UINT32_MAX, 0))')
F('fill-answers-uncounted', FA, FILL, 'facts->argument_answers += 1;', 'facts->argument_answers += 0;')

ARGS = 'static inline __attribute__((always_inline)) uint32_t node_facts_call_arguments('
FIRST = '''        const uint64_t key_types = (uint64_t)records[g].type << 32 | (TypeId)target;
        const uint64_t key_standing = node_facts_argument_standing(records + g);
        const NodeFactsArgumentSlot* slot = view->argument_slots + node_facts_argument_slot(key_types, key_standing);
        if (__builtin_expect(slot->types != key_types || slot->standing != key_standing, 0))
        {
            slot = node_facts_argument_fill(facts, records, view, g, target, true, key_types, key_standing);
        }
        outcome &= slot->outcome;
        if (!lean)
        {
            node_facts_store(records + g, 56, slot->conversion);
        }'''
SECOND = '''        const uint64_t key_types = (uint64_t)records[g].type << 32 | BUSTER_NODE_FACTS_NO_PARAMETER;
        const uint64_t key_standing = node_facts_argument_standing(records + g);
        const NodeFactsArgumentSlot* slot = view->argument_slots + node_facts_argument_slot(key_types, key_standing);
        if (__builtin_expect(slot->types != key_types || slot->standing != key_standing, 0))
        {
            slot = node_facts_argument_fill(facts, records, view, g, 0, false, key_types, key_standing);
        }
        outcome &= slot->outcome;
        if (!lean)
        {
            node_facts_store(records + g, 56, slot->conversion);
        }'''
for tag, loop in (('parameter', FIRST), ('other', SECOND)):
    F('args-%s-types-unchecked' % tag, FA, ARGS, loop, loop.replace('slot->types != key_types || slot->standing != key_standing', 'slot->standing != key_standing'))
    F('args-%s-standing-unchecked' % tag, FA, ARGS, loop, loop.replace('slot->types != key_types || slot->standing != key_standing', 'slot->types != key_types'))
    F('args-%s-always-answered' % tag, FA, ARGS, loop, loop.replace('slot->types != key_types || slot->standing != key_standing, 0', 'g != UINT32_MAX, 0'))
    F('args-%s-outcome-dropped' % tag, FA, ARGS, loop, loop.replace('outcome &= slot->outcome;', 'outcome &= slot->outcome | 7u;'))
    F('args-%s-conversion-not-written' % tag, FA, ARGS, loop, loop.replace('node_facts_store(records + g, 56, slot->conversion);', '(void)slot->conversion;'))
    F('args-%s-key-no-type' % tag, FA, ARGS, loop, loop.replace('(uint64_t)records[g].type << 32 | ', '(uint64_t)0 << 32 | '))
F('args-parameter-key-no-target', FA, ARGS, FIRST, FIRST.replace('(uint64_t)records[g].type << 32 | (TypeId)target;', '(uint64_t)records[g].type << 32;'))
F('args-other-key-as-target-none', FA, ARGS, SECOND, SECOND.replace('| BUSTER_NODE_FACTS_NO_PARAMETER;', '| 0u;'))
F('args-parameters-all', FA, ARGS, 'for (uint32_t i = 0; i < parameters; i += 1)', 'for (uint32_t i = 0; i < count; i += 1)')
F('args-others-none', FA, ARGS, 'for (uint32_t i = parameters; i < count; i += 1)', 'for (uint32_t i = count; i < count; i += 1)')
F('args-targets-place', FA, ARGS, 'const uint64_t* targets = view->targets + row->parameters;', 'const uint64_t* targets = view->targets + row->parameters + 1;')

SAYS = 'static inline __attribute__((always_inline)) uint32_t node_facts_call_says('
F('says-made-always', FA, SAYS, 'const uint32_t made = outcome & BUSTER_NODE_FACTS_ARGUMENT_MADE;', 'const uint32_t made = outcome | BUSTER_NODE_FACTS_ARGUMENT_MADE;')
F('says-plain-unmade', FA, SAYS, 'made != 0 && (outcome & BUSTER_NODE_FACTS_ARGUMENT_PLAIN) != 0 &&', '(outcome & BUSTER_NODE_FACTS_ARGUMENT_PLAIN) != 0 &&')
F('says-plain-any-argument', FA, SAYS, 'made != 0 && (outcome & BUSTER_NODE_FACTS_ARGUMENT_PLAIN) != 0 &&', 'made != 0 &&')
F('says-plain-any-prototype', FA, SAYS, ' && (function & BUSTER_NODE_FACTS_PLAIN) != 0 ?', ' ?')
F('says-converted-never', FA, SAYS, '(made != 0 ? BUSTER_NODE_FACTS_CONVERTED_CALL : 0)', '0u')

RULE = 'static inline __attribute__((always_inline)) bool node_facts_call('
F('rule-left-uncounted', FA, RULE, 'facts->argument_calls_left += taken && (outcome & BUSTER_NODE_FACTS_ARGUMENT_KEPT) == 0;', 'facts->argument_calls_left += 0;')
F('rule-kept-always', FA, RULE, 'taken = (outcome & BUSTER_NODE_FACTS_ARGUMENT_KEPT) != 0;', 'taken = taken || (outcome & BUSTER_NODE_FACTS_ARGUMENT_KEPT) != 0;')
F('rule-says-nothing', FA, RULE, '(uint64_t)node_facts_call_says(outcome, function) << 16', '(uint64_t)0 << 16')
F('rule-arguments-not-asked', FA, RULE, 'taken ? node_facts_call_arguments_ruled(facts, records, view, w, row) : 0;', 'taken ? 7u : 0;')

CALLS = 'static inline __attribute__((always_inline)) void node_facts_calls_of('
PASS2 = '''                if (__builtin_expect((outcome & BUSTER_NODE_FACTS_ARGUMENT_KEPT) == 0, 0))
                {
                    rare[rare_count] = w;
                    rare_count += 1;
                    records[w].standing = BUSTER_NODE_MACHINE_WIDE;
                }
                else if (!lean)
                {
                    records[w].exponent |= (uint16_t)node_facts_call_says(outcome, row->function);
                }'''
F('pass2-kept-always', FA, CALLS, PASS2, PASS2.replace('(outcome & BUSTER_NODE_FACTS_ARGUMENT_KEPT) == 0, 0', 'w == UINT32_MAX, 0'))
F('pass2-left-unmarked', FA, CALLS, PASS2, PASS2.replace('                    records[w].standing = BUSTER_NODE_MACHINE_WIDE;\n', ''))
F('pass2-says-nothing', FA, CALLS, PASS2, PASS2.replace('records[w].exponent |= (uint16_t)node_facts_call_says(outcome, row->function);', '(void)row;'))
F('pass2-none', FA, CALLS, '            if ((records[w].standing & BUSTER_NODE_MACHINE_WIDE) == 0)\n            {\n                const NodeFactsRow* row',
  '            if ((records[w].standing & BUSTER_NODE_MACHINE_WIDE) == 0 && w == UINT32_MAX)\n            {\n                const NodeFactsRow* row')
F('pass2-left-calls-too', FA, CALLS, '            if ((records[w].standing & BUSTER_NODE_MACHINE_WIDE) == 0)\n            {\n                const NodeFactsRow* row',
  '            if (w != UINT32_MAX)\n            {\n                const NodeFactsRow* row')
F('pass2-order-not-made', FA, CALLS, 'node_facts_rare_order(rare, left_before, rare_count);', '(void)left_before;')
F('pass2-order-always', FA, CALLS, 'if (__builtin_expect(left_before != 0 && rare_count != left_before, 0))', 'if (__builtin_expect(rare_count != left_before, 0))')

SAME = 'static bool node_facts_same('
F('same-arguments-unchecked', FA, SAME, 'arguments = arguments && facts->records[g].spare == facts->expected_arguments[(uint64_t)base + g];', 'arguments = arguments && g != UINT32_MAX;')
F('same-arguments-unsaid-too', FA, SAME, ' && (record->exponent & BUSTER_NODE_FACTS_CONVERTED_CALL) != 0)', ')')

APPEND_DECAYS = 'node_facts_decays(facts, columns->value_types[machine->arguments[first + i]]);'
P('append-no-decays', FA, APPEND_DECAYS, '(void)first;')
P('append-expected-none', FA, 'facts->expected_arguments[w - facts->arguments[entry + i]] = (uint64_t)conversion->type | (uint64_t)conversion->flags << 32;',
  'facts->expected_arguments[w - facts->arguments[entry + i]] = (uint64_t)conversion->type;')
P('run-control-off', FA, 'facts->expected_arguments[w] ^ (state->c_fault && facts->expected_arguments[w] != 0 ? 1u : 0u);', 'facts->expected_arguments[w];')
P('run-calls-uncounted', FA, 'counts[NODE_FACTS_COUNT_WINDOW_CALLS] += call;', 'counts[NODE_FACTS_COUNT_WINDOW_CALLS] += 0;')
P('run-made-uncounted', FA, 'counts[NODE_FACTS_COUNT_WINDOW_CALLS_MADE] += made;', 'counts[NODE_FACTS_COUNT_WINDOW_CALLS_MADE] += 0;')
P('run-converted-uncounted', FA, 'counts[NODE_FACTS_COUNT_WINDOW_CALLS_CONVERTED] += made && (facts->records[x].exponent & BUSTER_NODE_FACTS_CONVERTED_CALL) != 0;',
  'counts[NODE_FACTS_COUNT_WINDOW_CALLS_CONVERTED] += made;')
P('run-plain-uncounted', FA, 'counts[NODE_FACTS_COUNT_WINDOW_CALLS_PLAIN] += made && (facts->records[x].exponent & BUSTER_NODE_FACTS_PLAIN_CALL) != 0;',
  'counts[NODE_FACTS_COUNT_WINDOW_CALLS_PLAIN] += made;')
P('run-left-uncounted', FA, 'counts[NODE_FACTS_COUNT_WINDOW_CALLS_ARGUMENT] += facts->argument_calls_left - calls_left;', 'counts[NODE_FACTS_COUNT_WINDOW_CALLS_ARGUMENT] += 0;')
P('run-answers-uncounted', FA, 'counts[NODE_FACTS_COUNT_WINDOW_ANSWERS] += facts->argument_answers - answers;', 'counts[NODE_FACTS_COUNT_WINDOW_ANSWERS] += 0;')

# The rule: node_facts_argument_made.
MADE = 'static inline __attribute__((always_inline)) uint32_t node_facts_argument_made('
def M(name, a, b):
    F('made-' + name, FA, MADE, a, b)
M('array-no-array', '(1u << BUSTER_TYPE_KIND_ARRAY | 1u << BUSTER_TYPE_KIND_INCOMPLETE_ARRAY | 1u << BUSTER_TYPE_KIND_VARIABLE_ARRAY)', '(1u << BUSTER_TYPE_KIND_INCOMPLETE_ARRAY | 1u << BUSTER_TYPE_KIND_VARIABLE_ARRAY)')
M('array-no-incomplete', '(1u << BUSTER_TYPE_KIND_ARRAY | 1u << BUSTER_TYPE_KIND_INCOMPLETE_ARRAY | 1u << BUSTER_TYPE_KIND_VARIABLE_ARRAY)', '(1u << BUSTER_TYPE_KIND_ARRAY | 1u << BUSTER_TYPE_KIND_VARIABLE_ARRAY)')
M('array-no-variable', '(1u << BUSTER_TYPE_KIND_ARRAY | 1u << BUSTER_TYPE_KIND_INCOMPLETE_ARRAY | 1u << BUSTER_TYPE_KIND_VARIABLE_ARRAY)', '(1u << BUSTER_TYPE_KIND_ARRAY | 1u << BUSTER_TYPE_KIND_INCOMPLETE_ARRAY)')
M('function-never', 'const uint32_t is_function = own_kind == BUSTER_TYPE_KIND_FUNCTION ? 1u : 0u;', 'const uint32_t is_function = own_kind == BUSTER_TYPE_KIND_COUNT ? 1u : 0u;')
M('lvalue-decays-too', 'const uint32_t lvalue = ((standing & 0x03u) == CHECK_LVALUE ? 1u : 0u) & (decays ^ 1u);', 'const uint32_t lvalue = ((standing & 0x03u) == CHECK_LVALUE ? 1u : 0u);')
M('lvalue-never', 'const uint32_t lvalue = ((standing & 0x03u) == CHECK_LVALUE ? 1u : 0u) & (decays ^ 1u);', 'const uint32_t lvalue = ((standing & 0x03u) == CHECK_LVALUE ? 1u : 0u) & (decays ^ 1u) & 0u;')
M('array-register-too', '(flags & BUSTER_CHECK_REGISTER_NAME) == 0 && qualifiers <= BUSTER_TYPE_CONST ?', 'qualifiers <= BUSTER_TYPE_CONST ?')
M('array-any-qualifier', '(flags & BUSTER_CHECK_REGISTER_NAME) == 0 && qualifiers <= BUSTER_TYPE_CONST ?', '(flags & BUSTER_CHECK_REGISTER_NAME) == 0 ?')
M('array-const-as-plain', '(qualifiers != 0 ? const_pointer : function_pointer)', '(function_pointer)')
M('array-plain-as-const', '(qualifiers != 0 ? const_pointer : function_pointer)', '(const_pointer)')
M('pointer-value-functions-as-arrays', 'const TypeId pointer_value = is_array != 0 ? array_pointer : function_pointer;', 'const TypeId pointer_value = array_pointer;')
M('pointer-value-arrays-as-functions', 'const TypeId pointer_value = is_array != 0 ? array_pointer : function_pointer;', 'const TypeId pointer_value = function_pointer;')
M('value-decays-own', 'const TypeId value = decays != 0 ? pointer_value : lvalue != 0 ? row->value : type;', 'const TypeId value = lvalue != 0 ? row->value : type;')
M('value-lvalue-own', 'const TypeId value = decays != 0 ? pointer_value : lvalue != 0 ? row->value : type;', 'const TypeId value = decays != 0 ? pointer_value : type;')
M('value-rvalue-rows', 'const TypeId value = decays != 0 ? pointer_value : lvalue != 0 ? row->value : type;', 'const TypeId value = decays != 0 ? pointer_value : row->value;')
M('read-no-integer', '(1u << BUSTER_TYPE_KIND_INTEGER | 1u << BUSTER_TYPE_KIND_FLOATING | 1u << BUSTER_TYPE_KIND_POINTER)', '(1u << BUSTER_TYPE_KIND_FLOATING | 1u << BUSTER_TYPE_KIND_POINTER)')
M('read-no-floating', '(1u << BUSTER_TYPE_KIND_INTEGER | 1u << BUSTER_TYPE_KIND_FLOATING | 1u << BUSTER_TYPE_KIND_POINTER)', '(1u << BUSTER_TYPE_KIND_INTEGER | 1u << BUSTER_TYPE_KIND_POINTER)')
M('read-no-pointer', '(1u << BUSTER_TYPE_KIND_INTEGER | 1u << BUSTER_TYPE_KIND_FLOATING | 1u << BUSTER_TYPE_KIND_POINTER)', '(1u << BUSTER_TYPE_KIND_INTEGER | 1u << BUSTER_TYPE_KIND_FLOATING)')
M('read-any-kind', '(own & (1u << BUSTER_TYPE_KIND_INTEGER | 1u << BUSTER_TYPE_KIND_FLOATING | 1u << BUSTER_TYPE_KIND_POINTER)) != 0 &&\n', '(own | 1u) != 0 &&\n')
M('read-volatile-too', '(qualifiers & BUSTER_TYPE_VOLATILE) == 0 && ', '')
M('read-volatile-part-too', ' && (flags & BUSTER_CHECK_VOLATILE_PART) == 0 ? 1u : 0u;', ' ? 1u : 0u;')
M('taken-wrapped-too', '((word & BUSTER_NODE_MACHINE_WORD_PLAIN) != 0 ? 1u : 0u) & ', '')
M('taken-wide-too', '((standing & BUSTER_NODE_MACHINE_WIDE) == 0 ? 1u : 0u) &\n', '1u &\n')
M('taken-no-pointer-too', '(decays != 0 ? (pointer_value != 0 ? 1u : 0u) : 1u) & ', '')
M('taken-unread-too', ' & (lvalue != 0 ? read : 1u);', ';')
M('constant-lvalue-kept', '(lvalue & ((flags & BUSTER_CHECK_ICE) == 0 ? 1u : 0u)) != 0 ?', '(lvalue & ((flags & BUSTER_CHECK_ICE) == 0 ? 1u : 0u) & 0u) != 0 ?')
M('constant-lvalue-none', '(lvalue & ((flags & BUSTER_CHECK_ICE) == 0 ? 1u : 0u)) != 0 ?', '(lvalue) != 0 ?')
M('converts-array-as-function', 'is_array != 0 ? (uint32_t)BUSTER_CHECK_CONVERT_ARRAY : ', '')
M('converts-function-as-lvalue', ' : is_function != 0 ? (uint32_t)BUSTER_CHECK_CONVERT_FUNCTION : lvalue;', ' : lvalue;')
M('converts-lvalue-none', ' : is_function != 0 ? (uint32_t)BUSTER_CHECK_CONVERT_FUNCTION : lvalue;', ' : is_function != 0 ? (uint32_t)BUSTER_CHECK_CONVERT_FUNCTION : 0u;')
M('forms-any', 'const uint32_t forms = flags & view->null_forms;', 'const uint32_t forms = 1u;')
M('forms-none', 'const uint32_t forms = flags & view->null_forms;', 'const uint32_t forms = 0u;')
M('source-pointer-no-decays', 'const uint32_t source_pointer = decays | (own_kind == BUSTER_TYPE_KIND_POINTER ? 1u : 0u);', 'const uint32_t source_pointer = (own_kind == BUSTER_TYPE_KIND_POINTER ? 1u : 0u);')
M('source-pointer-decays-only', 'const uint32_t source_pointer = decays | (own_kind == BUSTER_TYPE_KIND_POINTER ? 1u : 0u);', 'const uint32_t source_pointer = decays;')
M('atomic-never', 'const uint32_t atomic = own_kind == BUSTER_TYPE_KIND_ATOMIC ? 1u : 0u;', 'const uint32_t atomic = own_kind == BUSTER_TYPE_KIND_COUNT ? 1u : 0u;')
M('unqualified-always', 'const uint32_t unqualified = type_qualifiers(value) == 0 ? 1u : 0u;', 'const uint32_t unqualified = 1u;')
M('real-none', 'const uint32_t real = ((value_facts & BUSTER_NODE_FACTS_ARGUED_REAL) != 0 ? 1u : 0u) & unqualified;', 'const uint32_t real = 0u & unqualified;')
M('real-qualified-too', 'const uint32_t real = ((value_facts & BUSTER_NODE_FACTS_ARGUED_REAL) != 0 ? 1u : 0u) & unqualified;', 'const uint32_t real = ((value_facts & BUSTER_NODE_FACTS_ARGUED_REAL) != 0 ? 1u : 0u);')
M('integer-any-constant', 'const uint32_t integer = (constant == CHECK_CONSTANT_INTEGER ? 1u : 0u) & ', 'const uint32_t integer = ')
M('integer-any-type', '((value_facts & BUSTER_NODE_FACTS_ARGUED_INTEGER) != 0 ? 1u : 0u) & (field == 0 ? 1u : 0u);', '(field == 0 ? 1u : 0u);')
M('integer-fields-too', '((value_facts & BUSTER_NODE_FACTS_ARGUED_INTEGER) != 0 ? 1u : 0u) & (field == 0 ? 1u : 0u);', '((value_facts & BUSTER_NODE_FACTS_ARGUED_INTEGER) != 0 ? 1u : 0u);')
M('floating-any-constant', 'const uint32_t floating = (constant == CHECK_CONSTANT_FLOATING ? 1u : 0u) & real;', 'const uint32_t floating = real;')
M('floating-any-type', 'const uint32_t floating = (constant == CHECK_CONSTANT_FLOATING ? 1u : 0u) & real;', 'const uint32_t floating = (constant == CHECK_CONSTANT_FLOATING ? 1u : 0u);')
M('flagged-never', 'const uint32_t flagged = (flags & BUSTER_CHECK_NULL_POINTER) != 0 ? 1u : 0u;', 'const uint32_t flagged = (flags & BUSTER_CHECK_NULL_POINTER & 0u) != 0 ? 1u : 0u;')
M('whole-always', 'const uint32_t whole = (standing & BUSTER_NODE_MACHINE_WIDE) == 0 ? 1u : 0u;', 'const uint32_t whole = 1u;')
M('valid-own-word-any', 'const uint32_t valid = ((word & BUSTER_NODE_MACHINE_WORD_VALID) != 0 ? 1u : 0u) & ', 'const uint32_t valid = ')
M('valid-decays-asked', '(decays | ((value_facts & BUSTER_NODE_FACTS_ARGUED_VALID) != 0 ? 1u : 0u));', '(((value_facts & BUSTER_NODE_FACTS_ARGUED_VALID) != 0 ? 1u : 0u));')
M('valid-value-any', '(decays | ((value_facts & BUSTER_NODE_FACTS_ARGUED_VALID) != 0 ? 1u : 0u));', '(decays | 1u);')
M('vector-value-never', 'uint32_t vector = (value_facts & BUSTER_NODE_FACTS_ARGUED_VECTOR) != 0 ? 1u : 0u;', 'uint32_t vector = 0u;')
M('complex-value-never', 'uint32_t complex = (value_facts & BUSTER_NODE_FACTS_ARGUED_COMPLEX) != 0 ? 1u : 0u;', 'uint32_t complex = 0u;')
M('targeted-always', 'const uint32_t targeted = (target_facts & BUSTER_NODE_FACTS_ARGUED_VALID) != 0 ? 1u : 0u;', 'const uint32_t targeted = 1u;')
M('pointer-never', 'const uint32_t pointer = (target_facts & BUSTER_NODE_FACTS_ARGUED_POINTER) != 0 ? 1u : 0u;', 'const uint32_t pointer = 0u;')
M('same-always', 'const uint32_t same = target_type == value ? 1u : 0u;', 'const uint32_t same = 1u;')
M('same-never', 'const uint32_t same = target_type == value ? 1u : 0u;', 'const uint32_t same = 0u;')
M('ruled-untaken-too', 'const uint32_t ruled = taken & targeted & (atomic ^ 1u);', 'const uint32_t ruled = targeted & (atomic ^ 1u);')
M('ruled-untargeted-too', 'const uint32_t ruled = taken & targeted & (atomic ^ 1u);', 'const uint32_t ruled = taken & (atomic ^ 1u);')
M('ruled-atomic-too', 'const uint32_t ruled = taken & targeted & (atomic ^ 1u);', 'const uint32_t ruled = taken & targeted;')
M('sized-qualified-too', 'const uint32_t sized = unqualified != 0 && (value_facts >> 24) != 0 ? 1u : 0u;', 'const uint32_t sized = (value_facts >> 24) != 0 ? 1u : 0u;')
M('sized-any-type', 'const uint32_t sized = unqualified != 0 && (value_facts >> 24) != 0 ? 1u : 0u;', 'const uint32_t sized = unqualified != 0 ? 1u : 0u;')
M('null-any-constant', 'const uint32_t null_constant = (constant == CHECK_CONSTANT_INTEGER ? 1u : 0u) & (forms != 0 ? 1u : 0u) & sized & zero;', 'const uint32_t null_constant = (forms != 0 ? 1u : 0u) & sized & zero;')
M('null-any-form', 'const uint32_t null_constant = (constant == CHECK_CONSTANT_INTEGER ? 1u : 0u) & (forms != 0 ? 1u : 0u) & sized & zero;', 'const uint32_t null_constant = (constant == CHECK_CONSTANT_INTEGER ? 1u : 0u) & sized & zero;')
M('null-any-size', 'const uint32_t null_constant = (constant == CHECK_CONSTANT_INTEGER ? 1u : 0u) & (forms != 0 ? 1u : 0u) & sized & zero;', 'const uint32_t null_constant = (constant == CHECK_CONSTANT_INTEGER ? 1u : 0u) & (forms != 0 ? 1u : 0u) & zero;')
M('null-any-value', 'const uint32_t null_constant = (constant == CHECK_CONSTANT_INTEGER ? 1u : 0u) & (forms != 0 ? 1u : 0u) & sized & zero;', 'const uint32_t null_constant = (constant == CHECK_CONSTANT_INTEGER ? 1u : 0u) & (forms != 0 ? 1u : 0u) & sized;')
M('null-pointer-unflagged', 'const uint32_t null = pointer & (source_pointer != 0 ? flagged : (flagged ^ 1u) & null_constant);', 'const uint32_t null = pointer & (source_pointer != 0 ? 0u : (flagged ^ 1u) & null_constant);')
M('null-constant-flagged-too', 'const uint32_t null = pointer & (source_pointer != 0 ? flagged : (flagged ^ 1u) & null_constant);', 'const uint32_t null = pointer & (source_pointer != 0 ? flagged : null_constant);')
M('null-any-target', 'const uint32_t null = pointer & (source_pointer != 0 ? flagged : (flagged ^ 1u) & null_constant);', 'const uint32_t null = (source_pointer != 0 ? flagged : (flagged ^ 1u) & null_constant);')
M('other-same-too', 'const uint32_t other = pointer & source_pointer & (same ^ 1u);', 'const uint32_t other = pointer & source_pointer;')
M('other-never', 'const uint32_t other = pointer & source_pointer & (same ^ 1u);', 'const uint32_t other = pointer & source_pointer & (same ^ 1u) & 0u;')
M('pair-unruled-too', 'if (__builtin_expect((ruled & other) != 0, 0))', 'if (__builtin_expect((other) != 0, 0))')
M('pair-not-asked', 'pair = node_facts_pair(facts, view, target_type, value)->flags;', 'pair = 0;')
M('pair-reversed', 'pair = node_facts_pair(facts, view, target_type, value)->flags;', 'pair = node_facts_pair(facts, view, value, target_type)->flags;')
M('answered-always', 'const uint32_t answered = (other ^ 1u) | ((pair & BUSTER_NODE_FACTS_PAIR_USED) != 0 ? 1u : 0u);', 'const uint32_t answered = 1u;')
M('pointed-any-source', 'const uint32_t pointed = source_pointer & (flagged ^ 1u) & ', 'const uint32_t pointed = (flagged ^ 1u) & ')
M('pointed-flagged-too', 'const uint32_t pointed = source_pointer & (flagged ^ 1u) & ', 'const uint32_t pointed = source_pointer & ')
M('pointed-other-unasked', '(same | ((pair & BUSTER_NODE_FACTS_PAIR_ASSIGNABLE) != 0 ? 1u : 0u)) & (none | address);', '(same | other) & (none | address);')
M('pointed-same-only', '(same | ((pair & BUSTER_NODE_FACTS_PAIR_ASSIGNABLE) != 0 ? 1u : 0u)) & (none | address);', '(same) & (none | address);')
M('pointed-any-constant', '(same | ((pair & BUSTER_NODE_FACTS_PAIR_ASSIGNABLE) != 0 ? 1u : 0u)) & (none | address);', '(same | ((pair & BUSTER_NODE_FACTS_PAIR_ASSIGNABLE) != 0 ? 1u : 0u));')
M('arithmetic-none', 'const uint32_t arithmetic = ((target_facts & value_facts & BUSTER_NODE_FACTS_ARGUED_ARITHMETIC) != 0 ? 1u : 0u) |', 'const uint32_t arithmetic = 0u |')
M('arithmetic-any-value', 'const uint32_t arithmetic = ((target_facts & value_facts & BUSTER_NODE_FACTS_ARGUED_ARITHMETIC) != 0 ? 1u : 0u) |', 'const uint32_t arithmetic = ((target_facts & BUSTER_NODE_FACTS_ARGUED_ARITHMETIC) != 0 ? 1u : 0u) |')
M('arithmetic-any-target', 'const uint32_t arithmetic = ((target_facts & value_facts & BUSTER_NODE_FACTS_ARGUED_ARITHMETIC) != 0 ? 1u : 0u) |', 'const uint32_t arithmetic = ((value_facts & BUSTER_NODE_FACTS_ARGUED_ARITHMETIC) != 0 ? 1u : 0u) |')
M('bool-none', '(((target_facts & BUSTER_NODE_FACTS_ARGUED_BOOL) != 0 ? 1u : 0u) & ((value_facts & BUSTER_NODE_FACTS_ARGUED_SCALAR) != 0 ? 1u : 0u));', '0u;')
M('bool-any-value', '(((target_facts & BUSTER_NODE_FACTS_ARGUED_BOOL) != 0 ? 1u : 0u) & ((value_facts & BUSTER_NODE_FACTS_ARGUED_SCALAR) != 0 ? 1u : 0u));', '(((target_facts & BUSTER_NODE_FACTS_ARGUED_BOOL) != 0 ? 1u : 0u));')
M('bool-any-target', '(((target_facts & BUSTER_NODE_FACTS_ARGUED_BOOL) != 0 ? 1u : 0u) & ((value_facts & BUSTER_NODE_FACTS_ARGUED_SCALAR) != 0 ? 1u : 0u));', '(((value_facts & BUSTER_NODE_FACTS_ARGUED_SCALAR) != 0 ? 1u : 0u));')
M('folds-no-none', 'const uint32_t folds = none | address | (integer & ', 'const uint32_t folds = address | (integer & ')
M('folds-no-address', 'const uint32_t folds = none | address | (integer & ', 'const uint32_t folds = none | (integer & ')
M('folds-no-integer', '(integer & ((target_facts & BUSTER_NODE_FACTS_ARGUED_FOLDS) != 0 ? 1u : 0u)) |', '0u |')
M('folds-integer-anywhere', '(integer & ((target_facts & BUSTER_NODE_FACTS_ARGUED_FOLDS) != 0 ? 1u : 0u)) |', '(integer) |')
M('folds-no-floating', '(floating & ((target_facts & BUSTER_NODE_FACTS_ARGUED_REAL) != 0 ? 1u : 0u));', '0u;')
M('folds-floating-anywhere', '(floating & ((target_facts & BUSTER_NODE_FACTS_ARGUED_REAL) != 0 ? 1u : 0u));', '(floating);')
M('made-unruled', 'made = ruled & (pointer != 0 ? pointed | (null & answered) : arithmetic & folds) & ', 'made = (pointer != 0 ? pointed | (null & answered) : arithmetic & folds) & ')
M('made-no-null', '(pointer != 0 ? pointed | (null & answered) : arithmetic & folds)', '(pointer != 0 ? pointed : arithmetic & folds)')
M('made-null-unanswered', '(pointer != 0 ? pointed | (null & answered) : arithmetic & folds)', '(pointer != 0 ? pointed | null : arithmetic & folds)')
M('made-no-pointed', '(pointer != 0 ? pointed | (null & answered) : arithmetic & folds)', '(pointer != 0 ? (null & answered) : arithmetic & folds)')
M('made-any-constant', '(pointer != 0 ? pointed | (null & answered) : arithmetic & folds)', '(pointer != 0 ? pointed | (null & answered) : arithmetic)')
M('made-no-arithmetic', '(pointer != 0 ? pointed | (null & answered) : arithmetic & folds)', '(pointer != 0 ? pointed | (null & answered) : 0u)')
M('made-any-target-type', ' & ((target_facts & BUSTER_NODE_FACTS_ARGUED_MADE) != 0 ? 1u : 0u);\n        made_type = target_type;', ';\n        made_type = target_type;')
M('made-flags-no-assignment', 'made_flags = converts | BUSTER_CHECK_CONVERT_ASSIGNMENT;', 'made_flags = converts;')
M('made-flags-no-own', 'made_flags = converts | BUSTER_CHECK_CONVERT_ASSIGNMENT;', 'made_flags = BUSTER_CHECK_CONVERT_ASSIGNMENT;')
M('plain-any-target', 'plain = (target_facts & BUSTER_NODE_FACTS_ARGUED_PLAIN) != 0 ? 1u : 0u;', 'plain = 1u;')
M('neutral-untargeted', 'neutral = targeted & (none | address) & (((target_facts & BUSTER_NODE_FACTS_ARGUED_AGGREGATE) == 0 ? 1u : 0u) | same);', 'neutral = (none | address) & (((target_facts & BUSTER_NODE_FACTS_ARGUED_AGGREGATE) == 0 ? 1u : 0u) | same);')
M('neutral-any-constant', 'neutral = targeted & (none | address) & (((target_facts & BUSTER_NODE_FACTS_ARGUED_AGGREGATE) == 0 ? 1u : 0u) | same);', 'neutral = targeted & (((target_facts & BUSTER_NODE_FACTS_ARGUED_AGGREGATE) == 0 ? 1u : 0u) | same);')
M('neutral-any-aggregate', 'neutral = targeted & (none | address) & (((target_facts & BUSTER_NODE_FACTS_ARGUED_AGGREGATE) == 0 ? 1u : 0u) | same);', 'neutral = targeted & (none | address);')
M('neutral-no-aggregate', 'neutral = targeted & (none | address) & (((target_facts & BUSTER_NODE_FACTS_ARGUED_AGGREGATE) == 0 ? 1u : 0u) | same);', 'neutral = targeted & (none | address) & (((target_facts & BUSTER_NODE_FACTS_ARGUED_AGGREGATE) == 0 ? 1u : 0u));')
M('vector-target-never', 'vector |= (target_facts & BUSTER_NODE_FACTS_ARGUED_VECTOR) != 0 ? 1u : 0u;', 'vector |= 0u;')
M('complex-target-never', 'complex |= (target_facts & BUSTER_NODE_FACTS_ARGUED_COMPLEX) != 0 ? 1u : 0u;', 'complex |= 0u;')
M('other-pointer-never', 'const uint32_t pointer = (value_facts & BUSTER_NODE_FACTS_ARGUED_PROMOTED_POINTER) != 0 ? 1u : 0u;', 'const uint32_t pointer = 0u;')
M('other-ruled-untaken', 'const uint32_t ruled = taken & unqualified & (promoted != 0 ? 1u : 0u) & (atomic ^ 1u);', 'const uint32_t ruled = unqualified & (promoted != 0 ? 1u : 0u) & (atomic ^ 1u);')
M('other-ruled-qualified', 'const uint32_t ruled = taken & unqualified & (promoted != 0 ? 1u : 0u) & (atomic ^ 1u);', 'const uint32_t ruled = taken & (promoted != 0 ? 1u : 0u) & (atomic ^ 1u);')
M('other-ruled-unpromoted', 'const uint32_t ruled = taken & unqualified & (promoted != 0 ? 1u : 0u) & (atomic ^ 1u);', 'const uint32_t ruled = taken & unqualified & (atomic ^ 1u);')
M('other-ruled-atomic', 'const uint32_t ruled = taken & unqualified & (promoted != 0 ? 1u : 0u) & (atomic ^ 1u);', 'const uint32_t ruled = taken & unqualified & (promoted != 0 ? 1u : 0u);')
M('other-made-no-none', 'made = ruled & (none | address | ((pointer ^ 1u) & (integer | floating))) & ', 'made = ruled & (address | ((pointer ^ 1u) & (integer | floating))) & ')
M('other-made-no-address', 'made = ruled & (none | address | ((pointer ^ 1u) & (integer | floating))) & ', 'made = ruled & (none | ((pointer ^ 1u) & (integer | floating))) & ')
M('other-made-pointer-constants', 'made = ruled & (none | address | ((pointer ^ 1u) & (integer | floating))) & ', 'made = ruled & (none | address | ((integer | floating))) & ')
M('other-made-no-integer', 'made = ruled & (none | address | ((pointer ^ 1u) & (integer | floating))) & ', 'made = ruled & (none | address | ((pointer ^ 1u) & (floating))) & ')
M('other-made-no-floating', 'made = ruled & (none | address | ((pointer ^ 1u) & (integer | floating))) & ', 'made = ruled & (none | address | ((pointer ^ 1u) & (integer))) & ')
M('other-made-any-type', ' & ((value_facts & BUSTER_NODE_FACTS_ARGUED_PROMOTED_MADE) != 0 ? 1u : 0u);', ';')
M('other-flags-no-promotion', 'made_flags = converts | (promoted != value ? (uint32_t)BUSTER_CHECK_CONVERT_PROMOTION : 0u);', 'made_flags = converts;')
M('other-flags-always-promotion', 'made_flags = converts | (promoted != value ? (uint32_t)BUSTER_CHECK_CONVERT_PROMOTION : 0u);', 'made_flags = converts | (uint32_t)BUSTER_CHECK_CONVERT_PROMOTION;')
M('other-flags-no-own', 'made_flags = converts | (promoted != value ? (uint32_t)BUSTER_CHECK_CONVERT_PROMOTION : 0u);', 'made_flags = (promoted != value ? (uint32_t)BUSTER_CHECK_CONVERT_PROMOTION : 0u);')
M('other-plain-any', 'plain = (value_facts & BUSTER_NODE_FACTS_ARGUED_PROMOTED_PLAIN) != 0 ? 1u : 0u;', 'plain = 1u;')
M('other-neutral-no-none', '        neutral = none | address;', '        neutral = address;')
M('other-neutral-no-address', '        neutral = none | address;', '        neutral = none;')
for flag in ('BUSTER_CHECK_SIDE_EFFECT', 'BUSTER_CHECK_GNU_CONSTANT', 'BUSTER_CHECK_FP_ENVIRONMENT'):
    whole = '~(uint32_t)(BUSTER_CHECK_SIDE_EFFECT | BUSTER_CHECK_GNU_CONSTANT | BUSTER_CHECK_FP_ENVIRONMENT);'
    M('dropped-' + flag[13:].lower().replace('_', '-') + '-too', whole, whole.replace(flag + ' | ', '').replace(' | ' + flag, ''))
M('neutral-wide-too', 'neutral = whole & valid & (complex ^ 1u) & ', 'neutral = valid & (complex ^ 1u) & ')
M('neutral-invalid-too', 'neutral = whole & valid & (complex ^ 1u) & ', 'neutral = whole & (complex ^ 1u) & ')
M('neutral-complex-too', 'neutral = whole & valid & (complex ^ 1u) & ', 'neutral = whole & valid & ')
M('neutral-vector-any-flags', '(vector != 0 ? (dropped == 0 ? 1u : 0u) : neutral);', '(vector != 0 ? 1u : neutral);')
M('neutral-vector-never', '(vector != 0 ? (dropped == 0 ? 1u : 0u) : neutral);', '(vector != 0 ? 0u : neutral);')
M('neutral-vector-as-others', '(vector != 0 ? (dropped == 0 ? 1u : 0u) : neutral);', '(neutral);')
M('made-invalid-too', 'made &= valid & (vector ^ 1u) & (complex ^ 1u);', 'made &= (vector ^ 1u) & (complex ^ 1u);')
M('made-vector-too', 'made &= valid & (vector ^ 1u) & (complex ^ 1u);', 'made &= valid & (complex ^ 1u);')
M('made-complex-too', 'made &= valid & (vector ^ 1u) & (complex ^ 1u);', 'made &= valid & (vector ^ 1u);')
M('conversion-unmade-too', '*conversion = made != 0 ? (uint64_t)made_type | (uint64_t)made_flags << 32 : 0;', '*conversion = (uint64_t)made_type | (uint64_t)made_flags << 32;')
M('kept-made-only', '((made | neutral) != 0 ? BUSTER_NODE_FACTS_ARGUMENT_KEPT : 0u)', '((made) != 0 ? BUSTER_NODE_FACTS_ARGUMENT_KEPT : 0u)')
M('kept-neutral-only', '((made | neutral) != 0 ? BUSTER_NODE_FACTS_ARGUMENT_KEPT : 0u)', '((neutral) != 0 ? BUSTER_NODE_FACTS_ARGUMENT_KEPT : 0u)')
M('made-bit-never', '(made != 0 ? BUSTER_NODE_FACTS_ARGUMENT_MADE : 0u)', '0u')
M('plain-bit-unmade', '((made & plain) != 0 ? BUSTER_NODE_FACTS_ARGUMENT_PLAIN : 0u)', '((plain) != 0 ? BUSTER_NODE_FACTS_ARGUMENT_PLAIN : 0u)')
M('plain-bit-always-made', '((made & plain) != 0 ? BUSTER_NODE_FACTS_ARGUMENT_PLAIN : 0u)', '((made) != 0 ? BUSTER_NODE_FACTS_ARGUMENT_PLAIN : 0u)')

# C's call on the window.
def WL(name, a, b):
    P('window-' + name, W, a, b)
WL('row-callee-unevaluated', 'tables->rows[BUSTER_NODE_MACHINE_TEMPLATE_CALL << 1] = BUSTER_NODE_CONTEXTS_EVALUATES | BUSTER_NODE_CONTEXTS_SOURCE_NONE;', 'tables->rows[BUSTER_NODE_MACHINE_TEMPLATE_CALL << 1] = BUSTER_NODE_CONTEXTS_SOURCE_NONE;')
WL('row-callee-own-target', 'tables->rows[BUSTER_NODE_MACHINE_TEMPLATE_CALL << 1] = BUSTER_NODE_CONTEXTS_EVALUATES | BUSTER_NODE_CONTEXTS_SOURCE_NONE;', 'tables->rows[BUSTER_NODE_MACHINE_TEMPLATE_CALL << 1] = BUSTER_NODE_CONTEXTS_EVALUATES | BUSTER_NODE_CONTEXTS_SOURCE_OWN;')
WL('row-argument-unevaluated', 'tables->rows[(BUSTER_NODE_MACHINE_TEMPLATE_CALL << 1) + 1] = BUSTER_NODE_CONTEXTS_EVALUATES | BUSTER_NODE_CONTEXTS_SOURCE_OWN;', 'tables->rows[(BUSTER_NODE_MACHINE_TEMPLATE_CALL << 1) + 1] = BUSTER_NODE_CONTEXTS_SOURCE_OWN;')
WL('row-argument-no-target', 'tables->rows[(BUSTER_NODE_MACHINE_TEMPLATE_CALL << 1) + 1] = BUSTER_NODE_CONTEXTS_EVALUATES | BUSTER_NODE_CONTEXTS_SOURCE_OWN;', 'tables->rows[(BUSTER_NODE_MACHINE_TEMPLATE_CALL << 1) + 1] = BUSTER_NODE_CONTEXTS_EVALUATES | BUSTER_NODE_CONTEXTS_SOURCE_NONE;')
window = text(W)
def mask(name):
    m = re.findall(r'\n( +const __mmask64 %s = ([^;]*);\n)' % re.escape(name), window)
    assert len(m) == 1, (name, len(m))
    return m[0]
for name in ('is_call', 'converted_call', 'plain_call', 'made_call', 'callee', 'offset', 'called', 'direct'):
    whole, rhs = mask(name)
    indent = whole[:len(whole) - len(whole.lstrip())]
    for value in (True, False):
        P('window-%s-%s' % (name.replace('_', '-'), 'all' if value else 'none'), W, whole, '%sconst __mmask64 %s = %s;\n' % (indent, name, ('(%s) | ~(__mmask64)0' if value else '(%s) & 0') % rhs))
WL('made-call-in-a-place', 'const __mmask64 made_call = is_call & ~address & plain_call;', 'const __mmask64 made_call = is_call & plain_call;')
WL('made-call-any-kind', 'const __mmask64 made_call = is_call & ~address & plain_call;', 'const __mmask64 made_call = is_call & ~address;')
WL('called-lvalue-too', 'const __mmask64 called = callee & ~lvalue & address_constant & ~offset & has_object & ~effects;', 'const __mmask64 called = callee & address_constant & ~offset & has_object & ~effects;')
WL('called-any-constant', 'const __mmask64 called = callee & ~lvalue & address_constant & ~offset & has_object & ~effects;', 'const __mmask64 called = callee & ~lvalue & ~offset & has_object & ~effects;')
WL('called-offset-too', 'const __mmask64 called = callee & ~lvalue & address_constant & ~offset & has_object & ~effects;', 'const __mmask64 called = callee & ~lvalue & address_constant & has_object & ~effects;')
WL('called-no-object-too', 'const __mmask64 called = callee & ~lvalue & address_constant & ~offset & has_object & ~effects;', 'const __mmask64 called = callee & ~lvalue & address_constant & ~offset & ~effects;')
WL('called-effects-too', 'const __mmask64 called = callee & ~lvalue & address_constant & ~offset & has_object & ~effects;', 'const __mmask64 called = callee & ~lvalue & address_constant & ~offset & has_object;')
WL('direct-any-record', 'const __mmask64 direct = called & is_value & symbol;', 'const __mmask64 direct = called & symbol;')
WL('direct-no-symbol', 'const __mmask64 direct = called & is_value & symbol;', 'const __mmask64 direct = called & is_value;')
WL('listed-unconverted-call-not', ' | (is_call & ~converted_call) | (called & ~is_value));', ' | (called & ~is_value));')
WL('listed-callee-not', ' | (is_call & ~converted_call) | (called & ~is_value));', ' | (is_call & ~converted_call));')
WL('templates-no-call', 'const __m512i templates = _mm512_mask_mov_epi8(own_templates, made_call, _mm512_set1_epi8(BUSTER_NODE_MACHINE_TEMPLATE_CALL));', 'const __m512i templates = own_templates;')
WL('evaluates-direct-too', ' & ~direct;', ';')
WL('uncased-call-too', 'const __mmask64 is_uncased = _mm512_cmpge_epu8_mask(class_kinds, _mm512_set1_epi8(BUSTER_NODE_CONTEXTS_CLASS_LOGICAL))', 'const __mmask64 is_uncased = _mm512_cmpge_epu8_mask(class_kinds, _mm512_set1_epi8(BUSTER_NODE_CONTEXTS_CLASS_CALL))')
WL('targets-own-none', 'const __mmask16 own = _mm512_mask_cmpeq_epi32_mask(alive, sources, _mm512_set1_epi32(BUSTER_NODE_CONTEXTS_SOURCE_OWN));', 'const __mmask16 own = (__mmask16)(_mm512_mask_cmpeq_epi32_mask(alive, sources, _mm512_set1_epi32(BUSTER_NODE_CONTEXTS_SOURCE_OWN)) & 0);')
WL('targets-own-consumers-line', 'const __m512i lines = _mm512_mask_mov_epi32(consumers, own, _mm512_add_epi32(_mm512_set1_epi32((int32_t)x), lanes));', 'const __m512i lines = consumers;')
WL('targets-own-converted-field', 'fields = _mm512_mask_mov_epi32(fields, own, _mm512_set1_epi32((int32_t)offsetof(NodeFactsRecord, spare)));', '(void)own;')
WL('targets-own-not-gathered', '_mm512_mask_i32gather_epi32(_mm512_setzero_si512(), given | node | own, offsets, records, 1);', '_mm512_mask_i32gather_epi32(_mm512_setzero_si512(), given | node, offsets, records, 1);')

# The records' bytes: the two bits of a call's record.
census = text(C)
for bit in ('CONVERTED', 'PLAIN'):
    lines = [l for l in census.split('\n') if 'BUSTER_NODE_CONTEXTS_' + bit in l and 'define' not in l]
    for n, line in enumerate(lines):
        P('bytes-%s-%d-none' % (bit.lower(), n), C, line, line.replace('BUSTER_NODE_CONTEXTS_' + bit, '0'))

names = [f[0] for f in FAULTS]
assert len(set(names)) == len(names), [n for n in names if names.count(n) > 1]
if len(sys.argv) > 3 and sys.argv[3] == 'check':
    bad = 0
    for name, f, a, b, n in FAULTS:
        if n != 1 or text(f).count(a) != 1 or a == b:
            print('NOT ONCE', name, n, text(f).count(a), a == b); bad += 1
    print(len(FAULTS), 'faults,', bad, 'bad')
    sys.exit(1 if bad else 0)
KEEP = None
if os.path.exists('/home/user/mut16/round%s-names.txt' % ROUND):
    KEEP = set(open('/home/user/mut16/round%s-names.txt' % ROUND).read().split())
BASE = {'lua': ('9135', '165', '4182', '4131', '4131', '0'), 'sqlite3': ('43876', '147', '12883', '12865', '12865', '0'), 'musl': ('37304', '1899', '8556', '8415', '8179', '25')}
CORPORA = open('/home/user/mut15/corpora.txt').read().strip().split('\n')
out = open('/home/user/mut16/results%s-%d.txt' % ('' if ROUND == '1' else ROUND, worker), 'w')
todo = [f for f in FAULTS if KEEP is None or f[0] in KEEP]
for index, (name, f, a, b, n) in enumerate(todo):
    if index % of != worker:
        continue
    source = open(SRC + f).read()
    assert source.count(a) == 1, (name, source.count(a))
    open(SRC + f, 'w').write(source.replace(a, b))
    t0 = time.time()
    build = subprocess.run(['./build.sh', '--config', 'Debug', '--jobs', '1'], cwd=TREE, capture_output=True, text=True)
    if build.returncode != 0:
        verdict = 'NOT BUILT ' + (build.stdout + build.stderr)[-300:].replace('\n', ' ')
    else:
        try:
            test = subprocess.run(['./build/compiler', 'test-checker', '--seed', '133', '--part', '5/8'], cwd=TREE, capture_output=True, text=True, timeout=900)
            first = (test.stderr.strip().split('\n') or [''])[0][:160]
            verdict = ('caught' if test.returncode != 0 else 'SURVIVED') + ' [status %d] %s' % (test.returncode, first)
        except subprocess.TimeoutExpired:
            verdict = 'TIMED OUT'
        told = []
        for line in (CORPORA if verdict.startswith('SURVIVED') else []):
            corpus, arguments = line.split(' ', 1)
            try:
                run = subprocess.run('./build/compiler measure-node-machine --shadow --passes 0 --window-contexts --list 3 ' + arguments, shell=True, cwd=TREE, capture_output=True, text=True, timeout=600)
                m = re.search(r'window contexts expressions=\d+ records=\d+ decided=(\d+) .*?of-them-refused=(\d+) differences=(\d+)', run.stdout)
                k = re.search(r"in place's calls: to-make=\d+ made=(\d+) with-every-argument's-conversion=(\d+) \([^)]*\) of-them-plain=(\d+) left-for-an-argument=(\d+)", run.stdout)
                got = (m.group(1), m.group(2)) + k.groups() if m and k else None
                same = run.returncode == 0 and got == BASE[corpus] and m.group(3) == '0'
                told.append('%s: %s status %d %s' % (corpus, 'same' if same else 'TOLD', run.returncode, ' '.join(got) if got else 'no line'))
            except subprocess.TimeoutExpired:
                told.append('%s: timed out' % corpus)
        verdict += ' || ' + '; '.join(told)
    out.write('%s: %s (%d s)\n' % (name, verdict, time.time() - t0)); out.flush()
    open(SRC + f, 'w').write(source)
out.write('done\n'); out.close()
