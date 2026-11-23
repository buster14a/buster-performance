#!/usr/bin/env python3
# splice-faults.py TREE: single changes to the compile that takes bodies (the lowering's splice, the program's hook, the
# reader's pass after the walk), each built (Develop) and run against the driver's test of --node-bodies
# (test-checker-driver's eight parts), which must fail; the tree's file is put back after each.
import subprocess, sys, os
tree = sys.argv[1]
BUILD = ['./build.sh', '--config', 'Develop', '--target', 'compiler']
base = os.path.join(tree, 'src/buster/compiler')
env = dict(os.environ); env['PATH'] = os.path.expanduser('~/.cache/buster/toolchain/4444af0bee44de2d/llvm-23.1.4/bin') + ':' + env['PATH']
env.pop('BUSTER_TEST_NODE_BODIES', None)
L = 'c_check_program_lower.c'
P = 'c_check_program.c'
N = 'c_check_node_bodies.c'
I = 'c_check_initializer_input.c'
T = 'c_check_node_machine_type.c'
faults = [
    ("a body that names a thread-local is taken", N,
     "                 check_input_bit(input->declaration_bits, input->declarations[token], BUSTER_CHECK_BITS_THREAD_LOCAL))",
     "                 check_input_bit(input->declaration_bits, input->declarations[token], BUSTER_CHECK_BITS_THREAD_LOCAL) && token == UINT32_MAX)", 0),
    ("the initializers' stage plans a taken body's declarations", I,
     "&& !(input->node_bodies && input->deferred_tokens[token] != 0)",
     "&& !(input->node_bodies && input->deferred_tokens[token] != 0 && token == UINT32_MAX)", 0),
    ("a taken body's direct calls' callees are no references of it", P,
     "        for (uint32_t i = 0; i < entries + calls; i += 1)",
     "        for (uint32_t i = 0; i < entries; i += 1)", 0),
    ("T's rule for a pointer's update asks the converted value's type alone", T,
     "(columns->value_types[a] & BUSTER_TYPE_QUALIFIERS) == 0 && check_action_kind(types, columns->value_types[a]) == BUSTER_TYPE_KIND_POINTER &&",
     "(columns->value_types[a] & BUSTER_TYPE_QUALIFIERS) == 0 &&", 0),
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
        print(f"{name}: DID NOT BUILD"); print((build.stdout + build.stderr)[-500:], flush=True); open(path, 'w').write(original); continue
    cc = os.path.join(tree, 'build/cmake/native/Develop/compiler')
    env['BUSTER_COMPILER'] = cc
    run = subprocess.run([cc, 'parallel', '--jobs', '6'], cwd=tree, stdin=open('/tmp/claude-1000/-home-david--config-Claude-scratch-workspaces-ad19dfdf-4593-4773-b5bf-773949ac7131-0e0946eb-e4e5-4f4b-9641-3ee67b4b9cf5-scratch-2026-11-22-3573fe/5a14f8bc-dcd4-4c24-a5d4-eca716965585/scratchpad/blocks-driver8.tests'), capture_output=True, text=True, env=env)
    out = run.stdout + run.stderr
    lines = [l for l in out.splitlines() if 'node-bodies' in l or 'node-gate' in l]
    tail = [l for l in out.splitlines() if l.startswith('parallel:') and 'passed' in l]
    failed = run.returncode != 0 and any('node-bodies' in l or 'node-gate' in l for l in out.splitlines())
    caught += failed
    print(f"{name}: {'fails the test' if failed else 'NOT CAUGHT'} (status {run.returncode}; {tail[-1] if tail else ''})", flush=True)
    for l in lines[:2]:
        print('    ' + l[:260], flush=True)
    open(path, 'w').write(original)
build = subprocess.run(BUILD, cwd=tree, capture_output=True, text=True)
print(f"{caught} of {len(faults)} fail the test; the files are put back and built again (status {build.returncode})", flush=True)
