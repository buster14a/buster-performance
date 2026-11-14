import os, json, re, datetime, collections, statistics
D=os.environ.get('QUEUE_DATA', '.') + '/'
def ts(s): return datetime.datetime.fromisoformat(s.replace('Z','+00:00')).timestamp() if s else None
main=set(open(D+'main.txt').read().split())
agg=collections.defaultdict(list)   # (jobkind, step) -> durations (per run summed)
runcount=0
for line in open(D+'runs.tsv'):
    rid, concl, st, up, sha, br, att = line.rstrip('\n').split('\t')
    if sha not in main: continue
    jobs=[]
    try:
        for p in (1,2): jobs+=json.load(open(D+'jobs/%s-%d.json'%(rid,p)))['jobs']
    except Exception: continue
    runcount+=1
    per=collections.defaultdict(float)
    for j in jobs:
        if j['conclusion']=='skipped' or not j['started_at']: continue
        n=j['name']
        kind='other'
        if 'Vector draw' in n and 'candidate' in n: kind='vector-item'
        elif 'shard' in n:
            m=re.search(r'\(Clang 23, (\S+), (\S+), O3, shard',n); kind='shard '+(m.group(1)+'-'+m.group(2) if m else '?')
            kind='shard native' if 'native' in kind else 'shard x86-64'
        elif 'Build the compiler once' in n: kind='row-build'
        elif n.startswith('libFuzzer'): kind='fuzz'
        elif n.startswith('Auxiliary'): kind='auxiliary'
        else: kind='other'
        jt=ts(j['completed_at'])-ts(j['started_at'])
        acc=0
        for s in j['steps']:
            a,b=ts(s['started_at']),ts(s['completed_at'])
            if a and b:
                sn=re.sub(r'\d+','N',s['name'])[:80]
                per[(kind,sn)]+=b-a; acc+=b-a
        per[(kind,'(job gaps / unattributed)')]+=jt-acc
        per[(kind,'(TOTAL)')]+=jt
    for k,v in per.items(): agg[k].append(v)
tot=sum(statistics.mean(v)*len(v)/runcount for k,v in agg.items() if k[1]=='(TOTAL)')
print('merged runs',runcount,'mean runner-min/run %.0f'%(tot/60))
rows=[(sum(v)/runcount/60,k) for k,v in agg.items() if k[1]!='(TOTAL)']
rows.sort(reverse=True)
for m,k in rows[:45]: print('%7.1f min  %5.1f%%  %-14s %s'%(m,100*m*60/tot,k[0],k[1]))
print()
for k,v in sorted(agg.items()):
    if k[1]=='(TOTAL)': print('%-14s total %.1f min/run'%(k[0],sum(v)/runcount/60))
