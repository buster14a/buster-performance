import sys,re,collections
# aggregate perf srcline report by (function, file, line range of the enclosing source function)
import bisect
src='/home/user/buster/src/buster/compiler/'
defs={}
for f in ['c_direct_lex.c','c_direct_cc.c','c_direct_types.c','c_direct_x86.c']:
    starts=[];names=[]
    for i,l in enumerate(open(src+f),1):
        m=re.match(r'^static .*?\b(\w+)\(',l)
        if m and not l.startswith('static const') : starts.append(i);names.append(m.group(1))
        elif re.match(r'^static\s+(inline\s+)?[\w\s\*]+\b(\w+)\(',l): pass
    defs[f]=(starts,names)
agg=collections.Counter(); bysym=collections.Counter()
for l in open(sys.argv[1]):
    p=l.split()
    if len(p)<4: continue
    pct=float(p[0].rstrip('%')); sym=p[2]; sl=p[3]
    bysym[sym]+=pct
    if ':' in sl:
        f,ln=sl.rsplit(':',1)
        try: ln=int(ln)
        except: ln=0
        if f in defs and ln>0:
            s,n=defs[f]; k=bisect.bisect_right(s,ln)-1
            inner=n[k] if k>=0 else '?'
        else: inner=sl
    else: inner=sl
    agg[(sym,inner)]+=pct
want=sys.argv[2:] 
for (sym,inner),v in sorted(agg.items(), key=lambda x:-x[1]):
    if (not want or sym in want) and v>=0.08: print(f"{v:6.2f}  {sym:34s} {inner}")
