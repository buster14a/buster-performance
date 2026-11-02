import collections,sys
addrs=[l.strip() for l in open('taken.addrs')]
blocks=[b for b in open('taken.sym').read().split('\n\n') if b.strip()]
m={}
for a,b in zip(addrs,blocks):
    ls=b.strip().split('\n'); m[a]=[(ls[i],ls[i+1].rsplit('/',1)[-1]) for i in range(0,len(ls)-1,2)]
tot=sum(int(l.split()[0]) for l in open('taken.edges')); scale=71.7e6/tot
want=sys.argv[1]
c=collections.Counter()
for l in open('taken.edges'):
    n,e=l.split(); f,t=e.split('/')
    fr=m.get(f,[('?','?')])
    if any(x[0]==want for x in fr):
        chain=' <- '.join(f'{x[0]}:{x[1].split(":")[1]}' for x in fr[:3])
        c[(chain, 'back' if int(t,16)<int(f,16) else 'fwd')]+=int(n)
for (k,d),v in c.most_common(int(sys.argv[2]) if len(sys.argv)>2 else 15): print(f'  {v*scale/1e6:6.2f} M {d:4s} {k}')
