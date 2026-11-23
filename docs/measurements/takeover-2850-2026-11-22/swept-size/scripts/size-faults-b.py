#!/usr/bin/env python3
# size-faults-b.py TREE: the one fault of size-faults.py that the wider bound passed, again at the head with the bound at 8.5 MB.
import subprocess, sys, os
tree = sys.argv[1]
env = dict(os.environ); env['PATH'] = os.path.expanduser('~/dev/scripts') + ':' + os.path.expanduser('~/.cache/buster/toolchain/4444af0bee44de2d/llvm-23.1.4/bin') + ':' + env['PATH']
env.pop('BUSTER_TEST_NODE_BODIES', None)
env['CORES_LINK'] = 'https://github.com/buster14a/buster/issues/2850'
BUILD = ['cores', '-n', '6', '--', './build.sh', '--config', 'Develop', '--target', 'compiler']
base = os.path.join(tree, 'src/buster/compiler')
A = 'c_check_node_machine_alone.c'
faults = [
    ("the roots by token made in a compile", A,
     "uint32_t* roots = compile ? NULL : arena_push_array(reader->arena, (uint64_t)count + 1, sizeof(uint32_t), _Alignof(uint32_t));",
     "uint32_t* roots = arena_push_array(reader->arena, (uint64_t)count + 1, sizeof(uint32_t), _Alignof(uint32_t));"),
]
caught = 0
for name, file, old, new in faults:
    path = os.path.join(base, file)
    original = open(path).read()
    if original.count(old) != 1:
        print(f"{name}: NOT APPLIED ({original.count(old)} places)", flush=True); continue
    open(path, 'w').write(original.replace(old, new))
    env['CORES_TITLE'] = '#2850: a single fault of the size cut, built'
    build = subprocess.run(BUILD, cwd=tree, capture_output=True, text=True, env=env)
    if build.returncode != 0:
        print(f"{name}: DID NOT BUILD"); print((build.stdout + build.stderr)[-600:], flush=True); open(path, 'w').write(original); continue
    cc = os.path.join(tree, 'build/cmake/native/Develop/compiler')
    env['CORES_TITLE'] = '#2850: a single fault of the size cut against the driver\'s test'
    run = subprocess.run(['cores', '-n', '1', '--', cc, 'test-checker-driver', '--executable', cc, '--part', '1/8', '--in-process'], cwd=tree, capture_output=True, text=True, env=env)
    out = run.stdout + run.stderr
    lines = [l for l in out.splitlines() if 'node-bodies' in l]
    tail = [l for l in out.splitlines() if l.startswith('checker-driver:') and 'checks' in l]
    failed = run.returncode != 0 and len(lines) != 0
    caught += failed
    print(f"{name}: {'fails the test' if failed else 'NOT CAUGHT'} (status {run.returncode}; {tail[-1] if tail else ''})", flush=True)
    for l in lines[:3]:
        print('    ' + l[:240], flush=True)
    open(path, 'w').write(original)
env['CORES_TITLE'] = '#2850: the scratch tree built again without a fault'
build = subprocess.run(BUILD, cwd=tree, capture_output=True, text=True, env=env)
print(f"{caught} of {len(faults)} fail the test; the files are put back and built again (status {build.returncode})", flush=True)
