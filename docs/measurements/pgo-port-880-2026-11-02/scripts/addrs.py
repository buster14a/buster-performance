import sys,collections
v,mode,func=sys.argv[1:4]
line=sys.argv[4] if len(sys.argv)>4 else None
addrs=[l.strip() for l in open(f'{v}.addresses')]
blocks=[b for b in open(f'{v}.symbolized').read().split('\n\n') if b.strip()]
m={}
for a,b in zip(addrs,blocks):
    ls=b.strip().split('\n'); m[int(a,16)]=[(ls[i],ls[i+1]) for i in range(0,len(ls)-1,2)]
c=collections.Counter()
for l in open(f'{v}-{mode}.ips'):
    p=l.split(); c[int(p[1],16)]+=int(p[0])
rows=[]
for ip,n in c.items():
    fr=m.get(ip)
    if fr and fr[0][0]==func and (line is None or (':'+line+':') in fr[0][1]):
        rows.append((ip,n,' <- '.join(f[0] for f in fr[1:3]), fr[0][1].rsplit('/',1)[1]))
rows.sort()
for ip,n,chain,loc in rows: print(hex(ip),n,loc,chain)
