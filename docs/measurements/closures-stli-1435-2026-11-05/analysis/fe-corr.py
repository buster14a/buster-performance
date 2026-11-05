import statistics as st, sys
pts = {}
for line in open(sys.argv[1]):
    p = line.split()
    d = {k: float(v) for k, v in (x.split('=') for x in p[3:])}
    key = (p[0], p[1], p[2][:-1])
    pts.setdefault(key, {}).update({(k if k != 'cycles' else 'cycles' + p[2][-1]): v for k, v in d.items()})
runs = list(pts.values())
def fit(xk, yk):
    x = [r[xk] for r in runs]
    y = [r[yk] for r in runs]
    mx, my = st.mean(x), st.mean(y)
    sxy = sum((a - mx) * (b - my) for a, b in zip(x, y))
    sxx = sum((a - mx) ** 2 for a in x)
    syy = sum((b - my) ** 2 for b in y)
    return sxy / (sxx * syy) ** .5, sxy / sxx
print('runs', len(runs))
for k in ['de_src_op_disp.x86_decoder', 'op_cache_hit_miss.op_cache_miss', 'ic_tag_hit_miss.instruction_cache_miss', 'de_no_dispatch_per_slot.no_ops_from_frontend']:
    r, b = fit(k, 'cyclesA')
    print('%-45s corr with cycles %.2f, slope %.2f cycles per event' % (k, r, b))
for k in ['ex_ret_brn_misp', 'bp_redirects.resync', 'de_no_dispatch_per_slot.backend_stalls']:
    r, b = fit(k, 'cyclesB')
    print('%-45s corr with cycles %.2f, slope %.2f cycles per event' % (k, r, b))
