from collections import Counter
from pathlib import Path
import csv
import sys
base=Path(__file__).resolve().parent/'complete'
for name in sys.argv[1:] or ('sqlite','main'):
    def read(mode,tag):
        rows={}
        for line in (base/(name+'.'+mode+'.log')).read_text().splitlines():
            if line.startswith('source-control-'+tag+'\t'):
                _,close,count,nrefs,*fields=line.split('\t')
                assert len(fields)==int(count)+1 and len(fields[-1].split(','))==int(nrefs)+1
                assert close not in rows
                rows[close]=fields
        return rows
    local=read('source','local');whole=read('whole','whole')
    kinds=Counter();miss=[];branches=0;refs=0
    with (base/(name+'.control-comparison.tsv')).open('w') as out:
        wr=csv.writer(out,delimiter='\t',lineterminator='\n')
        wr.writerow(['close','controls','references','branching','exact','first_difference','local','ordinary'])
        for k,v in local.items():
            other=whole.get(k,[])
            exact=v==other
            first=next((i for i in range(min(len(v),len(other))) if v[i]!=other[i]),min(len(v),len(other)))
            dif='-' if exact else first
            bk=any(int(c.split(',')[0]) in (17,18,19) for c in v[:-1]);branches+=bk
            refs+=len(v[-1].split(','))-1
            for c in v[:-1]:kinds[int(c.split(',')[0])]+=1
            wr.writerow([k,len(v)-1,len(v[-1].split(','))-1,int(bk),int(exact),dif,v[first] if not exact and first<len(v) else '',other[first] if not exact and first<len(other) else ''])
            if not exact:miss.append((k,dif))
    print(name,'source',len(local),'whole',len(whole),'exact',len(local)-len(miss),'controls',sum(kinds.values()),'with_branch',branches,'references',refs,'kinds',dict(kinds),'first_mismatches',miss[:7],flush=True)
    if not local or miss:sys.exit(1)
