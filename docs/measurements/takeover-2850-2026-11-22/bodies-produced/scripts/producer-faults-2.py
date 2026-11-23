#!/usr/bin/env python3
# producer-faults.py TREE: single changes to the producer's refusals (what stands, before the walk, for a diagnostic of
# the walk's or of a pass after it), each built (Develop) and run against the fixtures (test-checker part 45/64), which
# must fail; the tree's file is put back after each. A fault is (name, file, old, new, which): `which` the occurrence of
# `old` changed (0: the only one).
import subprocess, sys, os
tree = sys.argv[1]
BUILD = ['./build.sh', '--config', 'Develop', '--target', 'compiler']
base = os.path.join(tree, 'src/buster/compiler')
R = 'c_check_node_machine_reader.c'
B = 'c_check_node_bodies.c'
C = 'c_check_node_census.c'
conv = "                loud = (from != 0 && from != plain) || (arms && node_machine_arm_changes(machine, o, plain, 8));"
init = "        loud = (from != 0 && from != plain) || (arms && node_machine_arm_changes(machine, o, plain, 8));"
faults = [
    ("an operand's conversion to another enumeration not asked", R, conv,
     "                loud = (from != 0 && from != plain && plain == 0) || (arms && node_machine_arm_changes(machine, o, plain, 8));", 1),
    ("an operand's conditional's arms not asked", R, conv,
     "                loud = (from != 0 && from != plain) || (arms && plain == 0 && node_machine_arm_changes(machine, o, plain, 8));", 1),
    ("an argument's conversion to another enumeration not asked", R, conv,
     "                loud = (from != 0 && from != plain && plain == 0) || (arms && node_machine_arm_changes(machine, o, plain, 8));", 2),
    ("an initialization's conversion not asked", R, init,
     "        loud = (from != 0 && from != plain) || (arms && plain == 0 && node_machine_arm_changes(machine, o, plain, 8));", 3),
    ("a floating arm quiet to a smaller floating type", R,
     "            changes = !(target_floating && check_action_kind(types, source) == BUSTER_TYPE_KIND_FLOATING && type_size(types, target) >= type_size(types, source));",
     "            changes = !(target_floating && check_action_kind(types, source) == BUSTER_TYPE_KIND_FLOATING);", 0),
    ("an integer arm quiet to a floating target whatever its value", R,
     "            const bool exact = whole && target_floating && !huge && value > -(INT64_C(1) << 24) && value < (INT64_C(1) << 24);",
     "            const bool exact = whole && target_floating && !huge && value > -(INT64_C(1) << 62) && value < (INT64_C(1) << 62);", 0),
    ("an integer arm never quiet", R,
     "            changes = !exact;",
     "            changes = !exact || whole;", 0),
    ("an internal function the unit does not define named", B,
     "            if (!defined)\n            {\n                reason = NODE_PRODUCER_TOKEN;",
     "            if (!defined && object == 0)\n            {\n                reason = NODE_PRODUCER_TOKEN;", 0),
    ("a counted member's unit taken", B,
     "                         counted_member || input->marked_member_count != 0 ? BUSTER_NODE_PRODUCER_UNIT_MEMBERS :",
     "                         (counted_member && input->token_count == UINT32_MAX) || input->marked_member_count != 0 ? BUSTER_NODE_PRODUCER_UNIT_MEMBERS :", 0),
    ("a result's attribute on a type not looked for", B,
     "                results |= attributes != NULL && attributes->results && !function;",
     "                results |= attributes != NULL && attributes->results && !function && token == UINT32_MAX;", 0),
    ("a function's result's attribute taken for a type's", B,
     "                results |= attributes != NULL && attributes->results && !function;",
     "                results |= attributes != NULL && attributes->results && (!function || token != UINT32_MAX);", 0),
    ("a compound shift's count against its operand's promoted width, at reader time", C,
     "        const uint32_t promoted = operand_width < 32 && !compound ? 32 : operand_width;",
     "        const uint32_t promoted = operand_width < 32 && (!compound || op == CHECK_OP_SHIFT_LEFT_ASSIGN || op == CHECK_OP_SHIFT_RIGHT_ASSIGN) ? 32 : operand_width;", 0),
    ("a compound shift's count against its operand's promoted width, after the pipeline", C,
     "        const uint32_t promoted = width < 32 && !compound ? 32 : width;",
     "        const uint32_t promoted = width < 32 && (!compound || op == CHECK_OP_SHIFT_LEFT_ASSIGN || op == CHECK_OP_SHIFT_RIGHT_ASSIGN) ? 32 : width;", 0),
    ("an initialization of an object aligned past 8 bytes by its attribute taken", B,
     "            const bool plain = scalar && (attributes == NULL || attributes->alignment_log2 == 0) && type_alignment_log2(types, declared) <= 3;",
     "            const bool plain = scalar && (attributes == NULL || attributes->alignment_log2 == 0 || scalar) && type_alignment_log2(types, declared) <= 3;", 0),
    ("the comparison attempts an initialization of an object aligned by its attribute", C,
     "        const bool local = scalar && (attributes == NULL || attributes->alignment_log2 == 0) && type_alignment_log2(types, declared) <= 3;",
     "        const bool local = scalar && (attributes == NULL || attributes->alignment_log2 == 0 || scalar) && type_alignment_log2(types, declared) <= 3;", 0),
    ("a parameter's evaluated bound not looked for", B,
     "    const uint32_t declared_from = function < opening ? function : opening;",
     "    const uint32_t declared_from = function < opening ? opening : opening;", 0),
    ("something said before the walk not found", B,
     "        reason = low < producer->said_count && producer->said[low] <= last ? NODE_PRODUCER_SAID : reason;",
     "        reason = low < producer->said_count && producer->said[low] <= last && producer->said[low] < first ? NODE_PRODUCER_SAID : reason;", 0),
]
def replace_nth(text, old, new, which):
    count = text.count(old)
    if which == 0:
        assert count == 1, (old[:60], count)
        return text.replace(old, new)
    assert count >= which, (old[:60], count, which)
    at = -1
    for _ in range(which):
        at = text.index(old, at + 1)
    return text[:at] + new + text[at + len(old):]
caught = 0
for name, file, old, new, which in faults:
    path = os.path.join(base, file)
    original = open(path).read()
    try:
        changed = replace_nth(original, old, new, which)
    except AssertionError as e:
        print(f"{name}: NOT APPLIED {e}"); continue
    open(path, 'w').write(changed)
    build = subprocess.run(BUILD, cwd=tree, capture_output=True, text=True)
    if build.returncode != 0:
        print(f"{name}: DID NOT BUILD"); print((build.stdout + build.stderr)[-600:]); open(path, 'w').write(original); continue
    run = subprocess.run(['./build/cmake/native/Develop/compiler', 'test-checker', '--part', '45/64'], cwd=tree, capture_output=True, text=True)
    out = run.stdout + run.stderr
    lines = [l for l in out.splitlines() if l.startswith('test-checker: node-producer') or 'FAIL' in l]
    tail = out.strip().splitlines()[-1] if out.strip() else ''
    failed = run.returncode != 0
    caught += failed
    print(f"{name}: {'fails the fixture' if failed else 'NOT CAUGHT'} (status {run.returncode}; {tail})")
    for l in lines[:3]:
        print('    ' + l[:400])
    open(path, 'w').write(original)
build = subprocess.run(BUILD, cwd=tree, capture_output=True, text=True)
print(f"{caught} of {len(faults)} fail the fixture; the files are put back and built again (status {build.returncode})")
