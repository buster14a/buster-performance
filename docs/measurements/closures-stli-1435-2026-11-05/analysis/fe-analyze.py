import statistics as st, collections, sys
rows = collections.defaultdict(list)
builds = []
for line in open(sys.argv[1]):
    p = line.split()
    b = p[2][:-1]
    g = p[2][-1]
    if b not in builds:
        builds.append(b)
    d = {k: float(v) for k, v in (x.split('=') for x in p[3:])}
    rows[(int(p[0]), b, g)].append(d)
short = {
    'cycles': 'cyc', 'de_no_dispatch_per_slot.no_ops_from_frontend': 'fe-slots', 'de_src_op_disp.x86_decoder': 'dec-ops',
    'de_src_op_disp.op_cache': 'oc-ops', 'op_cache_hit_miss.op_cache_miss': 'oc-miss', 'ic_tag_hit_miss.instruction_cache_miss': 'ic-miss',
    'bp_de_redirect': 'de-redir', 'bp_redirects.resync': 'resync', 'ex_ret_brn_misp': 'br-misp', 'bp_l1_tlb_miss_l2_tlb_hit': 'itlb',
    'de_no_dispatch_per_slot.backend_stalls': 'be-slots',
}
shifts = sorted(set(k[0] for k in rows))
keys = None
for s in shifts:
    print('shift', s, '(medians, millions)')
    for b in builds:
        out = []
        for g in 'AB':
            r = rows[(s, b, g)]
            ks = [k for k in r[0] if not (g == 'B' and k == 'cycles')]
            for k in ks:
                out.append('%s=%.2f' % (short.get(k, k), st.median(d[k] for d in r) / 1e6))
        print('  %-6s %s' % (b, ' '.join(out)))
