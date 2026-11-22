#!/usr/bin/env python3
# beside-faults.py TREE: single changes to what the bodies' comparisons read beside the entries (a plain local's taken
# address, a temporary's class, the kept tapes' named objects against the program's references), to the producer's two
# sets, and to the reader's path under --statement-controls, each built (Develop) and run against the fixtures
# (test-checker part 45/64), which must fail; the tree's file is put back after each.
import subprocess, sys, os
tree = sys.argv[1]
C = 'src/buster/compiler/c_check_node_census.c'
I = 'src/buster/compiler/c_check_input.c'
L = 'src/buster/compiler/c_check_lower_inventory.c'
faults = [
    ("an address an entry takes not counted", C,
     "                    built->addressed[local] |= address;",
     "                    built->addressed[local] |= address && e == UINT32_MAX;"),
    ("a volatile local taken for a plain one", C,
     "                                   (function->local_flags[local] & BUSTER_TYPED_LOCAL_VOLATILE) == 0;",
     "                                   (function->local_flags[local] & BUSTER_TYPED_LOCAL_VOLATILE) <= BUSTER_TYPED_LOCAL_VOLATILE;"),
    ("a temporary's class the next one", C,
     "function->local_classes[local] != built->classes[e] ? \"temporary's-class\" : NULL;",
     "function->local_classes[local] != built->classes[e] + 1 ? \"temporary's-class\" : NULL;"),
    ("a call's callee not named", C,
     "                    if (callee != 0 && built->named_count < built->named_capacity)",
     "                    if (callee == 0 && built->named_count < built->named_capacity)"),
    ("a global's entry not named", C,
     "                    if (node_shadow_global_kind(kept->tape_kinds[tape_first + e]) && built->named_count < built->named_capacity)",
     "                    if (!node_shadow_global_kind(kept->tape_kinds[tape_first + e]) && built->named_count < built->named_capacity)"),
    ("a producer sweeps a body the scan finds a lost root in", C,
     "                const bool swept = fronted->alone_body_scanned[low] == 0 && s->twin->reason == NODE_TWIN_ATTEMPTED &&",
     "                const bool swept = fronted->alone_body_scanned[low] <= 1 && s->twin->reason == NODE_TWIN_ATTEMPTED &&"),
    ("a producer sweeps a body the twin's gates refuse", C,
     "                const bool swept = fronted->alone_body_scanned[low] == 0 && s->twin->reason == NODE_TWIN_ATTEMPTED &&",
     "                const bool swept = fronted->alone_body_scanned[low] == 0 && s->twin->reason <= NODE_TWIN_REASONS &&"),
    ("a producer takes a body whose return flow's silence is not proved", C,
     "shadow->twin_same != twin_before && shadow->twin_silent != silent_before;",
     "shadow->twin_same != twin_before && shadow->twin_silent >= silent_before;"),
    ("a producer takes a body the kept tapes' comparison left out", C,
     "                const bool taken = swept && shadow->bodies_same[1] != kept_before && shadow->twin_same != twin_before",
     "                const bool taken = swept && shadow->bodies_same[1] >= kept_before && shadow->twin_same != twin_before"),
    ("the statement controls' path only where the output is fresh", I,
     "(fresh_output || pp->options.statement_controls_anywhere)",
     "(fresh_output || (pp->options.statement_controls_anywhere && count == 0))"),
    ("the shadow's unit not asked to be read as -c reads it", L,
     "    pp_options.statement_controls = lower_source_statement_controls;",
     "    pp_options.statement_controls = false;"),
]
files = sorted({f for _, f, _, _ in faults})
originals = {f: open(os.path.join(tree, f)).read() for f in files}
for name, file, old, new in faults:
    assert originals[file].count(old) == 1, (name, originals[file].count(old))
caught = 0
for name, file, old, new in faults:
    original = originals[file]
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
