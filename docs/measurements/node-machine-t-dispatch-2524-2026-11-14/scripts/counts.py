#!/usr/bin/env python3
# counts.py RESULTS NODES: per taken node, each sweep set's counts from explore-only.sh (only/) and explore-repeat.sh
# (repeat/): set 0 is T, set 1 less set 0 is C, set 2 less set 1 is X, each 40 passes less a run of none (p0), over
# 40 * NODES taken evaluated nodes; the repeat rows are the second run's (--repeat 2 less --repeat 1) and the first's.
import sys, os, re
results, nodes = sys.argv[1], int(sys.argv[2])
runs = 40 * nodes
def read(path):
    counts = {}
    for line in open(path):
        m = re.match(r'\s*([0-9,]+)\s+(\S+)', line)
        if m and ':u' in m.group(2):
            counts[m.group(2).split(':')[0]] = int(m.group(1).replace(',', ''))
    return counts
d = os.path.join(results, 'only2')
def c(name):
    return read(os.path.join(d, name))
base = {e: c('only/counts-p0-setx-e%d.txt' % e) for e in (1, 2)}
sets = {k: {e: c('only/counts-p40-set%d-e%d.txt' % (k, e)) for e in (1, 2)} for k in (0, 1, 2)}
rep = {k: {e: c('repeat/counts-p40-set%d-r2-e%d.txt' % (k, e)) for e in (1, 2)} for k in (0, 2)}
def per(a, b, e, key):
    return (a[e].get(key, 0) - b[e].get(key, 0)) / runs
names = [('cycles', 1), ('instructions', 1), ('de_no_dispatch_per_slot.no_ops_from_frontend', 1),
         ('ic_tag_hit_miss.instruction_cache_miss', 1), ('ex_ret_brn_misp', 1), ('op_cache_hit_miss.op_cache_miss', 2),
         ('op_cache_hit_miss.all_op_cache_accesses', 2)]
print('%-8s %s' % ('set', ' '.join('%12s' % n.split('.')[-1][:12] for n, _ in names)))
rows = [('T', sets[0], base), ('C', sets[1], sets[0]), ('X', sets[2], sets[1]), ('all', sets[2], base),
        ('T r2nd', rep[0], sets[0]), ('all r2nd', rep[2], sets[2])]
for label, a, b in rows:
    print('%-8s %s' % (label, ' '.join('%12.1f' % per(a, b, e, n) for n, e in names)))
