import collections,sys
def load(v):
    m={}
    for l in open(f'{v}/calls.map'):
        p=l.split(); m[p[0]]=p[1] if len(p)>1 else '?'
    callee=collections.Counter(); edge=collections.Counter()
    for l in open(f'{v}/calls.edges'):
        n,e=l.split(); f,t=e.split('/')
        ce=m.get(f,'?'); ca=m.get(t,'?')
        w=int(n)*1011/4  # ~period, 4 runs
        callee[ce]+=w; edge[(ce,ca)]+=w
    return callee,edge
cb,eb=load('b'); cp,ep=load('pfull'); c0,e0=load('base')
print(f'calls: base {sum(c0.values())/1e6:.2f} M, b {sum(cb.values())/1e6:.2f} M, pgo {sum(cp.values())/1e6:.2f} M')
print('edges still hot in b (b - pgo):')
rows=sorted(((eb[k]-ep.get(k,0),k) for k in eb),reverse=True)
for d,(ce,ca) in rows[:int(sys.argv[1]) if len(sys.argv)>1 else 40]:
    print(f'  {eb[(ce,ca)]/1e3:7.0f}k b {ep.get((ce,ca),0)/1e3:7.0f}k pgo  {ce} <- {ca}')
