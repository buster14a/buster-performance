#!/usr/bin/env python3
# faults5.py WORKER OF [check]: the update piece's faults (#2850, an update on the window), one at a time in the copy
# /home/user/mut20/treeWORKER: a text of the piece's code replaced by a faulty one, the Debug compiler built, the node
# machine's tests run (test-checker part 5 of 8), and for a fault the tests don't fail the piece's statements one at a
# time (probe-u2.py on updates1.txt and updates2.txt, with the head's pointer to an int in a segment's space and with a
# plain one): whether any line differs from the base's. Worker WORKER of OF takes every OF-th fault. Results in
# /home/user/mut19/results5-WORKER.txt. With `check`, only that every text is in its file once.
import os, subprocess, sys, time
worker, of = int(sys.argv[1]), int(sys.argv[2])
ROUND = os.environ.get('ROUND', '1')
TREE = '/home/user/mut20/tree%d' % worker
SRC = TREE + '/src/buster/compiler/'
W = 'c_check_node_machine_window.c'
C = 'c_check_node_census.c'
texts = {}
def text(f):
    if f not in texts:
        texts[f] = open(SRC + f).read()
    return texts[f]
FAULTS = []
def P(name, f, a, b):
    FAULTS.append((name, f, a, b, text(f).count(a)))

# The operators' classes' table.
P('class-no-place', W, "class = update ? BUSTER_NODE_CONTEXTS_CLASS_UPDATE | BUSTER_NODE_CONTEXTS_CLASS_PLACE | increment | quotient :",
  "class = update ? BUSTER_NODE_CONTEXTS_CLASS_UPDATE | increment | quotient :")
P('class-increment-none', W, "const uint8_t increment = op <= CHECK_OP_POST_DECREMENT ? BUSTER_NODE_CONTEXTS_CLASS_INCREMENT : 0;", "const uint8_t increment = 0;")
P('class-increment-wide', W, "const uint8_t increment = op <= CHECK_OP_POST_DECREMENT ?", "const uint8_t increment = op <= CHECK_OP_ADD_ASSIGN ?")
P('class-increment-narrow', W, "const uint8_t increment = op <= CHECK_OP_POST_DECREMENT ?", "const uint8_t increment = op <= CHECK_OP_POST_INCREMENT ?")
P('class-quotient-none', W, "op == CHECK_OP_DIVIDE_ASSIGN || op == CHECK_OP_REMAINDER_ASSIGN ? BUSTER_NODE_CONTEXTS_CLASS_QUOTIENT : 0;", "0;")
P('class-quotient-divide-only', W, "op == CHECK_OP_DIVIDE_ASSIGN || op == CHECK_OP_REMAINDER_ASSIGN ? BUSTER_NODE_CONTEXTS_CLASS_QUOTIENT", "op == CHECK_OP_DIVIDE_ASSIGN ? BUSTER_NODE_CONTEXTS_CLASS_QUOTIENT")
P('class-quotient-remainder-only', W, "op == CHECK_OP_DIVIDE_ASSIGN || op == CHECK_OP_REMAINDER_ASSIGN ? BUSTER_NODE_CONTEXTS_CLASS_QUOTIENT", "op == CHECK_OP_REMAINDER_ASSIGN ? BUSTER_NODE_CONTEXTS_CLASS_QUOTIENT")
# An update's operands' rows.
ROW0 = "tables->rows[key << 1] = (bits & BUSTER_NODE_CONTEXTS_KEY_ADDRESS) != 0 ? BUSTER_NODE_CONTEXTS_EVALUATES | BUSTER_NODE_CONTEXTS_SOURCE_NONE : 0;"
P('row-address-none', W, ROW0, "tables->rows[key << 1] = 0;")
P('row-name-evaluated', W, ROW0, "tables->rows[key << 1] = BUSTER_NODE_CONTEXTS_EVALUATES | BUSTER_NODE_CONTEXTS_SOURCE_NONE;")
P('row-address-given', W, ROW0, "tables->rows[key << 1] = (bits & BUSTER_NODE_CONTEXTS_KEY_ADDRESS) != 0 ? BUSTER_NODE_CONTEXTS_EVALUATES | BUSTER_NODE_CONTEXTS_SOURCE_GIVEN : 0;")
ROW1 = "(bits & BUSTER_NODE_CONTEXTS_KEY_POINTER) != 0 ? BUSTER_NODE_CONTEXTS_SOURCE_LONG : BUSTER_NODE_CONTEXTS_SOURCE_GIVEN"
P('row-second-long-always', W, ROW1, "BUSTER_NODE_CONTEXTS_SOURCE_LONG")
P('row-second-given-always', W, ROW1, "BUSTER_NODE_CONTEXTS_SOURCE_GIVEN")
P('row-second-unevaluated', W, "tables->rows[(key << 1) + 1] = BUSTER_NODE_CONTEXTS_EVALUATES | ((bits", "tables->rows[(key << 1) + 1] = ((bits")
P('row-keys-short', W, "bits <= (BUSTER_NODE_CONTEXTS_KEY_ADDRESS | BUSTER_NODE_CONTEXTS_KEY_POINTER); bits +=", "bits < BUSTER_NODE_CONTEXTS_KEY_POINTER; bits +=")
# A far consumer's key and a far destination's standing.
FA = "const uint32_t address_bit = (front->ops[destination] & 0x7f) != CHECK_OP_VALUE ? BUSTER_NODE_CONTEXTS_KEY_ADDRESS : 0u;"
P('far-key-address-named', W, FA, "const uint32_t address_bit = (front->ops[destination] & 0x7f) == CHECK_OP_VALUE ? BUSTER_NODE_CONTEXTS_KEY_ADDRESS : 0u;")
P('far-key-no-address', W, FA, "const uint32_t address_bit = (front->ops[destination] & 0x7f) != CHECK_OP_VALUE ? 0u : 0u;")
P('far-key-address-always', W, FA, "const uint32_t address_bit = (front->ops[destination] & 0x7f) != CHECK_OP_VALUE ? BUSTER_NODE_CONTEXTS_KEY_ADDRESS : BUSTER_NODE_CONTEXTS_KEY_ADDRESS;")
P('far-key-template', W, "template != BUSTER_NODE_MACHINE_TEMPLATE_UPDATE ? template : (uint8_t)(BUSTER_NODE_MACHINE_TEMPLATE_UPDATE + address_bit);",
  "template != BUSTER_NODE_MACHINE_TEMPLATE_UPDATE ? template : (uint8_t)(BUSTER_NODE_MACHINE_TEMPLATE_UPDATE + 0u * address_bit);")
P('far-key-own-record', W, "const uint32_t destination = consumer - front->window_left[consumer];", "const uint32_t destination = consumer;")
# The loop's masks.
DIV = "const __mmask64 update_divisor = integral & right_constant & _mm512_test_epi8_mask(classes, _mm512_set1_epi8(BUSTER_NODE_CONTEXTS_CLASS_QUOTIENT));"
P('divisor-any-class', W, DIV, "const __mmask64 update_divisor = right_constant & _mm512_test_epi8_mask(classes, _mm512_set1_epi8(BUSTER_NODE_CONTEXTS_CLASS_QUOTIENT));")
P('divisor-any-operand', W, DIV, "const __mmask64 update_divisor = integral & _mm512_test_epi8_mask(classes, _mm512_set1_epi8(BUSTER_NODE_CONTEXTS_CLASS_QUOTIENT));")
P('divisor-none', W, DIV, "const __mmask64 update_divisor = 0;")
ASK = "const __mmask64 update_asked = free & is_update & numeric & ~update_divisor;"
P('asked-not-free', W, ASK, "const __mmask64 update_asked = is_update & numeric & ~update_divisor;")
P('asked-any-class', W, ASK, "const __mmask64 update_asked = free & is_update & ~update_divisor;")
P('asked-divisor', W, ASK, "const __mmask64 update_asked = free & is_update & numeric;")
P('asked-every-operator', W, ASK, "const __mmask64 update_asked = free & (is_update | ~is_update) & numeric & ~update_divisor;")
P('increment-inverted', W, "const __mmask64 increment = _mm512_test_epi8_mask(classes,", "const __mmask64 increment = _mm512_testn_epi8_mask(classes,")
MASKED = "const __mmask64 update_masked = update_asked & ~left_atomic & ~(left_named & left_register) & (increment | left_pointer | right_scalar);"
def M(name, a, b):
    assert MASKED.count(a) == 1, (name, a)
    P(name, W, MASKED, MASKED.replace(a, b))
M('atomic-taken', " & ~left_atomic", "")
M('register-any-destination', "~(left_named & left_register)", "~(left_register | (left_named & ~left_named))")
M('register-taken', "~(left_named & left_register)", "~(left_named & left_register & ~left_register)")
M('named-never', "~(left_named & left_register)", "~(left_named | (left_register & ~left_register))")
M('second-any', "(increment | left_pointer | right_scalar)", "(increment | ~increment)")
M('second-no-increment', "(increment | left_pointer | right_scalar)", "((increment & ~increment) | left_pointer | right_scalar)")
M('second-no-pointer', "(increment | left_pointer | right_scalar)", "(increment | right_scalar)")
M('second-no-class', "(increment | left_pointer | right_scalar)", "(increment | left_pointer)")
P('register-own-flags', W, "const __mmask64 left_register = _mm512_test_epi8_mask(left_flags,", "const __mmask64 left_register = _mm512_test_epi8_mask(flags,")
P('named-own-code', W, "const __mmask64 left_named = _mm512_cmpeq_epi8_mask(left_codes, _mm512_set1_epi8(CHECK_OP_VALUE));", "const __mmask64 left_named = _mm512_cmpeq_epi8_mask(codes, _mm512_set1_epi8(CHECK_OP_VALUE));")
# The strides' loop, the spaces' and what they give.
POINTED = "uint64_t pointed = (sums & left_pointer & ~right_pointer) | (update_masked & left_pointer);"
P('stride-no-update', W, POINTED, "uint64_t pointed = sums & left_pointer & ~right_pointer;")
P('stride-every-update', W, POINTED, "uint64_t pointed = (sums & left_pointer & ~right_pointer) | update_masked;")
SPACE = "spaced |= (uint64_t)(check_lower_segment_override(state->facts.machine->types, stored) != 0 ? 1 : 0) << lane;"
P('space-inverted', W, SPACE, "spaced |= (uint64_t)(check_lower_segment_override(state->facts.machine->types, stored) != 0 ? 0 : 1) << lane;")
P('space-first-lane', W, SPACE, "spaced |= (uint64_t)(check_lower_segment_override(state->facts.machine->types, stored) != 0 ? 1 : 0);")
P('space-own-record', W, "const TypeId stored = state->facts.records[x + lane - front->window_left[x + lane]].type;", "const TypeId stored = state->facts.records[x + lane].type;")
P('space-never', W, "if (__builtin_expect(extended, 0))", "if (__builtin_expect(extended && x > count, 0))")
P('space-always', W, "if (__builtin_expect(extended, 0))", "if (__builtin_expect(extended || x <= count, 0))")
MADE = "const __mmask64 made_update = _cvtu64_mask64(update_masked & ~spaced & (~(uint64_t)left_pointer | pointed));"
P('space-not-applied', W, MADE, "const __mmask64 made_update = _cvtu64_mask64(update_masked & ~(spaced & ~spaced) & (~(uint64_t)left_pointer | pointed));")
P('stride-not-applied', W, MADE, "const __mmask64 made_update = _cvtu64_mask64(update_masked & ~spaced);")
P('count-asked-masked', W, "updates += (uint64_t)_mm_popcnt_u64(update_asked);", "updates += (uint64_t)_mm_popcnt_u64(update_masked);")
P('count-taken-masked', W, "updates_taken += (uint64_t)_mm_popcnt_u64(made_update);", "updates_taken += (uint64_t)_mm_popcnt_u64(update_masked);")
P('listed-not', W, " |\n                                           (update_asked & ~made_update));", ");")
# The template and the keys.
P('template-none', W, "const __m512i templates = _mm512_mask_mov_epi8(called_templates, made_update, _mm512_set1_epi8(BUSTER_NODE_MACHINE_TEMPLATE_UPDATE));", "const __m512i templates = called_templates;")
P('key-no-address', W, "_mm512_mask_add_epi8(templates, made_update & ~left_named, templates,", "_mm512_mask_add_epi8(templates, 0, templates,")
P('key-address-named', W, "_mm512_mask_add_epi8(templates, made_update & ~left_named, templates,", "_mm512_mask_add_epi8(templates, made_update & left_named, templates,")
P('key-address-every-record', W, "_mm512_mask_add_epi8(templates, made_update & ~left_named, templates,", "_mm512_mask_add_epi8(templates, ~left_named, templates,")
P('key-no-pointer', W, "_mm512_mask_add_epi8(placed_keys, made_update & left_pointer, placed_keys,", "_mm512_mask_add_epi8(placed_keys, 0, placed_keys,")
P('key-pointer-every-record', W, "_mm512_mask_add_epi8(placed_keys, made_update & left_pointer, placed_keys,", "_mm512_mask_add_epi8(placed_keys, left_pointer, placed_keys,")
P('next-keys-templates', W, "next_keys = keys;", "next_keys = templates;")
P('near-keys-templates', W, "const __m512i near_keys = _mm512_maskz_permutex2var_epi8(near_up, keys, at_up, next_keys);", "const __m512i near_keys = _mm512_maskz_permutex2var_epi8(near_up, templates, at_up, next_keys);")
P('counts-swapped', W, "counts[NODE_FACTS_COUNT_CONTEXTS_UPDATES] += loop_counts.updates;", "counts[NODE_FACTS_COUNT_CONTEXTS_UPDATES] += loop_counts.updates_taken;")
# The flags' byte's register bit.
REG = "const __mmask16 register_object = _mm512_test_epi32_mask(flags, _mm512_set1_epi32((int32_t)BUSTER_CHECK_REGISTER));"
P('register-bit-name-flag', C, REG, "const __mmask16 register_object = _mm512_test_epi32_mask(flags, _mm512_set1_epi32((int32_t)BUSTER_CHECK_REGISTER_NAME));")
P('register-bit-none', C, REG, "const __mmask16 register_object = 0;")
P('register-bit-every-record', C, REG, "const __mmask16 register_object = placed;")

names = [f[0] for f in FAULTS]
assert len(set(names)) == len(names), [n for n in names if names.count(n) > 1]
if len(sys.argv) > 3 and sys.argv[3] == 'check':
    bad = 0
    for name, f, a, b, n in FAULTS:
        if n != 1 or a == b:
            print('NOT ONCE', name, n, a == b); bad += 1
    print(len(FAULTS), 'faults,', bad, 'bad')
    sys.exit(1 if bad else 0)
KEEP = None
if os.path.exists('/home/user/mut19/round%s-names.txt' % ROUND):
    KEEP = set(open('/home/user/mut19/round%s-names.txt' % ROUND).read().split())
PROBES = '/home/user/keep/next/probes'
def probes(compiler):
    lines = []
    work = '/home/user/mut19/probe%d' % worker
    os.makedirs(work, exist_ok=True)
    for name in ['updates1.txt', 'updates2.txt']:
        for flat in ([], ['--flat']):
            run = subprocess.run(['python3', PROBES + '/probe-u2.py', compiler, PROBES + '/' + name] + flat, cwd=work, capture_output=True, text=True, timeout=3000)
            lines += [('flat ' if flat else 'spaced ') + l for l in run.stdout.split('\n') if l]
    return lines
if len(sys.argv) > 3 and sys.argv[3] == 'base':
    open('/home/user/mut19/base%s-probes.txt' % ROUND, 'w').write('\n'.join(probes(TREE + '/build/compiler')) + '\n')
    sys.exit(0)
out = open('/home/user/mut19/results%s-%d.txt' % (ROUND, worker), 'w')
todo = [f for f in FAULTS if KEEP is None or f[0] in KEEP]
base_lines = None
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
            test = subprocess.run(['./build/compiler', 'test-checker', '--seed', '133', '--part', '5/8'], cwd=TREE, capture_output=True, text=True, timeout=1200)
            first = (test.stderr.strip().split('\n') or [''])[0][:160]
            verdict = ('caught' if test.returncode != 0 else 'SURVIVED') + ' [status %d] %s' % (test.returncode, first)
        except subprocess.TimeoutExpired:
            verdict = 'TIMED OUT'
        if verdict.startswith('SURVIVED'):
            if base_lines is None:
                base_lines = set(open('/home/user/mut19/base%s-probes.txt' % ROUND).read().split('\n'))
            try:
                got = probes(TREE + '/build/compiler')
                told = [l for l in got if l and l not in base_lines]
                verdict += ' || probes: %d lines not the base\'s%s' % (len(told), (': ' + told[0][:150]) if told else '')
            except subprocess.TimeoutExpired:
                verdict += ' || probes: timed out'
    out.write('%s: %s (%d s)\n' % (name, verdict, time.time() - t0)); out.flush()
    open(SRC + f, 'w').write(source)
out.write('done\n'); out.close()
