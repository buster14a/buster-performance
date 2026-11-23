#!/usr/bin/env python3
# producer-faults-3.py TREE: single changes to the machine's rule for a target that fuses a product and a sum
# (NodeMachine.fuses: C's two refusals, the flag at the pipeline's and at the reader's time, and the window's listing),
# each built (Develop) and run against the fixtures (test-checker part 45/64), which must fail; the tree's file is put
# back after each. A fault is (name, file, old, new, which): `which` the occurrence of `old` changed (0: the only one).
import subprocess, sys, os
tree = sys.argv[1]
BUILD = ['./build.sh', '--config', 'Develop', '--target', 'compiler']
base = os.path.join(tree, 'src/buster/compiler')
M = 'c_check_node_machine.c'
R = 'c_check_node_machine_reader.c'
X = 'c_check_node_machine_contexts.c'
W = 'c_check_node_machine_window.c'
faults = [
    ("no compound sum is refused on a fusing target", X,
     "    takes = takes && !(machine->fuses && (op == CHECK_OP_ADD_ASSIGN || op == CHECK_OP_SUBTRACT_ASSIGN) &&",
     "    takes = takes && !(machine->fuses && op == CHECK_OP_MULTIPLY_ASSIGN &&", 0),
    ("the reader's machine does not take a function's own target for one that fuses", R,
     "        typer->machine.fuses = (reader->pp->options.target.features & BUSTER_NODE_MACHINE_FUSED) != 0 || node_machine_reader_targeted(reader->output);",
     "        typer->machine.fuses = (reader->pp->options.target.features & BUSTER_NODE_MACHINE_FUSED) != 0 ||\n                               (node_machine_reader_targeted(reader->output) && reader->output->token_count == UINT32_MAX);", 0),
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
