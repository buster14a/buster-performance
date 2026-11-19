#!/usr/bin/env python3
# faults6.py WORKER OF [check|base]: the branches piece's faults (#2850, a condition's branches on the window), one at a
# time in the copy /home/user/mut22/treeWORKER: a text of the piece's code replaced by a faulty one, the Debug compiler
# built, the node machine's tests run (test-checker part 5 of 8), and for a fault the tests don't fail the piece's
# statements one at a time (probe-b.py on branches1.txt, branches2.txt and branches3.txt, with the head's pointer to
# an int in a segment's space and with a plain one): whether any line differs from the base's. Worker WORKER of OF
# takes every OF-th fault. Results in /home/user/mut21/resultsROUND-WORKER.txt. With `check`, only that every text is
# in its file once; with `base`, the base's probes' lines.
import os, subprocess, sys, time
worker, of = int(sys.argv[1]), int(sys.argv[2])
ROUND = os.environ.get('ROUND', '1')
KEEP = set(os.environ['KEEP'].split(',')) if os.environ.get('KEEP') else None
TREE = '/home/user/mut22/tree%d' % worker
SRC = TREE + '/src/buster/compiler/'
PROBES = '/home/user/keep/br/probes'
W = 'c_check_node_machine_window.c'
texts = {}
def text(f):
    if f not in texts:
        texts[f] = open(SRC + f).read()
    return texts[f]
FAULTS = []
def P(name, f, a, b):
    FAULTS.append((name, f, a, b, text(f).count(a)))
def L(name, line, a, b):
    assert line.count(a) == 1, (name, a)
    P(name, W, line, line.replace(a, b))

# The operators' classes' table.
CL = "case CHECK_OP_LOGICAL_AND: case CHECK_OP_LOGICAL_OR: class = BUSTER_NODE_CONTEXTS_CLASS_LOGICAL; break;"
P('class-and-only', W, CL, "case CHECK_OP_LOGICAL_AND: class = BUSTER_NODE_CONTEXTS_CLASS_LOGICAL; break;")
P('class-or-only', W, CL, "case CHECK_OP_LOGICAL_OR: class = BUSTER_NODE_CONTEXTS_CLASS_LOGICAL; break;")
P('class-logical-conditional', W, CL, "case CHECK_OP_LOGICAL_AND: case CHECK_OP_LOGICAL_OR: class = BUSTER_NODE_CONTEXTS_CLASS_CONDITIONAL; break;")
P('class-conditional-logical', W, "case CHECK_OP_CONDITIONAL: class = BUSTER_NODE_CONTEXTS_CLASS_CONDITIONAL; break;", "case CHECK_OP_CONDITIONAL: class = BUSTER_NODE_CONTEXTS_CLASS_LOGICAL; break;")
P('class-condition-no-bit', W, "case CHECK_OP_CONDITION: class = BUSTER_NODE_CONTEXTS_CLASS_TRUTH | BUSTER_NODE_CONTEXTS_CLASS_CONDITION; break;",
  "case CHECK_OP_CONDITION: class = BUSTER_NODE_CONTEXTS_CLASS_TRUTH; break;")
P('class-not-condition-bit', W, "case CHECK_OP_NOT: class = BUSTER_NODE_CONTEXTS_CLASS_TRUTH; break;", "case CHECK_OP_NOT: class = BUSTER_NODE_CONTEXTS_CLASS_TRUTH | BUSTER_NODE_CONTEXTS_CLASS_CONDITION; break;")
P('class-comma-conditional', W, "case CHECK_OP_COMMA: case CHECK_OP_SELECT: class = BUSTER_NODE_CONTEXTS_CLASS_COMMA; break;",
  "case CHECK_OP_COMMA: case CHECK_OP_SELECT: class = BUSTER_NODE_CONTEXTS_CLASS_CONDITIONAL; break;")
# A branched operator's operands' rows.
R0 = "tables->rows[NODE_MACHINE_TEMPLATE_BRANCHES << 1] = given;"
R1 = "tables->rows[(NODE_MACHINE_TEMPLATE_BRANCHES << 1) + 1] = given;"
P('row-first-no-target', W, R0, "tables->rows[NODE_MACHINE_TEMPLATE_BRANCHES << 1] = BUSTER_NODE_CONTEXTS_EVALUATES | BUSTER_NODE_CONTEXTS_SOURCE_NONE;")
P('row-second-no-target', W, R1, "tables->rows[(NODE_MACHINE_TEMPLATE_BRANCHES << 1) + 1] = BUSTER_NODE_CONTEXTS_EVALUATES | BUSTER_NODE_CONTEXTS_SOURCE_NONE;")
P('row-first-node', W, R0, "tables->rows[NODE_MACHINE_TEMPLATE_BRANCHES << 1] = node;")
P('row-second-node', W, R1, "tables->rows[(NODE_MACHINE_TEMPLATE_BRANCHES << 1) + 1] = node;")
P('row-first-unevaluated', W, R0, "tables->rows[NODE_MACHINE_TEMPLATE_BRANCHES << 1] = BUSTER_NODE_CONTEXTS_SOURCE_GIVEN;")
P('row-second-unevaluated', W, R1, "tables->rows[(NODE_MACHINE_TEMPLATE_BRANCHES << 1) + 1] = BUSTER_NODE_CONTEXTS_SOURCE_GIVEN;")
P('row-second-long', W, R1, "tables->rows[(NODE_MACHINE_TEMPLATE_BRANCHES << 1) + 1] = BUSTER_NODE_CONTEXTS_EVALUATES | BUSTER_NODE_CONTEXTS_SOURCE_LONG;")
# A far first operand's standing.
FS = "far_bytes[BUSTER_NODE_CONTEXTS_FAR_LEFT_STANDING][lane] = state->window_c_standings[operand];"
P('far-standing-own', W, FS, "far_bytes[BUSTER_NODE_CONTEXTS_FAR_LEFT_STANDING][lane] = state->window_c_standings[x + lane];")
P('far-standing-none', W, FS, "far_bytes[BUSTER_NODE_CONTEXTS_FAR_LEFT_STANDING][lane] = 0;")
P('far-standing-not-read', W, "            left_standings = _mm512_mask_loadu_epi8(left_standings, far_left, far_bytes[BUSTER_NODE_CONTEXTS_FAR_LEFT_STANDING]);\n", "")
P('far-standing-flags', W, "left_standings = _mm512_mask_loadu_epi8(left_standings, far_left, far_bytes[BUSTER_NODE_CONTEXTS_FAR_LEFT_STANDING]);",
  "left_standings = _mm512_mask_loadu_epi8(left_standings, far_left, far_bytes[BUSTER_NODE_CONTEXTS_FAR_LEFT_FLAGS]);")
P('near-standing-flags', W, "__m512i left_standings = node_window_operands(at_left, near_left, previous_standings, standings);",
  "__m512i left_standings = node_window_operands(at_left, near_left, previous_flags, flags);")
P('near-standing-this-block', W, "__m512i left_standings = node_window_operands(at_left, near_left, previous_standings, standings);",
  "__m512i left_standings = node_window_operands(at_left, near_left, standings, standings);")
# The operands' tests.
LT = "const __mmask64 left_tested = _mm512_testn_epi8_mask(left_facts, _mm512_set1_epi8(BUSTER_CHECK_LOWER_TYPE_AGGREGATE));"
RT = "const __mmask64 right_tested = _mm512_testn_epi8_mask(right_facts, _mm512_set1_epi8(BUSTER_CHECK_LOWER_TYPE_AGGREGATE));"
L('left-tested-pointer', LT, "BUSTER_CHECK_LOWER_TYPE_AGGREGATE", "BUSTER_CHECK_LOWER_TYPE_POINTER")
L('left-tested-right', LT, "left_facts", "right_facts")
L('right-tested-pointer', RT, "BUSTER_CHECK_LOWER_TYPE_AGGREGATE", "BUSTER_CHECK_LOWER_TYPE_POINTER")
L('right-tested-left', RT, "right_facts", "left_facts")
# The consumer's class and the record's own.
CK = "const __m512i consumer_kinds = _mm512_and_si512(consumer_classes, _mm512_set1_epi8(BUSTER_NODE_CONTEXTS_CLASS_KIND));"
P('consumer-kind-whole', W, CK, "const __m512i consumer_kinds = consumer_classes;")
CLG = "const __mmask64 consumer_logical = _mm512_cmpeq_epi8_mask(consumer_kinds, _mm512_set1_epi8(BUSTER_NODE_CONTEXTS_CLASS_LOGICAL));"
CT = "const __mmask64 consumer_truth = _mm512_cmpeq_epi8_mask(consumer_kinds, _mm512_set1_epi8(BUSTER_NODE_CONTEXTS_CLASS_TRUTH));"
L('consumer-logical-truth', CLG, "BUSTER_NODE_CONTEXTS_CLASS_LOGICAL", "BUSTER_NODE_CONTEXTS_CLASS_TRUTH")
L('consumer-logical-conditional', CLG, "BUSTER_NODE_CONTEXTS_CLASS_LOGICAL", "BUSTER_NODE_CONTEXTS_CLASS_CONDITIONAL")
L('consumer-logical-own', CLG, "consumer_kinds", "class_kinds")
L('consumer-truth-logical', CT, "BUSTER_NODE_CONTEXTS_CLASS_TRUTH", "BUSTER_NODE_CONTEXTS_CLASS_LOGICAL")
L('consumer-truth-unary', CT, "BUSTER_NODE_CONTEXTS_CLASS_TRUTH", "BUSTER_NODE_CONTEXTS_CLASS_UNARY")
L('consumer-truth-own', CT, "consumer_kinds", "class_kinds")
IC = "const __mmask64 is_condition = is_truth & _mm512_test_epi8_mask(classes, _mm512_set1_epi8(BUSTER_NODE_CONTEXTS_CLASS_CONDITION));"
P('condition-every-truth', W, IC, "const __mmask64 is_condition = is_truth;")
P('condition-none', W, IC, "const __mmask64 is_condition = is_truth & ~is_truth;")
L('condition-place-bit', IC, "BUSTER_NODE_CONTEXTS_CLASS_CONDITION", "(char)BUSTER_NODE_CONTEXTS_CLASS_PLACE")
L('condition-consumer', IC, "(classes,", "(consumer_classes,")
P('not-every-truth', W, "const __mmask64 is_not = is_truth & ~is_condition;", "const __mmask64 is_not = is_truth;")
# The first operand's code.
LL = "const __mmask64 left_logical = _mm512_cmple_epu8_mask(_mm512_sub_epi8(left_codes, _mm512_set1_epi8(CHECK_OP_LOGICAL_AND)), _mm512_set1_epi8(1));"
L('left-logical-and-only', LL, "_mm512_set1_epi8(1)", "_mm512_set1_epi8(0)")
L('left-logical-conditional-too', LL, "_mm512_set1_epi8(1)", "_mm512_set1_epi8(2)")
L('left-logical-xor-not-or', LL, "CHECK_OP_LOGICAL_AND", "CHECK_OP_BIT_XOR")
L('left-logical-or-only', LL, "CHECK_OP_LOGICAL_AND)), _mm512_set1_epi8(1)", "CHECK_OP_LOGICAL_OR)), _mm512_set1_epi8(0)")
L('left-logical-own', LL, "left_codes", "codes")
LN = "const __mmask64 left_not = _mm512_cmpeq_epi8_mask(left_codes, _mm512_set1_epi8(CHECK_OP_NOT));"
L('left-not-negative', LN, "CHECK_OP_NOT", "CHECK_OP_NEGATIVE")
L('left-not-own', LN, "left_codes", "codes")
P('left-not-none', W, LN, "const __mmask64 left_not = _mm512_cmpeq_epi8_mask(left_codes, _mm512_set1_epi8(CHECK_OP_COUNT));")
# The first operand's standing.
LV = "const __mmask64 left_variable = _mm512_testn_epi8_mask(left_standings, _mm512_set1_epi8(0x1c));"
L('variable-category', LV, "0x1c", "0x03")
L('variable-and-rvalue', LV, "0x1c", "0x1f")
L('variable-one-kind-bit', LV, "0x1c", "0x04")
L('variable-two-kind-bits', LV, "0x1c", "0x0c")
L('variable-high-kind-bits', LV, "0x1c", "0x18")
L('variable-own', LV, "left_standings", "standings")
LP = "const __mmask64 left_placed = _mm512_cmpeq_epi8_mask(_mm512_and_si512(left_standings, _mm512_set1_epi8(0x1f)), _mm512_set1_epi8((CHECK_CONSTANT_ADDRESS << 2) | CHECK_LVALUE));"
L('placed-integer', LP, "CHECK_CONSTANT_ADDRESS", "CHECK_CONSTANT_INTEGER")
L('placed-rvalue', LP, "CHECK_LVALUE", "CHECK_RVALUE")
L('placed-function', LP, "CHECK_LVALUE", "CHECK_FUNCTION")
L('placed-any-category', LP, "_mm512_set1_epi8(0x1f)), _mm512_set1_epi8((CHECK_CONSTANT_ADDRESS << 2) | CHECK_LVALUE)", "_mm512_set1_epi8(0x1c)), _mm512_set1_epi8(CHECK_CONSTANT_ADDRESS << 2)")
L('placed-any-kind', LP, "_mm512_set1_epi8(0x1f)), _mm512_set1_epi8((CHECK_CONSTANT_ADDRESS << 2) | CHECK_LVALUE)", "_mm512_set1_epi8(0x03)), _mm512_set1_epi8(CHECK_LVALUE)")
L('placed-no-offset', LP, "_mm512_set1_epi8(0x1f)", "_mm512_set1_epi8(0x3f)")
L('placed-not-wide', LP, "_mm512_set1_epi8(0x1f)", "_mm512_set1_epi8((char)0x9f)")
LO = "const __mmask64 left_object = _mm512_test_epi8_mask(left_flags, _mm512_set1_epi8(BUSTER_NODE_CONTEXTS_OBJECT));"
L('object-symbol', LO, "BUSTER_NODE_CONTEXTS_OBJECT", "BUSTER_NODE_CONTEXTS_SYMBOL")
L('object-placed', LO, "BUSTER_NODE_CONTEXTS_OBJECT", "BUSTER_NODE_CONTEXTS_PLACED")
L('object-own', LO, "left_flags", "flags")
LU = "const __mmask64 left_unknown = left_variable | (left_placed & left_object);"
P('unknown-any-object', W, LU, "const __mmask64 left_unknown = left_variable | left_object;")
P('unknown-no-object', W, LU, "const __mmask64 left_unknown = left_variable | left_placed;")
P('unknown-variable-only', W, LU, "const __mmask64 left_unknown = left_variable;")
P('unknown-placed-only', W, LU, "const __mmask64 left_unknown = left_placed & left_object;")
# The branched records.
BN = "const __mmask64 branched_not = is_not & free & consumer_logical;"
P('not-not-free', W, BN, "const __mmask64 branched_not = is_not & consumer_logical;")
P('not-any-consumer', W, BN, "const __mmask64 branched_not = is_not & free;")
P('not-under-truth-too', W, BN, "const __mmask64 branched_not = is_not & free & (consumer_logical | consumer_truth);")
P('not-under-truth', W, BN, "const __mmask64 branched_not = is_not & free & consumer_truth;")
P('not-condition-too', W, BN, "const __mmask64 branched_not = is_truth & free & consumer_logical;")
P('not-none', W, BN, "const __mmask64 branched_not = is_not & free & consumer_logical & ~is_not;")
BL = "const __mmask64 branched_logical = is_logical & free & left_unknown & (consumer_logical | consumer_truth);"
P('logical-not-free', W, BL, "const __mmask64 branched_logical = is_logical & left_unknown & (consumer_logical | consumer_truth);")
P('logical-any-left', W, BL, "const __mmask64 branched_logical = is_logical & free & (consumer_logical | consumer_truth);")
P('logical-any-consumer', W, BL, "const __mmask64 branched_logical = is_logical & free & left_unknown;")
P('logical-under-logical-only', W, BL, "const __mmask64 branched_logical = is_logical & free & left_unknown & consumer_logical;")
P('logical-under-truth-only', W, BL, "const __mmask64 branched_logical = is_logical & free & left_unknown & consumer_truth;")
P('logical-none', W, BL, "const __mmask64 branched_logical = is_logical & free & left_unknown & consumer_logical & consumer_truth;")
BR = "const __mmask64 branched_root = is_condition & left_logical;"
P('root-any-operand', W, BR, "const __mmask64 branched_root = is_condition;")
P('root-not-too', W, BR, "const __mmask64 branched_root = is_truth & left_logical;")
P('root-over-not', W, BR, "const __mmask64 branched_root = is_condition & (left_logical | left_not);")
P('root-none', W, BR, "const __mmask64 branched_root = is_condition & left_logical & left_not;")
BA = "const __mmask64 branched = branched_not | branched_logical | branched_root;"
P('branched-no-root', W, BA, "const __mmask64 branched = branched_not | branched_logical;")
P('branched-no-not', W, BA, "const __mmask64 branched = branched_logical | branched_root;")
P('branched-no-logical', W, BA, "const __mmask64 branched = branched_not | branched_root;")
MB = "const __mmask64 made_branches = branched & left_tested & (~is_logical | right_tested);"
P('made-no-left-test', W, MB, "const __mmask64 made_branches = branched & (~is_logical | right_tested);")
P('made-no-right-test', W, MB, "const __mmask64 made_branches = branched & left_tested;")
P('made-right-test-of-all', W, MB, "const __mmask64 made_branches = branched & left_tested & right_tested;")
P('made-left-test-of-truths', W, MB, "const __mmask64 made_branches = branched & (is_logical | left_tested) & (~is_logical | right_tested);")
P('made-left-test-of-logicals', W, MB, "const __mmask64 made_branches = branched & (~is_logical | (left_tested & right_tested));")
UB = "const __mmask64 unbranched = (is_logical & ~branched_logical) | (is_not & ~branched_not & left_logical) | (branched_not & left_not);"
P('unbranched-no-logical', W, UB, "const __mmask64 unbranched = (is_not & ~branched_not & left_logical) | (branched_not & left_not);")
P('unbranched-no-not-over', W, UB, "const __mmask64 unbranched = (is_logical & ~branched_logical) | (branched_not & left_not);")
P('unbranched-no-not-not', W, UB, "const __mmask64 unbranched = (is_logical & ~branched_logical) | (is_not & ~branched_not & left_logical);")
P('unbranched-every-logical', W, UB, "const __mmask64 unbranched = is_logical | (is_not & ~branched_not & left_logical) | (branched_not & left_not);")
P('unbranched-not-over-any', W, UB, "const __mmask64 unbranched = (is_logical & ~branched_logical) | (is_not & ~branched_not) | (branched_not & left_not);")
P('unbranched-not-over-branched-too', W, UB, "const __mmask64 unbranched = (is_logical & ~branched_logical) | (is_not & left_logical) | (branched_not & left_not);")
P('unbranched-every-branched-not', W, UB, "const __mmask64 unbranched = (is_logical & ~branched_logical) | (is_not & ~branched_not & left_logical) | branched_not;")
P('unbranched-not-not-any', W, UB, "const __mmask64 unbranched = (is_logical & ~branched_logical) | (is_not & ~branched_not & left_logical) | (is_not & left_not);")
MT = "const __mmask64 made_truth = free & is_truth & numeric & left_tested;"
P('truth-no-test', W, MT, "const __mmask64 made_truth = free & is_truth & numeric;")
P('truth-not-free', W, MT, "const __mmask64 made_truth = is_truth & numeric & left_tested;")
P('truth-any-class', W, MT, "const __mmask64 made_truth = free & is_truth & left_tested;")
# What the loop writes.
LI = "(update_asked & ~made_update) | unbranched);"
P('listed-no-unbranched', W, LI, "(update_asked & ~made_update));")
TM = "const __m512i templates = _mm512_mask_mov_epi8(updated_templates, made_branches, _mm512_set1_epi8(NODE_MACHINE_TEMPLATE_BRANCHES));"
P('templates-no-branches', W, TM, "const __m512i templates = updated_templates;")
L('templates-every-branched', TM, "made_branches", "branched")
L('templates-truth', TM, "NODE_MACHINE_TEMPLATE_BRANCHES", "CHECK_LOWER_TEMPLATE_TRUTH")
SO = "const __m512i sources = _mm512_maskz_mov_epi8(~(addressed | branched), _mm512_and_si512(rows, _mm512_set1_epi8(BUSTER_NODE_CONTEXTS_SOURCE)));"
L('sources-branched-target', SO, "~(addressed | branched)", "~addressed")
L('sources-made-only', SO, "~(addressed | branched)", "~(addressed | made_branches)")
L('sources-roots-only', SO, "~(addressed | branched)", "~(addressed | branched_root)")
L('sources-no-roots', SO, "~(addressed | branched)", "~(addressed | branched_not | branched_logical)")
UC = "const __mmask64 is_uncased = _mm512_cmpge_epu8_mask(class_kinds, _mm512_set1_epi8(BUSTER_NODE_CONTEXTS_CLASS_CONDITIONAL)) | _mm512_testn_epi8_mask(class_kinds, class_kinds);"
L('uncased-logical-too', UC, "BUSTER_NODE_CONTEXTS_CLASS_CONDITIONAL", "BUSTER_NODE_CONTEXTS_CLASS_LOGICAL")
L('uncased-no-conditional', UC, "BUSTER_NODE_CONTEXTS_CLASS_CONDITIONAL", "BUSTER_NODE_CONTEXTS_CLASS_COMMA")
# The counts and the reason.
P('count-unplaced', W, "branched_count += (uint64_t)_mm_popcnt_u64(placed & made_branches);", "branched_count += (uint64_t)_mm_popcnt_u64(made_branches);")
P('count-every-branched', W, "branched_count += (uint64_t)_mm_popcnt_u64(placed & made_branches);", "branched_count += (uint64_t)_mm_popcnt_u64(placed & branched);")
P('count-roots-all', W, "branched_roots += (uint64_t)_mm_popcnt_u64(placed & made_branches & is_condition);", "branched_roots += (uint64_t)_mm_popcnt_u64(placed & made_branches);")
P('count-roots-truths', W, "branched_roots += (uint64_t)_mm_popcnt_u64(placed & made_branches & is_condition);", "branched_roots += (uint64_t)_mm_popcnt_u64(placed & made_branches & is_truth);")
P('counts-swapped', W, "counts[NODE_FACTS_COUNT_CONTEXTS_BRANCHED] += loop_counts.branched;", "counts[NODE_FACTS_COUNT_CONTEXTS_BRANCHED] += loop_counts.branched_roots;")
RE = "                 class == BUSTER_NODE_CONTEXTS_CLASS_TRUTH                    ? BUSTER_NODE_CONTEXTS_REASON_LOGICAL :\n"
P('reason-truth-operator', W, RE, "")
P('reason-conditional-operator', W, "                 class == BUSTER_NODE_CONTEXTS_CLASS_CONDITIONAL              ? BUSTER_NODE_CONTEXTS_REASON_LOGICAL :\n", "")

if len(sys.argv) > 3 and sys.argv[3] == 'check':
    bad = [(name, n) for name, f, a, b, n in FAULTS if n != 1]
    names = [f[0] for f in FAULTS]
    print('%d faults; texts not in their file once: %s; names twice: %s' % (len(FAULTS), bad, sorted(set(n for n in names if names.count(n) > 1))))
    sys.exit(1 if bad or len(set(names)) != len(names) else 0)

def probes(compiler):
    lines = []
    work = '/home/user/mut21/probe%d' % worker
    os.makedirs(work, exist_ok=True)
    for name in ['branches1.txt', 'branches2.txt', 'branches3.txt']:
        for flat in ([], ['--flat']):
            run = subprocess.run(['python3', PROBES + '/probe-b.py', compiler, PROBES + '/' + name] + flat, cwd=work, capture_output=True, text=True, timeout=3000)
            lines += [('flat ' if flat else 'spaced ') + l for l in run.stdout.split('\n') if l]
    return lines
if len(sys.argv) > 3 and sys.argv[3] == 'base':
    open('/home/user/mut21/base%s-probes.txt' % ROUND, 'w').write('\n'.join(probes(TREE + '/build/compiler')) + '\n')
    sys.exit(0)
out = open('/home/user/mut21/results%s-%d.txt' % (ROUND, worker), 'w')
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
                base_lines = set(open('/home/user/mut21/base%s-probes.txt' % ROUND).read().split('\n'))
            try:
                got = probes(TREE + '/build/compiler')
                told = [l for l in got if l and l not in base_lines]
                verdict += ' || probes: %d lines not the base\'s%s' % (len(told), (': ' + told[0][:150]) if told else '')
            except subprocess.TimeoutExpired:
                verdict += ' || probes: timed out'
    out.write('%s: %s (%d s)\n' % (name, verdict, time.time() - t0)); out.flush()
    open(SRC + f, 'w').write(source)
out.write('done\n'); out.close()
