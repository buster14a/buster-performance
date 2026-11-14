# sizes.py LL REMARKS: per callee inlined (with a cost, no last-call bonus) in the whole unit, its raw instruction count,
# an "effective" count (no alloca, lifetime, or load/store through an alloca), and its median inline cost.
import re,sys,statistics,collections
ll,remarks=sys.argv[1],sys.argv[2]
raw={}; eff={}
cur=None; allocas=set()
for line in open(ll):
    if line.startswith('define '):
        m=re.search(r'@([\w.$]+)\(',line); cur=m.group(1); raw[cur]=0; eff[cur]=0; allocas=set(); continue
    if cur is None: continue
    if line.startswith('}'): cur=None; continue
    if not line.startswith('  ') or line.startswith('   '): 
        if not line.startswith('  '): continue
    s=line.strip()
    if not s or s.endswith(':') : continue
    raw[cur]+=1
    m=re.match(r'(%[\w.]+) = alloca',s)
    if m: allocas.add(m.group(1)); continue
    if 'llvm.lifetime' in s: continue
    m=re.match(r'(?:%[\w.]+ = )?load [^,]+, ptr (%[\w.]+)',s)
    if m and m.group(1) in allocas: continue
    m=re.match(r'store [^,]+, ptr (%[\w.]+)',s)
    if m and m.group(1) in allocas: continue
    eff[cur]+=1
costs=collections.defaultdict(list)
for line in open(remarks):
    m=re.search(r"'([\w.$]+)' inlined into '([\w.$]+)' with \(cost=(-?\d+), threshold=(\d+)\)",line)
    if m and int(m.group(3))>-5000:
        costs[m.group(1)].append((int(m.group(3)),int(m.group(4))))
rows=[]
for f,c in costs.items():
    if f in raw:
        rows.append((f,raw[f],eff[f],statistics.median([x for x,_ in c]),max(t for _,t in c),len(c)))
over=[r for r in rows if r[1]>300]
print("inlined callees with a cost:",len(rows),"raw>300:",len(over),"eff>300 among them:",len([r for r in over if r[2]>300]), "eff>150:",len([r for r in over if r[2]>150]))
for r in sorted(over,key=lambda r:-r[5])[:40]:
    print("%-45s raw=%5d eff=%5d cost~%5d thr<=%5d sites=%d"%r)
