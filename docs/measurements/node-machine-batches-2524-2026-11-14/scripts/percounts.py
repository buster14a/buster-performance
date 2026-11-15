#!/usr/bin/env python3
# percounts.py COUNTS NODES BATCH...: per taken node (NODES), each set's counts from counts-b.sh's files in COUNTS: T (set
# 0), C (set 1 less set 0), X (set 2 less set 1) and all three (set 2), 40 passes less the run of none, by batch.
import sys, os, re
d, nodes, batches = sys.argv[1], int(sys.argv[2]), sys.argv[3:]
runs = 40 * nodes
def read(path):
    counts = {}
    for line in open(path):
        m = re.match(r'\s*([0-9,]+)\s+(\S+)', line)
        if m and ':u' in m.group(2):
            counts[m.group(2).split(':')[0]] = int(m.group(1).replace(',', ''))
    return counts
names = [('cycles', 1), ('instructions', 1), ('de_no_dispatch_per_slot.no_ops_from_frontend', 1), ('ic_tag_hit_miss.instruction_cache_miss', 1),
         ('ex_ret_brn_misp', 1), ('op_cache_hit_miss.op_cache_miss', 2), ('de_no_dispatch_per_slot.backend_stalls', 2), ('ex_ret_brn_ind_misp', 2),
         ('ls_any_fills_from_sys.all', 3), ('ls_any_fills_from_sys.local_l2', 3), ('l2_request_g1.all_dc', 3)]
short = ['cycles', 'instr', 'fe-empty', 'l1i-miss', 'misp', 'opc-miss', 'be-stall', 'ind-misp', 'l1d-fills', 'from-l2', 'l2-dc-req']
base = {e: read(os.path.join(d, 'counts-p0-setx-e%d.txt' % e)) for e in (1, 2, 3)}
print('%-10s %s' % ('', ' '.join('%9s' % n for n in short)))
for b in batches:
    sets = {k: {e: read(os.path.join(d, 'counts-p40-set%d%s-e%d.txt' % (k, b, e))) for e in (1, 2, 3)} for k in (0, 1, 2)}
    for label, a, z in (('T', sets[0], base), ('C', sets[1], sets[0]), ('X', sets[2], sets[1]), ('all', sets[2], base)):
        print('%-10s %s' % ('b%s %s' % (b, label), ' '.join('%9.2f' % ((a[e].get(n, 0) - z[e].get(n, 0)) / runs) for n, e in names)))
