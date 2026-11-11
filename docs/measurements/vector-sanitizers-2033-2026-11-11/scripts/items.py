# items.py DIR ASSIGNMENT: the vector items' timings in a run's saved jobs pages (DIR/jobs-*.json).
import json, sys, glob
from datetime import datetime
d=sys.argv[1]
assign=dict(pair.split('x') for pair in sys.argv[2].split('-'))
jobs=[]
for f in sorted(glob.glob(d+'/jobs-*.json')):
    jobs+=json.load(open(f))['jobs']
def t(x): return datetime.strptime(x,'%Y-%m-%dT%H:%M:%SZ')
bycand={}
for j in jobs:
    n=j['name']
    if '(vector, ' in n and 'Vector draw 1, candidate' in n:
        c=n.split('candidate ')[1].split(' ')[0]; bycand[c]=j
def steps(j):
    out={}
    for s in j['steps']:
        if s['conclusion'] in ('skipped',None) or not s['started_at'] or not s['completed_at']: continue
        out[s['name']]=(t(s['completed_at'])-t(s['started_at'])).total_seconds()
    return out
B='Build the external Clang pragma oracle, the clang server and the compiler'
O="Check unity fixture ownership on the vector build's tree"
P="Pack the vector configuration's product with its identity"
U="Publish the product to the configuration's other items"
W="Wait for the vector configuration's product"
D="Download the vector configuration's product"
I="Verify and install the vector configuration's product"
T='Run correctness tests within the hosted CPU budget'
conf={}
for item,c in assign.items():
    j=bycand[c]; st=steps(j)
    js=(t(j['completed_at'])-t(j['started_at'])).total_seconds()
    conf.setdefault(item[0],[]).append((t(j['started_at']),t(j['completed_at']),js))
    print(f"{item:3} cand {c:>2} {j['started_at'][11:19]}-{j['completed_at'][11:19]} job {js:5.0f} s  build {st.get(B,0):4.0f} own {st.get(O,0):2.0f} pack {st.get(P,0):2.0f} pub {st.get(U,0):2.0f} | wait {st.get(W,0):4.0f} dl {st.get(D,0):2.0f} inst {st.get(I,0):2.0f} | tests {st.get(T,0):5.0f} {j['conclusion']}")
for k,v in conf.items():
    wall=(max(e for s,e,_ in v)-min(s for s,e,_ in v)).total_seconds()
    print(k, 'wall', round(wall/60,1), 'min; runner-min', round(sum(x for _,_,x in v)/60,1))
red=[j for c,j in bycand.items() if c not in assign.values()]
rs=sum((t(j['completed_at'])-t(j['started_at'])).total_seconds() for j in red)
print('redraw candidates', len(red), 'runner-min', round(rs/60,1), 'mean s', round(rs/max(1,len(red)),1))
col=[j for j in jobs if '(vector, ' in j['name'] and ('assignment' in j['name'] or 'verdict' in j['name']) and j['started_at'] and j['completed_at'] and j['conclusion']!='skipped']
for j in col: print('aux', j['name'].split(' / ')[1], (t(j['completed_at'])-t(j['started_at'])).total_seconds(), 's')
