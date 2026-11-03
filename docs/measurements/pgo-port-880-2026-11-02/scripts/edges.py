import sys,collections
def sym(v):
    addrs=[l.strip() for l in open(f'{v}.edgeaddrs')]
    blocks=[b for b in open(f'{v}.edgesym').read().split('\n\n') if b.strip()]
    assert len(addrs)==len(blocks),(len(addrs),len(blocks))
    m={}
    for a,b in zip(addrs,blocks):
        ls=b.strip().split('\n'); m[a]=[(ls[i],ls[i+1].rsplit('/',1)[-1]) for i in range(0,len(ls)-1,2)]
    return m
mode=sys.argv[1]
P=1009
res={}
for v in ('base','pgo'):
    s=sym(v); callee=collections.Counter(); edge=collections.Counter()
    for l in open(f'{v}-{mode}.edges'):
        n,e=l.split(); f,t=e.split('/')
        cf=s.get(f,[('?','?')]); tf=s.get(t,[('?','?')])
        # callee: outermost frame at the ret (the function the ret belongs to)
        ce=cf[-1][0]
        # caller: innermost frame at the return address, plus its outer function
        ca=tf[0][0]+' @'+tf[0][1]+(' in '+tf[-1][0] if len(tf)>1 else '')
        callee[ce]+=int(n)*P; edge[(ce,ca)]+=int(n)*P
    res[v]=(callee,edge)
cb,eb=res['base']; cp,ep=res['pgo']
print(f'== {mode}: calls by callee (estimated), base total {sum(cb.values())/1e6:.2f} M, pgo {sum(cp.values())/1e6:.2f} M')
for k,n in cb.most_common(int(sys.argv[2]) if len(sys.argv)>2 else 40):
    print(f'  {n/1e3:8.0f}k base  {cp.get(k,0)/1e3:8.0f}k pgo  {k}')
if len(sys.argv)>3:
    print('== top edges (base)')
    for (ce,ca),n in eb.most_common(int(sys.argv[3])):
        print(f'  {n/1e3:8.0f}k  {ce}  <-  {ca}')
