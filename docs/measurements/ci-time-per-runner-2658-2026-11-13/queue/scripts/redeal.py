# Usage: redeal.py ROW SHARDS [buster's tools/ci/correctness.tests at the candidate], reading commands.json.
import json,collections,heapq,re,sys
rows=json.load(open('commands.json'))
speed={'7763':1.0,'9V45':0.64,'6973P':0.64,'9V74':0.79,'8573':0.80,'8370':0.89}
def factor(cpu):
    for k,v in speed.items():
        if cpu and k in cpu.upper().replace('8573C','8573'): return v
    return 0.8
def sim(cmds,J=4,key='wall'):
    t=0.0; free=J; running=[]
    for c in cmds:
        need=min(c['ncpu'],J)
        while free<need:
            e,k=heapq.heappop(running); t=max(t,e); free+=k
        heapq.heappush(running,(t+c[key],need)); free-=need
    return max([e for e,k in running]+[t])
def deal(cmds,n,costkey):
    # costliest first to the shard that would end earliest (scheduled deal), each shard in list order
    shards=[[] for _ in range(n)]
    for c in sorted(cmds,key=lambda c:-c[costkey]):
        best=None
        for i in range(n):
            trial=sorted(shards[i]+[c],key=lambda x:x['order'])
            e=sim(trial,key='est')
            if best is None or e<best[0]: best=(e,i)
        shards[best[1]].append(c)
    return [sorted(s,key=lambda x:x['order']) for s in shards]
def split(cmds,pattern,parts):
    out=[]
    groups=collections.defaultdict(list)
    for c in cmds:
        if re.search(pattern,c['title']): groups['g'].append(c)
        else: out.append(c)
    if groups['g']:
        total=sum(c['wall'] for c in groups['g']); cpu=sum(c['cputime'] for c in groups['g'])
        o=min(c['order'] for c in groups['g'])
        for k in range(parts):
            out.append(dict(title='split %d'%k,wall=total/parts,cputime=cpu/parts,ncpu=1,order=o+k*0.001))
    return out
def elastic(shard,J=4):
    # long serial commands absorb idle CPUs: shard end ~ max(work/J, longest part)
    work=sum(c['wall']*min(c['ncpu'],J) for c in shard)
    return work/J
row=sys.argv[1]; n=int(sys.argv[2])
cmds=[]
seen=set()
for r in rows:
    if r['row']==row and 'shard' in r['name']:
        f=factor(r['cpu'])
        cmds.append(dict(title=r['title'],wall=r['wall']/f,cputime=r['cputime']/f,ncpu=r['ncpu'],order=len(cmds)))
# list order: use the inventory order
inv=[l[3:].strip() for l in open(sys.argv[3] if len(sys.argv)>3 else 'correctness.tests') if l.startswith('== ')]
pos={t:i for i,t in enumerate(inv)}
for c in cmds: c['order']=pos.get(c['title'],999)
def run(label,cs):
    for c in cs: c['est']=c['wall']; c['cost']=c['wall']*min(c['ncpu'],4)
    sh=deal(cs,n,'cost')
    ends=[sim(s) for s in sh]; el=[max(elastic(s),0) for s in sh]
    print('%-40s worst %5.0f  mean %5.0f   elastic worst %5.0f'%(label,max(ends),sum(ends)/n,max(el)))
run('fresh costs (7763 speed)',[dict(c) for c in cmds])
for p in (8,12,16):
    run('fresh + driver in %d parts'%p,split([dict(c) for c in cmds],r"semantic driver's diagnostics and emission against clang \(part",p))
print('lower bound work/4/n: %.0f'%(sum(c['wall']*min(c['ncpu'],4) for c in cmds)/4/n), ' longest command %.0f'%max(c['wall'] for c in cmds))

# Saturated: the deal by used CPU, each shard ending at max(used/4, its longest command)
cs=[dict(c) for c in cmds]
for c in cs: c['est']=c['cputime']/min(c['ncpu'],4); c['cost']=c['cputime']
n_=n
shards=[[] for _ in range(n_)]
for c in sorted(cs,key=lambda c:-c['cost']):
    i=min(range(n_),key=lambda i:max(sum(x['cost'] for x in shards[i])+c['cost'],0))
    shards[i].append(c)
ends=[max(sum(x['cputime'] for x in s)/4,max(x['wall'] for x in s)) for s in shards]
print('saturated (used CPU/4, longest)         worst %5.0f  used/4/n %5.0f'%(max(ends),sum(c['cputime'] for c in cs)/4/n_))
