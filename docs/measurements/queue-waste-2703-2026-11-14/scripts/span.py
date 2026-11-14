import os, json, re, datetime, collections, statistics, sys
D=os.environ.get('QUEUE_DATA', '.') + '/'
def ts(s): return datetime.datetime.fromisoformat(s.replace('Z','+00:00')).timestamp() if s else None
main=set(open(D+'main.txt').read().split())
starts=collections.defaultdict(list); builds=collections.defaultdict(list); ends=collections.defaultdict(list)
for line in open(D+'runs.tsv'):
    rid, concl, st, up, sha, br, att = line.rstrip('\n').split('\t')
    if sha not in main: continue
    jobs=[]
    try:
        for p in (1,2): jobs+=json.load(open(D+'jobs/%s-%d.json'%(rid,p)))['jobs']
    except Exception: continue
    t0=min(ts(j['created_at']) for j in jobs)
    for j in jobs:
        if j['conclusion']!='success': continue
        n=j['name']
        row=None
        m=re.search(r'\(Clang 23, (native|x86-64), (none|address|thread|memory), O3, shard (\d+)',n)
        if m: row=m.group(1)+'-'+m.group(2)
        if 'Vector draw' in n and 'candidate' in n: row='vector-item'
        if 'Build the compiler once' in n:
            m=re.search(r'\((x86-64), (none|address|thread|memory)',n); 
            for s in j['steps']:
                if s['name'].startswith('Build the external') and s['completed_at']:
                    builds['x86-64-'+m.group(2)+' product'].append(ts(s['completed_at'])-ts(s['started_at']))
            ends['x86-64-'+m.group(2)+' product'].append((ts(j['completed_at'])-t0)/60)
        if not row: continue
        for s in j['steps']:
            if not s['completed_at']: continue
            if s['name'].startswith('Run correctness tests'):
                starts[row].append((ts(s['started_at'])-t0)/60); ends[row].append((ts(s['completed_at'])-t0)/60)
            if s['name'].startswith('Build the external'):
                builds[row].append(ts(s['completed_at'])-ts(s['started_at']))
for k in sorted(set(starts)|set(builds)):
    print('%-22s tests start med %5.1f min | test end max-per-run med n/a | build med %5.0f s max %5.0f'%(k, statistics.median(starts[k]) if starts[k] else -1, statistics.median(builds[k]) if builds[k] else -1, max(builds[k]) if builds[k] else -1))
for k in sorted(ends):
    if 'product' in k: print('%-22s product job ends med %.1f min'%(k,statistics.median(ends[k])))
