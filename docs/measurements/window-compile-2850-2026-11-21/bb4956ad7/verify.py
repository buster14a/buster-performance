"""Compare the complete node and effect records for all source partitions of every declaration."""
from pathlib import Path
import csv
import re
import sys
here=Path(__file__).resolve().parent
for name in sys.argv[1:] or ('sqlite','main'):
    src=(here/(name+'.source.log')).read_text();ref=(here/(name+'.whole.log')).read_text()
    def data(txt, head, fields):
        rows=[l.split('\t')[1:] for l in txt.splitlines() if l.startswith(head+'\t')]
        keys={tuple(r[:fields]):r[fields:] for r in rows};assert len(rows)==len(keys)
        return keys
    ordinary=data(ref,'body-whole-row',1);whole=data(ref,'static-whole-row',2)
    body=data(src,'body-source-row',1);sliced=data(src,'static-source-row',2)
    done=data(src,'static-completed',1)
    errors=[]
    if set(body)&set(done) or set(body)|set(done)!=set(ordinary):errors.append(('coverage',len(body),len(done),len(ordinary)))
    if any(k[0] not in {d[0] for d in done} for k in sliced):errors.append(('partial-declaration',))
    for k,row in body.items():
        if ordinary.get(k)!=row:errors.append(('whole',k,row,ordinary.get(k)))
    cut_keys=set(k for k in whole if (k[0],) in done)
    if set(sliced)!=cut_keys:errors.append(('slice-coverage',len(sliced),len(cut_keys)))
    for (key,),v in done.items():
        rows=[r for (d,_),r in sliced.items() if d==key]
        n=sum(int(r[0])+int(r[1]) for r in rows)
        if ordinary.get((key,),['-'])[0]!=str(n) or v!=[str(n)]:errors.append(('count',key,n,v,ordinary.get((key,))))
    for k,row in sliced.items():
        if whole.get(k)!=row:errors.append(('slice',k,row,whole.get(k)))
    total=sum(int(row[0]) for row in ordinary.values())
    p=here/(name+'.partitions.tsv')
    with p.open('w') as f:
        write=csv.writer(f,delimiter='\t',lineterminator='\n')
        write.writerow(['declaration','cut','source-nodes','source-casts','source-node-hash','source-cast-hash','ordinary-nodes','ordinary-casts','ordinary-node-hash','ordinary-cast-hash','exact'])
        for key,row in sliced.items():write.writerow([*key,*row,*whole.get(key,['-']*4),int(whole.get(key)==row)])
    print(name,'declarations',len(ordinary),'nodes',total,'sliced',len(done),'windows',len(sliced),'window_nodes',sum(int(r[0]) for r in done.values()),'errors',len(errors),errors[:6],flush=True)
    if not ordinary or errors:sys.exit(1)
