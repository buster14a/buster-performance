#!/usr/bin/env python3
# dp-faults.py TREE: single changes to the default path's three rules, each built (Develop) and run against the driver's
# test (the part that has check_test_driver_default_path, found with the first fault), which must fail; the file is put
# back after each.
import subprocess, sys, os, re
tree = sys.argv[1]
env = dict(os.environ); env['PATH'] = os.path.expanduser('~/dev/scripts') + ':' + os.path.expanduser('~/.cache/buster/toolchain/4444af0bee44de2d/llvm-23.1.4/bin') + ':' + env['PATH']
for k in ('BUSTER_TEST_NODE_BODIES', 'BUSTER_TEST_DEFAULT_PATH_LOG'): env.pop(k, None)
env['CORES_LINK'] = 'https://github.com/buster14a/buster/issues/2850'
BUILD = ['cores', '-n', '6', '--', './build.sh', '--config', 'Develop', '--target', 'compiler']
base = os.path.join(tree, 'src/buster/compiler')
W = 'c_check_warning_graph.c'
C = 'c_check_program_cfg.c'
F = 'c_check_program_fold.c'
faults = [
    ("R1: the rule inverted (only an operand that can only be 0 or 1 is replayed)", W, "                        if (!boolean)\n", "                        if (boolean)\n"),
    ("R1: the rule asked of the left operand's operator", W, "check_warning_logical_boolean(graph->ops[graph->operand1[node]]);", "check_warning_logical_boolean(graph->ops[graph->operand0[node]]);"),
    ("R1: the rule widened by a sum", W, "op == CHECK_OP_LOGICAL_OR ||\n           op == CHECK_OP_CONDITION;", "op == CHECK_OP_LOGICAL_OR ||\n           op == CHECK_OP_CONDITION || op == CHECK_OP_ADD;"),
]
part = 3
caught = 0
for name, file, old, new in faults:
    path = os.path.join(base, file)
    original = open(path).read()
    if original.count(old) != 1:
        print(f"{name}: NOT APPLIED ({original.count(old)} places)", flush=True); continue
    open(path, 'w').write(original.replace(old, new))
    env['CORES_TITLE'] = '#2850: a single fault of the default path\'s rules, built'
    build = subprocess.run(BUILD, cwd=tree, capture_output=True, text=True, env=env)
    if build.returncode != 0:
        print(f"{name}: DID NOT BUILD"); print((build.stdout + build.stderr)[-600:], flush=True); open(path, 'w').write(original); continue
    cc = os.path.join(tree, 'build/cmake/native/Develop/compiler')
    env['CORES_TITLE'] = '#2850: a single fault of the default path\'s rules against the driver\'s test'
    parts = [part] if part is not None else list(range(1, 9))
    failed = False; shown = []; statuses = []
    for p in parts:
        run = subprocess.run(['cores', '-n', '1', '--', cc, 'test-checker-driver', '--executable', cc, '--part', f'{p}/8', '--in-process'], cwd=tree, capture_output=True, text=True, env=env)
        out = run.stdout + run.stderr
        lines = [l for l in out.splitlines() if 'default-path' in l]
        tail = [l for l in out.splitlines() if l.startswith('checker-driver:') and 'checks' in l]
        statuses.append(f"part {p}: status {run.returncode}; {tail[-1] if tail else ''}")
        if lines:
            part = p; shown = lines; failed = run.returncode != 0
    caught += failed
    print(f"{name}: {'fails the test' if failed else 'NOT CAUGHT'} ({'; '.join(s for s in statuses if 'status 0' not in s) or 'every part passed'})", flush=True)
    for l in shown[:4]:
        print('    ' + l[:260], flush=True)
    open(path, 'w').write(original)
env['CORES_TITLE'] = '#2850: the scratch tree built again without a fault'
build = subprocess.run(BUILD, cwd=tree, capture_output=True, text=True, env=env)
print(f"{caught} of {len(faults)} fail the test (the test's part: {part}); the files are put back and built again (status {build.returncode})", flush=True)
