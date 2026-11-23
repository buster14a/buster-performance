#!/usr/bin/env python3
# campaign2.py COMPILER ZERO_SITES OUT CASES: with every fresh push filled with garbage but the zero sites' (the
# experiment's default-garbage mode), find the sites each differing case needs zero, until no case differs. A case
# (name<TAB>arguments) differs when its status, stderr or output file do against the run with no garbage at all.
import sys, subprocess, os, hashlib, concurrent.futures, shlex, time
compiler, zero_path, out, cases_path = sys.argv[1:5]
os.makedirs(out, exist_ok=True)
zero = [l.strip() for l in open(zero_path) if l.strip()]
cases = [l.rstrip('\n').split('\t') for l in open(cases_path) if l.strip()]
def run(tag, args, mode, zeros=None, garbage=None):
    obj = os.path.join(out, f'o-{tag}')
    lst = os.path.join(out, f'l-{tag}')
    env = dict(os.environ)
    with open(lst, 'w') as f:
        if mode in ('zero', 'sites'):
            pass                                   # the default of the build: every site zero
        elif mode == 'default-garbage':
            env['BUSTER_EXPERIMENT_FRESH_DEFAULT'] = 'G'
            for s in zeros: f.write(f'{s} Z\n')
        else:                                      # only the listed sites garbage
            for s in garbage: f.write(f'{s} G\n')
    env['BUSTER_EXPERIMENT_FRESH_LIST'] = lst
    log = os.path.join(out, f's-{tag}')
    if mode == 'sites':
        env['BUSTER_EXPERIMENT_FRESH_LOG'] = log
        if os.path.exists(log): os.remove(log)
    try:
        r = subprocess.run([compiler] + args + ['-o', obj], env=env, capture_output=True, timeout=8)
        status = r.returncode; err = r.stderr + b'|' + r.stdout
    except subprocess.TimeoutExpired:
        status = 'timeout'; err = b''
    data = open(obj, 'rb').read() if os.path.exists(obj) else b''
    if os.path.exists(obj): os.remove(obj)
    return status, hashlib.sha256(err).hexdigest()[:12], hashlib.sha256(data).hexdigest()[:12]
reference = {}
def differs(item):
    index, (name, arguments) = item
    args = shlex.split(arguments)
    if index not in reference:
        reference[index] = run(f'{index}-z', args, 'zero')
    return run(f'{index}-g', args, 'default-garbage', zeros=zero) != reference[index]
def sites_of(index, args):
    # the sites this case pushes at, in the order of their bytes
    log = os.path.join(out, f's-{index}-s')
    run(f'{index}-s', args, 'sites')
    sites = {}
    if os.path.exists(log):
        for l in open(log):
            p = l.split()
            sites[p[0]] = sites.get(p[0], 0) + int(p[1])
    return [s for s, b in sorted(sites.items(), key=lambda x: -x[1]) if not s.startswith('internal')]
pool = concurrent.futures.ThreadPoolExecutor(4)
progress = open(os.path.join(out, 'progress.txt'), 'a')
start = time.time()
pending = list(enumerate(cases))
round_ = 0
while True:
    round_ += 1
    flags = list(pool.map(differs, pending))
    pending = [item for item, d in zip(pending, flags) if d]
    progress.write(f'round {round_}: {len(pending)} cases differ, {len(zero)} zero sites, {time.time() - start:.0f} s\n'); progress.flush()
    if not pending:
        break
    index, (name, arguments) = pending[0]
    args = shlex.split(arguments)
    found = 0
    while found < 40:
        candidates = [s for s in sites_of(index, args) if s not in zero]
        if run(f'{index}-b', args, 'only', garbage=candidates) == reference[index]:
            break                                  # the case passes with its own sites filled: its difference is another's
        lo, hi = 0, len(candidates)
        while hi - lo > 1:
            mid = (lo + hi) // 2
            if run(f'{index}-b', args, 'only', garbage=candidates[:mid]) == reference[index]: lo = mid
            else: hi = mid
        zero.append(candidates[hi - 1]); found += 1
        progress.write(f'  zero {len(zero)}: {candidates[hi - 1]} from {name}\n'); progress.flush()
    if found == 0:
        progress.write(f'  no site found for {name}: left out\n'); progress.flush()
        pending = pending[1:]
        open(os.path.join(out, 'unexplained.txt'), 'a').write(f'{name}\t{arguments}\n')
open(os.path.join(out, 'zero-sites.txt'), 'w').write('\n'.join(zero) + '\n')
progress.write(f'done: {len(zero)} zero sites, {time.time() - start:.0f} s\n')
