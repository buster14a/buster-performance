#!/usr/bin/env python3
import json, sys, collections, statistics as st
rows=[json.loads(l) for l in open(sys.argv[1])]
def parse(stderr):
    out={}
    for line in stderr.splitlines():
        p=line.split(';')
        if len(p)>=3 and p[0].strip().replace('.','',1).isdigit(): out[p[2].strip()]=float(p[0])
    return out
data=collections.defaultdict(lambda: collections.defaultdict(list))
for r in rows:
    v=parse(r['stderr'])
    if r['status']!=0 or 'cycles:u' not in v: continue
    k=(r['build'],r['workload'])
    data[k]['cycles'].append(v['cycles:u']); data[k]['instructions'].append(v['instructions:u'])
    data[k][r['event']].append(v.get(r['event']+':u',float('nan')))
Bs=['base','pgo','pgo-split','fsec','order']
wl=['preprocess','syntax','compile']
evs=['de_no_dispatch_per_slot.no_ops_from_frontend','de_no_dispatch_per_slot.backend_stalls',
     'op_cache_hit_miss.op_cache_miss','l2_request_g1.cacheable_ic_read','bp_l2_btb_correct',
     'ex_no_retire.empty','de_src_op_disp.x86_decoder','ex_ret_brn_misp']
print("== slots starved by frontend per cycle (no_ops_from_frontend / cycles) ==")
for w in wl:
    print(f"{w:12s} "+" ".join(f"{st.median(data[(b,w)]['de_no_dispatch_per_slot.no_ops_from_frontend'])/st.median(data[(b,w)]['cycles']):8.3f}" for b in Bs))
print("== backend-stalled slots per cycle ==")
for w in wl:
    print(f"{w:12s} "+" ".join(f"{st.median(data[(b,w)]['de_no_dispatch_per_slot.backend_stalls'])/st.median(data[(b,w)]['cycles']):8.3f}" for b in Bs))
print("== op cache miss ratio % ==")
for w in wl:
    print(f"{w:12s} "+" ".join(f"{st.median(data[(b,w)]['op_cache_hit_miss.op_cache_miss'])/st.median(data[(b,w)]['op_cache_hit_miss.all_op_cache_accesses'])*100:8.2f}" for b in Bs))
print("== absolute ex_ret_brn_misp (M) ==")
for w in wl:
    print(f"{w:12s} "+" ".join(f"{st.median(data[(b,w)]['ex_ret_brn_misp'])/1e6:8.3f}" for b in Bs))
print("== cycles (M) ==")
for w in wl:
    print(f"{w:12s} "+" ".join(f"{st.median(data[(b,w)]['cycles'])/1e6:8.2f}" for b in Bs))
print("== instructions (M) ==")
for w in wl:
    print(f"{w:12s} "+" ".join(f"{st.median(data[(b,w)]['instructions'])/1e6:8.2f}" for b in Bs))
