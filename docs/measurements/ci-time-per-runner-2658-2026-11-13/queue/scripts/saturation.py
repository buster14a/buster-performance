# Reads commands.json (parse.py's).
import json,collections,re
rows=json.load(open('commands.json'))
sh=[r for r in rows if r['row'] and 'shard' in r['name']]
by=collections.defaultdict(lambda: collections.defaultdict(list))
for r in sh: by[r['row']][r['job']].append(r)
summ={}
for line in open('summary.txt') if False else []: pass
print('%-15s %6s %8s %8s %8s %8s %8s'%('row','shards','work','ideal','max1cmd','maxshard','util'))
T=[0,0]
for row,jobs in sorted(by.items()):
    work=sum(r['cputime'] for v in jobs.values() for r in v)
    granted=sum(r['wall']*r['ncpu'] for v in jobs.values() for r in v)
    n=len(jobs)
    longest=max(r['wall'] for v in jobs.values() for r in v)
    # shard wall approximated by the parallel summary: use max over shards of (sum granted/4, longest)
    shard_lb=[max(sum(r['wall']*r['ncpu'] for r in v)/4, max(r['wall'] for r in v)) for v in jobs.values()]
    print('%-15s %6d %8.0f %8.0f %8.0f %8.0f %8.2f'%(row,n,work,work/4/n,longest,max(shard_lb),work/granted))
