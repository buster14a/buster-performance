#!/usr/bin/env python3
# bisect.py COMPILER SITES REFERENCE.o OUT -- ARGUMENT...: which sites' fresh pushes need zeros for the compile to give
# REFERENCE.o with nothing on stderr. SITES is "bytes pushes name" a line; a run gives a list file with G (garbage) or Z
# (zero) a site. A site is a culprit when garbage in the sites before it passes and garbage in them and it fails.
import sys, subprocess, os, hashlib, concurrent.futures, time
compiler, sites_path, reference, out = sys.argv[1:5]
args = sys.argv[6:]
sites = [l.split()[2] for l in open(sites_path) if not l.split()[2].startswith('internal')]
ref = hashlib.sha256(open(reference, 'rb').read()).hexdigest()
runs = 0
def passes(garbage, tag):
    global runs
    runs += 1
    lst = f'{out}/list-{tag}.txt'; obj = f'{out}/obj-{tag}.o'
    with open(lst, 'w') as f:
        for s in sites:
            f.write(f'{s} {"G" if s in garbage else "Z"}\n')
    env = dict(os.environ, BUSTER_EXPERIMENT_FRESH_LIST=lst)
    try:
        r = subprocess.run([compiler] + args + ['-o', obj], env=env, capture_output=True, timeout=8)
    except subprocess.TimeoutExpired:
        return False
    ok = r.returncode == 0 and r.stderr == b'' and os.path.exists(obj) and hashlib.sha256(open(obj, 'rb').read()).hexdigest() == ref
    if os.path.exists(obj): os.remove(obj)
    return ok
os.makedirs(out, exist_ok=True)
zero = []
log = open(f'{out}/progress.txt', 'a')
start = time.time()
pool = concurrent.futures.ThreadPoolExecutor(3)
while True:
    candidates = [s for s in sites if s not in zero]
    if passes(set(candidates), 'all'):
        break
    lo, hi = 0, len(candidates)
    while hi - lo > 1:
        step = max(1, (hi - lo) // 4)
        mids = sorted({lo + step, lo + 2 * step, lo + 3 * step} & set(range(lo + 1, hi)))
        results = list(pool.map(lambda m: passes(set(candidates[:m]), f'm{m}'), mids))
        for m, ok in zip(mids, results):
            if ok: lo = max(lo, m)
            else:
                hi = min(hi, m)
                break
    zero.append(candidates[hi - 1])
    log.write(f'{len(zero)} {candidates[hi - 1]} runs={runs} seconds={time.time() - start:.0f}\n'); log.flush()
open(f'{out}/zero-sites.txt', 'w').write('\n'.join(zero) + '\n')
log.write(f'done: {len(zero)} of {len(sites)} sites need zeros; runs={runs} seconds={time.time() - start:.0f}\n'); log.close()
