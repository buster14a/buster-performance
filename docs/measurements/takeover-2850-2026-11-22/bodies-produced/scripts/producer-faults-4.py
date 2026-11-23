#!/usr/bin/env python3
# producer-faults-4.py TREE: single changes to the refusals for a naked function, for an always_inline one's body and
# its calls, and to the reader's flag for a fusing target as it is made since,
# each built (Develop) and run against the fixtures (test-checker part 45/64), which must fail; the tree's file is put
# back after each. A fault is (name, file, old, new, which): `which` the occurrence of `old` changed (0: the only one).
import subprocess, sys, os
tree = sys.argv[1]
BUILD = ['./build.sh', '--config', 'Develop', '--target', 'compiler']
base = os.path.join(tree, 'src/buster/compiler')
M = 'c_check_node_machine.c'
R = 'c_check_node_machine_reader.c'
T = 'c_check_node_machine_type.c'
B = 'c_check_node_bodies.c'
faults = [
    ("a naked function's body taken", B,
     "(!none && (class < BUSTER_TYPED_CLASS_I8 || class > BUSTER_TYPED_CLASS_F64)) || naked || inlined)",
     "(!none && (class < BUSTER_TYPED_CLASS_I8 || class > BUSTER_TYPED_CLASS_F64)) || (naked && opening == UINT32_MAX) || inlined)", 0),
    ("the body of a function a declaration gives always_inline taken", B,
     "(!none && (class < BUSTER_TYPED_CLASS_I8 || class > BUSTER_TYPED_CLASS_F64)) || naked || inlined)",
     "(!none && (class < BUSTER_TYPED_CLASS_I8 || class > BUSTER_TYPED_CLASS_F64)) || naked || (inlined && opening == UINT32_MAX))", 0),
    ("T takes a call of a callee a declaration gives always_inline", T,
     "        refused = node_machine_object_twice(machine, object) || node_machine_object_inlined(machine, object);",
     "        refused = node_machine_object_twice(machine, object) || (node_machine_object_inlined(machine, object) && r == UINT32_MAX);", 0),
    ("the reader's facts do not say a declaration gives always_inline", R,
     "                    machine->reader_facts[object] |= (bits & BUSTER_CHECK_PROGRAM_ATTRIBUTE_ALWAYS_INLINE) != 0 ? BUSTER_NODE_MACHINE_OBJECT_INLINED : 0;",
     "                    machine->reader_facts[object] |= (bits & BUSTER_CHECK_PROGRAM_ATTRIBUTE_ALWAYS_INLINE) != 0 && token == UINT32_MAX ? BUSTER_NODE_MACHINE_OBJECT_INLINED : 0;", 0),
    ("the program's column of always_inline not read after the pipeline", M,
     "    return program != NULL ? program->object_inline != NULL && (program->object_inline[object] & BUSTER_CHECK_PROGRAM_INLINE_ALWAYS) != 0 :",
     "    return program != NULL ? program->object_inline != NULL && (program->object_inline[object] & BUSTER_CHECK_PROGRAM_INLINE_ALWAYS) != 0 && object == UINT32_MAX :", 0),
    ("the reader's machine does not take a function's own target for one that fuses", R,
     "                    machine->fuses |= (bits & BUSTER_CHECK_PROGRAM_ATTRIBUTE_TARGET) != 0;",
     "                    machine->fuses |= (bits & BUSTER_CHECK_PROGRAM_ATTRIBUTE_TARGET) != 0 && token == UINT32_MAX;", 0),
    ("the reader's machine does not read the options' target", R,
     "        typer->machine.fuses |= (reader->pp->options.target.features & BUSTER_NODE_MACHINE_FUSED) != 0;",
     "        typer->machine.fuses |= (reader->pp->options.target.features & BUSTER_NODE_MACHINE_FUSED) != 0 && capacity == UINT32_MAX;", 0),
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
