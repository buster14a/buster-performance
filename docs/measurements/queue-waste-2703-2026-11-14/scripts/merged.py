import os, json, re, datetime, collections, statistics
D=os.environ.get('QUEUE_DATA', '.') + '/'
def ts(s): return datetime.datetime.fromisoformat(s.replace('Z','+00:00')).timestamp() if s else None
main=set(open(D+'main.txt').read().split())
last=collections.Counter(); walls=[]; pre=[]
stepsum=collections.defaultdict(list)
rowmax=collections.defaultdict(list)
for line in open(D+'runs.tsv'):
    rid, concl, st, up, sha, br, att = line.rstrip('\n').split('\t')
    if sha not in main: continue
    jobs=[]
    try:
        for p in (1,2): jobs+=json.load(open(D+'jobs/%s-%d.json'%(rid,p)))['jobs']
    except Exception: continue
    t0=min(ts(j['created_at']) for j in jobs)
    run=[j for j in jobs if j['conclusion']!='skipped' and j['started_at'] and j['completed_at']]
    work=[j for j in run if not re.match(r'(Integration qualification|Coverage record|Vector row verdict|.*verdict)',j['name']) and 'verdict' not in j['name']]
    lastj=max(work,key=lambda j: ts(j['completed_at']))
    n=lastj['name']
    k=re.sub(r'shard \d+ of','shard K of',re.sub(r'candidate \d+','candidate K',n))
    k=re.sub(r'Tests on Ubuntu 26.04 ','',k)
    last[k[:110]]+=1
    walls.append((max(ts(j['completed_at']) for j in run)-t0)/60)
    sh=[j for j in run if 'shard' in j['name'] or 'Vector draw 1, candidate' in j['name']]
    pre.append((min(ts(j['started_at']) for j in sh)-t0)/60)
    for j in run:
        for s in j['steps']:
            a,b=ts(s['started_at']),ts(s['completed_at'])
            if a and b: stepsum[s['name']].append(b-a)
        m=re.search(r'\((?:Clang 23, )?(native|x86-64|vector)[^)]*?(none|address|thread|memory)[^)]*shard (\d+) of (\d+)\)',j['name'])
        if m:
            tt=[ts(s['completed_at'])-ts(s['started_at']) for s in j['steps'] if s['name'].startswith('Run correctness tests') and s['started_at'] and s['completed_at']]
            if tt: rowmax[(m.group(1),m.group(2),int(m.group(3)),int(m.group(4)))].append(tt[0])
print('merged runs', len(walls), 'wall median %.1f min, min %.1f max %.1f'%(statistics.median(walls),min(walls),max(walls)))
print('first test job starts: median %.1f min'%statistics.median(pre))
print('last-finishing work job:')
for k,v in last.most_common(): print('  %3d %s'%(v,k))
print('\nper shard test step median (s):')
for k in sorted(rowmax): print('  %-30s n=%2d median %6.0f max %6.0f'%(k,len(rowmax[k]),statistics.median(rowmax[k]),max(rowmax[k])))
