from collections import Counter, defaultdict, namedtuple
from pathlib import Path
import json, sys
Tag=namedtuple('Tag','node token op left right third type kind cat constant object flags storage role parent offset exact')
Root=namedtuple('Root','node assn equal semi records warning mismatch parentrole line')
p=Path(sys.argv[1]);out=Path(sys.argv[2]); freq=defaultdict(Counter); rec=defaultdict(Counter);examples=defaultdict(list)
def collect(r,ns):
    if not r:return
    assn=ns[r.assn]; lhs=ns.get(assn.left);rhs=ns.get(assn.right)
    def leaf(n):
        if n is None:return 'none'
        if n.op!='value':return n.op
        if n.storage:return ('','local','static-local','file')[n.storage]
        if n.constant==1:return 'integer'
        if n.constant==2:return 'floating'
        return 'value'
    def typename(n):
        if not n:return 'none'
        if n.type==64:return 'int'
        if n.type==72:return 'uint'
        if n.kind==2:return 'integer-other'
        if n.kind==7:return 'pointer'
        if n.kind==8:return 'array'
        if n.kind in (15,16):return 'aggregate'
        if n.kind==14:return 'atomic'
        return f'kind{n.kind}'
    def shape(n,depth=1):
        base=leaf(n)
        if not n or n.op=='value' or not depth:return base
        args=[shape(k,depth-1) for k in (ns.get(n.left),ns.get(n.right)) if k]
        return base+'('+','.join(args)+')'
    def add(key,val):
        freq[key][val]+=1
        rec[key][val]+=r.records
        if len(examples[(key,val)])<4:examples[(key,val)].append(r.line)
    add('root op',assn.op)
    if assn.op!='=':
        add('compound/increment by location/result',assn.op+' '+shape(lhs)+' '+typename(lhs));return
    raw=all(n.exact for n in ns.values())
    add('whole checked value parity',f'legacy-mismatch={r.mismatch} raw-exact={int(raw)}')
    strict=not r.warning and not r.mismatch and raw
    add('assignment ordinary agreement',f'warnings={r.warning} mismatch={r.mismatch}')
    add('destination',leaf(lhs)+' '+typename(lhs))
    add('destination shape',shape(lhs)+' '+typename(lhs))
    add('rhs shape',shape(rhs)+' '+typename(rhs))
    add('signature',shape(lhs)+' ['+typename(lhs)+'] = '+shape(rhs)+' ['+typename(rhs)+']')
    m=lhs and rhs and lhs.op=='value' and lhs.storage==1 and lhs.type==64
    simple=lambda n:n and n.op=='value' and n.type==64 and (n.storage==1 or leaf(n)=='integer')
    if m:
        if simple(rhs):add('plain local int, simple RHS',leaf(rhs))
        elif rhs and rhs.op in ('+','-','*','&','|','^','<<','>>','/','%','<','<=','>','>=','==','!='):
            l=ns.get(rhs.left); h=ns.get(rhs.right)
            if simple(l) and simple(h):
                overlap=lhs.object in (l.object,h.object)
                add('plain local int, two simple RHS leaves',rhs.op+' '+leaf(l)+' '+leaf(h)+(' self' if overlap else ' distinct'))
        add('local int RHS',shape(rhs)+' '+typename(rhs))
    if lhs and rhs and lhs.op=='->':
        b=ns.get(lhs.left)
        if b and b.storage==1 and b.kind==7 and (rhs.op=='value' or rhs.op=='->'):
            add('single local pointer field',typename(lhs)+' = '+shape(rhs)+' '+typename(rhs))
    if strict:add('exact signature',shape(lhs)+' ['+typename(lhs)+'] = '+shape(rhs)+' ['+typename(rhs)+']')
r=None;ns={}
for line in p.open():
    v=line.rstrip().split('\t');kind=v[0]
    if kind=='assignment-shape':
        collect(r,ns);r=Root(*map(int,v[1:]));ns={}
    elif kind=='assignment-node':
        node=Tag(int(v[2]),int(v[3]),v[4],*map(int,v[5:]));ns[node.node]=node
collect(r,ns)
with out.open('w') as f:
    for group in freq:
        print('\n',group,'total',sum(freq[group].values()),'records',sum(rec[group].values()),file=f)
        for name,n in freq[group].most_common(35):
            print(n,rec[group][name],name,'lines',','.join(map(str,examples[group,name])),sep='\t',file=f)
    print('roots',sum(freq['root op'].values()),file=f)
