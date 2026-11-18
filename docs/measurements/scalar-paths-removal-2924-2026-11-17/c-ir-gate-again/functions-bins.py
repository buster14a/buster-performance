import re,sys,glob,collections
pat=re.compile(r'function=(\S+) blocks=(\d+) slots=(\d+) instructions=(\d+) promoted_instructions=(\d+) vector_ns=([\d.]+) scalar_ns=([\d.]+)')
def load(f):
    d={}
    for line in open(f):
        m=pat.search(line)
        if m:
            n,b,s,i,p,v,sc=m.groups(); d[n]=(int(b),int(s),int(i),float(v),float(sc))
    return d
bins=[(0,64),(64,256),(256,1024),(1024,4096),(4096,16384),(16384,65536),(65536,262144),(262144,1<<40)]
for corpus in ('sqlite','lua'):
    for knob in ('0','1'):
        runs=[load(f) for f in sorted(glob.glob(f'{corpus}-{knob}-*.log'))]
        names=set(runs[0]).intersection(*runs[1:])
        agg=collections.defaultdict(lambda:[0,0.0,0.0,0,[]])
        for n in names:
            b,s,i,_,_=runs[0][n]
            cells=b*s
            v=min(r[n][3] for r in runs); sc=min(r[n][4] for r in runs)
            for lo,hi in bins:
                if lo<=cells<hi:
                    a=agg[(lo,hi)]; a[0]+=1; a[1]+=v; a[2]+=sc; a[3]+= v>sc; a[4].append(v/sc)
        print(f'== {corpus} knob {knob} ({"forced vector" if knob=="1" else "AUTO"}) vs scalar twin')
        tv=ts=0
        for lo,hi in bins:
            a=agg.get((lo,hi))
            if not a: continue
            r=sorted(a[4]); med=r[len(r)//2]
            tv+=a[1]; ts+=a[2]
            print(f'  cells [{lo},{hi}): n={a[0]:4d} vector/scalar total={a[1]/a[2]:.3f} median={med:.3f} min={r[0]:.3f} max={r[-1]:.3f} vector slower in {a[3]}')
        print(f'  all: vector {tv/1e6:.2f} ms, scalar {ts/1e6:.2f} ms, ratio {tv/ts:.3f}')
