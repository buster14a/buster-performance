#!/usr/bin/env python3
# run.py COMPILER UNITS OUT: each unit compiled as ever, with --node-bodies, and with the gate's log; a line a unit.
import subprocess, sys, os, re
cc, units, out = sys.argv[1], sys.argv[2], sys.argv[3]
os.makedirs(out, exist_ok=True)
rows = []
for name in sorted(os.listdir(units)):
    if not name.endswith('.c'):
        continue
    src = os.path.join(units, name)
    base = os.path.join(out, name[:-2])
    def compile(extra, obj, env=None):
        e = dict(os.environ)
        e.pop('BUSTER_TEST_NODE_BODIES', None); e.pop('BUSTER_TEST_NODE_BODIES_LOG', None)
        if env: e.update(env)
        r = subprocess.run([cc, '--lanes', '1'] + extra + ['-std=gnu17', '-c', '-nostdinc', src, '-o', obj], capture_output=True, text=True, env=e)
        return r.returncode, r.stdout + r.stderr
    for stale in (base + '.plain.o', base + '.taken.o'):
        if os.path.exists(stale): os.unlink(stale)
    ps, pt = compile([], base + '.plain.o')
    ts, tt = compile(['--node-bodies'], base + '.taken.o')
    log = base + '.gate.log'
    open(log, 'w').close()
    gs, gt = compile([], base + '.gate.o', {'BUSTER_TEST_NODE_BODIES_LOG': log})
    gate = open(log, errors='replace').read()
    m = re.search(r"producer-ran=(\d) bodies=(\d+) taken=(\d+) diagnostics-looked-at=(\d+) in-a-taken-body=(\d+)", gate)
    ran, bodies, taken, looked, inside = (int(x) for x in m.groups()) if m else (-1, -1, -1, -1, -1)
    ss, st = compile(['--node-bodies', '--time-stages'], base + '.timed.o')
    m2 = re.search(r"node-bodies: bodies=(\d+) taken=(\d+)", st)
    took = int(m2.group(2)) if m2 else -1
    same_text = pt == tt
    same_status = ps == ts
    po, to = base + '.plain.o', base + '.taken.o'
    objects = 'none' if not (os.path.exists(po) and os.path.exists(to)) else ('same' if open(po, 'rb').read() == open(to, 'rb').read() else 'DIFFER')
    if os.path.exists(po) != os.path.exists(to): objects = 'ONE-MISSING'
    loud = 'error' if ps != 0 else ('warning' if 'warning:' in pt else 'quiet')
    flag = '' if (same_text and same_status and objects in ('same', 'none') and inside == 0) else '  <<<<<'
    rows.append(f"{name[:-2]:38s} {loud:8s} gate: ran={ran} taken={taken} in-a-taken-body={inside}; --node-bodies took={took} diagnostics={'same' if same_text else 'DIFFER'} status={'same' if same_status else 'DIFFER'} objects={objects}{flag}")
open(os.path.join(out, 'summary.txt'), 'w').write('\n'.join(rows) + '\n')
print('\n'.join(r for r in rows if '<<<<<' in r))
quiet = [r.split()[0] for r in rows if ' quiet ' in r]
print(f"{len(rows)} units; flagged {sum('<<<<<' in r for r in rows)}; quiet (no diagnostic at all): {len(quiet)}: {' '.join(quiet)}")
print(f"units where --node-bodies took a body and the unit is loud: {sum(1 for r in rows if ' quiet ' not in r and 'took=0' not in r and 'took=-1' not in r)}")
