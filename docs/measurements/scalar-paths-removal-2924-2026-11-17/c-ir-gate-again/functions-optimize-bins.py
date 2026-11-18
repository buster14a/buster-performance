import re,sys,glob,collections
pat=re.compile(r'function=(\S+) blocks=(\d+) slots=(\d+) instructions=(\d+) promoted_instructions=(\d+) vector_ns=([\d.]+) scalar_ns=([\d.]+) optimize_vector_ns=([\d.]+) optimize_scalar_ns=([\d.]+) optimize_auto_ns=([\d.]+)')
def load(f):
    d={}
    for line in open(f):
        m=pat.search(line)
        if m:
            g=m.groups(); d[g[0]]=tuple(int(x) for x in g[1:5])+tuple(float(x) for x in g[5:])
    return d
bins=[(0,32),(32,128),(128,512),(512,2048),(2048,8192),(8192,1<<40)]
for corpus in ('sqlite','lua'):
    runs=[load(f) for f in sorted(glob.glob(f'{corpus}-0-*.log'))]
    names=set(runs[0]).intersection(*runs[1:])
    agg=collections.defaultdict(lambda:[0,0.0,0.0,0.0,0])
    for n in names:
        b,s,i,p=runs[0][n][:4]
        ov=min(r[n][6] for r in runs); osc=min(r[n][7] for r in runs); oa=min(r[n][8] for r in runs)
        for lo,hi in bins:
            if lo<=i<hi:
                a=agg[(lo,hi)]; a[0]+=1; a[1]+=ov; a[2]+=osc; a[3]+=oa; a[4]+= ov>osc
    print(f'== {corpus}: optimizer by lowered instructions (vector / scalar, auto / scalar)')
    t=[0,0,0]
    for lo,hi in bins:
        a=agg.get((lo,hi))
        if not a: continue
        t[0]+=a[1];t[1]+=a[2];t[2]+=a[3]
        print(f'  instr [{lo},{hi}): n={a[0]:4d} vector/scalar={a[1]/a[2]:.3f} auto/scalar={a[3]/a[2]:.3f} vector slower in {a[4]}')
    print(f'  all: vector {t[0]/1e6:.2f} ms scalar {t[1]/1e6:.2f} auto {t[2]/1e6:.2f}: vector/scalar {t[0]/t[1]:.3f} auto/scalar {t[2]/t[1]:.3f}')
