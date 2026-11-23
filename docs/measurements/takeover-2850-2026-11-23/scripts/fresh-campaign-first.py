#!/usr/bin/env python3
# campaign.py COMPILER GARBAGE_LIST OUT CASES: each case (a line "name<TAB>argument argument ...", a compile without its
# -o) run with every fresh push zero (an empty list) and with the list's sites filled; a case differs when its status,
# its stderr or its output file do. Writes OUT/differ.txt (name<TAB>what<TAB>arguments).
import sys, subprocess, os, hashlib, concurrent.futures, shlex
compiler, garbage, out, cases_path = sys.argv[1:5]
os.makedirs(out, exist_ok=True)
empty = os.path.join(out, 'empty.list'); open(empty, 'w').close()
cases = [l.rstrip('\n').split('\t') for l in open(cases_path) if l.strip()]
def run(index, mode, args):
    obj = os.path.join(out, f'o-{index}-{mode}')
    env = dict(os.environ, BUSTER_EXPERIMENT_FRESH_LIST=garbage if mode == 'g' else empty)
    try:
        r = subprocess.run([compiler] + args + ['-o', obj], env=env, capture_output=True, timeout=30)
        status = r.returncode; err = r.stderr + b'|' + r.stdout
    except subprocess.TimeoutExpired:
        status = 'timeout'; err = b''
    data = open(obj, 'rb').read() if os.path.exists(obj) else b''
    if os.path.exists(obj): os.remove(obj)
    return status, hashlib.sha256(err).hexdigest()[:12], hashlib.sha256(data).hexdigest()[:12]
def case(item):
    index, (name, arguments) = item
    args = shlex.split(arguments)
    z = run(index, 'z', args); g = run(index, 'g', args)
    what = [w for w, a, b in zip(('status', 'stderr', 'output'), z, g) if a != b]
    return name, arguments, what, z, g
differ = []
with concurrent.futures.ThreadPoolExecutor(4) as pool:
    for n, (name, arguments, what, z, g) in enumerate(pool.map(case, enumerate(cases))):
        if what:
            differ.append((name, ','.join(what), arguments, z, g))
with open(os.path.join(out, 'differ.txt'), 'w') as f:
    for name, what, arguments, z, g in differ:
        f.write(f'{name}\t{what}\t{arguments}\t{z}\t{g}\n')
print(f'{len(cases)} cases, {len(differ)} differ')
