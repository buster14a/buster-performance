#!/usr/bin/env python3
# faults4.py WORKER OF [check]: the null constant's piece's faults (#3012, #3014, #3017), one at a time in the copy
# /home/user/mut18/treeWORKER: a text of the piece's code replaced by a faulty one, the Debug compiler built, the node
# machine's tests run (test-checker part 5 of 8), and for a fault the tests don't fail the piece's statements one at a
# time (probe4.py on null2.txt and null3.txt): whether any line differs from the base's. Worker WORKER of OF takes
# every OF-th fault. Results in /home/user/mut17/results4-WORKER.txt. A fault whose text is no longer in the sources is left out and named. With `check`, only that every text is there once.
import os, re, subprocess, sys, time
worker, of = int(sys.argv[1]), int(sys.argv[2])
ROUND = os.environ.get('ROUND', '1')
TREE = '/home/user/mut18/tree%d' % worker
SRC = TREE + '/src/buster/compiler/'
FA = 'c_check_node_machine_facts.c'
M = 'c_check_node_machine.c'
T = 'c_check_node_machine_type.c'
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



# The earlier rounds' faults that the final list has, each with its last text.
WARNED = 'static bool node_census_null_warned('
TESTS = 'static bool node_census_constant_tests('
ROOT = 'static uint64_t node_census_root_tests('
LOW = 'static inline uint32_t node_census_initializer_low('
TOKEN = 'static uint32_t node_census_initialized_token('
ASKED = 'static inline bool node_tests_null_asked('
CONSTANTS = 'static inline NodeTestsTrigger node_tests_constants('
OPERATOR = 'static __attribute__((noinline)) uint64_t node_tests_operator('
OWNROOT = 'static inline uint64_t node_tests_root('
SWEEP = 'static inline __attribute__((always_inline)) void node_tests_window_bytes_by('
ARGUMENT = 'static inline __attribute__((always_inline)) void node_facts_argument('
MADE = 'static inline __attribute__((always_inline)) uint32_t node_facts_argument_made('
ARGUMENTS = 'static inline __attribute__((always_inline)) uint32_t node_facts_call_arguments('
CALLS = 'static inline __attribute__((always_inline)) void node_facts_calls_of('
OPERAND = 'static inline __attribute__((always_inline)) bool node_facts_operand('
COUNT = 'static void node_census_count('

F('asked-any-target', C, ASKED, '(target_bits & BUSTER_NODE_CENSUS_TYPE_POINTER) != 0 && ', '((target_bits & BUSTER_NODE_CENSUS_TYPE_POINTER) != 0 || o != UINT32_MAX) && ')
F('asked-literals-too', C, ASKED, ' && (s->records->columns->value_flags[o] & BUSTER_CHECK_LITERAL_ZERO) == 0;', ' && (s->records->columns->value_flags[o] & BUSTER_CHECK_LITERAL_ZERO) <= BUSTER_CHECK_LITERAL_ZERO;')
F('asked-never', C, ASKED, '(target_bits & BUSTER_NODE_CENSUS_TYPE_POINTER) != 0 && ', '(target_bits & BUSTER_NODE_CENSUS_TYPE_POINTER) != 0 && o == UINT32_MAX && ')
F('event-none-found', C, COUNT, 'const uint32_t event = found < CHECK_WARNING_ID_COUNT ? found : CHECK_WARNING_ID_COUNT;', 'const uint32_t event = found < CHECK_WARNING_ID_COUNT && found == UINT32_MAX ? found : CHECK_WARNING_ID_COUNT;')
F('kernel-loud-not-cleared', FA, CALLS, 'records[w].exponent = (uint16_t)((records[w].exponent & ~loud) | says);', 'records[w].exponent = (uint16_t)((records[w].exponent & ~(loud & 0u)) | says);')
F('kernel-operand-foreign-taken', FA, OPERAND, ' && (standing & BUSTER_NODE_MACHINE_WIDE) == 0 && !foreign;', ' && (standing & BUSTER_NODE_MACHINE_WIDE) == 0 && !(foreign && a == UINT32_MAX);')
F('kernel-quiet-always', FA, MADE, '(warned == 0 ? BUSTER_NODE_FACTS_ARGUMENT_QUIET : 0u)', '(warned == 0 || g != UINT32_MAX ? BUSTER_NODE_FACTS_ARGUMENT_QUIET : 0u)')
F('kernel-quiet-never', FA, MADE, '(warned == 0 ? BUSTER_NODE_FACTS_ARGUMENT_QUIET : 0u)', '(warned == 0 && g == UINT32_MAX ? BUSTER_NODE_FACTS_ARGUMENT_QUIET : 0u)')
F('kernel-warned-rvalues-constant', FA, MADE, 'warned = pointer & (((standing >> 2) & 0x07u) == CHECK_CONSTANT_INTEGER ? 1u : 0u)', 'warned = pointer & (constant == CHECK_CONSTANT_INTEGER ? 1u : 0u)')
F('low-from-the-name', C, LOW, 'declaration != BUSTER_CHECK_NONE ? declaration + 1 : lowest', 'declaration != BUSTER_CHECK_NONE ? declaration : lowest')
F('low-no-none', C, LOW, 'declaration != BUSTER_CHECK_NONE ? declaration + 1 : lowest', 'declaration + 1')
F('low-three-past-the-name', C, LOW, 'declaration != BUSTER_CHECK_NONE ? declaration + 1 : lowest', 'declaration != BUSTER_CHECK_NONE ? declaration + 3 : lowest')
F('low-two-past-the-name', C, LOW, 'declaration != BUSTER_CHECK_NONE ? declaration + 1 : lowest', 'declaration != BUSTER_CHECK_NONE ? declaration + 2 : lowest')
F('own-call-first-only', C, OPERATOR, 'nulls |= policy->non_literal_null && kind == CHECK_CONSTANT_INTEGER', 'nulls |= i == 0 && policy->non_literal_null && kind == CHECK_CONSTANT_INTEGER')
F('own-call-last-only', C, OPERATOR, 'nulls |= policy->non_literal_null && kind == CHECK_CONSTANT_INTEGER', 'nulls = policy->non_literal_null && kind == CHECK_CONSTANT_INTEGER')
F('own-call-not-sent', C, OPERATOR, 'NODE_TESTS_TRIGGER_CONVERSION : nulls ? NODE_TESTS_TRIGGER_NULL_CONSTANT :', 'NODE_TESTS_TRIGGER_CONVERSION : nulls && r == UINT32_MAX ? NODE_TESTS_TRIGGER_NULL_CONSTANT :')
F('own-root-any-constant', C, OWNROOT, 'const bool asked = policy->non_literal_null && kind == CHECK_CONSTANT_INTEGER && node_tests_null_asked', 'const bool asked = policy->non_literal_null && kind != CHECK_CONSTANT_NONE && node_tests_null_asked')
F('own-root-asked-is-warned', C, OWNROOT, 'tests |= asked && node_census_null_warned(s, root, declared) ? UINT64_C(1) << NODE_CENSUS_CONSTANT : 0;', 'tests |= asked ? UINT64_C(1) << NODE_CENSUS_CONSTANT : 0;')
F('own-root-no-null', C, OWNROOT, 'tests |= asked && node_census_null_warned(s, root, declared) ? UINT64_C(1) << NODE_CENSUS_CONSTANT : 0;', 'tests |= asked && count == 0 && node_census_null_warned(s, root, declared) ? UINT64_C(1) << NODE_CENSUS_CONSTANT : 0;')
F('own-root-not-asked', C, OWNROOT, 'const bool asked = policy->non_literal_null && kind == CHECK_CONSTANT_INTEGER && node_tests_null_asked(s, count - 1, node_census_type_bits(s, declared));', 'const bool asked = policy->non_literal_null && kind == CHECK_CONSTANT_INTEGER;')
F('own-root-not-counted', C, OWNROOT, 'counts->own_root_nulls += asked;', 'counts->own_root_nulls += asked && count == 0;')
F('own-root-whatever-the-policy', C, OWNROOT, 'const bool asked = policy->non_literal_null && kind == CHECK_CONSTANT_INTEGER && node_tests_null_asked', 'const bool asked = kind == CHECK_CONSTANT_INTEGER && node_tests_null_asked')
F('own-store-any-constant', C, CONSTANTS, 'policy->non_literal_null && kinds[side] == CHECK_CONSTANT_INTEGER && node_tests_null_asked', 'policy->non_literal_null && kinds[side] != CHECK_CONSTANT_NONE && node_tests_null_asked')
F('own-store-first-side', C, CONSTANTS, 'const uint32_t side = op == CHECK_OP_ASSIGN ? 1 : 0;\n        const bool asked', 'const uint32_t side = 0;\n        const bool asked')
F('own-store-not-sent', C, CONSTANTS, 'trigger = asked ? NODE_TESTS_TRIGGER_NULL_CONSTANT : trigger;', 'trigger = asked && r == UINT32_MAX ? NODE_TESTS_TRIGGER_NULL_CONSTANT : trigger;')
F('root-events-from-nodes', C, ROOT, 's->event_prefix[highest + 1] != s->event_prefix[low];', 's->event_prefix[highest + 1] != s->event_prefix[lowest];')
F('root-no-null', C, ROOT, 'tests |= s->policy.non_literal_null && node_census_null_warned(s, root, declared) ? UINT64_C(1) << NODE_CENSUS_CONSTANT : 0;', '')
F('root-null-whatever-the-policy', C, ROOT, 'tests |= s->policy.non_literal_null && node_census_null_warned', 'tests |= node_census_null_warned')
F('root-span-every-root', C, ROOT, 'context != NODE_CENSUS_ROOT_INITIALIZER || given ? BUSTER_CHECK_NONE : node_census_initialized_token(s, root)', 'given ? BUSTER_CHECK_NONE : node_census_initialized_token(s, root)')
F('root-span-kept-nodes', C, ROOT, 's->span_low = low;', 's->span_low = lowest;')
F('root-span-nodes-only', C, ROOT, 'const uint32_t low = node_census_initializer_low(lowest, context != NODE_CENSUS_ROOT_INITIALIZER || given ? BUSTER_CHECK_NONE : node_census_initialized_token(s, root));', 'const uint32_t low = lowest;')
F('sweep-held-none', C, SWEEP, 'const __m512i said = _mm512_maskz_srli_epi32(held, standings, 16);', 'const __m512i said = _mm512_maskz_srli_epi32((__mmask16)~held, standings, 16);')
F('sweep-held-offsets', C, SWEEP, '_mm512_set1_epi32(BUSTER_NODE_MACHINE_FLOATING));\n            const __m512i said', '_mm512_set1_epi32(BUSTER_NODE_MACHINE_OFFSET));\n            const __m512i said')
F('sweep-said-unheld-too', C, SWEEP, 'const __m512i said = _mm512_maskz_srli_epi32(held, standings, 16);', 'const __m512i said = _mm512_maskz_srli_epi32((__mmask16)(held | 0xffffu), standings, 16);')
F('tests-no-initialize-node', C, TESTS, 'policy->non_literal_null && (op == CHECK_OP_ASSIGN || op == CHECK_OP_INITIALIZE || op == CHECK_OP_CONVERT) && !result', 'policy->non_literal_null && (op == CHECK_OP_ASSIGN || op == CHECK_OP_CONVERT) && !result')
F('tests-no-store', C, TESTS, 'result = node_census_null_warned(s, slot == 1 ? b : a, node_view_converted(s, node, slot));', 'result = node_census_null_warned(s, slot == 1 ? b : a, node_view_converted(s, node, slot)) && slot > 1;')
F('tests-store-own-type', C, TESTS, 'node_view_converted(s, node, slot));', 'node_view_type(s, node));')
F('warned-literals-only', C, WARNED, '(value.flags & BUSTER_CHECK_LITERAL_ZERO) == 0;', '(value.flags & BUSTER_CHECK_LITERAL_ZERO) != 0;')
F('warned-literals-too', C, WARNED, ' && (value.flags & BUSTER_CHECK_LITERAL_ZERO) == 0;', ';')
F('warned-never', C, WARNED, '(value.flags & BUSTER_CHECK_LITERAL_ZERO) == 0;', '(value.flags & BUSTER_CHECK_LITERAL_ZERO) == 0 && source == UINT32_MAX;')

# Round 4: the writer's rule (#3014's second form), on the final sources with every earlier fault whose text is still there.
WHOLE = 'static inline bool node_machine_whole('
F('whole-old-rule', M, WHOLE, 'return kind == CHECK_CONSTANT_INTEGER ? fields == (low != 0 ? 1u : 0u) : fields <= 1;', 'return fields <= 1;')
F('whole-kind-swapped', M, WHOLE, 'return kind == CHECK_CONSTANT_INTEGER ? fields ==', 'return kind != CHECK_CONSTANT_INTEGER ? fields ==')
F('whole-integers-none', M, WHOLE, 'fields == (low != 0 ? 1u : 0u)', 'fields == 0u')
F('whole-floating-constants-too', M, WHOLE, 'return kind == CHECK_CONSTANT_INTEGER ? fields ==', 'return kind == CHECK_CONSTANT_INTEGER || kind == CHECK_CONSTANT_FLOATING ? fields ==')
F('whole-always', M, WHOLE, 'return kind == CHECK_CONSTANT_INTEGER ? fields == (low != 0 ? 1u : 0u) : fields <= 1;', 'return fields <= 3;')
PUT = 'static void node_machine_put_value('
F('put-old-rule', T, PUT, 'const bool whole = !rare && node_machine_whole(kind, low, offset, floating);', 'const bool whole = !rare && (low != 0) + (offset != 0) + floating <= 1;')
LINE = 'static bool node_facts_value_line('
F('line-old-rule', FA, LINE, 'return !rare && node_machine_whole(kind, low, offset, floating);', 'return !rare && (low != 0) + (offset != 0) + floating <= 1;')

names = [f[0] for f in FAULTS]
DROPPED = [f[0] for f in FAULTS if f[4] != 1 or f[2] == f[3]]
FAULTS = [f for f in FAULTS if f[4] == 1 and f[2] != f[3]]
assert len(set(names)) == len(names), [n for n in names if names.count(n) > 1]
if len(sys.argv) > 3 and sys.argv[3] == 'check':
    bad = 0
    for name, f, a, b, n in FAULTS:
        if n != 1 or text(f).count(a) != 1 or a == b:
            print('NOT ONCE', name, n, text(f).count(a), a == b); bad += 1
    print(len(FAULTS), 'faults,', bad, 'bad; left out:', ' '.join(DROPPED))
    sys.exit(1 if bad else 0)
KEEP = None
if os.path.exists('/home/user/mut17/round4-names.txt'):
    KEEP = set(open('/home/user/mut17/round4-names.txt').read().split())
PROBES = '/home/user/keep/null/probes'
def probes(compiler):
    lines = []
    for name in ['null2.txt', 'null3.txt']:
        run = subprocess.run(['python3', PROBES + '/probe4.py', compiler, name], cwd='/home/user/mut17/probe%d' % worker, capture_output=True, text=True, timeout=3000)
        lines += run.stdout.split('\n')
    return lines
out = open('/home/user/mut17/results4-%d.txt' % worker, 'w')
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
                base_lines = open('/home/user/mut17/base4-probes.txt').read().split('\n')
            try:
                got = probes(TREE + '/build/compiler')
                told = [l for l in got if l and l not in base_lines]
                verdict += ' || probes: %d lines not the base\'s%s' % (len(told), (': ' + told[0][:150]) if told else '')
            except subprocess.TimeoutExpired:
                verdict += ' || probes: timed out'
    out.write('%s: %s (%d s)\n' % (name, verdict, time.time() - t0)); out.flush()
    open(SRC + f, 'w').write(source)
out.write('done\n'); out.close()
