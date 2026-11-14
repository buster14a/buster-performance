import os, json, re, datetime, sys
D=os.environ.get('QUEUE_DATA', '.') + '/'
def ts(s): return datetime.datetime.fromisoformat(s.replace('Z','+00:00')).timestamp() if s else None
rid=sys.argv[1]
jobs=[]
for p in (1,2): jobs+=json.load(open(D+'jobs/%s-%d.json'%(rid,p)))['jobs']
t0=min(ts(j['created_at']) for j in jobs)
rows=[]
for j in jobs:
    if j['conclusion']=='skipped': continue
    c,s,e=ts(j['created_at']),ts(j['started_at']),ts(j['completed_at'])
    rows.append(((e-t0)/60,(c-t0)/60,(s-t0)/60,j))
rows.sort(key=lambda r:-r[0])
for e,c,s,j in rows[:int(sys.argv[2]) if len(sys.argv)>2 else 12]:
    n=re.sub(r'Tests on Ubuntu 26.04 ','',j['name'])
    print('end %5.1f created %5.1f start %5.1f wait %4.1f  %s [%s]'%(e,c,s,s-c,n[:120],j['runner_name']))
    for st in j['steps']:
        a,b=ts(st['started_at']),ts(st['completed_at'])
        if a and b and b-a>=20: print('        %6.0fs %s'%(b-a,st['name'][:100]))
