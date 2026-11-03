import sys,collections,os
P=50021
def symbolized(v):
    addrs=[l.strip() for l in open(f'{v}.addresses')]
    blocks=open(f'{v}.symbolized').read().split('\n\n')
    blocks=[b for b in blocks if b.strip()]
    assert len(blocks)==len(addrs),(len(blocks),len(addrs))
    m={}
    for a,b in zip(addrs,blocks):
        lines=b.strip().split('\n')
        frames=[(lines[i],lines[i+1]) for i in range(0,len(lines)-1,2)]
        m[int(a,16)]=frames
    return m
def counts(v,mode):
    c=collections.Counter()
    for l in open(f'{v}-{mode}.ips'):
        parts=l.split()
        n=int(parts[0]); ip=int(parts[1],16)
        c[ip]+=n
    return c
def short(loc):
    f,_,rest=loc.rpartition('/src/buster/compiler/')
    return rest if rest else loc
key=sys.argv[1] if len(sys.argv)>1 else 'inner'
for mode in ('fsyntax','c'):
    agg={}
    for v in ('base','pgo'):
        s=symbolized(v); c=counts(v,mode); a=collections.Counter()
        instr=int(open(f'{v}-{mode}.stat').readline().split(',')[0])
        P=instr/sum(c.values())
        for ip,n in c.items():
            fr=s.get(ip)
            if not fr: k='?'
            elif key=='inner': k=fr[0][0]
            elif key=='outer': k=fr[-1][0]
            elif key=='line': k=fr[0][0]+' '+short(fr[0][1]).rsplit(':',1)[0]
            a[k]+=n*P/1e6
        agg[v]=a
    keys=set(agg['base'])|set(agg['pgo'])
    rows=sorted((agg['pgo'][k]-agg['base'][k],k) for k in keys)
    tb=sum(agg['base'].values()); tp=sum(agg['pgo'].values())
    print(f'== {mode} by {key}: base {tb:.1f} M, pgo {tp:.1f} M, {tp-tb:+.1f}')
    for d,k in rows[:int(sys.argv[2]) if len(sys.argv)>2 else 40]:
        print(f'  {d:+7.2f}  base {agg["base"][k]:7.2f}  pgo {agg["pgo"][k]:7.2f}  {k}')
    print('  increases:')
    for d,k in rows[::-1][:12]:
        print(f'  {d:+7.2f}  base {agg["base"][k]:7.2f}  pgo {agg["pgo"][k]:7.2f}  {k}')
