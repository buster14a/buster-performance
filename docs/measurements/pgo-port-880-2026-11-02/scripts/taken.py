import collections,sys
addrs=[l.strip() for l in open('taken.addrs')]
blocks=[b for b in open('taken.sym').read().split('\n\n') if b.strip()]
assert len(addrs)==len(blocks)
m={}
for a,b in zip(addrs,blocks):
    ls=b.strip().split('\n'); m[a]=[(ls[i],ls[i+1].rsplit('/',1)[-1]) for i in range(0,len(ls)-1,2)]
tot=0; byline=collections.Counter(); byfunc=collections.Counter(); kinds=collections.Counter()
edges=[]
for l in open('taken.edges'):
    n,e=l.split(); f,t=e.split('/'); n=int(n)
    fr=m.get(f,[('?','?')])
    tot+=n
    loc=fr[0][0]+' '+fr[0][1].rsplit(':',1)[0]
    byline[loc]+=n; byfunc[fr[-1][0]]+=n
    back=int(t,16)<int(f,16)
    kinds['backward' if back else 'forward']+=n
    edges.append((n,f,t,loc,back))
scale=904.2e6*0.0+71.7e6/tot
print(f'total entries {tot}, scale {scale:.0f} taken per entry; kinds', {k:f'{v/tot*100:.0f}%' for k,v in kinds.items()})
print('by compiled function:')
for k,v in byfunc.most_common(15): print(f'  {v*scale/1e6:6.2f} M  {v/tot*100:5.1f}%  {k}')
print('by source line:')
acc=0
for i,(k,v) in enumerate(byline.most_common(int(sys.argv[1]) if len(sys.argv)>1 else 40)):
    acc+=v; print(f'  {v*scale/1e6:6.2f} M  {acc/tot*100:5.1f}% cum  {k}')
