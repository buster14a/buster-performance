#!/usr/bin/env python3
# size-faults.py TREE: single changes to the size cut (the producer's questions asked first, the machine's columns made for
# the bodies it will read, a compile making nothing the shadow alone reads), each built (Develop) and run against the
# driver's test of --node-bodies (test-checker-driver's part 1 of 8), which must fail; the file is put back after each.
import subprocess, sys, os
tree = sys.argv[1]
env = dict(os.environ); env['PATH'] = os.path.expanduser('~/dev/scripts') + ':' + os.path.expanduser('~/.cache/buster/toolchain/4444af0bee44de2d/llvm-23.1.4/bin') + ':' + env['PATH']
env.pop('BUSTER_TEST_NODE_BODIES', None)
env['CORES_LINK'] = 'https://github.com/buster14a/buster/issues/2850'
BUILD = ['cores', '-n', '6', '--', './build.sh', '--config', 'Develop', '--target', 'compiler']
base = os.path.join(tree, 'src/buster/compiler')
A = 'c_check_node_machine_alone.c'
E = 'c_check_expression_input.c'
faults = [
    ("a body's positions counted as one", A,
     "swept += reasons[body] == 0 ? ends[body] - firsts[body] : 0;", "swept += reasons[body] == 0 ? 1 : 0;"),
    ("a body's stored answer read for its neighbour", A,
     "reason = alone->before_reasons[body];", "reason = alone->before_reasons[body + 1 < alone->body_count ? body + 1 : body];"),
    ("every other body left out of the count and read", A,
     "swept += reasons[body] == 0 ? ends[body] - firsts[body] : 0;", "swept += reasons[body] == 0 && (body & 1) != 0 ? ends[body] - firsts[body] : 0;"),
    ("the room without its slack", A,
     "const uint64_t needed = swept + BUSTER_NODE_ALONE_SLACK;", "const uint64_t needed = swept;"),
    ("the machine's columns made for the unit's nodes", A,
     "capacity = needed < capacity ? (uint32_t)needed : capacity;", "capacity = needed > capacity ? (uint32_t)needed : capacity;"),
    ("the walk's report has the unit's nodes in a compile", E,
     "const uint32_t words = (reader->pp->options.node_reader & BUSTER_NODE_READER_BODIES) != 0 ? 1 : reader->output->graph.capacity / 64 + 1;",
     "const uint32_t words = (reader->pp->options.node_reader & BUSTER_NODE_READER_BODIES) == 0 ? 1 : reader->output->graph.capacity / 64 + 1;"),
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
