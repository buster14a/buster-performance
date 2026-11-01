#!/usr/bin/env python3
import json, sys, collections, statistics as st
rows=[json.loads(l) for l in open(sys.argv[1])]
def parse(stderr):
    out={}
    for line in stderr.splitlines():
        parts=line.split(';')
        if len(parts)>=3 and parts[0].strip().replace('.','',1).isdigit():
            out[parts[2].strip()]=float(parts[0])
    return out
data=collections.defaultdict(lambda: collections.defaultdict(list))
fails=0
for r in rows:
    vals=parse(r['stderr'])
    if r['status']!=0 or 'cycles:u' not in vals or 'instructions:u' not in vals:
        fails+=1; continue
    key=(r['build'],r['workload'])
    data[key]['cycles'].append(vals['cycles:u'])
    data[key]['instructions'].append(vals['instructions:u'])
    ev=r['event']
    evv=vals.get(ev+':u', float('nan'))
    data[key][ev].append(evv)
print("unusable records:",fails)
wl=['preprocess','syntax','compile']
evs=['de_no_dispatch_per_slot.no_ops_from_frontend','de_no_dispatch_per_slot.backend_stalls',
     'op_cache_hit_miss.op_cache_miss','op_cache_hit_miss.all_op_cache_accesses',
     'l2_request_g1.cacheable_ic_read','bp_l2_btb_correct','ex_no_retire.empty',
     'de_src_op_disp.x86_decoder','ex_ret_brn_misp']
Bs=['base','pgo','pgo-split','fsec','order']
for w in wl:
    print(f"\n=== {w} (per 1,000 instructions; medians) ===")
    print(f"{'event':56s} " + " ".join(f"{b:>10s}" for b in Bs))
    ins={b: st.median(data[(b,w)]['instructions']) for b in Bs}
    for ev in evs+['cycles']:
        cells=[]
        for b in Bs:
            vs=[v for v in data[(b,w)][ev]]
            cells.append(f"{st.median(vs)/ins[b]*1000:10.3f}")
        print(f"{ev:56s} " + " ".join(cells))
    print(f"{'instructions (M)':56s} " + " ".join(f"{ins[b]/1e6:10.2f}" for b in Bs))
# op-cache miss ratio
print("\n=== op_cache_miss / all_op_cache_accesses (%) ===")
for w in wl:
    cells=[]
    for b in Bs:
        d=data[(b,w)]
        m=st.median(d['op_cache_hit_miss.op_cache_miss']); a=st.median(d['op_cache_hit_miss.all_op_cache_accesses'])
        cells.append(f"{m/a*100:10.2f}")
    print(f"{w:20s} " + " ".join(cells))
# cycles ratio vs base
print("\n=== cycles ratio vs base ===")
for w in wl:
    cb=st.median(data[('base',w)]['cycles'])
    print(f"{w:20s} " + " ".join(f"{st.median(data[(b,w)]['cycles'])/cb:10.4f}" for b in Bs))
