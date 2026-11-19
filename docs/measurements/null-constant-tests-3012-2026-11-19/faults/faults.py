#!/usr/bin/env python3
# faults.py WORKER OF [check]: the null constant's piece's faults (#3012, #3014, #3017), one at a time in the copy
# /home/user/mut16/treeWORKER: a text of the piece's code replaced by a faulty one, the Debug compiler built, the node
# machine's tests run (test-checker part 5 of 8), and for a fault the tests don't fail the piece's statements one at a
# time (probe4.py on null2.txt and null3.txt): whether any line differs from the base's. Worker WORKER of OF takes
# every OF-th fault. Results in /home/user/mut17/results-WORKER.txt. With `check`, only that every text is there once.
import os, re, subprocess, sys, time
worker, of = int(sys.argv[1]), int(sys.argv[2])
ROUND = os.environ.get('ROUND', '1')
TREE = '/home/user/mut16/tree%d' % worker
SRC = TREE + '/src/buster/compiler/'
FA = 'c_check_node_machine_facts.c'
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

# The census's test of the value.
WARNED = 'static bool node_census_null_warned('
F('warned-never', C, WARNED, 'result = check_warning_null_integer(s->program->types, destination, &value) && (value.flags & BUSTER_CHECK_LITERAL_ZERO) == 0;', 'result = false;')
F('warned-literals-too', C, WARNED, ' && (value.flags & BUSTER_CHECK_LITERAL_ZERO) == 0;', ';')
F('warned-literals-only', C, WARNED, '(value.flags & BUSTER_CHECK_LITERAL_ZERO) == 0;', '(value.flags & BUSTER_CHECK_LITERAL_ZERO) != 0;')
F('warned-any-kind-read', C, WARNED, 'node_view_has(s, source) && node_view_constant_kind(s, source) == CHECK_CONSTANT_INTEGER', 'node_view_has(s, source)')
F('warned-addresses-only', C, WARNED, 'node_view_constant_kind(s, source) == CHECK_CONSTANT_INTEGER', 'node_view_constant_kind(s, source) == CHECK_CONSTANT_ADDRESS')

# Its places.
TESTS = 'static bool node_census_constant_tests('
F('tests-no-store', C, TESTS, 'result = node_census_null_warned(s, slot == 1 ? b : a, node_view_converted(s, node, slot));', '')
F('tests-store-first-slot', C, TESTS, 'const uint32_t slot = op == CHECK_OP_ASSIGN ? 1 : 0;', 'const uint32_t slot = 0;')
F('tests-store-second-slot', C, TESTS, 'const uint32_t slot = op == CHECK_OP_ASSIGN ? 1 : 0;', 'const uint32_t slot = 1;')
F('tests-store-other-operand', C, TESTS, 'node_census_null_warned(s, slot == 1 ? b : a, node_view_converted(s, node, slot))', 'node_census_null_warned(s, slot == 1 ? a : b, node_view_converted(s, node, slot))')
F('tests-store-other-conversion', C, TESTS, 'node_view_converted(s, node, slot));', 'node_view_converted(s, node, 1 - slot));')
F('tests-store-own-type', C, TESTS, 'node_view_converted(s, node, slot));', 'node_view_type(s, node));')
F('tests-no-assign', C, TESTS, 'policy->non_literal_null && (op == CHECK_OP_ASSIGN || op == CHECK_OP_INITIALIZE || op == CHECK_OP_CONVERT) && !result', 'policy->non_literal_null && (op == CHECK_OP_INITIALIZE || op == CHECK_OP_CONVERT) && !result')
F('tests-no-convert', C, TESTS, 'policy->non_literal_null && (op == CHECK_OP_ASSIGN || op == CHECK_OP_INITIALIZE || op == CHECK_OP_CONVERT) && !result', 'policy->non_literal_null && (op == CHECK_OP_ASSIGN || op == CHECK_OP_INITIALIZE) && !result')
F('tests-no-initialize-node', C, TESTS, 'policy->non_literal_null && (op == CHECK_OP_ASSIGN || op == CHECK_OP_INITIALIZE || op == CHECK_OP_CONVERT) && !result', 'policy->non_literal_null && (op == CHECK_OP_ASSIGN || op == CHECK_OP_CONVERT) && !result')
F('tests-store-whatever-the-policy', C, TESTS, 'policy->non_literal_null && (op == CHECK_OP_ASSIGN || op == CHECK_OP_INITIALIZE || op == CHECK_OP_CONVERT) && !result', '(op == CHECK_OP_ASSIGN || op == CHECK_OP_INITIALIZE || op == CHECK_OP_CONVERT) && !result')
F('tests-no-arguments', C, TESTS, 'for (uint32_t i = 0; policy->non_literal_null && op == CHECK_OP_CALL && !result && i < graph->argument_counts[node]; i += 1)', 'for (uint32_t i = 0; policy->non_literal_null && op == CHECK_OP_CALL && !result && i < 0; i += 1)')
F('tests-first-argument-only', C, TESTS, 'for (uint32_t i = 0; policy->non_literal_null && op == CHECK_OP_CALL && !result && i < graph->argument_counts[node]; i += 1)', 'for (uint32_t i = 0; policy->non_literal_null && op == CHECK_OP_CALL && !result && i < graph->argument_counts[node] && i < 1; i += 1)')
F('tests-arguments-whatever-the-policy', C, TESTS, 'for (uint32_t i = 0; policy->non_literal_null && op == CHECK_OP_CALL && !result', 'for (uint32_t i = 0; op == CHECK_OP_CALL && !result')
F('tests-argument-first-conversion', C, TESTS, 'graph->argument_offsets[node] + i], node_view_argument_converted(s, node, i));', 'graph->argument_offsets[node] + i], node_view_argument_converted(s, node, 0));')
F('tests-argument-first-node', C, TESTS, 'graph->argument_nodes[graph->argument_offsets[node] + i], node_view_argument_converted', 'graph->argument_nodes[graph->argument_offsets[node]], node_view_argument_converted')

# An initializer's root, and its span after the pipeline.
ROOT = 'static uint64_t node_census_root_tests('
F('root-no-null', C, ROOT, 'tests |= s->policy.non_literal_null && declared != 0 && node_census_null_warned(s, root, declared) ? UINT64_C(1) << NODE_CENSUS_CONSTANT : 0;', '')
F('root-null-whatever-the-policy', C, ROOT, 'tests |= s->policy.non_literal_null && declared != 0 && node_census_null_warned', 'tests |= declared != 0 && node_census_null_warned')
F('root-null-no-declared-test', C, ROOT, 'tests |= s->policy.non_literal_null && declared != 0 && node_census_null_warned', 'tests |= s->policy.non_literal_null && node_census_null_warned')
F('root-span-nodes-only', C, ROOT, 'const uint32_t low = node_census_initializer_low(lowest, context != NODE_CENSUS_ROOT_INITIALIZER || given ? BUSTER_CHECK_NONE : node_census_initialized_token(s, root));', 'const uint32_t low = lowest;')
F('root-span-every-root', C, ROOT, 'context != NODE_CENSUS_ROOT_INITIALIZER || given ? BUSTER_CHECK_NONE : node_census_initialized_token(s, root)', 'given ? BUSTER_CHECK_NONE : node_census_initialized_token(s, root)')
F('root-span-given-too', C, ROOT, 'context != NODE_CENSUS_ROOT_INITIALIZER || given ? BUSTER_CHECK_NONE : node_census_initialized_token(s, root)', 'context != NODE_CENSUS_ROOT_INITIALIZER ? BUSTER_CHECK_NONE : node_census_initialized_token(s, root)')
F('root-events-from-nodes', C, ROOT, 's->event_prefix[highest + 1] != s->event_prefix[low];', 's->event_prefix[highest + 1] != s->event_prefix[lowest];')
F('root-span-kept-nodes', C, ROOT, 's->span_low = low;', 's->span_low = lowest;')
LOW = 'static inline uint32_t node_census_initializer_low('
F('low-from-the-name', C, LOW, 'declaration + 1 < lowest ? declaration + 1 : lowest', 'declaration + 1 < lowest ? declaration : lowest')
F('low-two-past-the-name', C, LOW, 'declaration + 1 < lowest ? declaration + 1 : lowest', 'declaration + 1 < lowest ? declaration + 2 : lowest')
F('low-always-the-name', C, LOW, 'declaration != BUSTER_CHECK_NONE && declaration + 1 < lowest ? declaration + 1 : lowest', 'declaration != BUSTER_CHECK_NONE ? declaration + 1 : lowest')
F('low-no-none', C, LOW, 'declaration != BUSTER_CHECK_NONE && declaration + 1 < lowest', 'declaration + 1 < lowest')
TOKEN = 'static uint32_t node_census_initialized_token('
F('token-no-bound', C, TOKEN, 'return declaration < program->input->token_count ? declaration : BUSTER_CHECK_NONE;', 'return declaration;')

# The machine's own form.
ASKED = 'static inline bool node_tests_null_asked('
F('asked-any-target', C, ASKED, 'return pointer && (s->records->columns->value_flags[o] & BUSTER_CHECK_LITERAL_ZERO) == 0;', 'return (s->records->columns->value_flags[o] & BUSTER_CHECK_LITERAL_ZERO) == 0;')
F('asked-literals-too', C, ASKED, 'return pointer && (s->records->columns->value_flags[o] & BUSTER_CHECK_LITERAL_ZERO) == 0;', 'return pointer;')
F('asked-never', C, ASKED, 'return pointer && (s->records->columns->value_flags[o] & BUSTER_CHECK_LITERAL_ZERO) == 0;', 'return false;')
F('asked-no-target-test', C, ASKED, 'const bool pointer = target != 0 && (node_census_type_bits', 'const bool pointer = (node_census_type_bits')
CONSTANTS = 'static inline NodeTestsTrigger node_tests_constants('
F('own-store-not-sent', C, CONSTANTS, 'trigger = asked ? NODE_TESTS_TRIGGER_NULL_CONSTANT : trigger;', '')
F('own-store-any-constant', C, CONSTANTS, 'policy->non_literal_null && kinds[side] == CHECK_CONSTANT_INTEGER && node_tests_null_asked', 'policy->non_literal_null && node_tests_null_asked')
F('own-store-whatever-the-policy', C, CONSTANTS, 'policy->non_literal_null && kinds[side] == CHECK_CONSTANT_INTEGER && node_tests_null_asked', 'kinds[side] == CHECK_CONSTANT_INTEGER && node_tests_null_asked')
F('own-store-first-side', C, CONSTANTS, 'const uint32_t side = op == CHECK_OP_ASSIGN ? 1 : 0;\n        const bool asked', 'const uint32_t side = 0;\n        const bool asked')
F('own-store-first-conversion', C, CONSTANTS, 'node_tests_null_asked(s, o[side], columns->converted[2 * r + side]);', 'node_tests_null_asked(s, o[side], columns->converted[2 * r]);')
OPERATOR = 'static __attribute__((noinline)) uint64_t node_tests_operator('
F('own-call-not-sent', C, OPERATOR, 'trigger = (changes & BUSTER_NODE_TESTS_CONVERSION_ASKED) != 0 ? NODE_TESTS_TRIGGER_CONVERSION : nulls ? NODE_TESTS_TRIGGER_NULL_CONSTANT :\n                  enums', 'trigger = (changes & BUSTER_NODE_TESTS_CONVERSION_ASKED) != 0 ? NODE_TESTS_TRIGGER_CONVERSION :\n                  enums')
F('own-call-any-constant', C, OPERATOR, 'nulls |= policy->non_literal_null && kind == CHECK_CONSTANT_INTEGER && node_tests_null_asked(s, argument, target);', 'nulls |= policy->non_literal_null && kind != CHECK_CONSTANT_NONE && node_tests_null_asked(s, argument, target);')
F('own-call-whatever-the-policy', C, OPERATOR, 'nulls |= policy->non_literal_null && kind == CHECK_CONSTANT_INTEGER', 'nulls |= kind == CHECK_CONSTANT_INTEGER')
F('own-call-last-only', C, OPERATOR, 'nulls |= policy->non_literal_null && kind == CHECK_CONSTANT_INTEGER', 'nulls = policy->non_literal_null && kind == CHECK_CONSTANT_INTEGER')
OWNROOT = 'static inline uint64_t node_tests_root('
F('own-root-no-null', C, OWNROOT, 'tests |= null ? UINT64_C(1) << NODE_CENSUS_CONSTANT : 0;', '')
F('own-root-not-asked', C, OWNROOT, 'node_tests_null_asked(s, count - 1, declared) && node_census_null_warned(s, root, declared);', 'node_census_null_warned(s, root, declared);')
F('own-root-asked-is-warned', C, OWNROOT, 'node_tests_null_asked(s, count - 1, declared) && node_census_null_warned(s, root, declared);', 'node_tests_null_asked(s, count - 1, declared);')
F('own-root-any-constant', C, OWNROOT, 'const bool null = policy->non_literal_null && kind == CHECK_CONSTANT_INTEGER && node_tests_null_asked', 'const bool null = policy->non_literal_null && node_tests_null_asked')
F('own-root-whatever-the-policy', C, OWNROOT, 'const bool null = policy->non_literal_null && kind == CHECK_CONSTANT_INTEGER', 'const bool null = kind == CHECK_CONSTANT_INTEGER')

# The sweep's said values.
SWEEP = 'static inline __attribute__((always_inline)) void node_tests_window_bytes_by('
F('sweep-said-unheld-too', C, SWEEP, 'const __m512i said = _mm512_maskz_srli_epi32(held, standings, 16);', 'const __m512i said = _mm512_srli_epi32(standings, 16);')
F('sweep-held-wide-fields', C, SWEEP, '_mm512_set1_epi32(BUSTER_NODE_MACHINE_WIDE | BUSTER_NODE_MACHINE_FIELD));\n            const __m512i said', '_mm512_set1_epi32(BUSTER_NODE_MACHINE_WIDE));\n            const __m512i said')
F('sweep-held-wide-values', C, SWEEP, '_mm512_set1_epi32(BUSTER_NODE_MACHINE_WIDE | BUSTER_NODE_MACHINE_FIELD));\n            const __m512i said', '_mm512_set1_epi32(BUSTER_NODE_MACHINE_FIELD));\n            const __m512i said')
F('sweep-held-floating-only', C, SWEEP, '_mm512_set1_epi32(BUSTER_NODE_MACHINE_WIDE | BUSTER_NODE_MACHINE_FIELD));\n            const __m512i said', '_mm512_set1_epi32(BUSTER_NODE_MACHINE_WIDE | BUSTER_NODE_MACHINE_OFFSET));\n            const __m512i said')
F('sweep-held-none', C, SWEEP, 'const __m512i said = _mm512_maskz_srli_epi32(held, standings, 16);', 'const __m512i said = _mm512_maskz_srli_epi32((__mmask16)~held, standings, 16);')

# The kernel.
ARGUMENT = 'static inline __attribute__((always_inline)) void node_facts_argument('
F('kernel-large-unheld-quiet', FA, ARGUMENT, '(((uint32_t)argument->exponent - 1u > 126u) | unheld)', '((uint32_t)argument->exponent - 1u > 126u)')
F('kernel-large-unheld-offsets-only', FA, ARGUMENT, '((uint32_t)argument->standing & BUSTER_NODE_MACHINE_FIELD) != 0 ? 1u : 0u', '((uint32_t)argument->standing & BUSTER_NODE_MACHINE_OFFSET) != 0 ? 1u : 0u')
F('kernel-large-unheld-any-kind', FA, ARGUMENT, 'asked->large |= (kind == CHECK_CONSTANT_INTEGER) & (((uint32_t)argument->exponent - 1u > 126u) | unheld);', 'asked->large |= ((kind == CHECK_CONSTANT_INTEGER) & ((uint32_t)argument->exponent - 1u > 126u)) | unheld;')
MADE = 'static inline __attribute__((always_inline)) uint32_t node_facts_argument_made('
F('kernel-warned-never', FA, MADE, 'warned = pointer & (((standing >> 2) & 0x07u) == CHECK_CONSTANT_INTEGER ? 1u : 0u) & ((flags & BUSTER_CHECK_LITERAL_ZERO) == 0 ? 1u : 0u);', 'warned = 0;')
F('kernel-warned-any-target', FA, MADE, 'warned = pointer & (((standing >> 2) & 0x07u) == CHECK_CONSTANT_INTEGER ? 1u : 0u)', 'warned = (((standing >> 2) & 0x07u) == CHECK_CONSTANT_INTEGER ? 1u : 0u)')
F('kernel-warned-any-kind', FA, MADE, 'warned = pointer & (((standing >> 2) & 0x07u) == CHECK_CONSTANT_INTEGER ? 1u : 0u) & ', 'warned = pointer & ')
F('kernel-warned-literals-too', FA, MADE, ' & ((flags & BUSTER_CHECK_LITERAL_ZERO) == 0 ? 1u : 0u);', ';')
F('kernel-warned-rvalues-constant', FA, MADE, 'warned = pointer & (((standing >> 2) & 0x07u) == CHECK_CONSTANT_INTEGER ? 1u : 0u)', 'warned = pointer & (constant == CHECK_CONSTANT_INTEGER ? 1u : 0u)')
F('kernel-quiet-always', FA, MADE, '(warned == 0 ? BUSTER_NODE_FACTS_ARGUMENT_QUIET : 0u)', 'BUSTER_NODE_FACTS_ARGUMENT_QUIET')
F('kernel-quiet-never', FA, MADE, '(warned == 0 ? BUSTER_NODE_FACTS_ARGUMENT_QUIET : 0u)', '0u')
ARGUMENTS = 'static inline __attribute__((always_inline)) uint32_t node_facts_call_arguments('
F('kernel-outcome-starts-loud', FA, ARGUMENTS, ' | BUSTER_NODE_FACTS_ARGUMENT_PLAIN | BUSTER_NODE_FACTS_ARGUMENT_QUIET;', ' | BUSTER_NODE_FACTS_ARGUMENT_PLAIN;')
CALLS = 'static inline __attribute__((always_inline)) void node_facts_calls_of('
F('kernel-loud-never', FA, CALLS, 'const uint32_t loud = (outcome & BUSTER_NODE_FACTS_ARGUMENT_QUIET) == 0 ? (uint32_t)BUSTER_NODE_FACTS_QUIET_CALL : 0u;', 'const uint32_t loud = 0u;')
F('kernel-loud-always', FA, CALLS, 'const uint32_t loud = (outcome & BUSTER_NODE_FACTS_ARGUMENT_QUIET) == 0 ? (uint32_t)BUSTER_NODE_FACTS_QUIET_CALL : 0u;', 'const uint32_t loud = (uint32_t)BUSTER_NODE_FACTS_QUIET_CALL;')
F('kernel-loud-not-cleared', FA, CALLS, 'records[w].exponent = (uint16_t)((records[w].exponent & ~loud) | says);', 'records[w].exponent = (uint16_t)(records[w].exponent | says);')
F('kernel-says-lean-too', FA, CALLS, 'const uint32_t says = lean ? 0u : node_facts_call_says(outcome, row->function);', 'const uint32_t says = node_facts_call_says(outcome, row->function);')
F('kernel-says-never', FA, CALLS, 'const uint32_t says = lean ? 0u : node_facts_call_says(outcome, row->function);', 'const uint32_t says = 0u;')
P('kernel-key-no-literal', FA, 'BUSTER_CHECK_GNU_ICE_FORM | BUSTER_CHECK_NULL_POINTER | BUSTER_CHECK_LITERAL_ZERO | \\\n', 'BUSTER_CHECK_GNU_ICE_FORM | BUSTER_CHECK_NULL_POINTER | \\\n')
OPERAND = 'static inline __attribute__((always_inline)) bool node_facts_operand('
F('kernel-operand-foreign-taken', FA, OPERAND, ' && (standing & BUSTER_NODE_MACHINE_WIDE) == 0 && !foreign;', ' && (standing & BUSTER_NODE_MACHINE_WIDE) == 0;')
F('kernel-operand-foreign-any-kind', FA, OPERAND, 'const bool foreign = constant_kind == CHECK_CONSTANT_INTEGER && (standing & BUSTER_NODE_MACHINE_FIELD) != 0;', 'const bool foreign = (standing & BUSTER_NODE_MACHINE_FIELD) != 0;')
F('kernel-operand-foreign-offsets-only', FA, OPERAND, 'const bool foreign = constant_kind == CHECK_CONSTANT_INTEGER && (standing & BUSTER_NODE_MACHINE_FIELD) != 0;', 'const bool foreign = constant_kind == CHECK_CONSTANT_INTEGER && (standing & BUSTER_NODE_MACHINE_OFFSET) != 0;')

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
if os.path.exists('/home/user/mut17/round%s-names.txt' % ROUND):
    KEEP = set(open('/home/user/mut17/round%s-names.txt' % ROUND).read().split())
PROBES = '/home/user/keep/null/probes'
def probes(compiler):
    lines = []
    for name in ['null2.txt', 'null3.txt']:
        run = subprocess.run(['python3', PROBES + '/probe4.py', compiler, name], cwd='/home/user/mut17/probe%d' % worker, capture_output=True, text=True, timeout=3000)
        lines += run.stdout.split('\n')
    return lines
out = open('/home/user/mut17/results%s-%d.txt' % ('' if ROUND == '1' else ROUND, worker), 'w')
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
                base_lines = open('/home/user/mut17/base-probes.txt').read().split('\n')
            try:
                got = probes(TREE + '/build/compiler')
                told = [l for l in got if l and l not in base_lines]
                verdict += ' || probes: %d lines not the base\'s%s' % (len(told), (': ' + told[0][:150]) if told else '')
            except subprocess.TimeoutExpired:
                verdict += ' || probes: timed out'
    out.write('%s: %s (%d s)\n' % (name, verdict, time.time() - t0)); out.flush()
    open(SRC + f, 'w').write(source)
out.write('done\n'); out.close()
