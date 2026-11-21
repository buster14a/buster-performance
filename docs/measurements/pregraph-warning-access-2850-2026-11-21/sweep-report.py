import sys,json
from collections import Counter
for filename in sys.argv[1:]:
 cases=Counter()
 measures={}
 with open(filename) as f:
  for line in f:
   policy,source,rc,groups,evidence=json.loads(line);cases[(policy,rc)]+=1
   cols=measures.setdefault(policy,Counter())
   for g,row in groups.items():
    if 'branch=' in g: cols.update({f'access-{k}':int(v) for k,v in row.items()})
    elif 'kind=' in g: cols.update({g.split()[-1]+'-'+k:int(v) for k,v in row.items()})
    elif g=='probe-entry': cols.update({'entry-'+k:int(v) for k,v in row.items()})
   if evidence: print('evidence',policy,source,evidence)
 for p,c in sorted(measures.items()): print(filename,p,'statuses',sorted((rc,n) for (a,rc),n in cases.items() if a==p), ' '.join(f'{k}={v}' for k,v in sorted(c.items())))
