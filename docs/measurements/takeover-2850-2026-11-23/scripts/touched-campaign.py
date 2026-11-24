#!/usr/bin/env python3
# touched-campaign.py COMPILER LIST CASES OUT: every case as main runs it, and with the driver's two arenas reading as
# used before and every push of theirs filled with 0xA5 (BUSTER_EXPERIMENT_TOUCHED, _FILL), garbage in every other
# fresh push but the listed sites': the cases whose status, diagnostics or object differ.
import sys, subprocess, os, shlex, hashlib, concurrent.futures
compiler, zlist, cases_path, out = sys.argv[1:5]
os.makedirs(out, exist_ok=True)
cases = [l.rstrip('\n').split('\t') for l in open(cases_path) if l.strip()]
def one(tag, args, env):
    obj = os.path.join(out, f'o-{tag}')
    try:
        r = subprocess.run([compiler] + args + ['-o', obj], env=env, capture_output=True, timeout=30)
        status = r.returncode; err = r.stderr + b'|' + r.stdout
    except subprocess.TimeoutExpired:
        status = 'timeout'; err = b''
    data = open(obj, 'rb').read() if os.path.exists(obj) else b''
    if os.path.exists(obj): os.remove(obj)
    return status, hashlib.sha256(err).hexdigest()[:12], hashlib.sha256(data).hexdigest()[:12]
plain = dict(os.environ)
touched = dict(os.environ, BUSTER_EXPERIMENT_TOUCHED='1', BUSTER_EXPERIMENT_TOUCHED_FILL='1', BUSTER_EXPERIMENT_FRESH_DEFAULT='G', BUSTER_EXPERIMENT_FRESH_LIST=zlist)
def differs(item):
    index, (name, arguments) = item
    args = shlex.split(arguments)
    a = one(f'{index}-a', args, plain); b = one(f'{index}-b', args, touched)
    return (name, arguments, a, b) if a != b else None
with concurrent.futures.ThreadPoolExecutor(4) as pool:
    results = [r for r in pool.map(differs, enumerate(cases)) if r]
print(len(cases), 'cases;', len(results), 'differ')
for r in results[:12]: print(' ', r[0], r[2], r[3])
open(os.path.join(out, 'differ.txt'), 'w').write('\n'.join(f'{r[0]}\t{r[1]}' for r in results) + '\n')
