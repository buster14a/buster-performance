# Reads commands.json (parse.py's).
import json,collections,heapq
rows=json.load(open('commands.json'))
sh=[r for r in rows if r['row'] and 'shard' in r['name']]
jobs=collections.OrderedDict()
for r in sh: jobs.setdefault(r['job'],[]).append(r)
def sim(cmds,J=4):
    # list order; a command needing more CPUs than free waits and holds back the rest; >J runs alone with all J
    t=0.0; free=J; running=[]  # (end, cpus)
    for c in cmds:
        need=min(c['ncpu'],J)
        while free<need:
            e,k=heapq.heappop(running); t=max(t,e); free+=k
        heapq.heappush(running,(t+c['wall'],need)); free-=need
    return max([e for e,k in running]+[t])
def lpt(cmds,key):
    return sim(sorted(cmds,key=key))
tot=collections.defaultdict(lambda:[0,0,0,0])
print('%-16s %-14s %7s %7s %7s %7s %7s'%('row','shard','actual','sim','lpt','bound','work/4'))
for j,cmds in jobs.items():
    name=cmds[0]['name']; row=cmds[0]['row']; shard=name[name.find('shard'):-1]
    s=sim(cmds); l=lpt(cmds,lambda c:-c['wall']*min(c['ncpu'],4)); l2=lpt(cmds,lambda c:(-min(c['ncpu'],4),-c['wall']))
    work=sum(c['cputime'] for c in cmds)
    granted=sum(c['wall']*min(c['ncpu'],4) for c in cmds)
    bound=max(max(c['wall'] for c in cmds), granted/4)
    print('%-16s %-14s %7s %7.0f %7.0f %7.0f %7.0f'%(row,shard,'',s,min(l,l2),bound,work/4))
    t=tot[row]; t[0]=max(t[0],s); t[1]=max(t[1],min(l,l2)); t[2]=max(t[2],bound); t[3]=max(t[3],work/4)
print()
for row,t in sorted(tot.items()): print('%-16s worst shard: sim %5.0f  lpt %5.0f  bound %5.0f  max work/4 %5.0f'%(row,*t))
