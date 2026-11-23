#!/usr/bin/env python3
# producer-faults-5.py TREE: single changes to C's rule for a volatile access (#3310's mirror),
# each built (Develop) and run against the fixtures (test-checker part 45/64), which must fail; the tree's file is put
# back after each. A fault is (name, file, old, new, which): `which` the occurrence of `old` changed (0: the only one).
import subprocess, sys, os
tree = sys.argv[1]
BUILD = ['./build.sh', '--config', 'Develop', '--target', 'compiler']
base = os.path.join(tree, 'src/buster/compiler')
M = 'c_check_node_census.c'
R = 'c_check_node_machine_reader.c'
X = 'c_check_node_machine_contexts.c'
faults = [
    ("C has a template for a volatile lvalue's read", X,
     "    else if (machine->marks && !address && category == CHECK_LVALUE && check_lower_volatile(class, node_machine_record_type(machine, r)) &&",
     "    else if (machine->marks && r == UINT32_MAX && !address && category == CHECK_LVALUE && check_lower_volatile(class, node_machine_record_type(machine, r)) &&", 0),
    ("C has no template for a volatile local's read by its name", X,
     "             !(op == CHECK_OP_VALUE && known && node_machine_local(machine, known_object)))",
     "             !(op == CHECK_OP_VALUE && known && node_machine_local(machine, known_object) && r == UINT32_MAX))", 0),
    ("C has a template for a store to a volatile lvalue", X,
     "                const bool marked = machine->marks && op == CHECK_OP_ASSIGN && a < r && check_lower_volatile(class, node_machine_record_type(machine, a)) &&",
     "                const bool marked = machine->marks && r == UINT32_MAX && op == CHECK_OP_ASSIGN && a < r && check_lower_volatile(class, node_machine_record_type(machine, a)) &&", 0),
    ("C has no template for a store to a volatile local by its name", X,
     "                                    !(named && node_machine_local(machine, target));",
     "                                    !(named && node_machine_local(machine, target) && r == UINT32_MAX);", 0),
    ("an update of a volatile lvalue has a plan", X,
     "    takes = takes && !(machine->marks && check_lower_volatile(stored_class, stored) && !local);",
     "    takes = takes && !(machine->marks && r == UINT32_MAX && check_lower_volatile(stored_class, stored) && !local);", 0),
    ("an update of a volatile local by its name has no plan", X,
     "    takes = takes && !(machine->marks && check_lower_volatile(stored_class, stored) && !local);",
     "    takes = takes && !(machine->marks && check_lower_volatile(stored_class, stored));", 0),
    ("the reader's machine does not leave volatile accesses", R,
     "        typer->machine.marks = (options & BUSTER_NODE_READER_WINDOW) == 0;",
     "        typer->machine.marks = (options & BUSTER_NODE_READER_WINDOW) == 0 && capacity == UINT32_MAX;", 0),
    ("the pipeline's machine does not leave volatile accesses", M,
     "                machine.marks = (shadow->reader & BUSTER_NODE_READER_WINDOW) == 0;",
     "                machine.marks = (shadow->reader & BUSTER_NODE_READER_WINDOW) == 0 && objects == UINT32_MAX;", 0),
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
        print(f"{name}: NOT APPLIED {e}", flush=True); continue
    open(path, 'w').write(changed)
    build = subprocess.run(BUILD, cwd=tree, capture_output=True, text=True)
    if build.returncode != 0:
        print(f"{name}: DID NOT BUILD"); print((build.stdout + build.stderr)[-600:], flush=True); open(path, 'w').write(original); continue
    run = subprocess.run(['./build/cmake/native/Develop/compiler', 'test-checker', '--part', '45/64'], cwd=tree, capture_output=True, text=True)
    out = run.stdout + run.stderr
    lines = [l for l in out.splitlines() if l.startswith('test-checker: node-') and 'checks' not in l]
    tail = out.strip().splitlines()[-1] if out.strip() else ''
    failed = run.returncode != 0
    caught += failed
    print(f"{name}: {'fails the fixture' if failed else 'NOT CAUGHT'} (status {run.returncode}; {tail})", flush=True)
    for l in lines[-3:]:
        print('    ' + l[:300], flush=True)
    open(path, 'w').write(original)
build = subprocess.run(BUILD, cwd=tree, capture_output=True, text=True)
print(f"{caught} of {len(faults)} fail the fixture; the files are put back and built again (status {build.returncode})", flush=True)
