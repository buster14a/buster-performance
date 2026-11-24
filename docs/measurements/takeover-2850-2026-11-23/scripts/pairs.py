#!/usr/bin/env python3
# pairs.py COMPILER LIST CASES OUT: every case run once with the sites classed and nothing filled; the pairs (a
# zero-needing push's site, its reservation's site) each case logs, summed over the cases.
import sys, subprocess, os, shlex, collections, concurrent.futures
compiler, zlist, cases_path, out = sys.argv[1:5]
os.makedirs(out, exist_ok=True)
cases = [l.rstrip('\n').split('\t') for l in open(cases_path) if l.strip()]
def run(item):
    index, (name, arguments) = item
    log = os.path.join(out, f'p-{index}')
    env = dict(os.environ, BUSTER_EXPERIMENT_FRESH_NOFILL='1', BUSTER_EXPERIMENT_FRESH_DEFAULT='G', BUSTER_EXPERIMENT_FRESH_LIST=zlist, BUSTER_EXPERIMENT_FRESH_LOG=os.path.join(out, f's-{index}'), BUSTER_EXPERIMENT_PAIRS_LOG=log)
    try:
        subprocess.run([compiler] + shlex.split(arguments) + ['-o', os.path.join(out, f'o-{index}')], env=env, capture_output=True, timeout=30)
    except subprocess.TimeoutExpired:
        pass
    pairs = collections.Counter()
    if os.path.exists(log):
        for l in open(log):
            p = l.split()
            pairs[(p[0], p[1])] += 1
        os.remove(log)
    for f in (f's-{index}', f'o-{index}'):
        if os.path.exists(os.path.join(out, f)): os.remove(os.path.join(out, f))
    return pairs
total = collections.Counter(); cases_with = collections.Counter()
with concurrent.futures.ThreadPoolExecutor(4) as pool:
    for pairs in pool.map(run, enumerate(cases)):
        total.update(pairs)
        for k in pairs: cases_with[k] += 1
with open(os.path.join(out, 'pairs.txt'), 'w') as f:
    for (site, arena), n in sorted(total.items(), key=lambda x: (x[0][1], x[0][0])):
        f.write(f'{arena}\t{site}\t{n} pushes\t{cases_with[(site, arena)]} cases\n')
print(open(os.path.join(out, 'pairs.txt')).read())
