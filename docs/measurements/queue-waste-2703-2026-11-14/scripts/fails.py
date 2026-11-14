import os, json, re, datetime, collections
D=os.environ.get('QUEUE_DATA', '.') + '/'
def ts(s):
    return datetime.datetime.fromisoformat(s.replace('Z','+00:00')).timestamp() if s else None
main=set(open(D+'main.txt').read().split())
for line in open(D+'runs.tsv'):
    rid, concl, st, up, sha, br, att = line.rstrip('\n').split('\t')
    if concl!='failure': continue
    jobs=[]
    try:
        for p in (1,2): jobs+=json.load(open(D+'jobs/%s-%d.json'%(rid,p)))['jobs']
    except Exception: continue
    fl=[j for j in jobs if j['conclusion'] in ('failure','timed_out')]
    fl.sort(key=lambda j: j['completed_at'] or 'z')
    s0=ts(st)
    out=[]
    for j in fl[:3]:
        step=[s['name'] for s in j.get('steps',[]) if s['conclusion'] in ('failure','timed_out')]
        out.append('%5.1fm %s :: %s'%((ts(j['completed_at'])-s0)/60, re.sub(r'Tests on Ubuntu 26.04 ','',j['name'])[:110], step[:1]))
    pr=re.search(r'pr-(\d+)-',br).group(1)
    print(rid, 'pr', pr, st[5:16], len(fl), 'failed jobs')
    for o in out: print('    ',o)
