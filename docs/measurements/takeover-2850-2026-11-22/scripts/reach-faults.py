#!/usr/bin/env python3
# reach-faults.py TREE: single changes to the twin's walk that asks whether control reaches each statement (#2987's rule,
# node_twin_unreached) and to the kept tapes' comparison's use of it, each built (Develop) and run against the fixture
# (test-checker part 45/64), which must fail; the tree's file is put back after each.
import subprocess, sys, os
tree = sys.argv[1]
C = 'src/buster/compiler/c_check_node_census.c'
N = 'src/buster/compiler/c_check_node_bodies.c'
faults = [
    ("a statement after a jump walked as any other", N,
     "            else if (!frame->reaches && roles[child] != PARSE_ROLE_LABEL)",
     "            else if (!frame->reaches && roles[child] != PARSE_ROLE_LABEL && roles[child] == PARSE_ROLE_OPEN_BODY)"),
    ("a labelled statement after a jump refused too", N,
     "            else if (!frame->reaches && roles[child] != PARSE_ROLE_LABEL)",
     "            else if (!frame->reaches && roles[child] != PARSE_ROLE_OPEN_BODY)"),
    ("a jump taken to go on to the next statement", N,
     "                    completes = !jump;",
     "                    completes = body == BUSTER_CHECK_NONE || !jump;"),
    ("an if whose arms both end taken to go on", N,
     "            completes = frame->reaches || completes;",
     "            completes = frame->reaches || completes || frame->step == BUSTER_NODE_TWIN_REACH_ELSE;"),
    ("a constantly true while taken to be left", N,
     "                    frame->reaches = role == PARSE_ROLE_CLOSE_FOR ? slot != 0 : !constant;",
     "                    frame->reaches = role == PARSE_ROLE_CLOSE_FOR ? slot != 0 : !constant || slot != 0;"),
    ("a for without a condition taken to be left", N,
     "                    frame->reaches = role == PARSE_ROLE_CLOSE_FOR ? slot != 0 : !constant;",
     "                    frame->reaches = role == PARSE_ROLE_CLOSE_FOR ? slot != UINT32_MAX : !constant;"),
    ("the twin's builder does not ask", N,
     "        if (node_twin_unreached(twin))\n        {\n            node_twin_fail(twin, NODE_TWIN_REACH);",
     "        if (node_twin_unreached(twin) && twin->count == UINT32_MAX)\n        {\n            node_twin_fail(twin, NODE_TWIN_REACH);"),
    ("the kept tapes' comparison does not ask", C,
     "        if (node_twin_unreached(s->twin))\n        {\n            built->placed = false;",
     "        if (node_twin_unreached(s->twin) && built->count == UINT32_MAX)\n        {\n            built->placed = false;"),
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
        try:
            run = subprocess.run(['./build/cmake/native/Develop/compiler', 'test-checker', '--part', '45/64'], cwd=tree, capture_output=True, text=True, timeout=1800)
            out = run.stdout + run.stderr
            tail = out.strip().splitlines()[-1] if out.strip() else ''
            failed = run.returncode != 0
            status = run.returncode
        except subprocess.TimeoutExpired:
            failed, status, tail = True, 'timeout', 'the test did not end in 30 minutes'
        caught += failed
        print(f"{name}: {'fails the fixture' if failed else 'NOT CAUGHT'} (status {status}; {tail})", flush=True)
    open(os.path.join(tree, file), 'w').write(original)
build = subprocess.run(['./build.sh', '--config', 'Develop', '--target', 'compiler'], cwd=tree, capture_output=True, text=True)
print(f"{caught} of {len(faults)} fail the fixture; the files are put back and built again (status {build.returncode})")
