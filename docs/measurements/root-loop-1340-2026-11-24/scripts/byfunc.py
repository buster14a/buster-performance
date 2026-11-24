#!/usr/bin/env python3
# Cycles by enclosing function from perf's source lines, for two variants. Usage: byfunc.py BASE.txt BASEDIR HEAD.txt HEADDIR [SCALE]
import sys, os, re, bisect
def funcs(path):
    starts=[]; names=[]
    try: lines=open(path,errors='replace').read().split('\n')
    except OSError: return None
    for i,l in enumerate(lines):
        m=re.match(r'^(?:static |inline |__attribute__\S+ )*[A-Za-z_][\w \*]*?\b(\w+)\(', l)
        if m and not l.startswith(' ') and not l.startswith('//') and not l.startswith('#') and not l.rstrip().endswith(';'):
            starts.append(i+1); names.append(m.group(1))
    return starts,names
def load(fn, d, scale):
    cache={}; out={}
    for l in open(fn):
        p=l.split()
        if len(p)!=2 or ':' not in p[1]: continue
        f,n=p[1].rsplit(':',1)
        try: n=int(n)
        except ValueError: continue
        if f not in cache: cache[f]=funcs(os.path.join(d,f))
        fs=cache[f]
        if fs is None or not fs[0]: name=f+':?'
        elif n==0: name=f+':line0'
        else:
            i=bisect.bisect_right(fs[0],n)-1
            name=fs[1][i] if i>=0 else f+':top'
        out[name]=out.get(name,0)+float(p[0])*scale
    return out
scale=float(sys.argv[5]) if len(sys.argv)>5 else 1.0
b=load(sys.argv[1],sys.argv[2],scale); c=load(sys.argv[3],sys.argv[4],scale)
rows=sorted(((c.get(k,0)-b.get(k,0)),b.get(k,0),c.get(k,0),k) for k in set(b)|set(c))
print("total %.1f %.1f"%(sum(b.values()),sum(c.values())))
pat=sys.argv[6] if len(sys.argv)>6 else None
for d,bv,cv,k in rows:
    if (pat and re.search(pat,k)) or (not pat and abs(d)>=0.25): print("%+.2f %.2f %.2f %s"%(d,bv,cv,k))
