# excess.py DIR ASSIGNMENT: for each waiting item, the time from its builder's publish to its own install's end, and
# what a build of its own would have cost on the critical path (its builder's build + ownership + pack + publish).
import json, sys, glob
from datetime import datetime
d=sys.argv[1]
assign=dict(pair.split('x') for pair in sys.argv[2].split('-'))
jobs=[]
for f in sorted(glob.glob(d+'/jobs-*.json')): jobs+=json.load(open(f))['jobs']
def t(x): return datetime.strptime(x,'%Y-%m-%dT%H:%M:%SZ')
byc={}
for j in jobs:
    if '(vector, ' in j['name'] and 'Vector draw 1, candidate' in j['name']:
        byc[j['name'].split('candidate ')[1].split(' ')[0]]=j
def step(j,name):
    for s in j['steps']:
        if s['name']==name and s['completed_at'] and s['conclusion'] not in ('skipped',None): return s
    return None
U="Publish the product to the configuration's other items"
B='Build the external Clang pragma oracle, the clang server and the compiler'
W="Wait for the vector configuration's product"
I="Verify and install the vector configuration's product"
tot=0;n=0
for item,c in assign.items():
    if item[1:]=='1': continue
    j=byc[c]; b=byc[assign[item[0]+'1']]
    pub=step(b,U); bs=step(b,B); w=step(j,W); ins=step(j,I)
    if not (pub and w and ins): print(item,'incomplete'); continue
    after=(t(ins['completed_at'])-t(pub['completed_at'])).total_seconds()
    # the waiter's own setup ended when its wait began; its own build would have started there
    own_build_end_if_same=(t(w['started_at'])-t(bs['started_at'])).total_seconds()+(t(bs['completed_at'])-t(bs['started_at'])).total_seconds()
    excess=(t(ins['completed_at'])-t(w['started_at'])).total_seconds()-(t(bs['completed_at'])-t(bs['started_at'])).total_seconds()
    tot+=excess;n+=1
    print(f"{item}: waited {(t(w['completed_at'])-t(w['started_at'])).total_seconds():4.0f} s; publish->installed {after:3.0f} s; wait+install minus the builder's build {excess:4.0f} s")
print('mean excess', round(tot/n,1), 's over', n, 'waiting items; total', round(tot/60,1), 'runner-min')
