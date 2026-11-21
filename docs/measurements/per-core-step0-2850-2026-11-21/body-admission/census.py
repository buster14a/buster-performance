"""Census evaluated expression trees and complete lowered body streams from the inventory dump."""
from pathlib import Path
import collections, csv, itertools, struct, sys
d=Path(__file__).resolve().parent
POP=struct.Struct('<12I32s');NONE=2**32-1
kernels=('step0','scalar','scalar-memory','scalar-memory-calls','discard','aggregate-address','plain-quiet-shape')
# The class byte describes the *result*. It does not characterize the operand's full type or check warnings.
def supported(family,k,times,taken):
    op,c=k[0],k[2]
    if family=='step0': return taken
    if times!=1:return False
    if family in ('discard','aggregate-address','plain-quiet-shape'):
        if family=='plain-quiet-shape' and k[6]!=0:return False
        if c==0 and op in (24,34):return True
        if c==255 and family!='discard' and op in (0,25,26,29,32,33) and k[1]&1:return True
        family='scalar-memory-calls'
    if not 1<=c<=8: return False
    if op in {*range(25),27,28,30,31,37,*range(38,52)}:return True
    if family in ('scalar-memory','scalar-memory-calls') and op in (25,26,29,32,33,35,36):return True
    return family=='scalar-memory-calls' and op==34
def table(name,head,rows):
    with (d/name).open('w') as f:
        w=csv.writer(f,delimiter='\t',lineterminator='\n');w.writerow(head);w.writerows(rows)
allb=[];allr=[];blocks=[];fails=[]
for corpus in ('sqlite3','musl'):
    data=(d.parent/'step0-lanes/dumps'/f'{corpus}.dump').read_bytes()
    with (d/f'{corpus}.roots').open() as f: roots=iter([tuple(map(int,l.split())) for l in f])
    at=0;body=0;ordinal=0
    while at<len(data):
        tag,n,e=struct.unpack_from('<III',data,at);assert tag==0x59444f42
        owners=list(struct.iter_unpack('<II',data[at+12+e*10:at+12+e*18]))
        start=at+12+e*18
        pops=list(POP.iter_unpack(data[start:start+n*POP.size]));at=start+n*POP.size;body+=1
        children=collections.defaultdict(list);rs=[];node_root={}
        for j,p in enumerate(pops):
            if p[6]==NONE:continue
            if p[1]>=n:rs.append(j)
            else:children[p[1]].append(j)
        traces={k:[] for k in kernels}
        counts=collections.Counter()
        owned=collections.Counter(j for j,what in owners if j<n and what<=1)
        for irr,r in enumerate(rs):
            q=[r];nodes=[]
            while q:
                x=q.pop();nodes.append(x);q.extend(children[x])
            nr,size,twin,taken=next(roots)
            assert nr==ordinal and size==len(nodes) and twin==taken
            ordinal+=1
            for j in nodes:assert j not in node_root;node_root[j]=irr
            en=sum(owned[j] for j in nodes)
            for m in kernels:
                bad={j for j in nodes if not supported(m,pops[j][-1],pops[j][7],taken)}
                ok=not bad
                traces[m].append((ok,len(nodes),en))
                if m!='step0' and bad:
                    for j in bad:counts[m,pops[j][-1][0],pops[j][-1][2],pops[j][7]]+=1
        assert len(node_root)==sum(p[6]!=NONE for p in pops)
        for (m,op,c,times),v in counts.items():fails.append((corpus,m,op,c,times,v))
        for m,t in traces.items():
            yes=[r for r in t if r[0]]
            # Consume one group at a time before advancing the shared iterator.
            for ok,group in itertools.groupby(t,key=lambda v:v[0]):
                chunk=list(group)
                if ok: blocks.append((corpus,m,body,len(chunk),sum(x[1] for x in chunk),sum(x[2] for x in chunk)))
            allb.append((corpus,m,body,len(rs),len(node_root),e,sum(en for _,_,en in t),len(yes),sum(n for _,n,_ in yes),sum(en for _,_,en in yes)))
    assert next(roots,None)==None and at==len(data)
table('bodies.tsv',['input','admission','body','roots','evaluated nodes','stream entries','owned entries','eligible roots','eligible nodes','eligible owned entries'],allb)
table('runs.tsv',['input','admission','body','contiguous roots','evaluated nodes','owned entries'],blocks)
by=collections.Counter()
for g,m,op,c,t,n in fails:by[g,m,op,c,t]+=n
table('rejecting-nodes.tsv',['input','admission','operator','result class','pops','nodes'],[(*k,v) for k,v in by.most_common()])
for g,m in itertools.product(('sqlite3','musl'),kernels):
    rows=[r for r in allb if r[:2]==(g,m)];whole=[r for r in rows if r[3]==r[7] and r[3]];mix=[r for r in rows if 0<r[7]<r[3]];runs=[r[4] for r in blocks if r[:2]==(g,m)]
    report=(g,m,len(rows),sum(r[3]>0 for r in rows),sum(r[4] for r in rows),sum(r[5] for r in rows),sum(r[6] for r in rows),len(whole),sum(r[4] for r in whole),len(mix),sum(r[8] for r in mix),sum(r[8] for r in rows),sum(r[9] for r in rows),len(runs),sum(n for n in runs if n>=64))
    allr.append(report);print(*report)
table('coverage.tsv',['input','admission','bodies','nonempty bodies','evaluated nodes','stream entries','owned entries','fully admitted nonempty bodies','nodes in fully admitted bodies','mixed bodies','eligible nodes in mixed bodies','eligible nodes','eligible owned entries','eligible runs','eligible nodes in runs of at least 64'],allr)
