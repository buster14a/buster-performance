#!/usr/bin/env python3
# mutants.py: the faults of the tree's rule in the loop and of the verdict of an expression with nothing listed
# (buster#2850, the tests on the window, second half), one at a time, in a COPY of the tree (/home/user/mut12/tree<i>):
# each is a text of the new code replaced by a faulty one, the Debug compiler built, and the node machine's tests run
# (test-checker part 5 of 8). A fault the tests don't fail is a survivor. Every text is checked to be unique before any
# build, and the file is restored after each fault.
#   mutants.py check        : every fault's texts are unique, applies and reverts
#   mutants.py run [NAME..] : the campaign (all the faults, or those named); results in /home/user/mut12/results-<i>.txt
#   MUT_SHARD=i/n           : the faults whose place in the list is i modulo n, in the tree's copy tree<i>
import subprocess, sys, os, shutil, time

ROOT = '/home/user/mut12'
SHARD, SHARDS = [int(x) for x in os.environ.get('MUT_SHARD', '0/1').split('/')]
TREE = ROOT + '/tree%d' % SHARD
SRC = TREE + '/src/buster/compiler/'
C = 'c_check_node_census.c'
R = 'c_check_node_machine_reader.c'

MARKS = '        s->own_tree_marks[code] = (uint8_t)(op == CHECK_OP_NOT ? BUSTER_NODE_TESTS_TREE_NOT : op == CHECK_OP_ASSIGN ? BUSTER_NODE_TESTS_TREE_ASSIGN : 0);'
FIRSTS = '        s->own_tree_firsts[code] = (uint8_t)(comparison ? BUSTER_NODE_TESTS_TREE_NOT : op == CHECK_OP_CONDITION ? BUSTER_NODE_TESTS_TREE_ASSIGN : 0);'
SENDS = '        s->own_tree_sends[code] = bitwise || op == CHECK_OP_CAST ? BUSTER_NODE_TESTS_OPERAND_COMPARISON : 0;'
BITWISE = '        const bool bitwise = op == CHECK_OP_BIT_AND || op == CHECK_OP_BIT_OR || op == CHECK_OP_BIT_XOR;'
KIND = '''    return op == CHECK_OP_CAST ? NODE_CENSUS_ROOT_STATEMENT : op == CHECK_OP_CONDITION ? NODE_CENSUS_ROOT_CONDITION : op == CHECK_OP_CONVERT ? NODE_CENSUS_ROOT_RETURN :
           op == CHECK_OP_POSITIVE ? NODE_CENSUS_ROOT_SWITCH : NODE_CENSUS_ROOT_OTHER;'''
MARK_LEFT = '        const __m512i mark_left = node_tests_window_operands(at_left, near_left, previous_marks, tree_marks);'
FAR = "                tree_first |= (uint64_t)((s->own_tree_firsts[front->ops[r] & 0x7f] & s->own_tree_marks[front->ops[operand] & 0x7f]) != 0 ? 1 : 0) << (r & 63);"
MASK = '        masks[BUSTER_NODE_TESTS_MASK_TREE] = tree_first | _mm512_test_epi8_mask(tree_sends, operands);'
ROOT_TREE = '            tree_bits[size / 64] |= (rooted ? root_masks[BUSTER_NODE_TESTS_MASK_TREE] >> root_lane & 1 : 0) << (size & 63);'
ROOT_OPERATOR = '            operator_bits[size / 64] |= (rooted ? root_masks[BUSTER_NODE_TESTS_MASK_OPERATORS] >> root_lane & 1 : 0) << (size & 63);'
LISTS = '                lists |= tree_bits[word] | operator_bits[word];'
LISTED = '''            const uint32_t listed = (lists != 0) | !rooted | (unsequenced & (sequenced ^ 1)) | ((context == NODE_CENSUS_ROOT_STATEMENT) & (stores ^ 1)) | addresses |
                                    (types->warned[root] != 0);'''
SEQUENCED = '            const uint32_t sequenced = (writes == 0) | ((writes == 1) & top_writes);'
STORES = '            const uint32_t stores = in_unit & (role != PARSE_ROLE_CLOSE_CAST) & (role != PARSE_ROLE_OPEN_CAST) & top_writes;'
ADDRESSES = '            const uint32_t addresses = (context == NODE_CENSUS_ROOT_RETURN) & return_address & ((set & (BUSTER_NODE_TESTS_SET_ADDRESS | BUSTER_NODE_TESTS_SET_ARRAY)) != 0);'
CONTEXT = '            const uint32_t context = nested != 0 ? NODE_CENSUS_ROOT_OTHER : s->own_roots[front->ops[root_record] & 0x7f];'
CONTROL = '            bits |= fixed | (context == NODE_CENSUS_ROOT_OTHER ? UINT64_C(1) << NODE_CENSUS_CONTROL : 0);'
LOOPS = '            bits |= policy->loops && node_census_for_clause(reader->parser, token) ? UINT64_C(1) << NODE_CENSUS_LOOP : 0;'
VERDICT = '            loop->verdict = bits | node_census_reader_marks(tests, token, lowest, highest);'
TAKEN = '            const uint32_t taken = listed | verify_quiet;'
SIDES = '            for (uint32_t side = 0; side < 2; side += 1)'
CANDIDATE = '            if ((check_common_comparison_role(role) || op == CHECK_OP_NOT || op == CHECK_OP_ASSIGN) && (read[r >> 6] >> (r & 63) & 1) == 0)'
FROM = '    const uint64_t from = tests->event_bits[first] & (~UINT64_C(0) << (span_low & 63));'
TO = '    const uint64_t to = tests->event_bits[last] & (~UINT64_C(0) >> (63 - (span_high & 63)));'
EVENTS = '    uint64_t events = first == last ? from & to : from | to;'
MARKS_RETURN = '    return (region ? UINT64_C(1) << NODE_CENSUS_REGION : 0) | (some && events != 0 ? UINT64_C(1) << NODE_CENSUS_EVENT : 0);'
WARNED = '                            types->warned[root] = (machine->action_warnings & 0x01ffffffu) != 0;'
LONE = '            columns[column][operand + 1] = lone ? columns[column][record] : columns[column][operand + 1];'

MUTANTS = [
    # The tables.
    ('t-bitwise-and', C, BITWISE, BITWISE.replace('op == CHECK_OP_BIT_AND || ', '')),
    ('t-bitwise-or', C, BITWISE, BITWISE.replace('op == CHECK_OP_BIT_OR || ', '')),
    ('t-bitwise-xor', C, BITWISE, BITWISE.replace(' || op == CHECK_OP_BIT_XOR', '')),
    ('t-marks-not', C, MARKS, MARKS.replace('op == CHECK_OP_NOT ? BUSTER_NODE_TESTS_TREE_NOT : ', '')),
    ('t-marks-assign', C, MARKS, MARKS.replace(' : op == CHECK_OP_ASSIGN ? BUSTER_NODE_TESTS_TREE_ASSIGN : 0', ' : 0')),
    ('t-marks-swapped', C, MARKS, MARKS.replace('BUSTER_NODE_TESTS_TREE_NOT', 'XX').replace('BUSTER_NODE_TESTS_TREE_ASSIGN', 'BUSTER_NODE_TESTS_TREE_NOT').replace('XX', 'BUSTER_NODE_TESTS_TREE_ASSIGN')),
    ('t-firsts-comparison', C, FIRSTS, FIRSTS.replace('comparison ? BUSTER_NODE_TESTS_TREE_NOT : ', '')),
    ('t-firsts-condition', C, FIRSTS, FIRSTS.replace(' : op == CHECK_OP_CONDITION ? BUSTER_NODE_TESTS_TREE_ASSIGN : 0', ' : 0')),
    ('t-firsts-comparison-both', C, FIRSTS, FIRSTS.replace('comparison ? BUSTER_NODE_TESTS_TREE_NOT', 'comparison ? BUSTER_NODE_TESTS_TREE_NOT | BUSTER_NODE_TESTS_TREE_ASSIGN')),
    ('t-firsts-condition-both', C, FIRSTS, FIRSTS.replace('BUSTER_NODE_TESTS_TREE_ASSIGN : 0', 'BUSTER_NODE_TESTS_TREE_NOT | BUSTER_NODE_TESTS_TREE_ASSIGN : 0')),
    ('t-sends-bitwise', C, SENDS, SENDS.replace('bitwise || ', '')),
    ('t-sends-cast', C, SENDS, SENDS.replace(' || op == CHECK_OP_CAST', '')),
    ('t-sends-every', C, SENDS, SENDS.replace('bitwise || op == CHECK_OP_CAST ? ', 'code != 0 ? ')),
    ('t-kind-statement', C, KIND, KIND.replace('op == CHECK_OP_CAST ? NODE_CENSUS_ROOT_STATEMENT : ', '')),
    ('t-kind-condition', C, KIND, KIND.replace('op == CHECK_OP_CONDITION ? NODE_CENSUS_ROOT_CONDITION : ', '')),
    ('t-kind-return', C, KIND, KIND.replace('op == CHECK_OP_CONVERT ? NODE_CENSUS_ROOT_RETURN :', 'op == CHECK_OP_CONVERT ? NODE_CENSUS_ROOT_OTHER :')),
    ('t-kind-switch', C, KIND, KIND.replace('op == CHECK_OP_POSITIVE ? NODE_CENSUS_ROOT_SWITCH : NODE_CENSUS_ROOT_OTHER', 'NODE_CENSUS_ROOT_OTHER')),
    ('t-roots-table', C, '        s->own_roots[code] = (uint8_t)node_census_root_kind(op);', '        s->own_roots[code] = (uint8_t)NODE_CENSUS_ROOT_OTHER;'),
    # The loop.
    ('l-mark-right', C, MARK_LEFT, MARK_LEFT.replace('at_left, near_left', 'at_right, near_right')),
    ('l-mark-previous-none', C, MARK_LEFT, MARK_LEFT.replace('previous_marks, tree_marks', '_mm512_setzero_si512(), tree_marks')),
    ('l-mark-current-none', C, MARK_LEFT, MARK_LEFT.replace('previous_marks, tree_marks', 'previous_marks, _mm512_setzero_si512()')),
    ('l-previous-not-kept', C, '        previous_marks = tree_marks;', '        previous_marks = _mm512_setzero_si512();'),
    ('l-first-inverted', C, '        __mmask64 tree_first = _mm512_test_epi8_mask(tree_firsts, mark_left);', '        __mmask64 tree_first = _mm512_testn_epi8_mask(tree_firsts, mark_left);'),
    ('l-first-own-marks', C, '        __mmask64 tree_first = _mm512_test_epi8_mask(tree_firsts, mark_left);', '        __mmask64 tree_first = _mm512_test_epi8_mask(tree_firsts, tree_marks);'),
    ('l-far-none', C, FAR, FAR.replace('!= 0 ? 1 : 0', '!= 0 ? 0 : 0')),
    ('l-far-every', C, FAR, FAR.replace('!= 0 ? 1 : 0', '!= 0 ? 1 : 1')),
    ('l-far-own-mark', C, FAR, FAR.replace('s->own_tree_marks[front->ops[operand] & 0x7f]', 's->own_tree_marks[front->ops[r] & 0x7f]')),
    ('l-far-operand-firsts', C, FAR, FAR.replace('s->own_tree_firsts[front->ops[r] & 0x7f]', 's->own_tree_firsts[front->ops[operand] & 0x7f]')),
    ('l-far-lane', C, FAR, FAR.replace('<< (r & 63)', '<< ((r + 1) & 63)')),
    ('l-mask-first-alone', C, MASK, MASK.replace('tree_first | _mm512_test_epi8_mask(tree_sends, operands)', 'tree_first')),
    ('l-mask-sends-alone', C, MASK, MASK.replace('tree_first | ', '')),
    ('l-mask-own-property', C, MASK, MASK.replace('(tree_sends, operands)', '(tree_sends, property)')),
    ('l-table-marks', C, '        const __m512i tree_marks = node_tests_window_table(s->own_tree_marks, codes);', '        const __m512i tree_marks = node_tests_window_table(s->own_tree_firsts, codes);'),
    ('l-table-firsts', C, '        const __m512i tree_firsts = node_tests_window_table(s->own_tree_firsts, codes);', '        const __m512i tree_firsts = node_tests_window_table(s->own_tree_marks, codes);'),
    ('l-table-sends', C, '        const __m512i tree_sends = node_tests_window_table(s->own_tree_sends, codes);', '        const __m512i tree_sends = node_tests_window_table(s->own_sends, codes);'),
    # An expression's part.
    ('s-root-tree-none', C, ROOT_TREE, ROOT_TREE.replace('>> root_lane & 1 : 0)', '>> root_lane & 0 : 0)')),
    ('s-root-tree-unrooted', C, ROOT_TREE, ROOT_TREE.replace('(rooted ? root_masks[BUSTER_NODE_TESTS_MASK_TREE] >> root_lane & 1 : 0)', '(root_masks[BUSTER_NODE_TESTS_MASK_TREE] >> root_lane & 1)')),
    ('s-root-tree-operators', C, ROOT_TREE, ROOT_TREE.replace('BUSTER_NODE_TESTS_MASK_TREE', 'BUSTER_NODE_TESTS_MASK_OPERATORS')),
    ('s-root-operator-none', C, ROOT_OPERATOR, ROOT_OPERATOR.replace('>> root_lane & 1 : 0)', '>> root_lane & 0 : 0)')),
    ('s-root-operator-unrooted', C, ROOT_OPERATOR, ROOT_OPERATOR.replace('(rooted ? root_masks[BUSTER_NODE_TESTS_MASK_OPERATORS] >> root_lane & 1 : 0)', '(root_masks[BUSTER_NODE_TESTS_MASK_OPERATORS] >> root_lane & 1)')),
    ('s-root-record', C, '            const uint32_t root_record = rooted ? record : operand;', '            const uint32_t root_record = rooted ? record : record;'),
    ('s-root-highest', C, '            highest = in_unit != 0 && token > highest ? token : highest;', '            highest = in_unit != 0 && token > highest ? highest : highest;'),
    ('s-root-lowest', C, '            lowest = in_unit != 0 && token < lowest ? token : lowest;', '            lowest = in_unit != 0 && token < lowest ? lowest : lowest;'),
    ('s-lists-tree', C, LISTS, LISTS.replace('tree_bits[word] | ', '')),
    ('s-lists-operators', C, LISTS, LISTS.replace(' | operator_bits[word]', '')),
    ('s-listed-lists', C, LISTED, LISTED.replace('(lists != 0) | ', '')),
    ('s-listed-rooted', C, LISTED, LISTED.replace(' | !rooted', '')),
    ('s-listed-unsequenced', C, LISTED, LISTED.replace(' | (unsequenced & (sequenced ^ 1))', '')),
    ('s-listed-unsequenced-policy', C, LISTED, LISTED.replace('(unsequenced & (sequenced ^ 1))', '(sequenced ^ 1)')),
    ('s-listed-statement', C, LISTED, LISTED.replace(' | ((context == NODE_CENSUS_ROOT_STATEMENT) & (stores ^ 1))', '')),
    ('s-listed-statement-any', C, LISTED, LISTED.replace('((context == NODE_CENSUS_ROOT_STATEMENT) & (stores ^ 1))', '(stores ^ 1)')),
    ('s-listed-addresses', C, LISTED, LISTED.replace(' | addresses', '')),
    ('s-listed-warned', C, LISTED, LISTED.replace(''' |
                                    (types->warned[root] != 0)''', '')),
    ('s-sequenced-no-top', C, SEQUENCED, SEQUENCED.replace(' | ((writes == 1) & top_writes)', '')),
    ('s-sequenced-any-one', C, SEQUENCED, SEQUENCED.replace('((writes == 1) & top_writes)', '(writes == 1)')),
    ('s-sequenced-two', C, SEQUENCED, SEQUENCED.replace('(writes == 1)', '(writes <= 2)')),
    ('s-top-writes', C, '            const uint32_t top_writes = last_write + 1 == size;', '            const uint32_t top_writes = last_write + 2 == size;'),
    ('s-stores-top', C, STORES, STORES.replace(' & top_writes', '')),
    ('s-stores-close-cast', C, STORES, STORES.replace(' & (role != PARSE_ROLE_CLOSE_CAST)', '')),
    ('s-stores-open-cast', C, STORES, STORES.replace(' & (role != PARSE_ROLE_OPEN_CAST)', '')),
    ('s-stores-in-unit', C, STORES, STORES.replace('in_unit & (role', '(role')),
    ('s-addresses-return', C, ADDRESSES, ADDRESSES.replace('(context == NODE_CENSUS_ROOT_RETURN) & ', '')),
    ('s-addresses-policy', C, ADDRESSES, ADDRESSES.replace('return_address & ', '')),
    ('s-addresses-array-alone', C, ADDRESSES, ADDRESSES.replace('(BUSTER_NODE_TESTS_SET_ADDRESS | BUSTER_NODE_TESTS_SET_ARRAY)', '(BUSTER_NODE_TESTS_SET_ARRAY)')),
    ('s-addresses-address-alone', C, ADDRESSES, ADDRESSES.replace('(BUSTER_NODE_TESTS_SET_ADDRESS | BUSTER_NODE_TESTS_SET_ARRAY)', '(BUSTER_NODE_TESTS_SET_ADDRESS)')),
    ('s-context-nested', C, CONTEXT, CONTEXT.replace('nested != 0 ? NODE_CENSUS_ROOT_OTHER : ', '')),
    ('s-nested-bit', C, '            const uint32_t nested = in_unit & (uint32_t)(tests->nested_bits[held >> 6] >> (held & 63) & 1);', '            const uint32_t nested = in_unit & (uint32_t)(tests->nested_bits[held >> 6] >> ((held + 1) & 63) & 1);'),
    ('s-control', C, CONTROL, CONTROL.replace('UINT64_C(1) << NODE_CENSUS_CONTROL : 0', 'UINT64_C(0) : 0')),
    ('s-fixed', C, CONTROL, CONTROL.replace('bits |= fixed | ', 'bits |= ')),
    ('s-fixed-bit', C, '    const uint64_t fixed = policy->unmodeled ? UINT64_C(1) << NODE_CENSUS_UNMODELED : 0;', '    const uint64_t fixed = policy->unmodeled ? UINT64_C(1) << NODE_CENSUS_CONTROL : 0;'),
    ('s-loop-clause', C, LOOPS, LOOPS.replace('policy->loops && node_census_for_clause(reader->parser, token)', 'policy->loops && !node_census_for_clause(reader->parser, token)')),
    ('s-loop-none', C, LOOPS, LOOPS.replace('UINT64_C(1) << NODE_CENSUS_LOOP : 0', 'UINT64_C(0) : 0')),
    ('s-loop-policy', C, LOOPS, LOOPS.replace('policy->loops && ', '')),
    ('s-verdict-marks', C, VERDICT, VERDICT.replace('bits | node_census_reader_marks(tests, token, lowest, highest)', 'bits')),
    ('s-verdict-span', C, VERDICT, VERDICT.replace('(tests, token, lowest, highest)', '(tests, token, highest, highest)')),
    ('s-kind', C, '            loop->kind = (uint8_t)context;', '            loop->kind = (uint8_t)(context ^ 1);'),
    ('s-span-low', C, '            loop->span_low = lowest;', '            loop->span_low = highest;'),
    ('s-span-high', C, '            loop->span_high = highest;', '            loop->span_high = lowest;'),
    ('s-listed-kept', C, '            loop->listed = (uint8_t)listed;', '            loop->listed = 1;'),
    ('s-taken-verify', C, TAKEN, TAKEN.replace('listed | verify_quiet', 'listed')),
    ('s-taken-every', C, TAKEN, TAKEN.replace('listed | verify_quiet', 'listed | 1')),
    ('s-direct-count', C, '            direct += listed ^ 1;', '            direct += listed;'),
    ('s-skipped-count', C, '            skipped += taken ^ 1;', '            skipped += taken;'),
    ('s-skipped-records', C, '            skipped_records += taken != 0 ? 0 : state->counts[e];', '            skipped_records += taken != 0 ? state->counts[e] : 0;'),
    ('s-apart', C, '            apart += rooted & (record != operand + 1);', '            apart += rooted;'),
    ('s-apart-unrooted', C, '            apart += rooted & (record != operand + 1);', '            apart += record != operand + 1;'),
    # The tests that read T's records, of the expressions listed.
    ('c-lone', C, LONE, LONE.replace('lone ? columns[column][record] : columns[column][operand + 1]', 'columns[column][operand + 1]')),
    ('c-direct-checked', C, '        types->own_direct_checked += loop->listed == 0;', '        types->own_direct_checked += loop->listed != 0;'),
    ('e-first-operand', C, SIDES, SIDES.replace('side = 0;', 'side = 1;')),
    ('e-second-operand', C, SIDES, SIDES.replace('side < 2;', 'side < 1;')),
    ('e-read-bit', C, '                    read[o >> 6] |= s->own_tree_verify ? UINT64_C(1) << (o & 63) : 0;', '                    read[o >> 6] |= s->own_tree_verify ? UINT64_C(0) << (o & 63) : 0;'),
    ('e-candidate-comparison', C, CANDIDATE, CANDIDATE.replace('check_common_comparison_role(role) || ', '')),
    ('e-candidate-not', C, CANDIDATE, CANDIDATE.replace('op == CHECK_OP_NOT || ', '')),
    ('e-candidate-assign', C, CANDIDATE, CANDIDATE.replace(' || op == CHECK_OP_ASSIGN', '')),
    # The marks.
    ('m-from-mask', C, FROM, FROM.replace('(~UINT64_C(0) << (span_low & 63))', '~UINT64_C(0)')),
    ('m-from-word', C, FROM, FROM.replace('tests->event_bits[first]', 'tests->event_bits[last]')),
    ('m-to-mask', C, TO, TO.replace('(~UINT64_C(0) >> (63 - (span_high & 63)))', '~UINT64_C(0)')),
    ('m-to-word', C, TO, TO.replace('tests->event_bits[last]', 'tests->event_bits[first]')),
    ('m-one-word-or', C, EVENTS, EVENTS.replace('first == last ? from & to : from | to', 'from | to')),
    ('m-two-words-and', C, EVENTS, EVENTS.replace('first == last ? from & to : from | to', 'from & to')),
    ('m-between', C, '    for (uint32_t word = first + 1; word < last; word += 1)\n    {\n        events |= tests->event_bits[word];', '    for (uint32_t word = first + 1; word < last; word += 1)\n    {\n        events |= 0;'),
    ('m-events-none', C, MARKS_RETURN, MARKS_RETURN.replace('some && events != 0 ? UINT64_C(1) << NODE_CENSUS_EVENT : 0', 'some && events != 0 ? UINT64_C(0) : 0')),
    ('m-region-none', C, MARKS_RETURN, MARKS_RETURN.replace('region ? UINT64_C(1) << NODE_CENSUS_REGION : 0', 'region ? UINT64_C(0) : 0')),
    ('m-some', C, MARKS_RETURN, MARKS_RETURN.replace('some && events != 0', 'events != 0')),
    # The reader's column.
    ('r-warned-none', R, WARNED, WARNED.replace('(machine->action_warnings & 0x01ffffffu) != 0', '(machine->action_warnings & 0x01ffffffu) != 0 && false')),
    ('r-warned-every', R, WARNED, WARNED.replace('(machine->action_warnings & 0x01ffffffu) != 0', '(machine->action_warnings & 0x01ffffffu) != 0 || true')),
]

def read(path):
    return open(path).read()

def check():
    ok = True
    names = set()
    for name, f, old, new in MUTANTS:
        s = read(SRC + f)
        if name in names:
            print('DUPLICATE NAME', name); ok = False
        names.add(name)
        if s.count(old) != 1:
            print(name, 'old text occurs', s.count(old)); ok = False
        if old == new or s.replace(old, new) == s:
            print(name, 'changes nothing'); ok = False
        if new != '' and s.count(new) != 0:
            print(name, 'new text is there already', s.count(new)); ok = False
    print(len(MUTANTS), 'faults;', 'all unique' if ok else 'PROBLEMS')
    return ok

def run(only):
    if not check():
        sys.exit(1)
    results = open(ROOT + '/results-%d.txt' % SHARD, 'a')
    for place, (name, f, old, new) in enumerate(MUTANTS):
        if (only and name not in only) or place % SHARDS != SHARD:
            continue
        path = SRC + f
        saved = ROOT + '/saved%d.c' % SHARD
        shutil.copyfile(path, saved)
        s = read(path)
        open(path, 'w').write(s.replace(old, new))
        start = time.time()
        build = subprocess.run(['./build.sh', '--config', 'Debug'], cwd=TREE, capture_output=True, text=True)
        built = build.returncode == 0
        verdict = 'NOT BUILT'
        detail = ''
        if built:
            try:
                test = subprocess.run(['./build/compiler', 'test-checker', '--seed', '133', '--part', '5/8'], cwd=TREE, capture_output=True, text=True, timeout=900)
                failed = test.returncode != 0
                lines = [l for l in (test.stderr + test.stdout).splitlines() if 'test-checker' in l and 'retained' not in l]
                detail = ' | '.join(l[:150] for l in lines[:2])
                verdict = 'caught' if failed else 'SURVIVED'
            except subprocess.TimeoutExpired:
                verdict = 'caught (timeout)'
        else:
            detail = (build.stderr + build.stdout)[-300:].replace('\n', ' ')
        shutil.copyfile(saved, path)
        line = f'{name}: {verdict} ({time.time() - start:.0f} s) {detail}'
        print(line, flush=True)
        results.write(line + '\n'); results.flush()
    subprocess.run(['./build.sh', '--config', 'Debug'], cwd=TREE, capture_output=True, text=True)
    print('campaign done', flush=True)

if __name__ == '__main__':
    if len(sys.argv) > 1 and sys.argv[1] == 'check':
        sys.exit(0 if check() else 1)
    run(sys.argv[2:])
