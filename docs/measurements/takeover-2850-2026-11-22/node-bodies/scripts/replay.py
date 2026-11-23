#!/usr/bin/env python3
# replay.py COMPILER KEPT OUT [JOBS]: each command of a journal (BUSTER_TEST_NODE_BODIES_KEEP) run again on its inputs'
# kept bytes, as ever and with --node-bodies forced (BUSTER_TEST_NODE_BODIES=1): the exit statuses, the diagnostics and
# the outputs compared, and from the gate's log of the second run, whether a body was taken.
import os, re, sys, subprocess, shutil
from multiprocessing import Pool
cc, kept, out = sys.argv[1], sys.argv[2], sys.argv[3]
jobs = int(sys.argv[4]) if len(sys.argv) > 4 else int(os.environ.get('CORES', '6'))
os.makedirs(out, exist_ok=True)
def one(name):
    key = name[:-len('.command')]
    parts = open(os.path.join(kept, name), 'rb').read().split(b'\0')[:-1]
    cwd, argv = os.fsdecode(parts[0]), [os.fsdecode(a) for a in parts[1:]]
    inputs = [os.fsdecode(a) for a in open(os.path.join(kept, key + '.inputs'), 'rb').read().split(b'\0')[:-1]]
    work = os.path.join(out, 'work', key)
    os.makedirs(work, exist_ok=True)
    copies = {}
    for n, path in enumerate(inputs):
        ext = os.path.splitext(path)[1] or '.c'
        copy = os.path.join(work, f'in{n}{ext}')
        shutil.copyfile(os.path.join(kept, f'{key}.{n}.input'), copy)
        copies[path] = copy
    args = []
    skip = False
    for a in argv[1:]:
        if skip:
            skip = False; continue
        if a == '-o':
            skip = True; continue
        if a.startswith('-o') and len(a) > 2 and not a.startswith('-ob'):
            continue
        # A check without an object is replayed as a compile to one where it has one input: the unit's object is then
        # compared too, where it compiles.
        args.append('-c' if a == '-fsyntax-only' and len(inputs) == 1 else copies.get(a, a))
    results = []
    taken = -1
    for mode in ('off', 'on'):
        output = os.path.join(work, mode + '.out')
        if os.path.exists(output): os.unlink(output)
        env = {k: v for k, v in os.environ.items() if not k.startswith('BUSTER_TEST_NODE_BODIES')}
        log = os.path.join(work, 'gate.log')
        if mode == 'on':
            env['BUSTER_TEST_NODE_BODIES'] = '1'
            env['BUSTER_TEST_NODE_BODIES_LOG'] = log
            open(log, 'w').close()
        try:
            r = subprocess.run([cc] + args + ['-o', output], cwd=cwd if os.path.isdir(cwd) else None, env=env, capture_output=True, timeout=300)
            status, text = r.returncode, r.stdout + r.stderr
        except subprocess.TimeoutExpired:
            status, text = -99, b'timeout'
        data = open(output, 'rb').read() if os.path.isfile(output) else None
        # The copies' own paths are in a diagnostic's text for both runs alike; the outputs' paths differ by the mode.
        results.append((status, text.replace(output.encode(), b'OUT'), data))
        if mode == 'on':
            taken = sum(int(m.group(1)) for m in re.finditer(r"producer-ran=\d bodies=\d+ taken=(\d+)", open(log, errors='replace').read()))
    (s0, t0, d0), (s1, t1, d1) = results
    same = s0 == s1 and t0 == t1 and d0 == d1
    shutil.rmtree(work, ignore_errors=True) if same else None
    kind = 'same' if same else 'DIFFER'
    return f"{key} {kind} status={s0}/{s1} output={'none' if d0 is None else len(d0)}/{'none' if d1 is None else len(d1)} text-same={t0 == t1} taken={taken} inputs={len(inputs)}"
if __name__ == '__main__':
    names = sorted(n for n in os.listdir(kept) if n.endswith('.command'))
    with Pool(jobs) as pool:
        rows = pool.map(one, names, chunksize=16)
    open(os.path.join(out, 'rows.txt'), 'w').write('\n'.join(rows) + '\n')
    def count(pred): return sum(1 for r in rows if pred(r))
    took = lambda r: int(re.search(r'taken=(-?\d+)', r).group(1)) > 0
    compiled = lambda r: ' status=0/0 ' in r and 'output=none' not in r
    print(f"commands replayed: {len(rows)}; with a body taken: {count(took)}; of those, both runs made an output: {count(lambda r: took(r) and compiled(r))}")
    print(f"the same (status, diagnostics, output): {count(lambda r: ' same ' in r)}; of those with a body taken: {count(lambda r: ' same ' in r and took(r))}; and an output: {count(lambda r: ' same ' in r and took(r) and compiled(r))}")
    print(f"DIFFER: {count(lambda r: ' DIFFER ' in r)}")
    for r in rows:
        if ' DIFFER ' in r: print('  ' + r)
