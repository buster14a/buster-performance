#!/usr/bin/env python3
# before-faults.py TREE: single changes to the same comparison made before the walk (what the machine keeps beside a tape,
# the bodies' entries from the kept tapes, the controls' twin from the tokens), each built (Develop) and run against the
# fixture (test-checker part 45/64), which must fail; the tree's file is put back after each.
import subprocess, sys, os
tree = sys.argv[1]
R = 'src/buster/compiler/c_check_node_machine_reader.c'
A = 'src/buster/compiler/c_check_node_machine_alone.c'
C = 'src/buster/compiler/c_check_node_census.c'
N = 'src/buster/compiler/c_check_node_bodies.c'
faults = [
    ("a kept label's place one entry later", R,
     "        types->side_label_count += machine->label_count;",
     "        types->side_labels[types->side_label_count] += machine->label_count != 0;\n        types->side_label_count += machine->label_count;"),
    ("a root's temporaries not kept", R,
     "    types->side_temporaries[root] = room ? machine->temporary_count : 0;",
     "    types->side_temporaries[root] = 0;"),
    ("a root that is branches not said so", R,
     "(node_machine_record_state(machine, last) & BUSTER_NODE_MACHINE_BRANCHED) != 0 ? BUSTER_NODE_FRONT_SIDE_BRANCHED : 0u",
     "(node_machine_record_state(machine, last) & BUSTER_NODE_MACHINE_BRANCHED) != 0 ? 0u : 0u"),
    ("a constant root not said so", R,
     "(constant ? BUSTER_NODE_FRONT_SIDE_CONSTANT : 0u)",
     "(constant ? 0u : 0u)"),
    ("a kept call's callee none", R,
     "            types->side_call_targets[row] = node_machine_call_target(machine, r);",
     "            types->side_call_targets[row] = 0 * node_machine_call_target(machine, r);"),
    ("a kept call variadic where it is not", R,
     "            types->side_call_variadic[row] = node_machine_call_variadic(machine, r);",
     "            types->side_call_variadic[row] = !node_machine_call_variadic(machine, r);"),
    ("a kept argument's class the next one", R,
     "types->side_argument_classes[types->side_argument_count + i] = node_machine_class(machine, node_machine_record_argument_converted(machine, r, i));",
     "types->side_argument_classes[types->side_argument_count + i] = (uint8_t)(node_machine_class(machine, node_machine_record_argument_converted(machine, r, i)) + 1);"),
    ("an initialization's root kept under its own token", A,
     "                        const uint32_t control = initialization ? reader->initializer_declarations[own] : own;",
     "                        const uint32_t control = initialization && own == 0 ? reader->initializer_declarations[own] : own;"),
    ("a kept global's object left an object", C,
     "                    .objects = true,",
     "                    .objects = false,"),
    ("an if's constant condition not looked for", C,
     "            constant = slot != 0 && slot != UINT32_MAX && slot - 1 < kept->node_capacity && kept->side_label_firsts[slot - 1] != UINT32_MAX &&",
     "            constant = slot == 0 && slot != UINT32_MAX && slot - 1 < kept->node_capacity && kept->side_label_firsts[slot - 1] != UINT32_MAX &&"),
    ("the twin: an else's jump to the else", N,
     "                node_twin_entry(twin, CHECK_CONTROL_JUMP, token, false, end);\n            }\n            node_twin_statement(twin, body, task.stop, task.repeat);",
     "                node_twin_entry(twin, CHECK_CONTROL_JUMP, token, false, otherwise);\n            }\n            node_twin_statement(twin, body, task.stop, task.repeat);"),
    ("the twin: a while's branch to its start", N,
     "            node_twin_entry(twin, CHECK_CONTROL_BRANCH_FALSE, token, true, end);\n            node_twin_mark(twin, start);",
     "            node_twin_entry(twin, CHECK_CONTROL_BRANCH_FALSE, token, true, start);\n            node_twin_mark(twin, start);"),
    ("the twin: a do statement's branch of the other sense", N,
     "            node_twin_entry(twin, CHECK_CONTROL_BRANCH_TRUE, condition, true, start);",
     "            node_twin_entry(twin, CHECK_CONTROL_BRANCH_FALSE, condition, true, start);"),
    ("the twin: a for's condition left out", N,
     "            if (node_twin_valued(twin, condition))\n            {\n                node_twin_entry(twin, CHECK_CONTROL_BRANCH_FALSE, condition, true, end);",
     "            if (node_twin_valued(twin, condition) && body == BUSTER_CHECK_NONE)\n            {\n                node_twin_entry(twin, CHECK_CONTROL_BRANCH_FALSE, condition, true, end);"),
    ("the twin: a break to its loop's repeat", N,
     "                node_twin_entry(twin, CHECK_CONTROL_JUMP, jump, false, kind == PARSE_KIND_BREAK ? task.stop : task.repeat);",
     "                node_twin_entry(twin, CHECK_CONTROL_JUMP, jump, false, task.repeat != BUSTER_CHECK_NONE ? task.repeat : task.stop);"),
    ("the twin: a goto to the body's first label", N,
     "                    node_twin_entry(twin, CHECK_CONTROL_JUMP, jump, false, twin->source_labels[target - twin->opening]);",
     "                    node_twin_entry(twin, CHECK_CONTROL_JUMP, jump, false, 0 * twin->source_labels[target - twin->opening] + twin->label_count - 1);"),
    ("the twin: every return with a value", N,
     "                node_twin_entry(twin, CHECK_CONTROL_RETURN, jump, node_twin_valued(twin, jump), BUSTER_CHECK_NONE);",
     "                node_twin_entry(twin, CHECK_CONTROL_RETURN, jump, node_twin_valued(twin, jump) || true, BUSTER_CHECK_NONE);"),
    ("the twin: an initialization at its terminator", N,
     "twin->entries[twin->count++] = (NodeTwinControl){ .kind = CHECK_CONTROL_INITIALIZE, .token = declaration, .target = BUSTER_CHECK_NONE, .valued = false };",
     "twin->entries[twin->count++] = (NodeTwinControl){ .kind = CHECK_CONTROL_INITIALIZE, .token = declaration != BUSTER_CHECK_NONE ? task.token : declaration, .target = BUSTER_CHECK_NONE, .valued = false };"),
    ("the twin: a block's static declaration not left out", N,
     "            node_twin_fail(twin, NODE_TWIN_STATIC);",
     "            node_twin_fail(twin, NODE_TWIN_ATTEMPTED);"),
    ("the twin: a label's statement without its label", N,
     "        node_twin_mark(twin, twin->source_labels[token - twin->opening]);\n    }\n    else if (role == PARSE_ROLE_CLOSE_CASE)",
     "    }\n    else if (role == PARSE_ROLE_CLOSE_CASE)"),
]
originals = {f: open(os.path.join(tree, f)).read() for f in (R, A, C, N)}
caught = 0
for name, file, old, new in faults:
    original = originals[file]
    assert original.count(old) == 1, (name, original.count(old))
    open(os.path.join(tree, file), 'w').write(original.replace(old, new))
    build = subprocess.run(['./build.sh', '--config', 'Develop', '--target', 'compiler'], cwd=tree, capture_output=True, text=True)
    if build.returncode != 0:
        print(f"{name}: DID NOT BUILD"); print((build.stdout + build.stderr)[-500:])
    else:
        run = subprocess.run(['./build/cmake/native/Develop/compiler', 'test-checker', '--part', '45/64'], cwd=tree, capture_output=True, text=True)
        out = run.stdout + run.stderr
        tail = out.strip().splitlines()[-1] if out.strip() else ''
        failed = run.returncode != 0
        caught += failed
        print(f"{name}: {'fails the fixture' if failed else 'NOT CAUGHT'} (status {run.returncode}; {tail})", flush=True)
    open(os.path.join(tree, file), 'w').write(original)
build = subprocess.run(['./build.sh', '--config', 'Develop', '--target', 'compiler'], cwd=tree, capture_output=True, text=True)
print(f"{caught} of {len(faults)} fail the fixture; the files are put back and built again (status {build.returncode})")
