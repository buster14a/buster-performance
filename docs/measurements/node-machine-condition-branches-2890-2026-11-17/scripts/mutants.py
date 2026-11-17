#!/usr/bin/env python3
# mutants.py: buster#2890's faults, one at a time, in a COPY of the tree (/home/user/mut/tree): each is a text of the
# new code replaced by a faulty one, the Debug compiler built, and the node machine's tests run (test-checker part 5 of
# 8). A fault the tests don't fail is a survivor. Every text is checked to be unique before any build, and the file is
# restored from its saved copy after each fault.
#   mutants.py check        : every fault's texts are unique, applies and reverts
#   mutants.py run [NAME..] : the campaign (all the faults, or those named); results in /home/user/mut/results.txt
import subprocess, sys, os, shutil, time

TREE = '/home/user/mut/tree'
SRC = TREE + '/src/buster/compiler/'
C = 'c_check_node_machine_contexts.c'
X = 'c_check_node_machine_expand.c'
L = 'c_check_node_machine_lower.c'
M = 'c_check_node_machine.c'
R = 'c_check_node_machine_reader.c'
N = 'c_check_node_census.c'

MUTANTS = [
    # C: an operand as a condition (node_machine_branch_operand)
    ('c-operand-never-branched', C,
     '    if (node_machine_branch_operator(machine, child, false))\n    {\n        node_machine_evaluate(machine, r, child, false, 0);',
     '    if (child == UINT32_MAX && node_machine_branch_operator(machine, child, false))\n    {\n        node_machine_evaluate(machine, r, child, false, 0);'),
    ('c-operand-untestable-taken', C,
     '        takes = node_machine_testable(machine, type);\n        if (takes)\n        {\n            node_machine_evaluate(machine, r, child, false, type);',
     '        takes = node_machine_testable(machine, type) || type != 0;\n        if (takes)\n        {\n            node_machine_evaluate(machine, r, child, false, type);'),
    ('c-operand-branched-sense', C,
     '        node_machine_record_set_branch(machine, child, owner, sense, true);',
     '        node_machine_record_set_branch(machine, child, owner, !sense, true);'),
    ('c-operand-value-sense', C,
     '            node_machine_record_set_branch(machine, child, owner, sense, false);',
     '            node_machine_record_set_branch(machine, child, owner, !sense, false);'),
    ('c-operand-value-unconverted', C,
     '            node_machine_evaluate(machine, r, child, false, type);\n            node_machine_record_set_branch(machine, child, owner, sense, false);',
     '            node_machine_evaluate(machine, r, child, false, type == 0 ? type : 0);\n            node_machine_record_set_branch(machine, child, owner, sense, false);'),
    ('c-operand-branched-owner', C,
     '        node_machine_evaluate(machine, r, child, false, 0);\n        node_machine_record_set_branch(machine, child, owner, sense, true);',
     '        node_machine_evaluate(machine, r, child, false, 0);\n        node_machine_record_set_branch(machine, child, owner == r ? BUSTER_NODE_MACHINE_NO_OWNER : owner, sense, true);'),
    # C: an operator evaluated as branches (node_machine_classify_branches)
    ('c-branches-no-past', C,
     '        const bool past = node_machine_record_past(machine, r);\n        if (past)',
     '        const bool past = node_machine_record_past(machine, r) && a == UINT32_MAX;\n        if (past)'),
    ('c-branches-first-owner', C,
     'node_machine_branch_operand(machine, r, 0, a, past ? r : owner, past ? !sense : sense) &&',
     'node_machine_branch_operand(machine, r, 0, a, past ? owner : owner, past ? !sense : sense) &&'),
    ('c-branches-first-sense', C,
     'node_machine_branch_operand(machine, r, 0, a, past ? r : owner, past ? !sense : sense) &&',
     'node_machine_branch_operand(machine, r, 0, a, past ? r : owner, past ? sense : sense) &&'),
    ('c-branches-second-sense', C,
     '                node_machine_branch_operand(machine, r, 1, node_machine_record_right(machine, r), owner, sense);',
     '                node_machine_branch_operand(machine, r, 1, node_machine_record_right(machine, r), owner, !sense);'),
    ('c-branches-second-owner', C,
     '                node_machine_branch_operand(machine, r, 1, node_machine_record_right(machine, r), owner, sense);',
     '                node_machine_branch_operand(machine, r, 1, node_machine_record_right(machine, r), past ? r : owner, sense);'),
    ('c-branches-not-keeps-sense', C,
     '        takes = node_machine_branch_operand(machine, r, 0, a, owner, op == CHECK_OP_NOT ? !sense : sense);',
     '        takes = node_machine_branch_operand(machine, r, 0, a, owner, op == CHECK_OP_NOT ? sense : sense);'),
    ('c-branches-condition-swaps', C,
     '        takes = node_machine_branch_operand(machine, r, 0, a, owner, op == CHECK_OP_NOT ? !sense : sense);',
     '        takes = node_machine_branch_operand(machine, r, 0, a, owner, op == CHECK_OP_NOT ? !sense : !sense);'),
    ('c-branches-two-labels', C,
     '            machine->labeled_count += 1;\n            machine->label_count += 1;',
     '            machine->labeled_count += 1;\n            machine->label_count += 3;'),
    ('c-branches-operand-refusal-lost', C,
     '    return takes ? (CheckLowerTemplate)NODE_MACHINE_TEMPLATE_BRANCHES : CHECK_LOWER_TEMPLATE_NONE;',
     '    return takes ? (CheckLowerTemplate)NODE_MACHINE_TEMPLATE_BRANCHES : (CheckLowerTemplate)NODE_MACHINE_TEMPLATE_BRANCHES;'),
    # C: a value's first operand, the labels' numbers, the root
    ('c-logical-first-never-branched', C,
     '            if (node_machine_branch_condition(machine, a))\n            {\n                node_machine_evaluate(machine, r, a, false, 0);',
     '            if (a == UINT32_MAX && node_machine_branch_condition(machine, a))\n            {\n                node_machine_evaluate(machine, r, a, false, 0);'),
    ('c-logical-first-sense', C,
     '                node_machine_record_set_branch(machine, a, r, op == CHECK_OP_LOGICAL_OR, true);',
     '                node_machine_record_set_branch(machine, a, r, op != CHECK_OP_LOGICAL_OR, true);'),
    ('c-logical-first-owner', C,
     '                node_machine_record_set_branch(machine, a, r, op == CHECK_OP_LOGICAL_OR, true);',
     '                node_machine_record_set_branch(machine, a, BUSTER_NODE_MACHINE_NO_OWNER, op == CHECK_OP_LOGICAL_OR, true);'),
    ('c-labels-counted-as-two', C,
     '            base += before ? node_machine_record_labels(machine, other) : 0;',
     '            base += before ? 2 : 0;'),
    ('c-labels-ancestors-lost', C,
     '            const bool before = (other > r && firsts[j] <= r) || other < firsts[i];\n            base += before ? node_machine_record_labels(machine, other) : 0;',
     '            const bool before = other < firsts[i];\n            base += before ? node_machine_record_labels(machine, other) : 0;'),
    ('c-root-any-operator', C,
     '    if (node_machine_record_op(machine, root) == CHECK_OP_CONDITION && node_machine_branch_condition(machine, root))',
     '    if (node_machine_record_op(machine, root) != CHECK_OP_COUNT && node_machine_branch_condition(machine, root))'),
    ('c-root-never-branched', C,
     '    if (node_machine_record_op(machine, root) == CHECK_OP_CONDITION && node_machine_branch_condition(machine, root))',
     '    if (node_machine_record_op(machine, root) == CHECK_OP_COUNT && node_machine_branch_condition(machine, root))'),
    ('c-root-sense-false', C,
     '(context & BUSTER_NODE_MACHINE_ROOT_BRANCH_TRUE) != 0, true);',
     '(context & BUSTER_NODE_MACHINE_ROOT_BRANCH_TRUE) == 0x100, true);'),
    ('c-root-sense-true', C,
     '(context & BUSTER_NODE_MACHINE_ROOT_BRANCH_TRUE) != 0, true);',
     '(context & BUSTER_NODE_MACHINE_ROOT_BRANCH_TRUE) != 0x100, true);'),
    ('c-loop-branched-classified-as-value', C,
     '            const CheckLowerTemplate kind = __builtin_expect((state & BUSTER_NODE_MACHINE_BRANCHED) != 0, 0) ? node_machine_classify_branches(machine, r) :\n                                            node_machine_record_op(machine, r) == CHECK_OP_CALL ? node_machine_classify_call(machine, r) :\n                                                                                                   node_machine_classify(machine, r, r == root ? object : 0, &use);\n            node_machine_record_set_template',
     '            const CheckLowerTemplate kind = __builtin_expect((state & BUSTER_NODE_MACHINE_BRANCHED) == 0x100, 0) ? node_machine_classify_branches(machine, r) :\n                                            node_machine_record_op(machine, r) == CHECK_OP_CALL ? node_machine_classify_call(machine, r) :\n                                                                                                   node_machine_classify(machine, r, r == root ? object : 0, &use);\n            node_machine_record_set_template'),
    # the machine's accessors
    ('m-past-and-where-false', M,
     '    return (op == CHECK_OP_LOGICAL_AND && sense) || (op == CHECK_OP_LOGICAL_OR && !sense);',
     '    return (op == CHECK_OP_LOGICAL_AND && !sense) || (op == CHECK_OP_LOGICAL_OR && !sense);'),
    ('m-past-or-where-true', M,
     '    return (op == CHECK_OP_LOGICAL_AND && sense) || (op == CHECK_OP_LOGICAL_OR && !sense);',
     '    return (op == CHECK_OP_LOGICAL_AND && sense) || (op == CHECK_OP_LOGICAL_OR && sense);'),
    ('m-labels-always-two', M,
     '    return (machine->columns->states[r] & BUSTER_NODE_MACHINE_BRANCHED) != 0 ? 1 : 2;',
     '    return (machine->columns->states[r] & BUSTER_NODE_MACHINE_BRANCHED) != 0 ? 2 : 2;'),
    ('m-control-label-is-a-label', M,
     '    return owner == BUSTER_NODE_MACHINE_NO_OWNER ? BUSTER_NODE_MACHINE_CONTROL_LABEL : node_machine_record_label_base(machine, owner);',
     '    return owner == BUSTER_NODE_MACHINE_NO_OWNER ? 0 : node_machine_record_label_base(machine, owner);'),
    # X
    ('x-own-label-always-placed', X,
     '            if (node_machine_record_past(machine, r))\n            {\n                machine->label_entries[node_machine_record_label_base(machine, r)] = machine->entry_count;',
     '            if (node_machine_record_past(machine, r) || r != UINT32_MAX)\n            {\n                machine->label_entries[node_machine_record_label_base(machine, r)] = machine->entry_count;'),
    ('x-own-label-never-placed', X,
     '            if (node_machine_record_past(machine, r))\n            {\n                machine->label_entries[node_machine_record_label_base(machine, r)] = machine->entry_count;',
     '            if (node_machine_record_past(machine, r) && r == UINT32_MAX)\n            {\n                machine->label_entries[node_machine_record_label_base(machine, r)] = machine->entry_count;'),
    ('x-hook-sense', X,
     '    node_machine_put(machine, (state & BUSTER_NODE_MACHINE_BRANCH_TRUE) != 0 ? BUSTER_TYPED_BRANCH_TRUE : BUSTER_TYPED_BRANCH_FALSE, BUSTER_TYPED_CLASS_I32,',
     '    node_machine_put(machine, (state & BUSTER_NODE_MACHINE_BRANCH_TRUE) != 0 ? BUSTER_TYPED_BRANCH_FALSE : BUSTER_TYPED_BRANCH_TRUE, BUSTER_TYPED_CLASS_I32,'),
    ('x-hook-no-test', X,
     '    node_machine_put_truth(machine, node_machine_class(machine, node_machine_record_target(machine, r)), false);\n    node_machine_put(machine, (state',
     '    node_machine_put_truth(machine, node_machine_class(machine, node_machine_record_target(machine, r)), true);\n    node_machine_put(machine, (state'),
    ('x-after-branch-skipped', X,
     '    else if ((state & BUSTER_NODE_MACHINE_AFTER_BRANCH) != 0)\n    {\n        node_machine_branch_hook(machine, r, state);',
     '    else if ((state & BUSTER_NODE_MACHINE_AFTER_BRANCH) == 0x100)\n    {\n        node_machine_branch_hook(machine, r, state);'),
    ('x-split-for-any-state', X,
     '    else if ((state & BUSTER_NODE_MACHINE_SPLIT) != 0)\n    {\n        refusal = node_machine_split(machine, r);',
     '    else if ((state & BUSTER_NODE_MACHINE_SPLIT) != 0x100)\n    {\n        refusal = node_machine_split(machine, r);'),
    # the one sweep
    ('l-hook-sense', L,
     '        n = node_machine_back(out, n, (state & BUSTER_NODE_MACHINE_BRANCH_TRUE) != 0 ? BUSTER_TYPED_BRANCH_TRUE : BUSTER_TYPED_BRANCH_FALSE, BUSTER_TYPED_CLASS_I32,',
     '        n = node_machine_back(out, n, (state & BUSTER_NODE_MACHINE_BRANCH_TRUE) != 0 ? BUSTER_TYPED_BRANCH_FALSE : BUSTER_TYPED_BRANCH_TRUE, BUSTER_TYPED_CLASS_I32,'),
    ('l-after-branch-skipped', L,
     '    else if ((state & BUSTER_NODE_MACHINE_AFTER_BRANCH) != 0)\n    {\n        // node_machine_branch_hook',
     '    else if ((state & BUSTER_NODE_MACHINE_AFTER_BRANCH) == 0x100)\n    {\n        // node_machine_branch_hook'),
    ('l-split-for-any-state', L,
     '    else if ((state & BUSTER_NODE_MACHINE_SPLIT) != 0)\n    {\n        const uint32_t before = n;',
     '    else if ((state & BUSTER_NODE_MACHINE_SPLIT) != 0x100)\n    {\n        const uint32_t before = n;'),
    ('l-own-label-always-placed', L,
     '            if (node_machine_record_past(machine, r))\n            {\n                ends[node_machine_record_label_base(machine, r)] = n;',
     '            if (node_machine_record_past(machine, r) || r != UINT32_MAX)\n            {\n                ends[node_machine_record_label_base(machine, r)] = n;'),
    ('l-own-label-never-placed', L,
     '            if (node_machine_record_past(machine, r))\n            {\n                ends[node_machine_record_label_base(machine, r)] = n;',
     '            if (node_machine_record_past(machine, r) && r == UINT32_MAX)\n            {\n                ends[node_machine_record_label_base(machine, r)] = n;'),
    ('l-number-second-label-always', L,
     '            if (node_machine_record_labels(machine, met[k]) == 2)\n            {\n                machine->label_entries[base + 1] = n - ends[2 * k + 1];',
     '            if (node_machine_record_labels(machine, met[k]) != 0)\n            {\n                machine->label_entries[base + 1] = n - ends[2 * k + 1];'),
    ('l-number-second-label-never', L,
     '            if (node_machine_record_labels(machine, met[k]) == 2)\n            {\n                machine->label_entries[base + 1] = n - ends[2 * k + 1];',
     '            if (node_machine_record_labels(machine, met[k]) == 3)\n            {\n                machine->label_entries[base + 1] = n - ends[2 * k + 1];'),
    ('l-met-not-doubled', L,
     '                node_machine_record_set_label_base(machine, r, 2 * labeled);',
     '                node_machine_record_set_label_base(machine, r, labeled);'),
    ('l-loop-branched-classified-as-value', L,
     '            const CheckLowerTemplate kind = __builtin_expect((state & BUSTER_NODE_MACHINE_BRANCHED) != 0, 0) ? node_machine_classify_branches(machine, r) :\n                                            node_machine_record_op(machine, r) == CHECK_OP_CALL ? node_machine_classify_call(machine, r) :\n                                                                                                   node_machine_classify(machine, r, r == root ? object : 0, &use);\n            refusal',
     '            const CheckLowerTemplate kind = __builtin_expect((state & BUSTER_NODE_MACHINE_BRANCHED) == 0x100, 0) ? node_machine_classify_branches(machine, r) :\n                                            node_machine_record_op(machine, r) == CHECK_OP_CALL ? node_machine_classify_call(machine, r) :\n                                                                                                   node_machine_classify(machine, r, r == root ? object : 0, &use);\n            refusal'),
    # reader time: a do statement's sense
    ('r-do-any-condition', R,
     "    const bool repeats = parent < parser->tokens.count && parser->tree.roles[parent] == PARSE_ROLE_TERMINATOR;",
     "    const bool repeats = parent < parser->tokens.count && parser->tree.roles[parent] != PARSE_ROLE_COUNT;"),
    ('r-do-never', R,
     "    const bool repeats = parent < parser->tokens.count && parser->tree.roles[parent] == PARSE_ROLE_TERMINATOR;",
     "    const bool repeats = parent < parser->tokens.count && parser->tree.roles[parent] == PARSE_ROLE_COUNT;"),
    # the shadow: the control's sense and its label's entry
    ('n-sense-never', N,
     "    const uint8_t root_context = (uint8_t)(task_context | (branch_true ? BUSTER_NODE_MACHINE_ROOT_BRANCH_TRUE : 0u));",
     "    const uint8_t root_context = (uint8_t)(task_context | (branch_true ? 0u : 0u));"),
    ('n-sense-always', N,
     "    const uint8_t root_context = (uint8_t)(task_context | (branch_true ? BUSTER_NODE_MACHINE_ROOT_BRANCH_TRUE : 0u));",
     "    const uint8_t root_context = (uint8_t)(task_context | (branch_true ? BUSTER_NODE_MACHINE_ROOT_BRANCH_TRUE : BUSTER_NODE_MACHINE_ROOT_BRANCH_TRUE));"),
    ('n-control-entry-next-label', N,
     "    const uint64_t control_label = branching ? (uint64_t)pop->labels + control->target : UINT64_MAX;",
     "    const uint64_t control_label = branching ? (uint64_t)pop->labels + control->target + 1 : UINT64_MAX;"),
    ('n-control-entry-body-base-lost', N,
     "    const uint64_t control_label = branching ? (uint64_t)pop->labels + control->target : UINT64_MAX;",
     "    const uint64_t control_label = branching ? (uint64_t)control->target : UINT64_MAX;"),
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
        if old == new or s.count(new) != 0:
            print(name, 'new text is not new', s.count(new)); ok = False
        t = s.replace(old, new)
        if t.count(new) != 1 or t.replace(new, old) != s:
            print(name, 'does not revert'); ok = False
    print(len(MUTANTS), 'faults;', 'all unique' if ok else 'PROBLEMS')
    return ok

def run(only):
    if not check():
        sys.exit(1)
    results = open('/home/user/mut/results.txt', 'a')
    for name, f, old, new in MUTANTS:
        if only and name not in only:
            continue
        path = SRC + f
        saved = '/home/user/mut/saved.c'
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
    # the tree as it was, rebuilt
    subprocess.run(['./build.sh', '--config', 'Debug'], cwd=TREE, capture_output=True, text=True)
    print('campaign done', flush=True)
    results.write('campaign done\n'); results.flush()

if __name__ == '__main__':
    if len(sys.argv) > 1 and sys.argv[1] == 'check':
        sys.exit(0 if check() else 1)
    run(sys.argv[2:])
