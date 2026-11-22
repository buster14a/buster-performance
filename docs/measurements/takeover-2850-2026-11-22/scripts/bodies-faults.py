#!/usr/bin/env python3
# bodies-faults.py TREE: single changes to the piece that makes a body's entries from its controls and its tapes, each
# built (Develop) and run against the fixture (test-checker part 45/64), which must fail; the tree's file is put back
# after each.
import subprocess, sys, os
tree = sys.argv[1]
path = os.path.join(tree, 'src/buster/compiler/c_check_node_census.c')
original = open(path).read()
faults = [
    ("a jump's target one control later",
     "node_bodies_put(built, BUSTER_TYPED_JUMP, BUSTER_TYPED_CLASS_VOID, control->target, BUSTER_NODE_BODIES_LABEL);",
     "node_bodies_put(built, BUSTER_TYPED_JUMP, BUSTER_TYPED_CLASS_VOID, control->target + 1, BUSTER_NODE_BODIES_LABEL);"),
    ("no branch of the control's own after a condition",
     "if ((kind == CHECK_CONTROL_BRANCH_FALSE || kind == CHECK_CONTROL_BRANCH_TRUE) && !built->branched)",
     "if ((kind == CHECK_CONTROL_BRANCH_FALSE || kind == CHECK_CONTROL_BRANCH_TRUE) && built->branched)"),
    ("a branch of the control's own after a condition that is branches",
     "    built->branched = tape->branched;",
     "    built->branched = false;"),
    ("a branch taken where the condition holds for one that is not",
     "node_bodies_put(built, kind == CHECK_CONTROL_BRANCH_FALSE ? BUSTER_TYPED_BRANCH_FALSE : BUSTER_TYPED_BRANCH_TRUE, BUSTER_TYPED_CLASS_I32, control->target,",
     "node_bodies_put(built, BUSTER_TYPED_BRANCH_FALSE, BUSTER_TYPED_CLASS_I32, control->target,"),
    ("a return's class the first integer's",
     "            node_bodies_put(built, BUSTER_TYPED_RETURN, built->result_class, 0, BUSTER_NODE_BODIES_VALUE);",
     "            node_bodies_put(built, BUSTER_TYPED_RETURN, BUSTER_TYPED_CLASS_I8, 0, BUSTER_NODE_BODIES_VALUE);"),
    ("an initialization's store of another class",
     "node_bodies_put(built, BUSTER_TYPED_SET_LOCAL, node_machine_class(s->machine, plan->type), object, BUSTER_NODE_BODIES_OBJECT);",
     "node_bodies_put(built, BUSTER_TYPED_SET_LOCAL, (uint8_t)(node_machine_class(s->machine, plan->type) + 2), object, BUSTER_NODE_BODIES_OBJECT);"),
    ("the tapes' temporaries not counted",
     "    built->temporaries += tape->temporaries;",
     "    built->temporaries += 0;"),
    ("the tapes' calls not counted",
     "    built->calls += tape->calls;",
     "    built->calls += 0;"),
    ("a tape's label one entry later",
     "value < tape->label_count ? (uint64_t)start + tape->labels[value] : UINT64_MAX,",
     "value < tape->label_count ? (uint64_t)start + tape->labels[value] + 1 : UINT64_MAX,"),
    ("a control's own label taken for a tape's",
     "        else if (branch && value == BUSTER_NODE_MACHINE_CONTROL_LABEL)\n        {\n            node_bodies_put(built, entry, tape->classes[t], program->controls[built->body->first + index].target, BUSTER_NODE_BODIES_LABEL);",
     "        else if (branch && value == BUSTER_NODE_MACHINE_CONTROL_LABEL)\n        {\n            node_bodies_put(built, entry, tape->classes[t], program->controls[built->body->first + index].target + 1, BUSTER_NODE_BODIES_LABEL);"),
    ("no implicit return of a void function",
     "        if (built->result_void)\n        {\n            node_bodies_put(built, BUSTER_TYPED_RETURN, BUSTER_TYPED_CLASS_VOID, 0, BUSTER_NODE_BODIES_VALUE);\n        }\n        else if",
     "        if (false)\n        {\n            node_bodies_put(built, BUSTER_TYPED_RETURN, BUSTER_TYPED_CLASS_VOID, 0, BUSTER_NODE_BODIES_VALUE);\n        }\n        else if"),
    ("no zero for main's implicit return",
     "            node_bodies_put(built, BUSTER_TYPED_CONST, BUSTER_TYPED_CLASS_I32, 0, BUSTER_NODE_BODIES_VALUE);\n            node_bodies_put(built, BUSTER_TYPED_RETURN, BUSTER_TYPED_CLASS_I32, 0, BUSTER_NODE_BODIES_VALUE);",
     "            node_bodies_put(built, BUSTER_TYPED_RETURN, BUSTER_TYPED_CLASS_I32, 0, BUSTER_NODE_BODIES_VALUE);"),
    ("a control's label at its root's last entry",
     "        node_bodies_close(built, s);\n        built->labels[built->next] = built->count;\n        built->open = built->next;",
     "        node_bodies_close(built, s);\n        built->labels[built->next] = built->count + 1;\n        built->open = built->next;"),
    ("a call's row the tape's own",
     "            node_bodies_put(built, entry, tape->classes[t], built->calls + value, BUSTER_NODE_BODIES_VALUE);",
     "            node_bodies_put(built, entry, tape->classes[t], value + 0, BUSTER_NODE_BODIES_VALUE);"),
    ("a temporary's number the tape's own",
     "node_bodies_put(built, entry, tape->classes[t], built->temporaries + (value & ~BUSTER_NODE_MACHINE_TEMPORARY), BUSTER_NODE_BODIES_TEMPORARY);",
     "node_bodies_put(built, entry, tape->classes[t], value & ~BUSTER_NODE_MACHINE_TEMPORARY, BUSTER_NODE_BODIES_TEMPORARY);"),
    ("a body with a switch attempted",
     "                 kind != CHECK_CONTROL_BRANCH_FALSE && kind != CHECK_CONTROL_BRANCH_TRUE && kind != CHECK_CONTROL_JUMP)",
     "                 kind != CHECK_CONTROL_BRANCH_FALSE && kind != CHECK_CONTROL_BRANCH_TRUE && kind != CHECK_CONTROL_JUMP && kind != CHECK_CONTROL_SWITCH && kind != CHECK_CONTROL_CASE)"),
]
caught = 0
for name, old, new in faults:
    assert original.count(old) == 1, (name, original.count(old))
    open(path, 'w').write(original.replace(old, new))
    build = subprocess.run(['./build.sh', '--config', 'Develop', '--target', 'compiler'], cwd=tree, capture_output=True, text=True)
    if build.returncode != 0:
        print(f"{name}: DID NOT BUILD"); print(build.stdout[-600:]); continue
    run = subprocess.run(['./build/cmake/native/Develop/compiler', 'test-checker', '--part', '45/64'], cwd=tree, capture_output=True, text=True)
    out = run.stdout + run.stderr
    lines = [l for l in out.splitlines() if 'node-bodies' in l and 'bodies lowered' in l]
    tail = out.strip().splitlines()[-1] if out.strip() else ''
    failed = run.returncode != 0
    caught += failed
    print(f"{name}: {'fails the fixture' if failed else 'NOT CAUGHT'} (status {run.returncode}; {tail})")
    for l in lines[:2]:
        print('    ' + l[:330])
open(path, 'w').write(original)
build = subprocess.run(['./build.sh', '--config', 'Develop', '--target', 'compiler'], cwd=tree, capture_output=True, text=True)
print(f"{caught} of {len(faults)} fail the fixture; the file is put back and built again (status {build.returncode})")
